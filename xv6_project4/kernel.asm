
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 3e 10 80       	mov    $0x80103e50,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 c0 80 10 80       	push   $0x801080c0
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 81 51 00 00       	call   801051e0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 80 10 80       	push   $0x801080c7
80100097:	50                   	push   %eax
80100098:	e8 03 50 00 00       	call   801050a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 73 52 00 00       	call   80105360 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 b9 52 00 00       	call   80105420 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 4f 00 00       	call   801050e0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 21 00 00       	call   80102390 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ce 80 10 80       	push   $0x801080ce
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 b9 4f 00 00       	call   80105180 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 b3 21 00 00       	jmp    80102390 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 df 80 10 80       	push   $0x801080df
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 78 4f 00 00       	call   80105180 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 28 4f 00 00       	call   80105140 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 3c 51 00 00       	call   80105360 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 ab 51 00 00       	jmp    80105420 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 e6 80 10 80       	push   $0x801080e6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
    procdump(); // now call procdump() wo. cons.lock held
  }
}

int consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 aa 50 00 00       	call   80105360 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while (n > 0)
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while (n > 0)
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while (input.r == input.w)
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 36 4a 00 00       	call   80104d20 <sleep>
    while (input.r == input.w)
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if (myproc()->killed)
801002fa:	e8 71 44 00 00       	call   80104770 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 0d 51 00 00       	call   80105420 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
    if (c == C('D'))
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if (c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 b6 50 00 00       	call   80105420 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if (n < target)
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 fe 32 00 00       	call   801036b0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ed 80 10 80       	push   $0x801080ed
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 2b 8e 10 80 	movl   $0x80108e2b,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 1f 4e 00 00       	call   80105200 <getcallerpcs>
  for (i = 0; i < 10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 01 81 10 80       	push   $0x80108101
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for (i = 0; i < 10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for (;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
void consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if (c == BACKSPACE)
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 11 68 00 00       	call   80106c40 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if (c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if (c == BACKSPACE)
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c & 0xff) | 0x0700; // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if (pos < 0 || pos > 25 * 80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if ((pos / 80) >= 24)
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
      --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
    if (pos > 0)
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos % 80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 26 67 00 00       	call   80106c40 <uartputc>
    uartputc(' ');
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 1a 67 00 00       	call   80106c40 <uartputc>
    uartputc('\b');
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 0e 67 00 00       	call   80106c40 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 aa 4f 00 00       	call   80105510 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 f5 4e 00 00       	call   80105470 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 81 10 80       	push   $0x80108105
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if (sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 30 81 10 80 	movzbl -0x7fef7ed0(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  } while ((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  } while ((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if (sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while (--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if (panicked)
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for (;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while (--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 fc 4c 00 00       	call   80105360 <acquire>
  for (i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if (panicked)
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for (;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for (i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 84 4d 00 00       	call   80105420 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint *)(void *)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
801006e5:	31 f6                	xor    %esi,%esi
    if (c != '%')
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if (panicked)
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for (;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if (locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if (c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch (c)
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch (c)
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if ((s = (char *)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 18 81 10 80       	mov    $0x80108118,%ebx
      for (; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if (panicked)
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for (;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch (c)
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 9e 4b 00 00       	call   80105360 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for (; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if ((s = (char *)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if (panicked)
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for (;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if (panicked)
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for (;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if (panicked)
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for (;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 f3 4b 00 00       	call   80105420 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 81 10 80       	push   $0x8010811f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 e4 4a 00 00       	call   80105360 <acquire>
  while ((c = getc()) >= 0)
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch (c)
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while ((c = getc()) >= 0)
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch (c)
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if (c != 0 && input.e - input.r < INPUT_BUF)
801008b4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
  if (panicked)
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF)
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while (input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
             input.buf[(input.e - 1) % INPUT_BUF] != '\n')
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while (input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if (panicked)
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if (panicked)
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for (;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while (input.e != input.w &&
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (input.e != input.w)
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if (panicked)
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for (;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if (c != 0 && input.e - input.r < INPUT_BUF)
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 4c 4a 00 00       	call   80105420 <release>
  if (doprocdump)
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
  if (panicked)
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for (;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump(); // now call procdump() wo. cons.lock held
801009ff:	e9 cc 45 00 00       	jmp    80104fd0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF)
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 bb 44 00 00       	call   80104ee0 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 28 81 10 80       	push   $0x80108128
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 97 47 00 00       	call   801051e0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 19 11 80 40 	movl   $0x80100640,0x8011196c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 19 11 80 90 	movl   $0x80100290,0x80111968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ce 1a 00 00       	call   80102540 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "defs.h"
#include "x86.h"
#include "elf.h"

int exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3 + MAXARG + 1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 db 3c 00 00       	call   80104770 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 a0 30 00 00       	call   80103b40 <begin_op>

  if ((ip = namei(path)) == 0)
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
  {
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if (readi(ip, (char *)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>
bad:
  if (pgdir)
    freevm(pgdir);
  if (ip)
  {
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 c8 30 00 00       	call   80103bb0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if (elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if ((pgdir = setupkvm()) == 0)
80100b0c:	e8 ff 72 00 00       	call   80107e10 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if (ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if (ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if (ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 a8 70 00 00       	call   80107c20 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if (ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if (loaduvm(pgdir, (char *)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 a2 6f 00 00       	call   80107b50 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if (readi(ip, (char *)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 a0 71 00 00       	call   80107d90 <freevm>
  if (ip)
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 8a 2f 00 00       	call   80103bb0 <end_op>
  if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 e9 6f 00 00       	call   80107c20 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for (argc = 0; argv[argc]; argc++)
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for (argc = 0; argv[argc]; argc++)
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100c53:	e8 58 72 00 00       	call   80107eb0 <clearpteu>
  for (argc = 0; argv[argc]; argc++)
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3 + argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for (argc = 0; argv[argc]; argc++)
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3 + argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for (argc = 0; argv[argc]; argc++)
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if (argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 c8 49 00 00       	call   80105670 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 b5 49 00 00       	call   80105670 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 54 73 00 00       	call   80108020 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 aa 70 00 00       	call   80107d90 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3 + argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3 + argc + 1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3 + argc + 1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff; // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100d33:	e8 e8 72 00 00       	call   80108020 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for (last = s = path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if (*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for (last = s = path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if (*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for (last = s = path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 ba 48 00 00       	call   80105630 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry; // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 0e 6c 00 00       	call   801079b0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 e6 6f 00 00       	call   80107d90 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 f7 2d 00 00       	call   80103bb0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 41 81 10 80       	push   $0x80108141
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 4d 81 10 80       	push   $0x8010814d
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 e7 43 00 00       	call   801051e0 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 0f 11 80       	push   $0x80110fc0
80100e15:	e8 46 45 00 00       	call   80105360 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 da 45 00 00       	call   80105420 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 0f 11 80       	push   $0x80110fc0
80100e5a:	e8 c1 45 00 00       	call   80105420 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 0f 11 80       	push   $0x80110fc0
80100e83:	e8 d8 44 00 00       	call   80105360 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100ea0:	e8 7b 45 00 00       	call   80105420 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 54 81 10 80       	push   $0x80108154
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed5:	e8 86 44 00 00       	call   80105360 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 0b 45 00 00       	call   80105420 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 dd 44 00 00       	jmp    80105420 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 f3 2b 00 00       	call   80103b40 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 49 2c 00 00       	jmp    80103bb0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 92 33 00 00       	call   80104310 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 5c 81 10 80       	push   $0x8010815c
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 46 34 00 00       	jmp    801044b0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 66 81 10 80       	push   $0x80108166
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 ba 2a 00 00       	call   80103bb0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 21 2a 00 00       	call   80103b40 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 5a 2a 00 00       	call   80103bb0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 6f 81 10 80       	push   $0x8010816f
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 1a 32 00 00       	jmp    801043b0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 75 81 10 80       	push   $0x80108175
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for (b = 0; b < sb.size; b += BPB)
801011b9:	8b 0d c4 19 11 80    	mov    0x801119c4,%ecx
{
801011bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (b = 0; b < sb.size; b += BPB)
801011c2:	85 c9                	test   %ecx,%ecx
801011c4:	0f 84 87 00 00 00    	je     80101251 <balloc+0xa1>
801011ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  {
    bp = bread(dev, BBLOCK(b, sb));
801011d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	89 f0                	mov    %esi,%eax
801011d9:	c1 f8 0c             	sar    $0xc,%eax
801011dc:	03 05 dc 19 11 80    	add    0x801119dc,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	83 c4 10             	add    $0x10,%esp
801011ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
801011f1:	a1 c4 19 11 80       	mov    0x801119c4,%eax
801011f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011f9:	31 c0                	xor    %eax,%eax
801011fb:	eb 2f                	jmp    8010122c <balloc+0x7c>
801011fd:	8d 76 00             	lea    0x0(%esi),%esi
    {
      m = 1 << (bi % 8);
80101200:	89 c1                	mov    %eax,%ecx
80101202:	bb 01 00 00 00       	mov    $0x1,%ebx
      if ((bp->data[bi / 8] & m) == 0)
80101207:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010120a:	83 e1 07             	and    $0x7,%ecx
8010120d:	d3 e3                	shl    %cl,%ebx
      if ((bp->data[bi / 8] & m) == 0)
8010120f:	89 c1                	mov    %eax,%ecx
80101211:	c1 f9 03             	sar    $0x3,%ecx
80101214:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101219:	89 fa                	mov    %edi,%edx
8010121b:	85 df                	test   %ebx,%edi
8010121d:	74 41                	je     80101260 <balloc+0xb0>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
8010121f:	83 c0 01             	add    $0x1,%eax
80101222:	83 c6 01             	add    $0x1,%esi
80101225:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010122a:	74 05                	je     80101231 <balloc+0x81>
8010122c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010122f:	77 cf                	ja     80101200 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	ff 75 e4             	pushl  -0x1c(%ebp)
80101237:	e8 b4 ef ff ff       	call   801001f0 <brelse>
  for (b = 0; b < sb.size; b += BPB)
8010123c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101243:	83 c4 10             	add    $0x10,%esp
80101246:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101249:	39 05 c4 19 11 80    	cmp    %eax,0x801119c4
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 7f 81 10 80       	push   $0x8010817f
80101259:	e8 32 f1 ff ff       	call   80100390 <panic>
8010125e:	66 90                	xchg   %ax,%ax
        bp->data[bi / 8] |= m; // Mark block in use.
80101260:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101263:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi / 8] |= m; // Mark block in use.
80101266:	09 da                	or     %ebx,%edx
80101268:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010126c:	57                   	push   %edi
8010126d:	e8 ae 2a 00 00       	call   80103d20 <log_write>
        brelse(bp);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 76 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010127a:	58                   	pop    %eax
8010127b:	5a                   	pop    %edx
8010127c:	56                   	push   %esi
8010127d:	ff 75 d8             	pushl  -0x28(%ebp)
80101280:	e8 4b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101285:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101288:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010128a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010128d:	68 00 02 00 00       	push   $0x200
80101292:	6a 00                	push   $0x0
80101294:	50                   	push   %eax
80101295:	e8 d6 41 00 00       	call   80105470 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 7e 2a 00 00       	call   80103d20 <log_write>
  brelse(bp);
801012a2:	89 1c 24             	mov    %ebx,(%esp)
801012a5:	e8 46 ef ff ff       	call   801001f0 <brelse>
}
801012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ad:	89 f0                	mov    %esi,%eax
801012af:	5b                   	pop    %ebx
801012b0:	5e                   	pop    %esi
801012b1:	5f                   	pop    %edi
801012b2:	5d                   	pop    %ebp
801012b3:	c3                   	ret    
801012b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012bf:	90                   	nop

801012c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode *
iget(uint dev, uint inum)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	89 c7                	mov    %eax,%edi
801012c6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012c7:	31 f6                	xor    %esi,%esi
{
801012c9:	53                   	push   %ebx
  for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++)
801012ca:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 00 1a 11 80       	push   $0x80111a00
801012da:	e8 81 40 00 00       	call   80105360 <acquire>
  for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++)
801012df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801012e2:	83 c4 10             	add    $0x10,%esp
801012e5:	eb 1b                	jmp    80101302 <iget+0x42>
801012e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ee:	66 90                	xchg   %ax,%ax
  {
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
801012f0:	39 3b                	cmp    %edi,(%ebx)
801012f2:	74 6c                	je     80101360 <iget+0xa0>
801012f4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++)
801012fa:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
80101300:	73 26                	jae    80101328 <iget+0x68>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
80101302:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101305:	85 c9                	test   %ecx,%ecx
80101307:	7f e7                	jg     801012f0 <iget+0x30>
    {
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
80101309:	85 f6                	test   %esi,%esi
8010130b:	75 e7                	jne    801012f4 <iget+0x34>
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101315:	85 c9                	test   %ecx,%ecx
80101317:	75 6e                	jne    80101387 <iget+0xc7>
80101319:	89 c6                	mov    %eax,%esi
  for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++)
8010131b:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
80101321:	72 df                	jb     80101302 <iget+0x42>
80101323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101327:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if (empty == 0)
80101328:	85 f6                	test   %esi,%esi
8010132a:	74 73                	je     8010139f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010132c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010132f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101331:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101334:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010133b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101342:	68 00 1a 11 80       	push   $0x80111a00
80101347:	e8 d4 40 00 00       	call   80105420 <release>

  return ip;
8010134c:	83 c4 10             	add    $0x10,%esp
}
8010134f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101352:	89 f0                	mov    %esi,%eax
80101354:	5b                   	pop    %ebx
80101355:	5e                   	pop    %esi
80101356:	5f                   	pop    %edi
80101357:	5d                   	pop    %ebp
80101358:	c3                   	ret    
80101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
80101360:	39 53 04             	cmp    %edx,0x4(%ebx)
80101363:	75 8f                	jne    801012f4 <iget+0x34>
      release(&icache.lock);
80101365:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101368:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010136b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010136d:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
80101372:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101375:	e8 a6 40 00 00       	call   80105420 <release>
      return ip;
8010137a:	83 c4 10             	add    $0x10,%esp
}
8010137d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101380:	89 f0                	mov    %esi,%eax
80101382:	5b                   	pop    %ebx
80101383:	5e                   	pop    %esi
80101384:	5f                   	pop    %edi
80101385:	5d                   	pop    %ebp
80101386:	c3                   	ret    
  for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++)
80101387:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
8010138d:	73 10                	jae    8010139f <iget+0xdf>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
8010138f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101392:	85 c9                	test   %ecx,%ecx
80101394:	0f 8f 56 ff ff ff    	jg     801012f0 <iget+0x30>
8010139a:	e9 6e ff ff ff       	jmp    8010130d <iget+0x4d>
    panic("iget: no inodes");
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	68 95 81 10 80       	push   $0x80108195
801013a7:	e8 e4 ef ff ff       	call   80100390 <panic>
801013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	56                   	push   %esi
801013b5:	89 c6                	mov    %eax,%esi
801013b7:	53                   	push   %ebx
801013b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT)
801013bb:	83 fa 0b             	cmp    $0xb,%edx
801013be:	0f 86 84 00 00 00    	jbe    80101448 <bmap+0x98>
  {
    if ((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013c4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if (bn < NINDIRECT)
801013c7:	83 fb 7f             	cmp    $0x7f,%ebx
801013ca:	0f 87 98 00 00 00    	ja     80101468 <bmap+0xb8>
  {
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0)
801013d0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013d6:	8b 16                	mov    (%esi),%edx
801013d8:	85 c0                	test   %eax,%eax
801013da:	74 54                	je     80101430 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013dc:	83 ec 08             	sub    $0x8,%esp
801013df:	50                   	push   %eax
801013e0:	52                   	push   %edx
801013e1:	e8 ea ec ff ff       	call   801000d0 <bread>
    a = (uint *)bp->data;
    if ((addr = a[bn]) == 0)
801013e6:	83 c4 10             	add    $0x10,%esp
801013e9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013ed:	89 c7                	mov    %eax,%edi
    if ((addr = a[bn]) == 0)
801013ef:	8b 1a                	mov    (%edx),%ebx
801013f1:	85 db                	test   %ebx,%ebx
801013f3:	74 1b                	je     80101410 <bmap+0x60>
    {
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013f5:	83 ec 0c             	sub    $0xc,%esp
801013f8:	57                   	push   %edi
801013f9:	e8 f2 ed ff ff       	call   801001f0 <brelse>
    return addr;
801013fe:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101404:	89 d8                	mov    %ebx,%eax
80101406:	5b                   	pop    %ebx
80101407:	5e                   	pop    %esi
80101408:	5f                   	pop    %edi
80101409:	5d                   	pop    %ebp
8010140a:	c3                   	ret    
8010140b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010140f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101410:	8b 06                	mov    (%esi),%eax
80101412:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101415:	e8 96 fd ff ff       	call   801011b0 <balloc>
8010141a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010141d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101420:	89 c3                	mov    %eax,%ebx
80101422:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101424:	57                   	push   %edi
80101425:	e8 f6 28 00 00       	call   80103d20 <log_write>
8010142a:	83 c4 10             	add    $0x10,%esp
8010142d:	eb c6                	jmp    801013f5 <bmap+0x45>
8010142f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101430:	89 d0                	mov    %edx,%eax
80101432:	e8 79 fd ff ff       	call   801011b0 <balloc>
80101437:	8b 16                	mov    (%esi),%edx
80101439:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010143f:	eb 9b                	jmp    801013dc <bmap+0x2c>
80101441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if ((addr = ip->addrs[bn]) == 0)
80101448:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010144b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010144e:	85 db                	test   %ebx,%ebx
80101450:	75 af                	jne    80101401 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101452:	8b 00                	mov    (%eax),%eax
80101454:	e8 57 fd ff ff       	call   801011b0 <balloc>
80101459:	89 47 5c             	mov    %eax,0x5c(%edi)
8010145c:	89 c3                	mov    %eax,%ebx
}
8010145e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101461:	89 d8                	mov    %ebx,%eax
80101463:	5b                   	pop    %ebx
80101464:	5e                   	pop    %esi
80101465:	5f                   	pop    %edi
80101466:	5d                   	pop    %ebp
80101467:	c3                   	ret    
  panic("bmap: out of range");
80101468:	83 ec 0c             	sub    $0xc,%esp
8010146b:	68 a5 81 10 80       	push   $0x801081a5
80101470:	e8 1b ef ff ff       	call   80100390 <panic>
80101475:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101480 <readsb>:
{
80101480:	f3 0f 1e fb          	endbr32 
80101484:	55                   	push   %ebp
80101485:	89 e5                	mov    %esp,%ebp
80101487:	56                   	push   %esi
80101488:	53                   	push   %ebx
80101489:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010148c:	83 ec 08             	sub    $0x8,%esp
8010148f:	6a 01                	push   $0x1
80101491:	ff 75 08             	pushl  0x8(%ebp)
80101494:	e8 37 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101499:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010149c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010149e:	8d 40 5c             	lea    0x5c(%eax),%eax
801014a1:	6a 1c                	push   $0x1c
801014a3:	50                   	push   %eax
801014a4:	56                   	push   %esi
801014a5:	e8 66 40 00 00       	call   80105510 <memmove>
  brelse(bp);
801014aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014ad:	83 c4 10             	add    $0x10,%esp
}
801014b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014b3:	5b                   	pop    %ebx
801014b4:	5e                   	pop    %esi
801014b5:	5d                   	pop    %ebp
  brelse(bp);
801014b6:	e9 35 ed ff ff       	jmp    801001f0 <brelse>
801014bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014bf:	90                   	nop

801014c0 <bfree>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	56                   	push   %esi
801014c4:	89 c6                	mov    %eax,%esi
801014c6:	53                   	push   %ebx
801014c7:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801014c9:	83 ec 08             	sub    $0x8,%esp
801014cc:	68 c4 19 11 80       	push   $0x801119c4
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	89 d8                	mov    %ebx,%eax
801014da:	5a                   	pop    %edx
801014db:	c1 e8 0c             	shr    $0xc,%eax
801014de:	03 05 dc 19 11 80    	add    0x801119dc,%eax
801014e4:	50                   	push   %eax
801014e5:	56                   	push   %esi
801014e6:	e8 e5 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014eb:	89 d9                	mov    %ebx,%ecx
  if ((bp->data[bi / 8] & m) == 0)
801014ed:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014f0:	ba 01 00 00 00       	mov    $0x1,%edx
801014f5:	83 e1 07             	and    $0x7,%ecx
  if ((bp->data[bi / 8] & m) == 0)
801014f8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014fe:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101501:	d3 e2                	shl    %cl,%edx
  if ((bp->data[bi / 8] & m) == 0)
80101503:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101508:	85 d1                	test   %edx,%ecx
8010150a:	74 25                	je     80101531 <bfree+0x71>
  bp->data[bi / 8] &= ~m;
8010150c:	f7 d2                	not    %edx
  log_write(bp);
8010150e:	83 ec 0c             	sub    $0xc,%esp
80101511:	89 c6                	mov    %eax,%esi
  bp->data[bi / 8] &= ~m;
80101513:	21 ca                	and    %ecx,%edx
80101515:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
80101519:	50                   	push   %eax
8010151a:	e8 01 28 00 00       	call   80103d20 <log_write>
  brelse(bp);
8010151f:	89 34 24             	mov    %esi,(%esp)
80101522:	e8 c9 ec ff ff       	call   801001f0 <brelse>
}
80101527:	83 c4 10             	add    $0x10,%esp
8010152a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152d:	5b                   	pop    %ebx
8010152e:	5e                   	pop    %esi
8010152f:	5d                   	pop    %ebp
80101530:	c3                   	ret    
    panic("freeing free block");
80101531:	83 ec 0c             	sub    $0xc,%esp
80101534:	68 b8 81 10 80       	push   $0x801081b8
80101539:	e8 52 ee ff ff       	call   80100390 <panic>
8010153e:	66 90                	xchg   %ax,%ax

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 cb 81 10 80       	push   $0x801081cb
80101555:	68 00 1a 11 80       	push   $0x80111a00
8010155a:	e8 81 3c 00 00       	call   801051e0 <initlock>
  for (i = 0; i < NINODE; i++)
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 d2 81 10 80       	push   $0x801081d2
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 24 3b 00 00       	call   801050a0 <initsleeplock>
  for (i = 0; i < NINODE; i++)
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c4 19 11 80       	push   $0x801119c4
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 e9 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 dc 19 11 80    	pushl  0x801119dc
8010159d:	ff 35 d8 19 11 80    	pushl  0x801119d8
801015a3:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015a9:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015af:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015b5:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015bb:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015c1:	68 70 82 10 80       	push   $0x80108270
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for (inum = 1; inum < sb.ninodes; inum++)
801015f0:	83 3d cc 19 11 80 01 	cmpl   $0x1,0x801119cc
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for (inum = 1; inum < sb.ninodes; inum++)
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for (inum = 1; inum < sb.ninodes; inum++)
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++)
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d cc 19 11 80    	cmp    0x801119cc,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if (dip->type == 0)
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode *)bp->data + inum % IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if (dip->type == 0)
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 0d 3e 00 00       	call   80105470 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp); // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 ab 26 00 00       	call   80103d20 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 30 fc ff ff       	jmp    801012c0 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 d8 81 10 80       	push   $0x801081d8
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode *)bp->data + ip->inum % IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 06 3e 00 00       	call   80105510 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 0e 26 00 00       	call   80103d20 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 00 1a 11 80       	push   $0x80111a00
80101743:	e8 18 3c 00 00       	call   80105360 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101753:	e8 c8 3c 00 00       	call   80105420 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 55 39 00 00       	call   801050e0 <acquiresleep>
  if (ip->valid == 0)
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode *)bp->data + ip->inum % IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 13 3d 00 00       	call   80105510 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if (ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if (ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 f0 81 10 80       	push   $0x801081f0
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 ea 81 10 80       	push   $0x801081ea
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 24 39 00 00       	call   80105180 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 c8 38 00 00       	jmp    80105140 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 ff 81 10 80       	push   $0x801081ff
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 37 38 00 00       	call   801050e0 <acquiresleep>
  if (ip->valid && ip->nlink == 0)
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 7d 38 00 00       	call   80105140 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801018ca:	e8 91 3a 00 00       	call   80105360 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 37 3b 00 00       	jmp    80105420 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 00 1a 11 80       	push   $0x80111a00
801018f8:	e8 63 3a 00 00       	call   80105360 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101907:	e8 14 3b 00 00       	call   80105420 <release>
    if (r == 1)
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++)
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
  {
    if (ip->addrs[i])
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
    {
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 84 fb ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if (ip->addrs[NDIRECT])
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (j = 0; j < NINDIRECT; j++)
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if (a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 fc fa ff ff       	call   801014c0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 d5 fa ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:
}

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:

// Read data from inode.
// Caller must hold ip->lock.
int readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if (ip->type == T_DEV)
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if (ip->type == T_DEV)
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if (off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if (off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for (tot = 0; tot < n; tot += m, off += m, dst += m)
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
  {
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 e1 f8 ff ff       	call   801013b0 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off % BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off % BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off % BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off % BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off % BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off % BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off % BSIZE, m);
80101afe:	53                   	push   %ebx
  for (tot = 0; tot < n; tot += m, off += m, dst += m)
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off % BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 04 3a 00 00       	call   80105510 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m)
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if (ip->type == T_DEV)
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if (ip->type == T_DEV)
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if (off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if (off + n > MAXFILE * BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m)
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 e1 f7 ff ff       	call   801013b0 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off % BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off % BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off % BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off % BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off % BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for (tot = 0; tot < n; tot += m, off += m, src += m)
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off % BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 08 39 00 00       	call   80105510 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 10 21 00 00       	call   80103d20 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m)
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if (n > 0 && off > ip->size)
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
  {
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 d9 38 00 00       	call   80105580 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de))
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
  {
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if (de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 76 38 00 00       	call   80105580 <strncmp>
      continue;
    if (namecmp(name, de.name) == 0)
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for (off = 0; off < dp->size; off += sizeof(de))
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if (poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 81 f5 ff ff       	call   801012c0 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 19 82 10 80       	push   $0x80108219
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 07 82 10 80       	push   $0x80108207
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if (*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if (*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 e1 29 00 00       	call   80104770 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 00 1a 11 80       	push   $0x80111a00
80101d9c:	e8 bf 35 00 00       	call   80105360 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101dac:	e8 6f 36 00 00       	call   80105420 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while (*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if (*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while (*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while (*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if (len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 f4 36 00 00       	call   80105510 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while (*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while (*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while ((path = skipelem(path, name)) != 0)
  {
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if (ip->type != T_DIR)
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
    {
      iunlockput(ip);
      return 0;
    }
    if (nameiparent && *path == '\0')
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
    {
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if ((next = dirlookup(ip, name, 0)) == 0)
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 68 36 00 00       	call   80105510 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if (nameiparent)
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
  {
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while (*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 9f f3 ff ff       	call   801012c0 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if ((ip = dirlookup(dp, name, 0)) != 0)
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for (off = 0; off < dp->size; off += sizeof(de))
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if (de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 f6 35 00 00       	call   801055d0 <strncpy>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 28 82 10 80       	push   $0x80108228
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 ca 8b 10 80       	push   $0x80108bca
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode *
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010206f:	90                   	nop

80102070 <swapread>:

void swapread(char *ptr, int blkno)
{
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
80102075:	89 e5                	mov    %esp,%ebp
80102077:	57                   	push   %edi
80102078:	56                   	push   %esi
80102079:	53                   	push   %ebx
8010207a:	83 ec 1c             	sub    $0x1c,%esp
8010207d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct buf *bp;
  int i;

  if (blkno < 0 || blkno >= SWAPMAX / 8)
80102080:	81 ff 94 30 00 00    	cmp    $0x3094,%edi
80102086:	77 5f                	ja     801020e7 <swapread+0x77>
    panic("swapread: blkno exceed range");

  for (i = 0; i < 8; ++i)
  {
    nr_sectors_read++;
    bp = bread(0, blkno * 8 + SWAPBASE + i);
80102088:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
8010208f:	8b 75 08             	mov    0x8(%ebp),%esi
80102092:	8d b8 f4 01 00 00    	lea    0x1f4(%eax),%edi
80102098:	05 fc 01 00 00       	add    $0x1fc,%eax
8010209d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801020a0:	83 ec 08             	sub    $0x8,%esp
    nr_sectors_read++;
801020a3:	83 05 c0 19 11 80 01 	addl   $0x1,0x801119c0
    bp = bread(0, blkno * 8 + SWAPBASE + i);
801020aa:	57                   	push   %edi
801020ab:	83 c7 01             	add    $0x1,%edi
801020ae:	6a 00                	push   $0x0
801020b0:	e8 1b e0 ff ff       	call   801000d0 <bread>
    memmove(ptr + i * BSIZE, bp->data, BSIZE);
801020b5:	83 c4 0c             	add    $0xc,%esp
    bp = bread(0, blkno * 8 + SWAPBASE + i);
801020b8:	89 c3                	mov    %eax,%ebx
    memmove(ptr + i * BSIZE, bp->data, BSIZE);
801020ba:	8d 40 5c             	lea    0x5c(%eax),%eax
801020bd:	68 00 02 00 00       	push   $0x200
801020c2:	50                   	push   %eax
801020c3:	56                   	push   %esi
801020c4:	81 c6 00 02 00 00    	add    $0x200,%esi
801020ca:	e8 41 34 00 00       	call   80105510 <memmove>
    brelse(bp);
801020cf:	89 1c 24             	mov    %ebx,(%esp)
801020d2:	e8 19 e1 ff ff       	call   801001f0 <brelse>
  for (i = 0; i < 8; ++i)
801020d7:	83 c4 10             	add    $0x10,%esp
801020da:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801020dd:	75 c1                	jne    801020a0 <swapread+0x30>
  }
}
801020df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e2:	5b                   	pop    %ebx
801020e3:	5e                   	pop    %esi
801020e4:	5f                   	pop    %edi
801020e5:	5d                   	pop    %ebp
801020e6:	c3                   	ret    
    panic("swapread: blkno exceed range");
801020e7:	83 ec 0c             	sub    $0xc,%esp
801020ea:	68 35 82 10 80       	push   $0x80108235
801020ef:	e8 9c e2 ff ff       	call   80100390 <panic>
801020f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020ff:	90                   	nop

80102100 <swapwrite>:

void swapwrite(char *ptr, int blkno)
{
80102100:	f3 0f 1e fb          	endbr32 
80102104:	55                   	push   %ebp
80102105:	89 e5                	mov    %esp,%ebp
80102107:	57                   	push   %edi
80102108:	56                   	push   %esi
80102109:	53                   	push   %ebx
8010210a:	83 ec 1c             	sub    $0x1c,%esp
8010210d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct buf *bp;
  int i;

  if (blkno < 0 || blkno >= SWAPMAX / 8)
80102110:	81 ff 94 30 00 00    	cmp    $0x3094,%edi
80102116:	77 67                	ja     8010217f <swapwrite+0x7f>
    panic("swapwrite: blkno exceed range");

  for (i = 0; i < 8; ++i)
  {
    nr_sectors_write++;
    bp = bread(0, blkno * 8 + SWAPBASE + i);
80102118:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
8010211f:	8b 75 08             	mov    0x8(%ebp),%esi
80102122:	8d b8 f4 01 00 00    	lea    0x1f4(%eax),%edi
80102128:	05 fc 01 00 00       	add    $0x1fc,%eax
8010212d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102130:	83 ec 08             	sub    $0x8,%esp
    nr_sectors_write++;
80102133:	83 05 e0 19 11 80 01 	addl   $0x1,0x801119e0
    bp = bread(0, blkno * 8 + SWAPBASE + i);
8010213a:	57                   	push   %edi
8010213b:	83 c7 01             	add    $0x1,%edi
8010213e:	6a 00                	push   $0x0
80102140:	e8 8b df ff ff       	call   801000d0 <bread>
    memmove(bp->data, ptr + i * BSIZE, BSIZE);
80102145:	83 c4 0c             	add    $0xc,%esp
    bp = bread(0, blkno * 8 + SWAPBASE + i);
80102148:	89 c3                	mov    %eax,%ebx
    memmove(bp->data, ptr + i * BSIZE, BSIZE);
8010214a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010214d:	68 00 02 00 00       	push   $0x200
80102152:	56                   	push   %esi
80102153:	81 c6 00 02 00 00    	add    $0x200,%esi
80102159:	50                   	push   %eax
8010215a:	e8 b1 33 00 00       	call   80105510 <memmove>
    bwrite(bp);
8010215f:	89 1c 24             	mov    %ebx,(%esp)
80102162:	e8 49 e0 ff ff       	call   801001b0 <bwrite>
    brelse(bp);
80102167:	89 1c 24             	mov    %ebx,(%esp)
8010216a:	e8 81 e0 ff ff       	call   801001f0 <brelse>
  for (i = 0; i < 8; ++i)
8010216f:	83 c4 10             	add    $0x10,%esp
80102172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80102175:	75 b9                	jne    80102130 <swapwrite+0x30>
  }
}
80102177:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217a:	5b                   	pop    %ebx
8010217b:	5e                   	pop    %esi
8010217c:	5f                   	pop    %edi
8010217d:	5d                   	pop    %ebp
8010217e:	c3                   	ret    
    panic("swapwrite: blkno exceed range");
8010217f:	83 ec 0c             	sub    $0xc,%esp
80102182:	68 52 82 10 80       	push   $0x80108252
80102187:	e8 04 e2 ff ff       	call   80100390 <panic>
8010218c:	66 90                	xchg   %ax,%ax
8010218e:	66 90                	xchg   %ax,%ax

80102190 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	56                   	push   %esi
80102194:	53                   	push   %ebx
  if(b == 0)
80102195:	85 c0                	test   %eax,%eax
80102197:	0f 84 af 00 00 00    	je     8010224c <idestart+0xbc>
    panic("idestart");
  if(b->blockno >= FSSIZE)
8010219d:	8b 70 08             	mov    0x8(%eax),%esi
801021a0:	89 c3                	mov    %eax,%ebx
801021a2:	81 fe 9f 86 01 00    	cmp    $0x1869f,%esi
801021a8:	0f 87 91 00 00 00    	ja     8010223f <idestart+0xaf>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ae:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021b7:	90                   	nop
801021b8:	89 ca                	mov    %ecx,%edx
801021ba:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021bb:	83 e0 c0             	and    $0xffffffc0,%eax
801021be:	3c 40                	cmp    $0x40,%al
801021c0:	75 f6                	jne    801021b8 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c2:	31 c0                	xor    %eax,%eax
801021c4:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021c9:	ee                   	out    %al,(%dx)
801021ca:	b8 01 00 00 00       	mov    $0x1,%eax
801021cf:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021d4:	ee                   	out    %al,(%dx)
801021d5:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021da:	89 f0                	mov    %esi,%eax
801021dc:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021dd:	89 f0                	mov    %esi,%eax
801021df:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021e4:	c1 f8 08             	sar    $0x8,%eax
801021e7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
801021e8:	89 f0                	mov    %esi,%eax
801021ea:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021ef:	c1 f8 10             	sar    $0x10,%eax
801021f2:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021f3:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021f7:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021fc:	c1 e0 04             	shl    $0x4,%eax
801021ff:	83 e0 10             	and    $0x10,%eax
80102202:	83 c8 e0             	or     $0xffffffe0,%eax
80102205:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102206:	f6 03 04             	testb  $0x4,(%ebx)
80102209:	75 15                	jne    80102220 <idestart+0x90>
8010220b:	b8 20 00 00 00       	mov    $0x20,%eax
80102210:	89 ca                	mov    %ecx,%edx
80102212:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102213:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102216:	5b                   	pop    %ebx
80102217:	5e                   	pop    %esi
80102218:	5d                   	pop    %ebp
80102219:	c3                   	ret    
8010221a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102220:	b8 30 00 00 00       	mov    $0x30,%eax
80102225:	89 ca                	mov    %ecx,%edx
80102227:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102228:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010222d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102230:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102235:	fc                   	cld    
80102236:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102238:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010223b:	5b                   	pop    %ebx
8010223c:	5e                   	pop    %esi
8010223d:	5d                   	pop    %ebp
8010223e:	c3                   	ret    
    panic("incorrect blockno");
8010223f:	83 ec 0c             	sub    $0xc,%esp
80102242:	68 cc 82 10 80       	push   $0x801082cc
80102247:	e8 44 e1 ff ff       	call   80100390 <panic>
    panic("idestart");
8010224c:	83 ec 0c             	sub    $0xc,%esp
8010224f:	68 c3 82 10 80       	push   $0x801082c3
80102254:	e8 37 e1 ff ff       	call   80100390 <panic>
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102260 <ideinit>:
{
80102260:	f3 0f 1e fb          	endbr32 
80102264:	55                   	push   %ebp
80102265:	89 e5                	mov    %esp,%ebp
80102267:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010226a:	68 de 82 10 80       	push   $0x801082de
8010226f:	68 80 b5 10 80       	push   $0x8010b580
80102274:	e8 67 2f 00 00       	call   801051e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102279:	58                   	pop    %eax
8010227a:	a1 40 9e 11 80       	mov    0x80119e40,%eax
8010227f:	5a                   	pop    %edx
80102280:	83 e8 01             	sub    $0x1,%eax
80102283:	50                   	push   %eax
80102284:	6a 0e                	push   $0xe
80102286:	e8 b5 02 00 00       	call   80102540 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010228b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010228e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102297:	90                   	nop
80102298:	ec                   	in     (%dx),%al
80102299:	83 e0 c0             	and    $0xffffffc0,%eax
8010229c:	3c 40                	cmp    $0x40,%al
8010229e:	75 f8                	jne    80102298 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022a5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022aa:	ee                   	out    %al,(%dx)
801022ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022b5:	eb 0e                	jmp    801022c5 <ideinit+0x65>
801022b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801022c0:	83 e9 01             	sub    $0x1,%ecx
801022c3:	74 0f                	je     801022d4 <ideinit+0x74>
801022c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022c6:	84 c0                	test   %al,%al
801022c8:	74 f6                	je     801022c0 <ideinit+0x60>
      havedisk1 = 1;
801022ca:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801022d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022de:	ee                   	out    %al,(%dx)
}
801022df:	c9                   	leave  
801022e0:	c3                   	ret    
801022e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ef:	90                   	nop

801022f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022f0:	f3 0f 1e fb          	endbr32 
801022f4:	55                   	push   %ebp
801022f5:	89 e5                	mov    %esp,%ebp
801022f7:	57                   	push   %edi
801022f8:	56                   	push   %esi
801022f9:	53                   	push   %ebx
801022fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022fd:	68 80 b5 10 80       	push   $0x8010b580
80102302:	e8 59 30 00 00       	call   80105360 <acquire>

  if((b = idequeue) == 0){
80102307:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	85 db                	test   %ebx,%ebx
80102312:	74 5f                	je     80102373 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102314:	8b 43 58             	mov    0x58(%ebx),%eax
80102317:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010231c:	8b 33                	mov    (%ebx),%esi
8010231e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102324:	75 2b                	jne    80102351 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102326:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010232b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010232f:	90                   	nop
80102330:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102331:	89 c1                	mov    %eax,%ecx
80102333:	83 e1 c0             	and    $0xffffffc0,%ecx
80102336:	80 f9 40             	cmp    $0x40,%cl
80102339:	75 f5                	jne    80102330 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010233b:	a8 21                	test   $0x21,%al
8010233d:	75 12                	jne    80102351 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010233f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102342:	b9 80 00 00 00       	mov    $0x80,%ecx
80102347:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010234c:	fc                   	cld    
8010234d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010234f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102351:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102354:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102357:	83 ce 02             	or     $0x2,%esi
8010235a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010235c:	53                   	push   %ebx
8010235d:	e8 7e 2b 00 00       	call   80104ee0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102362:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102367:	83 c4 10             	add    $0x10,%esp
8010236a:	85 c0                	test   %eax,%eax
8010236c:	74 05                	je     80102373 <ideintr+0x83>
    idestart(idequeue);
8010236e:	e8 1d fe ff ff       	call   80102190 <idestart>
    release(&idelock);
80102373:	83 ec 0c             	sub    $0xc,%esp
80102376:	68 80 b5 10 80       	push   $0x8010b580
8010237b:	e8 a0 30 00 00       	call   80105420 <release>

  release(&idelock);
}
80102380:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102383:	5b                   	pop    %ebx
80102384:	5e                   	pop    %esi
80102385:	5f                   	pop    %edi
80102386:	5d                   	pop    %ebp
80102387:	c3                   	ret    
80102388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop

80102390 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
80102395:	89 e5                	mov    %esp,%ebp
80102397:	53                   	push   %ebx
80102398:	83 ec 10             	sub    $0x10,%esp
8010239b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010239e:	8d 43 0c             	lea    0xc(%ebx),%eax
801023a1:	50                   	push   %eax
801023a2:	e8 d9 2d 00 00       	call   80105180 <holdingsleep>
801023a7:	83 c4 10             	add    $0x10,%esp
801023aa:	85 c0                	test   %eax,%eax
801023ac:	0f 84 cf 00 00 00    	je     80102481 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023b2:	8b 03                	mov    (%ebx),%eax
801023b4:	83 e0 06             	and    $0x6,%eax
801023b7:	83 f8 02             	cmp    $0x2,%eax
801023ba:	0f 84 b4 00 00 00    	je     80102474 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023c0:	8b 53 04             	mov    0x4(%ebx),%edx
801023c3:	85 d2                	test   %edx,%edx
801023c5:	74 0d                	je     801023d4 <iderw+0x44>
801023c7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801023cc:	85 c0                	test   %eax,%eax
801023ce:	0f 84 93 00 00 00    	je     80102467 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 80 b5 10 80       	push   $0x8010b580
801023dc:	e8 7f 2f 00 00       	call   80105360 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023e1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801023e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	85 c0                	test   %eax,%eax
801023f2:	74 6c                	je     80102460 <iderw+0xd0>
801023f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023f8:	89 c2                	mov    %eax,%edx
801023fa:	8b 40 58             	mov    0x58(%eax),%eax
801023fd:	85 c0                	test   %eax,%eax
801023ff:	75 f7                	jne    801023f8 <iderw+0x68>
80102401:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102404:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102406:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010240c:	74 42                	je     80102450 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010240e:	8b 03                	mov    (%ebx),%eax
80102410:	83 e0 06             	and    $0x6,%eax
80102413:	83 f8 02             	cmp    $0x2,%eax
80102416:	74 23                	je     8010243b <iderw+0xab>
80102418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010241f:	90                   	nop
    sleep(b, &idelock);
80102420:	83 ec 08             	sub    $0x8,%esp
80102423:	68 80 b5 10 80       	push   $0x8010b580
80102428:	53                   	push   %ebx
80102429:	e8 f2 28 00 00       	call   80104d20 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010242e:	8b 03                	mov    (%ebx),%eax
80102430:	83 c4 10             	add    $0x10,%esp
80102433:	83 e0 06             	and    $0x6,%eax
80102436:	83 f8 02             	cmp    $0x2,%eax
80102439:	75 e5                	jne    80102420 <iderw+0x90>
  }


  release(&idelock);
8010243b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102442:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102445:	c9                   	leave  
  release(&idelock);
80102446:	e9 d5 2f 00 00       	jmp    80105420 <release>
8010244b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010244f:	90                   	nop
    idestart(b);
80102450:	89 d8                	mov    %ebx,%eax
80102452:	e8 39 fd ff ff       	call   80102190 <idestart>
80102457:	eb b5                	jmp    8010240e <iderw+0x7e>
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102460:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102465:	eb 9d                	jmp    80102404 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102467:	83 ec 0c             	sub    $0xc,%esp
8010246a:	68 0d 83 10 80       	push   $0x8010830d
8010246f:	e8 1c df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	68 f8 82 10 80       	push   $0x801082f8
8010247c:	e8 0f df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102481:	83 ec 0c             	sub    $0xc,%esp
80102484:	68 e2 82 10 80       	push   $0x801082e2
80102489:	e8 02 df ff ff       	call   80100390 <panic>
8010248e:	66 90                	xchg   %ax,%ax

80102490 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102490:	f3 0f 1e fb          	endbr32 
80102494:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102495:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
8010249c:	00 c0 fe 
{
8010249f:	89 e5                	mov    %esp,%ebp
801024a1:	56                   	push   %esi
801024a2:	53                   	push   %ebx
  ioapic->reg = reg;
801024a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024aa:	00 00 00 
  return ioapic->data;
801024ad:	8b 15 54 36 11 80    	mov    0x80113654,%edx
801024b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024bc:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024c2:	0f b6 15 a0 98 11 80 	movzbl 0x801198a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024c9:	c1 ee 10             	shr    $0x10,%esi
801024cc:	89 f0                	mov    %esi,%eax
801024ce:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801024d1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801024d4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024d7:	39 c2                	cmp    %eax,%edx
801024d9:	74 16                	je     801024f1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024db:	83 ec 0c             	sub    $0xc,%esp
801024de:	68 2c 83 10 80       	push   $0x8010832c
801024e3:	e8 c8 e1 ff ff       	call   801006b0 <cprintf>
801024e8:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
801024ee:	83 c4 10             	add    $0x10,%esp
801024f1:	83 c6 21             	add    $0x21,%esi
{
801024f4:	ba 10 00 00 00       	mov    $0x10,%edx
801024f9:	b8 20 00 00 00       	mov    $0x20,%eax
801024fe:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102500:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102502:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102504:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
8010250a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010250d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102513:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102516:	8d 5a 01             	lea    0x1(%edx),%ebx
80102519:	83 c2 02             	add    $0x2,%edx
8010251c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010251e:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102524:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010252b:	39 f0                	cmp    %esi,%eax
8010252d:	75 d1                	jne    80102500 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010252f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102532:	5b                   	pop    %ebx
80102533:	5e                   	pop    %esi
80102534:	5d                   	pop    %ebp
80102535:	c3                   	ret    
80102536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010253d:	8d 76 00             	lea    0x0(%esi),%esi

80102540 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102540:	f3 0f 1e fb          	endbr32 
80102544:	55                   	push   %ebp
  ioapic->reg = reg;
80102545:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
{
8010254b:	89 e5                	mov    %esp,%ebp
8010254d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102550:	8d 50 20             	lea    0x20(%eax),%edx
80102553:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102557:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102559:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010255f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102562:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102565:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102568:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010256a:	a1 54 36 11 80       	mov    0x80113654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010256f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102572:	89 50 10             	mov    %edx,0x10(%eax)
}
80102575:	5d                   	pop    %ebp
80102576:	c3                   	ret    
80102577:	66 90                	xchg   %ax,%ax
80102579:	66 90                	xchg   %ax,%ax
8010257b:	66 90                	xchg   %ax,%ax
8010257d:	66 90                	xchg   %ax,%ax
8010257f:	90                   	nop

80102580 <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(char *v)
{
80102580:	f3 0f 1e fb          	endbr32 
80102584:	55                   	push   %ebp
80102585:	89 e5                	mov    %esp,%ebp
80102587:	56                   	push   %esi
80102588:	53                   	push   %ebx
80102589:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010258c:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  struct run *r;

  if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102592:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102598:	75 3e                	jne    801025d8 <kfree+0x58>
8010259a:	81 fb e8 c5 11 80    	cmp    $0x8011c5e8,%ebx
801025a0:	72 75                	jb     80102617 <kfree+0x97>
801025a2:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
801025a8:	77 5b                	ja     80102605 <kfree+0x85>
      cprintf("physical addr is upper than PHYSTOP");
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025aa:	83 ec 04             	sub    $0x4,%esp
801025ad:	68 00 10 00 00       	push   $0x1000
801025b2:	6a 01                	push   $0x1
801025b4:	53                   	push   %ebx
801025b5:	e8 b6 2e 00 00       	call   80105470 <memset>

  r = (struct run *)v;
  r->next = kmem.freelist;
801025ba:	a1 d8 36 11 80       	mov    0x801136d8,%eax
  kmem.freelist = r;
  lru.num_free_pages++;
}
801025bf:	83 c4 10             	add    $0x10,%esp
  r->next = kmem.freelist;
801025c2:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
801025c4:	89 1d d8 36 11 80    	mov    %ebx,0x801136d8
  lru.num_free_pages++;
801025ca:	83 05 5c 97 11 80 01 	addl   $0x1,0x8011975c
}
801025d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d4:	5b                   	pop    %ebx
801025d5:	5e                   	pop    %esi
801025d6:	5d                   	pop    %ebp
801025d7:	c3                   	ret    
      cprintf("PGROUND Need\n");
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	68 79 83 10 80       	push   $0x80108379
801025e0:	e8 cb e0 ff ff       	call   801006b0 <cprintf>
    if (v < end)
801025e5:	83 c4 10             	add    $0x10,%esp
801025e8:	81 fb e8 c5 11 80    	cmp    $0x8011c5e8,%ebx
801025ee:	72 27                	jb     80102617 <kfree+0x97>
    if (V2P(v) >= PHYSTOP)
801025f0:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
801025f6:	77 0d                	ja     80102605 <kfree+0x85>
    panic("kfree");
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	68 87 83 10 80       	push   $0x80108387
80102600:	e8 8b dd ff ff       	call   80100390 <panic>
      cprintf("physical addr is upper than PHYSTOP");
80102605:	83 ec 0c             	sub    $0xc,%esp
80102608:	68 10 84 10 80       	push   $0x80108410
8010260d:	e8 9e e0 ff ff       	call   801006b0 <cprintf>
80102612:	83 c4 10             	add    $0x10,%esp
80102615:	eb e1                	jmp    801025f8 <kfree+0x78>
      cprintf("virtual addr is under end\n");
80102617:	83 ec 0c             	sub    $0xc,%esp
8010261a:	68 5e 83 10 80       	push   $0x8010835e
8010261f:	e8 8c e0 ff ff       	call   801006b0 <cprintf>
80102624:	83 c4 10             	add    $0x10,%esp
80102627:	eb c7                	jmp    801025f0 <kfree+0x70>
80102629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102630 <freerange>:
{
80102630:	f3 0f 1e fb          	endbr32 
80102634:	55                   	push   %ebp
80102635:	89 e5                	mov    %esp,%ebp
80102637:	56                   	push   %esi
  p = (char *)PGROUNDUP((uint)vstart);
80102638:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010263b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010263e:	53                   	push   %ebx
  p = (char *)PGROUNDUP((uint)vstart);
8010263f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102645:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
8010264b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102651:	39 de                	cmp    %ebx,%esi
80102653:	72 1f                	jb     80102674 <freerange+0x44>
80102655:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102661:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102667:	50                   	push   %eax
80102668:	e8 13 ff ff ff       	call   80102580 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	39 f3                	cmp    %esi,%ebx
80102672:	76 e4                	jbe    80102658 <freerange+0x28>
}
80102674:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102677:	5b                   	pop    %ebx
80102678:	5e                   	pop    %esi
80102679:	5d                   	pop    %ebp
8010267a:	c3                   	ret    
8010267b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010267f:	90                   	nop

80102680 <kinit1>:
{
80102680:	f3 0f 1e fb          	endbr32 
80102684:	55                   	push   %ebp
80102685:	89 e5                	mov    %esp,%ebp
80102687:	56                   	push   %esi
80102688:	53                   	push   %ebx
80102689:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  initlock(&kmem.lock, "kmem");
8010268c:	83 ec 08             	sub    $0x8,%esp
8010268f:	68 8d 83 10 80       	push   $0x8010838d
80102694:	68 a0 36 11 80       	push   $0x801136a0
80102699:	e8 42 2b 00 00       	call   801051e0 <initlock>
  initlock(&lru.lock, "lru");
8010269e:	58                   	pop    %eax
8010269f:	5a                   	pop    %edx
801026a0:	68 92 83 10 80       	push   $0x80108392
801026a5:	68 20 47 11 80       	push   $0x80114720
  kmem.use_lock = 0;
801026aa:	c7 05 d4 36 11 80 00 	movl   $0x0,0x801136d4
801026b1:	00 00 00 
  initlock(&lru.lock, "lru");
801026b4:	e8 27 2b 00 00       	call   801051e0 <initlock>
  initlock(&bitmap.lock, "bitmap");
801026b9:	59                   	pop    %ecx
801026ba:	5e                   	pop    %esi
801026bb:	68 96 83 10 80       	push   $0x80108396
801026c0:	68 e0 36 11 80       	push   $0x801136e0
  lru.use_lock = 0;
801026c5:	c7 05 54 47 11 80 00 	movl   $0x0,0x80114754
801026cc:	00 00 00 
  initlock(&bitmap.lock, "bitmap");
801026cf:	e8 0c 2b 00 00       	call   801051e0 <initlock>
  initlock(&swapout_lock.lock, "swap_control");
801026d4:	58                   	pop    %eax
801026d5:	5a                   	pop    %edx
801026d6:	68 9d 83 10 80       	push   $0x8010839d
801026db:	68 80 97 11 80       	push   $0x80119780
  bitmap.use_lock = 0;
801026e0:	c7 05 14 37 11 80 00 	movl   $0x0,0x80113714
801026e7:	00 00 00 
  initlock(&swapout_lock.lock, "swap_control");
801026ea:	e8 f1 2a 00 00       	call   801051e0 <initlock>
  initlock(&swapout_lock.lock, "swap_control");
801026ef:	59                   	pop    %ecx
801026f0:	5e                   	pop    %esi
801026f1:	68 9d 83 10 80       	push   $0x8010839d
801026f6:	68 80 97 11 80       	push   $0x80119780
  swapout_lock.use_lock = 0;
801026fb:	c7 05 b4 97 11 80 00 	movl   $0x0,0x801197b4
80102702:	00 00 00 
  initlock(&swapout_lock.lock, "swap_control");
80102705:	e8 d6 2a 00 00       	call   801051e0 <initlock>
  if (kmem.use_lock)
8010270a:	a1 d4 36 11 80       	mov    0x801136d4,%eax
8010270f:	83 c4 10             	add    $0x10,%esp
  page_fault_lock.use_lock = 0;
80102712:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102719:	00 00 00 
  if (kmem.use_lock)
8010271c:	85 c0                	test   %eax,%eax
8010271e:	0f 85 d7 00 00 00    	jne    801027fb <kinit1+0x17b>
  if (lru.use_lock)
80102724:	a1 54 47 11 80       	mov    0x80114754,%eax
80102729:	85 c0                	test   %eax,%eax
8010272b:	0f 85 e7 00 00 00    	jne    80102818 <kinit1+0x198>
  if (bitmap.use_lock)
80102731:	8b 35 14 37 11 80    	mov    0x80113714,%esi
80102737:	85 f6                	test   %esi,%esi
80102739:	0f 85 f7 00 00 00    	jne    80102836 <kinit1+0x1b6>
  lru.num_free_pages = 0;
8010273f:	c7 05 5c 97 11 80 00 	movl   $0x0,0x8011975c
80102746:	00 00 00 
  for (int i = 2; i < PGSIZE; i++)
80102749:	b8 02 00 00 00       	mov    $0x2,%eax
  lru.num_lru_pages = 0;
8010274e:	c7 05 60 97 11 80 00 	movl   $0x0,0x80119760
80102755:	00 00 00 
  bitmap.bitmap_arr[0] = 1;
80102758:	c6 05 18 37 11 80 01 	movb   $0x1,0x80113718
  for (int i = 2; i < PGSIZE; i++)
8010275f:	90                   	nop
    bitmap.bitmap_arr[i] = 0;
80102760:	c6 80 18 37 11 80 00 	movb   $0x0,-0x7feec8e8(%eax)
  for (int i = 2; i < PGSIZE; i++)
80102767:	83 c0 01             	add    $0x1,%eax
8010276a:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010276f:	75 ef                	jne    80102760 <kinit1+0xe0>
80102771:	b8 68 47 11 80       	mov    $0x80114768,%eax
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi
    lru.pages[i].use = 0;
80102780:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (int i = 0; i < PHYSTOP / PGSIZE; i++)
80102786:	83 c0 14             	add    $0x14,%eax
80102789:	3d 68 97 11 80       	cmp    $0x80119768,%eax
8010278e:	75 f0                	jne    80102780 <kinit1+0x100>
  if (kmem.use_lock)
80102790:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
80102796:	85 c9                	test   %ecx,%ecx
80102798:	0f 85 d7 00 00 00    	jne    80102875 <kinit1+0x1f5>
  if (lru.use_lock)
8010279e:	8b 15 54 47 11 80    	mov    0x80114754,%edx
801027a4:	85 d2                	test   %edx,%edx
801027a6:	0f 85 b4 00 00 00    	jne    80102860 <kinit1+0x1e0>
  if (bitmap.use_lock)
801027ac:	a1 14 37 11 80       	mov    0x80113714,%eax
801027b1:	85 c0                	test   %eax,%eax
801027b3:	0f 85 92 00 00 00    	jne    8010284b <kinit1+0x1cb>
  p = (char *)PGROUNDUP((uint)vstart);
801027b9:	8b 45 08             	mov    0x8(%ebp),%eax
801027bc:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801027c2:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801027c8:	81 c6 00 10 00 00    	add    $0x1000,%esi
801027ce:	39 f3                	cmp    %esi,%ebx
801027d0:	72 22                	jb     801027f4 <kinit1+0x174>
801027d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kfree(p);
801027d8:	83 ec 0c             	sub    $0xc,%esp
801027db:	8d 86 00 f0 ff ff    	lea    -0x1000(%esi),%eax
801027e1:	81 c6 00 10 00 00    	add    $0x1000,%esi
801027e7:	50                   	push   %eax
801027e8:	e8 93 fd ff ff       	call   80102580 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801027ed:	83 c4 10             	add    $0x10,%esp
801027f0:	39 f3                	cmp    %esi,%ebx
801027f2:	73 e4                	jae    801027d8 <kinit1+0x158>
}
801027f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027f7:	5b                   	pop    %ebx
801027f8:	5e                   	pop    %esi
801027f9:	5d                   	pop    %ebp
801027fa:	c3                   	ret    
    acquire(&kmem.lock);
801027fb:	83 ec 0c             	sub    $0xc,%esp
801027fe:	68 a0 36 11 80       	push   $0x801136a0
80102803:	e8 58 2b 00 00       	call   80105360 <acquire>
  if (lru.use_lock)
80102808:	a1 54 47 11 80       	mov    0x80114754,%eax
    acquire(&kmem.lock);
8010280d:	83 c4 10             	add    $0x10,%esp
  if (lru.use_lock)
80102810:	85 c0                	test   %eax,%eax
80102812:	0f 84 19 ff ff ff    	je     80102731 <kinit1+0xb1>
    acquire(&lru.lock);
80102818:	83 ec 0c             	sub    $0xc,%esp
8010281b:	68 20 47 11 80       	push   $0x80114720
80102820:	e8 3b 2b 00 00       	call   80105360 <acquire>
  if (bitmap.use_lock)
80102825:	8b 35 14 37 11 80    	mov    0x80113714,%esi
    acquire(&lru.lock);
8010282b:	83 c4 10             	add    $0x10,%esp
  if (bitmap.use_lock)
8010282e:	85 f6                	test   %esi,%esi
80102830:	0f 84 09 ff ff ff    	je     8010273f <kinit1+0xbf>
    acquire(&bitmap.lock);
80102836:	83 ec 0c             	sub    $0xc,%esp
80102839:	68 e0 36 11 80       	push   $0x801136e0
8010283e:	e8 1d 2b 00 00       	call   80105360 <acquire>
80102843:	83 c4 10             	add    $0x10,%esp
80102846:	e9 f4 fe ff ff       	jmp    8010273f <kinit1+0xbf>
    release(&bitmap.lock);
8010284b:	83 ec 0c             	sub    $0xc,%esp
8010284e:	68 e0 36 11 80       	push   $0x801136e0
80102853:	e8 c8 2b 00 00       	call   80105420 <release>
80102858:	83 c4 10             	add    $0x10,%esp
8010285b:	e9 59 ff ff ff       	jmp    801027b9 <kinit1+0x139>
    release(&lru.lock);
80102860:	83 ec 0c             	sub    $0xc,%esp
80102863:	68 20 47 11 80       	push   $0x80114720
80102868:	e8 b3 2b 00 00       	call   80105420 <release>
8010286d:	83 c4 10             	add    $0x10,%esp
80102870:	e9 37 ff ff ff       	jmp    801027ac <kinit1+0x12c>
    release(&kmem.lock);
80102875:	83 ec 0c             	sub    $0xc,%esp
80102878:	68 a0 36 11 80       	push   $0x801136a0
8010287d:	e8 9e 2b 00 00       	call   80105420 <release>
80102882:	83 c4 10             	add    $0x10,%esp
80102885:	e9 14 ff ff ff       	jmp    8010279e <kinit1+0x11e>
8010288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102890 <kinit2>:
{
80102890:	f3 0f 1e fb          	endbr32 
80102894:	55                   	push   %ebp
80102895:	89 e5                	mov    %esp,%ebp
80102897:	56                   	push   %esi
  p = (char *)PGROUNDUP((uint)vstart);
80102898:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010289b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010289e:	53                   	push   %ebx
  p = (char *)PGROUNDUP((uint)vstart);
8010289f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028a5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801028ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028b1:	39 de                	cmp    %ebx,%esi
801028b3:	72 1f                	jb     801028d4 <kinit2+0x44>
801028b5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801028b8:	83 ec 0c             	sub    $0xc,%esp
801028bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801028c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028c7:	50                   	push   %eax
801028c8:	e8 b3 fc ff ff       	call   80102580 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801028cd:	83 c4 10             	add    $0x10,%esp
801028d0:	39 de                	cmp    %ebx,%esi
801028d2:	73 e4                	jae    801028b8 <kinit2+0x28>
  kmem.use_lock = 1;
801028d4:	c7 05 d4 36 11 80 01 	movl   $0x1,0x801136d4
801028db:	00 00 00 
  lru.use_lock = 1;
801028de:	c7 05 54 47 11 80 01 	movl   $0x1,0x80114754
801028e5:	00 00 00 
  bitmap.use_lock = 1;
801028e8:	c7 05 14 37 11 80 01 	movl   $0x1,0x80113714
801028ef:	00 00 00 
  swapout_lock.use_lock = 1;
801028f2:	c7 05 b4 97 11 80 01 	movl   $0x1,0x801197b4
801028f9:	00 00 00 
  page_fault_lock.use_lock = 1;
801028fc:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
80102903:	00 00 00 
}
80102906:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102909:	5b                   	pop    %ebx
8010290a:	5e                   	pop    %esi
8010290b:	5d                   	pop    %ebp
8010290c:	c3                   	ret    
8010290d:	8d 76 00             	lea    0x0(%esi),%esi

80102910 <lru_print>:
  }

  return (char *)r;
}
void lru_print(void)
{
80102910:	f3 0f 1e fb          	endbr32 
80102914:	55                   	push   %ebp
80102915:	89 e5                	mov    %esp,%ebp
80102917:	56                   	push   %esi
  struct page *p_page;
  pte_t *pte;
  int pte_n_a = 0;
  if (kmem.use_lock)
80102918:	8b 35 d4 36 11 80    	mov    0x801136d4,%esi
{
8010291e:	53                   	push   %ebx
  if (kmem.use_lock)
8010291f:	85 f6                	test   %esi,%esi
80102921:	0f 85 b9 00 00 00    	jne    801029e0 <lru_print+0xd0>
    acquire(&kmem.lock);
  if (lru.use_lock)
80102927:	8b 1d 54 47 11 80    	mov    0x80114754,%ebx
8010292d:	85 db                	test   %ebx,%ebx
8010292f:	0f 85 c9 00 00 00    	jne    801029fe <lru_print+0xee>
    acquire(&lru.lock);

  p_page = lru.page_lru_head;
  for (int i = 0; i < lru.num_lru_pages; i++)
80102935:	8b 0d 60 97 11 80    	mov    0x80119760,%ecx
  p_page = lru.page_lru_head;
8010293b:	8b 1d 58 97 11 80    	mov    0x80119758,%ebx
  for (int i = 0; i < lru.num_lru_pages; i++)
80102941:	85 c9                	test   %ecx,%ecx
80102943:	7e 7a                	jle    801029bf <lru_print+0xaf>
80102945:	31 f6                	xor    %esi,%esi
80102947:	eb 31                	jmp    8010297a <lru_print+0x6a>
80102949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    // pte_n_a = *pte & PTE_A;
    if (p_page->vaddr == 0)
      cprintf("LRU entry %d, pgdir : %x, vaddr : 0000, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);

    else
      cprintf("LRU entry %d, pgdir : %x, vaddr : %x, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);
80102950:	83 ec 04             	sub    $0x4,%esp
80102953:	ff 30                	pushl  (%eax)
80102955:	6a 00                	push   $0x0
80102957:	ff 73 10             	pushl  0x10(%ebx)
8010295a:	52                   	push   %edx
8010295b:	ff 73 08             	pushl  0x8(%ebx)
8010295e:	56                   	push   %esi
  for (int i = 0; i < lru.num_lru_pages; i++)
8010295f:	83 c6 01             	add    $0x1,%esi
      cprintf("LRU entry %d, pgdir : %x, vaddr : %x, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);
80102962:	68 7c 84 10 80       	push   $0x8010847c
80102967:	e8 44 dd ff ff       	call   801006b0 <cprintf>
    p_page = p_page->prev;
8010296c:	8b 5b 04             	mov    0x4(%ebx),%ebx
      cprintf("LRU entry %d, pgdir : %x, vaddr : %x, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);
8010296f:	83 c4 20             	add    $0x20,%esp
  for (int i = 0; i < lru.num_lru_pages; i++)
80102972:	39 35 60 97 11 80    	cmp    %esi,0x80119760
80102978:	7e 45                	jle    801029bf <lru_print+0xaf>
    pte = walkpgdir(p_page->pgdir, p_page->vaddr, 0);
8010297a:	83 ec 04             	sub    $0x4,%esp
8010297d:	6a 00                	push   $0x0
8010297f:	ff 73 0c             	pushl  0xc(%ebx)
80102982:	ff 73 08             	pushl  0x8(%ebx)
80102985:	e8 06 4e 00 00       	call   80107790 <walkpgdir>
    if (p_page->vaddr == 0)
8010298a:	8b 53 0c             	mov    0xc(%ebx),%edx
8010298d:	83 c4 10             	add    $0x10,%esp
80102990:	85 d2                	test   %edx,%edx
80102992:	75 bc                	jne    80102950 <lru_print+0x40>
      cprintf("LRU entry %d, pgdir : %x, vaddr : 0000, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);
80102994:	83 ec 04             	sub    $0x4,%esp
80102997:	ff 30                	pushl  (%eax)
80102999:	6a 00                	push   $0x0
8010299b:	ff 73 10             	pushl  0x10(%ebx)
8010299e:	6a 00                	push   $0x0
801029a0:	ff 73 08             	pushl  0x8(%ebx)
801029a3:	56                   	push   %esi
  for (int i = 0; i < lru.num_lru_pages; i++)
801029a4:	83 c6 01             	add    $0x1,%esi
      cprintf("LRU entry %d, pgdir : %x, vaddr : 0000, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);
801029a7:	68 34 84 10 80       	push   $0x80108434
801029ac:	e8 ff dc ff ff       	call   801006b0 <cprintf>
    p_page = p_page->prev;
801029b1:	8b 5b 04             	mov    0x4(%ebx),%ebx
801029b4:	83 c4 20             	add    $0x20,%esp
  for (int i = 0; i < lru.num_lru_pages; i++)
801029b7:	39 35 60 97 11 80    	cmp    %esi,0x80119760
801029bd:	7f bb                	jg     8010297a <lru_print+0x6a>
  }
  if (kmem.use_lock)
801029bf:	8b 15 d4 36 11 80    	mov    0x801136d4,%edx
801029c5:	85 d2                	test   %edx,%edx
801029c7:	75 67                	jne    80102a30 <lru_print+0x120>
    release(&kmem.lock);
  if (lru.use_lock)
801029c9:	a1 54 47 11 80       	mov    0x80114754,%eax
801029ce:	85 c0                	test   %eax,%eax
801029d0:	75 46                	jne    80102a18 <lru_print+0x108>
    release(&lru.lock);
}
801029d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029d5:	5b                   	pop    %ebx
801029d6:	5e                   	pop    %esi
801029d7:	5d                   	pop    %ebp
801029d8:	c3                   	ret    
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801029e0:	83 ec 0c             	sub    $0xc,%esp
801029e3:	68 a0 36 11 80       	push   $0x801136a0
801029e8:	e8 73 29 00 00       	call   80105360 <acquire>
  if (lru.use_lock)
801029ed:	8b 1d 54 47 11 80    	mov    0x80114754,%ebx
    acquire(&kmem.lock);
801029f3:	83 c4 10             	add    $0x10,%esp
  if (lru.use_lock)
801029f6:	85 db                	test   %ebx,%ebx
801029f8:	0f 84 37 ff ff ff    	je     80102935 <lru_print+0x25>
    acquire(&lru.lock);
801029fe:	83 ec 0c             	sub    $0xc,%esp
80102a01:	68 20 47 11 80       	push   $0x80114720
80102a06:	e8 55 29 00 00       	call   80105360 <acquire>
80102a0b:	83 c4 10             	add    $0x10,%esp
80102a0e:	e9 22 ff ff ff       	jmp    80102935 <lru_print+0x25>
80102a13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a17:	90                   	nop
    release(&lru.lock);
80102a18:	83 ec 0c             	sub    $0xc,%esp
80102a1b:	68 20 47 11 80       	push   $0x80114720
80102a20:	e8 fb 29 00 00       	call   80105420 <release>
80102a25:	83 c4 10             	add    $0x10,%esp
}
80102a28:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a2b:	5b                   	pop    %ebx
80102a2c:	5e                   	pop    %esi
80102a2d:	5d                   	pop    %ebp
80102a2e:	c3                   	ret    
80102a2f:	90                   	nop
    release(&kmem.lock);
80102a30:	83 ec 0c             	sub    $0xc,%esp
80102a33:	68 a0 36 11 80       	push   $0x801136a0
80102a38:	e8 e3 29 00 00       	call   80105420 <release>
80102a3d:	83 c4 10             	add    $0x10,%esp
80102a40:	eb 87                	jmp    801029c9 <lru_print+0xb9>
80102a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a50 <page_insert>:

void page_insert(pde_t *pgdir, uint vaddr)
{
80102a50:	f3 0f 1e fb          	endbr32 
80102a54:	55                   	push   %ebp
80102a55:	89 e5                	mov    %esp,%ebp
80102a57:	57                   	push   %edi
80102a58:	56                   	push   %esi
80102a59:	53                   	push   %ebx
80102a5a:	83 ec 1c             	sub    $0x1c,%esp
  // cprintf("================Page insert start================\n");
  struct page *new_page, *next_page;
  // lru entry insert
  if (kmem.use_lock)
80102a5d:	a1 d4 36 11 80       	mov    0x801136d4,%eax
{
80102a62:	8b 7d 08             	mov    0x8(%ebp),%edi
80102a65:	8b 75 0c             	mov    0xc(%ebp),%esi
  if (kmem.use_lock)
80102a68:	85 c0                	test   %eax,%eax
80102a6a:	0f 85 08 02 00 00    	jne    80102c78 <page_insert+0x228>
    acquire(&kmem.lock);
  if (lru.use_lock)
80102a70:	8b 1d 54 47 11 80    	mov    0x80114754,%ebx
80102a76:	85 db                	test   %ebx,%ebx
80102a78:	0f 85 e2 01 00 00    	jne    80102c60 <page_insert+0x210>
    acquire(&lru.lock);
  if (bitmap.use_lock)
80102a7e:	8b 0d 14 37 11 80    	mov    0x80113714,%ecx
80102a84:	85 c9                	test   %ecx,%ecx
80102a86:	0f 85 bc 01 00 00    	jne    80102c48 <page_insert+0x1f8>
    acquire(&bitmap.lock);

  for (int i = 0; i < (PHYSTOP / PGSIZE); i++)
80102a8c:	b8 68 47 11 80       	mov    $0x80114768,%eax
80102a91:	31 db                	xor    %ebx,%ebx
80102a93:	eb 15                	jmp    80102aaa <page_insert+0x5a>
80102a95:	8d 76 00             	lea    0x0(%esi),%esi
80102a98:	83 c3 01             	add    $0x1,%ebx
80102a9b:	83 c0 14             	add    $0x14,%eax
80102a9e:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80102aa4:	0f 84 26 02 00 00    	je     80102cd0 <page_insert+0x280>
  {
    // search not using page
    new_page = &lru.pages[i];
    if (new_page->use == 0)
80102aaa:	8b 10                	mov    (%eax),%edx
80102aac:	85 d2                	test   %edx,%edx
80102aae:	75 e8                	jne    80102a98 <page_insert+0x48>
    new_page = &lru.pages[i];
80102ab0:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
    {
      break;
    }
  }

  if (lru.num_lru_pages == 0)
80102ab3:	8b 0d 60 97 11 80    	mov    0x80119760,%ecx
    new_page = &lru.pages[i];
80102ab9:	c1 e0 02             	shl    $0x2,%eax
80102abc:	8d 90 58 47 11 80    	lea    -0x7feeb8a8(%eax),%edx
80102ac2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  if (lru.num_lru_pages == 0)
80102ac5:	85 c9                	test   %ecx,%ecx
80102ac7:	75 57                	jne    80102b20 <page_insert+0xd0>
  {
    // case of first lru entry
    lru.page_lru_head = new_page;
80102ac9:	89 15 58 97 11 80    	mov    %edx,0x80119758
    lru.page_lru_head->prev = new_page;
80102acf:	89 90 5c 47 11 80    	mov    %edx,-0x7feeb8a4(%eax)
    lru.page_lru_head->next = new_page;
80102ad5:	89 90 58 47 11 80    	mov    %edx,-0x7feeb8a8(%eax)

    // page entry setting
    lru.num_lru_pages++;
80102adb:	c7 05 60 97 11 80 01 	movl   $0x1,0x80119760
80102ae2:	00 00 00 
    new_page->pgdir = pgdir;
80102ae5:	89 b8 60 47 11 80    	mov    %edi,-0x7feeb8a0(%eax)
    new_page->vaddr = (char *)vaddr;
80102aeb:	89 b0 64 47 11 80    	mov    %esi,-0x7feeb89c(%eax)
    new_page->use = 1;
80102af1:	c7 80 68 47 11 80 01 	movl   $0x1,-0x7feeb898(%eax)
80102af8:	00 00 00 
    if (vaddr == 0)
80102afb:	85 f6                	test   %esi,%esi
80102afd:	0f 85 e5 00 00 00    	jne    80102be8 <page_insert+0x198>
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : 0000, ", lru.num_lru_pages, new_page->pgdir);
80102b03:	83 ec 04             	sub    $0x4,%esp
80102b06:	57                   	push   %edi
80102b07:	6a 01                	push   $0x1
80102b09:	68 c4 84 10 80       	push   $0x801084c4
80102b0e:	e8 9d db ff ff       	call   801006b0 <cprintf>
80102b13:	83 c4 10             	add    $0x10,%esp
80102b16:	eb 7d                	jmp    80102b95 <page_insert+0x145>
80102b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1f:	90                   	nop
    else
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", lru.num_lru_pages, new_page->pgdir, new_page->vaddr);
  }
  else if (lru.num_lru_pages == 1)
80102b20:	8b 15 58 97 11 80    	mov    0x80119758,%edx
80102b26:	83 f9 01             	cmp    $0x1,%ecx
80102b29:	0f 84 79 01 00 00    	je     80102ca8 <page_insert+0x258>
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", lru.num_lru_pages, new_page->pgdir, new_page->vaddr);
  }
  else
  {
    // case of above third lru entry
    next_page = lru.page_lru_head->next;
80102b2f:	8b 0a                	mov    (%edx),%ecx
80102b31:	89 4d e0             	mov    %ecx,-0x20(%ebp)

    lru.page_lru_head->next = new_page;
80102b34:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102b37:	89 0a                	mov    %ecx,(%edx)
    new_page->prev = lru.page_lru_head;
80102b39:	8b 15 58 97 11 80    	mov    0x80119758,%edx
80102b3f:	89 90 5c 47 11 80    	mov    %edx,-0x7feeb8a4(%eax)

    new_page->next = next_page;
80102b45:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102b48:	89 90 58 47 11 80    	mov    %edx,-0x7feeb8a8(%eax)
    next_page->prev = new_page;
80102b4e:	89 ca                	mov    %ecx,%edx
80102b50:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80102b53:	89 51 04             	mov    %edx,0x4(%ecx)

    lru.num_lru_pages++;
80102b56:	8b 0d 60 97 11 80    	mov    0x80119760,%ecx
    // page entry setting
    new_page->pgdir = pgdir;
80102b5c:	89 b8 60 47 11 80    	mov    %edi,-0x7feeb8a0(%eax)
    new_page->vaddr = (char *)vaddr;
80102b62:	89 b0 64 47 11 80    	mov    %esi,-0x7feeb89c(%eax)
    new_page->use = 1;
80102b68:	c7 80 68 47 11 80 01 	movl   $0x1,-0x7feeb898(%eax)
80102b6f:	00 00 00 
    lru.num_lru_pages++;
80102b72:	8d 51 01             	lea    0x1(%ecx),%edx
80102b75:	89 15 60 97 11 80    	mov    %edx,0x80119760
    if (vaddr == 0)
80102b7b:	85 f6                	test   %esi,%esi
80102b7d:	0f 85 0d 01 00 00    	jne    80102c90 <page_insert+0x240>
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : 0000, ", lru.num_lru_pages, new_page->pgdir);
80102b83:	83 ec 04             	sub    $0x4,%esp
80102b86:	57                   	push   %edi
80102b87:	52                   	push   %edx
80102b88:	68 c4 84 10 80       	push   $0x801084c4
80102b8d:	e8 1e db ff ff       	call   801006b0 <cprintf>
80102b92:	83 c4 10             	add    $0x10,%esp
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", lru.num_lru_pages, new_page->pgdir, new_page->vaddr);
  }
  // cprintf("====lru entry top====\n");
  // lru_print();
  // cprintf("====lru entry bottom====\n");
  cprintf("PTE : %x\n", walkpgdir(new_page->pgdir, new_page->vaddr, 0));
80102b95:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
80102b98:	83 ec 04             	sub    $0x4,%esp
80102b9b:	8d 04 85 20 47 11 80 	lea    -0x7feeb8e0(,%eax,4),%eax
80102ba2:	6a 00                	push   $0x0
80102ba4:	ff 70 44             	pushl  0x44(%eax)
80102ba7:	ff 70 40             	pushl  0x40(%eax)
80102baa:	e8 e1 4b 00 00       	call   80107790 <walkpgdir>
80102baf:	59                   	pop    %ecx
80102bb0:	5b                   	pop    %ebx
80102bb1:	50                   	push   %eax
80102bb2:	68 aa 83 10 80       	push   $0x801083aa
80102bb7:	e8 f4 da ff ff       	call   801006b0 <cprintf>

  // cprintf("================Page insert finished================\n");
  if (kmem.use_lock)
80102bbc:	8b 35 d4 36 11 80    	mov    0x801136d4,%esi
80102bc2:	83 c4 10             	add    $0x10,%esp
80102bc5:	85 f6                	test   %esi,%esi
80102bc7:	75 67                	jne    80102c30 <page_insert+0x1e0>
    release(&kmem.lock);
  if (lru.use_lock)
80102bc9:	8b 15 54 47 11 80    	mov    0x80114754,%edx
80102bcf:	85 d2                	test   %edx,%edx
80102bd1:	75 45                	jne    80102c18 <page_insert+0x1c8>
    release(&lru.lock);
  if (bitmap.use_lock)
80102bd3:	a1 14 37 11 80       	mov    0x80113714,%eax
80102bd8:	85 c0                	test   %eax,%eax
80102bda:	75 24                	jne    80102c00 <page_insert+0x1b0>
    release(&bitmap.lock);
}
80102bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bdf:	5b                   	pop    %ebx
80102be0:	5e                   	pop    %esi
80102be1:	5f                   	pop    %edi
80102be2:	5d                   	pop    %ebp
80102be3:	c3                   	ret    
80102be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", lru.num_lru_pages, new_page->pgdir, new_page->vaddr);
80102be8:	56                   	push   %esi
80102be9:	57                   	push   %edi
80102bea:	6a 01                	push   $0x1
80102bec:	68 04 85 10 80       	push   $0x80108504
80102bf1:	e8 ba da ff ff       	call   801006b0 <cprintf>
80102bf6:	83 c4 10             	add    $0x10,%esp
80102bf9:	eb 9a                	jmp    80102b95 <page_insert+0x145>
80102bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bff:	90                   	nop
    release(&bitmap.lock);
80102c00:	c7 45 08 e0 36 11 80 	movl   $0x801136e0,0x8(%ebp)
}
80102c07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c0a:	5b                   	pop    %ebx
80102c0b:	5e                   	pop    %esi
80102c0c:	5f                   	pop    %edi
80102c0d:	5d                   	pop    %ebp
    release(&bitmap.lock);
80102c0e:	e9 0d 28 00 00       	jmp    80105420 <release>
80102c13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c17:	90                   	nop
    release(&lru.lock);
80102c18:	83 ec 0c             	sub    $0xc,%esp
80102c1b:	68 20 47 11 80       	push   $0x80114720
80102c20:	e8 fb 27 00 00       	call   80105420 <release>
80102c25:	83 c4 10             	add    $0x10,%esp
80102c28:	eb a9                	jmp    80102bd3 <page_insert+0x183>
80102c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102c30:	83 ec 0c             	sub    $0xc,%esp
80102c33:	68 a0 36 11 80       	push   $0x801136a0
80102c38:	e8 e3 27 00 00       	call   80105420 <release>
80102c3d:	83 c4 10             	add    $0x10,%esp
80102c40:	eb 87                	jmp    80102bc9 <page_insert+0x179>
80102c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&bitmap.lock);
80102c48:	83 ec 0c             	sub    $0xc,%esp
80102c4b:	68 e0 36 11 80       	push   $0x801136e0
80102c50:	e8 0b 27 00 00       	call   80105360 <acquire>
80102c55:	83 c4 10             	add    $0x10,%esp
80102c58:	e9 2f fe ff ff       	jmp    80102a8c <page_insert+0x3c>
80102c5d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&lru.lock);
80102c60:	83 ec 0c             	sub    $0xc,%esp
80102c63:	68 20 47 11 80       	push   $0x80114720
80102c68:	e8 f3 26 00 00       	call   80105360 <acquire>
80102c6d:	83 c4 10             	add    $0x10,%esp
80102c70:	e9 09 fe ff ff       	jmp    80102a7e <page_insert+0x2e>
80102c75:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102c78:	83 ec 0c             	sub    $0xc,%esp
80102c7b:	68 a0 36 11 80       	push   $0x801136a0
80102c80:	e8 db 26 00 00       	call   80105360 <acquire>
80102c85:	83 c4 10             	add    $0x10,%esp
80102c88:	e9 e3 fd ff ff       	jmp    80102a70 <page_insert+0x20>
80102c8d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", lru.num_lru_pages, new_page->pgdir, new_page->vaddr);
80102c90:	56                   	push   %esi
80102c91:	57                   	push   %edi
80102c92:	52                   	push   %edx
80102c93:	68 04 85 10 80       	push   $0x80108504
80102c98:	e8 13 da ff ff       	call   801006b0 <cprintf>
80102c9d:	83 c4 10             	add    $0x10,%esp
80102ca0:	e9 f0 fe ff ff       	jmp    80102b95 <page_insert+0x145>
80102ca5:	8d 76 00             	lea    0x0(%esi),%esi
    lru.page_lru_head->next = new_page;
80102ca8:	89 d1                	mov    %edx,%ecx
80102caa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102cad:	89 11                	mov    %edx,(%ecx)
    lru.page_lru_head->prev = new_page;
80102caf:	8b 0d 58 97 11 80    	mov    0x80119758,%ecx
80102cb5:	89 51 04             	mov    %edx,0x4(%ecx)
    new_page->prev = lru.page_lru_head;
80102cb8:	8b 15 58 97 11 80    	mov    0x80119758,%edx
80102cbe:	89 90 5c 47 11 80    	mov    %edx,-0x7feeb8a4(%eax)
    new_page->next = lru.page_lru_head;
80102cc4:	89 90 58 47 11 80    	mov    %edx,-0x7feeb8a8(%eax)
    lru.num_lru_pages++;
80102cca:	e9 87 fe ff ff       	jmp    80102b56 <page_insert+0x106>
80102ccf:	90                   	nop
80102cd0:	bb ff 03 00 00       	mov    $0x3ff,%ebx
80102cd5:	e9 d6 fd ff ff       	jmp    80102ab0 <page_insert+0x60>
80102cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ce0 <page_delete>:

int page_delete(pde_t *pgdir, char *vaddr)
{
80102ce0:	f3 0f 1e fb          	endbr32 
80102ce4:	55                   	push   %ebp
80102ce5:	89 e5                	mov    %esp,%ebp
80102ce7:	57                   	push   %edi
80102ce8:	56                   	push   %esi
80102ce9:	53                   	push   %ebx
80102cea:	83 ec 1c             	sub    $0x1c,%esp
  struct page *p_page, *temp_head, *f_page, *b_page;
  // cprintf("================Page delete start================\n");
  if (kmem.use_lock)
80102ced:	a1 d4 36 11 80       	mov    0x801136d4,%eax
{
80102cf2:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102cf5:	8b 75 0c             	mov    0xc(%ebp),%esi
  if (kmem.use_lock)
80102cf8:	85 c0                	test   %eax,%eax
80102cfa:	0f 85 28 01 00 00    	jne    80102e28 <page_delete+0x148>
    acquire(&kmem.lock);
  if (lru.use_lock)
80102d00:	8b 3d 54 47 11 80    	mov    0x80114754,%edi
80102d06:	85 ff                	test   %edi,%edi
80102d08:	0f 85 02 01 00 00    	jne    80102e10 <page_delete+0x130>
    acquire(&lru.lock);

  temp_head = lru.page_lru_head;
80102d0e:	a1 58 97 11 80       	mov    0x80119758,%eax
  // cprintf("page delete target | pgdir : %x | vaddr : %x\n", pgdir, vaddr);
  for (int i = 0; i < lru.num_lru_pages; i++) // search lru with vaddr, pgdir
80102d13:	8b 3d 60 97 11 80    	mov    0x80119760,%edi
80102d19:	31 d2                	xor    %edx,%edx
  temp_head = lru.page_lru_head;
80102d1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for (int i = 0; i < lru.num_lru_pages; i++) // search lru with vaddr, pgdir
80102d1e:	85 ff                	test   %edi,%edi
80102d20:	7f 21                	jg     80102d43 <page_delete+0x63>
80102d22:	e9 a9 00 00 00       	jmp    80102dd0 <page_delete+0xf0>
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax

      return 0;
    }
    else
    {
      lru.page_lru_head = lru.page_lru_head->prev;
80102d30:	8b 40 04             	mov    0x4(%eax),%eax
  for (int i = 0; i < lru.num_lru_pages; i++) // search lru with vaddr, pgdir
80102d33:	83 c2 01             	add    $0x1,%edx
      lru.page_lru_head = lru.page_lru_head->prev;
80102d36:	a3 58 97 11 80       	mov    %eax,0x80119758
  for (int i = 0; i < lru.num_lru_pages; i++) // search lru with vaddr, pgdir
80102d3b:	39 fa                	cmp    %edi,%edx
80102d3d:	0f 84 8d 00 00 00    	je     80102dd0 <page_delete+0xf0>
    if ((p_page->pgdir == pgdir) && (PTE_ADDR(p_page->vaddr) == (uint)vaddr))
80102d43:	39 58 08             	cmp    %ebx,0x8(%eax)
80102d46:	75 e8                	jne    80102d30 <page_delete+0x50>
80102d48:	8b 48 0c             	mov    0xc(%eax),%ecx
80102d4b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80102d51:	39 ce                	cmp    %ecx,%esi
80102d53:	75 db                	jne    80102d30 <page_delete+0x50>
      f_page = p_page->prev;
80102d55:	8b 48 04             	mov    0x4(%eax),%ecx
      b_page = p_page->next;
80102d58:	8b 10                	mov    (%eax),%edx
      f_page->next = b_page;
80102d5a:	89 11                	mov    %edx,(%ecx)
      b_page->prev = f_page;
80102d5c:	89 4a 04             	mov    %ecx,0x4(%edx)
      p_page->use = 0;
80102d5f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
      lru.num_lru_pages--;
80102d66:	8b 3d 60 97 11 80    	mov    0x80119760,%edi
80102d6c:	8d 57 ff             	lea    -0x1(%edi),%edx
      lru.page_lru_head = temp_head->prev;
80102d6f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      lru.num_lru_pages--;
80102d72:	89 15 60 97 11 80    	mov    %edx,0x80119760
      lru.page_lru_head = temp_head->prev;
80102d78:	8b 4f 04             	mov    0x4(%edi),%ecx
80102d7b:	89 0d 58 97 11 80    	mov    %ecx,0x80119758
      if (vaddr == 0)
80102d81:	85 f6                	test   %esi,%esi
80102d83:	0f 84 ec 00 00 00    	je     80102e75 <page_delete+0x195>
        cprintf("Page Delete | num_lru_pages : %d, pgdir : %x, vaddr : %x\n", lru.num_lru_pages, p_page->pgdir, p_page->vaddr);
80102d89:	ff 70 0c             	pushl  0xc(%eax)
80102d8c:	ff 70 08             	pushl  0x8(%eax)
80102d8f:	52                   	push   %edx
80102d90:	68 b0 85 10 80       	push   $0x801085b0
80102d95:	e8 16 d9 ff ff       	call   801006b0 <cprintf>
80102d9a:	83 c4 10             	add    $0x10,%esp
      if (kmem.use_lock)
80102d9d:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
80102da3:	85 c9                	test   %ecx,%ecx
80102da5:	0f 85 e3 00 00 00    	jne    80102e8e <page_delete+0x1ae>
      if (lru.use_lock)
80102dab:	a1 54 47 11 80       	mov    0x80114754,%eax
80102db0:	85 c0                	test   %eax,%eax
80102db2:	74 52                	je     80102e06 <page_delete+0x126>
        release(&lru.lock);
80102db4:	83 ec 0c             	sub    $0xc,%esp
80102db7:	68 20 47 11 80       	push   $0x80114720
80102dbc:	e8 5f 26 00 00       	call   80105420 <release>
80102dc1:	83 c4 10             	add    $0x10,%esp
      return 0;
80102dc4:	31 c0                	xor    %eax,%eax
80102dc6:	eb 3e                	jmp    80102e06 <page_delete+0x126>
80102dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcf:	90                   	nop
    }
  }
  // cprintf("=================================LRU linked list TOP=================================\n");
  cprintf("Page delete target, pgdir : %x, vaddr : %x, PTE\n", pgdir, vaddr, *walkpgdir(pgdir, vaddr, 0));
80102dd0:	83 ec 04             	sub    $0x4,%esp
80102dd3:	6a 00                	push   $0x0
80102dd5:	56                   	push   %esi
80102dd6:	53                   	push   %ebx
80102dd7:	e8 b4 49 00 00       	call   80107790 <walkpgdir>
80102ddc:	ff 30                	pushl  (%eax)
80102dde:	56                   	push   %esi
80102ddf:	53                   	push   %ebx
80102de0:	68 40 85 10 80       	push   $0x80108540
80102de5:	e8 c6 d8 ff ff       	call   801006b0 <cprintf>
  if (kmem.use_lock)
80102dea:	8b 1d d4 36 11 80    	mov    0x801136d4,%ebx
80102df0:	83 c4 20             	add    $0x20,%esp
80102df3:	85 db                	test   %ebx,%ebx
80102df5:	75 69                	jne    80102e60 <page_delete+0x180>
    release(&kmem.lock);
  if (lru.use_lock)
80102df7:	8b 15 54 47 11 80    	mov    0x80114754,%edx
  // for (int i = 0; i < PGSIZE; i++)
  // {
  //   cprintf("Bitmap[%d] : %x\n", i, bitmap[i]);
  // }

  return -1;
80102dfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if (lru.use_lock)
80102e02:	85 d2                	test   %edx,%edx
80102e04:	75 3a                	jne    80102e40 <page_delete+0x160>
}
80102e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e09:	5b                   	pop    %ebx
80102e0a:	5e                   	pop    %esi
80102e0b:	5f                   	pop    %edi
80102e0c:	5d                   	pop    %ebp
80102e0d:	c3                   	ret    
80102e0e:	66 90                	xchg   %ax,%ax
    acquire(&lru.lock);
80102e10:	83 ec 0c             	sub    $0xc,%esp
80102e13:	68 20 47 11 80       	push   $0x80114720
80102e18:	e8 43 25 00 00       	call   80105360 <acquire>
80102e1d:	83 c4 10             	add    $0x10,%esp
80102e20:	e9 e9 fe ff ff       	jmp    80102d0e <page_delete+0x2e>
80102e25:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102e28:	83 ec 0c             	sub    $0xc,%esp
80102e2b:	68 a0 36 11 80       	push   $0x801136a0
80102e30:	e8 2b 25 00 00       	call   80105360 <acquire>
80102e35:	83 c4 10             	add    $0x10,%esp
80102e38:	e9 c3 fe ff ff       	jmp    80102d00 <page_delete+0x20>
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&lru.lock);
80102e40:	83 ec 0c             	sub    $0xc,%esp
80102e43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102e46:	68 20 47 11 80       	push   $0x80114720
80102e4b:	e8 d0 25 00 00       	call   80105420 <release>
80102e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102e53:	83 c4 10             	add    $0x10,%esp
}
80102e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e59:	5b                   	pop    %ebx
80102e5a:	5e                   	pop    %esi
80102e5b:	5f                   	pop    %edi
80102e5c:	5d                   	pop    %ebp
80102e5d:	c3                   	ret    
80102e5e:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
80102e60:	83 ec 0c             	sub    $0xc,%esp
80102e63:	68 a0 36 11 80       	push   $0x801136a0
80102e68:	e8 b3 25 00 00       	call   80105420 <release>
80102e6d:	83 c4 10             	add    $0x10,%esp
80102e70:	e9 82 ff ff ff       	jmp    80102df7 <page_delete+0x117>
        cprintf("Page Delete | num_lru_pages : %d, pgdir : %x, vaddr : 0000\n", lru.num_lru_pages, p_page->pgdir);
80102e75:	83 ec 04             	sub    $0x4,%esp
80102e78:	ff 70 08             	pushl  0x8(%eax)
80102e7b:	52                   	push   %edx
80102e7c:	68 74 85 10 80       	push   $0x80108574
80102e81:	e8 2a d8 ff ff       	call   801006b0 <cprintf>
80102e86:	83 c4 10             	add    $0x10,%esp
80102e89:	e9 0f ff ff ff       	jmp    80102d9d <page_delete+0xbd>
        release(&kmem.lock);
80102e8e:	83 ec 0c             	sub    $0xc,%esp
80102e91:	68 a0 36 11 80       	push   $0x801136a0
80102e96:	e8 85 25 00 00       	call   80105420 <release>
80102e9b:	83 c4 10             	add    $0x10,%esp
80102e9e:	e9 08 ff ff ff       	jmp    80102dab <page_delete+0xcb>
80102ea3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102eb0 <bitmap_modify>:

  panic("swap out err not found zero page");
}

void bitmap_modify(int bitmap_offset, int set)
{
80102eb0:	f3 0f 1e fb          	endbr32 
80102eb4:	55                   	push   %ebp
80102eb5:	89 e5                	mov    %esp,%ebp
80102eb7:	57                   	push   %edi
80102eb8:	56                   	push   %esi
80102eb9:	53                   	push   %ebx
80102eba:	83 ec 0c             	sub    $0xc,%esp
  if (kmem.use_lock)
80102ebd:	a1 d4 36 11 80       	mov    0x801136d4,%eax
{
80102ec2:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ec5:	8b 75 0c             	mov    0xc(%ebp),%esi
  if (kmem.use_lock)
80102ec8:	85 c0                	test   %eax,%eax
80102eca:	0f 85 90 00 00 00    	jne    80102f60 <bitmap_modify+0xb0>
    acquire(&kmem.lock);
  if (lru.use_lock)
80102ed0:	a1 54 47 11 80       	mov    0x80114754,%eax
80102ed5:	85 c0                	test   %eax,%eax
80102ed7:	0f 85 a0 00 00 00    	jne    80102f7d <bitmap_modify+0xcd>
    acquire(&lru.lock);
  if (bitmap.use_lock)
80102edd:	8b 3d 14 37 11 80    	mov    0x80113714,%edi
80102ee3:	85 ff                	test   %edi,%edi
80102ee5:	0f 85 b0 00 00 00    	jne    80102f9b <bitmap_modify+0xeb>
    acquire(&bitmap.lock);

  if (set == 0) // unset
80102eeb:	85 db                	test   %ebx,%ebx
80102eed:	8d 43 07             	lea    0x7(%ebx),%eax
80102ef0:	89 df                	mov    %ebx,%edi
80102ef2:	0f 49 c3             	cmovns %ebx,%eax
80102ef5:	c1 ff 1f             	sar    $0x1f,%edi
80102ef8:	c1 ef 1d             	shr    $0x1d,%edi
80102efb:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
80102efe:	c1 f8 03             	sar    $0x3,%eax
80102f01:	bb 01 00 00 00       	mov    $0x1,%ebx
80102f06:	83 e1 07             	and    $0x7,%ecx
80102f09:	0f b6 90 18 37 11 80 	movzbl -0x7feec8e8(%eax),%edx
80102f10:	29 f9                	sub    %edi,%ecx
80102f12:	d3 e3                	shl    %cl,%ebx
80102f14:	89 d9                	mov    %ebx,%ecx
  {
    bitmap.bitmap_arr[bitmap_offset / 8] = bitmap.bitmap_arr[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102f16:	89 d3                	mov    %edx,%ebx
80102f18:	09 cb                	or     %ecx,%ebx
80102f1a:	f7 d1                	not    %ecx
80102f1c:	21 ca                	and    %ecx,%edx
80102f1e:	85 f6                	test   %esi,%esi
  }
  else // set
  {
    bitmap.bitmap_arr[bitmap_offset / 8] = bitmap.bitmap_arr[bitmap_offset / 8] | (1 << bitmap_offset % 8);
  }
  if (kmem.use_lock)
80102f20:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
    bitmap.bitmap_arr[bitmap_offset / 8] = bitmap.bitmap_arr[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102f26:	0f 45 d3             	cmovne %ebx,%edx
80102f29:	88 90 18 37 11 80    	mov    %dl,-0x7feec8e8(%eax)
  if (kmem.use_lock)
80102f2f:	85 c9                	test   %ecx,%ecx
80102f31:	0f 85 a9 00 00 00    	jne    80102fe0 <bitmap_modify+0x130>
    release(&kmem.lock);
  if (lru.use_lock)
80102f37:	8b 15 54 47 11 80    	mov    0x80114754,%edx
80102f3d:	85 d2                	test   %edx,%edx
80102f3f:	0f 85 83 00 00 00    	jne    80102fc8 <bitmap_modify+0x118>
    release(&lru.lock);
  if (bitmap.use_lock)
80102f45:	a1 14 37 11 80       	mov    0x80113714,%eax
80102f4a:	85 c0                	test   %eax,%eax
80102f4c:	75 62                	jne    80102fb0 <bitmap_modify+0x100>
    release(&bitmap.lock);
}
80102f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f51:	5b                   	pop    %ebx
80102f52:	5e                   	pop    %esi
80102f53:	5f                   	pop    %edi
80102f54:	5d                   	pop    %ebp
80102f55:	c3                   	ret    
80102f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f5d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102f60:	83 ec 0c             	sub    $0xc,%esp
80102f63:	68 a0 36 11 80       	push   $0x801136a0
80102f68:	e8 f3 23 00 00       	call   80105360 <acquire>
  if (lru.use_lock)
80102f6d:	a1 54 47 11 80       	mov    0x80114754,%eax
    acquire(&kmem.lock);
80102f72:	83 c4 10             	add    $0x10,%esp
  if (lru.use_lock)
80102f75:	85 c0                	test   %eax,%eax
80102f77:	0f 84 60 ff ff ff    	je     80102edd <bitmap_modify+0x2d>
    acquire(&lru.lock);
80102f7d:	83 ec 0c             	sub    $0xc,%esp
80102f80:	68 20 47 11 80       	push   $0x80114720
80102f85:	e8 d6 23 00 00       	call   80105360 <acquire>
  if (bitmap.use_lock)
80102f8a:	8b 3d 14 37 11 80    	mov    0x80113714,%edi
    acquire(&lru.lock);
80102f90:	83 c4 10             	add    $0x10,%esp
  if (bitmap.use_lock)
80102f93:	85 ff                	test   %edi,%edi
80102f95:	0f 84 50 ff ff ff    	je     80102eeb <bitmap_modify+0x3b>
    acquire(&bitmap.lock);
80102f9b:	83 ec 0c             	sub    $0xc,%esp
80102f9e:	68 e0 36 11 80       	push   $0x801136e0
80102fa3:	e8 b8 23 00 00       	call   80105360 <acquire>
80102fa8:	83 c4 10             	add    $0x10,%esp
80102fab:	e9 3b ff ff ff       	jmp    80102eeb <bitmap_modify+0x3b>
    release(&bitmap.lock);
80102fb0:	c7 45 08 e0 36 11 80 	movl   $0x801136e0,0x8(%ebp)
}
80102fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fba:	5b                   	pop    %ebx
80102fbb:	5e                   	pop    %esi
80102fbc:	5f                   	pop    %edi
80102fbd:	5d                   	pop    %ebp
    release(&bitmap.lock);
80102fbe:	e9 5d 24 00 00       	jmp    80105420 <release>
80102fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fc7:	90                   	nop
    release(&lru.lock);
80102fc8:	83 ec 0c             	sub    $0xc,%esp
80102fcb:	68 20 47 11 80       	push   $0x80114720
80102fd0:	e8 4b 24 00 00       	call   80105420 <release>
80102fd5:	83 c4 10             	add    $0x10,%esp
80102fd8:	e9 68 ff ff ff       	jmp    80102f45 <bitmap_modify+0x95>
80102fdd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102fe0:	83 ec 0c             	sub    $0xc,%esp
80102fe3:	68 a0 36 11 80       	push   $0x801136a0
80102fe8:	e8 33 24 00 00       	call   80105420 <release>
80102fed:	83 c4 10             	add    $0x10,%esp
80102ff0:	e9 42 ff ff ff       	jmp    80102f37 <bitmap_modify+0x87>
80102ff5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103000 <swapout>:
{
80103000:	f3 0f 1e fb          	endbr32 
80103004:	55                   	push   %ebp
80103005:	89 e5                	mov    %esp,%ebp
80103007:	57                   	push   %edi
80103008:	56                   	push   %esi
80103009:	53                   	push   %ebx
8010300a:	83 ec 1c             	sub    $0x1c,%esp
  if (lru.num_lru_pages == 0)
8010300d:	8b 1d 60 97 11 80    	mov    0x80119760,%ebx
80103013:	85 db                	test   %ebx,%ebx
80103015:	0f 84 e4 01 00 00    	je     801031ff <swapout+0x1ff>
  for (int i = 0; i < PGSIZE; i++)
8010301b:	31 f6                	xor    %esi,%esi
8010301d:	8d 76 00             	lea    0x0(%esi),%esi
      if ((set_bit & bitmap.bitmap_arr[i]) == 0)
80103020:	0f b6 8e 18 37 11 80 	movzbl -0x7feec8e8(%esi),%ecx
    for (int j = 0; j < 8; j++)
80103027:	31 c0                	xor    %eax,%eax
    set_bit = 1;
80103029:	ba 01 00 00 00       	mov    $0x1,%edx
8010302e:	66 90                	xchg   %ax,%ax
      if ((set_bit & bitmap.bitmap_arr[i]) == 0)
80103030:	84 d1                	test   %dl,%cl
80103032:	74 24                	je     80103058 <swapout+0x58>
    for (int j = 0; j < 8; j++)
80103034:	83 c0 01             	add    $0x1,%eax
        set_bit = set_bit << 1;
80103037:	01 d2                	add    %edx,%edx
    for (int j = 0; j < 8; j++)
80103039:	83 f8 08             	cmp    $0x8,%eax
8010303c:	75 f2                	jne    80103030 <swapout+0x30>
  for (int i = 0; i < PGSIZE; i++)
8010303e:	83 c6 01             	add    $0x1,%esi
80103041:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80103047:	75 d7                	jne    80103020 <swapout+0x20>
80103049:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103050:	eb 0c                	jmp    8010305e <swapout+0x5e>
80103052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bitmap_offset = 8 * i + j;
80103058:	8d 04 f0             	lea    (%eax,%esi,8),%eax
8010305b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for (int i = 0; i < k + 10; i++)
8010305e:	83 c3 09             	add    $0x9,%ebx
80103061:	89 d8                	mov    %ebx,%eax
80103063:	0f 88 78 01 00 00    	js     801031e1 <swapout+0x1e1>
80103069:	8b 3d 58 97 11 80    	mov    0x80119758,%edi
8010306f:	31 db                	xor    %ebx,%ebx
80103071:	89 c6                	mov    %eax,%esi
80103073:	eb 21                	jmp    80103096 <swapout+0x96>
80103075:	8d 76 00             	lea    0x0(%esi),%esi
      *pte = *pte & (~PTE_A);
80103078:	83 e2 df             	and    $0xffffffdf,%edx
  for (int i = 0; i < k + 10; i++)
8010307b:	83 c3 01             	add    $0x1,%ebx
      *pte = *pte & (~PTE_A);
8010307e:	89 10                	mov    %edx,(%eax)
      lru.page_lru_head = lru.page_lru_head->prev;
80103080:	a1 58 97 11 80       	mov    0x80119758,%eax
80103085:	8b 78 04             	mov    0x4(%eax),%edi
80103088:	89 3d 58 97 11 80    	mov    %edi,0x80119758
  for (int i = 0; i < k + 10; i++)
8010308e:	39 de                	cmp    %ebx,%esi
80103090:	0f 8c 4b 01 00 00    	jl     801031e1 <swapout+0x1e1>
    pte = walkpgdir(p_page->pgdir, p_page->vaddr, 0);
80103096:	83 ec 04             	sub    $0x4,%esp
80103099:	6a 00                	push   $0x0
8010309b:	ff 77 0c             	pushl  0xc(%edi)
8010309e:	ff 77 08             	pushl  0x8(%edi)
801030a1:	e8 ea 46 00 00       	call   80107790 <walkpgdir>
    if ((*pte != 0) && ((*pte & PTE_A) == 0)) // ref bit low
801030a6:	83 c4 10             	add    $0x10,%esp
    mem = P2V((PTE_ADDR(*pte)));
801030a9:	8b 10                	mov    (%eax),%edx
    if ((*pte != 0) && ((*pte & PTE_A) == 0)) // ref bit low
801030ab:	85 d2                	test   %edx,%edx
801030ad:	74 c9                	je     80103078 <swapout+0x78>
801030af:	f6 c2 20             	test   $0x20,%dl
801030b2:	75 c4                	jne    80103078 <swapout+0x78>
801030b4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801030b7:	89 c6                	mov    %eax,%esi
801030b9:	89 d0                	mov    %edx,%eax
      if (p_page->vaddr == 0)
801030bb:	8b 57 0c             	mov    0xc(%edi),%edx
801030be:	89 c1                	mov    %eax,%ecx
801030c0:	c1 e3 0c             	shl    $0xc,%ebx
801030c3:	81 e1 fe 0f 00 00    	and    $0xffe,%ecx
801030c9:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801030cc:	09 d9                	or     %ebx,%ecx
801030ce:	8b 5f 08             	mov    0x8(%edi),%ebx
801030d1:	85 d2                	test   %edx,%edx
801030d3:	0f 84 ed 00 00 00    	je     801031c6 <swapout+0x1c6>
        cprintf("Swapout victim page | pgdir : %x, vaddr : %x, PTE : %x, Modified PTE : %x\n", p_page->pgdir, p_page->vaddr, *pte, (((bitmap_offset << 12) | PTE_FLAGS(*pte)) & (~PTE_P)));
801030d9:	83 ec 0c             	sub    $0xc,%esp
801030dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
801030df:	51                   	push   %ecx
801030e0:	50                   	push   %eax
801030e1:	52                   	push   %edx
801030e2:	53                   	push   %ebx
801030e3:	68 8c 86 10 80       	push   $0x8010868c
801030e8:	e8 c3 d5 ff ff       	call   801006b0 <cprintf>
801030ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
801030f0:	83 c4 20             	add    $0x20,%esp
    mem = P2V((PTE_ADDR(*pte)));
801030f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      swapwrite(mem, bitmap_offset);
801030f8:	83 ec 08             	sub    $0x8,%esp
801030fb:	ff 75 e4             	pushl  -0x1c(%ebp)
    mem = P2V((PTE_ADDR(*pte)));
801030fe:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      swapwrite(mem, bitmap_offset);
80103104:	53                   	push   %ebx
80103105:	e8 f6 ef ff ff       	call   80102100 <swapwrite>
      *pte = (bitmap_offset << 12) | PTE_FLAGS(*pte);
8010310a:	8b 06                	mov    (%esi),%eax
8010310c:	25 fe 0f 00 00       	and    $0xffe,%eax
      *pte = *pte & (~PTE_P);
80103111:	0b 45 e0             	or     -0x20(%ebp),%eax
80103114:	89 06                	mov    %eax,(%esi)
      lru.page_lru_head = lru.page_lru_head->prev;
80103116:	a1 58 97 11 80       	mov    0x80119758,%eax
8010311b:	8b 48 04             	mov    0x4(%eax),%ecx
8010311e:	89 0d 58 97 11 80    	mov    %ecx,0x80119758
      lru.page_lru_head->next = p_page->next;
80103124:	8b 07                	mov    (%edi),%eax
80103126:	89 01                	mov    %eax,(%ecx)
      p_page->next->prev = lru.page_lru_head;
80103128:	8b 0d 58 97 11 80    	mov    0x80119758,%ecx
8010312e:	89 48 04             	mov    %ecx,0x4(%eax)
      lcr3(V2P(p_page->pgdir));
80103131:	8b 47 08             	mov    0x8(%edi),%eax
80103134:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80103139:	0f 22 d8             	mov    %eax,%cr3
      bitmap_modify(bitmap_offset, 1);
8010313c:	59                   	pop    %ecx
8010313d:	5e                   	pop    %esi
8010313e:	6a 01                	push   $0x1
80103140:	ff 75 e4             	pushl  -0x1c(%ebp)
80103143:	e8 68 fd ff ff       	call   80102eb0 <bitmap_modify>
      lru.num_lru_pages--;
80103148:	83 2d 60 97 11 80 01 	subl   $0x1,0x80119760
      p_page->use = 0;
8010314f:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
      kfree(mem);
80103156:	89 1c 24             	mov    %ebx,(%esp)
80103159:	e8 22 f4 ff ff       	call   80102580 <kfree>
      if (kmem.use_lock)
8010315e:	8b 3d d4 36 11 80    	mov    0x801136d4,%edi
80103164:	83 c4 10             	add    $0x10,%esp
80103167:	85 ff                	test   %edi,%edi
80103169:	75 49                	jne    801031b4 <swapout+0x1b4>
      if (lru.use_lock)
8010316b:	8b 15 54 47 11 80    	mov    0x80114754,%edx
80103171:	85 d2                	test   %edx,%edx
80103173:	75 2d                	jne    801031a2 <swapout+0x1a2>
      if (bitmap.use_lock)
80103175:	a1 14 37 11 80       	mov    0x80113714,%eax
8010317a:	85 c0                	test   %eax,%eax
8010317c:	75 0a                	jne    80103188 <swapout+0x188>
}
8010317e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103181:	89 d8                	mov    %ebx,%eax
80103183:	5b                   	pop    %ebx
80103184:	5e                   	pop    %esi
80103185:	5f                   	pop    %edi
80103186:	5d                   	pop    %ebp
80103187:	c3                   	ret    
        acquire(&bitmap.lock);
80103188:	83 ec 0c             	sub    $0xc,%esp
8010318b:	68 e0 36 11 80       	push   $0x801136e0
80103190:	e8 cb 21 00 00       	call   80105360 <acquire>
80103195:	83 c4 10             	add    $0x10,%esp
}
80103198:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010319b:	89 d8                	mov    %ebx,%eax
8010319d:	5b                   	pop    %ebx
8010319e:	5e                   	pop    %esi
8010319f:	5f                   	pop    %edi
801031a0:	5d                   	pop    %ebp
801031a1:	c3                   	ret    
        acquire(&lru.lock);
801031a2:	83 ec 0c             	sub    $0xc,%esp
801031a5:	68 20 47 11 80       	push   $0x80114720
801031aa:	e8 b1 21 00 00       	call   80105360 <acquire>
801031af:	83 c4 10             	add    $0x10,%esp
801031b2:	eb c1                	jmp    80103175 <swapout+0x175>
        acquire(&kmem.lock);
801031b4:	83 ec 0c             	sub    $0xc,%esp
801031b7:	68 a0 36 11 80       	push   $0x801136a0
801031bc:	e8 9f 21 00 00       	call   80105360 <acquire>
801031c1:	83 c4 10             	add    $0x10,%esp
801031c4:	eb a5                	jmp    8010316b <swapout+0x16b>
        cprintf("Swapout victim page | pgdir : %x,vaddr : 0000, PTE : %x, Modified PTE : %x\n", p_page->pgdir, *pte, (((bitmap_offset << 12) | PTE_FLAGS(*pte)) & (~PTE_P)));
801031c6:	51                   	push   %ecx
801031c7:	50                   	push   %eax
801031c8:	53                   	push   %ebx
801031c9:	68 40 86 10 80       	push   $0x80108640
801031ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
801031d1:	e8 da d4 ff ff       	call   801006b0 <cprintf>
801031d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031d9:	83 c4 10             	add    $0x10,%esp
801031dc:	e9 12 ff ff ff       	jmp    801030f3 <swapout+0xf3>
  cprintf("================swap out err================\n");
801031e1:	83 ec 0c             	sub    $0xc,%esp
801031e4:	68 ec 85 10 80       	push   $0x801085ec
801031e9:	e8 c2 d4 ff ff       	call   801006b0 <cprintf>
  lru_print();
801031ee:	e8 1d f7 ff ff       	call   80102910 <lru_print>
  panic("swap out err not found zero page");
801031f3:	c7 04 24 1c 86 10 80 	movl   $0x8010861c,(%esp)
801031fa:	e8 91 d1 ff ff       	call   80100390 <panic>
    panic("OOM Error");
801031ff:	83 ec 0c             	sub    $0xc,%esp
80103202:	68 b4 83 10 80       	push   $0x801083b4
80103207:	e8 84 d1 ff ff       	call   80100390 <panic>
8010320c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103210 <kalloc>:
{
80103210:	f3 0f 1e fb          	endbr32 
80103214:	55                   	push   %ebp
80103215:	89 e5                	mov    %esp,%ebp
80103217:	53                   	push   %ebx
80103218:	83 ec 04             	sub    $0x4,%esp
  if (kmem.use_lock)
8010321b:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80103220:	85 c0                	test   %eax,%eax
80103222:	0f 85 30 01 00 00    	jne    80103358 <kalloc+0x148>
  if (lru.use_lock)
80103228:	a1 54 47 11 80       	mov    0x80114754,%eax
8010322d:	85 c0                	test   %eax,%eax
8010322f:	0f 85 0b 01 00 00    	jne    80103340 <kalloc+0x130>
  if (bitmap.use_lock)
80103235:	a1 14 37 11 80       	mov    0x80113714,%eax
8010323a:	85 c0                	test   %eax,%eax
8010323c:	0f 85 e6 00 00 00    	jne    80103328 <kalloc+0x118>
  r = kmem.freelist;
80103242:	8b 1d d8 36 11 80    	mov    0x801136d8,%ebx
  lru.num_free_pages--;
80103248:	83 2d 5c 97 11 80 01 	subl   $0x1,0x8011975c
  if (r)
8010324f:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80103254:	85 db                	test   %ebx,%ebx
80103256:	74 30                	je     80103288 <kalloc+0x78>
    kmem.freelist = r->next;
80103258:	8b 13                	mov    (%ebx),%edx
8010325a:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
    if (kmem.use_lock)
80103260:	85 c0                	test   %eax,%eax
80103262:	75 6f                	jne    801032d3 <kalloc+0xc3>
    if (lru.use_lock)
80103264:	8b 15 54 47 11 80    	mov    0x80114754,%edx
8010326a:	85 d2                	test   %edx,%edx
8010326c:	75 7f                	jne    801032ed <kalloc+0xdd>
    if (bitmap.use_lock)
8010326e:	a1 14 37 11 80       	mov    0x80113714,%eax
80103273:	85 c0                	test   %eax,%eax
80103275:	0f 85 8f 00 00 00    	jne    8010330a <kalloc+0xfa>
}
8010327b:	89 d8                	mov    %ebx,%eax
8010327d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103280:	c9                   	leave  
80103281:	c3                   	ret    
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (kmem.use_lock)
80103288:	85 c0                	test   %eax,%eax
8010328a:	0f 85 e0 00 00 00    	jne    80103370 <kalloc+0x160>
    if (lru.use_lock)
80103290:	a1 54 47 11 80       	mov    0x80114754,%eax
80103295:	85 c0                	test   %eax,%eax
80103297:	0f 85 03 01 00 00    	jne    801033a0 <kalloc+0x190>
    if (bitmap.use_lock)
8010329d:	8b 1d 14 37 11 80    	mov    0x80113714,%ebx
801032a3:	85 db                	test   %ebx,%ebx
801032a5:	0f 85 dd 00 00 00    	jne    80103388 <kalloc+0x178>
    cprintf("No free physical page -> ");
801032ab:	83 ec 0c             	sub    $0xc,%esp
801032ae:	68 be 83 10 80       	push   $0x801083be
801032b3:	e8 f8 d3 ff ff       	call   801006b0 <cprintf>
    r = (struct run *)swapout();
801032b8:	e8 43 fd ff ff       	call   80103000 <swapout>
    if (kmem.use_lock)
801032bd:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
801032c3:	83 c4 10             	add    $0x10,%esp
    r = (struct run *)swapout();
801032c6:	89 c3                	mov    %eax,%ebx
    kmem.freelist = r->next;
801032c8:	8b 00                	mov    (%eax),%eax
801032ca:	a3 d8 36 11 80       	mov    %eax,0x801136d8
    if (kmem.use_lock)
801032cf:	85 c9                	test   %ecx,%ecx
801032d1:	74 91                	je     80103264 <kalloc+0x54>
      release(&kmem.lock);
801032d3:	83 ec 0c             	sub    $0xc,%esp
801032d6:	68 a0 36 11 80       	push   $0x801136a0
801032db:	e8 40 21 00 00       	call   80105420 <release>
    if (lru.use_lock)
801032e0:	8b 15 54 47 11 80    	mov    0x80114754,%edx
      release(&kmem.lock);
801032e6:	83 c4 10             	add    $0x10,%esp
    if (lru.use_lock)
801032e9:	85 d2                	test   %edx,%edx
801032eb:	74 81                	je     8010326e <kalloc+0x5e>
      release(&lru.lock);
801032ed:	83 ec 0c             	sub    $0xc,%esp
801032f0:	68 20 47 11 80       	push   $0x80114720
801032f5:	e8 26 21 00 00       	call   80105420 <release>
    if (bitmap.use_lock)
801032fa:	a1 14 37 11 80       	mov    0x80113714,%eax
      release(&lru.lock);
801032ff:	83 c4 10             	add    $0x10,%esp
    if (bitmap.use_lock)
80103302:	85 c0                	test   %eax,%eax
80103304:	0f 84 71 ff ff ff    	je     8010327b <kalloc+0x6b>
      release(&bitmap.lock);
8010330a:	83 ec 0c             	sub    $0xc,%esp
8010330d:	68 e0 36 11 80       	push   $0x801136e0
80103312:	e8 09 21 00 00       	call   80105420 <release>
}
80103317:	89 d8                	mov    %ebx,%eax
      release(&bitmap.lock);
80103319:	83 c4 10             	add    $0x10,%esp
}
8010331c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010331f:	c9                   	leave  
80103320:	c3                   	ret    
80103321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&bitmap.lock);
80103328:	83 ec 0c             	sub    $0xc,%esp
8010332b:	68 e0 36 11 80       	push   $0x801136e0
80103330:	e8 2b 20 00 00       	call   80105360 <acquire>
80103335:	83 c4 10             	add    $0x10,%esp
80103338:	e9 05 ff ff ff       	jmp    80103242 <kalloc+0x32>
8010333d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&lru.lock);
80103340:	83 ec 0c             	sub    $0xc,%esp
80103343:	68 20 47 11 80       	push   $0x80114720
80103348:	e8 13 20 00 00       	call   80105360 <acquire>
8010334d:	83 c4 10             	add    $0x10,%esp
80103350:	e9 e0 fe ff ff       	jmp    80103235 <kalloc+0x25>
80103355:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80103358:	83 ec 0c             	sub    $0xc,%esp
8010335b:	68 a0 36 11 80       	push   $0x801136a0
80103360:	e8 fb 1f 00 00       	call   80105360 <acquire>
80103365:	83 c4 10             	add    $0x10,%esp
80103368:	e9 bb fe ff ff       	jmp    80103228 <kalloc+0x18>
8010336d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&kmem.lock);
80103370:	83 ec 0c             	sub    $0xc,%esp
80103373:	68 a0 36 11 80       	push   $0x801136a0
80103378:	e8 a3 20 00 00       	call   80105420 <release>
8010337d:	83 c4 10             	add    $0x10,%esp
80103380:	e9 0b ff ff ff       	jmp    80103290 <kalloc+0x80>
80103385:	8d 76 00             	lea    0x0(%esi),%esi
      release(&bitmap.lock);
80103388:	83 ec 0c             	sub    $0xc,%esp
8010338b:	68 e0 36 11 80       	push   $0x801136e0
80103390:	e8 8b 20 00 00       	call   80105420 <release>
80103395:	83 c4 10             	add    $0x10,%esp
80103398:	e9 0e ff ff ff       	jmp    801032ab <kalloc+0x9b>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&lru.lock);
801033a0:	83 ec 0c             	sub    $0xc,%esp
801033a3:	68 20 47 11 80       	push   $0x80114720
801033a8:	e8 73 20 00 00       	call   80105420 <release>
801033ad:	83 c4 10             	add    $0x10,%esp
801033b0:	e9 e8 fe ff ff       	jmp    8010329d <kalloc+0x8d>
801033b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033c0 <page_fault_handler>:

int page_fault_handler(pde_t *pgdir, uint vaddr)
{
801033c0:	f3 0f 1e fb          	endbr32 
801033c4:	55                   	push   %ebp
801033c5:	89 e5                	mov    %esp,%ebp
801033c7:	57                   	push   %edi
    */
    // cprintf("================Page fault(non swappable) end================\n");
  }
  // cprintf("================Page fault end================\n");

  return 0;
801033c8:	31 ff                	xor    %edi,%edi
{
801033ca:	56                   	push   %esi
801033cb:	53                   	push   %ebx
801033cc:	83 ec 24             	sub    $0x24,%esp
801033cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  cprintf("Page Fault Occur at %x -> ", vaddr);
801033d2:	56                   	push   %esi
801033d3:	68 d8 83 10 80       	push   $0x801083d8
801033d8:	e8 d3 d2 ff ff       	call   801006b0 <cprintf>
  pte = walkpgdir(pgdir, (void *)vaddr, 0);
801033dd:	83 c4 0c             	add    $0xc,%esp
801033e0:	6a 00                	push   $0x0
801033e2:	56                   	push   %esi
801033e3:	ff 75 08             	pushl  0x8(%ebp)
801033e6:	e8 a5 43 00 00       	call   80107790 <walkpgdir>
  if ((*pte != 0) && ((*pte & PTE_P) == 0)) // page-fault occur where swapped out page
801033eb:	83 c4 10             	add    $0x10,%esp
  pte = walkpgdir(pgdir, (void *)vaddr, 0);
801033ee:	89 c3                	mov    %eax,%ebx
  if ((*pte != 0) && ((*pte & PTE_P) == 0)) // page-fault occur where swapped out page
801033f0:	8b 00                	mov    (%eax),%eax
801033f2:	85 c0                	test   %eax,%eax
801033f4:	74 04                	je     801033fa <page_fault_handler+0x3a>
801033f6:	a8 01                	test   $0x1,%al
801033f8:	74 0e                	je     80103408 <page_fault_handler+0x48>
801033fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033fd:	89 f8                	mov    %edi,%eax
801033ff:	5b                   	pop    %ebx
80103400:	5e                   	pop    %esi
80103401:	5f                   	pop    %edi
80103402:	5d                   	pop    %ebp
80103403:	c3                   	ret    
80103404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("Mem alloc -> ");
80103408:	83 ec 0c             	sub    $0xc,%esp
8010340b:	68 f3 83 10 80       	push   $0x801083f3
80103410:	e8 9b d2 ff ff       	call   801006b0 <cprintf>
    mem = kalloc();
80103415:	e8 f6 fd ff ff       	call   80103210 <kalloc>
    if (mem == 0)
8010341a:	83 c4 10             	add    $0x10,%esp
8010341d:	85 c0                	test   %eax,%eax
8010341f:	74 6c                	je     8010348d <page_fault_handler+0xcd>
    memset(mem, 0, PGSIZE);
80103421:	83 ec 04             	sub    $0x4,%esp
80103424:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103427:	68 00 10 00 00       	push   $0x1000
8010342c:	6a 00                	push   $0x0
8010342e:	50                   	push   %eax
8010342f:	e8 3c 20 00 00       	call   80105470 <memset>
    bitmap_offset = (PTE_ADDR(*pte)) >> 12;
80103434:	8b 03                	mov    (%ebx),%eax
    swapread(mem, bitmap_offset);
80103436:	5a                   	pop    %edx
80103437:	59                   	pop    %ecx
80103438:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    bitmap_offset = (PTE_ADDR(*pte)) >> 12;
8010343b:	c1 e8 0c             	shr    $0xc,%eax
    swapread(mem, bitmap_offset);
8010343e:	50                   	push   %eax
8010343f:	51                   	push   %ecx
80103440:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103443:	e8 28 ec ff ff       	call   80102070 <swapread>
    cprintf("Swap read -> ");
80103448:	c7 04 24 01 84 10 80 	movl   $0x80108401,(%esp)
8010344f:	e8 5c d2 ff ff       	call   801006b0 <cprintf>
    *pte = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
80103454:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103457:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
8010345d:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80103463:	83 c9 07             	or     $0x7,%ecx
80103466:	89 0b                	mov    %ecx,(%ebx)
    page_insert(pgdir, vaddr);
80103468:	5b                   	pop    %ebx
80103469:	58                   	pop    %eax
8010346a:	56                   	push   %esi
8010346b:	ff 75 08             	pushl  0x8(%ebp)
8010346e:	e8 dd f5 ff ff       	call   80102a50 <page_insert>
    bitmap_modify(bitmap_offset, 0);
80103473:	58                   	pop    %eax
80103474:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103477:	5a                   	pop    %edx
80103478:	6a 00                	push   $0x0
8010347a:	50                   	push   %eax
8010347b:	e8 30 fa ff ff       	call   80102eb0 <bitmap_modify>
80103480:	83 c4 10             	add    $0x10,%esp
80103483:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103486:	89 f8                	mov    %edi,%eax
80103488:	5b                   	pop    %ebx
80103489:	5e                   	pop    %esi
8010348a:	5f                   	pop    %edi
8010348b:	5d                   	pop    %ebp
8010348c:	c3                   	ret    
      cprintf("page fault allocate out of memory\n");
8010348d:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103490:	83 cf ff             	or     $0xffffffff,%edi
      cprintf("page fault allocate out of memory\n");
80103493:	68 d8 86 10 80       	push   $0x801086d8
80103498:	e8 13 d2 ff ff       	call   801006b0 <cprintf>
      return -1;
8010349d:	83 c4 10             	add    $0x10,%esp
801034a0:	e9 55 ff ff ff       	jmp    801033fa <page_fault_handler+0x3a>
801034a5:	66 90                	xchg   %ax,%ax
801034a7:	66 90                	xchg   %ax,%ax
801034a9:	66 90                	xchg   %ax,%ax
801034ab:	66 90                	xchg   %ax,%ax
801034ad:	66 90                	xchg   %ax,%ax
801034af:	90                   	nop

801034b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801034b0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034b4:	ba 64 00 00 00       	mov    $0x64,%edx
801034b9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801034ba:	a8 01                	test   $0x1,%al
801034bc:	0f 84 be 00 00 00    	je     80103580 <kbdgetc+0xd0>
{
801034c2:	55                   	push   %ebp
801034c3:	ba 60 00 00 00       	mov    $0x60,%edx
801034c8:	89 e5                	mov    %esp,%ebp
801034ca:	53                   	push   %ebx
801034cb:	ec                   	in     (%dx),%al
  return data;
801034cc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801034d2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801034d5:	3c e0                	cmp    $0xe0,%al
801034d7:	74 57                	je     80103530 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801034d9:	89 d9                	mov    %ebx,%ecx
801034db:	83 e1 40             	and    $0x40,%ecx
801034de:	84 c0                	test   %al,%al
801034e0:	78 5e                	js     80103540 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801034e2:	85 c9                	test   %ecx,%ecx
801034e4:	74 09                	je     801034ef <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801034e6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801034e9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801034ec:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801034ef:	0f b6 8a 20 88 10 80 	movzbl -0x7fef77e0(%edx),%ecx
  shift ^= togglecode[data];
801034f6:	0f b6 82 20 87 10 80 	movzbl -0x7fef78e0(%edx),%eax
  shift |= shiftcode[data];
801034fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801034ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80103501:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80103503:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80103509:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010350c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010350f:	8b 04 85 00 87 10 80 	mov    -0x7fef7900(,%eax,4),%eax
80103516:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010351a:	74 0b                	je     80103527 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010351c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010351f:	83 fa 19             	cmp    $0x19,%edx
80103522:	77 44                	ja     80103568 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103524:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103527:	5b                   	pop    %ebx
80103528:	5d                   	pop    %ebp
80103529:	c3                   	ret    
8010352a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80103530:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103533:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103535:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010353b:	5b                   	pop    %ebx
8010353c:	5d                   	pop    %ebp
8010353d:	c3                   	ret    
8010353e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80103540:	83 e0 7f             	and    $0x7f,%eax
80103543:	85 c9                	test   %ecx,%ecx
80103545:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80103548:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010354a:	0f b6 8a 20 88 10 80 	movzbl -0x7fef77e0(%edx),%ecx
80103551:	83 c9 40             	or     $0x40,%ecx
80103554:	0f b6 c9             	movzbl %cl,%ecx
80103557:	f7 d1                	not    %ecx
80103559:	21 d9                	and    %ebx,%ecx
}
8010355b:	5b                   	pop    %ebx
8010355c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010355d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80103563:	c3                   	ret    
80103564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80103568:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010356b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010356e:	5b                   	pop    %ebx
8010356f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80103570:	83 f9 1a             	cmp    $0x1a,%ecx
80103573:	0f 42 c2             	cmovb  %edx,%eax
}
80103576:	c3                   	ret    
80103577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010357e:	66 90                	xchg   %ax,%ax
    return -1;
80103580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103585:	c3                   	ret    
80103586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010358d:	8d 76 00             	lea    0x0(%esi),%esi

80103590 <kbdintr>:

void
kbdintr(void)
{
80103590:	f3 0f 1e fb          	endbr32 
80103594:	55                   	push   %ebp
80103595:	89 e5                	mov    %esp,%ebp
80103597:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010359a:	68 b0 34 10 80       	push   $0x801034b0
8010359f:	e8 bc d2 ff ff       	call   80100860 <consoleintr>
}
801035a4:	83 c4 10             	add    $0x10,%esp
801035a7:	c9                   	leave  
801035a8:	c3                   	ret    
801035a9:	66 90                	xchg   %ax,%ax
801035ab:	66 90                	xchg   %ax,%ax
801035ad:	66 90                	xchg   %ax,%ax
801035af:	90                   	nop

801035b0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801035b0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801035b4:	a1 b8 97 11 80       	mov    0x801197b8,%eax
801035b9:	85 c0                	test   %eax,%eax
801035bb:	0f 84 c7 00 00 00    	je     80103688 <lapicinit+0xd8>
  lapic[index] = value;
801035c1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801035c8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801035cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801035ce:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801035d5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801035d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801035db:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801035e2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801035e5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801035e8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801035ef:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801035f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801035f5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801035fc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801035ff:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103602:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103609:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010360c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010360f:	8b 50 30             	mov    0x30(%eax),%edx
80103612:	c1 ea 10             	shr    $0x10,%edx
80103615:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010361b:	75 73                	jne    80103690 <lapicinit+0xe0>
  lapic[index] = value;
8010361d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103624:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103627:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010362a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103631:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103634:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103637:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010363e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103641:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103644:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010364b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010364e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103651:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103658:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010365b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010365e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103665:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103668:	8b 50 20             	mov    0x20(%eax),%edx
8010366b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010366f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103670:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103676:	80 e6 10             	and    $0x10,%dh
80103679:	75 f5                	jne    80103670 <lapicinit+0xc0>
  lapic[index] = value;
8010367b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103682:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103685:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103688:	c3                   	ret    
80103689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103690:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103697:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010369a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010369d:	e9 7b ff ff ff       	jmp    8010361d <lapicinit+0x6d>
801036a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036b0 <lapicid>:

int
lapicid(void)
{
801036b0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801036b4:	a1 b8 97 11 80       	mov    0x801197b8,%eax
801036b9:	85 c0                	test   %eax,%eax
801036bb:	74 0b                	je     801036c8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801036bd:	8b 40 20             	mov    0x20(%eax),%eax
801036c0:	c1 e8 18             	shr    $0x18,%eax
801036c3:	c3                   	ret    
801036c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801036c8:	31 c0                	xor    %eax,%eax
}
801036ca:	c3                   	ret    
801036cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036cf:	90                   	nop

801036d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801036d0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801036d4:	a1 b8 97 11 80       	mov    0x801197b8,%eax
801036d9:	85 c0                	test   %eax,%eax
801036db:	74 0d                	je     801036ea <lapiceoi+0x1a>
  lapic[index] = value;
801036dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801036e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801036e7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801036ea:	c3                   	ret    
801036eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036ef:	90                   	nop

801036f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801036f0:	f3 0f 1e fb          	endbr32 
}
801036f4:	c3                   	ret    
801036f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103700 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103700:	f3 0f 1e fb          	endbr32 
80103704:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103705:	b8 0f 00 00 00       	mov    $0xf,%eax
8010370a:	ba 70 00 00 00       	mov    $0x70,%edx
8010370f:	89 e5                	mov    %esp,%ebp
80103711:	53                   	push   %ebx
80103712:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103715:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103718:	ee                   	out    %al,(%dx)
80103719:	b8 0a 00 00 00       	mov    $0xa,%eax
8010371e:	ba 71 00 00 00       	mov    $0x71,%edx
80103723:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103724:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103726:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103729:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010372f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103731:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103734:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103736:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103739:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010373c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103742:	a1 b8 97 11 80       	mov    0x801197b8,%eax
80103747:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010374d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103750:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103757:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010375a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010375d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103764:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103767:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010376a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103770:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103773:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103779:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010377c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103782:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103785:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010378b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010378c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010378f:	5d                   	pop    %ebp
80103790:	c3                   	ret    
80103791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010379f:	90                   	nop

801037a0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801037a0:	f3 0f 1e fb          	endbr32 
801037a4:	55                   	push   %ebp
801037a5:	b8 0b 00 00 00       	mov    $0xb,%eax
801037aa:	ba 70 00 00 00       	mov    $0x70,%edx
801037af:	89 e5                	mov    %esp,%ebp
801037b1:	57                   	push   %edi
801037b2:	56                   	push   %esi
801037b3:	53                   	push   %ebx
801037b4:	83 ec 4c             	sub    $0x4c,%esp
801037b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037b8:	ba 71 00 00 00       	mov    $0x71,%edx
801037bd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801037be:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037c1:	bb 70 00 00 00       	mov    $0x70,%ebx
801037c6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801037c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037d0:	31 c0                	xor    %eax,%eax
801037d2:	89 da                	mov    %ebx,%edx
801037d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037d5:	b9 71 00 00 00       	mov    $0x71,%ecx
801037da:	89 ca                	mov    %ecx,%edx
801037dc:	ec                   	in     (%dx),%al
801037dd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037e0:	89 da                	mov    %ebx,%edx
801037e2:	b8 02 00 00 00       	mov    $0x2,%eax
801037e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037e8:	89 ca                	mov    %ecx,%edx
801037ea:	ec                   	in     (%dx),%al
801037eb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037ee:	89 da                	mov    %ebx,%edx
801037f0:	b8 04 00 00 00       	mov    $0x4,%eax
801037f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037f6:	89 ca                	mov    %ecx,%edx
801037f8:	ec                   	in     (%dx),%al
801037f9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037fc:	89 da                	mov    %ebx,%edx
801037fe:	b8 07 00 00 00       	mov    $0x7,%eax
80103803:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103804:	89 ca                	mov    %ecx,%edx
80103806:	ec                   	in     (%dx),%al
80103807:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010380a:	89 da                	mov    %ebx,%edx
8010380c:	b8 08 00 00 00       	mov    $0x8,%eax
80103811:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103812:	89 ca                	mov    %ecx,%edx
80103814:	ec                   	in     (%dx),%al
80103815:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103817:	89 da                	mov    %ebx,%edx
80103819:	b8 09 00 00 00       	mov    $0x9,%eax
8010381e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010381f:	89 ca                	mov    %ecx,%edx
80103821:	ec                   	in     (%dx),%al
80103822:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103824:	89 da                	mov    %ebx,%edx
80103826:	b8 0a 00 00 00       	mov    $0xa,%eax
8010382b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010382c:	89 ca                	mov    %ecx,%edx
8010382e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010382f:	84 c0                	test   %al,%al
80103831:	78 9d                	js     801037d0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103833:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103837:	89 fa                	mov    %edi,%edx
80103839:	0f b6 fa             	movzbl %dl,%edi
8010383c:	89 f2                	mov    %esi,%edx
8010383e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103841:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103845:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103848:	89 da                	mov    %ebx,%edx
8010384a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010384d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103850:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103854:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103857:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010385a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010385e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103861:	31 c0                	xor    %eax,%eax
80103863:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103864:	89 ca                	mov    %ecx,%edx
80103866:	ec                   	in     (%dx),%al
80103867:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010386a:	89 da                	mov    %ebx,%edx
8010386c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010386f:	b8 02 00 00 00       	mov    $0x2,%eax
80103874:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103875:	89 ca                	mov    %ecx,%edx
80103877:	ec                   	in     (%dx),%al
80103878:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010387b:	89 da                	mov    %ebx,%edx
8010387d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103880:	b8 04 00 00 00       	mov    $0x4,%eax
80103885:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103886:	89 ca                	mov    %ecx,%edx
80103888:	ec                   	in     (%dx),%al
80103889:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010388c:	89 da                	mov    %ebx,%edx
8010388e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103891:	b8 07 00 00 00       	mov    $0x7,%eax
80103896:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103897:	89 ca                	mov    %ecx,%edx
80103899:	ec                   	in     (%dx),%al
8010389a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010389d:	89 da                	mov    %ebx,%edx
8010389f:	89 45 dc             	mov    %eax,-0x24(%ebp)
801038a2:	b8 08 00 00 00       	mov    $0x8,%eax
801038a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801038a8:	89 ca                	mov    %ecx,%edx
801038aa:	ec                   	in     (%dx),%al
801038ab:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801038ae:	89 da                	mov    %ebx,%edx
801038b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801038b3:	b8 09 00 00 00       	mov    $0x9,%eax
801038b8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801038b9:	89 ca                	mov    %ecx,%edx
801038bb:	ec                   	in     (%dx),%al
801038bc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801038bf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801038c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801038c5:	8d 45 d0             	lea    -0x30(%ebp),%eax
801038c8:	6a 18                	push   $0x18
801038ca:	50                   	push   %eax
801038cb:	8d 45 b8             	lea    -0x48(%ebp),%eax
801038ce:	50                   	push   %eax
801038cf:	e8 ec 1b 00 00       	call   801054c0 <memcmp>
801038d4:	83 c4 10             	add    $0x10,%esp
801038d7:	85 c0                	test   %eax,%eax
801038d9:	0f 85 f1 fe ff ff    	jne    801037d0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801038df:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801038e3:	75 78                	jne    8010395d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801038e5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801038e8:	89 c2                	mov    %eax,%edx
801038ea:	83 e0 0f             	and    $0xf,%eax
801038ed:	c1 ea 04             	shr    $0x4,%edx
801038f0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801038f3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801038f6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801038f9:	8b 45 bc             	mov    -0x44(%ebp),%eax
801038fc:	89 c2                	mov    %eax,%edx
801038fe:	83 e0 0f             	and    $0xf,%eax
80103901:	c1 ea 04             	shr    $0x4,%edx
80103904:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103907:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010390a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010390d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103910:	89 c2                	mov    %eax,%edx
80103912:	83 e0 0f             	and    $0xf,%eax
80103915:	c1 ea 04             	shr    $0x4,%edx
80103918:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010391b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010391e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103921:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103924:	89 c2                	mov    %eax,%edx
80103926:	83 e0 0f             	and    $0xf,%eax
80103929:	c1 ea 04             	shr    $0x4,%edx
8010392c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010392f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103932:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103935:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103938:	89 c2                	mov    %eax,%edx
8010393a:	83 e0 0f             	and    $0xf,%eax
8010393d:	c1 ea 04             	shr    $0x4,%edx
80103940:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103943:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103946:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103949:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010394c:	89 c2                	mov    %eax,%edx
8010394e:	83 e0 0f             	and    $0xf,%eax
80103951:	c1 ea 04             	shr    $0x4,%edx
80103954:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103957:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010395a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010395d:	8b 75 08             	mov    0x8(%ebp),%esi
80103960:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103963:	89 06                	mov    %eax,(%esi)
80103965:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103968:	89 46 04             	mov    %eax,0x4(%esi)
8010396b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010396e:	89 46 08             	mov    %eax,0x8(%esi)
80103971:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103974:	89 46 0c             	mov    %eax,0xc(%esi)
80103977:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010397a:	89 46 10             	mov    %eax,0x10(%esi)
8010397d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103980:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103983:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010398a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010398d:	5b                   	pop    %ebx
8010398e:	5e                   	pop    %esi
8010398f:	5f                   	pop    %edi
80103990:	5d                   	pop    %ebp
80103991:	c3                   	ret    
80103992:	66 90                	xchg   %ax,%ax
80103994:	66 90                	xchg   %ax,%ax
80103996:	66 90                	xchg   %ax,%ax
80103998:	66 90                	xchg   %ax,%ax
8010399a:	66 90                	xchg   %ax,%ax
8010399c:	66 90                	xchg   %ax,%ax
8010399e:	66 90                	xchg   %ax,%ax

801039a0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801039a0:	8b 0d 08 98 11 80    	mov    0x80119808,%ecx
801039a6:	85 c9                	test   %ecx,%ecx
801039a8:	0f 8e 8a 00 00 00    	jle    80103a38 <install_trans+0x98>
{
801039ae:	55                   	push   %ebp
801039af:	89 e5                	mov    %esp,%ebp
801039b1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801039b2:	31 ff                	xor    %edi,%edi
{
801039b4:	56                   	push   %esi
801039b5:	53                   	push   %ebx
801039b6:	83 ec 0c             	sub    $0xc,%esp
801039b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801039c0:	a1 f4 97 11 80       	mov    0x801197f4,%eax
801039c5:	83 ec 08             	sub    $0x8,%esp
801039c8:	01 f8                	add    %edi,%eax
801039ca:	83 c0 01             	add    $0x1,%eax
801039cd:	50                   	push   %eax
801039ce:	ff 35 04 98 11 80    	pushl  0x80119804
801039d4:	e8 f7 c6 ff ff       	call   801000d0 <bread>
801039d9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801039db:	58                   	pop    %eax
801039dc:	5a                   	pop    %edx
801039dd:	ff 34 bd 0c 98 11 80 	pushl  -0x7fee67f4(,%edi,4)
801039e4:	ff 35 04 98 11 80    	pushl  0x80119804
  for (tail = 0; tail < log.lh.n; tail++) {
801039ea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801039ed:	e8 de c6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801039f2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801039f5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801039f7:	8d 46 5c             	lea    0x5c(%esi),%eax
801039fa:	68 00 02 00 00       	push   $0x200
801039ff:	50                   	push   %eax
80103a00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103a03:	50                   	push   %eax
80103a04:	e8 07 1b 00 00       	call   80105510 <memmove>
    bwrite(dbuf);  // write dst to disk
80103a09:	89 1c 24             	mov    %ebx,(%esp)
80103a0c:	e8 9f c7 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103a11:	89 34 24             	mov    %esi,(%esp)
80103a14:	e8 d7 c7 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103a19:	89 1c 24             	mov    %ebx,(%esp)
80103a1c:	e8 cf c7 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103a21:	83 c4 10             	add    $0x10,%esp
80103a24:	39 3d 08 98 11 80    	cmp    %edi,0x80119808
80103a2a:	7f 94                	jg     801039c0 <install_trans+0x20>
  }
}
80103a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a2f:	5b                   	pop    %ebx
80103a30:	5e                   	pop    %esi
80103a31:	5f                   	pop    %edi
80103a32:	5d                   	pop    %ebp
80103a33:	c3                   	ret    
80103a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a38:	c3                   	ret    
80103a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	53                   	push   %ebx
80103a44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103a47:	ff 35 f4 97 11 80    	pushl  0x801197f4
80103a4d:	ff 35 04 98 11 80    	pushl  0x80119804
80103a53:	e8 78 c6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103a58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103a5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80103a5d:	a1 08 98 11 80       	mov    0x80119808,%eax
80103a62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103a65:	85 c0                	test   %eax,%eax
80103a67:	7e 19                	jle    80103a82 <write_head+0x42>
80103a69:	31 d2                	xor    %edx,%edx
80103a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103a70:	8b 0c 95 0c 98 11 80 	mov    -0x7fee67f4(,%edx,4),%ecx
80103a77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103a7b:	83 c2 01             	add    $0x1,%edx
80103a7e:	39 d0                	cmp    %edx,%eax
80103a80:	75 ee                	jne    80103a70 <write_head+0x30>
  }
  bwrite(buf);
80103a82:	83 ec 0c             	sub    $0xc,%esp
80103a85:	53                   	push   %ebx
80103a86:	e8 25 c7 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80103a8b:	89 1c 24             	mov    %ebx,(%esp)
80103a8e:	e8 5d c7 ff ff       	call   801001f0 <brelse>
}
80103a93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a96:	83 c4 10             	add    $0x10,%esp
80103a99:	c9                   	leave  
80103a9a:	c3                   	ret    
80103a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a9f:	90                   	nop

80103aa0 <initlog>:
{
80103aa0:	f3 0f 1e fb          	endbr32 
80103aa4:	55                   	push   %ebp
80103aa5:	89 e5                	mov    %esp,%ebp
80103aa7:	53                   	push   %ebx
80103aa8:	83 ec 2c             	sub    $0x2c,%esp
80103aab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80103aae:	68 20 89 10 80       	push   $0x80108920
80103ab3:	68 c0 97 11 80       	push   $0x801197c0
80103ab8:	e8 23 17 00 00       	call   801051e0 <initlock>
  readsb(dev, &sb);
80103abd:	58                   	pop    %eax
80103abe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103ac1:	5a                   	pop    %edx
80103ac2:	50                   	push   %eax
80103ac3:	53                   	push   %ebx
80103ac4:	e8 b7 d9 ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
80103ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103acc:	59                   	pop    %ecx
  log.dev = dev;
80103acd:	89 1d 04 98 11 80    	mov    %ebx,0x80119804
  log.size = sb.nlog;
80103ad3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103ad6:	a3 f4 97 11 80       	mov    %eax,0x801197f4
  log.size = sb.nlog;
80103adb:	89 15 f8 97 11 80    	mov    %edx,0x801197f8
  struct buf *buf = bread(log.dev, log.start);
80103ae1:	5a                   	pop    %edx
80103ae2:	50                   	push   %eax
80103ae3:	53                   	push   %ebx
80103ae4:	e8 e7 c5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103ae9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103aec:	8b 48 5c             	mov    0x5c(%eax),%ecx
80103aef:	89 0d 08 98 11 80    	mov    %ecx,0x80119808
  for (i = 0; i < log.lh.n; i++) {
80103af5:	85 c9                	test   %ecx,%ecx
80103af7:	7e 19                	jle    80103b12 <initlog+0x72>
80103af9:	31 d2                	xor    %edx,%edx
80103afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103b00:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103b04:	89 1c 95 0c 98 11 80 	mov    %ebx,-0x7fee67f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103b0b:	83 c2 01             	add    $0x1,%edx
80103b0e:	39 d1                	cmp    %edx,%ecx
80103b10:	75 ee                	jne    80103b00 <initlog+0x60>
  brelse(buf);
80103b12:	83 ec 0c             	sub    $0xc,%esp
80103b15:	50                   	push   %eax
80103b16:	e8 d5 c6 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80103b1b:	e8 80 fe ff ff       	call   801039a0 <install_trans>
  log.lh.n = 0;
80103b20:	c7 05 08 98 11 80 00 	movl   $0x0,0x80119808
80103b27:	00 00 00 
  write_head(); // clear the log
80103b2a:	e8 11 ff ff ff       	call   80103a40 <write_head>
}
80103b2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b32:	83 c4 10             	add    $0x10,%esp
80103b35:	c9                   	leave  
80103b36:	c3                   	ret    
80103b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b3e:	66 90                	xchg   %ax,%ax

80103b40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103b40:	f3 0f 1e fb          	endbr32 
80103b44:	55                   	push   %ebp
80103b45:	89 e5                	mov    %esp,%ebp
80103b47:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103b4a:	68 c0 97 11 80       	push   $0x801197c0
80103b4f:	e8 0c 18 00 00       	call   80105360 <acquire>
80103b54:	83 c4 10             	add    $0x10,%esp
80103b57:	eb 1c                	jmp    80103b75 <begin_op+0x35>
80103b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103b60:	83 ec 08             	sub    $0x8,%esp
80103b63:	68 c0 97 11 80       	push   $0x801197c0
80103b68:	68 c0 97 11 80       	push   $0x801197c0
80103b6d:	e8 ae 11 00 00       	call   80104d20 <sleep>
80103b72:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103b75:	a1 00 98 11 80       	mov    0x80119800,%eax
80103b7a:	85 c0                	test   %eax,%eax
80103b7c:	75 e2                	jne    80103b60 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103b7e:	a1 fc 97 11 80       	mov    0x801197fc,%eax
80103b83:	8b 15 08 98 11 80    	mov    0x80119808,%edx
80103b89:	83 c0 01             	add    $0x1,%eax
80103b8c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103b8f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103b92:	83 fa 1e             	cmp    $0x1e,%edx
80103b95:	7f c9                	jg     80103b60 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103b97:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103b9a:	a3 fc 97 11 80       	mov    %eax,0x801197fc
      release(&log.lock);
80103b9f:	68 c0 97 11 80       	push   $0x801197c0
80103ba4:	e8 77 18 00 00       	call   80105420 <release>
      break;
    }
  }
}
80103ba9:	83 c4 10             	add    $0x10,%esp
80103bac:	c9                   	leave  
80103bad:	c3                   	ret    
80103bae:	66 90                	xchg   %ax,%ax

80103bb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103bb0:	f3 0f 1e fb          	endbr32 
80103bb4:	55                   	push   %ebp
80103bb5:	89 e5                	mov    %esp,%ebp
80103bb7:	57                   	push   %edi
80103bb8:	56                   	push   %esi
80103bb9:	53                   	push   %ebx
80103bba:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103bbd:	68 c0 97 11 80       	push   $0x801197c0
80103bc2:	e8 99 17 00 00       	call   80105360 <acquire>
  log.outstanding -= 1;
80103bc7:	a1 fc 97 11 80       	mov    0x801197fc,%eax
  if(log.committing)
80103bcc:	8b 35 00 98 11 80    	mov    0x80119800,%esi
80103bd2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103bd5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103bd8:	89 1d fc 97 11 80    	mov    %ebx,0x801197fc
  if(log.committing)
80103bde:	85 f6                	test   %esi,%esi
80103be0:	0f 85 1e 01 00 00    	jne    80103d04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103be6:	85 db                	test   %ebx,%ebx
80103be8:	0f 85 f2 00 00 00    	jne    80103ce0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80103bee:	c7 05 00 98 11 80 01 	movl   $0x1,0x80119800
80103bf5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103bf8:	83 ec 0c             	sub    $0xc,%esp
80103bfb:	68 c0 97 11 80       	push   $0x801197c0
80103c00:	e8 1b 18 00 00       	call   80105420 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103c05:	8b 0d 08 98 11 80    	mov    0x80119808,%ecx
80103c0b:	83 c4 10             	add    $0x10,%esp
80103c0e:	85 c9                	test   %ecx,%ecx
80103c10:	7f 3e                	jg     80103c50 <end_op+0xa0>
    acquire(&log.lock);
80103c12:	83 ec 0c             	sub    $0xc,%esp
80103c15:	68 c0 97 11 80       	push   $0x801197c0
80103c1a:	e8 41 17 00 00       	call   80105360 <acquire>
    wakeup(&log);
80103c1f:	c7 04 24 c0 97 11 80 	movl   $0x801197c0,(%esp)
    log.committing = 0;
80103c26:	c7 05 00 98 11 80 00 	movl   $0x0,0x80119800
80103c2d:	00 00 00 
    wakeup(&log);
80103c30:	e8 ab 12 00 00       	call   80104ee0 <wakeup>
    release(&log.lock);
80103c35:	c7 04 24 c0 97 11 80 	movl   $0x801197c0,(%esp)
80103c3c:	e8 df 17 00 00       	call   80105420 <release>
80103c41:	83 c4 10             	add    $0x10,%esp
}
80103c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c47:	5b                   	pop    %ebx
80103c48:	5e                   	pop    %esi
80103c49:	5f                   	pop    %edi
80103c4a:	5d                   	pop    %ebp
80103c4b:	c3                   	ret    
80103c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103c50:	a1 f4 97 11 80       	mov    0x801197f4,%eax
80103c55:	83 ec 08             	sub    $0x8,%esp
80103c58:	01 d8                	add    %ebx,%eax
80103c5a:	83 c0 01             	add    $0x1,%eax
80103c5d:	50                   	push   %eax
80103c5e:	ff 35 04 98 11 80    	pushl  0x80119804
80103c64:	e8 67 c4 ff ff       	call   801000d0 <bread>
80103c69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103c6b:	58                   	pop    %eax
80103c6c:	5a                   	pop    %edx
80103c6d:	ff 34 9d 0c 98 11 80 	pushl  -0x7fee67f4(,%ebx,4)
80103c74:	ff 35 04 98 11 80    	pushl  0x80119804
  for (tail = 0; tail < log.lh.n; tail++) {
80103c7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103c7d:	e8 4e c4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103c82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103c85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103c87:	8d 40 5c             	lea    0x5c(%eax),%eax
80103c8a:	68 00 02 00 00       	push   $0x200
80103c8f:	50                   	push   %eax
80103c90:	8d 46 5c             	lea    0x5c(%esi),%eax
80103c93:	50                   	push   %eax
80103c94:	e8 77 18 00 00       	call   80105510 <memmove>
    bwrite(to);  // write the log
80103c99:	89 34 24             	mov    %esi,(%esp)
80103c9c:	e8 0f c5 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103ca1:	89 3c 24             	mov    %edi,(%esp)
80103ca4:	e8 47 c5 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103ca9:	89 34 24             	mov    %esi,(%esp)
80103cac:	e8 3f c5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103cb1:	83 c4 10             	add    $0x10,%esp
80103cb4:	3b 1d 08 98 11 80    	cmp    0x80119808,%ebx
80103cba:	7c 94                	jl     80103c50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80103cbc:	e8 7f fd ff ff       	call   80103a40 <write_head>
    install_trans(); // Now install writes to home locations
80103cc1:	e8 da fc ff ff       	call   801039a0 <install_trans>
    log.lh.n = 0;
80103cc6:	c7 05 08 98 11 80 00 	movl   $0x0,0x80119808
80103ccd:	00 00 00 
    write_head();    // Erase the transaction from the log
80103cd0:	e8 6b fd ff ff       	call   80103a40 <write_head>
80103cd5:	e9 38 ff ff ff       	jmp    80103c12 <end_op+0x62>
80103cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103ce0:	83 ec 0c             	sub    $0xc,%esp
80103ce3:	68 c0 97 11 80       	push   $0x801197c0
80103ce8:	e8 f3 11 00 00       	call   80104ee0 <wakeup>
  release(&log.lock);
80103ced:	c7 04 24 c0 97 11 80 	movl   $0x801197c0,(%esp)
80103cf4:	e8 27 17 00 00       	call   80105420 <release>
80103cf9:	83 c4 10             	add    $0x10,%esp
}
80103cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cff:	5b                   	pop    %ebx
80103d00:	5e                   	pop    %esi
80103d01:	5f                   	pop    %edi
80103d02:	5d                   	pop    %ebp
80103d03:	c3                   	ret    
    panic("log.committing");
80103d04:	83 ec 0c             	sub    $0xc,%esp
80103d07:	68 24 89 10 80       	push   $0x80108924
80103d0c:	e8 7f c6 ff ff       	call   80100390 <panic>
80103d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d1f:	90                   	nop

80103d20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103d20:	f3 0f 1e fb          	endbr32 
80103d24:	55                   	push   %ebp
80103d25:	89 e5                	mov    %esp,%ebp
80103d27:	53                   	push   %ebx
80103d28:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103d2b:	8b 15 08 98 11 80    	mov    0x80119808,%edx
{
80103d31:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103d34:	83 fa 1d             	cmp    $0x1d,%edx
80103d37:	0f 8f 91 00 00 00    	jg     80103dce <log_write+0xae>
80103d3d:	a1 f8 97 11 80       	mov    0x801197f8,%eax
80103d42:	83 e8 01             	sub    $0x1,%eax
80103d45:	39 c2                	cmp    %eax,%edx
80103d47:	0f 8d 81 00 00 00    	jge    80103dce <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103d4d:	a1 fc 97 11 80       	mov    0x801197fc,%eax
80103d52:	85 c0                	test   %eax,%eax
80103d54:	0f 8e 81 00 00 00    	jle    80103ddb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	68 c0 97 11 80       	push   $0x801197c0
80103d62:	e8 f9 15 00 00       	call   80105360 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103d67:	8b 15 08 98 11 80    	mov    0x80119808,%edx
80103d6d:	83 c4 10             	add    $0x10,%esp
80103d70:	85 d2                	test   %edx,%edx
80103d72:	7e 4e                	jle    80103dc2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103d74:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103d77:	31 c0                	xor    %eax,%eax
80103d79:	eb 0c                	jmp    80103d87 <log_write+0x67>
80103d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d7f:	90                   	nop
80103d80:	83 c0 01             	add    $0x1,%eax
80103d83:	39 c2                	cmp    %eax,%edx
80103d85:	74 29                	je     80103db0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103d87:	39 0c 85 0c 98 11 80 	cmp    %ecx,-0x7fee67f4(,%eax,4)
80103d8e:	75 f0                	jne    80103d80 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103d90:	89 0c 85 0c 98 11 80 	mov    %ecx,-0x7fee67f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103d97:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80103d9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103d9d:	c7 45 08 c0 97 11 80 	movl   $0x801197c0,0x8(%ebp)
}
80103da4:	c9                   	leave  
  release(&log.lock);
80103da5:	e9 76 16 00 00       	jmp    80105420 <release>
80103daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103db0:	89 0c 95 0c 98 11 80 	mov    %ecx,-0x7fee67f4(,%edx,4)
    log.lh.n++;
80103db7:	83 c2 01             	add    $0x1,%edx
80103dba:	89 15 08 98 11 80    	mov    %edx,0x80119808
80103dc0:	eb d5                	jmp    80103d97 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103dc2:	8b 43 08             	mov    0x8(%ebx),%eax
80103dc5:	a3 0c 98 11 80       	mov    %eax,0x8011980c
  if (i == log.lh.n)
80103dca:	75 cb                	jne    80103d97 <log_write+0x77>
80103dcc:	eb e9                	jmp    80103db7 <log_write+0x97>
    panic("too big a transaction");
80103dce:	83 ec 0c             	sub    $0xc,%esp
80103dd1:	68 33 89 10 80       	push   $0x80108933
80103dd6:	e8 b5 c5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103ddb:	83 ec 0c             	sub    $0xc,%esp
80103dde:	68 49 89 10 80       	push   $0x80108949
80103de3:	e8 a8 c5 ff ff       	call   80100390 <panic>
80103de8:	66 90                	xchg   %ax,%ax
80103dea:	66 90                	xchg   %ax,%ax
80103dec:	66 90                	xchg   %ax,%ax
80103dee:	66 90                	xchg   %ax,%ax

80103df0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103df7:	e8 54 09 00 00       	call   80104750 <cpuid>
80103dfc:	89 c3                	mov    %eax,%ebx
80103dfe:	e8 4d 09 00 00       	call   80104750 <cpuid>
80103e03:	83 ec 04             	sub    $0x4,%esp
80103e06:	53                   	push   %ebx
80103e07:	50                   	push   %eax
80103e08:	68 64 89 10 80       	push   $0x80108964
80103e0d:	e8 9e c8 ff ff       	call   801006b0 <cprintf>
  idtinit();                    // load idt register
80103e12:	e8 29 2a 00 00       	call   80106840 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103e17:	e8 c4 08 00 00       	call   801046e0 <mycpu>
80103e1c:	89 c2                	mov    %eax,%edx
  asm volatile("lock; xchgl %0, %1" :
80103e1e:	b8 01 00 00 00       	mov    $0x1,%eax
80103e23:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();                  // start running processes
80103e2a:	e8 21 0c 00 00       	call   80104a50 <scheduler>
80103e2f:	90                   	nop

80103e30 <mpenter>:
{
80103e30:	f3 0f 1e fb          	endbr32 
80103e34:	55                   	push   %ebp
80103e35:	89 e5                	mov    %esp,%ebp
80103e37:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103e3a:	e8 51 3b 00 00       	call   80107990 <switchkvm>
  seginit();
80103e3f:	e8 bc 38 00 00       	call   80107700 <seginit>
  lapicinit();
80103e44:	e8 67 f7 ff ff       	call   801035b0 <lapicinit>
  mpmain();
80103e49:	e8 a2 ff ff ff       	call   80103df0 <mpmain>
80103e4e:	66 90                	xchg   %ax,%ax

80103e50 <main>:
{
80103e50:	f3 0f 1e fb          	endbr32 
80103e54:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103e58:	83 e4 f0             	and    $0xfffffff0,%esp
80103e5b:	ff 71 fc             	pushl  -0x4(%ecx)
80103e5e:	55                   	push   %ebp
80103e5f:	89 e5                	mov    %esp,%ebp
80103e61:	53                   	push   %ebx
80103e62:	51                   	push   %ecx
  kinit1(end, P2V(4 * 1024 * 1024));          // phys page allocator
80103e63:	83 ec 08             	sub    $0x8,%esp
80103e66:	68 00 00 40 80       	push   $0x80400000
80103e6b:	68 e8 c5 11 80       	push   $0x8011c5e8
80103e70:	e8 0b e8 ff ff       	call   80102680 <kinit1>
  kvmalloc();                                 // kernel page table
80103e75:	e8 16 40 00 00       	call   80107e90 <kvmalloc>
  mpinit();                                   // detect other processors
80103e7a:	e8 81 01 00 00       	call   80104000 <mpinit>
  lapicinit();                                // interrupt controller
80103e7f:	e8 2c f7 ff ff       	call   801035b0 <lapicinit>
  seginit();                                  // segment descriptors
80103e84:	e8 77 38 00 00       	call   80107700 <seginit>
  picinit();                                  // disable pic
80103e89:	e8 52 03 00 00       	call   801041e0 <picinit>
  ioapicinit();                               // another interrupt controller
80103e8e:	e8 fd e5 ff ff       	call   80102490 <ioapicinit>
  consoleinit();                              // console hardware
80103e93:	e8 98 cb ff ff       	call   80100a30 <consoleinit>
  uartinit();                                 // serial port
80103e98:	e8 e3 2c 00 00       	call   80106b80 <uartinit>
  pinit();                                    // process table
80103e9d:	e8 1e 08 00 00       	call   801046c0 <pinit>
  tvinit();                                   // trap vectors
80103ea2:	e8 19 29 00 00       	call   801067c0 <tvinit>
  binit();                                    // buffer cache
80103ea7:	e8 94 c1 ff ff       	call   80100040 <binit>
  fileinit();                                 // file table
80103eac:	e8 2f cf ff ff       	call   80100de0 <fileinit>
  ideinit();                                  // disk
80103eb1:	e8 aa e3 ff ff       	call   80102260 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103eb6:	83 c4 0c             	add    $0xc,%esp
80103eb9:	68 8a 00 00 00       	push   $0x8a
80103ebe:	68 8c b4 10 80       	push   $0x8010b48c
80103ec3:	68 00 70 00 80       	push   $0x80007000
80103ec8:	e8 43 16 00 00       	call   80105510 <memmove>

  for (c = cpus; c < cpus + ncpu; c++)
80103ecd:	83 c4 10             	add    $0x10,%esp
80103ed0:	69 05 40 9e 11 80 b0 	imul   $0xb0,0x80119e40,%eax
80103ed7:	00 00 00 
80103eda:	05 c0 98 11 80       	add    $0x801198c0,%eax
80103edf:	3d c0 98 11 80       	cmp    $0x801198c0,%eax
80103ee4:	76 7a                	jbe    80103f60 <main+0x110>
80103ee6:	bb c0 98 11 80       	mov    $0x801198c0,%ebx
80103eeb:	eb 1c                	jmp    80103f09 <main+0xb9>
80103eed:	8d 76 00             	lea    0x0(%esi),%esi
80103ef0:	69 05 40 9e 11 80 b0 	imul   $0xb0,0x80119e40,%eax
80103ef7:	00 00 00 
80103efa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103f00:	05 c0 98 11 80       	add    $0x801198c0,%eax
80103f05:	39 c3                	cmp    %eax,%ebx
80103f07:	73 57                	jae    80103f60 <main+0x110>
  {
    if (c == mycpu()) // We've started already.
80103f09:	e8 d2 07 00 00       	call   801046e0 <mycpu>
80103f0e:	39 c3                	cmp    %eax,%ebx
80103f10:	74 de                	je     80103ef0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103f12:	e8 f9 f2 ff ff       	call   80103210 <kalloc>
    *(void **)(code - 4) = stack + KSTACKSIZE;
    *(void (**)(void))(code - 8) = mpenter;
    *(int **)(code - 12) = (void *)V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103f17:	83 ec 08             	sub    $0x8,%esp
    *(void (**)(void))(code - 8) = mpenter;
80103f1a:	c7 05 f8 6f 00 80 30 	movl   $0x80103e30,0x80006ff8
80103f21:	3e 10 80 
    *(int **)(code - 12) = (void *)V2P(entrypgdir);
80103f24:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103f2b:	a0 10 00 
    *(void **)(code - 4) = stack + KSTACKSIZE;
80103f2e:	05 00 10 00 00       	add    $0x1000,%eax
80103f33:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103f38:	0f b6 03             	movzbl (%ebx),%eax
80103f3b:	68 00 70 00 00       	push   $0x7000
80103f40:	50                   	push   %eax
80103f41:	e8 ba f7 ff ff       	call   80103700 <lapicstartap>

    // wait for cpu to finish mpmain()
    while (c->started == 0)
80103f46:	83 c4 10             	add    $0x10,%esp
80103f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f50:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103f56:	85 c0                	test   %eax,%eax
80103f58:	74 f6                	je     80103f50 <main+0x100>
80103f5a:	eb 94                	jmp    80103ef0 <main+0xa0>
80103f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
80103f60:	83 ec 08             	sub    $0x8,%esp
80103f63:	68 00 00 40 80       	push   $0x80400000
80103f68:	68 00 00 40 80       	push   $0x80400000
80103f6d:	e8 1e e9 ff ff       	call   80102890 <kinit2>
  userinit();                                 // first user process
80103f72:	e8 29 08 00 00       	call   801047a0 <userinit>
  mpmain();                                   // finish this processor's setup
80103f77:	e8 74 fe ff ff       	call   80103df0 <mpmain>
80103f7c:	66 90                	xchg   %ax,%ax
80103f7e:	66 90                	xchg   %ax,%ax

80103f80 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	57                   	push   %edi
80103f84:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103f85:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103f8b:	53                   	push   %ebx
  e = addr+len;
80103f8c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103f8f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103f92:	39 de                	cmp    %ebx,%esi
80103f94:	72 10                	jb     80103fa6 <mpsearch1+0x26>
80103f96:	eb 50                	jmp    80103fe8 <mpsearch1+0x68>
80103f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f9f:	90                   	nop
80103fa0:	89 fe                	mov    %edi,%esi
80103fa2:	39 fb                	cmp    %edi,%ebx
80103fa4:	76 42                	jbe    80103fe8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103fa6:	83 ec 04             	sub    $0x4,%esp
80103fa9:	8d 7e 10             	lea    0x10(%esi),%edi
80103fac:	6a 04                	push   $0x4
80103fae:	68 78 89 10 80       	push   $0x80108978
80103fb3:	56                   	push   %esi
80103fb4:	e8 07 15 00 00       	call   801054c0 <memcmp>
80103fb9:	83 c4 10             	add    $0x10,%esp
80103fbc:	85 c0                	test   %eax,%eax
80103fbe:	75 e0                	jne    80103fa0 <mpsearch1+0x20>
80103fc0:	89 f2                	mov    %esi,%edx
80103fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103fc8:	0f b6 0a             	movzbl (%edx),%ecx
80103fcb:	83 c2 01             	add    $0x1,%edx
80103fce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103fd0:	39 fa                	cmp    %edi,%edx
80103fd2:	75 f4                	jne    80103fc8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103fd4:	84 c0                	test   %al,%al
80103fd6:	75 c8                	jne    80103fa0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fdb:	89 f0                	mov    %esi,%eax
80103fdd:	5b                   	pop    %ebx
80103fde:	5e                   	pop    %esi
80103fdf:	5f                   	pop    %edi
80103fe0:	5d                   	pop    %ebp
80103fe1:	c3                   	ret    
80103fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103feb:	31 f6                	xor    %esi,%esi
}
80103fed:	5b                   	pop    %ebx
80103fee:	89 f0                	mov    %esi,%eax
80103ff0:	5e                   	pop    %esi
80103ff1:	5f                   	pop    %edi
80103ff2:	5d                   	pop    %ebp
80103ff3:	c3                   	ret    
80103ff4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fff:	90                   	nop

80104000 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80104000:	f3 0f 1e fb          	endbr32 
80104004:	55                   	push   %ebp
80104005:	89 e5                	mov    %esp,%ebp
80104007:	57                   	push   %edi
80104008:	56                   	push   %esi
80104009:	53                   	push   %ebx
8010400a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010400d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80104014:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010401b:	c1 e0 08             	shl    $0x8,%eax
8010401e:	09 d0                	or     %edx,%eax
80104020:	c1 e0 04             	shl    $0x4,%eax
80104023:	75 1b                	jne    80104040 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80104025:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010402c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80104033:	c1 e0 08             	shl    $0x8,%eax
80104036:	09 d0                	or     %edx,%eax
80104038:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010403b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80104040:	ba 00 04 00 00       	mov    $0x400,%edx
80104045:	e8 36 ff ff ff       	call   80103f80 <mpsearch1>
8010404a:	89 c6                	mov    %eax,%esi
8010404c:	85 c0                	test   %eax,%eax
8010404e:	0f 84 4c 01 00 00    	je     801041a0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104054:	8b 5e 04             	mov    0x4(%esi),%ebx
80104057:	85 db                	test   %ebx,%ebx
80104059:	0f 84 61 01 00 00    	je     801041c0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010405f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80104062:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80104068:	6a 04                	push   $0x4
8010406a:	68 7d 89 10 80       	push   $0x8010897d
8010406f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80104070:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80104073:	e8 48 14 00 00       	call   801054c0 <memcmp>
80104078:	83 c4 10             	add    $0x10,%esp
8010407b:	85 c0                	test   %eax,%eax
8010407d:	0f 85 3d 01 00 00    	jne    801041c0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80104083:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010408a:	3c 01                	cmp    $0x1,%al
8010408c:	74 08                	je     80104096 <mpinit+0x96>
8010408e:	3c 04                	cmp    $0x4,%al
80104090:	0f 85 2a 01 00 00    	jne    801041c0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80104096:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010409d:	66 85 d2             	test   %dx,%dx
801040a0:	74 26                	je     801040c8 <mpinit+0xc8>
801040a2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801040a5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801040a7:	31 d2                	xor    %edx,%edx
801040a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801040b0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801040b7:	83 c0 01             	add    $0x1,%eax
801040ba:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801040bc:	39 f8                	cmp    %edi,%eax
801040be:	75 f0                	jne    801040b0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801040c0:	84 d2                	test   %dl,%dl
801040c2:	0f 85 f8 00 00 00    	jne    801041c0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801040c8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801040ce:	a3 b8 97 11 80       	mov    %eax,0x801197b8
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801040d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801040d9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801040e0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801040e5:	03 55 e4             	add    -0x1c(%ebp),%edx
801040e8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801040eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040ef:	90                   	nop
801040f0:	39 c2                	cmp    %eax,%edx
801040f2:	76 15                	jbe    80104109 <mpinit+0x109>
    switch(*p){
801040f4:	0f b6 08             	movzbl (%eax),%ecx
801040f7:	80 f9 02             	cmp    $0x2,%cl
801040fa:	74 5c                	je     80104158 <mpinit+0x158>
801040fc:	77 42                	ja     80104140 <mpinit+0x140>
801040fe:	84 c9                	test   %cl,%cl
80104100:	74 6e                	je     80104170 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104102:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104105:	39 c2                	cmp    %eax,%edx
80104107:	77 eb                	ja     801040f4 <mpinit+0xf4>
80104109:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010410c:	85 db                	test   %ebx,%ebx
8010410e:	0f 84 b9 00 00 00    	je     801041cd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80104114:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80104118:	74 15                	je     8010412f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010411a:	b8 70 00 00 00       	mov    $0x70,%eax
8010411f:	ba 22 00 00 00       	mov    $0x22,%edx
80104124:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104125:	ba 23 00 00 00       	mov    $0x23,%edx
8010412a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010412b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010412e:	ee                   	out    %al,(%dx)
  }
}
8010412f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104132:	5b                   	pop    %ebx
80104133:	5e                   	pop    %esi
80104134:	5f                   	pop    %edi
80104135:	5d                   	pop    %ebp
80104136:	c3                   	ret    
80104137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413e:	66 90                	xchg   %ax,%ax
    switch(*p){
80104140:	83 e9 03             	sub    $0x3,%ecx
80104143:	80 f9 01             	cmp    $0x1,%cl
80104146:	76 ba                	jbe    80104102 <mpinit+0x102>
80104148:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010414f:	eb 9f                	jmp    801040f0 <mpinit+0xf0>
80104151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80104158:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010415c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010415f:	88 0d a0 98 11 80    	mov    %cl,0x801198a0
      continue;
80104165:	eb 89                	jmp    801040f0 <mpinit+0xf0>
80104167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80104170:	8b 0d 40 9e 11 80    	mov    0x80119e40,%ecx
80104176:	83 f9 07             	cmp    $0x7,%ecx
80104179:	7f 19                	jg     80104194 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010417b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80104181:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80104185:	83 c1 01             	add    $0x1,%ecx
80104188:	89 0d 40 9e 11 80    	mov    %ecx,0x80119e40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010418e:	88 9f c0 98 11 80    	mov    %bl,-0x7fee6740(%edi)
      p += sizeof(struct mpproc);
80104194:	83 c0 14             	add    $0x14,%eax
      continue;
80104197:	e9 54 ff ff ff       	jmp    801040f0 <mpinit+0xf0>
8010419c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801041a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801041a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801041aa:	e8 d1 fd ff ff       	call   80103f80 <mpsearch1>
801041af:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801041b1:	85 c0                	test   %eax,%eax
801041b3:	0f 85 9b fe ff ff    	jne    80104054 <mpinit+0x54>
801041b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801041c0:	83 ec 0c             	sub    $0xc,%esp
801041c3:	68 82 89 10 80       	push   $0x80108982
801041c8:	e8 c3 c1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801041cd:	83 ec 0c             	sub    $0xc,%esp
801041d0:	68 9c 89 10 80       	push   $0x8010899c
801041d5:	e8 b6 c1 ff ff       	call   80100390 <panic>
801041da:	66 90                	xchg   %ax,%ax
801041dc:	66 90                	xchg   %ax,%ax
801041de:	66 90                	xchg   %ax,%ax

801041e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801041e0:	f3 0f 1e fb          	endbr32 
801041e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041e9:	ba 21 00 00 00       	mov    $0x21,%edx
801041ee:	ee                   	out    %al,(%dx)
801041ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801041f4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801041f5:	c3                   	ret    
801041f6:	66 90                	xchg   %ax,%ax
801041f8:	66 90                	xchg   %ax,%ax
801041fa:	66 90                	xchg   %ax,%ax
801041fc:	66 90                	xchg   %ax,%ax
801041fe:	66 90                	xchg   %ax,%ax

80104200 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104200:	f3 0f 1e fb          	endbr32 
80104204:	55                   	push   %ebp
80104205:	89 e5                	mov    %esp,%ebp
80104207:	57                   	push   %edi
80104208:	56                   	push   %esi
80104209:	53                   	push   %ebx
8010420a:	83 ec 0c             	sub    $0xc,%esp
8010420d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104210:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80104213:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104219:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010421f:	e8 dc cb ff ff       	call   80100e00 <filealloc>
80104224:	89 03                	mov    %eax,(%ebx)
80104226:	85 c0                	test   %eax,%eax
80104228:	0f 84 ac 00 00 00    	je     801042da <pipealloc+0xda>
8010422e:	e8 cd cb ff ff       	call   80100e00 <filealloc>
80104233:	89 06                	mov    %eax,(%esi)
80104235:	85 c0                	test   %eax,%eax
80104237:	0f 84 8b 00 00 00    	je     801042c8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010423d:	e8 ce ef ff ff       	call   80103210 <kalloc>
80104242:	89 c7                	mov    %eax,%edi
80104244:	85 c0                	test   %eax,%eax
80104246:	0f 84 b4 00 00 00    	je     80104300 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010424c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104253:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80104256:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80104259:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104260:	00 00 00 
  p->nwrite = 0;
80104263:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010426a:	00 00 00 
  p->nread = 0;
8010426d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104274:	00 00 00 
  initlock(&p->lock, "pipe");
80104277:	68 bb 89 10 80       	push   $0x801089bb
8010427c:	50                   	push   %eax
8010427d:	e8 5e 0f 00 00       	call   801051e0 <initlock>
  (*f0)->type = FD_PIPE;
80104282:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80104284:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104287:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010428d:	8b 03                	mov    (%ebx),%eax
8010428f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104293:	8b 03                	mov    (%ebx),%eax
80104295:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104299:	8b 03                	mov    (%ebx),%eax
8010429b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010429e:	8b 06                	mov    (%esi),%eax
801042a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801042a6:	8b 06                	mov    (%esi),%eax
801042a8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801042ac:	8b 06                	mov    (%esi),%eax
801042ae:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801042b2:	8b 06                	mov    (%esi),%eax
801042b4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801042b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801042ba:	31 c0                	xor    %eax,%eax
}
801042bc:	5b                   	pop    %ebx
801042bd:	5e                   	pop    %esi
801042be:	5f                   	pop    %edi
801042bf:	5d                   	pop    %ebp
801042c0:	c3                   	ret    
801042c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801042c8:	8b 03                	mov    (%ebx),%eax
801042ca:	85 c0                	test   %eax,%eax
801042cc:	74 1e                	je     801042ec <pipealloc+0xec>
    fileclose(*f0);
801042ce:	83 ec 0c             	sub    $0xc,%esp
801042d1:	50                   	push   %eax
801042d2:	e8 e9 cb ff ff       	call   80100ec0 <fileclose>
801042d7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801042da:	8b 06                	mov    (%esi),%eax
801042dc:	85 c0                	test   %eax,%eax
801042de:	74 0c                	je     801042ec <pipealloc+0xec>
    fileclose(*f1);
801042e0:	83 ec 0c             	sub    $0xc,%esp
801042e3:	50                   	push   %eax
801042e4:	e8 d7 cb ff ff       	call   80100ec0 <fileclose>
801042e9:	83 c4 10             	add    $0x10,%esp
}
801042ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801042ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042f4:	5b                   	pop    %ebx
801042f5:	5e                   	pop    %esi
801042f6:	5f                   	pop    %edi
801042f7:	5d                   	pop    %ebp
801042f8:	c3                   	ret    
801042f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80104300:	8b 03                	mov    (%ebx),%eax
80104302:	85 c0                	test   %eax,%eax
80104304:	75 c8                	jne    801042ce <pipealloc+0xce>
80104306:	eb d2                	jmp    801042da <pipealloc+0xda>
80104308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430f:	90                   	nop

80104310 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	56                   	push   %esi
80104318:	53                   	push   %ebx
80104319:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010431c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010431f:	83 ec 0c             	sub    $0xc,%esp
80104322:	53                   	push   %ebx
80104323:	e8 38 10 00 00       	call   80105360 <acquire>
  if(writable){
80104328:	83 c4 10             	add    $0x10,%esp
8010432b:	85 f6                	test   %esi,%esi
8010432d:	74 41                	je     80104370 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010432f:	83 ec 0c             	sub    $0xc,%esp
80104332:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80104338:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010433f:	00 00 00 
    wakeup(&p->nread);
80104342:	50                   	push   %eax
80104343:	e8 98 0b 00 00       	call   80104ee0 <wakeup>
80104348:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010434b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80104351:	85 d2                	test   %edx,%edx
80104353:	75 0a                	jne    8010435f <pipeclose+0x4f>
80104355:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010435b:	85 c0                	test   %eax,%eax
8010435d:	74 31                	je     80104390 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010435f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80104362:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104365:	5b                   	pop    %ebx
80104366:	5e                   	pop    %esi
80104367:	5d                   	pop    %ebp
    release(&p->lock);
80104368:	e9 b3 10 00 00       	jmp    80105420 <release>
8010436d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80104370:	83 ec 0c             	sub    $0xc,%esp
80104373:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80104379:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80104380:	00 00 00 
    wakeup(&p->nwrite);
80104383:	50                   	push   %eax
80104384:	e8 57 0b 00 00       	call   80104ee0 <wakeup>
80104389:	83 c4 10             	add    $0x10,%esp
8010438c:	eb bd                	jmp    8010434b <pipeclose+0x3b>
8010438e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80104390:	83 ec 0c             	sub    $0xc,%esp
80104393:	53                   	push   %ebx
80104394:	e8 87 10 00 00       	call   80105420 <release>
    kfree((char*)p);
80104399:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010439c:	83 c4 10             	add    $0x10,%esp
}
8010439f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043a2:	5b                   	pop    %ebx
801043a3:	5e                   	pop    %esi
801043a4:	5d                   	pop    %ebp
    kfree((char*)p);
801043a5:	e9 d6 e1 ff ff       	jmp    80102580 <kfree>
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043b0 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
801043b0:	f3 0f 1e fb          	endbr32 
801043b4:	55                   	push   %ebp
801043b5:	89 e5                	mov    %esp,%ebp
801043b7:	57                   	push   %edi
801043b8:	56                   	push   %esi
801043b9:	53                   	push   %ebx
801043ba:	83 ec 28             	sub    $0x28,%esp
801043bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801043c0:	53                   	push   %ebx
801043c1:	e8 9a 0f 00 00       	call   80105360 <acquire>
  for(i = 0; i < n; i++){
801043c6:	8b 45 10             	mov    0x10(%ebp),%eax
801043c9:	83 c4 10             	add    $0x10,%esp
801043cc:	85 c0                	test   %eax,%eax
801043ce:	0f 8e bc 00 00 00    	jle    80104490 <pipewrite+0xe0>
801043d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801043d7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801043dd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801043e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043e6:	03 45 10             	add    0x10(%ebp),%eax
801043e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801043ec:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801043f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801043f8:	89 ca                	mov    %ecx,%edx
801043fa:	05 00 02 00 00       	add    $0x200,%eax
801043ff:	39 c1                	cmp    %eax,%ecx
80104401:	74 3b                	je     8010443e <pipewrite+0x8e>
80104403:	eb 63                	jmp    80104468 <pipewrite+0xb8>
80104405:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80104408:	e8 63 03 00 00       	call   80104770 <myproc>
8010440d:	8b 48 24             	mov    0x24(%eax),%ecx
80104410:	85 c9                	test   %ecx,%ecx
80104412:	75 34                	jne    80104448 <pipewrite+0x98>
      wakeup(&p->nread);
80104414:	83 ec 0c             	sub    $0xc,%esp
80104417:	57                   	push   %edi
80104418:	e8 c3 0a 00 00       	call   80104ee0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010441d:	58                   	pop    %eax
8010441e:	5a                   	pop    %edx
8010441f:	53                   	push   %ebx
80104420:	56                   	push   %esi
80104421:	e8 fa 08 00 00       	call   80104d20 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104426:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010442c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80104432:	83 c4 10             	add    $0x10,%esp
80104435:	05 00 02 00 00       	add    $0x200,%eax
8010443a:	39 c2                	cmp    %eax,%edx
8010443c:	75 2a                	jne    80104468 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010443e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80104444:	85 c0                	test   %eax,%eax
80104446:	75 c0                	jne    80104408 <pipewrite+0x58>
        release(&p->lock);
80104448:	83 ec 0c             	sub    $0xc,%esp
8010444b:	53                   	push   %ebx
8010444c:	e8 cf 0f 00 00       	call   80105420 <release>
        return -1;
80104451:	83 c4 10             	add    $0x10,%esp
80104454:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80104459:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010445c:	5b                   	pop    %ebx
8010445d:	5e                   	pop    %esi
8010445e:	5f                   	pop    %edi
8010445f:	5d                   	pop    %ebp
80104460:	c3                   	ret    
80104461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104468:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010446b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010446e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80104474:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010447a:	0f b6 06             	movzbl (%esi),%eax
8010447d:	83 c6 01             	add    $0x1,%esi
80104480:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80104483:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80104487:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010448a:	0f 85 5c ff ff ff    	jne    801043ec <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104490:	83 ec 0c             	sub    $0xc,%esp
80104493:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104499:	50                   	push   %eax
8010449a:	e8 41 0a 00 00       	call   80104ee0 <wakeup>
  release(&p->lock);
8010449f:	89 1c 24             	mov    %ebx,(%esp)
801044a2:	e8 79 0f 00 00       	call   80105420 <release>
  return n;
801044a7:	8b 45 10             	mov    0x10(%ebp),%eax
801044aa:	83 c4 10             	add    $0x10,%esp
801044ad:	eb aa                	jmp    80104459 <pipewrite+0xa9>
801044af:	90                   	nop

801044b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801044b0:	f3 0f 1e fb          	endbr32 
801044b4:	55                   	push   %ebp
801044b5:	89 e5                	mov    %esp,%ebp
801044b7:	57                   	push   %edi
801044b8:	56                   	push   %esi
801044b9:	53                   	push   %ebx
801044ba:	83 ec 18             	sub    $0x18,%esp
801044bd:	8b 75 08             	mov    0x8(%ebp),%esi
801044c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801044c3:	56                   	push   %esi
801044c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801044ca:	e8 91 0e 00 00       	call   80105360 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801044cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801044d5:	83 c4 10             	add    $0x10,%esp
801044d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801044de:	74 33                	je     80104513 <piperead+0x63>
801044e0:	eb 3b                	jmp    8010451d <piperead+0x6d>
801044e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801044e8:	e8 83 02 00 00       	call   80104770 <myproc>
801044ed:	8b 48 24             	mov    0x24(%eax),%ecx
801044f0:	85 c9                	test   %ecx,%ecx
801044f2:	0f 85 88 00 00 00    	jne    80104580 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801044f8:	83 ec 08             	sub    $0x8,%esp
801044fb:	56                   	push   %esi
801044fc:	53                   	push   %ebx
801044fd:	e8 1e 08 00 00       	call   80104d20 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104502:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80104508:	83 c4 10             	add    $0x10,%esp
8010450b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80104511:	75 0a                	jne    8010451d <piperead+0x6d>
80104513:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80104519:	85 c0                	test   %eax,%eax
8010451b:	75 cb                	jne    801044e8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010451d:	8b 55 10             	mov    0x10(%ebp),%edx
80104520:	31 db                	xor    %ebx,%ebx
80104522:	85 d2                	test   %edx,%edx
80104524:	7f 28                	jg     8010454e <piperead+0x9e>
80104526:	eb 34                	jmp    8010455c <piperead+0xac>
80104528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104530:	8d 48 01             	lea    0x1(%eax),%ecx
80104533:	25 ff 01 00 00       	and    $0x1ff,%eax
80104538:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010453e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104543:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104546:	83 c3 01             	add    $0x1,%ebx
80104549:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010454c:	74 0e                	je     8010455c <piperead+0xac>
    if(p->nread == p->nwrite)
8010454e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104554:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010455a:	75 d4                	jne    80104530 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010455c:	83 ec 0c             	sub    $0xc,%esp
8010455f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104565:	50                   	push   %eax
80104566:	e8 75 09 00 00       	call   80104ee0 <wakeup>
  release(&p->lock);
8010456b:	89 34 24             	mov    %esi,(%esp)
8010456e:	e8 ad 0e 00 00       	call   80105420 <release>
  return i;
80104573:	83 c4 10             	add    $0x10,%esp
}
80104576:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104579:	89 d8                	mov    %ebx,%eax
8010457b:	5b                   	pop    %ebx
8010457c:	5e                   	pop    %esi
8010457d:	5f                   	pop    %edi
8010457e:	5d                   	pop    %ebp
8010457f:	c3                   	ret    
      release(&p->lock);
80104580:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104583:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104588:	56                   	push   %esi
80104589:	e8 92 0e 00 00       	call   80105420 <release>
      return -1;
8010458e:	83 c4 10             	add    $0x10,%esp
}
80104591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104594:	89 d8                	mov    %ebx,%eax
80104596:	5b                   	pop    %ebx
80104597:	5e                   	pop    %esi
80104598:	5f                   	pop    %edi
80104599:	5d                   	pop    %ebp
8010459a:	c3                   	ret    
8010459b:	66 90                	xchg   %ax,%ax
8010459d:	66 90                	xchg   %ax,%ax
8010459f:	90                   	nop

801045a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045a4:	bb 94 9e 11 80       	mov    $0x80119e94,%ebx
{
801045a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801045ac:	68 60 9e 11 80       	push   $0x80119e60
801045b1:	e8 aa 0d 00 00       	call   80105360 <acquire>
801045b6:	83 c4 10             	add    $0x10,%esp
801045b9:	eb 10                	jmp    801045cb <allocproc+0x2b>
801045bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045bf:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045c0:	83 c3 7c             	add    $0x7c,%ebx
801045c3:	81 fb 94 bd 11 80    	cmp    $0x8011bd94,%ebx
801045c9:	74 75                	je     80104640 <allocproc+0xa0>
    if (p->state == UNUSED)
801045cb:	8b 43 0c             	mov    0xc(%ebx),%eax
801045ce:	85 c0                	test   %eax,%eax
801045d0:	75 ee                	jne    801045c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801045d2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801045d7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801045da:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801045e1:	89 43 10             	mov    %eax,0x10(%ebx)
801045e4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801045e7:	68 60 9e 11 80       	push   $0x80119e60
  p->pid = nextpid++;
801045ec:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801045f2:	e8 29 0e 00 00       	call   80105420 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
801045f7:	e8 14 ec ff ff       	call   80103210 <kalloc>
801045fc:	83 c4 10             	add    $0x10,%esp
801045ff:	89 43 08             	mov    %eax,0x8(%ebx)
80104602:	85 c0                	test   %eax,%eax
80104604:	74 53                	je     80104659 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104606:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
8010460c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010460f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104614:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80104617:	c7 40 14 a6 67 10 80 	movl   $0x801067a6,0x14(%eax)
  p->context = (struct context *)sp;
8010461e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104621:	6a 14                	push   $0x14
80104623:	6a 00                	push   $0x0
80104625:	50                   	push   %eax
80104626:	e8 45 0e 00 00       	call   80105470 <memset>
  p->context->eip = (uint)forkret;
8010462b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010462e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104631:	c7 40 10 70 46 10 80 	movl   $0x80104670,0x10(%eax)
}
80104638:	89 d8                	mov    %ebx,%eax
8010463a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010463d:	c9                   	leave  
8010463e:	c3                   	ret    
8010463f:	90                   	nop
  release(&ptable.lock);
80104640:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104643:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104645:	68 60 9e 11 80       	push   $0x80119e60
8010464a:	e8 d1 0d 00 00       	call   80105420 <release>
}
8010464f:	89 d8                	mov    %ebx,%eax
  return 0;
80104651:	83 c4 10             	add    $0x10,%esp
}
80104654:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104657:	c9                   	leave  
80104658:	c3                   	ret    
    p->state = UNUSED;
80104659:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104660:	31 db                	xor    %ebx,%ebx
}
80104662:	89 d8                	mov    %ebx,%eax
80104664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104667:	c9                   	leave  
80104668:	c3                   	ret    
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104670 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
80104670:	f3 0f 1e fb          	endbr32 
80104674:	55                   	push   %ebp
80104675:	89 e5                	mov    %esp,%ebp
80104677:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010467a:	68 60 9e 11 80       	push   $0x80119e60
8010467f:	e8 9c 0d 00 00       	call   80105420 <release>

  if (first)
80104684:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104689:	83 c4 10             	add    $0x10,%esp
8010468c:	85 c0                	test   %eax,%eax
8010468e:	75 08                	jne    80104698 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104690:	c9                   	leave  
80104691:	c3                   	ret    
80104692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104698:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010469f:	00 00 00 
    iinit(ROOTDEV);
801046a2:	83 ec 0c             	sub    $0xc,%esp
801046a5:	6a 01                	push   $0x1
801046a7:	e8 94 ce ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801046ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801046b3:	e8 e8 f3 ff ff       	call   80103aa0 <initlog>
}
801046b8:	83 c4 10             	add    $0x10,%esp
801046bb:	c9                   	leave  
801046bc:	c3                   	ret    
801046bd:	8d 76 00             	lea    0x0(%esi),%esi

801046c0 <pinit>:
{
801046c0:	f3 0f 1e fb          	endbr32 
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801046ca:	68 c0 89 10 80       	push   $0x801089c0
801046cf:	68 60 9e 11 80       	push   $0x80119e60
801046d4:	e8 07 0b 00 00       	call   801051e0 <initlock>
}
801046d9:	83 c4 10             	add    $0x10,%esp
801046dc:	c9                   	leave  
801046dd:	c3                   	ret    
801046de:	66 90                	xchg   %ax,%ax

801046e0 <mycpu>:
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	56                   	push   %esi
801046e8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046e9:	9c                   	pushf  
801046ea:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801046eb:	f6 c4 02             	test   $0x2,%ah
801046ee:	75 4a                	jne    8010473a <mycpu+0x5a>
  apicid = lapicid();
801046f0:	e8 bb ef ff ff       	call   801036b0 <lapicid>
  for (i = 0; i < ncpu; ++i)
801046f5:	8b 35 40 9e 11 80    	mov    0x80119e40,%esi
  apicid = lapicid();
801046fb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i)
801046fd:	85 f6                	test   %esi,%esi
801046ff:	7e 2c                	jle    8010472d <mycpu+0x4d>
80104701:	31 d2                	xor    %edx,%edx
80104703:	eb 0a                	jmp    8010470f <mycpu+0x2f>
80104705:	8d 76 00             	lea    0x0(%esi),%esi
80104708:	83 c2 01             	add    $0x1,%edx
8010470b:	39 f2                	cmp    %esi,%edx
8010470d:	74 1e                	je     8010472d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010470f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104715:	0f b6 81 c0 98 11 80 	movzbl -0x7fee6740(%ecx),%eax
8010471c:	39 d8                	cmp    %ebx,%eax
8010471e:	75 e8                	jne    80104708 <mycpu+0x28>
}
80104720:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104723:	8d 81 c0 98 11 80    	lea    -0x7fee6740(%ecx),%eax
}
80104729:	5b                   	pop    %ebx
8010472a:	5e                   	pop    %esi
8010472b:	5d                   	pop    %ebp
8010472c:	c3                   	ret    
  panic("unknown apicid\n");
8010472d:	83 ec 0c             	sub    $0xc,%esp
80104730:	68 c7 89 10 80       	push   $0x801089c7
80104735:	e8 56 bc ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010473a:	83 ec 0c             	sub    $0xc,%esp
8010473d:	68 a0 8a 10 80       	push   $0x80108aa0
80104742:	e8 49 bc ff ff       	call   80100390 <panic>
80104747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474e:	66 90                	xchg   %ax,%ax

80104750 <cpuid>:
{
80104750:	f3 0f 1e fb          	endbr32 
80104754:	55                   	push   %ebp
80104755:	89 e5                	mov    %esp,%ebp
80104757:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
8010475a:	e8 81 ff ff ff       	call   801046e0 <mycpu>
}
8010475f:	c9                   	leave  
  return mycpu() - cpus;
80104760:	2d c0 98 11 80       	sub    $0x801198c0,%eax
80104765:	c1 f8 04             	sar    $0x4,%eax
80104768:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010476e:	c3                   	ret    
8010476f:	90                   	nop

80104770 <myproc>:
{
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	53                   	push   %ebx
80104778:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010477b:	e8 e0 0a 00 00       	call   80105260 <pushcli>
  c = mycpu();
80104780:	e8 5b ff ff ff       	call   801046e0 <mycpu>
  p = c->proc;
80104785:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010478b:	e8 20 0b 00 00       	call   801052b0 <popcli>
}
80104790:	83 c4 04             	add    $0x4,%esp
80104793:	89 d8                	mov    %ebx,%eax
80104795:	5b                   	pop    %ebx
80104796:	5d                   	pop    %ebp
80104797:	c3                   	ret    
80104798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479f:	90                   	nop

801047a0 <userinit>:
{
801047a0:	f3 0f 1e fb          	endbr32 
801047a4:	55                   	push   %ebp
801047a5:	89 e5                	mov    %esp,%ebp
801047a7:	53                   	push   %ebx
801047a8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801047ab:	e8 f0 fd ff ff       	call   801045a0 <allocproc>
801047b0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801047b2:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if ((p->pgdir = setupkvm()) == 0)
801047b7:	e8 54 36 00 00       	call   80107e10 <setupkvm>
801047bc:	89 43 04             	mov    %eax,0x4(%ebx)
801047bf:	85 c0                	test   %eax,%eax
801047c1:	0f 84 d6 00 00 00    	je     8010489d <userinit+0xfd>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
801047c7:	83 ec 04             	sub    $0x4,%esp
801047ca:	68 2c 00 00 00       	push   $0x2c
801047cf:	68 60 b4 10 80       	push   $0x8010b460
801047d4:	68 f0 89 10 80       	push   $0x801089f0
801047d9:	e8 d2 be ff ff       	call   801006b0 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047de:	83 c4 0c             	add    $0xc,%esp
801047e1:	68 2c 00 00 00       	push   $0x2c
801047e6:	68 60 b4 10 80       	push   $0x8010b460
801047eb:	ff 73 04             	pushl  0x4(%ebx)
801047ee:	e8 cd 32 00 00       	call   80107ac0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801047f3:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801047f6:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801047fc:	6a 4c                	push   $0x4c
801047fe:	6a 00                	push   $0x0
80104800:	ff 73 18             	pushl  0x18(%ebx)
80104803:	e8 68 0c 00 00       	call   80105470 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104808:	8b 43 18             	mov    0x18(%ebx),%eax
8010480b:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104810:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104813:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104818:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010481c:	8b 43 18             	mov    0x18(%ebx),%eax
8010481f:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104823:	8b 43 18             	mov    0x18(%ebx),%eax
80104826:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010482a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010482e:	8b 43 18             	mov    0x18(%ebx),%eax
80104831:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104835:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104839:	8b 43 18             	mov    0x18(%ebx),%eax
8010483c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104843:	8b 43 18             	mov    0x18(%ebx),%eax
80104846:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
8010484d:	8b 43 18             	mov    0x18(%ebx),%eax
80104850:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104857:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010485a:	6a 10                	push   $0x10
8010485c:	68 f7 89 10 80       	push   $0x801089f7
80104861:	50                   	push   %eax
80104862:	e8 c9 0d 00 00       	call   80105630 <safestrcpy>
  p->cwd = namei("/");
80104867:	c7 04 24 00 8a 10 80 	movl   $0x80108a00,(%esp)
8010486e:	e8 bd d7 ff ff       	call   80102030 <namei>
80104873:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104876:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
8010487d:	e8 de 0a 00 00       	call   80105360 <acquire>
  p->state = RUNNABLE;
80104882:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104889:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
80104890:	e8 8b 0b 00 00       	call   80105420 <release>
}
80104895:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104898:	83 c4 10             	add    $0x10,%esp
8010489b:	c9                   	leave  
8010489c:	c3                   	ret    
    panic("userinit: out of memory?");
8010489d:	83 ec 0c             	sub    $0xc,%esp
801048a0:	68 d7 89 10 80       	push   $0x801089d7
801048a5:	e8 e6 ba ff ff       	call   80100390 <panic>
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048b0 <growproc>:
{
801048b0:	f3 0f 1e fb          	endbr32 
801048b4:	55                   	push   %ebp
801048b5:	89 e5                	mov    %esp,%ebp
801048b7:	56                   	push   %esi
801048b8:	53                   	push   %ebx
801048b9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801048bc:	e8 9f 09 00 00       	call   80105260 <pushcli>
  c = mycpu();
801048c1:	e8 1a fe ff ff       	call   801046e0 <mycpu>
  p = c->proc;
801048c6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048cc:	e8 df 09 00 00       	call   801052b0 <popcli>
  sz = curproc->sz;
801048d1:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
801048d3:	85 f6                	test   %esi,%esi
801048d5:	7f 19                	jg     801048f0 <growproc+0x40>
  else if (n < 0)
801048d7:	75 37                	jne    80104910 <growproc+0x60>
  switchuvm(curproc);
801048d9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801048dc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801048de:	53                   	push   %ebx
801048df:	e8 cc 30 00 00       	call   801079b0 <switchuvm>
  return 0;
801048e4:	83 c4 10             	add    $0x10,%esp
801048e7:	31 c0                	xor    %eax,%eax
}
801048e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048ec:	5b                   	pop    %ebx
801048ed:	5e                   	pop    %esi
801048ee:	5d                   	pop    %ebp
801048ef:	c3                   	ret    
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801048f0:	83 ec 04             	sub    $0x4,%esp
801048f3:	01 c6                	add    %eax,%esi
801048f5:	56                   	push   %esi
801048f6:	50                   	push   %eax
801048f7:	ff 73 04             	pushl  0x4(%ebx)
801048fa:	e8 21 33 00 00       	call   80107c20 <allocuvm>
801048ff:	83 c4 10             	add    $0x10,%esp
80104902:	85 c0                	test   %eax,%eax
80104904:	75 d3                	jne    801048d9 <growproc+0x29>
      return -1;
80104906:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010490b:	eb dc                	jmp    801048e9 <growproc+0x39>
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104910:	83 ec 04             	sub    $0x4,%esp
80104913:	01 c6                	add    %eax,%esi
80104915:	56                   	push   %esi
80104916:	50                   	push   %eax
80104917:	ff 73 04             	pushl  0x4(%ebx)
8010491a:	e8 41 34 00 00       	call   80107d60 <deallocuvm>
8010491f:	83 c4 10             	add    $0x10,%esp
80104922:	85 c0                	test   %eax,%eax
80104924:	75 b3                	jne    801048d9 <growproc+0x29>
80104926:	eb de                	jmp    80104906 <growproc+0x56>
80104928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492f:	90                   	nop

80104930 <fork>:
{
80104930:	f3 0f 1e fb          	endbr32 
80104934:	55                   	push   %ebp
80104935:	89 e5                	mov    %esp,%ebp
80104937:	57                   	push   %edi
80104938:	56                   	push   %esi
80104939:	53                   	push   %ebx
8010493a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010493d:	e8 1e 09 00 00       	call   80105260 <pushcli>
  c = mycpu();
80104942:	e8 99 fd ff ff       	call   801046e0 <mycpu>
  p = c->proc;
80104947:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010494d:	e8 5e 09 00 00       	call   801052b0 <popcli>
  if ((np = allocproc()) == 0)
80104952:	e8 49 fc ff ff       	call   801045a0 <allocproc>
80104957:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010495a:	85 c0                	test   %eax,%eax
8010495c:	0f 84 bb 00 00 00    	je     80104a1d <fork+0xed>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80104962:	83 ec 08             	sub    $0x8,%esp
80104965:	ff 33                	pushl  (%ebx)
80104967:	89 c7                	mov    %eax,%edi
80104969:	ff 73 04             	pushl  0x4(%ebx)
8010496c:	e8 6f 35 00 00       	call   80107ee0 <copyuvm>
80104971:	83 c4 10             	add    $0x10,%esp
80104974:	89 47 04             	mov    %eax,0x4(%edi)
80104977:	85 c0                	test   %eax,%eax
80104979:	0f 84 a5 00 00 00    	je     80104a24 <fork+0xf4>
  np->sz = curproc->sz;
8010497f:	8b 03                	mov    (%ebx),%eax
80104981:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104984:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104986:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104989:	89 c8                	mov    %ecx,%eax
8010498b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010498e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104993:	8b 73 18             	mov    0x18(%ebx),%esi
80104996:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80104998:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010499a:	8b 40 18             	mov    0x18(%eax),%eax
8010499d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
801049a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[i])
801049a8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801049ac:	85 c0                	test   %eax,%eax
801049ae:	74 13                	je     801049c3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
801049b0:	83 ec 0c             	sub    $0xc,%esp
801049b3:	50                   	push   %eax
801049b4:	e8 b7 c4 ff ff       	call   80100e70 <filedup>
801049b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049bc:	83 c4 10             	add    $0x10,%esp
801049bf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
801049c3:	83 c6 01             	add    $0x1,%esi
801049c6:	83 fe 10             	cmp    $0x10,%esi
801049c9:	75 dd                	jne    801049a8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
801049cb:	83 ec 0c             	sub    $0xc,%esp
801049ce:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801049d1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801049d4:	e8 57 cd ff ff       	call   80101730 <idup>
801049d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801049dc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801049df:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801049e2:	8d 47 6c             	lea    0x6c(%edi),%eax
801049e5:	6a 10                	push   $0x10
801049e7:	53                   	push   %ebx
801049e8:	50                   	push   %eax
801049e9:	e8 42 0c 00 00       	call   80105630 <safestrcpy>
  pid = np->pid;
801049ee:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801049f1:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
801049f8:	e8 63 09 00 00       	call   80105360 <acquire>
  np->state = RUNNABLE;
801049fd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104a04:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
80104a0b:	e8 10 0a 00 00       	call   80105420 <release>
  return pid;
80104a10:	83 c4 10             	add    $0x10,%esp
}
80104a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a16:	89 d8                	mov    %ebx,%eax
80104a18:	5b                   	pop    %ebx
80104a19:	5e                   	pop    %esi
80104a1a:	5f                   	pop    %edi
80104a1b:	5d                   	pop    %ebp
80104a1c:	c3                   	ret    
    return -1;
80104a1d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104a22:	eb ef                	jmp    80104a13 <fork+0xe3>
    kfree(np->kstack);
80104a24:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104a27:	83 ec 0c             	sub    $0xc,%esp
80104a2a:	ff 73 08             	pushl  0x8(%ebx)
80104a2d:	e8 4e db ff ff       	call   80102580 <kfree>
    np->kstack = 0;
80104a32:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104a39:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104a3c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104a43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104a48:	eb c9                	jmp    80104a13 <fork+0xe3>
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a50 <scheduler>:
{
80104a50:	f3 0f 1e fb          	endbr32 
80104a54:	55                   	push   %ebp
80104a55:	89 e5                	mov    %esp,%ebp
80104a57:	57                   	push   %edi
80104a58:	56                   	push   %esi
80104a59:	53                   	push   %ebx
80104a5a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104a5d:	e8 7e fc ff ff       	call   801046e0 <mycpu>
  c->proc = 0;
80104a62:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104a69:	00 00 00 
  struct cpu *c = mycpu();
80104a6c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104a6e:	8d 78 04             	lea    0x4(%eax),%edi
80104a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104a78:	fb                   	sti    
    acquire(&ptable.lock);
80104a79:	83 ec 0c             	sub    $0xc,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a7c:	bb 94 9e 11 80       	mov    $0x80119e94,%ebx
    acquire(&ptable.lock);
80104a81:	68 60 9e 11 80       	push   $0x80119e60
80104a86:	e8 d5 08 00 00       	call   80105360 <acquire>
80104a8b:	83 c4 10             	add    $0x10,%esp
80104a8e:	66 90                	xchg   %ax,%ax
      if (p->state != RUNNABLE)
80104a90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104a94:	75 33                	jne    80104ac9 <scheduler+0x79>
      switchuvm(p);
80104a96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104a99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80104a9f:	53                   	push   %ebx
80104aa0:	e8 0b 2f 00 00       	call   801079b0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104aa5:	58                   	pop    %eax
80104aa6:	5a                   	pop    %edx
80104aa7:	ff 73 1c             	pushl  0x1c(%ebx)
80104aaa:	57                   	push   %edi
      p->state = RUNNING;
80104aab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104ab2:	e8 dc 0b 00 00       	call   80105693 <swtch>
      switchkvm();
80104ab7:	e8 d4 2e 00 00       	call   80107990 <switchkvm>
      c->proc = 0;
80104abc:	83 c4 10             	add    $0x10,%esp
80104abf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104ac6:	00 00 00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ac9:	83 c3 7c             	add    $0x7c,%ebx
80104acc:	81 fb 94 bd 11 80    	cmp    $0x8011bd94,%ebx
80104ad2:	75 bc                	jne    80104a90 <scheduler+0x40>
    release(&ptable.lock);
80104ad4:	83 ec 0c             	sub    $0xc,%esp
80104ad7:	68 60 9e 11 80       	push   $0x80119e60
80104adc:	e8 3f 09 00 00       	call   80105420 <release>
    sti();
80104ae1:	83 c4 10             	add    $0x10,%esp
80104ae4:	eb 92                	jmp    80104a78 <scheduler+0x28>
80104ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aed:	8d 76 00             	lea    0x0(%esi),%esi

80104af0 <sched>:
{
80104af0:	f3 0f 1e fb          	endbr32 
80104af4:	55                   	push   %ebp
80104af5:	89 e5                	mov    %esp,%ebp
80104af7:	56                   	push   %esi
80104af8:	53                   	push   %ebx
  pushcli();
80104af9:	e8 62 07 00 00       	call   80105260 <pushcli>
  c = mycpu();
80104afe:	e8 dd fb ff ff       	call   801046e0 <mycpu>
  p = c->proc;
80104b03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b09:	e8 a2 07 00 00       	call   801052b0 <popcli>
  if (!holding(&ptable.lock))
80104b0e:	83 ec 0c             	sub    $0xc,%esp
80104b11:	68 60 9e 11 80       	push   $0x80119e60
80104b16:	e8 f5 07 00 00       	call   80105310 <holding>
80104b1b:	83 c4 10             	add    $0x10,%esp
80104b1e:	85 c0                	test   %eax,%eax
80104b20:	74 41                	je     80104b63 <sched+0x73>
  if (p->state == RUNNING)
80104b22:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104b26:	74 55                	je     80104b7d <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b28:	9c                   	pushf  
80104b29:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104b2a:	f6 c4 02             	test   $0x2,%ah
80104b2d:	75 41                	jne    80104b70 <sched+0x80>
  intena = mycpu()->intena;
80104b2f:	e8 ac fb ff ff       	call   801046e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104b34:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104b37:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104b3d:	e8 9e fb ff ff       	call   801046e0 <mycpu>
80104b42:	83 ec 08             	sub    $0x8,%esp
80104b45:	ff 70 04             	pushl  0x4(%eax)
80104b48:	53                   	push   %ebx
80104b49:	e8 45 0b 00 00       	call   80105693 <swtch>
  mycpu()->intena = intena;
80104b4e:	e8 8d fb ff ff       	call   801046e0 <mycpu>
}
80104b53:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104b56:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104b5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b5f:	5b                   	pop    %ebx
80104b60:	5e                   	pop    %esi
80104b61:	5d                   	pop    %ebp
80104b62:	c3                   	ret    
    panic("sched ptable.lock");
80104b63:	83 ec 0c             	sub    $0xc,%esp
80104b66:	68 02 8a 10 80       	push   $0x80108a02
80104b6b:	e8 20 b8 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80104b70:	83 ec 0c             	sub    $0xc,%esp
80104b73:	68 22 8a 10 80       	push   $0x80108a22
80104b78:	e8 13 b8 ff ff       	call   80100390 <panic>
    panic("sched running");
80104b7d:	83 ec 0c             	sub    $0xc,%esp
80104b80:	68 14 8a 10 80       	push   $0x80108a14
80104b85:	e8 06 b8 ff ff       	call   80100390 <panic>
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b90 <exit>:
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	57                   	push   %edi
80104b98:	56                   	push   %esi
80104b99:	53                   	push   %ebx
80104b9a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104b9d:	e8 be 06 00 00       	call   80105260 <pushcli>
  c = mycpu();
80104ba2:	e8 39 fb ff ff       	call   801046e0 <mycpu>
  p = c->proc;
80104ba7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104bad:	e8 fe 06 00 00       	call   801052b0 <popcli>
  if (curproc == initproc)
80104bb2:	8d 5e 28             	lea    0x28(%esi),%ebx
80104bb5:	8d 7e 68             	lea    0x68(%esi),%edi
80104bb8:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104bbe:	0f 84 f3 00 00 00    	je     80104cb7 <exit+0x127>
80104bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd])
80104bc8:	8b 03                	mov    (%ebx),%eax
80104bca:	85 c0                	test   %eax,%eax
80104bcc:	74 12                	je     80104be0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80104bce:	83 ec 0c             	sub    $0xc,%esp
80104bd1:	50                   	push   %eax
80104bd2:	e8 e9 c2 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104bd7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104bdd:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80104be0:	83 c3 04             	add    $0x4,%ebx
80104be3:	39 df                	cmp    %ebx,%edi
80104be5:	75 e1                	jne    80104bc8 <exit+0x38>
  begin_op();
80104be7:	e8 54 ef ff ff       	call   80103b40 <begin_op>
  iput(curproc->cwd);
80104bec:	83 ec 0c             	sub    $0xc,%esp
80104bef:	ff 76 68             	pushl  0x68(%esi)
80104bf2:	e8 99 cc ff ff       	call   80101890 <iput>
  end_op();
80104bf7:	e8 b4 ef ff ff       	call   80103bb0 <end_op>
  curproc->cwd = 0;
80104bfc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104c03:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
80104c0a:	e8 51 07 00 00       	call   80105360 <acquire>
  wakeup1(curproc->parent);
80104c0f:	8b 56 14             	mov    0x14(%esi),%edx
80104c12:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c15:	b8 94 9e 11 80       	mov    $0x80119e94,%eax
80104c1a:	eb 0e                	jmp    80104c2a <exit+0x9a>
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c20:	83 c0 7c             	add    $0x7c,%eax
80104c23:	3d 94 bd 11 80       	cmp    $0x8011bd94,%eax
80104c28:	74 1c                	je     80104c46 <exit+0xb6>
    if (p->state == SLEEPING && p->chan == chan)
80104c2a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104c2e:	75 f0                	jne    80104c20 <exit+0x90>
80104c30:	3b 50 20             	cmp    0x20(%eax),%edx
80104c33:	75 eb                	jne    80104c20 <exit+0x90>
      p->state = RUNNABLE;
80104c35:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c3c:	83 c0 7c             	add    $0x7c,%eax
80104c3f:	3d 94 bd 11 80       	cmp    $0x8011bd94,%eax
80104c44:	75 e4                	jne    80104c2a <exit+0x9a>
      p->parent = initproc;
80104c46:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c4c:	ba 94 9e 11 80       	mov    $0x80119e94,%edx
80104c51:	eb 10                	jmp    80104c63 <exit+0xd3>
80104c53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c57:	90                   	nop
80104c58:	83 c2 7c             	add    $0x7c,%edx
80104c5b:	81 fa 94 bd 11 80    	cmp    $0x8011bd94,%edx
80104c61:	74 3b                	je     80104c9e <exit+0x10e>
    if (p->parent == curproc)
80104c63:	39 72 14             	cmp    %esi,0x14(%edx)
80104c66:	75 f0                	jne    80104c58 <exit+0xc8>
      if (p->state == ZOMBIE)
80104c68:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104c6c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
80104c6f:	75 e7                	jne    80104c58 <exit+0xc8>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c71:	b8 94 9e 11 80       	mov    $0x80119e94,%eax
80104c76:	eb 12                	jmp    80104c8a <exit+0xfa>
80104c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7f:	90                   	nop
80104c80:	83 c0 7c             	add    $0x7c,%eax
80104c83:	3d 94 bd 11 80       	cmp    $0x8011bd94,%eax
80104c88:	74 ce                	je     80104c58 <exit+0xc8>
    if (p->state == SLEEPING && p->chan == chan)
80104c8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104c8e:	75 f0                	jne    80104c80 <exit+0xf0>
80104c90:	3b 48 20             	cmp    0x20(%eax),%ecx
80104c93:	75 eb                	jne    80104c80 <exit+0xf0>
      p->state = RUNNABLE;
80104c95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104c9c:	eb e2                	jmp    80104c80 <exit+0xf0>
  curproc->state = ZOMBIE;
80104c9e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104ca5:	e8 46 fe ff ff       	call   80104af0 <sched>
  panic("zombie exit");
80104caa:	83 ec 0c             	sub    $0xc,%esp
80104cad:	68 43 8a 10 80       	push   $0x80108a43
80104cb2:	e8 d9 b6 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104cb7:	83 ec 0c             	sub    $0xc,%esp
80104cba:	68 36 8a 10 80       	push   $0x80108a36
80104cbf:	e8 cc b6 ff ff       	call   80100390 <panic>
80104cc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ccf:	90                   	nop

80104cd0 <yield>:
{
80104cd0:	f3 0f 1e fb          	endbr32 
80104cd4:	55                   	push   %ebp
80104cd5:	89 e5                	mov    %esp,%ebp
80104cd7:	53                   	push   %ebx
80104cd8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
80104cdb:	68 60 9e 11 80       	push   $0x80119e60
80104ce0:	e8 7b 06 00 00       	call   80105360 <acquire>
  pushcli();
80104ce5:	e8 76 05 00 00       	call   80105260 <pushcli>
  c = mycpu();
80104cea:	e8 f1 f9 ff ff       	call   801046e0 <mycpu>
  p = c->proc;
80104cef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104cf5:	e8 b6 05 00 00       	call   801052b0 <popcli>
  myproc()->state = RUNNABLE;
80104cfa:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104d01:	e8 ea fd ff ff       	call   80104af0 <sched>
  release(&ptable.lock);
80104d06:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
80104d0d:	e8 0e 07 00 00       	call   80105420 <release>
}
80104d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d15:	83 c4 10             	add    $0x10,%esp
80104d18:	c9                   	leave  
80104d19:	c3                   	ret    
80104d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d20 <sleep>:
{
80104d20:	f3 0f 1e fb          	endbr32 
80104d24:	55                   	push   %ebp
80104d25:	89 e5                	mov    %esp,%ebp
80104d27:	57                   	push   %edi
80104d28:	56                   	push   %esi
80104d29:	53                   	push   %ebx
80104d2a:	83 ec 0c             	sub    $0xc,%esp
80104d2d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104d30:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104d33:	e8 28 05 00 00       	call   80105260 <pushcli>
  c = mycpu();
80104d38:	e8 a3 f9 ff ff       	call   801046e0 <mycpu>
  p = c->proc;
80104d3d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d43:	e8 68 05 00 00       	call   801052b0 <popcli>
  if (p == 0)
80104d48:	85 db                	test   %ebx,%ebx
80104d4a:	0f 84 83 00 00 00    	je     80104dd3 <sleep+0xb3>
  if (lk == 0)
80104d50:	85 f6                	test   %esi,%esi
80104d52:	74 72                	je     80104dc6 <sleep+0xa6>
  if (lk != &ptable.lock)
80104d54:	81 fe 60 9e 11 80    	cmp    $0x80119e60,%esi
80104d5a:	74 4c                	je     80104da8 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
80104d5c:	83 ec 0c             	sub    $0xc,%esp
80104d5f:	68 60 9e 11 80       	push   $0x80119e60
80104d64:	e8 f7 05 00 00       	call   80105360 <acquire>
    release(lk);
80104d69:	89 34 24             	mov    %esi,(%esp)
80104d6c:	e8 af 06 00 00       	call   80105420 <release>
  p->chan = chan;
80104d71:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104d74:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104d7b:	e8 70 fd ff ff       	call   80104af0 <sched>
  p->chan = 0;
80104d80:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104d87:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
80104d8e:	e8 8d 06 00 00       	call   80105420 <release>
    acquire(lk);
80104d93:	89 75 08             	mov    %esi,0x8(%ebp)
80104d96:	83 c4 10             	add    $0x10,%esp
}
80104d99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d9c:	5b                   	pop    %ebx
80104d9d:	5e                   	pop    %esi
80104d9e:	5f                   	pop    %edi
80104d9f:	5d                   	pop    %ebp
    acquire(lk);
80104da0:	e9 bb 05 00 00       	jmp    80105360 <acquire>
80104da5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104da8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104dab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104db2:	e8 39 fd ff ff       	call   80104af0 <sched>
  p->chan = 0;
80104db7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dc1:	5b                   	pop    %ebx
80104dc2:	5e                   	pop    %esi
80104dc3:	5f                   	pop    %edi
80104dc4:	5d                   	pop    %ebp
80104dc5:	c3                   	ret    
    panic("sleep without lk");
80104dc6:	83 ec 0c             	sub    $0xc,%esp
80104dc9:	68 55 8a 10 80       	push   $0x80108a55
80104dce:	e8 bd b5 ff ff       	call   80100390 <panic>
    panic("sleep");
80104dd3:	83 ec 0c             	sub    $0xc,%esp
80104dd6:	68 4f 8a 10 80       	push   $0x80108a4f
80104ddb:	e8 b0 b5 ff ff       	call   80100390 <panic>

80104de0 <wait>:
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
80104de7:	56                   	push   %esi
80104de8:	53                   	push   %ebx
  pushcli();
80104de9:	e8 72 04 00 00       	call   80105260 <pushcli>
  c = mycpu();
80104dee:	e8 ed f8 ff ff       	call   801046e0 <mycpu>
  p = c->proc;
80104df3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104df9:	e8 b2 04 00 00       	call   801052b0 <popcli>
  acquire(&ptable.lock);
80104dfe:	83 ec 0c             	sub    $0xc,%esp
80104e01:	68 60 9e 11 80       	push   $0x80119e60
80104e06:	e8 55 05 00 00       	call   80105360 <acquire>
80104e0b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104e0e:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e10:	bb 94 9e 11 80       	mov    $0x80119e94,%ebx
80104e15:	eb 14                	jmp    80104e2b <wait+0x4b>
80104e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1e:	66 90                	xchg   %ax,%ax
80104e20:	83 c3 7c             	add    $0x7c,%ebx
80104e23:	81 fb 94 bd 11 80    	cmp    $0x8011bd94,%ebx
80104e29:	74 1b                	je     80104e46 <wait+0x66>
      if (p->parent != curproc)
80104e2b:	39 73 14             	cmp    %esi,0x14(%ebx)
80104e2e:	75 f0                	jne    80104e20 <wait+0x40>
      if (p->state == ZOMBIE)
80104e30:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104e34:	74 32                	je     80104e68 <wait+0x88>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e36:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104e39:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e3e:	81 fb 94 bd 11 80    	cmp    $0x8011bd94,%ebx
80104e44:	75 e5                	jne    80104e2b <wait+0x4b>
    if (!havekids || curproc->killed)
80104e46:	85 c0                	test   %eax,%eax
80104e48:	74 74                	je     80104ebe <wait+0xde>
80104e4a:	8b 46 24             	mov    0x24(%esi),%eax
80104e4d:	85 c0                	test   %eax,%eax
80104e4f:	75 6d                	jne    80104ebe <wait+0xde>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
80104e51:	83 ec 08             	sub    $0x8,%esp
80104e54:	68 60 9e 11 80       	push   $0x80119e60
80104e59:	56                   	push   %esi
80104e5a:	e8 c1 fe ff ff       	call   80104d20 <sleep>
    havekids = 0;
80104e5f:	83 c4 10             	add    $0x10,%esp
80104e62:	eb aa                	jmp    80104e0e <wait+0x2e>
80104e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104e68:	83 ec 0c             	sub    $0xc,%esp
80104e6b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104e6e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104e71:	e8 0a d7 ff ff       	call   80102580 <kfree>
        freevm(p->pgdir);
80104e76:	5a                   	pop    %edx
80104e77:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104e7a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104e81:	e8 0a 2f 00 00       	call   80107d90 <freevm>
        release(&ptable.lock);
80104e86:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
        p->pid = 0;
80104e8d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104e94:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104e9b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104e9f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104ea6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104ead:	e8 6e 05 00 00       	call   80105420 <release>
        return pid;
80104eb2:	83 c4 10             	add    $0x10,%esp
}
80104eb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eb8:	89 f0                	mov    %esi,%eax
80104eba:	5b                   	pop    %ebx
80104ebb:	5e                   	pop    %esi
80104ebc:	5d                   	pop    %ebp
80104ebd:	c3                   	ret    
      release(&ptable.lock);
80104ebe:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104ec1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104ec6:	68 60 9e 11 80       	push   $0x80119e60
80104ecb:	e8 50 05 00 00       	call   80105420 <release>
      return -1;
80104ed0:	83 c4 10             	add    $0x10,%esp
80104ed3:	eb e0                	jmp    80104eb5 <wait+0xd5>
80104ed5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
80104ee5:	89 e5                	mov    %esp,%ebp
80104ee7:	53                   	push   %ebx
80104ee8:	83 ec 10             	sub    $0x10,%esp
80104eeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104eee:	68 60 9e 11 80       	push   $0x80119e60
80104ef3:	e8 68 04 00 00       	call   80105360 <acquire>
80104ef8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104efb:	b8 94 9e 11 80       	mov    $0x80119e94,%eax
80104f00:	eb 10                	jmp    80104f12 <wakeup+0x32>
80104f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f08:	83 c0 7c             	add    $0x7c,%eax
80104f0b:	3d 94 bd 11 80       	cmp    $0x8011bd94,%eax
80104f10:	74 1c                	je     80104f2e <wakeup+0x4e>
    if (p->state == SLEEPING && p->chan == chan)
80104f12:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104f16:	75 f0                	jne    80104f08 <wakeup+0x28>
80104f18:	3b 58 20             	cmp    0x20(%eax),%ebx
80104f1b:	75 eb                	jne    80104f08 <wakeup+0x28>
      p->state = RUNNABLE;
80104f1d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f24:	83 c0 7c             	add    $0x7c,%eax
80104f27:	3d 94 bd 11 80       	cmp    $0x8011bd94,%eax
80104f2c:	75 e4                	jne    80104f12 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
80104f2e:	c7 45 08 60 9e 11 80 	movl   $0x80119e60,0x8(%ebp)
}
80104f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f38:	c9                   	leave  
  release(&ptable.lock);
80104f39:	e9 e2 04 00 00       	jmp    80105420 <release>
80104f3e:	66 90                	xchg   %ax,%ax

80104f40 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	53                   	push   %ebx
80104f48:	83 ec 10             	sub    $0x10,%esp
80104f4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104f4e:	68 60 9e 11 80       	push   $0x80119e60
80104f53:	e8 08 04 00 00       	call   80105360 <acquire>
80104f58:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f5b:	b8 94 9e 11 80       	mov    $0x80119e94,%eax
80104f60:	eb 10                	jmp    80104f72 <kill+0x32>
80104f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f68:	83 c0 7c             	add    $0x7c,%eax
80104f6b:	3d 94 bd 11 80       	cmp    $0x8011bd94,%eax
80104f70:	74 36                	je     80104fa8 <kill+0x68>
  {
    if (p->pid == pid)
80104f72:	39 58 10             	cmp    %ebx,0x10(%eax)
80104f75:	75 f1                	jne    80104f68 <kill+0x28>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104f77:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104f7b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
80104f82:	75 07                	jne    80104f8b <kill+0x4b>
        p->state = RUNNABLE;
80104f84:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104f8b:	83 ec 0c             	sub    $0xc,%esp
80104f8e:	68 60 9e 11 80       	push   $0x80119e60
80104f93:	e8 88 04 00 00       	call   80105420 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104f98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104f9b:	83 c4 10             	add    $0x10,%esp
80104f9e:	31 c0                	xor    %eax,%eax
}
80104fa0:	c9                   	leave  
80104fa1:	c3                   	ret    
80104fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104fa8:	83 ec 0c             	sub    $0xc,%esp
80104fab:	68 60 9e 11 80       	push   $0x80119e60
80104fb0:	e8 6b 04 00 00       	call   80105420 <release>
}
80104fb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104fb8:	83 c4 10             	add    $0x10,%esp
80104fbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fc0:	c9                   	leave  
80104fc1:	c3                   	ret    
80104fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fd0 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104fd0:	f3 0f 1e fb          	endbr32 
80104fd4:	55                   	push   %ebp
80104fd5:	89 e5                	mov    %esp,%ebp
80104fd7:	57                   	push   %edi
80104fd8:	56                   	push   %esi
80104fd9:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104fdc:	53                   	push   %ebx
80104fdd:	bb 00 9f 11 80       	mov    $0x80119f00,%ebx
80104fe2:	83 ec 3c             	sub    $0x3c,%esp
80104fe5:	eb 28                	jmp    8010500f <procdump+0x3f>
80104fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fee:	66 90                	xchg   %ax,%ax
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ff0:	83 ec 0c             	sub    $0xc,%esp
80104ff3:	68 2b 8e 10 80       	push   $0x80108e2b
80104ff8:	e8 b3 b6 ff ff       	call   801006b0 <cprintf>
80104ffd:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105000:	83 c3 7c             	add    $0x7c,%ebx
80105003:	81 fb 00 be 11 80    	cmp    $0x8011be00,%ebx
80105009:	0f 84 81 00 00 00    	je     80105090 <procdump+0xc0>
    if (p->state == UNUSED)
8010500f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80105012:	85 c0                	test   %eax,%eax
80105014:	74 ea                	je     80105000 <procdump+0x30>
      state = "???";
80105016:	ba 66 8a 10 80       	mov    $0x80108a66,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010501b:	83 f8 05             	cmp    $0x5,%eax
8010501e:	77 11                	ja     80105031 <procdump+0x61>
80105020:	8b 14 85 c8 8a 10 80 	mov    -0x7fef7538(,%eax,4),%edx
      state = "???";
80105027:	b8 66 8a 10 80       	mov    $0x80108a66,%eax
8010502c:	85 d2                	test   %edx,%edx
8010502e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80105031:	53                   	push   %ebx
80105032:	52                   	push   %edx
80105033:	ff 73 a4             	pushl  -0x5c(%ebx)
80105036:	68 6a 8a 10 80       	push   $0x80108a6a
8010503b:	e8 70 b6 ff ff       	call   801006b0 <cprintf>
    if (p->state == SLEEPING)
80105040:	83 c4 10             	add    $0x10,%esp
80105043:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80105047:	75 a7                	jne    80104ff0 <procdump+0x20>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80105049:	83 ec 08             	sub    $0x8,%esp
8010504c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010504f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80105052:	50                   	push   %eax
80105053:	8b 43 b0             	mov    -0x50(%ebx),%eax
80105056:	8b 40 0c             	mov    0xc(%eax),%eax
80105059:	83 c0 08             	add    $0x8,%eax
8010505c:	50                   	push   %eax
8010505d:	e8 9e 01 00 00       	call   80105200 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80105062:	83 c4 10             	add    $0x10,%esp
80105065:	8d 76 00             	lea    0x0(%esi),%esi
80105068:	8b 17                	mov    (%edi),%edx
8010506a:	85 d2                	test   %edx,%edx
8010506c:	74 82                	je     80104ff0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010506e:	83 ec 08             	sub    $0x8,%esp
80105071:	83 c7 04             	add    $0x4,%edi
80105074:	52                   	push   %edx
80105075:	68 01 81 10 80       	push   $0x80108101
8010507a:	e8 31 b6 ff ff       	call   801006b0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
8010507f:	83 c4 10             	add    $0x10,%esp
80105082:	39 fe                	cmp    %edi,%esi
80105084:	75 e2                	jne    80105068 <procdump+0x98>
80105086:	e9 65 ff ff ff       	jmp    80104ff0 <procdump+0x20>
8010508b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010508f:	90                   	nop
  }
}
80105090:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105093:	5b                   	pop    %ebx
80105094:	5e                   	pop    %esi
80105095:	5f                   	pop    %edi
80105096:	5d                   	pop    %ebp
80105097:	c3                   	ret    
80105098:	66 90                	xchg   %ax,%ax
8010509a:	66 90                	xchg   %ax,%ax
8010509c:	66 90                	xchg   %ax,%ax
8010509e:	66 90                	xchg   %ax,%ax

801050a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801050a0:	f3 0f 1e fb          	endbr32 
801050a4:	55                   	push   %ebp
801050a5:	89 e5                	mov    %esp,%ebp
801050a7:	53                   	push   %ebx
801050a8:	83 ec 0c             	sub    $0xc,%esp
801050ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801050ae:	68 e0 8a 10 80       	push   $0x80108ae0
801050b3:	8d 43 04             	lea    0x4(%ebx),%eax
801050b6:	50                   	push   %eax
801050b7:	e8 24 01 00 00       	call   801051e0 <initlock>
  lk->name = name;
801050bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801050bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801050c5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801050c8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801050cf:	89 43 38             	mov    %eax,0x38(%ebx)
}
801050d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050d5:	c9                   	leave  
801050d6:	c3                   	ret    
801050d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050de:	66 90                	xchg   %ax,%ax

801050e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801050e0:	f3 0f 1e fb          	endbr32 
801050e4:	55                   	push   %ebp
801050e5:	89 e5                	mov    %esp,%ebp
801050e7:	56                   	push   %esi
801050e8:	53                   	push   %ebx
801050e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801050ec:	8d 73 04             	lea    0x4(%ebx),%esi
801050ef:	83 ec 0c             	sub    $0xc,%esp
801050f2:	56                   	push   %esi
801050f3:	e8 68 02 00 00       	call   80105360 <acquire>
  while (lk->locked) {
801050f8:	8b 13                	mov    (%ebx),%edx
801050fa:	83 c4 10             	add    $0x10,%esp
801050fd:	85 d2                	test   %edx,%edx
801050ff:	74 1a                	je     8010511b <acquiresleep+0x3b>
80105101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80105108:	83 ec 08             	sub    $0x8,%esp
8010510b:	56                   	push   %esi
8010510c:	53                   	push   %ebx
8010510d:	e8 0e fc ff ff       	call   80104d20 <sleep>
  while (lk->locked) {
80105112:	8b 03                	mov    (%ebx),%eax
80105114:	83 c4 10             	add    $0x10,%esp
80105117:	85 c0                	test   %eax,%eax
80105119:	75 ed                	jne    80105108 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010511b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105121:	e8 4a f6 ff ff       	call   80104770 <myproc>
80105126:	8b 40 10             	mov    0x10(%eax),%eax
80105129:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010512c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010512f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105132:	5b                   	pop    %ebx
80105133:	5e                   	pop    %esi
80105134:	5d                   	pop    %ebp
  release(&lk->lk);
80105135:	e9 e6 02 00 00       	jmp    80105420 <release>
8010513a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105140 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105140:	f3 0f 1e fb          	endbr32 
80105144:	55                   	push   %ebp
80105145:	89 e5                	mov    %esp,%ebp
80105147:	56                   	push   %esi
80105148:	53                   	push   %ebx
80105149:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010514c:	8d 73 04             	lea    0x4(%ebx),%esi
8010514f:	83 ec 0c             	sub    $0xc,%esp
80105152:	56                   	push   %esi
80105153:	e8 08 02 00 00       	call   80105360 <acquire>
  lk->locked = 0;
80105158:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010515e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105165:	89 1c 24             	mov    %ebx,(%esp)
80105168:	e8 73 fd ff ff       	call   80104ee0 <wakeup>
  release(&lk->lk);
8010516d:	89 75 08             	mov    %esi,0x8(%ebp)
80105170:	83 c4 10             	add    $0x10,%esp
}
80105173:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105176:	5b                   	pop    %ebx
80105177:	5e                   	pop    %esi
80105178:	5d                   	pop    %ebp
  release(&lk->lk);
80105179:	e9 a2 02 00 00       	jmp    80105420 <release>
8010517e:	66 90                	xchg   %ax,%ax

80105180 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	57                   	push   %edi
80105188:	31 ff                	xor    %edi,%edi
8010518a:	56                   	push   %esi
8010518b:	53                   	push   %ebx
8010518c:	83 ec 18             	sub    $0x18,%esp
8010518f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80105192:	8d 73 04             	lea    0x4(%ebx),%esi
80105195:	56                   	push   %esi
80105196:	e8 c5 01 00 00       	call   80105360 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010519b:	8b 03                	mov    (%ebx),%eax
8010519d:	83 c4 10             	add    $0x10,%esp
801051a0:	85 c0                	test   %eax,%eax
801051a2:	75 1c                	jne    801051c0 <holdingsleep+0x40>
  release(&lk->lk);
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	56                   	push   %esi
801051a8:	e8 73 02 00 00       	call   80105420 <release>
  return r;
}
801051ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051b0:	89 f8                	mov    %edi,%eax
801051b2:	5b                   	pop    %ebx
801051b3:	5e                   	pop    %esi
801051b4:	5f                   	pop    %edi
801051b5:	5d                   	pop    %ebp
801051b6:	c3                   	ret    
801051b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051be:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801051c0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801051c3:	e8 a8 f5 ff ff       	call   80104770 <myproc>
801051c8:	39 58 10             	cmp    %ebx,0x10(%eax)
801051cb:	0f 94 c0             	sete   %al
801051ce:	0f b6 c0             	movzbl %al,%eax
801051d1:	89 c7                	mov    %eax,%edi
801051d3:	eb cf                	jmp    801051a4 <holdingsleep+0x24>
801051d5:	66 90                	xchg   %ax,%ax
801051d7:	66 90                	xchg   %ax,%ax
801051d9:	66 90                	xchg   %ax,%ax
801051db:	66 90                	xchg   %ax,%ax
801051dd:	66 90                	xchg   %ax,%ax
801051df:	90                   	nop

801051e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801051ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801051ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801051f3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801051f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801051fd:	5d                   	pop    %ebp
801051fe:	c3                   	ret    
801051ff:	90                   	nop

80105200 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105205:	31 d2                	xor    %edx,%edx
{
80105207:	89 e5                	mov    %esp,%ebp
80105209:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010520a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010520d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80105210:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80105213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105217:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105218:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010521e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105224:	77 1a                	ja     80105240 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105226:	8b 58 04             	mov    0x4(%eax),%ebx
80105229:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010522c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010522f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105231:	83 fa 0a             	cmp    $0xa,%edx
80105234:	75 e2                	jne    80105218 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105236:	5b                   	pop    %ebx
80105237:	5d                   	pop    %ebp
80105238:	c3                   	ret    
80105239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105240:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105243:	8d 51 28             	lea    0x28(%ecx),%edx
80105246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105250:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105256:	83 c0 04             	add    $0x4,%eax
80105259:	39 d0                	cmp    %edx,%eax
8010525b:	75 f3                	jne    80105250 <getcallerpcs+0x50>
}
8010525d:	5b                   	pop    %ebx
8010525e:	5d                   	pop    %ebp
8010525f:	c3                   	ret    

80105260 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105260:	f3 0f 1e fb          	endbr32 
80105264:	55                   	push   %ebp
80105265:	89 e5                	mov    %esp,%ebp
80105267:	53                   	push   %ebx
80105268:	83 ec 04             	sub    $0x4,%esp
8010526b:	9c                   	pushf  
8010526c:	5b                   	pop    %ebx
  asm volatile("cli");
8010526d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010526e:	e8 6d f4 ff ff       	call   801046e0 <mycpu>
80105273:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105279:	85 c0                	test   %eax,%eax
8010527b:	74 13                	je     80105290 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010527d:	e8 5e f4 ff ff       	call   801046e0 <mycpu>
80105282:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105289:	83 c4 04             	add    $0x4,%esp
8010528c:	5b                   	pop    %ebx
8010528d:	5d                   	pop    %ebp
8010528e:	c3                   	ret    
8010528f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80105290:	e8 4b f4 ff ff       	call   801046e0 <mycpu>
80105295:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010529b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801052a1:	eb da                	jmp    8010527d <pushcli+0x1d>
801052a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052b0 <popcli>:

void
popcli(void)
{
801052b0:	f3 0f 1e fb          	endbr32 
801052b4:	55                   	push   %ebp
801052b5:	89 e5                	mov    %esp,%ebp
801052b7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801052ba:	9c                   	pushf  
801052bb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801052bc:	f6 c4 02             	test   $0x2,%ah
801052bf:	75 31                	jne    801052f2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801052c1:	e8 1a f4 ff ff       	call   801046e0 <mycpu>
801052c6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801052cd:	78 30                	js     801052ff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801052cf:	e8 0c f4 ff ff       	call   801046e0 <mycpu>
801052d4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801052da:	85 d2                	test   %edx,%edx
801052dc:	74 02                	je     801052e0 <popcli+0x30>
    sti();
}
801052de:	c9                   	leave  
801052df:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801052e0:	e8 fb f3 ff ff       	call   801046e0 <mycpu>
801052e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801052eb:	85 c0                	test   %eax,%eax
801052ed:	74 ef                	je     801052de <popcli+0x2e>
  asm volatile("sti");
801052ef:	fb                   	sti    
}
801052f0:	c9                   	leave  
801052f1:	c3                   	ret    
    panic("popcli - interruptible");
801052f2:	83 ec 0c             	sub    $0xc,%esp
801052f5:	68 eb 8a 10 80       	push   $0x80108aeb
801052fa:	e8 91 b0 ff ff       	call   80100390 <panic>
    panic("popcli");
801052ff:	83 ec 0c             	sub    $0xc,%esp
80105302:	68 02 8b 10 80       	push   $0x80108b02
80105307:	e8 84 b0 ff ff       	call   80100390 <panic>
8010530c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105310 <holding>:
{
80105310:	f3 0f 1e fb          	endbr32 
80105314:	55                   	push   %ebp
80105315:	89 e5                	mov    %esp,%ebp
80105317:	56                   	push   %esi
80105318:	53                   	push   %ebx
80105319:	8b 75 08             	mov    0x8(%ebp),%esi
8010531c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010531e:	e8 3d ff ff ff       	call   80105260 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105323:	8b 06                	mov    (%esi),%eax
80105325:	85 c0                	test   %eax,%eax
80105327:	75 0f                	jne    80105338 <holding+0x28>
  popcli();
80105329:	e8 82 ff ff ff       	call   801052b0 <popcli>
}
8010532e:	89 d8                	mov    %ebx,%eax
80105330:	5b                   	pop    %ebx
80105331:	5e                   	pop    %esi
80105332:	5d                   	pop    %ebp
80105333:	c3                   	ret    
80105334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105338:	8b 5e 08             	mov    0x8(%esi),%ebx
8010533b:	e8 a0 f3 ff ff       	call   801046e0 <mycpu>
80105340:	39 c3                	cmp    %eax,%ebx
80105342:	0f 94 c3             	sete   %bl
  popcli();
80105345:	e8 66 ff ff ff       	call   801052b0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010534a:	0f b6 db             	movzbl %bl,%ebx
}
8010534d:	89 d8                	mov    %ebx,%eax
8010534f:	5b                   	pop    %ebx
80105350:	5e                   	pop    %esi
80105351:	5d                   	pop    %ebp
80105352:	c3                   	ret    
80105353:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105360 <acquire>:
{
80105360:	f3 0f 1e fb          	endbr32 
80105364:	55                   	push   %ebp
80105365:	89 e5                	mov    %esp,%ebp
80105367:	56                   	push   %esi
80105368:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105369:	e8 f2 fe ff ff       	call   80105260 <pushcli>
  if(holding(lk))
8010536e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105371:	83 ec 0c             	sub    $0xc,%esp
80105374:	53                   	push   %ebx
80105375:	e8 96 ff ff ff       	call   80105310 <holding>
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	85 c0                	test   %eax,%eax
8010537f:	0f 85 7f 00 00 00    	jne    80105404 <acquire+0xa4>
80105385:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105387:	ba 01 00 00 00       	mov    $0x1,%edx
8010538c:	eb 05                	jmp    80105393 <acquire+0x33>
8010538e:	66 90                	xchg   %ax,%ax
80105390:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105393:	89 d0                	mov    %edx,%eax
80105395:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105398:	85 c0                	test   %eax,%eax
8010539a:	75 f4                	jne    80105390 <acquire+0x30>
  __sync_synchronize();
8010539c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801053a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801053a4:	e8 37 f3 ff ff       	call   801046e0 <mycpu>
801053a9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801053ac:	89 e8                	mov    %ebp,%eax
801053ae:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801053b0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801053b6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801053bc:	77 22                	ja     801053e0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801053be:	8b 50 04             	mov    0x4(%eax),%edx
801053c1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801053c5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801053c8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801053ca:	83 fe 0a             	cmp    $0xa,%esi
801053cd:	75 e1                	jne    801053b0 <acquire+0x50>
}
801053cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053d2:	5b                   	pop    %ebx
801053d3:	5e                   	pop    %esi
801053d4:	5d                   	pop    %ebp
801053d5:	c3                   	ret    
801053d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801053e0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801053e4:	83 c3 34             	add    $0x34,%ebx
801053e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801053f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801053f6:	83 c0 04             	add    $0x4,%eax
801053f9:	39 d8                	cmp    %ebx,%eax
801053fb:	75 f3                	jne    801053f0 <acquire+0x90>
}
801053fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105400:	5b                   	pop    %ebx
80105401:	5e                   	pop    %esi
80105402:	5d                   	pop    %ebp
80105403:	c3                   	ret    
    panic("acquire");
80105404:	83 ec 0c             	sub    $0xc,%esp
80105407:	68 09 8b 10 80       	push   $0x80108b09
8010540c:	e8 7f af ff ff       	call   80100390 <panic>
80105411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541f:	90                   	nop

80105420 <release>:
{
80105420:	f3 0f 1e fb          	endbr32 
80105424:	55                   	push   %ebp
80105425:	89 e5                	mov    %esp,%ebp
80105427:	53                   	push   %ebx
80105428:	83 ec 10             	sub    $0x10,%esp
8010542b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010542e:	53                   	push   %ebx
8010542f:	e8 dc fe ff ff       	call   80105310 <holding>
80105434:	83 c4 10             	add    $0x10,%esp
80105437:	85 c0                	test   %eax,%eax
80105439:	74 22                	je     8010545d <release+0x3d>
  lk->pcs[0] = 0;
8010543b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105442:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105449:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010544e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105454:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105457:	c9                   	leave  
  popcli();
80105458:	e9 53 fe ff ff       	jmp    801052b0 <popcli>
    panic("release");
8010545d:	83 ec 0c             	sub    $0xc,%esp
80105460:	68 11 8b 10 80       	push   $0x80108b11
80105465:	e8 26 af ff ff       	call   80100390 <panic>
8010546a:	66 90                	xchg   %ax,%ax
8010546c:	66 90                	xchg   %ax,%ax
8010546e:	66 90                	xchg   %ax,%ax

80105470 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105470:	f3 0f 1e fb          	endbr32 
80105474:	55                   	push   %ebp
80105475:	89 e5                	mov    %esp,%ebp
80105477:	57                   	push   %edi
80105478:	8b 55 08             	mov    0x8(%ebp),%edx
8010547b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010547e:	53                   	push   %ebx
8010547f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105482:	89 d7                	mov    %edx,%edi
80105484:	09 cf                	or     %ecx,%edi
80105486:	83 e7 03             	and    $0x3,%edi
80105489:	75 25                	jne    801054b0 <memset+0x40>
    c &= 0xFF;
8010548b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010548e:	c1 e0 18             	shl    $0x18,%eax
80105491:	89 fb                	mov    %edi,%ebx
80105493:	c1 e9 02             	shr    $0x2,%ecx
80105496:	c1 e3 10             	shl    $0x10,%ebx
80105499:	09 d8                	or     %ebx,%eax
8010549b:	09 f8                	or     %edi,%eax
8010549d:	c1 e7 08             	shl    $0x8,%edi
801054a0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801054a2:	89 d7                	mov    %edx,%edi
801054a4:	fc                   	cld    
801054a5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801054a7:	5b                   	pop    %ebx
801054a8:	89 d0                	mov    %edx,%eax
801054aa:	5f                   	pop    %edi
801054ab:	5d                   	pop    %ebp
801054ac:	c3                   	ret    
801054ad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801054b0:	89 d7                	mov    %edx,%edi
801054b2:	fc                   	cld    
801054b3:	f3 aa                	rep stos %al,%es:(%edi)
801054b5:	5b                   	pop    %ebx
801054b6:	89 d0                	mov    %edx,%eax
801054b8:	5f                   	pop    %edi
801054b9:	5d                   	pop    %ebp
801054ba:	c3                   	ret    
801054bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054bf:	90                   	nop

801054c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801054c0:	f3 0f 1e fb          	endbr32 
801054c4:	55                   	push   %ebp
801054c5:	89 e5                	mov    %esp,%ebp
801054c7:	56                   	push   %esi
801054c8:	8b 75 10             	mov    0x10(%ebp),%esi
801054cb:	8b 55 08             	mov    0x8(%ebp),%edx
801054ce:	53                   	push   %ebx
801054cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801054d2:	85 f6                	test   %esi,%esi
801054d4:	74 2a                	je     80105500 <memcmp+0x40>
801054d6:	01 c6                	add    %eax,%esi
801054d8:	eb 10                	jmp    801054ea <memcmp+0x2a>
801054da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801054e0:	83 c0 01             	add    $0x1,%eax
801054e3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801054e6:	39 f0                	cmp    %esi,%eax
801054e8:	74 16                	je     80105500 <memcmp+0x40>
    if(*s1 != *s2)
801054ea:	0f b6 0a             	movzbl (%edx),%ecx
801054ed:	0f b6 18             	movzbl (%eax),%ebx
801054f0:	38 d9                	cmp    %bl,%cl
801054f2:	74 ec                	je     801054e0 <memcmp+0x20>
      return *s1 - *s2;
801054f4:	0f b6 c1             	movzbl %cl,%eax
801054f7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801054f9:	5b                   	pop    %ebx
801054fa:	5e                   	pop    %esi
801054fb:	5d                   	pop    %ebp
801054fc:	c3                   	ret    
801054fd:	8d 76 00             	lea    0x0(%esi),%esi
80105500:	5b                   	pop    %ebx
  return 0;
80105501:	31 c0                	xor    %eax,%eax
}
80105503:	5e                   	pop    %esi
80105504:	5d                   	pop    %ebp
80105505:	c3                   	ret    
80105506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550d:	8d 76 00             	lea    0x0(%esi),%esi

80105510 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105510:	f3 0f 1e fb          	endbr32 
80105514:	55                   	push   %ebp
80105515:	89 e5                	mov    %esp,%ebp
80105517:	57                   	push   %edi
80105518:	8b 55 08             	mov    0x8(%ebp),%edx
8010551b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010551e:	56                   	push   %esi
8010551f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105522:	39 d6                	cmp    %edx,%esi
80105524:	73 2a                	jae    80105550 <memmove+0x40>
80105526:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105529:	39 fa                	cmp    %edi,%edx
8010552b:	73 23                	jae    80105550 <memmove+0x40>
8010552d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105530:	85 c9                	test   %ecx,%ecx
80105532:	74 13                	je     80105547 <memmove+0x37>
80105534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105538:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010553c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010553f:	83 e8 01             	sub    $0x1,%eax
80105542:	83 f8 ff             	cmp    $0xffffffff,%eax
80105545:	75 f1                	jne    80105538 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105547:	5e                   	pop    %esi
80105548:	89 d0                	mov    %edx,%eax
8010554a:	5f                   	pop    %edi
8010554b:	5d                   	pop    %ebp
8010554c:	c3                   	ret    
8010554d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105550:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105553:	89 d7                	mov    %edx,%edi
80105555:	85 c9                	test   %ecx,%ecx
80105557:	74 ee                	je     80105547 <memmove+0x37>
80105559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105560:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105561:	39 f0                	cmp    %esi,%eax
80105563:	75 fb                	jne    80105560 <memmove+0x50>
}
80105565:	5e                   	pop    %esi
80105566:	89 d0                	mov    %edx,%eax
80105568:	5f                   	pop    %edi
80105569:	5d                   	pop    %ebp
8010556a:	c3                   	ret    
8010556b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010556f:	90                   	nop

80105570 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105570:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105574:	eb 9a                	jmp    80105510 <memmove>
80105576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557d:	8d 76 00             	lea    0x0(%esi),%esi

80105580 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105580:	f3 0f 1e fb          	endbr32 
80105584:	55                   	push   %ebp
80105585:	89 e5                	mov    %esp,%ebp
80105587:	56                   	push   %esi
80105588:	8b 75 10             	mov    0x10(%ebp),%esi
8010558b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010558e:	53                   	push   %ebx
8010558f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105592:	85 f6                	test   %esi,%esi
80105594:	74 32                	je     801055c8 <strncmp+0x48>
80105596:	01 c6                	add    %eax,%esi
80105598:	eb 14                	jmp    801055ae <strncmp+0x2e>
8010559a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055a0:	38 da                	cmp    %bl,%dl
801055a2:	75 14                	jne    801055b8 <strncmp+0x38>
    n--, p++, q++;
801055a4:	83 c0 01             	add    $0x1,%eax
801055a7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801055aa:	39 f0                	cmp    %esi,%eax
801055ac:	74 1a                	je     801055c8 <strncmp+0x48>
801055ae:	0f b6 11             	movzbl (%ecx),%edx
801055b1:	0f b6 18             	movzbl (%eax),%ebx
801055b4:	84 d2                	test   %dl,%dl
801055b6:	75 e8                	jne    801055a0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801055b8:	0f b6 c2             	movzbl %dl,%eax
801055bb:	29 d8                	sub    %ebx,%eax
}
801055bd:	5b                   	pop    %ebx
801055be:	5e                   	pop    %esi
801055bf:	5d                   	pop    %ebp
801055c0:	c3                   	ret    
801055c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055c8:	5b                   	pop    %ebx
    return 0;
801055c9:	31 c0                	xor    %eax,%eax
}
801055cb:	5e                   	pop    %esi
801055cc:	5d                   	pop    %ebp
801055cd:	c3                   	ret    
801055ce:	66 90                	xchg   %ax,%ax

801055d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801055d0:	f3 0f 1e fb          	endbr32 
801055d4:	55                   	push   %ebp
801055d5:	89 e5                	mov    %esp,%ebp
801055d7:	57                   	push   %edi
801055d8:	56                   	push   %esi
801055d9:	8b 75 08             	mov    0x8(%ebp),%esi
801055dc:	53                   	push   %ebx
801055dd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801055e0:	89 f2                	mov    %esi,%edx
801055e2:	eb 1b                	jmp    801055ff <strncpy+0x2f>
801055e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055e8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801055ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
801055ef:	83 c2 01             	add    $0x1,%edx
801055f2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801055f6:	89 f9                	mov    %edi,%ecx
801055f8:	88 4a ff             	mov    %cl,-0x1(%edx)
801055fb:	84 c9                	test   %cl,%cl
801055fd:	74 09                	je     80105608 <strncpy+0x38>
801055ff:	89 c3                	mov    %eax,%ebx
80105601:	83 e8 01             	sub    $0x1,%eax
80105604:	85 db                	test   %ebx,%ebx
80105606:	7f e0                	jg     801055e8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105608:	89 d1                	mov    %edx,%ecx
8010560a:	85 c0                	test   %eax,%eax
8010560c:	7e 15                	jle    80105623 <strncpy+0x53>
8010560e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105610:	83 c1 01             	add    $0x1,%ecx
80105613:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105617:	89 c8                	mov    %ecx,%eax
80105619:	f7 d0                	not    %eax
8010561b:	01 d0                	add    %edx,%eax
8010561d:	01 d8                	add    %ebx,%eax
8010561f:	85 c0                	test   %eax,%eax
80105621:	7f ed                	jg     80105610 <strncpy+0x40>
  return os;
}
80105623:	5b                   	pop    %ebx
80105624:	89 f0                	mov    %esi,%eax
80105626:	5e                   	pop    %esi
80105627:	5f                   	pop    %edi
80105628:	5d                   	pop    %ebp
80105629:	c3                   	ret    
8010562a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105630 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105630:	f3 0f 1e fb          	endbr32 
80105634:	55                   	push   %ebp
80105635:	89 e5                	mov    %esp,%ebp
80105637:	56                   	push   %esi
80105638:	8b 55 10             	mov    0x10(%ebp),%edx
8010563b:	8b 75 08             	mov    0x8(%ebp),%esi
8010563e:	53                   	push   %ebx
8010563f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105642:	85 d2                	test   %edx,%edx
80105644:	7e 21                	jle    80105667 <safestrcpy+0x37>
80105646:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010564a:	89 f2                	mov    %esi,%edx
8010564c:	eb 12                	jmp    80105660 <safestrcpy+0x30>
8010564e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105650:	0f b6 08             	movzbl (%eax),%ecx
80105653:	83 c0 01             	add    $0x1,%eax
80105656:	83 c2 01             	add    $0x1,%edx
80105659:	88 4a ff             	mov    %cl,-0x1(%edx)
8010565c:	84 c9                	test   %cl,%cl
8010565e:	74 04                	je     80105664 <safestrcpy+0x34>
80105660:	39 d8                	cmp    %ebx,%eax
80105662:	75 ec                	jne    80105650 <safestrcpy+0x20>
    ;
  *s = 0;
80105664:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105667:	89 f0                	mov    %esi,%eax
80105669:	5b                   	pop    %ebx
8010566a:	5e                   	pop    %esi
8010566b:	5d                   	pop    %ebp
8010566c:	c3                   	ret    
8010566d:	8d 76 00             	lea    0x0(%esi),%esi

80105670 <strlen>:

int
strlen(const char *s)
{
80105670:	f3 0f 1e fb          	endbr32 
80105674:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105675:	31 c0                	xor    %eax,%eax
{
80105677:	89 e5                	mov    %esp,%ebp
80105679:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010567c:	80 3a 00             	cmpb   $0x0,(%edx)
8010567f:	74 10                	je     80105691 <strlen+0x21>
80105681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105688:	83 c0 01             	add    $0x1,%eax
8010568b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010568f:	75 f7                	jne    80105688 <strlen+0x18>
    ;
  return n;
}
80105691:	5d                   	pop    %ebp
80105692:	c3                   	ret    

80105693 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105693:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105697:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010569b:	55                   	push   %ebp
  pushl %ebx
8010569c:	53                   	push   %ebx
  pushl %esi
8010569d:	56                   	push   %esi
  pushl %edi
8010569e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010569f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801056a1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801056a3:	5f                   	pop    %edi
  popl %esi
801056a4:	5e                   	pop    %esi
  popl %ebx
801056a5:	5b                   	pop    %ebx
  popl %ebp
801056a6:	5d                   	pop    %ebp
  ret
801056a7:	c3                   	ret    
801056a8:	66 90                	xchg   %ax,%ax
801056aa:	66 90                	xchg   %ax,%ax
801056ac:	66 90                	xchg   %ax,%ax
801056ae:	66 90                	xchg   %ax,%ax

801056b0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801056b0:	f3 0f 1e fb          	endbr32 
801056b4:	55                   	push   %ebp
801056b5:	89 e5                	mov    %esp,%ebp
801056b7:	53                   	push   %ebx
801056b8:	83 ec 04             	sub    $0x4,%esp
801056bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801056be:	e8 ad f0 ff ff       	call   80104770 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801056c3:	8b 00                	mov    (%eax),%eax
801056c5:	39 d8                	cmp    %ebx,%eax
801056c7:	76 17                	jbe    801056e0 <fetchint+0x30>
801056c9:	8d 53 04             	lea    0x4(%ebx),%edx
801056cc:	39 d0                	cmp    %edx,%eax
801056ce:	72 10                	jb     801056e0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801056d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801056d3:	8b 13                	mov    (%ebx),%edx
801056d5:	89 10                	mov    %edx,(%eax)
  return 0;
801056d7:	31 c0                	xor    %eax,%eax
}
801056d9:	83 c4 04             	add    $0x4,%esp
801056dc:	5b                   	pop    %ebx
801056dd:	5d                   	pop    %ebp
801056de:	c3                   	ret    
801056df:	90                   	nop
    return -1;
801056e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e5:	eb f2                	jmp    801056d9 <fetchint+0x29>
801056e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ee:	66 90                	xchg   %ax,%ax

801056f0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801056f0:	f3 0f 1e fb          	endbr32 
801056f4:	55                   	push   %ebp
801056f5:	89 e5                	mov    %esp,%ebp
801056f7:	53                   	push   %ebx
801056f8:	83 ec 04             	sub    $0x4,%esp
801056fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801056fe:	e8 6d f0 ff ff       	call   80104770 <myproc>

  if(addr >= curproc->sz)
80105703:	39 18                	cmp    %ebx,(%eax)
80105705:	76 31                	jbe    80105738 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105707:	8b 55 0c             	mov    0xc(%ebp),%edx
8010570a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010570c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010570e:	39 d3                	cmp    %edx,%ebx
80105710:	73 26                	jae    80105738 <fetchstr+0x48>
80105712:	89 d8                	mov    %ebx,%eax
80105714:	eb 11                	jmp    80105727 <fetchstr+0x37>
80105716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571d:	8d 76 00             	lea    0x0(%esi),%esi
80105720:	83 c0 01             	add    $0x1,%eax
80105723:	39 c2                	cmp    %eax,%edx
80105725:	76 11                	jbe    80105738 <fetchstr+0x48>
    if(*s == 0)
80105727:	80 38 00             	cmpb   $0x0,(%eax)
8010572a:	75 f4                	jne    80105720 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010572c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010572f:	29 d8                	sub    %ebx,%eax
}
80105731:	5b                   	pop    %ebx
80105732:	5d                   	pop    %ebp
80105733:	c3                   	ret    
80105734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105738:	83 c4 04             	add    $0x4,%esp
    return -1;
8010573b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105740:	5b                   	pop    %ebx
80105741:	5d                   	pop    %ebp
80105742:	c3                   	ret    
80105743:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105750 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105750:	f3 0f 1e fb          	endbr32 
80105754:	55                   	push   %ebp
80105755:	89 e5                	mov    %esp,%ebp
80105757:	56                   	push   %esi
80105758:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105759:	e8 12 f0 ff ff       	call   80104770 <myproc>
8010575e:	8b 55 08             	mov    0x8(%ebp),%edx
80105761:	8b 40 18             	mov    0x18(%eax),%eax
80105764:	8b 40 44             	mov    0x44(%eax),%eax
80105767:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010576a:	e8 01 f0 ff ff       	call   80104770 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010576f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105772:	8b 00                	mov    (%eax),%eax
80105774:	39 c6                	cmp    %eax,%esi
80105776:	73 18                	jae    80105790 <argint+0x40>
80105778:	8d 53 08             	lea    0x8(%ebx),%edx
8010577b:	39 d0                	cmp    %edx,%eax
8010577d:	72 11                	jb     80105790 <argint+0x40>
  *ip = *(int*)(addr);
8010577f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105782:	8b 53 04             	mov    0x4(%ebx),%edx
80105785:	89 10                	mov    %edx,(%eax)
  return 0;
80105787:	31 c0                	xor    %eax,%eax
}
80105789:	5b                   	pop    %ebx
8010578a:	5e                   	pop    %esi
8010578b:	5d                   	pop    %ebp
8010578c:	c3                   	ret    
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105790:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105795:	eb f2                	jmp    80105789 <argint+0x39>
80105797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579e:	66 90                	xchg   %ax,%ax

801057a0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801057a0:	f3 0f 1e fb          	endbr32 
801057a4:	55                   	push   %ebp
801057a5:	89 e5                	mov    %esp,%ebp
801057a7:	56                   	push   %esi
801057a8:	53                   	push   %ebx
801057a9:	83 ec 10             	sub    $0x10,%esp
801057ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801057af:	e8 bc ef ff ff       	call   80104770 <myproc>
 
  if(argint(n, &i) < 0)
801057b4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801057b7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801057b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057bc:	50                   	push   %eax
801057bd:	ff 75 08             	pushl  0x8(%ebp)
801057c0:	e8 8b ff ff ff       	call   80105750 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801057c5:	83 c4 10             	add    $0x10,%esp
801057c8:	85 c0                	test   %eax,%eax
801057ca:	78 24                	js     801057f0 <argptr+0x50>
801057cc:	85 db                	test   %ebx,%ebx
801057ce:	78 20                	js     801057f0 <argptr+0x50>
801057d0:	8b 16                	mov    (%esi),%edx
801057d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d5:	39 c2                	cmp    %eax,%edx
801057d7:	76 17                	jbe    801057f0 <argptr+0x50>
801057d9:	01 c3                	add    %eax,%ebx
801057db:	39 da                	cmp    %ebx,%edx
801057dd:	72 11                	jb     801057f0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801057df:	8b 55 0c             	mov    0xc(%ebp),%edx
801057e2:	89 02                	mov    %eax,(%edx)
  return 0;
801057e4:	31 c0                	xor    %eax,%eax
}
801057e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057e9:	5b                   	pop    %ebx
801057ea:	5e                   	pop    %esi
801057eb:	5d                   	pop    %ebp
801057ec:	c3                   	ret    
801057ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f5:	eb ef                	jmp    801057e6 <argptr+0x46>
801057f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057fe:	66 90                	xchg   %ax,%ax

80105800 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105800:	f3 0f 1e fb          	endbr32 
80105804:	55                   	push   %ebp
80105805:	89 e5                	mov    %esp,%ebp
80105807:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010580a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010580d:	50                   	push   %eax
8010580e:	ff 75 08             	pushl  0x8(%ebp)
80105811:	e8 3a ff ff ff       	call   80105750 <argint>
80105816:	83 c4 10             	add    $0x10,%esp
80105819:	85 c0                	test   %eax,%eax
8010581b:	78 13                	js     80105830 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010581d:	83 ec 08             	sub    $0x8,%esp
80105820:	ff 75 0c             	pushl  0xc(%ebp)
80105823:	ff 75 f4             	pushl  -0xc(%ebp)
80105826:	e8 c5 fe ff ff       	call   801056f0 <fetchstr>
8010582b:	83 c4 10             	add    $0x10,%esp
}
8010582e:	c9                   	leave  
8010582f:	c3                   	ret    
80105830:	c9                   	leave  
    return -1;
80105831:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105836:	c3                   	ret    
80105837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583e:	66 90                	xchg   %ax,%ax

80105840 <syscall>:
[SYS_swapstat] sys_swapstat,
};

void
syscall(void)
{
80105840:	f3 0f 1e fb          	endbr32 
80105844:	55                   	push   %ebp
80105845:	89 e5                	mov    %esp,%ebp
80105847:	53                   	push   %ebx
80105848:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010584b:	e8 20 ef ff ff       	call   80104770 <myproc>
80105850:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105852:	8b 40 18             	mov    0x18(%eax),%eax
80105855:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105858:	8d 50 ff             	lea    -0x1(%eax),%edx
8010585b:	83 fa 17             	cmp    $0x17,%edx
8010585e:	77 20                	ja     80105880 <syscall+0x40>
80105860:	8b 14 85 40 8b 10 80 	mov    -0x7fef74c0(,%eax,4),%edx
80105867:	85 d2                	test   %edx,%edx
80105869:	74 15                	je     80105880 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010586b:	ff d2                	call   *%edx
8010586d:	89 c2                	mov    %eax,%edx
8010586f:	8b 43 18             	mov    0x18(%ebx),%eax
80105872:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105878:	c9                   	leave  
80105879:	c3                   	ret    
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105880:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105881:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105884:	50                   	push   %eax
80105885:	ff 73 10             	pushl  0x10(%ebx)
80105888:	68 19 8b 10 80       	push   $0x80108b19
8010588d:	e8 1e ae ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105892:	8b 43 18             	mov    0x18(%ebx),%eax
80105895:	83 c4 10             	add    $0x10,%esp
80105898:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010589f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058a2:	c9                   	leave  
801058a3:	c3                   	ret    
801058a4:	66 90                	xchg   %ax,%ax
801058a6:	66 90                	xchg   %ax,%ax
801058a8:	66 90                	xchg   %ax,%ax
801058aa:	66 90                	xchg   %ax,%ax
801058ac:	66 90                	xchg   %ax,%ax
801058ae:	66 90                	xchg   %ax,%ax

801058b0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	57                   	push   %edi
801058b4:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801058b5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801058b8:	53                   	push   %ebx
801058b9:	83 ec 44             	sub    $0x44,%esp
801058bc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801058bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801058c2:	57                   	push   %edi
801058c3:	50                   	push   %eax
{
801058c4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801058c7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801058ca:	e8 81 c7 ff ff       	call   80102050 <nameiparent>
801058cf:	83 c4 10             	add    $0x10,%esp
801058d2:	85 c0                	test   %eax,%eax
801058d4:	0f 84 46 01 00 00    	je     80105a20 <create+0x170>
    return 0;
  ilock(dp);
801058da:	83 ec 0c             	sub    $0xc,%esp
801058dd:	89 c3                	mov    %eax,%ebx
801058df:	50                   	push   %eax
801058e0:	e8 7b be ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801058e5:	83 c4 0c             	add    $0xc,%esp
801058e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801058eb:	50                   	push   %eax
801058ec:	57                   	push   %edi
801058ed:	53                   	push   %ebx
801058ee:	e8 bd c3 ff ff       	call   80101cb0 <dirlookup>
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	89 c6                	mov    %eax,%esi
801058f8:	85 c0                	test   %eax,%eax
801058fa:	74 54                	je     80105950 <create+0xa0>
    iunlockput(dp);
801058fc:	83 ec 0c             	sub    $0xc,%esp
801058ff:	53                   	push   %ebx
80105900:	e8 fb c0 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105905:	89 34 24             	mov    %esi,(%esp)
80105908:	e8 53 be ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010590d:	83 c4 10             	add    $0x10,%esp
80105910:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105915:	75 19                	jne    80105930 <create+0x80>
80105917:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010591c:	75 12                	jne    80105930 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010591e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105921:	89 f0                	mov    %esi,%eax
80105923:	5b                   	pop    %ebx
80105924:	5e                   	pop    %esi
80105925:	5f                   	pop    %edi
80105926:	5d                   	pop    %ebp
80105927:	c3                   	ret    
80105928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592f:	90                   	nop
    iunlockput(ip);
80105930:	83 ec 0c             	sub    $0xc,%esp
80105933:	56                   	push   %esi
    return 0;
80105934:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105936:	e8 c5 c0 ff ff       	call   80101a00 <iunlockput>
    return 0;
8010593b:	83 c4 10             	add    $0x10,%esp
}
8010593e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105941:	89 f0                	mov    %esi,%eax
80105943:	5b                   	pop    %ebx
80105944:	5e                   	pop    %esi
80105945:	5f                   	pop    %edi
80105946:	5d                   	pop    %ebp
80105947:	c3                   	ret    
80105948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105950:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105954:	83 ec 08             	sub    $0x8,%esp
80105957:	50                   	push   %eax
80105958:	ff 33                	pushl  (%ebx)
8010595a:	e8 81 bc ff ff       	call   801015e0 <ialloc>
8010595f:	83 c4 10             	add    $0x10,%esp
80105962:	89 c6                	mov    %eax,%esi
80105964:	85 c0                	test   %eax,%eax
80105966:	0f 84 cd 00 00 00    	je     80105a39 <create+0x189>
  ilock(ip);
8010596c:	83 ec 0c             	sub    $0xc,%esp
8010596f:	50                   	push   %eax
80105970:	e8 eb bd ff ff       	call   80101760 <ilock>
  ip->major = major;
80105975:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105979:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010597d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105981:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105985:	b8 01 00 00 00       	mov    $0x1,%eax
8010598a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010598e:	89 34 24             	mov    %esi,(%esp)
80105991:	e8 0a bd ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105996:	83 c4 10             	add    $0x10,%esp
80105999:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010599e:	74 30                	je     801059d0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801059a0:	83 ec 04             	sub    $0x4,%esp
801059a3:	ff 76 04             	pushl  0x4(%esi)
801059a6:	57                   	push   %edi
801059a7:	53                   	push   %ebx
801059a8:	e8 c3 c5 ff ff       	call   80101f70 <dirlink>
801059ad:	83 c4 10             	add    $0x10,%esp
801059b0:	85 c0                	test   %eax,%eax
801059b2:	78 78                	js     80105a2c <create+0x17c>
  iunlockput(dp);
801059b4:	83 ec 0c             	sub    $0xc,%esp
801059b7:	53                   	push   %ebx
801059b8:	e8 43 c0 ff ff       	call   80101a00 <iunlockput>
  return ip;
801059bd:	83 c4 10             	add    $0x10,%esp
}
801059c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059c3:	89 f0                	mov    %esi,%eax
801059c5:	5b                   	pop    %ebx
801059c6:	5e                   	pop    %esi
801059c7:	5f                   	pop    %edi
801059c8:	5d                   	pop    %ebp
801059c9:	c3                   	ret    
801059ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801059d0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801059d3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801059d8:	53                   	push   %ebx
801059d9:	e8 c2 bc ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801059de:	83 c4 0c             	add    $0xc,%esp
801059e1:	ff 76 04             	pushl  0x4(%esi)
801059e4:	68 c0 8b 10 80       	push   $0x80108bc0
801059e9:	56                   	push   %esi
801059ea:	e8 81 c5 ff ff       	call   80101f70 <dirlink>
801059ef:	83 c4 10             	add    $0x10,%esp
801059f2:	85 c0                	test   %eax,%eax
801059f4:	78 18                	js     80105a0e <create+0x15e>
801059f6:	83 ec 04             	sub    $0x4,%esp
801059f9:	ff 73 04             	pushl  0x4(%ebx)
801059fc:	68 bf 8b 10 80       	push   $0x80108bbf
80105a01:	56                   	push   %esi
80105a02:	e8 69 c5 ff ff       	call   80101f70 <dirlink>
80105a07:	83 c4 10             	add    $0x10,%esp
80105a0a:	85 c0                	test   %eax,%eax
80105a0c:	79 92                	jns    801059a0 <create+0xf0>
      panic("create dots");
80105a0e:	83 ec 0c             	sub    $0xc,%esp
80105a11:	68 b3 8b 10 80       	push   $0x80108bb3
80105a16:	e8 75 a9 ff ff       	call   80100390 <panic>
80105a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a1f:	90                   	nop
}
80105a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105a23:	31 f6                	xor    %esi,%esi
}
80105a25:	5b                   	pop    %ebx
80105a26:	89 f0                	mov    %esi,%eax
80105a28:	5e                   	pop    %esi
80105a29:	5f                   	pop    %edi
80105a2a:	5d                   	pop    %ebp
80105a2b:	c3                   	ret    
    panic("create: dirlink");
80105a2c:	83 ec 0c             	sub    $0xc,%esp
80105a2f:	68 c2 8b 10 80       	push   $0x80108bc2
80105a34:	e8 57 a9 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105a39:	83 ec 0c             	sub    $0xc,%esp
80105a3c:	68 a4 8b 10 80       	push   $0x80108ba4
80105a41:	e8 4a a9 ff ff       	call   80100390 <panic>
80105a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi

80105a50 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	56                   	push   %esi
80105a54:	89 d6                	mov    %edx,%esi
80105a56:	53                   	push   %ebx
80105a57:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105a59:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105a5c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105a5f:	50                   	push   %eax
80105a60:	6a 00                	push   $0x0
80105a62:	e8 e9 fc ff ff       	call   80105750 <argint>
80105a67:	83 c4 10             	add    $0x10,%esp
80105a6a:	85 c0                	test   %eax,%eax
80105a6c:	78 2a                	js     80105a98 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105a6e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105a72:	77 24                	ja     80105a98 <argfd.constprop.0+0x48>
80105a74:	e8 f7 ec ff ff       	call   80104770 <myproc>
80105a79:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a7c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105a80:	85 c0                	test   %eax,%eax
80105a82:	74 14                	je     80105a98 <argfd.constprop.0+0x48>
  if(pfd)
80105a84:	85 db                	test   %ebx,%ebx
80105a86:	74 02                	je     80105a8a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105a88:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105a8a:	89 06                	mov    %eax,(%esi)
  return 0;
80105a8c:	31 c0                	xor    %eax,%eax
}
80105a8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a91:	5b                   	pop    %ebx
80105a92:	5e                   	pop    %esi
80105a93:	5d                   	pop    %ebp
80105a94:	c3                   	ret    
80105a95:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9d:	eb ef                	jmp    80105a8e <argfd.constprop.0+0x3e>
80105a9f:	90                   	nop

80105aa0 <sys_dup>:
{
80105aa0:	f3 0f 1e fb          	endbr32 
80105aa4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105aa5:	31 c0                	xor    %eax,%eax
{
80105aa7:	89 e5                	mov    %esp,%ebp
80105aa9:	56                   	push   %esi
80105aaa:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105aab:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105aae:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105ab1:	e8 9a ff ff ff       	call   80105a50 <argfd.constprop.0>
80105ab6:	85 c0                	test   %eax,%eax
80105ab8:	78 1e                	js     80105ad8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80105aba:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105abd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105abf:	e8 ac ec ff ff       	call   80104770 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105ac8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105acc:	85 d2                	test   %edx,%edx
80105ace:	74 20                	je     80105af0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105ad0:	83 c3 01             	add    $0x1,%ebx
80105ad3:	83 fb 10             	cmp    $0x10,%ebx
80105ad6:	75 f0                	jne    80105ac8 <sys_dup+0x28>
}
80105ad8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105adb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105ae0:	89 d8                	mov    %ebx,%eax
80105ae2:	5b                   	pop    %ebx
80105ae3:	5e                   	pop    %esi
80105ae4:	5d                   	pop    %ebp
80105ae5:	c3                   	ret    
80105ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aed:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105af0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105af4:	83 ec 0c             	sub    $0xc,%esp
80105af7:	ff 75 f4             	pushl  -0xc(%ebp)
80105afa:	e8 71 b3 ff ff       	call   80100e70 <filedup>
  return fd;
80105aff:	83 c4 10             	add    $0x10,%esp
}
80105b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b05:	89 d8                	mov    %ebx,%eax
80105b07:	5b                   	pop    %ebx
80105b08:	5e                   	pop    %esi
80105b09:	5d                   	pop    %ebp
80105b0a:	c3                   	ret    
80105b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b0f:	90                   	nop

80105b10 <sys_read>:
{
80105b10:	f3 0f 1e fb          	endbr32 
80105b14:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b15:	31 c0                	xor    %eax,%eax
{
80105b17:	89 e5                	mov    %esp,%ebp
80105b19:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b1c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105b1f:	e8 2c ff ff ff       	call   80105a50 <argfd.constprop.0>
80105b24:	85 c0                	test   %eax,%eax
80105b26:	78 48                	js     80105b70 <sys_read+0x60>
80105b28:	83 ec 08             	sub    $0x8,%esp
80105b2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b2e:	50                   	push   %eax
80105b2f:	6a 02                	push   $0x2
80105b31:	e8 1a fc ff ff       	call   80105750 <argint>
80105b36:	83 c4 10             	add    $0x10,%esp
80105b39:	85 c0                	test   %eax,%eax
80105b3b:	78 33                	js     80105b70 <sys_read+0x60>
80105b3d:	83 ec 04             	sub    $0x4,%esp
80105b40:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b43:	ff 75 f0             	pushl  -0x10(%ebp)
80105b46:	50                   	push   %eax
80105b47:	6a 01                	push   $0x1
80105b49:	e8 52 fc ff ff       	call   801057a0 <argptr>
80105b4e:	83 c4 10             	add    $0x10,%esp
80105b51:	85 c0                	test   %eax,%eax
80105b53:	78 1b                	js     80105b70 <sys_read+0x60>
  return fileread(f, p, n);
80105b55:	83 ec 04             	sub    $0x4,%esp
80105b58:	ff 75 f0             	pushl  -0x10(%ebp)
80105b5b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b5e:	ff 75 ec             	pushl  -0x14(%ebp)
80105b61:	e8 8a b4 ff ff       	call   80100ff0 <fileread>
80105b66:	83 c4 10             	add    $0x10,%esp
}
80105b69:	c9                   	leave  
80105b6a:	c3                   	ret    
80105b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b6f:	90                   	nop
80105b70:	c9                   	leave  
    return -1;
80105b71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b76:	c3                   	ret    
80105b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7e:	66 90                	xchg   %ax,%ax

80105b80 <sys_write>:
{
80105b80:	f3 0f 1e fb          	endbr32 
80105b84:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b85:	31 c0                	xor    %eax,%eax
{
80105b87:	89 e5                	mov    %esp,%ebp
80105b89:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b8c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105b8f:	e8 bc fe ff ff       	call   80105a50 <argfd.constprop.0>
80105b94:	85 c0                	test   %eax,%eax
80105b96:	78 48                	js     80105be0 <sys_write+0x60>
80105b98:	83 ec 08             	sub    $0x8,%esp
80105b9b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b9e:	50                   	push   %eax
80105b9f:	6a 02                	push   $0x2
80105ba1:	e8 aa fb ff ff       	call   80105750 <argint>
80105ba6:	83 c4 10             	add    $0x10,%esp
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	78 33                	js     80105be0 <sys_write+0x60>
80105bad:	83 ec 04             	sub    $0x4,%esp
80105bb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bb3:	ff 75 f0             	pushl  -0x10(%ebp)
80105bb6:	50                   	push   %eax
80105bb7:	6a 01                	push   $0x1
80105bb9:	e8 e2 fb ff ff       	call   801057a0 <argptr>
80105bbe:	83 c4 10             	add    $0x10,%esp
80105bc1:	85 c0                	test   %eax,%eax
80105bc3:	78 1b                	js     80105be0 <sys_write+0x60>
  return filewrite(f, p, n);
80105bc5:	83 ec 04             	sub    $0x4,%esp
80105bc8:	ff 75 f0             	pushl  -0x10(%ebp)
80105bcb:	ff 75 f4             	pushl  -0xc(%ebp)
80105bce:	ff 75 ec             	pushl  -0x14(%ebp)
80105bd1:	e8 ba b4 ff ff       	call   80101090 <filewrite>
80105bd6:	83 c4 10             	add    $0x10,%esp
}
80105bd9:	c9                   	leave  
80105bda:	c3                   	ret    
80105bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop
80105be0:	c9                   	leave  
    return -1;
80105be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105be6:	c3                   	ret    
80105be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bee:	66 90                	xchg   %ax,%ax

80105bf0 <sys_close>:
{
80105bf0:	f3 0f 1e fb          	endbr32 
80105bf4:	55                   	push   %ebp
80105bf5:	89 e5                	mov    %esp,%ebp
80105bf7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105bfa:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105bfd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c00:	e8 4b fe ff ff       	call   80105a50 <argfd.constprop.0>
80105c05:	85 c0                	test   %eax,%eax
80105c07:	78 27                	js     80105c30 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105c09:	e8 62 eb ff ff       	call   80104770 <myproc>
80105c0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105c11:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105c14:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105c1b:	00 
  fileclose(f);
80105c1c:	ff 75 f4             	pushl  -0xc(%ebp)
80105c1f:	e8 9c b2 ff ff       	call   80100ec0 <fileclose>
  return 0;
80105c24:	83 c4 10             	add    $0x10,%esp
80105c27:	31 c0                	xor    %eax,%eax
}
80105c29:	c9                   	leave  
80105c2a:	c3                   	ret    
80105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop
80105c30:	c9                   	leave  
    return -1;
80105c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c36:	c3                   	ret    
80105c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3e:	66 90                	xchg   %ax,%ax

80105c40 <sys_fstat>:
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105c45:	31 c0                	xor    %eax,%eax
{
80105c47:	89 e5                	mov    %esp,%ebp
80105c49:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105c4c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105c4f:	e8 fc fd ff ff       	call   80105a50 <argfd.constprop.0>
80105c54:	85 c0                	test   %eax,%eax
80105c56:	78 30                	js     80105c88 <sys_fstat+0x48>
80105c58:	83 ec 04             	sub    $0x4,%esp
80105c5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c5e:	6a 14                	push   $0x14
80105c60:	50                   	push   %eax
80105c61:	6a 01                	push   $0x1
80105c63:	e8 38 fb ff ff       	call   801057a0 <argptr>
80105c68:	83 c4 10             	add    $0x10,%esp
80105c6b:	85 c0                	test   %eax,%eax
80105c6d:	78 19                	js     80105c88 <sys_fstat+0x48>
  return filestat(f, st);
80105c6f:	83 ec 08             	sub    $0x8,%esp
80105c72:	ff 75 f4             	pushl  -0xc(%ebp)
80105c75:	ff 75 f0             	pushl  -0x10(%ebp)
80105c78:	e8 23 b3 ff ff       	call   80100fa0 <filestat>
80105c7d:	83 c4 10             	add    $0x10,%esp
}
80105c80:	c9                   	leave  
80105c81:	c3                   	ret    
80105c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c88:	c9                   	leave  
    return -1;
80105c89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c8e:	c3                   	ret    
80105c8f:	90                   	nop

80105c90 <sys_link>:
{
80105c90:	f3 0f 1e fb          	endbr32 
80105c94:	55                   	push   %ebp
80105c95:	89 e5                	mov    %esp,%ebp
80105c97:	57                   	push   %edi
80105c98:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105c99:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105c9c:	53                   	push   %ebx
80105c9d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105ca0:	50                   	push   %eax
80105ca1:	6a 00                	push   $0x0
80105ca3:	e8 58 fb ff ff       	call   80105800 <argstr>
80105ca8:	83 c4 10             	add    $0x10,%esp
80105cab:	85 c0                	test   %eax,%eax
80105cad:	0f 88 ff 00 00 00    	js     80105db2 <sys_link+0x122>
80105cb3:	83 ec 08             	sub    $0x8,%esp
80105cb6:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105cb9:	50                   	push   %eax
80105cba:	6a 01                	push   $0x1
80105cbc:	e8 3f fb ff ff       	call   80105800 <argstr>
80105cc1:	83 c4 10             	add    $0x10,%esp
80105cc4:	85 c0                	test   %eax,%eax
80105cc6:	0f 88 e6 00 00 00    	js     80105db2 <sys_link+0x122>
  begin_op();
80105ccc:	e8 6f de ff ff       	call   80103b40 <begin_op>
  if((ip = namei(old)) == 0){
80105cd1:	83 ec 0c             	sub    $0xc,%esp
80105cd4:	ff 75 d4             	pushl  -0x2c(%ebp)
80105cd7:	e8 54 c3 ff ff       	call   80102030 <namei>
80105cdc:	83 c4 10             	add    $0x10,%esp
80105cdf:	89 c3                	mov    %eax,%ebx
80105ce1:	85 c0                	test   %eax,%eax
80105ce3:	0f 84 e8 00 00 00    	je     80105dd1 <sys_link+0x141>
  ilock(ip);
80105ce9:	83 ec 0c             	sub    $0xc,%esp
80105cec:	50                   	push   %eax
80105ced:	e8 6e ba ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105cf2:	83 c4 10             	add    $0x10,%esp
80105cf5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cfa:	0f 84 b9 00 00 00    	je     80105db9 <sys_link+0x129>
  iupdate(ip);
80105d00:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105d03:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105d08:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105d0b:	53                   	push   %ebx
80105d0c:	e8 8f b9 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105d11:	89 1c 24             	mov    %ebx,(%esp)
80105d14:	e8 27 bb ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105d19:	58                   	pop    %eax
80105d1a:	5a                   	pop    %edx
80105d1b:	57                   	push   %edi
80105d1c:	ff 75 d0             	pushl  -0x30(%ebp)
80105d1f:	e8 2c c3 ff ff       	call   80102050 <nameiparent>
80105d24:	83 c4 10             	add    $0x10,%esp
80105d27:	89 c6                	mov    %eax,%esi
80105d29:	85 c0                	test   %eax,%eax
80105d2b:	74 5f                	je     80105d8c <sys_link+0xfc>
  ilock(dp);
80105d2d:	83 ec 0c             	sub    $0xc,%esp
80105d30:	50                   	push   %eax
80105d31:	e8 2a ba ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105d36:	8b 03                	mov    (%ebx),%eax
80105d38:	83 c4 10             	add    $0x10,%esp
80105d3b:	39 06                	cmp    %eax,(%esi)
80105d3d:	75 41                	jne    80105d80 <sys_link+0xf0>
80105d3f:	83 ec 04             	sub    $0x4,%esp
80105d42:	ff 73 04             	pushl  0x4(%ebx)
80105d45:	57                   	push   %edi
80105d46:	56                   	push   %esi
80105d47:	e8 24 c2 ff ff       	call   80101f70 <dirlink>
80105d4c:	83 c4 10             	add    $0x10,%esp
80105d4f:	85 c0                	test   %eax,%eax
80105d51:	78 2d                	js     80105d80 <sys_link+0xf0>
  iunlockput(dp);
80105d53:	83 ec 0c             	sub    $0xc,%esp
80105d56:	56                   	push   %esi
80105d57:	e8 a4 bc ff ff       	call   80101a00 <iunlockput>
  iput(ip);
80105d5c:	89 1c 24             	mov    %ebx,(%esp)
80105d5f:	e8 2c bb ff ff       	call   80101890 <iput>
  end_op();
80105d64:	e8 47 de ff ff       	call   80103bb0 <end_op>
  return 0;
80105d69:	83 c4 10             	add    $0x10,%esp
80105d6c:	31 c0                	xor    %eax,%eax
}
80105d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d71:	5b                   	pop    %ebx
80105d72:	5e                   	pop    %esi
80105d73:	5f                   	pop    %edi
80105d74:	5d                   	pop    %ebp
80105d75:	c3                   	ret    
80105d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d7d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105d80:	83 ec 0c             	sub    $0xc,%esp
80105d83:	56                   	push   %esi
80105d84:	e8 77 bc ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105d89:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105d8c:	83 ec 0c             	sub    $0xc,%esp
80105d8f:	53                   	push   %ebx
80105d90:	e8 cb b9 ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105d95:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105d9a:	89 1c 24             	mov    %ebx,(%esp)
80105d9d:	e8 fe b8 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105da2:	89 1c 24             	mov    %ebx,(%esp)
80105da5:	e8 56 bc ff ff       	call   80101a00 <iunlockput>
  end_op();
80105daa:	e8 01 de ff ff       	call   80103bb0 <end_op>
  return -1;
80105daf:	83 c4 10             	add    $0x10,%esp
80105db2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db7:	eb b5                	jmp    80105d6e <sys_link+0xde>
    iunlockput(ip);
80105db9:	83 ec 0c             	sub    $0xc,%esp
80105dbc:	53                   	push   %ebx
80105dbd:	e8 3e bc ff ff       	call   80101a00 <iunlockput>
    end_op();
80105dc2:	e8 e9 dd ff ff       	call   80103bb0 <end_op>
    return -1;
80105dc7:	83 c4 10             	add    $0x10,%esp
80105dca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dcf:	eb 9d                	jmp    80105d6e <sys_link+0xde>
    end_op();
80105dd1:	e8 da dd ff ff       	call   80103bb0 <end_op>
    return -1;
80105dd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ddb:	eb 91                	jmp    80105d6e <sys_link+0xde>
80105ddd:	8d 76 00             	lea    0x0(%esi),%esi

80105de0 <sys_unlink>:
{
80105de0:	f3 0f 1e fb          	endbr32 
80105de4:	55                   	push   %ebp
80105de5:	89 e5                	mov    %esp,%ebp
80105de7:	57                   	push   %edi
80105de8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105de9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105dec:	53                   	push   %ebx
80105ded:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105df0:	50                   	push   %eax
80105df1:	6a 00                	push   $0x0
80105df3:	e8 08 fa ff ff       	call   80105800 <argstr>
80105df8:	83 c4 10             	add    $0x10,%esp
80105dfb:	85 c0                	test   %eax,%eax
80105dfd:	0f 88 7d 01 00 00    	js     80105f80 <sys_unlink+0x1a0>
  begin_op();
80105e03:	e8 38 dd ff ff       	call   80103b40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105e08:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105e0b:	83 ec 08             	sub    $0x8,%esp
80105e0e:	53                   	push   %ebx
80105e0f:	ff 75 c0             	pushl  -0x40(%ebp)
80105e12:	e8 39 c2 ff ff       	call   80102050 <nameiparent>
80105e17:	83 c4 10             	add    $0x10,%esp
80105e1a:	89 c6                	mov    %eax,%esi
80105e1c:	85 c0                	test   %eax,%eax
80105e1e:	0f 84 66 01 00 00    	je     80105f8a <sys_unlink+0x1aa>
  ilock(dp);
80105e24:	83 ec 0c             	sub    $0xc,%esp
80105e27:	50                   	push   %eax
80105e28:	e8 33 b9 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105e2d:	58                   	pop    %eax
80105e2e:	5a                   	pop    %edx
80105e2f:	68 c0 8b 10 80       	push   $0x80108bc0
80105e34:	53                   	push   %ebx
80105e35:	e8 56 be ff ff       	call   80101c90 <namecmp>
80105e3a:	83 c4 10             	add    $0x10,%esp
80105e3d:	85 c0                	test   %eax,%eax
80105e3f:	0f 84 03 01 00 00    	je     80105f48 <sys_unlink+0x168>
80105e45:	83 ec 08             	sub    $0x8,%esp
80105e48:	68 bf 8b 10 80       	push   $0x80108bbf
80105e4d:	53                   	push   %ebx
80105e4e:	e8 3d be ff ff       	call   80101c90 <namecmp>
80105e53:	83 c4 10             	add    $0x10,%esp
80105e56:	85 c0                	test   %eax,%eax
80105e58:	0f 84 ea 00 00 00    	je     80105f48 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105e5e:	83 ec 04             	sub    $0x4,%esp
80105e61:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105e64:	50                   	push   %eax
80105e65:	53                   	push   %ebx
80105e66:	56                   	push   %esi
80105e67:	e8 44 be ff ff       	call   80101cb0 <dirlookup>
80105e6c:	83 c4 10             	add    $0x10,%esp
80105e6f:	89 c3                	mov    %eax,%ebx
80105e71:	85 c0                	test   %eax,%eax
80105e73:	0f 84 cf 00 00 00    	je     80105f48 <sys_unlink+0x168>
  ilock(ip);
80105e79:	83 ec 0c             	sub    $0xc,%esp
80105e7c:	50                   	push   %eax
80105e7d:	e8 de b8 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105e82:	83 c4 10             	add    $0x10,%esp
80105e85:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105e8a:	0f 8e 23 01 00 00    	jle    80105fb3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105e90:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e95:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105e98:	74 66                	je     80105f00 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105e9a:	83 ec 04             	sub    $0x4,%esp
80105e9d:	6a 10                	push   $0x10
80105e9f:	6a 00                	push   $0x0
80105ea1:	57                   	push   %edi
80105ea2:	e8 c9 f5 ff ff       	call   80105470 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ea7:	6a 10                	push   $0x10
80105ea9:	ff 75 c4             	pushl  -0x3c(%ebp)
80105eac:	57                   	push   %edi
80105ead:	56                   	push   %esi
80105eae:	e8 ad bc ff ff       	call   80101b60 <writei>
80105eb3:	83 c4 20             	add    $0x20,%esp
80105eb6:	83 f8 10             	cmp    $0x10,%eax
80105eb9:	0f 85 e7 00 00 00    	jne    80105fa6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
80105ebf:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ec4:	0f 84 96 00 00 00    	je     80105f60 <sys_unlink+0x180>
  iunlockput(dp);
80105eca:	83 ec 0c             	sub    $0xc,%esp
80105ecd:	56                   	push   %esi
80105ece:	e8 2d bb ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105ed3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105ed8:	89 1c 24             	mov    %ebx,(%esp)
80105edb:	e8 c0 b7 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105ee0:	89 1c 24             	mov    %ebx,(%esp)
80105ee3:	e8 18 bb ff ff       	call   80101a00 <iunlockput>
  end_op();
80105ee8:	e8 c3 dc ff ff       	call   80103bb0 <end_op>
  return 0;
80105eed:	83 c4 10             	add    $0x10,%esp
80105ef0:	31 c0                	xor    %eax,%eax
}
80105ef2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ef5:	5b                   	pop    %ebx
80105ef6:	5e                   	pop    %esi
80105ef7:	5f                   	pop    %edi
80105ef8:	5d                   	pop    %ebp
80105ef9:	c3                   	ret    
80105efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f00:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105f04:	76 94                	jbe    80105e9a <sys_unlink+0xba>
80105f06:	ba 20 00 00 00       	mov    $0x20,%edx
80105f0b:	eb 0b                	jmp    80105f18 <sys_unlink+0x138>
80105f0d:	8d 76 00             	lea    0x0(%esi),%esi
80105f10:	83 c2 10             	add    $0x10,%edx
80105f13:	39 53 58             	cmp    %edx,0x58(%ebx)
80105f16:	76 82                	jbe    80105e9a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f18:	6a 10                	push   $0x10
80105f1a:	52                   	push   %edx
80105f1b:	57                   	push   %edi
80105f1c:	53                   	push   %ebx
80105f1d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105f20:	e8 3b bb ff ff       	call   80101a60 <readi>
80105f25:	83 c4 10             	add    $0x10,%esp
80105f28:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105f2b:	83 f8 10             	cmp    $0x10,%eax
80105f2e:	75 69                	jne    80105f99 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105f30:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105f35:	74 d9                	je     80105f10 <sys_unlink+0x130>
    iunlockput(ip);
80105f37:	83 ec 0c             	sub    $0xc,%esp
80105f3a:	53                   	push   %ebx
80105f3b:	e8 c0 ba ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105f40:	83 c4 10             	add    $0x10,%esp
80105f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f47:	90                   	nop
  iunlockput(dp);
80105f48:	83 ec 0c             	sub    $0xc,%esp
80105f4b:	56                   	push   %esi
80105f4c:	e8 af ba ff ff       	call   80101a00 <iunlockput>
  end_op();
80105f51:	e8 5a dc ff ff       	call   80103bb0 <end_op>
  return -1;
80105f56:	83 c4 10             	add    $0x10,%esp
80105f59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f5e:	eb 92                	jmp    80105ef2 <sys_unlink+0x112>
    iupdate(dp);
80105f60:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105f63:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105f68:	56                   	push   %esi
80105f69:	e8 32 b7 ff ff       	call   801016a0 <iupdate>
80105f6e:	83 c4 10             	add    $0x10,%esp
80105f71:	e9 54 ff ff ff       	jmp    80105eca <sys_unlink+0xea>
80105f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f85:	e9 68 ff ff ff       	jmp    80105ef2 <sys_unlink+0x112>
    end_op();
80105f8a:	e8 21 dc ff ff       	call   80103bb0 <end_op>
    return -1;
80105f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f94:	e9 59 ff ff ff       	jmp    80105ef2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105f99:	83 ec 0c             	sub    $0xc,%esp
80105f9c:	68 e4 8b 10 80       	push   $0x80108be4
80105fa1:	e8 ea a3 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105fa6:	83 ec 0c             	sub    $0xc,%esp
80105fa9:	68 f6 8b 10 80       	push   $0x80108bf6
80105fae:	e8 dd a3 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105fb3:	83 ec 0c             	sub    $0xc,%esp
80105fb6:	68 d2 8b 10 80       	push   $0x80108bd2
80105fbb:	e8 d0 a3 ff ff       	call   80100390 <panic>

80105fc0 <sys_open>:

int
sys_open(void)
{
80105fc0:	f3 0f 1e fb          	endbr32 
80105fc4:	55                   	push   %ebp
80105fc5:	89 e5                	mov    %esp,%ebp
80105fc7:	57                   	push   %edi
80105fc8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105fc9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105fcc:	53                   	push   %ebx
80105fcd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105fd0:	50                   	push   %eax
80105fd1:	6a 00                	push   $0x0
80105fd3:	e8 28 f8 ff ff       	call   80105800 <argstr>
80105fd8:	83 c4 10             	add    $0x10,%esp
80105fdb:	85 c0                	test   %eax,%eax
80105fdd:	0f 88 8a 00 00 00    	js     8010606d <sys_open+0xad>
80105fe3:	83 ec 08             	sub    $0x8,%esp
80105fe6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fe9:	50                   	push   %eax
80105fea:	6a 01                	push   $0x1
80105fec:	e8 5f f7 ff ff       	call   80105750 <argint>
80105ff1:	83 c4 10             	add    $0x10,%esp
80105ff4:	85 c0                	test   %eax,%eax
80105ff6:	78 75                	js     8010606d <sys_open+0xad>
    return -1;

  begin_op();
80105ff8:	e8 43 db ff ff       	call   80103b40 <begin_op>

  if(omode & O_CREATE){
80105ffd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106001:	75 75                	jne    80106078 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106003:	83 ec 0c             	sub    $0xc,%esp
80106006:	ff 75 e0             	pushl  -0x20(%ebp)
80106009:	e8 22 c0 ff ff       	call   80102030 <namei>
8010600e:	83 c4 10             	add    $0x10,%esp
80106011:	89 c6                	mov    %eax,%esi
80106013:	85 c0                	test   %eax,%eax
80106015:	74 7e                	je     80106095 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106017:	83 ec 0c             	sub    $0xc,%esp
8010601a:	50                   	push   %eax
8010601b:	e8 40 b7 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106020:	83 c4 10             	add    $0x10,%esp
80106023:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106028:	0f 84 c2 00 00 00    	je     801060f0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010602e:	e8 cd ad ff ff       	call   80100e00 <filealloc>
80106033:	89 c7                	mov    %eax,%edi
80106035:	85 c0                	test   %eax,%eax
80106037:	74 23                	je     8010605c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106039:	e8 32 e7 ff ff       	call   80104770 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010603e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106040:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106044:	85 d2                	test   %edx,%edx
80106046:	74 60                	je     801060a8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106048:	83 c3 01             	add    $0x1,%ebx
8010604b:	83 fb 10             	cmp    $0x10,%ebx
8010604e:	75 f0                	jne    80106040 <sys_open+0x80>
    if(f)
      fileclose(f);
80106050:	83 ec 0c             	sub    $0xc,%esp
80106053:	57                   	push   %edi
80106054:	e8 67 ae ff ff       	call   80100ec0 <fileclose>
80106059:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010605c:	83 ec 0c             	sub    $0xc,%esp
8010605f:	56                   	push   %esi
80106060:	e8 9b b9 ff ff       	call   80101a00 <iunlockput>
    end_op();
80106065:	e8 46 db ff ff       	call   80103bb0 <end_op>
    return -1;
8010606a:	83 c4 10             	add    $0x10,%esp
8010606d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106072:	eb 6d                	jmp    801060e1 <sys_open+0x121>
80106074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106078:	83 ec 0c             	sub    $0xc,%esp
8010607b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010607e:	31 c9                	xor    %ecx,%ecx
80106080:	ba 02 00 00 00       	mov    $0x2,%edx
80106085:	6a 00                	push   $0x0
80106087:	e8 24 f8 ff ff       	call   801058b0 <create>
    if(ip == 0){
8010608c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010608f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106091:	85 c0                	test   %eax,%eax
80106093:	75 99                	jne    8010602e <sys_open+0x6e>
      end_op();
80106095:	e8 16 db ff ff       	call   80103bb0 <end_op>
      return -1;
8010609a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010609f:	eb 40                	jmp    801060e1 <sys_open+0x121>
801060a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801060a8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801060ab:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801060af:	56                   	push   %esi
801060b0:	e8 8b b7 ff ff       	call   80101840 <iunlock>
  end_op();
801060b5:	e8 f6 da ff ff       	call   80103bb0 <end_op>

  f->type = FD_INODE;
801060ba:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801060c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801060c3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801060c6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801060c9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801060cb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801060d2:	f7 d0                	not    %eax
801060d4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801060d7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801060da:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801060dd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801060e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060e4:	89 d8                	mov    %ebx,%eax
801060e6:	5b                   	pop    %ebx
801060e7:	5e                   	pop    %esi
801060e8:	5f                   	pop    %edi
801060e9:	5d                   	pop    %ebp
801060ea:	c3                   	ret    
801060eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060ef:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801060f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801060f3:	85 c9                	test   %ecx,%ecx
801060f5:	0f 84 33 ff ff ff    	je     8010602e <sys_open+0x6e>
801060fb:	e9 5c ff ff ff       	jmp    8010605c <sys_open+0x9c>

80106100 <sys_mkdir>:

int
sys_mkdir(void)
{
80106100:	f3 0f 1e fb          	endbr32 
80106104:	55                   	push   %ebp
80106105:	89 e5                	mov    %esp,%ebp
80106107:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010610a:	e8 31 da ff ff       	call   80103b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010610f:	83 ec 08             	sub    $0x8,%esp
80106112:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106115:	50                   	push   %eax
80106116:	6a 00                	push   $0x0
80106118:	e8 e3 f6 ff ff       	call   80105800 <argstr>
8010611d:	83 c4 10             	add    $0x10,%esp
80106120:	85 c0                	test   %eax,%eax
80106122:	78 34                	js     80106158 <sys_mkdir+0x58>
80106124:	83 ec 0c             	sub    $0xc,%esp
80106127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010612a:	31 c9                	xor    %ecx,%ecx
8010612c:	ba 01 00 00 00       	mov    $0x1,%edx
80106131:	6a 00                	push   $0x0
80106133:	e8 78 f7 ff ff       	call   801058b0 <create>
80106138:	83 c4 10             	add    $0x10,%esp
8010613b:	85 c0                	test   %eax,%eax
8010613d:	74 19                	je     80106158 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010613f:	83 ec 0c             	sub    $0xc,%esp
80106142:	50                   	push   %eax
80106143:	e8 b8 b8 ff ff       	call   80101a00 <iunlockput>
  end_op();
80106148:	e8 63 da ff ff       	call   80103bb0 <end_op>
  return 0;
8010614d:	83 c4 10             	add    $0x10,%esp
80106150:	31 c0                	xor    %eax,%eax
}
80106152:	c9                   	leave  
80106153:	c3                   	ret    
80106154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106158:	e8 53 da ff ff       	call   80103bb0 <end_op>
    return -1;
8010615d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106162:	c9                   	leave  
80106163:	c3                   	ret    
80106164:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010616f:	90                   	nop

80106170 <sys_mknod>:

int
sys_mknod(void)
{
80106170:	f3 0f 1e fb          	endbr32 
80106174:	55                   	push   %ebp
80106175:	89 e5                	mov    %esp,%ebp
80106177:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010617a:	e8 c1 d9 ff ff       	call   80103b40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010617f:	83 ec 08             	sub    $0x8,%esp
80106182:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106185:	50                   	push   %eax
80106186:	6a 00                	push   $0x0
80106188:	e8 73 f6 ff ff       	call   80105800 <argstr>
8010618d:	83 c4 10             	add    $0x10,%esp
80106190:	85 c0                	test   %eax,%eax
80106192:	78 64                	js     801061f8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80106194:	83 ec 08             	sub    $0x8,%esp
80106197:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010619a:	50                   	push   %eax
8010619b:	6a 01                	push   $0x1
8010619d:	e8 ae f5 ff ff       	call   80105750 <argint>
  if((argstr(0, &path)) < 0 ||
801061a2:	83 c4 10             	add    $0x10,%esp
801061a5:	85 c0                	test   %eax,%eax
801061a7:	78 4f                	js     801061f8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801061a9:	83 ec 08             	sub    $0x8,%esp
801061ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061af:	50                   	push   %eax
801061b0:	6a 02                	push   $0x2
801061b2:	e8 99 f5 ff ff       	call   80105750 <argint>
     argint(1, &major) < 0 ||
801061b7:	83 c4 10             	add    $0x10,%esp
801061ba:	85 c0                	test   %eax,%eax
801061bc:	78 3a                	js     801061f8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
801061be:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801061c2:	83 ec 0c             	sub    $0xc,%esp
801061c5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801061c9:	ba 03 00 00 00       	mov    $0x3,%edx
801061ce:	50                   	push   %eax
801061cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801061d2:	e8 d9 f6 ff ff       	call   801058b0 <create>
     argint(2, &minor) < 0 ||
801061d7:	83 c4 10             	add    $0x10,%esp
801061da:	85 c0                	test   %eax,%eax
801061dc:	74 1a                	je     801061f8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801061de:	83 ec 0c             	sub    $0xc,%esp
801061e1:	50                   	push   %eax
801061e2:	e8 19 b8 ff ff       	call   80101a00 <iunlockput>
  end_op();
801061e7:	e8 c4 d9 ff ff       	call   80103bb0 <end_op>
  return 0;
801061ec:	83 c4 10             	add    $0x10,%esp
801061ef:	31 c0                	xor    %eax,%eax
}
801061f1:	c9                   	leave  
801061f2:	c3                   	ret    
801061f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061f7:	90                   	nop
    end_op();
801061f8:	e8 b3 d9 ff ff       	call   80103bb0 <end_op>
    return -1;
801061fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106202:	c9                   	leave  
80106203:	c3                   	ret    
80106204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010620f:	90                   	nop

80106210 <sys_chdir>:

int
sys_chdir(void)
{
80106210:	f3 0f 1e fb          	endbr32 
80106214:	55                   	push   %ebp
80106215:	89 e5                	mov    %esp,%ebp
80106217:	56                   	push   %esi
80106218:	53                   	push   %ebx
80106219:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010621c:	e8 4f e5 ff ff       	call   80104770 <myproc>
80106221:	89 c6                	mov    %eax,%esi
  
  begin_op();
80106223:	e8 18 d9 ff ff       	call   80103b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106228:	83 ec 08             	sub    $0x8,%esp
8010622b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010622e:	50                   	push   %eax
8010622f:	6a 00                	push   $0x0
80106231:	e8 ca f5 ff ff       	call   80105800 <argstr>
80106236:	83 c4 10             	add    $0x10,%esp
80106239:	85 c0                	test   %eax,%eax
8010623b:	78 73                	js     801062b0 <sys_chdir+0xa0>
8010623d:	83 ec 0c             	sub    $0xc,%esp
80106240:	ff 75 f4             	pushl  -0xc(%ebp)
80106243:	e8 e8 bd ff ff       	call   80102030 <namei>
80106248:	83 c4 10             	add    $0x10,%esp
8010624b:	89 c3                	mov    %eax,%ebx
8010624d:	85 c0                	test   %eax,%eax
8010624f:	74 5f                	je     801062b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80106251:	83 ec 0c             	sub    $0xc,%esp
80106254:	50                   	push   %eax
80106255:	e8 06 b5 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
8010625a:	83 c4 10             	add    $0x10,%esp
8010625d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106262:	75 2c                	jne    80106290 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106264:	83 ec 0c             	sub    $0xc,%esp
80106267:	53                   	push   %ebx
80106268:	e8 d3 b5 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
8010626d:	58                   	pop    %eax
8010626e:	ff 76 68             	pushl  0x68(%esi)
80106271:	e8 1a b6 ff ff       	call   80101890 <iput>
  end_op();
80106276:	e8 35 d9 ff ff       	call   80103bb0 <end_op>
  curproc->cwd = ip;
8010627b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010627e:	83 c4 10             	add    $0x10,%esp
80106281:	31 c0                	xor    %eax,%eax
}
80106283:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106286:	5b                   	pop    %ebx
80106287:	5e                   	pop    %esi
80106288:	5d                   	pop    %ebp
80106289:	c3                   	ret    
8010628a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80106290:	83 ec 0c             	sub    $0xc,%esp
80106293:	53                   	push   %ebx
80106294:	e8 67 b7 ff ff       	call   80101a00 <iunlockput>
    end_op();
80106299:	e8 12 d9 ff ff       	call   80103bb0 <end_op>
    return -1;
8010629e:	83 c4 10             	add    $0x10,%esp
801062a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062a6:	eb db                	jmp    80106283 <sys_chdir+0x73>
801062a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062af:	90                   	nop
    end_op();
801062b0:	e8 fb d8 ff ff       	call   80103bb0 <end_op>
    return -1;
801062b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ba:	eb c7                	jmp    80106283 <sys_chdir+0x73>
801062bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062c0 <sys_exec>:

int
sys_exec(void)
{
801062c0:	f3 0f 1e fb          	endbr32 
801062c4:	55                   	push   %ebp
801062c5:	89 e5                	mov    %esp,%ebp
801062c7:	57                   	push   %edi
801062c8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801062c9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801062cf:	53                   	push   %ebx
801062d0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801062d6:	50                   	push   %eax
801062d7:	6a 00                	push   $0x0
801062d9:	e8 22 f5 ff ff       	call   80105800 <argstr>
801062de:	83 c4 10             	add    $0x10,%esp
801062e1:	85 c0                	test   %eax,%eax
801062e3:	0f 88 8b 00 00 00    	js     80106374 <sys_exec+0xb4>
801062e9:	83 ec 08             	sub    $0x8,%esp
801062ec:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801062f2:	50                   	push   %eax
801062f3:	6a 01                	push   $0x1
801062f5:	e8 56 f4 ff ff       	call   80105750 <argint>
801062fa:	83 c4 10             	add    $0x10,%esp
801062fd:	85 c0                	test   %eax,%eax
801062ff:	78 73                	js     80106374 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106301:	83 ec 04             	sub    $0x4,%esp
80106304:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010630a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010630c:	68 80 00 00 00       	push   $0x80
80106311:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106317:	6a 00                	push   $0x0
80106319:	50                   	push   %eax
8010631a:	e8 51 f1 ff ff       	call   80105470 <memset>
8010631f:	83 c4 10             	add    $0x10,%esp
80106322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106328:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010632e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106335:	83 ec 08             	sub    $0x8,%esp
80106338:	57                   	push   %edi
80106339:	01 f0                	add    %esi,%eax
8010633b:	50                   	push   %eax
8010633c:	e8 6f f3 ff ff       	call   801056b0 <fetchint>
80106341:	83 c4 10             	add    $0x10,%esp
80106344:	85 c0                	test   %eax,%eax
80106346:	78 2c                	js     80106374 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80106348:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010634e:	85 c0                	test   %eax,%eax
80106350:	74 36                	je     80106388 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106352:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106358:	83 ec 08             	sub    $0x8,%esp
8010635b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010635e:	52                   	push   %edx
8010635f:	50                   	push   %eax
80106360:	e8 8b f3 ff ff       	call   801056f0 <fetchstr>
80106365:	83 c4 10             	add    $0x10,%esp
80106368:	85 c0                	test   %eax,%eax
8010636a:	78 08                	js     80106374 <sys_exec+0xb4>
  for(i=0;; i++){
8010636c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010636f:	83 fb 20             	cmp    $0x20,%ebx
80106372:	75 b4                	jne    80106328 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80106374:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010637c:	5b                   	pop    %ebx
8010637d:	5e                   	pop    %esi
8010637e:	5f                   	pop    %edi
8010637f:	5d                   	pop    %ebp
80106380:	c3                   	ret    
80106381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106388:	83 ec 08             	sub    $0x8,%esp
8010638b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80106391:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106398:	00 00 00 00 
  return exec(path, argv);
8010639c:	50                   	push   %eax
8010639d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801063a3:	e8 d8 a6 ff ff       	call   80100a80 <exec>
801063a8:	83 c4 10             	add    $0x10,%esp
}
801063ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063ae:	5b                   	pop    %ebx
801063af:	5e                   	pop    %esi
801063b0:	5f                   	pop    %edi
801063b1:	5d                   	pop    %ebp
801063b2:	c3                   	ret    
801063b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801063c0 <sys_pipe>:

int
sys_pipe(void)
{
801063c0:	f3 0f 1e fb          	endbr32 
801063c4:	55                   	push   %ebp
801063c5:	89 e5                	mov    %esp,%ebp
801063c7:	57                   	push   %edi
801063c8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801063c9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801063cc:	53                   	push   %ebx
801063cd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801063d0:	6a 08                	push   $0x8
801063d2:	50                   	push   %eax
801063d3:	6a 00                	push   $0x0
801063d5:	e8 c6 f3 ff ff       	call   801057a0 <argptr>
801063da:	83 c4 10             	add    $0x10,%esp
801063dd:	85 c0                	test   %eax,%eax
801063df:	78 4e                	js     8010642f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801063e1:	83 ec 08             	sub    $0x8,%esp
801063e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801063e7:	50                   	push   %eax
801063e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801063eb:	50                   	push   %eax
801063ec:	e8 0f de ff ff       	call   80104200 <pipealloc>
801063f1:	83 c4 10             	add    $0x10,%esp
801063f4:	85 c0                	test   %eax,%eax
801063f6:	78 37                	js     8010642f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801063f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801063fb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801063fd:	e8 6e e3 ff ff       	call   80104770 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80106408:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010640c:	85 f6                	test   %esi,%esi
8010640e:	74 30                	je     80106440 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106410:	83 c3 01             	add    $0x1,%ebx
80106413:	83 fb 10             	cmp    $0x10,%ebx
80106416:	75 f0                	jne    80106408 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106418:	83 ec 0c             	sub    $0xc,%esp
8010641b:	ff 75 e0             	pushl  -0x20(%ebp)
8010641e:	e8 9d aa ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80106423:	58                   	pop    %eax
80106424:	ff 75 e4             	pushl  -0x1c(%ebp)
80106427:	e8 94 aa ff ff       	call   80100ec0 <fileclose>
    return -1;
8010642c:	83 c4 10             	add    $0x10,%esp
8010642f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106434:	eb 5b                	jmp    80106491 <sys_pipe+0xd1>
80106436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010643d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106440:	8d 73 08             	lea    0x8(%ebx),%esi
80106443:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106447:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010644a:	e8 21 e3 ff ff       	call   80104770 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010644f:	31 d2                	xor    %edx,%edx
80106451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106458:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010645c:	85 c9                	test   %ecx,%ecx
8010645e:	74 20                	je     80106480 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106460:	83 c2 01             	add    $0x1,%edx
80106463:	83 fa 10             	cmp    $0x10,%edx
80106466:	75 f0                	jne    80106458 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106468:	e8 03 e3 ff ff       	call   80104770 <myproc>
8010646d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106474:	00 
80106475:	eb a1                	jmp    80106418 <sys_pipe+0x58>
80106477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010647e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106480:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106484:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106487:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106489:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010648c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010648f:	31 c0                	xor    %eax,%eax
}
80106491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106494:	5b                   	pop    %ebx
80106495:	5e                   	pop    %esi
80106496:	5f                   	pop    %edi
80106497:	5d                   	pop    %ebp
80106498:	c3                   	ret    
80106499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064a0 <sys_swapread>:

int sys_swapread(void)
{
801064a0:	f3 0f 1e fb          	endbr32 
801064a4:	55                   	push   %ebp
801064a5:	89 e5                	mov    %esp,%ebp
801064a7:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
801064aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064ad:	68 00 10 00 00       	push   $0x1000
801064b2:	50                   	push   %eax
801064b3:	6a 00                	push   $0x0
801064b5:	e8 e6 f2 ff ff       	call   801057a0 <argptr>
801064ba:	83 c4 10             	add    $0x10,%esp
801064bd:	85 c0                	test   %eax,%eax
801064bf:	78 2f                	js     801064f0 <sys_swapread+0x50>
801064c1:	83 ec 08             	sub    $0x8,%esp
801064c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064c7:	50                   	push   %eax
801064c8:	6a 01                	push   $0x1
801064ca:	e8 81 f2 ff ff       	call   80105750 <argint>
801064cf:	83 c4 10             	add    $0x10,%esp
801064d2:	85 c0                	test   %eax,%eax
801064d4:	78 1a                	js     801064f0 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
801064d6:	83 ec 08             	sub    $0x8,%esp
801064d9:	ff 75 f4             	pushl  -0xc(%ebp)
801064dc:	ff 75 f0             	pushl  -0x10(%ebp)
801064df:	e8 8c bb ff ff       	call   80102070 <swapread>
	return 0;
801064e4:	83 c4 10             	add    $0x10,%esp
801064e7:	31 c0                	xor    %eax,%eax
}
801064e9:	c9                   	leave  
801064ea:	c3                   	ret    
801064eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064ef:	90                   	nop
801064f0:	c9                   	leave  
		return -1;
801064f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064f6:	c3                   	ret    
801064f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064fe:	66 90                	xchg   %ax,%ax

80106500 <sys_swapwrite>:

int sys_swapwrite(void)
{
80106500:	f3 0f 1e fb          	endbr32 
80106504:	55                   	push   %ebp
80106505:	89 e5                	mov    %esp,%ebp
80106507:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
8010650a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010650d:	68 00 10 00 00       	push   $0x1000
80106512:	50                   	push   %eax
80106513:	6a 00                	push   $0x0
80106515:	e8 86 f2 ff ff       	call   801057a0 <argptr>
8010651a:	83 c4 10             	add    $0x10,%esp
8010651d:	85 c0                	test   %eax,%eax
8010651f:	78 2f                	js     80106550 <sys_swapwrite+0x50>
80106521:	83 ec 08             	sub    $0x8,%esp
80106524:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106527:	50                   	push   %eax
80106528:	6a 01                	push   $0x1
8010652a:	e8 21 f2 ff ff       	call   80105750 <argint>
8010652f:	83 c4 10             	add    $0x10,%esp
80106532:	85 c0                	test   %eax,%eax
80106534:	78 1a                	js     80106550 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
80106536:	83 ec 08             	sub    $0x8,%esp
80106539:	ff 75 f4             	pushl  -0xc(%ebp)
8010653c:	ff 75 f0             	pushl  -0x10(%ebp)
8010653f:	e8 bc bb ff ff       	call   80102100 <swapwrite>
	return 0;
80106544:	83 c4 10             	add    $0x10,%esp
80106547:	31 c0                	xor    %eax,%eax
}
80106549:	c9                   	leave  
8010654a:	c3                   	ret    
8010654b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010654f:	90                   	nop
80106550:	c9                   	leave  
		return -1;
80106551:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106556:	c3                   	ret    
80106557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010655e:	66 90                	xchg   %ax,%ax

80106560 <sys_swapstat>:

int sys_swapstat(void)
{
80106560:	f3 0f 1e fb          	endbr32 
80106564:	55                   	push   %ebp
80106565:	89 e5                	mov    %esp,%ebp
80106567:	53                   	push   %ebx
	int* nr_read;
	int* nr_write;
	
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80106568:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
8010656b:	83 ec 18             	sub    $0x18,%esp
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
8010656e:	6a 04                	push   $0x4
80106570:	50                   	push   %eax
80106571:	6a 00                	push   $0x0
80106573:	e8 28 f2 ff ff       	call   801057a0 <argptr>
80106578:	83 c4 10             	add    $0x10,%esp
8010657b:	85 c0                	test   %eax,%eax
8010657d:	75 39                	jne    801065b8 <sys_swapstat+0x58>
			argptr(1, (void*)&nr_write, sizeof(*nr_write)) < 0)
8010657f:	83 ec 04             	sub    $0x4,%esp
80106582:	89 c3                	mov    %eax,%ebx
80106584:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106587:	6a 04                	push   $0x4
80106589:	50                   	push   %eax
8010658a:	6a 01                	push   $0x1
8010658c:	e8 0f f2 ff ff       	call   801057a0 <argptr>
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80106591:	83 c4 10             	add    $0x10,%esp
80106594:	85 c0                	test   %eax,%eax
80106596:	78 20                	js     801065b8 <sys_swapstat+0x58>
		return -1;

	*nr_read = nr_sectors_read;
80106598:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010659b:	8b 15 c0 19 11 80    	mov    0x801119c0,%edx
801065a1:	89 10                	mov    %edx,(%eax)
	*nr_write = nr_sectors_write;
801065a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a6:	8b 15 e0 19 11 80    	mov    0x801119e0,%edx
801065ac:	89 10                	mov    %edx,(%eax)
	return 0;
}
801065ae:	89 d8                	mov    %ebx,%eax
801065b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065b3:	c9                   	leave  
801065b4:	c3                   	ret    
801065b5:	8d 76 00             	lea    0x0(%esi),%esi
		return -1;
801065b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801065bd:	eb ef                	jmp    801065ae <sys_swapstat+0x4e>
801065bf:	90                   	nop

801065c0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801065c0:	f3 0f 1e fb          	endbr32 
  return fork();
801065c4:	e9 67 e3 ff ff       	jmp    80104930 <fork>
801065c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065d0 <sys_exit>:
}

int
sys_exit(void)
{
801065d0:	f3 0f 1e fb          	endbr32 
801065d4:	55                   	push   %ebp
801065d5:	89 e5                	mov    %esp,%ebp
801065d7:	83 ec 08             	sub    $0x8,%esp
  exit();
801065da:	e8 b1 e5 ff ff       	call   80104b90 <exit>
  return 0;  // not reached
}
801065df:	31 c0                	xor    %eax,%eax
801065e1:	c9                   	leave  
801065e2:	c3                   	ret    
801065e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801065f0 <sys_wait>:

int
sys_wait(void)
{
801065f0:	f3 0f 1e fb          	endbr32 
  return wait();
801065f4:	e9 e7 e7 ff ff       	jmp    80104de0 <wait>
801065f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106600 <sys_kill>:
}

int
sys_kill(void)
{
80106600:	f3 0f 1e fb          	endbr32 
80106604:	55                   	push   %ebp
80106605:	89 e5                	mov    %esp,%ebp
80106607:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010660a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010660d:	50                   	push   %eax
8010660e:	6a 00                	push   $0x0
80106610:	e8 3b f1 ff ff       	call   80105750 <argint>
80106615:	83 c4 10             	add    $0x10,%esp
80106618:	85 c0                	test   %eax,%eax
8010661a:	78 14                	js     80106630 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010661c:	83 ec 0c             	sub    $0xc,%esp
8010661f:	ff 75 f4             	pushl  -0xc(%ebp)
80106622:	e8 19 e9 ff ff       	call   80104f40 <kill>
80106627:	83 c4 10             	add    $0x10,%esp
}
8010662a:	c9                   	leave  
8010662b:	c3                   	ret    
8010662c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106630:	c9                   	leave  
    return -1;
80106631:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106636:	c3                   	ret    
80106637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010663e:	66 90                	xchg   %ax,%ax

80106640 <sys_getpid>:

int
sys_getpid(void)
{
80106640:	f3 0f 1e fb          	endbr32 
80106644:	55                   	push   %ebp
80106645:	89 e5                	mov    %esp,%ebp
80106647:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010664a:	e8 21 e1 ff ff       	call   80104770 <myproc>
8010664f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106652:	c9                   	leave  
80106653:	c3                   	ret    
80106654:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010665b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010665f:	90                   	nop

80106660 <sys_sbrk>:

int
sys_sbrk(void)
{
80106660:	f3 0f 1e fb          	endbr32 
80106664:	55                   	push   %ebp
80106665:	89 e5                	mov    %esp,%ebp
80106667:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106668:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010666b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010666e:	50                   	push   %eax
8010666f:	6a 00                	push   $0x0
80106671:	e8 da f0 ff ff       	call   80105750 <argint>
80106676:	83 c4 10             	add    $0x10,%esp
80106679:	85 c0                	test   %eax,%eax
8010667b:	78 23                	js     801066a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010667d:	e8 ee e0 ff ff       	call   80104770 <myproc>
  if(growproc(n) < 0)
80106682:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106685:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106687:	ff 75 f4             	pushl  -0xc(%ebp)
8010668a:	e8 21 e2 ff ff       	call   801048b0 <growproc>
8010668f:	83 c4 10             	add    $0x10,%esp
80106692:	85 c0                	test   %eax,%eax
80106694:	78 0a                	js     801066a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106696:	89 d8                	mov    %ebx,%eax
80106698:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010669b:	c9                   	leave  
8010669c:	c3                   	ret    
8010669d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801066a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801066a5:	eb ef                	jmp    80106696 <sys_sbrk+0x36>
801066a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ae:	66 90                	xchg   %ax,%ax

801066b0 <sys_sleep>:

int
sys_sleep(void)
{
801066b0:	f3 0f 1e fb          	endbr32 
801066b4:	55                   	push   %ebp
801066b5:	89 e5                	mov    %esp,%ebp
801066b7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801066b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801066bb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801066be:	50                   	push   %eax
801066bf:	6a 00                	push   $0x0
801066c1:	e8 8a f0 ff ff       	call   80105750 <argint>
801066c6:	83 c4 10             	add    $0x10,%esp
801066c9:	85 c0                	test   %eax,%eax
801066cb:	0f 88 86 00 00 00    	js     80106757 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801066d1:	83 ec 0c             	sub    $0xc,%esp
801066d4:	68 a0 bd 11 80       	push   $0x8011bda0
801066d9:	e8 82 ec ff ff       	call   80105360 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801066de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801066e1:	8b 1d e0 c5 11 80    	mov    0x8011c5e0,%ebx
  while(ticks - ticks0 < n){
801066e7:	83 c4 10             	add    $0x10,%esp
801066ea:	85 d2                	test   %edx,%edx
801066ec:	75 23                	jne    80106711 <sys_sleep+0x61>
801066ee:	eb 50                	jmp    80106740 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801066f0:	83 ec 08             	sub    $0x8,%esp
801066f3:	68 a0 bd 11 80       	push   $0x8011bda0
801066f8:	68 e0 c5 11 80       	push   $0x8011c5e0
801066fd:	e8 1e e6 ff ff       	call   80104d20 <sleep>
  while(ticks - ticks0 < n){
80106702:	a1 e0 c5 11 80       	mov    0x8011c5e0,%eax
80106707:	83 c4 10             	add    $0x10,%esp
8010670a:	29 d8                	sub    %ebx,%eax
8010670c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010670f:	73 2f                	jae    80106740 <sys_sleep+0x90>
    if(myproc()->killed){
80106711:	e8 5a e0 ff ff       	call   80104770 <myproc>
80106716:	8b 40 24             	mov    0x24(%eax),%eax
80106719:	85 c0                	test   %eax,%eax
8010671b:	74 d3                	je     801066f0 <sys_sleep+0x40>
      release(&tickslock);
8010671d:	83 ec 0c             	sub    $0xc,%esp
80106720:	68 a0 bd 11 80       	push   $0x8011bda0
80106725:	e8 f6 ec ff ff       	call   80105420 <release>
  }
  release(&tickslock);
  return 0;
}
8010672a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010672d:	83 c4 10             	add    $0x10,%esp
80106730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106735:	c9                   	leave  
80106736:	c3                   	ret    
80106737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010673e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106740:	83 ec 0c             	sub    $0xc,%esp
80106743:	68 a0 bd 11 80       	push   $0x8011bda0
80106748:	e8 d3 ec ff ff       	call   80105420 <release>
  return 0;
8010674d:	83 c4 10             	add    $0x10,%esp
80106750:	31 c0                	xor    %eax,%eax
}
80106752:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106755:	c9                   	leave  
80106756:	c3                   	ret    
    return -1;
80106757:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010675c:	eb f4                	jmp    80106752 <sys_sleep+0xa2>
8010675e:	66 90                	xchg   %ax,%ax

80106760 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106760:	f3 0f 1e fb          	endbr32 
80106764:	55                   	push   %ebp
80106765:	89 e5                	mov    %esp,%ebp
80106767:	53                   	push   %ebx
80106768:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010676b:	68 a0 bd 11 80       	push   $0x8011bda0
80106770:	e8 eb eb ff ff       	call   80105360 <acquire>
  xticks = ticks;
80106775:	8b 1d e0 c5 11 80    	mov    0x8011c5e0,%ebx
  release(&tickslock);
8010677b:	c7 04 24 a0 bd 11 80 	movl   $0x8011bda0,(%esp)
80106782:	e8 99 ec ff ff       	call   80105420 <release>
  return xticks;
}
80106787:	89 d8                	mov    %ebx,%eax
80106789:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010678c:	c9                   	leave  
8010678d:	c3                   	ret    

8010678e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010678e:	1e                   	push   %ds
  pushl %es
8010678f:	06                   	push   %es
  pushl %fs
80106790:	0f a0                	push   %fs
  pushl %gs
80106792:	0f a8                	push   %gs
  pushal
80106794:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106795:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106799:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010679b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010679d:	54                   	push   %esp
  call trap
8010679e:	e8 cd 00 00 00       	call   80106870 <trap>
  addl $4, %esp
801067a3:	83 c4 04             	add    $0x4,%esp

801067a6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801067a6:	61                   	popa   
  popl %gs
801067a7:	0f a9                	pop    %gs
  popl %fs
801067a9:	0f a1                	pop    %fs
  popl %es
801067ab:	07                   	pop    %es
  popl %ds
801067ac:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801067ad:	83 c4 08             	add    $0x8,%esp
  iret
801067b0:	cf                   	iret   
801067b1:	66 90                	xchg   %ax,%ax
801067b3:	66 90                	xchg   %ax,%ax
801067b5:	66 90                	xchg   %ax,%ax
801067b7:	66 90                	xchg   %ax,%ax
801067b9:	66 90                	xchg   %ax,%ax
801067bb:	66 90                	xchg   %ax,%ax
801067bd:	66 90                	xchg   %ax,%ax
801067bf:	90                   	nop

801067c0 <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
801067c0:	f3 0f 1e fb          	endbr32 
801067c4:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
801067c5:	31 c0                	xor    %eax,%eax
{
801067c7:	89 e5                	mov    %esp,%ebp
801067c9:	83 ec 08             	sub    $0x8,%esp
801067cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
801067d0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801067d7:	c7 04 c5 e2 bd 11 80 	movl   $0x8e000008,-0x7fee421e(,%eax,8)
801067de:	08 00 00 8e 
801067e2:	66 89 14 c5 e0 bd 11 	mov    %dx,-0x7fee4220(,%eax,8)
801067e9:	80 
801067ea:	c1 ea 10             	shr    $0x10,%edx
801067ed:	66 89 14 c5 e6 bd 11 	mov    %dx,-0x7fee421a(,%eax,8)
801067f4:	80 
  for (i = 0; i < 256; i++)
801067f5:	83 c0 01             	add    $0x1,%eax
801067f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801067fd:	75 d1                	jne    801067d0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801067ff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106802:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106807:	c7 05 e2 bf 11 80 08 	movl   $0xef000008,0x8011bfe2
8010680e:	00 00 ef 
  initlock(&tickslock, "time");
80106811:	68 05 8c 10 80       	push   $0x80108c05
80106816:	68 a0 bd 11 80       	push   $0x8011bda0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010681b:	66 a3 e0 bf 11 80    	mov    %ax,0x8011bfe0
80106821:	c1 e8 10             	shr    $0x10,%eax
80106824:	66 a3 e6 bf 11 80    	mov    %ax,0x8011bfe6
  initlock(&tickslock, "time");
8010682a:	e8 b1 e9 ff ff       	call   801051e0 <initlock>
}
8010682f:	83 c4 10             	add    $0x10,%esp
80106832:	c9                   	leave  
80106833:	c3                   	ret    
80106834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010683b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010683f:	90                   	nop

80106840 <idtinit>:

void idtinit(void)
{
80106840:	f3 0f 1e fb          	endbr32 
80106844:	55                   	push   %ebp
  pd[0] = size-1;
80106845:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010684a:	89 e5                	mov    %esp,%ebp
8010684c:	83 ec 10             	sub    $0x10,%esp
8010684f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106853:	b8 e0 bd 11 80       	mov    $0x8011bde0,%eax
80106858:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010685c:	c1 e8 10             	shr    $0x10,%eax
8010685f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106863:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106866:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106869:	c9                   	leave  
8010686a:	c3                   	ret    
8010686b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010686f:	90                   	nop

80106870 <trap>:

void trap(struct trapframe *tf)
{
80106870:	f3 0f 1e fb          	endbr32 
80106874:	55                   	push   %ebp
80106875:	89 e5                	mov    %esp,%ebp
80106877:	57                   	push   %edi
80106878:	56                   	push   %esi
80106879:	53                   	push   %ebx
8010687a:	83 ec 1c             	sub    $0x1c,%esp
8010687d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (tf->trapno == T_SYSCALL)
80106880:	8b 43 30             	mov    0x30(%ebx),%eax
80106883:	83 f8 40             	cmp    $0x40,%eax
80106886:	0f 84 ec 01 00 00    	je     80106a78 <trap+0x208>
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
8010688c:	83 e8 0e             	sub    $0xe,%eax
8010688f:	83 f8 31             	cmp    $0x31,%eax
80106892:	77 08                	ja     8010689c <trap+0x2c>
80106894:	3e ff 24 85 ac 8c 10 	notrack jmp *-0x7fef7354(,%eax,4)
8010689b:	80 
  case T_PGFLT:
    page_fault_handler(myproc()->pgdir, rcr2());
    break;

  default:
    if (myproc() == 0 || (tf->cs & 3) == 0)
8010689c:	e8 cf de ff ff       	call   80104770 <myproc>
801068a1:	85 c0                	test   %eax,%eax
801068a3:	0f 84 1e 02 00 00    	je     80106ac7 <trap+0x257>
801068a9:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801068ad:	0f 84 14 02 00 00    	je     80106ac7 <trap+0x257>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801068b3:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068b6:	8b 53 38             	mov    0x38(%ebx),%edx
801068b9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801068bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
801068bf:	e8 8c de ff ff       	call   80104750 <cpuid>
801068c4:	8b 73 30             	mov    0x30(%ebx),%esi
801068c7:	89 c7                	mov    %eax,%edi
801068c9:	8b 43 34             	mov    0x34(%ebx),%eax
801068cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801068cf:	e8 9c de ff ff       	call   80104770 <myproc>
801068d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801068d7:	e8 94 de ff ff       	call   80104770 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068dc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801068df:	8b 55 dc             	mov    -0x24(%ebp),%edx
801068e2:	51                   	push   %ecx
801068e3:	52                   	push   %edx
801068e4:	57                   	push   %edi
801068e5:	ff 75 e4             	pushl  -0x1c(%ebp)
801068e8:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801068e9:	8b 75 e0             	mov    -0x20(%ebp),%esi
801068ec:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068ef:	56                   	push   %esi
801068f0:	ff 70 10             	pushl  0x10(%eax)
801068f3:	68 68 8c 10 80       	push   $0x80108c68
801068f8:	e8 b3 9d ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801068fd:	83 c4 20             	add    $0x20,%esp
80106900:	e8 6b de ff ff       	call   80104770 <myproc>
80106905:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010690c:	e8 5f de ff ff       	call   80104770 <myproc>
80106911:	85 c0                	test   %eax,%eax
80106913:	74 1d                	je     80106932 <trap+0xc2>
80106915:	e8 56 de ff ff       	call   80104770 <myproc>
8010691a:	8b 50 24             	mov    0x24(%eax),%edx
8010691d:	85 d2                	test   %edx,%edx
8010691f:	74 11                	je     80106932 <trap+0xc2>
80106921:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106925:	83 e0 03             	and    $0x3,%eax
80106928:	66 83 f8 03          	cmp    $0x3,%ax
8010692c:	0f 84 7e 01 00 00    	je     80106ab0 <trap+0x240>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING &&
80106932:	e8 39 de ff ff       	call   80104770 <myproc>
80106937:	85 c0                	test   %eax,%eax
80106939:	74 0f                	je     8010694a <trap+0xda>
8010693b:	e8 30 de ff ff       	call   80104770 <myproc>
80106940:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106944:	0f 84 16 01 00 00    	je     80106a60 <trap+0x1f0>
      tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010694a:	e8 21 de ff ff       	call   80104770 <myproc>
8010694f:	85 c0                	test   %eax,%eax
80106951:	74 1d                	je     80106970 <trap+0x100>
80106953:	e8 18 de ff ff       	call   80104770 <myproc>
80106958:	8b 40 24             	mov    0x24(%eax),%eax
8010695b:	85 c0                	test   %eax,%eax
8010695d:	74 11                	je     80106970 <trap+0x100>
8010695f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106963:	83 e0 03             	and    $0x3,%eax
80106966:	66 83 f8 03          	cmp    $0x3,%ax
8010696a:	0f 84 31 01 00 00    	je     80106aa1 <trap+0x231>
    exit();
}
80106970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106973:	5b                   	pop    %ebx
80106974:	5e                   	pop    %esi
80106975:	5f                   	pop    %edi
80106976:	5d                   	pop    %ebp
80106977:	c3                   	ret    
    ideintr();
80106978:	e8 73 b9 ff ff       	call   801022f0 <ideintr>
    lapiceoi();
8010697d:	e8 4e cd ff ff       	call   801036d0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106982:	e8 e9 dd ff ff       	call   80104770 <myproc>
80106987:	85 c0                	test   %eax,%eax
80106989:	75 8a                	jne    80106915 <trap+0xa5>
8010698b:	eb a5                	jmp    80106932 <trap+0xc2>
8010698d:	0f 20 d6             	mov    %cr2,%esi
    page_fault_handler(myproc()->pgdir, rcr2());
80106990:	e8 db dd ff ff       	call   80104770 <myproc>
80106995:	83 ec 08             	sub    $0x8,%esp
80106998:	56                   	push   %esi
80106999:	ff 70 04             	pushl  0x4(%eax)
8010699c:	e8 1f ca ff ff       	call   801033c0 <page_fault_handler>
    break;
801069a1:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801069a4:	e8 c7 dd ff ff       	call   80104770 <myproc>
801069a9:	85 c0                	test   %eax,%eax
801069ab:	0f 85 64 ff ff ff    	jne    80106915 <trap+0xa5>
801069b1:	e9 7c ff ff ff       	jmp    80106932 <trap+0xc2>
    if (cpuid() == 0)
801069b6:	e8 95 dd ff ff       	call   80104750 <cpuid>
801069bb:	85 c0                	test   %eax,%eax
801069bd:	75 be                	jne    8010697d <trap+0x10d>
      acquire(&tickslock);
801069bf:	83 ec 0c             	sub    $0xc,%esp
801069c2:	68 a0 bd 11 80       	push   $0x8011bda0
801069c7:	e8 94 e9 ff ff       	call   80105360 <acquire>
      wakeup(&ticks);
801069cc:	c7 04 24 e0 c5 11 80 	movl   $0x8011c5e0,(%esp)
      ticks++;
801069d3:	83 05 e0 c5 11 80 01 	addl   $0x1,0x8011c5e0
      wakeup(&ticks);
801069da:	e8 01 e5 ff ff       	call   80104ee0 <wakeup>
      release(&tickslock);
801069df:	c7 04 24 a0 bd 11 80 	movl   $0x8011bda0,(%esp)
801069e6:	e8 35 ea ff ff       	call   80105420 <release>
801069eb:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801069ee:	eb 8d                	jmp    8010697d <trap+0x10d>
    kbdintr();
801069f0:	e8 9b cb ff ff       	call   80103590 <kbdintr>
    lapiceoi();
801069f5:	e8 d6 cc ff ff       	call   801036d0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801069fa:	e8 71 dd ff ff       	call   80104770 <myproc>
801069ff:	85 c0                	test   %eax,%eax
80106a01:	0f 85 0e ff ff ff    	jne    80106915 <trap+0xa5>
80106a07:	e9 26 ff ff ff       	jmp    80106932 <trap+0xc2>
    uartintr();
80106a0c:	e8 5f 02 00 00       	call   80106c70 <uartintr>
    lapiceoi();
80106a11:	e8 ba cc ff ff       	call   801036d0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106a16:	e8 55 dd ff ff       	call   80104770 <myproc>
80106a1b:	85 c0                	test   %eax,%eax
80106a1d:	0f 85 f2 fe ff ff    	jne    80106915 <trap+0xa5>
80106a23:	e9 0a ff ff ff       	jmp    80106932 <trap+0xc2>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a28:	8b 7b 38             	mov    0x38(%ebx),%edi
80106a2b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106a2f:	e8 1c dd ff ff       	call   80104750 <cpuid>
80106a34:	57                   	push   %edi
80106a35:	56                   	push   %esi
80106a36:	50                   	push   %eax
80106a37:	68 10 8c 10 80       	push   $0x80108c10
80106a3c:	e8 6f 9c ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106a41:	e8 8a cc ff ff       	call   801036d0 <lapiceoi>
    break;
80106a46:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106a49:	e8 22 dd ff ff       	call   80104770 <myproc>
80106a4e:	85 c0                	test   %eax,%eax
80106a50:	0f 85 bf fe ff ff    	jne    80106915 <trap+0xa5>
80106a56:	e9 d7 fe ff ff       	jmp    80106932 <trap+0xc2>
80106a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a5f:	90                   	nop
  if (myproc() && myproc()->state == RUNNING &&
80106a60:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106a64:	0f 85 e0 fe ff ff    	jne    8010694a <trap+0xda>
    yield();
80106a6a:	e8 61 e2 ff ff       	call   80104cd0 <yield>
80106a6f:	e9 d6 fe ff ff       	jmp    8010694a <trap+0xda>
80106a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
80106a78:	e8 f3 dc ff ff       	call   80104770 <myproc>
80106a7d:	8b 70 24             	mov    0x24(%eax),%esi
80106a80:	85 f6                	test   %esi,%esi
80106a82:	75 3c                	jne    80106ac0 <trap+0x250>
    myproc()->tf = tf;
80106a84:	e8 e7 dc ff ff       	call   80104770 <myproc>
80106a89:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106a8c:	e8 af ed ff ff       	call   80105840 <syscall>
    if (myproc()->killed)
80106a91:	e8 da dc ff ff       	call   80104770 <myproc>
80106a96:	8b 48 24             	mov    0x24(%eax),%ecx
80106a99:	85 c9                	test   %ecx,%ecx
80106a9b:	0f 84 cf fe ff ff    	je     80106970 <trap+0x100>
}
80106aa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106aa4:	5b                   	pop    %ebx
80106aa5:	5e                   	pop    %esi
80106aa6:	5f                   	pop    %edi
80106aa7:	5d                   	pop    %ebp
      exit();
80106aa8:	e9 e3 e0 ff ff       	jmp    80104b90 <exit>
80106aad:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106ab0:	e8 db e0 ff ff       	call   80104b90 <exit>
80106ab5:	e9 78 fe ff ff       	jmp    80106932 <trap+0xc2>
80106aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106ac0:	e8 cb e0 ff ff       	call   80104b90 <exit>
80106ac5:	eb bd                	jmp    80106a84 <trap+0x214>
80106ac7:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106aca:	8b 73 38             	mov    0x38(%ebx),%esi
80106acd:	e8 7e dc ff ff       	call   80104750 <cpuid>
80106ad2:	83 ec 0c             	sub    $0xc,%esp
80106ad5:	57                   	push   %edi
80106ad6:	56                   	push   %esi
80106ad7:	50                   	push   %eax
80106ad8:	ff 73 30             	pushl  0x30(%ebx)
80106adb:	68 34 8c 10 80       	push   $0x80108c34
80106ae0:	e8 cb 9b ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106ae5:	83 c4 14             	add    $0x14,%esp
80106ae8:	68 0a 8c 10 80       	push   $0x80108c0a
80106aed:	e8 9e 98 ff ff       	call   80100390 <panic>
80106af2:	66 90                	xchg   %ax,%ax
80106af4:	66 90                	xchg   %ax,%ax
80106af6:	66 90                	xchg   %ax,%ax
80106af8:	66 90                	xchg   %ax,%ax
80106afa:	66 90                	xchg   %ax,%ax
80106afc:	66 90                	xchg   %ax,%ax
80106afe:	66 90                	xchg   %ax,%ax

80106b00 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106b00:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106b04:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106b09:	85 c0                	test   %eax,%eax
80106b0b:	74 1b                	je     80106b28 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b0d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106b12:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106b13:	a8 01                	test   $0x1,%al
80106b15:	74 11                	je     80106b28 <uartgetc+0x28>
80106b17:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b1c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106b1d:	0f b6 c0             	movzbl %al,%eax
80106b20:	c3                   	ret    
80106b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b2d:	c3                   	ret    
80106b2e:	66 90                	xchg   %ax,%ax

80106b30 <uartputc.part.0>:
uartputc(int c)
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	89 c7                	mov    %eax,%edi
80106b36:	56                   	push   %esi
80106b37:	be fd 03 00 00       	mov    $0x3fd,%esi
80106b3c:	53                   	push   %ebx
80106b3d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106b42:	83 ec 0c             	sub    $0xc,%esp
80106b45:	eb 1b                	jmp    80106b62 <uartputc.part.0+0x32>
80106b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b4e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106b50:	83 ec 0c             	sub    $0xc,%esp
80106b53:	6a 0a                	push   $0xa
80106b55:	e8 96 cb ff ff       	call   801036f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b5a:	83 c4 10             	add    $0x10,%esp
80106b5d:	83 eb 01             	sub    $0x1,%ebx
80106b60:	74 07                	je     80106b69 <uartputc.part.0+0x39>
80106b62:	89 f2                	mov    %esi,%edx
80106b64:	ec                   	in     (%dx),%al
80106b65:	a8 20                	test   $0x20,%al
80106b67:	74 e7                	je     80106b50 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b69:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b6e:	89 f8                	mov    %edi,%eax
80106b70:	ee                   	out    %al,(%dx)
}
80106b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b74:	5b                   	pop    %ebx
80106b75:	5e                   	pop    %esi
80106b76:	5f                   	pop    %edi
80106b77:	5d                   	pop    %ebp
80106b78:	c3                   	ret    
80106b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b80 <uartinit>:
{
80106b80:	f3 0f 1e fb          	endbr32 
80106b84:	55                   	push   %ebp
80106b85:	31 c9                	xor    %ecx,%ecx
80106b87:	89 c8                	mov    %ecx,%eax
80106b89:	89 e5                	mov    %esp,%ebp
80106b8b:	57                   	push   %edi
80106b8c:	56                   	push   %esi
80106b8d:	53                   	push   %ebx
80106b8e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106b93:	89 da                	mov    %ebx,%edx
80106b95:	83 ec 0c             	sub    $0xc,%esp
80106b98:	ee                   	out    %al,(%dx)
80106b99:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106b9e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106ba3:	89 fa                	mov    %edi,%edx
80106ba5:	ee                   	out    %al,(%dx)
80106ba6:	b8 0c 00 00 00       	mov    $0xc,%eax
80106bab:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bb0:	ee                   	out    %al,(%dx)
80106bb1:	be f9 03 00 00       	mov    $0x3f9,%esi
80106bb6:	89 c8                	mov    %ecx,%eax
80106bb8:	89 f2                	mov    %esi,%edx
80106bba:	ee                   	out    %al,(%dx)
80106bbb:	b8 03 00 00 00       	mov    $0x3,%eax
80106bc0:	89 fa                	mov    %edi,%edx
80106bc2:	ee                   	out    %al,(%dx)
80106bc3:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106bc8:	89 c8                	mov    %ecx,%eax
80106bca:	ee                   	out    %al,(%dx)
80106bcb:	b8 01 00 00 00       	mov    $0x1,%eax
80106bd0:	89 f2                	mov    %esi,%edx
80106bd2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106bd3:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106bd8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106bd9:	3c ff                	cmp    $0xff,%al
80106bdb:	74 52                	je     80106c2f <uartinit+0xaf>
  uart = 1;
80106bdd:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106be4:	00 00 00 
80106be7:	89 da                	mov    %ebx,%edx
80106be9:	ec                   	in     (%dx),%al
80106bea:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bef:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106bf0:	83 ec 08             	sub    $0x8,%esp
80106bf3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106bf8:	bb 74 8d 10 80       	mov    $0x80108d74,%ebx
  ioapicenable(IRQ_COM1, 0);
80106bfd:	6a 00                	push   $0x0
80106bff:	6a 04                	push   $0x4
80106c01:	e8 3a b9 ff ff       	call   80102540 <ioapicenable>
80106c06:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106c09:	b8 78 00 00 00       	mov    $0x78,%eax
80106c0e:	eb 04                	jmp    80106c14 <uartinit+0x94>
80106c10:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106c14:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106c1a:	85 d2                	test   %edx,%edx
80106c1c:	74 08                	je     80106c26 <uartinit+0xa6>
    uartputc(*p);
80106c1e:	0f be c0             	movsbl %al,%eax
80106c21:	e8 0a ff ff ff       	call   80106b30 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106c26:	89 f0                	mov    %esi,%eax
80106c28:	83 c3 01             	add    $0x1,%ebx
80106c2b:	84 c0                	test   %al,%al
80106c2d:	75 e1                	jne    80106c10 <uartinit+0x90>
}
80106c2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c32:	5b                   	pop    %ebx
80106c33:	5e                   	pop    %esi
80106c34:	5f                   	pop    %edi
80106c35:	5d                   	pop    %ebp
80106c36:	c3                   	ret    
80106c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c3e:	66 90                	xchg   %ax,%ax

80106c40 <uartputc>:
{
80106c40:	f3 0f 1e fb          	endbr32 
80106c44:	55                   	push   %ebp
  if(!uart)
80106c45:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106c4b:	89 e5                	mov    %esp,%ebp
80106c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106c50:	85 d2                	test   %edx,%edx
80106c52:	74 0c                	je     80106c60 <uartputc+0x20>
}
80106c54:	5d                   	pop    %ebp
80106c55:	e9 d6 fe ff ff       	jmp    80106b30 <uartputc.part.0>
80106c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c60:	5d                   	pop    %ebp
80106c61:	c3                   	ret    
80106c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c70 <uartintr>:

void
uartintr(void)
{
80106c70:	f3 0f 1e fb          	endbr32 
80106c74:	55                   	push   %ebp
80106c75:	89 e5                	mov    %esp,%ebp
80106c77:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106c7a:	68 00 6b 10 80       	push   $0x80106b00
80106c7f:	e8 dc 9b ff ff       	call   80100860 <consoleintr>
}
80106c84:	83 c4 10             	add    $0x10,%esp
80106c87:	c9                   	leave  
80106c88:	c3                   	ret    

80106c89 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106c89:	6a 00                	push   $0x0
  pushl $0
80106c8b:	6a 00                	push   $0x0
  jmp alltraps
80106c8d:	e9 fc fa ff ff       	jmp    8010678e <alltraps>

80106c92 <vector1>:
.globl vector1
vector1:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $1
80106c94:	6a 01                	push   $0x1
  jmp alltraps
80106c96:	e9 f3 fa ff ff       	jmp    8010678e <alltraps>

80106c9b <vector2>:
.globl vector2
vector2:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $2
80106c9d:	6a 02                	push   $0x2
  jmp alltraps
80106c9f:	e9 ea fa ff ff       	jmp    8010678e <alltraps>

80106ca4 <vector3>:
.globl vector3
vector3:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $3
80106ca6:	6a 03                	push   $0x3
  jmp alltraps
80106ca8:	e9 e1 fa ff ff       	jmp    8010678e <alltraps>

80106cad <vector4>:
.globl vector4
vector4:
  pushl $0
80106cad:	6a 00                	push   $0x0
  pushl $4
80106caf:	6a 04                	push   $0x4
  jmp alltraps
80106cb1:	e9 d8 fa ff ff       	jmp    8010678e <alltraps>

80106cb6 <vector5>:
.globl vector5
vector5:
  pushl $0
80106cb6:	6a 00                	push   $0x0
  pushl $5
80106cb8:	6a 05                	push   $0x5
  jmp alltraps
80106cba:	e9 cf fa ff ff       	jmp    8010678e <alltraps>

80106cbf <vector6>:
.globl vector6
vector6:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $6
80106cc1:	6a 06                	push   $0x6
  jmp alltraps
80106cc3:	e9 c6 fa ff ff       	jmp    8010678e <alltraps>

80106cc8 <vector7>:
.globl vector7
vector7:
  pushl $0
80106cc8:	6a 00                	push   $0x0
  pushl $7
80106cca:	6a 07                	push   $0x7
  jmp alltraps
80106ccc:	e9 bd fa ff ff       	jmp    8010678e <alltraps>

80106cd1 <vector8>:
.globl vector8
vector8:
  pushl $8
80106cd1:	6a 08                	push   $0x8
  jmp alltraps
80106cd3:	e9 b6 fa ff ff       	jmp    8010678e <alltraps>

80106cd8 <vector9>:
.globl vector9
vector9:
  pushl $0
80106cd8:	6a 00                	push   $0x0
  pushl $9
80106cda:	6a 09                	push   $0x9
  jmp alltraps
80106cdc:	e9 ad fa ff ff       	jmp    8010678e <alltraps>

80106ce1 <vector10>:
.globl vector10
vector10:
  pushl $10
80106ce1:	6a 0a                	push   $0xa
  jmp alltraps
80106ce3:	e9 a6 fa ff ff       	jmp    8010678e <alltraps>

80106ce8 <vector11>:
.globl vector11
vector11:
  pushl $11
80106ce8:	6a 0b                	push   $0xb
  jmp alltraps
80106cea:	e9 9f fa ff ff       	jmp    8010678e <alltraps>

80106cef <vector12>:
.globl vector12
vector12:
  pushl $12
80106cef:	6a 0c                	push   $0xc
  jmp alltraps
80106cf1:	e9 98 fa ff ff       	jmp    8010678e <alltraps>

80106cf6 <vector13>:
.globl vector13
vector13:
  pushl $13
80106cf6:	6a 0d                	push   $0xd
  jmp alltraps
80106cf8:	e9 91 fa ff ff       	jmp    8010678e <alltraps>

80106cfd <vector14>:
.globl vector14
vector14:
  pushl $14
80106cfd:	6a 0e                	push   $0xe
  jmp alltraps
80106cff:	e9 8a fa ff ff       	jmp    8010678e <alltraps>

80106d04 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d04:	6a 00                	push   $0x0
  pushl $15
80106d06:	6a 0f                	push   $0xf
  jmp alltraps
80106d08:	e9 81 fa ff ff       	jmp    8010678e <alltraps>

80106d0d <vector16>:
.globl vector16
vector16:
  pushl $0
80106d0d:	6a 00                	push   $0x0
  pushl $16
80106d0f:	6a 10                	push   $0x10
  jmp alltraps
80106d11:	e9 78 fa ff ff       	jmp    8010678e <alltraps>

80106d16 <vector17>:
.globl vector17
vector17:
  pushl $17
80106d16:	6a 11                	push   $0x11
  jmp alltraps
80106d18:	e9 71 fa ff ff       	jmp    8010678e <alltraps>

80106d1d <vector18>:
.globl vector18
vector18:
  pushl $0
80106d1d:	6a 00                	push   $0x0
  pushl $18
80106d1f:	6a 12                	push   $0x12
  jmp alltraps
80106d21:	e9 68 fa ff ff       	jmp    8010678e <alltraps>

80106d26 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d26:	6a 00                	push   $0x0
  pushl $19
80106d28:	6a 13                	push   $0x13
  jmp alltraps
80106d2a:	e9 5f fa ff ff       	jmp    8010678e <alltraps>

80106d2f <vector20>:
.globl vector20
vector20:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $20
80106d31:	6a 14                	push   $0x14
  jmp alltraps
80106d33:	e9 56 fa ff ff       	jmp    8010678e <alltraps>

80106d38 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d38:	6a 00                	push   $0x0
  pushl $21
80106d3a:	6a 15                	push   $0x15
  jmp alltraps
80106d3c:	e9 4d fa ff ff       	jmp    8010678e <alltraps>

80106d41 <vector22>:
.globl vector22
vector22:
  pushl $0
80106d41:	6a 00                	push   $0x0
  pushl $22
80106d43:	6a 16                	push   $0x16
  jmp alltraps
80106d45:	e9 44 fa ff ff       	jmp    8010678e <alltraps>

80106d4a <vector23>:
.globl vector23
vector23:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $23
80106d4c:	6a 17                	push   $0x17
  jmp alltraps
80106d4e:	e9 3b fa ff ff       	jmp    8010678e <alltraps>

80106d53 <vector24>:
.globl vector24
vector24:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $24
80106d55:	6a 18                	push   $0x18
  jmp alltraps
80106d57:	e9 32 fa ff ff       	jmp    8010678e <alltraps>

80106d5c <vector25>:
.globl vector25
vector25:
  pushl $0
80106d5c:	6a 00                	push   $0x0
  pushl $25
80106d5e:	6a 19                	push   $0x19
  jmp alltraps
80106d60:	e9 29 fa ff ff       	jmp    8010678e <alltraps>

80106d65 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d65:	6a 00                	push   $0x0
  pushl $26
80106d67:	6a 1a                	push   $0x1a
  jmp alltraps
80106d69:	e9 20 fa ff ff       	jmp    8010678e <alltraps>

80106d6e <vector27>:
.globl vector27
vector27:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $27
80106d70:	6a 1b                	push   $0x1b
  jmp alltraps
80106d72:	e9 17 fa ff ff       	jmp    8010678e <alltraps>

80106d77 <vector28>:
.globl vector28
vector28:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $28
80106d79:	6a 1c                	push   $0x1c
  jmp alltraps
80106d7b:	e9 0e fa ff ff       	jmp    8010678e <alltraps>

80106d80 <vector29>:
.globl vector29
vector29:
  pushl $0
80106d80:	6a 00                	push   $0x0
  pushl $29
80106d82:	6a 1d                	push   $0x1d
  jmp alltraps
80106d84:	e9 05 fa ff ff       	jmp    8010678e <alltraps>

80106d89 <vector30>:
.globl vector30
vector30:
  pushl $0
80106d89:	6a 00                	push   $0x0
  pushl $30
80106d8b:	6a 1e                	push   $0x1e
  jmp alltraps
80106d8d:	e9 fc f9 ff ff       	jmp    8010678e <alltraps>

80106d92 <vector31>:
.globl vector31
vector31:
  pushl $0
80106d92:	6a 00                	push   $0x0
  pushl $31
80106d94:	6a 1f                	push   $0x1f
  jmp alltraps
80106d96:	e9 f3 f9 ff ff       	jmp    8010678e <alltraps>

80106d9b <vector32>:
.globl vector32
vector32:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $32
80106d9d:	6a 20                	push   $0x20
  jmp alltraps
80106d9f:	e9 ea f9 ff ff       	jmp    8010678e <alltraps>

80106da4 <vector33>:
.globl vector33
vector33:
  pushl $0
80106da4:	6a 00                	push   $0x0
  pushl $33
80106da6:	6a 21                	push   $0x21
  jmp alltraps
80106da8:	e9 e1 f9 ff ff       	jmp    8010678e <alltraps>

80106dad <vector34>:
.globl vector34
vector34:
  pushl $0
80106dad:	6a 00                	push   $0x0
  pushl $34
80106daf:	6a 22                	push   $0x22
  jmp alltraps
80106db1:	e9 d8 f9 ff ff       	jmp    8010678e <alltraps>

80106db6 <vector35>:
.globl vector35
vector35:
  pushl $0
80106db6:	6a 00                	push   $0x0
  pushl $35
80106db8:	6a 23                	push   $0x23
  jmp alltraps
80106dba:	e9 cf f9 ff ff       	jmp    8010678e <alltraps>

80106dbf <vector36>:
.globl vector36
vector36:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $36
80106dc1:	6a 24                	push   $0x24
  jmp alltraps
80106dc3:	e9 c6 f9 ff ff       	jmp    8010678e <alltraps>

80106dc8 <vector37>:
.globl vector37
vector37:
  pushl $0
80106dc8:	6a 00                	push   $0x0
  pushl $37
80106dca:	6a 25                	push   $0x25
  jmp alltraps
80106dcc:	e9 bd f9 ff ff       	jmp    8010678e <alltraps>

80106dd1 <vector38>:
.globl vector38
vector38:
  pushl $0
80106dd1:	6a 00                	push   $0x0
  pushl $38
80106dd3:	6a 26                	push   $0x26
  jmp alltraps
80106dd5:	e9 b4 f9 ff ff       	jmp    8010678e <alltraps>

80106dda <vector39>:
.globl vector39
vector39:
  pushl $0
80106dda:	6a 00                	push   $0x0
  pushl $39
80106ddc:	6a 27                	push   $0x27
  jmp alltraps
80106dde:	e9 ab f9 ff ff       	jmp    8010678e <alltraps>

80106de3 <vector40>:
.globl vector40
vector40:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $40
80106de5:	6a 28                	push   $0x28
  jmp alltraps
80106de7:	e9 a2 f9 ff ff       	jmp    8010678e <alltraps>

80106dec <vector41>:
.globl vector41
vector41:
  pushl $0
80106dec:	6a 00                	push   $0x0
  pushl $41
80106dee:	6a 29                	push   $0x29
  jmp alltraps
80106df0:	e9 99 f9 ff ff       	jmp    8010678e <alltraps>

80106df5 <vector42>:
.globl vector42
vector42:
  pushl $0
80106df5:	6a 00                	push   $0x0
  pushl $42
80106df7:	6a 2a                	push   $0x2a
  jmp alltraps
80106df9:	e9 90 f9 ff ff       	jmp    8010678e <alltraps>

80106dfe <vector43>:
.globl vector43
vector43:
  pushl $0
80106dfe:	6a 00                	push   $0x0
  pushl $43
80106e00:	6a 2b                	push   $0x2b
  jmp alltraps
80106e02:	e9 87 f9 ff ff       	jmp    8010678e <alltraps>

80106e07 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $44
80106e09:	6a 2c                	push   $0x2c
  jmp alltraps
80106e0b:	e9 7e f9 ff ff       	jmp    8010678e <alltraps>

80106e10 <vector45>:
.globl vector45
vector45:
  pushl $0
80106e10:	6a 00                	push   $0x0
  pushl $45
80106e12:	6a 2d                	push   $0x2d
  jmp alltraps
80106e14:	e9 75 f9 ff ff       	jmp    8010678e <alltraps>

80106e19 <vector46>:
.globl vector46
vector46:
  pushl $0
80106e19:	6a 00                	push   $0x0
  pushl $46
80106e1b:	6a 2e                	push   $0x2e
  jmp alltraps
80106e1d:	e9 6c f9 ff ff       	jmp    8010678e <alltraps>

80106e22 <vector47>:
.globl vector47
vector47:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $47
80106e24:	6a 2f                	push   $0x2f
  jmp alltraps
80106e26:	e9 63 f9 ff ff       	jmp    8010678e <alltraps>

80106e2b <vector48>:
.globl vector48
vector48:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $48
80106e2d:	6a 30                	push   $0x30
  jmp alltraps
80106e2f:	e9 5a f9 ff ff       	jmp    8010678e <alltraps>

80106e34 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e34:	6a 00                	push   $0x0
  pushl $49
80106e36:	6a 31                	push   $0x31
  jmp alltraps
80106e38:	e9 51 f9 ff ff       	jmp    8010678e <alltraps>

80106e3d <vector50>:
.globl vector50
vector50:
  pushl $0
80106e3d:	6a 00                	push   $0x0
  pushl $50
80106e3f:	6a 32                	push   $0x32
  jmp alltraps
80106e41:	e9 48 f9 ff ff       	jmp    8010678e <alltraps>

80106e46 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $51
80106e48:	6a 33                	push   $0x33
  jmp alltraps
80106e4a:	e9 3f f9 ff ff       	jmp    8010678e <alltraps>

80106e4f <vector52>:
.globl vector52
vector52:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $52
80106e51:	6a 34                	push   $0x34
  jmp alltraps
80106e53:	e9 36 f9 ff ff       	jmp    8010678e <alltraps>

80106e58 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e58:	6a 00                	push   $0x0
  pushl $53
80106e5a:	6a 35                	push   $0x35
  jmp alltraps
80106e5c:	e9 2d f9 ff ff       	jmp    8010678e <alltraps>

80106e61 <vector54>:
.globl vector54
vector54:
  pushl $0
80106e61:	6a 00                	push   $0x0
  pushl $54
80106e63:	6a 36                	push   $0x36
  jmp alltraps
80106e65:	e9 24 f9 ff ff       	jmp    8010678e <alltraps>

80106e6a <vector55>:
.globl vector55
vector55:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $55
80106e6c:	6a 37                	push   $0x37
  jmp alltraps
80106e6e:	e9 1b f9 ff ff       	jmp    8010678e <alltraps>

80106e73 <vector56>:
.globl vector56
vector56:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $56
80106e75:	6a 38                	push   $0x38
  jmp alltraps
80106e77:	e9 12 f9 ff ff       	jmp    8010678e <alltraps>

80106e7c <vector57>:
.globl vector57
vector57:
  pushl $0
80106e7c:	6a 00                	push   $0x0
  pushl $57
80106e7e:	6a 39                	push   $0x39
  jmp alltraps
80106e80:	e9 09 f9 ff ff       	jmp    8010678e <alltraps>

80106e85 <vector58>:
.globl vector58
vector58:
  pushl $0
80106e85:	6a 00                	push   $0x0
  pushl $58
80106e87:	6a 3a                	push   $0x3a
  jmp alltraps
80106e89:	e9 00 f9 ff ff       	jmp    8010678e <alltraps>

80106e8e <vector59>:
.globl vector59
vector59:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $59
80106e90:	6a 3b                	push   $0x3b
  jmp alltraps
80106e92:	e9 f7 f8 ff ff       	jmp    8010678e <alltraps>

80106e97 <vector60>:
.globl vector60
vector60:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $60
80106e99:	6a 3c                	push   $0x3c
  jmp alltraps
80106e9b:	e9 ee f8 ff ff       	jmp    8010678e <alltraps>

80106ea0 <vector61>:
.globl vector61
vector61:
  pushl $0
80106ea0:	6a 00                	push   $0x0
  pushl $61
80106ea2:	6a 3d                	push   $0x3d
  jmp alltraps
80106ea4:	e9 e5 f8 ff ff       	jmp    8010678e <alltraps>

80106ea9 <vector62>:
.globl vector62
vector62:
  pushl $0
80106ea9:	6a 00                	push   $0x0
  pushl $62
80106eab:	6a 3e                	push   $0x3e
  jmp alltraps
80106ead:	e9 dc f8 ff ff       	jmp    8010678e <alltraps>

80106eb2 <vector63>:
.globl vector63
vector63:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $63
80106eb4:	6a 3f                	push   $0x3f
  jmp alltraps
80106eb6:	e9 d3 f8 ff ff       	jmp    8010678e <alltraps>

80106ebb <vector64>:
.globl vector64
vector64:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $64
80106ebd:	6a 40                	push   $0x40
  jmp alltraps
80106ebf:	e9 ca f8 ff ff       	jmp    8010678e <alltraps>

80106ec4 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ec4:	6a 00                	push   $0x0
  pushl $65
80106ec6:	6a 41                	push   $0x41
  jmp alltraps
80106ec8:	e9 c1 f8 ff ff       	jmp    8010678e <alltraps>

80106ecd <vector66>:
.globl vector66
vector66:
  pushl $0
80106ecd:	6a 00                	push   $0x0
  pushl $66
80106ecf:	6a 42                	push   $0x42
  jmp alltraps
80106ed1:	e9 b8 f8 ff ff       	jmp    8010678e <alltraps>

80106ed6 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $67
80106ed8:	6a 43                	push   $0x43
  jmp alltraps
80106eda:	e9 af f8 ff ff       	jmp    8010678e <alltraps>

80106edf <vector68>:
.globl vector68
vector68:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $68
80106ee1:	6a 44                	push   $0x44
  jmp alltraps
80106ee3:	e9 a6 f8 ff ff       	jmp    8010678e <alltraps>

80106ee8 <vector69>:
.globl vector69
vector69:
  pushl $0
80106ee8:	6a 00                	push   $0x0
  pushl $69
80106eea:	6a 45                	push   $0x45
  jmp alltraps
80106eec:	e9 9d f8 ff ff       	jmp    8010678e <alltraps>

80106ef1 <vector70>:
.globl vector70
vector70:
  pushl $0
80106ef1:	6a 00                	push   $0x0
  pushl $70
80106ef3:	6a 46                	push   $0x46
  jmp alltraps
80106ef5:	e9 94 f8 ff ff       	jmp    8010678e <alltraps>

80106efa <vector71>:
.globl vector71
vector71:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $71
80106efc:	6a 47                	push   $0x47
  jmp alltraps
80106efe:	e9 8b f8 ff ff       	jmp    8010678e <alltraps>

80106f03 <vector72>:
.globl vector72
vector72:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $72
80106f05:	6a 48                	push   $0x48
  jmp alltraps
80106f07:	e9 82 f8 ff ff       	jmp    8010678e <alltraps>

80106f0c <vector73>:
.globl vector73
vector73:
  pushl $0
80106f0c:	6a 00                	push   $0x0
  pushl $73
80106f0e:	6a 49                	push   $0x49
  jmp alltraps
80106f10:	e9 79 f8 ff ff       	jmp    8010678e <alltraps>

80106f15 <vector74>:
.globl vector74
vector74:
  pushl $0
80106f15:	6a 00                	push   $0x0
  pushl $74
80106f17:	6a 4a                	push   $0x4a
  jmp alltraps
80106f19:	e9 70 f8 ff ff       	jmp    8010678e <alltraps>

80106f1e <vector75>:
.globl vector75
vector75:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $75
80106f20:	6a 4b                	push   $0x4b
  jmp alltraps
80106f22:	e9 67 f8 ff ff       	jmp    8010678e <alltraps>

80106f27 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $76
80106f29:	6a 4c                	push   $0x4c
  jmp alltraps
80106f2b:	e9 5e f8 ff ff       	jmp    8010678e <alltraps>

80106f30 <vector77>:
.globl vector77
vector77:
  pushl $0
80106f30:	6a 00                	push   $0x0
  pushl $77
80106f32:	6a 4d                	push   $0x4d
  jmp alltraps
80106f34:	e9 55 f8 ff ff       	jmp    8010678e <alltraps>

80106f39 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f39:	6a 00                	push   $0x0
  pushl $78
80106f3b:	6a 4e                	push   $0x4e
  jmp alltraps
80106f3d:	e9 4c f8 ff ff       	jmp    8010678e <alltraps>

80106f42 <vector79>:
.globl vector79
vector79:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $79
80106f44:	6a 4f                	push   $0x4f
  jmp alltraps
80106f46:	e9 43 f8 ff ff       	jmp    8010678e <alltraps>

80106f4b <vector80>:
.globl vector80
vector80:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $80
80106f4d:	6a 50                	push   $0x50
  jmp alltraps
80106f4f:	e9 3a f8 ff ff       	jmp    8010678e <alltraps>

80106f54 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f54:	6a 00                	push   $0x0
  pushl $81
80106f56:	6a 51                	push   $0x51
  jmp alltraps
80106f58:	e9 31 f8 ff ff       	jmp    8010678e <alltraps>

80106f5d <vector82>:
.globl vector82
vector82:
  pushl $0
80106f5d:	6a 00                	push   $0x0
  pushl $82
80106f5f:	6a 52                	push   $0x52
  jmp alltraps
80106f61:	e9 28 f8 ff ff       	jmp    8010678e <alltraps>

80106f66 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $83
80106f68:	6a 53                	push   $0x53
  jmp alltraps
80106f6a:	e9 1f f8 ff ff       	jmp    8010678e <alltraps>

80106f6f <vector84>:
.globl vector84
vector84:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $84
80106f71:	6a 54                	push   $0x54
  jmp alltraps
80106f73:	e9 16 f8 ff ff       	jmp    8010678e <alltraps>

80106f78 <vector85>:
.globl vector85
vector85:
  pushl $0
80106f78:	6a 00                	push   $0x0
  pushl $85
80106f7a:	6a 55                	push   $0x55
  jmp alltraps
80106f7c:	e9 0d f8 ff ff       	jmp    8010678e <alltraps>

80106f81 <vector86>:
.globl vector86
vector86:
  pushl $0
80106f81:	6a 00                	push   $0x0
  pushl $86
80106f83:	6a 56                	push   $0x56
  jmp alltraps
80106f85:	e9 04 f8 ff ff       	jmp    8010678e <alltraps>

80106f8a <vector87>:
.globl vector87
vector87:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $87
80106f8c:	6a 57                	push   $0x57
  jmp alltraps
80106f8e:	e9 fb f7 ff ff       	jmp    8010678e <alltraps>

80106f93 <vector88>:
.globl vector88
vector88:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $88
80106f95:	6a 58                	push   $0x58
  jmp alltraps
80106f97:	e9 f2 f7 ff ff       	jmp    8010678e <alltraps>

80106f9c <vector89>:
.globl vector89
vector89:
  pushl $0
80106f9c:	6a 00                	push   $0x0
  pushl $89
80106f9e:	6a 59                	push   $0x59
  jmp alltraps
80106fa0:	e9 e9 f7 ff ff       	jmp    8010678e <alltraps>

80106fa5 <vector90>:
.globl vector90
vector90:
  pushl $0
80106fa5:	6a 00                	push   $0x0
  pushl $90
80106fa7:	6a 5a                	push   $0x5a
  jmp alltraps
80106fa9:	e9 e0 f7 ff ff       	jmp    8010678e <alltraps>

80106fae <vector91>:
.globl vector91
vector91:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $91
80106fb0:	6a 5b                	push   $0x5b
  jmp alltraps
80106fb2:	e9 d7 f7 ff ff       	jmp    8010678e <alltraps>

80106fb7 <vector92>:
.globl vector92
vector92:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $92
80106fb9:	6a 5c                	push   $0x5c
  jmp alltraps
80106fbb:	e9 ce f7 ff ff       	jmp    8010678e <alltraps>

80106fc0 <vector93>:
.globl vector93
vector93:
  pushl $0
80106fc0:	6a 00                	push   $0x0
  pushl $93
80106fc2:	6a 5d                	push   $0x5d
  jmp alltraps
80106fc4:	e9 c5 f7 ff ff       	jmp    8010678e <alltraps>

80106fc9 <vector94>:
.globl vector94
vector94:
  pushl $0
80106fc9:	6a 00                	push   $0x0
  pushl $94
80106fcb:	6a 5e                	push   $0x5e
  jmp alltraps
80106fcd:	e9 bc f7 ff ff       	jmp    8010678e <alltraps>

80106fd2 <vector95>:
.globl vector95
vector95:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $95
80106fd4:	6a 5f                	push   $0x5f
  jmp alltraps
80106fd6:	e9 b3 f7 ff ff       	jmp    8010678e <alltraps>

80106fdb <vector96>:
.globl vector96
vector96:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $96
80106fdd:	6a 60                	push   $0x60
  jmp alltraps
80106fdf:	e9 aa f7 ff ff       	jmp    8010678e <alltraps>

80106fe4 <vector97>:
.globl vector97
vector97:
  pushl $0
80106fe4:	6a 00                	push   $0x0
  pushl $97
80106fe6:	6a 61                	push   $0x61
  jmp alltraps
80106fe8:	e9 a1 f7 ff ff       	jmp    8010678e <alltraps>

80106fed <vector98>:
.globl vector98
vector98:
  pushl $0
80106fed:	6a 00                	push   $0x0
  pushl $98
80106fef:	6a 62                	push   $0x62
  jmp alltraps
80106ff1:	e9 98 f7 ff ff       	jmp    8010678e <alltraps>

80106ff6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $99
80106ff8:	6a 63                	push   $0x63
  jmp alltraps
80106ffa:	e9 8f f7 ff ff       	jmp    8010678e <alltraps>

80106fff <vector100>:
.globl vector100
vector100:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $100
80107001:	6a 64                	push   $0x64
  jmp alltraps
80107003:	e9 86 f7 ff ff       	jmp    8010678e <alltraps>

80107008 <vector101>:
.globl vector101
vector101:
  pushl $0
80107008:	6a 00                	push   $0x0
  pushl $101
8010700a:	6a 65                	push   $0x65
  jmp alltraps
8010700c:	e9 7d f7 ff ff       	jmp    8010678e <alltraps>

80107011 <vector102>:
.globl vector102
vector102:
  pushl $0
80107011:	6a 00                	push   $0x0
  pushl $102
80107013:	6a 66                	push   $0x66
  jmp alltraps
80107015:	e9 74 f7 ff ff       	jmp    8010678e <alltraps>

8010701a <vector103>:
.globl vector103
vector103:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $103
8010701c:	6a 67                	push   $0x67
  jmp alltraps
8010701e:	e9 6b f7 ff ff       	jmp    8010678e <alltraps>

80107023 <vector104>:
.globl vector104
vector104:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $104
80107025:	6a 68                	push   $0x68
  jmp alltraps
80107027:	e9 62 f7 ff ff       	jmp    8010678e <alltraps>

8010702c <vector105>:
.globl vector105
vector105:
  pushl $0
8010702c:	6a 00                	push   $0x0
  pushl $105
8010702e:	6a 69                	push   $0x69
  jmp alltraps
80107030:	e9 59 f7 ff ff       	jmp    8010678e <alltraps>

80107035 <vector106>:
.globl vector106
vector106:
  pushl $0
80107035:	6a 00                	push   $0x0
  pushl $106
80107037:	6a 6a                	push   $0x6a
  jmp alltraps
80107039:	e9 50 f7 ff ff       	jmp    8010678e <alltraps>

8010703e <vector107>:
.globl vector107
vector107:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $107
80107040:	6a 6b                	push   $0x6b
  jmp alltraps
80107042:	e9 47 f7 ff ff       	jmp    8010678e <alltraps>

80107047 <vector108>:
.globl vector108
vector108:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $108
80107049:	6a 6c                	push   $0x6c
  jmp alltraps
8010704b:	e9 3e f7 ff ff       	jmp    8010678e <alltraps>

80107050 <vector109>:
.globl vector109
vector109:
  pushl $0
80107050:	6a 00                	push   $0x0
  pushl $109
80107052:	6a 6d                	push   $0x6d
  jmp alltraps
80107054:	e9 35 f7 ff ff       	jmp    8010678e <alltraps>

80107059 <vector110>:
.globl vector110
vector110:
  pushl $0
80107059:	6a 00                	push   $0x0
  pushl $110
8010705b:	6a 6e                	push   $0x6e
  jmp alltraps
8010705d:	e9 2c f7 ff ff       	jmp    8010678e <alltraps>

80107062 <vector111>:
.globl vector111
vector111:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $111
80107064:	6a 6f                	push   $0x6f
  jmp alltraps
80107066:	e9 23 f7 ff ff       	jmp    8010678e <alltraps>

8010706b <vector112>:
.globl vector112
vector112:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $112
8010706d:	6a 70                	push   $0x70
  jmp alltraps
8010706f:	e9 1a f7 ff ff       	jmp    8010678e <alltraps>

80107074 <vector113>:
.globl vector113
vector113:
  pushl $0
80107074:	6a 00                	push   $0x0
  pushl $113
80107076:	6a 71                	push   $0x71
  jmp alltraps
80107078:	e9 11 f7 ff ff       	jmp    8010678e <alltraps>

8010707d <vector114>:
.globl vector114
vector114:
  pushl $0
8010707d:	6a 00                	push   $0x0
  pushl $114
8010707f:	6a 72                	push   $0x72
  jmp alltraps
80107081:	e9 08 f7 ff ff       	jmp    8010678e <alltraps>

80107086 <vector115>:
.globl vector115
vector115:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $115
80107088:	6a 73                	push   $0x73
  jmp alltraps
8010708a:	e9 ff f6 ff ff       	jmp    8010678e <alltraps>

8010708f <vector116>:
.globl vector116
vector116:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $116
80107091:	6a 74                	push   $0x74
  jmp alltraps
80107093:	e9 f6 f6 ff ff       	jmp    8010678e <alltraps>

80107098 <vector117>:
.globl vector117
vector117:
  pushl $0
80107098:	6a 00                	push   $0x0
  pushl $117
8010709a:	6a 75                	push   $0x75
  jmp alltraps
8010709c:	e9 ed f6 ff ff       	jmp    8010678e <alltraps>

801070a1 <vector118>:
.globl vector118
vector118:
  pushl $0
801070a1:	6a 00                	push   $0x0
  pushl $118
801070a3:	6a 76                	push   $0x76
  jmp alltraps
801070a5:	e9 e4 f6 ff ff       	jmp    8010678e <alltraps>

801070aa <vector119>:
.globl vector119
vector119:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $119
801070ac:	6a 77                	push   $0x77
  jmp alltraps
801070ae:	e9 db f6 ff ff       	jmp    8010678e <alltraps>

801070b3 <vector120>:
.globl vector120
vector120:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $120
801070b5:	6a 78                	push   $0x78
  jmp alltraps
801070b7:	e9 d2 f6 ff ff       	jmp    8010678e <alltraps>

801070bc <vector121>:
.globl vector121
vector121:
  pushl $0
801070bc:	6a 00                	push   $0x0
  pushl $121
801070be:	6a 79                	push   $0x79
  jmp alltraps
801070c0:	e9 c9 f6 ff ff       	jmp    8010678e <alltraps>

801070c5 <vector122>:
.globl vector122
vector122:
  pushl $0
801070c5:	6a 00                	push   $0x0
  pushl $122
801070c7:	6a 7a                	push   $0x7a
  jmp alltraps
801070c9:	e9 c0 f6 ff ff       	jmp    8010678e <alltraps>

801070ce <vector123>:
.globl vector123
vector123:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $123
801070d0:	6a 7b                	push   $0x7b
  jmp alltraps
801070d2:	e9 b7 f6 ff ff       	jmp    8010678e <alltraps>

801070d7 <vector124>:
.globl vector124
vector124:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $124
801070d9:	6a 7c                	push   $0x7c
  jmp alltraps
801070db:	e9 ae f6 ff ff       	jmp    8010678e <alltraps>

801070e0 <vector125>:
.globl vector125
vector125:
  pushl $0
801070e0:	6a 00                	push   $0x0
  pushl $125
801070e2:	6a 7d                	push   $0x7d
  jmp alltraps
801070e4:	e9 a5 f6 ff ff       	jmp    8010678e <alltraps>

801070e9 <vector126>:
.globl vector126
vector126:
  pushl $0
801070e9:	6a 00                	push   $0x0
  pushl $126
801070eb:	6a 7e                	push   $0x7e
  jmp alltraps
801070ed:	e9 9c f6 ff ff       	jmp    8010678e <alltraps>

801070f2 <vector127>:
.globl vector127
vector127:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $127
801070f4:	6a 7f                	push   $0x7f
  jmp alltraps
801070f6:	e9 93 f6 ff ff       	jmp    8010678e <alltraps>

801070fb <vector128>:
.globl vector128
vector128:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $128
801070fd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107102:	e9 87 f6 ff ff       	jmp    8010678e <alltraps>

80107107 <vector129>:
.globl vector129
vector129:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $129
80107109:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010710e:	e9 7b f6 ff ff       	jmp    8010678e <alltraps>

80107113 <vector130>:
.globl vector130
vector130:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $130
80107115:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010711a:	e9 6f f6 ff ff       	jmp    8010678e <alltraps>

8010711f <vector131>:
.globl vector131
vector131:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $131
80107121:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107126:	e9 63 f6 ff ff       	jmp    8010678e <alltraps>

8010712b <vector132>:
.globl vector132
vector132:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $132
8010712d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107132:	e9 57 f6 ff ff       	jmp    8010678e <alltraps>

80107137 <vector133>:
.globl vector133
vector133:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $133
80107139:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010713e:	e9 4b f6 ff ff       	jmp    8010678e <alltraps>

80107143 <vector134>:
.globl vector134
vector134:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $134
80107145:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010714a:	e9 3f f6 ff ff       	jmp    8010678e <alltraps>

8010714f <vector135>:
.globl vector135
vector135:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $135
80107151:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107156:	e9 33 f6 ff ff       	jmp    8010678e <alltraps>

8010715b <vector136>:
.globl vector136
vector136:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $136
8010715d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107162:	e9 27 f6 ff ff       	jmp    8010678e <alltraps>

80107167 <vector137>:
.globl vector137
vector137:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $137
80107169:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010716e:	e9 1b f6 ff ff       	jmp    8010678e <alltraps>

80107173 <vector138>:
.globl vector138
vector138:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $138
80107175:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010717a:	e9 0f f6 ff ff       	jmp    8010678e <alltraps>

8010717f <vector139>:
.globl vector139
vector139:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $139
80107181:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107186:	e9 03 f6 ff ff       	jmp    8010678e <alltraps>

8010718b <vector140>:
.globl vector140
vector140:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $140
8010718d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107192:	e9 f7 f5 ff ff       	jmp    8010678e <alltraps>

80107197 <vector141>:
.globl vector141
vector141:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $141
80107199:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010719e:	e9 eb f5 ff ff       	jmp    8010678e <alltraps>

801071a3 <vector142>:
.globl vector142
vector142:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $142
801071a5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801071aa:	e9 df f5 ff ff       	jmp    8010678e <alltraps>

801071af <vector143>:
.globl vector143
vector143:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $143
801071b1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801071b6:	e9 d3 f5 ff ff       	jmp    8010678e <alltraps>

801071bb <vector144>:
.globl vector144
vector144:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $144
801071bd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801071c2:	e9 c7 f5 ff ff       	jmp    8010678e <alltraps>

801071c7 <vector145>:
.globl vector145
vector145:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $145
801071c9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071ce:	e9 bb f5 ff ff       	jmp    8010678e <alltraps>

801071d3 <vector146>:
.globl vector146
vector146:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $146
801071d5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071da:	e9 af f5 ff ff       	jmp    8010678e <alltraps>

801071df <vector147>:
.globl vector147
vector147:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $147
801071e1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801071e6:	e9 a3 f5 ff ff       	jmp    8010678e <alltraps>

801071eb <vector148>:
.globl vector148
vector148:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $148
801071ed:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801071f2:	e9 97 f5 ff ff       	jmp    8010678e <alltraps>

801071f7 <vector149>:
.globl vector149
vector149:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $149
801071f9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801071fe:	e9 8b f5 ff ff       	jmp    8010678e <alltraps>

80107203 <vector150>:
.globl vector150
vector150:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $150
80107205:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010720a:	e9 7f f5 ff ff       	jmp    8010678e <alltraps>

8010720f <vector151>:
.globl vector151
vector151:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $151
80107211:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107216:	e9 73 f5 ff ff       	jmp    8010678e <alltraps>

8010721b <vector152>:
.globl vector152
vector152:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $152
8010721d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107222:	e9 67 f5 ff ff       	jmp    8010678e <alltraps>

80107227 <vector153>:
.globl vector153
vector153:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $153
80107229:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010722e:	e9 5b f5 ff ff       	jmp    8010678e <alltraps>

80107233 <vector154>:
.globl vector154
vector154:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $154
80107235:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010723a:	e9 4f f5 ff ff       	jmp    8010678e <alltraps>

8010723f <vector155>:
.globl vector155
vector155:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $155
80107241:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107246:	e9 43 f5 ff ff       	jmp    8010678e <alltraps>

8010724b <vector156>:
.globl vector156
vector156:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $156
8010724d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107252:	e9 37 f5 ff ff       	jmp    8010678e <alltraps>

80107257 <vector157>:
.globl vector157
vector157:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $157
80107259:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010725e:	e9 2b f5 ff ff       	jmp    8010678e <alltraps>

80107263 <vector158>:
.globl vector158
vector158:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $158
80107265:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010726a:	e9 1f f5 ff ff       	jmp    8010678e <alltraps>

8010726f <vector159>:
.globl vector159
vector159:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $159
80107271:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107276:	e9 13 f5 ff ff       	jmp    8010678e <alltraps>

8010727b <vector160>:
.globl vector160
vector160:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $160
8010727d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107282:	e9 07 f5 ff ff       	jmp    8010678e <alltraps>

80107287 <vector161>:
.globl vector161
vector161:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $161
80107289:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010728e:	e9 fb f4 ff ff       	jmp    8010678e <alltraps>

80107293 <vector162>:
.globl vector162
vector162:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $162
80107295:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010729a:	e9 ef f4 ff ff       	jmp    8010678e <alltraps>

8010729f <vector163>:
.globl vector163
vector163:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $163
801072a1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801072a6:	e9 e3 f4 ff ff       	jmp    8010678e <alltraps>

801072ab <vector164>:
.globl vector164
vector164:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $164
801072ad:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801072b2:	e9 d7 f4 ff ff       	jmp    8010678e <alltraps>

801072b7 <vector165>:
.globl vector165
vector165:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $165
801072b9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801072be:	e9 cb f4 ff ff       	jmp    8010678e <alltraps>

801072c3 <vector166>:
.globl vector166
vector166:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $166
801072c5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072ca:	e9 bf f4 ff ff       	jmp    8010678e <alltraps>

801072cf <vector167>:
.globl vector167
vector167:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $167
801072d1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072d6:	e9 b3 f4 ff ff       	jmp    8010678e <alltraps>

801072db <vector168>:
.globl vector168
vector168:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $168
801072dd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801072e2:	e9 a7 f4 ff ff       	jmp    8010678e <alltraps>

801072e7 <vector169>:
.globl vector169
vector169:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $169
801072e9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801072ee:	e9 9b f4 ff ff       	jmp    8010678e <alltraps>

801072f3 <vector170>:
.globl vector170
vector170:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $170
801072f5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801072fa:	e9 8f f4 ff ff       	jmp    8010678e <alltraps>

801072ff <vector171>:
.globl vector171
vector171:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $171
80107301:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107306:	e9 83 f4 ff ff       	jmp    8010678e <alltraps>

8010730b <vector172>:
.globl vector172
vector172:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $172
8010730d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107312:	e9 77 f4 ff ff       	jmp    8010678e <alltraps>

80107317 <vector173>:
.globl vector173
vector173:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $173
80107319:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010731e:	e9 6b f4 ff ff       	jmp    8010678e <alltraps>

80107323 <vector174>:
.globl vector174
vector174:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $174
80107325:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010732a:	e9 5f f4 ff ff       	jmp    8010678e <alltraps>

8010732f <vector175>:
.globl vector175
vector175:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $175
80107331:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107336:	e9 53 f4 ff ff       	jmp    8010678e <alltraps>

8010733b <vector176>:
.globl vector176
vector176:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $176
8010733d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107342:	e9 47 f4 ff ff       	jmp    8010678e <alltraps>

80107347 <vector177>:
.globl vector177
vector177:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $177
80107349:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010734e:	e9 3b f4 ff ff       	jmp    8010678e <alltraps>

80107353 <vector178>:
.globl vector178
vector178:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $178
80107355:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010735a:	e9 2f f4 ff ff       	jmp    8010678e <alltraps>

8010735f <vector179>:
.globl vector179
vector179:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $179
80107361:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107366:	e9 23 f4 ff ff       	jmp    8010678e <alltraps>

8010736b <vector180>:
.globl vector180
vector180:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $180
8010736d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107372:	e9 17 f4 ff ff       	jmp    8010678e <alltraps>

80107377 <vector181>:
.globl vector181
vector181:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $181
80107379:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010737e:	e9 0b f4 ff ff       	jmp    8010678e <alltraps>

80107383 <vector182>:
.globl vector182
vector182:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $182
80107385:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010738a:	e9 ff f3 ff ff       	jmp    8010678e <alltraps>

8010738f <vector183>:
.globl vector183
vector183:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $183
80107391:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107396:	e9 f3 f3 ff ff       	jmp    8010678e <alltraps>

8010739b <vector184>:
.globl vector184
vector184:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $184
8010739d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801073a2:	e9 e7 f3 ff ff       	jmp    8010678e <alltraps>

801073a7 <vector185>:
.globl vector185
vector185:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $185
801073a9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801073ae:	e9 db f3 ff ff       	jmp    8010678e <alltraps>

801073b3 <vector186>:
.globl vector186
vector186:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $186
801073b5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801073ba:	e9 cf f3 ff ff       	jmp    8010678e <alltraps>

801073bf <vector187>:
.globl vector187
vector187:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $187
801073c1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073c6:	e9 c3 f3 ff ff       	jmp    8010678e <alltraps>

801073cb <vector188>:
.globl vector188
vector188:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $188
801073cd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073d2:	e9 b7 f3 ff ff       	jmp    8010678e <alltraps>

801073d7 <vector189>:
.globl vector189
vector189:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $189
801073d9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073de:	e9 ab f3 ff ff       	jmp    8010678e <alltraps>

801073e3 <vector190>:
.globl vector190
vector190:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $190
801073e5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801073ea:	e9 9f f3 ff ff       	jmp    8010678e <alltraps>

801073ef <vector191>:
.globl vector191
vector191:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $191
801073f1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801073f6:	e9 93 f3 ff ff       	jmp    8010678e <alltraps>

801073fb <vector192>:
.globl vector192
vector192:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $192
801073fd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107402:	e9 87 f3 ff ff       	jmp    8010678e <alltraps>

80107407 <vector193>:
.globl vector193
vector193:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $193
80107409:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010740e:	e9 7b f3 ff ff       	jmp    8010678e <alltraps>

80107413 <vector194>:
.globl vector194
vector194:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $194
80107415:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010741a:	e9 6f f3 ff ff       	jmp    8010678e <alltraps>

8010741f <vector195>:
.globl vector195
vector195:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $195
80107421:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107426:	e9 63 f3 ff ff       	jmp    8010678e <alltraps>

8010742b <vector196>:
.globl vector196
vector196:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $196
8010742d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107432:	e9 57 f3 ff ff       	jmp    8010678e <alltraps>

80107437 <vector197>:
.globl vector197
vector197:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $197
80107439:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010743e:	e9 4b f3 ff ff       	jmp    8010678e <alltraps>

80107443 <vector198>:
.globl vector198
vector198:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $198
80107445:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010744a:	e9 3f f3 ff ff       	jmp    8010678e <alltraps>

8010744f <vector199>:
.globl vector199
vector199:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $199
80107451:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107456:	e9 33 f3 ff ff       	jmp    8010678e <alltraps>

8010745b <vector200>:
.globl vector200
vector200:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $200
8010745d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107462:	e9 27 f3 ff ff       	jmp    8010678e <alltraps>

80107467 <vector201>:
.globl vector201
vector201:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $201
80107469:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010746e:	e9 1b f3 ff ff       	jmp    8010678e <alltraps>

80107473 <vector202>:
.globl vector202
vector202:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $202
80107475:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010747a:	e9 0f f3 ff ff       	jmp    8010678e <alltraps>

8010747f <vector203>:
.globl vector203
vector203:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $203
80107481:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107486:	e9 03 f3 ff ff       	jmp    8010678e <alltraps>

8010748b <vector204>:
.globl vector204
vector204:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $204
8010748d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107492:	e9 f7 f2 ff ff       	jmp    8010678e <alltraps>

80107497 <vector205>:
.globl vector205
vector205:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $205
80107499:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010749e:	e9 eb f2 ff ff       	jmp    8010678e <alltraps>

801074a3 <vector206>:
.globl vector206
vector206:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $206
801074a5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801074aa:	e9 df f2 ff ff       	jmp    8010678e <alltraps>

801074af <vector207>:
.globl vector207
vector207:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $207
801074b1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801074b6:	e9 d3 f2 ff ff       	jmp    8010678e <alltraps>

801074bb <vector208>:
.globl vector208
vector208:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $208
801074bd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801074c2:	e9 c7 f2 ff ff       	jmp    8010678e <alltraps>

801074c7 <vector209>:
.globl vector209
vector209:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $209
801074c9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074ce:	e9 bb f2 ff ff       	jmp    8010678e <alltraps>

801074d3 <vector210>:
.globl vector210
vector210:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $210
801074d5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074da:	e9 af f2 ff ff       	jmp    8010678e <alltraps>

801074df <vector211>:
.globl vector211
vector211:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $211
801074e1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801074e6:	e9 a3 f2 ff ff       	jmp    8010678e <alltraps>

801074eb <vector212>:
.globl vector212
vector212:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $212
801074ed:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801074f2:	e9 97 f2 ff ff       	jmp    8010678e <alltraps>

801074f7 <vector213>:
.globl vector213
vector213:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $213
801074f9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801074fe:	e9 8b f2 ff ff       	jmp    8010678e <alltraps>

80107503 <vector214>:
.globl vector214
vector214:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $214
80107505:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010750a:	e9 7f f2 ff ff       	jmp    8010678e <alltraps>

8010750f <vector215>:
.globl vector215
vector215:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $215
80107511:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107516:	e9 73 f2 ff ff       	jmp    8010678e <alltraps>

8010751b <vector216>:
.globl vector216
vector216:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $216
8010751d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107522:	e9 67 f2 ff ff       	jmp    8010678e <alltraps>

80107527 <vector217>:
.globl vector217
vector217:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $217
80107529:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010752e:	e9 5b f2 ff ff       	jmp    8010678e <alltraps>

80107533 <vector218>:
.globl vector218
vector218:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $218
80107535:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010753a:	e9 4f f2 ff ff       	jmp    8010678e <alltraps>

8010753f <vector219>:
.globl vector219
vector219:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $219
80107541:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107546:	e9 43 f2 ff ff       	jmp    8010678e <alltraps>

8010754b <vector220>:
.globl vector220
vector220:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $220
8010754d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107552:	e9 37 f2 ff ff       	jmp    8010678e <alltraps>

80107557 <vector221>:
.globl vector221
vector221:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $221
80107559:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010755e:	e9 2b f2 ff ff       	jmp    8010678e <alltraps>

80107563 <vector222>:
.globl vector222
vector222:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $222
80107565:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010756a:	e9 1f f2 ff ff       	jmp    8010678e <alltraps>

8010756f <vector223>:
.globl vector223
vector223:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $223
80107571:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107576:	e9 13 f2 ff ff       	jmp    8010678e <alltraps>

8010757b <vector224>:
.globl vector224
vector224:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $224
8010757d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107582:	e9 07 f2 ff ff       	jmp    8010678e <alltraps>

80107587 <vector225>:
.globl vector225
vector225:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $225
80107589:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010758e:	e9 fb f1 ff ff       	jmp    8010678e <alltraps>

80107593 <vector226>:
.globl vector226
vector226:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $226
80107595:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010759a:	e9 ef f1 ff ff       	jmp    8010678e <alltraps>

8010759f <vector227>:
.globl vector227
vector227:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $227
801075a1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801075a6:	e9 e3 f1 ff ff       	jmp    8010678e <alltraps>

801075ab <vector228>:
.globl vector228
vector228:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $228
801075ad:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801075b2:	e9 d7 f1 ff ff       	jmp    8010678e <alltraps>

801075b7 <vector229>:
.globl vector229
vector229:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $229
801075b9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801075be:	e9 cb f1 ff ff       	jmp    8010678e <alltraps>

801075c3 <vector230>:
.globl vector230
vector230:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $230
801075c5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075ca:	e9 bf f1 ff ff       	jmp    8010678e <alltraps>

801075cf <vector231>:
.globl vector231
vector231:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $231
801075d1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075d6:	e9 b3 f1 ff ff       	jmp    8010678e <alltraps>

801075db <vector232>:
.globl vector232
vector232:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $232
801075dd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801075e2:	e9 a7 f1 ff ff       	jmp    8010678e <alltraps>

801075e7 <vector233>:
.globl vector233
vector233:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $233
801075e9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801075ee:	e9 9b f1 ff ff       	jmp    8010678e <alltraps>

801075f3 <vector234>:
.globl vector234
vector234:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $234
801075f5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801075fa:	e9 8f f1 ff ff       	jmp    8010678e <alltraps>

801075ff <vector235>:
.globl vector235
vector235:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $235
80107601:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107606:	e9 83 f1 ff ff       	jmp    8010678e <alltraps>

8010760b <vector236>:
.globl vector236
vector236:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $236
8010760d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107612:	e9 77 f1 ff ff       	jmp    8010678e <alltraps>

80107617 <vector237>:
.globl vector237
vector237:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $237
80107619:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010761e:	e9 6b f1 ff ff       	jmp    8010678e <alltraps>

80107623 <vector238>:
.globl vector238
vector238:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $238
80107625:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010762a:	e9 5f f1 ff ff       	jmp    8010678e <alltraps>

8010762f <vector239>:
.globl vector239
vector239:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $239
80107631:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107636:	e9 53 f1 ff ff       	jmp    8010678e <alltraps>

8010763b <vector240>:
.globl vector240
vector240:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $240
8010763d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107642:	e9 47 f1 ff ff       	jmp    8010678e <alltraps>

80107647 <vector241>:
.globl vector241
vector241:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $241
80107649:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010764e:	e9 3b f1 ff ff       	jmp    8010678e <alltraps>

80107653 <vector242>:
.globl vector242
vector242:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $242
80107655:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010765a:	e9 2f f1 ff ff       	jmp    8010678e <alltraps>

8010765f <vector243>:
.globl vector243
vector243:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $243
80107661:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107666:	e9 23 f1 ff ff       	jmp    8010678e <alltraps>

8010766b <vector244>:
.globl vector244
vector244:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $244
8010766d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107672:	e9 17 f1 ff ff       	jmp    8010678e <alltraps>

80107677 <vector245>:
.globl vector245
vector245:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $245
80107679:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010767e:	e9 0b f1 ff ff       	jmp    8010678e <alltraps>

80107683 <vector246>:
.globl vector246
vector246:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $246
80107685:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010768a:	e9 ff f0 ff ff       	jmp    8010678e <alltraps>

8010768f <vector247>:
.globl vector247
vector247:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $247
80107691:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107696:	e9 f3 f0 ff ff       	jmp    8010678e <alltraps>

8010769b <vector248>:
.globl vector248
vector248:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $248
8010769d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801076a2:	e9 e7 f0 ff ff       	jmp    8010678e <alltraps>

801076a7 <vector249>:
.globl vector249
vector249:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $249
801076a9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801076ae:	e9 db f0 ff ff       	jmp    8010678e <alltraps>

801076b3 <vector250>:
.globl vector250
vector250:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $250
801076b5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801076ba:	e9 cf f0 ff ff       	jmp    8010678e <alltraps>

801076bf <vector251>:
.globl vector251
vector251:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $251
801076c1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076c6:	e9 c3 f0 ff ff       	jmp    8010678e <alltraps>

801076cb <vector252>:
.globl vector252
vector252:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $252
801076cd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076d2:	e9 b7 f0 ff ff       	jmp    8010678e <alltraps>

801076d7 <vector253>:
.globl vector253
vector253:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $253
801076d9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076de:	e9 ab f0 ff ff       	jmp    8010678e <alltraps>

801076e3 <vector254>:
.globl vector254
vector254:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $254
801076e5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801076ea:	e9 9f f0 ff ff       	jmp    8010678e <alltraps>

801076ef <vector255>:
.globl vector255
vector255:
  pushl $0
801076ef:	6a 00                	push   $0x0
  pushl $255
801076f1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801076f6:	e9 93 f0 ff ff       	jmp    8010678e <alltraps>
801076fb:	66 90                	xchg   %ax,%ax
801076fd:	66 90                	xchg   %ax,%ax
801076ff:	90                   	nop

80107700 <seginit>:
pde_t *kpgdir;      // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void seginit(void)
{
80107700:	f3 0f 1e fb          	endbr32 
80107704:	55                   	push   %ebp
80107705:	89 e5                	mov    %esp,%ebp
80107707:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
8010770a:	e8 41 d0 ff ff       	call   80104750 <cpuid>
  pd[0] = size-1;
8010770f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107714:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010771a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010771e:	c7 80 38 99 11 80 ff 	movl   $0xffff,-0x7fee66c8(%eax)
80107725:	ff 00 00 
80107728:	c7 80 3c 99 11 80 00 	movl   $0xcf9a00,-0x7fee66c4(%eax)
8010772f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107732:	c7 80 40 99 11 80 ff 	movl   $0xffff,-0x7fee66c0(%eax)
80107739:	ff 00 00 
8010773c:	c7 80 44 99 11 80 00 	movl   $0xcf9200,-0x7fee66bc(%eax)
80107743:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80107746:	c7 80 48 99 11 80 ff 	movl   $0xffff,-0x7fee66b8(%eax)
8010774d:	ff 00 00 
80107750:	c7 80 4c 99 11 80 00 	movl   $0xcffa00,-0x7fee66b4(%eax)
80107757:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010775a:	c7 80 50 99 11 80 ff 	movl   $0xffff,-0x7fee66b0(%eax)
80107761:	ff 00 00 
80107764:	c7 80 54 99 11 80 00 	movl   $0xcff200,-0x7fee66ac(%eax)
8010776b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010776e:	05 30 99 11 80       	add    $0x80119930,%eax
  pd[1] = (uint)p;
80107773:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107777:	c1 e8 10             	shr    $0x10,%eax
8010777a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010777e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107781:	0f 01 10             	lgdtl  (%eax)
}
80107784:	c9                   	leave  
80107785:	c3                   	ret    
80107786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010778d:	8d 76 00             	lea    0x0(%esi),%esi

80107790 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107790:	f3 0f 1e fb          	endbr32 
80107794:	55                   	push   %ebp
80107795:	89 e5                	mov    %esp,%ebp
80107797:	57                   	push   %edi
80107798:	56                   	push   %esi
80107799:	53                   	push   %ebx
8010779a:	83 ec 0c             	sub    $0xc,%esp
8010779d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801077a0:	8b 55 08             	mov    0x8(%ebp),%edx
801077a3:	89 fe                	mov    %edi,%esi
801077a5:	c1 ee 16             	shr    $0x16,%esi
801077a8:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if (*pde & PTE_P)
801077ab:	8b 1e                	mov    (%esi),%ebx
801077ad:	f6 c3 01             	test   $0x1,%bl
801077b0:	74 26                	je     801077d8 <walkpgdir+0x48>
  {
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
801077b2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801077b8:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801077be:	89 f8                	mov    %edi,%eax
}
801077c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801077c3:	c1 e8 0a             	shr    $0xa,%eax
801077c6:	25 fc 0f 00 00       	and    $0xffc,%eax
801077cb:	01 d8                	add    %ebx,%eax
}
801077cd:	5b                   	pop    %ebx
801077ce:	5e                   	pop    %esi
801077cf:	5f                   	pop    %edi
801077d0:	5d                   	pop    %ebp
801077d1:	c3                   	ret    
801077d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (!alloc || (pgtab = (pte_t *)kalloc()) == 0)
801077d8:	8b 45 10             	mov    0x10(%ebp),%eax
801077db:	85 c0                	test   %eax,%eax
801077dd:	74 31                	je     80107810 <walkpgdir+0x80>
801077df:	e8 2c ba ff ff       	call   80103210 <kalloc>
801077e4:	89 c3                	mov    %eax,%ebx
801077e6:	85 c0                	test   %eax,%eax
801077e8:	74 26                	je     80107810 <walkpgdir+0x80>
    memset(pgtab, 0, PGSIZE);
801077ea:	83 ec 04             	sub    $0x4,%esp
801077ed:	68 00 10 00 00       	push   $0x1000
801077f2:	6a 00                	push   $0x0
801077f4:	50                   	push   %eax
801077f5:	e8 76 dc ff ff       	call   80105470 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801077fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107800:	83 c4 10             	add    $0x10,%esp
80107803:	83 c8 07             	or     $0x7,%eax
80107806:	89 06                	mov    %eax,(%esi)
80107808:	eb b4                	jmp    801077be <walkpgdir+0x2e>
8010780a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80107810:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107813:	31 c0                	xor    %eax,%eax
}
80107815:	5b                   	pop    %ebx
80107816:	5e                   	pop    %esi
80107817:	5f                   	pop    %edi
80107818:	5d                   	pop    %ebp
80107819:	c3                   	ret    
8010781a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107820 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107820:	55                   	push   %ebp
80107821:	89 e5                	mov    %esp,%ebp
80107823:	57                   	push   %edi
80107824:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char *)PGROUNDDOWN((uint)va);
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80107826:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010782a:	56                   	push   %esi
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
8010782b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char *)PGROUNDDOWN((uint)va);
80107830:	89 d6                	mov    %edx,%esi
{
80107832:	53                   	push   %ebx
  a = (char *)PGROUNDDOWN((uint)va);
80107833:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107839:	83 ec 1c             	sub    $0x1c,%esp
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
8010783c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010783f:	8b 45 08             	mov    0x8(%ebp),%eax
80107842:	29 f0                	sub    %esi,%eax
80107844:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107847:	eb 1f                	jmp    80107868 <mappages+0x48>
80107849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (;;)
  {
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if (*pte & PTE_P)
80107850:	f6 00 01             	testb  $0x1,(%eax)
80107853:	75 45                	jne    8010789a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107855:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107858:	83 cb 01             	or     $0x1,%ebx
8010785b:	89 18                	mov    %ebx,(%eax)
    if (a == last)
8010785d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107860:	74 2e                	je     80107890 <mappages+0x70>
      break;
    a += PGSIZE;
80107862:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
80107868:	83 ec 04             	sub    $0x4,%esp
8010786b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010786e:	6a 01                	push   $0x1
80107870:	56                   	push   %esi
80107871:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107874:	57                   	push   %edi
80107875:	e8 16 ff ff ff       	call   80107790 <walkpgdir>
8010787a:	83 c4 10             	add    $0x10,%esp
8010787d:	85 c0                	test   %eax,%eax
8010787f:	75 cf                	jne    80107850 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107881:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107884:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107889:	5b                   	pop    %ebx
8010788a:	5e                   	pop    %esi
8010788b:	5f                   	pop    %edi
8010788c:	5d                   	pop    %ebp
8010788d:	c3                   	ret    
8010788e:	66 90                	xchg   %ax,%ax
80107890:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107893:	31 c0                	xor    %eax,%eax
}
80107895:	5b                   	pop    %ebx
80107896:	5e                   	pop    %esi
80107897:	5f                   	pop    %edi
80107898:	5d                   	pop    %ebp
80107899:	c3                   	ret    
      panic("remap");
8010789a:	83 ec 0c             	sub    $0xc,%esp
8010789d:	68 7c 8d 10 80       	push   $0x80108d7c
801078a2:	e8 e9 8a ff ff       	call   80100390 <panic>
801078a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ae:	66 90                	xchg   %ax,%ax

801078b0 <deallocuvm.part.0>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078b0:	55                   	push   %ebp
801078b1:	89 e5                	mov    %esp,%ebp
801078b3:	57                   	push   %edi
801078b4:	56                   	push   %esi
801078b5:	89 c6                	mov    %eax,%esi
801078b7:	53                   	push   %ebx
801078b8:	89 d3                	mov    %edx,%ebx
801078ba:	83 ec 1c             	sub    $0x1c,%esp
801078bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  int bitmap_offset;

  if (newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801078c0:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801078c6:	89 d7                	mov    %edx,%edi
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078c8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  a = PGROUNDUP(newsz);
801078cb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for (; a < oldsz; a += PGSIZE)
801078d1:	39 df                	cmp    %ebx,%edi
801078d3:	72 49                	jb     8010791e <deallocuvm.part.0+0x6e>
801078d5:	e9 8a 00 00 00       	jmp    80107964 <deallocuvm.part.0+0xb4>
801078da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (!pte) // pte not exist
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if ((*pte & PTE_P) != 0) // swapped in pages(PTE_P is set)
    {
      pa = PTE_ADDR(*pte);
      if (pa == 0)
801078e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801078e6:	0f 84 94 00 00 00    	je     80107980 <deallocuvm.part.0+0xd0>
        panic("kfree");
      char *v = P2V(pa);
      // remove from LRU list
      page_delete(pgdir, (char *)a);
801078ec:	83 ec 08             	sub    $0x8,%esp
      char *v = P2V(pa);
801078ef:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801078f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
      page_delete(pgdir, (char *)a);
801078f8:	57                   	push   %edi
801078f9:	81 c7 00 10 00 00    	add    $0x1000,%edi
801078ff:	56                   	push   %esi
80107900:	e8 db b3 ff ff       	call   80102ce0 <page_delete>
      kfree(v);
80107905:	89 1c 24             	mov    %ebx,(%esp)
80107908:	e8 73 ac ff ff       	call   80102580 <kfree>
      *pte = 0;
8010790d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107910:	83 c4 10             	add    $0x10,%esp
80107913:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for (; a < oldsz; a += PGSIZE)
80107919:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010791c:	76 46                	jbe    80107964 <deallocuvm.part.0+0xb4>
    pte = walkpgdir(pgdir, (char *)a, 0);
8010791e:	83 ec 04             	sub    $0x4,%esp
80107921:	6a 00                	push   $0x0
80107923:	57                   	push   %edi
80107924:	56                   	push   %esi
80107925:	e8 66 fe ff ff       	call   80107790 <walkpgdir>
    if (!pte) // pte not exist
8010792a:	83 c4 10             	add    $0x10,%esp
8010792d:	85 c0                	test   %eax,%eax
8010792f:	74 3f                	je     80107970 <deallocuvm.part.0+0xc0>
    else if ((*pte & PTE_P) != 0) // swapped in pages(PTE_P is set)
80107931:	8b 18                	mov    (%eax),%ebx
80107933:	f6 c3 01             	test   $0x1,%bl
80107936:	75 a8                	jne    801078e0 <deallocuvm.part.0+0x30>
    }
    else if (*pte != 0) // swapped out pages(pte is not zero, PTE_P is clear)
80107938:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010793e:	85 db                	test   %ebx,%ebx
80107940:	74 d7                	je     80107919 <deallocuvm.part.0+0x69>
    {
      // clear in bitmap
      pa = PTE_ADDR(*pte);
      bitmap_offset = (int)(pa >> 12);
      bitmap_modify(bitmap_offset, 0);
80107942:	83 ec 08             	sub    $0x8,%esp
      bitmap_offset = (int)(pa >> 12);
80107945:	c1 eb 0c             	shr    $0xc,%ebx
80107948:	89 45 e0             	mov    %eax,-0x20(%ebp)
      bitmap_modify(bitmap_offset, 0);
8010794b:	6a 00                	push   $0x0
8010794d:	53                   	push   %ebx
8010794e:	e8 5d b5 ff ff       	call   80102eb0 <bitmap_modify>
      // page_delete(pgdir, (char *)a);
      // clear page table entry
      *pte = 0;
80107953:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107956:	83 c4 10             	add    $0x10,%esp
80107959:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for (; a < oldsz; a += PGSIZE)
8010795f:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107962:	77 ba                	ja     8010791e <deallocuvm.part.0+0x6e>
    }
  }
  return newsz;
}
80107964:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107967:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010796a:	5b                   	pop    %ebx
8010796b:	5e                   	pop    %esi
8010796c:	5f                   	pop    %edi
8010796d:	5d                   	pop    %ebp
8010796e:	c3                   	ret    
8010796f:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107970:	89 f9                	mov    %edi,%ecx
80107972:	81 e1 00 00 c0 ff    	and    $0xffc00000,%ecx
80107978:	8d b9 00 00 40 00    	lea    0x400000(%ecx),%edi
8010797e:	eb 99                	jmp    80107919 <deallocuvm.part.0+0x69>
        panic("kfree");
80107980:	83 ec 0c             	sub    $0xc,%esp
80107983:	68 87 83 10 80       	push   $0x80108387
80107988:	e8 03 8a ff ff       	call   80100390 <panic>
8010798d:	8d 76 00             	lea    0x0(%esi),%esi

80107990 <switchkvm>:
{
80107990:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80107994:	a1 e4 c5 11 80       	mov    0x8011c5e4,%eax
80107999:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010799e:	0f 22 d8             	mov    %eax,%cr3
}
801079a1:	c3                   	ret    
801079a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801079b0 <switchuvm>:
{
801079b0:	f3 0f 1e fb          	endbr32 
801079b4:	55                   	push   %ebp
801079b5:	89 e5                	mov    %esp,%ebp
801079b7:	57                   	push   %edi
801079b8:	56                   	push   %esi
801079b9:	53                   	push   %ebx
801079ba:	83 ec 1c             	sub    $0x1c,%esp
801079bd:	8b 75 08             	mov    0x8(%ebp),%esi
  if (p == 0)
801079c0:	85 f6                	test   %esi,%esi
801079c2:	0f 84 cb 00 00 00    	je     80107a93 <switchuvm+0xe3>
  if (p->kstack == 0)
801079c8:	8b 46 08             	mov    0x8(%esi),%eax
801079cb:	85 c0                	test   %eax,%eax
801079cd:	0f 84 da 00 00 00    	je     80107aad <switchuvm+0xfd>
  if (p->pgdir == 0)
801079d3:	8b 46 04             	mov    0x4(%esi),%eax
801079d6:	85 c0                	test   %eax,%eax
801079d8:	0f 84 c2 00 00 00    	je     80107aa0 <switchuvm+0xf0>
  pushcli();
801079de:	e8 7d d8 ff ff       	call   80105260 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801079e3:	e8 f8 cc ff ff       	call   801046e0 <mycpu>
801079e8:	89 c3                	mov    %eax,%ebx
801079ea:	e8 f1 cc ff ff       	call   801046e0 <mycpu>
801079ef:	89 c7                	mov    %eax,%edi
801079f1:	e8 ea cc ff ff       	call   801046e0 <mycpu>
801079f6:	83 c7 08             	add    $0x8,%edi
801079f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079fc:	e8 df cc ff ff       	call   801046e0 <mycpu>
80107a01:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107a04:	ba 67 00 00 00       	mov    $0x67,%edx
80107a09:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107a10:	83 c0 08             	add    $0x8,%eax
80107a13:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort)0xFFFF;
80107a1a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a1f:	83 c1 08             	add    $0x8,%ecx
80107a22:	c1 e8 18             	shr    $0x18,%eax
80107a25:	c1 e9 10             	shr    $0x10,%ecx
80107a28:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107a2e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107a34:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107a39:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a40:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107a45:	e8 96 cc ff ff       	call   801046e0 <mycpu>
80107a4a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a51:	e8 8a cc ff ff       	call   801046e0 <mycpu>
80107a56:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107a5a:	8b 5e 08             	mov    0x8(%esi),%ebx
80107a5d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a63:	e8 78 cc ff ff       	call   801046e0 <mycpu>
80107a68:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort)0xFFFF;
80107a6b:	e8 70 cc ff ff       	call   801046e0 <mycpu>
80107a70:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107a74:	b8 28 00 00 00       	mov    $0x28,%eax
80107a79:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir)); // switch to process's address space
80107a7c:	8b 46 04             	mov    0x4(%esi),%eax
80107a7f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a84:	0f 22 d8             	mov    %eax,%cr3
}
80107a87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a8a:	5b                   	pop    %ebx
80107a8b:	5e                   	pop    %esi
80107a8c:	5f                   	pop    %edi
80107a8d:	5d                   	pop    %ebp
  popcli();
80107a8e:	e9 1d d8 ff ff       	jmp    801052b0 <popcli>
    panic("switchuvm: no process");
80107a93:	83 ec 0c             	sub    $0xc,%esp
80107a96:	68 82 8d 10 80       	push   $0x80108d82
80107a9b:	e8 f0 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107aa0:	83 ec 0c             	sub    $0xc,%esp
80107aa3:	68 ad 8d 10 80       	push   $0x80108dad
80107aa8:	e8 e3 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107aad:	83 ec 0c             	sub    $0xc,%esp
80107ab0:	68 98 8d 10 80       	push   $0x80108d98
80107ab5:	e8 d6 88 ff ff       	call   80100390 <panic>
80107aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ac0 <inituvm>:
{
80107ac0:	f3 0f 1e fb          	endbr32 
80107ac4:	55                   	push   %ebp
80107ac5:	89 e5                	mov    %esp,%ebp
80107ac7:	57                   	push   %edi
80107ac8:	56                   	push   %esi
80107ac9:	53                   	push   %ebx
80107aca:	83 ec 1c             	sub    $0x1c,%esp
80107acd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ad0:	8b 75 10             	mov    0x10(%ebp),%esi
80107ad3:	8b 7d 08             	mov    0x8(%ebp),%edi
80107ad6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (sz >= PGSIZE)
80107ad9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107adf:	77 55                	ja     80107b36 <inituvm+0x76>
  mem = kalloc();
80107ae1:	e8 2a b7 ff ff       	call   80103210 <kalloc>
  memset(mem, 0, PGSIZE);
80107ae6:	83 ec 04             	sub    $0x4,%esp
80107ae9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107aee:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107af0:	6a 00                	push   $0x0
80107af2:	50                   	push   %eax
80107af3:	e8 78 d9 ff ff       	call   80105470 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107af8:	58                   	pop    %eax
80107af9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107aff:	5a                   	pop    %edx
80107b00:	6a 06                	push   $0x6
80107b02:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b07:	31 d2                	xor    %edx,%edx
80107b09:	50                   	push   %eax
80107b0a:	89 f8                	mov    %edi,%eax
80107b0c:	e8 0f fd ff ff       	call   80107820 <mappages>
  page_insert(pgdir, 0);
80107b11:	59                   	pop    %ecx
80107b12:	58                   	pop    %eax
80107b13:	6a 00                	push   $0x0
80107b15:	57                   	push   %edi
80107b16:	e8 35 af ff ff       	call   80102a50 <page_insert>
  memmove(mem, init, sz);
80107b1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b1e:	89 75 10             	mov    %esi,0x10(%ebp)
80107b21:	83 c4 10             	add    $0x10,%esp
80107b24:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107b27:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107b2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b2d:	5b                   	pop    %ebx
80107b2e:	5e                   	pop    %esi
80107b2f:	5f                   	pop    %edi
80107b30:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107b31:	e9 da d9 ff ff       	jmp    80105510 <memmove>
    panic("inituvm: more than a page");
80107b36:	83 ec 0c             	sub    $0xc,%esp
80107b39:	68 c1 8d 10 80       	push   $0x80108dc1
80107b3e:	e8 4d 88 ff ff       	call   80100390 <panic>
80107b43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b50 <loaduvm>:
{
80107b50:	f3 0f 1e fb          	endbr32 
80107b54:	55                   	push   %ebp
80107b55:	89 e5                	mov    %esp,%ebp
80107b57:	57                   	push   %edi
80107b58:	56                   	push   %esi
80107b59:	53                   	push   %ebx
80107b5a:	83 ec 1c             	sub    $0x1c,%esp
80107b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b60:	8b 75 18             	mov    0x18(%ebp),%esi
  if ((uint)addr % PGSIZE != 0)
80107b63:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107b68:	0f 85 99 00 00 00    	jne    80107c07 <loaduvm+0xb7>
  for (i = 0; i < sz; i += PGSIZE)
80107b6e:	01 f0                	add    %esi,%eax
80107b70:	89 f3                	mov    %esi,%ebx
80107b72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107b75:	8b 45 14             	mov    0x14(%ebp),%eax
80107b78:	01 f0                	add    %esi,%eax
80107b7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for (i = 0; i < sz; i += PGSIZE)
80107b7d:	85 f6                	test   %esi,%esi
80107b7f:	75 15                	jne    80107b96 <loaduvm+0x46>
80107b81:	eb 6d                	jmp    80107bf0 <loaduvm+0xa0>
80107b83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b87:	90                   	nop
80107b88:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107b8e:	89 f0                	mov    %esi,%eax
80107b90:	29 d8                	sub    %ebx,%eax
80107b92:	39 c6                	cmp    %eax,%esi
80107b94:	76 5a                	jbe    80107bf0 <loaduvm+0xa0>
    if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
80107b96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b99:	83 ec 04             	sub    $0x4,%esp
80107b9c:	6a 00                	push   $0x0
80107b9e:	29 d8                	sub    %ebx,%eax
80107ba0:	50                   	push   %eax
80107ba1:	ff 75 08             	pushl  0x8(%ebp)
80107ba4:	e8 e7 fb ff ff       	call   80107790 <walkpgdir>
80107ba9:	83 c4 10             	add    $0x10,%esp
80107bac:	85 c0                	test   %eax,%eax
80107bae:	74 4a                	je     80107bfa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107bb0:	8b 00                	mov    (%eax),%eax
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107bb2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if (sz - i < PGSIZE)
80107bb5:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107bba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if (sz - i < PGSIZE)
80107bbf:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107bc5:	0f 46 fb             	cmovbe %ebx,%edi
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107bc8:	29 d9                	sub    %ebx,%ecx
80107bca:	05 00 00 00 80       	add    $0x80000000,%eax
80107bcf:	57                   	push   %edi
80107bd0:	51                   	push   %ecx
80107bd1:	50                   	push   %eax
80107bd2:	ff 75 10             	pushl  0x10(%ebp)
80107bd5:	e8 86 9e ff ff       	call   80101a60 <readi>
80107bda:	83 c4 10             	add    $0x10,%esp
80107bdd:	39 f8                	cmp    %edi,%eax
80107bdf:	74 a7                	je     80107b88 <loaduvm+0x38>
}
80107be1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107be4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107be9:	5b                   	pop    %ebx
80107bea:	5e                   	pop    %esi
80107beb:	5f                   	pop    %edi
80107bec:	5d                   	pop    %ebp
80107bed:	c3                   	ret    
80107bee:	66 90                	xchg   %ax,%ax
80107bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107bf3:	31 c0                	xor    %eax,%eax
}
80107bf5:	5b                   	pop    %ebx
80107bf6:	5e                   	pop    %esi
80107bf7:	5f                   	pop    %edi
80107bf8:	5d                   	pop    %ebp
80107bf9:	c3                   	ret    
      panic("loaduvm: address should exist");
80107bfa:	83 ec 0c             	sub    $0xc,%esp
80107bfd:	68 db 8d 10 80       	push   $0x80108ddb
80107c02:	e8 89 87 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107c07:	83 ec 0c             	sub    $0xc,%esp
80107c0a:	68 64 8e 10 80       	push   $0x80108e64
80107c0f:	e8 7c 87 ff ff       	call   80100390 <panic>
80107c14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c1f:	90                   	nop

80107c20 <allocuvm>:
{
80107c20:	f3 0f 1e fb          	endbr32 
80107c24:	55                   	push   %ebp
80107c25:	89 e5                	mov    %esp,%ebp
80107c27:	57                   	push   %edi
80107c28:	56                   	push   %esi
80107c29:	53                   	push   %ebx
80107c2a:	83 ec 1c             	sub    $0x1c,%esp
  if (newsz >= KERNBASE)
80107c2d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107c30:	8b 7d 08             	mov    0x8(%ebp),%edi
  if (newsz >= KERNBASE)
80107c33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c36:	85 c0                	test   %eax,%eax
80107c38:	0f 88 c2 00 00 00    	js     80107d00 <allocuvm+0xe0>
  if (newsz < oldsz)
80107c3e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (newsz < oldsz)
80107c44:	0f 82 a6 00 00 00    	jb     80107cf0 <allocuvm+0xd0>
  a = PGROUNDUP(oldsz);
80107c4a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107c50:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a < newsz; a += PGSIZE)
80107c56:	39 75 10             	cmp    %esi,0x10(%ebp)
80107c59:	77 51                	ja     80107cac <allocuvm+0x8c>
80107c5b:	e9 93 00 00 00       	jmp    80107cf3 <allocuvm+0xd3>
    memset(mem, 0, PGSIZE);
80107c60:	83 ec 04             	sub    $0x4,%esp
80107c63:	68 00 10 00 00       	push   $0x1000
80107c68:	6a 00                	push   $0x0
80107c6a:	50                   	push   %eax
80107c6b:	e8 00 d8 ff ff       	call   80105470 <memset>
    if (mappages(pgdir, (char *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
80107c70:	58                   	pop    %eax
80107c71:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c77:	5a                   	pop    %edx
80107c78:	6a 06                	push   $0x6
80107c7a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c7f:	89 f2                	mov    %esi,%edx
80107c81:	50                   	push   %eax
80107c82:	89 f8                	mov    %edi,%eax
80107c84:	e8 97 fb ff ff       	call   80107820 <mappages>
80107c89:	83 c4 10             	add    $0x10,%esp
80107c8c:	85 c0                	test   %eax,%eax
80107c8e:	0f 88 84 00 00 00    	js     80107d18 <allocuvm+0xf8>
    page_insert(pgdir, a);
80107c94:	83 ec 08             	sub    $0x8,%esp
80107c97:	56                   	push   %esi
  for (; a < newsz; a += PGSIZE)
80107c98:	81 c6 00 10 00 00    	add    $0x1000,%esi
    page_insert(pgdir, a);
80107c9e:	57                   	push   %edi
80107c9f:	e8 ac ad ff ff       	call   80102a50 <page_insert>
  for (; a < newsz; a += PGSIZE)
80107ca4:	83 c4 10             	add    $0x10,%esp
80107ca7:	39 75 10             	cmp    %esi,0x10(%ebp)
80107caa:	76 47                	jbe    80107cf3 <allocuvm+0xd3>
    mem = kalloc();
80107cac:	e8 5f b5 ff ff       	call   80103210 <kalloc>
80107cb1:	89 c3                	mov    %eax,%ebx
    if (mem == 0)
80107cb3:	85 c0                	test   %eax,%eax
80107cb5:	75 a9                	jne    80107c60 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107cb7:	83 ec 0c             	sub    $0xc,%esp
80107cba:	68 f9 8d 10 80       	push   $0x80108df9
80107cbf:	e8 ec 89 ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz)
80107cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cc7:	83 c4 10             	add    $0x10,%esp
80107cca:	39 45 10             	cmp    %eax,0x10(%ebp)
80107ccd:	74 31                	je     80107d00 <allocuvm+0xe0>
80107ccf:	8b 55 10             	mov    0x10(%ebp),%edx
80107cd2:	89 c1                	mov    %eax,%ecx
80107cd4:	89 f8                	mov    %edi,%eax
80107cd6:	e8 d5 fb ff ff       	call   801078b0 <deallocuvm.part.0>
      return 0;
80107cdb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107ce2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ce5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ce8:	5b                   	pop    %ebx
80107ce9:	5e                   	pop    %esi
80107cea:	5f                   	pop    %edi
80107ceb:	5d                   	pop    %ebp
80107cec:	c3                   	ret    
80107ced:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80107cf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107cf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cf9:	5b                   	pop    %ebx
80107cfa:	5e                   	pop    %esi
80107cfb:	5f                   	pop    %edi
80107cfc:	5d                   	pop    %ebp
80107cfd:	c3                   	ret    
80107cfe:	66 90                	xchg   %ax,%ax
    return 0;
80107d00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107d07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d0d:	5b                   	pop    %ebx
80107d0e:	5e                   	pop    %esi
80107d0f:	5f                   	pop    %edi
80107d10:	5d                   	pop    %ebp
80107d11:	c3                   	ret    
80107d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107d18:	83 ec 0c             	sub    $0xc,%esp
80107d1b:	68 11 8e 10 80       	push   $0x80108e11
80107d20:	e8 8b 89 ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz)
80107d25:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d28:	83 c4 10             	add    $0x10,%esp
80107d2b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107d2e:	74 0c                	je     80107d3c <allocuvm+0x11c>
80107d30:	8b 55 10             	mov    0x10(%ebp),%edx
80107d33:	89 c1                	mov    %eax,%ecx
80107d35:	89 f8                	mov    %edi,%eax
80107d37:	e8 74 fb ff ff       	call   801078b0 <deallocuvm.part.0>
      kfree(mem);
80107d3c:	83 ec 0c             	sub    $0xc,%esp
80107d3f:	53                   	push   %ebx
80107d40:	e8 3b a8 ff ff       	call   80102580 <kfree>
      return 0;
80107d45:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107d4c:	83 c4 10             	add    $0x10,%esp
}
80107d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d55:	5b                   	pop    %ebx
80107d56:	5e                   	pop    %esi
80107d57:	5f                   	pop    %edi
80107d58:	5d                   	pop    %ebp
80107d59:	c3                   	ret    
80107d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107d60 <deallocuvm>:
{
80107d60:	f3 0f 1e fb          	endbr32 
80107d64:	55                   	push   %ebp
80107d65:	89 e5                	mov    %esp,%ebp
80107d67:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  if (newsz >= oldsz)
80107d70:	39 d1                	cmp    %edx,%ecx
80107d72:	73 0c                	jae    80107d80 <deallocuvm+0x20>
}
80107d74:	5d                   	pop    %ebp
80107d75:	e9 36 fb ff ff       	jmp    801078b0 <deallocuvm.part.0>
80107d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d80:	89 d0                	mov    %edx,%eax
80107d82:	5d                   	pop    %ebp
80107d83:	c3                   	ret    
80107d84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d8f:	90                   	nop

80107d90 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t *pgdir)
{
80107d90:	f3 0f 1e fb          	endbr32 
80107d94:	55                   	push   %ebp
80107d95:	89 e5                	mov    %esp,%ebp
80107d97:	57                   	push   %edi
80107d98:	56                   	push   %esi
80107d99:	53                   	push   %ebx
80107d9a:	83 ec 0c             	sub    $0xc,%esp
80107d9d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if (pgdir == 0)
80107da0:	85 f6                	test   %esi,%esi
80107da2:	74 55                	je     80107df9 <freevm+0x69>
  if (newsz >= oldsz)
80107da4:	31 c9                	xor    %ecx,%ecx
80107da6:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107dab:	89 f0                	mov    %esi,%eax
80107dad:	89 f3                	mov    %esi,%ebx
80107daf:	e8 fc fa ff ff       	call   801078b0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for (i = 0; i < NPDENTRIES; i++)
80107db4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107dba:	eb 0b                	jmp    80107dc7 <freevm+0x37>
80107dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107dc0:	83 c3 04             	add    $0x4,%ebx
80107dc3:	39 df                	cmp    %ebx,%edi
80107dc5:	74 23                	je     80107dea <freevm+0x5a>
  {
    if (pgdir[i] & PTE_P)
80107dc7:	8b 03                	mov    (%ebx),%eax
80107dc9:	a8 01                	test   $0x1,%al
80107dcb:	74 f3                	je     80107dc0 <freevm+0x30>
    {
      char *v = P2V(PTE_ADDR(pgdir[i]));
80107dcd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107dd2:	83 ec 0c             	sub    $0xc,%esp
80107dd5:	83 c3 04             	add    $0x4,%ebx
      char *v = P2V(PTE_ADDR(pgdir[i]));
80107dd8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107ddd:	50                   	push   %eax
80107dde:	e8 9d a7 ff ff       	call   80102580 <kfree>
80107de3:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < NPDENTRIES; i++)
80107de6:	39 df                	cmp    %ebx,%edi
80107de8:	75 dd                	jne    80107dc7 <freevm+0x37>
    }
  }
  kfree((char *)pgdir);
80107dea:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107df0:	5b                   	pop    %ebx
80107df1:	5e                   	pop    %esi
80107df2:	5f                   	pop    %edi
80107df3:	5d                   	pop    %ebp
  kfree((char *)pgdir);
80107df4:	e9 87 a7 ff ff       	jmp    80102580 <kfree>
    panic("freevm: no pgdir");
80107df9:	83 ec 0c             	sub    $0xc,%esp
80107dfc:	68 2d 8e 10 80       	push   $0x80108e2d
80107e01:	e8 8a 85 ff ff       	call   80100390 <panic>
80107e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e0d:	8d 76 00             	lea    0x0(%esi),%esi

80107e10 <setupkvm>:
{
80107e10:	f3 0f 1e fb          	endbr32 
80107e14:	55                   	push   %ebp
80107e15:	89 e5                	mov    %esp,%ebp
80107e17:	56                   	push   %esi
80107e18:	53                   	push   %ebx
  if ((pgdir = (pde_t *)kalloc()) == 0)
80107e19:	e8 f2 b3 ff ff       	call   80103210 <kalloc>
80107e1e:	89 c6                	mov    %eax,%esi
80107e20:	85 c0                	test   %eax,%eax
80107e22:	74 42                	je     80107e66 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107e24:	83 ec 04             	sub    $0x4,%esp
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e27:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107e2c:	68 00 10 00 00       	push   $0x1000
80107e31:	6a 00                	push   $0x0
80107e33:	50                   	push   %eax
80107e34:	e8 37 d6 ff ff       	call   80105470 <memset>
80107e39:	83 c4 10             	add    $0x10,%esp
                 (uint)k->phys_start, k->perm) < 0)
80107e3c:	8b 43 04             	mov    0x4(%ebx),%eax
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107e3f:	83 ec 08             	sub    $0x8,%esp
80107e42:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107e45:	ff 73 0c             	pushl  0xc(%ebx)
80107e48:	8b 13                	mov    (%ebx),%edx
80107e4a:	50                   	push   %eax
80107e4b:	29 c1                	sub    %eax,%ecx
80107e4d:	89 f0                	mov    %esi,%eax
80107e4f:	e8 cc f9 ff ff       	call   80107820 <mappages>
80107e54:	83 c4 10             	add    $0x10,%esp
80107e57:	85 c0                	test   %eax,%eax
80107e59:	78 15                	js     80107e70 <setupkvm+0x60>
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e5b:	83 c3 10             	add    $0x10,%ebx
80107e5e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107e64:	75 d6                	jne    80107e3c <setupkvm+0x2c>
}
80107e66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e69:	89 f0                	mov    %esi,%eax
80107e6b:	5b                   	pop    %ebx
80107e6c:	5e                   	pop    %esi
80107e6d:	5d                   	pop    %ebp
80107e6e:	c3                   	ret    
80107e6f:	90                   	nop
      freevm(pgdir);
80107e70:	83 ec 0c             	sub    $0xc,%esp
80107e73:	56                   	push   %esi
      return 0;
80107e74:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107e76:	e8 15 ff ff ff       	call   80107d90 <freevm>
      return 0;
80107e7b:	83 c4 10             	add    $0x10,%esp
}
80107e7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e81:	89 f0                	mov    %esi,%eax
80107e83:	5b                   	pop    %ebx
80107e84:	5e                   	pop    %esi
80107e85:	5d                   	pop    %ebp
80107e86:	c3                   	ret    
80107e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e8e:	66 90                	xchg   %ax,%ax

80107e90 <kvmalloc>:
{
80107e90:	f3 0f 1e fb          	endbr32 
80107e94:	55                   	push   %ebp
80107e95:	89 e5                	mov    %esp,%ebp
80107e97:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e9a:	e8 71 ff ff ff       	call   80107e10 <setupkvm>
80107e9f:	a3 e4 c5 11 80       	mov    %eax,0x8011c5e4
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80107ea4:	05 00 00 00 80       	add    $0x80000000,%eax
80107ea9:	0f 22 d8             	mov    %eax,%cr3
}
80107eac:	c9                   	leave  
80107ead:	c3                   	ret    
80107eae:	66 90                	xchg   %ax,%ax

80107eb0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva)
{
80107eb0:	f3 0f 1e fb          	endbr32 
80107eb4:	55                   	push   %ebp
80107eb5:	89 e5                	mov    %esp,%ebp
80107eb7:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107eba:	6a 00                	push   $0x0
80107ebc:	ff 75 0c             	pushl  0xc(%ebp)
80107ebf:	ff 75 08             	pushl  0x8(%ebp)
80107ec2:	e8 c9 f8 ff ff       	call   80107790 <walkpgdir>
  if (pte == 0)
80107ec7:	83 c4 10             	add    $0x10,%esp
80107eca:	85 c0                	test   %eax,%eax
80107ecc:	74 05                	je     80107ed3 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107ece:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107ed1:	c9                   	leave  
80107ed2:	c3                   	ret    
    panic("clearpteu");
80107ed3:	83 ec 0c             	sub    $0xc,%esp
80107ed6:	68 3e 8e 10 80       	push   $0x80108e3e
80107edb:	e8 b0 84 ff ff       	call   80100390 <panic>

80107ee0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *copyuvm(pde_t *pgdir, uint sz)
{
80107ee0:	f3 0f 1e fb          	endbr32 
80107ee4:	55                   	push   %ebp
80107ee5:	89 e5                	mov    %esp,%ebp
80107ee7:	57                   	push   %edi
80107ee8:	56                   	push   %esi
80107ee9:	53                   	push   %ebx
80107eea:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if ((d = setupkvm()) == 0)
80107eed:	e8 1e ff ff ff       	call   80107e10 <setupkvm>
80107ef2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107ef5:	85 c0                	test   %eax,%eax
80107ef7:	0f 84 af 00 00 00    	je     80107fac <copyuvm+0xcc>
    return 0;
  for (i = 0; i < sz; i += PGSIZE)
80107efd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107f00:	85 c9                	test   %ecx,%ecx
80107f02:	0f 84 a4 00 00 00    	je     80107fac <copyuvm+0xcc>
80107f08:	31 db                	xor    %ebx,%ebx
80107f0a:	eb 55                	jmp    80107f61 <copyuvm+0x81>
80107f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //   panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char *)P2V(pa), PGSIZE);
80107f10:	83 ec 04             	sub    $0x4,%esp
80107f13:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107f19:	68 00 10 00 00       	push   $0x1000
80107f1e:	57                   	push   %edi
80107f1f:	50                   	push   %eax
80107f20:	e8 eb d5 ff ff       	call   80105510 <memmove>
    if (mappages(d, (void *)i, PGSIZE, V2P(mem), flags) < 0)
80107f25:	58                   	pop    %eax
80107f26:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107f2c:	5a                   	pop    %edx
80107f2d:	ff 75 e0             	pushl  -0x20(%ebp)
80107f30:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f35:	89 da                	mov    %ebx,%edx
80107f37:	50                   	push   %eax
80107f38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f3b:	e8 e0 f8 ff ff       	call   80107820 <mappages>
80107f40:	83 c4 10             	add    $0x10,%esp
80107f43:	85 c0                	test   %eax,%eax
80107f45:	78 79                	js     80107fc0 <copyuvm+0xe0>
    {
      kfree(mem);
      goto bad;
    }
    page_insert(d, i);
80107f47:	83 ec 08             	sub    $0x8,%esp
80107f4a:	53                   	push   %ebx
  for (i = 0; i < sz; i += PGSIZE)
80107f4b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    page_insert(d, i);
80107f51:	ff 75 e4             	pushl  -0x1c(%ebp)
80107f54:	e8 f7 aa ff ff       	call   80102a50 <page_insert>
  for (i = 0; i < sz; i += PGSIZE)
80107f59:	83 c4 10             	add    $0x10,%esp
80107f5c:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107f5f:	76 4b                	jbe    80107fac <copyuvm+0xcc>
    if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
80107f61:	83 ec 04             	sub    $0x4,%esp
80107f64:	6a 00                	push   $0x0
80107f66:	53                   	push   %ebx
80107f67:	ff 75 08             	pushl  0x8(%ebp)
80107f6a:	e8 21 f8 ff ff       	call   80107790 <walkpgdir>
80107f6f:	83 c4 10             	add    $0x10,%esp
80107f72:	85 c0                	test   %eax,%eax
80107f74:	74 58                	je     80107fce <copyuvm+0xee>
    pa = PTE_ADDR(*pte);
80107f76:	8b 00                	mov    (%eax),%eax
80107f78:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107f7a:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    pa = PTE_ADDR(*pte);
80107f82:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if ((mem = kalloc()) == 0)
80107f88:	e8 83 b2 ff ff       	call   80103210 <kalloc>
80107f8d:	89 c6                	mov    %eax,%esi
80107f8f:	85 c0                	test   %eax,%eax
80107f91:	0f 85 79 ff ff ff    	jne    80107f10 <copyuvm+0x30>
  }
  // page insert in LRU linked list
  return d;

bad:
  freevm(d);
80107f97:	83 ec 0c             	sub    $0xc,%esp
80107f9a:	ff 75 e4             	pushl  -0x1c(%ebp)
80107f9d:	e8 ee fd ff ff       	call   80107d90 <freevm>
  return 0;
80107fa2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107fa9:	83 c4 10             	add    $0x10,%esp
}
80107fac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fb2:	5b                   	pop    %ebx
80107fb3:	5e                   	pop    %esi
80107fb4:	5f                   	pop    %edi
80107fb5:	5d                   	pop    %ebp
80107fb6:	c3                   	ret    
80107fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fbe:	66 90                	xchg   %ax,%ax
      kfree(mem);
80107fc0:	83 ec 0c             	sub    $0xc,%esp
80107fc3:	56                   	push   %esi
80107fc4:	e8 b7 a5 ff ff       	call   80102580 <kfree>
      goto bad;
80107fc9:	83 c4 10             	add    $0x10,%esp
80107fcc:	eb c9                	jmp    80107f97 <copyuvm+0xb7>
      panic("copyuvm: pte should exist");
80107fce:	83 ec 0c             	sub    $0xc,%esp
80107fd1:	68 48 8e 10 80       	push   $0x80108e48
80107fd6:	e8 b5 83 ff ff       	call   80100390 <panic>
80107fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107fdf:	90                   	nop

80107fe0 <uva2ka>:

// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva)
{
80107fe0:	f3 0f 1e fb          	endbr32 
80107fe4:	55                   	push   %ebp
80107fe5:	89 e5                	mov    %esp,%ebp
80107fe7:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107fea:	6a 00                	push   $0x0
80107fec:	ff 75 0c             	pushl  0xc(%ebp)
80107fef:	ff 75 08             	pushl  0x8(%ebp)
80107ff2:	e8 99 f7 ff ff       	call   80107790 <walkpgdir>
  if ((*pte & PTE_P) == 0)
    return 0;
  if ((*pte & PTE_U) == 0)
80107ff7:	83 c4 10             	add    $0x10,%esp
  if ((*pte & PTE_P) == 0)
80107ffa:	8b 00                	mov    (%eax),%eax
    return 0;
  return (char *)P2V(PTE_ADDR(*pte));
}
80107ffc:	c9                   	leave  
  if ((*pte & PTE_U) == 0)
80107ffd:	89 c2                	mov    %eax,%edx
  return (char *)P2V(PTE_ADDR(*pte));
80107fff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if ((*pte & PTE_U) == 0)
80108004:	83 e2 05             	and    $0x5,%edx
  return (char *)P2V(PTE_ADDR(*pte));
80108007:	05 00 00 00 80       	add    $0x80000000,%eax
8010800c:	83 fa 05             	cmp    $0x5,%edx
8010800f:	ba 00 00 00 00       	mov    $0x0,%edx
80108014:	0f 45 c2             	cmovne %edx,%eax
}
80108017:	c3                   	ret    
80108018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010801f:	90                   	nop

80108020 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108020:	f3 0f 1e fb          	endbr32 
80108024:	55                   	push   %ebp
80108025:	89 e5                	mov    %esp,%ebp
80108027:	57                   	push   %edi
80108028:	56                   	push   %esi
80108029:	53                   	push   %ebx
8010802a:	83 ec 0c             	sub    $0xc,%esp
8010802d:	8b 75 14             	mov    0x14(%ebp),%esi
80108030:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char *)p;
  while (len > 0)
80108033:	85 f6                	test   %esi,%esi
80108035:	75 3c                	jne    80108073 <copyout+0x53>
80108037:	eb 67                	jmp    801080a0 <copyout+0x80>
80108039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char *)va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108040:	8b 55 0c             	mov    0xc(%ebp),%edx
80108043:	89 fb                	mov    %edi,%ebx
80108045:	29 d3                	sub    %edx,%ebx
80108047:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if (n > len)
8010804d:	39 f3                	cmp    %esi,%ebx
8010804f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108052:	29 fa                	sub    %edi,%edx
80108054:	83 ec 04             	sub    $0x4,%esp
80108057:	01 c2                	add    %eax,%edx
80108059:	53                   	push   %ebx
8010805a:	ff 75 10             	pushl  0x10(%ebp)
8010805d:	52                   	push   %edx
8010805e:	e8 ad d4 ff ff       	call   80105510 <memmove>
    len -= n;
    buf += n;
80108063:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80108066:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while (len > 0)
8010806c:	83 c4 10             	add    $0x10,%esp
8010806f:	29 de                	sub    %ebx,%esi
80108071:	74 2d                	je     801080a0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80108073:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
80108075:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108078:	89 55 0c             	mov    %edx,0xc(%ebp)
8010807b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
80108081:	57                   	push   %edi
80108082:	ff 75 08             	pushl  0x8(%ebp)
80108085:	e8 56 ff ff ff       	call   80107fe0 <uva2ka>
    if (pa0 == 0)
8010808a:	83 c4 10             	add    $0x10,%esp
8010808d:	85 c0                	test   %eax,%eax
8010808f:	75 af                	jne    80108040 <copyout+0x20>
  }
  return 0;
}
80108091:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108094:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108099:	5b                   	pop    %ebx
8010809a:	5e                   	pop    %esi
8010809b:	5f                   	pop    %edi
8010809c:	5d                   	pop    %ebp
8010809d:	c3                   	ret    
8010809e:	66 90                	xchg   %ax,%ax
801080a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801080a3:	31 c0                	xor    %eax,%eax
}
801080a5:	5b                   	pop    %ebx
801080a6:	5e                   	pop    %esi
801080a7:	5f                   	pop    %edi
801080a8:	5d                   	pop    %ebp
801080a9:	c3                   	ret    
