4800 // File system implementation.  Five layers:
4801 //   + Blocks: allocator for raw disk blocks.
4802 //   + Log: crash recovery for multi-step updates.
4803 //   + Files: inode allocator, reading, writing, metadata.
4804 //   + Directories: inode with special contents (list of other inodes!)
4805 //   + Names: paths like /usr/rtm/xv6/fs.c for convenient naming.
4806 //
4807 // This file contains the low-level file system manipulation
4808 // routines.  The (higher-level) system call implementations
4809 // are in sysfile.c.
4810 
4811 #include "types.h"
4812 #include "defs.h"
4813 #include "param.h"
4814 #include "stat.h"
4815 #include "mmu.h"
4816 #include "proc.h"
4817 #include "spinlock.h"
4818 #include "buf.h"
4819 #include "fs.h"
4820 #include "file.h"
4821 
4822 #define min(a, b) ((a) < (b) ? (a) : (b))
4823 static void itrunc(struct inode*);
4824 
4825 // Read the super block.
4826 void
4827 readsb(int dev, struct superblock *sb)
4828 {
4829   struct buf *bp;
4830 
4831   bp = bread(dev, 1);
4832   memmove(sb, bp->data, sizeof(*sb));
4833   brelse(bp);
4834 }
4835 
4836 // Zero a block.
4837 static void
4838 bzero(int dev, int bno)
4839 {
4840   struct buf *bp;
4841 
4842   bp = bread(dev, bno);
4843   memset(bp->data, 0, BSIZE);
4844   log_write(bp);
4845   brelse(bp);
4846 }
4847 
4848 
4849 
4850 // Blocks.
4851 
4852 // Allocate a zeroed disk block.
4853 static uint
4854 balloc(uint dev)
4855 {
4856   int b, bi, m;
4857   struct buf *bp;
4858   struct superblock sb;
4859 
4860   bp = 0;
4861   readsb(dev, &sb);
4862   for(b = 0; b < sb.size; b += BPB){
4863     bp = bread(dev, BBLOCK(b, sb.ninodes));
4864     for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
4865       m = 1 << (bi % 8);
4866       if((bp->data[bi/8] & m) == 0){  // Is block free?
4867         bp->data[bi/8] |= m;  // Mark block in use.
4868         log_write(bp);
4869         brelse(bp);
4870         bzero(dev, b + bi);
4871         return b + bi;
4872       }
4873     }
4874     brelse(bp);
4875   }
4876   panic("balloc: out of blocks");
4877 }
4878 
4879 // Free a disk block.
4880 // 将对应的block 设置成空, 这里做这个操作也是事务的做,
4881 // 把某一个block直接设置成空, 在superblock里面
4882 static void
4883 bfree(int dev, uint b)
4884 {
4885   struct buf *bp;
4886   struct superblock sb;
4887   int bi, m;
4888 
4889   readsb(dev, &sb);
4890   // 这里BBLOCK是获得这个block b所在的bitmap block的位置
4891   // 然后将其修改, 然后下面的log_write 通过事务的方式去释放这个block
4892   bp = bread(dev, BBLOCK(b, sb.ninodes));
4893   bi = b % BPB;
4894   m = 1 << (bi % 8);
4895   if((bp->data[bi/8] & m) == 0)
4896     panic("freeing free block");
4897   bp->data[bi/8] &= ~m;
4898   log_write(bp);
4899   brelse(bp);
4900 }
4901 
4902 // Inodes.
4903 //
4904 // An inode describes a single unnamed file.
4905 // The inode disk structure holds metadata: the file's type,
4906 // its size, the number of links referring to it, and the
4907 // list of blocks holding the file's content.
4908 //
4909 // The inodes are laid out sequentially on disk immediately after
4910 // the superblock. Each inode has a number, indicating its
4911 // position on the disk.
4912 //
4913 // The kernel keeps a cache of in-use inodes in memory
4914 // to provide a place for synchronizing access
4915 // to inodes used by multiple processes. The cached
4916 // inodes include book-keeping information that is
4917 // not stored on disk: ip->ref and ip->flags.
4918 //
4919 // An inode and its in-memory represtative go through a
4920 // sequence of states before they can be used by the
4921 // rest of the file system code.
4922 //
4923 // * Allocation: an inode is allocated if its type (on disk)
4924 //   is non-zero. ialloc() allocates, iput() frees if
4925 //   the link count has fallen to zero.
4926 //
4927 // * Referencing in cache: an entry in the inode cache
4928 //   is free if ip->ref is zero. Otherwise ip->ref tracks
4929 //   the number of in-memory pointers to the entry (open
4930 //   files and current directories). iget() to find or
4931 //   create a cache entry and increment its ref, iput()
4932 //   to decrement ref.
4933 //
4934 //   这里就是对inode修改的时候会将内存中的flag设置成I_VALID, 当
4935 //   从dinode里面读取然后设置到inode时候会设置I_VALID,
4936 //   如果修改了dinode的信息以后会将这个I_VALID信息清空
4937 // * Valid: the information (type, size, &c) in an inode
4938 //   cache entry is only correct when the I_VALID bit
4939 //   is set in ip->flags. ilock() reads the inode from
4940 //   the disk and sets I_VALID, while iput() clears
4941 //   I_VALID if ip->ref has fallen to zero.
4942 //
4943 // * Locked: file system code may only examine and modify
4944 //   the information in an inode and its content if it
4945 //   has first locked the inode. The I_BUSY flag indicates
4946 //   that the inode is locked. ilock() sets I_BUSY,
4947 //   while iunlock clears it.
4948 //
4949 // Thus a typical sequence is:
4950 //   ip = iget(dev, inum)
4951 //   ilock(ip)
4952 //   ... examine and modify ip->xxx ...
4953 //   iunlock(ip)
4954 //   iput(ip)
4955 //
4956 // ilock() is separate from iget() so that system calls can
4957 // get a long-term reference to an inode (as for an open file)
4958 // and only lock it for short periods (e.g., in read()).
4959 // The separation also helps avoid deadlock and races during
4960 // pathname lookup. iget() increments ip->ref so that the inode
4961 // stays cached and pointers to it remain valid.
4962 //
4963 // Many internal file system functions expect the caller to
4964 // have locked the inodes involved; this lets callers create
4965 // multi-step atomic operations.
4966 
4967 // inode 里面的锁都是通过这个icache来实现, icache
4968 struct {
4969   struct spinlock lock;
4970   struct inode inode[NINODE];
4971 } icache;
4972 
4973 void
4974 iinit(void)
4975 {
4976   initlock(&icache.lock, "icache");
4977 }
4978 
4979 static struct inode* iget(uint dev, uint inum);
4980 
4981 
4982 
4983 
4984 
4985 
4986 
4987 
4988 
4989 
4990 
4991 
4992 
4993 
4994 
4995 
4996 
4997 
4998 
4999 
5000 // Allocate a new inode with the given type on device dev.
5001 // A free inode has a type of zero.
5002 struct inode*
5003 ialloc(uint dev, short type)
5004 {
5005   int inum;
5006   struct buf *bp;
5007   struct dinode *dip;
5008   struct superblock sb;
5009 
5010   readsb(dev, &sb);
5011 
5012   for(inum = 1; inum < sb.ninodes; inum++){
5013     bp = bread(dev, IBLOCK(inum));
5014     dip = (struct dinode*)bp->data + inum%IPB;
5015     if(dip->type == 0){  // a free inode
5016       memset(dip, 0, sizeof(*dip));
5017       dip->type = type;
5018       log_write(bp);   // mark it allocated on the disk
5019       brelse(bp);
5020       return iget(dev, inum);
5021     }
5022     brelse(bp);
5023   }
5024   panic("ialloc: no inodes");
5025 }
5026 
5027 // Copy a modified in-memory inode to disk.
5028 void
5029 iupdate(struct inode *ip)
5030 {
5031   struct buf *bp;
5032   struct dinode *dip;
5033 
5034   bp = bread(ip->dev, IBLOCK(ip->inum));
5035   dip = (struct dinode*)bp->data + ip->inum%IPB;
5036   dip->type = ip->type;
5037   dip->major = ip->major;
5038   dip->minor = ip->minor;
5039   dip->nlink = ip->nlink;
5040   dip->size = ip->size;
5041   memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
5042   log_write(bp);
5043   brelse(bp);
5044 }
5045 
5046 
5047 
5048 
5049 
5050 // Find the inode with number inum on device dev
5051 // and return the in-memory copy. Does not lock
5052 // the inode and does not read it from disk.
5053 static struct inode*
5054 iget(uint dev, uint inum)
5055 {
5056   struct inode *ip, *empty;
5057 
5058   acquire(&icache.lock);
5059 
5060   // Is the inode already cached?
5061   empty = 0;
5062   for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
5063     if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
5064       ip->ref++;
5065       release(&icache.lock);
5066       return ip;
5067     }
5068     if(empty == 0 && ip->ref == 0)    // Remember empty slot.
5069       empty = ip;
5070   }
5071 
5072   // Recycle an inode cache entry.
5073   if(empty == 0)
5074     panic("iget: no inodes");
5075 
5076   ip = empty;
5077   ip->dev = dev;
5078   ip->inum = inum;
5079   ip->ref = 1;
5080   ip->flags = 0;
5081   release(&icache.lock);
5082 
5083   return ip;
5084 }
5085 
5086 // Increment reference count for ip.
5087 // Returns ip to enable ip = idup(ip1) idiom.
5088 struct inode*
5089 idup(struct inode *ip)
5090 {
5091   acquire(&icache.lock);
5092   ip->ref++;
5093   release(&icache.lock);
5094   return ip;
5095 }
5096 
5097 
5098 
5099 
5100 // Lock the given inode.
5101 // Reads the inode from disk if necessary.
5102 // ilock 做的事情不只是锁住inode, 而且如果这个inode是旧的,
5103 // 那么就从inode里面将这个inode的信息读取出来, 并且更新
5104 void
5105 ilock(struct inode *ip)
5106 {
5107   struct buf *bp;
5108   struct dinode *dip;
5109 
5110   if(ip == 0 || ip->ref < 1)
5111     panic("ilock");
5112 
5113   acquire(&icache.lock);
5114   while(ip->flags & I_BUSY)
5115     sleep(ip, &icache.lock);
5116   ip->flags |= I_BUSY;
5117   release(&icache.lock);
5118 
5119   if(!(ip->flags & I_VALID)){
5120     bp = bread(ip->dev, IBLOCK(ip->inum));
5121     dip = (struct dinode*)bp->data + ip->inum%IPB;
5122     ip->type = dip->type;
5123     ip->major = dip->major;
5124     ip->minor = dip->minor;
5125     ip->nlink = dip->nlink;
5126     ip->size = dip->size;
5127     memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
5128     brelse(bp);
5129     ip->flags |= I_VALID;
5130     if(ip->type == 0)
5131       panic("ilock: no type");
5132   }
5133 }
5134 
5135 // Unlock the given inode.
5136 void
5137 iunlock(struct inode *ip)
5138 {
5139   if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
5140     panic("iunlock");
5141 
5142   acquire(&icache.lock);
5143   ip->flags &= ~I_BUSY;
5144   wakeup(ip);
5145   release(&icache.lock);
5146 }
5147 
5148 
5149 
5150 // Drop a reference to an in-memory inode.
5151 // If that was the last reference, the inode cache entry can
5152 // be recycled.
5153 // If that was the last reference and the inode has no links
5154 // to it, free the inode (and its content) on disk.
5155 // All calls to iput() must be inside a transaction in
5156 // case it has to free the inode.
5157 void
5158 iput(struct inode *ip)
5159 {
5160   acquire(&icache.lock);
5161   if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
5162     // inode has no links and no other references: truncate and free.
5163     if(ip->flags & I_BUSY)
5164       panic("iput busy");
5165     ip->flags |= I_BUSY;
5166     release(&icache.lock);
5167     itrunc(ip);
5168     ip->type = 0;
5169     iupdate(ip);
5170     acquire(&icache.lock);
5171     ip->flags = 0;
5172     wakeup(ip);
5173   }
5174   ip->ref--;
5175   release(&icache.lock);
5176 }
5177 
5178 // Common idiom: unlock, then put.
5179 void
5180 iunlockput(struct inode *ip)
5181 {
5182   iunlock(ip);
5183   iput(ip);
5184 }
5185 
5186 
5187 
5188 
5189 
5190 
5191 
5192 
5193 
5194 
5195 
5196 
5197 
5198 
5199 
5200 // Inode content
5201 //
5202 // The content (data) associated with each inode is stored
5203 // in blocks on the disk. The first NDIRECT block numbers
5204 // are listed in ip->addrs[].  The next NINDIRECT blocks are
5205 // listed in block ip->addrs[NDIRECT].
5206 
5207 // Return the disk block address of the nth block in inode ip.
5208 // If there is no such block, bmap allocates one.
5209 static uint
5210 bmap(struct inode *ip, uint bn)
5211 {
5212   uint addr, *a;
5213   struct buf *bp;
5214 
5215   if(bn < NDIRECT){
5216     if((addr = ip->addrs[bn]) == 0)
5217       ip->addrs[bn] = addr = balloc(ip->dev);
5218     return addr;
5219   }
5220   bn -= NDIRECT;
5221 
5222   if(bn < NINDIRECT){
5223     // Load indirect block, allocating if necessary.
5224     if((addr = ip->addrs[NDIRECT]) == 0)
5225       ip->addrs[NDIRECT] = addr = balloc(ip->dev);
5226     bp = bread(ip->dev, addr);
5227     a = (uint*)bp->data;
5228     if((addr = a[bn]) == 0){
5229       a[bn] = addr = balloc(ip->dev);
5230       log_write(bp);
5231     }
5232     brelse(bp);
5233     return addr;
5234   }
5235 
5236   panic("bmap: out of range");
5237 }
5238 
5239 
5240 
5241 
5242 
5243 
5244 
5245 
5246 
5247 
5248 
5249 
5250 // Truncate inode (discard contents).
5251 // Only called when the inode has no links
5252 // to it (no directory entries referring to it)
5253 // and has no in-memory reference to it (is
5254 // not an open file or current directory).
5255 // 这里是真正将文件删除的逻辑, 这里会依次的将inode
5256 // 里面的addrs里面记录的对应的block里面的数据给删除掉
5257 static void
5258 itrunc(struct inode *ip)
5259 {
5260   int i, j;
5261   struct buf *bp;
5262   uint *a;
5263 
5264   for(i = 0; i < NDIRECT; i++){
5265     // 这不部分释放的是DIRECT BLOCK
5266     if(ip->addrs[i]){
5267       bfree(ip->dev, ip->addrs[i]);
5268       ip->addrs[i] = 0;
5269     }
5270   }
5271 
5272   // 这一部分释放的NDIRECT BLOCK
5273   // 所以可以看到xv6 的一个文件最大的大小就是
5274   // NDIRECT + NINDIRECT
5275   // NINDIRECT = BSIZE / sizeof(uint)
5276   if(ip->addrs[NDIRECT]){
5277     bp = bread(ip->dev, ip->addrs[NDIRECT]);
5278     a = (uint*)bp->data;
5279     for(j = 0; j < NINDIRECT; j++){
5280       if(a[j])
5281         bfree(ip->dev, a[j]);
5282     }
5283     brelse(bp);
5284     bfree(ip->dev, ip->addrs[NDIRECT]);
5285     ip->addrs[NDIRECT] = 0;
5286   }
5287 
5288   // 将这个文件的size 设置成0
5289   ip->size = 0;
5290   // 然后将这个inode 更新到dinode里面去
5291   iupdate(ip);
5292 }
5293 
5294 
5295 
5296 
5297 
5298 
5299 
5300 // Copy stat information from inode.
5301 void
5302 stati(struct inode *ip, struct stat *st)
5303 {
5304   st->dev = ip->dev;
5305   st->ino = ip->inum;
5306   st->type = ip->type;
5307   st->nlink = ip->nlink;
5308   st->size = ip->size;
5309 }
5310 
5311 
5312 
5313 
5314 
5315 
5316 
5317 
5318 
5319 
5320 
5321 
5322 
5323 
5324 
5325 
5326 
5327 
5328 
5329 
5330 
5331 
5332 
5333 
5334 
5335 
5336 
5337 
5338 
5339 
5340 
5341 
5342 
5343 
5344 
5345 
5346 
5347 
5348 
5349 
5350 // Read data from inode.
5351 // Readi 是从inode 里面读取信息, 常见的应用就是当inode存放的是目录的时候,
5352 //
5353 int
5354 readi(struct inode *ip, char *dst, uint off, uint n)
5355 {
5356   uint tot, m;
5357   struct buf *bp;
5358 
5359   if(ip->type == T_DEV){
5360     if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
5361       return -1;
5362     return devsw[ip->major].read(ip, dst, n);
5363   }
5364 
5365   if(off > ip->size || off + n < off)
5366     return -1;
5367   if(off + n > ip->size)
5368     n = ip->size - off;
5369 
5370   for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
5371     bp = bread(ip->dev, bmap(ip, off/BSIZE));
5372     m = min(n - tot, BSIZE - off%BSIZE);
5373     memmove(dst, bp->data + off%BSIZE, m);
5374     brelse(bp);
5375   }
5376   return n;
5377 }
5378 
5379 
5380 
5381 
5382 
5383 
5384 
5385 
5386 
5387 
5388 
5389 
5390 
5391 
5392 
5393 
5394 
5395 
5396 
5397 
5398 
5399 
5400 // Write data to inode.
5401 int
5402 writei(struct inode *ip, char *src, uint off, uint n)
5403 {
5404   uint tot, m;
5405   struct buf *bp;
5406 
5407   if(ip->type == T_DEV){
5408     if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
5409       return -1;
5410     return devsw[ip->major].write(ip, src, n);
5411   }
5412 
5413   if(off > ip->size || off + n < off)
5414     return -1;
5415   if(off + n > MAXFILE*BSIZE)
5416     return -1;
5417 
5418   for(tot=0; tot<n; tot+=m, off+=m, src+=m){
5419     bp = bread(ip->dev, bmap(ip, off/BSIZE));
5420     m = min(n - tot, BSIZE - off%BSIZE);
5421     memmove(bp->data + off%BSIZE, src, m);
5422     log_write(bp);
5423     brelse(bp);
5424   }
5425 
5426   if(n > 0 && off > ip->size){
5427     ip->size = off;
5428     iupdate(ip);
5429   }
5430   return n;
5431 }
5432 
5433 
5434 
5435 
5436 
5437 
5438 
5439 
5440 
5441 
5442 
5443 
5444 
5445 
5446 
5447 
5448 
5449 
5450 // Directories
5451 
5452 int
5453 namecmp(const char *s, const char *t)
5454 {
5455   return strncmp(s, t, DIRSIZ);
5456 }
5457 
5458 // Look for a directory entry in a directory.
5459 // If found, set *poff to byte offset of entry.
5460 struct inode*
5461 dirlookup(struct inode *dp, char *name, uint *poff)
5462 {
5463   uint off, inum;
5464   struct dirent de;
5465 
5466   // 从这里可以看出inode的结构里面, file和directory都是存放在inode里面的,
5467   // 只是type的标识不一样而已
5468   if(dp->type != T_DIR)
5469     panic("dirlookup not DIR");
5470 
5471   for(off = 0; off < dp->size; off += sizeof(de)){
5472     // 这里就是从这个inode 里面读取出来里面存的一个个dirent的信息
5473     // 这里可以看到其实directory 就是将一个个的底下的目录信息存在data区域而已
5474     if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
5475       panic("dirlink read");
5476     if(de.inum == 0)
5477       continue;
5478     if(namecmp(name, de.name) == 0){
5479       // entry matches path element
5480       if(poff)
5481         *poff = off;
5482       inum = de.inum;
5483       return iget(dp->dev, inum);
5484     }
5485   }
5486 
5487   return 0;
5488 }
5489 
5490 
5491 
5492 
5493 
5494 
5495 
5496 
5497 
5498 
5499 
5500 // Write a new directory entry (name, inum) into the directory dp.
5501 int
5502 dirlink(struct inode *dp, char *name, uint inum)
5503 {
5504   int off;
5505   struct dirent de;
5506   struct inode *ip;
5507 
5508   // Check that name is not present.
5509   if((ip = dirlookup(dp, name, 0)) != 0){
5510     iput(ip);
5511     return -1;
5512   }
5513 
5514   // Look for an empty dirent.
5515   for(off = 0; off < dp->size; off += sizeof(de)){
5516     if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
5517       panic("dirlink read");
5518     if(de.inum == 0)
5519       break;
5520   }
5521 
5522   strncpy(de.name, name, DIRSIZ);
5523   de.inum = inum;
5524   if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
5525     panic("dirlink");
5526 
5527   return 0;
5528 }
5529 
5530 
5531 
5532 
5533 
5534 
5535 
5536 
5537 
5538 
5539 
5540 
5541 
5542 
5543 
5544 
5545 
5546 
5547 
5548 
5549 
5550 // Paths
5551 
5552 // Copy the next path element from path into name.
5553 // Return a pointer to the element following the copied one.
5554 // The returned path has no leading slashes,
5555 // so the caller can check *path=='\0' to see if the name is the last one.
5556 // If no name to remove, return 0.
5557 //
5558 // Examples:
5559 //   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
5560 //   skipelem("///a//bb", name) = "bb", setting name = "a"
5561 //   skipelem("a", name) = "", setting name = "a"
5562 //   skipelem("", name) = skipelem("////", name) = 0
5563 //
5564 static char*
5565 skipelem(char *path, char *name)
5566 {
5567   char *s;
5568   int len;
5569 
5570   while(*path == '/')
5571     path++;
5572   if(*path == 0)
5573     return 0;
5574   s = path;
5575   while(*path != '/' && *path != 0)
5576     path++;
5577   len = path - s;
5578   if(len >= DIRSIZ)
5579     memmove(name, s, DIRSIZ);
5580   else {
5581     memmove(name, s, len);
5582     name[len] = 0;
5583   }
5584   while(*path == '/')
5585     path++;
5586   return path;
5587 }
5588 
5589 
5590 
5591 
5592 
5593 
5594 
5595 
5596 
5597 
5598 
5599 
5600 // namex 做的事情就是根据某一个路径找到对应的inode
5601 // 这里首先是先找目录, 有/的话从根目录开始找, 没有的话从当前目录开始找
5602 // 找某一个目录下面是否有这个文件或者目录主要是dirlookup函数
5603 // Look up and return the inode for a path name.
5604 // If parent != 0, return the inode for the parent and copy the final
5605 // path element into name, which must have room for DIRSIZ bytes.
5606 // Must be called inside a transaction since it calls iput().
5607 static struct inode*
5608 namex(char *path, int nameiparent, char *name)
5609 {
5610   struct inode *ip, *next;
5611 
5612   if(*path == '/')
5613     ip = iget(ROOTDEV, ROOTINO);
5614   else
5615     ip = idup(proc->cwd);
5616 
5617   while((path = skipelem(path, name)) != 0){
5618     ilock(ip);
5619     if(ip->type != T_DIR){
5620       iunlockput(ip);
5621       return 0;
5622     }
5623     if(nameiparent && *path == '\0'){
5624       // Stop one level early.
5625       iunlock(ip);
5626       return ip;
5627     }
5628     if((next = dirlookup(ip, name, 0)) == 0){
5629       iunlockput(ip);
5630       return 0;
5631     }
5632     iunlockput(ip);
5633     ip = next;
5634   }
5635   if(nameiparent){
5636     iput(ip);
5637     return 0;
5638   }
5639   return ip;
5640 }
5641 
5642 struct inode*
5643 namei(char *path)
5644 {
5645   char name[DIRSIZ];
5646   return namex(path, 0, name);
5647 }
5648 
5649 
5650 struct inode*
5651 nameiparent(char *path, char *name)
5652 {
5653   return namex(path, 1, name);
5654 }
5655 
5656 
5657 
5658 
5659 
5660 
5661 
5662 
5663 
5664 
5665 
5666 
5667 
5668 
5669 
5670 
5671 
5672 
5673 
5674 
5675 
5676 
5677 
5678 
5679 
5680 
5681 
5682 
5683 
5684 
5685 
5686 
5687 
5688 
5689 
5690 
5691 
5692 
5693 
5694 
5695 
5696 
5697 
5698 
5699 
