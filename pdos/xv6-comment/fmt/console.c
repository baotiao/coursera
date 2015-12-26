7900 // Console input and output.
7901 // Input is from the keyboard or serial port.
7902 // Output is written to the screen and serial port.
7903 
7904 #include "types.h"
7905 #include "defs.h"
7906 #include "param.h"
7907 #include "traps.h"
7908 #include "spinlock.h"
7909 #include "fs.h"
7910 #include "file.h"
7911 #include "memlayout.h"
7912 #include "mmu.h"
7913 #include "proc.h"
7914 #include "x86.h"
7915 
7916 static void consputc(int);
7917 
7918 static int panicked = 0;
7919 
7920 static struct {
7921   struct spinlock lock;
7922   int locking;
7923 } cons;
7924 
7925 static void
7926 printint(int xx, int base, int sign)
7927 {
7928   static char digits[] = "0123456789abcdef";
7929   char buf[16];
7930   int i;
7931   uint x;
7932 
7933   if(sign && (sign = xx < 0))
7934     x = -xx;
7935   else
7936     x = xx;
7937 
7938   i = 0;
7939   do{
7940     buf[i++] = digits[x % base];
7941   }while((x /= base) != 0);
7942 
7943   if(sign)
7944     buf[i++] = '-';
7945 
7946   while(--i >= 0)
7947     consputc(buf[i]);
7948 }
7949 
7950 // Print to the console. only understands %d, %x, %p, %s.
7951 void
7952 cprintf(char *fmt, ...)
7953 {
7954   int i, c, locking;
7955   uint *argp;
7956   char *s;
7957 
7958   locking = cons.locking;
7959   if(locking)
7960     acquire(&cons.lock);
7961 
7962   if (fmt == 0)
7963     panic("null fmt");
7964 
7965   argp = (uint*)(void*)(&fmt + 1);
7966   for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
7967     if(c != '%'){
7968       consputc(c);
7969       continue;
7970     }
7971     c = fmt[++i] & 0xff;
7972     if(c == 0)
7973       break;
7974     switch(c){
7975     case 'd':
7976       printint(*argp++, 10, 1);
7977       break;
7978     case 'x':
7979     case 'p':
7980       printint(*argp++, 16, 0);
7981       break;
7982     case 's':
7983       if((s = (char*)*argp++) == 0)
7984         s = "(null)";
7985       for(; *s; s++)
7986         consputc(*s);
7987       break;
7988     case '%':
7989       consputc('%');
7990       break;
7991     default:
7992       // Print unknown % sequence to draw attention.
7993       consputc('%');
7994       consputc(c);
7995       break;
7996     }
7997   }
7998 
7999 
8000   if(locking)
8001     release(&cons.lock);
8002 }
8003 
8004 void
8005 panic(char *s)
8006 {
8007   int i;
8008   uint pcs[10];
8009 
8010   cli();
8011   cons.locking = 0;
8012   cprintf("cpu%d: panic: ", cpu->id);
8013   cprintf(s);
8014   cprintf("\n");
8015   getcallerpcs(&s, pcs);
8016   for(i=0; i<10; i++)
8017     cprintf(" %p", pcs[i]);
8018   panicked = 1; // freeze other CPU
8019   for(;;)
8020     ;
8021 }
8022 
8023 
8024 
8025 
8026 
8027 
8028 
8029 
8030 
8031 
8032 
8033 
8034 
8035 
8036 
8037 
8038 
8039 
8040 
8041 
8042 
8043 
8044 
8045 
8046 
8047 
8048 
8049 
8050 #define BACKSPACE 0x100
8051 #define CRTPORT 0x3d4
8052 static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory
8053 
8054 static void
8055 cgaputc(int c)
8056 {
8057   int pos;
8058 
8059   // Cursor position: col + 80*row.
8060   outb(CRTPORT, 14);
8061   pos = inb(CRTPORT+1) << 8;
8062   outb(CRTPORT, 15);
8063   pos |= inb(CRTPORT+1);
8064 
8065   if(c == '\n')
8066     pos += 80 - pos%80;
8067   else if(c == BACKSPACE){
8068     if(pos > 0) --pos;
8069   } else
8070     crt[pos++] = (c&0xff) | 0x0700;  // black on white
8071 
8072   if((pos/80) >= 24){  // Scroll up.
8073     memmove(crt, crt+80, sizeof(crt[0])*23*80);
8074     pos -= 80;
8075     memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8076   }
8077 
8078   outb(CRTPORT, 14);
8079   outb(CRTPORT+1, pos>>8);
8080   outb(CRTPORT, 15);
8081   outb(CRTPORT+1, pos);
8082   crt[pos] = ' ' | 0x0700;
8083 }
8084 
8085 void
8086 consputc(int c)
8087 {
8088   if(panicked){
8089     cli();
8090     for(;;)
8091       ;
8092   }
8093 
8094   if(c == BACKSPACE){
8095     uartputc('\b'); uartputc(' '); uartputc('\b');
8096   } else
8097     uartputc(c);
8098   cgaputc(c);
8099 }
8100 #define INPUT_BUF 128
8101 struct {
8102   struct spinlock lock;
8103   char buf[INPUT_BUF];
8104   uint r;  // Read index
8105   uint w;  // Write index
8106   uint e;  // Edit index
8107 } input;
8108 
8109 #define C(x)  ((x)-'@')  // Control-x
8110 
8111 void
8112 consoleintr(int (*getc)(void))
8113 {
8114   int c;
8115 
8116   acquire(&input.lock);
8117   while((c = getc()) >= 0){
8118     switch(c){
8119     case C('P'):  // Process listing.
8120       procdump();
8121       break;
8122     case C('U'):  // Kill line.
8123       while(input.e != input.w &&
8124             input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8125         input.e--;
8126         consputc(BACKSPACE);
8127       }
8128       break;
8129     case C('H'): case '\x7f':  // Backspace
8130       if(input.e != input.w){
8131         input.e--;
8132         consputc(BACKSPACE);
8133       }
8134       break;
8135     default:
8136       if(c != 0 && input.e-input.r < INPUT_BUF){
8137         c = (c == '\r') ? '\n' : c;
8138         input.buf[input.e++ % INPUT_BUF] = c;
8139         consputc(c);
8140         if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8141           input.w = input.e;
8142           wakeup(&input.r);
8143         }
8144       }
8145       break;
8146     }
8147   }
8148   release(&input.lock);
8149 }
8150 int
8151 consoleread(struct inode *ip, char *dst, int n)
8152 {
8153   uint target;
8154   int c;
8155 
8156   iunlock(ip);
8157   target = n;
8158   acquire(&input.lock);
8159   while(n > 0){
8160     while(input.r == input.w){
8161       if(proc->killed){
8162         release(&input.lock);
8163         ilock(ip);
8164         return -1;
8165       }
8166       sleep(&input.r, &input.lock);
8167     }
8168     c = input.buf[input.r++ % INPUT_BUF];
8169     if(c == C('D')){  // EOF
8170       if(n < target){
8171         // Save ^D for next time, to make sure
8172         // caller gets a 0-byte result.
8173         input.r--;
8174       }
8175       break;
8176     }
8177     *dst++ = c;
8178     --n;
8179     if(c == '\n')
8180       break;
8181   }
8182   release(&input.lock);
8183   ilock(ip);
8184 
8185   return target - n;
8186 }
8187 
8188 
8189 
8190 
8191 
8192 
8193 
8194 
8195 
8196 
8197 
8198 
8199 
8200 int
8201 consolewrite(struct inode *ip, char *buf, int n)
8202 {
8203   int i;
8204 
8205   iunlock(ip);
8206   acquire(&cons.lock);
8207   for(i = 0; i < n; i++)
8208     consputc(buf[i] & 0xff);
8209   release(&cons.lock);
8210   ilock(ip);
8211 
8212   return n;
8213 }
8214 
8215 void
8216 consoleinit(void)
8217 {
8218   initlock(&cons.lock, "console");
8219   initlock(&input.lock, "input");
8220 
8221   devsw[CONSOLE].write = consolewrite;
8222   devsw[CONSOLE].read = consoleread;
8223   cons.locking = 1;
8224 
8225   picenable(IRQ_KBD);
8226   ioapicenable(IRQ_KBD, 0);
8227 }
8228 
8229 
8230 
8231 
8232 
8233 
8234 
8235 
8236 
8237 
8238 
8239 
8240 
8241 
8242 
8243 
8244 
8245 
8246 
8247 
8248 
8249 
