
_testcase:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char **argv)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 20             	sub    $0x20,%esp
	int in, out;
	int *a, *b;

	printf(1, "\n===============swap test start===============\n");
  18:	68 38 09 00 00       	push   $0x938
  1d:	6a 01                	push   $0x1
  1f:	e8 ac 05 00 00       	call   5d0 <printf>

	// make some swappable page
	// allocuvm(growproc & write some data in vaddr)

	// consume physical memory for occur swap out
	printf(1, "\n=====================================mallocation_A=====================================\n");
  24:	59                   	pop    %ecx
  25:	5b                   	pop    %ebx
  26:	68 68 09 00 00       	push   $0x968
  2b:	6a 01                	push   $0x1
	a = (int *)malloc(sizeof(int) * 1024 * 700);
	printf(1, "\n=================================mallocation_A_Finished=====================================\n");

	printf(1, "\n======================================Page Write A=====================================\n");
	for (int i = 0; i < 600; i++)
  2d:	31 db                	xor    %ebx,%ebx
	printf(1, "\n=====================================mallocation_A=====================================\n");
  2f:	e8 9c 05 00 00       	call   5d0 <printf>
	a = (int *)malloc(sizeof(int) * 1024 * 700);
  34:	c7 04 24 00 c0 2b 00 	movl   $0x2bc000,(%esp)
  3b:	e8 f0 07 00 00       	call   830 <malloc>
	printf(1, "\n=================================mallocation_A_Finished=====================================\n");
  40:	5e                   	pop    %esi
	a = (int *)malloc(sizeof(int) * 1024 * 700);
  41:	89 c7                	mov    %eax,%edi
	printf(1, "\n=================================mallocation_A_Finished=====================================\n");
  43:	58                   	pop    %eax
  44:	68 c4 09 00 00       	push   $0x9c4
  49:	6a 01                	push   $0x1
  4b:	e8 80 05 00 00       	call   5d0 <printf>
	printf(1, "\n======================================Page Write A=====================================\n");
  50:	58                   	pop    %eax
  51:	5a                   	pop    %edx
  52:	68 24 0a 00 00       	push   $0xa24
  57:	6a 01                	push   $0x1
  59:	e8 72 05 00 00       	call   5d0 <printf>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	{
		printf(1, "Write Array A call :  %d\n", i);
  68:	83 ec 04             	sub    $0x4,%esp
  6b:	53                   	push   %ebx
  6c:	68 b3 0c 00 00       	push   $0xcb3
  71:	6a 01                	push   $0x1
  73:	e8 58 05 00 00       	call   5d0 <printf>
		a[i * 1024] = i * 1024;
  78:	89 d8                	mov    %ebx,%eax
  7a:	89 da                	mov    %ebx,%edx
	for (int i = 0; i < 600; i++)
  7c:	83 c3 01             	add    $0x1,%ebx
		a[i * 1024] = i * 1024;
  7f:	c1 e0 0c             	shl    $0xc,%eax
  82:	c1 e2 0a             	shl    $0xa,%edx
	for (int i = 0; i < 600; i++)
  85:	83 c4 10             	add    $0x10,%esp
		a[i * 1024] = i * 1024;
  88:	89 14 07             	mov    %edx,(%edi,%eax,1)
	for (int i = 0; i < 600; i++)
  8b:	81 fb 58 02 00 00    	cmp    $0x258,%ebx
  91:	75 d5                	jne    68 <main+0x68>
		// printf(1, "number of a[%d] is %d\n", i * 1024, a[i * 1024]);
	}
	printf(1, "\n=====================================mallocation_B=====================================\n");
  93:	83 ec 08             	sub    $0x8,%esp
  96:	68 80 0a 00 00       	push   $0xa80
  9b:	6a 01                	push   $0x1
  9d:	e8 2e 05 00 00       	call   5d0 <printf>
	b = (int *)malloc(sizeof(int) * 1024 * 700);
  a2:	c7 04 24 00 c0 2b 00 	movl   $0x2bc000,(%esp)
  a9:	e8 82 07 00 00       	call   830 <malloc>
	printf(1, "\n=================================mallocation_B_Finished=====================================\n");
  ae:	59                   	pop    %ecx
  af:	5b                   	pop    %ebx
  b0:	68 dc 0a 00 00       	push   $0xadc
  b5:	6a 01                	push   $0x1
	b = (int *)malloc(sizeof(int) * 1024 * 700);
  b7:	89 c6                	mov    %eax,%esi

	printf(1, "\n======================================Page Write B=====================================\n");
	for (int i = 0; i < 600; i++)
  b9:	31 db                	xor    %ebx,%ebx
	printf(1, "\n=================================mallocation_B_Finished=====================================\n");
  bb:	e8 10 05 00 00       	call   5d0 <printf>
	printf(1, "\n======================================Page Write B=====================================\n");
  c0:	58                   	pop    %eax
  c1:	5a                   	pop    %edx
  c2:	68 3c 0b 00 00       	push   $0xb3c
  c7:	6a 01                	push   $0x1
  c9:	e8 02 05 00 00       	call   5d0 <printf>
  ce:	83 c4 10             	add    $0x10,%esp
  d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	{
		printf(1, "Write Array B call : %d\n", i);
  d8:	83 ec 04             	sub    $0x4,%esp
  db:	53                   	push   %ebx
  dc:	68 cd 0c 00 00       	push   $0xccd
  e1:	6a 01                	push   $0x1
  e3:	e8 e8 04 00 00       	call   5d0 <printf>
		b[i * 1024] = -i * 1024;
  e8:	89 d8                	mov    %ebx,%eax
  ea:	89 da                	mov    %ebx,%edx
	for (int i = 0; i < 600; i++)
  ec:	83 c3 01             	add    $0x1,%ebx
		b[i * 1024] = -i * 1024;
  ef:	f7 d8                	neg    %eax
  f1:	c1 e2 0c             	shl    $0xc,%edx
	for (int i = 0; i < 600; i++)
  f4:	83 c4 10             	add    $0x10,%esp
		b[i * 1024] = -i * 1024;
  f7:	c1 e0 0a             	shl    $0xa,%eax
  fa:	89 04 16             	mov    %eax,(%esi,%edx,1)
	for (int i = 0; i < 600; i++)
  fd:	81 fb 58 02 00 00    	cmp    $0x258,%ebx
 103:	75 d3                	jne    d8 <main+0xd8>
		// printf(1, "number of a[%d] is %d\n", i * 1024, a[i * 1024]);
	}
	printf(1, "\n======================================Page Read A=====================================\n");
 105:	83 ec 08             	sub    $0x8,%esp
	for (int i = 0; i < 600; i++)
 108:	31 db                	xor    %ebx,%ebx
	printf(1, "\n======================================Page Read A=====================================\n");
 10a:	68 98 0b 00 00       	push   $0xb98
 10f:	6a 01                	push   $0x1
 111:	e8 ba 04 00 00       	call   5d0 <printf>
 116:	83 c4 10             	add    $0x10,%esp
 119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	{
		printf(1, "Read Array A call : %d\n", i);
 120:	83 ec 04             	sub    $0x4,%esp
 123:	53                   	push   %ebx
 124:	68 e6 0c 00 00       	push   $0xce6
 129:	6a 01                	push   $0x1
 12b:	e8 a0 04 00 00       	call   5d0 <printf>
		printf(1, "number of a[%d] is %d\n", i * 1024, a[i * 1024]);
 130:	89 d8                	mov    %ebx,%eax
 132:	c1 e0 0c             	shl    $0xc,%eax
 135:	ff 34 07             	pushl  (%edi,%eax,1)
 138:	89 d8                	mov    %ebx,%eax
	for (int i = 0; i < 600; i++)
 13a:	83 c3 01             	add    $0x1,%ebx
		printf(1, "number of a[%d] is %d\n", i * 1024, a[i * 1024]);
 13d:	c1 e0 0a             	shl    $0xa,%eax
 140:	50                   	push   %eax
 141:	68 fe 0c 00 00       	push   $0xcfe
 146:	6a 01                	push   $0x1
 148:	e8 83 04 00 00       	call   5d0 <printf>
	for (int i = 0; i < 600; i++)
 14d:	83 c4 20             	add    $0x20,%esp
 150:	81 fb 58 02 00 00    	cmp    $0x258,%ebx
 156:	75 c8                	jne    120 <main+0x120>
	}
	printf(1, "\n======================================Page Read B=====================================\n");
 158:	83 ec 08             	sub    $0x8,%esp
	for (int i = 0; i < 600; i++)
 15b:	31 db                	xor    %ebx,%ebx
	printf(1, "\n======================================Page Read B=====================================\n");
 15d:	68 f4 0b 00 00       	push   $0xbf4
 162:	6a 01                	push   $0x1
 164:	e8 67 04 00 00       	call   5d0 <printf>
 169:	83 c4 10             	add    $0x10,%esp
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	{
		printf(1, "Read Array B call : %d\n", i);
 170:	83 ec 04             	sub    $0x4,%esp
 173:	53                   	push   %ebx
 174:	68 15 0d 00 00       	push   $0xd15
 179:	6a 01                	push   $0x1
 17b:	e8 50 04 00 00       	call   5d0 <printf>
		printf(1, "number of b[%d] is %d\n", i * 1024, b[i * 1024]);
 180:	89 d8                	mov    %ebx,%eax
 182:	c1 e0 0c             	shl    $0xc,%eax
 185:	ff 34 06             	pushl  (%esi,%eax,1)
 188:	89 d8                	mov    %ebx,%eax
	for (int i = 0; i < 600; i++)
 18a:	83 c3 01             	add    $0x1,%ebx
		printf(1, "number of b[%d] is %d\n", i * 1024, b[i * 1024]);
 18d:	c1 e0 0a             	shl    $0xa,%eax
 190:	50                   	push   %eax
 191:	68 2d 0d 00 00       	push   $0xd2d
 196:	6a 01                	push   $0x1
 198:	e8 33 04 00 00       	call   5d0 <printf>
	for (int i = 0; i < 600; i++)
 19d:	83 c4 20             	add    $0x20,%esp
 1a0:	81 fb 58 02 00 00    	cmp    $0x258,%ebx
 1a6:	75 c8                	jne    170 <main+0x170>
	}

	printf(1, "===========free a for checking swap in===========\n");
 1a8:	83 ec 08             	sub    $0x8,%esp
 1ab:	68 50 0c 00 00       	push   $0xc50
 1b0:	6a 01                	push   $0x1
 1b2:	e8 19 04 00 00       	call   5d0 <printf>
	free(a);
 1b7:	89 3c 24             	mov    %edi,(%esp)
 1ba:	e8 e1 05 00 00       	call   7a0 <free>
	free(b);
 1bf:	89 34 24             	mov    %esi,(%esp)
 1c2:	e8 d9 05 00 00       	call   7a0 <free>

	// check swap state
	swapstat(&in, &out);
 1c7:	58                   	pop    %eax
 1c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 1cb:	5a                   	pop    %edx
 1cc:	50                   	push   %eax
 1cd:	8d 45 e0             	lea    -0x20(%ebp),%eax
 1d0:	50                   	push   %eax
 1d1:	e8 3d 03 00 00       	call   513 <swapstat>
	printf(1, "\n1)swapin : %d\n2)swapout: %d\n", in, out);
 1d6:	ff 75 e4             	pushl  -0x1c(%ebp)
 1d9:	ff 75 e0             	pushl  -0x20(%ebp)
 1dc:	68 44 0d 00 00       	push   $0xd44
 1e1:	6a 01                	push   $0x1
 1e3:	e8 e8 03 00 00       	call   5d0 <printf>
	printf(1, "\n===============swap test end=============== \n");
 1e8:	83 c4 18             	add    $0x18,%esp
 1eb:	68 84 0c 00 00       	push   $0xc84
 1f0:	6a 01                	push   $0x1
 1f2:	e8 d9 03 00 00       	call   5d0 <printf>
	exit();
 1f7:	e8 67 02 00 00       	call   463 <exit>
 1fc:	66 90                	xchg   %ax,%ax
 1fe:	66 90                	xchg   %ax,%ax

