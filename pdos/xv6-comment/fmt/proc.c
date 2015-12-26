2400 #include "types.h"
2401 #include "defs.h"
2402 #include "param.h"
2403 #include "memlayout.h"
2404 #include "mmu.h"
2405 #include "x86.h"
2406 #include "proc.h"
2407 #include "spinlock.h"
2408 
2409 struct {
2410   struct spinlock lock;
2411   struct proc proc[NPROC];
2412 } ptable;
2413 
2414 static struct proc *initproc;
2415 
2416 int nextpid = 1;
2417 extern void forkret(void);
2418 extern void trapret(void);
2419 
2420 static void wakeup1(void *chan);
2421 
2422 void
2423 pinit(void)
2424 {
2425   initlock(&ptable.lock, "ptable");
2426 }
2427 
2428 
2429 
2430 
2431 
2432 
2433 
2434 
2435 
2436 
2437 
2438 
2439 
2440 
2441 
2442 
2443 
2444 
2445 
2446 
2447 
2448 
2449 
2450 // Look in the process table for an UNUSED proc.
2451 // If found, change state to EMBRYO and initialize
2452 // state required to run in the kernel.
2453 // Otherwise return 0.
2454 // new 一个新的process, 就是从ptable 里面找到一个UNUSED的进程, 然后返回就可以
2455 // 从这里可以看到, 新建立了一个进程以后, 需要分配进程的kernel栈空间,
2456 // 需要设置好新的context 等内容
2457 static struct proc*
2458 allocproc(void)
2459 {
2460   struct proc *p;
2461   char *sp;
2462 
2463   acquire(&ptable.lock);
2464   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
2465     if(p->state == UNUSED)
2466       goto found;
2467   release(&ptable.lock);
2468   return 0;
2469 
2470 found:
2471   p->state = EMBRYO;
2472   p->pid = nextpid++;
2473   release(&ptable.lock);
2474 
2475   // Allocate kernel stack.
2476   if((p->kstack = kalloc()) == 0){
2477     p->state = UNUSED;
2478     return 0;
2479   }
2480   sp = p->kstack + KSTACKSIZE;
2481 
2482   // Leave room for trap frame.
2483   sp -= sizeof *p->tf;
2484   p->tf = (struct trapframe*)sp;
2485 
2486   // Set up new context to start executing at forkret,
2487   // which returns to trapret.
2488   sp -= 4;
2489   *(uint*)sp = (uint)trapret;
2490 
2491   sp -= sizeof *p->context;
2492   p->context = (struct context*)sp;
2493   memset(p->context, 0, sizeof *p->context);
2494   p->context->eip = (uint)forkret;
2495 
2496   return p;
2497 }
2498 
2499 
2500 // Set up first user process.
2501 void
2502 userinit(void)
2503 {
2504   struct proc *p;
2505   extern char _binary_initcode_start[], _binary_initcode_size[];
2506 
2507   p = allocproc();
2508   initproc = p;
2509   if((p->pgdir = setupkvm()) == 0)
2510     panic("userinit: out of memory?");
2511   inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
2512   p->sz = PGSIZE;
2513   memset(p->tf, 0, sizeof(*p->tf));
2514   p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
2515   p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
2516   p->tf->es = p->tf->ds;
2517   p->tf->ss = p->tf->ds;
2518   p->tf->eflags = FL_IF;
2519   p->tf->esp = PGSIZE;
2520   p->tf->eip = 0;  // beginning of initcode.S
2521 
2522   safestrcpy(p->name, "initcode", sizeof(p->name));
2523   p->cwd = namei("/");
2524 
2525   p->state = RUNNABLE;
2526 }
2527 
2528 // Grow current process's memory by n bytes.
2529 // Return 0 on success, -1 on failure.
2530 int
2531 growproc(int n)
2532 {
2533   uint sz;
2534 
2535   sz = proc->sz;
2536   if(n > 0){
2537     if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
2538       return -1;
2539   } else if(n < 0){
2540     if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
2541       return -1;
2542   }
2543   proc->sz = sz;
2544   switchuvm(proc);
2545   return 0;
2546 }
2547 
2548 
2549 
2550 // Create a new process copying p as the parent.
2551 // Sets up stack to return as if from system call.
2552 // Caller must set state of returned proc to RUNNABLE.
2553 int
2554 fork(void)
2555 {
2556   int i, pid;
2557   struct proc *np;
2558 
2559   // Allocate process.
2560   if((np = allocproc()) == 0)
2561     return -1;
2562 
2563   // Copy process state from p.
2564   if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
2565     kfree(np->kstack);
2566     np->kstack = 0;
2567     np->state = UNUSED;
2568     return -1;
2569   }
2570   np->sz = proc->sz;
2571   np->parent = proc;
2572   *np->tf = *proc->tf;
2573 
2574   // Clear %eax so that fork returns 0 in the child.
2575   // 因为函数的返回值是从eax寄存器里面获得的
2576   // 所以这里设置了np 的eax以后就可以让子进程的返回值是0
2577   np->tf->eax = 0;
2578 
2579   for(i = 0; i < NOFILE; i++)
2580     if(proc->ofile[i])
2581       np->ofile[i] = filedup(proc->ofile[i]);
2582   np->cwd = idup(proc->cwd);
2583 
2584   safestrcpy(np->name, proc->name, sizeof(proc->name));
2585 
2586   pid = np->pid;
2587 
2588   // lock to force the compiler to emit the np->state write last.
2589   acquire(&ptable.lock);
2590   np->state = RUNNABLE;
2591   release(&ptable.lock);
2592 
2593   // 这里这个pid 返回的是新的子进程的pid, 到了这一步以后, 父进程正常的返回,
2594   // fork里面做的事情就是给进程队列添加了一个子进程而已,
2595   // 然后后续子进程的启动应该就是调度进程做的事情了. 然后这个父进程就正常返回了
2596   // 并且里面可以看到. 子进程会拷贝父进程的用户虚拟地址空间里面的内容,
2597   // 也就是包含pgtable, 还有给对应的文件句柄的ref + 1等操作
2598   return pid;
2599 }
2600 // Exit the current process.  Does not return.
2601 // An exited process remains in the zombie state
2602 // until its parent calls wait() to find out it exited.
2603 void
2604 exit(void)
2605 {
2606   struct proc *p;
2607   int fd;
2608 
2609   if(proc == initproc)
2610     panic("init exiting");
2611 
2612   // Close all open files.
2613   for(fd = 0; fd < NOFILE; fd++){
2614     if(proc->ofile[fd]){
2615       fileclose(proc->ofile[fd]);
2616       proc->ofile[fd] = 0;
2617     }
2618   }
2619 
2620   begin_op();
2621   iput(proc->cwd);
2622   end_op();
2623   proc->cwd = 0;
2624 
2625   acquire(&ptable.lock);
2626 
2627   // Parent might be sleeping in wait().
2628   wakeup1(proc->parent);
2629 
2630   // Pass abandoned children to init.
2631   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2632     if(p->parent == proc){
2633       p->parent = initproc;
2634       if(p->state == ZOMBIE)
2635         wakeup1(initproc);
2636     }
2637   }
2638 
2639   // Jump into the scheduler, never to return.
2640   proc->state = ZOMBIE;
2641   sched();
2642   panic("zombie exit");
2643 }
2644 
2645 
2646 
2647 
2648 
2649 
2650 // Wait for a child process to exit and return its pid.
2651 // Return -1 if this process has no children.
2652 int
2653 wait(void)
2654 {
2655   struct proc *p;
2656   int havekids, pid;
2657 
2658   acquire(&ptable.lock);
2659   for(;;){
2660     // Scan through table looking for zombie children.
2661     havekids = 0;
2662     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2663       if(p->parent != proc)
2664         continue;
2665       havekids = 1;
2666       if(p->state == ZOMBIE){
2667         // Found one.
2668         pid = p->pid;
2669         kfree(p->kstack);
2670         p->kstack = 0;
2671         freevm(p->pgdir);
2672         p->state = UNUSED;
2673         p->pid = 0;
2674         p->parent = 0;
2675         p->name[0] = 0;
2676         p->killed = 0;
2677         release(&ptable.lock);
2678         return pid;
2679       }
2680     }
2681 
2682     // No point waiting if we don't have any children.
2683     if(!havekids || proc->killed){
2684       release(&ptable.lock);
2685       return -1;
2686     }
2687 
2688     // Wait for children to exit.  (See wakeup1 call in proc_exit.)
2689     sleep(proc, &ptable.lock);  //DOC: wait-sleep
2690   }
2691 }
2692 
2693 
2694 
2695 
2696 
2697 
2698 
2699 
2700 // Per-CPU process scheduler.
2701 // Each CPU calls scheduler() after setting itself up.
2702 // Scheduler never returns.  It loops, doing:
2703 //  - choose a process to run
2704 //  - swtch to start running that process
2705 //  - eventually that process transfers control
2706 //      via swtch back to the scheduler.
2707 // 这个scheduler 是每一个CPU都有一个scheduler进程在运行的
2708 // 这个cpu 里面所有的信息在全局变量 cpu 里, 当前运行的进程信息在 proc里
2709 // extern struct cpu *cpu asm("%gs:0");       // &cpus[cpunum()]
2710 // extern struct proc *proc asm("%gs:4");     // cpus[cpunum()].proc
2711 // 可以看到cpu 里面的进程切换就是通过swtch, scheduler 切换到某一个进程,
2712 // 当某一个进程要切换另一个进程的时候, 是当前这个进程->scheduler进程->另一个进程
2713 void
2714 scheduler(void)
2715 {
2716   struct proc *p;
2717 
2718   for(;;){
2719     // Enable interrupts on this processor.
2720     sti();
2721 
2722     // Loop over process table looking for process to run.
2723     acquire(&ptable.lock);
2724     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2725       if(p->state != RUNNABLE)
2726         continue;
2727 
2728       // Switch to chosen process.  It is the process's job
2729       // to release ptable.lock and then reacquire it
2730       // before jumping back to us.
2731       // 这里在进来swtch之前, ptable.lock 是在当前这个进程获得的,
2732       // 然后什么时候释放呢? 释放的时间是在进入要切换的进程后.
2733       // 然后当进程切换重新进入到scheduler的时候, 又会获得这个ptable.lock
2734       // 这里yield的时候就是进程切换的时候, yield 里面会有acquire 这个锁
2735       // acquire(&ptable.lock);  //DOC: yieldlock
2736       proc = p;
2737       switchuvm(p);
2738       p->state = RUNNING;
2739       // 调用swtch 以后, 当前的cpu 就会去运行这个proc所表示的进程
2740       swtch(&cpu->scheduler, proc->context);
2741       switchkvm();
2742 
2743       // Process is done running for now.
2744       // It should have changed its p->state before coming back.
2745       proc = 0;
2746     }
2747     release(&ptable.lock);
2748 
2749 
2750   }
2751 }
2752 
2753 // Enter scheduler.  Must hold only ptable.lock
2754 // and have changed proc->state.
2755 void
2756 sched(void)
2757 {
2758   int intena;
2759 
2760   if(!holding(&ptable.lock))
2761     panic("sched ptable.lock");
2762   if(cpu->ncli != 1)
2763     panic("sched locks");
2764   if(proc->state == RUNNING)
2765     panic("sched running");
2766   if(readeflags()&FL_IF)
2767     panic("sched interruptible");
2768   intena = cpu->intena;
2769   swtch(&proc->context, cpu->scheduler);
2770   cpu->intena = intena;
2771 }
2772 
2773 // Give up the CPU for one scheduling round.
2774 void
2775 yield(void)
2776 {
2777   acquire(&ptable.lock);  //DOC: yieldlock
2778   proc->state = RUNNABLE;
2779   sched();
2780   release(&ptable.lock);
2781 }
2782 
2783 // A fork child's very first scheduling by scheduler()
2784 // will swtch here.  "Return" to user space.
2785 void
2786 forkret(void)
2787 {
2788   static int first = 1;
2789   // Still holding ptable.lock from scheduler.
2790   release(&ptable.lock);
2791 
2792   if (first) {
2793     // Some initialization functions must be run in the context
2794     // of a regular process (e.g., they call sleep), and thus cannot
2795     // be run from main().
2796     first = 0;
2797     initlog();
2798   }
2799 
2800   // Return to "caller", actually trapret (see allocproc).
2801 }
2802 
2803 // Atomically release lock and sleep on chan.
2804 // Reacquires lock when awakened.
2805 void
2806 sleep(void *chan, struct spinlock *lk)
2807 {
2808   if(proc == 0)
2809     panic("sleep");
2810 
2811   if(lk == 0)
2812     panic("sleep without lk");
2813 
2814   // Must acquire ptable.lock in order to
2815   // change p->state and then call sched.
2816   // Once we hold ptable.lock, we can be
2817   // guaranteed that we won't miss any wakeup
2818   // (wakeup runs with ptable.lock locked),
2819   // so it's okay to release lk.
2820   if(lk != &ptable.lock){  //DOC: sleeplock0
2821     acquire(&ptable.lock);  //DOC: sleeplock1
2822     release(lk);
2823   }
2824 
2825   // Go to sleep.
2826   proc->chan = chan;
2827   proc->state = SLEEPING;
2828   sched();
2829 
2830   // Tidy up.
2831   proc->chan = 0;
2832 
2833   // Reacquire original lock.
2834   if(lk != &ptable.lock){  //DOC: sleeplock2
2835     release(&ptable.lock);
2836     acquire(lk);
2837   }
2838 }
2839 
2840 
2841 
2842 
2843 
2844 
2845 
2846 
2847 
2848 
2849 
2850 // Wake up all processes sleeping on chan.
2851 // The ptable lock must be held.
2852 static void
2853 wakeup1(void *chan)
2854 {
2855   struct proc *p;
2856 
2857   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
2858     if(p->state == SLEEPING && p->chan == chan)
2859       p->state = RUNNABLE;
2860 }
2861 
2862 // Wake up all processes sleeping on chan.
2863 void
2864 wakeup(void *chan)
2865 {
2866   acquire(&ptable.lock);
2867   wakeup1(chan);
2868   release(&ptable.lock);
2869 }
2870 
2871 // Kill the process with the given pid.
2872 // Process won't exit until it returns
2873 // to user space (see trap in trap.c).
2874 int
2875 kill(int pid)
2876 {
2877   struct proc *p;
2878 
2879   acquire(&ptable.lock);
2880   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2881     if(p->pid == pid){
2882       p->killed = 1;
2883       // Wake process from sleep if necessary.
2884       if(p->state == SLEEPING)
2885         p->state = RUNNABLE;
2886       release(&ptable.lock);
2887       return 0;
2888     }
2889   }
2890   release(&ptable.lock);
2891   return -1;
2892 }
2893 
2894 
2895 
2896 
2897 
2898 
2899 
2900 // Print a process listing to console.  For debugging.
2901 // Runs when user types ^P on console.
2902 // No lock to avoid wedging a stuck machine further.
2903 void
2904 procdump(void)
2905 {
2906   static char *states[] = {
2907   [UNUSED]    "unused",
2908   [EMBRYO]    "embryo",
2909   [SLEEPING]  "sleep ",
2910   [RUNNABLE]  "runble",
2911   [RUNNING]   "run   ",
2912   [ZOMBIE]    "zombie"
2913   };
2914   int i;
2915   struct proc *p;
2916   char *state;
2917   uint pc[10];
2918 
2919   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2920     if(p->state == UNUSED)
2921       continue;
2922     if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
2923       state = states[p->state];
2924     else
2925       state = "???";
2926     cprintf("%d %s %s", p->pid, state, p->name);
2927     if(p->state == SLEEPING){
2928       getcallerpcs((uint*)p->context->ebp+2, pc);
2929       for(i=0; i<10 && pc[i] != 0; i++)
2930         cprintf(" %p", pc[i]);
2931     }
2932     cprintf("\n");
2933   }
2934 }
2935 
2936 
2937 
2938 
2939 
2940 
2941 
2942 
2943 
2944 
2945 
2946 
2947 
2948 
2949 
