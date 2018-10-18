
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char* argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 1c             	sub    $0x1c,%esp
  13:	89 cb                	mov    %ecx,%ebx

  //Ensure that we have the correct amount of arguments being passed in
  if(argc <=1){
  15:	83 3b 01             	cmpl   $0x1,(%ebx)
  18:	7f 17                	jg     31 <main+0x31>
    printf(1, "Error, not enough arguments\n");
  1a:	83 ec 08             	sub    $0x8,%esp
  1d:	68 d8 08 00 00       	push   $0x8d8
  22:	6a 01                	push   $0x1
  24:	e8 f9 04 00 00       	call   522 <printf>
  29:	83 c4 10             	add    $0x10,%esp
    exit();
  2c:	e8 3a 03 00 00       	call   36b <exit>
  
  //Var variables
  uint start, end, pid;

  //Set the start time calling uptime
  start = (uint)uptime();
  31:	e8 cd 03 00 00       	call   403 <uptime>
  36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  end = 0;
  39:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  pid = fork();
  40:	e8 1e 03 00 00       	call   363 <fork>
  45:	89 45 dc             	mov    %eax,-0x24(%ebp)

  //check to see if there are other process' running
  if(pid == 0){
  48:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  4c:	75 20                	jne    6e <main+0x6e>
   	if(exec(argv[1], argv+1) == 0); 
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	8d 50 04             	lea    0x4(%eax),%edx
  54:	8b 43 04             	mov    0x4(%ebx),%eax
  57:	83 c0 04             	add    $0x4,%eax
  5a:	8b 00                	mov    (%eax),%eax
  5c:	83 ec 08             	sub    $0x8,%esp
  5f:	52                   	push   %edx
  60:	50                   	push   %eax
  61:	e8 3d 03 00 00       	call   3a3 <exec>
  66:	83 c4 10             	add    $0x10,%esp
	exit();
  69:	e8 fd 02 00 00       	call   36b <exit>
  }
  else
    wait();
  6e:	e8 00 03 00 00       	call   373 <wait>
  //call uptime again to grab the running time.
  end = (uint)uptime();
  73:	e8 8b 03 00 00       	call   403 <uptime>
  78:	89 45 e0             	mov    %eax,-0x20(%ebp)

  printf(1,"%s %s %d.%d\n", argv[1], " ran in  ",  (end-start)/100, (end-start)%100); 
  7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  7e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  81:	89 c6                	mov    %eax,%esi
  83:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  88:	89 f0                	mov    %esi,%eax
  8a:	f7 e2                	mul    %edx
  8c:	89 d1                	mov    %edx,%ecx
  8e:	c1 e9 05             	shr    $0x5,%ecx
  91:	6b c1 64             	imul   $0x64,%ecx,%eax
  94:	29 c6                	sub    %eax,%esi
  96:	89 f1                	mov    %esi,%ecx
  98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  9b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  9e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  a3:	f7 e2                	mul    %edx
  a5:	c1 ea 05             	shr    $0x5,%edx
  a8:	8b 43 04             	mov    0x4(%ebx),%eax
  ab:	83 c0 04             	add    $0x4,%eax
  ae:	8b 00                	mov    (%eax),%eax
  b0:	83 ec 08             	sub    $0x8,%esp
  b3:	51                   	push   %ecx
  b4:	52                   	push   %edx
  b5:	68 f5 08 00 00       	push   $0x8f5
  ba:	50                   	push   %eax
  bb:	68 ff 08 00 00       	push   $0x8ff
  c0:	6a 01                	push   $0x1
  c2:	e8 5b 04 00 00       	call   522 <printf>
  c7:	83 c4 20             	add    $0x20,%esp
  exit();
  ca:	e8 9c 02 00 00       	call   36b <exit>

000000cf <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  d2:	57                   	push   %edi
  d3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  d7:	8b 55 10             	mov    0x10(%ebp),%edx
  da:	8b 45 0c             	mov    0xc(%ebp),%eax
  dd:	89 cb                	mov    %ecx,%ebx
  df:	89 df                	mov    %ebx,%edi
  e1:	89 d1                	mov    %edx,%ecx
  e3:	fc                   	cld    
  e4:	f3 aa                	rep stos %al,%es:(%edi)
  e6:	89 ca                	mov    %ecx,%edx
  e8:	89 fb                	mov    %edi,%ebx
  ea:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ed:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  f0:	90                   	nop
  f1:	5b                   	pop    %ebx
  f2:	5f                   	pop    %edi
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    

000000f5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  f5:	55                   	push   %ebp
  f6:	89 e5                	mov    %esp,%ebp
  f8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 101:	90                   	nop
 102:	8b 45 08             	mov    0x8(%ebp),%eax
 105:	8d 50 01             	lea    0x1(%eax),%edx
 108:	89 55 08             	mov    %edx,0x8(%ebp)
 10b:	8b 55 0c             	mov    0xc(%ebp),%edx
 10e:	8d 4a 01             	lea    0x1(%edx),%ecx
 111:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 114:	0f b6 12             	movzbl (%edx),%edx
 117:	88 10                	mov    %dl,(%eax)
 119:	0f b6 00             	movzbl (%eax),%eax
 11c:	84 c0                	test   %al,%al
 11e:	75 e2                	jne    102 <strcpy+0xd>
    ;
  return os;
 120:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 123:	c9                   	leave  
 124:	c3                   	ret    

00000125 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 128:	eb 08                	jmp    132 <strcmp+0xd>
    p++, q++;
 12a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 132:	8b 45 08             	mov    0x8(%ebp),%eax
 135:	0f b6 00             	movzbl (%eax),%eax
 138:	84 c0                	test   %al,%al
 13a:	74 10                	je     14c <strcmp+0x27>
 13c:	8b 45 08             	mov    0x8(%ebp),%eax
 13f:	0f b6 10             	movzbl (%eax),%edx
 142:	8b 45 0c             	mov    0xc(%ebp),%eax
 145:	0f b6 00             	movzbl (%eax),%eax
 148:	38 c2                	cmp    %al,%dl
 14a:	74 de                	je     12a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	0f b6 00             	movzbl (%eax),%eax
 152:	0f b6 d0             	movzbl %al,%edx
 155:	8b 45 0c             	mov    0xc(%ebp),%eax
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	0f b6 c0             	movzbl %al,%eax
 15e:	29 c2                	sub    %eax,%edx
 160:	89 d0                	mov    %edx,%eax
}
 162:	5d                   	pop    %ebp
 163:	c3                   	ret    