00000200 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 200:	f3 0f 1e fb          	endbr32 
 204:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 205:	31 c0                	xor    %eax,%eax
{
 207:	89 e5                	mov    %esp,%ebp
 209:	53                   	push   %ebx
 20a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 20d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 210:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 214:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 217:	83 c0 01             	add    $0x1,%eax
 21a:	84 d2                	test   %dl,%dl
 21c:	75 f2                	jne    210 <strcpy+0x10>
    ;
  return os;
}
 21e:	89 c8                	mov    %ecx,%eax
 220:	5b                   	pop    %ebx
 221:	5d                   	pop    %ebp
 222:	c3                   	ret    
 223:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000230 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 230:	f3 0f 1e fb          	endbr32 
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	53                   	push   %ebx
 238:	8b 4d 08             	mov    0x8(%ebp),%ecx
 23b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 23e:	0f b6 01             	movzbl (%ecx),%eax
 241:	0f b6 1a             	movzbl (%edx),%ebx
 244:	84 c0                	test   %al,%al
 246:	75 19                	jne    261 <strcmp+0x31>
 248:	eb 26                	jmp    270 <strcmp+0x40>
 24a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 250:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 254:	83 c1 01             	add    $0x1,%ecx
 257:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 25a:	0f b6 1a             	movzbl (%edx),%ebx
 25d:	84 c0                	test   %al,%al
 25f:	74 0f                	je     270 <strcmp+0x40>
 261:	38 d8                	cmp    %bl,%al
 263:	74 eb                	je     250 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 265:	29 d8                	sub    %ebx,%eax
}
 267:	5b                   	pop    %ebx
 268:	5d                   	pop    %ebp
 269:	c3                   	ret    
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 270:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 272:	29 d8                	sub    %ebx,%eax
}
 274:	5b                   	pop    %ebx
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax

