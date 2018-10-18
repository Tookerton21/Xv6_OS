
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "uproc.h"
//#include "syscall.h"

#define SIZE  72
int main(int argc, char* argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 48             	sub    $0x48,%esp
  14:	89 c8                	mov    %ecx,%eax
  //Variable dec
  struct uproc *uptr;
  int size_ar;

  //Test to see if there is a second arg
  if(argv[1] != 0)
  16:	8b 50 04             	mov    0x4(%eax),%edx
  19:	83 c2 04             	add    $0x4,%edx
  1c:	8b 12                	mov    (%edx),%edx
  1e:	85 d2                	test   %edx,%edx
  20:	74 19                	je     3b <main+0x3b>
    size_ar = atoi(argv[1]);//Converting string into an int
  22:	8b 40 04             	mov    0x4(%eax),%eax
  25:	83 c0 04             	add    $0x4,%eax
  28:	8b 00                	mov    (%eax),%eax
  2a:	83 ec 0c             	sub    $0xc,%esp
  2d:	50                   	push   %eax
  2e:	e8 e5 03 00 00       	call   418 <atoi>
  33:	83 c4 10             	add    $0x10,%esp
  36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  39:	eb 07                	jmp    42 <main+0x42>
  
  else//Default to size 72
    size_ar = SIZE; 
  3b:	c7 45 e4 48 00 00 00 	movl   $0x48,-0x1c(%ebp)
  
  uptr = malloc(sizeof(struct uproc) * size_ar);//allocate memory off the heap  
  42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  45:	6b c0 5c             	imul   $0x5c,%eax,%eax
  48:	83 ec 0c             	sub    $0xc,%esp
  4b:	50                   	push   %eax
  4c:	e8 28 09 00 00       	call   979 <malloc>
  51:	83 c4 10             	add    $0x10,%esp
  54:	89 45 d8             	mov    %eax,-0x28(%ebp)
  
  int size = getprocs(size_ar, uptr);//Get the amount of uproc tables 
  57:	83 ec 08             	sub    $0x8,%esp
  5a:	ff 75 d8             	pushl  -0x28(%ebp)
  5d:	ff 75 e4             	pushl  -0x1c(%ebp)
  60:	e8 62 05 00 00       	call   5c7 <getprocs>
  65:	83 c4 10             	add    $0x10,%esp
  68:	89 45 d4             	mov    %eax,-0x2c(%ebp)

  //Test to ensure that number return from getprocs is valid
  if(size  < 0){
  6b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  6f:	79 17                	jns    88 <main+0x88>
	printf(2, "getprocs failed\n");
  71:	83 ec 08             	sub    $0x8,%esp
  74:	68 5c 0a 00 00       	push   $0xa5c
  79:	6a 02                	push   $0x2
  7b:	e8 26 06 00 00       	call   6a6 <printf>
  80:	83 c4 10             	add    $0x10,%esp
	exit();
  83:	e8 67 04 00 00       	call   4ef <exit>
  }

  //Print out the label for the uproc table
  printf(2,"%s,\t %s,\t %s,\t %s,\t %s, %s,\t %s,\t %s,\t %s,\t \n","PID",
  88:	83 ec 04             	sub    $0x4,%esp
  8b:	68 6d 0a 00 00       	push   $0xa6d
  90:	68 72 0a 00 00       	push   $0xa72
  95:	68 77 0a 00 00       	push   $0xa77
  9a:	68 7d 0a 00 00       	push   $0xa7d
  9f:	68 81 0a 00 00       	push   $0xa81
  a4:	68 89 0a 00 00       	push   $0xa89
  a9:	68 8e 0a 00 00       	push   $0xa8e
  ae:	68 92 0a 00 00       	push   $0xa92
  b3:	68 96 0a 00 00       	push   $0xa96
  b8:	68 9c 0a 00 00       	push   $0xa9c
  bd:	6a 02                	push   $0x2
  bf:	e8 e2 05 00 00       	call   6a6 <printf>
  c4:	83 c4 30             	add    $0x30,%esp
								    "CPU", 
								    "State", 
								    "Size", 
								    "Name");
  //Print out the Uproc table using size as the condition in the for loop. 
  for(int i=0; i<size; ++i){
  c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  ce:	e9 18 01 00 00       	jmp    1eb <main+0x1eb>
			                          		         uptr[i].ppid,
				    					 uptr[i].elapsed_ticks/100, uptr[i].elapsed_ticks%100,
				    					 uptr[i].CPU_total_ticks/100, uptr[i].CPU_total_ticks%100,
						 			 uptr[i].state,
						 			 uptr[i].size,
						 			 uptr[i].name);
  d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  d6:	6b d0 5c             	imul   $0x5c,%eax,%edx
  d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  dc:	01 d0                	add    %edx,%eax
  de:	83 c0 3c             	add    $0x3c,%eax
  e1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
				    					 uptr[i].gid,
			                          		         uptr[i].ppid,
				    					 uptr[i].elapsed_ticks/100, uptr[i].elapsed_ticks%100,
				    					 uptr[i].CPU_total_ticks/100, uptr[i].CPU_total_ticks%100,
						 			 uptr[i].state,
						 			 uptr[i].size,
  e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e7:	6b d0 5c             	imul   $0x5c,%eax,%edx
  ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  ed:	01 d0                	add    %edx,%eax
								    "State", 
								    "Size", 
								    "Name");
  //Print out the Uproc table using size as the condition in the for loop. 
  for(int i=0; i<size; ++i){
    printf(1, ":%d\t :%d\t :%d\t :%d\t :%d.%d\t :%d.%d\t :%s\t :%d\t :%s\t \n", uptr[i].pid,
  ef:	8b 78 38             	mov    0x38(%eax),%edi
  f2:	89 7d c0             	mov    %edi,-0x40(%ebp)
	       		  	    					 uptr[i].uid,
				    					 uptr[i].gid,
			                          		         uptr[i].ppid,
				    					 uptr[i].elapsed_ticks/100, uptr[i].elapsed_ticks%100,
				    					 uptr[i].CPU_total_ticks/100, uptr[i].CPU_total_ticks%100,
						 			 uptr[i].state,
  f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  f8:	6b d0 5c             	imul   $0x5c,%eax,%edx
  fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  fe:	01 d0                	add    %edx,%eax
 100:	8d 48 18             	lea    0x18(%eax),%ecx
 103:	89 4d bc             	mov    %ecx,-0x44(%ebp)
    printf(1, ":%d\t :%d\t :%d\t :%d\t :%d.%d\t :%d.%d\t :%s\t :%d\t :%s\t \n", uptr[i].pid,
	       		  	    					 uptr[i].uid,
				    					 uptr[i].gid,
			                          		         uptr[i].ppid,
				    					 uptr[i].elapsed_ticks/100, uptr[i].elapsed_ticks%100,
				    					 uptr[i].CPU_total_ticks/100, uptr[i].CPU_total_ticks%100,
 106:	8b 45 e0             	mov    -0x20(%ebp),%eax
 109:	6b d0 5c             	imul   $0x5c,%eax,%edx
 10c:	8b 45 d8             	mov    -0x28(%ebp),%eax
 10f:	01 d0                	add    %edx,%eax
 111:	8b 48 14             	mov    0x14(%eax),%ecx
								    "State", 
								    "Size", 
								    "Name");
  //Print out the Uproc table using size as the condition in the for loop. 
  for(int i=0; i<size; ++i){
    printf(1, ":%d\t :%d\t :%d\t :%d\t :%d.%d\t :%d.%d\t :%s\t :%d\t :%s\t \n", uptr[i].pid,
 114:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 119:	89 c8                	mov    %ecx,%eax
 11b:	f7 e2                	mul    %edx
 11d:	89 d6                	mov    %edx,%esi
 11f:	c1 ee 05             	shr    $0x5,%esi
 122:	6b c6 64             	imul   $0x64,%esi,%eax
 125:	89 ce                	mov    %ecx,%esi
 127:	29 c6                	sub    %eax,%esi
	       		  	    					 uptr[i].uid,
				    					 uptr[i].gid,
			                          		         uptr[i].ppid,
				    					 uptr[i].elapsed_ticks/100, uptr[i].elapsed_ticks%100,
				    					 uptr[i].CPU_total_ticks/100, uptr[i].CPU_total_ticks%100,
 129:	8b 45 e0             	mov    -0x20(%ebp),%eax
 12c:	6b d0 5c             	imul   $0x5c,%eax,%edx
 12f:	8b 45 d8             	mov    -0x28(%ebp),%eax
 132:	01 d0                	add    %edx,%eax
 134:	8b 40 14             	mov    0x14(%eax),%eax
								    "State", 
								    "Size", 
								    "Name");
  //Print out the Uproc table using size as the condition in the for loop. 
  for(int i=0; i<size; ++i){
    printf(1, ":%d\t :%d\t :%d\t :%d\t :%d.%d\t :%d.%d\t :%s\t :%d\t :%s\t \n", uptr[i].pid,
 137:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 13c:	f7 e2                	mul    %edx
 13e:	c1 ea 05             	shr    $0x5,%edx
 141:	89 55 b8             	mov    %edx,-0x48(%ebp)
	       		  	    					 uptr[i].uid,
				    					 uptr[i].gid,
			                          		         uptr[i].ppid,
				    					 uptr[i].elapsed_ticks/100, uptr[i].elapsed_ticks%100,
 144:	8b 45 e0             	mov    -0x20(%ebp),%eax
 147:	6b d0 5c             	imul   $0x5c,%eax,%edx
 14a:	8b 45 d8             	mov    -0x28(%ebp),%eax
 14d:	01 d0                	add    %edx,%eax
 14f:	8b 48 10             	mov    0x10(%eax),%ecx
								    "State", 
								    "Size", 
								    "Name");
  //Print out the Uproc table using size as the condition in the for loop. 
  for(int i=0; i<size; ++i){
    printf(1, ":%d\t :%d\t :%d\t :%d\t :%d.%d\t :%d.%d\t :%s\t :%d\t :%s\t \n", uptr[i].pid,
 152:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 157:	89 c8                	mov    %ecx,%eax
 159:	f7 e2                	mul    %edx
 15b:	89 d3                	mov    %edx,%ebx
 15d:	c1 eb 05             	shr    $0x5,%ebx
 160:	6b c3 64             	imul   $0x64,%ebx,%eax
 163:	89 cb                	mov    %ecx,%ebx
 165:	29 c3                	sub    %eax,%ebx
	       		  	    					 uptr[i].uid,
				    					 uptr[i].gid,
			                          		         uptr[i].ppid,
				    					 uptr[i].elapsed_ticks/100, uptr[i].elapsed_ticks%100,
 167:	8b 45 e0             	mov    -0x20(%ebp),%eax
 16a:	6b d0 5c             	imul   $0x5c,%eax,%edx
 16d:	8b 45 d8             	mov    -0x28(%ebp),%eax
 170:	01 d0                	add    %edx,%eax
 172:	8b 40 10             	mov    0x10(%eax),%eax
								    "State", 
								    "Size", 
								    "Name");
  //Print out the Uproc table using size as the condition in the for loop. 
  for(int i=0; i<size; ++i){
    printf(1, ":%d\t :%d\t :%d\t :%d\t :%d.%d\t :%d.%d\t :%s\t :%d\t :%s\t \n", uptr[i].pid,
 175:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 17a:	f7 e2                	mul    %edx
 17c:	89 d0                	mov    %edx,%eax
 17e:	c1 e8 05             	shr    $0x5,%eax
 181:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	       		  	    					 uptr[i].uid,
				    					 uptr[i].gid,
			                          		         uptr[i].ppid,
 184:	8b 45 e0             	mov    -0x20(%ebp),%eax
 187:	6b d0 5c             	imul   $0x5c,%eax,%edx
 18a:	8b 45 d8             	mov    -0x28(%ebp),%eax
 18d:	01 d0                	add    %edx,%eax
								    "State", 
								    "Size", 
								    "Name");
  //Print out the Uproc table using size as the condition in the for loop. 
  for(int i=0; i<size; ++i){
    printf(1, ":%d\t :%d\t :%d\t :%d\t :%d.%d\t :%d.%d\t :%s\t :%d\t :%s\t \n", uptr[i].pid,
 18f:	8b 78 0c             	mov    0xc(%eax),%edi
 192:	89 7d b0             	mov    %edi,-0x50(%ebp)
	       		  	    					 uptr[i].uid,
				    					 uptr[i].gid,
 195:	8b 45 e0             	mov    -0x20(%ebp),%eax
 198:	6b d0 5c             	imul   $0x5c,%eax,%edx
 19b:	8b 45 d8             	mov    -0x28(%ebp),%eax
 19e:	01 d0                	add    %edx,%eax
								    "State", 
								    "Size", 
								    "Name");
  //Print out the Uproc table using size as the condition in the for loop. 
  for(int i=0; i<size; ++i){
    printf(1, ":%d\t :%d\t :%d\t :%d\t :%d.%d\t :%d.%d\t :%s\t :%d\t :%s\t \n", uptr[i].pid,
 1a0:	8b 78 08             	mov    0x8(%eax),%edi
	       		  	    					 uptr[i].uid,
 1a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1a6:	6b d0 5c             	imul   $0x5c,%eax,%edx
 1a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1ac:	01 d0                	add    %edx,%eax
								    "State", 
								    "Size", 
								    "Name");
  //Print out the Uproc table using size as the condition in the for loop. 
  for(int i=0; i<size; ++i){
    printf(1, ":%d\t :%d\t :%d\t :%d\t :%d.%d\t :%d.%d\t :%s\t :%d\t :%s\t \n", uptr[i].pid,
 1ae:	8b 48 04             	mov    0x4(%eax),%ecx
 1b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1b4:	6b d0 5c             	imul   $0x5c,%eax,%edx
 1b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1ba:	01 d0                	add    %edx,%eax
 1bc:	8b 00                	mov    (%eax),%eax
 1be:	83 ec 0c             	sub    $0xc,%esp
 1c1:	ff 75 c4             	pushl  -0x3c(%ebp)
 1c4:	ff 75 c0             	pushl  -0x40(%ebp)
 1c7:	ff 75 bc             	pushl  -0x44(%ebp)
 1ca:	56                   	push   %esi
 1cb:	ff 75 b8             	pushl  -0x48(%ebp)
 1ce:	53                   	push   %ebx
 1cf:	ff 75 b4             	pushl  -0x4c(%ebp)
 1d2:	ff 75 b0             	pushl  -0x50(%ebp)
 1d5:	57                   	push   %edi
 1d6:	51                   	push   %ecx
 1d7:	50                   	push   %eax
 1d8:	68 cc 0a 00 00       	push   $0xacc
 1dd:	6a 01                	push   $0x1
 1df:	e8 c2 04 00 00       	call   6a6 <printf>
 1e4:	83 c4 40             	add    $0x40,%esp
								    "CPU", 
								    "State", 
								    "Size", 
								    "Name");
  //Print out the Uproc table using size as the condition in the for loop. 
  for(int i=0; i<size; ++i){
 1e7:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
 1eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1ee:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
 1f1:	0f 8c dc fe ff ff    	jl     d3 <main+0xd3>
						 			 uptr[i].state,
						 			 uptr[i].size,
						 			 uptr[i].name);
  }
  //Deallocate the memory in the in each of the char ptrs
  for(int i=0; i<size; ++i){
 1f7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 1fe:	eb 38                	jmp    238 <main+0x238>
    free(uptr[i].state);
 200:	8b 45 dc             	mov    -0x24(%ebp),%eax
 203:	6b d0 5c             	imul   $0x5c,%eax,%edx
 206:	8b 45 d8             	mov    -0x28(%ebp),%eax
 209:	01 d0                	add    %edx,%eax
 20b:	83 c0 18             	add    $0x18,%eax
 20e:	83 ec 0c             	sub    $0xc,%esp
 211:	50                   	push   %eax
 212:	e8 20 06 00 00       	call   837 <free>
 217:	83 c4 10             	add    $0x10,%esp
    free(uptr[i].name);
 21a:	8b 45 dc             	mov    -0x24(%ebp),%eax
 21d:	6b d0 5c             	imul   $0x5c,%eax,%edx
 220:	8b 45 d8             	mov    -0x28(%ebp),%eax
 223:	01 d0                	add    %edx,%eax
 225:	83 c0 3c             	add    $0x3c,%eax
 228:	83 ec 0c             	sub    $0xc,%esp
 22b:	50                   	push   %eax
 22c:	e8 06 06 00 00       	call   837 <free>
 231:	83 c4 10             	add    $0x10,%esp
						 			 uptr[i].state,
						 			 uptr[i].size,
						 			 uptr[i].name);
  }
  //Deallocate the memory in the in each of the char ptrs
  for(int i=0; i<size; ++i){
 234:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 238:	8b 45 dc             	mov    -0x24(%ebp),%eax
 23b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
 23e:	7c c0                	jl     200 <main+0x200>
    free(uptr[i].state);
    free(uptr[i].name);
  }	
  //Deallocate the memory from array of uprocs
  free(uptr);
 240:	83 ec 0c             	sub    $0xc,%esp
 243:	ff 75 d8             	pushl  -0x28(%ebp)
 246:	e8 ec 05 00 00       	call   837 <free>
 24b:	83 c4 10             	add    $0x10,%esp
  exit();
 24e:	e8 9c 02 00 00       	call   4ef <exit>

00000253 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	57                   	push   %edi
 257:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 258:	8b 4d 08             	mov    0x8(%ebp),%ecx
 25b:	8b 55 10             	mov    0x10(%ebp),%edx
 25e:	8b 45 0c             	mov    0xc(%ebp),%eax
 261:	89 cb                	mov    %ecx,%ebx
 263:	89 df                	mov    %ebx,%edi
 265:	89 d1                	mov    %edx,%ecx
 267:	fc                   	cld    
 268:	f3 aa                	rep stos %al,%es:(%edi)
 26a:	89 ca                	mov    %ecx,%edx
 26c:	89 fb                	mov    %edi,%ebx
 26e:	89 5d 08             	mov    %ebx,0x8(%ebp)
 271:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 274:	90                   	nop
 275:	5b                   	pop    %ebx
 276:	5f                   	pop    %edi
 277:	5d                   	pop    %ebp
 278:	c3                   	ret    

00000279 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 285:	90                   	nop
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	8d 50 01             	lea    0x1(%eax),%edx
 28c:	89 55 08             	mov    %edx,0x8(%ebp)
 28f:	8b 55 0c             	mov    0xc(%ebp),%edx
 292:	8d 4a 01             	lea    0x1(%edx),%ecx
 295:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 298:	0f b6 12             	movzbl (%edx),%edx
 29b:	88 10                	mov    %dl,(%eax)
 29d:	0f b6 00             	movzbl (%eax),%eax
 2a0:	84 c0                	test   %al,%al
 2a2:	75 e2                	jne    286 <strcpy+0xd>
    ;
  return os;
 2a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a7:	c9                   	leave  
 2a8:	c3                   	ret    

000002a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2ac:	eb 08                	jmp    2b6 <strcmp+0xd>
    p++, q++;
 2ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 00             	movzbl (%eax),%eax
 2bc:	84 c0                	test   %al,%al
 2be:	74 10                	je     2d0 <strcmp+0x27>
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	0f b6 10             	movzbl (%eax),%edx
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	0f b6 00             	movzbl (%eax),%eax
 2cc:	38 c2                	cmp    %al,%dl
 2ce:	74 de                	je     2ae <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	0f b6 00             	movzbl (%eax),%eax
 2d6:	0f b6 d0             	movzbl %al,%edx
 2d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	0f b6 c0             	movzbl %al,%eax
 2e2:	29 c2                	sub    %eax,%edx
 2e4:	89 d0                	mov    %edx,%eax
}
 2e6:	5d                   	pop    %ebp
 2e7:	c3                   	ret    

000002e8 <strlen>:

uint
strlen(char *s)
{
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2f5:	eb 04                	jmp    2fb <strlen+0x13>
 2f7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
 301:	01 d0                	add    %edx,%eax
 303:	0f b6 00             	movzbl (%eax),%eax
 306:	84 c0                	test   %al,%al
 308:	75 ed                	jne    2f7 <strlen+0xf>
    ;
  return n;
 30a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 30d:	c9                   	leave  
 30e:	c3                   	ret    

0000030f <memset>:

void*
memset(void *dst, int c, uint n)
{
 30f:	55                   	push   %ebp
 310:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 312:	8b 45 10             	mov    0x10(%ebp),%eax
 315:	50                   	push   %eax
 316:	ff 75 0c             	pushl  0xc(%ebp)
 319:	ff 75 08             	pushl  0x8(%ebp)
 31c:	e8 32 ff ff ff       	call   253 <stosb>
 321:	83 c4 0c             	add    $0xc,%esp
  return dst;
 324:	8b 45 08             	mov    0x8(%ebp),%eax
}
 327:	c9                   	leave  
 328:	c3                   	ret    

00000329 <strchr>:

char*
strchr(const char *s, char c)
{
 329:	55                   	push   %ebp
 32a:	89 e5                	mov    %esp,%ebp
 32c:	83 ec 04             	sub    $0x4,%esp
 32f:	8b 45 0c             	mov    0xc(%ebp),%eax
 332:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 335:	eb 14                	jmp    34b <strchr+0x22>
    if(*s == c)
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	0f b6 00             	movzbl (%eax),%eax
 33d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 340:	75 05                	jne    347 <strchr+0x1e>
      return (char*)s;
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	eb 13                	jmp    35a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 347:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	84 c0                	test   %al,%al
 353:	75 e2                	jne    337 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 355:	b8 00 00 00 00       	mov    $0x0,%eax
}
 35a:	c9                   	leave  
 35b:	c3                   	ret    

0000035c <gets>:

char*
gets(char *buf, int max)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 362:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 369:	eb 42                	jmp    3ad <gets+0x51>
    cc = read(0, &c, 1);
 36b:	83 ec 04             	sub    $0x4,%esp
 36e:	6a 01                	push   $0x1
 370:	8d 45 ef             	lea    -0x11(%ebp),%eax
 373:	50                   	push   %eax
 374:	6a 00                	push   $0x0
 376:	e8 8c 01 00 00       	call   507 <read>
 37b:	83 c4 10             	add    $0x10,%esp
 37e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 381:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 385:	7e 33                	jle    3ba <gets+0x5e>
      break;
    buf[i++] = c;
 387:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38a:	8d 50 01             	lea    0x1(%eax),%edx
 38d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 390:	89 c2                	mov    %eax,%edx
 392:	8b 45 08             	mov    0x8(%ebp),%eax
 395:	01 c2                	add    %eax,%edx
 397:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 39b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 39d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3a1:	3c 0a                	cmp    $0xa,%al
 3a3:	74 16                	je     3bb <gets+0x5f>
 3a5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3a9:	3c 0d                	cmp    $0xd,%al
 3ab:	74 0e                	je     3bb <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b0:	83 c0 01             	add    $0x1,%eax
 3b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3b6:	7c b3                	jl     36b <gets+0xf>
 3b8:	eb 01                	jmp    3bb <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3ba:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3be:	8b 45 08             	mov    0x8(%ebp),%eax
 3c1:	01 d0                	add    %edx,%eax
 3c3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c9:	c9                   	leave  
 3ca:	c3                   	ret    

000003cb <stat>:

int
stat(char *n, struct stat *st)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d1:	83 ec 08             	sub    $0x8,%esp
 3d4:	6a 00                	push   $0x0
 3d6:	ff 75 08             	pushl  0x8(%ebp)
 3d9:	e8 51 01 00 00       	call   52f <open>
 3de:	83 c4 10             	add    $0x10,%esp
 3e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3e8:	79 07                	jns    3f1 <stat+0x26>
    return -1;
 3ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ef:	eb 25                	jmp    416 <stat+0x4b>
  r = fstat(fd, st);
 3f1:	83 ec 08             	sub    $0x8,%esp
 3f4:	ff 75 0c             	pushl  0xc(%ebp)
 3f7:	ff 75 f4             	pushl  -0xc(%ebp)
 3fa:	e8 48 01 00 00       	call   547 <fstat>
 3ff:	83 c4 10             	add    $0x10,%esp
 402:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 405:	83 ec 0c             	sub    $0xc,%esp
 408:	ff 75 f4             	pushl  -0xc(%ebp)
 40b:	e8 07 01 00 00       	call   517 <close>
 410:	83 c4 10             	add    $0x10,%esp
  return r;
 413:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 416:	c9                   	leave  
 417:	c3                   	ret    

00000418 <atoi>:

// new atoi added 4/22/17 to be able to handle negative numbers
int
atoi(const char *s)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	83 ec 10             	sub    $0x10,%esp
  int n, sign;
  
  n=0;
 41e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(*s==' ')s++;//Remove leading spaces
 425:	eb 04                	jmp    42b <atoi+0x13>
 427:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
 42e:	0f b6 00             	movzbl (%eax),%eax
 431:	3c 20                	cmp    $0x20,%al
 433:	74 f2                	je     427 <atoi+0xf>
  sign =(*s=='-')?-1 : 1;
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	0f b6 00             	movzbl (%eax),%eax
 43b:	3c 2d                	cmp    $0x2d,%al
 43d:	75 07                	jne    446 <atoi+0x2e>
 43f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 444:	eb 05                	jmp    44b <atoi+0x33>
 446:	b8 01 00 00 00       	mov    $0x1,%eax
 44b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(*s=='+' || *s=='-')
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	0f b6 00             	movzbl (%eax),%eax
 454:	3c 2b                	cmp    $0x2b,%al
 456:	74 0a                	je     462 <atoi+0x4a>
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	0f b6 00             	movzbl (%eax),%eax
 45e:	3c 2d                	cmp    $0x2d,%al
 460:	75 2b                	jne    48d <atoi+0x75>
    s++;
 462:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s&&*s<='9')
 466:	eb 25                	jmp    48d <atoi+0x75>
    n = n*10 + *s++ - '0';
 468:	8b 55 fc             	mov    -0x4(%ebp),%edx
 46b:	89 d0                	mov    %edx,%eax
 46d:	c1 e0 02             	shl    $0x2,%eax
 470:	01 d0                	add    %edx,%eax
 472:	01 c0                	add    %eax,%eax
 474:	89 c1                	mov    %eax,%ecx
 476:	8b 45 08             	mov    0x8(%ebp),%eax
 479:	8d 50 01             	lea    0x1(%eax),%edx
 47c:	89 55 08             	mov    %edx,0x8(%ebp)
 47f:	0f b6 00             	movzbl (%eax),%eax
 482:	0f be c0             	movsbl %al,%eax
 485:	01 c8                	add    %ecx,%eax
 487:	83 e8 30             	sub    $0x30,%eax
 48a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n=0;
  while(*s==' ')s++;//Remove leading spaces
  sign =(*s=='-')?-1 : 1;
  if(*s=='+' || *s=='-')
    s++;
  while('0' <= *s&&*s<='9')
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	0f b6 00             	movzbl (%eax),%eax
 493:	3c 2f                	cmp    $0x2f,%al
 495:	7e 0a                	jle    4a1 <atoi+0x89>
 497:	8b 45 08             	mov    0x8(%ebp),%eax
 49a:	0f b6 00             	movzbl (%eax),%eax
 49d:	3c 39                	cmp    $0x39,%al
 49f:	7e c7                	jle    468 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 4a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4a4:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4a8:	c9                   	leave  
 4a9:	c3                   	ret    

000004aa <memmove>:
  return n;
}
*/
void*
memmove(void *vdst, void *vsrc, int n)
{
 4aa:	55                   	push   %ebp
 4ab:	89 e5                	mov    %esp,%ebp
 4ad:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4bc:	eb 17                	jmp    4d5 <memmove+0x2b>
    *dst++ = *src++;
 4be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4c1:	8d 50 01             	lea    0x1(%eax),%edx
 4c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4c7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4ca:	8d 4a 01             	lea    0x1(%edx),%ecx
 4cd:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4d0:	0f b6 12             	movzbl (%edx),%edx
 4d3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4d5:	8b 45 10             	mov    0x10(%ebp),%eax
 4d8:	8d 50 ff             	lea    -0x1(%eax),%edx
 4db:	89 55 10             	mov    %edx,0x10(%ebp)
 4de:	85 c0                	test   %eax,%eax
 4e0:	7f dc                	jg     4be <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4e5:	c9                   	leave  
 4e6:	c3                   	ret    

000004e7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4e7:	b8 01 00 00 00       	mov    $0x1,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <exit>:
SYSCALL(exit)
 4ef:	b8 02 00 00 00       	mov    $0x2,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <wait>:
SYSCALL(wait)
 4f7:	b8 03 00 00 00       	mov    $0x3,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <pipe>:
SYSCALL(pipe)
 4ff:	b8 04 00 00 00       	mov    $0x4,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <read>:
SYSCALL(read)
 507:	b8 05 00 00 00       	mov    $0x5,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <write>:
SYSCALL(write)
 50f:	b8 10 00 00 00       	mov    $0x10,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <close>:
SYSCALL(close)
 517:	b8 15 00 00 00       	mov    $0x15,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <kill>:
SYSCALL(kill)
 51f:	b8 06 00 00 00       	mov    $0x6,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <exec>:
SYSCALL(exec)
 527:	b8 07 00 00 00       	mov    $0x7,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <open>:
SYSCALL(open)
 52f:	b8 0f 00 00 00       	mov    $0xf,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <mknod>:
SYSCALL(mknod)
 537:	b8 11 00 00 00       	mov    $0x11,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret    

0000053f <unlink>:
SYSCALL(unlink)
 53f:	b8 12 00 00 00       	mov    $0x12,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <fstat>:
SYSCALL(fstat)
 547:	b8 08 00 00 00       	mov    $0x8,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret    

0000054f <link>:
SYSCALL(link)
 54f:	b8 13 00 00 00       	mov    $0x13,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret    

00000557 <mkdir>:
SYSCALL(mkdir)
 557:	b8 14 00 00 00       	mov    $0x14,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <chdir>:
SYSCALL(chdir)
 55f:	b8 09 00 00 00       	mov    $0x9,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret    

00000567 <dup>:
SYSCALL(dup)
 567:	b8 0a 00 00 00       	mov    $0xa,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret    

0000056f <getpid>:
SYSCALL(getpid)
 56f:	b8 0b 00 00 00       	mov    $0xb,%eax
 574:	cd 40                	int    $0x40
 576:	c3                   	ret    

00000577 <sbrk>:
SYSCALL(sbrk)
 577:	b8 0c 00 00 00       	mov    $0xc,%eax
 57c:	cd 40                	int    $0x40
 57e:	c3                   	ret    

0000057f <sleep>:
SYSCALL(sleep)
 57f:	b8 0d 00 00 00       	mov    $0xd,%eax
 584:	cd 40                	int    $0x40
 586:	c3                   	ret    

00000587 <uptime>:
SYSCALL(uptime)
 587:	b8 0e 00 00 00       	mov    $0xe,%eax
 58c:	cd 40                	int    $0x40
 58e:	c3                   	ret    

0000058f <halt>:
SYSCALL(halt)
 58f:	b8 16 00 00 00       	mov    $0x16,%eax
 594:	cd 40                	int    $0x40
 596:	c3                   	ret    

00000597 <date>:
//Project additions
SYSCALL(date)
 597:	b8 17 00 00 00       	mov    $0x17,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <getuid>:
SYSCALL(getuid)
 59f:	b8 18 00 00 00       	mov    $0x18,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <getgid>:
SYSCALL(getgid)
 5a7:	b8 19 00 00 00       	mov    $0x19,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <getppid>:
SYSCALL(getppid)
 5af:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <setuid>:
SYSCALL(setuid)
 5b7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5bc:	cd 40                	int    $0x40
 5be:	c3                   	ret    

000005bf <setgid>:
SYSCALL(setgid)
 5bf:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5c4:	cd 40                	int    $0x40
 5c6:	c3                   	ret    

000005c7 <getprocs>:
SYSCALL(getprocs)
 5c7:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5cc:	cd 40                	int    $0x40
 5ce:	c3                   	ret    

000005cf <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5cf:	55                   	push   %ebp
 5d0:	89 e5                	mov    %esp,%ebp
 5d2:	83 ec 18             	sub    $0x18,%esp
 5d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5db:	83 ec 04             	sub    $0x4,%esp
 5de:	6a 01                	push   $0x1
 5e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5e3:	50                   	push   %eax
 5e4:	ff 75 08             	pushl  0x8(%ebp)
 5e7:	e8 23 ff ff ff       	call   50f <write>
 5ec:	83 c4 10             	add    $0x10,%esp
}
 5ef:	90                   	nop
 5f0:	c9                   	leave  
 5f1:	c3                   	ret    

000005f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f2:	55                   	push   %ebp
 5f3:	89 e5                	mov    %esp,%ebp
 5f5:	53                   	push   %ebx
 5f6:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 600:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 604:	74 17                	je     61d <printint+0x2b>
 606:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 60a:	79 11                	jns    61d <printint+0x2b>
    neg = 1;
 60c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 613:	8b 45 0c             	mov    0xc(%ebp),%eax
 616:	f7 d8                	neg    %eax
 618:	89 45 ec             	mov    %eax,-0x14(%ebp)
 61b:	eb 06                	jmp    623 <printint+0x31>
  } else {
    x = xx;
 61d:	8b 45 0c             	mov    0xc(%ebp),%eax
 620:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 623:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 62a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 62d:	8d 41 01             	lea    0x1(%ecx),%eax
 630:	89 45 f4             	mov    %eax,-0xc(%ebp)
 633:	8b 5d 10             	mov    0x10(%ebp),%ebx
 636:	8b 45 ec             	mov    -0x14(%ebp),%eax
 639:	ba 00 00 00 00       	mov    $0x0,%edx
 63e:	f7 f3                	div    %ebx
 640:	89 d0                	mov    %edx,%eax
 642:	0f b6 80 5c 0d 00 00 	movzbl 0xd5c(%eax),%eax
 649:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 64d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 650:	8b 45 ec             	mov    -0x14(%ebp),%eax
 653:	ba 00 00 00 00       	mov    $0x0,%edx
 658:	f7 f3                	div    %ebx
 65a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 65d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 661:	75 c7                	jne    62a <printint+0x38>
  if(neg)
 663:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 667:	74 2d                	je     696 <printint+0xa4>
    buf[i++] = '-';
 669:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66c:	8d 50 01             	lea    0x1(%eax),%edx
 66f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 672:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 677:	eb 1d                	jmp    696 <printint+0xa4>
    putc(fd, buf[i]);
 679:	8d 55 dc             	lea    -0x24(%ebp),%edx
 67c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67f:	01 d0                	add    %edx,%eax
 681:	0f b6 00             	movzbl (%eax),%eax
 684:	0f be c0             	movsbl %al,%eax
 687:	83 ec 08             	sub    $0x8,%esp
 68a:	50                   	push   %eax
 68b:	ff 75 08             	pushl  0x8(%ebp)
 68e:	e8 3c ff ff ff       	call   5cf <putc>
 693:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 696:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 69a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 69e:	79 d9                	jns    679 <printint+0x87>
    putc(fd, buf[i]);
}
 6a0:	90                   	nop
 6a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6a4:	c9                   	leave  
 6a5:	c3                   	ret    

000006a6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6a6:	55                   	push   %ebp
 6a7:	89 e5                	mov    %esp,%ebp
 6a9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6b3:	8d 45 0c             	lea    0xc(%ebp),%eax
 6b6:	83 c0 04             	add    $0x4,%eax
 6b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6c3:	e9 59 01 00 00       	jmp    821 <printf+0x17b>
    c = fmt[i] & 0xff;
 6c8:	8b 55 0c             	mov    0xc(%ebp),%edx
 6cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ce:	01 d0                	add    %edx,%eax
 6d0:	0f b6 00             	movzbl (%eax),%eax
 6d3:	0f be c0             	movsbl %al,%eax
 6d6:	25 ff 00 00 00       	and    $0xff,%eax
 6db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6e2:	75 2c                	jne    710 <printf+0x6a>
      if(c == '%'){
 6e4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6e8:	75 0c                	jne    6f6 <printf+0x50>
        state = '%';
 6ea:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6f1:	e9 27 01 00 00       	jmp    81d <printf+0x177>
      } else {
        putc(fd, c);
 6f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f9:	0f be c0             	movsbl %al,%eax
 6fc:	83 ec 08             	sub    $0x8,%esp
 6ff:	50                   	push   %eax
 700:	ff 75 08             	pushl  0x8(%ebp)
 703:	e8 c7 fe ff ff       	call   5cf <putc>
 708:	83 c4 10             	add    $0x10,%esp
 70b:	e9 0d 01 00 00       	jmp    81d <printf+0x177>
      }
    } else if(state == '%'){
 710:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 714:	0f 85 03 01 00 00    	jne    81d <printf+0x177>
      if(c == 'd'){
 71a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 71e:	75 1e                	jne    73e <printf+0x98>
        printint(fd, *ap, 10, 1);
 720:	8b 45 e8             	mov    -0x18(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	6a 01                	push   $0x1
 727:	6a 0a                	push   $0xa
 729:	50                   	push   %eax
 72a:	ff 75 08             	pushl  0x8(%ebp)
 72d:	e8 c0 fe ff ff       	call   5f2 <printint>
 732:	83 c4 10             	add    $0x10,%esp
        ap++;
 735:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 739:	e9 d8 00 00 00       	jmp    816 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 73e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 742:	74 06                	je     74a <printf+0xa4>
 744:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 748:	75 1e                	jne    768 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 74a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	6a 00                	push   $0x0
 751:	6a 10                	push   $0x10
 753:	50                   	push   %eax
 754:	ff 75 08             	pushl  0x8(%ebp)
 757:	e8 96 fe ff ff       	call   5f2 <printint>
 75c:	83 c4 10             	add    $0x10,%esp
        ap++;
 75f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 763:	e9 ae 00 00 00       	jmp    816 <printf+0x170>
      } else if(c == 's'){
 768:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 76c:	75 43                	jne    7b1 <printf+0x10b>
        s = (char*)*ap;
 76e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 771:	8b 00                	mov    (%eax),%eax
 773:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 776:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 77a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 77e:	75 25                	jne    7a5 <printf+0xff>
          s = "(null)";
 780:	c7 45 f4 01 0b 00 00 	movl   $0xb01,-0xc(%ebp)
        while(*s != 0){
 787:	eb 1c                	jmp    7a5 <printf+0xff>
          putc(fd, *s);
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	0f b6 00             	movzbl (%eax),%eax
 78f:	0f be c0             	movsbl %al,%eax
 792:	83 ec 08             	sub    $0x8,%esp
 795:	50                   	push   %eax
 796:	ff 75 08             	pushl  0x8(%ebp)
 799:	e8 31 fe ff ff       	call   5cf <putc>
 79e:	83 c4 10             	add    $0x10,%esp
          s++;
 7a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	0f b6 00             	movzbl (%eax),%eax
 7ab:	84 c0                	test   %al,%al
 7ad:	75 da                	jne    789 <printf+0xe3>
 7af:	eb 65                	jmp    816 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7b1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7b5:	75 1d                	jne    7d4 <printf+0x12e>
        putc(fd, *ap);
 7b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ba:	8b 00                	mov    (%eax),%eax
 7bc:	0f be c0             	movsbl %al,%eax
 7bf:	83 ec 08             	sub    $0x8,%esp
 7c2:	50                   	push   %eax
 7c3:	ff 75 08             	pushl  0x8(%ebp)
 7c6:	e8 04 fe ff ff       	call   5cf <putc>
 7cb:	83 c4 10             	add    $0x10,%esp
        ap++;
 7ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d2:	eb 42                	jmp    816 <printf+0x170>
      } else if(c == '%'){
 7d4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7d8:	75 17                	jne    7f1 <printf+0x14b>
        putc(fd, c);
 7da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7dd:	0f be c0             	movsbl %al,%eax
 7e0:	83 ec 08             	sub    $0x8,%esp
 7e3:	50                   	push   %eax
 7e4:	ff 75 08             	pushl  0x8(%ebp)
 7e7:	e8 e3 fd ff ff       	call   5cf <putc>
 7ec:	83 c4 10             	add    $0x10,%esp
 7ef:	eb 25                	jmp    816 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7f1:	83 ec 08             	sub    $0x8,%esp
 7f4:	6a 25                	push   $0x25
 7f6:	ff 75 08             	pushl  0x8(%ebp)
 7f9:	e8 d1 fd ff ff       	call   5cf <putc>
 7fe:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 804:	0f be c0             	movsbl %al,%eax
 807:	83 ec 08             	sub    $0x8,%esp
 80a:	50                   	push   %eax
 80b:	ff 75 08             	pushl  0x8(%ebp)
 80e:	e8 bc fd ff ff       	call   5cf <putc>
 813:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 816:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 81d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 821:	8b 55 0c             	mov    0xc(%ebp),%edx
 824:	8b 45 f0             	mov    -0x10(%ebp),%eax
 827:	01 d0                	add    %edx,%eax
 829:	0f b6 00             	movzbl (%eax),%eax
 82c:	84 c0                	test   %al,%al
 82e:	0f 85 94 fe ff ff    	jne    6c8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 834:	90                   	nop
 835:	c9                   	leave  
 836:	c3                   	ret    

00000837 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 837:	55                   	push   %ebp
 838:	89 e5                	mov    %esp,%ebp
 83a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83d:	8b 45 08             	mov    0x8(%ebp),%eax
 840:	83 e8 08             	sub    $0x8,%eax
 843:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 846:	a1 78 0d 00 00       	mov    0xd78,%eax
 84b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 84e:	eb 24                	jmp    874 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	8b 00                	mov    (%eax),%eax
 855:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 858:	77 12                	ja     86c <free+0x35>
 85a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 860:	77 24                	ja     886 <free+0x4f>
 862:	8b 45 fc             	mov    -0x4(%ebp),%eax
 865:	8b 00                	mov    (%eax),%eax
 867:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 86a:	77 1a                	ja     886 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	89 45 fc             	mov    %eax,-0x4(%ebp)
 874:	8b 45 f8             	mov    -0x8(%ebp),%eax
 877:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 87a:	76 d4                	jbe    850 <free+0x19>
 87c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87f:	8b 00                	mov    (%eax),%eax
 881:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 884:	76 ca                	jbe    850 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 886:	8b 45 f8             	mov    -0x8(%ebp),%eax
 889:	8b 40 04             	mov    0x4(%eax),%eax
 88c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 893:	8b 45 f8             	mov    -0x8(%ebp),%eax
 896:	01 c2                	add    %eax,%edx
 898:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89b:	8b 00                	mov    (%eax),%eax
 89d:	39 c2                	cmp    %eax,%edx
 89f:	75 24                	jne    8c5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a4:	8b 50 04             	mov    0x4(%eax),%edx
 8a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8aa:	8b 00                	mov    (%eax),%eax
 8ac:	8b 40 04             	mov    0x4(%eax),%eax
 8af:	01 c2                	add    %eax,%edx
 8b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ba:	8b 00                	mov    (%eax),%eax
 8bc:	8b 10                	mov    (%eax),%edx
 8be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c1:	89 10                	mov    %edx,(%eax)
 8c3:	eb 0a                	jmp    8cf <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c8:	8b 10                	mov    (%eax),%edx
 8ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d2:	8b 40 04             	mov    0x4(%eax),%eax
 8d5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8df:	01 d0                	add    %edx,%eax
 8e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e4:	75 20                	jne    906 <free+0xcf>
    p->s.size += bp->s.size;
 8e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e9:	8b 50 04             	mov    0x4(%eax),%edx
 8ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ef:	8b 40 04             	mov    0x4(%eax),%eax
 8f2:	01 c2                	add    %eax,%edx
 8f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fd:	8b 10                	mov    (%eax),%edx
 8ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 902:	89 10                	mov    %edx,(%eax)
 904:	eb 08                	jmp    90e <free+0xd7>
  } else
    p->s.ptr = bp;
 906:	8b 45 fc             	mov    -0x4(%ebp),%eax
 909:	8b 55 f8             	mov    -0x8(%ebp),%edx
 90c:	89 10                	mov    %edx,(%eax)
  freep = p;
 90e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 911:	a3 78 0d 00 00       	mov    %eax,0xd78
}
 916:	90                   	nop
 917:	c9                   	leave  
 918:	c3                   	ret    

00000919 <morecore>:

static Header*
morecore(uint nu)
{
 919:	55                   	push   %ebp
 91a:	89 e5                	mov    %esp,%ebp
 91c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 91f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 926:	77 07                	ja     92f <morecore+0x16>
    nu = 4096;
 928:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 92f:	8b 45 08             	mov    0x8(%ebp),%eax
 932:	c1 e0 03             	shl    $0x3,%eax
 935:	83 ec 0c             	sub    $0xc,%esp
 938:	50                   	push   %eax
 939:	e8 39 fc ff ff       	call   577 <sbrk>
 93e:	83 c4 10             	add    $0x10,%esp
 941:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 944:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 948:	75 07                	jne    951 <morecore+0x38>
    return 0;
 94a:	b8 00 00 00 00       	mov    $0x0,%eax
 94f:	eb 26                	jmp    977 <morecore+0x5e>
  hp = (Header*)p;
 951:	8b 45 f4             	mov    -0xc(%ebp),%eax
 954:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 957:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95a:	8b 55 08             	mov    0x8(%ebp),%edx
 95d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 960:	8b 45 f0             	mov    -0x10(%ebp),%eax
 963:	83 c0 08             	add    $0x8,%eax
 966:	83 ec 0c             	sub    $0xc,%esp
 969:	50                   	push   %eax
 96a:	e8 c8 fe ff ff       	call   837 <free>
 96f:	83 c4 10             	add    $0x10,%esp
  return freep;
 972:	a1 78 0d 00 00       	mov    0xd78,%eax
}
 977:	c9                   	leave  
 978:	c3                   	ret    

00000979 <malloc>:

void*
malloc(uint nbytes)
{
 979:	55                   	push   %ebp
 97a:	89 e5                	mov    %esp,%ebp
 97c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97f:	8b 45 08             	mov    0x8(%ebp),%eax
 982:	83 c0 07             	add    $0x7,%eax
 985:	c1 e8 03             	shr    $0x3,%eax
 988:	83 c0 01             	add    $0x1,%eax
 98b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 98e:	a1 78 0d 00 00       	mov    0xd78,%eax
 993:	89 45 f0             	mov    %eax,-0x10(%ebp)
 996:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 99a:	75 23                	jne    9bf <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 99c:	c7 45 f0 70 0d 00 00 	movl   $0xd70,-0x10(%ebp)
 9a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a6:	a3 78 0d 00 00       	mov    %eax,0xd78
 9ab:	a1 78 0d 00 00       	mov    0xd78,%eax
 9b0:	a3 70 0d 00 00       	mov    %eax,0xd70
    base.s.size = 0;
 9b5:	c7 05 74 0d 00 00 00 	movl   $0x0,0xd74
 9bc:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c2:	8b 00                	mov    (%eax),%eax
 9c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ca:	8b 40 04             	mov    0x4(%eax),%eax
 9cd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9d0:	72 4d                	jb     a1f <malloc+0xa6>
      if(p->s.size == nunits)
 9d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d5:	8b 40 04             	mov    0x4(%eax),%eax
 9d8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9db:	75 0c                	jne    9e9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e0:	8b 10                	mov    (%eax),%edx
 9e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e5:	89 10                	mov    %edx,(%eax)
 9e7:	eb 26                	jmp    a0f <malloc+0x96>
      else {
        p->s.size -= nunits;
 9e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ec:	8b 40 04             	mov    0x4(%eax),%eax
 9ef:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9f2:	89 c2                	mov    %eax,%edx
 9f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fd:	8b 40 04             	mov    0x4(%eax),%eax
 a00:	c1 e0 03             	shl    $0x3,%eax
 a03:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a09:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a0c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a12:	a3 78 0d 00 00       	mov    %eax,0xd78
      return (void*)(p + 1);
 a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1a:	83 c0 08             	add    $0x8,%eax
 a1d:	eb 3b                	jmp    a5a <malloc+0xe1>
    }
    if(p == freep)
 a1f:	a1 78 0d 00 00       	mov    0xd78,%eax
 a24:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a27:	75 1e                	jne    a47 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a29:	83 ec 0c             	sub    $0xc,%esp
 a2c:	ff 75 ec             	pushl  -0x14(%ebp)
 a2f:	e8 e5 fe ff ff       	call   919 <morecore>
 a34:	83 c4 10             	add    $0x10,%esp
 a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a3e:	75 07                	jne    a47 <malloc+0xce>
        return 0;
 a40:	b8 00 00 00 00       	mov    $0x0,%eax
 a45:	eb 13                	jmp    a5a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a50:	8b 00                	mov    (%eax),%eax
 a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a55:	e9 6d ff ff ff       	jmp    9c7 <malloc+0x4e>
}
 a5a:	c9                   	leave  
 a5b:	c3                   	ret    
