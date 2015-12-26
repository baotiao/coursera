4000 struct file {
4001   enum { FD_NONE, FD_PIPE, FD_INODE } type;
4002   // 这个referenct 是用来记录这个file 结构被多少个进程使用,
4003   // 因为在dup或者clone出另一个进程的时候, 会直接将这个open file拷贝走
4004   int ref; // reference count
4005   char readable; // 这里readable writable是用来标记这个file 是否是可读或者可写
4006   char writable;
4007   struct pipe *pipe;
4008   struct inode *ip;
4009   uint off;
4010 };
4011 
4012 
4013 // in-memory copy of an inode
4014 struct inode {
4015   uint dev;           // Device number
4016   uint inum;          // Inode number
4017   int ref;            // Reference count
4018   int flags;          // I_BUSY, I_VALID
4019 
4020   short type;         // copy of disk inode
4021   short major;
4022   short minor;
4023   short nlink;
4024   uint size;
4025   uint addrs[NDIRECT+1];
4026 };
4027 #define I_BUSY 0x1
4028 #define I_VALID 0x2
4029 
4030 // table mapping major device number to
4031 // device functions
4032 struct devsw {
4033   int (*read)(struct inode*, char*, int);
4034   int (*write)(struct inode*, char*, int);
4035 };
4036 
4037 extern struct devsw devsw[];
4038 
4039 #define CONSOLE 1
4040 
4041 
4042 
4043 
4044 
4045 
4046 
4047 
4048 
4049 
4050 // Blank page.
4051 
4052 
4053 
4054 
4055 
4056 
4057 
4058 
4059 
4060 
4061 
4062 
4063 
4064 
4065 
4066 
4067 
4068 
4069 
4070 
4071 
4072 
4073 
4074 
4075 
4076 
4077 
4078 
4079 
4080 
4081 
4082 
4083 
4084 
4085 
4086 
4087 
4088 
4089 
4090 
4091 
4092 
4093 
4094 
4095 
4096 
4097 
4098 
4099 