00000280 <strlen>:

uint
strlen(const char *s)
{
 280:	f3 0f 1e fb          	endbr32 
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 28a:	80 3a 00             	cmpb   $0x0,(%edx)
 28d:	74 21                	je     2b0 <strlen+0x30>
 28f:	31 c0                	xor    %eax,%eax
 291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 298:	83 c0 01             	add    $0x1,%eax
 29b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 29f:	89 c1                	mov    %eax,%ecx
 2a1:	75 f5                	jne    298 <strlen+0x18>
    ;
  return n;
}
 2a3:	89 c8                	mov    %ecx,%eax
 2a5:	5d                   	pop    %ebp
 2a6:	c3                   	ret    
 2a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ae:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 2b0:	31 c9                	xor    %ecx,%ecx
}
 2b2:	5d                   	pop    %ebp
 2b3:	89 c8                	mov    %ecx,%eax
 2b5:	c3                   	ret    
 2b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bd:	8d 76 00             	lea    0x0(%esi),%esi

000002c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c0:	f3 0f 1e fb          	endbr32 
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	57                   	push   %edi
 2c8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d1:	89 d7                	mov    %edx,%edi
 2d3:	fc                   	cld    
 2d4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2d6:	89 d0                	mov    %edx,%eax
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    
 2db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2df:	90                   	nop

000002e0 <strchr>:

