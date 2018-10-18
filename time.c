#include "types.h"
#include "user.h"

int main(int argc, char* argv[]){

  //Ensure that we have the correct amount of arguments being passed in
  if(argc <=1){
    printf(1, "Error, not enough arguments\n");
    exit();
  }
  
  //Var variables
  uint start, end, pid;

  //Set the start time calling uptime
  start = (uint)uptime();
  end = 0;
  pid = fork();

  //check to see if there are other process' running
  if(pid == 0){
   	if(exec(argv[1], argv+1) == 0); 
	exit();
  }
  else
    wait();
  //call uptime again to grab the running time.
  end = (uint)uptime();

  printf(1,"%s %s %d.%d\n", argv[1], " ran in  ",  (end-start)/100, (end-start)%100); 
  exit();
}
