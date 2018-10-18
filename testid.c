#include "types.h"
#include "user.h"

int main(int argc, char* argv[]){

	//Var declarations
	uint uid, gid, ppid;
  //Test to see what the current UID is
  uid = getuid();
  printf(2, "%s %d \n\n","Current_UID_is:_", uid);
  printf(2, "%s \n","Setting_UID_to_100");
  setuid(100);
  uid = getuid();
  printf(2,"%s %d \n\n","Current_UID_is_", uid);
  
  //Setting UID to a negative number
  printf(2, "%s \n", "Setting_UID_to_-5");
  setuid(-5);
  uid = getuid();
  printf(2,"%s %d \n\n", "Current_UID_is_", uid);

  //Setting UID to a very Large number
  printf(2,"%s \n", "Setting_UID_to_50000");
  setuid(50000);
  uid = getuid();
  printf(2,"%s %d \n\n", "Current_UID_is_", uid);

  //GID TEST
  gid = getgid();
  printf(2, "%s %d \n","Curretn_GID_is:_", gid);
  printf(2, "%s \n","Setting_GID_to_100");
  setgid(100);
  gid = getgid();
  printf(2, "%s %d \n\n","Current_GID_is:_", gid);

  //Test GID to a negative number
  printf(2, "%s \n", "Setting Current_GID_to_-3");
  setgid(-3);
  gid = getgid();
  printf(2, "%s %d \n\n", "Current_GID_is:_", gid);

  //Test GID with a very large number at 60000
  printf(2, "%s \n","Setting_GID_to_60000");
  setgid(60000);
  gid = getgid();
  printf(2, "%s %d \n\n", "Current_GID_is:_", gid);
  
  //PPID TEST
  ppid = getppid();
  printf(2, "%s %d \n","My_parent_process_is:_", ppid);
  printf(2, "Done!\n");
	
  exit();
}

