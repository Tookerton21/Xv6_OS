#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
}

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
  uint xticks;
  
  xticks = ticks;
  return xticks;
}

//Turn of the computer
int sys_halt(void){
  cprintf("Shutting down ...\n");
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
  return 0;
}

//Added for project 1
int 
sys_date(void)
{
	struct rtcdate *d;

	if(argptr(0, (void*)&d, sizeof(*d)) < 0)
		return -1;
	
	else{
		cmostime(d);
		return 0;
	}
}

//Added for project 2
int
sys_getuid(void){
  return proc->uid;
}

int 
sys_getgid(void){
  return proc->gid;
}

int 
sys_getppid(void){
  return proc->parent->pid;
}

int 
sys_setuid(void){
  if(argint(0, (int*)&proc->uid) < 0)
    return -1;

  //Ensure that uid gets set within its bounds
  if(proc->uid < 0 || proc->uid > 32767){
    proc->uid = 3;
    return -1;
  }

  else 
    return 0;	
}

int
sys_setgid(void){
  if(argint(0, (int*)&proc->gid) < 0)
    return -1;
	
  //Ensure that gid get set within its bounds
  if(proc->gid < 0 || proc->gid > 32767){
    proc->gid = 3;
    return -1;
  }
	
  else
    return 0;
}

int
sys_getprocs(void){
  int max;
  struct uproc *table;
	
  if(argint(0, &max) < 0)
    return -1;

  if(argptr(1, (void*)&table, sizeof(*table)) < 0)
    return -3;

  return getprocs(max,table);
}
