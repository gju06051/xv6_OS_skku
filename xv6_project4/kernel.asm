
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
8010002d:	b8 70 3e 10 80       	mov    $0x80103e70,%eax
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
80100050:	68 e0 80 10 80       	push   $0x801080e0
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 a1 51 00 00       	call   80105200 <initlock>
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
80100092:	68 e7 80 10 80       	push   $0x801080e7
80100097:	50                   	push   %eax
80100098:	e8 23 50 00 00       	call   801050c0 <initsleeplock>
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
801000e8:	e8 93 52 00 00       	call   80105380 <acquire>
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
80100162:	e8 d9 52 00 00       	call   80105440 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 4f 00 00       	call   80105100 <acquiresleep>
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
801001a3:	68 ee 80 10 80       	push   $0x801080ee
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
801001c2:	e8 d9 4f 00 00       	call   801051a0 <holdingsleep>
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
801001e0:	68 ff 80 10 80       	push   $0x801080ff
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
80100203:	e8 98 4f 00 00       	call   801051a0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 48 4f 00 00       	call   80105160 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 5c 51 00 00       	call   80105380 <acquire>
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
80100270:	e9 cb 51 00 00       	jmp    80105440 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 06 81 10 80       	push   $0x80108106
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
801002b1:	e8 ca 50 00 00       	call   80105380 <acquire>
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
801002e5:	e8 56 4a 00 00       	call   80104d40 <sleep>
    while (input.r == input.w)
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if (myproc()->killed)
801002fa:	e8 91 44 00 00       	call   80104790 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 2d 51 00 00       	call   80105440 <release>
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
80100365:	e8 d6 50 00 00       	call   80105440 <release>
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
801003ad:	e8 1e 33 00 00       	call   801036d0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 0d 81 10 80       	push   $0x8010810d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 8b 8f 10 80 	movl   $0x80108f8b,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 3f 4e 00 00       	call   80105220 <getcallerpcs>
  for (i = 0; i < 10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 21 81 10 80       	push   $0x80108121
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
8010042a:	e8 31 68 00 00       	call   80106c60 <uartputc>
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
80100515:	e8 46 67 00 00       	call   80106c60 <uartputc>
    uartputc(' ');
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 3a 67 00 00       	call   80106c60 <uartputc>
    uartputc('\b');
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 2e 67 00 00       	call   80106c60 <uartputc>
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
80100561:	e8 ca 4f 00 00       	call   80105530 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 15 4f 00 00       	call   80105490 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 25 81 10 80       	push   $0x80108125
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
801005c9:	0f b6 92 50 81 10 80 	movzbl -0x7fef7eb0(%edx),%edx
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
8010065f:	e8 1c 4d 00 00       	call   80105380 <acquire>
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
80100697:	e8 a4 4d 00 00       	call   80105440 <release>
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
8010077d:	bb 38 81 10 80       	mov    $0x80108138,%ebx
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
801007bd:	e8 be 4b 00 00       	call   80105380 <acquire>
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
80100828:	e8 13 4c 00 00       	call   80105440 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 3f 81 10 80       	push   $0x8010813f
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
80100877:	e8 04 4b 00 00       	call   80105380 <acquire>
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
801009cf:	e8 6c 4a 00 00       	call   80105440 <release>
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
801009ff:	e9 ec 45 00 00       	jmp    80104ff0 <procdump>
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
80100a20:	e8 db 44 00 00       	call   80104f00 <wakeup>
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
80100a3a:	68 48 81 10 80       	push   $0x80108148
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 b7 47 00 00       	call   80105200 <initlock>

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
80100a90:	e8 fb 3c 00 00       	call   80104790 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 c0 30 00 00       	call   80103b60 <begin_op>

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
80100ae3:	e8 e8 30 00 00       	call   80103bd0 <end_op>
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
80100b0c:	e8 1f 73 00 00       	call   80107e30 <setupkvm>
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
80100b73:	e8 c8 70 00 00       	call   80107c40 <allocuvm>
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
80100ba9:	e8 c2 6f 00 00       	call   80107b70 <loaduvm>
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
80100beb:	e8 c0 71 00 00       	call   80107db0 <freevm>
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
80100c21:	e8 aa 2f 00 00       	call   80103bd0 <end_op>
  if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 09 70 00 00       	call   80107c40 <allocuvm>
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
80100c53:	e8 78 72 00 00       	call   80107ed0 <clearpteu>
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
80100ca3:	e8 e8 49 00 00       	call   80105690 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 d5 49 00 00       	call   80105690 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 74 73 00 00       	call   80108040 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 ca 70 00 00       	call   80107db0 <freevm>
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
80100d33:	e8 08 73 00 00       	call   80108040 <copyout>
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
80100d71:	e8 da 48 00 00       	call   80105650 <safestrcpy>
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
80100d9d:	e8 2e 6c 00 00       	call   801079d0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 06 70 00 00       	call   80107db0 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 17 2e 00 00       	call   80103bd0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 61 81 10 80       	push   $0x80108161
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
80100dea:	68 6d 81 10 80       	push   $0x8010816d
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 07 44 00 00       	call   80105200 <initlock>
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
80100e15:	e8 66 45 00 00       	call   80105380 <acquire>
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
80100e41:	e8 fa 45 00 00       	call   80105440 <release>
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
80100e5a:	e8 e1 45 00 00       	call   80105440 <release>
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
80100e83:	e8 f8 44 00 00       	call   80105380 <acquire>
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
80100ea0:	e8 9b 45 00 00       	call   80105440 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 74 81 10 80       	push   $0x80108174
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
80100ed5:	e8 a6 44 00 00       	call   80105380 <acquire>
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
80100f10:	e8 2b 45 00 00       	call   80105440 <release>

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
80100f3e:	e9 fd 44 00 00       	jmp    80105440 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 13 2c 00 00       	call   80103b60 <begin_op>
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
80100f62:	e9 69 2c 00 00       	jmp    80103bd0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 b2 33 00 00       	call   80104330 <pipeclose>
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
80100f8c:	68 7c 81 10 80       	push   $0x8010817c
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
80101065:	e9 66 34 00 00       	jmp    801044d0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 86 81 10 80       	push   $0x80108186
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
801010f1:	e8 da 2a 00 00       	call   80103bd0 <end_op>

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
8010111a:	e8 41 2a 00 00       	call   80103b60 <begin_op>
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
80101151:	e8 7a 2a 00 00       	call   80103bd0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 8f 81 10 80       	push   $0x8010818f
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
80101191:	e9 3a 32 00 00       	jmp    801043d0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 95 81 10 80       	push   $0x80108195
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
80101254:	68 9f 81 10 80       	push   $0x8010819f
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
8010126d:	e8 ce 2a 00 00       	call   80103d40 <log_write>
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
80101295:	e8 f6 41 00 00       	call   80105490 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 9e 2a 00 00       	call   80103d40 <log_write>
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
801012da:	e8 a1 40 00 00       	call   80105380 <acquire>
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
80101347:	e8 f4 40 00 00       	call   80105440 <release>

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
80101375:	e8 c6 40 00 00       	call   80105440 <release>
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
801013a2:	68 b5 81 10 80       	push   $0x801081b5
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
80101425:	e8 16 29 00 00       	call   80103d40 <log_write>
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
8010146b:	68 c5 81 10 80       	push   $0x801081c5
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
801014a5:	e8 86 40 00 00       	call   80105530 <memmove>
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
8010151a:	e8 21 28 00 00       	call   80103d40 <log_write>
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
80101534:	68 d8 81 10 80       	push   $0x801081d8
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
80101550:	68 eb 81 10 80       	push   $0x801081eb
80101555:	68 00 1a 11 80       	push   $0x80111a00
8010155a:	e8 a1 3c 00 00       	call   80105200 <initlock>
  for (i = 0; i < NINODE; i++)
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 f2 81 10 80       	push   $0x801081f2
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 44 3b 00 00       	call   801050c0 <initsleeplock>
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
801015c1:	68 90 82 10 80       	push   $0x80108290
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
8010165e:	e8 2d 3e 00 00       	call   80105490 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp); // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 cb 26 00 00       	call   80103d40 <log_write>
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
80101693:	68 f8 81 10 80       	push   $0x801081f8
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
80101705:	e8 26 3e 00 00       	call   80105530 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 2e 26 00 00       	call   80103d40 <log_write>
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
80101743:	e8 38 3c 00 00       	call   80105380 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101753:	e8 e8 3c 00 00       	call   80105440 <release>
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
80101786:	e8 75 39 00 00       	call   80105100 <acquiresleep>
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
801017f8:	e8 33 3d 00 00       	call   80105530 <memmove>
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
8010181d:	68 10 82 10 80       	push   $0x80108210
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 0a 82 10 80       	push   $0x8010820a
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
80101857:	e8 44 39 00 00       	call   801051a0 <holdingsleep>
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
80101873:	e9 e8 38 00 00       	jmp    80105160 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 1f 82 10 80       	push   $0x8010821f
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
801018a4:	e8 57 38 00 00       	call   80105100 <acquiresleep>
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
801018be:	e8 9d 38 00 00       	call   80105160 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801018ca:	e8 b1 3a 00 00       	call   80105380 <acquire>
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
801018e4:	e9 57 3b 00 00       	jmp    80105440 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 00 1a 11 80       	push   $0x80111a00
801018f8:	e8 83 3a 00 00       	call   80105380 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101907:	e8 34 3b 00 00       	call   80105440 <release>
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
80101b07:	e8 24 3a 00 00       	call   80105530 <memmove>
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
80101c03:	e8 28 39 00 00       	call   80105530 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 30 21 00 00       	call   80103d40 <log_write>
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
80101ca2:	e8 f9 38 00 00       	call   801055a0 <strncmp>
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
80101d05:	e8 96 38 00 00       	call   801055a0 <strncmp>
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
80101d4a:	68 39 82 10 80       	push   $0x80108239
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 27 82 10 80       	push   $0x80108227
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
80101d8a:	e8 01 2a 00 00       	call   80104790 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 00 1a 11 80       	push   $0x80111a00
80101d9c:	e8 df 35 00 00       	call   80105380 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101dac:	e8 8f 36 00 00       	call   80105440 <release>
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
80101e17:	e8 14 37 00 00       	call   80105530 <memmove>
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
80101ea3:	e8 88 36 00 00       	call   80105530 <memmove>
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
80101fd5:	e8 16 36 00 00       	call   801055f0 <strncpy>
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
80102013:	68 48 82 10 80       	push   $0x80108248
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 2a 8d 10 80       	push   $0x80108d2a
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
801020ca:	e8 61 34 00 00       	call   80105530 <memmove>
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
801020ea:	68 55 82 10 80       	push   $0x80108255
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
8010215a:	e8 d1 33 00 00       	call   80105530 <memmove>
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
80102182:	68 72 82 10 80       	push   $0x80108272
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
80102242:	68 ec 82 10 80       	push   $0x801082ec
80102247:	e8 44 e1 ff ff       	call   80100390 <panic>
    panic("idestart");
8010224c:	83 ec 0c             	sub    $0xc,%esp
8010224f:	68 e3 82 10 80       	push   $0x801082e3
80102254:	e8 37 e1 ff ff       	call   80100390 <panic>
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102260 <ideinit>:
{
80102260:	f3 0f 1e fb          	endbr32 
80102264:	55                   	push   %ebp
80102265:	89 e5                	mov    %esp,%ebp
80102267:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010226a:	68 fe 82 10 80       	push   $0x801082fe
8010226f:	68 80 b5 10 80       	push   $0x8010b580
80102274:	e8 87 2f 00 00       	call   80105200 <initlock>
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
80102302:	e8 79 30 00 00       	call   80105380 <acquire>

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
8010235d:	e8 9e 2b 00 00       	call   80104f00 <wakeup>

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
8010237b:	e8 c0 30 00 00       	call   80105440 <release>

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
801023a2:	e8 f9 2d 00 00       	call   801051a0 <holdingsleep>
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
801023dc:	e8 9f 2f 00 00       	call   80105380 <acquire>

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
80102429:	e8 12 29 00 00       	call   80104d40 <sleep>
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
80102446:	e9 f5 2f 00 00       	jmp    80105440 <release>
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
8010246a:	68 2d 83 10 80       	push   $0x8010832d
8010246f:	e8 1c df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	68 18 83 10 80       	push   $0x80108318
8010247c:	e8 0f df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102481:	83 ec 0c             	sub    $0xc,%esp
80102484:	68 02 83 10 80       	push   $0x80108302
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
801024de:	68 4c 83 10 80       	push   $0x8010834c
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
801025b5:	e8 d6 2e 00 00       	call   80105490 <memset>

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
801025db:	68 99 83 10 80       	push   $0x80108399
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
801025fb:	68 a7 83 10 80       	push   $0x801083a7
80102600:	e8 8b dd ff ff       	call   80100390 <panic>
      cprintf("physical addr is upper than PHYSTOP");
80102605:	83 ec 0c             	sub    $0xc,%esp
80102608:	68 30 84 10 80       	push   $0x80108430
8010260d:	e8 9e e0 ff ff       	call   801006b0 <cprintf>
80102612:	83 c4 10             	add    $0x10,%esp
80102615:	eb e1                	jmp    801025f8 <kfree+0x78>
      cprintf("virtual addr is under end\n");
80102617:	83 ec 0c             	sub    $0xc,%esp
8010261a:	68 7e 83 10 80       	push   $0x8010837e
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
8010268f:	68 ad 83 10 80       	push   $0x801083ad
80102694:	68 a0 36 11 80       	push   $0x801136a0
80102699:	e8 62 2b 00 00       	call   80105200 <initlock>
  initlock(&lru.lock, "lru");
8010269e:	58                   	pop    %eax
8010269f:	5a                   	pop    %edx
801026a0:	68 b2 83 10 80       	push   $0x801083b2
801026a5:	68 20 47 11 80       	push   $0x80114720
  kmem.use_lock = 0;
801026aa:	c7 05 d4 36 11 80 00 	movl   $0x0,0x801136d4
801026b1:	00 00 00 
  initlock(&lru.lock, "lru");
801026b4:	e8 47 2b 00 00       	call   80105200 <initlock>
  initlock(&bitmap.lock, "bitmap");
801026b9:	59                   	pop    %ecx
801026ba:	5e                   	pop    %esi
801026bb:	68 b6 83 10 80       	push   $0x801083b6
801026c0:	68 e0 36 11 80       	push   $0x801136e0
  lru.use_lock = 0;
801026c5:	c7 05 54 47 11 80 00 	movl   $0x0,0x80114754
801026cc:	00 00 00 
  initlock(&bitmap.lock, "bitmap");
801026cf:	e8 2c 2b 00 00       	call   80105200 <initlock>
  initlock(&swapout_lock.lock, "swap_control");
801026d4:	58                   	pop    %eax
801026d5:	5a                   	pop    %edx
801026d6:	68 bd 83 10 80       	push   $0x801083bd
801026db:	68 80 97 11 80       	push   $0x80119780
  bitmap.use_lock = 0;
801026e0:	c7 05 14 37 11 80 00 	movl   $0x0,0x80113714
801026e7:	00 00 00 
  initlock(&swapout_lock.lock, "swap_control");
801026ea:	e8 11 2b 00 00       	call   80105200 <initlock>
  initlock(&swapout_lock.lock, "swap_control");
801026ef:	59                   	pop    %ecx
801026f0:	5e                   	pop    %esi
801026f1:	68 bd 83 10 80       	push   $0x801083bd
801026f6:	68 80 97 11 80       	push   $0x80119780
  swapout_lock.use_lock = 0;
801026fb:	c7 05 b4 97 11 80 00 	movl   $0x0,0x801197b4
80102702:	00 00 00 
  initlock(&swapout_lock.lock, "swap_control");
80102705:	e8 f6 2a 00 00       	call   80105200 <initlock>
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
80102803:	e8 78 2b 00 00       	call   80105380 <acquire>
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
80102820:	e8 5b 2b 00 00       	call   80105380 <acquire>
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
8010283e:	e8 3d 2b 00 00       	call   80105380 <acquire>
80102843:	83 c4 10             	add    $0x10,%esp
80102846:	e9 f4 fe ff ff       	jmp    8010273f <kinit1+0xbf>
    release(&bitmap.lock);
8010284b:	83 ec 0c             	sub    $0xc,%esp
8010284e:	68 e0 36 11 80       	push   $0x801136e0
80102853:	e8 e8 2b 00 00       	call   80105440 <release>
80102858:	83 c4 10             	add    $0x10,%esp
8010285b:	e9 59 ff ff ff       	jmp    801027b9 <kinit1+0x139>
    release(&lru.lock);
80102860:	83 ec 0c             	sub    $0xc,%esp
80102863:	68 20 47 11 80       	push   $0x80114720
80102868:	e8 d3 2b 00 00       	call   80105440 <release>
8010286d:	83 c4 10             	add    $0x10,%esp
80102870:	e9 37 ff ff ff       	jmp    801027ac <kinit1+0x12c>
    release(&kmem.lock);
80102875:	83 ec 0c             	sub    $0xc,%esp
80102878:	68 a0 36 11 80       	push   $0x801136a0
8010287d:	e8 be 2b 00 00       	call   80105440 <release>
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
80102962:	68 9c 84 10 80       	push   $0x8010849c
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
80102985:	e8 26 4e 00 00       	call   801077b0 <walkpgdir>
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
801029a7:	68 54 84 10 80       	push   $0x80108454
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
801029e8:	e8 93 29 00 00       	call   80105380 <acquire>
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
80102a06:	e8 75 29 00 00       	call   80105380 <acquire>
80102a0b:	83 c4 10             	add    $0x10,%esp
80102a0e:	e9 22 ff ff ff       	jmp    80102935 <lru_print+0x25>
80102a13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a17:	90                   	nop
    release(&lru.lock);
80102a18:	83 ec 0c             	sub    $0xc,%esp
80102a1b:	68 20 47 11 80       	push   $0x80114720
80102a20:	e8 1b 2a 00 00       	call   80105440 <release>
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
80102a38:	e8 03 2a 00 00       	call   80105440 <release>
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
80102b09:	68 e4 84 10 80       	push   $0x801084e4
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
80102b88:	68 e4 84 10 80       	push   $0x801084e4
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
80102baa:	e8 01 4c 00 00       	call   801077b0 <walkpgdir>
80102baf:	59                   	pop    %ecx
80102bb0:	5b                   	pop    %ebx
80102bb1:	50                   	push   %eax
80102bb2:	68 ca 83 10 80       	push   $0x801083ca
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
80102bec:	68 24 85 10 80       	push   $0x80108524
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
80102c0e:	e9 2d 28 00 00       	jmp    80105440 <release>
80102c13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c17:	90                   	nop
    release(&lru.lock);
80102c18:	83 ec 0c             	sub    $0xc,%esp
80102c1b:	68 20 47 11 80       	push   $0x80114720
80102c20:	e8 1b 28 00 00       	call   80105440 <release>
80102c25:	83 c4 10             	add    $0x10,%esp
80102c28:	eb a9                	jmp    80102bd3 <page_insert+0x183>
80102c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102c30:	83 ec 0c             	sub    $0xc,%esp
80102c33:	68 a0 36 11 80       	push   $0x801136a0
80102c38:	e8 03 28 00 00       	call   80105440 <release>
80102c3d:	83 c4 10             	add    $0x10,%esp
80102c40:	eb 87                	jmp    80102bc9 <page_insert+0x179>
80102c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&bitmap.lock);
80102c48:	83 ec 0c             	sub    $0xc,%esp
80102c4b:	68 e0 36 11 80       	push   $0x801136e0
80102c50:	e8 2b 27 00 00       	call   80105380 <acquire>
80102c55:	83 c4 10             	add    $0x10,%esp
80102c58:	e9 2f fe ff ff       	jmp    80102a8c <page_insert+0x3c>
80102c5d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&lru.lock);
80102c60:	83 ec 0c             	sub    $0xc,%esp
80102c63:	68 20 47 11 80       	push   $0x80114720
80102c68:	e8 13 27 00 00       	call   80105380 <acquire>
80102c6d:	83 c4 10             	add    $0x10,%esp
80102c70:	e9 09 fe ff ff       	jmp    80102a7e <page_insert+0x2e>
80102c75:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102c78:	83 ec 0c             	sub    $0xc,%esp
80102c7b:	68 a0 36 11 80       	push   $0x801136a0
80102c80:	e8 fb 26 00 00       	call   80105380 <acquire>
80102c85:	83 c4 10             	add    $0x10,%esp
80102c88:	e9 e3 fd ff ff       	jmp    80102a70 <page_insert+0x20>
80102c8d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", lru.num_lru_pages, new_page->pgdir, new_page->vaddr);
80102c90:	56                   	push   %esi
80102c91:	57                   	push   %edi
80102c92:	52                   	push   %edx
80102c93:	68 24 85 10 80       	push   $0x80108524
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
80102cf2:	8b 75 08             	mov    0x8(%ebp),%esi
80102cf5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if (kmem.use_lock)
80102cf8:	85 c0                	test   %eax,%eax
80102cfa:	0f 85 48 01 00 00    	jne    80102e48 <page_delete+0x168>
    acquire(&kmem.lock);
  if (lru.use_lock)
80102d00:	8b 3d 54 47 11 80    	mov    0x80114754,%edi
80102d06:	85 ff                	test   %edi,%edi
80102d08:	0f 85 22 01 00 00    	jne    80102e30 <page_delete+0x150>
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
80102d43:	39 70 08             	cmp    %esi,0x8(%eax)
80102d46:	75 e8                	jne    80102d30 <page_delete+0x50>
80102d48:	8b 48 0c             	mov    0xc(%eax),%ecx
80102d4b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80102d51:	39 cb                	cmp    %ecx,%ebx
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
80102d81:	85 db                	test   %ebx,%ebx
80102d83:	0f 84 04 01 00 00    	je     80102e8d <page_delete+0x1ad>
        cprintf("Page Delete | num_lru_pages : %d, pgdir : %x, vaddr : %x\n", lru.num_lru_pages, p_page->pgdir, p_page->vaddr);
80102d89:	ff 70 0c             	pushl  0xc(%eax)
80102d8c:	ff 70 08             	pushl  0x8(%eax)
80102d8f:	52                   	push   %edx
80102d90:	68 28 86 10 80       	push   $0x80108628
80102d95:	e8 16 d9 ff ff       	call   801006b0 <cprintf>
80102d9a:	83 c4 10             	add    $0x10,%esp
      if (kmem.use_lock)
80102d9d:	8b 15 d4 36 11 80    	mov    0x801136d4,%edx
80102da3:	85 d2                	test   %edx,%edx
80102da5:	0f 85 fb 00 00 00    	jne    80102ea6 <page_delete+0x1c6>
      if (lru.use_lock)
80102dab:	a1 54 47 11 80       	mov    0x80114754,%eax
80102db0:	85 c0                	test   %eax,%eax
80102db2:	74 73                	je     80102e27 <page_delete+0x147>
        release(&lru.lock);
80102db4:	83 ec 0c             	sub    $0xc,%esp
80102db7:	68 20 47 11 80       	push   $0x80114720
80102dbc:	e8 7f 26 00 00       	call   80105440 <release>
80102dc1:	83 c4 10             	add    $0x10,%esp
      return 0;
80102dc4:	31 c0                	xor    %eax,%eax
80102dc6:	eb 5f                	jmp    80102e27 <page_delete+0x147>
80102dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcf:	90                   	nop
    }
  }
  cprintf("=================================LRU linked list TOP=================================\n");
80102dd0:	83 ec 0c             	sub    $0xc,%esp
80102dd3:	68 60 85 10 80       	push   $0x80108560
80102dd8:	e8 d3 d8 ff ff       	call   801006b0 <cprintf>
  cprintf("Page delete target, pgdir : %x, vaddr : %x, PTE\n", pgdir, vaddr, *walkpgdir(pgdir, vaddr, 0));
80102ddd:	83 c4 0c             	add    $0xc,%esp
80102de0:	6a 00                	push   $0x0
80102de2:	53                   	push   %ebx
80102de3:	56                   	push   %esi
80102de4:	e8 c7 49 00 00       	call   801077b0 <walkpgdir>
80102de9:	ff 30                	pushl  (%eax)
80102deb:	53                   	push   %ebx
80102dec:	56                   	push   %esi
80102ded:	68 b8 85 10 80       	push   $0x801085b8
80102df2:	e8 b9 d8 ff ff       	call   801006b0 <cprintf>
  if (kmem.use_lock)
80102df7:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
80102dfd:	83 c4 20             	add    $0x20,%esp
80102e00:	85 c9                	test   %ecx,%ecx
80102e02:	75 74                	jne    80102e78 <page_delete+0x198>
    release(&kmem.lock);
  if (lru.use_lock)
80102e04:	a1 54 47 11 80       	mov    0x80114754,%eax
80102e09:	85 c0                	test   %eax,%eax
80102e0b:	75 53                	jne    80102e60 <page_delete+0x180>
    release(&lru.lock);
  lru_print();
80102e0d:	e8 fe fa ff ff       	call   80102910 <lru_print>
  cprintf("=================================LRU linked list BOT=================================\n");
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	68 64 86 10 80       	push   $0x80108664
80102e1a:	e8 91 d8 ff ff       	call   801006b0 <cprintf>
  // for (int i = 0; i < PGSIZE; i++)
  // {
  //   cprintf("Bitmap[%d] : %x\n", i, bitmap[i]);
  // }

  return -1;
80102e1f:	83 c4 10             	add    $0x10,%esp
80102e22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e2a:	5b                   	pop    %ebx
80102e2b:	5e                   	pop    %esi
80102e2c:	5f                   	pop    %edi
80102e2d:	5d                   	pop    %ebp
80102e2e:	c3                   	ret    
80102e2f:	90                   	nop
    acquire(&lru.lock);
80102e30:	83 ec 0c             	sub    $0xc,%esp
80102e33:	68 20 47 11 80       	push   $0x80114720
80102e38:	e8 43 25 00 00       	call   80105380 <acquire>
80102e3d:	83 c4 10             	add    $0x10,%esp
80102e40:	e9 c9 fe ff ff       	jmp    80102d0e <page_delete+0x2e>
80102e45:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102e48:	83 ec 0c             	sub    $0xc,%esp
80102e4b:	68 a0 36 11 80       	push   $0x801136a0
80102e50:	e8 2b 25 00 00       	call   80105380 <acquire>
80102e55:	83 c4 10             	add    $0x10,%esp
80102e58:	e9 a3 fe ff ff       	jmp    80102d00 <page_delete+0x20>
80102e5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&lru.lock);
80102e60:	83 ec 0c             	sub    $0xc,%esp
80102e63:	68 20 47 11 80       	push   $0x80114720
80102e68:	e8 d3 25 00 00       	call   80105440 <release>
80102e6d:	83 c4 10             	add    $0x10,%esp
80102e70:	eb 9b                	jmp    80102e0d <page_delete+0x12d>
80102e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102e78:	83 ec 0c             	sub    $0xc,%esp
80102e7b:	68 a0 36 11 80       	push   $0x801136a0
80102e80:	e8 bb 25 00 00       	call   80105440 <release>
80102e85:	83 c4 10             	add    $0x10,%esp
80102e88:	e9 77 ff ff ff       	jmp    80102e04 <page_delete+0x124>
        cprintf("Page Delete | num_lru_pages : %d, pgdir : %x, vaddr : 0000\n", lru.num_lru_pages, p_page->pgdir);
80102e8d:	83 ec 04             	sub    $0x4,%esp
80102e90:	ff 70 08             	pushl  0x8(%eax)
80102e93:	52                   	push   %edx
80102e94:	68 ec 85 10 80       	push   $0x801085ec
80102e99:	e8 12 d8 ff ff       	call   801006b0 <cprintf>
80102e9e:	83 c4 10             	add    $0x10,%esp
80102ea1:	e9 f7 fe ff ff       	jmp    80102d9d <page_delete+0xbd>
        release(&kmem.lock);
80102ea6:	83 ec 0c             	sub    $0xc,%esp
80102ea9:	68 a0 36 11 80       	push   $0x801136a0
80102eae:	e8 8d 25 00 00       	call   80105440 <release>
80102eb3:	83 c4 10             	add    $0x10,%esp
80102eb6:	e9 f0 fe ff ff       	jmp    80102dab <page_delete+0xcb>
80102ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ebf:	90                   	nop

80102ec0 <bitmap_modify>:

  panic("swap out err not found zero page");
}

void bitmap_modify(int bitmap_offset, int set)
{
80102ec0:	f3 0f 1e fb          	endbr32 
80102ec4:	55                   	push   %ebp
80102ec5:	89 e5                	mov    %esp,%ebp
80102ec7:	57                   	push   %edi
80102ec8:	56                   	push   %esi
80102ec9:	53                   	push   %ebx
80102eca:	83 ec 0c             	sub    $0xc,%esp
  if (kmem.use_lock)
80102ecd:	a1 d4 36 11 80       	mov    0x801136d4,%eax
{
80102ed2:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ed5:	8b 75 0c             	mov    0xc(%ebp),%esi
  if (kmem.use_lock)
80102ed8:	85 c0                	test   %eax,%eax
80102eda:	0f 85 90 00 00 00    	jne    80102f70 <bitmap_modify+0xb0>
    acquire(&kmem.lock);
  if (lru.use_lock)
80102ee0:	a1 54 47 11 80       	mov    0x80114754,%eax
80102ee5:	85 c0                	test   %eax,%eax
80102ee7:	0f 85 a0 00 00 00    	jne    80102f8d <bitmap_modify+0xcd>
    acquire(&lru.lock);
  if (bitmap.use_lock)
80102eed:	8b 3d 14 37 11 80    	mov    0x80113714,%edi
80102ef3:	85 ff                	test   %edi,%edi
80102ef5:	0f 85 b0 00 00 00    	jne    80102fab <bitmap_modify+0xeb>
    acquire(&bitmap.lock);

  if (set == 0) // unset
80102efb:	85 db                	test   %ebx,%ebx
80102efd:	8d 43 07             	lea    0x7(%ebx),%eax
80102f00:	89 df                	mov    %ebx,%edi
80102f02:	0f 49 c3             	cmovns %ebx,%eax
80102f05:	c1 ff 1f             	sar    $0x1f,%edi
80102f08:	c1 ef 1d             	shr    $0x1d,%edi
80102f0b:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
80102f0e:	c1 f8 03             	sar    $0x3,%eax
80102f11:	bb 01 00 00 00       	mov    $0x1,%ebx
80102f16:	83 e1 07             	and    $0x7,%ecx
80102f19:	0f b6 90 18 37 11 80 	movzbl -0x7feec8e8(%eax),%edx
80102f20:	29 f9                	sub    %edi,%ecx
80102f22:	d3 e3                	shl    %cl,%ebx
80102f24:	89 d9                	mov    %ebx,%ecx
  {
    bitmap.bitmap_arr[bitmap_offset / 8] = bitmap.bitmap_arr[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102f26:	89 d3                	mov    %edx,%ebx
80102f28:	09 cb                	or     %ecx,%ebx
80102f2a:	f7 d1                	not    %ecx
80102f2c:	21 ca                	and    %ecx,%edx
80102f2e:	85 f6                	test   %esi,%esi
  }
  else // set
  {
    bitmap.bitmap_arr[bitmap_offset / 8] = bitmap.bitmap_arr[bitmap_offset / 8] | (1 << bitmap_offset % 8);
  }
  if (kmem.use_lock)
80102f30:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
    bitmap.bitmap_arr[bitmap_offset / 8] = bitmap.bitmap_arr[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102f36:	0f 45 d3             	cmovne %ebx,%edx
80102f39:	88 90 18 37 11 80    	mov    %dl,-0x7feec8e8(%eax)
  if (kmem.use_lock)
80102f3f:	85 c9                	test   %ecx,%ecx
80102f41:	0f 85 a9 00 00 00    	jne    80102ff0 <bitmap_modify+0x130>
    release(&kmem.lock);
  if (lru.use_lock)
80102f47:	8b 15 54 47 11 80    	mov    0x80114754,%edx
80102f4d:	85 d2                	test   %edx,%edx
80102f4f:	0f 85 83 00 00 00    	jne    80102fd8 <bitmap_modify+0x118>
    release(&lru.lock);
  if (bitmap.use_lock)
80102f55:	a1 14 37 11 80       	mov    0x80113714,%eax
80102f5a:	85 c0                	test   %eax,%eax
80102f5c:	75 62                	jne    80102fc0 <bitmap_modify+0x100>
    release(&bitmap.lock);
}
80102f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f61:	5b                   	pop    %ebx
80102f62:	5e                   	pop    %esi
80102f63:	5f                   	pop    %edi
80102f64:	5d                   	pop    %ebp
80102f65:	c3                   	ret    
80102f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f6d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102f70:	83 ec 0c             	sub    $0xc,%esp
80102f73:	68 a0 36 11 80       	push   $0x801136a0
80102f78:	e8 03 24 00 00       	call   80105380 <acquire>
  if (lru.use_lock)
80102f7d:	a1 54 47 11 80       	mov    0x80114754,%eax
    acquire(&kmem.lock);
80102f82:	83 c4 10             	add    $0x10,%esp
  if (lru.use_lock)
80102f85:	85 c0                	test   %eax,%eax
80102f87:	0f 84 60 ff ff ff    	je     80102eed <bitmap_modify+0x2d>
    acquire(&lru.lock);
80102f8d:	83 ec 0c             	sub    $0xc,%esp
80102f90:	68 20 47 11 80       	push   $0x80114720
80102f95:	e8 e6 23 00 00       	call   80105380 <acquire>
  if (bitmap.use_lock)
80102f9a:	8b 3d 14 37 11 80    	mov    0x80113714,%edi
    acquire(&lru.lock);
80102fa0:	83 c4 10             	add    $0x10,%esp
  if (bitmap.use_lock)
80102fa3:	85 ff                	test   %edi,%edi
80102fa5:	0f 84 50 ff ff ff    	je     80102efb <bitmap_modify+0x3b>
    acquire(&bitmap.lock);
80102fab:	83 ec 0c             	sub    $0xc,%esp
80102fae:	68 e0 36 11 80       	push   $0x801136e0
80102fb3:	e8 c8 23 00 00       	call   80105380 <acquire>
80102fb8:	83 c4 10             	add    $0x10,%esp
80102fbb:	e9 3b ff ff ff       	jmp    80102efb <bitmap_modify+0x3b>
    release(&bitmap.lock);
80102fc0:	c7 45 08 e0 36 11 80 	movl   $0x801136e0,0x8(%ebp)
}
80102fc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fca:	5b                   	pop    %ebx
80102fcb:	5e                   	pop    %esi
80102fcc:	5f                   	pop    %edi
80102fcd:	5d                   	pop    %ebp
    release(&bitmap.lock);
80102fce:	e9 6d 24 00 00       	jmp    80105440 <release>
80102fd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fd7:	90                   	nop
    release(&lru.lock);
80102fd8:	83 ec 0c             	sub    $0xc,%esp
80102fdb:	68 20 47 11 80       	push   $0x80114720
80102fe0:	e8 5b 24 00 00       	call   80105440 <release>
80102fe5:	83 c4 10             	add    $0x10,%esp
80102fe8:	e9 68 ff ff ff       	jmp    80102f55 <bitmap_modify+0x95>
80102fed:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102ff0:	83 ec 0c             	sub    $0xc,%esp
80102ff3:	68 a0 36 11 80       	push   $0x801136a0
80102ff8:	e8 43 24 00 00       	call   80105440 <release>
80102ffd:	83 c4 10             	add    $0x10,%esp
80103000:	e9 42 ff ff ff       	jmp    80102f47 <bitmap_modify+0x87>
80103005:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010300c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103010 <swapout>:
{
80103010:	f3 0f 1e fb          	endbr32 
80103014:	55                   	push   %ebp
80103015:	89 e5                	mov    %esp,%ebp
80103017:	57                   	push   %edi
80103018:	56                   	push   %esi
80103019:	53                   	push   %ebx
8010301a:	83 ec 1c             	sub    $0x1c,%esp
  if (lru.num_lru_pages == 0)
8010301d:	8b 1d 60 97 11 80    	mov    0x80119760,%ebx
80103023:	85 db                	test   %ebx,%ebx
80103025:	0f 84 e4 01 00 00    	je     8010320f <swapout+0x1ff>
  for (int i = 0; i < PGSIZE; i++)
8010302b:	31 f6                	xor    %esi,%esi
8010302d:	8d 76 00             	lea    0x0(%esi),%esi
      if ((set_bit & bitmap.bitmap_arr[i]) == 0)
80103030:	0f b6 8e 18 37 11 80 	movzbl -0x7feec8e8(%esi),%ecx
    for (int j = 0; j < 8; j++)
80103037:	31 c0                	xor    %eax,%eax
    set_bit = 1;
80103039:	ba 01 00 00 00       	mov    $0x1,%edx
8010303e:	66 90                	xchg   %ax,%ax
      if ((set_bit & bitmap.bitmap_arr[i]) == 0)
80103040:	84 d1                	test   %dl,%cl
80103042:	74 24                	je     80103068 <swapout+0x58>
    for (int j = 0; j < 8; j++)
80103044:	83 c0 01             	add    $0x1,%eax
        set_bit = set_bit << 1;
80103047:	01 d2                	add    %edx,%edx
    for (int j = 0; j < 8; j++)
80103049:	83 f8 08             	cmp    $0x8,%eax
8010304c:	75 f2                	jne    80103040 <swapout+0x30>
  for (int i = 0; i < PGSIZE; i++)
8010304e:	83 c6 01             	add    $0x1,%esi
80103051:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80103057:	75 d7                	jne    80103030 <swapout+0x20>
80103059:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103060:	eb 0c                	jmp    8010306e <swapout+0x5e>
80103062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bitmap_offset = 8 * i + j;
80103068:	8d 04 f0             	lea    (%eax,%esi,8),%eax
8010306b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for (int i = 0; i < k + 10; i++)
8010306e:	83 c3 09             	add    $0x9,%ebx
80103071:	89 d8                	mov    %ebx,%eax
80103073:	0f 88 78 01 00 00    	js     801031f1 <swapout+0x1e1>
80103079:	8b 3d 58 97 11 80    	mov    0x80119758,%edi
8010307f:	31 db                	xor    %ebx,%ebx
80103081:	89 c6                	mov    %eax,%esi
80103083:	eb 21                	jmp    801030a6 <swapout+0x96>
80103085:	8d 76 00             	lea    0x0(%esi),%esi
      *pte = *pte & (~PTE_A);
80103088:	83 e2 df             	and    $0xffffffdf,%edx
  for (int i = 0; i < k + 10; i++)
8010308b:	83 c3 01             	add    $0x1,%ebx
      *pte = *pte & (~PTE_A);
8010308e:	89 10                	mov    %edx,(%eax)
      lru.page_lru_head = lru.page_lru_head->prev;
80103090:	a1 58 97 11 80       	mov    0x80119758,%eax
80103095:	8b 78 04             	mov    0x4(%eax),%edi
80103098:	89 3d 58 97 11 80    	mov    %edi,0x80119758
  for (int i = 0; i < k + 10; i++)
8010309e:	39 de                	cmp    %ebx,%esi
801030a0:	0f 8c 4b 01 00 00    	jl     801031f1 <swapout+0x1e1>
    pte = walkpgdir(p_page->pgdir, p_page->vaddr, 0);
801030a6:	83 ec 04             	sub    $0x4,%esp
801030a9:	6a 00                	push   $0x0
801030ab:	ff 77 0c             	pushl  0xc(%edi)
801030ae:	ff 77 08             	pushl  0x8(%edi)
801030b1:	e8 fa 46 00 00       	call   801077b0 <walkpgdir>
    if ((*pte != 0) && ((*pte & PTE_A) == 0)) // ref bit low
801030b6:	83 c4 10             	add    $0x10,%esp
    mem = P2V((PTE_ADDR(*pte)));
801030b9:	8b 10                	mov    (%eax),%edx
    if ((*pte != 0) && ((*pte & PTE_A) == 0)) // ref bit low
801030bb:	85 d2                	test   %edx,%edx
801030bd:	74 c9                	je     80103088 <swapout+0x78>
801030bf:	f6 c2 20             	test   $0x20,%dl
801030c2:	75 c4                	jne    80103088 <swapout+0x78>
801030c4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801030c7:	89 c6                	mov    %eax,%esi
801030c9:	89 d0                	mov    %edx,%eax
      if (p_page->vaddr == 0)
801030cb:	8b 57 0c             	mov    0xc(%edi),%edx
801030ce:	89 c1                	mov    %eax,%ecx
801030d0:	c1 e3 0c             	shl    $0xc,%ebx
801030d3:	81 e1 fe 0f 00 00    	and    $0xffe,%ecx
801030d9:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801030dc:	09 d9                	or     %ebx,%ecx
801030de:	8b 5f 08             	mov    0x8(%edi),%ebx
801030e1:	85 d2                	test   %edx,%edx
801030e3:	0f 84 ed 00 00 00    	je     801031d6 <swapout+0x1c6>
        cprintf("Swapout victim page | pgdir : %x, vaddr : %x, PTE : %x, Modified PTE : %x\n", p_page->pgdir, p_page->vaddr, *pte, (((bitmap_offset << 12) | PTE_FLAGS(*pte)) & (~PTE_P)));
801030e9:	83 ec 0c             	sub    $0xc,%esp
801030ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
801030ef:	51                   	push   %ecx
801030f0:	50                   	push   %eax
801030f1:	52                   	push   %edx
801030f2:	53                   	push   %ebx
801030f3:	68 5c 87 10 80       	push   $0x8010875c
801030f8:	e8 b3 d5 ff ff       	call   801006b0 <cprintf>
801030fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103100:	83 c4 20             	add    $0x20,%esp
    mem = P2V((PTE_ADDR(*pte)));
80103103:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      swapwrite(mem, bitmap_offset);
80103108:	83 ec 08             	sub    $0x8,%esp
8010310b:	ff 75 e4             	pushl  -0x1c(%ebp)
    mem = P2V((PTE_ADDR(*pte)));
8010310e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      swapwrite(mem, bitmap_offset);
80103114:	53                   	push   %ebx
80103115:	e8 e6 ef ff ff       	call   80102100 <swapwrite>
      *pte = (bitmap_offset << 12) | PTE_FLAGS(*pte);
8010311a:	8b 06                	mov    (%esi),%eax
8010311c:	25 fe 0f 00 00       	and    $0xffe,%eax
      *pte = *pte & (~PTE_P);
80103121:	0b 45 e0             	or     -0x20(%ebp),%eax
80103124:	89 06                	mov    %eax,(%esi)
      lcr3(V2P(p_page->pgdir));
80103126:	8b 47 08             	mov    0x8(%edi),%eax
80103129:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010312e:	0f 22 d8             	mov    %eax,%cr3
      lru.page_lru_head = lru.page_lru_head->prev;
80103131:	a1 58 97 11 80       	mov    0x80119758,%eax
80103136:	8b 48 04             	mov    0x4(%eax),%ecx
80103139:	89 0d 58 97 11 80    	mov    %ecx,0x80119758
      lru.page_lru_head->next = p_page->next;
8010313f:	8b 07                	mov    (%edi),%eax
80103141:	89 01                	mov    %eax,(%ecx)
      p_page->next->prev = lru.page_lru_head;
80103143:	8b 0d 58 97 11 80    	mov    0x80119758,%ecx
80103149:	89 48 04             	mov    %ecx,0x4(%eax)
      bitmap_modify(bitmap_offset, 1);
8010314c:	59                   	pop    %ecx
8010314d:	5e                   	pop    %esi
8010314e:	6a 01                	push   $0x1
80103150:	ff 75 e4             	pushl  -0x1c(%ebp)
80103153:	e8 68 fd ff ff       	call   80102ec0 <bitmap_modify>
      lru.num_lru_pages--;
80103158:	83 2d 60 97 11 80 01 	subl   $0x1,0x80119760
      p_page->use = 0;
8010315f:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
      kfree(mem);
80103166:	89 1c 24             	mov    %ebx,(%esp)
80103169:	e8 12 f4 ff ff       	call   80102580 <kfree>
      if (kmem.use_lock)
8010316e:	8b 3d d4 36 11 80    	mov    0x801136d4,%edi
80103174:	83 c4 10             	add    $0x10,%esp
80103177:	85 ff                	test   %edi,%edi
80103179:	75 49                	jne    801031c4 <swapout+0x1b4>
      if (lru.use_lock)
8010317b:	8b 15 54 47 11 80    	mov    0x80114754,%edx
80103181:	85 d2                	test   %edx,%edx
80103183:	75 2d                	jne    801031b2 <swapout+0x1a2>
      if (bitmap.use_lock)
80103185:	a1 14 37 11 80       	mov    0x80113714,%eax
8010318a:	85 c0                	test   %eax,%eax
8010318c:	75 0a                	jne    80103198 <swapout+0x188>
}
8010318e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103191:	89 d8                	mov    %ebx,%eax
80103193:	5b                   	pop    %ebx
80103194:	5e                   	pop    %esi
80103195:	5f                   	pop    %edi
80103196:	5d                   	pop    %ebp
80103197:	c3                   	ret    
        acquire(&bitmap.lock);
80103198:	83 ec 0c             	sub    $0xc,%esp
8010319b:	68 e0 36 11 80       	push   $0x801136e0
801031a0:	e8 db 21 00 00       	call   80105380 <acquire>
801031a5:	83 c4 10             	add    $0x10,%esp
}
801031a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031ab:	89 d8                	mov    %ebx,%eax
801031ad:	5b                   	pop    %ebx
801031ae:	5e                   	pop    %esi
801031af:	5f                   	pop    %edi
801031b0:	5d                   	pop    %ebp
801031b1:	c3                   	ret    
        acquire(&lru.lock);
801031b2:	83 ec 0c             	sub    $0xc,%esp
801031b5:	68 20 47 11 80       	push   $0x80114720
801031ba:	e8 c1 21 00 00       	call   80105380 <acquire>
801031bf:	83 c4 10             	add    $0x10,%esp
801031c2:	eb c1                	jmp    80103185 <swapout+0x175>
        acquire(&kmem.lock);
801031c4:	83 ec 0c             	sub    $0xc,%esp
801031c7:	68 a0 36 11 80       	push   $0x801136a0
801031cc:	e8 af 21 00 00       	call   80105380 <acquire>
801031d1:	83 c4 10             	add    $0x10,%esp
801031d4:	eb a5                	jmp    8010317b <swapout+0x16b>
        cprintf("Swapout victim page | pgdir : %x,vaddr : 0000, PTE : %x, Modified PTE : %x\n", p_page->pgdir, *pte, (((bitmap_offset << 12) | PTE_FLAGS(*pte)) & (~PTE_P)));
801031d6:	51                   	push   %ecx
801031d7:	50                   	push   %eax
801031d8:	53                   	push   %ebx
801031d9:	68 10 87 10 80       	push   $0x80108710
801031de:	89 45 dc             	mov    %eax,-0x24(%ebp)
801031e1:	e8 ca d4 ff ff       	call   801006b0 <cprintf>
801031e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	e9 12 ff ff ff       	jmp    80103103 <swapout+0xf3>
  cprintf("================swap out err================\n");
801031f1:	83 ec 0c             	sub    $0xc,%esp
801031f4:	68 bc 86 10 80       	push   $0x801086bc
801031f9:	e8 b2 d4 ff ff       	call   801006b0 <cprintf>
  lru_print();
801031fe:	e8 0d f7 ff ff       	call   80102910 <lru_print>
  panic("swap out err not found zero page");
80103203:	c7 04 24 ec 86 10 80 	movl   $0x801086ec,(%esp)
8010320a:	e8 81 d1 ff ff       	call   80100390 <panic>
    panic("OOM Error");
8010320f:	83 ec 0c             	sub    $0xc,%esp
80103212:	68 d4 83 10 80       	push   $0x801083d4
80103217:	e8 74 d1 ff ff       	call   80100390 <panic>
8010321c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103220 <kalloc>:
{
80103220:	f3 0f 1e fb          	endbr32 
80103224:	55                   	push   %ebp
80103225:	89 e5                	mov    %esp,%ebp
80103227:	53                   	push   %ebx
80103228:	83 ec 04             	sub    $0x4,%esp
  if (kmem.use_lock)
8010322b:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80103230:	85 c0                	test   %eax,%eax
80103232:	0f 85 30 01 00 00    	jne    80103368 <kalloc+0x148>
  if (lru.use_lock)
80103238:	a1 54 47 11 80       	mov    0x80114754,%eax
8010323d:	85 c0                	test   %eax,%eax
8010323f:	0f 85 0b 01 00 00    	jne    80103350 <kalloc+0x130>
  if (bitmap.use_lock)
80103245:	a1 14 37 11 80       	mov    0x80113714,%eax
8010324a:	85 c0                	test   %eax,%eax
8010324c:	0f 85 e6 00 00 00    	jne    80103338 <kalloc+0x118>
  r = kmem.freelist;
80103252:	8b 1d d8 36 11 80    	mov    0x801136d8,%ebx
  lru.num_free_pages--;
80103258:	83 2d 5c 97 11 80 01 	subl   $0x1,0x8011975c
  if (r)
8010325f:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80103264:	85 db                	test   %ebx,%ebx
80103266:	74 30                	je     80103298 <kalloc+0x78>
    kmem.freelist = r->next;
80103268:	8b 13                	mov    (%ebx),%edx
8010326a:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
    if (kmem.use_lock)
80103270:	85 c0                	test   %eax,%eax
80103272:	75 6f                	jne    801032e3 <kalloc+0xc3>
    if (lru.use_lock)
80103274:	8b 15 54 47 11 80    	mov    0x80114754,%edx
8010327a:	85 d2                	test   %edx,%edx
8010327c:	75 7f                	jne    801032fd <kalloc+0xdd>
    if (bitmap.use_lock)
8010327e:	a1 14 37 11 80       	mov    0x80113714,%eax
80103283:	85 c0                	test   %eax,%eax
80103285:	0f 85 8f 00 00 00    	jne    8010331a <kalloc+0xfa>
}
8010328b:	89 d8                	mov    %ebx,%eax
8010328d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103290:	c9                   	leave  
80103291:	c3                   	ret    
80103292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (kmem.use_lock)
80103298:	85 c0                	test   %eax,%eax
8010329a:	0f 85 e0 00 00 00    	jne    80103380 <kalloc+0x160>
    if (lru.use_lock)
801032a0:	a1 54 47 11 80       	mov    0x80114754,%eax
801032a5:	85 c0                	test   %eax,%eax
801032a7:	0f 85 03 01 00 00    	jne    801033b0 <kalloc+0x190>
    if (bitmap.use_lock)
801032ad:	8b 1d 14 37 11 80    	mov    0x80113714,%ebx
801032b3:	85 db                	test   %ebx,%ebx
801032b5:	0f 85 dd 00 00 00    	jne    80103398 <kalloc+0x178>
    cprintf("No free physical page -> ");
801032bb:	83 ec 0c             	sub    $0xc,%esp
801032be:	68 de 83 10 80       	push   $0x801083de
801032c3:	e8 e8 d3 ff ff       	call   801006b0 <cprintf>
    r = (struct run *)swapout();
801032c8:	e8 43 fd ff ff       	call   80103010 <swapout>
    if (kmem.use_lock)
801032cd:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
801032d3:	83 c4 10             	add    $0x10,%esp
    r = (struct run *)swapout();
801032d6:	89 c3                	mov    %eax,%ebx
    kmem.freelist = r->next;
801032d8:	8b 00                	mov    (%eax),%eax
801032da:	a3 d8 36 11 80       	mov    %eax,0x801136d8
    if (kmem.use_lock)
801032df:	85 c9                	test   %ecx,%ecx
801032e1:	74 91                	je     80103274 <kalloc+0x54>
      release(&kmem.lock);
801032e3:	83 ec 0c             	sub    $0xc,%esp
801032e6:	68 a0 36 11 80       	push   $0x801136a0
801032eb:	e8 50 21 00 00       	call   80105440 <release>
    if (lru.use_lock)
801032f0:	8b 15 54 47 11 80    	mov    0x80114754,%edx
      release(&kmem.lock);
801032f6:	83 c4 10             	add    $0x10,%esp
    if (lru.use_lock)
801032f9:	85 d2                	test   %edx,%edx
801032fb:	74 81                	je     8010327e <kalloc+0x5e>
      release(&lru.lock);
801032fd:	83 ec 0c             	sub    $0xc,%esp
80103300:	68 20 47 11 80       	push   $0x80114720
80103305:	e8 36 21 00 00       	call   80105440 <release>
    if (bitmap.use_lock)
8010330a:	a1 14 37 11 80       	mov    0x80113714,%eax
      release(&lru.lock);
8010330f:	83 c4 10             	add    $0x10,%esp
    if (bitmap.use_lock)
80103312:	85 c0                	test   %eax,%eax
80103314:	0f 84 71 ff ff ff    	je     8010328b <kalloc+0x6b>
      release(&bitmap.lock);
8010331a:	83 ec 0c             	sub    $0xc,%esp
8010331d:	68 e0 36 11 80       	push   $0x801136e0
80103322:	e8 19 21 00 00       	call   80105440 <release>
}
80103327:	89 d8                	mov    %ebx,%eax
      release(&bitmap.lock);
80103329:	83 c4 10             	add    $0x10,%esp
}
8010332c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010332f:	c9                   	leave  
80103330:	c3                   	ret    
80103331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&bitmap.lock);
80103338:	83 ec 0c             	sub    $0xc,%esp
8010333b:	68 e0 36 11 80       	push   $0x801136e0
80103340:	e8 3b 20 00 00       	call   80105380 <acquire>
80103345:	83 c4 10             	add    $0x10,%esp
80103348:	e9 05 ff ff ff       	jmp    80103252 <kalloc+0x32>
8010334d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&lru.lock);
80103350:	83 ec 0c             	sub    $0xc,%esp
80103353:	68 20 47 11 80       	push   $0x80114720
80103358:	e8 23 20 00 00       	call   80105380 <acquire>
8010335d:	83 c4 10             	add    $0x10,%esp
80103360:	e9 e0 fe ff ff       	jmp    80103245 <kalloc+0x25>
80103365:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80103368:	83 ec 0c             	sub    $0xc,%esp
8010336b:	68 a0 36 11 80       	push   $0x801136a0
80103370:	e8 0b 20 00 00       	call   80105380 <acquire>
80103375:	83 c4 10             	add    $0x10,%esp
80103378:	e9 bb fe ff ff       	jmp    80103238 <kalloc+0x18>
8010337d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&kmem.lock);
80103380:	83 ec 0c             	sub    $0xc,%esp
80103383:	68 a0 36 11 80       	push   $0x801136a0
80103388:	e8 b3 20 00 00       	call   80105440 <release>
8010338d:	83 c4 10             	add    $0x10,%esp
80103390:	e9 0b ff ff ff       	jmp    801032a0 <kalloc+0x80>
80103395:	8d 76 00             	lea    0x0(%esi),%esi
      release(&bitmap.lock);
80103398:	83 ec 0c             	sub    $0xc,%esp
8010339b:	68 e0 36 11 80       	push   $0x801136e0
801033a0:	e8 9b 20 00 00       	call   80105440 <release>
801033a5:	83 c4 10             	add    $0x10,%esp
801033a8:	e9 0e ff ff ff       	jmp    801032bb <kalloc+0x9b>
801033ad:	8d 76 00             	lea    0x0(%esi),%esi
      release(&lru.lock);
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 20 47 11 80       	push   $0x80114720
801033b8:	e8 83 20 00 00       	call   80105440 <release>
801033bd:	83 c4 10             	add    $0x10,%esp
801033c0:	e9 e8 fe ff ff       	jmp    801032ad <kalloc+0x8d>
801033c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033d0 <page_fault_handler>:

int page_fault_handler(pde_t *pgdir, uint vaddr)
{
801033d0:	f3 0f 1e fb          	endbr32 
801033d4:	55                   	push   %ebp
801033d5:	89 e5                	mov    %esp,%ebp
801033d7:	57                   	push   %edi
801033d8:	56                   	push   %esi
801033d9:	53                   	push   %ebx
801033da:	83 ec 24             	sub    $0x24,%esp
801033dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *mem;
  pte_t *pte;
  int bitmap_offset;

  // PTE check
  cprintf("Page Fault Occur at %x -> ", vaddr);
801033e0:	56                   	push   %esi
801033e1:	68 f8 83 10 80       	push   $0x801083f8
801033e6:	e8 c5 d2 ff ff       	call   801006b0 <cprintf>
  pte = walkpgdir(pgdir, (void *)vaddr, 0);
801033eb:	83 c4 0c             	add    $0xc,%esp
801033ee:	6a 00                	push   $0x0
801033f0:	56                   	push   %esi
801033f1:	ff 75 08             	pushl  0x8(%ebp)
801033f4:	e8 b7 43 00 00       	call   801077b0 <walkpgdir>
  if ((*pte != 0) && ((*pte & PTE_P) == 0)) // page-fault occur where swapped out page
801033f9:	83 c4 10             	add    $0x10,%esp
  pte = walkpgdir(pgdir, (void *)vaddr, 0);
801033fc:	89 c3                	mov    %eax,%ebx
  if ((*pte != 0) && ((*pte & PTE_P) == 0)) // page-fault occur where swapped out page
801033fe:	8b 00                	mov    (%eax),%eax
80103400:	85 c0                	test   %eax,%eax
80103402:	74 04                	je     80103408 <page_fault_handler+0x38>
80103404:	a8 01                	test   $0x1,%al
80103406:	74 28                	je     80103430 <page_fault_handler+0x60>

    // cprintf("================Page fault(swappable) end================\n");
  }
  else // page fault occur not exist
  {
    cprintf("================Page fault(non swappable) start================\n");
80103408:	83 ec 0c             	sub    $0xc,%esp
8010340b:	68 cc 87 10 80       	push   $0x801087cc
80103410:	e8 9b d2 ff ff       	call   801006b0 <cprintf>
    // generate page table
    pte = walkpgdir(pgdir, (void *)vaddr, 1);
    // mapping physical page with virtual page
    mappages(pgdir, vaddr, PGSIZE, V2P(mem), PTE_P | PTE_W | PTE_U);
    */
    cprintf("================Page fault(non swappable) end================\n");
80103415:	c7 04 24 10 88 10 80 	movl   $0x80108810,(%esp)
8010341c:	e8 8f d2 ff ff       	call   801006b0 <cprintf>
80103421:	83 c4 10             	add    $0x10,%esp
  }
  // cprintf("================Page fault end================\n");

  return 0;
80103424:	31 c0                	xor    %eax,%eax
80103426:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103429:	5b                   	pop    %ebx
8010342a:	5e                   	pop    %esi
8010342b:	5f                   	pop    %edi
8010342c:	5d                   	pop    %ebp
8010342d:	c3                   	ret    
8010342e:	66 90                	xchg   %ax,%ax
    cprintf("Mem alloc -> ");
80103430:	83 ec 0c             	sub    $0xc,%esp
80103433:	68 13 84 10 80       	push   $0x80108413
80103438:	e8 73 d2 ff ff       	call   801006b0 <cprintf>
    mem = kalloc();
8010343d:	e8 de fd ff ff       	call   80103220 <kalloc>
    if (mem == 0)
80103442:	83 c4 10             	add    $0x10,%esp
    mem = kalloc();
80103445:	89 c7                	mov    %eax,%edi
    if (mem == 0)
80103447:	85 c0                	test   %eax,%eax
80103449:	74 63                	je     801034ae <page_fault_handler+0xde>
    memset(mem, 0, PGSIZE);
8010344b:	83 ec 04             	sub    $0x4,%esp
8010344e:	68 00 10 00 00       	push   $0x1000
80103453:	6a 00                	push   $0x0
80103455:	50                   	push   %eax
80103456:	e8 35 20 00 00       	call   80105490 <memset>
    bitmap_offset = (PTE_ADDR(*pte)) >> 12;
8010345b:	8b 03                	mov    (%ebx),%eax
    swapread(mem, bitmap_offset);
8010345d:	5a                   	pop    %edx
8010345e:	59                   	pop    %ecx
    bitmap_offset = (PTE_ADDR(*pte)) >> 12;
8010345f:	c1 e8 0c             	shr    $0xc,%eax
    swapread(mem, bitmap_offset);
80103462:	50                   	push   %eax
80103463:	57                   	push   %edi
80103464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103467:	e8 04 ec ff ff       	call   80102070 <swapread>
    cprintf("Swap read -> ");
8010346c:	c7 04 24 21 84 10 80 	movl   $0x80108421,(%esp)
80103473:	e8 38 d2 ff ff       	call   801006b0 <cprintf>
    *pte = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
80103478:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
8010347e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80103484:	83 ca 07             	or     $0x7,%edx
80103487:	89 13                	mov    %edx,(%ebx)
    page_insert(pgdir, vaddr);
80103489:	5b                   	pop    %ebx
8010348a:	5f                   	pop    %edi
8010348b:	56                   	push   %esi
8010348c:	ff 75 08             	pushl  0x8(%ebp)
8010348f:	e8 bc f5 ff ff       	call   80102a50 <page_insert>
    bitmap_modify(bitmap_offset, 0);
80103494:	58                   	pop    %eax
80103495:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103498:	5a                   	pop    %edx
80103499:	6a 00                	push   $0x0
8010349b:	50                   	push   %eax
8010349c:	e8 1f fa ff ff       	call   80102ec0 <bitmap_modify>
801034a1:	83 c4 10             	add    $0x10,%esp
801034a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034a7:	31 c0                	xor    %eax,%eax
801034a9:	5b                   	pop    %ebx
801034aa:	5e                   	pop    %esi
801034ab:	5f                   	pop    %edi
801034ac:	5d                   	pop    %ebp
801034ad:	c3                   	ret    
      cprintf("page fault allocate out of memory\n");
801034ae:	83 ec 0c             	sub    $0xc,%esp
801034b1:	68 a8 87 10 80       	push   $0x801087a8
801034b6:	e8 f5 d1 ff ff       	call   801006b0 <cprintf>
      return -1;
801034bb:	83 c4 10             	add    $0x10,%esp
801034be:	83 c8 ff             	or     $0xffffffff,%eax
801034c1:	e9 60 ff ff ff       	jmp    80103426 <page_fault_handler+0x56>
801034c6:	66 90                	xchg   %ax,%ax
801034c8:	66 90                	xchg   %ax,%ax
801034ca:	66 90                	xchg   %ax,%ax
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801034d0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034d4:	ba 64 00 00 00       	mov    $0x64,%edx
801034d9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801034da:	a8 01                	test   $0x1,%al
801034dc:	0f 84 be 00 00 00    	je     801035a0 <kbdgetc+0xd0>
{
801034e2:	55                   	push   %ebp
801034e3:	ba 60 00 00 00       	mov    $0x60,%edx
801034e8:	89 e5                	mov    %esp,%ebp
801034ea:	53                   	push   %ebx
801034eb:	ec                   	in     (%dx),%al
  return data;
801034ec:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801034f2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801034f5:	3c e0                	cmp    $0xe0,%al
801034f7:	74 57                	je     80103550 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801034f9:	89 d9                	mov    %ebx,%ecx
801034fb:	83 e1 40             	and    $0x40,%ecx
801034fe:	84 c0                	test   %al,%al
80103500:	78 5e                	js     80103560 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80103502:	85 c9                	test   %ecx,%ecx
80103504:	74 09                	je     8010350f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103506:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80103509:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010350c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010350f:	0f b6 8a 80 89 10 80 	movzbl -0x7fef7680(%edx),%ecx
  shift ^= togglecode[data];
80103516:	0f b6 82 80 88 10 80 	movzbl -0x7fef7780(%edx),%eax
  shift |= shiftcode[data];
8010351d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010351f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80103521:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80103523:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80103529:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010352c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010352f:	8b 04 85 60 88 10 80 	mov    -0x7fef77a0(,%eax,4),%eax
80103536:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010353a:	74 0b                	je     80103547 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010353c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010353f:	83 fa 19             	cmp    $0x19,%edx
80103542:	77 44                	ja     80103588 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103544:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103547:	5b                   	pop    %ebx
80103548:	5d                   	pop    %ebp
80103549:	c3                   	ret    
8010354a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80103550:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103553:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103555:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010355b:	5b                   	pop    %ebx
8010355c:	5d                   	pop    %ebp
8010355d:	c3                   	ret    
8010355e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80103560:	83 e0 7f             	and    $0x7f,%eax
80103563:	85 c9                	test   %ecx,%ecx
80103565:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80103568:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010356a:	0f b6 8a 80 89 10 80 	movzbl -0x7fef7680(%edx),%ecx
80103571:	83 c9 40             	or     $0x40,%ecx
80103574:	0f b6 c9             	movzbl %cl,%ecx
80103577:	f7 d1                	not    %ecx
80103579:	21 d9                	and    %ebx,%ecx
}
8010357b:	5b                   	pop    %ebx
8010357c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010357d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80103583:	c3                   	ret    
80103584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80103588:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010358b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010358e:	5b                   	pop    %ebx
8010358f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80103590:	83 f9 1a             	cmp    $0x1a,%ecx
80103593:	0f 42 c2             	cmovb  %edx,%eax
}
80103596:	c3                   	ret    
80103597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010359e:	66 90                	xchg   %ax,%ax
    return -1;
801035a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801035a5:	c3                   	ret    
801035a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ad:	8d 76 00             	lea    0x0(%esi),%esi

801035b0 <kbdintr>:

void
kbdintr(void)
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801035ba:	68 d0 34 10 80       	push   $0x801034d0
801035bf:	e8 9c d2 ff ff       	call   80100860 <consoleintr>
}
801035c4:	83 c4 10             	add    $0x10,%esp
801035c7:	c9                   	leave  
801035c8:	c3                   	ret    
801035c9:	66 90                	xchg   %ax,%ax
801035cb:	66 90                	xchg   %ax,%ax
801035cd:	66 90                	xchg   %ax,%ax
801035cf:	90                   	nop

801035d0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801035d0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801035d4:	a1 b8 97 11 80       	mov    0x801197b8,%eax
801035d9:	85 c0                	test   %eax,%eax
801035db:	0f 84 c7 00 00 00    	je     801036a8 <lapicinit+0xd8>
  lapic[index] = value;
801035e1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801035e8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801035eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801035ee:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801035f5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801035f8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801035fb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103602:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103605:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103608:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010360f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103612:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103615:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010361c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010361f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103622:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103629:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010362c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010362f:	8b 50 30             	mov    0x30(%eax),%edx
80103632:	c1 ea 10             	shr    $0x10,%edx
80103635:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010363b:	75 73                	jne    801036b0 <lapicinit+0xe0>
  lapic[index] = value;
8010363d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103644:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103647:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010364a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103651:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103654:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103657:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010365e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103661:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103664:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010366b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010366e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103671:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103678:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010367b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010367e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103685:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103688:	8b 50 20             	mov    0x20(%eax),%edx
8010368b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010368f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103690:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103696:	80 e6 10             	and    $0x10,%dh
80103699:	75 f5                	jne    80103690 <lapicinit+0xc0>
  lapic[index] = value;
8010369b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801036a2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801036a5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801036a8:	c3                   	ret    
801036a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801036b0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801036b7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801036ba:	8b 50 20             	mov    0x20(%eax),%edx
}
801036bd:	e9 7b ff ff ff       	jmp    8010363d <lapicinit+0x6d>
801036c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036d0 <lapicid>:

int
lapicid(void)
{
801036d0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801036d4:	a1 b8 97 11 80       	mov    0x801197b8,%eax
801036d9:	85 c0                	test   %eax,%eax
801036db:	74 0b                	je     801036e8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801036dd:	8b 40 20             	mov    0x20(%eax),%eax
801036e0:	c1 e8 18             	shr    $0x18,%eax
801036e3:	c3                   	ret    
801036e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801036e8:	31 c0                	xor    %eax,%eax
}
801036ea:	c3                   	ret    
801036eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036ef:	90                   	nop

801036f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801036f0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801036f4:	a1 b8 97 11 80       	mov    0x801197b8,%eax
801036f9:	85 c0                	test   %eax,%eax
801036fb:	74 0d                	je     8010370a <lapiceoi+0x1a>
  lapic[index] = value;
801036fd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103707:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010370a:	c3                   	ret    
8010370b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010370f:	90                   	nop

80103710 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103710:	f3 0f 1e fb          	endbr32 
}
80103714:	c3                   	ret    
80103715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010371c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103720 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103720:	f3 0f 1e fb          	endbr32 
80103724:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103725:	b8 0f 00 00 00       	mov    $0xf,%eax
8010372a:	ba 70 00 00 00       	mov    $0x70,%edx
8010372f:	89 e5                	mov    %esp,%ebp
80103731:	53                   	push   %ebx
80103732:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103735:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103738:	ee                   	out    %al,(%dx)
80103739:	b8 0a 00 00 00       	mov    $0xa,%eax
8010373e:	ba 71 00 00 00       	mov    $0x71,%edx
80103743:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103744:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103746:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103749:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010374f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103751:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103754:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103756:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103759:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010375c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103762:	a1 b8 97 11 80       	mov    0x801197b8,%eax
80103767:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010376d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103770:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103777:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010377a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010377d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103784:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103787:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010378a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103790:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103793:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103799:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010379c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801037a2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801037a5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801037ab:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801037ac:	8b 40 20             	mov    0x20(%eax),%eax
}
801037af:	5d                   	pop    %ebp
801037b0:	c3                   	ret    
801037b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037bf:	90                   	nop

801037c0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801037c0:	f3 0f 1e fb          	endbr32 
801037c4:	55                   	push   %ebp
801037c5:	b8 0b 00 00 00       	mov    $0xb,%eax
801037ca:	ba 70 00 00 00       	mov    $0x70,%edx
801037cf:	89 e5                	mov    %esp,%ebp
801037d1:	57                   	push   %edi
801037d2:	56                   	push   %esi
801037d3:	53                   	push   %ebx
801037d4:	83 ec 4c             	sub    $0x4c,%esp
801037d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037d8:	ba 71 00 00 00       	mov    $0x71,%edx
801037dd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801037de:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037e1:	bb 70 00 00 00       	mov    $0x70,%ebx
801037e6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801037e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037f0:	31 c0                	xor    %eax,%eax
801037f2:	89 da                	mov    %ebx,%edx
801037f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037f5:	b9 71 00 00 00       	mov    $0x71,%ecx
801037fa:	89 ca                	mov    %ecx,%edx
801037fc:	ec                   	in     (%dx),%al
801037fd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103800:	89 da                	mov    %ebx,%edx
80103802:	b8 02 00 00 00       	mov    $0x2,%eax
80103807:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103808:	89 ca                	mov    %ecx,%edx
8010380a:	ec                   	in     (%dx),%al
8010380b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010380e:	89 da                	mov    %ebx,%edx
80103810:	b8 04 00 00 00       	mov    $0x4,%eax
80103815:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103816:	89 ca                	mov    %ecx,%edx
80103818:	ec                   	in     (%dx),%al
80103819:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010381c:	89 da                	mov    %ebx,%edx
8010381e:	b8 07 00 00 00       	mov    $0x7,%eax
80103823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103824:	89 ca                	mov    %ecx,%edx
80103826:	ec                   	in     (%dx),%al
80103827:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010382a:	89 da                	mov    %ebx,%edx
8010382c:	b8 08 00 00 00       	mov    $0x8,%eax
80103831:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103832:	89 ca                	mov    %ecx,%edx
80103834:	ec                   	in     (%dx),%al
80103835:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103837:	89 da                	mov    %ebx,%edx
80103839:	b8 09 00 00 00       	mov    $0x9,%eax
8010383e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010383f:	89 ca                	mov    %ecx,%edx
80103841:	ec                   	in     (%dx),%al
80103842:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103844:	89 da                	mov    %ebx,%edx
80103846:	b8 0a 00 00 00       	mov    $0xa,%eax
8010384b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010384c:	89 ca                	mov    %ecx,%edx
8010384e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010384f:	84 c0                	test   %al,%al
80103851:	78 9d                	js     801037f0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103853:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103857:	89 fa                	mov    %edi,%edx
80103859:	0f b6 fa             	movzbl %dl,%edi
8010385c:	89 f2                	mov    %esi,%edx
8010385e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103861:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103865:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103868:	89 da                	mov    %ebx,%edx
8010386a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010386d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103870:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103874:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103877:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010387a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010387e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103881:	31 c0                	xor    %eax,%eax
80103883:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103884:	89 ca                	mov    %ecx,%edx
80103886:	ec                   	in     (%dx),%al
80103887:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010388a:	89 da                	mov    %ebx,%edx
8010388c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010388f:	b8 02 00 00 00       	mov    $0x2,%eax
80103894:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103895:	89 ca                	mov    %ecx,%edx
80103897:	ec                   	in     (%dx),%al
80103898:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010389b:	89 da                	mov    %ebx,%edx
8010389d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801038a0:	b8 04 00 00 00       	mov    $0x4,%eax
801038a5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801038a6:	89 ca                	mov    %ecx,%edx
801038a8:	ec                   	in     (%dx),%al
801038a9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801038ac:	89 da                	mov    %ebx,%edx
801038ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
801038b1:	b8 07 00 00 00       	mov    $0x7,%eax
801038b6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801038b7:	89 ca                	mov    %ecx,%edx
801038b9:	ec                   	in     (%dx),%al
801038ba:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801038bd:	89 da                	mov    %ebx,%edx
801038bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801038c2:	b8 08 00 00 00       	mov    $0x8,%eax
801038c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801038c8:	89 ca                	mov    %ecx,%edx
801038ca:	ec                   	in     (%dx),%al
801038cb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801038ce:	89 da                	mov    %ebx,%edx
801038d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801038d3:	b8 09 00 00 00       	mov    $0x9,%eax
801038d8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801038d9:	89 ca                	mov    %ecx,%edx
801038db:	ec                   	in     (%dx),%al
801038dc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801038df:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801038e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801038e5:	8d 45 d0             	lea    -0x30(%ebp),%eax
801038e8:	6a 18                	push   $0x18
801038ea:	50                   	push   %eax
801038eb:	8d 45 b8             	lea    -0x48(%ebp),%eax
801038ee:	50                   	push   %eax
801038ef:	e8 ec 1b 00 00       	call   801054e0 <memcmp>
801038f4:	83 c4 10             	add    $0x10,%esp
801038f7:	85 c0                	test   %eax,%eax
801038f9:	0f 85 f1 fe ff ff    	jne    801037f0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801038ff:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103903:	75 78                	jne    8010397d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103905:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103908:	89 c2                	mov    %eax,%edx
8010390a:	83 e0 0f             	and    $0xf,%eax
8010390d:	c1 ea 04             	shr    $0x4,%edx
80103910:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103913:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103916:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103919:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010391c:	89 c2                	mov    %eax,%edx
8010391e:	83 e0 0f             	and    $0xf,%eax
80103921:	c1 ea 04             	shr    $0x4,%edx
80103924:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103927:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010392a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010392d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103930:	89 c2                	mov    %eax,%edx
80103932:	83 e0 0f             	and    $0xf,%eax
80103935:	c1 ea 04             	shr    $0x4,%edx
80103938:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010393b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010393e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103941:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103944:	89 c2                	mov    %eax,%edx
80103946:	83 e0 0f             	and    $0xf,%eax
80103949:	c1 ea 04             	shr    $0x4,%edx
8010394c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010394f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103952:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103955:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103958:	89 c2                	mov    %eax,%edx
8010395a:	83 e0 0f             	and    $0xf,%eax
8010395d:	c1 ea 04             	shr    $0x4,%edx
80103960:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103963:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103966:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103969:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010396c:	89 c2                	mov    %eax,%edx
8010396e:	83 e0 0f             	and    $0xf,%eax
80103971:	c1 ea 04             	shr    $0x4,%edx
80103974:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103977:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010397a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010397d:	8b 75 08             	mov    0x8(%ebp),%esi
80103980:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103983:	89 06                	mov    %eax,(%esi)
80103985:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103988:	89 46 04             	mov    %eax,0x4(%esi)
8010398b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010398e:	89 46 08             	mov    %eax,0x8(%esi)
80103991:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103994:	89 46 0c             	mov    %eax,0xc(%esi)
80103997:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010399a:	89 46 10             	mov    %eax,0x10(%esi)
8010399d:	8b 45 cc             	mov    -0x34(%ebp),%eax
801039a0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801039a3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801039aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039ad:	5b                   	pop    %ebx
801039ae:	5e                   	pop    %esi
801039af:	5f                   	pop    %edi
801039b0:	5d                   	pop    %ebp
801039b1:	c3                   	ret    
801039b2:	66 90                	xchg   %ax,%ax
801039b4:	66 90                	xchg   %ax,%ax
801039b6:	66 90                	xchg   %ax,%ax
801039b8:	66 90                	xchg   %ax,%ax
801039ba:	66 90                	xchg   %ax,%ax
801039bc:	66 90                	xchg   %ax,%ax
801039be:	66 90                	xchg   %ax,%ax

801039c0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801039c0:	8b 0d 08 98 11 80    	mov    0x80119808,%ecx
801039c6:	85 c9                	test   %ecx,%ecx
801039c8:	0f 8e 8a 00 00 00    	jle    80103a58 <install_trans+0x98>
{
801039ce:	55                   	push   %ebp
801039cf:	89 e5                	mov    %esp,%ebp
801039d1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801039d2:	31 ff                	xor    %edi,%edi
{
801039d4:	56                   	push   %esi
801039d5:	53                   	push   %ebx
801039d6:	83 ec 0c             	sub    $0xc,%esp
801039d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801039e0:	a1 f4 97 11 80       	mov    0x801197f4,%eax
801039e5:	83 ec 08             	sub    $0x8,%esp
801039e8:	01 f8                	add    %edi,%eax
801039ea:	83 c0 01             	add    $0x1,%eax
801039ed:	50                   	push   %eax
801039ee:	ff 35 04 98 11 80    	pushl  0x80119804
801039f4:	e8 d7 c6 ff ff       	call   801000d0 <bread>
801039f9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801039fb:	58                   	pop    %eax
801039fc:	5a                   	pop    %edx
801039fd:	ff 34 bd 0c 98 11 80 	pushl  -0x7fee67f4(,%edi,4)
80103a04:	ff 35 04 98 11 80    	pushl  0x80119804
  for (tail = 0; tail < log.lh.n; tail++) {
80103a0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103a0d:	e8 be c6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103a12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103a15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103a17:	8d 46 5c             	lea    0x5c(%esi),%eax
80103a1a:	68 00 02 00 00       	push   $0x200
80103a1f:	50                   	push   %eax
80103a20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103a23:	50                   	push   %eax
80103a24:	e8 07 1b 00 00       	call   80105530 <memmove>
    bwrite(dbuf);  // write dst to disk
80103a29:	89 1c 24             	mov    %ebx,(%esp)
80103a2c:	e8 7f c7 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103a31:	89 34 24             	mov    %esi,(%esp)
80103a34:	e8 b7 c7 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103a39:	89 1c 24             	mov    %ebx,(%esp)
80103a3c:	e8 af c7 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103a41:	83 c4 10             	add    $0x10,%esp
80103a44:	39 3d 08 98 11 80    	cmp    %edi,0x80119808
80103a4a:	7f 94                	jg     801039e0 <install_trans+0x20>
  }
}
80103a4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a4f:	5b                   	pop    %ebx
80103a50:	5e                   	pop    %esi
80103a51:	5f                   	pop    %edi
80103a52:	5d                   	pop    %ebp
80103a53:	c3                   	ret    
80103a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a58:	c3                   	ret    
80103a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	53                   	push   %ebx
80103a64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103a67:	ff 35 f4 97 11 80    	pushl  0x801197f4
80103a6d:	ff 35 04 98 11 80    	pushl  0x80119804
80103a73:	e8 58 c6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103a78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103a7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80103a7d:	a1 08 98 11 80       	mov    0x80119808,%eax
80103a82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103a85:	85 c0                	test   %eax,%eax
80103a87:	7e 19                	jle    80103aa2 <write_head+0x42>
80103a89:	31 d2                	xor    %edx,%edx
80103a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103a90:	8b 0c 95 0c 98 11 80 	mov    -0x7fee67f4(,%edx,4),%ecx
80103a97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103a9b:	83 c2 01             	add    $0x1,%edx
80103a9e:	39 d0                	cmp    %edx,%eax
80103aa0:	75 ee                	jne    80103a90 <write_head+0x30>
  }
  bwrite(buf);
80103aa2:	83 ec 0c             	sub    $0xc,%esp
80103aa5:	53                   	push   %ebx
80103aa6:	e8 05 c7 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80103aab:	89 1c 24             	mov    %ebx,(%esp)
80103aae:	e8 3d c7 ff ff       	call   801001f0 <brelse>
}
80103ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab6:	83 c4 10             	add    $0x10,%esp
80103ab9:	c9                   	leave  
80103aba:	c3                   	ret    
80103abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103abf:	90                   	nop

80103ac0 <initlog>:
{
80103ac0:	f3 0f 1e fb          	endbr32 
80103ac4:	55                   	push   %ebp
80103ac5:	89 e5                	mov    %esp,%ebp
80103ac7:	53                   	push   %ebx
80103ac8:	83 ec 2c             	sub    $0x2c,%esp
80103acb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80103ace:	68 80 8a 10 80       	push   $0x80108a80
80103ad3:	68 c0 97 11 80       	push   $0x801197c0
80103ad8:	e8 23 17 00 00       	call   80105200 <initlock>
  readsb(dev, &sb);
80103add:	58                   	pop    %eax
80103ade:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103ae1:	5a                   	pop    %edx
80103ae2:	50                   	push   %eax
80103ae3:	53                   	push   %ebx
80103ae4:	e8 97 d9 ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
80103ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103aec:	59                   	pop    %ecx
  log.dev = dev;
80103aed:	89 1d 04 98 11 80    	mov    %ebx,0x80119804
  log.size = sb.nlog;
80103af3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103af6:	a3 f4 97 11 80       	mov    %eax,0x801197f4
  log.size = sb.nlog;
80103afb:	89 15 f8 97 11 80    	mov    %edx,0x801197f8
  struct buf *buf = bread(log.dev, log.start);
80103b01:	5a                   	pop    %edx
80103b02:	50                   	push   %eax
80103b03:	53                   	push   %ebx
80103b04:	e8 c7 c5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103b09:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103b0c:	8b 48 5c             	mov    0x5c(%eax),%ecx
80103b0f:	89 0d 08 98 11 80    	mov    %ecx,0x80119808
  for (i = 0; i < log.lh.n; i++) {
80103b15:	85 c9                	test   %ecx,%ecx
80103b17:	7e 19                	jle    80103b32 <initlog+0x72>
80103b19:	31 d2                	xor    %edx,%edx
80103b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103b20:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103b24:	89 1c 95 0c 98 11 80 	mov    %ebx,-0x7fee67f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103b2b:	83 c2 01             	add    $0x1,%edx
80103b2e:	39 d1                	cmp    %edx,%ecx
80103b30:	75 ee                	jne    80103b20 <initlog+0x60>
  brelse(buf);
80103b32:	83 ec 0c             	sub    $0xc,%esp
80103b35:	50                   	push   %eax
80103b36:	e8 b5 c6 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80103b3b:	e8 80 fe ff ff       	call   801039c0 <install_trans>
  log.lh.n = 0;
80103b40:	c7 05 08 98 11 80 00 	movl   $0x0,0x80119808
80103b47:	00 00 00 
  write_head(); // clear the log
80103b4a:	e8 11 ff ff ff       	call   80103a60 <write_head>
}
80103b4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b52:	83 c4 10             	add    $0x10,%esp
80103b55:	c9                   	leave  
80103b56:	c3                   	ret    
80103b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5e:	66 90                	xchg   %ax,%ax

80103b60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103b60:	f3 0f 1e fb          	endbr32 
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103b6a:	68 c0 97 11 80       	push   $0x801197c0
80103b6f:	e8 0c 18 00 00       	call   80105380 <acquire>
80103b74:	83 c4 10             	add    $0x10,%esp
80103b77:	eb 1c                	jmp    80103b95 <begin_op+0x35>
80103b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103b80:	83 ec 08             	sub    $0x8,%esp
80103b83:	68 c0 97 11 80       	push   $0x801197c0
80103b88:	68 c0 97 11 80       	push   $0x801197c0
80103b8d:	e8 ae 11 00 00       	call   80104d40 <sleep>
80103b92:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103b95:	a1 00 98 11 80       	mov    0x80119800,%eax
80103b9a:	85 c0                	test   %eax,%eax
80103b9c:	75 e2                	jne    80103b80 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103b9e:	a1 fc 97 11 80       	mov    0x801197fc,%eax
80103ba3:	8b 15 08 98 11 80    	mov    0x80119808,%edx
80103ba9:	83 c0 01             	add    $0x1,%eax
80103bac:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103baf:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103bb2:	83 fa 1e             	cmp    $0x1e,%edx
80103bb5:	7f c9                	jg     80103b80 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103bb7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103bba:	a3 fc 97 11 80       	mov    %eax,0x801197fc
      release(&log.lock);
80103bbf:	68 c0 97 11 80       	push   $0x801197c0
80103bc4:	e8 77 18 00 00       	call   80105440 <release>
      break;
    }
  }
}
80103bc9:	83 c4 10             	add    $0x10,%esp
80103bcc:	c9                   	leave  
80103bcd:	c3                   	ret    
80103bce:	66 90                	xchg   %ax,%ax

80103bd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103bd0:	f3 0f 1e fb          	endbr32 
80103bd4:	55                   	push   %ebp
80103bd5:	89 e5                	mov    %esp,%ebp
80103bd7:	57                   	push   %edi
80103bd8:	56                   	push   %esi
80103bd9:	53                   	push   %ebx
80103bda:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103bdd:	68 c0 97 11 80       	push   $0x801197c0
80103be2:	e8 99 17 00 00       	call   80105380 <acquire>
  log.outstanding -= 1;
80103be7:	a1 fc 97 11 80       	mov    0x801197fc,%eax
  if(log.committing)
80103bec:	8b 35 00 98 11 80    	mov    0x80119800,%esi
80103bf2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103bf5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103bf8:	89 1d fc 97 11 80    	mov    %ebx,0x801197fc
  if(log.committing)
80103bfe:	85 f6                	test   %esi,%esi
80103c00:	0f 85 1e 01 00 00    	jne    80103d24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103c06:	85 db                	test   %ebx,%ebx
80103c08:	0f 85 f2 00 00 00    	jne    80103d00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80103c0e:	c7 05 00 98 11 80 01 	movl   $0x1,0x80119800
80103c15:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103c18:	83 ec 0c             	sub    $0xc,%esp
80103c1b:	68 c0 97 11 80       	push   $0x801197c0
80103c20:	e8 1b 18 00 00       	call   80105440 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103c25:	8b 0d 08 98 11 80    	mov    0x80119808,%ecx
80103c2b:	83 c4 10             	add    $0x10,%esp
80103c2e:	85 c9                	test   %ecx,%ecx
80103c30:	7f 3e                	jg     80103c70 <end_op+0xa0>
    acquire(&log.lock);
80103c32:	83 ec 0c             	sub    $0xc,%esp
80103c35:	68 c0 97 11 80       	push   $0x801197c0
80103c3a:	e8 41 17 00 00       	call   80105380 <acquire>
    wakeup(&log);
80103c3f:	c7 04 24 c0 97 11 80 	movl   $0x801197c0,(%esp)
    log.committing = 0;
80103c46:	c7 05 00 98 11 80 00 	movl   $0x0,0x80119800
80103c4d:	00 00 00 
    wakeup(&log);
80103c50:	e8 ab 12 00 00       	call   80104f00 <wakeup>
    release(&log.lock);
80103c55:	c7 04 24 c0 97 11 80 	movl   $0x801197c0,(%esp)
80103c5c:	e8 df 17 00 00       	call   80105440 <release>
80103c61:	83 c4 10             	add    $0x10,%esp
}
80103c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c67:	5b                   	pop    %ebx
80103c68:	5e                   	pop    %esi
80103c69:	5f                   	pop    %edi
80103c6a:	5d                   	pop    %ebp
80103c6b:	c3                   	ret    
80103c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103c70:	a1 f4 97 11 80       	mov    0x801197f4,%eax
80103c75:	83 ec 08             	sub    $0x8,%esp
80103c78:	01 d8                	add    %ebx,%eax
80103c7a:	83 c0 01             	add    $0x1,%eax
80103c7d:	50                   	push   %eax
80103c7e:	ff 35 04 98 11 80    	pushl  0x80119804
80103c84:	e8 47 c4 ff ff       	call   801000d0 <bread>
80103c89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103c8b:	58                   	pop    %eax
80103c8c:	5a                   	pop    %edx
80103c8d:	ff 34 9d 0c 98 11 80 	pushl  -0x7fee67f4(,%ebx,4)
80103c94:	ff 35 04 98 11 80    	pushl  0x80119804
  for (tail = 0; tail < log.lh.n; tail++) {
80103c9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103c9d:	e8 2e c4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103ca2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103ca5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103ca7:	8d 40 5c             	lea    0x5c(%eax),%eax
80103caa:	68 00 02 00 00       	push   $0x200
80103caf:	50                   	push   %eax
80103cb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80103cb3:	50                   	push   %eax
80103cb4:	e8 77 18 00 00       	call   80105530 <memmove>
    bwrite(to);  // write the log
80103cb9:	89 34 24             	mov    %esi,(%esp)
80103cbc:	e8 ef c4 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103cc1:	89 3c 24             	mov    %edi,(%esp)
80103cc4:	e8 27 c5 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103cc9:	89 34 24             	mov    %esi,(%esp)
80103ccc:	e8 1f c5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103cd1:	83 c4 10             	add    $0x10,%esp
80103cd4:	3b 1d 08 98 11 80    	cmp    0x80119808,%ebx
80103cda:	7c 94                	jl     80103c70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80103cdc:	e8 7f fd ff ff       	call   80103a60 <write_head>
    install_trans(); // Now install writes to home locations
80103ce1:	e8 da fc ff ff       	call   801039c0 <install_trans>
    log.lh.n = 0;
80103ce6:	c7 05 08 98 11 80 00 	movl   $0x0,0x80119808
80103ced:	00 00 00 
    write_head();    // Erase the transaction from the log
80103cf0:	e8 6b fd ff ff       	call   80103a60 <write_head>
80103cf5:	e9 38 ff ff ff       	jmp    80103c32 <end_op+0x62>
80103cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103d00:	83 ec 0c             	sub    $0xc,%esp
80103d03:	68 c0 97 11 80       	push   $0x801197c0
80103d08:	e8 f3 11 00 00       	call   80104f00 <wakeup>
  release(&log.lock);
80103d0d:	c7 04 24 c0 97 11 80 	movl   $0x801197c0,(%esp)
80103d14:	e8 27 17 00 00       	call   80105440 <release>
80103d19:	83 c4 10             	add    $0x10,%esp
}
80103d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d1f:	5b                   	pop    %ebx
80103d20:	5e                   	pop    %esi
80103d21:	5f                   	pop    %edi
80103d22:	5d                   	pop    %ebp
80103d23:	c3                   	ret    
    panic("log.committing");
80103d24:	83 ec 0c             	sub    $0xc,%esp
80103d27:	68 84 8a 10 80       	push   $0x80108a84
80103d2c:	e8 5f c6 ff ff       	call   80100390 <panic>
80103d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3f:	90                   	nop

80103d40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103d40:	f3 0f 1e fb          	endbr32 
80103d44:	55                   	push   %ebp
80103d45:	89 e5                	mov    %esp,%ebp
80103d47:	53                   	push   %ebx
80103d48:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103d4b:	8b 15 08 98 11 80    	mov    0x80119808,%edx
{
80103d51:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103d54:	83 fa 1d             	cmp    $0x1d,%edx
80103d57:	0f 8f 91 00 00 00    	jg     80103dee <log_write+0xae>
80103d5d:	a1 f8 97 11 80       	mov    0x801197f8,%eax
80103d62:	83 e8 01             	sub    $0x1,%eax
80103d65:	39 c2                	cmp    %eax,%edx
80103d67:	0f 8d 81 00 00 00    	jge    80103dee <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103d6d:	a1 fc 97 11 80       	mov    0x801197fc,%eax
80103d72:	85 c0                	test   %eax,%eax
80103d74:	0f 8e 81 00 00 00    	jle    80103dfb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103d7a:	83 ec 0c             	sub    $0xc,%esp
80103d7d:	68 c0 97 11 80       	push   $0x801197c0
80103d82:	e8 f9 15 00 00       	call   80105380 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103d87:	8b 15 08 98 11 80    	mov    0x80119808,%edx
80103d8d:	83 c4 10             	add    $0x10,%esp
80103d90:	85 d2                	test   %edx,%edx
80103d92:	7e 4e                	jle    80103de2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103d94:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103d97:	31 c0                	xor    %eax,%eax
80103d99:	eb 0c                	jmp    80103da7 <log_write+0x67>
80103d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d9f:	90                   	nop
80103da0:	83 c0 01             	add    $0x1,%eax
80103da3:	39 c2                	cmp    %eax,%edx
80103da5:	74 29                	je     80103dd0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103da7:	39 0c 85 0c 98 11 80 	cmp    %ecx,-0x7fee67f4(,%eax,4)
80103dae:	75 f0                	jne    80103da0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103db0:	89 0c 85 0c 98 11 80 	mov    %ecx,-0x7fee67f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103db7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80103dba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103dbd:	c7 45 08 c0 97 11 80 	movl   $0x801197c0,0x8(%ebp)
}
80103dc4:	c9                   	leave  
  release(&log.lock);
80103dc5:	e9 76 16 00 00       	jmp    80105440 <release>
80103dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103dd0:	89 0c 95 0c 98 11 80 	mov    %ecx,-0x7fee67f4(,%edx,4)
    log.lh.n++;
80103dd7:	83 c2 01             	add    $0x1,%edx
80103dda:	89 15 08 98 11 80    	mov    %edx,0x80119808
80103de0:	eb d5                	jmp    80103db7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103de2:	8b 43 08             	mov    0x8(%ebx),%eax
80103de5:	a3 0c 98 11 80       	mov    %eax,0x8011980c
  if (i == log.lh.n)
80103dea:	75 cb                	jne    80103db7 <log_write+0x77>
80103dec:	eb e9                	jmp    80103dd7 <log_write+0x97>
    panic("too big a transaction");
80103dee:	83 ec 0c             	sub    $0xc,%esp
80103df1:	68 93 8a 10 80       	push   $0x80108a93
80103df6:	e8 95 c5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103dfb:	83 ec 0c             	sub    $0xc,%esp
80103dfe:	68 a9 8a 10 80       	push   $0x80108aa9
80103e03:	e8 88 c5 ff ff       	call   80100390 <panic>
80103e08:	66 90                	xchg   %ax,%ax
80103e0a:	66 90                	xchg   %ax,%ax
80103e0c:	66 90                	xchg   %ax,%ax
80103e0e:	66 90                	xchg   %ax,%ax

80103e10 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	53                   	push   %ebx
80103e14:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103e17:	e8 54 09 00 00       	call   80104770 <cpuid>
80103e1c:	89 c3                	mov    %eax,%ebx
80103e1e:	e8 4d 09 00 00       	call   80104770 <cpuid>
80103e23:	83 ec 04             	sub    $0x4,%esp
80103e26:	53                   	push   %ebx
80103e27:	50                   	push   %eax
80103e28:	68 c4 8a 10 80       	push   $0x80108ac4
80103e2d:	e8 7e c8 ff ff       	call   801006b0 <cprintf>
  idtinit();                    // load idt register
80103e32:	e8 29 2a 00 00       	call   80106860 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103e37:	e8 c4 08 00 00       	call   80104700 <mycpu>
80103e3c:	89 c2                	mov    %eax,%edx
  asm volatile("lock; xchgl %0, %1" :
80103e3e:	b8 01 00 00 00       	mov    $0x1,%eax
80103e43:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();                  // start running processes
80103e4a:	e8 21 0c 00 00       	call   80104a70 <scheduler>
80103e4f:	90                   	nop

80103e50 <mpenter>:
{
80103e50:	f3 0f 1e fb          	endbr32 
80103e54:	55                   	push   %ebp
80103e55:	89 e5                	mov    %esp,%ebp
80103e57:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103e5a:	e8 51 3b 00 00       	call   801079b0 <switchkvm>
  seginit();
80103e5f:	e8 bc 38 00 00       	call   80107720 <seginit>
  lapicinit();
80103e64:	e8 67 f7 ff ff       	call   801035d0 <lapicinit>
  mpmain();
80103e69:	e8 a2 ff ff ff       	call   80103e10 <mpmain>
80103e6e:	66 90                	xchg   %ax,%ax

80103e70 <main>:
{
80103e70:	f3 0f 1e fb          	endbr32 
80103e74:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103e78:	83 e4 f0             	and    $0xfffffff0,%esp
80103e7b:	ff 71 fc             	pushl  -0x4(%ecx)
80103e7e:	55                   	push   %ebp
80103e7f:	89 e5                	mov    %esp,%ebp
80103e81:	53                   	push   %ebx
80103e82:	51                   	push   %ecx
  kinit1(end, P2V(4 * 1024 * 1024));          // phys page allocator
80103e83:	83 ec 08             	sub    $0x8,%esp
80103e86:	68 00 00 40 80       	push   $0x80400000
80103e8b:	68 e8 c5 11 80       	push   $0x8011c5e8
80103e90:	e8 eb e7 ff ff       	call   80102680 <kinit1>
  kvmalloc();                                 // kernel page table
80103e95:	e8 16 40 00 00       	call   80107eb0 <kvmalloc>
  mpinit();                                   // detect other processors
80103e9a:	e8 81 01 00 00       	call   80104020 <mpinit>
  lapicinit();                                // interrupt controller
80103e9f:	e8 2c f7 ff ff       	call   801035d0 <lapicinit>
  seginit();                                  // segment descriptors
80103ea4:	e8 77 38 00 00       	call   80107720 <seginit>
  picinit();                                  // disable pic
80103ea9:	e8 52 03 00 00       	call   80104200 <picinit>
  ioapicinit();                               // another interrupt controller
80103eae:	e8 dd e5 ff ff       	call   80102490 <ioapicinit>
  consoleinit();                              // console hardware
80103eb3:	e8 78 cb ff ff       	call   80100a30 <consoleinit>
  uartinit();                                 // serial port
80103eb8:	e8 e3 2c 00 00       	call   80106ba0 <uartinit>
  pinit();                                    // process table
80103ebd:	e8 1e 08 00 00       	call   801046e0 <pinit>
  tvinit();                                   // trap vectors
80103ec2:	e8 19 29 00 00       	call   801067e0 <tvinit>
  binit();                                    // buffer cache
80103ec7:	e8 74 c1 ff ff       	call   80100040 <binit>
  fileinit();                                 // file table
80103ecc:	e8 0f cf ff ff       	call   80100de0 <fileinit>
  ideinit();                                  // disk
80103ed1:	e8 8a e3 ff ff       	call   80102260 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103ed6:	83 c4 0c             	add    $0xc,%esp
80103ed9:	68 8a 00 00 00       	push   $0x8a
80103ede:	68 8c b4 10 80       	push   $0x8010b48c
80103ee3:	68 00 70 00 80       	push   $0x80007000
80103ee8:	e8 43 16 00 00       	call   80105530 <memmove>

  for (c = cpus; c < cpus + ncpu; c++)
80103eed:	83 c4 10             	add    $0x10,%esp
80103ef0:	69 05 40 9e 11 80 b0 	imul   $0xb0,0x80119e40,%eax
80103ef7:	00 00 00 
80103efa:	05 c0 98 11 80       	add    $0x801198c0,%eax
80103eff:	3d c0 98 11 80       	cmp    $0x801198c0,%eax
80103f04:	76 7a                	jbe    80103f80 <main+0x110>
80103f06:	bb c0 98 11 80       	mov    $0x801198c0,%ebx
80103f0b:	eb 1c                	jmp    80103f29 <main+0xb9>
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi
80103f10:	69 05 40 9e 11 80 b0 	imul   $0xb0,0x80119e40,%eax
80103f17:	00 00 00 
80103f1a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103f20:	05 c0 98 11 80       	add    $0x801198c0,%eax
80103f25:	39 c3                	cmp    %eax,%ebx
80103f27:	73 57                	jae    80103f80 <main+0x110>
  {
    if (c == mycpu()) // We've started already.
80103f29:	e8 d2 07 00 00       	call   80104700 <mycpu>
80103f2e:	39 c3                	cmp    %eax,%ebx
80103f30:	74 de                	je     80103f10 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103f32:	e8 e9 f2 ff ff       	call   80103220 <kalloc>
    *(void **)(code - 4) = stack + KSTACKSIZE;
    *(void (**)(void))(code - 8) = mpenter;
    *(int **)(code - 12) = (void *)V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103f37:	83 ec 08             	sub    $0x8,%esp
    *(void (**)(void))(code - 8) = mpenter;
80103f3a:	c7 05 f8 6f 00 80 50 	movl   $0x80103e50,0x80006ff8
80103f41:	3e 10 80 
    *(int **)(code - 12) = (void *)V2P(entrypgdir);
80103f44:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103f4b:	a0 10 00 
    *(void **)(code - 4) = stack + KSTACKSIZE;
80103f4e:	05 00 10 00 00       	add    $0x1000,%eax
80103f53:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103f58:	0f b6 03             	movzbl (%ebx),%eax
80103f5b:	68 00 70 00 00       	push   $0x7000
80103f60:	50                   	push   %eax
80103f61:	e8 ba f7 ff ff       	call   80103720 <lapicstartap>

    // wait for cpu to finish mpmain()
    while (c->started == 0)
80103f66:	83 c4 10             	add    $0x10,%esp
80103f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f70:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103f76:	85 c0                	test   %eax,%eax
80103f78:	74 f6                	je     80103f70 <main+0x100>
80103f7a:	eb 94                	jmp    80103f10 <main+0xa0>
80103f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
80103f80:	83 ec 08             	sub    $0x8,%esp
80103f83:	68 00 00 40 80       	push   $0x80400000
80103f88:	68 00 00 40 80       	push   $0x80400000
80103f8d:	e8 fe e8 ff ff       	call   80102890 <kinit2>
  userinit();                                 // first user process
80103f92:	e8 29 08 00 00       	call   801047c0 <userinit>
  mpmain();                                   // finish this processor's setup
80103f97:	e8 74 fe ff ff       	call   80103e10 <mpmain>
80103f9c:	66 90                	xchg   %ax,%ax
80103f9e:	66 90                	xchg   %ax,%ax

80103fa0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103fa5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103fab:	53                   	push   %ebx
  e = addr+len;
80103fac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103faf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103fb2:	39 de                	cmp    %ebx,%esi
80103fb4:	72 10                	jb     80103fc6 <mpsearch1+0x26>
80103fb6:	eb 50                	jmp    80104008 <mpsearch1+0x68>
80103fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fbf:	90                   	nop
80103fc0:	89 fe                	mov    %edi,%esi
80103fc2:	39 fb                	cmp    %edi,%ebx
80103fc4:	76 42                	jbe    80104008 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103fc6:	83 ec 04             	sub    $0x4,%esp
80103fc9:	8d 7e 10             	lea    0x10(%esi),%edi
80103fcc:	6a 04                	push   $0x4
80103fce:	68 d8 8a 10 80       	push   $0x80108ad8
80103fd3:	56                   	push   %esi
80103fd4:	e8 07 15 00 00       	call   801054e0 <memcmp>
80103fd9:	83 c4 10             	add    $0x10,%esp
80103fdc:	85 c0                	test   %eax,%eax
80103fde:	75 e0                	jne    80103fc0 <mpsearch1+0x20>
80103fe0:	89 f2                	mov    %esi,%edx
80103fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103fe8:	0f b6 0a             	movzbl (%edx),%ecx
80103feb:	83 c2 01             	add    $0x1,%edx
80103fee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103ff0:	39 fa                	cmp    %edi,%edx
80103ff2:	75 f4                	jne    80103fe8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ff4:	84 c0                	test   %al,%al
80103ff6:	75 c8                	jne    80103fc0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103ff8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ffb:	89 f0                	mov    %esi,%eax
80103ffd:	5b                   	pop    %ebx
80103ffe:	5e                   	pop    %esi
80103fff:	5f                   	pop    %edi
80104000:	5d                   	pop    %ebp
80104001:	c3                   	ret    
80104002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104008:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010400b:	31 f6                	xor    %esi,%esi
}
8010400d:	5b                   	pop    %ebx
8010400e:	89 f0                	mov    %esi,%eax
80104010:	5e                   	pop    %esi
80104011:	5f                   	pop    %edi
80104012:	5d                   	pop    %ebp
80104013:	c3                   	ret    
80104014:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010401f:	90                   	nop

80104020 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80104020:	f3 0f 1e fb          	endbr32 
80104024:	55                   	push   %ebp
80104025:	89 e5                	mov    %esp,%ebp
80104027:	57                   	push   %edi
80104028:	56                   	push   %esi
80104029:	53                   	push   %ebx
8010402a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010402d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80104034:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010403b:	c1 e0 08             	shl    $0x8,%eax
8010403e:	09 d0                	or     %edx,%eax
80104040:	c1 e0 04             	shl    $0x4,%eax
80104043:	75 1b                	jne    80104060 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80104045:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010404c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80104053:	c1 e0 08             	shl    $0x8,%eax
80104056:	09 d0                	or     %edx,%eax
80104058:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010405b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80104060:	ba 00 04 00 00       	mov    $0x400,%edx
80104065:	e8 36 ff ff ff       	call   80103fa0 <mpsearch1>
8010406a:	89 c6                	mov    %eax,%esi
8010406c:	85 c0                	test   %eax,%eax
8010406e:	0f 84 4c 01 00 00    	je     801041c0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104074:	8b 5e 04             	mov    0x4(%esi),%ebx
80104077:	85 db                	test   %ebx,%ebx
80104079:	0f 84 61 01 00 00    	je     801041e0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010407f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80104082:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80104088:	6a 04                	push   $0x4
8010408a:	68 dd 8a 10 80       	push   $0x80108add
8010408f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80104090:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80104093:	e8 48 14 00 00       	call   801054e0 <memcmp>
80104098:	83 c4 10             	add    $0x10,%esp
8010409b:	85 c0                	test   %eax,%eax
8010409d:	0f 85 3d 01 00 00    	jne    801041e0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801040a3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801040aa:	3c 01                	cmp    $0x1,%al
801040ac:	74 08                	je     801040b6 <mpinit+0x96>
801040ae:	3c 04                	cmp    $0x4,%al
801040b0:	0f 85 2a 01 00 00    	jne    801041e0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801040b6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801040bd:	66 85 d2             	test   %dx,%dx
801040c0:	74 26                	je     801040e8 <mpinit+0xc8>
801040c2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801040c5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801040c7:	31 d2                	xor    %edx,%edx
801040c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801040d0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801040d7:	83 c0 01             	add    $0x1,%eax
801040da:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801040dc:	39 f8                	cmp    %edi,%eax
801040de:	75 f0                	jne    801040d0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801040e0:	84 d2                	test   %dl,%dl
801040e2:	0f 85 f8 00 00 00    	jne    801041e0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801040e8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801040ee:	a3 b8 97 11 80       	mov    %eax,0x801197b8
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801040f3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801040f9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80104100:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104105:	03 55 e4             	add    -0x1c(%ebp),%edx
80104108:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010410b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010410f:	90                   	nop
80104110:	39 c2                	cmp    %eax,%edx
80104112:	76 15                	jbe    80104129 <mpinit+0x109>
    switch(*p){
80104114:	0f b6 08             	movzbl (%eax),%ecx
80104117:	80 f9 02             	cmp    $0x2,%cl
8010411a:	74 5c                	je     80104178 <mpinit+0x158>
8010411c:	77 42                	ja     80104160 <mpinit+0x140>
8010411e:	84 c9                	test   %cl,%cl
80104120:	74 6e                	je     80104190 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104122:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104125:	39 c2                	cmp    %eax,%edx
80104127:	77 eb                	ja     80104114 <mpinit+0xf4>
80104129:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010412c:	85 db                	test   %ebx,%ebx
8010412e:	0f 84 b9 00 00 00    	je     801041ed <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80104134:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80104138:	74 15                	je     8010414f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010413a:	b8 70 00 00 00       	mov    $0x70,%eax
8010413f:	ba 22 00 00 00       	mov    $0x22,%edx
80104144:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104145:	ba 23 00 00 00       	mov    $0x23,%edx
8010414a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010414b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010414e:	ee                   	out    %al,(%dx)
  }
}
8010414f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104152:	5b                   	pop    %ebx
80104153:	5e                   	pop    %esi
80104154:	5f                   	pop    %edi
80104155:	5d                   	pop    %ebp
80104156:	c3                   	ret    
80104157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415e:	66 90                	xchg   %ax,%ax
    switch(*p){
80104160:	83 e9 03             	sub    $0x3,%ecx
80104163:	80 f9 01             	cmp    $0x1,%cl
80104166:	76 ba                	jbe    80104122 <mpinit+0x102>
80104168:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010416f:	eb 9f                	jmp    80104110 <mpinit+0xf0>
80104171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80104178:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010417c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010417f:	88 0d a0 98 11 80    	mov    %cl,0x801198a0
      continue;
80104185:	eb 89                	jmp    80104110 <mpinit+0xf0>
80104187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010418e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80104190:	8b 0d 40 9e 11 80    	mov    0x80119e40,%ecx
80104196:	83 f9 07             	cmp    $0x7,%ecx
80104199:	7f 19                	jg     801041b4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010419b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801041a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801041a5:	83 c1 01             	add    $0x1,%ecx
801041a8:	89 0d 40 9e 11 80    	mov    %ecx,0x80119e40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801041ae:	88 9f c0 98 11 80    	mov    %bl,-0x7fee6740(%edi)
      p += sizeof(struct mpproc);
801041b4:	83 c0 14             	add    $0x14,%eax
      continue;
801041b7:	e9 54 ff ff ff       	jmp    80104110 <mpinit+0xf0>
801041bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801041c0:	ba 00 00 01 00       	mov    $0x10000,%edx
801041c5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801041ca:	e8 d1 fd ff ff       	call   80103fa0 <mpsearch1>
801041cf:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801041d1:	85 c0                	test   %eax,%eax
801041d3:	0f 85 9b fe ff ff    	jne    80104074 <mpinit+0x54>
801041d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801041e0:	83 ec 0c             	sub    $0xc,%esp
801041e3:	68 e2 8a 10 80       	push   $0x80108ae2
801041e8:	e8 a3 c1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801041ed:	83 ec 0c             	sub    $0xc,%esp
801041f0:	68 fc 8a 10 80       	push   $0x80108afc
801041f5:	e8 96 c1 ff ff       	call   80100390 <panic>
801041fa:	66 90                	xchg   %ax,%ax
801041fc:	66 90                	xchg   %ax,%ax
801041fe:	66 90                	xchg   %ax,%ax

80104200 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80104200:	f3 0f 1e fb          	endbr32 
80104204:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104209:	ba 21 00 00 00       	mov    $0x21,%edx
8010420e:	ee                   	out    %al,(%dx)
8010420f:	ba a1 00 00 00       	mov    $0xa1,%edx
80104214:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80104215:	c3                   	ret    
80104216:	66 90                	xchg   %ax,%ax
80104218:	66 90                	xchg   %ax,%ax
8010421a:	66 90                	xchg   %ax,%ax
8010421c:	66 90                	xchg   %ax,%ax
8010421e:	66 90                	xchg   %ax,%ax

80104220 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104220:	f3 0f 1e fb          	endbr32 
80104224:	55                   	push   %ebp
80104225:	89 e5                	mov    %esp,%ebp
80104227:	57                   	push   %edi
80104228:	56                   	push   %esi
80104229:	53                   	push   %ebx
8010422a:	83 ec 0c             	sub    $0xc,%esp
8010422d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104230:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80104233:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104239:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010423f:	e8 bc cb ff ff       	call   80100e00 <filealloc>
80104244:	89 03                	mov    %eax,(%ebx)
80104246:	85 c0                	test   %eax,%eax
80104248:	0f 84 ac 00 00 00    	je     801042fa <pipealloc+0xda>
8010424e:	e8 ad cb ff ff       	call   80100e00 <filealloc>
80104253:	89 06                	mov    %eax,(%esi)
80104255:	85 c0                	test   %eax,%eax
80104257:	0f 84 8b 00 00 00    	je     801042e8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010425d:	e8 be ef ff ff       	call   80103220 <kalloc>
80104262:	89 c7                	mov    %eax,%edi
80104264:	85 c0                	test   %eax,%eax
80104266:	0f 84 b4 00 00 00    	je     80104320 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010426c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104273:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80104276:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80104279:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104280:	00 00 00 
  p->nwrite = 0;
80104283:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010428a:	00 00 00 
  p->nread = 0;
8010428d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104294:	00 00 00 
  initlock(&p->lock, "pipe");
80104297:	68 1b 8b 10 80       	push   $0x80108b1b
8010429c:	50                   	push   %eax
8010429d:	e8 5e 0f 00 00       	call   80105200 <initlock>
  (*f0)->type = FD_PIPE;
801042a2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801042a4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801042a7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801042ad:	8b 03                	mov    (%ebx),%eax
801042af:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801042b3:	8b 03                	mov    (%ebx),%eax
801042b5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801042b9:	8b 03                	mov    (%ebx),%eax
801042bb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801042be:	8b 06                	mov    (%esi),%eax
801042c0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801042c6:	8b 06                	mov    (%esi),%eax
801042c8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801042cc:	8b 06                	mov    (%esi),%eax
801042ce:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801042d2:	8b 06                	mov    (%esi),%eax
801042d4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801042d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801042da:	31 c0                	xor    %eax,%eax
}
801042dc:	5b                   	pop    %ebx
801042dd:	5e                   	pop    %esi
801042de:	5f                   	pop    %edi
801042df:	5d                   	pop    %ebp
801042e0:	c3                   	ret    
801042e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801042e8:	8b 03                	mov    (%ebx),%eax
801042ea:	85 c0                	test   %eax,%eax
801042ec:	74 1e                	je     8010430c <pipealloc+0xec>
    fileclose(*f0);
801042ee:	83 ec 0c             	sub    $0xc,%esp
801042f1:	50                   	push   %eax
801042f2:	e8 c9 cb ff ff       	call   80100ec0 <fileclose>
801042f7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801042fa:	8b 06                	mov    (%esi),%eax
801042fc:	85 c0                	test   %eax,%eax
801042fe:	74 0c                	je     8010430c <pipealloc+0xec>
    fileclose(*f1);
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	50                   	push   %eax
80104304:	e8 b7 cb ff ff       	call   80100ec0 <fileclose>
80104309:	83 c4 10             	add    $0x10,%esp
}
8010430c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010430f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104314:	5b                   	pop    %ebx
80104315:	5e                   	pop    %esi
80104316:	5f                   	pop    %edi
80104317:	5d                   	pop    %ebp
80104318:	c3                   	ret    
80104319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80104320:	8b 03                	mov    (%ebx),%eax
80104322:	85 c0                	test   %eax,%eax
80104324:	75 c8                	jne    801042ee <pipealloc+0xce>
80104326:	eb d2                	jmp    801042fa <pipealloc+0xda>
80104328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010432f:	90                   	nop

80104330 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104330:	f3 0f 1e fb          	endbr32 
80104334:	55                   	push   %ebp
80104335:	89 e5                	mov    %esp,%ebp
80104337:	56                   	push   %esi
80104338:	53                   	push   %ebx
80104339:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010433c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010433f:	83 ec 0c             	sub    $0xc,%esp
80104342:	53                   	push   %ebx
80104343:	e8 38 10 00 00       	call   80105380 <acquire>
  if(writable){
80104348:	83 c4 10             	add    $0x10,%esp
8010434b:	85 f6                	test   %esi,%esi
8010434d:	74 41                	je     80104390 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010434f:	83 ec 0c             	sub    $0xc,%esp
80104352:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80104358:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010435f:	00 00 00 
    wakeup(&p->nread);
80104362:	50                   	push   %eax
80104363:	e8 98 0b 00 00       	call   80104f00 <wakeup>
80104368:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010436b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80104371:	85 d2                	test   %edx,%edx
80104373:	75 0a                	jne    8010437f <pipeclose+0x4f>
80104375:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010437b:	85 c0                	test   %eax,%eax
8010437d:	74 31                	je     801043b0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010437f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80104382:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104385:	5b                   	pop    %ebx
80104386:	5e                   	pop    %esi
80104387:	5d                   	pop    %ebp
    release(&p->lock);
80104388:	e9 b3 10 00 00       	jmp    80105440 <release>
8010438d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80104390:	83 ec 0c             	sub    $0xc,%esp
80104393:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80104399:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801043a0:	00 00 00 
    wakeup(&p->nwrite);
801043a3:	50                   	push   %eax
801043a4:	e8 57 0b 00 00       	call   80104f00 <wakeup>
801043a9:	83 c4 10             	add    $0x10,%esp
801043ac:	eb bd                	jmp    8010436b <pipeclose+0x3b>
801043ae:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801043b0:	83 ec 0c             	sub    $0xc,%esp
801043b3:	53                   	push   %ebx
801043b4:	e8 87 10 00 00       	call   80105440 <release>
    kfree((char*)p);
801043b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801043bc:	83 c4 10             	add    $0x10,%esp
}
801043bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043c2:	5b                   	pop    %ebx
801043c3:	5e                   	pop    %esi
801043c4:	5d                   	pop    %ebp
    kfree((char*)p);
801043c5:	e9 b6 e1 ff ff       	jmp    80102580 <kfree>
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043d0 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
801043d0:	f3 0f 1e fb          	endbr32 
801043d4:	55                   	push   %ebp
801043d5:	89 e5                	mov    %esp,%ebp
801043d7:	57                   	push   %edi
801043d8:	56                   	push   %esi
801043d9:	53                   	push   %ebx
801043da:	83 ec 28             	sub    $0x28,%esp
801043dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801043e0:	53                   	push   %ebx
801043e1:	e8 9a 0f 00 00       	call   80105380 <acquire>
  for(i = 0; i < n; i++){
801043e6:	8b 45 10             	mov    0x10(%ebp),%eax
801043e9:	83 c4 10             	add    $0x10,%esp
801043ec:	85 c0                	test   %eax,%eax
801043ee:	0f 8e bc 00 00 00    	jle    801044b0 <pipewrite+0xe0>
801043f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801043f7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801043fd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80104403:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104406:	03 45 10             	add    0x10(%ebp),%eax
80104409:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010440c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104412:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104418:	89 ca                	mov    %ecx,%edx
8010441a:	05 00 02 00 00       	add    $0x200,%eax
8010441f:	39 c1                	cmp    %eax,%ecx
80104421:	74 3b                	je     8010445e <pipewrite+0x8e>
80104423:	eb 63                	jmp    80104488 <pipewrite+0xb8>
80104425:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80104428:	e8 63 03 00 00       	call   80104790 <myproc>
8010442d:	8b 48 24             	mov    0x24(%eax),%ecx
80104430:	85 c9                	test   %ecx,%ecx
80104432:	75 34                	jne    80104468 <pipewrite+0x98>
      wakeup(&p->nread);
80104434:	83 ec 0c             	sub    $0xc,%esp
80104437:	57                   	push   %edi
80104438:	e8 c3 0a 00 00       	call   80104f00 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010443d:	58                   	pop    %eax
8010443e:	5a                   	pop    %edx
8010443f:	53                   	push   %ebx
80104440:	56                   	push   %esi
80104441:	e8 fa 08 00 00       	call   80104d40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104446:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010444c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80104452:	83 c4 10             	add    $0x10,%esp
80104455:	05 00 02 00 00       	add    $0x200,%eax
8010445a:	39 c2                	cmp    %eax,%edx
8010445c:	75 2a                	jne    80104488 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010445e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80104464:	85 c0                	test   %eax,%eax
80104466:	75 c0                	jne    80104428 <pipewrite+0x58>
        release(&p->lock);
80104468:	83 ec 0c             	sub    $0xc,%esp
8010446b:	53                   	push   %ebx
8010446c:	e8 cf 0f 00 00       	call   80105440 <release>
        return -1;
80104471:	83 c4 10             	add    $0x10,%esp
80104474:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80104479:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010447c:	5b                   	pop    %ebx
8010447d:	5e                   	pop    %esi
8010447e:	5f                   	pop    %edi
8010447f:	5d                   	pop    %ebp
80104480:	c3                   	ret    
80104481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104488:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010448b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010448e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80104494:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010449a:	0f b6 06             	movzbl (%esi),%eax
8010449d:	83 c6 01             	add    $0x1,%esi
801044a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801044a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801044a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801044aa:	0f 85 5c ff ff ff    	jne    8010440c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801044b0:	83 ec 0c             	sub    $0xc,%esp
801044b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801044b9:	50                   	push   %eax
801044ba:	e8 41 0a 00 00       	call   80104f00 <wakeup>
  release(&p->lock);
801044bf:	89 1c 24             	mov    %ebx,(%esp)
801044c2:	e8 79 0f 00 00       	call   80105440 <release>
  return n;
801044c7:	8b 45 10             	mov    0x10(%ebp),%eax
801044ca:	83 c4 10             	add    $0x10,%esp
801044cd:	eb aa                	jmp    80104479 <pipewrite+0xa9>
801044cf:	90                   	nop

801044d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	57                   	push   %edi
801044d8:	56                   	push   %esi
801044d9:	53                   	push   %ebx
801044da:	83 ec 18             	sub    $0x18,%esp
801044dd:	8b 75 08             	mov    0x8(%ebp),%esi
801044e0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801044e3:	56                   	push   %esi
801044e4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801044ea:	e8 91 0e 00 00       	call   80105380 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801044ef:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801044f5:	83 c4 10             	add    $0x10,%esp
801044f8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801044fe:	74 33                	je     80104533 <piperead+0x63>
80104500:	eb 3b                	jmp    8010453d <piperead+0x6d>
80104502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80104508:	e8 83 02 00 00       	call   80104790 <myproc>
8010450d:	8b 48 24             	mov    0x24(%eax),%ecx
80104510:	85 c9                	test   %ecx,%ecx
80104512:	0f 85 88 00 00 00    	jne    801045a0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104518:	83 ec 08             	sub    $0x8,%esp
8010451b:	56                   	push   %esi
8010451c:	53                   	push   %ebx
8010451d:	e8 1e 08 00 00       	call   80104d40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104522:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80104528:	83 c4 10             	add    $0x10,%esp
8010452b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80104531:	75 0a                	jne    8010453d <piperead+0x6d>
80104533:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80104539:	85 c0                	test   %eax,%eax
8010453b:	75 cb                	jne    80104508 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010453d:	8b 55 10             	mov    0x10(%ebp),%edx
80104540:	31 db                	xor    %ebx,%ebx
80104542:	85 d2                	test   %edx,%edx
80104544:	7f 28                	jg     8010456e <piperead+0x9e>
80104546:	eb 34                	jmp    8010457c <piperead+0xac>
80104548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010454f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104550:	8d 48 01             	lea    0x1(%eax),%ecx
80104553:	25 ff 01 00 00       	and    $0x1ff,%eax
80104558:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010455e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104563:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104566:	83 c3 01             	add    $0x1,%ebx
80104569:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010456c:	74 0e                	je     8010457c <piperead+0xac>
    if(p->nread == p->nwrite)
8010456e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104574:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010457a:	75 d4                	jne    80104550 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010457c:	83 ec 0c             	sub    $0xc,%esp
8010457f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104585:	50                   	push   %eax
80104586:	e8 75 09 00 00       	call   80104f00 <wakeup>
  release(&p->lock);
8010458b:	89 34 24             	mov    %esi,(%esp)
8010458e:	e8 ad 0e 00 00       	call   80105440 <release>
  return i;
80104593:	83 c4 10             	add    $0x10,%esp
}
80104596:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104599:	89 d8                	mov    %ebx,%eax
8010459b:	5b                   	pop    %ebx
8010459c:	5e                   	pop    %esi
8010459d:	5f                   	pop    %edi
8010459e:	5d                   	pop    %ebp
8010459f:	c3                   	ret    
      release(&p->lock);
801045a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801045a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801045a8:	56                   	push   %esi
801045a9:	e8 92 0e 00 00       	call   80105440 <release>
      return -1;
801045ae:	83 c4 10             	add    $0x10,%esp
}
801045b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045b4:	89 d8                	mov    %ebx,%eax
801045b6:	5b                   	pop    %ebx
801045b7:	5e                   	pop    %esi
801045b8:	5f                   	pop    %edi
801045b9:	5d                   	pop    %ebp
801045ba:	c3                   	ret    
801045bb:	66 90                	xchg   %ax,%ax
801045bd:	66 90                	xchg   %ax,%ax
801045bf:	90                   	nop

801045c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045c4:	bb 94 9e 11 80       	mov    $0x80119e94,%ebx
{
801045c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801045cc:	68 60 9e 11 80       	push   $0x80119e60
801045d1:	e8 aa 0d 00 00       	call   80105380 <acquire>
801045d6:	83 c4 10             	add    $0x10,%esp
801045d9:	eb 10                	jmp    801045eb <allocproc+0x2b>
801045db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045df:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045e0:	83 c3 7c             	add    $0x7c,%ebx
801045e3:	81 fb 94 bd 11 80    	cmp    $0x8011bd94,%ebx
801045e9:	74 75                	je     80104660 <allocproc+0xa0>
    if (p->state == UNUSED)
801045eb:	8b 43 0c             	mov    0xc(%ebx),%eax
801045ee:	85 c0                	test   %eax,%eax
801045f0:	75 ee                	jne    801045e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801045f2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801045f7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801045fa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104601:	89 43 10             	mov    %eax,0x10(%ebx)
80104604:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104607:	68 60 9e 11 80       	push   $0x80119e60
  p->pid = nextpid++;
8010460c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104612:	e8 29 0e 00 00       	call   80105440 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
80104617:	e8 04 ec ff ff       	call   80103220 <kalloc>
8010461c:	83 c4 10             	add    $0x10,%esp
8010461f:	89 43 08             	mov    %eax,0x8(%ebx)
80104622:	85 c0                	test   %eax,%eax
80104624:	74 53                	je     80104679 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104626:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
8010462c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010462f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104634:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80104637:	c7 40 14 c6 67 10 80 	movl   $0x801067c6,0x14(%eax)
  p->context = (struct context *)sp;
8010463e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104641:	6a 14                	push   $0x14
80104643:	6a 00                	push   $0x0
80104645:	50                   	push   %eax
80104646:	e8 45 0e 00 00       	call   80105490 <memset>
  p->context->eip = (uint)forkret;
8010464b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010464e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104651:	c7 40 10 90 46 10 80 	movl   $0x80104690,0x10(%eax)
}
80104658:	89 d8                	mov    %ebx,%eax
8010465a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010465d:	c9                   	leave  
8010465e:	c3                   	ret    
8010465f:	90                   	nop
  release(&ptable.lock);
80104660:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104663:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104665:	68 60 9e 11 80       	push   $0x80119e60
8010466a:	e8 d1 0d 00 00       	call   80105440 <release>
}
8010466f:	89 d8                	mov    %ebx,%eax
  return 0;
80104671:	83 c4 10             	add    $0x10,%esp
}
80104674:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104677:	c9                   	leave  
80104678:	c3                   	ret    
    p->state = UNUSED;
80104679:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104680:	31 db                	xor    %ebx,%ebx
}
80104682:	89 d8                	mov    %ebx,%eax
80104684:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104687:	c9                   	leave  
80104688:	c3                   	ret    
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104690 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
80104695:	89 e5                	mov    %esp,%ebp
80104697:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010469a:	68 60 9e 11 80       	push   $0x80119e60
8010469f:	e8 9c 0d 00 00       	call   80105440 <release>

  if (first)
801046a4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801046a9:	83 c4 10             	add    $0x10,%esp
801046ac:	85 c0                	test   %eax,%eax
801046ae:	75 08                	jne    801046b8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801046b0:	c9                   	leave  
801046b1:	c3                   	ret    
801046b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801046b8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801046bf:	00 00 00 
    iinit(ROOTDEV);
801046c2:	83 ec 0c             	sub    $0xc,%esp
801046c5:	6a 01                	push   $0x1
801046c7:	e8 74 ce ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801046cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801046d3:	e8 e8 f3 ff ff       	call   80103ac0 <initlog>
}
801046d8:	83 c4 10             	add    $0x10,%esp
801046db:	c9                   	leave  
801046dc:	c3                   	ret    
801046dd:	8d 76 00             	lea    0x0(%esi),%esi

801046e0 <pinit>:
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801046ea:	68 20 8b 10 80       	push   $0x80108b20
801046ef:	68 60 9e 11 80       	push   $0x80119e60
801046f4:	e8 07 0b 00 00       	call   80105200 <initlock>
}
801046f9:	83 c4 10             	add    $0x10,%esp
801046fc:	c9                   	leave  
801046fd:	c3                   	ret    
801046fe:	66 90                	xchg   %ax,%ax

80104700 <mycpu>:
{
80104700:	f3 0f 1e fb          	endbr32 
80104704:	55                   	push   %ebp
80104705:	89 e5                	mov    %esp,%ebp
80104707:	56                   	push   %esi
80104708:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104709:	9c                   	pushf  
8010470a:	58                   	pop    %eax
  if (readeflags() & FL_IF)
8010470b:	f6 c4 02             	test   $0x2,%ah
8010470e:	75 4a                	jne    8010475a <mycpu+0x5a>
  apicid = lapicid();
80104710:	e8 bb ef ff ff       	call   801036d0 <lapicid>
  for (i = 0; i < ncpu; ++i)
80104715:	8b 35 40 9e 11 80    	mov    0x80119e40,%esi
  apicid = lapicid();
8010471b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i)
8010471d:	85 f6                	test   %esi,%esi
8010471f:	7e 2c                	jle    8010474d <mycpu+0x4d>
80104721:	31 d2                	xor    %edx,%edx
80104723:	eb 0a                	jmp    8010472f <mycpu+0x2f>
80104725:	8d 76 00             	lea    0x0(%esi),%esi
80104728:	83 c2 01             	add    $0x1,%edx
8010472b:	39 f2                	cmp    %esi,%edx
8010472d:	74 1e                	je     8010474d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010472f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104735:	0f b6 81 c0 98 11 80 	movzbl -0x7fee6740(%ecx),%eax
8010473c:	39 d8                	cmp    %ebx,%eax
8010473e:	75 e8                	jne    80104728 <mycpu+0x28>
}
80104740:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104743:	8d 81 c0 98 11 80    	lea    -0x7fee6740(%ecx),%eax
}
80104749:	5b                   	pop    %ebx
8010474a:	5e                   	pop    %esi
8010474b:	5d                   	pop    %ebp
8010474c:	c3                   	ret    
  panic("unknown apicid\n");
8010474d:	83 ec 0c             	sub    $0xc,%esp
80104750:	68 27 8b 10 80       	push   $0x80108b27
80104755:	e8 36 bc ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010475a:	83 ec 0c             	sub    $0xc,%esp
8010475d:	68 00 8c 10 80       	push   $0x80108c00
80104762:	e8 29 bc ff ff       	call   80100390 <panic>
80104767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476e:	66 90                	xchg   %ax,%ax

80104770 <cpuid>:
{
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
8010477a:	e8 81 ff ff ff       	call   80104700 <mycpu>
}
8010477f:	c9                   	leave  
  return mycpu() - cpus;
80104780:	2d c0 98 11 80       	sub    $0x801198c0,%eax
80104785:	c1 f8 04             	sar    $0x4,%eax
80104788:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010478e:	c3                   	ret    
8010478f:	90                   	nop

80104790 <myproc>:
{
80104790:	f3 0f 1e fb          	endbr32 
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	53                   	push   %ebx
80104798:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010479b:	e8 e0 0a 00 00       	call   80105280 <pushcli>
  c = mycpu();
801047a0:	e8 5b ff ff ff       	call   80104700 <mycpu>
  p = c->proc;
801047a5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047ab:	e8 20 0b 00 00       	call   801052d0 <popcli>
}
801047b0:	83 c4 04             	add    $0x4,%esp
801047b3:	89 d8                	mov    %ebx,%eax
801047b5:	5b                   	pop    %ebx
801047b6:	5d                   	pop    %ebp
801047b7:	c3                   	ret    
801047b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047bf:	90                   	nop

801047c0 <userinit>:
{
801047c0:	f3 0f 1e fb          	endbr32 
801047c4:	55                   	push   %ebp
801047c5:	89 e5                	mov    %esp,%ebp
801047c7:	53                   	push   %ebx
801047c8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801047cb:	e8 f0 fd ff ff       	call   801045c0 <allocproc>
801047d0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801047d2:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if ((p->pgdir = setupkvm()) == 0)
801047d7:	e8 54 36 00 00       	call   80107e30 <setupkvm>
801047dc:	89 43 04             	mov    %eax,0x4(%ebx)
801047df:	85 c0                	test   %eax,%eax
801047e1:	0f 84 d6 00 00 00    	je     801048bd <userinit+0xfd>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
801047e7:	83 ec 04             	sub    $0x4,%esp
801047ea:	68 2c 00 00 00       	push   $0x2c
801047ef:	68 60 b4 10 80       	push   $0x8010b460
801047f4:	68 50 8b 10 80       	push   $0x80108b50
801047f9:	e8 b2 be ff ff       	call   801006b0 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047fe:	83 c4 0c             	add    $0xc,%esp
80104801:	68 2c 00 00 00       	push   $0x2c
80104806:	68 60 b4 10 80       	push   $0x8010b460
8010480b:	ff 73 04             	pushl  0x4(%ebx)
8010480e:	e8 cd 32 00 00       	call   80107ae0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104813:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104816:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010481c:	6a 4c                	push   $0x4c
8010481e:	6a 00                	push   $0x0
80104820:	ff 73 18             	pushl  0x18(%ebx)
80104823:	e8 68 0c 00 00       	call   80105490 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104828:	8b 43 18             	mov    0x18(%ebx),%eax
8010482b:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104830:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104833:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104838:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010483c:	8b 43 18             	mov    0x18(%ebx),%eax
8010483f:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104843:	8b 43 18             	mov    0x18(%ebx),%eax
80104846:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010484a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010484e:	8b 43 18             	mov    0x18(%ebx),%eax
80104851:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104855:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104859:	8b 43 18             	mov    0x18(%ebx),%eax
8010485c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104863:	8b 43 18             	mov    0x18(%ebx),%eax
80104866:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
8010486d:	8b 43 18             	mov    0x18(%ebx),%eax
80104870:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104877:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010487a:	6a 10                	push   $0x10
8010487c:	68 57 8b 10 80       	push   $0x80108b57
80104881:	50                   	push   %eax
80104882:	e8 c9 0d 00 00       	call   80105650 <safestrcpy>
  p->cwd = namei("/");
80104887:	c7 04 24 60 8b 10 80 	movl   $0x80108b60,(%esp)
8010488e:	e8 9d d7 ff ff       	call   80102030 <namei>
80104893:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104896:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
8010489d:	e8 de 0a 00 00       	call   80105380 <acquire>
  p->state = RUNNABLE;
801048a2:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801048a9:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
801048b0:	e8 8b 0b 00 00       	call   80105440 <release>
}
801048b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048b8:	83 c4 10             	add    $0x10,%esp
801048bb:	c9                   	leave  
801048bc:	c3                   	ret    
    panic("userinit: out of memory?");
801048bd:	83 ec 0c             	sub    $0xc,%esp
801048c0:	68 37 8b 10 80       	push   $0x80108b37
801048c5:	e8 c6 ba ff ff       	call   80100390 <panic>
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048d0 <growproc>:
{
801048d0:	f3 0f 1e fb          	endbr32 
801048d4:	55                   	push   %ebp
801048d5:	89 e5                	mov    %esp,%ebp
801048d7:	56                   	push   %esi
801048d8:	53                   	push   %ebx
801048d9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801048dc:	e8 9f 09 00 00       	call   80105280 <pushcli>
  c = mycpu();
801048e1:	e8 1a fe ff ff       	call   80104700 <mycpu>
  p = c->proc;
801048e6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048ec:	e8 df 09 00 00       	call   801052d0 <popcli>
  sz = curproc->sz;
801048f1:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
801048f3:	85 f6                	test   %esi,%esi
801048f5:	7f 19                	jg     80104910 <growproc+0x40>
  else if (n < 0)
801048f7:	75 37                	jne    80104930 <growproc+0x60>
  switchuvm(curproc);
801048f9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801048fc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801048fe:	53                   	push   %ebx
801048ff:	e8 cc 30 00 00       	call   801079d0 <switchuvm>
  return 0;
80104904:	83 c4 10             	add    $0x10,%esp
80104907:	31 c0                	xor    %eax,%eax
}
80104909:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010490c:	5b                   	pop    %ebx
8010490d:	5e                   	pop    %esi
8010490e:	5d                   	pop    %ebp
8010490f:	c3                   	ret    
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104910:	83 ec 04             	sub    $0x4,%esp
80104913:	01 c6                	add    %eax,%esi
80104915:	56                   	push   %esi
80104916:	50                   	push   %eax
80104917:	ff 73 04             	pushl  0x4(%ebx)
8010491a:	e8 21 33 00 00       	call   80107c40 <allocuvm>
8010491f:	83 c4 10             	add    $0x10,%esp
80104922:	85 c0                	test   %eax,%eax
80104924:	75 d3                	jne    801048f9 <growproc+0x29>
      return -1;
80104926:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010492b:	eb dc                	jmp    80104909 <growproc+0x39>
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104930:	83 ec 04             	sub    $0x4,%esp
80104933:	01 c6                	add    %eax,%esi
80104935:	56                   	push   %esi
80104936:	50                   	push   %eax
80104937:	ff 73 04             	pushl  0x4(%ebx)
8010493a:	e8 41 34 00 00       	call   80107d80 <deallocuvm>
8010493f:	83 c4 10             	add    $0x10,%esp
80104942:	85 c0                	test   %eax,%eax
80104944:	75 b3                	jne    801048f9 <growproc+0x29>
80104946:	eb de                	jmp    80104926 <growproc+0x56>
80104948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494f:	90                   	nop

80104950 <fork>:
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	57                   	push   %edi
80104958:	56                   	push   %esi
80104959:	53                   	push   %ebx
8010495a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010495d:	e8 1e 09 00 00       	call   80105280 <pushcli>
  c = mycpu();
80104962:	e8 99 fd ff ff       	call   80104700 <mycpu>
  p = c->proc;
80104967:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010496d:	e8 5e 09 00 00       	call   801052d0 <popcli>
  if ((np = allocproc()) == 0)
80104972:	e8 49 fc ff ff       	call   801045c0 <allocproc>
80104977:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010497a:	85 c0                	test   %eax,%eax
8010497c:	0f 84 bb 00 00 00    	je     80104a3d <fork+0xed>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80104982:	83 ec 08             	sub    $0x8,%esp
80104985:	ff 33                	pushl  (%ebx)
80104987:	89 c7                	mov    %eax,%edi
80104989:	ff 73 04             	pushl  0x4(%ebx)
8010498c:	e8 6f 35 00 00       	call   80107f00 <copyuvm>
80104991:	83 c4 10             	add    $0x10,%esp
80104994:	89 47 04             	mov    %eax,0x4(%edi)
80104997:	85 c0                	test   %eax,%eax
80104999:	0f 84 a5 00 00 00    	je     80104a44 <fork+0xf4>
  np->sz = curproc->sz;
8010499f:	8b 03                	mov    (%ebx),%eax
801049a1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801049a4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801049a6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801049a9:	89 c8                	mov    %ecx,%eax
801049ab:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801049ae:	b9 13 00 00 00       	mov    $0x13,%ecx
801049b3:	8b 73 18             	mov    0x18(%ebx),%esi
801049b6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
801049b8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801049ba:	8b 40 18             	mov    0x18(%eax),%eax
801049bd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[i])
801049c8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801049cc:	85 c0                	test   %eax,%eax
801049ce:	74 13                	je     801049e3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
801049d0:	83 ec 0c             	sub    $0xc,%esp
801049d3:	50                   	push   %eax
801049d4:	e8 97 c4 ff ff       	call   80100e70 <filedup>
801049d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049dc:	83 c4 10             	add    $0x10,%esp
801049df:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
801049e3:	83 c6 01             	add    $0x1,%esi
801049e6:	83 fe 10             	cmp    $0x10,%esi
801049e9:	75 dd                	jne    801049c8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
801049eb:	83 ec 0c             	sub    $0xc,%esp
801049ee:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801049f1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801049f4:	e8 37 cd ff ff       	call   80101730 <idup>
801049f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801049fc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801049ff:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104a02:	8d 47 6c             	lea    0x6c(%edi),%eax
80104a05:	6a 10                	push   $0x10
80104a07:	53                   	push   %ebx
80104a08:	50                   	push   %eax
80104a09:	e8 42 0c 00 00       	call   80105650 <safestrcpy>
  pid = np->pid;
80104a0e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104a11:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
80104a18:	e8 63 09 00 00       	call   80105380 <acquire>
  np->state = RUNNABLE;
80104a1d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104a24:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
80104a2b:	e8 10 0a 00 00       	call   80105440 <release>
  return pid;
80104a30:	83 c4 10             	add    $0x10,%esp
}
80104a33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a36:	89 d8                	mov    %ebx,%eax
80104a38:	5b                   	pop    %ebx
80104a39:	5e                   	pop    %esi
80104a3a:	5f                   	pop    %edi
80104a3b:	5d                   	pop    %ebp
80104a3c:	c3                   	ret    
    return -1;
80104a3d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104a42:	eb ef                	jmp    80104a33 <fork+0xe3>
    kfree(np->kstack);
80104a44:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104a47:	83 ec 0c             	sub    $0xc,%esp
80104a4a:	ff 73 08             	pushl  0x8(%ebx)
80104a4d:	e8 2e db ff ff       	call   80102580 <kfree>
    np->kstack = 0;
80104a52:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104a59:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104a5c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104a63:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104a68:	eb c9                	jmp    80104a33 <fork+0xe3>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a70 <scheduler>:
{
80104a70:	f3 0f 1e fb          	endbr32 
80104a74:	55                   	push   %ebp
80104a75:	89 e5                	mov    %esp,%ebp
80104a77:	57                   	push   %edi
80104a78:	56                   	push   %esi
80104a79:	53                   	push   %ebx
80104a7a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104a7d:	e8 7e fc ff ff       	call   80104700 <mycpu>
  c->proc = 0;
80104a82:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104a89:	00 00 00 
  struct cpu *c = mycpu();
80104a8c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104a8e:	8d 78 04             	lea    0x4(%eax),%edi
80104a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104a98:	fb                   	sti    
    acquire(&ptable.lock);
80104a99:	83 ec 0c             	sub    $0xc,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a9c:	bb 94 9e 11 80       	mov    $0x80119e94,%ebx
    acquire(&ptable.lock);
80104aa1:	68 60 9e 11 80       	push   $0x80119e60
80104aa6:	e8 d5 08 00 00       	call   80105380 <acquire>
80104aab:	83 c4 10             	add    $0x10,%esp
80104aae:	66 90                	xchg   %ax,%ax
      if (p->state != RUNNABLE)
80104ab0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104ab4:	75 33                	jne    80104ae9 <scheduler+0x79>
      switchuvm(p);
80104ab6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104ab9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80104abf:	53                   	push   %ebx
80104ac0:	e8 0b 2f 00 00       	call   801079d0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104ac5:	58                   	pop    %eax
80104ac6:	5a                   	pop    %edx
80104ac7:	ff 73 1c             	pushl  0x1c(%ebx)
80104aca:	57                   	push   %edi
      p->state = RUNNING;
80104acb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104ad2:	e8 dc 0b 00 00       	call   801056b3 <swtch>
      switchkvm();
80104ad7:	e8 d4 2e 00 00       	call   801079b0 <switchkvm>
      c->proc = 0;
80104adc:	83 c4 10             	add    $0x10,%esp
80104adf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104ae6:	00 00 00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ae9:	83 c3 7c             	add    $0x7c,%ebx
80104aec:	81 fb 94 bd 11 80    	cmp    $0x8011bd94,%ebx
80104af2:	75 bc                	jne    80104ab0 <scheduler+0x40>
    release(&ptable.lock);
80104af4:	83 ec 0c             	sub    $0xc,%esp
80104af7:	68 60 9e 11 80       	push   $0x80119e60
80104afc:	e8 3f 09 00 00       	call   80105440 <release>
    sti();
80104b01:	83 c4 10             	add    $0x10,%esp
80104b04:	eb 92                	jmp    80104a98 <scheduler+0x28>
80104b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi

80104b10 <sched>:
{
80104b10:	f3 0f 1e fb          	endbr32 
80104b14:	55                   	push   %ebp
80104b15:	89 e5                	mov    %esp,%ebp
80104b17:	56                   	push   %esi
80104b18:	53                   	push   %ebx
  pushcli();
80104b19:	e8 62 07 00 00       	call   80105280 <pushcli>
  c = mycpu();
80104b1e:	e8 dd fb ff ff       	call   80104700 <mycpu>
  p = c->proc;
80104b23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b29:	e8 a2 07 00 00       	call   801052d0 <popcli>
  if (!holding(&ptable.lock))
80104b2e:	83 ec 0c             	sub    $0xc,%esp
80104b31:	68 60 9e 11 80       	push   $0x80119e60
80104b36:	e8 f5 07 00 00       	call   80105330 <holding>
80104b3b:	83 c4 10             	add    $0x10,%esp
80104b3e:	85 c0                	test   %eax,%eax
80104b40:	74 41                	je     80104b83 <sched+0x73>
  if (p->state == RUNNING)
80104b42:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104b46:	74 55                	je     80104b9d <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b48:	9c                   	pushf  
80104b49:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104b4a:	f6 c4 02             	test   $0x2,%ah
80104b4d:	75 41                	jne    80104b90 <sched+0x80>
  intena = mycpu()->intena;
80104b4f:	e8 ac fb ff ff       	call   80104700 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104b54:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104b57:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104b5d:	e8 9e fb ff ff       	call   80104700 <mycpu>
80104b62:	83 ec 08             	sub    $0x8,%esp
80104b65:	ff 70 04             	pushl  0x4(%eax)
80104b68:	53                   	push   %ebx
80104b69:	e8 45 0b 00 00       	call   801056b3 <swtch>
  mycpu()->intena = intena;
80104b6e:	e8 8d fb ff ff       	call   80104700 <mycpu>
}
80104b73:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104b76:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104b7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b7f:	5b                   	pop    %ebx
80104b80:	5e                   	pop    %esi
80104b81:	5d                   	pop    %ebp
80104b82:	c3                   	ret    
    panic("sched ptable.lock");
80104b83:	83 ec 0c             	sub    $0xc,%esp
80104b86:	68 62 8b 10 80       	push   $0x80108b62
80104b8b:	e8 00 b8 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	68 82 8b 10 80       	push   $0x80108b82
80104b98:	e8 f3 b7 ff ff       	call   80100390 <panic>
    panic("sched running");
80104b9d:	83 ec 0c             	sub    $0xc,%esp
80104ba0:	68 74 8b 10 80       	push   $0x80108b74
80104ba5:	e8 e6 b7 ff ff       	call   80100390 <panic>
80104baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bb0 <exit>:
{
80104bb0:	f3 0f 1e fb          	endbr32 
80104bb4:	55                   	push   %ebp
80104bb5:	89 e5                	mov    %esp,%ebp
80104bb7:	57                   	push   %edi
80104bb8:	56                   	push   %esi
80104bb9:	53                   	push   %ebx
80104bba:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104bbd:	e8 be 06 00 00       	call   80105280 <pushcli>
  c = mycpu();
80104bc2:	e8 39 fb ff ff       	call   80104700 <mycpu>
  p = c->proc;
80104bc7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104bcd:	e8 fe 06 00 00       	call   801052d0 <popcli>
  if (curproc == initproc)
80104bd2:	8d 5e 28             	lea    0x28(%esi),%ebx
80104bd5:	8d 7e 68             	lea    0x68(%esi),%edi
80104bd8:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104bde:	0f 84 f3 00 00 00    	je     80104cd7 <exit+0x127>
80104be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd])
80104be8:	8b 03                	mov    (%ebx),%eax
80104bea:	85 c0                	test   %eax,%eax
80104bec:	74 12                	je     80104c00 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80104bee:	83 ec 0c             	sub    $0xc,%esp
80104bf1:	50                   	push   %eax
80104bf2:	e8 c9 c2 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104bf7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104bfd:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80104c00:	83 c3 04             	add    $0x4,%ebx
80104c03:	39 df                	cmp    %ebx,%edi
80104c05:	75 e1                	jne    80104be8 <exit+0x38>
  begin_op();
80104c07:	e8 54 ef ff ff       	call   80103b60 <begin_op>
  iput(curproc->cwd);
80104c0c:	83 ec 0c             	sub    $0xc,%esp
80104c0f:	ff 76 68             	pushl  0x68(%esi)
80104c12:	e8 79 cc ff ff       	call   80101890 <iput>
  end_op();
80104c17:	e8 b4 ef ff ff       	call   80103bd0 <end_op>
  curproc->cwd = 0;
80104c1c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104c23:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
80104c2a:	e8 51 07 00 00       	call   80105380 <acquire>
  wakeup1(curproc->parent);
80104c2f:	8b 56 14             	mov    0x14(%esi),%edx
80104c32:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c35:	b8 94 9e 11 80       	mov    $0x80119e94,%eax
80104c3a:	eb 0e                	jmp    80104c4a <exit+0x9a>
80104c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c40:	83 c0 7c             	add    $0x7c,%eax
80104c43:	3d 94 bd 11 80       	cmp    $0x8011bd94,%eax
80104c48:	74 1c                	je     80104c66 <exit+0xb6>
    if (p->state == SLEEPING && p->chan == chan)
80104c4a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104c4e:	75 f0                	jne    80104c40 <exit+0x90>
80104c50:	3b 50 20             	cmp    0x20(%eax),%edx
80104c53:	75 eb                	jne    80104c40 <exit+0x90>
      p->state = RUNNABLE;
80104c55:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c5c:	83 c0 7c             	add    $0x7c,%eax
80104c5f:	3d 94 bd 11 80       	cmp    $0x8011bd94,%eax
80104c64:	75 e4                	jne    80104c4a <exit+0x9a>
      p->parent = initproc;
80104c66:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c6c:	ba 94 9e 11 80       	mov    $0x80119e94,%edx
80104c71:	eb 10                	jmp    80104c83 <exit+0xd3>
80104c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c77:	90                   	nop
80104c78:	83 c2 7c             	add    $0x7c,%edx
80104c7b:	81 fa 94 bd 11 80    	cmp    $0x8011bd94,%edx
80104c81:	74 3b                	je     80104cbe <exit+0x10e>
    if (p->parent == curproc)
80104c83:	39 72 14             	cmp    %esi,0x14(%edx)
80104c86:	75 f0                	jne    80104c78 <exit+0xc8>
      if (p->state == ZOMBIE)
80104c88:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104c8c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
80104c8f:	75 e7                	jne    80104c78 <exit+0xc8>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c91:	b8 94 9e 11 80       	mov    $0x80119e94,%eax
80104c96:	eb 12                	jmp    80104caa <exit+0xfa>
80104c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9f:	90                   	nop
80104ca0:	83 c0 7c             	add    $0x7c,%eax
80104ca3:	3d 94 bd 11 80       	cmp    $0x8011bd94,%eax
80104ca8:	74 ce                	je     80104c78 <exit+0xc8>
    if (p->state == SLEEPING && p->chan == chan)
80104caa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104cae:	75 f0                	jne    80104ca0 <exit+0xf0>
80104cb0:	3b 48 20             	cmp    0x20(%eax),%ecx
80104cb3:	75 eb                	jne    80104ca0 <exit+0xf0>
      p->state = RUNNABLE;
80104cb5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104cbc:	eb e2                	jmp    80104ca0 <exit+0xf0>
  curproc->state = ZOMBIE;
80104cbe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104cc5:	e8 46 fe ff ff       	call   80104b10 <sched>
  panic("zombie exit");
80104cca:	83 ec 0c             	sub    $0xc,%esp
80104ccd:	68 a3 8b 10 80       	push   $0x80108ba3
80104cd2:	e8 b9 b6 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104cd7:	83 ec 0c             	sub    $0xc,%esp
80104cda:	68 96 8b 10 80       	push   $0x80108b96
80104cdf:	e8 ac b6 ff ff       	call   80100390 <panic>
80104ce4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cef:	90                   	nop

80104cf0 <yield>:
{
80104cf0:	f3 0f 1e fb          	endbr32 
80104cf4:	55                   	push   %ebp
80104cf5:	89 e5                	mov    %esp,%ebp
80104cf7:	53                   	push   %ebx
80104cf8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
80104cfb:	68 60 9e 11 80       	push   $0x80119e60
80104d00:	e8 7b 06 00 00       	call   80105380 <acquire>
  pushcli();
80104d05:	e8 76 05 00 00       	call   80105280 <pushcli>
  c = mycpu();
80104d0a:	e8 f1 f9 ff ff       	call   80104700 <mycpu>
  p = c->proc;
80104d0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d15:	e8 b6 05 00 00       	call   801052d0 <popcli>
  myproc()->state = RUNNABLE;
80104d1a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104d21:	e8 ea fd ff ff       	call   80104b10 <sched>
  release(&ptable.lock);
80104d26:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
80104d2d:	e8 0e 07 00 00       	call   80105440 <release>
}
80104d32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d35:	83 c4 10             	add    $0x10,%esp
80104d38:	c9                   	leave  
80104d39:	c3                   	ret    
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d40 <sleep>:
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
80104d45:	89 e5                	mov    %esp,%ebp
80104d47:	57                   	push   %edi
80104d48:	56                   	push   %esi
80104d49:	53                   	push   %ebx
80104d4a:	83 ec 0c             	sub    $0xc,%esp
80104d4d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104d50:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104d53:	e8 28 05 00 00       	call   80105280 <pushcli>
  c = mycpu();
80104d58:	e8 a3 f9 ff ff       	call   80104700 <mycpu>
  p = c->proc;
80104d5d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d63:	e8 68 05 00 00       	call   801052d0 <popcli>
  if (p == 0)
80104d68:	85 db                	test   %ebx,%ebx
80104d6a:	0f 84 83 00 00 00    	je     80104df3 <sleep+0xb3>
  if (lk == 0)
80104d70:	85 f6                	test   %esi,%esi
80104d72:	74 72                	je     80104de6 <sleep+0xa6>
  if (lk != &ptable.lock)
80104d74:	81 fe 60 9e 11 80    	cmp    $0x80119e60,%esi
80104d7a:	74 4c                	je     80104dc8 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
80104d7c:	83 ec 0c             	sub    $0xc,%esp
80104d7f:	68 60 9e 11 80       	push   $0x80119e60
80104d84:	e8 f7 05 00 00       	call   80105380 <acquire>
    release(lk);
80104d89:	89 34 24             	mov    %esi,(%esp)
80104d8c:	e8 af 06 00 00       	call   80105440 <release>
  p->chan = chan;
80104d91:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104d94:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104d9b:	e8 70 fd ff ff       	call   80104b10 <sched>
  p->chan = 0;
80104da0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104da7:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
80104dae:	e8 8d 06 00 00       	call   80105440 <release>
    acquire(lk);
80104db3:	89 75 08             	mov    %esi,0x8(%ebp)
80104db6:	83 c4 10             	add    $0x10,%esp
}
80104db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dbc:	5b                   	pop    %ebx
80104dbd:	5e                   	pop    %esi
80104dbe:	5f                   	pop    %edi
80104dbf:	5d                   	pop    %ebp
    acquire(lk);
80104dc0:	e9 bb 05 00 00       	jmp    80105380 <acquire>
80104dc5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104dc8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104dcb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104dd2:	e8 39 fd ff ff       	call   80104b10 <sched>
  p->chan = 0;
80104dd7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104de1:	5b                   	pop    %ebx
80104de2:	5e                   	pop    %esi
80104de3:	5f                   	pop    %edi
80104de4:	5d                   	pop    %ebp
80104de5:	c3                   	ret    
    panic("sleep without lk");
80104de6:	83 ec 0c             	sub    $0xc,%esp
80104de9:	68 b5 8b 10 80       	push   $0x80108bb5
80104dee:	e8 9d b5 ff ff       	call   80100390 <panic>
    panic("sleep");
80104df3:	83 ec 0c             	sub    $0xc,%esp
80104df6:	68 af 8b 10 80       	push   $0x80108baf
80104dfb:	e8 90 b5 ff ff       	call   80100390 <panic>

80104e00 <wait>:
{
80104e00:	f3 0f 1e fb          	endbr32 
80104e04:	55                   	push   %ebp
80104e05:	89 e5                	mov    %esp,%ebp
80104e07:	56                   	push   %esi
80104e08:	53                   	push   %ebx
  pushcli();
80104e09:	e8 72 04 00 00       	call   80105280 <pushcli>
  c = mycpu();
80104e0e:	e8 ed f8 ff ff       	call   80104700 <mycpu>
  p = c->proc;
80104e13:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104e19:	e8 b2 04 00 00       	call   801052d0 <popcli>
  acquire(&ptable.lock);
80104e1e:	83 ec 0c             	sub    $0xc,%esp
80104e21:	68 60 9e 11 80       	push   $0x80119e60
80104e26:	e8 55 05 00 00       	call   80105380 <acquire>
80104e2b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104e2e:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e30:	bb 94 9e 11 80       	mov    $0x80119e94,%ebx
80104e35:	eb 14                	jmp    80104e4b <wait+0x4b>
80104e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3e:	66 90                	xchg   %ax,%ax
80104e40:	83 c3 7c             	add    $0x7c,%ebx
80104e43:	81 fb 94 bd 11 80    	cmp    $0x8011bd94,%ebx
80104e49:	74 1b                	je     80104e66 <wait+0x66>
      if (p->parent != curproc)
80104e4b:	39 73 14             	cmp    %esi,0x14(%ebx)
80104e4e:	75 f0                	jne    80104e40 <wait+0x40>
      if (p->state == ZOMBIE)
80104e50:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104e54:	74 32                	je     80104e88 <wait+0x88>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e56:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104e59:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e5e:	81 fb 94 bd 11 80    	cmp    $0x8011bd94,%ebx
80104e64:	75 e5                	jne    80104e4b <wait+0x4b>
    if (!havekids || curproc->killed)
80104e66:	85 c0                	test   %eax,%eax
80104e68:	74 74                	je     80104ede <wait+0xde>
80104e6a:	8b 46 24             	mov    0x24(%esi),%eax
80104e6d:	85 c0                	test   %eax,%eax
80104e6f:	75 6d                	jne    80104ede <wait+0xde>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
80104e71:	83 ec 08             	sub    $0x8,%esp
80104e74:	68 60 9e 11 80       	push   $0x80119e60
80104e79:	56                   	push   %esi
80104e7a:	e8 c1 fe ff ff       	call   80104d40 <sleep>
    havekids = 0;
80104e7f:	83 c4 10             	add    $0x10,%esp
80104e82:	eb aa                	jmp    80104e2e <wait+0x2e>
80104e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104e88:	83 ec 0c             	sub    $0xc,%esp
80104e8b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104e8e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104e91:	e8 ea d6 ff ff       	call   80102580 <kfree>
        freevm(p->pgdir);
80104e96:	5a                   	pop    %edx
80104e97:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104e9a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104ea1:	e8 0a 2f 00 00       	call   80107db0 <freevm>
        release(&ptable.lock);
80104ea6:	c7 04 24 60 9e 11 80 	movl   $0x80119e60,(%esp)
        p->pid = 0;
80104ead:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104eb4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104ebb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104ebf:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104ec6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104ecd:	e8 6e 05 00 00       	call   80105440 <release>
        return pid;
80104ed2:	83 c4 10             	add    $0x10,%esp
}
80104ed5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed8:	89 f0                	mov    %esi,%eax
80104eda:	5b                   	pop    %ebx
80104edb:	5e                   	pop    %esi
80104edc:	5d                   	pop    %ebp
80104edd:	c3                   	ret    
      release(&ptable.lock);
80104ede:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104ee1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104ee6:	68 60 9e 11 80       	push   $0x80119e60
80104eeb:	e8 50 05 00 00       	call   80105440 <release>
      return -1;
80104ef0:	83 c4 10             	add    $0x10,%esp
80104ef3:	eb e0                	jmp    80104ed5 <wait+0xd5>
80104ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f00 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	53                   	push   %ebx
80104f08:	83 ec 10             	sub    $0x10,%esp
80104f0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104f0e:	68 60 9e 11 80       	push   $0x80119e60
80104f13:	e8 68 04 00 00       	call   80105380 <acquire>
80104f18:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f1b:	b8 94 9e 11 80       	mov    $0x80119e94,%eax
80104f20:	eb 10                	jmp    80104f32 <wakeup+0x32>
80104f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f28:	83 c0 7c             	add    $0x7c,%eax
80104f2b:	3d 94 bd 11 80       	cmp    $0x8011bd94,%eax
80104f30:	74 1c                	je     80104f4e <wakeup+0x4e>
    if (p->state == SLEEPING && p->chan == chan)
80104f32:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104f36:	75 f0                	jne    80104f28 <wakeup+0x28>
80104f38:	3b 58 20             	cmp    0x20(%eax),%ebx
80104f3b:	75 eb                	jne    80104f28 <wakeup+0x28>
      p->state = RUNNABLE;
80104f3d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f44:	83 c0 7c             	add    $0x7c,%eax
80104f47:	3d 94 bd 11 80       	cmp    $0x8011bd94,%eax
80104f4c:	75 e4                	jne    80104f32 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
80104f4e:	c7 45 08 60 9e 11 80 	movl   $0x80119e60,0x8(%ebp)
}
80104f55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f58:	c9                   	leave  
  release(&ptable.lock);
80104f59:	e9 e2 04 00 00       	jmp    80105440 <release>
80104f5e:	66 90                	xchg   %ax,%ax

80104f60 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104f60:	f3 0f 1e fb          	endbr32 
80104f64:	55                   	push   %ebp
80104f65:	89 e5                	mov    %esp,%ebp
80104f67:	53                   	push   %ebx
80104f68:	83 ec 10             	sub    $0x10,%esp
80104f6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104f6e:	68 60 9e 11 80       	push   $0x80119e60
80104f73:	e8 08 04 00 00       	call   80105380 <acquire>
80104f78:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f7b:	b8 94 9e 11 80       	mov    $0x80119e94,%eax
80104f80:	eb 10                	jmp    80104f92 <kill+0x32>
80104f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f88:	83 c0 7c             	add    $0x7c,%eax
80104f8b:	3d 94 bd 11 80       	cmp    $0x8011bd94,%eax
80104f90:	74 36                	je     80104fc8 <kill+0x68>
  {
    if (p->pid == pid)
80104f92:	39 58 10             	cmp    %ebx,0x10(%eax)
80104f95:	75 f1                	jne    80104f88 <kill+0x28>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104f97:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104f9b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
80104fa2:	75 07                	jne    80104fab <kill+0x4b>
        p->state = RUNNABLE;
80104fa4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104fab:	83 ec 0c             	sub    $0xc,%esp
80104fae:	68 60 9e 11 80       	push   $0x80119e60
80104fb3:	e8 88 04 00 00       	call   80105440 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104fb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104fbb:	83 c4 10             	add    $0x10,%esp
80104fbe:	31 c0                	xor    %eax,%eax
}
80104fc0:	c9                   	leave  
80104fc1:	c3                   	ret    
80104fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104fc8:	83 ec 0c             	sub    $0xc,%esp
80104fcb:	68 60 9e 11 80       	push   $0x80119e60
80104fd0:	e8 6b 04 00 00       	call   80105440 <release>
}
80104fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fe0:	c9                   	leave  
80104fe1:	c3                   	ret    
80104fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ff0 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	57                   	push   %edi
80104ff8:	56                   	push   %esi
80104ff9:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104ffc:	53                   	push   %ebx
80104ffd:	bb 00 9f 11 80       	mov    $0x80119f00,%ebx
80105002:	83 ec 3c             	sub    $0x3c,%esp
80105005:	eb 28                	jmp    8010502f <procdump+0x3f>
80105007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500e:	66 90                	xchg   %ax,%ax
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105010:	83 ec 0c             	sub    $0xc,%esp
80105013:	68 8b 8f 10 80       	push   $0x80108f8b
80105018:	e8 93 b6 ff ff       	call   801006b0 <cprintf>
8010501d:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105020:	83 c3 7c             	add    $0x7c,%ebx
80105023:	81 fb 00 be 11 80    	cmp    $0x8011be00,%ebx
80105029:	0f 84 81 00 00 00    	je     801050b0 <procdump+0xc0>
    if (p->state == UNUSED)
8010502f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80105032:	85 c0                	test   %eax,%eax
80105034:	74 ea                	je     80105020 <procdump+0x30>
      state = "???";
80105036:	ba c6 8b 10 80       	mov    $0x80108bc6,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010503b:	83 f8 05             	cmp    $0x5,%eax
8010503e:	77 11                	ja     80105051 <procdump+0x61>
80105040:	8b 14 85 28 8c 10 80 	mov    -0x7fef73d8(,%eax,4),%edx
      state = "???";
80105047:	b8 c6 8b 10 80       	mov    $0x80108bc6,%eax
8010504c:	85 d2                	test   %edx,%edx
8010504e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80105051:	53                   	push   %ebx
80105052:	52                   	push   %edx
80105053:	ff 73 a4             	pushl  -0x5c(%ebx)
80105056:	68 ca 8b 10 80       	push   $0x80108bca
8010505b:	e8 50 b6 ff ff       	call   801006b0 <cprintf>
    if (p->state == SLEEPING)
80105060:	83 c4 10             	add    $0x10,%esp
80105063:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80105067:	75 a7                	jne    80105010 <procdump+0x20>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80105069:	83 ec 08             	sub    $0x8,%esp
8010506c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010506f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80105072:	50                   	push   %eax
80105073:	8b 43 b0             	mov    -0x50(%ebx),%eax
80105076:	8b 40 0c             	mov    0xc(%eax),%eax
80105079:	83 c0 08             	add    $0x8,%eax
8010507c:	50                   	push   %eax
8010507d:	e8 9e 01 00 00       	call   80105220 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80105082:	83 c4 10             	add    $0x10,%esp
80105085:	8d 76 00             	lea    0x0(%esi),%esi
80105088:	8b 17                	mov    (%edi),%edx
8010508a:	85 d2                	test   %edx,%edx
8010508c:	74 82                	je     80105010 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010508e:	83 ec 08             	sub    $0x8,%esp
80105091:	83 c7 04             	add    $0x4,%edi
80105094:	52                   	push   %edx
80105095:	68 21 81 10 80       	push   $0x80108121
8010509a:	e8 11 b6 ff ff       	call   801006b0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
8010509f:	83 c4 10             	add    $0x10,%esp
801050a2:	39 fe                	cmp    %edi,%esi
801050a4:	75 e2                	jne    80105088 <procdump+0x98>
801050a6:	e9 65 ff ff ff       	jmp    80105010 <procdump+0x20>
801050ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050af:	90                   	nop
  }
}
801050b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050b3:	5b                   	pop    %ebx
801050b4:	5e                   	pop    %esi
801050b5:	5f                   	pop    %edi
801050b6:	5d                   	pop    %ebp
801050b7:	c3                   	ret    
801050b8:	66 90                	xchg   %ax,%ax
801050ba:	66 90                	xchg   %ax,%ax
801050bc:	66 90                	xchg   %ax,%ax
801050be:	66 90                	xchg   %ax,%ax

801050c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	53                   	push   %ebx
801050c8:	83 ec 0c             	sub    $0xc,%esp
801050cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801050ce:	68 40 8c 10 80       	push   $0x80108c40
801050d3:	8d 43 04             	lea    0x4(%ebx),%eax
801050d6:	50                   	push   %eax
801050d7:	e8 24 01 00 00       	call   80105200 <initlock>
  lk->name = name;
801050dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801050df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801050e5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801050e8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801050ef:	89 43 38             	mov    %eax,0x38(%ebx)
}
801050f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
801050f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fe:	66 90                	xchg   %ax,%ax

80105100 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105100:	f3 0f 1e fb          	endbr32 
80105104:	55                   	push   %ebp
80105105:	89 e5                	mov    %esp,%ebp
80105107:	56                   	push   %esi
80105108:	53                   	push   %ebx
80105109:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010510c:	8d 73 04             	lea    0x4(%ebx),%esi
8010510f:	83 ec 0c             	sub    $0xc,%esp
80105112:	56                   	push   %esi
80105113:	e8 68 02 00 00       	call   80105380 <acquire>
  while (lk->locked) {
80105118:	8b 13                	mov    (%ebx),%edx
8010511a:	83 c4 10             	add    $0x10,%esp
8010511d:	85 d2                	test   %edx,%edx
8010511f:	74 1a                	je     8010513b <acquiresleep+0x3b>
80105121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80105128:	83 ec 08             	sub    $0x8,%esp
8010512b:	56                   	push   %esi
8010512c:	53                   	push   %ebx
8010512d:	e8 0e fc ff ff       	call   80104d40 <sleep>
  while (lk->locked) {
80105132:	8b 03                	mov    (%ebx),%eax
80105134:	83 c4 10             	add    $0x10,%esp
80105137:	85 c0                	test   %eax,%eax
80105139:	75 ed                	jne    80105128 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010513b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105141:	e8 4a f6 ff ff       	call   80104790 <myproc>
80105146:	8b 40 10             	mov    0x10(%eax),%eax
80105149:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010514c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010514f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105152:	5b                   	pop    %ebx
80105153:	5e                   	pop    %esi
80105154:	5d                   	pop    %ebp
  release(&lk->lk);
80105155:	e9 e6 02 00 00       	jmp    80105440 <release>
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105160 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
80105167:	56                   	push   %esi
80105168:	53                   	push   %ebx
80105169:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010516c:	8d 73 04             	lea    0x4(%ebx),%esi
8010516f:	83 ec 0c             	sub    $0xc,%esp
80105172:	56                   	push   %esi
80105173:	e8 08 02 00 00       	call   80105380 <acquire>
  lk->locked = 0;
80105178:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010517e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105185:	89 1c 24             	mov    %ebx,(%esp)
80105188:	e8 73 fd ff ff       	call   80104f00 <wakeup>
  release(&lk->lk);
8010518d:	89 75 08             	mov    %esi,0x8(%ebp)
80105190:	83 c4 10             	add    $0x10,%esp
}
80105193:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105196:	5b                   	pop    %ebx
80105197:	5e                   	pop    %esi
80105198:	5d                   	pop    %ebp
  release(&lk->lk);
80105199:	e9 a2 02 00 00       	jmp    80105440 <release>
8010519e:	66 90                	xchg   %ax,%ax

801051a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801051a0:	f3 0f 1e fb          	endbr32 
801051a4:	55                   	push   %ebp
801051a5:	89 e5                	mov    %esp,%ebp
801051a7:	57                   	push   %edi
801051a8:	31 ff                	xor    %edi,%edi
801051aa:	56                   	push   %esi
801051ab:	53                   	push   %ebx
801051ac:	83 ec 18             	sub    $0x18,%esp
801051af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801051b2:	8d 73 04             	lea    0x4(%ebx),%esi
801051b5:	56                   	push   %esi
801051b6:	e8 c5 01 00 00       	call   80105380 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801051bb:	8b 03                	mov    (%ebx),%eax
801051bd:	83 c4 10             	add    $0x10,%esp
801051c0:	85 c0                	test   %eax,%eax
801051c2:	75 1c                	jne    801051e0 <holdingsleep+0x40>
  release(&lk->lk);
801051c4:	83 ec 0c             	sub    $0xc,%esp
801051c7:	56                   	push   %esi
801051c8:	e8 73 02 00 00       	call   80105440 <release>
  return r;
}
801051cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051d0:	89 f8                	mov    %edi,%eax
801051d2:	5b                   	pop    %ebx
801051d3:	5e                   	pop    %esi
801051d4:	5f                   	pop    %edi
801051d5:	5d                   	pop    %ebp
801051d6:	c3                   	ret    
801051d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051de:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801051e0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801051e3:	e8 a8 f5 ff ff       	call   80104790 <myproc>
801051e8:	39 58 10             	cmp    %ebx,0x10(%eax)
801051eb:	0f 94 c0             	sete   %al
801051ee:	0f b6 c0             	movzbl %al,%eax
801051f1:	89 c7                	mov    %eax,%edi
801051f3:	eb cf                	jmp    801051c4 <holdingsleep+0x24>
801051f5:	66 90                	xchg   %ax,%ax
801051f7:	66 90                	xchg   %ax,%ax
801051f9:	66 90                	xchg   %ax,%ax
801051fb:	66 90                	xchg   %ax,%ax
801051fd:	66 90                	xchg   %ax,%ax
801051ff:	90                   	nop

80105200 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010520a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010520d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80105213:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105216:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010521d:	5d                   	pop    %ebp
8010521e:	c3                   	ret    
8010521f:	90                   	nop

80105220 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105220:	f3 0f 1e fb          	endbr32 
80105224:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105225:	31 d2                	xor    %edx,%edx
{
80105227:	89 e5                	mov    %esp,%ebp
80105229:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010522a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010522d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80105230:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80105233:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105237:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105238:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010523e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105244:	77 1a                	ja     80105260 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105246:	8b 58 04             	mov    0x4(%eax),%ebx
80105249:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010524c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010524f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105251:	83 fa 0a             	cmp    $0xa,%edx
80105254:	75 e2                	jne    80105238 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105256:	5b                   	pop    %ebx
80105257:	5d                   	pop    %ebp
80105258:	c3                   	ret    
80105259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105260:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105263:	8d 51 28             	lea    0x28(%ecx),%edx
80105266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105276:	83 c0 04             	add    $0x4,%eax
80105279:	39 d0                	cmp    %edx,%eax
8010527b:	75 f3                	jne    80105270 <getcallerpcs+0x50>
}
8010527d:	5b                   	pop    %ebx
8010527e:	5d                   	pop    %ebp
8010527f:	c3                   	ret    

80105280 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105280:	f3 0f 1e fb          	endbr32 
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
80105287:	53                   	push   %ebx
80105288:	83 ec 04             	sub    $0x4,%esp
8010528b:	9c                   	pushf  
8010528c:	5b                   	pop    %ebx
  asm volatile("cli");
8010528d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010528e:	e8 6d f4 ff ff       	call   80104700 <mycpu>
80105293:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105299:	85 c0                	test   %eax,%eax
8010529b:	74 13                	je     801052b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010529d:	e8 5e f4 ff ff       	call   80104700 <mycpu>
801052a2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801052a9:	83 c4 04             	add    $0x4,%esp
801052ac:	5b                   	pop    %ebx
801052ad:	5d                   	pop    %ebp
801052ae:	c3                   	ret    
801052af:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801052b0:	e8 4b f4 ff ff       	call   80104700 <mycpu>
801052b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801052bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801052c1:	eb da                	jmp    8010529d <pushcli+0x1d>
801052c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052d0 <popcli>:

void
popcli(void)
{
801052d0:	f3 0f 1e fb          	endbr32 
801052d4:	55                   	push   %ebp
801052d5:	89 e5                	mov    %esp,%ebp
801052d7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801052da:	9c                   	pushf  
801052db:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801052dc:	f6 c4 02             	test   $0x2,%ah
801052df:	75 31                	jne    80105312 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801052e1:	e8 1a f4 ff ff       	call   80104700 <mycpu>
801052e6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801052ed:	78 30                	js     8010531f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801052ef:	e8 0c f4 ff ff       	call   80104700 <mycpu>
801052f4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801052fa:	85 d2                	test   %edx,%edx
801052fc:	74 02                	je     80105300 <popcli+0x30>
    sti();
}
801052fe:	c9                   	leave  
801052ff:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105300:	e8 fb f3 ff ff       	call   80104700 <mycpu>
80105305:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010530b:	85 c0                	test   %eax,%eax
8010530d:	74 ef                	je     801052fe <popcli+0x2e>
  asm volatile("sti");
8010530f:	fb                   	sti    
}
80105310:	c9                   	leave  
80105311:	c3                   	ret    
    panic("popcli - interruptible");
80105312:	83 ec 0c             	sub    $0xc,%esp
80105315:	68 4b 8c 10 80       	push   $0x80108c4b
8010531a:	e8 71 b0 ff ff       	call   80100390 <panic>
    panic("popcli");
8010531f:	83 ec 0c             	sub    $0xc,%esp
80105322:	68 62 8c 10 80       	push   $0x80108c62
80105327:	e8 64 b0 ff ff       	call   80100390 <panic>
8010532c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105330 <holding>:
{
80105330:	f3 0f 1e fb          	endbr32 
80105334:	55                   	push   %ebp
80105335:	89 e5                	mov    %esp,%ebp
80105337:	56                   	push   %esi
80105338:	53                   	push   %ebx
80105339:	8b 75 08             	mov    0x8(%ebp),%esi
8010533c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010533e:	e8 3d ff ff ff       	call   80105280 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105343:	8b 06                	mov    (%esi),%eax
80105345:	85 c0                	test   %eax,%eax
80105347:	75 0f                	jne    80105358 <holding+0x28>
  popcli();
80105349:	e8 82 ff ff ff       	call   801052d0 <popcli>
}
8010534e:	89 d8                	mov    %ebx,%eax
80105350:	5b                   	pop    %ebx
80105351:	5e                   	pop    %esi
80105352:	5d                   	pop    %ebp
80105353:	c3                   	ret    
80105354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105358:	8b 5e 08             	mov    0x8(%esi),%ebx
8010535b:	e8 a0 f3 ff ff       	call   80104700 <mycpu>
80105360:	39 c3                	cmp    %eax,%ebx
80105362:	0f 94 c3             	sete   %bl
  popcli();
80105365:	e8 66 ff ff ff       	call   801052d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010536a:	0f b6 db             	movzbl %bl,%ebx
}
8010536d:	89 d8                	mov    %ebx,%eax
8010536f:	5b                   	pop    %ebx
80105370:	5e                   	pop    %esi
80105371:	5d                   	pop    %ebp
80105372:	c3                   	ret    
80105373:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010537a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105380 <acquire>:
{
80105380:	f3 0f 1e fb          	endbr32 
80105384:	55                   	push   %ebp
80105385:	89 e5                	mov    %esp,%ebp
80105387:	56                   	push   %esi
80105388:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105389:	e8 f2 fe ff ff       	call   80105280 <pushcli>
  if(holding(lk))
8010538e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105391:	83 ec 0c             	sub    $0xc,%esp
80105394:	53                   	push   %ebx
80105395:	e8 96 ff ff ff       	call   80105330 <holding>
8010539a:	83 c4 10             	add    $0x10,%esp
8010539d:	85 c0                	test   %eax,%eax
8010539f:	0f 85 7f 00 00 00    	jne    80105424 <acquire+0xa4>
801053a5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801053a7:	ba 01 00 00 00       	mov    $0x1,%edx
801053ac:	eb 05                	jmp    801053b3 <acquire+0x33>
801053ae:	66 90                	xchg   %ax,%ax
801053b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801053b3:	89 d0                	mov    %edx,%eax
801053b5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801053b8:	85 c0                	test   %eax,%eax
801053ba:	75 f4                	jne    801053b0 <acquire+0x30>
  __sync_synchronize();
801053bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801053c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801053c4:	e8 37 f3 ff ff       	call   80104700 <mycpu>
801053c9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801053cc:	89 e8                	mov    %ebp,%eax
801053ce:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801053d0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801053d6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801053dc:	77 22                	ja     80105400 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801053de:	8b 50 04             	mov    0x4(%eax),%edx
801053e1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801053e5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801053e8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801053ea:	83 fe 0a             	cmp    $0xa,%esi
801053ed:	75 e1                	jne    801053d0 <acquire+0x50>
}
801053ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053f2:	5b                   	pop    %ebx
801053f3:	5e                   	pop    %esi
801053f4:	5d                   	pop    %ebp
801053f5:	c3                   	ret    
801053f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80105400:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80105404:	83 c3 34             	add    $0x34,%ebx
80105407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105416:	83 c0 04             	add    $0x4,%eax
80105419:	39 d8                	cmp    %ebx,%eax
8010541b:	75 f3                	jne    80105410 <acquire+0x90>
}
8010541d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105420:	5b                   	pop    %ebx
80105421:	5e                   	pop    %esi
80105422:	5d                   	pop    %ebp
80105423:	c3                   	ret    
    panic("acquire");
80105424:	83 ec 0c             	sub    $0xc,%esp
80105427:	68 69 8c 10 80       	push   $0x80108c69
8010542c:	e8 5f af ff ff       	call   80100390 <panic>
80105431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543f:	90                   	nop

80105440 <release>:
{
80105440:	f3 0f 1e fb          	endbr32 
80105444:	55                   	push   %ebp
80105445:	89 e5                	mov    %esp,%ebp
80105447:	53                   	push   %ebx
80105448:	83 ec 10             	sub    $0x10,%esp
8010544b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010544e:	53                   	push   %ebx
8010544f:	e8 dc fe ff ff       	call   80105330 <holding>
80105454:	83 c4 10             	add    $0x10,%esp
80105457:	85 c0                	test   %eax,%eax
80105459:	74 22                	je     8010547d <release+0x3d>
  lk->pcs[0] = 0;
8010545b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105462:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105469:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010546e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105474:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105477:	c9                   	leave  
  popcli();
80105478:	e9 53 fe ff ff       	jmp    801052d0 <popcli>
    panic("release");
8010547d:	83 ec 0c             	sub    $0xc,%esp
80105480:	68 71 8c 10 80       	push   $0x80108c71
80105485:	e8 06 af ff ff       	call   80100390 <panic>
8010548a:	66 90                	xchg   %ax,%ax
8010548c:	66 90                	xchg   %ax,%ax
8010548e:	66 90                	xchg   %ax,%ax

80105490 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105490:	f3 0f 1e fb          	endbr32 
80105494:	55                   	push   %ebp
80105495:	89 e5                	mov    %esp,%ebp
80105497:	57                   	push   %edi
80105498:	8b 55 08             	mov    0x8(%ebp),%edx
8010549b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010549e:	53                   	push   %ebx
8010549f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801054a2:	89 d7                	mov    %edx,%edi
801054a4:	09 cf                	or     %ecx,%edi
801054a6:	83 e7 03             	and    $0x3,%edi
801054a9:	75 25                	jne    801054d0 <memset+0x40>
    c &= 0xFF;
801054ab:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801054ae:	c1 e0 18             	shl    $0x18,%eax
801054b1:	89 fb                	mov    %edi,%ebx
801054b3:	c1 e9 02             	shr    $0x2,%ecx
801054b6:	c1 e3 10             	shl    $0x10,%ebx
801054b9:	09 d8                	or     %ebx,%eax
801054bb:	09 f8                	or     %edi,%eax
801054bd:	c1 e7 08             	shl    $0x8,%edi
801054c0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801054c2:	89 d7                	mov    %edx,%edi
801054c4:	fc                   	cld    
801054c5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801054c7:	5b                   	pop    %ebx
801054c8:	89 d0                	mov    %edx,%eax
801054ca:	5f                   	pop    %edi
801054cb:	5d                   	pop    %ebp
801054cc:	c3                   	ret    
801054cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801054d0:	89 d7                	mov    %edx,%edi
801054d2:	fc                   	cld    
801054d3:	f3 aa                	rep stos %al,%es:(%edi)
801054d5:	5b                   	pop    %ebx
801054d6:	89 d0                	mov    %edx,%eax
801054d8:	5f                   	pop    %edi
801054d9:	5d                   	pop    %ebp
801054da:	c3                   	ret    
801054db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054df:	90                   	nop

801054e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	56                   	push   %esi
801054e8:	8b 75 10             	mov    0x10(%ebp),%esi
801054eb:	8b 55 08             	mov    0x8(%ebp),%edx
801054ee:	53                   	push   %ebx
801054ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801054f2:	85 f6                	test   %esi,%esi
801054f4:	74 2a                	je     80105520 <memcmp+0x40>
801054f6:	01 c6                	add    %eax,%esi
801054f8:	eb 10                	jmp    8010550a <memcmp+0x2a>
801054fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105500:	83 c0 01             	add    $0x1,%eax
80105503:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105506:	39 f0                	cmp    %esi,%eax
80105508:	74 16                	je     80105520 <memcmp+0x40>
    if(*s1 != *s2)
8010550a:	0f b6 0a             	movzbl (%edx),%ecx
8010550d:	0f b6 18             	movzbl (%eax),%ebx
80105510:	38 d9                	cmp    %bl,%cl
80105512:	74 ec                	je     80105500 <memcmp+0x20>
      return *s1 - *s2;
80105514:	0f b6 c1             	movzbl %cl,%eax
80105517:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105519:	5b                   	pop    %ebx
8010551a:	5e                   	pop    %esi
8010551b:	5d                   	pop    %ebp
8010551c:	c3                   	ret    
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
80105520:	5b                   	pop    %ebx
  return 0;
80105521:	31 c0                	xor    %eax,%eax
}
80105523:	5e                   	pop    %esi
80105524:	5d                   	pop    %ebp
80105525:	c3                   	ret    
80105526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552d:	8d 76 00             	lea    0x0(%esi),%esi

80105530 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105530:	f3 0f 1e fb          	endbr32 
80105534:	55                   	push   %ebp
80105535:	89 e5                	mov    %esp,%ebp
80105537:	57                   	push   %edi
80105538:	8b 55 08             	mov    0x8(%ebp),%edx
8010553b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010553e:	56                   	push   %esi
8010553f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105542:	39 d6                	cmp    %edx,%esi
80105544:	73 2a                	jae    80105570 <memmove+0x40>
80105546:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105549:	39 fa                	cmp    %edi,%edx
8010554b:	73 23                	jae    80105570 <memmove+0x40>
8010554d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105550:	85 c9                	test   %ecx,%ecx
80105552:	74 13                	je     80105567 <memmove+0x37>
80105554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105558:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010555c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010555f:	83 e8 01             	sub    $0x1,%eax
80105562:	83 f8 ff             	cmp    $0xffffffff,%eax
80105565:	75 f1                	jne    80105558 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105567:	5e                   	pop    %esi
80105568:	89 d0                	mov    %edx,%eax
8010556a:	5f                   	pop    %edi
8010556b:	5d                   	pop    %ebp
8010556c:	c3                   	ret    
8010556d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105570:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105573:	89 d7                	mov    %edx,%edi
80105575:	85 c9                	test   %ecx,%ecx
80105577:	74 ee                	je     80105567 <memmove+0x37>
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105580:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105581:	39 f0                	cmp    %esi,%eax
80105583:	75 fb                	jne    80105580 <memmove+0x50>
}
80105585:	5e                   	pop    %esi
80105586:	89 d0                	mov    %edx,%eax
80105588:	5f                   	pop    %edi
80105589:	5d                   	pop    %ebp
8010558a:	c3                   	ret    
8010558b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010558f:	90                   	nop

80105590 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105590:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105594:	eb 9a                	jmp    80105530 <memmove>
80105596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559d:	8d 76 00             	lea    0x0(%esi),%esi

801055a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801055a0:	f3 0f 1e fb          	endbr32 
801055a4:	55                   	push   %ebp
801055a5:	89 e5                	mov    %esp,%ebp
801055a7:	56                   	push   %esi
801055a8:	8b 75 10             	mov    0x10(%ebp),%esi
801055ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
801055ae:	53                   	push   %ebx
801055af:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801055b2:	85 f6                	test   %esi,%esi
801055b4:	74 32                	je     801055e8 <strncmp+0x48>
801055b6:	01 c6                	add    %eax,%esi
801055b8:	eb 14                	jmp    801055ce <strncmp+0x2e>
801055ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055c0:	38 da                	cmp    %bl,%dl
801055c2:	75 14                	jne    801055d8 <strncmp+0x38>
    n--, p++, q++;
801055c4:	83 c0 01             	add    $0x1,%eax
801055c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801055ca:	39 f0                	cmp    %esi,%eax
801055cc:	74 1a                	je     801055e8 <strncmp+0x48>
801055ce:	0f b6 11             	movzbl (%ecx),%edx
801055d1:	0f b6 18             	movzbl (%eax),%ebx
801055d4:	84 d2                	test   %dl,%dl
801055d6:	75 e8                	jne    801055c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801055d8:	0f b6 c2             	movzbl %dl,%eax
801055db:	29 d8                	sub    %ebx,%eax
}
801055dd:	5b                   	pop    %ebx
801055de:	5e                   	pop    %esi
801055df:	5d                   	pop    %ebp
801055e0:	c3                   	ret    
801055e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055e8:	5b                   	pop    %ebx
    return 0;
801055e9:	31 c0                	xor    %eax,%eax
}
801055eb:	5e                   	pop    %esi
801055ec:	5d                   	pop    %ebp
801055ed:	c3                   	ret    
801055ee:	66 90                	xchg   %ax,%ax

801055f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801055f0:	f3 0f 1e fb          	endbr32 
801055f4:	55                   	push   %ebp
801055f5:	89 e5                	mov    %esp,%ebp
801055f7:	57                   	push   %edi
801055f8:	56                   	push   %esi
801055f9:	8b 75 08             	mov    0x8(%ebp),%esi
801055fc:	53                   	push   %ebx
801055fd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105600:	89 f2                	mov    %esi,%edx
80105602:	eb 1b                	jmp    8010561f <strncpy+0x2f>
80105604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105608:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010560c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010560f:	83 c2 01             	add    $0x1,%edx
80105612:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105616:	89 f9                	mov    %edi,%ecx
80105618:	88 4a ff             	mov    %cl,-0x1(%edx)
8010561b:	84 c9                	test   %cl,%cl
8010561d:	74 09                	je     80105628 <strncpy+0x38>
8010561f:	89 c3                	mov    %eax,%ebx
80105621:	83 e8 01             	sub    $0x1,%eax
80105624:	85 db                	test   %ebx,%ebx
80105626:	7f e0                	jg     80105608 <strncpy+0x18>
    ;
  while(n-- > 0)
80105628:	89 d1                	mov    %edx,%ecx
8010562a:	85 c0                	test   %eax,%eax
8010562c:	7e 15                	jle    80105643 <strncpy+0x53>
8010562e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105630:	83 c1 01             	add    $0x1,%ecx
80105633:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105637:	89 c8                	mov    %ecx,%eax
80105639:	f7 d0                	not    %eax
8010563b:	01 d0                	add    %edx,%eax
8010563d:	01 d8                	add    %ebx,%eax
8010563f:	85 c0                	test   %eax,%eax
80105641:	7f ed                	jg     80105630 <strncpy+0x40>
  return os;
}
80105643:	5b                   	pop    %ebx
80105644:	89 f0                	mov    %esi,%eax
80105646:	5e                   	pop    %esi
80105647:	5f                   	pop    %edi
80105648:	5d                   	pop    %ebp
80105649:	c3                   	ret    
8010564a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105650 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105650:	f3 0f 1e fb          	endbr32 
80105654:	55                   	push   %ebp
80105655:	89 e5                	mov    %esp,%ebp
80105657:	56                   	push   %esi
80105658:	8b 55 10             	mov    0x10(%ebp),%edx
8010565b:	8b 75 08             	mov    0x8(%ebp),%esi
8010565e:	53                   	push   %ebx
8010565f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105662:	85 d2                	test   %edx,%edx
80105664:	7e 21                	jle    80105687 <safestrcpy+0x37>
80105666:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010566a:	89 f2                	mov    %esi,%edx
8010566c:	eb 12                	jmp    80105680 <safestrcpy+0x30>
8010566e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105670:	0f b6 08             	movzbl (%eax),%ecx
80105673:	83 c0 01             	add    $0x1,%eax
80105676:	83 c2 01             	add    $0x1,%edx
80105679:	88 4a ff             	mov    %cl,-0x1(%edx)
8010567c:	84 c9                	test   %cl,%cl
8010567e:	74 04                	je     80105684 <safestrcpy+0x34>
80105680:	39 d8                	cmp    %ebx,%eax
80105682:	75 ec                	jne    80105670 <safestrcpy+0x20>
    ;
  *s = 0;
80105684:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105687:	89 f0                	mov    %esi,%eax
80105689:	5b                   	pop    %ebx
8010568a:	5e                   	pop    %esi
8010568b:	5d                   	pop    %ebp
8010568c:	c3                   	ret    
8010568d:	8d 76 00             	lea    0x0(%esi),%esi

80105690 <strlen>:

int
strlen(const char *s)
{
80105690:	f3 0f 1e fb          	endbr32 
80105694:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105695:	31 c0                	xor    %eax,%eax
{
80105697:	89 e5                	mov    %esp,%ebp
80105699:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010569c:	80 3a 00             	cmpb   $0x0,(%edx)
8010569f:	74 10                	je     801056b1 <strlen+0x21>
801056a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056a8:	83 c0 01             	add    $0x1,%eax
801056ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801056af:	75 f7                	jne    801056a8 <strlen+0x18>
    ;
  return n;
}
801056b1:	5d                   	pop    %ebp
801056b2:	c3                   	ret    

801056b3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801056b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801056b7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801056bb:	55                   	push   %ebp
  pushl %ebx
801056bc:	53                   	push   %ebx
  pushl %esi
801056bd:	56                   	push   %esi
  pushl %edi
801056be:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801056bf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801056c1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801056c3:	5f                   	pop    %edi
  popl %esi
801056c4:	5e                   	pop    %esi
  popl %ebx
801056c5:	5b                   	pop    %ebx
  popl %ebp
801056c6:	5d                   	pop    %ebp
  ret
801056c7:	c3                   	ret    
801056c8:	66 90                	xchg   %ax,%ax
801056ca:	66 90                	xchg   %ax,%ax
801056cc:	66 90                	xchg   %ax,%ax
801056ce:	66 90                	xchg   %ax,%ax

801056d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	53                   	push   %ebx
801056d8:	83 ec 04             	sub    $0x4,%esp
801056db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801056de:	e8 ad f0 ff ff       	call   80104790 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801056e3:	8b 00                	mov    (%eax),%eax
801056e5:	39 d8                	cmp    %ebx,%eax
801056e7:	76 17                	jbe    80105700 <fetchint+0x30>
801056e9:	8d 53 04             	lea    0x4(%ebx),%edx
801056ec:	39 d0                	cmp    %edx,%eax
801056ee:	72 10                	jb     80105700 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801056f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801056f3:	8b 13                	mov    (%ebx),%edx
801056f5:	89 10                	mov    %edx,(%eax)
  return 0;
801056f7:	31 c0                	xor    %eax,%eax
}
801056f9:	83 c4 04             	add    $0x4,%esp
801056fc:	5b                   	pop    %ebx
801056fd:	5d                   	pop    %ebp
801056fe:	c3                   	ret    
801056ff:	90                   	nop
    return -1;
80105700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105705:	eb f2                	jmp    801056f9 <fetchint+0x29>
80105707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570e:	66 90                	xchg   %ax,%ax

80105710 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105710:	f3 0f 1e fb          	endbr32 
80105714:	55                   	push   %ebp
80105715:	89 e5                	mov    %esp,%ebp
80105717:	53                   	push   %ebx
80105718:	83 ec 04             	sub    $0x4,%esp
8010571b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010571e:	e8 6d f0 ff ff       	call   80104790 <myproc>

  if(addr >= curproc->sz)
80105723:	39 18                	cmp    %ebx,(%eax)
80105725:	76 31                	jbe    80105758 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105727:	8b 55 0c             	mov    0xc(%ebp),%edx
8010572a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010572c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010572e:	39 d3                	cmp    %edx,%ebx
80105730:	73 26                	jae    80105758 <fetchstr+0x48>
80105732:	89 d8                	mov    %ebx,%eax
80105734:	eb 11                	jmp    80105747 <fetchstr+0x37>
80105736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573d:	8d 76 00             	lea    0x0(%esi),%esi
80105740:	83 c0 01             	add    $0x1,%eax
80105743:	39 c2                	cmp    %eax,%edx
80105745:	76 11                	jbe    80105758 <fetchstr+0x48>
    if(*s == 0)
80105747:	80 38 00             	cmpb   $0x0,(%eax)
8010574a:	75 f4                	jne    80105740 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010574c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010574f:	29 d8                	sub    %ebx,%eax
}
80105751:	5b                   	pop    %ebx
80105752:	5d                   	pop    %ebp
80105753:	c3                   	ret    
80105754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105758:	83 c4 04             	add    $0x4,%esp
    return -1;
8010575b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105760:	5b                   	pop    %ebx
80105761:	5d                   	pop    %ebp
80105762:	c3                   	ret    
80105763:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105770 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105770:	f3 0f 1e fb          	endbr32 
80105774:	55                   	push   %ebp
80105775:	89 e5                	mov    %esp,%ebp
80105777:	56                   	push   %esi
80105778:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105779:	e8 12 f0 ff ff       	call   80104790 <myproc>
8010577e:	8b 55 08             	mov    0x8(%ebp),%edx
80105781:	8b 40 18             	mov    0x18(%eax),%eax
80105784:	8b 40 44             	mov    0x44(%eax),%eax
80105787:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010578a:	e8 01 f0 ff ff       	call   80104790 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010578f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105792:	8b 00                	mov    (%eax),%eax
80105794:	39 c6                	cmp    %eax,%esi
80105796:	73 18                	jae    801057b0 <argint+0x40>
80105798:	8d 53 08             	lea    0x8(%ebx),%edx
8010579b:	39 d0                	cmp    %edx,%eax
8010579d:	72 11                	jb     801057b0 <argint+0x40>
  *ip = *(int*)(addr);
8010579f:	8b 45 0c             	mov    0xc(%ebp),%eax
801057a2:	8b 53 04             	mov    0x4(%ebx),%edx
801057a5:	89 10                	mov    %edx,(%eax)
  return 0;
801057a7:	31 c0                	xor    %eax,%eax
}
801057a9:	5b                   	pop    %ebx
801057aa:	5e                   	pop    %esi
801057ab:	5d                   	pop    %ebp
801057ac:	c3                   	ret    
801057ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801057b5:	eb f2                	jmp    801057a9 <argint+0x39>
801057b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057be:	66 90                	xchg   %ax,%ax

801057c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801057c0:	f3 0f 1e fb          	endbr32 
801057c4:	55                   	push   %ebp
801057c5:	89 e5                	mov    %esp,%ebp
801057c7:	56                   	push   %esi
801057c8:	53                   	push   %ebx
801057c9:	83 ec 10             	sub    $0x10,%esp
801057cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801057cf:	e8 bc ef ff ff       	call   80104790 <myproc>
 
  if(argint(n, &i) < 0)
801057d4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801057d7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801057d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057dc:	50                   	push   %eax
801057dd:	ff 75 08             	pushl  0x8(%ebp)
801057e0:	e8 8b ff ff ff       	call   80105770 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801057e5:	83 c4 10             	add    $0x10,%esp
801057e8:	85 c0                	test   %eax,%eax
801057ea:	78 24                	js     80105810 <argptr+0x50>
801057ec:	85 db                	test   %ebx,%ebx
801057ee:	78 20                	js     80105810 <argptr+0x50>
801057f0:	8b 16                	mov    (%esi),%edx
801057f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f5:	39 c2                	cmp    %eax,%edx
801057f7:	76 17                	jbe    80105810 <argptr+0x50>
801057f9:	01 c3                	add    %eax,%ebx
801057fb:	39 da                	cmp    %ebx,%edx
801057fd:	72 11                	jb     80105810 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801057ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80105802:	89 02                	mov    %eax,(%edx)
  return 0;
80105804:	31 c0                	xor    %eax,%eax
}
80105806:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105809:	5b                   	pop    %ebx
8010580a:	5e                   	pop    %esi
8010580b:	5d                   	pop    %ebp
8010580c:	c3                   	ret    
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105815:	eb ef                	jmp    80105806 <argptr+0x46>
80105817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581e:	66 90                	xchg   %ax,%ax

80105820 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105820:	f3 0f 1e fb          	endbr32 
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010582a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010582d:	50                   	push   %eax
8010582e:	ff 75 08             	pushl  0x8(%ebp)
80105831:	e8 3a ff ff ff       	call   80105770 <argint>
80105836:	83 c4 10             	add    $0x10,%esp
80105839:	85 c0                	test   %eax,%eax
8010583b:	78 13                	js     80105850 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010583d:	83 ec 08             	sub    $0x8,%esp
80105840:	ff 75 0c             	pushl  0xc(%ebp)
80105843:	ff 75 f4             	pushl  -0xc(%ebp)
80105846:	e8 c5 fe ff ff       	call   80105710 <fetchstr>
8010584b:	83 c4 10             	add    $0x10,%esp
}
8010584e:	c9                   	leave  
8010584f:	c3                   	ret    
80105850:	c9                   	leave  
    return -1;
80105851:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105856:	c3                   	ret    
80105857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585e:	66 90                	xchg   %ax,%ax

80105860 <syscall>:
[SYS_swapstat] sys_swapstat,
};

void
syscall(void)
{
80105860:	f3 0f 1e fb          	endbr32 
80105864:	55                   	push   %ebp
80105865:	89 e5                	mov    %esp,%ebp
80105867:	53                   	push   %ebx
80105868:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010586b:	e8 20 ef ff ff       	call   80104790 <myproc>
80105870:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105872:	8b 40 18             	mov    0x18(%eax),%eax
80105875:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105878:	8d 50 ff             	lea    -0x1(%eax),%edx
8010587b:	83 fa 17             	cmp    $0x17,%edx
8010587e:	77 20                	ja     801058a0 <syscall+0x40>
80105880:	8b 14 85 a0 8c 10 80 	mov    -0x7fef7360(,%eax,4),%edx
80105887:	85 d2                	test   %edx,%edx
80105889:	74 15                	je     801058a0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010588b:	ff d2                	call   *%edx
8010588d:	89 c2                	mov    %eax,%edx
8010588f:	8b 43 18             	mov    0x18(%ebx),%eax
80105892:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105895:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105898:	c9                   	leave  
80105899:	c3                   	ret    
8010589a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801058a0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801058a1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801058a4:	50                   	push   %eax
801058a5:	ff 73 10             	pushl  0x10(%ebx)
801058a8:	68 79 8c 10 80       	push   $0x80108c79
801058ad:	e8 fe ad ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801058b2:	8b 43 18             	mov    0x18(%ebx),%eax
801058b5:	83 c4 10             	add    $0x10,%esp
801058b8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801058bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c2:	c9                   	leave  
801058c3:	c3                   	ret    
801058c4:	66 90                	xchg   %ax,%ax
801058c6:	66 90                	xchg   %ax,%ax
801058c8:	66 90                	xchg   %ax,%ax
801058ca:	66 90                	xchg   %ax,%ax
801058cc:	66 90                	xchg   %ax,%ax
801058ce:	66 90                	xchg   %ax,%ax

801058d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801058d5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801058d8:	53                   	push   %ebx
801058d9:	83 ec 44             	sub    $0x44,%esp
801058dc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801058df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801058e2:	57                   	push   %edi
801058e3:	50                   	push   %eax
{
801058e4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801058e7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801058ea:	e8 61 c7 ff ff       	call   80102050 <nameiparent>
801058ef:	83 c4 10             	add    $0x10,%esp
801058f2:	85 c0                	test   %eax,%eax
801058f4:	0f 84 46 01 00 00    	je     80105a40 <create+0x170>
    return 0;
  ilock(dp);
801058fa:	83 ec 0c             	sub    $0xc,%esp
801058fd:	89 c3                	mov    %eax,%ebx
801058ff:	50                   	push   %eax
80105900:	e8 5b be ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105905:	83 c4 0c             	add    $0xc,%esp
80105908:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010590b:	50                   	push   %eax
8010590c:	57                   	push   %edi
8010590d:	53                   	push   %ebx
8010590e:	e8 9d c3 ff ff       	call   80101cb0 <dirlookup>
80105913:	83 c4 10             	add    $0x10,%esp
80105916:	89 c6                	mov    %eax,%esi
80105918:	85 c0                	test   %eax,%eax
8010591a:	74 54                	je     80105970 <create+0xa0>
    iunlockput(dp);
8010591c:	83 ec 0c             	sub    $0xc,%esp
8010591f:	53                   	push   %ebx
80105920:	e8 db c0 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105925:	89 34 24             	mov    %esi,(%esp)
80105928:	e8 33 be ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010592d:	83 c4 10             	add    $0x10,%esp
80105930:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105935:	75 19                	jne    80105950 <create+0x80>
80105937:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010593c:	75 12                	jne    80105950 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
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
    iunlockput(ip);
80105950:	83 ec 0c             	sub    $0xc,%esp
80105953:	56                   	push   %esi
    return 0;
80105954:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105956:	e8 a5 c0 ff ff       	call   80101a00 <iunlockput>
    return 0;
8010595b:	83 c4 10             	add    $0x10,%esp
}
8010595e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105961:	89 f0                	mov    %esi,%eax
80105963:	5b                   	pop    %ebx
80105964:	5e                   	pop    %esi
80105965:	5f                   	pop    %edi
80105966:	5d                   	pop    %ebp
80105967:	c3                   	ret    
80105968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105970:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105974:	83 ec 08             	sub    $0x8,%esp
80105977:	50                   	push   %eax
80105978:	ff 33                	pushl  (%ebx)
8010597a:	e8 61 bc ff ff       	call   801015e0 <ialloc>
8010597f:	83 c4 10             	add    $0x10,%esp
80105982:	89 c6                	mov    %eax,%esi
80105984:	85 c0                	test   %eax,%eax
80105986:	0f 84 cd 00 00 00    	je     80105a59 <create+0x189>
  ilock(ip);
8010598c:	83 ec 0c             	sub    $0xc,%esp
8010598f:	50                   	push   %eax
80105990:	e8 cb bd ff ff       	call   80101760 <ilock>
  ip->major = major;
80105995:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105999:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010599d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801059a1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801059a5:	b8 01 00 00 00       	mov    $0x1,%eax
801059aa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801059ae:	89 34 24             	mov    %esi,(%esp)
801059b1:	e8 ea bc ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801059b6:	83 c4 10             	add    $0x10,%esp
801059b9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801059be:	74 30                	je     801059f0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801059c0:	83 ec 04             	sub    $0x4,%esp
801059c3:	ff 76 04             	pushl  0x4(%esi)
801059c6:	57                   	push   %edi
801059c7:	53                   	push   %ebx
801059c8:	e8 a3 c5 ff ff       	call   80101f70 <dirlink>
801059cd:	83 c4 10             	add    $0x10,%esp
801059d0:	85 c0                	test   %eax,%eax
801059d2:	78 78                	js     80105a4c <create+0x17c>
  iunlockput(dp);
801059d4:	83 ec 0c             	sub    $0xc,%esp
801059d7:	53                   	push   %ebx
801059d8:	e8 23 c0 ff ff       	call   80101a00 <iunlockput>
  return ip;
801059dd:	83 c4 10             	add    $0x10,%esp
}
801059e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059e3:	89 f0                	mov    %esi,%eax
801059e5:	5b                   	pop    %ebx
801059e6:	5e                   	pop    %esi
801059e7:	5f                   	pop    %edi
801059e8:	5d                   	pop    %ebp
801059e9:	c3                   	ret    
801059ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801059f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801059f3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801059f8:	53                   	push   %ebx
801059f9:	e8 a2 bc ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801059fe:	83 c4 0c             	add    $0xc,%esp
80105a01:	ff 76 04             	pushl  0x4(%esi)
80105a04:	68 20 8d 10 80       	push   $0x80108d20
80105a09:	56                   	push   %esi
80105a0a:	e8 61 c5 ff ff       	call   80101f70 <dirlink>
80105a0f:	83 c4 10             	add    $0x10,%esp
80105a12:	85 c0                	test   %eax,%eax
80105a14:	78 18                	js     80105a2e <create+0x15e>
80105a16:	83 ec 04             	sub    $0x4,%esp
80105a19:	ff 73 04             	pushl  0x4(%ebx)
80105a1c:	68 1f 8d 10 80       	push   $0x80108d1f
80105a21:	56                   	push   %esi
80105a22:	e8 49 c5 ff ff       	call   80101f70 <dirlink>
80105a27:	83 c4 10             	add    $0x10,%esp
80105a2a:	85 c0                	test   %eax,%eax
80105a2c:	79 92                	jns    801059c0 <create+0xf0>
      panic("create dots");
80105a2e:	83 ec 0c             	sub    $0xc,%esp
80105a31:	68 13 8d 10 80       	push   $0x80108d13
80105a36:	e8 55 a9 ff ff       	call   80100390 <panic>
80105a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a3f:	90                   	nop
}
80105a40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105a43:	31 f6                	xor    %esi,%esi
}
80105a45:	5b                   	pop    %ebx
80105a46:	89 f0                	mov    %esi,%eax
80105a48:	5e                   	pop    %esi
80105a49:	5f                   	pop    %edi
80105a4a:	5d                   	pop    %ebp
80105a4b:	c3                   	ret    
    panic("create: dirlink");
80105a4c:	83 ec 0c             	sub    $0xc,%esp
80105a4f:	68 22 8d 10 80       	push   $0x80108d22
80105a54:	e8 37 a9 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105a59:	83 ec 0c             	sub    $0xc,%esp
80105a5c:	68 04 8d 10 80       	push   $0x80108d04
80105a61:	e8 2a a9 ff ff       	call   80100390 <panic>
80105a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6d:	8d 76 00             	lea    0x0(%esi),%esi

80105a70 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	56                   	push   %esi
80105a74:	89 d6                	mov    %edx,%esi
80105a76:	53                   	push   %ebx
80105a77:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105a79:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105a7c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105a7f:	50                   	push   %eax
80105a80:	6a 00                	push   $0x0
80105a82:	e8 e9 fc ff ff       	call   80105770 <argint>
80105a87:	83 c4 10             	add    $0x10,%esp
80105a8a:	85 c0                	test   %eax,%eax
80105a8c:	78 2a                	js     80105ab8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105a8e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105a92:	77 24                	ja     80105ab8 <argfd.constprop.0+0x48>
80105a94:	e8 f7 ec ff ff       	call   80104790 <myproc>
80105a99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a9c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105aa0:	85 c0                	test   %eax,%eax
80105aa2:	74 14                	je     80105ab8 <argfd.constprop.0+0x48>
  if(pfd)
80105aa4:	85 db                	test   %ebx,%ebx
80105aa6:	74 02                	je     80105aaa <argfd.constprop.0+0x3a>
    *pfd = fd;
80105aa8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105aaa:	89 06                	mov    %eax,(%esi)
  return 0;
80105aac:	31 c0                	xor    %eax,%eax
}
80105aae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ab1:	5b                   	pop    %ebx
80105ab2:	5e                   	pop    %esi
80105ab3:	5d                   	pop    %ebp
80105ab4:	c3                   	ret    
80105ab5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abd:	eb ef                	jmp    80105aae <argfd.constprop.0+0x3e>
80105abf:	90                   	nop

80105ac0 <sys_dup>:
{
80105ac0:	f3 0f 1e fb          	endbr32 
80105ac4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105ac5:	31 c0                	xor    %eax,%eax
{
80105ac7:	89 e5                	mov    %esp,%ebp
80105ac9:	56                   	push   %esi
80105aca:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105acb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105ace:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105ad1:	e8 9a ff ff ff       	call   80105a70 <argfd.constprop.0>
80105ad6:	85 c0                	test   %eax,%eax
80105ad8:	78 1e                	js     80105af8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80105ada:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105add:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105adf:	e8 ac ec ff ff       	call   80104790 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105ae8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105aec:	85 d2                	test   %edx,%edx
80105aee:	74 20                	je     80105b10 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105af0:	83 c3 01             	add    $0x1,%ebx
80105af3:	83 fb 10             	cmp    $0x10,%ebx
80105af6:	75 f0                	jne    80105ae8 <sys_dup+0x28>
}
80105af8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105afb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105b00:	89 d8                	mov    %ebx,%eax
80105b02:	5b                   	pop    %ebx
80105b03:	5e                   	pop    %esi
80105b04:	5d                   	pop    %ebp
80105b05:	c3                   	ret    
80105b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105b10:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105b14:	83 ec 0c             	sub    $0xc,%esp
80105b17:	ff 75 f4             	pushl  -0xc(%ebp)
80105b1a:	e8 51 b3 ff ff       	call   80100e70 <filedup>
  return fd;
80105b1f:	83 c4 10             	add    $0x10,%esp
}
80105b22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b25:	89 d8                	mov    %ebx,%eax
80105b27:	5b                   	pop    %ebx
80105b28:	5e                   	pop    %esi
80105b29:	5d                   	pop    %ebp
80105b2a:	c3                   	ret    
80105b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b2f:	90                   	nop

80105b30 <sys_read>:
{
80105b30:	f3 0f 1e fb          	endbr32 
80105b34:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b35:	31 c0                	xor    %eax,%eax
{
80105b37:	89 e5                	mov    %esp,%ebp
80105b39:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b3c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105b3f:	e8 2c ff ff ff       	call   80105a70 <argfd.constprop.0>
80105b44:	85 c0                	test   %eax,%eax
80105b46:	78 48                	js     80105b90 <sys_read+0x60>
80105b48:	83 ec 08             	sub    $0x8,%esp
80105b4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b4e:	50                   	push   %eax
80105b4f:	6a 02                	push   $0x2
80105b51:	e8 1a fc ff ff       	call   80105770 <argint>
80105b56:	83 c4 10             	add    $0x10,%esp
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	78 33                	js     80105b90 <sys_read+0x60>
80105b5d:	83 ec 04             	sub    $0x4,%esp
80105b60:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b63:	ff 75 f0             	pushl  -0x10(%ebp)
80105b66:	50                   	push   %eax
80105b67:	6a 01                	push   $0x1
80105b69:	e8 52 fc ff ff       	call   801057c0 <argptr>
80105b6e:	83 c4 10             	add    $0x10,%esp
80105b71:	85 c0                	test   %eax,%eax
80105b73:	78 1b                	js     80105b90 <sys_read+0x60>
  return fileread(f, p, n);
80105b75:	83 ec 04             	sub    $0x4,%esp
80105b78:	ff 75 f0             	pushl  -0x10(%ebp)
80105b7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b7e:	ff 75 ec             	pushl  -0x14(%ebp)
80105b81:	e8 6a b4 ff ff       	call   80100ff0 <fileread>
80105b86:	83 c4 10             	add    $0x10,%esp
}
80105b89:	c9                   	leave  
80105b8a:	c3                   	ret    
80105b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b8f:	90                   	nop
80105b90:	c9                   	leave  
    return -1;
80105b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b96:	c3                   	ret    
80105b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9e:	66 90                	xchg   %ax,%ax

80105ba0 <sys_write>:
{
80105ba0:	f3 0f 1e fb          	endbr32 
80105ba4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ba5:	31 c0                	xor    %eax,%eax
{
80105ba7:	89 e5                	mov    %esp,%ebp
80105ba9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105bac:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105baf:	e8 bc fe ff ff       	call   80105a70 <argfd.constprop.0>
80105bb4:	85 c0                	test   %eax,%eax
80105bb6:	78 48                	js     80105c00 <sys_write+0x60>
80105bb8:	83 ec 08             	sub    $0x8,%esp
80105bbb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bbe:	50                   	push   %eax
80105bbf:	6a 02                	push   $0x2
80105bc1:	e8 aa fb ff ff       	call   80105770 <argint>
80105bc6:	83 c4 10             	add    $0x10,%esp
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	78 33                	js     80105c00 <sys_write+0x60>
80105bcd:	83 ec 04             	sub    $0x4,%esp
80105bd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bd3:	ff 75 f0             	pushl  -0x10(%ebp)
80105bd6:	50                   	push   %eax
80105bd7:	6a 01                	push   $0x1
80105bd9:	e8 e2 fb ff ff       	call   801057c0 <argptr>
80105bde:	83 c4 10             	add    $0x10,%esp
80105be1:	85 c0                	test   %eax,%eax
80105be3:	78 1b                	js     80105c00 <sys_write+0x60>
  return filewrite(f, p, n);
80105be5:	83 ec 04             	sub    $0x4,%esp
80105be8:	ff 75 f0             	pushl  -0x10(%ebp)
80105beb:	ff 75 f4             	pushl  -0xc(%ebp)
80105bee:	ff 75 ec             	pushl  -0x14(%ebp)
80105bf1:	e8 9a b4 ff ff       	call   80101090 <filewrite>
80105bf6:	83 c4 10             	add    $0x10,%esp
}
80105bf9:	c9                   	leave  
80105bfa:	c3                   	ret    
80105bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bff:	90                   	nop
80105c00:	c9                   	leave  
    return -1;
80105c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c06:	c3                   	ret    
80105c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0e:	66 90                	xchg   %ax,%ax

80105c10 <sys_close>:
{
80105c10:	f3 0f 1e fb          	endbr32 
80105c14:	55                   	push   %ebp
80105c15:	89 e5                	mov    %esp,%ebp
80105c17:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105c1a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105c1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c20:	e8 4b fe ff ff       	call   80105a70 <argfd.constprop.0>
80105c25:	85 c0                	test   %eax,%eax
80105c27:	78 27                	js     80105c50 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105c29:	e8 62 eb ff ff       	call   80104790 <myproc>
80105c2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105c31:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105c34:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105c3b:	00 
  fileclose(f);
80105c3c:	ff 75 f4             	pushl  -0xc(%ebp)
80105c3f:	e8 7c b2 ff ff       	call   80100ec0 <fileclose>
  return 0;
80105c44:	83 c4 10             	add    $0x10,%esp
80105c47:	31 c0                	xor    %eax,%eax
}
80105c49:	c9                   	leave  
80105c4a:	c3                   	ret    
80105c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop
80105c50:	c9                   	leave  
    return -1;
80105c51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c56:	c3                   	ret    
80105c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5e:	66 90                	xchg   %ax,%ax

80105c60 <sys_fstat>:
{
80105c60:	f3 0f 1e fb          	endbr32 
80105c64:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105c65:	31 c0                	xor    %eax,%eax
{
80105c67:	89 e5                	mov    %esp,%ebp
80105c69:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105c6c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105c6f:	e8 fc fd ff ff       	call   80105a70 <argfd.constprop.0>
80105c74:	85 c0                	test   %eax,%eax
80105c76:	78 30                	js     80105ca8 <sys_fstat+0x48>
80105c78:	83 ec 04             	sub    $0x4,%esp
80105c7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c7e:	6a 14                	push   $0x14
80105c80:	50                   	push   %eax
80105c81:	6a 01                	push   $0x1
80105c83:	e8 38 fb ff ff       	call   801057c0 <argptr>
80105c88:	83 c4 10             	add    $0x10,%esp
80105c8b:	85 c0                	test   %eax,%eax
80105c8d:	78 19                	js     80105ca8 <sys_fstat+0x48>
  return filestat(f, st);
80105c8f:	83 ec 08             	sub    $0x8,%esp
80105c92:	ff 75 f4             	pushl  -0xc(%ebp)
80105c95:	ff 75 f0             	pushl  -0x10(%ebp)
80105c98:	e8 03 b3 ff ff       	call   80100fa0 <filestat>
80105c9d:	83 c4 10             	add    $0x10,%esp
}
80105ca0:	c9                   	leave  
80105ca1:	c3                   	ret    
80105ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ca8:	c9                   	leave  
    return -1;
80105ca9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cae:	c3                   	ret    
80105caf:	90                   	nop

80105cb0 <sys_link>:
{
80105cb0:	f3 0f 1e fb          	endbr32 
80105cb4:	55                   	push   %ebp
80105cb5:	89 e5                	mov    %esp,%ebp
80105cb7:	57                   	push   %edi
80105cb8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105cb9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105cbc:	53                   	push   %ebx
80105cbd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105cc0:	50                   	push   %eax
80105cc1:	6a 00                	push   $0x0
80105cc3:	e8 58 fb ff ff       	call   80105820 <argstr>
80105cc8:	83 c4 10             	add    $0x10,%esp
80105ccb:	85 c0                	test   %eax,%eax
80105ccd:	0f 88 ff 00 00 00    	js     80105dd2 <sys_link+0x122>
80105cd3:	83 ec 08             	sub    $0x8,%esp
80105cd6:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105cd9:	50                   	push   %eax
80105cda:	6a 01                	push   $0x1
80105cdc:	e8 3f fb ff ff       	call   80105820 <argstr>
80105ce1:	83 c4 10             	add    $0x10,%esp
80105ce4:	85 c0                	test   %eax,%eax
80105ce6:	0f 88 e6 00 00 00    	js     80105dd2 <sys_link+0x122>
  begin_op();
80105cec:	e8 6f de ff ff       	call   80103b60 <begin_op>
  if((ip = namei(old)) == 0){
80105cf1:	83 ec 0c             	sub    $0xc,%esp
80105cf4:	ff 75 d4             	pushl  -0x2c(%ebp)
80105cf7:	e8 34 c3 ff ff       	call   80102030 <namei>
80105cfc:	83 c4 10             	add    $0x10,%esp
80105cff:	89 c3                	mov    %eax,%ebx
80105d01:	85 c0                	test   %eax,%eax
80105d03:	0f 84 e8 00 00 00    	je     80105df1 <sys_link+0x141>
  ilock(ip);
80105d09:	83 ec 0c             	sub    $0xc,%esp
80105d0c:	50                   	push   %eax
80105d0d:	e8 4e ba ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105d12:	83 c4 10             	add    $0x10,%esp
80105d15:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d1a:	0f 84 b9 00 00 00    	je     80105dd9 <sys_link+0x129>
  iupdate(ip);
80105d20:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105d23:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105d28:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105d2b:	53                   	push   %ebx
80105d2c:	e8 6f b9 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105d31:	89 1c 24             	mov    %ebx,(%esp)
80105d34:	e8 07 bb ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105d39:	58                   	pop    %eax
80105d3a:	5a                   	pop    %edx
80105d3b:	57                   	push   %edi
80105d3c:	ff 75 d0             	pushl  -0x30(%ebp)
80105d3f:	e8 0c c3 ff ff       	call   80102050 <nameiparent>
80105d44:	83 c4 10             	add    $0x10,%esp
80105d47:	89 c6                	mov    %eax,%esi
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	74 5f                	je     80105dac <sys_link+0xfc>
  ilock(dp);
80105d4d:	83 ec 0c             	sub    $0xc,%esp
80105d50:	50                   	push   %eax
80105d51:	e8 0a ba ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105d56:	8b 03                	mov    (%ebx),%eax
80105d58:	83 c4 10             	add    $0x10,%esp
80105d5b:	39 06                	cmp    %eax,(%esi)
80105d5d:	75 41                	jne    80105da0 <sys_link+0xf0>
80105d5f:	83 ec 04             	sub    $0x4,%esp
80105d62:	ff 73 04             	pushl  0x4(%ebx)
80105d65:	57                   	push   %edi
80105d66:	56                   	push   %esi
80105d67:	e8 04 c2 ff ff       	call   80101f70 <dirlink>
80105d6c:	83 c4 10             	add    $0x10,%esp
80105d6f:	85 c0                	test   %eax,%eax
80105d71:	78 2d                	js     80105da0 <sys_link+0xf0>
  iunlockput(dp);
80105d73:	83 ec 0c             	sub    $0xc,%esp
80105d76:	56                   	push   %esi
80105d77:	e8 84 bc ff ff       	call   80101a00 <iunlockput>
  iput(ip);
80105d7c:	89 1c 24             	mov    %ebx,(%esp)
80105d7f:	e8 0c bb ff ff       	call   80101890 <iput>
  end_op();
80105d84:	e8 47 de ff ff       	call   80103bd0 <end_op>
  return 0;
80105d89:	83 c4 10             	add    $0x10,%esp
80105d8c:	31 c0                	xor    %eax,%eax
}
80105d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d91:	5b                   	pop    %ebx
80105d92:	5e                   	pop    %esi
80105d93:	5f                   	pop    %edi
80105d94:	5d                   	pop    %ebp
80105d95:	c3                   	ret    
80105d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	56                   	push   %esi
80105da4:	e8 57 bc ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105da9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105dac:	83 ec 0c             	sub    $0xc,%esp
80105daf:	53                   	push   %ebx
80105db0:	e8 ab b9 ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105db5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105dba:	89 1c 24             	mov    %ebx,(%esp)
80105dbd:	e8 de b8 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105dc2:	89 1c 24             	mov    %ebx,(%esp)
80105dc5:	e8 36 bc ff ff       	call   80101a00 <iunlockput>
  end_op();
80105dca:	e8 01 de ff ff       	call   80103bd0 <end_op>
  return -1;
80105dcf:	83 c4 10             	add    $0x10,%esp
80105dd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd7:	eb b5                	jmp    80105d8e <sys_link+0xde>
    iunlockput(ip);
80105dd9:	83 ec 0c             	sub    $0xc,%esp
80105ddc:	53                   	push   %ebx
80105ddd:	e8 1e bc ff ff       	call   80101a00 <iunlockput>
    end_op();
80105de2:	e8 e9 dd ff ff       	call   80103bd0 <end_op>
    return -1;
80105de7:	83 c4 10             	add    $0x10,%esp
80105dea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105def:	eb 9d                	jmp    80105d8e <sys_link+0xde>
    end_op();
80105df1:	e8 da dd ff ff       	call   80103bd0 <end_op>
    return -1;
80105df6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfb:	eb 91                	jmp    80105d8e <sys_link+0xde>
80105dfd:	8d 76 00             	lea    0x0(%esi),%esi

80105e00 <sys_unlink>:
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	57                   	push   %edi
80105e08:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105e09:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105e0c:	53                   	push   %ebx
80105e0d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105e10:	50                   	push   %eax
80105e11:	6a 00                	push   $0x0
80105e13:	e8 08 fa ff ff       	call   80105820 <argstr>
80105e18:	83 c4 10             	add    $0x10,%esp
80105e1b:	85 c0                	test   %eax,%eax
80105e1d:	0f 88 7d 01 00 00    	js     80105fa0 <sys_unlink+0x1a0>
  begin_op();
80105e23:	e8 38 dd ff ff       	call   80103b60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105e28:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105e2b:	83 ec 08             	sub    $0x8,%esp
80105e2e:	53                   	push   %ebx
80105e2f:	ff 75 c0             	pushl  -0x40(%ebp)
80105e32:	e8 19 c2 ff ff       	call   80102050 <nameiparent>
80105e37:	83 c4 10             	add    $0x10,%esp
80105e3a:	89 c6                	mov    %eax,%esi
80105e3c:	85 c0                	test   %eax,%eax
80105e3e:	0f 84 66 01 00 00    	je     80105faa <sys_unlink+0x1aa>
  ilock(dp);
80105e44:	83 ec 0c             	sub    $0xc,%esp
80105e47:	50                   	push   %eax
80105e48:	e8 13 b9 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105e4d:	58                   	pop    %eax
80105e4e:	5a                   	pop    %edx
80105e4f:	68 20 8d 10 80       	push   $0x80108d20
80105e54:	53                   	push   %ebx
80105e55:	e8 36 be ff ff       	call   80101c90 <namecmp>
80105e5a:	83 c4 10             	add    $0x10,%esp
80105e5d:	85 c0                	test   %eax,%eax
80105e5f:	0f 84 03 01 00 00    	je     80105f68 <sys_unlink+0x168>
80105e65:	83 ec 08             	sub    $0x8,%esp
80105e68:	68 1f 8d 10 80       	push   $0x80108d1f
80105e6d:	53                   	push   %ebx
80105e6e:	e8 1d be ff ff       	call   80101c90 <namecmp>
80105e73:	83 c4 10             	add    $0x10,%esp
80105e76:	85 c0                	test   %eax,%eax
80105e78:	0f 84 ea 00 00 00    	je     80105f68 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105e7e:	83 ec 04             	sub    $0x4,%esp
80105e81:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105e84:	50                   	push   %eax
80105e85:	53                   	push   %ebx
80105e86:	56                   	push   %esi
80105e87:	e8 24 be ff ff       	call   80101cb0 <dirlookup>
80105e8c:	83 c4 10             	add    $0x10,%esp
80105e8f:	89 c3                	mov    %eax,%ebx
80105e91:	85 c0                	test   %eax,%eax
80105e93:	0f 84 cf 00 00 00    	je     80105f68 <sys_unlink+0x168>
  ilock(ip);
80105e99:	83 ec 0c             	sub    $0xc,%esp
80105e9c:	50                   	push   %eax
80105e9d:	e8 be b8 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105ea2:	83 c4 10             	add    $0x10,%esp
80105ea5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105eaa:	0f 8e 23 01 00 00    	jle    80105fd3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105eb0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105eb5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105eb8:	74 66                	je     80105f20 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105eba:	83 ec 04             	sub    $0x4,%esp
80105ebd:	6a 10                	push   $0x10
80105ebf:	6a 00                	push   $0x0
80105ec1:	57                   	push   %edi
80105ec2:	e8 c9 f5 ff ff       	call   80105490 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ec7:	6a 10                	push   $0x10
80105ec9:	ff 75 c4             	pushl  -0x3c(%ebp)
80105ecc:	57                   	push   %edi
80105ecd:	56                   	push   %esi
80105ece:	e8 8d bc ff ff       	call   80101b60 <writei>
80105ed3:	83 c4 20             	add    $0x20,%esp
80105ed6:	83 f8 10             	cmp    $0x10,%eax
80105ed9:	0f 85 e7 00 00 00    	jne    80105fc6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
80105edf:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ee4:	0f 84 96 00 00 00    	je     80105f80 <sys_unlink+0x180>
  iunlockput(dp);
80105eea:	83 ec 0c             	sub    $0xc,%esp
80105eed:	56                   	push   %esi
80105eee:	e8 0d bb ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105ef3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105ef8:	89 1c 24             	mov    %ebx,(%esp)
80105efb:	e8 a0 b7 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105f00:	89 1c 24             	mov    %ebx,(%esp)
80105f03:	e8 f8 ba ff ff       	call   80101a00 <iunlockput>
  end_op();
80105f08:	e8 c3 dc ff ff       	call   80103bd0 <end_op>
  return 0;
80105f0d:	83 c4 10             	add    $0x10,%esp
80105f10:	31 c0                	xor    %eax,%eax
}
80105f12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f15:	5b                   	pop    %ebx
80105f16:	5e                   	pop    %esi
80105f17:	5f                   	pop    %edi
80105f18:	5d                   	pop    %ebp
80105f19:	c3                   	ret    
80105f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f20:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105f24:	76 94                	jbe    80105eba <sys_unlink+0xba>
80105f26:	ba 20 00 00 00       	mov    $0x20,%edx
80105f2b:	eb 0b                	jmp    80105f38 <sys_unlink+0x138>
80105f2d:	8d 76 00             	lea    0x0(%esi),%esi
80105f30:	83 c2 10             	add    $0x10,%edx
80105f33:	39 53 58             	cmp    %edx,0x58(%ebx)
80105f36:	76 82                	jbe    80105eba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f38:	6a 10                	push   $0x10
80105f3a:	52                   	push   %edx
80105f3b:	57                   	push   %edi
80105f3c:	53                   	push   %ebx
80105f3d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105f40:	e8 1b bb ff ff       	call   80101a60 <readi>
80105f45:	83 c4 10             	add    $0x10,%esp
80105f48:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105f4b:	83 f8 10             	cmp    $0x10,%eax
80105f4e:	75 69                	jne    80105fb9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105f50:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105f55:	74 d9                	je     80105f30 <sys_unlink+0x130>
    iunlockput(ip);
80105f57:	83 ec 0c             	sub    $0xc,%esp
80105f5a:	53                   	push   %ebx
80105f5b:	e8 a0 ba ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105f60:	83 c4 10             	add    $0x10,%esp
80105f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f67:	90                   	nop
  iunlockput(dp);
80105f68:	83 ec 0c             	sub    $0xc,%esp
80105f6b:	56                   	push   %esi
80105f6c:	e8 8f ba ff ff       	call   80101a00 <iunlockput>
  end_op();
80105f71:	e8 5a dc ff ff       	call   80103bd0 <end_op>
  return -1;
80105f76:	83 c4 10             	add    $0x10,%esp
80105f79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f7e:	eb 92                	jmp    80105f12 <sys_unlink+0x112>
    iupdate(dp);
80105f80:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105f83:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105f88:	56                   	push   %esi
80105f89:	e8 12 b7 ff ff       	call   801016a0 <iupdate>
80105f8e:	83 c4 10             	add    $0x10,%esp
80105f91:	e9 54 ff ff ff       	jmp    80105eea <sys_unlink+0xea>
80105f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa5:	e9 68 ff ff ff       	jmp    80105f12 <sys_unlink+0x112>
    end_op();
80105faa:	e8 21 dc ff ff       	call   80103bd0 <end_op>
    return -1;
80105faf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb4:	e9 59 ff ff ff       	jmp    80105f12 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105fb9:	83 ec 0c             	sub    $0xc,%esp
80105fbc:	68 44 8d 10 80       	push   $0x80108d44
80105fc1:	e8 ca a3 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105fc6:	83 ec 0c             	sub    $0xc,%esp
80105fc9:	68 56 8d 10 80       	push   $0x80108d56
80105fce:	e8 bd a3 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105fd3:	83 ec 0c             	sub    $0xc,%esp
80105fd6:	68 32 8d 10 80       	push   $0x80108d32
80105fdb:	e8 b0 a3 ff ff       	call   80100390 <panic>

80105fe0 <sys_open>:

int
sys_open(void)
{
80105fe0:	f3 0f 1e fb          	endbr32 
80105fe4:	55                   	push   %ebp
80105fe5:	89 e5                	mov    %esp,%ebp
80105fe7:	57                   	push   %edi
80105fe8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105fe9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105fec:	53                   	push   %ebx
80105fed:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ff0:	50                   	push   %eax
80105ff1:	6a 00                	push   $0x0
80105ff3:	e8 28 f8 ff ff       	call   80105820 <argstr>
80105ff8:	83 c4 10             	add    $0x10,%esp
80105ffb:	85 c0                	test   %eax,%eax
80105ffd:	0f 88 8a 00 00 00    	js     8010608d <sys_open+0xad>
80106003:	83 ec 08             	sub    $0x8,%esp
80106006:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106009:	50                   	push   %eax
8010600a:	6a 01                	push   $0x1
8010600c:	e8 5f f7 ff ff       	call   80105770 <argint>
80106011:	83 c4 10             	add    $0x10,%esp
80106014:	85 c0                	test   %eax,%eax
80106016:	78 75                	js     8010608d <sys_open+0xad>
    return -1;

  begin_op();
80106018:	e8 43 db ff ff       	call   80103b60 <begin_op>

  if(omode & O_CREATE){
8010601d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106021:	75 75                	jne    80106098 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106023:	83 ec 0c             	sub    $0xc,%esp
80106026:	ff 75 e0             	pushl  -0x20(%ebp)
80106029:	e8 02 c0 ff ff       	call   80102030 <namei>
8010602e:	83 c4 10             	add    $0x10,%esp
80106031:	89 c6                	mov    %eax,%esi
80106033:	85 c0                	test   %eax,%eax
80106035:	74 7e                	je     801060b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106037:	83 ec 0c             	sub    $0xc,%esp
8010603a:	50                   	push   %eax
8010603b:	e8 20 b7 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106040:	83 c4 10             	add    $0x10,%esp
80106043:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106048:	0f 84 c2 00 00 00    	je     80106110 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010604e:	e8 ad ad ff ff       	call   80100e00 <filealloc>
80106053:	89 c7                	mov    %eax,%edi
80106055:	85 c0                	test   %eax,%eax
80106057:	74 23                	je     8010607c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106059:	e8 32 e7 ff ff       	call   80104790 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010605e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106060:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106064:	85 d2                	test   %edx,%edx
80106066:	74 60                	je     801060c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106068:	83 c3 01             	add    $0x1,%ebx
8010606b:	83 fb 10             	cmp    $0x10,%ebx
8010606e:	75 f0                	jne    80106060 <sys_open+0x80>
    if(f)
      fileclose(f);
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	57                   	push   %edi
80106074:	e8 47 ae ff ff       	call   80100ec0 <fileclose>
80106079:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010607c:	83 ec 0c             	sub    $0xc,%esp
8010607f:	56                   	push   %esi
80106080:	e8 7b b9 ff ff       	call   80101a00 <iunlockput>
    end_op();
80106085:	e8 46 db ff ff       	call   80103bd0 <end_op>
    return -1;
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106092:	eb 6d                	jmp    80106101 <sys_open+0x121>
80106094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106098:	83 ec 0c             	sub    $0xc,%esp
8010609b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010609e:	31 c9                	xor    %ecx,%ecx
801060a0:	ba 02 00 00 00       	mov    $0x2,%edx
801060a5:	6a 00                	push   $0x0
801060a7:	e8 24 f8 ff ff       	call   801058d0 <create>
    if(ip == 0){
801060ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801060af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801060b1:	85 c0                	test   %eax,%eax
801060b3:	75 99                	jne    8010604e <sys_open+0x6e>
      end_op();
801060b5:	e8 16 db ff ff       	call   80103bd0 <end_op>
      return -1;
801060ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801060bf:	eb 40                	jmp    80106101 <sys_open+0x121>
801060c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801060c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801060cb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801060cf:	56                   	push   %esi
801060d0:	e8 6b b7 ff ff       	call   80101840 <iunlock>
  end_op();
801060d5:	e8 f6 da ff ff       	call   80103bd0 <end_op>

  f->type = FD_INODE;
801060da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801060e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801060e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801060e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801060e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801060eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801060f2:	f7 d0                	not    %eax
801060f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801060f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801060fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801060fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106101:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106104:	89 d8                	mov    %ebx,%eax
80106106:	5b                   	pop    %ebx
80106107:	5e                   	pop    %esi
80106108:	5f                   	pop    %edi
80106109:	5d                   	pop    %ebp
8010610a:	c3                   	ret    
8010610b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010610f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106110:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106113:	85 c9                	test   %ecx,%ecx
80106115:	0f 84 33 ff ff ff    	je     8010604e <sys_open+0x6e>
8010611b:	e9 5c ff ff ff       	jmp    8010607c <sys_open+0x9c>

80106120 <sys_mkdir>:

int
sys_mkdir(void)
{
80106120:	f3 0f 1e fb          	endbr32 
80106124:	55                   	push   %ebp
80106125:	89 e5                	mov    %esp,%ebp
80106127:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010612a:	e8 31 da ff ff       	call   80103b60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010612f:	83 ec 08             	sub    $0x8,%esp
80106132:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106135:	50                   	push   %eax
80106136:	6a 00                	push   $0x0
80106138:	e8 e3 f6 ff ff       	call   80105820 <argstr>
8010613d:	83 c4 10             	add    $0x10,%esp
80106140:	85 c0                	test   %eax,%eax
80106142:	78 34                	js     80106178 <sys_mkdir+0x58>
80106144:	83 ec 0c             	sub    $0xc,%esp
80106147:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010614a:	31 c9                	xor    %ecx,%ecx
8010614c:	ba 01 00 00 00       	mov    $0x1,%edx
80106151:	6a 00                	push   $0x0
80106153:	e8 78 f7 ff ff       	call   801058d0 <create>
80106158:	83 c4 10             	add    $0x10,%esp
8010615b:	85 c0                	test   %eax,%eax
8010615d:	74 19                	je     80106178 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010615f:	83 ec 0c             	sub    $0xc,%esp
80106162:	50                   	push   %eax
80106163:	e8 98 b8 ff ff       	call   80101a00 <iunlockput>
  end_op();
80106168:	e8 63 da ff ff       	call   80103bd0 <end_op>
  return 0;
8010616d:	83 c4 10             	add    $0x10,%esp
80106170:	31 c0                	xor    %eax,%eax
}
80106172:	c9                   	leave  
80106173:	c3                   	ret    
80106174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106178:	e8 53 da ff ff       	call   80103bd0 <end_op>
    return -1;
8010617d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106182:	c9                   	leave  
80106183:	c3                   	ret    
80106184:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010618b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010618f:	90                   	nop

80106190 <sys_mknod>:

int
sys_mknod(void)
{
80106190:	f3 0f 1e fb          	endbr32 
80106194:	55                   	push   %ebp
80106195:	89 e5                	mov    %esp,%ebp
80106197:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010619a:	e8 c1 d9 ff ff       	call   80103b60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010619f:	83 ec 08             	sub    $0x8,%esp
801061a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061a5:	50                   	push   %eax
801061a6:	6a 00                	push   $0x0
801061a8:	e8 73 f6 ff ff       	call   80105820 <argstr>
801061ad:	83 c4 10             	add    $0x10,%esp
801061b0:	85 c0                	test   %eax,%eax
801061b2:	78 64                	js     80106218 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801061b4:	83 ec 08             	sub    $0x8,%esp
801061b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061ba:	50                   	push   %eax
801061bb:	6a 01                	push   $0x1
801061bd:	e8 ae f5 ff ff       	call   80105770 <argint>
  if((argstr(0, &path)) < 0 ||
801061c2:	83 c4 10             	add    $0x10,%esp
801061c5:	85 c0                	test   %eax,%eax
801061c7:	78 4f                	js     80106218 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801061c9:	83 ec 08             	sub    $0x8,%esp
801061cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061cf:	50                   	push   %eax
801061d0:	6a 02                	push   $0x2
801061d2:	e8 99 f5 ff ff       	call   80105770 <argint>
     argint(1, &major) < 0 ||
801061d7:	83 c4 10             	add    $0x10,%esp
801061da:	85 c0                	test   %eax,%eax
801061dc:	78 3a                	js     80106218 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
801061de:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801061e2:	83 ec 0c             	sub    $0xc,%esp
801061e5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801061e9:	ba 03 00 00 00       	mov    $0x3,%edx
801061ee:	50                   	push   %eax
801061ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801061f2:	e8 d9 f6 ff ff       	call   801058d0 <create>
     argint(2, &minor) < 0 ||
801061f7:	83 c4 10             	add    $0x10,%esp
801061fa:	85 c0                	test   %eax,%eax
801061fc:	74 1a                	je     80106218 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801061fe:	83 ec 0c             	sub    $0xc,%esp
80106201:	50                   	push   %eax
80106202:	e8 f9 b7 ff ff       	call   80101a00 <iunlockput>
  end_op();
80106207:	e8 c4 d9 ff ff       	call   80103bd0 <end_op>
  return 0;
8010620c:	83 c4 10             	add    $0x10,%esp
8010620f:	31 c0                	xor    %eax,%eax
}
80106211:	c9                   	leave  
80106212:	c3                   	ret    
80106213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106217:	90                   	nop
    end_op();
80106218:	e8 b3 d9 ff ff       	call   80103bd0 <end_op>
    return -1;
8010621d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106222:	c9                   	leave  
80106223:	c3                   	ret    
80106224:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010622b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010622f:	90                   	nop

80106230 <sys_chdir>:

int
sys_chdir(void)
{
80106230:	f3 0f 1e fb          	endbr32 
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	56                   	push   %esi
80106238:	53                   	push   %ebx
80106239:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010623c:	e8 4f e5 ff ff       	call   80104790 <myproc>
80106241:	89 c6                	mov    %eax,%esi
  
  begin_op();
80106243:	e8 18 d9 ff ff       	call   80103b60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106248:	83 ec 08             	sub    $0x8,%esp
8010624b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010624e:	50                   	push   %eax
8010624f:	6a 00                	push   $0x0
80106251:	e8 ca f5 ff ff       	call   80105820 <argstr>
80106256:	83 c4 10             	add    $0x10,%esp
80106259:	85 c0                	test   %eax,%eax
8010625b:	78 73                	js     801062d0 <sys_chdir+0xa0>
8010625d:	83 ec 0c             	sub    $0xc,%esp
80106260:	ff 75 f4             	pushl  -0xc(%ebp)
80106263:	e8 c8 bd ff ff       	call   80102030 <namei>
80106268:	83 c4 10             	add    $0x10,%esp
8010626b:	89 c3                	mov    %eax,%ebx
8010626d:	85 c0                	test   %eax,%eax
8010626f:	74 5f                	je     801062d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80106271:	83 ec 0c             	sub    $0xc,%esp
80106274:	50                   	push   %eax
80106275:	e8 e6 b4 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
8010627a:	83 c4 10             	add    $0x10,%esp
8010627d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106282:	75 2c                	jne    801062b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106284:	83 ec 0c             	sub    $0xc,%esp
80106287:	53                   	push   %ebx
80106288:	e8 b3 b5 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
8010628d:	58                   	pop    %eax
8010628e:	ff 76 68             	pushl  0x68(%esi)
80106291:	e8 fa b5 ff ff       	call   80101890 <iput>
  end_op();
80106296:	e8 35 d9 ff ff       	call   80103bd0 <end_op>
  curproc->cwd = ip;
8010629b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010629e:	83 c4 10             	add    $0x10,%esp
801062a1:	31 c0                	xor    %eax,%eax
}
801062a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801062a6:	5b                   	pop    %ebx
801062a7:	5e                   	pop    %esi
801062a8:	5d                   	pop    %ebp
801062a9:	c3                   	ret    
801062aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801062b0:	83 ec 0c             	sub    $0xc,%esp
801062b3:	53                   	push   %ebx
801062b4:	e8 47 b7 ff ff       	call   80101a00 <iunlockput>
    end_op();
801062b9:	e8 12 d9 ff ff       	call   80103bd0 <end_op>
    return -1;
801062be:	83 c4 10             	add    $0x10,%esp
801062c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062c6:	eb db                	jmp    801062a3 <sys_chdir+0x73>
801062c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062cf:	90                   	nop
    end_op();
801062d0:	e8 fb d8 ff ff       	call   80103bd0 <end_op>
    return -1;
801062d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062da:	eb c7                	jmp    801062a3 <sys_chdir+0x73>
801062dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062e0 <sys_exec>:

int
sys_exec(void)
{
801062e0:	f3 0f 1e fb          	endbr32 
801062e4:	55                   	push   %ebp
801062e5:	89 e5                	mov    %esp,%ebp
801062e7:	57                   	push   %edi
801062e8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801062e9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801062ef:	53                   	push   %ebx
801062f0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801062f6:	50                   	push   %eax
801062f7:	6a 00                	push   $0x0
801062f9:	e8 22 f5 ff ff       	call   80105820 <argstr>
801062fe:	83 c4 10             	add    $0x10,%esp
80106301:	85 c0                	test   %eax,%eax
80106303:	0f 88 8b 00 00 00    	js     80106394 <sys_exec+0xb4>
80106309:	83 ec 08             	sub    $0x8,%esp
8010630c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106312:	50                   	push   %eax
80106313:	6a 01                	push   $0x1
80106315:	e8 56 f4 ff ff       	call   80105770 <argint>
8010631a:	83 c4 10             	add    $0x10,%esp
8010631d:	85 c0                	test   %eax,%eax
8010631f:	78 73                	js     80106394 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106321:	83 ec 04             	sub    $0x4,%esp
80106324:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010632a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010632c:	68 80 00 00 00       	push   $0x80
80106331:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106337:	6a 00                	push   $0x0
80106339:	50                   	push   %eax
8010633a:	e8 51 f1 ff ff       	call   80105490 <memset>
8010633f:	83 c4 10             	add    $0x10,%esp
80106342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106348:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010634e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106355:	83 ec 08             	sub    $0x8,%esp
80106358:	57                   	push   %edi
80106359:	01 f0                	add    %esi,%eax
8010635b:	50                   	push   %eax
8010635c:	e8 6f f3 ff ff       	call   801056d0 <fetchint>
80106361:	83 c4 10             	add    $0x10,%esp
80106364:	85 c0                	test   %eax,%eax
80106366:	78 2c                	js     80106394 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80106368:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010636e:	85 c0                	test   %eax,%eax
80106370:	74 36                	je     801063a8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106372:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106378:	83 ec 08             	sub    $0x8,%esp
8010637b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010637e:	52                   	push   %edx
8010637f:	50                   	push   %eax
80106380:	e8 8b f3 ff ff       	call   80105710 <fetchstr>
80106385:	83 c4 10             	add    $0x10,%esp
80106388:	85 c0                	test   %eax,%eax
8010638a:	78 08                	js     80106394 <sys_exec+0xb4>
  for(i=0;; i++){
8010638c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010638f:	83 fb 20             	cmp    $0x20,%ebx
80106392:	75 b4                	jne    80106348 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80106394:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010639c:	5b                   	pop    %ebx
8010639d:	5e                   	pop    %esi
8010639e:	5f                   	pop    %edi
8010639f:	5d                   	pop    %ebp
801063a0:	c3                   	ret    
801063a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801063a8:	83 ec 08             	sub    $0x8,%esp
801063ab:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801063b1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801063b8:	00 00 00 00 
  return exec(path, argv);
801063bc:	50                   	push   %eax
801063bd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801063c3:	e8 b8 a6 ff ff       	call   80100a80 <exec>
801063c8:	83 c4 10             	add    $0x10,%esp
}
801063cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063ce:	5b                   	pop    %ebx
801063cf:	5e                   	pop    %esi
801063d0:	5f                   	pop    %edi
801063d1:	5d                   	pop    %ebp
801063d2:	c3                   	ret    
801063d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801063e0 <sys_pipe>:

int
sys_pipe(void)
{
801063e0:	f3 0f 1e fb          	endbr32 
801063e4:	55                   	push   %ebp
801063e5:	89 e5                	mov    %esp,%ebp
801063e7:	57                   	push   %edi
801063e8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801063e9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801063ec:	53                   	push   %ebx
801063ed:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801063f0:	6a 08                	push   $0x8
801063f2:	50                   	push   %eax
801063f3:	6a 00                	push   $0x0
801063f5:	e8 c6 f3 ff ff       	call   801057c0 <argptr>
801063fa:	83 c4 10             	add    $0x10,%esp
801063fd:	85 c0                	test   %eax,%eax
801063ff:	78 4e                	js     8010644f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106401:	83 ec 08             	sub    $0x8,%esp
80106404:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106407:	50                   	push   %eax
80106408:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010640b:	50                   	push   %eax
8010640c:	e8 0f de ff ff       	call   80104220 <pipealloc>
80106411:	83 c4 10             	add    $0x10,%esp
80106414:	85 c0                	test   %eax,%eax
80106416:	78 37                	js     8010644f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106418:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010641b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010641d:	e8 6e e3 ff ff       	call   80104790 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80106428:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010642c:	85 f6                	test   %esi,%esi
8010642e:	74 30                	je     80106460 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106430:	83 c3 01             	add    $0x1,%ebx
80106433:	83 fb 10             	cmp    $0x10,%ebx
80106436:	75 f0                	jne    80106428 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106438:	83 ec 0c             	sub    $0xc,%esp
8010643b:	ff 75 e0             	pushl  -0x20(%ebp)
8010643e:	e8 7d aa ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80106443:	58                   	pop    %eax
80106444:	ff 75 e4             	pushl  -0x1c(%ebp)
80106447:	e8 74 aa ff ff       	call   80100ec0 <fileclose>
    return -1;
8010644c:	83 c4 10             	add    $0x10,%esp
8010644f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106454:	eb 5b                	jmp    801064b1 <sys_pipe+0xd1>
80106456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010645d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106460:	8d 73 08             	lea    0x8(%ebx),%esi
80106463:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106467:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010646a:	e8 21 e3 ff ff       	call   80104790 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010646f:	31 d2                	xor    %edx,%edx
80106471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106478:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010647c:	85 c9                	test   %ecx,%ecx
8010647e:	74 20                	je     801064a0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106480:	83 c2 01             	add    $0x1,%edx
80106483:	83 fa 10             	cmp    $0x10,%edx
80106486:	75 f0                	jne    80106478 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106488:	e8 03 e3 ff ff       	call   80104790 <myproc>
8010648d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106494:	00 
80106495:	eb a1                	jmp    80106438 <sys_pipe+0x58>
80106497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010649e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801064a0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801064a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801064a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801064af:	31 c0                	xor    %eax,%eax
}
801064b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064b4:	5b                   	pop    %ebx
801064b5:	5e                   	pop    %esi
801064b6:	5f                   	pop    %edi
801064b7:	5d                   	pop    %ebp
801064b8:	c3                   	ret    
801064b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064c0 <sys_swapread>:

int sys_swapread(void)
{
801064c0:	f3 0f 1e fb          	endbr32 
801064c4:	55                   	push   %ebp
801064c5:	89 e5                	mov    %esp,%ebp
801064c7:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
801064ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064cd:	68 00 10 00 00       	push   $0x1000
801064d2:	50                   	push   %eax
801064d3:	6a 00                	push   $0x0
801064d5:	e8 e6 f2 ff ff       	call   801057c0 <argptr>
801064da:	83 c4 10             	add    $0x10,%esp
801064dd:	85 c0                	test   %eax,%eax
801064df:	78 2f                	js     80106510 <sys_swapread+0x50>
801064e1:	83 ec 08             	sub    $0x8,%esp
801064e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064e7:	50                   	push   %eax
801064e8:	6a 01                	push   $0x1
801064ea:	e8 81 f2 ff ff       	call   80105770 <argint>
801064ef:	83 c4 10             	add    $0x10,%esp
801064f2:	85 c0                	test   %eax,%eax
801064f4:	78 1a                	js     80106510 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
801064f6:	83 ec 08             	sub    $0x8,%esp
801064f9:	ff 75 f4             	pushl  -0xc(%ebp)
801064fc:	ff 75 f0             	pushl  -0x10(%ebp)
801064ff:	e8 6c bb ff ff       	call   80102070 <swapread>
	return 0;
80106504:	83 c4 10             	add    $0x10,%esp
80106507:	31 c0                	xor    %eax,%eax
}
80106509:	c9                   	leave  
8010650a:	c3                   	ret    
8010650b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010650f:	90                   	nop
80106510:	c9                   	leave  
		return -1;
80106511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106516:	c3                   	ret    
80106517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010651e:	66 90                	xchg   %ax,%ax

80106520 <sys_swapwrite>:

int sys_swapwrite(void)
{
80106520:	f3 0f 1e fb          	endbr32 
80106524:	55                   	push   %ebp
80106525:	89 e5                	mov    %esp,%ebp
80106527:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
8010652a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010652d:	68 00 10 00 00       	push   $0x1000
80106532:	50                   	push   %eax
80106533:	6a 00                	push   $0x0
80106535:	e8 86 f2 ff ff       	call   801057c0 <argptr>
8010653a:	83 c4 10             	add    $0x10,%esp
8010653d:	85 c0                	test   %eax,%eax
8010653f:	78 2f                	js     80106570 <sys_swapwrite+0x50>
80106541:	83 ec 08             	sub    $0x8,%esp
80106544:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106547:	50                   	push   %eax
80106548:	6a 01                	push   $0x1
8010654a:	e8 21 f2 ff ff       	call   80105770 <argint>
8010654f:	83 c4 10             	add    $0x10,%esp
80106552:	85 c0                	test   %eax,%eax
80106554:	78 1a                	js     80106570 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
80106556:	83 ec 08             	sub    $0x8,%esp
80106559:	ff 75 f4             	pushl  -0xc(%ebp)
8010655c:	ff 75 f0             	pushl  -0x10(%ebp)
8010655f:	e8 9c bb ff ff       	call   80102100 <swapwrite>
	return 0;
80106564:	83 c4 10             	add    $0x10,%esp
80106567:	31 c0                	xor    %eax,%eax
}
80106569:	c9                   	leave  
8010656a:	c3                   	ret    
8010656b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010656f:	90                   	nop
80106570:	c9                   	leave  
		return -1;
80106571:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106576:	c3                   	ret    
80106577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010657e:	66 90                	xchg   %ax,%ax

80106580 <sys_swapstat>:

int sys_swapstat(void)
{
80106580:	f3 0f 1e fb          	endbr32 
80106584:	55                   	push   %ebp
80106585:	89 e5                	mov    %esp,%ebp
80106587:	53                   	push   %ebx
	int* nr_read;
	int* nr_write;
	
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80106588:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
8010658b:	83 ec 18             	sub    $0x18,%esp
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
8010658e:	6a 04                	push   $0x4
80106590:	50                   	push   %eax
80106591:	6a 00                	push   $0x0
80106593:	e8 28 f2 ff ff       	call   801057c0 <argptr>
80106598:	83 c4 10             	add    $0x10,%esp
8010659b:	85 c0                	test   %eax,%eax
8010659d:	75 39                	jne    801065d8 <sys_swapstat+0x58>
			argptr(1, (void*)&nr_write, sizeof(*nr_write)) < 0)
8010659f:	83 ec 04             	sub    $0x4,%esp
801065a2:	89 c3                	mov    %eax,%ebx
801065a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065a7:	6a 04                	push   $0x4
801065a9:	50                   	push   %eax
801065aa:	6a 01                	push   $0x1
801065ac:	e8 0f f2 ff ff       	call   801057c0 <argptr>
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
801065b1:	83 c4 10             	add    $0x10,%esp
801065b4:	85 c0                	test   %eax,%eax
801065b6:	78 20                	js     801065d8 <sys_swapstat+0x58>
		return -1;

	*nr_read = nr_sectors_read;
801065b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065bb:	8b 15 c0 19 11 80    	mov    0x801119c0,%edx
801065c1:	89 10                	mov    %edx,(%eax)
	*nr_write = nr_sectors_write;
801065c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c6:	8b 15 e0 19 11 80    	mov    0x801119e0,%edx
801065cc:	89 10                	mov    %edx,(%eax)
	return 0;
}
801065ce:	89 d8                	mov    %ebx,%eax
801065d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065d3:	c9                   	leave  
801065d4:	c3                   	ret    
801065d5:	8d 76 00             	lea    0x0(%esi),%esi
		return -1;
801065d8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801065dd:	eb ef                	jmp    801065ce <sys_swapstat+0x4e>
801065df:	90                   	nop

801065e0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801065e0:	f3 0f 1e fb          	endbr32 
  return fork();
801065e4:	e9 67 e3 ff ff       	jmp    80104950 <fork>
801065e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065f0 <sys_exit>:
}

int
sys_exit(void)
{
801065f0:	f3 0f 1e fb          	endbr32 
801065f4:	55                   	push   %ebp
801065f5:	89 e5                	mov    %esp,%ebp
801065f7:	83 ec 08             	sub    $0x8,%esp
  exit();
801065fa:	e8 b1 e5 ff ff       	call   80104bb0 <exit>
  return 0;  // not reached
}
801065ff:	31 c0                	xor    %eax,%eax
80106601:	c9                   	leave  
80106602:	c3                   	ret    
80106603:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010660a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106610 <sys_wait>:

int
sys_wait(void)
{
80106610:	f3 0f 1e fb          	endbr32 
  return wait();
80106614:	e9 e7 e7 ff ff       	jmp    80104e00 <wait>
80106619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106620 <sys_kill>:
}

int
sys_kill(void)
{
80106620:	f3 0f 1e fb          	endbr32 
80106624:	55                   	push   %ebp
80106625:	89 e5                	mov    %esp,%ebp
80106627:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010662a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010662d:	50                   	push   %eax
8010662e:	6a 00                	push   $0x0
80106630:	e8 3b f1 ff ff       	call   80105770 <argint>
80106635:	83 c4 10             	add    $0x10,%esp
80106638:	85 c0                	test   %eax,%eax
8010663a:	78 14                	js     80106650 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010663c:	83 ec 0c             	sub    $0xc,%esp
8010663f:	ff 75 f4             	pushl  -0xc(%ebp)
80106642:	e8 19 e9 ff ff       	call   80104f60 <kill>
80106647:	83 c4 10             	add    $0x10,%esp
}
8010664a:	c9                   	leave  
8010664b:	c3                   	ret    
8010664c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106650:	c9                   	leave  
    return -1;
80106651:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106656:	c3                   	ret    
80106657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010665e:	66 90                	xchg   %ax,%ax

80106660 <sys_getpid>:

int
sys_getpid(void)
{
80106660:	f3 0f 1e fb          	endbr32 
80106664:	55                   	push   %ebp
80106665:	89 e5                	mov    %esp,%ebp
80106667:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010666a:	e8 21 e1 ff ff       	call   80104790 <myproc>
8010666f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106672:	c9                   	leave  
80106673:	c3                   	ret    
80106674:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010667b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010667f:	90                   	nop

80106680 <sys_sbrk>:

int
sys_sbrk(void)
{
80106680:	f3 0f 1e fb          	endbr32 
80106684:	55                   	push   %ebp
80106685:	89 e5                	mov    %esp,%ebp
80106687:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106688:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010668b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010668e:	50                   	push   %eax
8010668f:	6a 00                	push   $0x0
80106691:	e8 da f0 ff ff       	call   80105770 <argint>
80106696:	83 c4 10             	add    $0x10,%esp
80106699:	85 c0                	test   %eax,%eax
8010669b:	78 23                	js     801066c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010669d:	e8 ee e0 ff ff       	call   80104790 <myproc>
  if(growproc(n) < 0)
801066a2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801066a5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801066a7:	ff 75 f4             	pushl  -0xc(%ebp)
801066aa:	e8 21 e2 ff ff       	call   801048d0 <growproc>
801066af:	83 c4 10             	add    $0x10,%esp
801066b2:	85 c0                	test   %eax,%eax
801066b4:	78 0a                	js     801066c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801066b6:	89 d8                	mov    %ebx,%eax
801066b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066bb:	c9                   	leave  
801066bc:	c3                   	ret    
801066bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801066c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801066c5:	eb ef                	jmp    801066b6 <sys_sbrk+0x36>
801066c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ce:	66 90                	xchg   %ax,%ax

801066d0 <sys_sleep>:

int
sys_sleep(void)
{
801066d0:	f3 0f 1e fb          	endbr32 
801066d4:	55                   	push   %ebp
801066d5:	89 e5                	mov    %esp,%ebp
801066d7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801066d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801066db:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801066de:	50                   	push   %eax
801066df:	6a 00                	push   $0x0
801066e1:	e8 8a f0 ff ff       	call   80105770 <argint>
801066e6:	83 c4 10             	add    $0x10,%esp
801066e9:	85 c0                	test   %eax,%eax
801066eb:	0f 88 86 00 00 00    	js     80106777 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801066f1:	83 ec 0c             	sub    $0xc,%esp
801066f4:	68 a0 bd 11 80       	push   $0x8011bda0
801066f9:	e8 82 ec ff ff       	call   80105380 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801066fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106701:	8b 1d e0 c5 11 80    	mov    0x8011c5e0,%ebx
  while(ticks - ticks0 < n){
80106707:	83 c4 10             	add    $0x10,%esp
8010670a:	85 d2                	test   %edx,%edx
8010670c:	75 23                	jne    80106731 <sys_sleep+0x61>
8010670e:	eb 50                	jmp    80106760 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106710:	83 ec 08             	sub    $0x8,%esp
80106713:	68 a0 bd 11 80       	push   $0x8011bda0
80106718:	68 e0 c5 11 80       	push   $0x8011c5e0
8010671d:	e8 1e e6 ff ff       	call   80104d40 <sleep>
  while(ticks - ticks0 < n){
80106722:	a1 e0 c5 11 80       	mov    0x8011c5e0,%eax
80106727:	83 c4 10             	add    $0x10,%esp
8010672a:	29 d8                	sub    %ebx,%eax
8010672c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010672f:	73 2f                	jae    80106760 <sys_sleep+0x90>
    if(myproc()->killed){
80106731:	e8 5a e0 ff ff       	call   80104790 <myproc>
80106736:	8b 40 24             	mov    0x24(%eax),%eax
80106739:	85 c0                	test   %eax,%eax
8010673b:	74 d3                	je     80106710 <sys_sleep+0x40>
      release(&tickslock);
8010673d:	83 ec 0c             	sub    $0xc,%esp
80106740:	68 a0 bd 11 80       	push   $0x8011bda0
80106745:	e8 f6 ec ff ff       	call   80105440 <release>
  }
  release(&tickslock);
  return 0;
}
8010674a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010674d:	83 c4 10             	add    $0x10,%esp
80106750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106755:	c9                   	leave  
80106756:	c3                   	ret    
80106757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010675e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106760:	83 ec 0c             	sub    $0xc,%esp
80106763:	68 a0 bd 11 80       	push   $0x8011bda0
80106768:	e8 d3 ec ff ff       	call   80105440 <release>
  return 0;
8010676d:	83 c4 10             	add    $0x10,%esp
80106770:	31 c0                	xor    %eax,%eax
}
80106772:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106775:	c9                   	leave  
80106776:	c3                   	ret    
    return -1;
80106777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010677c:	eb f4                	jmp    80106772 <sys_sleep+0xa2>
8010677e:	66 90                	xchg   %ax,%ax

80106780 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106780:	f3 0f 1e fb          	endbr32 
80106784:	55                   	push   %ebp
80106785:	89 e5                	mov    %esp,%ebp
80106787:	53                   	push   %ebx
80106788:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010678b:	68 a0 bd 11 80       	push   $0x8011bda0
80106790:	e8 eb eb ff ff       	call   80105380 <acquire>
  xticks = ticks;
80106795:	8b 1d e0 c5 11 80    	mov    0x8011c5e0,%ebx
  release(&tickslock);
8010679b:	c7 04 24 a0 bd 11 80 	movl   $0x8011bda0,(%esp)
801067a2:	e8 99 ec ff ff       	call   80105440 <release>
  return xticks;
}
801067a7:	89 d8                	mov    %ebx,%eax
801067a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801067ac:	c9                   	leave  
801067ad:	c3                   	ret    

801067ae <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801067ae:	1e                   	push   %ds
  pushl %es
801067af:	06                   	push   %es
  pushl %fs
801067b0:	0f a0                	push   %fs
  pushl %gs
801067b2:	0f a8                	push   %gs
  pushal
801067b4:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801067b5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801067b9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801067bb:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801067bd:	54                   	push   %esp
  call trap
801067be:	e8 cd 00 00 00       	call   80106890 <trap>
  addl $4, %esp
801067c3:	83 c4 04             	add    $0x4,%esp

801067c6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801067c6:	61                   	popa   
  popl %gs
801067c7:	0f a9                	pop    %gs
  popl %fs
801067c9:	0f a1                	pop    %fs
  popl %es
801067cb:	07                   	pop    %es
  popl %ds
801067cc:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801067cd:	83 c4 08             	add    $0x8,%esp
  iret
801067d0:	cf                   	iret   
801067d1:	66 90                	xchg   %ax,%ax
801067d3:	66 90                	xchg   %ax,%ax
801067d5:	66 90                	xchg   %ax,%ax
801067d7:	66 90                	xchg   %ax,%ax
801067d9:	66 90                	xchg   %ax,%ax
801067db:	66 90                	xchg   %ax,%ax
801067dd:	66 90                	xchg   %ax,%ax
801067df:	90                   	nop

801067e0 <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
801067e0:	f3 0f 1e fb          	endbr32 
801067e4:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
801067e5:	31 c0                	xor    %eax,%eax
{
801067e7:	89 e5                	mov    %esp,%ebp
801067e9:	83 ec 08             	sub    $0x8,%esp
801067ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
801067f0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801067f7:	c7 04 c5 e2 bd 11 80 	movl   $0x8e000008,-0x7fee421e(,%eax,8)
801067fe:	08 00 00 8e 
80106802:	66 89 14 c5 e0 bd 11 	mov    %dx,-0x7fee4220(,%eax,8)
80106809:	80 
8010680a:	c1 ea 10             	shr    $0x10,%edx
8010680d:	66 89 14 c5 e6 bd 11 	mov    %dx,-0x7fee421a(,%eax,8)
80106814:	80 
  for (i = 0; i < 256; i++)
80106815:	83 c0 01             	add    $0x1,%eax
80106818:	3d 00 01 00 00       	cmp    $0x100,%eax
8010681d:	75 d1                	jne    801067f0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010681f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106822:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106827:	c7 05 e2 bf 11 80 08 	movl   $0xef000008,0x8011bfe2
8010682e:	00 00 ef 
  initlock(&tickslock, "time");
80106831:	68 65 8d 10 80       	push   $0x80108d65
80106836:	68 a0 bd 11 80       	push   $0x8011bda0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010683b:	66 a3 e0 bf 11 80    	mov    %ax,0x8011bfe0
80106841:	c1 e8 10             	shr    $0x10,%eax
80106844:	66 a3 e6 bf 11 80    	mov    %ax,0x8011bfe6
  initlock(&tickslock, "time");
8010684a:	e8 b1 e9 ff ff       	call   80105200 <initlock>
}
8010684f:	83 c4 10             	add    $0x10,%esp
80106852:	c9                   	leave  
80106853:	c3                   	ret    
80106854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010685b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010685f:	90                   	nop

80106860 <idtinit>:

void idtinit(void)
{
80106860:	f3 0f 1e fb          	endbr32 
80106864:	55                   	push   %ebp
  pd[0] = size-1;
80106865:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010686a:	89 e5                	mov    %esp,%ebp
8010686c:	83 ec 10             	sub    $0x10,%esp
8010686f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106873:	b8 e0 bd 11 80       	mov    $0x8011bde0,%eax
80106878:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010687c:	c1 e8 10             	shr    $0x10,%eax
8010687f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106883:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106886:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106889:	c9                   	leave  
8010688a:	c3                   	ret    
8010688b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010688f:	90                   	nop

80106890 <trap>:

void trap(struct trapframe *tf)
{
80106890:	f3 0f 1e fb          	endbr32 
80106894:	55                   	push   %ebp
80106895:	89 e5                	mov    %esp,%ebp
80106897:	57                   	push   %edi
80106898:	56                   	push   %esi
80106899:	53                   	push   %ebx
8010689a:	83 ec 1c             	sub    $0x1c,%esp
8010689d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (tf->trapno == T_SYSCALL)
801068a0:	8b 43 30             	mov    0x30(%ebx),%eax
801068a3:	83 f8 40             	cmp    $0x40,%eax
801068a6:	0f 84 ec 01 00 00    	je     80106a98 <trap+0x208>
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
801068ac:	83 e8 0e             	sub    $0xe,%eax
801068af:	83 f8 31             	cmp    $0x31,%eax
801068b2:	77 08                	ja     801068bc <trap+0x2c>
801068b4:	3e ff 24 85 0c 8e 10 	notrack jmp *-0x7fef71f4(,%eax,4)
801068bb:	80 
  case T_PGFLT:
    page_fault_handler(myproc()->pgdir, rcr2());
    break;

  default:
    if (myproc() == 0 || (tf->cs & 3) == 0)
801068bc:	e8 cf de ff ff       	call   80104790 <myproc>
801068c1:	85 c0                	test   %eax,%eax
801068c3:	0f 84 1e 02 00 00    	je     80106ae7 <trap+0x257>
801068c9:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801068cd:	0f 84 14 02 00 00    	je     80106ae7 <trap+0x257>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801068d3:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068d6:	8b 53 38             	mov    0x38(%ebx),%edx
801068d9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801068dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
801068df:	e8 8c de ff ff       	call   80104770 <cpuid>
801068e4:	8b 73 30             	mov    0x30(%ebx),%esi
801068e7:	89 c7                	mov    %eax,%edi
801068e9:	8b 43 34             	mov    0x34(%ebx),%eax
801068ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801068ef:	e8 9c de ff ff       	call   80104790 <myproc>
801068f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801068f7:	e8 94 de ff ff       	call   80104790 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068fc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801068ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106902:	51                   	push   %ecx
80106903:	52                   	push   %edx
80106904:	57                   	push   %edi
80106905:	ff 75 e4             	pushl  -0x1c(%ebp)
80106908:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106909:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010690c:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010690f:	56                   	push   %esi
80106910:	ff 70 10             	pushl  0x10(%eax)
80106913:	68 c8 8d 10 80       	push   $0x80108dc8
80106918:	e8 93 9d ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010691d:	83 c4 20             	add    $0x20,%esp
80106920:	e8 6b de ff ff       	call   80104790 <myproc>
80106925:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010692c:	e8 5f de ff ff       	call   80104790 <myproc>
80106931:	85 c0                	test   %eax,%eax
80106933:	74 1d                	je     80106952 <trap+0xc2>
80106935:	e8 56 de ff ff       	call   80104790 <myproc>
8010693a:	8b 50 24             	mov    0x24(%eax),%edx
8010693d:	85 d2                	test   %edx,%edx
8010693f:	74 11                	je     80106952 <trap+0xc2>
80106941:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106945:	83 e0 03             	and    $0x3,%eax
80106948:	66 83 f8 03          	cmp    $0x3,%ax
8010694c:	0f 84 7e 01 00 00    	je     80106ad0 <trap+0x240>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING &&
80106952:	e8 39 de ff ff       	call   80104790 <myproc>
80106957:	85 c0                	test   %eax,%eax
80106959:	74 0f                	je     8010696a <trap+0xda>
8010695b:	e8 30 de ff ff       	call   80104790 <myproc>
80106960:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106964:	0f 84 16 01 00 00    	je     80106a80 <trap+0x1f0>
      tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010696a:	e8 21 de ff ff       	call   80104790 <myproc>
8010696f:	85 c0                	test   %eax,%eax
80106971:	74 1d                	je     80106990 <trap+0x100>
80106973:	e8 18 de ff ff       	call   80104790 <myproc>
80106978:	8b 40 24             	mov    0x24(%eax),%eax
8010697b:	85 c0                	test   %eax,%eax
8010697d:	74 11                	je     80106990 <trap+0x100>
8010697f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106983:	83 e0 03             	and    $0x3,%eax
80106986:	66 83 f8 03          	cmp    $0x3,%ax
8010698a:	0f 84 31 01 00 00    	je     80106ac1 <trap+0x231>
    exit();
}
80106990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106993:	5b                   	pop    %ebx
80106994:	5e                   	pop    %esi
80106995:	5f                   	pop    %edi
80106996:	5d                   	pop    %ebp
80106997:	c3                   	ret    
    ideintr();
80106998:	e8 53 b9 ff ff       	call   801022f0 <ideintr>
    lapiceoi();
8010699d:	e8 4e cd ff ff       	call   801036f0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801069a2:	e8 e9 dd ff ff       	call   80104790 <myproc>
801069a7:	85 c0                	test   %eax,%eax
801069a9:	75 8a                	jne    80106935 <trap+0xa5>
801069ab:	eb a5                	jmp    80106952 <trap+0xc2>
801069ad:	0f 20 d6             	mov    %cr2,%esi
    page_fault_handler(myproc()->pgdir, rcr2());
801069b0:	e8 db dd ff ff       	call   80104790 <myproc>
801069b5:	83 ec 08             	sub    $0x8,%esp
801069b8:	56                   	push   %esi
801069b9:	ff 70 04             	pushl  0x4(%eax)
801069bc:	e8 0f ca ff ff       	call   801033d0 <page_fault_handler>
    break;
801069c1:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801069c4:	e8 c7 dd ff ff       	call   80104790 <myproc>
801069c9:	85 c0                	test   %eax,%eax
801069cb:	0f 85 64 ff ff ff    	jne    80106935 <trap+0xa5>
801069d1:	e9 7c ff ff ff       	jmp    80106952 <trap+0xc2>
    if (cpuid() == 0)
801069d6:	e8 95 dd ff ff       	call   80104770 <cpuid>
801069db:	85 c0                	test   %eax,%eax
801069dd:	75 be                	jne    8010699d <trap+0x10d>
      acquire(&tickslock);
801069df:	83 ec 0c             	sub    $0xc,%esp
801069e2:	68 a0 bd 11 80       	push   $0x8011bda0
801069e7:	e8 94 e9 ff ff       	call   80105380 <acquire>
      wakeup(&ticks);
801069ec:	c7 04 24 e0 c5 11 80 	movl   $0x8011c5e0,(%esp)
      ticks++;
801069f3:	83 05 e0 c5 11 80 01 	addl   $0x1,0x8011c5e0
      wakeup(&ticks);
801069fa:	e8 01 e5 ff ff       	call   80104f00 <wakeup>
      release(&tickslock);
801069ff:	c7 04 24 a0 bd 11 80 	movl   $0x8011bda0,(%esp)
80106a06:	e8 35 ea ff ff       	call   80105440 <release>
80106a0b:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106a0e:	eb 8d                	jmp    8010699d <trap+0x10d>
    kbdintr();
80106a10:	e8 9b cb ff ff       	call   801035b0 <kbdintr>
    lapiceoi();
80106a15:	e8 d6 cc ff ff       	call   801036f0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106a1a:	e8 71 dd ff ff       	call   80104790 <myproc>
80106a1f:	85 c0                	test   %eax,%eax
80106a21:	0f 85 0e ff ff ff    	jne    80106935 <trap+0xa5>
80106a27:	e9 26 ff ff ff       	jmp    80106952 <trap+0xc2>
    uartintr();
80106a2c:	e8 5f 02 00 00       	call   80106c90 <uartintr>
    lapiceoi();
80106a31:	e8 ba cc ff ff       	call   801036f0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106a36:	e8 55 dd ff ff       	call   80104790 <myproc>
80106a3b:	85 c0                	test   %eax,%eax
80106a3d:	0f 85 f2 fe ff ff    	jne    80106935 <trap+0xa5>
80106a43:	e9 0a ff ff ff       	jmp    80106952 <trap+0xc2>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a48:	8b 7b 38             	mov    0x38(%ebx),%edi
80106a4b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106a4f:	e8 1c dd ff ff       	call   80104770 <cpuid>
80106a54:	57                   	push   %edi
80106a55:	56                   	push   %esi
80106a56:	50                   	push   %eax
80106a57:	68 70 8d 10 80       	push   $0x80108d70
80106a5c:	e8 4f 9c ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106a61:	e8 8a cc ff ff       	call   801036f0 <lapiceoi>
    break;
80106a66:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106a69:	e8 22 dd ff ff       	call   80104790 <myproc>
80106a6e:	85 c0                	test   %eax,%eax
80106a70:	0f 85 bf fe ff ff    	jne    80106935 <trap+0xa5>
80106a76:	e9 d7 fe ff ff       	jmp    80106952 <trap+0xc2>
80106a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a7f:	90                   	nop
  if (myproc() && myproc()->state == RUNNING &&
80106a80:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106a84:	0f 85 e0 fe ff ff    	jne    8010696a <trap+0xda>
    yield();
80106a8a:	e8 61 e2 ff ff       	call   80104cf0 <yield>
80106a8f:	e9 d6 fe ff ff       	jmp    8010696a <trap+0xda>
80106a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
80106a98:	e8 f3 dc ff ff       	call   80104790 <myproc>
80106a9d:	8b 70 24             	mov    0x24(%eax),%esi
80106aa0:	85 f6                	test   %esi,%esi
80106aa2:	75 3c                	jne    80106ae0 <trap+0x250>
    myproc()->tf = tf;
80106aa4:	e8 e7 dc ff ff       	call   80104790 <myproc>
80106aa9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106aac:	e8 af ed ff ff       	call   80105860 <syscall>
    if (myproc()->killed)
80106ab1:	e8 da dc ff ff       	call   80104790 <myproc>
80106ab6:	8b 48 24             	mov    0x24(%eax),%ecx
80106ab9:	85 c9                	test   %ecx,%ecx
80106abb:	0f 84 cf fe ff ff    	je     80106990 <trap+0x100>
}
80106ac1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ac4:	5b                   	pop    %ebx
80106ac5:	5e                   	pop    %esi
80106ac6:	5f                   	pop    %edi
80106ac7:	5d                   	pop    %ebp
      exit();
80106ac8:	e9 e3 e0 ff ff       	jmp    80104bb0 <exit>
80106acd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106ad0:	e8 db e0 ff ff       	call   80104bb0 <exit>
80106ad5:	e9 78 fe ff ff       	jmp    80106952 <trap+0xc2>
80106ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106ae0:	e8 cb e0 ff ff       	call   80104bb0 <exit>
80106ae5:	eb bd                	jmp    80106aa4 <trap+0x214>
80106ae7:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106aea:	8b 73 38             	mov    0x38(%ebx),%esi
80106aed:	e8 7e dc ff ff       	call   80104770 <cpuid>
80106af2:	83 ec 0c             	sub    $0xc,%esp
80106af5:	57                   	push   %edi
80106af6:	56                   	push   %esi
80106af7:	50                   	push   %eax
80106af8:	ff 73 30             	pushl  0x30(%ebx)
80106afb:	68 94 8d 10 80       	push   $0x80108d94
80106b00:	e8 ab 9b ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106b05:	83 c4 14             	add    $0x14,%esp
80106b08:	68 6a 8d 10 80       	push   $0x80108d6a
80106b0d:	e8 7e 98 ff ff       	call   80100390 <panic>
80106b12:	66 90                	xchg   %ax,%ax
80106b14:	66 90                	xchg   %ax,%ax
80106b16:	66 90                	xchg   %ax,%ax
80106b18:	66 90                	xchg   %ax,%ax
80106b1a:	66 90                	xchg   %ax,%ax
80106b1c:	66 90                	xchg   %ax,%ax
80106b1e:	66 90                	xchg   %ax,%ax

80106b20 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106b20:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106b24:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106b29:	85 c0                	test   %eax,%eax
80106b2b:	74 1b                	je     80106b48 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b2d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106b32:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106b33:	a8 01                	test   $0x1,%al
80106b35:	74 11                	je     80106b48 <uartgetc+0x28>
80106b37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b3c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106b3d:	0f b6 c0             	movzbl %al,%eax
80106b40:	c3                   	ret    
80106b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106b48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b4d:	c3                   	ret    
80106b4e:	66 90                	xchg   %ax,%ax

80106b50 <uartputc.part.0>:
uartputc(int c)
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	89 c7                	mov    %eax,%edi
80106b56:	56                   	push   %esi
80106b57:	be fd 03 00 00       	mov    $0x3fd,%esi
80106b5c:	53                   	push   %ebx
80106b5d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106b62:	83 ec 0c             	sub    $0xc,%esp
80106b65:	eb 1b                	jmp    80106b82 <uartputc.part.0+0x32>
80106b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b6e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106b70:	83 ec 0c             	sub    $0xc,%esp
80106b73:	6a 0a                	push   $0xa
80106b75:	e8 96 cb ff ff       	call   80103710 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b7a:	83 c4 10             	add    $0x10,%esp
80106b7d:	83 eb 01             	sub    $0x1,%ebx
80106b80:	74 07                	je     80106b89 <uartputc.part.0+0x39>
80106b82:	89 f2                	mov    %esi,%edx
80106b84:	ec                   	in     (%dx),%al
80106b85:	a8 20                	test   $0x20,%al
80106b87:	74 e7                	je     80106b70 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b89:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b8e:	89 f8                	mov    %edi,%eax
80106b90:	ee                   	out    %al,(%dx)
}
80106b91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b94:	5b                   	pop    %ebx
80106b95:	5e                   	pop    %esi
80106b96:	5f                   	pop    %edi
80106b97:	5d                   	pop    %ebp
80106b98:	c3                   	ret    
80106b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ba0 <uartinit>:
{
80106ba0:	f3 0f 1e fb          	endbr32 
80106ba4:	55                   	push   %ebp
80106ba5:	31 c9                	xor    %ecx,%ecx
80106ba7:	89 c8                	mov    %ecx,%eax
80106ba9:	89 e5                	mov    %esp,%ebp
80106bab:	57                   	push   %edi
80106bac:	56                   	push   %esi
80106bad:	53                   	push   %ebx
80106bae:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106bb3:	89 da                	mov    %ebx,%edx
80106bb5:	83 ec 0c             	sub    $0xc,%esp
80106bb8:	ee                   	out    %al,(%dx)
80106bb9:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106bbe:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106bc3:	89 fa                	mov    %edi,%edx
80106bc5:	ee                   	out    %al,(%dx)
80106bc6:	b8 0c 00 00 00       	mov    $0xc,%eax
80106bcb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bd0:	ee                   	out    %al,(%dx)
80106bd1:	be f9 03 00 00       	mov    $0x3f9,%esi
80106bd6:	89 c8                	mov    %ecx,%eax
80106bd8:	89 f2                	mov    %esi,%edx
80106bda:	ee                   	out    %al,(%dx)
80106bdb:	b8 03 00 00 00       	mov    $0x3,%eax
80106be0:	89 fa                	mov    %edi,%edx
80106be2:	ee                   	out    %al,(%dx)
80106be3:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106be8:	89 c8                	mov    %ecx,%eax
80106bea:	ee                   	out    %al,(%dx)
80106beb:	b8 01 00 00 00       	mov    $0x1,%eax
80106bf0:	89 f2                	mov    %esi,%edx
80106bf2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106bf3:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106bf8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106bf9:	3c ff                	cmp    $0xff,%al
80106bfb:	74 52                	je     80106c4f <uartinit+0xaf>
  uart = 1;
80106bfd:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106c04:	00 00 00 
80106c07:	89 da                	mov    %ebx,%edx
80106c09:	ec                   	in     (%dx),%al
80106c0a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c0f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106c10:	83 ec 08             	sub    $0x8,%esp
80106c13:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106c18:	bb d4 8e 10 80       	mov    $0x80108ed4,%ebx
  ioapicenable(IRQ_COM1, 0);
80106c1d:	6a 00                	push   $0x0
80106c1f:	6a 04                	push   $0x4
80106c21:	e8 1a b9 ff ff       	call   80102540 <ioapicenable>
80106c26:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106c29:	b8 78 00 00 00       	mov    $0x78,%eax
80106c2e:	eb 04                	jmp    80106c34 <uartinit+0x94>
80106c30:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106c34:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106c3a:	85 d2                	test   %edx,%edx
80106c3c:	74 08                	je     80106c46 <uartinit+0xa6>
    uartputc(*p);
80106c3e:	0f be c0             	movsbl %al,%eax
80106c41:	e8 0a ff ff ff       	call   80106b50 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106c46:	89 f0                	mov    %esi,%eax
80106c48:	83 c3 01             	add    $0x1,%ebx
80106c4b:	84 c0                	test   %al,%al
80106c4d:	75 e1                	jne    80106c30 <uartinit+0x90>
}
80106c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c52:	5b                   	pop    %ebx
80106c53:	5e                   	pop    %esi
80106c54:	5f                   	pop    %edi
80106c55:	5d                   	pop    %ebp
80106c56:	c3                   	ret    
80106c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c5e:	66 90                	xchg   %ax,%ax

80106c60 <uartputc>:
{
80106c60:	f3 0f 1e fb          	endbr32 
80106c64:	55                   	push   %ebp
  if(!uart)
80106c65:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106c6b:	89 e5                	mov    %esp,%ebp
80106c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106c70:	85 d2                	test   %edx,%edx
80106c72:	74 0c                	je     80106c80 <uartputc+0x20>
}
80106c74:	5d                   	pop    %ebp
80106c75:	e9 d6 fe ff ff       	jmp    80106b50 <uartputc.part.0>
80106c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c80:	5d                   	pop    %ebp
80106c81:	c3                   	ret    
80106c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c90 <uartintr>:

void
uartintr(void)
{
80106c90:	f3 0f 1e fb          	endbr32 
80106c94:	55                   	push   %ebp
80106c95:	89 e5                	mov    %esp,%ebp
80106c97:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106c9a:	68 20 6b 10 80       	push   $0x80106b20
80106c9f:	e8 bc 9b ff ff       	call   80100860 <consoleintr>
}
80106ca4:	83 c4 10             	add    $0x10,%esp
80106ca7:	c9                   	leave  
80106ca8:	c3                   	ret    

80106ca9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106ca9:	6a 00                	push   $0x0
  pushl $0
80106cab:	6a 00                	push   $0x0
  jmp alltraps
80106cad:	e9 fc fa ff ff       	jmp    801067ae <alltraps>

80106cb2 <vector1>:
.globl vector1
vector1:
  pushl $0
80106cb2:	6a 00                	push   $0x0
  pushl $1
80106cb4:	6a 01                	push   $0x1
  jmp alltraps
80106cb6:	e9 f3 fa ff ff       	jmp    801067ae <alltraps>

80106cbb <vector2>:
.globl vector2
vector2:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $2
80106cbd:	6a 02                	push   $0x2
  jmp alltraps
80106cbf:	e9 ea fa ff ff       	jmp    801067ae <alltraps>

80106cc4 <vector3>:
.globl vector3
vector3:
  pushl $0
80106cc4:	6a 00                	push   $0x0
  pushl $3
80106cc6:	6a 03                	push   $0x3
  jmp alltraps
80106cc8:	e9 e1 fa ff ff       	jmp    801067ae <alltraps>

80106ccd <vector4>:
.globl vector4
vector4:
  pushl $0
80106ccd:	6a 00                	push   $0x0
  pushl $4
80106ccf:	6a 04                	push   $0x4
  jmp alltraps
80106cd1:	e9 d8 fa ff ff       	jmp    801067ae <alltraps>

80106cd6 <vector5>:
.globl vector5
vector5:
  pushl $0
80106cd6:	6a 00                	push   $0x0
  pushl $5
80106cd8:	6a 05                	push   $0x5
  jmp alltraps
80106cda:	e9 cf fa ff ff       	jmp    801067ae <alltraps>

80106cdf <vector6>:
.globl vector6
vector6:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $6
80106ce1:	6a 06                	push   $0x6
  jmp alltraps
80106ce3:	e9 c6 fa ff ff       	jmp    801067ae <alltraps>

80106ce8 <vector7>:
.globl vector7
vector7:
  pushl $0
80106ce8:	6a 00                	push   $0x0
  pushl $7
80106cea:	6a 07                	push   $0x7
  jmp alltraps
80106cec:	e9 bd fa ff ff       	jmp    801067ae <alltraps>

80106cf1 <vector8>:
.globl vector8
vector8:
  pushl $8
80106cf1:	6a 08                	push   $0x8
  jmp alltraps
80106cf3:	e9 b6 fa ff ff       	jmp    801067ae <alltraps>

80106cf8 <vector9>:
.globl vector9
vector9:
  pushl $0
80106cf8:	6a 00                	push   $0x0
  pushl $9
80106cfa:	6a 09                	push   $0x9
  jmp alltraps
80106cfc:	e9 ad fa ff ff       	jmp    801067ae <alltraps>

80106d01 <vector10>:
.globl vector10
vector10:
  pushl $10
80106d01:	6a 0a                	push   $0xa
  jmp alltraps
80106d03:	e9 a6 fa ff ff       	jmp    801067ae <alltraps>

80106d08 <vector11>:
.globl vector11
vector11:
  pushl $11
80106d08:	6a 0b                	push   $0xb
  jmp alltraps
80106d0a:	e9 9f fa ff ff       	jmp    801067ae <alltraps>

80106d0f <vector12>:
.globl vector12
vector12:
  pushl $12
80106d0f:	6a 0c                	push   $0xc
  jmp alltraps
80106d11:	e9 98 fa ff ff       	jmp    801067ae <alltraps>

80106d16 <vector13>:
.globl vector13
vector13:
  pushl $13
80106d16:	6a 0d                	push   $0xd
  jmp alltraps
80106d18:	e9 91 fa ff ff       	jmp    801067ae <alltraps>

80106d1d <vector14>:
.globl vector14
vector14:
  pushl $14
80106d1d:	6a 0e                	push   $0xe
  jmp alltraps
80106d1f:	e9 8a fa ff ff       	jmp    801067ae <alltraps>

80106d24 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d24:	6a 00                	push   $0x0
  pushl $15
80106d26:	6a 0f                	push   $0xf
  jmp alltraps
80106d28:	e9 81 fa ff ff       	jmp    801067ae <alltraps>

80106d2d <vector16>:
.globl vector16
vector16:
  pushl $0
80106d2d:	6a 00                	push   $0x0
  pushl $16
80106d2f:	6a 10                	push   $0x10
  jmp alltraps
80106d31:	e9 78 fa ff ff       	jmp    801067ae <alltraps>

80106d36 <vector17>:
.globl vector17
vector17:
  pushl $17
80106d36:	6a 11                	push   $0x11
  jmp alltraps
80106d38:	e9 71 fa ff ff       	jmp    801067ae <alltraps>

80106d3d <vector18>:
.globl vector18
vector18:
  pushl $0
80106d3d:	6a 00                	push   $0x0
  pushl $18
80106d3f:	6a 12                	push   $0x12
  jmp alltraps
80106d41:	e9 68 fa ff ff       	jmp    801067ae <alltraps>

80106d46 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d46:	6a 00                	push   $0x0
  pushl $19
80106d48:	6a 13                	push   $0x13
  jmp alltraps
80106d4a:	e9 5f fa ff ff       	jmp    801067ae <alltraps>

80106d4f <vector20>:
.globl vector20
vector20:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $20
80106d51:	6a 14                	push   $0x14
  jmp alltraps
80106d53:	e9 56 fa ff ff       	jmp    801067ae <alltraps>

80106d58 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d58:	6a 00                	push   $0x0
  pushl $21
80106d5a:	6a 15                	push   $0x15
  jmp alltraps
80106d5c:	e9 4d fa ff ff       	jmp    801067ae <alltraps>

80106d61 <vector22>:
.globl vector22
vector22:
  pushl $0
80106d61:	6a 00                	push   $0x0
  pushl $22
80106d63:	6a 16                	push   $0x16
  jmp alltraps
80106d65:	e9 44 fa ff ff       	jmp    801067ae <alltraps>

80106d6a <vector23>:
.globl vector23
vector23:
  pushl $0
80106d6a:	6a 00                	push   $0x0
  pushl $23
80106d6c:	6a 17                	push   $0x17
  jmp alltraps
80106d6e:	e9 3b fa ff ff       	jmp    801067ae <alltraps>

80106d73 <vector24>:
.globl vector24
vector24:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $24
80106d75:	6a 18                	push   $0x18
  jmp alltraps
80106d77:	e9 32 fa ff ff       	jmp    801067ae <alltraps>

80106d7c <vector25>:
.globl vector25
vector25:
  pushl $0
80106d7c:	6a 00                	push   $0x0
  pushl $25
80106d7e:	6a 19                	push   $0x19
  jmp alltraps
80106d80:	e9 29 fa ff ff       	jmp    801067ae <alltraps>

80106d85 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $26
80106d87:	6a 1a                	push   $0x1a
  jmp alltraps
80106d89:	e9 20 fa ff ff       	jmp    801067ae <alltraps>

80106d8e <vector27>:
.globl vector27
vector27:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $27
80106d90:	6a 1b                	push   $0x1b
  jmp alltraps
80106d92:	e9 17 fa ff ff       	jmp    801067ae <alltraps>

80106d97 <vector28>:
.globl vector28
vector28:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $28
80106d99:	6a 1c                	push   $0x1c
  jmp alltraps
80106d9b:	e9 0e fa ff ff       	jmp    801067ae <alltraps>

80106da0 <vector29>:
.globl vector29
vector29:
  pushl $0
80106da0:	6a 00                	push   $0x0
  pushl $29
80106da2:	6a 1d                	push   $0x1d
  jmp alltraps
80106da4:	e9 05 fa ff ff       	jmp    801067ae <alltraps>

80106da9 <vector30>:
.globl vector30
vector30:
  pushl $0
80106da9:	6a 00                	push   $0x0
  pushl $30
80106dab:	6a 1e                	push   $0x1e
  jmp alltraps
80106dad:	e9 fc f9 ff ff       	jmp    801067ae <alltraps>

80106db2 <vector31>:
.globl vector31
vector31:
  pushl $0
80106db2:	6a 00                	push   $0x0
  pushl $31
80106db4:	6a 1f                	push   $0x1f
  jmp alltraps
80106db6:	e9 f3 f9 ff ff       	jmp    801067ae <alltraps>

80106dbb <vector32>:
.globl vector32
vector32:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $32
80106dbd:	6a 20                	push   $0x20
  jmp alltraps
80106dbf:	e9 ea f9 ff ff       	jmp    801067ae <alltraps>

80106dc4 <vector33>:
.globl vector33
vector33:
  pushl $0
80106dc4:	6a 00                	push   $0x0
  pushl $33
80106dc6:	6a 21                	push   $0x21
  jmp alltraps
80106dc8:	e9 e1 f9 ff ff       	jmp    801067ae <alltraps>

80106dcd <vector34>:
.globl vector34
vector34:
  pushl $0
80106dcd:	6a 00                	push   $0x0
  pushl $34
80106dcf:	6a 22                	push   $0x22
  jmp alltraps
80106dd1:	e9 d8 f9 ff ff       	jmp    801067ae <alltraps>

80106dd6 <vector35>:
.globl vector35
vector35:
  pushl $0
80106dd6:	6a 00                	push   $0x0
  pushl $35
80106dd8:	6a 23                	push   $0x23
  jmp alltraps
80106dda:	e9 cf f9 ff ff       	jmp    801067ae <alltraps>

80106ddf <vector36>:
.globl vector36
vector36:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $36
80106de1:	6a 24                	push   $0x24
  jmp alltraps
80106de3:	e9 c6 f9 ff ff       	jmp    801067ae <alltraps>

80106de8 <vector37>:
.globl vector37
vector37:
  pushl $0
80106de8:	6a 00                	push   $0x0
  pushl $37
80106dea:	6a 25                	push   $0x25
  jmp alltraps
80106dec:	e9 bd f9 ff ff       	jmp    801067ae <alltraps>

80106df1 <vector38>:
.globl vector38
vector38:
  pushl $0
80106df1:	6a 00                	push   $0x0
  pushl $38
80106df3:	6a 26                	push   $0x26
  jmp alltraps
80106df5:	e9 b4 f9 ff ff       	jmp    801067ae <alltraps>

80106dfa <vector39>:
.globl vector39
vector39:
  pushl $0
80106dfa:	6a 00                	push   $0x0
  pushl $39
80106dfc:	6a 27                	push   $0x27
  jmp alltraps
80106dfe:	e9 ab f9 ff ff       	jmp    801067ae <alltraps>

80106e03 <vector40>:
.globl vector40
vector40:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $40
80106e05:	6a 28                	push   $0x28
  jmp alltraps
80106e07:	e9 a2 f9 ff ff       	jmp    801067ae <alltraps>

80106e0c <vector41>:
.globl vector41
vector41:
  pushl $0
80106e0c:	6a 00                	push   $0x0
  pushl $41
80106e0e:	6a 29                	push   $0x29
  jmp alltraps
80106e10:	e9 99 f9 ff ff       	jmp    801067ae <alltraps>

80106e15 <vector42>:
.globl vector42
vector42:
  pushl $0
80106e15:	6a 00                	push   $0x0
  pushl $42
80106e17:	6a 2a                	push   $0x2a
  jmp alltraps
80106e19:	e9 90 f9 ff ff       	jmp    801067ae <alltraps>

80106e1e <vector43>:
.globl vector43
vector43:
  pushl $0
80106e1e:	6a 00                	push   $0x0
  pushl $43
80106e20:	6a 2b                	push   $0x2b
  jmp alltraps
80106e22:	e9 87 f9 ff ff       	jmp    801067ae <alltraps>

80106e27 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $44
80106e29:	6a 2c                	push   $0x2c
  jmp alltraps
80106e2b:	e9 7e f9 ff ff       	jmp    801067ae <alltraps>

80106e30 <vector45>:
.globl vector45
vector45:
  pushl $0
80106e30:	6a 00                	push   $0x0
  pushl $45
80106e32:	6a 2d                	push   $0x2d
  jmp alltraps
80106e34:	e9 75 f9 ff ff       	jmp    801067ae <alltraps>

80106e39 <vector46>:
.globl vector46
vector46:
  pushl $0
80106e39:	6a 00                	push   $0x0
  pushl $46
80106e3b:	6a 2e                	push   $0x2e
  jmp alltraps
80106e3d:	e9 6c f9 ff ff       	jmp    801067ae <alltraps>

80106e42 <vector47>:
.globl vector47
vector47:
  pushl $0
80106e42:	6a 00                	push   $0x0
  pushl $47
80106e44:	6a 2f                	push   $0x2f
  jmp alltraps
80106e46:	e9 63 f9 ff ff       	jmp    801067ae <alltraps>

80106e4b <vector48>:
.globl vector48
vector48:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $48
80106e4d:	6a 30                	push   $0x30
  jmp alltraps
80106e4f:	e9 5a f9 ff ff       	jmp    801067ae <alltraps>

80106e54 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e54:	6a 00                	push   $0x0
  pushl $49
80106e56:	6a 31                	push   $0x31
  jmp alltraps
80106e58:	e9 51 f9 ff ff       	jmp    801067ae <alltraps>

80106e5d <vector50>:
.globl vector50
vector50:
  pushl $0
80106e5d:	6a 00                	push   $0x0
  pushl $50
80106e5f:	6a 32                	push   $0x32
  jmp alltraps
80106e61:	e9 48 f9 ff ff       	jmp    801067ae <alltraps>

80106e66 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e66:	6a 00                	push   $0x0
  pushl $51
80106e68:	6a 33                	push   $0x33
  jmp alltraps
80106e6a:	e9 3f f9 ff ff       	jmp    801067ae <alltraps>

80106e6f <vector52>:
.globl vector52
vector52:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $52
80106e71:	6a 34                	push   $0x34
  jmp alltraps
80106e73:	e9 36 f9 ff ff       	jmp    801067ae <alltraps>

80106e78 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e78:	6a 00                	push   $0x0
  pushl $53
80106e7a:	6a 35                	push   $0x35
  jmp alltraps
80106e7c:	e9 2d f9 ff ff       	jmp    801067ae <alltraps>

80106e81 <vector54>:
.globl vector54
vector54:
  pushl $0
80106e81:	6a 00                	push   $0x0
  pushl $54
80106e83:	6a 36                	push   $0x36
  jmp alltraps
80106e85:	e9 24 f9 ff ff       	jmp    801067ae <alltraps>

80106e8a <vector55>:
.globl vector55
vector55:
  pushl $0
80106e8a:	6a 00                	push   $0x0
  pushl $55
80106e8c:	6a 37                	push   $0x37
  jmp alltraps
80106e8e:	e9 1b f9 ff ff       	jmp    801067ae <alltraps>

80106e93 <vector56>:
.globl vector56
vector56:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $56
80106e95:	6a 38                	push   $0x38
  jmp alltraps
80106e97:	e9 12 f9 ff ff       	jmp    801067ae <alltraps>

80106e9c <vector57>:
.globl vector57
vector57:
  pushl $0
80106e9c:	6a 00                	push   $0x0
  pushl $57
80106e9e:	6a 39                	push   $0x39
  jmp alltraps
80106ea0:	e9 09 f9 ff ff       	jmp    801067ae <alltraps>

80106ea5 <vector58>:
.globl vector58
vector58:
  pushl $0
80106ea5:	6a 00                	push   $0x0
  pushl $58
80106ea7:	6a 3a                	push   $0x3a
  jmp alltraps
80106ea9:	e9 00 f9 ff ff       	jmp    801067ae <alltraps>

80106eae <vector59>:
.globl vector59
vector59:
  pushl $0
80106eae:	6a 00                	push   $0x0
  pushl $59
80106eb0:	6a 3b                	push   $0x3b
  jmp alltraps
80106eb2:	e9 f7 f8 ff ff       	jmp    801067ae <alltraps>

80106eb7 <vector60>:
.globl vector60
vector60:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $60
80106eb9:	6a 3c                	push   $0x3c
  jmp alltraps
80106ebb:	e9 ee f8 ff ff       	jmp    801067ae <alltraps>

80106ec0 <vector61>:
.globl vector61
vector61:
  pushl $0
80106ec0:	6a 00                	push   $0x0
  pushl $61
80106ec2:	6a 3d                	push   $0x3d
  jmp alltraps
80106ec4:	e9 e5 f8 ff ff       	jmp    801067ae <alltraps>

80106ec9 <vector62>:
.globl vector62
vector62:
  pushl $0
80106ec9:	6a 00                	push   $0x0
  pushl $62
80106ecb:	6a 3e                	push   $0x3e
  jmp alltraps
80106ecd:	e9 dc f8 ff ff       	jmp    801067ae <alltraps>

80106ed2 <vector63>:
.globl vector63
vector63:
  pushl $0
80106ed2:	6a 00                	push   $0x0
  pushl $63
80106ed4:	6a 3f                	push   $0x3f
  jmp alltraps
80106ed6:	e9 d3 f8 ff ff       	jmp    801067ae <alltraps>

80106edb <vector64>:
.globl vector64
vector64:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $64
80106edd:	6a 40                	push   $0x40
  jmp alltraps
80106edf:	e9 ca f8 ff ff       	jmp    801067ae <alltraps>

80106ee4 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ee4:	6a 00                	push   $0x0
  pushl $65
80106ee6:	6a 41                	push   $0x41
  jmp alltraps
80106ee8:	e9 c1 f8 ff ff       	jmp    801067ae <alltraps>

80106eed <vector66>:
.globl vector66
vector66:
  pushl $0
80106eed:	6a 00                	push   $0x0
  pushl $66
80106eef:	6a 42                	push   $0x42
  jmp alltraps
80106ef1:	e9 b8 f8 ff ff       	jmp    801067ae <alltraps>

80106ef6 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ef6:	6a 00                	push   $0x0
  pushl $67
80106ef8:	6a 43                	push   $0x43
  jmp alltraps
80106efa:	e9 af f8 ff ff       	jmp    801067ae <alltraps>

80106eff <vector68>:
.globl vector68
vector68:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $68
80106f01:	6a 44                	push   $0x44
  jmp alltraps
80106f03:	e9 a6 f8 ff ff       	jmp    801067ae <alltraps>

80106f08 <vector69>:
.globl vector69
vector69:
  pushl $0
80106f08:	6a 00                	push   $0x0
  pushl $69
80106f0a:	6a 45                	push   $0x45
  jmp alltraps
80106f0c:	e9 9d f8 ff ff       	jmp    801067ae <alltraps>

80106f11 <vector70>:
.globl vector70
vector70:
  pushl $0
80106f11:	6a 00                	push   $0x0
  pushl $70
80106f13:	6a 46                	push   $0x46
  jmp alltraps
80106f15:	e9 94 f8 ff ff       	jmp    801067ae <alltraps>

80106f1a <vector71>:
.globl vector71
vector71:
  pushl $0
80106f1a:	6a 00                	push   $0x0
  pushl $71
80106f1c:	6a 47                	push   $0x47
  jmp alltraps
80106f1e:	e9 8b f8 ff ff       	jmp    801067ae <alltraps>

80106f23 <vector72>:
.globl vector72
vector72:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $72
80106f25:	6a 48                	push   $0x48
  jmp alltraps
80106f27:	e9 82 f8 ff ff       	jmp    801067ae <alltraps>

80106f2c <vector73>:
.globl vector73
vector73:
  pushl $0
80106f2c:	6a 00                	push   $0x0
  pushl $73
80106f2e:	6a 49                	push   $0x49
  jmp alltraps
80106f30:	e9 79 f8 ff ff       	jmp    801067ae <alltraps>

80106f35 <vector74>:
.globl vector74
vector74:
  pushl $0
80106f35:	6a 00                	push   $0x0
  pushl $74
80106f37:	6a 4a                	push   $0x4a
  jmp alltraps
80106f39:	e9 70 f8 ff ff       	jmp    801067ae <alltraps>

80106f3e <vector75>:
.globl vector75
vector75:
  pushl $0
80106f3e:	6a 00                	push   $0x0
  pushl $75
80106f40:	6a 4b                	push   $0x4b
  jmp alltraps
80106f42:	e9 67 f8 ff ff       	jmp    801067ae <alltraps>

80106f47 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $76
80106f49:	6a 4c                	push   $0x4c
  jmp alltraps
80106f4b:	e9 5e f8 ff ff       	jmp    801067ae <alltraps>

80106f50 <vector77>:
.globl vector77
vector77:
  pushl $0
80106f50:	6a 00                	push   $0x0
  pushl $77
80106f52:	6a 4d                	push   $0x4d
  jmp alltraps
80106f54:	e9 55 f8 ff ff       	jmp    801067ae <alltraps>

80106f59 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f59:	6a 00                	push   $0x0
  pushl $78
80106f5b:	6a 4e                	push   $0x4e
  jmp alltraps
80106f5d:	e9 4c f8 ff ff       	jmp    801067ae <alltraps>

80106f62 <vector79>:
.globl vector79
vector79:
  pushl $0
80106f62:	6a 00                	push   $0x0
  pushl $79
80106f64:	6a 4f                	push   $0x4f
  jmp alltraps
80106f66:	e9 43 f8 ff ff       	jmp    801067ae <alltraps>

80106f6b <vector80>:
.globl vector80
vector80:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $80
80106f6d:	6a 50                	push   $0x50
  jmp alltraps
80106f6f:	e9 3a f8 ff ff       	jmp    801067ae <alltraps>

80106f74 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f74:	6a 00                	push   $0x0
  pushl $81
80106f76:	6a 51                	push   $0x51
  jmp alltraps
80106f78:	e9 31 f8 ff ff       	jmp    801067ae <alltraps>

80106f7d <vector82>:
.globl vector82
vector82:
  pushl $0
80106f7d:	6a 00                	push   $0x0
  pushl $82
80106f7f:	6a 52                	push   $0x52
  jmp alltraps
80106f81:	e9 28 f8 ff ff       	jmp    801067ae <alltraps>

80106f86 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f86:	6a 00                	push   $0x0
  pushl $83
80106f88:	6a 53                	push   $0x53
  jmp alltraps
80106f8a:	e9 1f f8 ff ff       	jmp    801067ae <alltraps>

80106f8f <vector84>:
.globl vector84
vector84:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $84
80106f91:	6a 54                	push   $0x54
  jmp alltraps
80106f93:	e9 16 f8 ff ff       	jmp    801067ae <alltraps>

80106f98 <vector85>:
.globl vector85
vector85:
  pushl $0
80106f98:	6a 00                	push   $0x0
  pushl $85
80106f9a:	6a 55                	push   $0x55
  jmp alltraps
80106f9c:	e9 0d f8 ff ff       	jmp    801067ae <alltraps>

80106fa1 <vector86>:
.globl vector86
vector86:
  pushl $0
80106fa1:	6a 00                	push   $0x0
  pushl $86
80106fa3:	6a 56                	push   $0x56
  jmp alltraps
80106fa5:	e9 04 f8 ff ff       	jmp    801067ae <alltraps>

80106faa <vector87>:
.globl vector87
vector87:
  pushl $0
80106faa:	6a 00                	push   $0x0
  pushl $87
80106fac:	6a 57                	push   $0x57
  jmp alltraps
80106fae:	e9 fb f7 ff ff       	jmp    801067ae <alltraps>

80106fb3 <vector88>:
.globl vector88
vector88:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $88
80106fb5:	6a 58                	push   $0x58
  jmp alltraps
80106fb7:	e9 f2 f7 ff ff       	jmp    801067ae <alltraps>

80106fbc <vector89>:
.globl vector89
vector89:
  pushl $0
80106fbc:	6a 00                	push   $0x0
  pushl $89
80106fbe:	6a 59                	push   $0x59
  jmp alltraps
80106fc0:	e9 e9 f7 ff ff       	jmp    801067ae <alltraps>

80106fc5 <vector90>:
.globl vector90
vector90:
  pushl $0
80106fc5:	6a 00                	push   $0x0
  pushl $90
80106fc7:	6a 5a                	push   $0x5a
  jmp alltraps
80106fc9:	e9 e0 f7 ff ff       	jmp    801067ae <alltraps>

80106fce <vector91>:
.globl vector91
vector91:
  pushl $0
80106fce:	6a 00                	push   $0x0
  pushl $91
80106fd0:	6a 5b                	push   $0x5b
  jmp alltraps
80106fd2:	e9 d7 f7 ff ff       	jmp    801067ae <alltraps>

80106fd7 <vector92>:
.globl vector92
vector92:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $92
80106fd9:	6a 5c                	push   $0x5c
  jmp alltraps
80106fdb:	e9 ce f7 ff ff       	jmp    801067ae <alltraps>

80106fe0 <vector93>:
.globl vector93
vector93:
  pushl $0
80106fe0:	6a 00                	push   $0x0
  pushl $93
80106fe2:	6a 5d                	push   $0x5d
  jmp alltraps
80106fe4:	e9 c5 f7 ff ff       	jmp    801067ae <alltraps>

80106fe9 <vector94>:
.globl vector94
vector94:
  pushl $0
80106fe9:	6a 00                	push   $0x0
  pushl $94
80106feb:	6a 5e                	push   $0x5e
  jmp alltraps
80106fed:	e9 bc f7 ff ff       	jmp    801067ae <alltraps>

80106ff2 <vector95>:
.globl vector95
vector95:
  pushl $0
80106ff2:	6a 00                	push   $0x0
  pushl $95
80106ff4:	6a 5f                	push   $0x5f
  jmp alltraps
80106ff6:	e9 b3 f7 ff ff       	jmp    801067ae <alltraps>

80106ffb <vector96>:
.globl vector96
vector96:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $96
80106ffd:	6a 60                	push   $0x60
  jmp alltraps
80106fff:	e9 aa f7 ff ff       	jmp    801067ae <alltraps>

80107004 <vector97>:
.globl vector97
vector97:
  pushl $0
80107004:	6a 00                	push   $0x0
  pushl $97
80107006:	6a 61                	push   $0x61
  jmp alltraps
80107008:	e9 a1 f7 ff ff       	jmp    801067ae <alltraps>

8010700d <vector98>:
.globl vector98
vector98:
  pushl $0
8010700d:	6a 00                	push   $0x0
  pushl $98
8010700f:	6a 62                	push   $0x62
  jmp alltraps
80107011:	e9 98 f7 ff ff       	jmp    801067ae <alltraps>

80107016 <vector99>:
.globl vector99
vector99:
  pushl $0
80107016:	6a 00                	push   $0x0
  pushl $99
80107018:	6a 63                	push   $0x63
  jmp alltraps
8010701a:	e9 8f f7 ff ff       	jmp    801067ae <alltraps>

8010701f <vector100>:
.globl vector100
vector100:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $100
80107021:	6a 64                	push   $0x64
  jmp alltraps
80107023:	e9 86 f7 ff ff       	jmp    801067ae <alltraps>

80107028 <vector101>:
.globl vector101
vector101:
  pushl $0
80107028:	6a 00                	push   $0x0
  pushl $101
8010702a:	6a 65                	push   $0x65
  jmp alltraps
8010702c:	e9 7d f7 ff ff       	jmp    801067ae <alltraps>

80107031 <vector102>:
.globl vector102
vector102:
  pushl $0
80107031:	6a 00                	push   $0x0
  pushl $102
80107033:	6a 66                	push   $0x66
  jmp alltraps
80107035:	e9 74 f7 ff ff       	jmp    801067ae <alltraps>

8010703a <vector103>:
.globl vector103
vector103:
  pushl $0
8010703a:	6a 00                	push   $0x0
  pushl $103
8010703c:	6a 67                	push   $0x67
  jmp alltraps
8010703e:	e9 6b f7 ff ff       	jmp    801067ae <alltraps>

80107043 <vector104>:
.globl vector104
vector104:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $104
80107045:	6a 68                	push   $0x68
  jmp alltraps
80107047:	e9 62 f7 ff ff       	jmp    801067ae <alltraps>

8010704c <vector105>:
.globl vector105
vector105:
  pushl $0
8010704c:	6a 00                	push   $0x0
  pushl $105
8010704e:	6a 69                	push   $0x69
  jmp alltraps
80107050:	e9 59 f7 ff ff       	jmp    801067ae <alltraps>

80107055 <vector106>:
.globl vector106
vector106:
  pushl $0
80107055:	6a 00                	push   $0x0
  pushl $106
80107057:	6a 6a                	push   $0x6a
  jmp alltraps
80107059:	e9 50 f7 ff ff       	jmp    801067ae <alltraps>

8010705e <vector107>:
.globl vector107
vector107:
  pushl $0
8010705e:	6a 00                	push   $0x0
  pushl $107
80107060:	6a 6b                	push   $0x6b
  jmp alltraps
80107062:	e9 47 f7 ff ff       	jmp    801067ae <alltraps>

80107067 <vector108>:
.globl vector108
vector108:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $108
80107069:	6a 6c                	push   $0x6c
  jmp alltraps
8010706b:	e9 3e f7 ff ff       	jmp    801067ae <alltraps>

80107070 <vector109>:
.globl vector109
vector109:
  pushl $0
80107070:	6a 00                	push   $0x0
  pushl $109
80107072:	6a 6d                	push   $0x6d
  jmp alltraps
80107074:	e9 35 f7 ff ff       	jmp    801067ae <alltraps>

80107079 <vector110>:
.globl vector110
vector110:
  pushl $0
80107079:	6a 00                	push   $0x0
  pushl $110
8010707b:	6a 6e                	push   $0x6e
  jmp alltraps
8010707d:	e9 2c f7 ff ff       	jmp    801067ae <alltraps>

80107082 <vector111>:
.globl vector111
vector111:
  pushl $0
80107082:	6a 00                	push   $0x0
  pushl $111
80107084:	6a 6f                	push   $0x6f
  jmp alltraps
80107086:	e9 23 f7 ff ff       	jmp    801067ae <alltraps>

8010708b <vector112>:
.globl vector112
vector112:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $112
8010708d:	6a 70                	push   $0x70
  jmp alltraps
8010708f:	e9 1a f7 ff ff       	jmp    801067ae <alltraps>

80107094 <vector113>:
.globl vector113
vector113:
  pushl $0
80107094:	6a 00                	push   $0x0
  pushl $113
80107096:	6a 71                	push   $0x71
  jmp alltraps
80107098:	e9 11 f7 ff ff       	jmp    801067ae <alltraps>

8010709d <vector114>:
.globl vector114
vector114:
  pushl $0
8010709d:	6a 00                	push   $0x0
  pushl $114
8010709f:	6a 72                	push   $0x72
  jmp alltraps
801070a1:	e9 08 f7 ff ff       	jmp    801067ae <alltraps>

801070a6 <vector115>:
.globl vector115
vector115:
  pushl $0
801070a6:	6a 00                	push   $0x0
  pushl $115
801070a8:	6a 73                	push   $0x73
  jmp alltraps
801070aa:	e9 ff f6 ff ff       	jmp    801067ae <alltraps>

801070af <vector116>:
.globl vector116
vector116:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $116
801070b1:	6a 74                	push   $0x74
  jmp alltraps
801070b3:	e9 f6 f6 ff ff       	jmp    801067ae <alltraps>

801070b8 <vector117>:
.globl vector117
vector117:
  pushl $0
801070b8:	6a 00                	push   $0x0
  pushl $117
801070ba:	6a 75                	push   $0x75
  jmp alltraps
801070bc:	e9 ed f6 ff ff       	jmp    801067ae <alltraps>

801070c1 <vector118>:
.globl vector118
vector118:
  pushl $0
801070c1:	6a 00                	push   $0x0
  pushl $118
801070c3:	6a 76                	push   $0x76
  jmp alltraps
801070c5:	e9 e4 f6 ff ff       	jmp    801067ae <alltraps>

801070ca <vector119>:
.globl vector119
vector119:
  pushl $0
801070ca:	6a 00                	push   $0x0
  pushl $119
801070cc:	6a 77                	push   $0x77
  jmp alltraps
801070ce:	e9 db f6 ff ff       	jmp    801067ae <alltraps>

801070d3 <vector120>:
.globl vector120
vector120:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $120
801070d5:	6a 78                	push   $0x78
  jmp alltraps
801070d7:	e9 d2 f6 ff ff       	jmp    801067ae <alltraps>

801070dc <vector121>:
.globl vector121
vector121:
  pushl $0
801070dc:	6a 00                	push   $0x0
  pushl $121
801070de:	6a 79                	push   $0x79
  jmp alltraps
801070e0:	e9 c9 f6 ff ff       	jmp    801067ae <alltraps>

801070e5 <vector122>:
.globl vector122
vector122:
  pushl $0
801070e5:	6a 00                	push   $0x0
  pushl $122
801070e7:	6a 7a                	push   $0x7a
  jmp alltraps
801070e9:	e9 c0 f6 ff ff       	jmp    801067ae <alltraps>

801070ee <vector123>:
.globl vector123
vector123:
  pushl $0
801070ee:	6a 00                	push   $0x0
  pushl $123
801070f0:	6a 7b                	push   $0x7b
  jmp alltraps
801070f2:	e9 b7 f6 ff ff       	jmp    801067ae <alltraps>

801070f7 <vector124>:
.globl vector124
vector124:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $124
801070f9:	6a 7c                	push   $0x7c
  jmp alltraps
801070fb:	e9 ae f6 ff ff       	jmp    801067ae <alltraps>

80107100 <vector125>:
.globl vector125
vector125:
  pushl $0
80107100:	6a 00                	push   $0x0
  pushl $125
80107102:	6a 7d                	push   $0x7d
  jmp alltraps
80107104:	e9 a5 f6 ff ff       	jmp    801067ae <alltraps>

80107109 <vector126>:
.globl vector126
vector126:
  pushl $0
80107109:	6a 00                	push   $0x0
  pushl $126
8010710b:	6a 7e                	push   $0x7e
  jmp alltraps
8010710d:	e9 9c f6 ff ff       	jmp    801067ae <alltraps>

80107112 <vector127>:
.globl vector127
vector127:
  pushl $0
80107112:	6a 00                	push   $0x0
  pushl $127
80107114:	6a 7f                	push   $0x7f
  jmp alltraps
80107116:	e9 93 f6 ff ff       	jmp    801067ae <alltraps>

8010711b <vector128>:
.globl vector128
vector128:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $128
8010711d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107122:	e9 87 f6 ff ff       	jmp    801067ae <alltraps>

80107127 <vector129>:
.globl vector129
vector129:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $129
80107129:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010712e:	e9 7b f6 ff ff       	jmp    801067ae <alltraps>

80107133 <vector130>:
.globl vector130
vector130:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $130
80107135:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010713a:	e9 6f f6 ff ff       	jmp    801067ae <alltraps>

8010713f <vector131>:
.globl vector131
vector131:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $131
80107141:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107146:	e9 63 f6 ff ff       	jmp    801067ae <alltraps>

8010714b <vector132>:
.globl vector132
vector132:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $132
8010714d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107152:	e9 57 f6 ff ff       	jmp    801067ae <alltraps>

80107157 <vector133>:
.globl vector133
vector133:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $133
80107159:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010715e:	e9 4b f6 ff ff       	jmp    801067ae <alltraps>

80107163 <vector134>:
.globl vector134
vector134:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $134
80107165:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010716a:	e9 3f f6 ff ff       	jmp    801067ae <alltraps>

8010716f <vector135>:
.globl vector135
vector135:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $135
80107171:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107176:	e9 33 f6 ff ff       	jmp    801067ae <alltraps>

8010717b <vector136>:
.globl vector136
vector136:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $136
8010717d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107182:	e9 27 f6 ff ff       	jmp    801067ae <alltraps>

80107187 <vector137>:
.globl vector137
vector137:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $137
80107189:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010718e:	e9 1b f6 ff ff       	jmp    801067ae <alltraps>

80107193 <vector138>:
.globl vector138
vector138:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $138
80107195:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010719a:	e9 0f f6 ff ff       	jmp    801067ae <alltraps>

8010719f <vector139>:
.globl vector139
vector139:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $139
801071a1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801071a6:	e9 03 f6 ff ff       	jmp    801067ae <alltraps>

801071ab <vector140>:
.globl vector140
vector140:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $140
801071ad:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801071b2:	e9 f7 f5 ff ff       	jmp    801067ae <alltraps>

801071b7 <vector141>:
.globl vector141
vector141:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $141
801071b9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801071be:	e9 eb f5 ff ff       	jmp    801067ae <alltraps>

801071c3 <vector142>:
.globl vector142
vector142:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $142
801071c5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801071ca:	e9 df f5 ff ff       	jmp    801067ae <alltraps>

801071cf <vector143>:
.globl vector143
vector143:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $143
801071d1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801071d6:	e9 d3 f5 ff ff       	jmp    801067ae <alltraps>

801071db <vector144>:
.globl vector144
vector144:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $144
801071dd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801071e2:	e9 c7 f5 ff ff       	jmp    801067ae <alltraps>

801071e7 <vector145>:
.globl vector145
vector145:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $145
801071e9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071ee:	e9 bb f5 ff ff       	jmp    801067ae <alltraps>

801071f3 <vector146>:
.globl vector146
vector146:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $146
801071f5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071fa:	e9 af f5 ff ff       	jmp    801067ae <alltraps>

801071ff <vector147>:
.globl vector147
vector147:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $147
80107201:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107206:	e9 a3 f5 ff ff       	jmp    801067ae <alltraps>

8010720b <vector148>:
.globl vector148
vector148:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $148
8010720d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107212:	e9 97 f5 ff ff       	jmp    801067ae <alltraps>

80107217 <vector149>:
.globl vector149
vector149:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $149
80107219:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010721e:	e9 8b f5 ff ff       	jmp    801067ae <alltraps>

80107223 <vector150>:
.globl vector150
vector150:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $150
80107225:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010722a:	e9 7f f5 ff ff       	jmp    801067ae <alltraps>

8010722f <vector151>:
.globl vector151
vector151:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $151
80107231:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107236:	e9 73 f5 ff ff       	jmp    801067ae <alltraps>

8010723b <vector152>:
.globl vector152
vector152:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $152
8010723d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107242:	e9 67 f5 ff ff       	jmp    801067ae <alltraps>

80107247 <vector153>:
.globl vector153
vector153:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $153
80107249:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010724e:	e9 5b f5 ff ff       	jmp    801067ae <alltraps>

80107253 <vector154>:
.globl vector154
vector154:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $154
80107255:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010725a:	e9 4f f5 ff ff       	jmp    801067ae <alltraps>

8010725f <vector155>:
.globl vector155
vector155:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $155
80107261:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107266:	e9 43 f5 ff ff       	jmp    801067ae <alltraps>

8010726b <vector156>:
.globl vector156
vector156:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $156
8010726d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107272:	e9 37 f5 ff ff       	jmp    801067ae <alltraps>

80107277 <vector157>:
.globl vector157
vector157:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $157
80107279:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010727e:	e9 2b f5 ff ff       	jmp    801067ae <alltraps>

80107283 <vector158>:
.globl vector158
vector158:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $158
80107285:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010728a:	e9 1f f5 ff ff       	jmp    801067ae <alltraps>

8010728f <vector159>:
.globl vector159
vector159:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $159
80107291:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107296:	e9 13 f5 ff ff       	jmp    801067ae <alltraps>

8010729b <vector160>:
.globl vector160
vector160:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $160
8010729d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801072a2:	e9 07 f5 ff ff       	jmp    801067ae <alltraps>

801072a7 <vector161>:
.globl vector161
vector161:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $161
801072a9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801072ae:	e9 fb f4 ff ff       	jmp    801067ae <alltraps>

801072b3 <vector162>:
.globl vector162
vector162:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $162
801072b5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801072ba:	e9 ef f4 ff ff       	jmp    801067ae <alltraps>

801072bf <vector163>:
.globl vector163
vector163:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $163
801072c1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801072c6:	e9 e3 f4 ff ff       	jmp    801067ae <alltraps>

801072cb <vector164>:
.globl vector164
vector164:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $164
801072cd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801072d2:	e9 d7 f4 ff ff       	jmp    801067ae <alltraps>

801072d7 <vector165>:
.globl vector165
vector165:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $165
801072d9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801072de:	e9 cb f4 ff ff       	jmp    801067ae <alltraps>

801072e3 <vector166>:
.globl vector166
vector166:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $166
801072e5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072ea:	e9 bf f4 ff ff       	jmp    801067ae <alltraps>

801072ef <vector167>:
.globl vector167
vector167:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $167
801072f1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072f6:	e9 b3 f4 ff ff       	jmp    801067ae <alltraps>

801072fb <vector168>:
.globl vector168
vector168:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $168
801072fd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107302:	e9 a7 f4 ff ff       	jmp    801067ae <alltraps>

80107307 <vector169>:
.globl vector169
vector169:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $169
80107309:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010730e:	e9 9b f4 ff ff       	jmp    801067ae <alltraps>

80107313 <vector170>:
.globl vector170
vector170:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $170
80107315:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010731a:	e9 8f f4 ff ff       	jmp    801067ae <alltraps>

8010731f <vector171>:
.globl vector171
vector171:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $171
80107321:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107326:	e9 83 f4 ff ff       	jmp    801067ae <alltraps>

8010732b <vector172>:
.globl vector172
vector172:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $172
8010732d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107332:	e9 77 f4 ff ff       	jmp    801067ae <alltraps>

80107337 <vector173>:
.globl vector173
vector173:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $173
80107339:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010733e:	e9 6b f4 ff ff       	jmp    801067ae <alltraps>

80107343 <vector174>:
.globl vector174
vector174:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $174
80107345:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010734a:	e9 5f f4 ff ff       	jmp    801067ae <alltraps>

8010734f <vector175>:
.globl vector175
vector175:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $175
80107351:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107356:	e9 53 f4 ff ff       	jmp    801067ae <alltraps>

8010735b <vector176>:
.globl vector176
vector176:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $176
8010735d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107362:	e9 47 f4 ff ff       	jmp    801067ae <alltraps>

80107367 <vector177>:
.globl vector177
vector177:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $177
80107369:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010736e:	e9 3b f4 ff ff       	jmp    801067ae <alltraps>

80107373 <vector178>:
.globl vector178
vector178:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $178
80107375:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010737a:	e9 2f f4 ff ff       	jmp    801067ae <alltraps>

8010737f <vector179>:
.globl vector179
vector179:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $179
80107381:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107386:	e9 23 f4 ff ff       	jmp    801067ae <alltraps>

8010738b <vector180>:
.globl vector180
vector180:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $180
8010738d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107392:	e9 17 f4 ff ff       	jmp    801067ae <alltraps>

80107397 <vector181>:
.globl vector181
vector181:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $181
80107399:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010739e:	e9 0b f4 ff ff       	jmp    801067ae <alltraps>

801073a3 <vector182>:
.globl vector182
vector182:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $182
801073a5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801073aa:	e9 ff f3 ff ff       	jmp    801067ae <alltraps>

801073af <vector183>:
.globl vector183
vector183:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $183
801073b1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801073b6:	e9 f3 f3 ff ff       	jmp    801067ae <alltraps>

801073bb <vector184>:
.globl vector184
vector184:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $184
801073bd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801073c2:	e9 e7 f3 ff ff       	jmp    801067ae <alltraps>

801073c7 <vector185>:
.globl vector185
vector185:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $185
801073c9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801073ce:	e9 db f3 ff ff       	jmp    801067ae <alltraps>

801073d3 <vector186>:
.globl vector186
vector186:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $186
801073d5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801073da:	e9 cf f3 ff ff       	jmp    801067ae <alltraps>

801073df <vector187>:
.globl vector187
vector187:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $187
801073e1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073e6:	e9 c3 f3 ff ff       	jmp    801067ae <alltraps>

801073eb <vector188>:
.globl vector188
vector188:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $188
801073ed:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073f2:	e9 b7 f3 ff ff       	jmp    801067ae <alltraps>

801073f7 <vector189>:
.globl vector189
vector189:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $189
801073f9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073fe:	e9 ab f3 ff ff       	jmp    801067ae <alltraps>

80107403 <vector190>:
.globl vector190
vector190:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $190
80107405:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010740a:	e9 9f f3 ff ff       	jmp    801067ae <alltraps>

8010740f <vector191>:
.globl vector191
vector191:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $191
80107411:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107416:	e9 93 f3 ff ff       	jmp    801067ae <alltraps>

8010741b <vector192>:
.globl vector192
vector192:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $192
8010741d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107422:	e9 87 f3 ff ff       	jmp    801067ae <alltraps>

80107427 <vector193>:
.globl vector193
vector193:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $193
80107429:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010742e:	e9 7b f3 ff ff       	jmp    801067ae <alltraps>

80107433 <vector194>:
.globl vector194
vector194:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $194
80107435:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010743a:	e9 6f f3 ff ff       	jmp    801067ae <alltraps>

8010743f <vector195>:
.globl vector195
vector195:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $195
80107441:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107446:	e9 63 f3 ff ff       	jmp    801067ae <alltraps>

8010744b <vector196>:
.globl vector196
vector196:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $196
8010744d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107452:	e9 57 f3 ff ff       	jmp    801067ae <alltraps>

80107457 <vector197>:
.globl vector197
vector197:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $197
80107459:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010745e:	e9 4b f3 ff ff       	jmp    801067ae <alltraps>

80107463 <vector198>:
.globl vector198
vector198:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $198
80107465:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010746a:	e9 3f f3 ff ff       	jmp    801067ae <alltraps>

8010746f <vector199>:
.globl vector199
vector199:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $199
80107471:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107476:	e9 33 f3 ff ff       	jmp    801067ae <alltraps>

8010747b <vector200>:
.globl vector200
vector200:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $200
8010747d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107482:	e9 27 f3 ff ff       	jmp    801067ae <alltraps>

80107487 <vector201>:
.globl vector201
vector201:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $201
80107489:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010748e:	e9 1b f3 ff ff       	jmp    801067ae <alltraps>

80107493 <vector202>:
.globl vector202
vector202:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $202
80107495:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010749a:	e9 0f f3 ff ff       	jmp    801067ae <alltraps>

8010749f <vector203>:
.globl vector203
vector203:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $203
801074a1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801074a6:	e9 03 f3 ff ff       	jmp    801067ae <alltraps>

801074ab <vector204>:
.globl vector204
vector204:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $204
801074ad:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801074b2:	e9 f7 f2 ff ff       	jmp    801067ae <alltraps>

801074b7 <vector205>:
.globl vector205
vector205:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $205
801074b9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801074be:	e9 eb f2 ff ff       	jmp    801067ae <alltraps>

801074c3 <vector206>:
.globl vector206
vector206:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $206
801074c5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801074ca:	e9 df f2 ff ff       	jmp    801067ae <alltraps>

801074cf <vector207>:
.globl vector207
vector207:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $207
801074d1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801074d6:	e9 d3 f2 ff ff       	jmp    801067ae <alltraps>

801074db <vector208>:
.globl vector208
vector208:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $208
801074dd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801074e2:	e9 c7 f2 ff ff       	jmp    801067ae <alltraps>

801074e7 <vector209>:
.globl vector209
vector209:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $209
801074e9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074ee:	e9 bb f2 ff ff       	jmp    801067ae <alltraps>

801074f3 <vector210>:
.globl vector210
vector210:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $210
801074f5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074fa:	e9 af f2 ff ff       	jmp    801067ae <alltraps>

801074ff <vector211>:
.globl vector211
vector211:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $211
80107501:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107506:	e9 a3 f2 ff ff       	jmp    801067ae <alltraps>

8010750b <vector212>:
.globl vector212
vector212:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $212
8010750d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107512:	e9 97 f2 ff ff       	jmp    801067ae <alltraps>

80107517 <vector213>:
.globl vector213
vector213:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $213
80107519:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010751e:	e9 8b f2 ff ff       	jmp    801067ae <alltraps>

80107523 <vector214>:
.globl vector214
vector214:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $214
80107525:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010752a:	e9 7f f2 ff ff       	jmp    801067ae <alltraps>

8010752f <vector215>:
.globl vector215
vector215:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $215
80107531:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107536:	e9 73 f2 ff ff       	jmp    801067ae <alltraps>

8010753b <vector216>:
.globl vector216
vector216:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $216
8010753d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107542:	e9 67 f2 ff ff       	jmp    801067ae <alltraps>

80107547 <vector217>:
.globl vector217
vector217:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $217
80107549:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010754e:	e9 5b f2 ff ff       	jmp    801067ae <alltraps>

80107553 <vector218>:
.globl vector218
vector218:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $218
80107555:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010755a:	e9 4f f2 ff ff       	jmp    801067ae <alltraps>

8010755f <vector219>:
.globl vector219
vector219:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $219
80107561:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107566:	e9 43 f2 ff ff       	jmp    801067ae <alltraps>

8010756b <vector220>:
.globl vector220
vector220:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $220
8010756d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107572:	e9 37 f2 ff ff       	jmp    801067ae <alltraps>

80107577 <vector221>:
.globl vector221
vector221:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $221
80107579:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010757e:	e9 2b f2 ff ff       	jmp    801067ae <alltraps>

80107583 <vector222>:
.globl vector222
vector222:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $222
80107585:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010758a:	e9 1f f2 ff ff       	jmp    801067ae <alltraps>

8010758f <vector223>:
.globl vector223
vector223:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $223
80107591:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107596:	e9 13 f2 ff ff       	jmp    801067ae <alltraps>

8010759b <vector224>:
.globl vector224
vector224:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $224
8010759d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801075a2:	e9 07 f2 ff ff       	jmp    801067ae <alltraps>

801075a7 <vector225>:
.globl vector225
vector225:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $225
801075a9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801075ae:	e9 fb f1 ff ff       	jmp    801067ae <alltraps>

801075b3 <vector226>:
.globl vector226
vector226:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $226
801075b5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801075ba:	e9 ef f1 ff ff       	jmp    801067ae <alltraps>

801075bf <vector227>:
.globl vector227
vector227:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $227
801075c1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801075c6:	e9 e3 f1 ff ff       	jmp    801067ae <alltraps>

801075cb <vector228>:
.globl vector228
vector228:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $228
801075cd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801075d2:	e9 d7 f1 ff ff       	jmp    801067ae <alltraps>

801075d7 <vector229>:
.globl vector229
vector229:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $229
801075d9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801075de:	e9 cb f1 ff ff       	jmp    801067ae <alltraps>

801075e3 <vector230>:
.globl vector230
vector230:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $230
801075e5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075ea:	e9 bf f1 ff ff       	jmp    801067ae <alltraps>

801075ef <vector231>:
.globl vector231
vector231:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $231
801075f1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075f6:	e9 b3 f1 ff ff       	jmp    801067ae <alltraps>

801075fb <vector232>:
.globl vector232
vector232:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $232
801075fd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107602:	e9 a7 f1 ff ff       	jmp    801067ae <alltraps>

80107607 <vector233>:
.globl vector233
vector233:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $233
80107609:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010760e:	e9 9b f1 ff ff       	jmp    801067ae <alltraps>

80107613 <vector234>:
.globl vector234
vector234:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $234
80107615:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010761a:	e9 8f f1 ff ff       	jmp    801067ae <alltraps>

8010761f <vector235>:
.globl vector235
vector235:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $235
80107621:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107626:	e9 83 f1 ff ff       	jmp    801067ae <alltraps>

8010762b <vector236>:
.globl vector236
vector236:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $236
8010762d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107632:	e9 77 f1 ff ff       	jmp    801067ae <alltraps>

80107637 <vector237>:
.globl vector237
vector237:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $237
80107639:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010763e:	e9 6b f1 ff ff       	jmp    801067ae <alltraps>

80107643 <vector238>:
.globl vector238
vector238:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $238
80107645:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010764a:	e9 5f f1 ff ff       	jmp    801067ae <alltraps>

8010764f <vector239>:
.globl vector239
vector239:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $239
80107651:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107656:	e9 53 f1 ff ff       	jmp    801067ae <alltraps>

8010765b <vector240>:
.globl vector240
vector240:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $240
8010765d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107662:	e9 47 f1 ff ff       	jmp    801067ae <alltraps>

80107667 <vector241>:
.globl vector241
vector241:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $241
80107669:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010766e:	e9 3b f1 ff ff       	jmp    801067ae <alltraps>

80107673 <vector242>:
.globl vector242
vector242:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $242
80107675:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010767a:	e9 2f f1 ff ff       	jmp    801067ae <alltraps>

8010767f <vector243>:
.globl vector243
vector243:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $243
80107681:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107686:	e9 23 f1 ff ff       	jmp    801067ae <alltraps>

8010768b <vector244>:
.globl vector244
vector244:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $244
8010768d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107692:	e9 17 f1 ff ff       	jmp    801067ae <alltraps>

80107697 <vector245>:
.globl vector245
vector245:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $245
80107699:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010769e:	e9 0b f1 ff ff       	jmp    801067ae <alltraps>

801076a3 <vector246>:
.globl vector246
vector246:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $246
801076a5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801076aa:	e9 ff f0 ff ff       	jmp    801067ae <alltraps>

801076af <vector247>:
.globl vector247
vector247:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $247
801076b1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801076b6:	e9 f3 f0 ff ff       	jmp    801067ae <alltraps>

801076bb <vector248>:
.globl vector248
vector248:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $248
801076bd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801076c2:	e9 e7 f0 ff ff       	jmp    801067ae <alltraps>

801076c7 <vector249>:
.globl vector249
vector249:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $249
801076c9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801076ce:	e9 db f0 ff ff       	jmp    801067ae <alltraps>

801076d3 <vector250>:
.globl vector250
vector250:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $250
801076d5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801076da:	e9 cf f0 ff ff       	jmp    801067ae <alltraps>

801076df <vector251>:
.globl vector251
vector251:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $251
801076e1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076e6:	e9 c3 f0 ff ff       	jmp    801067ae <alltraps>

801076eb <vector252>:
.globl vector252
vector252:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $252
801076ed:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076f2:	e9 b7 f0 ff ff       	jmp    801067ae <alltraps>

801076f7 <vector253>:
.globl vector253
vector253:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $253
801076f9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076fe:	e9 ab f0 ff ff       	jmp    801067ae <alltraps>

80107703 <vector254>:
.globl vector254
vector254:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $254
80107705:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010770a:	e9 9f f0 ff ff       	jmp    801067ae <alltraps>

8010770f <vector255>:
.globl vector255
vector255:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $255
80107711:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107716:	e9 93 f0 ff ff       	jmp    801067ae <alltraps>
8010771b:	66 90                	xchg   %ax,%ax
8010771d:	66 90                	xchg   %ax,%ax
8010771f:	90                   	nop

80107720 <seginit>:
pde_t *kpgdir;      // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void seginit(void)
{
80107720:	f3 0f 1e fb          	endbr32 
80107724:	55                   	push   %ebp
80107725:	89 e5                	mov    %esp,%ebp
80107727:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
8010772a:	e8 41 d0 ff ff       	call   80104770 <cpuid>
  pd[0] = size-1;
8010772f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107734:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010773a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010773e:	c7 80 38 99 11 80 ff 	movl   $0xffff,-0x7fee66c8(%eax)
80107745:	ff 00 00 
80107748:	c7 80 3c 99 11 80 00 	movl   $0xcf9a00,-0x7fee66c4(%eax)
8010774f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107752:	c7 80 40 99 11 80 ff 	movl   $0xffff,-0x7fee66c0(%eax)
80107759:	ff 00 00 
8010775c:	c7 80 44 99 11 80 00 	movl   $0xcf9200,-0x7fee66bc(%eax)
80107763:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80107766:	c7 80 48 99 11 80 ff 	movl   $0xffff,-0x7fee66b8(%eax)
8010776d:	ff 00 00 
80107770:	c7 80 4c 99 11 80 00 	movl   $0xcffa00,-0x7fee66b4(%eax)
80107777:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010777a:	c7 80 50 99 11 80 ff 	movl   $0xffff,-0x7fee66b0(%eax)
80107781:	ff 00 00 
80107784:	c7 80 54 99 11 80 00 	movl   $0xcff200,-0x7fee66ac(%eax)
8010778b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010778e:	05 30 99 11 80       	add    $0x80119930,%eax
  pd[1] = (uint)p;
80107793:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107797:	c1 e8 10             	shr    $0x10,%eax
8010779a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010779e:	8d 45 f2             	lea    -0xe(%ebp),%eax
801077a1:	0f 01 10             	lgdtl  (%eax)
}
801077a4:	c9                   	leave  
801077a5:	c3                   	ret    
801077a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ad:	8d 76 00             	lea    0x0(%esi),%esi

801077b0 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801077b0:	f3 0f 1e fb          	endbr32 
801077b4:	55                   	push   %ebp
801077b5:	89 e5                	mov    %esp,%ebp
801077b7:	57                   	push   %edi
801077b8:	56                   	push   %esi
801077b9:	53                   	push   %ebx
801077ba:	83 ec 0c             	sub    $0xc,%esp
801077bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801077c0:	8b 55 08             	mov    0x8(%ebp),%edx
801077c3:	89 fe                	mov    %edi,%esi
801077c5:	c1 ee 16             	shr    $0x16,%esi
801077c8:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if (*pde & PTE_P)
801077cb:	8b 1e                	mov    (%esi),%ebx
801077cd:	f6 c3 01             	test   $0x1,%bl
801077d0:	74 26                	je     801077f8 <walkpgdir+0x48>
  {
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
801077d2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801077d8:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801077de:	89 f8                	mov    %edi,%eax
}
801077e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801077e3:	c1 e8 0a             	shr    $0xa,%eax
801077e6:	25 fc 0f 00 00       	and    $0xffc,%eax
801077eb:	01 d8                	add    %ebx,%eax
}
801077ed:	5b                   	pop    %ebx
801077ee:	5e                   	pop    %esi
801077ef:	5f                   	pop    %edi
801077f0:	5d                   	pop    %ebp
801077f1:	c3                   	ret    
801077f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (!alloc || (pgtab = (pte_t *)kalloc()) == 0)
801077f8:	8b 45 10             	mov    0x10(%ebp),%eax
801077fb:	85 c0                	test   %eax,%eax
801077fd:	74 31                	je     80107830 <walkpgdir+0x80>
801077ff:	e8 1c ba ff ff       	call   80103220 <kalloc>
80107804:	89 c3                	mov    %eax,%ebx
80107806:	85 c0                	test   %eax,%eax
80107808:	74 26                	je     80107830 <walkpgdir+0x80>
    memset(pgtab, 0, PGSIZE);
8010780a:	83 ec 04             	sub    $0x4,%esp
8010780d:	68 00 10 00 00       	push   $0x1000
80107812:	6a 00                	push   $0x0
80107814:	50                   	push   %eax
80107815:	e8 76 dc ff ff       	call   80105490 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010781a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107820:	83 c4 10             	add    $0x10,%esp
80107823:	83 c8 07             	or     $0x7,%eax
80107826:	89 06                	mov    %eax,(%esi)
80107828:	eb b4                	jmp    801077de <walkpgdir+0x2e>
8010782a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80107830:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107833:	31 c0                	xor    %eax,%eax
}
80107835:	5b                   	pop    %ebx
80107836:	5e                   	pop    %esi
80107837:	5f                   	pop    %edi
80107838:	5d                   	pop    %ebp
80107839:	c3                   	ret    
8010783a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107840 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107840:	55                   	push   %ebp
80107841:	89 e5                	mov    %esp,%ebp
80107843:	57                   	push   %edi
80107844:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char *)PGROUNDDOWN((uint)va);
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80107846:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010784a:	56                   	push   %esi
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
8010784b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char *)PGROUNDDOWN((uint)va);
80107850:	89 d6                	mov    %edx,%esi
{
80107852:	53                   	push   %ebx
  a = (char *)PGROUNDDOWN((uint)va);
80107853:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107859:	83 ec 1c             	sub    $0x1c,%esp
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
8010785c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010785f:	8b 45 08             	mov    0x8(%ebp),%eax
80107862:	29 f0                	sub    %esi,%eax
80107864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107867:	eb 1f                	jmp    80107888 <mappages+0x48>
80107869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (;;)
  {
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if (*pte & PTE_P)
80107870:	f6 00 01             	testb  $0x1,(%eax)
80107873:	75 45                	jne    801078ba <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107875:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107878:	83 cb 01             	or     $0x1,%ebx
8010787b:	89 18                	mov    %ebx,(%eax)
    if (a == last)
8010787d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107880:	74 2e                	je     801078b0 <mappages+0x70>
      break;
    a += PGSIZE;
80107882:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
80107888:	83 ec 04             	sub    $0x4,%esp
8010788b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010788e:	6a 01                	push   $0x1
80107890:	56                   	push   %esi
80107891:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107894:	57                   	push   %edi
80107895:	e8 16 ff ff ff       	call   801077b0 <walkpgdir>
8010789a:	83 c4 10             	add    $0x10,%esp
8010789d:	85 c0                	test   %eax,%eax
8010789f:	75 cf                	jne    80107870 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801078a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801078a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078a9:	5b                   	pop    %ebx
801078aa:	5e                   	pop    %esi
801078ab:	5f                   	pop    %edi
801078ac:	5d                   	pop    %ebp
801078ad:	c3                   	ret    
801078ae:	66 90                	xchg   %ax,%ax
801078b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078b3:	31 c0                	xor    %eax,%eax
}
801078b5:	5b                   	pop    %ebx
801078b6:	5e                   	pop    %esi
801078b7:	5f                   	pop    %edi
801078b8:	5d                   	pop    %ebp
801078b9:	c3                   	ret    
      panic("remap");
801078ba:	83 ec 0c             	sub    $0xc,%esp
801078bd:	68 dc 8e 10 80       	push   $0x80108edc
801078c2:	e8 c9 8a ff ff       	call   80100390 <panic>
801078c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ce:	66 90                	xchg   %ax,%ax

801078d0 <deallocuvm.part.0>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078d0:	55                   	push   %ebp
801078d1:	89 e5                	mov    %esp,%ebp
801078d3:	57                   	push   %edi
801078d4:	56                   	push   %esi
801078d5:	89 c6                	mov    %eax,%esi
801078d7:	53                   	push   %ebx
801078d8:	89 d3                	mov    %edx,%ebx
801078da:	83 ec 1c             	sub    $0x1c,%esp
801078dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  int bitmap_offset;

  if (newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801078e0:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801078e6:	89 d7                	mov    %edx,%edi
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078e8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  a = PGROUNDUP(newsz);
801078eb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for (; a < oldsz; a += PGSIZE)
801078f1:	39 df                	cmp    %ebx,%edi
801078f3:	72 49                	jb     8010793e <deallocuvm.part.0+0x6e>
801078f5:	e9 8a 00 00 00       	jmp    80107984 <deallocuvm.part.0+0xb4>
801078fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (!pte) // pte not exist
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if ((*pte & PTE_P) != 0) // swapped in pages(PTE_P is set)
    {
      pa = PTE_ADDR(*pte);
      if (pa == 0)
80107900:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107906:	0f 84 94 00 00 00    	je     801079a0 <deallocuvm.part.0+0xd0>
        panic("kfree");
      char *v = P2V(pa);
      // remove from LRU list
      page_delete(pgdir, (char *)a);
8010790c:	83 ec 08             	sub    $0x8,%esp
      char *v = P2V(pa);
8010790f:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107915:	89 45 e0             	mov    %eax,-0x20(%ebp)
      page_delete(pgdir, (char *)a);
80107918:	57                   	push   %edi
80107919:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010791f:	56                   	push   %esi
80107920:	e8 bb b3 ff ff       	call   80102ce0 <page_delete>
      kfree(v);
80107925:	89 1c 24             	mov    %ebx,(%esp)
80107928:	e8 53 ac ff ff       	call   80102580 <kfree>
      *pte = 0;
8010792d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107930:	83 c4 10             	add    $0x10,%esp
80107933:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for (; a < oldsz; a += PGSIZE)
80107939:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010793c:	76 46                	jbe    80107984 <deallocuvm.part.0+0xb4>
    pte = walkpgdir(pgdir, (char *)a, 0);
8010793e:	83 ec 04             	sub    $0x4,%esp
80107941:	6a 00                	push   $0x0
80107943:	57                   	push   %edi
80107944:	56                   	push   %esi
80107945:	e8 66 fe ff ff       	call   801077b0 <walkpgdir>
    if (!pte) // pte not exist
8010794a:	83 c4 10             	add    $0x10,%esp
8010794d:	85 c0                	test   %eax,%eax
8010794f:	74 3f                	je     80107990 <deallocuvm.part.0+0xc0>
    else if ((*pte & PTE_P) != 0) // swapped in pages(PTE_P is set)
80107951:	8b 18                	mov    (%eax),%ebx
80107953:	f6 c3 01             	test   $0x1,%bl
80107956:	75 a8                	jne    80107900 <deallocuvm.part.0+0x30>
    }
    else if (*pte != 0) // swapped out pages(pte is not zero, PTE_P is clear)
80107958:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010795e:	85 db                	test   %ebx,%ebx
80107960:	74 d7                	je     80107939 <deallocuvm.part.0+0x69>
    {
      // clear in bitmap
      pa = PTE_ADDR(*pte);
      bitmap_offset = (int)(pa >> 12);
      bitmap_modify(bitmap_offset, 0);
80107962:	83 ec 08             	sub    $0x8,%esp
      bitmap_offset = (int)(pa >> 12);
80107965:	c1 eb 0c             	shr    $0xc,%ebx
80107968:	89 45 e0             	mov    %eax,-0x20(%ebp)
      bitmap_modify(bitmap_offset, 0);
8010796b:	6a 00                	push   $0x0
8010796d:	53                   	push   %ebx
8010796e:	e8 4d b5 ff ff       	call   80102ec0 <bitmap_modify>
      // page_delete(pgdir, (char *)a);
      // clear page table entry
      *pte = 0;
80107973:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107976:	83 c4 10             	add    $0x10,%esp
80107979:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for (; a < oldsz; a += PGSIZE)
8010797f:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107982:	77 ba                	ja     8010793e <deallocuvm.part.0+0x6e>
    }
  }
  return newsz;
}
80107984:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107987:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010798a:	5b                   	pop    %ebx
8010798b:	5e                   	pop    %esi
8010798c:	5f                   	pop    %edi
8010798d:	5d                   	pop    %ebp
8010798e:	c3                   	ret    
8010798f:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107990:	89 f9                	mov    %edi,%ecx
80107992:	81 e1 00 00 c0 ff    	and    $0xffc00000,%ecx
80107998:	8d b9 00 00 40 00    	lea    0x400000(%ecx),%edi
8010799e:	eb 99                	jmp    80107939 <deallocuvm.part.0+0x69>
        panic("kfree");
801079a0:	83 ec 0c             	sub    $0xc,%esp
801079a3:	68 a7 83 10 80       	push   $0x801083a7
801079a8:	e8 e3 89 ff ff       	call   80100390 <panic>
801079ad:	8d 76 00             	lea    0x0(%esi),%esi

801079b0 <switchkvm>:
{
801079b0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir)); // switch to the kernel page table
801079b4:	a1 e4 c5 11 80       	mov    0x8011c5e4,%eax
801079b9:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801079be:	0f 22 d8             	mov    %eax,%cr3
}
801079c1:	c3                   	ret    
801079c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801079d0 <switchuvm>:
{
801079d0:	f3 0f 1e fb          	endbr32 
801079d4:	55                   	push   %ebp
801079d5:	89 e5                	mov    %esp,%ebp
801079d7:	57                   	push   %edi
801079d8:	56                   	push   %esi
801079d9:	53                   	push   %ebx
801079da:	83 ec 1c             	sub    $0x1c,%esp
801079dd:	8b 75 08             	mov    0x8(%ebp),%esi
  if (p == 0)
801079e0:	85 f6                	test   %esi,%esi
801079e2:	0f 84 cb 00 00 00    	je     80107ab3 <switchuvm+0xe3>
  if (p->kstack == 0)
801079e8:	8b 46 08             	mov    0x8(%esi),%eax
801079eb:	85 c0                	test   %eax,%eax
801079ed:	0f 84 da 00 00 00    	je     80107acd <switchuvm+0xfd>
  if (p->pgdir == 0)
801079f3:	8b 46 04             	mov    0x4(%esi),%eax
801079f6:	85 c0                	test   %eax,%eax
801079f8:	0f 84 c2 00 00 00    	je     80107ac0 <switchuvm+0xf0>
  pushcli();
801079fe:	e8 7d d8 ff ff       	call   80105280 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a03:	e8 f8 cc ff ff       	call   80104700 <mycpu>
80107a08:	89 c3                	mov    %eax,%ebx
80107a0a:	e8 f1 cc ff ff       	call   80104700 <mycpu>
80107a0f:	89 c7                	mov    %eax,%edi
80107a11:	e8 ea cc ff ff       	call   80104700 <mycpu>
80107a16:	83 c7 08             	add    $0x8,%edi
80107a19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a1c:	e8 df cc ff ff       	call   80104700 <mycpu>
80107a21:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107a24:	ba 67 00 00 00       	mov    $0x67,%edx
80107a29:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107a30:	83 c0 08             	add    $0x8,%eax
80107a33:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort)0xFFFF;
80107a3a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a3f:	83 c1 08             	add    $0x8,%ecx
80107a42:	c1 e8 18             	shr    $0x18,%eax
80107a45:	c1 e9 10             	shr    $0x10,%ecx
80107a48:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107a4e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107a54:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107a59:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a60:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107a65:	e8 96 cc ff ff       	call   80104700 <mycpu>
80107a6a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a71:	e8 8a cc ff ff       	call   80104700 <mycpu>
80107a76:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107a7a:	8b 5e 08             	mov    0x8(%esi),%ebx
80107a7d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a83:	e8 78 cc ff ff       	call   80104700 <mycpu>
80107a88:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort)0xFFFF;
80107a8b:	e8 70 cc ff ff       	call   80104700 <mycpu>
80107a90:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107a94:	b8 28 00 00 00       	mov    $0x28,%eax
80107a99:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir)); // switch to process's address space
80107a9c:	8b 46 04             	mov    0x4(%esi),%eax
80107a9f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107aa4:	0f 22 d8             	mov    %eax,%cr3
}
80107aa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107aaa:	5b                   	pop    %ebx
80107aab:	5e                   	pop    %esi
80107aac:	5f                   	pop    %edi
80107aad:	5d                   	pop    %ebp
  popcli();
80107aae:	e9 1d d8 ff ff       	jmp    801052d0 <popcli>
    panic("switchuvm: no process");
80107ab3:	83 ec 0c             	sub    $0xc,%esp
80107ab6:	68 e2 8e 10 80       	push   $0x80108ee2
80107abb:	e8 d0 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107ac0:	83 ec 0c             	sub    $0xc,%esp
80107ac3:	68 0d 8f 10 80       	push   $0x80108f0d
80107ac8:	e8 c3 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107acd:	83 ec 0c             	sub    $0xc,%esp
80107ad0:	68 f8 8e 10 80       	push   $0x80108ef8
80107ad5:	e8 b6 88 ff ff       	call   80100390 <panic>
80107ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ae0 <inituvm>:
{
80107ae0:	f3 0f 1e fb          	endbr32 
80107ae4:	55                   	push   %ebp
80107ae5:	89 e5                	mov    %esp,%ebp
80107ae7:	57                   	push   %edi
80107ae8:	56                   	push   %esi
80107ae9:	53                   	push   %ebx
80107aea:	83 ec 1c             	sub    $0x1c,%esp
80107aed:	8b 45 0c             	mov    0xc(%ebp),%eax
80107af0:	8b 75 10             	mov    0x10(%ebp),%esi
80107af3:	8b 7d 08             	mov    0x8(%ebp),%edi
80107af6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (sz >= PGSIZE)
80107af9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107aff:	77 55                	ja     80107b56 <inituvm+0x76>
  mem = kalloc();
80107b01:	e8 1a b7 ff ff       	call   80103220 <kalloc>
  memset(mem, 0, PGSIZE);
80107b06:	83 ec 04             	sub    $0x4,%esp
80107b09:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107b0e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107b10:	6a 00                	push   $0x0
80107b12:	50                   	push   %eax
80107b13:	e8 78 d9 ff ff       	call   80105490 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107b18:	58                   	pop    %eax
80107b19:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107b1f:	5a                   	pop    %edx
80107b20:	6a 06                	push   $0x6
80107b22:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b27:	31 d2                	xor    %edx,%edx
80107b29:	50                   	push   %eax
80107b2a:	89 f8                	mov    %edi,%eax
80107b2c:	e8 0f fd ff ff       	call   80107840 <mappages>
  page_insert(pgdir, 0);
80107b31:	59                   	pop    %ecx
80107b32:	58                   	pop    %eax
80107b33:	6a 00                	push   $0x0
80107b35:	57                   	push   %edi
80107b36:	e8 15 af ff ff       	call   80102a50 <page_insert>
  memmove(mem, init, sz);
80107b3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b3e:	89 75 10             	mov    %esi,0x10(%ebp)
80107b41:	83 c4 10             	add    $0x10,%esp
80107b44:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107b47:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107b4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b4d:	5b                   	pop    %ebx
80107b4e:	5e                   	pop    %esi
80107b4f:	5f                   	pop    %edi
80107b50:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107b51:	e9 da d9 ff ff       	jmp    80105530 <memmove>
    panic("inituvm: more than a page");
80107b56:	83 ec 0c             	sub    $0xc,%esp
80107b59:	68 21 8f 10 80       	push   $0x80108f21
80107b5e:	e8 2d 88 ff ff       	call   80100390 <panic>
80107b63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b70 <loaduvm>:
{
80107b70:	f3 0f 1e fb          	endbr32 
80107b74:	55                   	push   %ebp
80107b75:	89 e5                	mov    %esp,%ebp
80107b77:	57                   	push   %edi
80107b78:	56                   	push   %esi
80107b79:	53                   	push   %ebx
80107b7a:	83 ec 1c             	sub    $0x1c,%esp
80107b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b80:	8b 75 18             	mov    0x18(%ebp),%esi
  if ((uint)addr % PGSIZE != 0)
80107b83:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107b88:	0f 85 99 00 00 00    	jne    80107c27 <loaduvm+0xb7>
  for (i = 0; i < sz; i += PGSIZE)
80107b8e:	01 f0                	add    %esi,%eax
80107b90:	89 f3                	mov    %esi,%ebx
80107b92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107b95:	8b 45 14             	mov    0x14(%ebp),%eax
80107b98:	01 f0                	add    %esi,%eax
80107b9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for (i = 0; i < sz; i += PGSIZE)
80107b9d:	85 f6                	test   %esi,%esi
80107b9f:	75 15                	jne    80107bb6 <loaduvm+0x46>
80107ba1:	eb 6d                	jmp    80107c10 <loaduvm+0xa0>
80107ba3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ba7:	90                   	nop
80107ba8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107bae:	89 f0                	mov    %esi,%eax
80107bb0:	29 d8                	sub    %ebx,%eax
80107bb2:	39 c6                	cmp    %eax,%esi
80107bb4:	76 5a                	jbe    80107c10 <loaduvm+0xa0>
    if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
80107bb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107bb9:	83 ec 04             	sub    $0x4,%esp
80107bbc:	6a 00                	push   $0x0
80107bbe:	29 d8                	sub    %ebx,%eax
80107bc0:	50                   	push   %eax
80107bc1:	ff 75 08             	pushl  0x8(%ebp)
80107bc4:	e8 e7 fb ff ff       	call   801077b0 <walkpgdir>
80107bc9:	83 c4 10             	add    $0x10,%esp
80107bcc:	85 c0                	test   %eax,%eax
80107bce:	74 4a                	je     80107c1a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107bd0:	8b 00                	mov    (%eax),%eax
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107bd2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if (sz - i < PGSIZE)
80107bd5:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107bda:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if (sz - i < PGSIZE)
80107bdf:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107be5:	0f 46 fb             	cmovbe %ebx,%edi
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107be8:	29 d9                	sub    %ebx,%ecx
80107bea:	05 00 00 00 80       	add    $0x80000000,%eax
80107bef:	57                   	push   %edi
80107bf0:	51                   	push   %ecx
80107bf1:	50                   	push   %eax
80107bf2:	ff 75 10             	pushl  0x10(%ebp)
80107bf5:	e8 66 9e ff ff       	call   80101a60 <readi>
80107bfa:	83 c4 10             	add    $0x10,%esp
80107bfd:	39 f8                	cmp    %edi,%eax
80107bff:	74 a7                	je     80107ba8 <loaduvm+0x38>
}
80107c01:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107c04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c09:	5b                   	pop    %ebx
80107c0a:	5e                   	pop    %esi
80107c0b:	5f                   	pop    %edi
80107c0c:	5d                   	pop    %ebp
80107c0d:	c3                   	ret    
80107c0e:	66 90                	xchg   %ax,%ax
80107c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c13:	31 c0                	xor    %eax,%eax
}
80107c15:	5b                   	pop    %ebx
80107c16:	5e                   	pop    %esi
80107c17:	5f                   	pop    %edi
80107c18:	5d                   	pop    %ebp
80107c19:	c3                   	ret    
      panic("loaduvm: address should exist");
80107c1a:	83 ec 0c             	sub    $0xc,%esp
80107c1d:	68 3b 8f 10 80       	push   $0x80108f3b
80107c22:	e8 69 87 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107c27:	83 ec 0c             	sub    $0xc,%esp
80107c2a:	68 c4 8f 10 80       	push   $0x80108fc4
80107c2f:	e8 5c 87 ff ff       	call   80100390 <panic>
80107c34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c3f:	90                   	nop

80107c40 <allocuvm>:
{
80107c40:	f3 0f 1e fb          	endbr32 
80107c44:	55                   	push   %ebp
80107c45:	89 e5                	mov    %esp,%ebp
80107c47:	57                   	push   %edi
80107c48:	56                   	push   %esi
80107c49:	53                   	push   %ebx
80107c4a:	83 ec 1c             	sub    $0x1c,%esp
  if (newsz >= KERNBASE)
80107c4d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107c50:	8b 7d 08             	mov    0x8(%ebp),%edi
  if (newsz >= KERNBASE)
80107c53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c56:	85 c0                	test   %eax,%eax
80107c58:	0f 88 c2 00 00 00    	js     80107d20 <allocuvm+0xe0>
  if (newsz < oldsz)
80107c5e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (newsz < oldsz)
80107c64:	0f 82 a6 00 00 00    	jb     80107d10 <allocuvm+0xd0>
  a = PGROUNDUP(oldsz);
80107c6a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107c70:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a < newsz; a += PGSIZE)
80107c76:	39 75 10             	cmp    %esi,0x10(%ebp)
80107c79:	77 51                	ja     80107ccc <allocuvm+0x8c>
80107c7b:	e9 93 00 00 00       	jmp    80107d13 <allocuvm+0xd3>
    memset(mem, 0, PGSIZE);
80107c80:	83 ec 04             	sub    $0x4,%esp
80107c83:	68 00 10 00 00       	push   $0x1000
80107c88:	6a 00                	push   $0x0
80107c8a:	50                   	push   %eax
80107c8b:	e8 00 d8 ff ff       	call   80105490 <memset>
    if (mappages(pgdir, (char *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
80107c90:	58                   	pop    %eax
80107c91:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c97:	5a                   	pop    %edx
80107c98:	6a 06                	push   $0x6
80107c9a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c9f:	89 f2                	mov    %esi,%edx
80107ca1:	50                   	push   %eax
80107ca2:	89 f8                	mov    %edi,%eax
80107ca4:	e8 97 fb ff ff       	call   80107840 <mappages>
80107ca9:	83 c4 10             	add    $0x10,%esp
80107cac:	85 c0                	test   %eax,%eax
80107cae:	0f 88 84 00 00 00    	js     80107d38 <allocuvm+0xf8>
    page_insert(pgdir, a);
80107cb4:	83 ec 08             	sub    $0x8,%esp
80107cb7:	56                   	push   %esi
  for (; a < newsz; a += PGSIZE)
80107cb8:	81 c6 00 10 00 00    	add    $0x1000,%esi
    page_insert(pgdir, a);
80107cbe:	57                   	push   %edi
80107cbf:	e8 8c ad ff ff       	call   80102a50 <page_insert>
  for (; a < newsz; a += PGSIZE)
80107cc4:	83 c4 10             	add    $0x10,%esp
80107cc7:	39 75 10             	cmp    %esi,0x10(%ebp)
80107cca:	76 47                	jbe    80107d13 <allocuvm+0xd3>
    mem = kalloc();
80107ccc:	e8 4f b5 ff ff       	call   80103220 <kalloc>
80107cd1:	89 c3                	mov    %eax,%ebx
    if (mem == 0)
80107cd3:	85 c0                	test   %eax,%eax
80107cd5:	75 a9                	jne    80107c80 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107cd7:	83 ec 0c             	sub    $0xc,%esp
80107cda:	68 59 8f 10 80       	push   $0x80108f59
80107cdf:	e8 cc 89 ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz)
80107ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ce7:	83 c4 10             	add    $0x10,%esp
80107cea:	39 45 10             	cmp    %eax,0x10(%ebp)
80107ced:	74 31                	je     80107d20 <allocuvm+0xe0>
80107cef:	8b 55 10             	mov    0x10(%ebp),%edx
80107cf2:	89 c1                	mov    %eax,%ecx
80107cf4:	89 f8                	mov    %edi,%eax
80107cf6:	e8 d5 fb ff ff       	call   801078d0 <deallocuvm.part.0>
      return 0;
80107cfb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d08:	5b                   	pop    %ebx
80107d09:	5e                   	pop    %esi
80107d0a:	5f                   	pop    %edi
80107d0b:	5d                   	pop    %ebp
80107d0c:	c3                   	ret    
80107d0d:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80107d10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107d13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d19:	5b                   	pop    %ebx
80107d1a:	5e                   	pop    %esi
80107d1b:	5f                   	pop    %edi
80107d1c:	5d                   	pop    %ebp
80107d1d:	c3                   	ret    
80107d1e:	66 90                	xchg   %ax,%ax
    return 0;
80107d20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107d27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d2d:	5b                   	pop    %ebx
80107d2e:	5e                   	pop    %esi
80107d2f:	5f                   	pop    %edi
80107d30:	5d                   	pop    %ebp
80107d31:	c3                   	ret    
80107d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107d38:	83 ec 0c             	sub    $0xc,%esp
80107d3b:	68 71 8f 10 80       	push   $0x80108f71
80107d40:	e8 6b 89 ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz)
80107d45:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d48:	83 c4 10             	add    $0x10,%esp
80107d4b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107d4e:	74 0c                	je     80107d5c <allocuvm+0x11c>
80107d50:	8b 55 10             	mov    0x10(%ebp),%edx
80107d53:	89 c1                	mov    %eax,%ecx
80107d55:	89 f8                	mov    %edi,%eax
80107d57:	e8 74 fb ff ff       	call   801078d0 <deallocuvm.part.0>
      kfree(mem);
80107d5c:	83 ec 0c             	sub    $0xc,%esp
80107d5f:	53                   	push   %ebx
80107d60:	e8 1b a8 ff ff       	call   80102580 <kfree>
      return 0;
80107d65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107d6c:	83 c4 10             	add    $0x10,%esp
}
80107d6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d75:	5b                   	pop    %ebx
80107d76:	5e                   	pop    %esi
80107d77:	5f                   	pop    %edi
80107d78:	5d                   	pop    %ebp
80107d79:	c3                   	ret    
80107d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107d80 <deallocuvm>:
{
80107d80:	f3 0f 1e fb          	endbr32 
80107d84:	55                   	push   %ebp
80107d85:	89 e5                	mov    %esp,%ebp
80107d87:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  if (newsz >= oldsz)
80107d90:	39 d1                	cmp    %edx,%ecx
80107d92:	73 0c                	jae    80107da0 <deallocuvm+0x20>
}
80107d94:	5d                   	pop    %ebp
80107d95:	e9 36 fb ff ff       	jmp    801078d0 <deallocuvm.part.0>
80107d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107da0:	89 d0                	mov    %edx,%eax
80107da2:	5d                   	pop    %ebp
80107da3:	c3                   	ret    
80107da4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107daf:	90                   	nop

80107db0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t *pgdir)
{
80107db0:	f3 0f 1e fb          	endbr32 
80107db4:	55                   	push   %ebp
80107db5:	89 e5                	mov    %esp,%ebp
80107db7:	57                   	push   %edi
80107db8:	56                   	push   %esi
80107db9:	53                   	push   %ebx
80107dba:	83 ec 0c             	sub    $0xc,%esp
80107dbd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if (pgdir == 0)
80107dc0:	85 f6                	test   %esi,%esi
80107dc2:	74 55                	je     80107e19 <freevm+0x69>
  if (newsz >= oldsz)
80107dc4:	31 c9                	xor    %ecx,%ecx
80107dc6:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107dcb:	89 f0                	mov    %esi,%eax
80107dcd:	89 f3                	mov    %esi,%ebx
80107dcf:	e8 fc fa ff ff       	call   801078d0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for (i = 0; i < NPDENTRIES; i++)
80107dd4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107dda:	eb 0b                	jmp    80107de7 <freevm+0x37>
80107ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107de0:	83 c3 04             	add    $0x4,%ebx
80107de3:	39 df                	cmp    %ebx,%edi
80107de5:	74 23                	je     80107e0a <freevm+0x5a>
  {
    if (pgdir[i] & PTE_P)
80107de7:	8b 03                	mov    (%ebx),%eax
80107de9:	a8 01                	test   $0x1,%al
80107deb:	74 f3                	je     80107de0 <freevm+0x30>
    {
      char *v = P2V(PTE_ADDR(pgdir[i]));
80107ded:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107df2:	83 ec 0c             	sub    $0xc,%esp
80107df5:	83 c3 04             	add    $0x4,%ebx
      char *v = P2V(PTE_ADDR(pgdir[i]));
80107df8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107dfd:	50                   	push   %eax
80107dfe:	e8 7d a7 ff ff       	call   80102580 <kfree>
80107e03:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < NPDENTRIES; i++)
80107e06:	39 df                	cmp    %ebx,%edi
80107e08:	75 dd                	jne    80107de7 <freevm+0x37>
    }
  }
  kfree((char *)pgdir);
80107e0a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107e0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e10:	5b                   	pop    %ebx
80107e11:	5e                   	pop    %esi
80107e12:	5f                   	pop    %edi
80107e13:	5d                   	pop    %ebp
  kfree((char *)pgdir);
80107e14:	e9 67 a7 ff ff       	jmp    80102580 <kfree>
    panic("freevm: no pgdir");
80107e19:	83 ec 0c             	sub    $0xc,%esp
80107e1c:	68 8d 8f 10 80       	push   $0x80108f8d
80107e21:	e8 6a 85 ff ff       	call   80100390 <panic>
80107e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e2d:	8d 76 00             	lea    0x0(%esi),%esi

80107e30 <setupkvm>:
{
80107e30:	f3 0f 1e fb          	endbr32 
80107e34:	55                   	push   %ebp
80107e35:	89 e5                	mov    %esp,%ebp
80107e37:	56                   	push   %esi
80107e38:	53                   	push   %ebx
  if ((pgdir = (pde_t *)kalloc()) == 0)
80107e39:	e8 e2 b3 ff ff       	call   80103220 <kalloc>
80107e3e:	89 c6                	mov    %eax,%esi
80107e40:	85 c0                	test   %eax,%eax
80107e42:	74 42                	je     80107e86 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107e44:	83 ec 04             	sub    $0x4,%esp
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e47:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107e4c:	68 00 10 00 00       	push   $0x1000
80107e51:	6a 00                	push   $0x0
80107e53:	50                   	push   %eax
80107e54:	e8 37 d6 ff ff       	call   80105490 <memset>
80107e59:	83 c4 10             	add    $0x10,%esp
                 (uint)k->phys_start, k->perm) < 0)
80107e5c:	8b 43 04             	mov    0x4(%ebx),%eax
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107e5f:	83 ec 08             	sub    $0x8,%esp
80107e62:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107e65:	ff 73 0c             	pushl  0xc(%ebx)
80107e68:	8b 13                	mov    (%ebx),%edx
80107e6a:	50                   	push   %eax
80107e6b:	29 c1                	sub    %eax,%ecx
80107e6d:	89 f0                	mov    %esi,%eax
80107e6f:	e8 cc f9 ff ff       	call   80107840 <mappages>
80107e74:	83 c4 10             	add    $0x10,%esp
80107e77:	85 c0                	test   %eax,%eax
80107e79:	78 15                	js     80107e90 <setupkvm+0x60>
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e7b:	83 c3 10             	add    $0x10,%ebx
80107e7e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107e84:	75 d6                	jne    80107e5c <setupkvm+0x2c>
}
80107e86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e89:	89 f0                	mov    %esi,%eax
80107e8b:	5b                   	pop    %ebx
80107e8c:	5e                   	pop    %esi
80107e8d:	5d                   	pop    %ebp
80107e8e:	c3                   	ret    
80107e8f:	90                   	nop
      freevm(pgdir);
80107e90:	83 ec 0c             	sub    $0xc,%esp
80107e93:	56                   	push   %esi
      return 0;
80107e94:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107e96:	e8 15 ff ff ff       	call   80107db0 <freevm>
      return 0;
80107e9b:	83 c4 10             	add    $0x10,%esp
}
80107e9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ea1:	89 f0                	mov    %esi,%eax
80107ea3:	5b                   	pop    %ebx
80107ea4:	5e                   	pop    %esi
80107ea5:	5d                   	pop    %ebp
80107ea6:	c3                   	ret    
80107ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eae:	66 90                	xchg   %ax,%ax

80107eb0 <kvmalloc>:
{
80107eb0:	f3 0f 1e fb          	endbr32 
80107eb4:	55                   	push   %ebp
80107eb5:	89 e5                	mov    %esp,%ebp
80107eb7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107eba:	e8 71 ff ff ff       	call   80107e30 <setupkvm>
80107ebf:	a3 e4 c5 11 80       	mov    %eax,0x8011c5e4
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80107ec4:	05 00 00 00 80       	add    $0x80000000,%eax
80107ec9:	0f 22 d8             	mov    %eax,%cr3
}
80107ecc:	c9                   	leave  
80107ecd:	c3                   	ret    
80107ece:	66 90                	xchg   %ax,%ax

80107ed0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva)
{
80107ed0:	f3 0f 1e fb          	endbr32 
80107ed4:	55                   	push   %ebp
80107ed5:	89 e5                	mov    %esp,%ebp
80107ed7:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107eda:	6a 00                	push   $0x0
80107edc:	ff 75 0c             	pushl  0xc(%ebp)
80107edf:	ff 75 08             	pushl  0x8(%ebp)
80107ee2:	e8 c9 f8 ff ff       	call   801077b0 <walkpgdir>
  if (pte == 0)
80107ee7:	83 c4 10             	add    $0x10,%esp
80107eea:	85 c0                	test   %eax,%eax
80107eec:	74 05                	je     80107ef3 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107eee:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107ef1:	c9                   	leave  
80107ef2:	c3                   	ret    
    panic("clearpteu");
80107ef3:	83 ec 0c             	sub    $0xc,%esp
80107ef6:	68 9e 8f 10 80       	push   $0x80108f9e
80107efb:	e8 90 84 ff ff       	call   80100390 <panic>

80107f00 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *copyuvm(pde_t *pgdir, uint sz)
{
80107f00:	f3 0f 1e fb          	endbr32 
80107f04:	55                   	push   %ebp
80107f05:	89 e5                	mov    %esp,%ebp
80107f07:	57                   	push   %edi
80107f08:	56                   	push   %esi
80107f09:	53                   	push   %ebx
80107f0a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if ((d = setupkvm()) == 0)
80107f0d:	e8 1e ff ff ff       	call   80107e30 <setupkvm>
80107f12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107f15:	85 c0                	test   %eax,%eax
80107f17:	0f 84 af 00 00 00    	je     80107fcc <copyuvm+0xcc>
    return 0;
  for (i = 0; i < sz; i += PGSIZE)
80107f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107f20:	85 c9                	test   %ecx,%ecx
80107f22:	0f 84 a4 00 00 00    	je     80107fcc <copyuvm+0xcc>
80107f28:	31 db                	xor    %ebx,%ebx
80107f2a:	eb 55                	jmp    80107f81 <copyuvm+0x81>
80107f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //   panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char *)P2V(pa), PGSIZE);
80107f30:	83 ec 04             	sub    $0x4,%esp
80107f33:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107f39:	68 00 10 00 00       	push   $0x1000
80107f3e:	57                   	push   %edi
80107f3f:	50                   	push   %eax
80107f40:	e8 eb d5 ff ff       	call   80105530 <memmove>
    if (mappages(d, (void *)i, PGSIZE, V2P(mem), flags) < 0)
80107f45:	58                   	pop    %eax
80107f46:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107f4c:	5a                   	pop    %edx
80107f4d:	ff 75 e0             	pushl  -0x20(%ebp)
80107f50:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f55:	89 da                	mov    %ebx,%edx
80107f57:	50                   	push   %eax
80107f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f5b:	e8 e0 f8 ff ff       	call   80107840 <mappages>
80107f60:	83 c4 10             	add    $0x10,%esp
80107f63:	85 c0                	test   %eax,%eax
80107f65:	78 79                	js     80107fe0 <copyuvm+0xe0>
    {
      kfree(mem);
      goto bad;
    }
    page_insert(d, i);
80107f67:	83 ec 08             	sub    $0x8,%esp
80107f6a:	53                   	push   %ebx
  for (i = 0; i < sz; i += PGSIZE)
80107f6b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    page_insert(d, i);
80107f71:	ff 75 e4             	pushl  -0x1c(%ebp)
80107f74:	e8 d7 aa ff ff       	call   80102a50 <page_insert>
  for (i = 0; i < sz; i += PGSIZE)
80107f79:	83 c4 10             	add    $0x10,%esp
80107f7c:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107f7f:	76 4b                	jbe    80107fcc <copyuvm+0xcc>
    if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
80107f81:	83 ec 04             	sub    $0x4,%esp
80107f84:	6a 00                	push   $0x0
80107f86:	53                   	push   %ebx
80107f87:	ff 75 08             	pushl  0x8(%ebp)
80107f8a:	e8 21 f8 ff ff       	call   801077b0 <walkpgdir>
80107f8f:	83 c4 10             	add    $0x10,%esp
80107f92:	85 c0                	test   %eax,%eax
80107f94:	74 58                	je     80107fee <copyuvm+0xee>
    pa = PTE_ADDR(*pte);
80107f96:	8b 00                	mov    (%eax),%eax
80107f98:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107f9a:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    pa = PTE_ADDR(*pte);
80107fa2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if ((mem = kalloc()) == 0)
80107fa8:	e8 73 b2 ff ff       	call   80103220 <kalloc>
80107fad:	89 c6                	mov    %eax,%esi
80107faf:	85 c0                	test   %eax,%eax
80107fb1:	0f 85 79 ff ff ff    	jne    80107f30 <copyuvm+0x30>
  }
  // page insert in LRU linked list
  return d;

bad:
  freevm(d);
80107fb7:	83 ec 0c             	sub    $0xc,%esp
80107fba:	ff 75 e4             	pushl  -0x1c(%ebp)
80107fbd:	e8 ee fd ff ff       	call   80107db0 <freevm>
  return 0;
80107fc2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107fc9:	83 c4 10             	add    $0x10,%esp
}
80107fcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107fcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fd2:	5b                   	pop    %ebx
80107fd3:	5e                   	pop    %esi
80107fd4:	5f                   	pop    %edi
80107fd5:	5d                   	pop    %ebp
80107fd6:	c3                   	ret    
80107fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fde:	66 90                	xchg   %ax,%ax
      kfree(mem);
80107fe0:	83 ec 0c             	sub    $0xc,%esp
80107fe3:	56                   	push   %esi
80107fe4:	e8 97 a5 ff ff       	call   80102580 <kfree>
      goto bad;
80107fe9:	83 c4 10             	add    $0x10,%esp
80107fec:	eb c9                	jmp    80107fb7 <copyuvm+0xb7>
      panic("copyuvm: pte should exist");
80107fee:	83 ec 0c             	sub    $0xc,%esp
80107ff1:	68 a8 8f 10 80       	push   $0x80108fa8
80107ff6:	e8 95 83 ff ff       	call   80100390 <panic>
80107ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107fff:	90                   	nop

80108000 <uva2ka>:

// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva)
{
80108000:	f3 0f 1e fb          	endbr32 
80108004:	55                   	push   %ebp
80108005:	89 e5                	mov    %esp,%ebp
80108007:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010800a:	6a 00                	push   $0x0
8010800c:	ff 75 0c             	pushl  0xc(%ebp)
8010800f:	ff 75 08             	pushl  0x8(%ebp)
80108012:	e8 99 f7 ff ff       	call   801077b0 <walkpgdir>
  if ((*pte & PTE_P) == 0)
    return 0;
  if ((*pte & PTE_U) == 0)
80108017:	83 c4 10             	add    $0x10,%esp
  if ((*pte & PTE_P) == 0)
8010801a:	8b 00                	mov    (%eax),%eax
    return 0;
  return (char *)P2V(PTE_ADDR(*pte));
}
8010801c:	c9                   	leave  
  if ((*pte & PTE_U) == 0)
8010801d:	89 c2                	mov    %eax,%edx
  return (char *)P2V(PTE_ADDR(*pte));
8010801f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if ((*pte & PTE_U) == 0)
80108024:	83 e2 05             	and    $0x5,%edx
  return (char *)P2V(PTE_ADDR(*pte));
80108027:	05 00 00 00 80       	add    $0x80000000,%eax
8010802c:	83 fa 05             	cmp    $0x5,%edx
8010802f:	ba 00 00 00 00       	mov    $0x0,%edx
80108034:	0f 45 c2             	cmovne %edx,%eax
}
80108037:	c3                   	ret    
80108038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010803f:	90                   	nop

80108040 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108040:	f3 0f 1e fb          	endbr32 
80108044:	55                   	push   %ebp
80108045:	89 e5                	mov    %esp,%ebp
80108047:	57                   	push   %edi
80108048:	56                   	push   %esi
80108049:	53                   	push   %ebx
8010804a:	83 ec 0c             	sub    $0xc,%esp
8010804d:	8b 75 14             	mov    0x14(%ebp),%esi
80108050:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char *)p;
  while (len > 0)
80108053:	85 f6                	test   %esi,%esi
80108055:	75 3c                	jne    80108093 <copyout+0x53>
80108057:	eb 67                	jmp    801080c0 <copyout+0x80>
80108059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char *)va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108060:	8b 55 0c             	mov    0xc(%ebp),%edx
80108063:	89 fb                	mov    %edi,%ebx
80108065:	29 d3                	sub    %edx,%ebx
80108067:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if (n > len)
8010806d:	39 f3                	cmp    %esi,%ebx
8010806f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108072:	29 fa                	sub    %edi,%edx
80108074:	83 ec 04             	sub    $0x4,%esp
80108077:	01 c2                	add    %eax,%edx
80108079:	53                   	push   %ebx
8010807a:	ff 75 10             	pushl  0x10(%ebp)
8010807d:	52                   	push   %edx
8010807e:	e8 ad d4 ff ff       	call   80105530 <memmove>
    len -= n;
    buf += n;
80108083:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80108086:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while (len > 0)
8010808c:	83 c4 10             	add    $0x10,%esp
8010808f:	29 de                	sub    %ebx,%esi
80108091:	74 2d                	je     801080c0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80108093:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
80108095:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108098:	89 55 0c             	mov    %edx,0xc(%ebp)
8010809b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
801080a1:	57                   	push   %edi
801080a2:	ff 75 08             	pushl  0x8(%ebp)
801080a5:	e8 56 ff ff ff       	call   80108000 <uva2ka>
    if (pa0 == 0)
801080aa:	83 c4 10             	add    $0x10,%esp
801080ad:	85 c0                	test   %eax,%eax
801080af:	75 af                	jne    80108060 <copyout+0x20>
  }
  return 0;
}
801080b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801080b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801080b9:	5b                   	pop    %ebx
801080ba:	5e                   	pop    %esi
801080bb:	5f                   	pop    %edi
801080bc:	5d                   	pop    %ebp
801080bd:	c3                   	ret    
801080be:	66 90                	xchg   %ax,%ax
801080c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801080c3:	31 c0                	xor    %eax,%eax
}
801080c5:	5b                   	pop    %ebx
801080c6:	5e                   	pop    %esi
801080c7:	5f                   	pop    %edi
801080c8:	5d                   	pop    %ebp
801080c9:	c3                   	ret    
