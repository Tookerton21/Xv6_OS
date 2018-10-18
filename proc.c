#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "uproc.h"

//#define CS333_P3P4
//#define DEBUG

struct StateLists {
  struct proc* ready;
  struct proc* free;
  struct proc* sleep;
  struct proc* zombie;
  struct proc* running;
  struct proc* embryo;
};

void
init_states(struct StateLists* list){
  list->ready = 0;
  list->free = 0;
  list->sleep = 0;
  list->zombie = 0;
  list->running =0;
  list->embryo = 0;
}

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  struct StateLists pLists;
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
 initlock(&ptable.lock, "ptable");
}

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  
  #ifndef CS333_P3P4
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED){
      goto found;
    }
  #else
  //Call for the lock, call remove_head and assign to p, if valid proc then goto found 
  if((p = remove_head(&ptable.pLists.free, UNUSED)) != 0){
 	goto found;
  }

  release(&ptable.lock);//Release Lock if there no free UNUSED Procs available 
  #endif
  return 0;

found:
  p->state = EMBRYO;// Still have lock, and change from unused to embryo
  
  #ifdef CS333_P3P4
  add_head(&ptable.pLists.embryo, p, EMBRYO);//Add p to the head of the embryo list
  #endif

  p->pid = nextpid++;
  release(&ptable.lock);//Release lock from the goto
  
  // Allocate kernel stack. 
  //Check to see if memory is allocated on the stack. If none then remove embryo
  //from embryo list and place back at the head of the unused list
  if((p->kstack = kalloc()) == 0){
    acquire(&ptable.lock);//get lock
    
    //Added for assignment 3. Remove from the Embryo list and add to the free list.
    #ifndef CS_P3P4
    p->state = UNUSED;
    #else
    remove(&ptable.pLists.embryo,p, EMBRYO);
    p->state = UNUSED;
    add_head(&ptable.pLists.free,p, UNUSED);
    #endif

    release(&ptable.lock);//Release lock for 

    cprintf("NOT ENOUGH MEM ON STACK\n");
    return 0;
  }

  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  //Asignment 1
  p->start_ticks = (uint)ticks;

  //Assignment 2
  p->cpu_ticks_total = CPU_T_TOTAL;//Initualize to 0
  p->cpu_ticks_in = CPU_T_IN;//Initialize to 0
  
  return p;
}

// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  acquire(&ptable.lock);//Lock is held for initialization of Lists.

  //Assignment 3
  init_states(&ptable.pLists);//Initiate pLists to null(0)
  
  //Initialize the UNUSED list 
  for(int i=0; i<NPROC; ++i){
    if(ptable.proc[i].state == UNUSED){
      add_head(&ptable.pLists.free, &ptable.proc[i], UNUSED);
    }
  }

  release(&ptable.lock);

  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  acquire(&ptable.lock);

  #ifndef CS333_P3P4
  p->state=RUNNABLE;
  #else
  //Assignment 3 
  //Remove from the embryo, change to Runnable state and add 
  //To the RUNNABLE list
  remove(&ptable.pLists.embryo, p, EMBRYO);
  p->state = RUNNABLE;
  add_tail(&ptable.pLists.ready, p, RUNNABLE);
  #endif
  
  release(&ptable.lock);//

  //Added for assignment2
  p->uid = UID; //Init to 0
  p->gid = GID; //Init to 0
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  //Error has occored and ust take the empbryo and put back 
  //on the unused list
  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
 
    acquire(&ptable.lock);
    #ifndef CS_P3P4
    np->state = UNUSED;
    #else
    //Assignment 3
    //Remove from the Embryo list, change state to UNUSED
    //and add to the head of the UNUSED list
    remove(&ptable.pLists.embryo, np, EMBRYO);//remove from embryo
    np->state = UNUSED;
    add_head(&ptable.pLists.free, np, UNUSED);//add to unused
    #endif

    release(&ptable.lock);
    return -1;
  }

  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  //Assignment 2
  //Copy ID's into the fork
  np->uid = proc->uid;
  np->gid = proc->gid;
  
  // lock to force the compiler to emit the np->state write last.
  
  //Go from the embryo state to the runnable state
  acquire(&ptable.lock);
  
  #ifndef CS333_P3P4
  np->state = RUNNABLE;
  #else
  //Assignment 3
  //Remove from the Empryo list, change state to the RUNNABLE state and
  //add to the tail off the RUNNABLE list
  remove(&ptable.pLists.embryo, np, EMBRYO);//remove from embryo
  np->state = RUNNABLE;
  add_tail(&ptable.pLists.ready, np, RUNNABLE);//Add to runnable
  #endif

  release(&ptable.lock);
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#else
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  //Assignment 3
  //Remove from the RUNNING list, change state to Zombie and
  //add to the ZOMBIE list
  remove(&ptable.pLists.running, proc, RUNNING);//remove from running
  proc->state = ZOMBIE;
  add_head(&ptable.pLists.zombie, proc, ZOMBIE);//add to zombie
  sched();
  panic("zombie exit");

}
#endif

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#else
int
wait(void)
{

  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;

  p = ptable.pLists.zombie;
  while(p != 0){
    if(p->parent != proc){
    p = p->next;
     
      continue;
    }
      havekids = 1;
      pid = p->pid;
      kfree(p->kstack);
      p->kstack = 0;
      freevm(p->pgdir);

      //Assignment 3
      //Add to unused list        
      remove(&ptable.pLists.zombie, p, ZOMBIE);//remove from zombie
      p->state = UNUSED;
      add_head(&ptable.pLists.free, p, UNUSED);//Add to unused

      p->pid = 0;
      p->parent = 0;
      p->name[0] = 0;
      p->killed = 0;
      release(&ptable.lock);
      return pid;
    }

    p = ptable.pLists.embryo;
    while(p != 0 && havekids != 1){
      if(p->parent != proc){
        p = p->next;
        continue;
      }
      havekids = 1; 
      break; 
   }

    p = ptable.pLists.sleep;
    while(p != 0 && havekids != 1){
      if(p->parent != proc){
        p = p->next;
        continue;
      }
      havekids = 1; 
      break;
    }

    p = ptable.pLists.running;
    while(p != 0 && havekids != 1){
      if(p->parent != proc){
        p = p->next;
        continue;
      }
      havekids = 1; 
      break;
    }

    p = ptable.pLists.ready;
    while(p != 0 && havekids != 1){
      if(p->parent != proc){
        p = p->next;
        continue;
      }
      havekids = 1; 
      break;
    }
    
    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
}
#endif

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle
  uint ticks_in; // added for assign2
  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      
      //Assignment 2
      //Grab ticks to start the count for tick_in and cpu_ticks_in
      ticks_in = (uint)ticks; 
      p->cpu_ticks_in = ticks_in;	
      
      swtch(&cpu->scheduler, proc->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}

#else
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle
  uint ticks_in; // added for assign2
  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    //Grap the first process in line in the ready list
    p = remove_head(&ptable.pLists.ready, RUNNABLE);
      
    //Check to see if p is a valid proc pointer
    if(p){
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      //Change the state and the add to the head of the RUNNING list
 	     
 p->state = RUNNING;
      add_head(&ptable.pLists.running, p, RUNNING);

      //Assignment 2
      //Grab ticks to start the count for tick_in and cpu_ticks_in
      ticks_in = (uint)ticks; 
      p->cpu_ticks_in = ticks_in;	
      
      swtch(&cpu->scheduler, proc->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }

}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;

  //Assignment 2
  //Add time while the process is runinng
  proc->cpu_ticks_total = proc->cpu_ticks_total+((uint)ticks-proc->cpu_ticks_in);
  
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;

  //Start the cpu_ticks
}
#else
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;

  //Assignment 2
  //Add time while the process is runinng
  proc->cpu_ticks_total = proc->cpu_ticks_total+((uint)ticks-proc->cpu_ticks_in);
  
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;

  //Start the cpu_ticks

}
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  #ifndef CS333_P3P4
  proc->state = RUNNABLE;
  #else
  //Assignment 3
  remove(&ptable.pLists.running,proc, RUNNING);
  proc->state = RUNNABLE;
  add_tail(&ptable.pLists.ready, proc, RUNNABLE);
  #endif

  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