00000164 <strlen>:

uint
strlen(char *s)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 16a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 171:	eb 04                	jmp    177 <strlen+0x13>
 173:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 177:	8b 55 fc             	mov    -0x4(%ebp),%edx
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	01 d0                	add    %edx,%eax
 17f:	0f b6 00             	movzbl (%eax),%eax
 182:	84 c0                	test   %al,%al
 184:	75 ed                	jne    173 <strlen+0xf>
    ;
  return n;
 186:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 189:	c9                   	leave  
 18a:	c3                   	ret    

0000018b <memset>:

void*
memset(void *dst, int c, uint n)
{
 18b:	55                   	push   %ebp
 18c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 18e:	8b 45 10             	mov    0x10(%ebp),%eax
 191:	50                   	push   %eax
 192:	ff 75 0c             	pushl  0xc(%ebp)
 195:	ff 75 08             	pushl  0x8(%ebp)
 198:	e8 32 ff ff ff       	call   cf <stosb>
 19d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a3:	c9                   	leave  
 1a4:	c3                   	ret    

000001a5 <strchr>:

char*
strchr(const char *s, char c)
{
 1a5:	55                   	push   %ebp
 1a6:	89 e5                	mov    %esp,%ebp
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ae:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b1:	eb 14                	jmp    1c7 <strchr+0x22>
    if(*s == c)
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	0f b6 00             	movzbl (%eax),%eax
 1b9:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1bc:	75 05                	jne    1c3 <strchr+0x1e>
      return (char*)s;
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	eb 13                	jmp    1d6 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	0f b6 00             	movzbl (%eax),%eax
 1cd:	84 c0                	test   %al,%al
 1cf:	75 e2                	jne    1b3 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1d6:	c9                   	leave  
 1d7:	c3                   	ret    

000001d8 <gets>:

char*
gets(char *buf, int max)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e5:	eb 42                	jmp    229 <gets+0x51>
    cc = read(0, &c, 1);
 1e7:	83 ec 04             	sub    $0x4,%esp
 1ea:	6a 01                	push   $0x1
 1ec:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ef:	50                   	push   %eax
 1f0:	6a 00                	push   $0x0
 1f2:	e8 8c 01 00 00       	call   383 <read>
 1f7:	83 c4 10             	add    $0x10,%esp
 1fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 201:	7e 33                	jle    236 <gets+0x5e>
      break;
    buf[i++] = c;
 203:	8b 45 f4             	mov    -0xc(%ebp),%eax
 206:	8d 50 01             	lea    0x1(%eax),%edx
 209:	89 55 f4             	mov    %edx,-0xc(%ebp)
 20c:	89 c2                	mov    %eax,%edx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	01 c2                	add    %eax,%edx
 213:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 217:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 219:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21d:	3c 0a                	cmp    $0xa,%al
 21f:	74 16                	je     237 <gets+0x5f>
 221:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 225:	3c 0d                	cmp    $0xd,%al
 227:	74 0e                	je     237 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 229:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22c:	83 c0 01             	add    $0x1,%eax
 22f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 232:	7c b3                	jl     1e7 <gets+0xf>
 234:	eb 01                	jmp    237 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 236:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 237:	8b 55 f4             	mov    -0xc(%ebp),%edx
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	01 d0                	add    %edx,%eax
 23f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 242:	8b 45 08             	mov    0x8(%ebp),%eax
}
 245:	c9                   	leave  
 246:	c3                   	ret    

00000247 <stat>:

int
stat(char *n, struct stat *st)
{
 247:	55                   	push   %ebp
 248:	89 e5                	mov    %esp,%ebp
 24a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24d:	83 ec 08             	sub    $0x8,%esp
 250:	6a 00                	push   $0x0
 252:	ff 75 08             	pushl  0x8(%ebp)
 255:	e8 51 01 00 00       	call   3ab <open>
 25a:	83 c4 10             	add    $0x10,%esp
 25d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 264:	79 07                	jns    26d <stat+0x26>
    return -1;
 266:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 26b:	eb 25                	jmp    292 <stat+0x4b>
  r = fstat(fd, st);
 26d:	83 ec 08             	sub    $0x8,%esp
 270:	ff 75 0c             	pushl  0xc(%ebp)
 273:	ff 75 f4             	pushl  -0xc(%ebp)
 276:	e8 48 01 00 00       	call   3c3 <fstat>
 27b:	83 c4 10             	add    $0x10,%esp
 27e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 281:	83 ec 0c             	sub    $0xc,%esp
 284:	ff 75 f4             	pushl  -0xc(%ebp)
 287:	e8 07 01 00 00       	call   393 <close>
 28c:	83 c4 10             	add    $0x10,%esp
  return r;
 28f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 292:	c9                   	leave  
 293:	c3                   	ret    

00000294 <atoi>:

// new atoi added 4/22/17 to be able to handle negative numbers
int
atoi(const char *s)
{
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	83 ec 10             	sub    $0x10,%esp
  int n, sign;
  
  n=0;
 29a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(*s==' ')s++;//Remove leading spaces
 2a1:	eb 04                	jmp    2a7 <atoi+0x13>
 2a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	3c 20                	cmp    $0x20,%al
 2af:	74 f2                	je     2a3 <atoi+0xf>
  sign =(*s=='-')?-1 : 1;
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	3c 2d                	cmp    $0x2d,%al
 2b9:	75 07                	jne    2c2 <atoi+0x2e>
 2bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c0:	eb 05                	jmp    2c7 <atoi+0x33>
 2c2:	b8 01 00 00 00       	mov    $0x1,%eax
 2c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(*s=='+' || *s=='-')
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
 2cd:	0f b6 00             	movzbl (%eax),%eax
 2d0:	3c 2b                	cmp    $0x2b,%al
 2d2:	74 0a                	je     2de <atoi+0x4a>
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	0f b6 00             	movzbl (%eax),%eax
 2da:	3c 2d                	cmp    $0x2d,%al
 2dc:	75 2b                	jne    309 <atoi+0x75>
    s++;
 2de:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s&&*s<='9')
 2e2:	eb 25                	jmp    309 <atoi+0x75>
    n = n*10 + *s++ - '0';
 2e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e7:	89 d0                	mov    %edx,%eax
 2e9:	c1 e0 02             	shl    $0x2,%eax
 2ec:	01 d0                	add    %edx,%eax
 2ee:	01 c0                	add    %eax,%eax
 2f0:	89 c1                	mov    %eax,%ecx
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	8d 50 01             	lea    0x1(%eax),%edx
 2f8:	89 55 08             	mov    %edx,0x8(%ebp)
 2fb:	0f b6 00             	movzbl (%eax),%eax
 2fe:	0f be c0             	movsbl %al,%eax
 301:	01 c8                	add    %ecx,%eax
 303:	83 e8 30             	sub    $0x30,%eax
 306:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n=0;
  while(*s==' ')s++;//Remove leading spaces
  sign =(*s=='-')?-1 : 1;
  if(*s=='+' || *s=='-')
    s++;
  while('0' <= *s&&*s<='9')
 309:	8b 45 08             	mov    0x8(%ebp),%eax
 30c:	0f b6 00             	movzbl (%eax),%eax
 30f:	3c 2f                	cmp    $0x2f,%al
 311:	7e 0a                	jle    31d <atoi+0x89>
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	0f b6 00             	movzbl (%eax),%eax
 319:	3c 39                	cmp    $0x39,%al
 31b:	7e c7                	jle    2e4 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 31d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 320:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 324:	c9                   	leave  
 325:	c3                   	ret    

00000326 <memmove>:
  return n;
}
*/
void*
memmove(void *vdst, void *vsrc, int n)
{
 326:	55                   	push   %ebp
 327:	89 e5                	mov    %esp,%ebp
 329:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 332:	8b 45 0c             	mov    0xc(%ebp),%eax
 335:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 338:	eb 17                	jmp    351 <memmove+0x2b>
    *dst++ = *src++;
 33a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33d:	8d 50 01             	lea    0x1(%eax),%edx
 340:	89 55 fc             	mov    %edx,-0x4(%ebp)
 343:	8b 55 f8             	mov    -0x8(%ebp),%edx
 346:	8d 4a 01             	lea    0x1(%edx),%ecx
 349:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 34c:	0f b6 12             	movzbl (%edx),%edx
 34f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 351:	8b 45 10             	mov    0x10(%ebp),%eax
 354:	8d 50 ff             	lea    -0x1(%eax),%edx
 357:	89 55 10             	mov    %edx,0x10(%ebp)
 35a:	85 c0                	test   %eax,%eax
 35c:	7f dc                	jg     33a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 361:	c9                   	leave  
 362:	c3                   	ret    

00000363 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 363:	b8 01 00 00 00       	mov    $0x1,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <exit>:
SYSCALL(exit)
 36b:	b8 02 00 00 00       	mov    $0x2,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <wait>:
SYSCALL(wait)
 373:	b8 03 00 00 00       	mov    $0x3,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <pipe>:
SYSCALL(pipe)
 37b:	b8 04 00 00 00       	mov    $0x4,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <read>:
SYSCALL(read)
 383:	b8 05 00 00 00       	mov    $0x5,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <write>:
SYSCALL(write)
 38b:	b8 10 00 00 00       	mov    $0x10,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <close>:
SYSCALL(close)
 393:	b8 15 00 00 00       	mov    $0x15,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <kill>:
SYSCALL(kill)
 39b:	b8 06 00 00 00       	mov    $0x6,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <exec>:
SYSCALL(exec)
 3a3:	b8 07 00 00 00       	mov    $0x7,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <open>:
SYSCALL(open)
 3ab:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <mknod>:
SYSCALL(mknod)
 3b3:	b8 11 00 00 00       	mov    $0x11,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <unlink>:
SYSCALL(unlink)
 3bb:	b8 12 00 00 00       	mov    $0x12,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <fstat>:
SYSCALL(fstat)
 3c3:	b8 08 00 00 00       	mov    $0x8,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <link>:
SYSCALL(link)
 3cb:	b8 13 00 00 00       	mov    $0x13,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <mkdir>:
SYSCALL(mkdir)
 3d3:	b8 14 00 00 00       	mov    $0x14,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <chdir>:
SYSCALL(chdir)
 3db:	b8 09 00 00 00       	mov    $0x9,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <dup>:
SYSCALL(dup)
 3e3:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <getpid>:
SYSCALL(getpid)
 3eb:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <sbrk>:
SYSCALL(sbrk)
 3f3:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <sleep>:
SYSCALL(sleep)
 3fb:	b8 0d 00 00 00       	mov    $0xd,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <uptime>:
SYSCALL(uptime)
 403:	b8 0e 00 00 00       	mov    $0xe,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <halt>:
SYSCALL(halt)
 40b:	b8 16 00 00 00       	mov    $0x16,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <date>:
//Project additions
SYSCALL(date)
 413:	b8 17 00 00 00       	mov    $0x17,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <getuid>:
SYSCALL(getuid)
 41b:	b8 18 00 00 00       	mov    $0x18,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <getgid>:
SYSCALL(getgid)
 423:	b8 19 00 00 00       	mov    $0x19,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <getppid>:
SYSCALL(getppid)
 42b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <setuid>:
SYSCALL(setuid)
 433:	b8 1b 00 00 00       	mov    $0x1b,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <setgid>:
SYSCALL(setgid)
 43b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <getprocs>:
SYSCALL(getprocs)
 443:	b8 1d 00 00 00       	mov    $0x1d,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 44b:	55                   	push   %ebp
 44c:	89 e5                	mov    %esp,%ebp
 44e:	83 ec 18             	sub    $0x18,%esp
 451:	8b 45 0c             	mov    0xc(%ebp),%eax
 454:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 457:	83 ec 04             	sub    $0x4,%esp
 45a:	6a 01                	push   $0x1
 45c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 45f:	50                   	push   %eax
 460:	ff 75 08             	pushl  0x8(%ebp)
 463:	e8 23 ff ff ff       	call   38b <write>
 468:	83 c4 10             	add    $0x10,%esp
}
 46b:	90                   	nop
 46c:	c9                   	leave  
 46d:	c3                   	ret    

0000046e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46e:	55                   	push   %ebp
 46f:	89 e5                	mov    %esp,%ebp
 471:	53                   	push   %ebx
 472:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 475:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 47c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 480:	74 17                	je     499 <printint+0x2b>
 482:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 486:	79 11                	jns    499 <printint+0x2b>
    neg = 1;
 488:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 48f:	8b 45 0c             	mov    0xc(%ebp),%eax
 492:	f7 d8                	neg    %eax
 494:	89 45 ec             	mov    %eax,-0x14(%ebp)
 497:	eb 06                	jmp    49f <printint+0x31>
  } else {
    x = xx;
 499:	8b 45 0c             	mov    0xc(%ebp),%eax
 49c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 49f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4a9:	8d 41 01             	lea    0x1(%ecx),%eax
 4ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4af:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b5:	ba 00 00 00 00       	mov    $0x0,%edx
 4ba:	f7 f3                	div    %ebx
 4bc:	89 d0                	mov    %edx,%eax
 4be:	0f b6 80 64 0b 00 00 	movzbl 0xb64(%eax),%eax
 4c5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4cf:	ba 00 00 00 00       	mov    $0x0,%edx
 4d4:	f7 f3                	div    %ebx
 4d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4dd:	75 c7                	jne    4a6 <printint+0x38>
  if(neg)
 4df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e3:	74 2d                	je     512 <printint+0xa4>
    buf[i++] = '-';
 4e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e8:	8d 50 01             	lea    0x1(%eax),%edx
 4eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ee:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4f3:	eb 1d                	jmp    512 <printint+0xa4>
    putc(fd, buf[i]);
 4f5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fb:	01 d0                	add    %edx,%eax
 4fd:	0f b6 00             	movzbl (%eax),%eax
 500:	0f be c0             	movsbl %al,%eax
 503:	83 ec 08             	sub    $0x8,%esp
 506:	50                   	push   %eax
 507:	ff 75 08             	pushl  0x8(%ebp)
 50a:	e8 3c ff ff ff       	call   44b <putc>
 50f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 512:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51a:	79 d9                	jns    4f5 <printint+0x87>
    putc(fd, buf[i]);
}
 51c:	90                   	nop
 51d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 520:	c9                   	leave  
 521:	c3                   	ret    

