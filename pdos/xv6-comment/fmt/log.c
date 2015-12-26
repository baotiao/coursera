4500 #include "types.h"
4501 #include "defs.h"
4502 #include "param.h"
4503 #include "spinlock.h"
4504 #include "fs.h"
4505 #include "buf.h"
4506 
4507 // Simple logging that allows concurrent FS system calls.
4508 //
4509 // A log transaction contains the updates of multiple FS system
4510 // calls. The logging system only commits when there are
4511 // no FS system calls active. Thus there is never
4512 // any reasoning required about whether a commit might
4513 // write an uncommitted system call's updates to disk.
4514 //
4515 // A system call should call begin_op()/end_op() to mark
4516 // its start and end. Usually begin_op() just increments
4517 // the count of in-progress FS system calls and returns.
4518 // But if it thinks the log is close to running out, it
4519 // sleeps until the last outstanding end_op() commits.
4520 //
4521 // The log is a physical re-do log containing disk blocks.
4522 // The on-disk log format:
4523 //   header block, containing sector #s for block A, B, C, ...
4524 //   block A
4525 //   block B
4526 //   block C
4527 //   ...
4528 // Log appends are synchronous.
4529 
4530 // Contents of the header block, used for both the on-disk header block
4531 // and to keep track in memory of logged sector #s before commit.
4532 struct logheader {
4533   int n;
4534   int sector[LOGSIZE]; // 所以这里的sector 记录的不是
4535 };
4536 
4537 struct log {
4538   struct spinlock lock;
4539   int start; // 这里的start 是第几个block的意思, 所以每+1 就是block + 1
4540   int size;
4541   int outstanding; // how many FS sys calls are executing.
4542   int committing;  // in commit(), please wait.
4543   int dev;
4544   struct logheader lh;
4545 };
4546 
4547 
4548 
4549 
4550 struct log log;
4551 
4552 static void recover_from_log(void);
4553 static void commit();
4554 
4555 void
4556 initlog(void)
4557 {
4558   if (sizeof(struct logheader) >= BSIZE)
4559     panic("initlog: too big logheader");
4560 
4561   struct superblock sb;
4562   initlock(&log.lock, "log");
4563   readsb(ROOTDEV, &sb);
4564   log.start = sb.size - sb.nlog;
4565   log.size = sb.nlog;
4566   log.dev = ROOTDEV;
4567   recover_from_log();
4568 }
4569 
4570 // Copy committed blocks from log to their home location
4571 static void
4572 install_trans(void)
4573 {
4574   int tail;
4575 
4576   for (tail = 0; tail < log.lh.n; tail++) {
4577     struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
4578     struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
4579     memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
4580     bwrite(dbuf);  // write dst to disk
4581     brelse(lbuf);
4582     brelse(dbuf);
4583   }
4584 }
4585 
4586 // Read the log header from disk into the in-memory log header
4587 static void
4588 read_head(void)
4589 {
4590   struct buf *buf = bread(log.dev, log.start);
4591   struct logheader *lh = (struct logheader *) (buf->data);
4592   int i;
4593   log.lh.n = lh->n;
4594   for (i = 0; i < log.lh.n; i++) {
4595     log.lh.sector[i] = lh->sector[i];
4596   }
4597   brelse(buf);
4598 }
4599 
4600 // Write in-memory log header to disk.
4601 // This is the true point at which the
4602 // current transaction commits.
4603 static void
4604 write_head(void)
4605 {
4606   // 这里可以看到 logheader 是存在log.start 的这个Block的位置,
4607   // 然后接下来才是真正的log data数据
4608   // 这里是把这个数据从log里面拷出来, 然后hb指针指向的是这个第一个block的位置,
4609   // 也就是logheader的位置
4610   // 然后这个全局的Log拷贝给这个hb指针, 也就是logheader 的位置, 然后写入到磁盘
4611   struct buf *buf = bread(log.dev, log.start);
4612   struct logheader *hb = (struct logheader *) (buf->data);
4613   int i;
4614   hb->n = log.lh.n;
4615   for (i = 0; i < log.lh.n; i++) {
4616     hb->sector[i] = log.lh.sector[i];
4617   }
4618   bwrite(buf);
4619   brelse(buf);
4620 }
4621 
4622 static void
4623 recover_from_log(void)
4624 {
4625   read_head();
4626   install_trans(); // if committed, copy from log to disk
4627   log.lh.n = 0;
4628   write_head(); // clear the log
4629 }
4630 
4631 // called at the start of each FS system call.
4632 void
4633 begin_op(void)
4634 {
4635   acquire(&log.lock);
4636   while(1){
4637     if(log.committing){
4638       sleep(&log, &log.lock);
4639     } else if (log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE) {
4640       // this op might exhaust log space; wait for commit.
4641       sleep(&log, &log.lock);
4642     } else {
4643       log.outstanding += 1;
4644       release(&log.lock);
4645       break;
4646     }
4647   }
4648 }
4649 
4650 // called at the end of each FS system call.
4651 // commits if this was the last outstanding operation.
4652 void
4653 end_op(void)
4654 {
4655   int do_commit = 0;
4656 
4657   acquire(&log.lock);
4658   log.outstanding -= 1;
4659   if(log.committing)
4660     panic("log.committing");
4661   if(log.outstanding == 0){
4662     do_commit = 1;
4663     log.committing = 1;
4664   } else {
4665     // begin_op() may be waiting for log space.
4666     wakeup(&log);
4667   }
4668   release(&log.lock);
4669 
4670   if(do_commit){
4671     // call commit w/o holding locks, since not allowed
4672     // to sleep with locks.
4673     commit();
4674     acquire(&log.lock);
4675     log.committing = 0;
4676     wakeup(&log);
4677     release(&log.lock);
4678   }
4679 }
4680 
4681 // Copy modified blocks from cache to log.
4682 static void
4683 write_log(void)
4684 {
4685   int tail;
4686 
4687   for (tail = 0; tail < log.lh.n; tail++) {
4688     // 这里的log.start 是log block 的位置
4689     struct buf *to = bread(log.dev, log.start+tail+1); // log block
4690     // 这里为什么bread 一定读的是cache block呢,
4691     // 因为到了log.lh.sector[tail]里面记录的block肯定是被修改过的,
4692     // 所以被修改过的block信息一定是放在buffer cache里面的, 所以这里是将buffer
4693     // cache 里面的数据写入到具体的log data block 里面
4694     struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
4695     memmove(to->data, from->data, BSIZE);
4696     bwrite(to);  // write the log
4697     brelse(from);
4698     brelse(to);
4699   }
4700 }
4701 
4702 static void
4703 commit()
4704 {
4705   if (log.lh.n > 0) {
4706     // write_log 做的事情就是将在transaction中修改过的block 写入到log block
4707     // 里面去, 具体写入的是log block 最后面的 logged block
4708     write_log();     // Write modified blocks from cache to log
4709     // 然后将log block 里面的head 数据先写入到disk
4710     // 也就是Log结构里面的logheader 这一部分的数据, 标记log.lh.n字段,
4711     // 表示要写入的数据块的个数, 如果log.lh.n == 0,
4712     // 表示不写入数据或者以及进行过情况操作
4713     // 写入完成这个logheader以后我们就知道log
4714     // data里面的数据到底是哪些block的数据了, 因为这个write_header
4715     // 写入的只有logheader这个块, 所以可以认为这个操作是原子的.
4716     // 那么如果在写入write_head之前失败了, 那么之前写入的log
4717     // block的数据其实是没用的, 因为之前写入的log block 只是log, 不是真实的数据,
4718     // 后续要你经过install_trans 才将log block 里面的数据考入到真实的数据的地址,
4719     // 因为如果写到这一步成功了, 还没写入data block
4720     // 的时候crash了, (也就是没执行install_trans的时候)那么没有影响, 重启以后会检查log.lh.n != 0, 那么就知道之前的install_trans操作可能没完成, 也可能完成了, 自动将这部分的log
4721     // block的数据写入到真正的位置, 重新执行一遍, 假如写入一半crash以后, 不会有影响,
4722     // 只不过重新将之前写入一半的数据重新写入一遍.
4723     // 如果没写这个logheader之前就crash了, 那么其实没影响,
4724     // 因为logheader并没有记录需要拷贝的信息, 也就是没有设置这个log.lh.n 信息
4725     // 这部分log data数据直接清空了
4726     write_head();    // Write header to disk -- the real commit
4727     // install_trans 是将写在磁盘里面的log_block里面的数据写到磁盘具体的位置
4728     install_trans(); // Now install writes to home locations
4729     // 写完以后这里直接将这个log header的信息改成0, 那么后续的所有logged
4730     // block里面的数据就没用了, 因为在写真正数据块的时候是看这个logheader
4731     // 里面有多少的block的
4732     log.lh.n = 0;
4733     // 这一步主要就是更新log.lh.n = 0, 那么后面的log block 的数据不用管了,
4734     // 读到log.lh.n == 0, 就知道后面的数据是没用的了
4735     write_head();    // Erase the transaction from the log
4736   }
4737 }
4738 
4739 
4740 
4741 
4742 
4743 
4744 
4745 
4746 
4747 
4748 
4749 
4750 // Caller has modified b->data and is done with the buffer.
4751 // Record the block number and pin in the cache with B_DIRTY.
4752 // commit()/write_log() will do the disk write.
4753 //
4754 // log_write() replaces bwrite(); a typical use is:
4755 //   bp = bread(...)
4756 //   modify bp->data[]
4757 //   log_write(bp)
4758 //   brelse(bp)
4759 // 这里log_write 主要做的事情就是将需要修改的block记录在log.lh.sector[]数组里面,
4760 // 并且更新log.lh.n的值
4761 // 因为这个时候对于block的修改是放在buffer cache内存里面的,
4762 // 所以后续还需要将它从buffer cache里面读取出来
4763 void
4764 log_write(struct buf *b)
4765 {
4766   int i;
4767 
4768   if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
4769     panic("too big a transaction");
4770   if (log.outstanding < 1)
4771     panic("log_write outside of trans");
4772 
4773   // 这里是先查看一下是否有某一个sector 已经被修改过了, 否则就找到最大的那个,
4774   // 标记成DIRTY
4775 
4776   for (i = 0; i < log.lh.n; i++) {
4777     if (log.lh.sector[i] == b->sector)   // log absorbtion
4778       break;
4779   }
4780   log.lh.sector[i] = b->sector;
4781   if (i == log.lh.n)
4782     log.lh.n++;
4783   b->flags |= B_DIRTY; // prevent eviction
4784 }
4785 
4786 
4787 
4788 
4789 
4790 
4791 
4792 
4793 
4794 
4795 
4796 
4797 
4798 
4799 
