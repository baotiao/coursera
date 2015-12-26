#include "types.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "fs.h"
#include "buf.h"

// Simple logging that allows concurrent FS system calls.
//
// A log transaction contains the updates of multiple FS system
// calls. The logging system only commits when there are
// no FS system calls active. Thus there is never
// any reasoning required about whether a commit might
// write an uncommitted system call's updates to disk.
//
// A system call should call begin_op()/end_op() to mark
// its start and end. Usually begin_op() just increments
// the count of in-progress FS system calls and returns.
// But if it thinks the log is close to running out, it
// sleeps until the last outstanding end_op() commits.
//
// The log is a physical re-do log containing disk blocks.
// The on-disk log format:
//   header block, containing sector #s for block A, B, C, ...
//   block A
//   block B
//   block C
//   ...
// Log appends are synchronous.

// Contents of the header block, used for both the on-disk header block
// and to keep track in memory of logged sector #s before commit.
struct logheader {
  int n;   
  int sector[LOGSIZE]; // 所以这里的sector 记录的不是
};

struct log {
  struct spinlock lock;
  int start; // 这里的start 是第几个block的意思, 所以每+1 就是block + 1
  int size;
  int outstanding; // how many FS sys calls are executing.
  int committing;  // in commit(), please wait.
  int dev;
  struct logheader lh;
};
struct log log;

static void recover_from_log(void);
static void commit();

void
initlog(void)
{
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(ROOTDEV, &sb);
  log.start = sb.size - sb.nlog;
  log.size = sb.nlog;
  log.dev = ROOTDEV;
  recover_from_log();
}

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  // 这里可以看到 logheader 是存在log.start 的这个Block的位置, 
  // 然后接下来才是真正的log data数据
  // 这里是把这个数据从log里面拷出来, 然后hb指针指向的是这个第一个block的位置,
  // 也就是logheader的位置
  // 然后这个全局的Log拷贝给这个hb指针, 也就是logheader 的位置, 然后写入到磁盘
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
  brelse(buf);
}

static void
recover_from_log(void)
{
  read_head();      
  install_trans(); // if committed, copy from log to disk
  log.lh.n = 0;
  write_head(); // clear the log
}

// called at the start of each FS system call.
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE) {
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
}

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    // 这里的log.start 是log block 的位置
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    // 这里为什么bread 一定读的是cache block呢,
    // 因为到了log.lh.sector[tail]里面记录的block肯定是被修改过的,
    // 所以被修改过的block信息一定是放在buffer cache里面的, 所以这里是将buffer
    // cache 里面的数据写入到具体的log data block 里面
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}

static void
commit()
{
  if (log.lh.n > 0) {
    // write_log 做的事情就是将在transaction中修改过的block 写入到log block
    // 里面去, 具体写入的是log block 最后面的 logged block
    write_log();     // Write modified blocks from cache to log
    // 然后将log block 里面的head 数据先写入到disk
    // 也就是Log结构里面的logheader 这一部分的数据, 标记log.lh.n字段,
    // 表示要写入的数据块的个数, 如果log.lh.n == 0,
    // 表示不写入数据或者以及进行过情况操作
    // 写入完成这个logheader以后我们就知道log
    // data里面的数据到底是哪些block的数据了, 因为这个write_header
    // 写入的只有logheader这个块, 所以可以认为这个操作是原子的.
    // 那么如果在写入write_head之前失败了, 那么之前写入的log
    // block的数据其实是没用的, 因为之前写入的log block 只是log, 不是真实的数据,
    // 后续要你经过install_trans 才将log block 里面的数据考入到真实的数据的地址, 
    // 因为如果写到这一步成功了, 还没写入data block
    // 的时候crash了, (也就是没执行install_trans的时候)那么没有影响, 重启以后会检查log.lh.n != 0, 那么就知道之前的install_trans操作可能没完成, 也可能完成了, 自动将这部分的log
    // block的数据写入到真正的位置, 重新执行一遍, 假如写入一半crash以后, 不会有影响,
    // 只不过重新将之前写入一半的数据重新写入一遍.
    // 如果没写这个logheader之前就crash了, 那么其实没影响,
    // 因为logheader并没有记录需要拷贝的信息, 也就是没有设置这个log.lh.n 信息
    // 这部分log data数据直接清空了
    write_head();    // Write header to disk -- the real commit
    // install_trans 是将写在磁盘里面的log_block里面的数据写到磁盘具体的位置
    install_trans(); // Now install writes to home locations
    // 写完以后这里直接将这个log header的信息改成0, 那么后续的所有logged
    // block里面的数据就没用了, 因为在写真正数据块的时候是看这个logheader
    // 里面有多少的block的
    log.lh.n = 0; 
    // 这一步主要就是更新log.lh.n = 0, 那么后面的log block 的数据不用管了,
    // 读到log.lh.n == 0, 就知道后面的数据是没用的了
    write_head();    // Erase the transaction from the log
  }
}

// Caller has modified b->data and is done with the buffer.
// Record the block number and pin in the cache with B_DIRTY.
// commit()/write_log() will do the disk write.
//
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
// 这里log_write 主要做的事情就是将需要修改的block记录在log.lh.sector[]数组里面,
// 并且更新log.lh.n的值
// 因为这个时候对于block的修改是放在buffer cache内存里面的,
// 所以后续还需要将它从buffer cache里面读取出来
void
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  // 这里是先查看一下是否有某一个sector 已经被修改过了, 否则就找到最大的那个,
  // 标记成DIRTY
  
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
  }
  log.lh.sector[i] = b->sector;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
}