char*
strchr(const char *s, char c)
{
 2e0:	f3 0f 1e fb          	endbr32 
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2ee:	0f b6 10             	movzbl (%eax),%edx
 2f1:	84 d2                	test   %dl,%dl
 2f3:	75 16                	jne    30b <strchr+0x2b>
 2f5:	eb 21                	jmp    318 <strchr+0x38>
 2f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fe:	66 90                	xchg   %ax,%ax
 300:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 304:	83 c0 01             	add    $0x1,%eax
 307:	84 d2                	test   %dl,%dl
 309:	74 0d                	je     318 <strchr+0x38>
    if(*s == c)
 30b:	38 d1                	cmp    %dl,%cl
 30d:	75 f1                	jne    300 <strchr+0x20>
      return (char*)s;
  return 0;
}
 30f:	5d                   	pop    %ebp
 310:	c3                   	ret    
 311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 318:	31 c0                	xor    %eax,%eax
}
 31a:	5d                   	pop    %ebp
 31b:	c3                   	ret    
 31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000320 <gets>:

char*
gets(char *buf, int max)
{
 320:	f3 0f 1e fb          	endbr32 
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	57                   	push   %edi
 328:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 329:	31 f6                	xor    %esi,%esi
{
 32b:	53                   	push   %ebx
 32c:	89 f3                	mov    %esi,%ebx
 32e:	83 ec 1c             	sub    $0x1c,%esp
 331:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 334:	eb 33                	jmp    369 <gets+0x49>
 336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 340:	83 ec 04             	sub    $0x4,%esp
 343:	8d 45 e7             	lea    -0x19(%ebp),%eax
 346:	6a 01                	push   $0x1
 348:	50                   	push   %eax
 349:	6a 00                	push   $0x0
 34b:	e8 2b 01 00 00       	call   47b <read>
    if(cc < 1)
 350:	83 c4 10             	add    $0x10,%esp
 353:	85 c0                	test   %eax,%eax
 355:	7e 1c                	jle    373 <gets+0x53>
      break;
    buf[i++] = c;
 357:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 35b:	83 c7 01             	add    $0x1,%edi
 35e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 361:	3c 0a                	cmp    $0xa,%al
 363:	74 23                	je     388 <gets+0x68>
 365:	3c 0d                	cmp    $0xd,%al
 367:	74 1f                	je     388 <gets+0x68>
  for(i=0; i+1 < max; ){
 369:	83 c3 01             	add    $0x1,%ebx
 36c:	89 fe                	mov    %edi,%esi
 36e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 371:	7c cd                	jl     340 <gets+0x20>
 373:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 375:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 378:	c6 03 00             	movb   $0x0,(%ebx)
}
 37b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37e:	5b                   	pop    %ebx
 37f:	5e                   	pop    %esi
 380:	5f                   	pop    %edi
 381:	5d                   	pop    %ebp
 382:	c3                   	ret    
 383:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 387:	90                   	nop
 388:	8b 75 08             	mov    0x8(%ebp),%esi
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	01 de                	add    %ebx,%esi
 390:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 392:	c6 03 00             	movb   $0x0,(%ebx)
}
 395:	8d 65 f4             	lea    -0xc(%ebp),%esp
 398:	5b                   	pop    %ebx
 399:	5e                   	pop    %esi
 39a:	5f                   	pop    %edi
 39b:	5d                   	pop    %ebp
 39c:	c3                   	ret    
 39d:	8d 76 00             	lea    0x0(%esi),%esi

000003a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a0:	f3 0f 1e fb          	endbr32 
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	56                   	push   %esi
 3a8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a9:	83 ec 08             	sub    $0x8,%esp
 3ac:	6a 00                	push   $0x0
 3ae:	ff 75 08             	pushl  0x8(%ebp)
 3b1:	e8 ed 00 00 00       	call   4a3 <open>
  if(fd < 0)
 3b6:	83 c4 10             	add    $0x10,%esp
 3b9:	85 c0                	test   %eax,%eax
 3bb:	78 2b                	js     3e8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 3bd:	83 ec 08             	sub    $0x8,%esp
 3c0:	ff 75 0c             	pushl  0xc(%ebp)
 3c3:	89 c3                	mov    %eax,%ebx
 3c5:	50                   	push   %eax
 3c6:	e8 f0 00 00 00       	call   4bb <fstat>
  close(fd);
 3cb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3ce:	89 c6                	mov    %eax,%esi
  close(fd);
 3d0:	e8 b6 00 00 00       	call   48b <close>
  return r;
 3d5:	83 c4 10             	add    $0x10,%esp
}
 3d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3db:	89 f0                	mov    %esi,%eax
 3dd:	5b                   	pop    %ebx
 3de:	5e                   	pop    %esi
 3df:	5d                   	pop    %ebp
 3e0:	c3                   	ret    
 3e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 3e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3ed:	eb e9                	jmp    3d8 <stat+0x38>
 3ef:	90                   	nop

000003f0 <atoi>:

