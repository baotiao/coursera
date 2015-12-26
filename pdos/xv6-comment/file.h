struct file {
  enum { FD_NONE, FD_PIPE, FD_INODE } type;
  // 这个referenct 是用来记录这个file 结构被多少个进程使用,
  // 因为在dup或者clone出另一个进程的时候, 会直接将这个open file拷贝走
  int ref; // reference count
  char readable; // 这里readable writable是用来标记这个file 是否是可读或者可写
  char writable;
  struct pipe *pipe;
  struct inode *ip;
  uint off;
};


// in-memory copy of an inode
struct inode {
  uint dev;           // Device number
  uint inum;          // Inode number
  int ref;            // Reference count
  int flags;          // I_BUSY, I_VALID

  short type;         // copy of disk inode
  short major;
  short minor;
  short nlink;
  uint size;
  uint addrs[NDIRECT+1];
};
#define I_BUSY 0x1
#define I_VALID 0x2

// table mapping major device number to
// device functions
struct devsw {
  int (*read)(struct inode*, char*, int);
  int (*write)(struct inode*, char*, int);
};

extern struct devsw devsw[];

#define CONSOLE 1

//PAGEBREAK!
// Blank page.