//cprintf("In forket call\n\n");
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
//	cprintf("In func sleep \n\n");  

  if(proc == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    if (lk) release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  
  #ifndef CS333_P3P4
  proc->state=SLEEPING;
  #else 
  //Assignment 3
  remove(&ptable.pLists.running, proc, RUNNING);
  proc->state = SLEEPING;
  add_head(&ptable.pLists.sleep, proc, SLEEPING);
  #endif

  sched();
  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
  struct proc *p;
  p = ptable.pLists.sleep;
  while(p != 0){
    if(p->chan == chan){          
      remove(&ptable.pLists.sleep,p , SLEEPING);
      p->state = RUNNABLE;
      add_tail(&ptable.pLists.ready,p , RUNNABLE);
    }
    p = p->next;
  }
}
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
//	cprintf("11In func kill() \n\n");  
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#else
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  
  //Assignment 3
  p = ptable.pLists.sleep;
  while(p != 0){
    if(p->pid == pid){
      p->killed = 1;
      remove(&ptable.pLists.sleep, p, SLEEPING);
      p->state = RUNNABLE;
      add_tail(&ptable.pLists.ready, p, RUNNABLE);
      release(&ptable.lock);
      return 0;
    }
    p = p->next;  
  } 
  
  p = ptable.pLists.embryo;
  while(p != 0){
    if(p->pid == pid){
      p->killed = 1;
      release(&ptable.lock);
      return 0;
     }
   p = p->next;
  }

  p = ptable.pLists.ready;
  while(p != 0){
    if(p->pid == pid){
      p->killed = 1;
      release(&ptable.lock);
      return 0;
    }      
    p = p->next;
  }

  p = ptable.pLists.zombie;
  while(p != 0){
    if(p->pid == pid){
      p->killed = 1;
      release(&ptable.lock);
      return 0;
    }    
    p = p->next;
  }
  
  p = ptable.pLists.running;
  while(p != 0){
    if(p->pid == pid){
      p->killed = 1;
      release(&ptable.lock);
      return 0;
    }
    p = p->next;
  }

  release(&ptable.lock);
  return -1;
}
#endif

static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleeping",
  [RUNNABLE]  "runnable",
  [RUNNING]   "runnning",
  [ZOMBIE]    "zombie"
};

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  uint cur;//Store the corrent time
  uint ppid;

  static char *label[] = {
  	"PID",
        "Name",
  	"UID",
  	"GID",
	"PPID",
	"Elapsed",
	"CPU",
	"State",
	"Size",
 	"PCs"
  };
  
  cur = (uint)ticks;//grabbing curent ticks
  
  cprintf("%s\t ,%s\t ,%s\t ,%s\t ,%s\t ,%s ,%s\t ,%s\t ,%s\t ,%s\t \n", label[0],
								    label[1],
								    label[2],
								    label[3],
								    label[4],
								    label[5],
								    label[6],
								    label[7],
								    label[8],
						    		    label[9]
  );

  cprintf("\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){

    if(p->state == UNUSED)
      continue;

    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
	
    else
      state = "???";

    //Test to see if we are process is the parent
    if(p->pid == 1)
      ppid = 1;

    else
      ppid = p->parent->pid;
    
  cprintf("%d\t %s\t %d\t %d\t %d\t %d.%d\t %d.%d\t %s\t %d\t", p->pid, 
							   p->name, 
							   p->uid, 
							   p->gid, 
							   ppid,
							   (cur-p->start_ticks)/100, (cur-p->start_ticks)%100, 
							   p->cpu_ticks_total/100, p->cpu_ticks_total%100,
							   state,
							   p->sz 
  );

    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }

    cprintf("\n");
  }
    cprintf("\n");
}

//Added for assign 3
//Print the amount of procs that in the UNUSED proc list
int
freedump(){
  acquire(&ptable.lock);
  if(ptable.pLists.free == 0){
   release(&ptable.lock);
    return 0;  
  }

  struct proc* ptr = ptable.pLists.free;
  int count = 0;

  do{
    ++count;
    ptr = ptr->next;
  }while(ptr != 0);
    cprintf("\n");

  cprintf("%s %d \n", "Free(unused) count: ", count);
  release(&ptable.lock);
    return 0;
}

//Added for assign 3
//CTRL-r
//WIll print the PIDS of all the process that are currently on the ready list
int
readydump(){
  acquire(&ptable.lock);

  if(ptable.pLists.ready == 0){
    cprintf( "RUNNABLE LIST EMPTY\n"); 
    release(&ptable.lock);
    return 0;
  }
 
  struct proc* ptr = ptable.pLists.ready;
  cprintf("Runnable dump: \n");
  
  do{
    if(ptr->next == 0)
      cprintf("%d", ptr->pid);
    
    else
      cprintf("%d %s", ptr->pid, " -> ");
    ptr = ptr->next;
  }while(ptr != 0);
cprintf("\n");
  release(&ptable.lock);

cprintf("\n");
  return 0;
}