int
atoi(const char *s)
{
 3f0:	f3 0f 1e fb          	endbr32 
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	53                   	push   %ebx
 3f8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3fb:	0f be 02             	movsbl (%edx),%eax
 3fe:	8d 48 d0             	lea    -0x30(%eax),%ecx
 401:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 404:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 409:	77 1a                	ja     425 <atoi+0x35>
 40b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 40f:	90                   	nop
    n = n*10 + *s++ - '0';
 410:	83 c2 01             	add    $0x1,%edx
 413:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 416:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 41a:	0f be 02             	movsbl (%edx),%eax
 41d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 420:	80 fb 09             	cmp    $0x9,%bl
 423:	76 eb                	jbe    410 <atoi+0x20>
  return n;
}
 425:	89 c8                	mov    %ecx,%eax
 427:	5b                   	pop    %ebx
 428:	5d                   	pop    %ebp
 429:	c3                   	ret    
 42a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000430 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 430:	f3 0f 1e fb          	endbr32 
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	57                   	push   %edi
 438:	8b 45 10             	mov    0x10(%ebp),%eax
 43b:	8b 55 08             	mov    0x8(%ebp),%edx
 43e:	56                   	push   %esi
 43f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 442:	85 c0                	test   %eax,%eax
 444:	7e 0f                	jle    455 <memmove+0x25>
 446:	01 d0                	add    %edx,%eax
  dst = vdst;
 448:	89 d7                	mov    %edx,%edi
 44a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 450:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 451:	39 f8                	cmp    %edi,%eax
 453:	75 fb                	jne    450 <memmove+0x20>
  return vdst;
}
 455:	5e                   	pop    %esi
 456:	89 d0                	mov    %edx,%eax
 458:	5f                   	pop    %edi
 459:	5d                   	pop    %ebp
 45a:	c3                   	ret    

0000045b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 45b:	b8 01 00 00 00       	mov    $0x1,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <exit>:
SYSCALL(exit)
 463:	b8 02 00 00 00       	mov    $0x2,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <wait>:
SYSCALL(wait)
 46b:	b8 03 00 00 00       	mov    $0x3,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <pipe>:
SYSCALL(pipe)
 473:	b8 04 00 00 00       	mov    $0x4,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <read>:
SYSCALL(read)
 47b:	b8 05 00 00 00       	mov    $0x5,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <write>:
SYSCALL(write)
 483:	b8 10 00 00 00       	mov    $0x10,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <close>:
SYSCALL(close)
 48b:	b8 15 00 00 00       	mov    $0x15,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <kill>:
SYSCALL(kill)
 493:	b8 06 00 00 00       	mov    $0x6,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <exec>:
SYSCALL(exec)
 49b:	b8 07 00 00 00       	mov    $0x7,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <open>:
SYSCALL(open)
 4a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <mknod>:
SYSCALL(mknod)
 4ab:	b8 11 00 00 00       	mov    $0x11,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <unlink>:
SYSCALL(unlink)
 4b3:	b8 12 00 00 00       	mov    $0x12,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <fstat>:
SYSCALL(fstat)
 4bb:	b8 08 00 00 00       	mov    $0x8,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <link>:
SYSCALL(link)
 4c3:	b8 13 00 00 00       	mov    $0x13,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <mkdir>:
SYSCALL(mkdir)
 4cb:	b8 14 00 00 00       	mov    $0x14,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <chdir>:
SYSCALL(chdir)
 4d3:	b8 09 00 00 00       	mov    $0x9,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <dup>:
SYSCALL(dup)
 4db:	b8 0a 00 00 00       	mov    $0xa,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <getpid>:
SYSCALL(getpid)
 4e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <sbrk>:
SYSCALL(sbrk)
 4eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <sleep>:
SYSCALL(sleep)
 4f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <uptime>:
SYSCALL(uptime)
 4fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <swapread>:
SYSCALL(swapread)
 503:	b8 16 00 00 00       	mov    $0x16,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <swapwrite>:
SYSCALL(swapwrite)
 50b:	b8 17 00 00 00       	mov    $0x17,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <swapstat>:
SYSCALL(swapstat)
 513:	b8 18 00 00 00       	mov    $0x18,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    
 51b:	66 90                	xchg   %ax,%ax
 51d:	66 90                	xchg   %ax,%ax
 51f:	90                   	nop

00000520 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	83 ec 3c             	sub    $0x3c,%esp
 529:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 52c:	89 d1                	mov    %edx,%ecx
{
 52e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 531:	85 d2                	test   %edx,%edx
 533:	0f 89 7f 00 00 00    	jns    5b8 <printint+0x98>
 539:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 53d:	74 79                	je     5b8 <printint+0x98>
    neg = 1;
 53f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 546:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 548:	31 db                	xor    %ebx,%ebx
 54a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 54d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 550:	89 c8                	mov    %ecx,%eax
 552:	31 d2                	xor    %edx,%edx
 554:	89 cf                	mov    %ecx,%edi
 556:	f7 75 c4             	divl   -0x3c(%ebp)
 559:	0f b6 92 6c 0d 00 00 	movzbl 0xd6c(%edx),%edx
 560:	89 45 c0             	mov    %eax,-0x40(%ebp)
 563:	89 d8                	mov    %ebx,%eax
 565:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 568:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 56b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 56e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 571:	76 dd                	jbe    550 <printint+0x30>
  if(neg)
 573:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 576:	85 c9                	test   %ecx,%ecx
 578:	74 0c                	je     586 <printint+0x66>
    buf[i++] = '-';
 57a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 57f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 581:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 586:	8b 7d b8             	mov    -0x48(%ebp),%edi
 589:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 58d:	eb 07                	jmp    596 <printint+0x76>
 58f:	90                   	nop
 590:	0f b6 13             	movzbl (%ebx),%edx
 593:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 596:	83 ec 04             	sub    $0x4,%esp
 599:	88 55 d7             	mov    %dl,-0x29(%ebp)
 59c:	6a 01                	push   $0x1
 59e:	56                   	push   %esi
 59f:	57                   	push   %edi
 5a0:	e8 de fe ff ff       	call   483 <write>
  while(--i >= 0)
 5a5:	83 c4 10             	add    $0x10,%esp
 5a8:	39 de                	cmp    %ebx,%esi
 5aa:	75 e4                	jne    590 <printint+0x70>
    putc(fd, buf[i]);
}
 5ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5af:	5b                   	pop    %ebx
 5b0:	5e                   	pop    %esi
 5b1:	5f                   	pop    %edi
 5b2:	5d                   	pop    %ebp
 5b3:	c3                   	ret    
 5b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5b8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 5bf:	eb 87                	jmp    548 <printint+0x28>
 5c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5cf:	90                   	nop

