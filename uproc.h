#define STRMAX 32

//Data structure to copy the essensial information from struct proc in the
//function call getprocs
struct uproc {
  uint pid;
  uint uid;
  uint gid;
  uint ppid;
  uint elapsed_ticks;
  uint CPU_total_ticks;
  char state[STRMAX];
  uint size;
  char name[STRMAX];
};

