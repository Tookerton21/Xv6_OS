#include "types.h"
#include "user.h"
#include "uproc.h"
//#include "syscall.h"

#define SIZE  72
int main(int argc, char* argv[]){
  
  
  //Variable dec
  struct uproc *uptr;
  int size_ar;

  //Test to see if there is a second arg
  if(argv[1] != 0)
    size_ar = atoi(argv[1]);//Converting string into an int
  
  else//Default to size 72
    size_ar = SIZE; 
  
  uptr = malloc(sizeof(struct uproc) * size_ar);//allocate memory off the heap  
  
  int size = getprocs(size_ar, uptr);//Get the amount of uproc tables 

  //Test to ensure that number return from getprocs is valid
  if(size  < 0){
	printf(2, "getprocs failed\n");
	exit();
  }

  //Print out the label for the uproc table
  printf(2,"%s,\t %s,\t %s,\t %s,\t %s, %s,\t %s,\t %s,\t %s,\t \n","PID",
								    "UID", 
								    "GID",  
								    "PPID", 
								    "Elapsed",
								    "CPU", 
								    "State", 
								    "Size", 
								    "Name");
  //Print out the Uproc table using size as the condition in the for loop. 
  for(int i=0; i<size; ++i){
    printf(1, ":%d\t :%d\t :%d\t :%d\t :%d.%d\t :%d.%d\t :%s\t :%d\t :%s\t \n", uptr[i].pid,
	       		  	    					 uptr[i].uid,
				    					 uptr[i].gid,
			                          		         uptr[i].ppid,
				    					 uptr[i].elapsed_ticks/100, uptr[i].elapsed_ticks%100,
				    					 uptr[i].CPU_total_ticks/100, uptr[i].CPU_total_ticks%100,
						 			 uptr[i].state,
						 			 uptr[i].size,
						 			 uptr[i].name);
  }
  //Deallocate the memory in the in each of the char ptrs
  for(int i=0; i<size; ++i){
    free(uptr[i].state);
    free(uptr[i].name);
  }	
  //Deallocate the memory from array of uprocs
  free(uptr);
  exit();
}