000005d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5d0:	f3 0f 1e fb          	endbr32 
 5d4:	55                   	push   %ebp
 5d5:	89 e5                	mov    %esp,%ebp
 5d7:	57                   	push   %edi
 5d8:	56                   	push   %esi
 5d9:	53                   	push   %ebx
 5da:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5dd:	8b 75 0c             	mov    0xc(%ebp),%esi
 5e0:	0f b6 1e             	movzbl (%esi),%ebx
 5e3:	84 db                	test   %bl,%bl
 5e5:	0f 84 b4 00 00 00    	je     69f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 5eb:	8d 45 10             	lea    0x10(%ebp),%eax
 5ee:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 5f1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 5f4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 5f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5f9:	eb 33                	jmp    62e <printf+0x5e>
 5fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ff:	90                   	nop
 600:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 603:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 608:	83 f8 25             	cmp    $0x25,%eax
 60b:	74 17                	je     624 <printf+0x54>
  write(fd, &c, 1);
 60d:	83 ec 04             	sub    $0x4,%esp
 610:	88 5d e7             	mov    %bl,-0x19(%ebp)
 613:	6a 01                	push   $0x1
 615:	57                   	push   %edi
 616:	ff 75 08             	pushl  0x8(%ebp)
 619:	e8 65 fe ff ff       	call   483 <write>
 61e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 621:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 624:	0f b6 1e             	movzbl (%esi),%ebx
 627:	83 c6 01             	add    $0x1,%esi
 62a:	84 db                	test   %bl,%bl
 62c:	74 71                	je     69f <printf+0xcf>
    c = fmt[i] & 0xff;
 62e:	0f be cb             	movsbl %bl,%ecx
 631:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 634:	85 d2                	test   %edx,%edx
 636:	74 c8                	je     600 <printf+0x30>
      }
    } else if(state == '%'){
 638:	83 fa 25             	cmp    $0x25,%edx
 63b:	75 e7                	jne    624 <printf+0x54>
      if(c == 'd'){
 63d:	83 f8 64             	cmp    $0x64,%eax
 640:	0f 84 9a 00 00 00    	je     6e0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 646:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 64c:	83 f9 70             	cmp    $0x70,%ecx
 64f:	74 5f                	je     6b0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 651:	83 f8 73             	cmp    $0x73,%eax
 654:	0f 84 d6 00 00 00    	je     730 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 65a:	83 f8 63             	cmp    $0x63,%eax
 65d:	0f 84 8d 00 00 00    	je     6f0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 663:	83 f8 25             	cmp    $0x25,%eax
 666:	0f 84 b4 00 00 00    	je     720 <printf+0x150>
  write(fd, &c, 1);
 66c:	83 ec 04             	sub    $0x4,%esp
 66f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 673:	6a 01                	push   $0x1
 675:	57                   	push   %edi
 676:	ff 75 08             	pushl  0x8(%ebp)
 679:	e8 05 fe ff ff       	call   483 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 67e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 681:	83 c4 0c             	add    $0xc,%esp
 684:	6a 01                	push   $0x1
 686:	83 c6 01             	add    $0x1,%esi
 689:	57                   	push   %edi
 68a:	ff 75 08             	pushl  0x8(%ebp)
 68d:	e8 f1 fd ff ff       	call   483 <write>
  for(i = 0; fmt[i]; i++){
 692:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 696:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 699:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 69b:	84 db                	test   %bl,%bl
 69d:	75 8f                	jne    62e <printf+0x5e>
    }
  }
}
 69f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a2:	5b                   	pop    %ebx
 6a3:	5e                   	pop    %esi
 6a4:	5f                   	pop    %edi
 6a5:	5d                   	pop    %ebp
 6a6:	c3                   	ret    
 6a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6b0:	83 ec 0c             	sub    $0xc,%esp
 6b3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6b8:	6a 00                	push   $0x0
 6ba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6bd:	8b 45 08             	mov    0x8(%ebp),%eax
 6c0:	8b 13                	mov    (%ebx),%edx
 6c2:	e8 59 fe ff ff       	call   520 <printint>
        ap++;
 6c7:	89 d8                	mov    %ebx,%eax
 6c9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6cc:	31 d2                	xor    %edx,%edx
        ap++;
 6ce:	83 c0 04             	add    $0x4,%eax
 6d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6d4:	e9 4b ff ff ff       	jmp    624 <printf+0x54>
 6d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 6e0:	83 ec 0c             	sub    $0xc,%esp
 6e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6e8:	6a 01                	push   $0x1
 6ea:	eb ce                	jmp    6ba <printf+0xea>
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 6f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6f6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 6f8:	6a 01                	push   $0x1
        ap++;
 6fa:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 6fd:	57                   	push   %edi
 6fe:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 701:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 704:	e8 7a fd ff ff       	call   483 <write>
        ap++;
 709:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 70c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 70f:	31 d2                	xor    %edx,%edx
 711:	e9 0e ff ff ff       	jmp    624 <printf+0x54>
 716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 71d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 720:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 723:	83 ec 04             	sub    $0x4,%esp
 726:	e9 59 ff ff ff       	jmp    684 <printf+0xb4>
 72b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 72f:	90                   	nop
        s = (char*)*ap;
 730:	8b 45 d0             	mov    -0x30(%ebp),%eax
 733:	8b 18                	mov    (%eax),%ebx
        ap++;
 735:	83 c0 04             	add    $0x4,%eax
 738:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 73b:	85 db                	test   %ebx,%ebx
 73d:	74 17                	je     756 <printf+0x186>
        while(*s != 0){
 73f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 742:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 744:	84 c0                	test   %al,%al
 746:	0f 84 d8 fe ff ff    	je     624 <printf+0x54>
 74c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 74f:	89 de                	mov    %ebx,%esi
 751:	8b 5d 08             	mov    0x8(%ebp),%ebx
 754:	eb 1a                	jmp    770 <printf+0x1a0>
          s = "(null)";
 756:	bb 62 0d 00 00       	mov    $0xd62,%ebx
        while(*s != 0){
 75b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 75e:	b8 28 00 00 00       	mov    $0x28,%eax
 763:	89 de                	mov    %ebx,%esi
 765:	8b 5d 08             	mov    0x8(%ebp),%ebx
 768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 76f:	90                   	nop
  write(fd, &c, 1);
 770:	83 ec 04             	sub    $0x4,%esp
          s++;
 773:	83 c6 01             	add    $0x1,%esi
 776:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 779:	6a 01                	push   $0x1
 77b:	57                   	push   %edi
 77c:	53                   	push   %ebx
 77d:	e8 01 fd ff ff       	call   483 <write>
        while(*s != 0){
 782:	0f b6 06             	movzbl (%esi),%eax
 785:	83 c4 10             	add    $0x10,%esp
 788:	84 c0                	test   %al,%al
 78a:	75 e4                	jne    770 <printf+0x1a0>
 78c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 78f:	31 d2                	xor    %edx,%edx
 791:	e9 8e fe ff ff       	jmp    624 <printf+0x54>
 796:	66 90                	xchg   %ax,%ax
 798:	66 90                	xchg   %ax,%ax
 79a:	66 90                	xchg   %ax,%ax
 79c:	66 90                	xchg   %ax,%ax
 79e:	66 90                	xchg   %ax,%ax

000007a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a0:	f3 0f 1e fb          	endbr32 
 7a4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a5:	a1 20 10 00 00       	mov    0x1020,%eax
{
 7aa:	89 e5                	mov    %esp,%ebp
 7ac:	57                   	push   %edi
 7ad:	56                   	push   %esi
 7ae:	53                   	push   %ebx
 7af:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7b2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 7b4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b7:	39 c8                	cmp    %ecx,%eax
 7b9:	73 15                	jae    7d0 <free+0x30>
 7bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7bf:	90                   	nop
 7c0:	39 d1                	cmp    %edx,%ecx
 7c2:	72 14                	jb     7d8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c4:	39 d0                	cmp    %edx,%eax
 7c6:	73 10                	jae    7d8 <free+0x38>
{
 7c8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	8b 10                	mov    (%eax),%edx
 7cc:	39 c8                	cmp    %ecx,%eax
 7ce:	72 f0                	jb     7c0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	39 d0                	cmp    %edx,%eax
 7d2:	72 f4                	jb     7c8 <free+0x28>
 7d4:	39 d1                	cmp    %edx,%ecx
 7d6:	73 f0                	jae    7c8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7de:	39 fa                	cmp    %edi,%edx
 7e0:	74 1e                	je     800 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7e2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7e5:	8b 50 04             	mov    0x4(%eax),%edx
 7e8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7eb:	39 f1                	cmp    %esi,%ecx
 7ed:	74 28                	je     817 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7ef:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 7f1:	5b                   	pop    %ebx
  freep = p;
 7f2:	a3 20 10 00 00       	mov    %eax,0x1020
}
 7f7:	5e                   	pop    %esi
 7f8:	5f                   	pop    %edi
 7f9:	5d                   	pop    %ebp
 7fa:	c3                   	ret    
 7fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7ff:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 800:	03 72 04             	add    0x4(%edx),%esi
 803:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 806:	8b 10                	mov    (%eax),%edx
 808:	8b 12                	mov    (%edx),%edx
 80a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 80d:	8b 50 04             	mov    0x4(%eax),%edx
 810:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 813:	39 f1                	cmp    %esi,%ecx
 815:	75 d8                	jne    7ef <free+0x4f>
    p->s.size += bp->s.size;
 817:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 81a:	a3 20 10 00 00       	mov    %eax,0x1020
    p->s.size += bp->s.size;
 81f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 822:	8b 53 f8             	mov    -0x8(%ebx),%edx
 825:	89 10                	mov    %edx,(%eax)
}
 827:	5b                   	pop    %ebx
 828:	5e                   	pop    %esi
 829:	5f                   	pop    %edi
 82a:	5d                   	pop    %ebp
 82b:	c3                   	ret    
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000830 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 830:	f3 0f 1e fb          	endbr32 
 834:	55                   	push   %ebp
 835:	89 e5                	mov    %esp,%ebp
 837:	57                   	push   %edi
 838:	56                   	push   %esi
 839:	53                   	push   %ebx
 83a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 840:	8b 3d 20 10 00 00    	mov    0x1020,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 846:	8d 70 07             	lea    0x7(%eax),%esi
 849:	c1 ee 03             	shr    $0x3,%esi
 84c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 84f:	85 ff                	test   %edi,%edi
 851:	0f 84 a9 00 00 00    	je     900 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 857:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 859:	8b 48 04             	mov    0x4(%eax),%ecx
 85c:	39 f1                	cmp    %esi,%ecx
 85e:	73 6d                	jae    8cd <malloc+0x9d>
 860:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 866:	bb 00 10 00 00       	mov    $0x1000,%ebx
 86b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 86e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 875:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 878:	eb 17                	jmp    891 <malloc+0x61>
 87a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 880:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 882:	8b 4a 04             	mov    0x4(%edx),%ecx
 885:	39 f1                	cmp    %esi,%ecx
 887:	73 4f                	jae    8d8 <malloc+0xa8>
 889:	8b 3d 20 10 00 00    	mov    0x1020,%edi
 88f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 891:	39 c7                	cmp    %eax,%edi
 893:	75 eb                	jne    880 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 895:	83 ec 0c             	sub    $0xc,%esp
 898:	ff 75 e4             	pushl  -0x1c(%ebp)
 89b:	e8 4b fc ff ff       	call   4eb <sbrk>
  if(p == (char*)-1)
 8a0:	83 c4 10             	add    $0x10,%esp
 8a3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8a6:	74 1b                	je     8c3 <malloc+0x93>
  hp->s.size = nu;
 8a8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8ab:	83 ec 0c             	sub    $0xc,%esp
 8ae:	83 c0 08             	add    $0x8,%eax
 8b1:	50                   	push   %eax
 8b2:	e8 e9 fe ff ff       	call   7a0 <free>
  return freep;
 8b7:	a1 20 10 00 00       	mov    0x1020,%eax
      if((p = morecore(nunits)) == 0)
 8bc:	83 c4 10             	add    $0x10,%esp
 8bf:	85 c0                	test   %eax,%eax
 8c1:	75 bd                	jne    880 <malloc+0x50>
        return 0;
  }
}
 8c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8c6:	31 c0                	xor    %eax,%eax
}
 8c8:	5b                   	pop    %ebx
 8c9:	5e                   	pop    %esi
 8ca:	5f                   	pop    %edi
 8cb:	5d                   	pop    %ebp
 8cc:	c3                   	ret    
    if(p->s.size >= nunits){
 8cd:	89 c2                	mov    %eax,%edx
 8cf:	89 f8                	mov    %edi,%eax
 8d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 8d8:	39 ce                	cmp    %ecx,%esi
 8da:	74 54                	je     930 <malloc+0x100>
        p->s.size -= nunits;
 8dc:	29 f1                	sub    %esi,%ecx
 8de:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 8e1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 8e4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 8e7:	a3 20 10 00 00       	mov    %eax,0x1020
}
 8ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8ef:	8d 42 08             	lea    0x8(%edx),%eax
}
 8f2:	5b                   	pop    %ebx
 8f3:	5e                   	pop    %esi
 8f4:	5f                   	pop    %edi
 8f5:	5d                   	pop    %ebp
 8f6:	c3                   	ret    
 8f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8fe:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 900:	c7 05 20 10 00 00 24 	movl   $0x1024,0x1020
 907:	10 00 00 
    base.s.size = 0;
 90a:	bf 24 10 00 00       	mov    $0x1024,%edi
    base.s.ptr = freep = prevp = &base;
 90f:	c7 05 24 10 00 00 24 	movl   $0x1024,0x1024
 916:	10 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 919:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 91b:	c7 05 28 10 00 00 00 	movl   $0x0,0x1028
 922:	00 00 00 
    if(p->s.size >= nunits){
 925:	e9 36 ff ff ff       	jmp    860 <malloc+0x30>
 92a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 930:	8b 0a                	mov    (%edx),%ecx
 932:	89 08                	mov    %ecx,(%eax)
 934:	eb b1                	jmp    8e7 <malloc+0xb7>