//Assignment 3
//Print out the PID of all the items in the Sleep proc list
void
sleepdump(){
  if(ptable.pLists.sleep == 0){
    cprintf("Empy Sleep List\n");
    return;
  }

  cprintf("Sleep List: \n");
  struct proc* ptr = ptable.pLists.sleep;
  
  while(ptr->next != 0){
    cprintf("%d %s", ptr->pid, " -> ");
    ptr = ptr->next;
  }
    cprintf("%d \n", ptr->pid);

  return;
}

//Assignment 3
//Print out the PID along with the PPID of each proc in the 
//ZOMBIE proc list.
void 
zombiedump(){
  if(ptable.pLists.zombie == 0){
    cprintf("Empty Zombie List\n");
    return;
  }
 
  //int ppid;
  struct proc* ptr = ptable.pLists.zombie;
  

  cprintf("Zombie List: \n");
  while(ptr->next != 0){
 
    cprintf("(%d %s %d) %s", ptr->pid, ", PPID", ptr->parent->pid, " -> ");
    ptr = ptr->next;
  }
  cprintf("(%d, PPID %d) \n", ptr->pid, ptr->parent->pid);	
  return;
}

//Added for project 2
int 
getprocs(int max, struct uproc* table){
	
  struct proc *ptr;
  int pos = 0;

  uint cur_tick = (uint)ticks;
  
  acquire(&ptable.lock); // Lock ptable
  if(max < 0)
    return -1;
  
  ptr = ptable.proc;
  
  for(int i=0; pos < max && i < NPROC; ++i){
 
    if(ptr->state){

      table[pos].pid = ptr->pid;
      table[pos].uid = ptr->uid;
      table[pos].gid = ptr->gid;

      //Test to see if this is the parrent
      if(ptr->pid == 1)
	table[pos].ppid = 1;

      else
        table[pos].ppid = ptr->parent->pid;
      
      table[pos].elapsed_ticks = (cur_tick - ptr->start_ticks);
      table[pos].CPU_total_ticks = ptr->cpu_ticks_total;
      safestrcpy(table[pos].state, states[ptr->state], strlen(states[ptr->state]));
      table[pos].size = ptr->sz;
      safestrcpy(table[pos].name, ptr->name, strlen(ptr->name)+1);

      ++ptr;//Move to the next location in ptr
      ++pos;//counter for copied  	   
    }
  }
  
  release(&ptable.lock);
  return pos; 
}

//Assignment 3
//Add to the head of the linked list for StateLists. Uses comparison
// betwent the list->state adn enum procstate to ensure we are adding to 
//the correct list, Panic otherwise.
void
add_head(struct proc** list, struct proc* ptr, enum procstate state){
  if(ptr == 0)
    panic("empty Proc struct!!!");

  if(ptr->state != state)
    panic("Wrong STATE, No additon");

  ptr->next = *list;
  (*list) = ptr;
  return;
}

//Assignment 3
//Add to the tail of a linked list for State list. Compares between
//list->state and the enum procstate passed in. Panic if there is no
//match
void
add_tail(struct proc** list, struct proc* ptr, enum procstate state){
  if(ptr == 0)
    panic("empty proc struct");

  if(ptr->state != state)
    panic("Wrong STATE, No addition");

  while((*list))
    list = &(*list)->next;

  (*list) = ptr;
  ptr->next = 0;
}

//Assignment 3
//Remove a proc from the proc list fom the head of the list that is passed
//in. COmpare the list->state with the enum procstate. Return 0 is the the list
//passed in is null, otherwise return the head. 
struct proc*
remove_head(struct proc** list, enum procstate state){
  struct proc* ptr = *list;
	
  if(!ptr)
    return ptr;

  if((*list)->state != state)
    panic("Incorect state, cant remove from head");
	
  *list=(*list)->next;
    return ptr;
}

//Assignment 3
//Remove a proc from a list that is passed in. Searches for the item to be removed
// if found removes from the list. If no match is found then panic and send a message;
void
remove(struct proc** list, struct proc* ptr, enum procstate state){
  if(ptr == 0)
    panic("empty proc struct passed in!");
  
  if(ptr->state != state)
    panic("Incorrect state!!!");
  
  //Move up the list looking for the match with the condition
  // that the next item isnt null and that the no match
  while((*list) != ptr && (*list) != 0)
    list = &(*list)->next;
  
  //Ensure taht there is a match and that the list isnt empty
  if((*list) == ptr && (*list) != 0)
    (*list) = ptr->next;

  else
    panic("NO Match to remove!!!");
}