00000522 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 522:	55                   	push   %ebp
 523:	89 e5                	mov    %esp,%ebp
 525:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 528:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 52f:	8d 45 0c             	lea    0xc(%ebp),%eax
 532:	83 c0 04             	add    $0x4,%eax
 535:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 538:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 53f:	e9 59 01 00 00       	jmp    69d <printf+0x17b>
    c = fmt[i] & 0xff;
 544:	8b 55 0c             	mov    0xc(%ebp),%edx
 547:	8b 45 f0             	mov    -0x10(%ebp),%eax
 54a:	01 d0                	add    %edx,%eax
 54c:	0f b6 00             	movzbl (%eax),%eax
 54f:	0f be c0             	movsbl %al,%eax
 552:	25 ff 00 00 00       	and    $0xff,%eax
 557:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 55a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55e:	75 2c                	jne    58c <printf+0x6a>
      if(c == '%'){
 560:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 564:	75 0c                	jne    572 <printf+0x50>
        state = '%';
 566:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56d:	e9 27 01 00 00       	jmp    699 <printf+0x177>
      } else {
        putc(fd, c);
 572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 575:	0f be c0             	movsbl %al,%eax
 578:	83 ec 08             	sub    $0x8,%esp
 57b:	50                   	push   %eax
 57c:	ff 75 08             	pushl  0x8(%ebp)
 57f:	e8 c7 fe ff ff       	call   44b <putc>
 584:	83 c4 10             	add    $0x10,%esp
 587:	e9 0d 01 00 00       	jmp    699 <printf+0x177>
      }
    } else if(state == '%'){
 58c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 590:	0f 85 03 01 00 00    	jne    699 <printf+0x177>
      if(c == 'd'){
 596:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 59a:	75 1e                	jne    5ba <printf+0x98>
        printint(fd, *ap, 10, 1);
 59c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59f:	8b 00                	mov    (%eax),%eax
 5a1:	6a 01                	push   $0x1
 5a3:	6a 0a                	push   $0xa
 5a5:	50                   	push   %eax
 5a6:	ff 75 08             	pushl  0x8(%ebp)
 5a9:	e8 c0 fe ff ff       	call   46e <printint>
 5ae:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b5:	e9 d8 00 00 00       	jmp    692 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5ba:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5be:	74 06                	je     5c6 <printf+0xa4>
 5c0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c4:	75 1e                	jne    5e4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c9:	8b 00                	mov    (%eax),%eax
 5cb:	6a 00                	push   $0x0
 5cd:	6a 10                	push   $0x10
 5cf:	50                   	push   %eax
 5d0:	ff 75 08             	pushl  0x8(%ebp)
 5d3:	e8 96 fe ff ff       	call   46e <printint>
 5d8:	83 c4 10             	add    $0x10,%esp
        ap++;
 5db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5df:	e9 ae 00 00 00       	jmp    692 <printf+0x170>
      } else if(c == 's'){
 5e4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e8:	75 43                	jne    62d <printf+0x10b>
        s = (char*)*ap;
 5ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ed:	8b 00                	mov    (%eax),%eax
 5ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5fa:	75 25                	jne    621 <printf+0xff>
          s = "(null)";
 5fc:	c7 45 f4 0c 09 00 00 	movl   $0x90c,-0xc(%ebp)
        while(*s != 0){
 603:	eb 1c                	jmp    621 <printf+0xff>
          putc(fd, *s);
 605:	8b 45 f4             	mov    -0xc(%ebp),%eax
 608:	0f b6 00             	movzbl (%eax),%eax
 60b:	0f be c0             	movsbl %al,%eax
 60e:	83 ec 08             	sub    $0x8,%esp
 611:	50                   	push   %eax
 612:	ff 75 08             	pushl  0x8(%ebp)
 615:	e8 31 fe ff ff       	call   44b <putc>
 61a:	83 c4 10             	add    $0x10,%esp
          s++;
 61d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 621:	8b 45 f4             	mov    -0xc(%ebp),%eax
 624:	0f b6 00             	movzbl (%eax),%eax
 627:	84 c0                	test   %al,%al
 629:	75 da                	jne    605 <printf+0xe3>
 62b:	eb 65                	jmp    692 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 631:	75 1d                	jne    650 <printf+0x12e>
        putc(fd, *ap);
 633:	8b 45 e8             	mov    -0x18(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	0f be c0             	movsbl %al,%eax
 63b:	83 ec 08             	sub    $0x8,%esp
 63e:	50                   	push   %eax
 63f:	ff 75 08             	pushl  0x8(%ebp)
 642:	e8 04 fe ff ff       	call   44b <putc>
 647:	83 c4 10             	add    $0x10,%esp
        ap++;
 64a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64e:	eb 42                	jmp    692 <printf+0x170>
      } else if(c == '%'){
 650:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 654:	75 17                	jne    66d <printf+0x14b>
        putc(fd, c);
 656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 659:	0f be c0             	movsbl %al,%eax
 65c:	83 ec 08             	sub    $0x8,%esp
 65f:	50                   	push   %eax
 660:	ff 75 08             	pushl  0x8(%ebp)
 663:	e8 e3 fd ff ff       	call   44b <putc>
 668:	83 c4 10             	add    $0x10,%esp
 66b:	eb 25                	jmp    692 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66d:	83 ec 08             	sub    $0x8,%esp
 670:	6a 25                	push   $0x25
 672:	ff 75 08             	pushl  0x8(%ebp)
 675:	e8 d1 fd ff ff       	call   44b <putc>
 67a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 67d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 680:	0f be c0             	movsbl %al,%eax
 683:	83 ec 08             	sub    $0x8,%esp
 686:	50                   	push   %eax
 687:	ff 75 08             	pushl  0x8(%ebp)
 68a:	e8 bc fd ff ff       	call   44b <putc>
 68f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 692:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 699:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 69d:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a3:	01 d0                	add    %edx,%eax
 6a5:	0f b6 00             	movzbl (%eax),%eax
 6a8:	84 c0                	test   %al,%al
 6aa:	0f 85 94 fe ff ff    	jne    544 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b0:	90                   	nop
 6b1:	c9                   	leave  
 6b2:	c3                   	ret    

000006b3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b3:	55                   	push   %ebp
 6b4:	89 e5                	mov    %esp,%ebp
 6b6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
 6bc:	83 e8 08             	sub    $0x8,%eax
 6bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c2:	a1 80 0b 00 00       	mov    0xb80,%eax
 6c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ca:	eb 24                	jmp    6f0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 00                	mov    (%eax),%eax
 6d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d4:	77 12                	ja     6e8 <free+0x35>
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6dc:	77 24                	ja     702 <free+0x4f>
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 00                	mov    (%eax),%eax
 6e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e6:	77 1a                	ja     702 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 00                	mov    (%eax),%eax
 6ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f6:	76 d4                	jbe    6cc <free+0x19>
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	8b 00                	mov    (%eax),%eax
 6fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 700:	76 ca                	jbe    6cc <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	8b 40 04             	mov    0x4(%eax),%eax
 708:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	01 c2                	add    %eax,%edx
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	8b 00                	mov    (%eax),%eax
 719:	39 c2                	cmp    %eax,%edx
 71b:	75 24                	jne    741 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 71d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 720:	8b 50 04             	mov    0x4(%eax),%edx
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 00                	mov    (%eax),%eax
 728:	8b 40 04             	mov    0x4(%eax),%eax
 72b:	01 c2                	add    %eax,%edx
 72d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 730:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8b 00                	mov    (%eax),%eax
 738:	8b 10                	mov    (%eax),%edx
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	89 10                	mov    %edx,(%eax)
 73f:	eb 0a                	jmp    74b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	8b 10                	mov    (%eax),%edx
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 40 04             	mov    0x4(%eax),%eax
 751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	01 d0                	add    %edx,%eax
 75d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 760:	75 20                	jne    782 <free+0xcf>
    p->s.size += bp->s.size;
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 50 04             	mov    0x4(%eax),%edx
 768:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76b:	8b 40 04             	mov    0x4(%eax),%eax
 76e:	01 c2                	add    %eax,%edx
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 776:	8b 45 f8             	mov    -0x8(%ebp),%eax
 779:	8b 10                	mov    (%eax),%edx
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	89 10                	mov    %edx,(%eax)
 780:	eb 08                	jmp    78a <free+0xd7>
  } else
    p->s.ptr = bp;
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	8b 55 f8             	mov    -0x8(%ebp),%edx
 788:	89 10                	mov    %edx,(%eax)
  freep = p;
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	a3 80 0b 00 00       	mov    %eax,0xb80
}
 792:	90                   	nop
 793:	c9                   	leave  
 794:	c3                   	ret    

00000795 <morecore>:

static Header*
morecore(uint nu)
{
 795:	55                   	push   %ebp
 796:	89 e5                	mov    %esp,%ebp
 798:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 79b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7a2:	77 07                	ja     7ab <morecore+0x16>
    nu = 4096;
 7a4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ab:	8b 45 08             	mov    0x8(%ebp),%eax
 7ae:	c1 e0 03             	shl    $0x3,%eax
 7b1:	83 ec 0c             	sub    $0xc,%esp
 7b4:	50                   	push   %eax
 7b5:	e8 39 fc ff ff       	call   3f3 <sbrk>
 7ba:	83 c4 10             	add    $0x10,%esp
 7bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7c0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c4:	75 07                	jne    7cd <morecore+0x38>
    return 0;
 7c6:	b8 00 00 00 00       	mov    $0x0,%eax
 7cb:	eb 26                	jmp    7f3 <morecore+0x5e>
  hp = (Header*)p;
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d6:	8b 55 08             	mov    0x8(%ebp),%edx
 7d9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7df:	83 c0 08             	add    $0x8,%eax
 7e2:	83 ec 0c             	sub    $0xc,%esp
 7e5:	50                   	push   %eax
 7e6:	e8 c8 fe ff ff       	call   6b3 <free>
 7eb:	83 c4 10             	add    $0x10,%esp
  return freep;
 7ee:	a1 80 0b 00 00       	mov    0xb80,%eax
}
 7f3:	c9                   	leave  
 7f4:	c3                   	ret    

000007f5 <malloc>:

void*
malloc(uint nbytes)
{
 7f5:	55                   	push   %ebp
 7f6:	89 e5                	mov    %esp,%ebp
 7f8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fb:	8b 45 08             	mov    0x8(%ebp),%eax
 7fe:	83 c0 07             	add    $0x7,%eax
 801:	c1 e8 03             	shr    $0x3,%eax
 804:	83 c0 01             	add    $0x1,%eax
 807:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 80a:	a1 80 0b 00 00       	mov    0xb80,%eax
 80f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 812:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 816:	75 23                	jne    83b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 818:	c7 45 f0 78 0b 00 00 	movl   $0xb78,-0x10(%ebp)
 81f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 822:	a3 80 0b 00 00       	mov    %eax,0xb80
 827:	a1 80 0b 00 00       	mov    0xb80,%eax
 82c:	a3 78 0b 00 00       	mov    %eax,0xb78
    base.s.size = 0;
 831:	c7 05 7c 0b 00 00 00 	movl   $0x0,0xb7c
 838:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83e:	8b 00                	mov    (%eax),%eax
 840:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	8b 40 04             	mov    0x4(%eax),%eax
 849:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 84c:	72 4d                	jb     89b <malloc+0xa6>
      if(p->s.size == nunits)
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	8b 40 04             	mov    0x4(%eax),%eax
 854:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 857:	75 0c                	jne    865 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 859:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85c:	8b 10                	mov    (%eax),%edx
 85e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 861:	89 10                	mov    %edx,(%eax)
 863:	eb 26                	jmp    88b <malloc+0x96>
      else {
        p->s.size -= nunits;
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	8b 40 04             	mov    0x4(%eax),%eax
 86b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 86e:	89 c2                	mov    %eax,%edx
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	8b 40 04             	mov    0x4(%eax),%eax
 87c:	c1 e0 03             	shl    $0x3,%eax
 87f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	8b 55 ec             	mov    -0x14(%ebp),%edx
 888:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 88b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88e:	a3 80 0b 00 00       	mov    %eax,0xb80
      return (void*)(p + 1);
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	83 c0 08             	add    $0x8,%eax
 899:	eb 3b                	jmp    8d6 <malloc+0xe1>
    }
    if(p == freep)
 89b:	a1 80 0b 00 00       	mov    0xb80,%eax
 8a0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a3:	75 1e                	jne    8c3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8a5:	83 ec 0c             	sub    $0xc,%esp
 8a8:	ff 75 ec             	pushl  -0x14(%ebp)
 8ab:	e8 e5 fe ff ff       	call   795 <morecore>
 8b0:	83 c4 10             	add    $0x10,%esp
 8b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ba:	75 07                	jne    8c3 <malloc+0xce>
        return 0;
 8bc:	b8 00 00 00 00       	mov    $0x0,%eax
 8c1:	eb 13                	jmp    8d6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cc:	8b 00                	mov    (%eax),%eax
 8ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8d1:	e9 6d ff ff ff       	jmp    843 <malloc+0x4e>
}
 8d6:	c9                   	leave  
 8d7:	c3                   	ret    
