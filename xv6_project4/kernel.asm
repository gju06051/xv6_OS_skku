
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
8010002d:	b8 c0 37 10 80       	mov    $0x801037c0,%eax
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
80100050:	68 40 7a 10 80       	push   $0x80107a40
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 01 4b 00 00       	call   80104b60 <initlock>
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
80100092:	68 47 7a 10 80       	push   $0x80107a47
80100097:	50                   	push   %eax
80100098:	e8 83 49 00 00       	call   80104a20 <initsleeplock>
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
801000e8:	e8 f3 4b 00 00       	call   80104ce0 <acquire>
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
80100162:	e8 39 4c 00 00       	call   80104da0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 48 00 00       	call   80104a60 <acquiresleep>
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
801001a3:	68 4e 7a 10 80       	push   $0x80107a4e
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
801001c2:	e8 39 49 00 00       	call   80104b00 <holdingsleep>
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
801001e0:	68 5f 7a 10 80       	push   $0x80107a5f
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
80100203:	e8 f8 48 00 00       	call   80104b00 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 a8 48 00 00       	call   80104ac0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 bc 4a 00 00       	call   80104ce0 <acquire>
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
80100270:	e9 2b 4b 00 00       	jmp    80104da0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 66 7a 10 80       	push   $0x80107a66
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
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
801002b1:	e8 2a 4a 00 00       	call   80104ce0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 b6 43 00 00       	call   801046a0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 f1 3d 00 00       	call   801040f0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 8d 4a 00 00       	call   80104da0 <release>
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
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 36 4a 00 00       	call   80104da0 <release>
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
      if(n < target){
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
801003ad:	e8 6e 2c 00 00       	call   80103020 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 6d 7a 10 80       	push   $0x80107a6d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 cb 86 10 80 	movl   $0x801086cb,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 9f 47 00 00       	call   80104b80 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 81 7a 10 80       	push   $0x80107a81
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 91 61 00 00       	call   801065c0 <uartputc>
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
  pos = inb(CRTPORT+1) << 8;
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
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
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
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 a6 60 00 00       	call   801065c0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 9a 60 00 00       	call   801065c0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 8e 60 00 00       	call   801065c0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 2a 49 00 00       	call   80104e90 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 75 48 00 00       	call   80104df0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 85 7a 10 80       	push   $0x80107a85
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
  if(sign && (sign = xx < 0))
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
801005c9:	0f b6 92 b0 7a 10 80 	movzbl -0x7fef8550(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
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

int
consolewrite(struct inode *ip, char *buf, int n)
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
8010065f:	e8 7c 46 00 00       	call   80104ce0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 04 47 00 00       	call   80104da0 <release>
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
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
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
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
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
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 98 7a 10 80       	mov    $0x80107a98,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
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
801007bd:	e8 1e 45 00 00       	call   80104ce0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 73 45 00 00       	call   80104da0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 9f 7a 10 80       	push   $0x80107a9f
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
80100877:	e8 64 44 00 00       	call   80104ce0 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
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
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
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
      while(input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
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
801009cf:	e8 cc 43 00 00       	call   80104da0 <release>
  if(doprocdump) {
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
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 4c 3f 00 00       	jmp    80104950 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 3b 3e 00 00       	call   80104860 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 a8 7a 10 80       	push   $0x80107aa8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 17 41 00 00       	call   80104b60 <initlock>

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
80100a90:	e8 5b 36 00 00       	call   801040f0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 10 2a 00 00       	call   801034b0 <begin_op>

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
80100ae3:	e8 38 2a 00 00       	call   80103520 <end_op>
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
80100b0c:	e8 7f 6c 00 00       	call   80107790 <setupkvm>
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
80100b73:	e8 28 6a 00 00       	call   801075a0 <allocuvm>
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
80100ba9:	e8 22 69 00 00       	call   801074d0 <loaduvm>
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
80100beb:	e8 20 6b 00 00       	call   80107710 <freevm>
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
80100c21:	e8 fa 28 00 00       	call   80103520 <end_op>
  if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 69 69 00 00       	call   801075a0 <allocuvm>
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
80100c53:	e8 d8 6b 00 00       	call   80107830 <clearpteu>
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
80100ca3:	e8 48 43 00 00       	call   80104ff0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 35 43 00 00       	call   80104ff0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 e4 6c 00 00       	call   801079b0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 2a 6a 00 00       	call   80107710 <freevm>
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
80100d33:	e8 78 6c 00 00       	call   801079b0 <copyout>
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
80100d71:	e8 3a 42 00 00       	call   80104fb0 <safestrcpy>
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
80100d9d:	e8 8e 65 00 00       	call   80107330 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 66 69 00 00       	call   80107710 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 67 27 00 00       	call   80103520 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 c1 7a 10 80       	push   $0x80107ac1
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
80100dea:	68 cd 7a 10 80       	push   $0x80107acd
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 67 3d 00 00       	call   80104b60 <initlock>
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
80100e15:	e8 c6 3e 00 00       	call   80104ce0 <acquire>
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
80100e41:	e8 5a 3f 00 00       	call   80104da0 <release>
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
80100e5a:	e8 41 3f 00 00       	call   80104da0 <release>
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
80100e83:	e8 58 3e 00 00       	call   80104ce0 <acquire>
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
80100ea0:	e8 fb 3e 00 00       	call   80104da0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 d4 7a 10 80       	push   $0x80107ad4
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
80100ed5:	e8 06 3e 00 00       	call   80104ce0 <acquire>
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
80100f10:	e8 8b 3e 00 00       	call   80104da0 <release>

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
80100f3e:	e9 5d 3e 00 00       	jmp    80104da0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 63 25 00 00       	call   801034b0 <begin_op>
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
80100f62:	e9 b9 25 00 00       	jmp    80103520 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 12 2d 00 00       	call   80103c90 <pipeclose>
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
80100f8c:	68 dc 7a 10 80       	push   $0x80107adc
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
80101065:	e9 c6 2d 00 00       	jmp    80103e30 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 e6 7a 10 80       	push   $0x80107ae6
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
801010f1:	e8 2a 24 00 00       	call   80103520 <end_op>

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
8010111a:	e8 91 23 00 00       	call   801034b0 <begin_op>
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
80101151:	e8 ca 23 00 00       	call   80103520 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 ef 7a 10 80       	push   $0x80107aef
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
80101191:	e9 9a 2b 00 00       	jmp    80103d30 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 f5 7a 10 80       	push   $0x80107af5
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
80101254:	68 ff 7a 10 80       	push   $0x80107aff
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
8010126d:	e8 1e 24 00 00       	call   80103690 <log_write>
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
80101295:	e8 56 3b 00 00       	call   80104df0 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 ee 23 00 00       	call   80103690 <log_write>
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
801012da:	e8 01 3a 00 00       	call   80104ce0 <acquire>
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
80101347:	e8 54 3a 00 00       	call   80104da0 <release>

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
80101375:	e8 26 3a 00 00       	call   80104da0 <release>
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
801013a2:	68 15 7b 10 80       	push   $0x80107b15
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
80101425:	e8 66 22 00 00       	call   80103690 <log_write>
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
8010146b:	68 25 7b 10 80       	push   $0x80107b25
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
801014a5:	e8 e6 39 00 00       	call   80104e90 <memmove>
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
8010151a:	e8 71 21 00 00       	call   80103690 <log_write>
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
80101534:	68 38 7b 10 80       	push   $0x80107b38
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
80101550:	68 4b 7b 10 80       	push   $0x80107b4b
80101555:	68 00 1a 11 80       	push   $0x80111a00
8010155a:	e8 01 36 00 00       	call   80104b60 <initlock>
  for (i = 0; i < NINODE; i++)
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 52 7b 10 80       	push   $0x80107b52
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 a4 34 00 00       	call   80104a20 <initsleeplock>
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
801015c1:	68 f0 7b 10 80       	push   $0x80107bf0
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
8010165e:	e8 8d 37 00 00       	call   80104df0 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp); // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 1b 20 00 00       	call   80103690 <log_write>
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
80101693:	68 58 7b 10 80       	push   $0x80107b58
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
80101705:	e8 86 37 00 00       	call   80104e90 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 7e 1f 00 00       	call   80103690 <log_write>
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
80101743:	e8 98 35 00 00       	call   80104ce0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101753:	e8 48 36 00 00       	call   80104da0 <release>
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
80101786:	e8 d5 32 00 00       	call   80104a60 <acquiresleep>
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
801017f8:	e8 93 36 00 00       	call   80104e90 <memmove>
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
8010181d:	68 70 7b 10 80       	push   $0x80107b70
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 6a 7b 10 80       	push   $0x80107b6a
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
80101857:	e8 a4 32 00 00       	call   80104b00 <holdingsleep>
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
80101873:	e9 48 32 00 00       	jmp    80104ac0 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 7f 7b 10 80       	push   $0x80107b7f
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
801018a4:	e8 b7 31 00 00       	call   80104a60 <acquiresleep>
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
801018be:	e8 fd 31 00 00       	call   80104ac0 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801018ca:	e8 11 34 00 00       	call   80104ce0 <acquire>
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
801018e4:	e9 b7 34 00 00       	jmp    80104da0 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 00 1a 11 80       	push   $0x80111a00
801018f8:	e8 e3 33 00 00       	call   80104ce0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101907:	e8 94 34 00 00       	call   80104da0 <release>
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
80101b07:	e8 84 33 00 00       	call   80104e90 <memmove>
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
80101c03:	e8 88 32 00 00       	call   80104e90 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 80 1a 00 00       	call   80103690 <log_write>
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
80101ca2:	e8 59 32 00 00       	call   80104f00 <strncmp>
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
80101d05:	e8 f6 31 00 00       	call   80104f00 <strncmp>
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
80101d4a:	68 99 7b 10 80       	push   $0x80107b99
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 87 7b 10 80       	push   $0x80107b87
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
80101d8a:	e8 61 23 00 00       	call   801040f0 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 00 1a 11 80       	push   $0x80111a00
80101d9c:	e8 3f 2f 00 00       	call   80104ce0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101dac:	e8 ef 2f 00 00       	call   80104da0 <release>
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
80101e17:	e8 74 30 00 00       	call   80104e90 <memmove>
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
80101ea3:	e8 e8 2f 00 00       	call   80104e90 <memmove>
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
80101fd5:	e8 76 2f 00 00       	call   80104f50 <strncpy>
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
80102013:	68 a8 7b 10 80       	push   $0x80107ba8
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 6a 84 10 80       	push   $0x8010846a
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
801020ca:	e8 c1 2d 00 00       	call   80104e90 <memmove>
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
801020ea:	68 b5 7b 10 80       	push   $0x80107bb5
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
8010215a:	e8 31 2d 00 00       	call   80104e90 <memmove>
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
80102182:	68 d2 7b 10 80       	push   $0x80107bd2
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
80102242:	68 4c 7c 10 80       	push   $0x80107c4c
80102247:	e8 44 e1 ff ff       	call   80100390 <panic>
    panic("idestart");
8010224c:	83 ec 0c             	sub    $0xc,%esp
8010224f:	68 43 7c 10 80       	push   $0x80107c43
80102254:	e8 37 e1 ff ff       	call   80100390 <panic>
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102260 <ideinit>:
{
80102260:	f3 0f 1e fb          	endbr32 
80102264:	55                   	push   %ebp
80102265:	89 e5                	mov    %esp,%ebp
80102267:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010226a:	68 5e 7c 10 80       	push   $0x80107c5e
8010226f:	68 80 b5 10 80       	push   $0x8010b580
80102274:	e8 e7 28 00 00       	call   80104b60 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102279:	58                   	pop    %eax
8010227a:	a1 60 9d 11 80       	mov    0x80119d60,%eax
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
80102302:	e8 d9 29 00 00       	call   80104ce0 <acquire>

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
8010235d:	e8 fe 24 00 00       	call   80104860 <wakeup>

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
8010237b:	e8 20 2a 00 00       	call   80104da0 <release>

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
801023a2:	e8 59 27 00 00       	call   80104b00 <holdingsleep>
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
801023dc:	e8 ff 28 00 00       	call   80104ce0 <acquire>

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
80102429:	e8 72 22 00 00       	call   801046a0 <sleep>
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
80102446:	e9 55 29 00 00       	jmp    80104da0 <release>
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
8010246a:	68 8d 7c 10 80       	push   $0x80107c8d
8010246f:	e8 1c df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	68 78 7c 10 80       	push   $0x80107c78
8010247c:	e8 0f df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102481:	83 ec 0c             	sub    $0xc,%esp
80102484:	68 62 7c 10 80       	push   $0x80107c62
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
801024c2:	0f b6 15 c0 97 11 80 	movzbl 0x801197c0,%edx
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
801024de:	68 ac 7c 10 80       	push   $0x80107cac
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
80102598:	0f 85 8c 00 00 00    	jne    8010262a <kfree+0xaa>
8010259e:	81 fb 08 c5 11 80    	cmp    $0x8011c508,%ebx
801025a4:	0f 82 bf 00 00 00    	jb     80102669 <kfree+0xe9>
801025aa:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
801025b0:	0f 87 a1 00 00 00    	ja     80102657 <kfree+0xd7>
      cprintf("physical addr is upper than PHYSTOP");
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025b6:	83 ec 04             	sub    $0x4,%esp
801025b9:	68 00 10 00 00       	push   $0x1000
801025be:	6a 01                	push   $0x1
801025c0:	53                   	push   %ebx
801025c1:	e8 2a 28 00 00       	call   80104df0 <memset>

  if (kmem.use_lock)
801025c6:	8b 15 94 36 11 80    	mov    0x80113694,%edx
801025cc:	83 c4 10             	add    $0x10,%esp
801025cf:	85 d2                	test   %edx,%edx
801025d1:	75 2d                	jne    80102600 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run *)v;
  r->next = kmem.freelist;
801025d3:	a1 98 36 11 80       	mov    0x80113698,%eax
801025d8:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  num_free_pages++;
  if (kmem.use_lock)
801025da:	a1 94 36 11 80       	mov    0x80113694,%eax
  num_free_pages++;
801025df:	83 05 a8 46 11 80 01 	addl   $0x1,0x801146a8
  kmem.freelist = r;
801025e6:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if (kmem.use_lock)
801025ec:	85 c0                	test   %eax,%eax
801025ee:	75 28                	jne    80102618 <kfree+0x98>
    release(&kmem.lock);
}
801025f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025f3:	5b                   	pop    %ebx
801025f4:	5e                   	pop    %esi
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025fe:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102600:	83 ec 0c             	sub    $0xc,%esp
80102603:	68 60 36 11 80       	push   $0x80113660
80102608:	e8 d3 26 00 00       	call   80104ce0 <acquire>
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	eb c1                	jmp    801025d3 <kfree+0x53>
80102612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102618:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
8010261f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102622:	5b                   	pop    %ebx
80102623:	5e                   	pop    %esi
80102624:	5d                   	pop    %ebp
    release(&kmem.lock);
80102625:	e9 76 27 00 00       	jmp    80104da0 <release>
      cprintf("PGROUND Need\n");
8010262a:	83 ec 0c             	sub    $0xc,%esp
8010262d:	68 f9 7c 10 80       	push   $0x80107cf9
80102632:	e8 79 e0 ff ff       	call   801006b0 <cprintf>
    if (v < end)
80102637:	83 c4 10             	add    $0x10,%esp
8010263a:	81 fb 08 c5 11 80    	cmp    $0x8011c508,%ebx
80102640:	72 27                	jb     80102669 <kfree+0xe9>
    if (V2P(v) >= PHYSTOP)
80102642:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
80102648:	77 0d                	ja     80102657 <kfree+0xd7>
    panic("kfree");
8010264a:	83 ec 0c             	sub    $0xc,%esp
8010264d:	68 07 7d 10 80       	push   $0x80107d07
80102652:	e8 39 dd ff ff       	call   80100390 <panic>
      cprintf("physical addr is upper than PHYSTOP");
80102657:	83 ec 0c             	sub    $0xc,%esp
8010265a:	68 5c 7d 10 80       	push   $0x80107d5c
8010265f:	e8 4c e0 ff ff       	call   801006b0 <cprintf>
80102664:	83 c4 10             	add    $0x10,%esp
80102667:	eb e1                	jmp    8010264a <kfree+0xca>
      cprintf("virtual addr is under end\n");
80102669:	83 ec 0c             	sub    $0xc,%esp
8010266c:	68 de 7c 10 80       	push   $0x80107cde
80102671:	e8 3a e0 ff ff       	call   801006b0 <cprintf>
80102676:	83 c4 10             	add    $0x10,%esp
80102679:	eb c7                	jmp    80102642 <kfree+0xc2>
8010267b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010267f:	90                   	nop

80102680 <freerange>:
{
80102680:	f3 0f 1e fb          	endbr32 
80102684:	55                   	push   %ebp
80102685:	89 e5                	mov    %esp,%ebp
80102687:	56                   	push   %esi
  p = (char *)PGROUNDUP((uint)vstart);
80102688:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010268b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010268e:	53                   	push   %ebx
  p = (char *)PGROUNDUP((uint)vstart);
8010268f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102695:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
8010269b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026a1:	39 de                	cmp    %ebx,%esi
801026a3:	72 1f                	jb     801026c4 <freerange+0x44>
801026a5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801026a8:	83 ec 0c             	sub    $0xc,%esp
801026ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801026b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026b7:	50                   	push   %eax
801026b8:	e8 c3 fe ff ff       	call   80102580 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	39 f3                	cmp    %esi,%ebx
801026c2:	76 e4                	jbe    801026a8 <freerange+0x28>
}
801026c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026c7:	5b                   	pop    %ebx
801026c8:	5e                   	pop    %esi
801026c9:	5d                   	pop    %ebp
801026ca:	c3                   	ret    
801026cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026cf:	90                   	nop

801026d0 <kinit1>:
{
801026d0:	f3 0f 1e fb          	endbr32 
801026d4:	55                   	push   %ebp
801026d5:	89 e5                	mov    %esp,%ebp
801026d7:	56                   	push   %esi
801026d8:	53                   	push   %ebx
801026d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  initlock(&kmem.lock, "kmem");
801026dc:	83 ec 08             	sub    $0x8,%esp
801026df:	68 0d 7d 10 80       	push   $0x80107d0d
801026e4:	68 60 36 11 80       	push   $0x80113660
801026e9:	e8 72 24 00 00       	call   80104b60 <initlock>
  bitmap[0] = 1;
801026ee:	c6 05 a0 36 11 80 01 	movb   $0x1,0x801136a0
801026f5:	83 c4 10             	add    $0x10,%esp
  for (int i = 2; i < PGSIZE; i++)
801026f8:	b8 02 00 00 00       	mov    $0x2,%eax
  kmem.use_lock = 0;
801026fd:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102704:	00 00 00 
  num_free_pages = 0;
80102707:	c7 05 a8 46 11 80 00 	movl   $0x0,0x801146a8
8010270e:	00 00 00 
  num_lru_pages = 0;
80102711:	c7 05 a0 46 11 80 00 	movl   $0x0,0x801146a0
80102718:	00 00 00 
  for (int i = 2; i < PGSIZE; i++)
8010271b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010271f:	90                   	nop
    bitmap[i] = 0;
80102720:	c6 80 a0 36 11 80 00 	movb   $0x0,-0x7feec960(%eax)
  for (int i = 2; i < PGSIZE; i++)
80102727:	83 c0 01             	add    $0x1,%eax
8010272a:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010272f:	75 ef                	jne    80102720 <kinit1+0x50>
80102731:	b8 d0 46 11 80       	mov    $0x801146d0,%eax
80102736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273d:	8d 76 00             	lea    0x0(%esi),%esi
    pages[i].use = 0;
80102740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (int i = 0; i < PHYSTOP / PGSIZE; i++)
80102746:	83 c0 14             	add    $0x14,%eax
80102749:	3d d0 96 11 80       	cmp    $0x801196d0,%eax
8010274e:	75 f0                	jne    80102740 <kinit1+0x70>
  p = (char *)PGROUNDUP((uint)vstart);
80102750:	8b 45 08             	mov    0x8(%ebp),%eax
80102753:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80102759:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
8010275f:	81 c6 00 10 00 00    	add    $0x1000,%esi
80102765:	39 f3                	cmp    %esi,%ebx
80102767:	72 23                	jb     8010278c <kinit1+0xbc>
80102769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102770:	83 ec 0c             	sub    $0xc,%esp
80102773:	8d 86 00 f0 ff ff    	lea    -0x1000(%esi),%eax
80102779:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010277f:	50                   	push   %eax
80102780:	e8 fb fd ff ff       	call   80102580 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102785:	83 c4 10             	add    $0x10,%esp
80102788:	39 f3                	cmp    %esi,%ebx
8010278a:	73 e4                	jae    80102770 <kinit1+0xa0>
}
8010278c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010278f:	5b                   	pop    %ebx
80102790:	5e                   	pop    %esi
80102791:	5d                   	pop    %ebp
80102792:	c3                   	ret    
80102793:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010279a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801027a0 <kinit2>:
{
801027a0:	f3 0f 1e fb          	endbr32 
801027a4:	55                   	push   %ebp
801027a5:	89 e5                	mov    %esp,%ebp
801027a7:	56                   	push   %esi
  p = (char *)PGROUNDUP((uint)vstart);
801027a8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027ab:	8b 75 0c             	mov    0xc(%ebp),%esi
801027ae:	53                   	push   %ebx
  p = (char *)PGROUNDUP((uint)vstart);
801027af:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027b5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801027bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027c1:	39 de                	cmp    %ebx,%esi
801027c3:	72 1f                	jb     801027e4 <kinit2+0x44>
801027c5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801027c8:	83 ec 0c             	sub    $0xc,%esp
801027cb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801027d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027d7:	50                   	push   %eax
801027d8:	e8 a3 fd ff ff       	call   80102580 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801027dd:	83 c4 10             	add    $0x10,%esp
801027e0:	39 de                	cmp    %ebx,%esi
801027e2:	73 e4                	jae    801027c8 <kinit2+0x28>
  cprintf("kinit2 finished | num_free_page : %d | num_lru_page : %d\n", num_free_pages, num_lru_pages);
801027e4:	83 ec 04             	sub    $0x4,%esp
801027e7:	ff 35 a0 46 11 80    	pushl  0x801146a0
801027ed:	ff 35 a8 46 11 80    	pushl  0x801146a8
801027f3:	68 80 7d 10 80       	push   $0x80107d80
801027f8:	e8 b3 de ff ff       	call   801006b0 <cprintf>
}
801027fd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102800:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
80102807:	00 00 00 
}
8010280a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010280d:	5b                   	pop    %ebx
8010280e:	5e                   	pop    %esi
8010280f:	5d                   	pop    %ebp
80102810:	c3                   	ret    
80102811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010281f:	90                   	nop

80102820 <lru_print>:
  if (kmem.use_lock)
    release(&kmem.lock);
  return (char *)r;
}
void lru_print(void)
{
80102820:	f3 0f 1e fb          	endbr32 
80102824:	55                   	push   %ebp
  struct page *p_page;
  pte_t *pte;
  p_page = page_lru_head;
  for (int i = 0; i < num_lru_pages; i++)
80102825:	a1 a0 46 11 80       	mov    0x801146a0,%eax
{
8010282a:	89 e5                	mov    %esp,%ebp
8010282c:	56                   	push   %esi
8010282d:	53                   	push   %ebx
  p_page = page_lru_head;
8010282e:	8b 1d a4 46 11 80    	mov    0x801146a4,%ebx
  for (int i = 0; i < num_lru_pages; i++)
80102834:	85 c0                	test   %eax,%eax
80102836:	7e 47                	jle    8010287f <lru_print+0x5f>
80102838:	31 f6                	xor    %esi,%esi
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  {
    pte = walkpgdir(p_page->pgdir, p_page->vaddr, 0);
80102840:	83 ec 04             	sub    $0x4,%esp
80102843:	6a 00                	push   $0x0
80102845:	ff 73 0c             	pushl  0xc(%ebx)
80102848:	ff 73 08             	pushl  0x8(%ebx)
8010284b:	e8 c0 48 00 00       	call   80107110 <walkpgdir>
    cprintf("lru_entry %d | pgdir : %x | vaddr : %x | use : %d | PTE_A : %x | PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, *pte & PTE_A, *pte);
80102850:	83 c4 0c             	add    $0xc,%esp
80102853:	8b 00                	mov    (%eax),%eax
80102855:	50                   	push   %eax
80102856:	83 e0 20             	and    $0x20,%eax
80102859:	50                   	push   %eax
8010285a:	ff 73 10             	pushl  0x10(%ebx)
8010285d:	ff 73 0c             	pushl  0xc(%ebx)
80102860:	ff 73 08             	pushl  0x8(%ebx)
80102863:	56                   	push   %esi
  for (int i = 0; i < num_lru_pages; i++)
80102864:	83 c6 01             	add    $0x1,%esi
    cprintf("lru_entry %d | pgdir : %x | vaddr : %x | use : %d | PTE_A : %x | PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, *pte & PTE_A, *pte);
80102867:	68 bc 7d 10 80       	push   $0x80107dbc
8010286c:	e8 3f de ff ff       	call   801006b0 <cprintf>
    p_page = p_page->prev;
80102871:	8b 5b 04             	mov    0x4(%ebx),%ebx
  for (int i = 0; i < num_lru_pages; i++)
80102874:	83 c4 20             	add    $0x20,%esp
80102877:	39 35 a0 46 11 80    	cmp    %esi,0x801146a0
8010287d:	7f c1                	jg     80102840 <lru_print+0x20>
  }
}
8010287f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102882:	5b                   	pop    %ebx
80102883:	5e                   	pop    %esi
80102884:	5d                   	pop    %ebp
80102885:	c3                   	ret    
80102886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010288d:	8d 76 00             	lea    0x0(%esi),%esi

80102890 <page_insert>:

void page_insert(pde_t *pgdir, uint vaddr)
{
80102890:	f3 0f 1e fb          	endbr32 
80102894:	55                   	push   %ebp
80102895:	b8 d0 46 11 80       	mov    $0x801146d0,%eax
8010289a:	89 e5                	mov    %esp,%ebp
8010289c:	57                   	push   %edi
8010289d:	56                   	push   %esi
8010289e:	53                   	push   %ebx
  // cprintf("================Page insert start================\n");
  struct page *new_page, *next_page;
  // lru entry insert
  for (int i = 0; i < (PHYSTOP / PGSIZE); i++)
8010289f:	31 db                	xor    %ebx,%ebx
{
801028a1:	83 ec 1c             	sub    $0x1c,%esp
801028a4:	8b 55 08             	mov    0x8(%ebp),%edx
801028a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028aa:	eb 16                	jmp    801028c2 <page_insert+0x32>
801028ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (int i = 0; i < (PHYSTOP / PGSIZE); i++)
801028b0:	83 c3 01             	add    $0x1,%ebx
801028b3:	83 c0 14             	add    $0x14,%eax
801028b6:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801028bc:	0f 84 0e 01 00 00    	je     801029d0 <page_insert+0x140>
  {
    // search not using page
    new_page = &pages[i];
    if (new_page->use == 0)
801028c2:	8b 30                	mov    (%eax),%esi
801028c4:	85 f6                	test   %esi,%esi
801028c6:	75 e8                	jne    801028b0 <page_insert+0x20>
    new_page = &pages[i];
801028c8:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
    {
      break;
    }
  }

  if (num_lru_pages == 0)
801028cb:	8b 35 a0 46 11 80    	mov    0x801146a0,%esi
    new_page = &pages[i];
801028d1:	c1 e0 02             	shl    $0x2,%eax
801028d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801028d7:	05 c0 46 11 80       	add    $0x801146c0,%eax
  if (num_lru_pages == 0)
801028dc:	85 f6                	test   %esi,%esi
801028de:	0f 84 ac 00 00 00    	je     80102990 <page_insert+0x100>
    new_page->pgdir = pgdir;
    new_page->vaddr = (char *)vaddr;
    new_page->use = 1;
    cprintf("page insert | lru_page_num : %d | pgdir : %x | vaddr : %x", num_lru_pages, new_page->pgdir, new_page->vaddr);
  }
  else if (num_lru_pages == 1)
801028e4:	8b 3d a4 46 11 80    	mov    0x801146a4,%edi
801028ea:	83 fe 01             	cmp    $0x1,%esi
801028ed:	0f 84 7d 00 00 00    	je     80102970 <page_insert+0xe0>
    cprintf("page insert | lru_page_num : %d | pgdir : %x | vaddr : %x", num_lru_pages, new_page->pgdir, new_page->vaddr);
  }
  else
  {
    // case of above third lru entry
    next_page = page_lru_head->next;
801028f3:	8b 37                	mov    (%edi),%esi

    page_lru_head->next = new_page;
801028f5:	89 07                	mov    %eax,(%edi)
    new_page->prev = page_lru_head;
801028f7:	8b 3d a4 46 11 80    	mov    0x801146a4,%edi
801028fd:	89 78 04             	mov    %edi,0x4(%eax)

    new_page->next = next_page;
80102900:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102903:	89 b7 c0 46 11 80    	mov    %esi,-0x7feeb940(%edi)
    next_page->prev = new_page;
80102909:	89 46 04             	mov    %eax,0x4(%esi)

    num_lru_pages++;
8010290c:	8b 3d a0 46 11 80    	mov    0x801146a0,%edi
    // page entry setting
    new_page->pgdir = pgdir;
80102912:	89 50 08             	mov    %edx,0x8(%eax)
    new_page->vaddr = (char *)vaddr;
80102915:	89 48 0c             	mov    %ecx,0xc(%eax)
    num_lru_pages++;
80102918:	8d 77 01             	lea    0x1(%edi),%esi
    new_page->use = 1;
8010291b:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    cprintf("page insert | lru_page_num : %d | pgdir : %x | vaddr : %x", num_lru_pages, new_page->pgdir, new_page->vaddr);
80102922:	51                   	push   %ecx
80102923:	52                   	push   %edx
80102924:	56                   	push   %esi
80102925:	68 08 7e 10 80       	push   $0x80107e08
    num_lru_pages++;
8010292a:	89 35 a0 46 11 80    	mov    %esi,0x801146a0
    cprintf("page insert | lru_page_num : %d | pgdir : %x | vaddr : %x", num_lru_pages, new_page->pgdir, new_page->vaddr);
80102930:	e8 7b dd ff ff       	call   801006b0 <cprintf>
80102935:	83 c4 10             	add    $0x10,%esp
  }
  // cprintf("====lru entry top====\n");
  // lru_print();
  // cprintf("====lru entry bottom====\n");
  cprintf(" | \tPTE : %x\n", walkpgdir(new_page->pgdir, new_page->vaddr, 0));
80102938:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
8010293b:	83 ec 04             	sub    $0x4,%esp
8010293e:	8d 04 85 c0 46 11 80 	lea    -0x7feeb940(,%eax,4),%eax
80102945:	6a 00                	push   $0x0
80102947:	ff 70 0c             	pushl  0xc(%eax)
8010294a:	ff 70 08             	pushl  0x8(%eax)
8010294d:	e8 be 47 00 00       	call   80107110 <walkpgdir>
80102952:	c7 45 08 12 7d 10 80 	movl   $0x80107d12,0x8(%ebp)
80102959:	83 c4 10             	add    $0x10,%esp
8010295c:	89 45 0c             	mov    %eax,0xc(%ebp)

  // cprintf("================Page insert finished================\n");
}
8010295f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102962:	5b                   	pop    %ebx
80102963:	5e                   	pop    %esi
80102964:	5f                   	pop    %edi
80102965:	5d                   	pop    %ebp
  cprintf(" | \tPTE : %x\n", walkpgdir(new_page->pgdir, new_page->vaddr, 0));
80102966:	e9 45 dd ff ff       	jmp    801006b0 <cprintf>
8010296b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010296f:	90                   	nop
    page_lru_head->next = new_page;
80102970:	89 07                	mov    %eax,(%edi)
    new_page->next = page_lru_head;
80102972:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    page_lru_head->prev = new_page;
80102975:	8b 35 a4 46 11 80    	mov    0x801146a4,%esi
8010297b:	89 46 04             	mov    %eax,0x4(%esi)
    new_page->prev = page_lru_head;
8010297e:	89 70 04             	mov    %esi,0x4(%eax)
    new_page->next = page_lru_head;
80102981:	89 b7 c0 46 11 80    	mov    %esi,-0x7feeb940(%edi)
    num_lru_pages++;
80102987:	e9 80 ff ff ff       	jmp    8010290c <page_insert+0x7c>
8010298c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    page_lru_head->prev = new_page;
80102990:	89 40 04             	mov    %eax,0x4(%eax)
    page_lru_head->next = new_page;
80102993:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    new_page->pgdir = pgdir;
80102996:	89 50 08             	mov    %edx,0x8(%eax)
    new_page->vaddr = (char *)vaddr;
80102999:	89 48 0c             	mov    %ecx,0xc(%eax)
    new_page->use = 1;
8010299c:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    cprintf("page insert | lru_page_num : %d | pgdir : %x | vaddr : %x", num_lru_pages, new_page->pgdir, new_page->vaddr);
801029a3:	51                   	push   %ecx
801029a4:	52                   	push   %edx
801029a5:	6a 01                	push   $0x1
801029a7:	68 08 7e 10 80       	push   $0x80107e08
    page_lru_head = new_page;
801029ac:	a3 a4 46 11 80       	mov    %eax,0x801146a4
    page_lru_head->next = new_page;
801029b1:	89 86 c0 46 11 80    	mov    %eax,-0x7feeb940(%esi)
    num_lru_pages++;
801029b7:	c7 05 a0 46 11 80 01 	movl   $0x1,0x801146a0
801029be:	00 00 00 
    cprintf("page insert | lru_page_num : %d | pgdir : %x | vaddr : %x", num_lru_pages, new_page->pgdir, new_page->vaddr);
801029c1:	e8 ea dc ff ff       	call   801006b0 <cprintf>
801029c6:	83 c4 10             	add    $0x10,%esp
801029c9:	e9 6a ff ff ff       	jmp    80102938 <page_insert+0xa8>
801029ce:	66 90                	xchg   %ax,%ax
801029d0:	bb ff 03 00 00       	mov    $0x3ff,%ebx
801029d5:	e9 ee fe ff ff       	jmp    801028c8 <page_insert+0x38>
801029da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029e0 <page_delete>:

int page_delete(pde_t *pgdir, char *vaddr)
{
801029e0:	f3 0f 1e fb          	endbr32 
801029e4:	55                   	push   %ebp
801029e5:	89 e5                	mov    %esp,%ebp
801029e7:	57                   	push   %edi
801029e8:	56                   	push   %esi
801029e9:	53                   	push   %ebx
801029ea:	83 ec 04             	sub    $0x4,%esp
  struct page *p_page, *temp_head, *f_page, *b_page;
  // cprintf("================Page delete start================\n");

  temp_head = page_lru_head;
801029ed:	a1 a4 46 11 80       	mov    0x801146a4,%eax
  // cprintf("page delete target | pgdir : %x | vaddr : %x\n", pgdir, vaddr);
  for (int i = 0; i < num_lru_pages; i++) // search lru with vaddr, pgdir
801029f2:	8b 0d a0 46 11 80    	mov    0x801146a0,%ecx
{
801029f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029fb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  temp_head = page_lru_head;
801029fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (int i = 0; i < num_lru_pages; i++) // search lru with vaddr, pgdir
80102a01:	85 c9                	test   %ecx,%ecx
80102a03:	7e 75                	jle    80102a7a <page_delete+0x9a>
80102a05:	31 f6                	xor    %esi,%esi
80102a07:	31 d2                	xor    %edx,%edx
80102a09:	eb 14                	jmp    80102a1f <page_delete+0x3f>
80102a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a0f:	90                   	nop
80102a10:	83 c2 01             	add    $0x1,%edx
      // cprintf("================Page delete end================\n");
      return 0;
    }
    else
    {
      page_lru_head = page_lru_head->prev;
80102a13:	8b 40 04             	mov    0x4(%eax),%eax
  for (int i = 0; i < num_lru_pages; i++) // search lru with vaddr, pgdir
80102a16:	be 01 00 00 00       	mov    $0x1,%esi
80102a1b:	39 ca                	cmp    %ecx,%edx
80102a1d:	74 49                	je     80102a68 <page_delete+0x88>
    if ((p_page->pgdir == pgdir) && (p_page->vaddr == vaddr))
80102a1f:	39 58 08             	cmp    %ebx,0x8(%eax)
80102a22:	75 ec                	jne    80102a10 <page_delete+0x30>
80102a24:	39 78 0c             	cmp    %edi,0xc(%eax)
80102a27:	75 e7                	jne    80102a10 <page_delete+0x30>
80102a29:	89 f3                	mov    %esi,%ebx
80102a2b:	84 db                	test   %bl,%bl
80102a2d:	74 05                	je     80102a34 <page_delete+0x54>
80102a2f:	a3 a4 46 11 80       	mov    %eax,0x801146a4
      b_page = p_page->next;
80102a34:	8b 10                	mov    (%eax),%edx
      f_page = p_page->prev;
80102a36:	8b 48 04             	mov    0x4(%eax),%ecx
      f_page->next = b_page;
80102a39:	89 11                	mov    %edx,(%ecx)
      b_page->prev = f_page;
80102a3b:	89 4a 04             	mov    %ecx,0x4(%edx)
      p_page->use = 0;
80102a3e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
      page_lru_head = temp_head->prev;
80102a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
      num_lru_pages--;
80102a48:	83 2d a0 46 11 80 01 	subl   $0x1,0x801146a0
      page_lru_head = temp_head->prev;
80102a4f:	8b 40 04             	mov    0x4(%eax),%eax
80102a52:	a3 a4 46 11 80       	mov    %eax,0x801146a4
    }
  }
  // cprintf("================Page delete not exist================\n");
  return -1;
}
80102a57:	83 c4 04             	add    $0x4,%esp
      return 0;
80102a5a:	31 c0                	xor    %eax,%eax
}
80102a5c:	5b                   	pop    %ebx
80102a5d:	5e                   	pop    %esi
80102a5e:	5f                   	pop    %edi
80102a5f:	5d                   	pop    %ebp
80102a60:	c3                   	ret    
80102a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a68:	a3 a4 46 11 80       	mov    %eax,0x801146a4
  return -1;
80102a6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102a72:	83 c4 04             	add    $0x4,%esp
80102a75:	5b                   	pop    %ebx
80102a76:	5e                   	pop    %esi
80102a77:	5f                   	pop    %edi
80102a78:	5d                   	pop    %ebp
80102a79:	c3                   	ret    
  return -1;
80102a7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102a7f:	eb f1                	jmp    80102a72 <page_delete+0x92>
80102a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8f:	90                   	nop

80102a90 <swapout>:

char *swapout(void)
{
80102a90:	f3 0f 1e fb          	endbr32 
80102a94:	55                   	push   %ebp
80102a95:	89 e5                	mov    %esp,%ebp
80102a97:	57                   	push   %edi
80102a98:	56                   	push   %esi
80102a99:	53                   	push   %ebx
80102a9a:	83 ec 1c             	sub    $0x1c,%esp
  char *mem;
  int bitmap_offset_get = 0;
  // cprintf("================swap out start================\n");

  int bitmap_offset = 0;
  if (num_lru_pages == 0)
80102a9d:	8b 3d a0 46 11 80    	mov    0x801146a0,%edi
80102aa3:	85 ff                	test   %edi,%edi
80102aa5:	0f 84 6c 01 00 00    	je     80102c17 <swapout+0x187>
  {
    panic("OOM Error");
  }

  // get bitmap free
  for (int i = 0; i < PGSIZE; i++)
80102aab:	31 db                	xor    %ebx,%ebx
80102aad:	8d 76 00             	lea    0x0(%esi),%esi
    for (int j = 0; j < 8; j++)
    {
      // cprintf("setbit : %d\n", set_bit);
      // cprintf("bitmap[%d] : %d\n", i, bitmap[i]);
      //  get low bit in bitmap
      if ((set_bit & bitmap[i]) == 0)
80102ab0:	0f b6 8b a0 36 11 80 	movzbl -0x7feec960(%ebx),%ecx
    for (int j = 0; j < 8; j++)
80102ab7:	31 c0                	xor    %eax,%eax
    set_bit = 1;
80102ab9:	ba 01 00 00 00       	mov    $0x1,%edx
80102abe:	66 90                	xchg   %ax,%ax
      if ((set_bit & bitmap[i]) == 0)
80102ac0:	84 d1                	test   %dl,%cl
80102ac2:	74 1c                	je     80102ae0 <swapout+0x50>
    for (int j = 0; j < 8; j++)
80102ac4:	83 c0 01             	add    $0x1,%eax
        break;
      }
      else
      {
        // shift to next bit for check
        set_bit = set_bit << 1;
80102ac7:	01 d2                	add    %edx,%edx
    for (int j = 0; j < 8; j++)
80102ac9:	83 f8 08             	cmp    $0x8,%eax
80102acc:	75 f2                	jne    80102ac0 <swapout+0x30>
  for (int i = 0; i < PGSIZE; i++)
80102ace:	83 c3 01             	add    $0x1,%ebx
80102ad1:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
80102ad7:	75 d7                	jne    80102ab0 <swapout+0x20>
80102ad9:	31 f6                	xor    %esi,%esi
80102adb:	eb 06                	jmp    80102ae3 <swapout+0x53>
80102add:	8d 76 00             	lea    0x0(%esi),%esi
        bitmap_offset = 8 * i + j;
80102ae0:	8d 34 d8             	lea    (%eax,%ebx,8),%esi
    p_page = p_page->prev;
  }
  cprintf("============page entry bottom\n");
  */
  // victim page process
  for (int i = 0; i < num_lru_pages + 10; i++)
80102ae3:	83 ff f7             	cmp    $0xfffffff7,%edi
80102ae6:	0f 8c 0d 01 00 00    	jl     80102bf9 <swapout+0x169>
80102aec:	8b 1d a4 46 11 80    	mov    0x801146a4,%ebx
80102af2:	31 ff                	xor    %edi,%edi
80102af4:	eb 30                	jmp    80102b26 <swapout+0x96>
80102af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102afd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    else // ref bit high
    {
      // clear the flag
      // cprintf("clear flag occur\n");
      *pte = *pte & (~PTE_A);
80102b00:	83 e2 df             	and    $0xffffffdf,%edx
  for (int i = 0; i < num_lru_pages + 10; i++)
80102b03:	83 c7 01             	add    $0x1,%edi
      *pte = *pte & (~PTE_A);
80102b06:	89 10                	mov    %edx,(%eax)
      // go to previous page
      page_lru_head = page_lru_head->prev;
80102b08:	a1 a4 46 11 80       	mov    0x801146a4,%eax
80102b0d:	8b 58 04             	mov    0x4(%eax),%ebx
  for (int i = 0; i < num_lru_pages + 10; i++)
80102b10:	a1 a0 46 11 80       	mov    0x801146a0,%eax
80102b15:	83 c0 09             	add    $0x9,%eax
      page_lru_head = page_lru_head->prev;
80102b18:	89 1d a4 46 11 80    	mov    %ebx,0x801146a4
  for (int i = 0; i < num_lru_pages + 10; i++)
80102b1e:	39 c7                	cmp    %eax,%edi
80102b20:	0f 8f d3 00 00 00    	jg     80102bf9 <swapout+0x169>
    pte = walkpgdir(p_page->pgdir, p_page->vaddr, 0);
80102b26:	83 ec 04             	sub    $0x4,%esp
80102b29:	6a 00                	push   $0x0
80102b2b:	ff 73 0c             	pushl  0xc(%ebx)
80102b2e:	ff 73 08             	pushl  0x8(%ebx)
80102b31:	e8 da 45 00 00       	call   80107110 <walkpgdir>
    if ((*pte != 0) && ((*pte & PTE_A) == 0)) // ref bit low
80102b36:	83 c4 10             	add    $0x10,%esp
    mem = P2V((PTE_ADDR(*pte)));
80102b39:	8b 10                	mov    (%eax),%edx
    if ((*pte != 0) && ((*pte & PTE_A) == 0)) // ref bit low
80102b3b:	85 d2                	test   %edx,%edx
80102b3d:	74 c1                	je     80102b00 <swapout+0x70>
80102b3f:	f6 c2 20             	test   $0x20,%dl
80102b42:	75 bc                	jne    80102b00 <swapout+0x70>
    mem = P2V((PTE_ADDR(*pte)));
80102b44:	89 d7                	mov    %edx,%edi
      cprintf("swapout victim page | pgdir : %x | vaddr : %x | PTE : %x | MEM : %x\n", p_page->pgdir, p_page->vaddr, *pte, mem);
80102b46:	83 ec 0c             	sub    $0xc,%esp
80102b49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    mem = P2V((PTE_ADDR(*pte)));
80102b4c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80102b52:	81 c7 00 00 00 80    	add    $0x80000000,%edi
      cprintf("swapout victim page | pgdir : %x | vaddr : %x | PTE : %x | MEM : %x\n", p_page->pgdir, p_page->vaddr, *pte, mem);
80102b58:	57                   	push   %edi
80102b59:	52                   	push   %edx
80102b5a:	ff 73 0c             	pushl  0xc(%ebx)
80102b5d:	ff 73 08             	pushl  0x8(%ebx)
80102b60:	68 98 7e 10 80       	push   $0x80107e98
80102b65:	e8 46 db ff ff       	call   801006b0 <cprintf>
      swapwrite(mem, bitmap_offset);
80102b6a:	83 c4 18             	add    $0x18,%esp
80102b6d:	56                   	push   %esi
80102b6e:	57                   	push   %edi
80102b6f:	e8 8c f5 ff ff       	call   80102100 <swapwrite>
      *pte = (bitmap_offset << 12) | PTE_FLAGS(pte);
80102b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102b77:	89 f1                	mov    %esi,%ecx
80102b79:	c1 e1 0c             	shl    $0xc,%ecx
80102b7c:	89 c2                	mov    %eax,%edx
80102b7e:	81 e2 fe 0f 00 00    	and    $0xffe,%edx
      *pte = *pte & (~PTE_P);
80102b84:	09 ca                	or     %ecx,%edx
80102b86:	89 10                	mov    %edx,(%eax)
      lcr3(V2P(p_page->pgdir));
80102b88:	8b 43 08             	mov    0x8(%ebx),%eax
80102b8b:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80102b90:	0f 22 d8             	mov    %eax,%cr3
      page_lru_head = page_lru_head->prev;
80102b93:	a1 a4 46 11 80       	mov    0x801146a4,%eax
80102b98:	8b 50 04             	mov    0x4(%eax),%edx
80102b9b:	89 15 a4 46 11 80    	mov    %edx,0x801146a4
      page_lru_head->next = p_page->next;
80102ba1:	8b 03                	mov    (%ebx),%eax
80102ba3:	89 02                	mov    %eax,(%edx)
      p_page->next->prev = page_lru_head;
80102ba5:	8b 15 a4 46 11 80    	mov    0x801146a4,%edx
80102bab:	89 50 04             	mov    %edx,0x4(%eax)
  {
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
  }
  else // set
  {
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] | (1 << bitmap_offset % 8);
80102bae:	89 f0                	mov    %esi,%eax
80102bb0:	83 e6 07             	and    $0x7,%esi
80102bb3:	ba 01 00 00 00       	mov    $0x1,%edx
80102bb8:	c1 f8 03             	sar    $0x3,%eax
80102bbb:	89 f1                	mov    %esi,%ecx
      kfree(mem);
80102bbd:	89 3c 24             	mov    %edi,(%esp)
      kmem.use_lock = 0;
80102bc0:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102bc7:	00 00 00 
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] | (1 << bitmap_offset % 8);
80102bca:	d3 e2                	shl    %cl,%edx
80102bcc:	08 90 a0 36 11 80    	or     %dl,-0x7feec960(%eax)
      kfree(mem);
80102bd2:	e8 a9 f9 ff ff       	call   80102580 <kfree>
      num_lru_pages--;
80102bd7:	83 2d a0 46 11 80 01 	subl   $0x1,0x801146a0
}
80102bde:	89 f8                	mov    %edi,%eax
      kmem.use_lock = 1;
80102be0:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
80102be7:	00 00 00 
      p_page->use = 0;
80102bea:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
}
80102bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bf4:	5b                   	pop    %ebx
80102bf5:	5e                   	pop    %esi
80102bf6:	5f                   	pop    %edi
80102bf7:	5d                   	pop    %ebp
80102bf8:	c3                   	ret    
  cprintf("================swap out err================\n");
80102bf9:	83 ec 0c             	sub    $0xc,%esp
80102bfc:	68 44 7e 10 80       	push   $0x80107e44
80102c01:	e8 aa da ff ff       	call   801006b0 <cprintf>
  lru_print();
80102c06:	e8 15 fc ff ff       	call   80102820 <lru_print>
  panic("swap out err not found zero page");
80102c0b:	c7 04 24 74 7e 10 80 	movl   $0x80107e74,(%esp)
80102c12:	e8 79 d7 ff ff       	call   80100390 <panic>
    panic("OOM Error");
80102c17:	83 ec 0c             	sub    $0xc,%esp
80102c1a:	68 20 7d 10 80       	push   $0x80107d20
80102c1f:	e8 6c d7 ff ff       	call   80100390 <panic>
80102c24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c2f:	90                   	nop

80102c30 <kalloc>:
{
80102c30:	f3 0f 1e fb          	endbr32 
80102c34:	55                   	push   %ebp
80102c35:	89 e5                	mov    %esp,%ebp
80102c37:	83 ec 18             	sub    $0x18,%esp
  if (kmem.use_lock)
80102c3a:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx
80102c40:	85 c9                	test   %ecx,%ecx
80102c42:	75 5c                	jne    80102ca0 <kalloc+0x70>
  if (num_free_pages <= 0)
80102c44:	8b 15 a8 46 11 80    	mov    0x801146a8,%edx
80102c4a:	85 d2                	test   %edx,%edx
80102c4c:	7e 42                	jle    80102c90 <kalloc+0x60>
    r = kmem.freelist;
80102c4e:	a1 98 36 11 80       	mov    0x80113698,%eax
    if (r)
80102c53:	85 c0                	test   %eax,%eax
80102c55:	74 39                	je     80102c90 <kalloc+0x60>
      kmem.freelist = r->next;
80102c57:	8b 08                	mov    (%eax),%ecx
80102c59:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  num_free_pages--;
80102c5f:	83 ea 01             	sub    $0x1,%edx
80102c62:	89 15 a8 46 11 80    	mov    %edx,0x801146a8
  if (kmem.use_lock)
80102c68:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102c6e:	85 d2                	test   %edx,%edx
80102c70:	75 06                	jne    80102c78 <kalloc+0x48>
}
80102c72:	c9                   	leave  
80102c73:	c3                   	ret    
80102c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
80102c78:	83 ec 0c             	sub    $0xc,%esp
80102c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102c7e:	68 60 36 11 80       	push   $0x80113660
80102c83:	e8 18 21 00 00       	call   80104da0 <release>
80102c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c8b:	83 c4 10             	add    $0x10,%esp
}
80102c8e:	c9                   	leave  
80102c8f:	c3                   	ret    
    r = (struct run *)swapout();
80102c90:	e8 fb fd ff ff       	call   80102a90 <swapout>
80102c95:	8b 15 a8 46 11 80    	mov    0x801146a8,%edx
80102c9b:	eb c2                	jmp    80102c5f <kalloc+0x2f>
80102c9d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102ca0:	83 ec 0c             	sub    $0xc,%esp
80102ca3:	68 60 36 11 80       	push   $0x80113660
80102ca8:	e8 33 20 00 00       	call   80104ce0 <acquire>
80102cad:	83 c4 10             	add    $0x10,%esp
80102cb0:	eb 92                	jmp    80102c44 <kalloc+0x14>
80102cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cc0 <bitmap_modify>:
{
80102cc0:	f3 0f 1e fb          	endbr32 
80102cc4:	55                   	push   %ebp
80102cc5:	89 e5                	mov    %esp,%ebp
80102cc7:	53                   	push   %ebx
80102cc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102ccb:	85 c9                	test   %ecx,%ecx
80102ccd:	8d 41 07             	lea    0x7(%ecx),%eax
80102cd0:	89 cb                	mov    %ecx,%ebx
80102cd2:	0f 49 c1             	cmovns %ecx,%eax
80102cd5:	c1 fb 1f             	sar    $0x1f,%ebx
80102cd8:	c1 eb 1d             	shr    $0x1d,%ebx
80102cdb:	01 d9                	add    %ebx,%ecx
80102cdd:	c1 f8 03             	sar    $0x3,%eax
80102ce0:	83 e1 07             	and    $0x7,%ecx
80102ce3:	0f b6 90 a0 36 11 80 	movzbl -0x7feec960(%eax),%edx
80102cea:	29 d9                	sub    %ebx,%ecx
80102cec:	bb 01 00 00 00       	mov    $0x1,%ebx
80102cf1:	d3 e3                	shl    %cl,%ebx
80102cf3:	89 d9                	mov    %ebx,%ecx
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102cf5:	89 d3                	mov    %edx,%ebx
80102cf7:	09 cb                	or     %ecx,%ebx
80102cf9:	f7 d1                	not    %ecx
80102cfb:	21 ca                	and    %ecx,%edx
80102cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102d00:	85 c9                	test   %ecx,%ecx
80102d02:	0f 45 d3             	cmovne %ebx,%edx
  }
  // cprintf("================bitmap modify end================\n");
}
80102d05:	5b                   	pop    %ebx
80102d06:	5d                   	pop    %ebp
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102d07:	88 90 a0 36 11 80    	mov    %dl,-0x7feec960(%eax)
}
80102d0d:	c3                   	ret    
80102d0e:	66 90                	xchg   %ax,%ax

80102d10 <page_fault_handler>:

int page_fault_handler(pde_t *pgdir, uint vaddr)
{
80102d10:	f3 0f 1e fb          	endbr32 
80102d14:	55                   	push   %ebp
80102d15:	89 e5                	mov    %esp,%ebp
80102d17:	57                   	push   %edi
80102d18:	56                   	push   %esi
80102d19:	53                   	push   %ebx
80102d1a:	83 ec 24             	sub    $0x24,%esp
80102d1d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *mem;
  pte_t *pte;
  int bitmap_offset;
  cprintf("Page fault at %x\n", vaddr);
80102d20:	56                   	push   %esi
80102d21:	68 2a 7d 10 80       	push   $0x80107d2a
80102d26:	e8 85 d9 ff ff       	call   801006b0 <cprintf>

  // PTE check
  pte = walkpgdir(pgdir, (void *)vaddr, 0);
80102d2b:	83 c4 0c             	add    $0xc,%esp
80102d2e:	6a 00                	push   $0x0
80102d30:	56                   	push   %esi
80102d31:	ff 75 08             	pushl  0x8(%ebp)
80102d34:	e8 d7 43 00 00       	call   80107110 <walkpgdir>
  // cprintf("present page info | pgdir : %x | vaddr : %x | PTE : %x\n", pgdir, vaddr, *pte);
  // cprintf("*pte & PTE_P = %x\n", *pte & PTE_P);
  if ((*pte != 0) && ((*pte & PTE_P) == 0)) // page-fault occur where swapped out page
80102d39:	83 c4 10             	add    $0x10,%esp
  pte = walkpgdir(pgdir, (void *)vaddr, 0);
80102d3c:	89 c3                	mov    %eax,%ebx
  if ((*pte != 0) && ((*pte & PTE_P) == 0)) // page-fault occur where swapped out page
80102d3e:	8b 00                	mov    (%eax),%eax
80102d40:	85 c0                	test   %eax,%eax
80102d42:	74 04                	je     80102d48 <page_fault_handler+0x38>
80102d44:	a8 01                	test   $0x1,%al
80102d46:	74 28                	je     80102d70 <page_fault_handler+0x60>
    bitmap_modify(bitmap_offset, 0);
    // cprintf("================Page fault(swappable) end================\n");
  }
  else // page fault occur not exist
  {
    cprintf("================Page fault(non swappable) start================\n");
80102d48:	83 ec 0c             	sub    $0xc,%esp
80102d4b:	68 04 7f 10 80       	push   $0x80107f04
80102d50:	e8 5b d9 ff ff       	call   801006b0 <cprintf>
    // generate page table
    pte = walkpgdir(pgdir, (void *)vaddr, 1);
    // mapping physical page with virtual page
    mappages(pgdir, vaddr, PGSIZE, V2P(mem), PTE_P | PTE_W | PTE_U);
    */
    cprintf("================Page fault(non swappable) end================\n");
80102d55:	c7 04 24 48 7f 10 80 	movl   $0x80107f48,(%esp)
80102d5c:	e8 4f d9 ff ff       	call   801006b0 <cprintf>
80102d61:	83 c4 10             	add    $0x10,%esp
  }
  // cprintf("================Page fault end================\n");

  return 0;
80102d64:	31 c0                	xor    %eax,%eax
80102d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d69:	5b                   	pop    %ebx
80102d6a:	5e                   	pop    %esi
80102d6b:	5f                   	pop    %edi
80102d6c:	5d                   	pop    %ebp
80102d6d:	c3                   	ret    
80102d6e:	66 90                	xchg   %ax,%ax
    cprintf("Memory allocation\n");
80102d70:	83 ec 0c             	sub    $0xc,%esp
80102d73:	68 3c 7d 10 80       	push   $0x80107d3c
80102d78:	e8 33 d9 ff ff       	call   801006b0 <cprintf>
    mem = kalloc();
80102d7d:	e8 ae fe ff ff       	call   80102c30 <kalloc>
    if (mem == 0)
80102d82:	83 c4 10             	add    $0x10,%esp
    mem = kalloc();
80102d85:	89 c7                	mov    %eax,%edi
    if (mem == 0)
80102d87:	85 c0                	test   %eax,%eax
80102d89:	74 72                	je     80102dfd <page_fault_handler+0xed>
    memset(mem, 0, PGSIZE);
80102d8b:	83 ec 04             	sub    $0x4,%esp
80102d8e:	68 00 10 00 00       	push   $0x1000
80102d93:	6a 00                	push   $0x0
80102d95:	50                   	push   %eax
80102d96:	e8 55 20 00 00       	call   80104df0 <memset>
    bitmap_offset = (PTE_ADDR(*pte)) >> 12;
80102d9b:	8b 03                	mov    (%ebx),%eax
    swapread(mem, bitmap_offset);
80102d9d:	5a                   	pop    %edx
80102d9e:	59                   	pop    %ecx
    bitmap_offset = (PTE_ADDR(*pte)) >> 12;
80102d9f:	c1 e8 0c             	shr    $0xc,%eax
    swapread(mem, bitmap_offset);
80102da2:	50                   	push   %eax
80102da3:	57                   	push   %edi
80102da4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102da7:	e8 c4 f2 ff ff       	call   80102070 <swapread>
    *pte = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
80102dac:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80102db2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80102db8:	83 ca 07             	or     $0x7,%edx
80102dbb:	89 13                	mov    %edx,(%ebx)
    cprintf("Swap in | ");
80102dbd:	c7 04 24 4f 7d 10 80 	movl   $0x80107d4f,(%esp)
80102dc4:	e8 e7 d8 ff ff       	call   801006b0 <cprintf>
    page_insert(pgdir, vaddr);
80102dc9:	5b                   	pop    %ebx
80102dca:	5f                   	pop    %edi
80102dcb:	56                   	push   %esi
80102dcc:	ff 75 08             	pushl  0x8(%ebp)
80102dcf:	e8 bc fa ff ff       	call   80102890 <page_insert>
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102dd7:	83 c4 10             	add    $0x10,%esp
80102dda:	89 c2                	mov    %eax,%edx
80102ddc:	83 e0 07             	and    $0x7,%eax
80102ddf:	89 c1                	mov    %eax,%ecx
80102de1:	b8 01 00 00 00       	mov    $0x1,%eax
80102de6:	c1 fa 03             	sar    $0x3,%edx
80102de9:	d3 e0                	shl    %cl,%eax
80102deb:	f7 d0                	not    %eax
80102ded:	20 82 a0 36 11 80    	and    %al,-0x7feec960(%edx)
80102df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102df6:	31 c0                	xor    %eax,%eax
80102df8:	5b                   	pop    %ebx
80102df9:	5e                   	pop    %esi
80102dfa:	5f                   	pop    %edi
80102dfb:	5d                   	pop    %ebp
80102dfc:	c3                   	ret    
      cprintf("page fault allocate out of memory\n");
80102dfd:	83 ec 0c             	sub    $0xc,%esp
80102e00:	68 e0 7e 10 80       	push   $0x80107ee0
80102e05:	e8 a6 d8 ff ff       	call   801006b0 <cprintf>
      return -1;
80102e0a:	83 c4 10             	add    $0x10,%esp
80102e0d:	83 c8 ff             	or     $0xffffffff,%eax
80102e10:	e9 51 ff ff ff       	jmp    80102d66 <page_fault_handler+0x56>
80102e15:	66 90                	xchg   %ax,%ax
80102e17:	66 90                	xchg   %ax,%ax
80102e19:	66 90                	xchg   %ax,%ax
80102e1b:	66 90                	xchg   %ax,%ax
80102e1d:	66 90                	xchg   %ax,%ax
80102e1f:	90                   	nop

80102e20 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102e20:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e24:	ba 64 00 00 00       	mov    $0x64,%edx
80102e29:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102e2a:	a8 01                	test   $0x1,%al
80102e2c:	0f 84 be 00 00 00    	je     80102ef0 <kbdgetc+0xd0>
{
80102e32:	55                   	push   %ebp
80102e33:	ba 60 00 00 00       	mov    $0x60,%edx
80102e38:	89 e5                	mov    %esp,%ebp
80102e3a:	53                   	push   %ebx
80102e3b:	ec                   	in     (%dx),%al
  return data;
80102e3c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102e42:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102e45:	3c e0                	cmp    $0xe0,%al
80102e47:	74 57                	je     80102ea0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102e49:	89 d9                	mov    %ebx,%ecx
80102e4b:	83 e1 40             	and    $0x40,%ecx
80102e4e:	84 c0                	test   %al,%al
80102e50:	78 5e                	js     80102eb0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102e52:	85 c9                	test   %ecx,%ecx
80102e54:	74 09                	je     80102e5f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e56:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102e59:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102e5c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102e5f:	0f b6 8a c0 80 10 80 	movzbl -0x7fef7f40(%edx),%ecx
  shift ^= togglecode[data];
80102e66:	0f b6 82 c0 7f 10 80 	movzbl -0x7fef8040(%edx),%eax
  shift |= shiftcode[data];
80102e6d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102e6f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102e71:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102e73:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102e79:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102e7c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102e7f:	8b 04 85 a0 7f 10 80 	mov    -0x7fef8060(,%eax,4),%eax
80102e86:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102e8a:	74 0b                	je     80102e97 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102e8c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102e8f:	83 fa 19             	cmp    $0x19,%edx
80102e92:	77 44                	ja     80102ed8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102e94:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102e97:	5b                   	pop    %ebx
80102e98:	5d                   	pop    %ebp
80102e99:	c3                   	ret    
80102e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102ea0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102ea3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102ea5:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
80102eab:	5b                   	pop    %ebx
80102eac:	5d                   	pop    %ebp
80102ead:	c3                   	ret    
80102eae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102eb0:	83 e0 7f             	and    $0x7f,%eax
80102eb3:	85 c9                	test   %ecx,%ecx
80102eb5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102eb8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102eba:	0f b6 8a c0 80 10 80 	movzbl -0x7fef7f40(%edx),%ecx
80102ec1:	83 c9 40             	or     $0x40,%ecx
80102ec4:	0f b6 c9             	movzbl %cl,%ecx
80102ec7:	f7 d1                	not    %ecx
80102ec9:	21 d9                	and    %ebx,%ecx
}
80102ecb:	5b                   	pop    %ebx
80102ecc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102ecd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102ed3:	c3                   	ret    
80102ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102ed8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102edb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102ede:	5b                   	pop    %ebx
80102edf:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102ee0:	83 f9 1a             	cmp    $0x1a,%ecx
80102ee3:	0f 42 c2             	cmovb  %edx,%eax
}
80102ee6:	c3                   	ret    
80102ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eee:	66 90                	xchg   %ax,%ax
    return -1;
80102ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ef5:	c3                   	ret    
80102ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102efd:	8d 76 00             	lea    0x0(%esi),%esi

80102f00 <kbdintr>:

void
kbdintr(void)
{
80102f00:	f3 0f 1e fb          	endbr32 
80102f04:	55                   	push   %ebp
80102f05:	89 e5                	mov    %esp,%ebp
80102f07:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102f0a:	68 20 2e 10 80       	push   $0x80102e20
80102f0f:	e8 4c d9 ff ff       	call   80100860 <consoleintr>
}
80102f14:	83 c4 10             	add    $0x10,%esp
80102f17:	c9                   	leave  
80102f18:	c3                   	ret    
80102f19:	66 90                	xchg   %ax,%ax
80102f1b:	66 90                	xchg   %ax,%ax
80102f1d:	66 90                	xchg   %ax,%ax
80102f1f:	90                   	nop

80102f20 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102f20:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102f24:	a1 c0 96 11 80       	mov    0x801196c0,%eax
80102f29:	85 c0                	test   %eax,%eax
80102f2b:	0f 84 c7 00 00 00    	je     80102ff8 <lapicinit+0xd8>
  lapic[index] = value;
80102f31:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102f38:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f3b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f3e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102f45:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f48:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f4b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102f52:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102f55:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f58:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102f5f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102f62:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f65:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102f6c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f6f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f72:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102f79:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f7c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f7f:	8b 50 30             	mov    0x30(%eax),%edx
80102f82:	c1 ea 10             	shr    $0x10,%edx
80102f85:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102f8b:	75 73                	jne    80103000 <lapicinit+0xe0>
  lapic[index] = value;
80102f8d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102f94:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f97:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f9a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102fa1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fa4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fa7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102fae:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fb1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fb4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102fbb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fbe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fc1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102fc8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fcb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fce:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102fd5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102fd8:	8b 50 20             	mov    0x20(%eax),%edx
80102fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fdf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102fe0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102fe6:	80 e6 10             	and    $0x10,%dh
80102fe9:	75 f5                	jne    80102fe0 <lapicinit+0xc0>
  lapic[index] = value;
80102feb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ff2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ff5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ff8:	c3                   	ret    
80102ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103000:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103007:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010300a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010300d:	e9 7b ff ff ff       	jmp    80102f8d <lapicinit+0x6d>
80103012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103020 <lapicid>:

int
lapicid(void)
{
80103020:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80103024:	a1 c0 96 11 80       	mov    0x801196c0,%eax
80103029:	85 c0                	test   %eax,%eax
8010302b:	74 0b                	je     80103038 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010302d:	8b 40 20             	mov    0x20(%eax),%eax
80103030:	c1 e8 18             	shr    $0x18,%eax
80103033:	c3                   	ret    
80103034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80103038:	31 c0                	xor    %eax,%eax
}
8010303a:	c3                   	ret    
8010303b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010303f:	90                   	nop

80103040 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103040:	f3 0f 1e fb          	endbr32 
  if(lapic)
80103044:	a1 c0 96 11 80       	mov    0x801196c0,%eax
80103049:	85 c0                	test   %eax,%eax
8010304b:	74 0d                	je     8010305a <lapiceoi+0x1a>
  lapic[index] = value;
8010304d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103054:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103057:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010305a:	c3                   	ret    
8010305b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010305f:	90                   	nop

80103060 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103060:	f3 0f 1e fb          	endbr32 
}
80103064:	c3                   	ret    
80103065:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010306c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103070 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103070:	f3 0f 1e fb          	endbr32 
80103074:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103075:	b8 0f 00 00 00       	mov    $0xf,%eax
8010307a:	ba 70 00 00 00       	mov    $0x70,%edx
8010307f:	89 e5                	mov    %esp,%ebp
80103081:	53                   	push   %ebx
80103082:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103085:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103088:	ee                   	out    %al,(%dx)
80103089:	b8 0a 00 00 00       	mov    $0xa,%eax
8010308e:	ba 71 00 00 00       	mov    $0x71,%edx
80103093:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103094:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103096:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103099:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010309f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801030a1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801030a4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801030a6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801030a9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801030ac:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801030b2:	a1 c0 96 11 80       	mov    0x801196c0,%eax
801030b7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801030bd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801030c0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801030c7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030ca:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801030cd:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801030d4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030d7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801030da:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801030e0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801030e3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801030e9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801030ec:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801030f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030f5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801030fb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801030fc:	8b 40 20             	mov    0x20(%eax),%eax
}
801030ff:	5d                   	pop    %ebp
80103100:	c3                   	ret    
80103101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010310f:	90                   	nop

80103110 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103110:	f3 0f 1e fb          	endbr32 
80103114:	55                   	push   %ebp
80103115:	b8 0b 00 00 00       	mov    $0xb,%eax
8010311a:	ba 70 00 00 00       	mov    $0x70,%edx
8010311f:	89 e5                	mov    %esp,%ebp
80103121:	57                   	push   %edi
80103122:	56                   	push   %esi
80103123:	53                   	push   %ebx
80103124:	83 ec 4c             	sub    $0x4c,%esp
80103127:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103128:	ba 71 00 00 00       	mov    $0x71,%edx
8010312d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010312e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103131:	bb 70 00 00 00       	mov    $0x70,%ebx
80103136:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103140:	31 c0                	xor    %eax,%eax
80103142:	89 da                	mov    %ebx,%edx
80103144:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103145:	b9 71 00 00 00       	mov    $0x71,%ecx
8010314a:	89 ca                	mov    %ecx,%edx
8010314c:	ec                   	in     (%dx),%al
8010314d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103150:	89 da                	mov    %ebx,%edx
80103152:	b8 02 00 00 00       	mov    $0x2,%eax
80103157:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103158:	89 ca                	mov    %ecx,%edx
8010315a:	ec                   	in     (%dx),%al
8010315b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010315e:	89 da                	mov    %ebx,%edx
80103160:	b8 04 00 00 00       	mov    $0x4,%eax
80103165:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103166:	89 ca                	mov    %ecx,%edx
80103168:	ec                   	in     (%dx),%al
80103169:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010316c:	89 da                	mov    %ebx,%edx
8010316e:	b8 07 00 00 00       	mov    $0x7,%eax
80103173:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103174:	89 ca                	mov    %ecx,%edx
80103176:	ec                   	in     (%dx),%al
80103177:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317a:	89 da                	mov    %ebx,%edx
8010317c:	b8 08 00 00 00       	mov    $0x8,%eax
80103181:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103182:	89 ca                	mov    %ecx,%edx
80103184:	ec                   	in     (%dx),%al
80103185:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103187:	89 da                	mov    %ebx,%edx
80103189:	b8 09 00 00 00       	mov    $0x9,%eax
8010318e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010318f:	89 ca                	mov    %ecx,%edx
80103191:	ec                   	in     (%dx),%al
80103192:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103194:	89 da                	mov    %ebx,%edx
80103196:	b8 0a 00 00 00       	mov    $0xa,%eax
8010319b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010319c:	89 ca                	mov    %ecx,%edx
8010319e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010319f:	84 c0                	test   %al,%al
801031a1:	78 9d                	js     80103140 <cmostime+0x30>
  return inb(CMOS_RETURN);
801031a3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801031a7:	89 fa                	mov    %edi,%edx
801031a9:	0f b6 fa             	movzbl %dl,%edi
801031ac:	89 f2                	mov    %esi,%edx
801031ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
801031b1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801031b5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031b8:	89 da                	mov    %ebx,%edx
801031ba:	89 7d c8             	mov    %edi,-0x38(%ebp)
801031bd:	89 45 bc             	mov    %eax,-0x44(%ebp)
801031c0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801031c4:	89 75 cc             	mov    %esi,-0x34(%ebp)
801031c7:	89 45 c0             	mov    %eax,-0x40(%ebp)
801031ca:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801031ce:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801031d1:	31 c0                	xor    %eax,%eax
801031d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031d4:	89 ca                	mov    %ecx,%edx
801031d6:	ec                   	in     (%dx),%al
801031d7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031da:	89 da                	mov    %ebx,%edx
801031dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
801031df:	b8 02 00 00 00       	mov    $0x2,%eax
801031e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031e5:	89 ca                	mov    %ecx,%edx
801031e7:	ec                   	in     (%dx),%al
801031e8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031eb:	89 da                	mov    %ebx,%edx
801031ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801031f0:	b8 04 00 00 00       	mov    $0x4,%eax
801031f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031f6:	89 ca                	mov    %ecx,%edx
801031f8:	ec                   	in     (%dx),%al
801031f9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031fc:	89 da                	mov    %ebx,%edx
801031fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103201:	b8 07 00 00 00       	mov    $0x7,%eax
80103206:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103207:	89 ca                	mov    %ecx,%edx
80103209:	ec                   	in     (%dx),%al
8010320a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010320d:	89 da                	mov    %ebx,%edx
8010320f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103212:	b8 08 00 00 00       	mov    $0x8,%eax
80103217:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103218:	89 ca                	mov    %ecx,%edx
8010321a:	ec                   	in     (%dx),%al
8010321b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010321e:	89 da                	mov    %ebx,%edx
80103220:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103223:	b8 09 00 00 00       	mov    $0x9,%eax
80103228:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103229:	89 ca                	mov    %ecx,%edx
8010322b:	ec                   	in     (%dx),%al
8010322c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010322f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103232:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103235:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103238:	6a 18                	push   $0x18
8010323a:	50                   	push   %eax
8010323b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010323e:	50                   	push   %eax
8010323f:	e8 fc 1b 00 00       	call   80104e40 <memcmp>
80103244:	83 c4 10             	add    $0x10,%esp
80103247:	85 c0                	test   %eax,%eax
80103249:	0f 85 f1 fe ff ff    	jne    80103140 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010324f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103253:	75 78                	jne    801032cd <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103255:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103258:	89 c2                	mov    %eax,%edx
8010325a:	83 e0 0f             	and    $0xf,%eax
8010325d:	c1 ea 04             	shr    $0x4,%edx
80103260:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103263:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103266:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103269:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010326c:	89 c2                	mov    %eax,%edx
8010326e:	83 e0 0f             	and    $0xf,%eax
80103271:	c1 ea 04             	shr    $0x4,%edx
80103274:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103277:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010327a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010327d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103280:	89 c2                	mov    %eax,%edx
80103282:	83 e0 0f             	and    $0xf,%eax
80103285:	c1 ea 04             	shr    $0x4,%edx
80103288:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010328b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010328e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103291:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103294:	89 c2                	mov    %eax,%edx
80103296:	83 e0 0f             	and    $0xf,%eax
80103299:	c1 ea 04             	shr    $0x4,%edx
8010329c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010329f:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032a2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801032a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801032a8:	89 c2                	mov    %eax,%edx
801032aa:	83 e0 0f             	and    $0xf,%eax
801032ad:	c1 ea 04             	shr    $0x4,%edx
801032b0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032b3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032b6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801032b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801032bc:	89 c2                	mov    %eax,%edx
801032be:	83 e0 0f             	and    $0xf,%eax
801032c1:	c1 ea 04             	shr    $0x4,%edx
801032c4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032c7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801032cd:	8b 75 08             	mov    0x8(%ebp),%esi
801032d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801032d3:	89 06                	mov    %eax,(%esi)
801032d5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801032d8:	89 46 04             	mov    %eax,0x4(%esi)
801032db:	8b 45 c0             	mov    -0x40(%ebp),%eax
801032de:	89 46 08             	mov    %eax,0x8(%esi)
801032e1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801032e4:	89 46 0c             	mov    %eax,0xc(%esi)
801032e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
801032ea:	89 46 10             	mov    %eax,0x10(%esi)
801032ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
801032f0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801032f3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801032fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032fd:	5b                   	pop    %ebx
801032fe:	5e                   	pop    %esi
801032ff:	5f                   	pop    %edi
80103300:	5d                   	pop    %ebp
80103301:	c3                   	ret    
80103302:	66 90                	xchg   %ax,%ax
80103304:	66 90                	xchg   %ax,%ax
80103306:	66 90                	xchg   %ax,%ax
80103308:	66 90                	xchg   %ax,%ax
8010330a:	66 90                	xchg   %ax,%ax
8010330c:	66 90                	xchg   %ax,%ax
8010330e:	66 90                	xchg   %ax,%ax

80103310 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103310:	8b 0d 28 97 11 80    	mov    0x80119728,%ecx
80103316:	85 c9                	test   %ecx,%ecx
80103318:	0f 8e 8a 00 00 00    	jle    801033a8 <install_trans+0x98>
{
8010331e:	55                   	push   %ebp
8010331f:	89 e5                	mov    %esp,%ebp
80103321:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103322:	31 ff                	xor    %edi,%edi
{
80103324:	56                   	push   %esi
80103325:	53                   	push   %ebx
80103326:	83 ec 0c             	sub    $0xc,%esp
80103329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103330:	a1 14 97 11 80       	mov    0x80119714,%eax
80103335:	83 ec 08             	sub    $0x8,%esp
80103338:	01 f8                	add    %edi,%eax
8010333a:	83 c0 01             	add    $0x1,%eax
8010333d:	50                   	push   %eax
8010333e:	ff 35 24 97 11 80    	pushl  0x80119724
80103344:	e8 87 cd ff ff       	call   801000d0 <bread>
80103349:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010334b:	58                   	pop    %eax
8010334c:	5a                   	pop    %edx
8010334d:	ff 34 bd 2c 97 11 80 	pushl  -0x7fee68d4(,%edi,4)
80103354:	ff 35 24 97 11 80    	pushl  0x80119724
  for (tail = 0; tail < log.lh.n; tail++) {
8010335a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010335d:	e8 6e cd ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103362:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103365:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103367:	8d 46 5c             	lea    0x5c(%esi),%eax
8010336a:	68 00 02 00 00       	push   $0x200
8010336f:	50                   	push   %eax
80103370:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103373:	50                   	push   %eax
80103374:	e8 17 1b 00 00       	call   80104e90 <memmove>
    bwrite(dbuf);  // write dst to disk
80103379:	89 1c 24             	mov    %ebx,(%esp)
8010337c:	e8 2f ce ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103381:	89 34 24             	mov    %esi,(%esp)
80103384:	e8 67 ce ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103389:	89 1c 24             	mov    %ebx,(%esp)
8010338c:	e8 5f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103391:	83 c4 10             	add    $0x10,%esp
80103394:	39 3d 28 97 11 80    	cmp    %edi,0x80119728
8010339a:	7f 94                	jg     80103330 <install_trans+0x20>
  }
}
8010339c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010339f:	5b                   	pop    %ebx
801033a0:	5e                   	pop    %esi
801033a1:	5f                   	pop    %edi
801033a2:	5d                   	pop    %ebp
801033a3:	c3                   	ret    
801033a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033a8:	c3                   	ret    
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801033b0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	53                   	push   %ebx
801033b4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801033b7:	ff 35 14 97 11 80    	pushl  0x80119714
801033bd:	ff 35 24 97 11 80    	pushl  0x80119724
801033c3:	e8 08 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801033c8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801033cb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801033cd:	a1 28 97 11 80       	mov    0x80119728,%eax
801033d2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801033d5:	85 c0                	test   %eax,%eax
801033d7:	7e 19                	jle    801033f2 <write_head+0x42>
801033d9:	31 d2                	xor    %edx,%edx
801033db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033df:	90                   	nop
    hb->block[i] = log.lh.block[i];
801033e0:	8b 0c 95 2c 97 11 80 	mov    -0x7fee68d4(,%edx,4),%ecx
801033e7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801033eb:	83 c2 01             	add    $0x1,%edx
801033ee:	39 d0                	cmp    %edx,%eax
801033f0:	75 ee                	jne    801033e0 <write_head+0x30>
  }
  bwrite(buf);
801033f2:	83 ec 0c             	sub    $0xc,%esp
801033f5:	53                   	push   %ebx
801033f6:	e8 b5 cd ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801033fb:	89 1c 24             	mov    %ebx,(%esp)
801033fe:	e8 ed cd ff ff       	call   801001f0 <brelse>
}
80103403:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103406:	83 c4 10             	add    $0x10,%esp
80103409:	c9                   	leave  
8010340a:	c3                   	ret    
8010340b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010340f:	90                   	nop

80103410 <initlog>:
{
80103410:	f3 0f 1e fb          	endbr32 
80103414:	55                   	push   %ebp
80103415:	89 e5                	mov    %esp,%ebp
80103417:	53                   	push   %ebx
80103418:	83 ec 2c             	sub    $0x2c,%esp
8010341b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010341e:	68 c0 81 10 80       	push   $0x801081c0
80103423:	68 e0 96 11 80       	push   $0x801196e0
80103428:	e8 33 17 00 00       	call   80104b60 <initlock>
  readsb(dev, &sb);
8010342d:	58                   	pop    %eax
8010342e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103431:	5a                   	pop    %edx
80103432:	50                   	push   %eax
80103433:	53                   	push   %ebx
80103434:	e8 47 e0 ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
80103439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010343c:	59                   	pop    %ecx
  log.dev = dev;
8010343d:	89 1d 24 97 11 80    	mov    %ebx,0x80119724
  log.size = sb.nlog;
80103443:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103446:	a3 14 97 11 80       	mov    %eax,0x80119714
  log.size = sb.nlog;
8010344b:	89 15 18 97 11 80    	mov    %edx,0x80119718
  struct buf *buf = bread(log.dev, log.start);
80103451:	5a                   	pop    %edx
80103452:	50                   	push   %eax
80103453:	53                   	push   %ebx
80103454:	e8 77 cc ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103459:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010345c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010345f:	89 0d 28 97 11 80    	mov    %ecx,0x80119728
  for (i = 0; i < log.lh.n; i++) {
80103465:	85 c9                	test   %ecx,%ecx
80103467:	7e 19                	jle    80103482 <initlog+0x72>
80103469:	31 d2                	xor    %edx,%edx
8010346b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010346f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103470:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103474:	89 1c 95 2c 97 11 80 	mov    %ebx,-0x7fee68d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010347b:	83 c2 01             	add    $0x1,%edx
8010347e:	39 d1                	cmp    %edx,%ecx
80103480:	75 ee                	jne    80103470 <initlog+0x60>
  brelse(buf);
80103482:	83 ec 0c             	sub    $0xc,%esp
80103485:	50                   	push   %eax
80103486:	e8 65 cd ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010348b:	e8 80 fe ff ff       	call   80103310 <install_trans>
  log.lh.n = 0;
80103490:	c7 05 28 97 11 80 00 	movl   $0x0,0x80119728
80103497:	00 00 00 
  write_head(); // clear the log
8010349a:	e8 11 ff ff ff       	call   801033b0 <write_head>
}
8010349f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801034a2:	83 c4 10             	add    $0x10,%esp
801034a5:	c9                   	leave  
801034a6:	c3                   	ret    
801034a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801034b0:	f3 0f 1e fb          	endbr32 
801034b4:	55                   	push   %ebp
801034b5:	89 e5                	mov    %esp,%ebp
801034b7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801034ba:	68 e0 96 11 80       	push   $0x801196e0
801034bf:	e8 1c 18 00 00       	call   80104ce0 <acquire>
801034c4:	83 c4 10             	add    $0x10,%esp
801034c7:	eb 1c                	jmp    801034e5 <begin_op+0x35>
801034c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801034d0:	83 ec 08             	sub    $0x8,%esp
801034d3:	68 e0 96 11 80       	push   $0x801196e0
801034d8:	68 e0 96 11 80       	push   $0x801196e0
801034dd:	e8 be 11 00 00       	call   801046a0 <sleep>
801034e2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801034e5:	a1 20 97 11 80       	mov    0x80119720,%eax
801034ea:	85 c0                	test   %eax,%eax
801034ec:	75 e2                	jne    801034d0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034ee:	a1 1c 97 11 80       	mov    0x8011971c,%eax
801034f3:	8b 15 28 97 11 80    	mov    0x80119728,%edx
801034f9:	83 c0 01             	add    $0x1,%eax
801034fc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801034ff:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103502:	83 fa 1e             	cmp    $0x1e,%edx
80103505:	7f c9                	jg     801034d0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103507:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010350a:	a3 1c 97 11 80       	mov    %eax,0x8011971c
      release(&log.lock);
8010350f:	68 e0 96 11 80       	push   $0x801196e0
80103514:	e8 87 18 00 00       	call   80104da0 <release>
      break;
    }
  }
}
80103519:	83 c4 10             	add    $0x10,%esp
8010351c:	c9                   	leave  
8010351d:	c3                   	ret    
8010351e:	66 90                	xchg   %ax,%ax

80103520 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103520:	f3 0f 1e fb          	endbr32 
80103524:	55                   	push   %ebp
80103525:	89 e5                	mov    %esp,%ebp
80103527:	57                   	push   %edi
80103528:	56                   	push   %esi
80103529:	53                   	push   %ebx
8010352a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010352d:	68 e0 96 11 80       	push   $0x801196e0
80103532:	e8 a9 17 00 00       	call   80104ce0 <acquire>
  log.outstanding -= 1;
80103537:	a1 1c 97 11 80       	mov    0x8011971c,%eax
  if(log.committing)
8010353c:	8b 35 20 97 11 80    	mov    0x80119720,%esi
80103542:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103545:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103548:	89 1d 1c 97 11 80    	mov    %ebx,0x8011971c
  if(log.committing)
8010354e:	85 f6                	test   %esi,%esi
80103550:	0f 85 1e 01 00 00    	jne    80103674 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103556:	85 db                	test   %ebx,%ebx
80103558:	0f 85 f2 00 00 00    	jne    80103650 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010355e:	c7 05 20 97 11 80 01 	movl   $0x1,0x80119720
80103565:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103568:	83 ec 0c             	sub    $0xc,%esp
8010356b:	68 e0 96 11 80       	push   $0x801196e0
80103570:	e8 2b 18 00 00       	call   80104da0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103575:	8b 0d 28 97 11 80    	mov    0x80119728,%ecx
8010357b:	83 c4 10             	add    $0x10,%esp
8010357e:	85 c9                	test   %ecx,%ecx
80103580:	7f 3e                	jg     801035c0 <end_op+0xa0>
    acquire(&log.lock);
80103582:	83 ec 0c             	sub    $0xc,%esp
80103585:	68 e0 96 11 80       	push   $0x801196e0
8010358a:	e8 51 17 00 00       	call   80104ce0 <acquire>
    wakeup(&log);
8010358f:	c7 04 24 e0 96 11 80 	movl   $0x801196e0,(%esp)
    log.committing = 0;
80103596:	c7 05 20 97 11 80 00 	movl   $0x0,0x80119720
8010359d:	00 00 00 
    wakeup(&log);
801035a0:	e8 bb 12 00 00       	call   80104860 <wakeup>
    release(&log.lock);
801035a5:	c7 04 24 e0 96 11 80 	movl   $0x801196e0,(%esp)
801035ac:	e8 ef 17 00 00       	call   80104da0 <release>
801035b1:	83 c4 10             	add    $0x10,%esp
}
801035b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035b7:	5b                   	pop    %ebx
801035b8:	5e                   	pop    %esi
801035b9:	5f                   	pop    %edi
801035ba:	5d                   	pop    %ebp
801035bb:	c3                   	ret    
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801035c0:	a1 14 97 11 80       	mov    0x80119714,%eax
801035c5:	83 ec 08             	sub    $0x8,%esp
801035c8:	01 d8                	add    %ebx,%eax
801035ca:	83 c0 01             	add    $0x1,%eax
801035cd:	50                   	push   %eax
801035ce:	ff 35 24 97 11 80    	pushl  0x80119724
801035d4:	e8 f7 ca ff ff       	call   801000d0 <bread>
801035d9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801035db:	58                   	pop    %eax
801035dc:	5a                   	pop    %edx
801035dd:	ff 34 9d 2c 97 11 80 	pushl  -0x7fee68d4(,%ebx,4)
801035e4:	ff 35 24 97 11 80    	pushl  0x80119724
  for (tail = 0; tail < log.lh.n; tail++) {
801035ea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801035ed:	e8 de ca ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801035f2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801035f5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801035f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801035fa:	68 00 02 00 00       	push   $0x200
801035ff:	50                   	push   %eax
80103600:	8d 46 5c             	lea    0x5c(%esi),%eax
80103603:	50                   	push   %eax
80103604:	e8 87 18 00 00       	call   80104e90 <memmove>
    bwrite(to);  // write the log
80103609:	89 34 24             	mov    %esi,(%esp)
8010360c:	e8 9f cb ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103611:	89 3c 24             	mov    %edi,(%esp)
80103614:	e8 d7 cb ff ff       	call   801001f0 <brelse>
    brelse(to);
80103619:	89 34 24             	mov    %esi,(%esp)
8010361c:	e8 cf cb ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103621:	83 c4 10             	add    $0x10,%esp
80103624:	3b 1d 28 97 11 80    	cmp    0x80119728,%ebx
8010362a:	7c 94                	jl     801035c0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010362c:	e8 7f fd ff ff       	call   801033b0 <write_head>
    install_trans(); // Now install writes to home locations
80103631:	e8 da fc ff ff       	call   80103310 <install_trans>
    log.lh.n = 0;
80103636:	c7 05 28 97 11 80 00 	movl   $0x0,0x80119728
8010363d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103640:	e8 6b fd ff ff       	call   801033b0 <write_head>
80103645:	e9 38 ff ff ff       	jmp    80103582 <end_op+0x62>
8010364a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	68 e0 96 11 80       	push   $0x801196e0
80103658:	e8 03 12 00 00       	call   80104860 <wakeup>
  release(&log.lock);
8010365d:	c7 04 24 e0 96 11 80 	movl   $0x801196e0,(%esp)
80103664:	e8 37 17 00 00       	call   80104da0 <release>
80103669:	83 c4 10             	add    $0x10,%esp
}
8010366c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010366f:	5b                   	pop    %ebx
80103670:	5e                   	pop    %esi
80103671:	5f                   	pop    %edi
80103672:	5d                   	pop    %ebp
80103673:	c3                   	ret    
    panic("log.committing");
80103674:	83 ec 0c             	sub    $0xc,%esp
80103677:	68 c4 81 10 80       	push   $0x801081c4
8010367c:	e8 0f cd ff ff       	call   80100390 <panic>
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010368f:	90                   	nop

80103690 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103690:	f3 0f 1e fb          	endbr32 
80103694:	55                   	push   %ebp
80103695:	89 e5                	mov    %esp,%ebp
80103697:	53                   	push   %ebx
80103698:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010369b:	8b 15 28 97 11 80    	mov    0x80119728,%edx
{
801036a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036a4:	83 fa 1d             	cmp    $0x1d,%edx
801036a7:	0f 8f 91 00 00 00    	jg     8010373e <log_write+0xae>
801036ad:	a1 18 97 11 80       	mov    0x80119718,%eax
801036b2:	83 e8 01             	sub    $0x1,%eax
801036b5:	39 c2                	cmp    %eax,%edx
801036b7:	0f 8d 81 00 00 00    	jge    8010373e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801036bd:	a1 1c 97 11 80       	mov    0x8011971c,%eax
801036c2:	85 c0                	test   %eax,%eax
801036c4:	0f 8e 81 00 00 00    	jle    8010374b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801036ca:	83 ec 0c             	sub    $0xc,%esp
801036cd:	68 e0 96 11 80       	push   $0x801196e0
801036d2:	e8 09 16 00 00       	call   80104ce0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801036d7:	8b 15 28 97 11 80    	mov    0x80119728,%edx
801036dd:	83 c4 10             	add    $0x10,%esp
801036e0:	85 d2                	test   %edx,%edx
801036e2:	7e 4e                	jle    80103732 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801036e4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801036e7:	31 c0                	xor    %eax,%eax
801036e9:	eb 0c                	jmp    801036f7 <log_write+0x67>
801036eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036ef:	90                   	nop
801036f0:	83 c0 01             	add    $0x1,%eax
801036f3:	39 c2                	cmp    %eax,%edx
801036f5:	74 29                	je     80103720 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801036f7:	39 0c 85 2c 97 11 80 	cmp    %ecx,-0x7fee68d4(,%eax,4)
801036fe:	75 f0                	jne    801036f0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103700:	89 0c 85 2c 97 11 80 	mov    %ecx,-0x7fee68d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103707:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010370a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010370d:	c7 45 08 e0 96 11 80 	movl   $0x801196e0,0x8(%ebp)
}
80103714:	c9                   	leave  
  release(&log.lock);
80103715:	e9 86 16 00 00       	jmp    80104da0 <release>
8010371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103720:	89 0c 95 2c 97 11 80 	mov    %ecx,-0x7fee68d4(,%edx,4)
    log.lh.n++;
80103727:	83 c2 01             	add    $0x1,%edx
8010372a:	89 15 28 97 11 80    	mov    %edx,0x80119728
80103730:	eb d5                	jmp    80103707 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103732:	8b 43 08             	mov    0x8(%ebx),%eax
80103735:	a3 2c 97 11 80       	mov    %eax,0x8011972c
  if (i == log.lh.n)
8010373a:	75 cb                	jne    80103707 <log_write+0x77>
8010373c:	eb e9                	jmp    80103727 <log_write+0x97>
    panic("too big a transaction");
8010373e:	83 ec 0c             	sub    $0xc,%esp
80103741:	68 d3 81 10 80       	push   $0x801081d3
80103746:	e8 45 cc ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010374b:	83 ec 0c             	sub    $0xc,%esp
8010374e:	68 e9 81 10 80       	push   $0x801081e9
80103753:	e8 38 cc ff ff       	call   80100390 <panic>
80103758:	66 90                	xchg   %ax,%ax
8010375a:	66 90                	xchg   %ax,%ax
8010375c:	66 90                	xchg   %ax,%ax
8010375e:	66 90                	xchg   %ax,%ax

80103760 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	53                   	push   %ebx
80103764:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103767:	e8 64 09 00 00       	call   801040d0 <cpuid>
8010376c:	89 c3                	mov    %eax,%ebx
8010376e:	e8 5d 09 00 00       	call   801040d0 <cpuid>
80103773:	83 ec 04             	sub    $0x4,%esp
80103776:	53                   	push   %ebx
80103777:	50                   	push   %eax
80103778:	68 04 82 10 80       	push   $0x80108204
8010377d:	e8 2e cf ff ff       	call   801006b0 <cprintf>
  idtinit();                    // load idt register
80103782:	e8 39 2a 00 00       	call   801061c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103787:	e8 d4 08 00 00       	call   80104060 <mycpu>
8010378c:	89 c2                	mov    %eax,%edx
  asm volatile("lock; xchgl %0, %1" :
8010378e:	b8 01 00 00 00       	mov    $0x1,%eax
80103793:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();                  // start running processes
8010379a:	e8 31 0c 00 00       	call   801043d0 <scheduler>
8010379f:	90                   	nop

801037a0 <mpenter>:
{
801037a0:	f3 0f 1e fb          	endbr32 
801037a4:	55                   	push   %ebp
801037a5:	89 e5                	mov    %esp,%ebp
801037a7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801037aa:	e8 61 3b 00 00       	call   80107310 <switchkvm>
  seginit();
801037af:	e8 cc 38 00 00       	call   80107080 <seginit>
  lapicinit();
801037b4:	e8 67 f7 ff ff       	call   80102f20 <lapicinit>
  mpmain();
801037b9:	e8 a2 ff ff ff       	call   80103760 <mpmain>
801037be:	66 90                	xchg   %ax,%ax

801037c0 <main>:
{
801037c0:	f3 0f 1e fb          	endbr32 
801037c4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801037c8:	83 e4 f0             	and    $0xfffffff0,%esp
801037cb:	ff 71 fc             	pushl  -0x4(%ecx)
801037ce:	55                   	push   %ebp
801037cf:	89 e5                	mov    %esp,%ebp
801037d1:	53                   	push   %ebx
801037d2:	51                   	push   %ecx
  kinit1(end, P2V(4 * 1024 * 1024));          // phys page allocator
801037d3:	83 ec 08             	sub    $0x8,%esp
801037d6:	68 00 00 40 80       	push   $0x80400000
801037db:	68 08 c5 11 80       	push   $0x8011c508
801037e0:	e8 eb ee ff ff       	call   801026d0 <kinit1>
  kvmalloc();                                 // kernel page table
801037e5:	e8 26 40 00 00       	call   80107810 <kvmalloc>
  mpinit();                                   // detect other processors
801037ea:	e8 91 01 00 00       	call   80103980 <mpinit>
  lapicinit();                                // interrupt controller
801037ef:	e8 2c f7 ff ff       	call   80102f20 <lapicinit>
  seginit();                                  // segment descriptors
801037f4:	e8 87 38 00 00       	call   80107080 <seginit>
  picinit();                                  // disable pic
801037f9:	e8 62 03 00 00       	call   80103b60 <picinit>
  ioapicinit();                               // another interrupt controller
801037fe:	e8 8d ec ff ff       	call   80102490 <ioapicinit>
  consoleinit();                              // console hardware
80103803:	e8 28 d2 ff ff       	call   80100a30 <consoleinit>
  uartinit();                                 // serial port
80103808:	e8 f3 2c 00 00       	call   80106500 <uartinit>
  pinit();                                    // process table
8010380d:	e8 2e 08 00 00       	call   80104040 <pinit>
  tvinit();                                   // trap vectors
80103812:	e8 29 29 00 00       	call   80106140 <tvinit>
  binit();                                    // buffer cache
80103817:	e8 24 c8 ff ff       	call   80100040 <binit>
  fileinit();                                 // file table
8010381c:	e8 bf d5 ff ff       	call   80100de0 <fileinit>
  ideinit();                                  // disk
80103821:	e8 3a ea ff ff       	call   80102260 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103826:	83 c4 0c             	add    $0xc,%esp
80103829:	68 8a 00 00 00       	push   $0x8a
8010382e:	68 8c b4 10 80       	push   $0x8010b48c
80103833:	68 00 70 00 80       	push   $0x80007000
80103838:	e8 53 16 00 00       	call   80104e90 <memmove>

  for (c = cpus; c < cpus + ncpu; c++)
8010383d:	83 c4 10             	add    $0x10,%esp
80103840:	69 05 60 9d 11 80 b0 	imul   $0xb0,0x80119d60,%eax
80103847:	00 00 00 
8010384a:	05 e0 97 11 80       	add    $0x801197e0,%eax
8010384f:	3d e0 97 11 80       	cmp    $0x801197e0,%eax
80103854:	76 7a                	jbe    801038d0 <main+0x110>
80103856:	bb e0 97 11 80       	mov    $0x801197e0,%ebx
8010385b:	eb 1c                	jmp    80103879 <main+0xb9>
8010385d:	8d 76 00             	lea    0x0(%esi),%esi
80103860:	69 05 60 9d 11 80 b0 	imul   $0xb0,0x80119d60,%eax
80103867:	00 00 00 
8010386a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103870:	05 e0 97 11 80       	add    $0x801197e0,%eax
80103875:	39 c3                	cmp    %eax,%ebx
80103877:	73 57                	jae    801038d0 <main+0x110>
  {
    if (c == mycpu()) // We've started already.
80103879:	e8 e2 07 00 00       	call   80104060 <mycpu>
8010387e:	39 c3                	cmp    %eax,%ebx
80103880:	74 de                	je     80103860 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103882:	e8 a9 f3 ff ff       	call   80102c30 <kalloc>
    *(void **)(code - 4) = stack + KSTACKSIZE;
    *(void (**)(void))(code - 8) = mpenter;
    *(int **)(code - 12) = (void *)V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103887:	83 ec 08             	sub    $0x8,%esp
    *(void (**)(void))(code - 8) = mpenter;
8010388a:	c7 05 f8 6f 00 80 a0 	movl   $0x801037a0,0x80006ff8
80103891:	37 10 80 
    *(int **)(code - 12) = (void *)V2P(entrypgdir);
80103894:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010389b:	a0 10 00 
    *(void **)(code - 4) = stack + KSTACKSIZE;
8010389e:	05 00 10 00 00       	add    $0x1000,%eax
801038a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801038a8:	0f b6 03             	movzbl (%ebx),%eax
801038ab:	68 00 70 00 00       	push   $0x7000
801038b0:	50                   	push   %eax
801038b1:	e8 ba f7 ff ff       	call   80103070 <lapicstartap>

    // wait for cpu to finish mpmain()
    while (c->started == 0)
801038b6:	83 c4 10             	add    $0x10,%esp
801038b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801038c6:	85 c0                	test   %eax,%eax
801038c8:	74 f6                	je     801038c0 <main+0x100>
801038ca:	eb 94                	jmp    80103860 <main+0xa0>
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
801038d0:	83 ec 08             	sub    $0x8,%esp
801038d3:	68 00 00 40 80       	push   $0x80400000
801038d8:	68 00 00 40 80       	push   $0x80400000
801038dd:	e8 be ee ff ff       	call   801027a0 <kinit2>
  userinit();                                 // first user process
801038e2:	e8 39 08 00 00       	call   80104120 <userinit>
  lru_print();                                // lru linkedlist print
801038e7:	e8 34 ef ff ff       	call   80102820 <lru_print>
  mpmain();                                   // finish this processor's setup
801038ec:	e8 6f fe ff ff       	call   80103760 <mpmain>
801038f1:	66 90                	xchg   %ax,%ax
801038f3:	66 90                	xchg   %ax,%ax
801038f5:	66 90                	xchg   %ax,%ax
801038f7:	66 90                	xchg   %ax,%ax
801038f9:	66 90                	xchg   %ax,%ax
801038fb:	66 90                	xchg   %ax,%ax
801038fd:	66 90                	xchg   %ax,%ax
801038ff:	90                   	nop

80103900 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103905:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010390b:	53                   	push   %ebx
  e = addr+len;
8010390c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010390f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103912:	39 de                	cmp    %ebx,%esi
80103914:	72 10                	jb     80103926 <mpsearch1+0x26>
80103916:	eb 50                	jmp    80103968 <mpsearch1+0x68>
80103918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010391f:	90                   	nop
80103920:	89 fe                	mov    %edi,%esi
80103922:	39 fb                	cmp    %edi,%ebx
80103924:	76 42                	jbe    80103968 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103926:	83 ec 04             	sub    $0x4,%esp
80103929:	8d 7e 10             	lea    0x10(%esi),%edi
8010392c:	6a 04                	push   $0x4
8010392e:	68 18 82 10 80       	push   $0x80108218
80103933:	56                   	push   %esi
80103934:	e8 07 15 00 00       	call   80104e40 <memcmp>
80103939:	83 c4 10             	add    $0x10,%esp
8010393c:	85 c0                	test   %eax,%eax
8010393e:	75 e0                	jne    80103920 <mpsearch1+0x20>
80103940:	89 f2                	mov    %esi,%edx
80103942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103948:	0f b6 0a             	movzbl (%edx),%ecx
8010394b:	83 c2 01             	add    $0x1,%edx
8010394e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103950:	39 fa                	cmp    %edi,%edx
80103952:	75 f4                	jne    80103948 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103954:	84 c0                	test   %al,%al
80103956:	75 c8                	jne    80103920 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103958:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010395b:	89 f0                	mov    %esi,%eax
8010395d:	5b                   	pop    %ebx
8010395e:	5e                   	pop    %esi
8010395f:	5f                   	pop    %edi
80103960:	5d                   	pop    %ebp
80103961:	c3                   	ret    
80103962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103968:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010396b:	31 f6                	xor    %esi,%esi
}
8010396d:	5b                   	pop    %ebx
8010396e:	89 f0                	mov    %esi,%eax
80103970:	5e                   	pop    %esi
80103971:	5f                   	pop    %edi
80103972:	5d                   	pop    %ebp
80103973:	c3                   	ret    
80103974:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010397b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010397f:	90                   	nop

80103980 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103980:	f3 0f 1e fb          	endbr32 
80103984:	55                   	push   %ebp
80103985:	89 e5                	mov    %esp,%ebp
80103987:	57                   	push   %edi
80103988:	56                   	push   %esi
80103989:	53                   	push   %ebx
8010398a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010398d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103994:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010399b:	c1 e0 08             	shl    $0x8,%eax
8010399e:	09 d0                	or     %edx,%eax
801039a0:	c1 e0 04             	shl    $0x4,%eax
801039a3:	75 1b                	jne    801039c0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801039a5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801039ac:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801039b3:	c1 e0 08             	shl    $0x8,%eax
801039b6:	09 d0                	or     %edx,%eax
801039b8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801039bb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801039c0:	ba 00 04 00 00       	mov    $0x400,%edx
801039c5:	e8 36 ff ff ff       	call   80103900 <mpsearch1>
801039ca:	89 c6                	mov    %eax,%esi
801039cc:	85 c0                	test   %eax,%eax
801039ce:	0f 84 4c 01 00 00    	je     80103b20 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801039d4:	8b 5e 04             	mov    0x4(%esi),%ebx
801039d7:	85 db                	test   %ebx,%ebx
801039d9:	0f 84 61 01 00 00    	je     80103b40 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801039df:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801039e2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801039e8:	6a 04                	push   $0x4
801039ea:	68 1d 82 10 80       	push   $0x8010821d
801039ef:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801039f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801039f3:	e8 48 14 00 00       	call   80104e40 <memcmp>
801039f8:	83 c4 10             	add    $0x10,%esp
801039fb:	85 c0                	test   %eax,%eax
801039fd:	0f 85 3d 01 00 00    	jne    80103b40 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103a03:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103a0a:	3c 01                	cmp    $0x1,%al
80103a0c:	74 08                	je     80103a16 <mpinit+0x96>
80103a0e:	3c 04                	cmp    $0x4,%al
80103a10:	0f 85 2a 01 00 00    	jne    80103b40 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103a16:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103a1d:	66 85 d2             	test   %dx,%dx
80103a20:	74 26                	je     80103a48 <mpinit+0xc8>
80103a22:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103a25:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103a27:	31 d2                	xor    %edx,%edx
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103a30:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103a37:	83 c0 01             	add    $0x1,%eax
80103a3a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103a3c:	39 f8                	cmp    %edi,%eax
80103a3e:	75 f0                	jne    80103a30 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103a40:	84 d2                	test   %dl,%dl
80103a42:	0f 85 f8 00 00 00    	jne    80103b40 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103a48:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103a4e:	a3 c0 96 11 80       	mov    %eax,0x801196c0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a53:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103a59:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103a60:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a65:	03 55 e4             	add    -0x1c(%ebp),%edx
80103a68:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a6f:	90                   	nop
80103a70:	39 c2                	cmp    %eax,%edx
80103a72:	76 15                	jbe    80103a89 <mpinit+0x109>
    switch(*p){
80103a74:	0f b6 08             	movzbl (%eax),%ecx
80103a77:	80 f9 02             	cmp    $0x2,%cl
80103a7a:	74 5c                	je     80103ad8 <mpinit+0x158>
80103a7c:	77 42                	ja     80103ac0 <mpinit+0x140>
80103a7e:	84 c9                	test   %cl,%cl
80103a80:	74 6e                	je     80103af0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103a82:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a85:	39 c2                	cmp    %eax,%edx
80103a87:	77 eb                	ja     80103a74 <mpinit+0xf4>
80103a89:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103a8c:	85 db                	test   %ebx,%ebx
80103a8e:	0f 84 b9 00 00 00    	je     80103b4d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103a94:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103a98:	74 15                	je     80103aaf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a9a:	b8 70 00 00 00       	mov    $0x70,%eax
80103a9f:	ba 22 00 00 00       	mov    $0x22,%edx
80103aa4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103aa5:	ba 23 00 00 00       	mov    $0x23,%edx
80103aaa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103aab:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103aae:	ee                   	out    %al,(%dx)
  }
}
80103aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ab2:	5b                   	pop    %ebx
80103ab3:	5e                   	pop    %esi
80103ab4:	5f                   	pop    %edi
80103ab5:	5d                   	pop    %ebp
80103ab6:	c3                   	ret    
80103ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103abe:	66 90                	xchg   %ax,%ax
    switch(*p){
80103ac0:	83 e9 03             	sub    $0x3,%ecx
80103ac3:	80 f9 01             	cmp    $0x1,%cl
80103ac6:	76 ba                	jbe    80103a82 <mpinit+0x102>
80103ac8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103acf:	eb 9f                	jmp    80103a70 <mpinit+0xf0>
80103ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103ad8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103adc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103adf:	88 0d c0 97 11 80    	mov    %cl,0x801197c0
      continue;
80103ae5:	eb 89                	jmp    80103a70 <mpinit+0xf0>
80103ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aee:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103af0:	8b 0d 60 9d 11 80    	mov    0x80119d60,%ecx
80103af6:	83 f9 07             	cmp    $0x7,%ecx
80103af9:	7f 19                	jg     80103b14 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103afb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103b01:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103b05:	83 c1 01             	add    $0x1,%ecx
80103b08:	89 0d 60 9d 11 80    	mov    %ecx,0x80119d60
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b0e:	88 9f e0 97 11 80    	mov    %bl,-0x7fee6820(%edi)
      p += sizeof(struct mpproc);
80103b14:	83 c0 14             	add    $0x14,%eax
      continue;
80103b17:	e9 54 ff ff ff       	jmp    80103a70 <mpinit+0xf0>
80103b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103b20:	ba 00 00 01 00       	mov    $0x10000,%edx
80103b25:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103b2a:	e8 d1 fd ff ff       	call   80103900 <mpsearch1>
80103b2f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b31:	85 c0                	test   %eax,%eax
80103b33:	0f 85 9b fe ff ff    	jne    801039d4 <mpinit+0x54>
80103b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103b40:	83 ec 0c             	sub    $0xc,%esp
80103b43:	68 22 82 10 80       	push   $0x80108222
80103b48:	e8 43 c8 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103b4d:	83 ec 0c             	sub    $0xc,%esp
80103b50:	68 3c 82 10 80       	push   $0x8010823c
80103b55:	e8 36 c8 ff ff       	call   80100390 <panic>
80103b5a:	66 90                	xchg   %ax,%ax
80103b5c:	66 90                	xchg   %ax,%ax
80103b5e:	66 90                	xchg   %ax,%ax

80103b60 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103b60:	f3 0f 1e fb          	endbr32 
80103b64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b69:	ba 21 00 00 00       	mov    $0x21,%edx
80103b6e:	ee                   	out    %al,(%dx)
80103b6f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103b74:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103b75:	c3                   	ret    
80103b76:	66 90                	xchg   %ax,%ax
80103b78:	66 90                	xchg   %ax,%ax
80103b7a:	66 90                	xchg   %ax,%ax
80103b7c:	66 90                	xchg   %ax,%ax
80103b7e:	66 90                	xchg   %ax,%ax

80103b80 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103b80:	f3 0f 1e fb          	endbr32 
80103b84:	55                   	push   %ebp
80103b85:	89 e5                	mov    %esp,%ebp
80103b87:	57                   	push   %edi
80103b88:	56                   	push   %esi
80103b89:	53                   	push   %ebx
80103b8a:	83 ec 0c             	sub    $0xc,%esp
80103b8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b90:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103b93:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103b99:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103b9f:	e8 5c d2 ff ff       	call   80100e00 <filealloc>
80103ba4:	89 03                	mov    %eax,(%ebx)
80103ba6:	85 c0                	test   %eax,%eax
80103ba8:	0f 84 ac 00 00 00    	je     80103c5a <pipealloc+0xda>
80103bae:	e8 4d d2 ff ff       	call   80100e00 <filealloc>
80103bb3:	89 06                	mov    %eax,(%esi)
80103bb5:	85 c0                	test   %eax,%eax
80103bb7:	0f 84 8b 00 00 00    	je     80103c48 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103bbd:	e8 6e f0 ff ff       	call   80102c30 <kalloc>
80103bc2:	89 c7                	mov    %eax,%edi
80103bc4:	85 c0                	test   %eax,%eax
80103bc6:	0f 84 b4 00 00 00    	je     80103c80 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103bcc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103bd3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103bd6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103bd9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103be0:	00 00 00 
  p->nwrite = 0;
80103be3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103bea:	00 00 00 
  p->nread = 0;
80103bed:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103bf4:	00 00 00 
  initlock(&p->lock, "pipe");
80103bf7:	68 5b 82 10 80       	push   $0x8010825b
80103bfc:	50                   	push   %eax
80103bfd:	e8 5e 0f 00 00       	call   80104b60 <initlock>
  (*f0)->type = FD_PIPE;
80103c02:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103c04:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103c07:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103c0d:	8b 03                	mov    (%ebx),%eax
80103c0f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103c13:	8b 03                	mov    (%ebx),%eax
80103c15:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103c19:	8b 03                	mov    (%ebx),%eax
80103c1b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103c1e:	8b 06                	mov    (%esi),%eax
80103c20:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103c26:	8b 06                	mov    (%esi),%eax
80103c28:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103c2c:	8b 06                	mov    (%esi),%eax
80103c2e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103c32:	8b 06                	mov    (%esi),%eax
80103c34:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103c3a:	31 c0                	xor    %eax,%eax
}
80103c3c:	5b                   	pop    %ebx
80103c3d:	5e                   	pop    %esi
80103c3e:	5f                   	pop    %edi
80103c3f:	5d                   	pop    %ebp
80103c40:	c3                   	ret    
80103c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103c48:	8b 03                	mov    (%ebx),%eax
80103c4a:	85 c0                	test   %eax,%eax
80103c4c:	74 1e                	je     80103c6c <pipealloc+0xec>
    fileclose(*f0);
80103c4e:	83 ec 0c             	sub    $0xc,%esp
80103c51:	50                   	push   %eax
80103c52:	e8 69 d2 ff ff       	call   80100ec0 <fileclose>
80103c57:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103c5a:	8b 06                	mov    (%esi),%eax
80103c5c:	85 c0                	test   %eax,%eax
80103c5e:	74 0c                	je     80103c6c <pipealloc+0xec>
    fileclose(*f1);
80103c60:	83 ec 0c             	sub    $0xc,%esp
80103c63:	50                   	push   %eax
80103c64:	e8 57 d2 ff ff       	call   80100ec0 <fileclose>
80103c69:	83 c4 10             	add    $0x10,%esp
}
80103c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103c6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103c74:	5b                   	pop    %ebx
80103c75:	5e                   	pop    %esi
80103c76:	5f                   	pop    %edi
80103c77:	5d                   	pop    %ebp
80103c78:	c3                   	ret    
80103c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103c80:	8b 03                	mov    (%ebx),%eax
80103c82:	85 c0                	test   %eax,%eax
80103c84:	75 c8                	jne    80103c4e <pipealloc+0xce>
80103c86:	eb d2                	jmp    80103c5a <pipealloc+0xda>
80103c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8f:	90                   	nop

80103c90 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103c90:	f3 0f 1e fb          	endbr32 
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	56                   	push   %esi
80103c98:	53                   	push   %ebx
80103c99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103c9f:	83 ec 0c             	sub    $0xc,%esp
80103ca2:	53                   	push   %ebx
80103ca3:	e8 38 10 00 00       	call   80104ce0 <acquire>
  if(writable){
80103ca8:	83 c4 10             	add    $0x10,%esp
80103cab:	85 f6                	test   %esi,%esi
80103cad:	74 41                	je     80103cf0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103caf:	83 ec 0c             	sub    $0xc,%esp
80103cb2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103cb8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103cbf:	00 00 00 
    wakeup(&p->nread);
80103cc2:	50                   	push   %eax
80103cc3:	e8 98 0b 00 00       	call   80104860 <wakeup>
80103cc8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103ccb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103cd1:	85 d2                	test   %edx,%edx
80103cd3:	75 0a                	jne    80103cdf <pipeclose+0x4f>
80103cd5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103cdb:	85 c0                	test   %eax,%eax
80103cdd:	74 31                	je     80103d10 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103cdf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103ce2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ce5:	5b                   	pop    %ebx
80103ce6:	5e                   	pop    %esi
80103ce7:	5d                   	pop    %ebp
    release(&p->lock);
80103ce8:	e9 b3 10 00 00       	jmp    80104da0 <release>
80103ced:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103cf0:	83 ec 0c             	sub    $0xc,%esp
80103cf3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103cf9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103d00:	00 00 00 
    wakeup(&p->nwrite);
80103d03:	50                   	push   %eax
80103d04:	e8 57 0b 00 00       	call   80104860 <wakeup>
80103d09:	83 c4 10             	add    $0x10,%esp
80103d0c:	eb bd                	jmp    80103ccb <pipeclose+0x3b>
80103d0e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103d10:	83 ec 0c             	sub    $0xc,%esp
80103d13:	53                   	push   %ebx
80103d14:	e8 87 10 00 00       	call   80104da0 <release>
    kfree((char*)p);
80103d19:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103d1c:	83 c4 10             	add    $0x10,%esp
}
80103d1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d22:	5b                   	pop    %ebx
80103d23:	5e                   	pop    %esi
80103d24:	5d                   	pop    %ebp
    kfree((char*)p);
80103d25:	e9 56 e8 ff ff       	jmp    80102580 <kfree>
80103d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d30 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
80103d30:	f3 0f 1e fb          	endbr32 
80103d34:	55                   	push   %ebp
80103d35:	89 e5                	mov    %esp,%ebp
80103d37:	57                   	push   %edi
80103d38:	56                   	push   %esi
80103d39:	53                   	push   %ebx
80103d3a:	83 ec 28             	sub    $0x28,%esp
80103d3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103d40:	53                   	push   %ebx
80103d41:	e8 9a 0f 00 00       	call   80104ce0 <acquire>
  for(i = 0; i < n; i++){
80103d46:	8b 45 10             	mov    0x10(%ebp),%eax
80103d49:	83 c4 10             	add    $0x10,%esp
80103d4c:	85 c0                	test   %eax,%eax
80103d4e:	0f 8e bc 00 00 00    	jle    80103e10 <pipewrite+0xe0>
80103d54:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d57:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103d5d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103d63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d66:	03 45 10             	add    0x10(%ebp),%eax
80103d69:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103d6c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103d72:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103d78:	89 ca                	mov    %ecx,%edx
80103d7a:	05 00 02 00 00       	add    $0x200,%eax
80103d7f:	39 c1                	cmp    %eax,%ecx
80103d81:	74 3b                	je     80103dbe <pipewrite+0x8e>
80103d83:	eb 63                	jmp    80103de8 <pipewrite+0xb8>
80103d85:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103d88:	e8 63 03 00 00       	call   801040f0 <myproc>
80103d8d:	8b 48 24             	mov    0x24(%eax),%ecx
80103d90:	85 c9                	test   %ecx,%ecx
80103d92:	75 34                	jne    80103dc8 <pipewrite+0x98>
      wakeup(&p->nread);
80103d94:	83 ec 0c             	sub    $0xc,%esp
80103d97:	57                   	push   %edi
80103d98:	e8 c3 0a 00 00       	call   80104860 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103d9d:	58                   	pop    %eax
80103d9e:	5a                   	pop    %edx
80103d9f:	53                   	push   %ebx
80103da0:	56                   	push   %esi
80103da1:	e8 fa 08 00 00       	call   801046a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103da6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103dac:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103db2:	83 c4 10             	add    $0x10,%esp
80103db5:	05 00 02 00 00       	add    $0x200,%eax
80103dba:	39 c2                	cmp    %eax,%edx
80103dbc:	75 2a                	jne    80103de8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103dbe:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103dc4:	85 c0                	test   %eax,%eax
80103dc6:	75 c0                	jne    80103d88 <pipewrite+0x58>
        release(&p->lock);
80103dc8:	83 ec 0c             	sub    $0xc,%esp
80103dcb:	53                   	push   %ebx
80103dcc:	e8 cf 0f 00 00       	call   80104da0 <release>
        return -1;
80103dd1:	83 c4 10             	add    $0x10,%esp
80103dd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ddc:	5b                   	pop    %ebx
80103ddd:	5e                   	pop    %esi
80103dde:	5f                   	pop    %edi
80103ddf:	5d                   	pop    %ebp
80103de0:	c3                   	ret    
80103de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103de8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103deb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103dee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103df4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103dfa:	0f b6 06             	movzbl (%esi),%eax
80103dfd:	83 c6 01             	add    $0x1,%esi
80103e00:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103e03:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103e07:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103e0a:	0f 85 5c ff ff ff    	jne    80103d6c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e10:	83 ec 0c             	sub    $0xc,%esp
80103e13:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103e19:	50                   	push   %eax
80103e1a:	e8 41 0a 00 00       	call   80104860 <wakeup>
  release(&p->lock);
80103e1f:	89 1c 24             	mov    %ebx,(%esp)
80103e22:	e8 79 0f 00 00       	call   80104da0 <release>
  return n;
80103e27:	8b 45 10             	mov    0x10(%ebp),%eax
80103e2a:	83 c4 10             	add    $0x10,%esp
80103e2d:	eb aa                	jmp    80103dd9 <pipewrite+0xa9>
80103e2f:	90                   	nop

80103e30 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103e30:	f3 0f 1e fb          	endbr32 
80103e34:	55                   	push   %ebp
80103e35:	89 e5                	mov    %esp,%ebp
80103e37:	57                   	push   %edi
80103e38:	56                   	push   %esi
80103e39:	53                   	push   %ebx
80103e3a:	83 ec 18             	sub    $0x18,%esp
80103e3d:	8b 75 08             	mov    0x8(%ebp),%esi
80103e40:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103e43:	56                   	push   %esi
80103e44:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103e4a:	e8 91 0e 00 00       	call   80104ce0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103e4f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103e55:	83 c4 10             	add    $0x10,%esp
80103e58:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103e5e:	74 33                	je     80103e93 <piperead+0x63>
80103e60:	eb 3b                	jmp    80103e9d <piperead+0x6d>
80103e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103e68:	e8 83 02 00 00       	call   801040f0 <myproc>
80103e6d:	8b 48 24             	mov    0x24(%eax),%ecx
80103e70:	85 c9                	test   %ecx,%ecx
80103e72:	0f 85 88 00 00 00    	jne    80103f00 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103e78:	83 ec 08             	sub    $0x8,%esp
80103e7b:	56                   	push   %esi
80103e7c:	53                   	push   %ebx
80103e7d:	e8 1e 08 00 00       	call   801046a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103e82:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103e88:	83 c4 10             	add    $0x10,%esp
80103e8b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103e91:	75 0a                	jne    80103e9d <piperead+0x6d>
80103e93:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103e99:	85 c0                	test   %eax,%eax
80103e9b:	75 cb                	jne    80103e68 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e9d:	8b 55 10             	mov    0x10(%ebp),%edx
80103ea0:	31 db                	xor    %ebx,%ebx
80103ea2:	85 d2                	test   %edx,%edx
80103ea4:	7f 28                	jg     80103ece <piperead+0x9e>
80103ea6:	eb 34                	jmp    80103edc <piperead+0xac>
80103ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eaf:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103eb0:	8d 48 01             	lea    0x1(%eax),%ecx
80103eb3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103eb8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103ebe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103ec3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ec6:	83 c3 01             	add    $0x1,%ebx
80103ec9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103ecc:	74 0e                	je     80103edc <piperead+0xac>
    if(p->nread == p->nwrite)
80103ece:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ed4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103eda:	75 d4                	jne    80103eb0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103edc:	83 ec 0c             	sub    $0xc,%esp
80103edf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103ee5:	50                   	push   %eax
80103ee6:	e8 75 09 00 00       	call   80104860 <wakeup>
  release(&p->lock);
80103eeb:	89 34 24             	mov    %esi,(%esp)
80103eee:	e8 ad 0e 00 00       	call   80104da0 <release>
  return i;
80103ef3:	83 c4 10             	add    $0x10,%esp
}
80103ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ef9:	89 d8                	mov    %ebx,%eax
80103efb:	5b                   	pop    %ebx
80103efc:	5e                   	pop    %esi
80103efd:	5f                   	pop    %edi
80103efe:	5d                   	pop    %ebp
80103eff:	c3                   	ret    
      release(&p->lock);
80103f00:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f03:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103f08:	56                   	push   %esi
80103f09:	e8 92 0e 00 00       	call   80104da0 <release>
      return -1;
80103f0e:	83 c4 10             	add    $0x10,%esp
}
80103f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f14:	89 d8                	mov    %ebx,%eax
80103f16:	5b                   	pop    %ebx
80103f17:	5e                   	pop    %esi
80103f18:	5f                   	pop    %edi
80103f19:	5d                   	pop    %ebp
80103f1a:	c3                   	ret    
80103f1b:	66 90                	xchg   %ax,%ax
80103f1d:	66 90                	xchg   %ax,%ax
80103f1f:	90                   	nop

80103f20 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f24:	bb b4 9d 11 80       	mov    $0x80119db4,%ebx
{
80103f29:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103f2c:	68 80 9d 11 80       	push   $0x80119d80
80103f31:	e8 aa 0d 00 00       	call   80104ce0 <acquire>
80103f36:	83 c4 10             	add    $0x10,%esp
80103f39:	eb 10                	jmp    80103f4b <allocproc+0x2b>
80103f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f3f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f40:	83 c3 7c             	add    $0x7c,%ebx
80103f43:	81 fb b4 bc 11 80    	cmp    $0x8011bcb4,%ebx
80103f49:	74 75                	je     80103fc0 <allocproc+0xa0>
    if (p->state == UNUSED)
80103f4b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103f4e:	85 c0                	test   %eax,%eax
80103f50:	75 ee                	jne    80103f40 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103f52:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103f57:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103f5a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103f61:	89 43 10             	mov    %eax,0x10(%ebx)
80103f64:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103f67:	68 80 9d 11 80       	push   $0x80119d80
  p->pid = nextpid++;
80103f6c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103f72:	e8 29 0e 00 00       	call   80104da0 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
80103f77:	e8 b4 ec ff ff       	call   80102c30 <kalloc>
80103f7c:	83 c4 10             	add    $0x10,%esp
80103f7f:	89 43 08             	mov    %eax,0x8(%ebx)
80103f82:	85 c0                	test   %eax,%eax
80103f84:	74 53                	je     80103fd9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103f86:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80103f8c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103f8f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103f94:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80103f97:	c7 40 14 26 61 10 80 	movl   $0x80106126,0x14(%eax)
  p->context = (struct context *)sp;
80103f9e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103fa1:	6a 14                	push   $0x14
80103fa3:	6a 00                	push   $0x0
80103fa5:	50                   	push   %eax
80103fa6:	e8 45 0e 00 00       	call   80104df0 <memset>
  p->context->eip = (uint)forkret;
80103fab:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103fae:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103fb1:	c7 40 10 f0 3f 10 80 	movl   $0x80103ff0,0x10(%eax)
}
80103fb8:	89 d8                	mov    %ebx,%eax
80103fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fbd:	c9                   	leave  
80103fbe:	c3                   	ret    
80103fbf:	90                   	nop
  release(&ptable.lock);
80103fc0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103fc3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103fc5:	68 80 9d 11 80       	push   $0x80119d80
80103fca:	e8 d1 0d 00 00       	call   80104da0 <release>
}
80103fcf:	89 d8                	mov    %ebx,%eax
  return 0;
80103fd1:	83 c4 10             	add    $0x10,%esp
}
80103fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fd7:	c9                   	leave  
80103fd8:	c3                   	ret    
    p->state = UNUSED;
80103fd9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103fe0:	31 db                	xor    %ebx,%ebx
}
80103fe2:	89 d8                	mov    %ebx,%eax
80103fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fe7:	c9                   	leave  
80103fe8:	c3                   	ret    
80103fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ff0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
80103ff0:	f3 0f 1e fb          	endbr32 
80103ff4:	55                   	push   %ebp
80103ff5:	89 e5                	mov    %esp,%ebp
80103ff7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103ffa:	68 80 9d 11 80       	push   $0x80119d80
80103fff:	e8 9c 0d 00 00       	call   80104da0 <release>

  if (first)
80104004:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104009:	83 c4 10             	add    $0x10,%esp
8010400c:	85 c0                	test   %eax,%eax
8010400e:	75 08                	jne    80104018 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104010:	c9                   	leave  
80104011:	c3                   	ret    
80104012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104018:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010401f:	00 00 00 
    iinit(ROOTDEV);
80104022:	83 ec 0c             	sub    $0xc,%esp
80104025:	6a 01                	push   $0x1
80104027:	e8 14 d5 ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
8010402c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104033:	e8 d8 f3 ff ff       	call   80103410 <initlog>
}
80104038:	83 c4 10             	add    $0x10,%esp
8010403b:	c9                   	leave  
8010403c:	c3                   	ret    
8010403d:	8d 76 00             	lea    0x0(%esi),%esi

80104040 <pinit>:
{
80104040:	f3 0f 1e fb          	endbr32 
80104044:	55                   	push   %ebp
80104045:	89 e5                	mov    %esp,%ebp
80104047:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010404a:	68 60 82 10 80       	push   $0x80108260
8010404f:	68 80 9d 11 80       	push   $0x80119d80
80104054:	e8 07 0b 00 00       	call   80104b60 <initlock>
}
80104059:	83 c4 10             	add    $0x10,%esp
8010405c:	c9                   	leave  
8010405d:	c3                   	ret    
8010405e:	66 90                	xchg   %ax,%ax

80104060 <mycpu>:
{
80104060:	f3 0f 1e fb          	endbr32 
80104064:	55                   	push   %ebp
80104065:	89 e5                	mov    %esp,%ebp
80104067:	56                   	push   %esi
80104068:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104069:	9c                   	pushf  
8010406a:	58                   	pop    %eax
  if (readeflags() & FL_IF)
8010406b:	f6 c4 02             	test   $0x2,%ah
8010406e:	75 4a                	jne    801040ba <mycpu+0x5a>
  apicid = lapicid();
80104070:	e8 ab ef ff ff       	call   80103020 <lapicid>
  for (i = 0; i < ncpu; ++i)
80104075:	8b 35 60 9d 11 80    	mov    0x80119d60,%esi
  apicid = lapicid();
8010407b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i)
8010407d:	85 f6                	test   %esi,%esi
8010407f:	7e 2c                	jle    801040ad <mycpu+0x4d>
80104081:	31 d2                	xor    %edx,%edx
80104083:	eb 0a                	jmp    8010408f <mycpu+0x2f>
80104085:	8d 76 00             	lea    0x0(%esi),%esi
80104088:	83 c2 01             	add    $0x1,%edx
8010408b:	39 f2                	cmp    %esi,%edx
8010408d:	74 1e                	je     801040ad <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010408f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104095:	0f b6 81 e0 97 11 80 	movzbl -0x7fee6820(%ecx),%eax
8010409c:	39 d8                	cmp    %ebx,%eax
8010409e:	75 e8                	jne    80104088 <mycpu+0x28>
}
801040a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801040a3:	8d 81 e0 97 11 80    	lea    -0x7fee6820(%ecx),%eax
}
801040a9:	5b                   	pop    %ebx
801040aa:	5e                   	pop    %esi
801040ab:	5d                   	pop    %ebp
801040ac:	c3                   	ret    
  panic("unknown apicid\n");
801040ad:	83 ec 0c             	sub    $0xc,%esp
801040b0:	68 67 82 10 80       	push   $0x80108267
801040b5:	e8 d6 c2 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801040ba:	83 ec 0c             	sub    $0xc,%esp
801040bd:	68 40 83 10 80       	push   $0x80108340
801040c2:	e8 c9 c2 ff ff       	call   80100390 <panic>
801040c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ce:	66 90                	xchg   %ax,%ax

801040d0 <cpuid>:
{
801040d0:	f3 0f 1e fb          	endbr32 
801040d4:	55                   	push   %ebp
801040d5:	89 e5                	mov    %esp,%ebp
801040d7:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
801040da:	e8 81 ff ff ff       	call   80104060 <mycpu>
}
801040df:	c9                   	leave  
  return mycpu() - cpus;
801040e0:	2d e0 97 11 80       	sub    $0x801197e0,%eax
801040e5:	c1 f8 04             	sar    $0x4,%eax
801040e8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801040ee:	c3                   	ret    
801040ef:	90                   	nop

801040f0 <myproc>:
{
801040f0:	f3 0f 1e fb          	endbr32 
801040f4:	55                   	push   %ebp
801040f5:	89 e5                	mov    %esp,%ebp
801040f7:	53                   	push   %ebx
801040f8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801040fb:	e8 e0 0a 00 00       	call   80104be0 <pushcli>
  c = mycpu();
80104100:	e8 5b ff ff ff       	call   80104060 <mycpu>
  p = c->proc;
80104105:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010410b:	e8 20 0b 00 00       	call   80104c30 <popcli>
}
80104110:	83 c4 04             	add    $0x4,%esp
80104113:	89 d8                	mov    %ebx,%eax
80104115:	5b                   	pop    %ebx
80104116:	5d                   	pop    %ebp
80104117:	c3                   	ret    
80104118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411f:	90                   	nop

80104120 <userinit>:
{
80104120:	f3 0f 1e fb          	endbr32 
80104124:	55                   	push   %ebp
80104125:	89 e5                	mov    %esp,%ebp
80104127:	53                   	push   %ebx
80104128:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010412b:	e8 f0 fd ff ff       	call   80103f20 <allocproc>
80104130:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104132:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if ((p->pgdir = setupkvm()) == 0)
80104137:	e8 54 36 00 00       	call   80107790 <setupkvm>
8010413c:	89 43 04             	mov    %eax,0x4(%ebx)
8010413f:	85 c0                	test   %eax,%eax
80104141:	0f 84 d6 00 00 00    	je     8010421d <userinit+0xfd>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
80104147:	83 ec 04             	sub    $0x4,%esp
8010414a:	68 2c 00 00 00       	push   $0x2c
8010414f:	68 60 b4 10 80       	push   $0x8010b460
80104154:	68 90 82 10 80       	push   $0x80108290
80104159:	e8 52 c5 ff ff       	call   801006b0 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010415e:	83 c4 0c             	add    $0xc,%esp
80104161:	68 2c 00 00 00       	push   $0x2c
80104166:	68 60 b4 10 80       	push   $0x8010b460
8010416b:	ff 73 04             	pushl  0x4(%ebx)
8010416e:	e8 cd 32 00 00       	call   80107440 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104173:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104176:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010417c:	6a 4c                	push   $0x4c
8010417e:	6a 00                	push   $0x0
80104180:	ff 73 18             	pushl  0x18(%ebx)
80104183:	e8 68 0c 00 00       	call   80104df0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104188:	8b 43 18             	mov    0x18(%ebx),%eax
8010418b:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104190:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104193:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104198:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010419c:	8b 43 18             	mov    0x18(%ebx),%eax
8010419f:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801041a3:	8b 43 18             	mov    0x18(%ebx),%eax
801041a6:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801041aa:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801041ae:	8b 43 18             	mov    0x18(%ebx),%eax
801041b1:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801041b5:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801041b9:	8b 43 18             	mov    0x18(%ebx),%eax
801041bc:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801041c3:	8b 43 18             	mov    0x18(%ebx),%eax
801041c6:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
801041cd:	8b 43 18             	mov    0x18(%ebx),%eax
801041d0:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801041d7:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041da:	6a 10                	push   $0x10
801041dc:	68 97 82 10 80       	push   $0x80108297
801041e1:	50                   	push   %eax
801041e2:	e8 c9 0d 00 00       	call   80104fb0 <safestrcpy>
  p->cwd = namei("/");
801041e7:	c7 04 24 a0 82 10 80 	movl   $0x801082a0,(%esp)
801041ee:	e8 3d de ff ff       	call   80102030 <namei>
801041f3:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801041f6:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
801041fd:	e8 de 0a 00 00       	call   80104ce0 <acquire>
  p->state = RUNNABLE;
80104202:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104209:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
80104210:	e8 8b 0b 00 00       	call   80104da0 <release>
}
80104215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104218:	83 c4 10             	add    $0x10,%esp
8010421b:	c9                   	leave  
8010421c:	c3                   	ret    
    panic("userinit: out of memory?");
8010421d:	83 ec 0c             	sub    $0xc,%esp
80104220:	68 77 82 10 80       	push   $0x80108277
80104225:	e8 66 c1 ff ff       	call   80100390 <panic>
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104230 <growproc>:
{
80104230:	f3 0f 1e fb          	endbr32 
80104234:	55                   	push   %ebp
80104235:	89 e5                	mov    %esp,%ebp
80104237:	56                   	push   %esi
80104238:	53                   	push   %ebx
80104239:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010423c:	e8 9f 09 00 00       	call   80104be0 <pushcli>
  c = mycpu();
80104241:	e8 1a fe ff ff       	call   80104060 <mycpu>
  p = c->proc;
80104246:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010424c:	e8 df 09 00 00       	call   80104c30 <popcli>
  sz = curproc->sz;
80104251:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80104253:	85 f6                	test   %esi,%esi
80104255:	7f 19                	jg     80104270 <growproc+0x40>
  else if (n < 0)
80104257:	75 37                	jne    80104290 <growproc+0x60>
  switchuvm(curproc);
80104259:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010425c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010425e:	53                   	push   %ebx
8010425f:	e8 cc 30 00 00       	call   80107330 <switchuvm>
  return 0;
80104264:	83 c4 10             	add    $0x10,%esp
80104267:	31 c0                	xor    %eax,%eax
}
80104269:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010426c:	5b                   	pop    %ebx
8010426d:	5e                   	pop    %esi
8010426e:	5d                   	pop    %ebp
8010426f:	c3                   	ret    
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104270:	83 ec 04             	sub    $0x4,%esp
80104273:	01 c6                	add    %eax,%esi
80104275:	56                   	push   %esi
80104276:	50                   	push   %eax
80104277:	ff 73 04             	pushl  0x4(%ebx)
8010427a:	e8 21 33 00 00       	call   801075a0 <allocuvm>
8010427f:	83 c4 10             	add    $0x10,%esp
80104282:	85 c0                	test   %eax,%eax
80104284:	75 d3                	jne    80104259 <growproc+0x29>
      return -1;
80104286:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010428b:	eb dc                	jmp    80104269 <growproc+0x39>
8010428d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104290:	83 ec 04             	sub    $0x4,%esp
80104293:	01 c6                	add    %eax,%esi
80104295:	56                   	push   %esi
80104296:	50                   	push   %eax
80104297:	ff 73 04             	pushl  0x4(%ebx)
8010429a:	e8 41 34 00 00       	call   801076e0 <deallocuvm>
8010429f:	83 c4 10             	add    $0x10,%esp
801042a2:	85 c0                	test   %eax,%eax
801042a4:	75 b3                	jne    80104259 <growproc+0x29>
801042a6:	eb de                	jmp    80104286 <growproc+0x56>
801042a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042af:	90                   	nop

801042b0 <fork>:
{
801042b0:	f3 0f 1e fb          	endbr32 
801042b4:	55                   	push   %ebp
801042b5:	89 e5                	mov    %esp,%ebp
801042b7:	57                   	push   %edi
801042b8:	56                   	push   %esi
801042b9:	53                   	push   %ebx
801042ba:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801042bd:	e8 1e 09 00 00       	call   80104be0 <pushcli>
  c = mycpu();
801042c2:	e8 99 fd ff ff       	call   80104060 <mycpu>
  p = c->proc;
801042c7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042cd:	e8 5e 09 00 00       	call   80104c30 <popcli>
  if ((np = allocproc()) == 0)
801042d2:	e8 49 fc ff ff       	call   80103f20 <allocproc>
801042d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042da:	85 c0                	test   %eax,%eax
801042dc:	0f 84 bb 00 00 00    	je     8010439d <fork+0xed>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
801042e2:	83 ec 08             	sub    $0x8,%esp
801042e5:	ff 33                	pushl  (%ebx)
801042e7:	89 c7                	mov    %eax,%edi
801042e9:	ff 73 04             	pushl  0x4(%ebx)
801042ec:	e8 6f 35 00 00       	call   80107860 <copyuvm>
801042f1:	83 c4 10             	add    $0x10,%esp
801042f4:	89 47 04             	mov    %eax,0x4(%edi)
801042f7:	85 c0                	test   %eax,%eax
801042f9:	0f 84 a5 00 00 00    	je     801043a4 <fork+0xf4>
  np->sz = curproc->sz;
801042ff:	8b 03                	mov    (%ebx),%eax
80104301:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104304:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104306:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104309:	89 c8                	mov    %ecx,%eax
8010430b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010430e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104313:	8b 73 18             	mov    0x18(%ebx),%esi
80104316:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80104318:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010431a:	8b 40 18             	mov    0x18(%eax),%eax
8010431d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
80104324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[i])
80104328:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010432c:	85 c0                	test   %eax,%eax
8010432e:	74 13                	je     80104343 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104330:	83 ec 0c             	sub    $0xc,%esp
80104333:	50                   	push   %eax
80104334:	e8 37 cb ff ff       	call   80100e70 <filedup>
80104339:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010433c:	83 c4 10             	add    $0x10,%esp
8010433f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80104343:	83 c6 01             	add    $0x1,%esi
80104346:	83 fe 10             	cmp    $0x10,%esi
80104349:	75 dd                	jne    80104328 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010434b:	83 ec 0c             	sub    $0xc,%esp
8010434e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104351:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104354:	e8 d7 d3 ff ff       	call   80101730 <idup>
80104359:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010435c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010435f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104362:	8d 47 6c             	lea    0x6c(%edi),%eax
80104365:	6a 10                	push   $0x10
80104367:	53                   	push   %ebx
80104368:	50                   	push   %eax
80104369:	e8 42 0c 00 00       	call   80104fb0 <safestrcpy>
  pid = np->pid;
8010436e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104371:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
80104378:	e8 63 09 00 00       	call   80104ce0 <acquire>
  np->state = RUNNABLE;
8010437d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104384:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
8010438b:	e8 10 0a 00 00       	call   80104da0 <release>
  return pid;
80104390:	83 c4 10             	add    $0x10,%esp
}
80104393:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104396:	89 d8                	mov    %ebx,%eax
80104398:	5b                   	pop    %ebx
80104399:	5e                   	pop    %esi
8010439a:	5f                   	pop    %edi
8010439b:	5d                   	pop    %ebp
8010439c:	c3                   	ret    
    return -1;
8010439d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043a2:	eb ef                	jmp    80104393 <fork+0xe3>
    kfree(np->kstack);
801043a4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801043a7:	83 ec 0c             	sub    $0xc,%esp
801043aa:	ff 73 08             	pushl  0x8(%ebx)
801043ad:	e8 ce e1 ff ff       	call   80102580 <kfree>
    np->kstack = 0;
801043b2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801043b9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801043bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801043c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043c8:	eb c9                	jmp    80104393 <fork+0xe3>
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043d0 <scheduler>:
{
801043d0:	f3 0f 1e fb          	endbr32 
801043d4:	55                   	push   %ebp
801043d5:	89 e5                	mov    %esp,%ebp
801043d7:	57                   	push   %edi
801043d8:	56                   	push   %esi
801043d9:	53                   	push   %ebx
801043da:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801043dd:	e8 7e fc ff ff       	call   80104060 <mycpu>
  c->proc = 0;
801043e2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801043e9:	00 00 00 
  struct cpu *c = mycpu();
801043ec:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801043ee:	8d 78 04             	lea    0x4(%eax),%edi
801043f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801043f8:	fb                   	sti    
    acquire(&ptable.lock);
801043f9:	83 ec 0c             	sub    $0xc,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043fc:	bb b4 9d 11 80       	mov    $0x80119db4,%ebx
    acquire(&ptable.lock);
80104401:	68 80 9d 11 80       	push   $0x80119d80
80104406:	e8 d5 08 00 00       	call   80104ce0 <acquire>
8010440b:	83 c4 10             	add    $0x10,%esp
8010440e:	66 90                	xchg   %ax,%ax
      if (p->state != RUNNABLE)
80104410:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104414:	75 33                	jne    80104449 <scheduler+0x79>
      switchuvm(p);
80104416:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104419:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010441f:	53                   	push   %ebx
80104420:	e8 0b 2f 00 00       	call   80107330 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104425:	58                   	pop    %eax
80104426:	5a                   	pop    %edx
80104427:	ff 73 1c             	pushl  0x1c(%ebx)
8010442a:	57                   	push   %edi
      p->state = RUNNING;
8010442b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104432:	e8 dc 0b 00 00       	call   80105013 <swtch>
      switchkvm();
80104437:	e8 d4 2e 00 00       	call   80107310 <switchkvm>
      c->proc = 0;
8010443c:	83 c4 10             	add    $0x10,%esp
8010443f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104446:	00 00 00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104449:	83 c3 7c             	add    $0x7c,%ebx
8010444c:	81 fb b4 bc 11 80    	cmp    $0x8011bcb4,%ebx
80104452:	75 bc                	jne    80104410 <scheduler+0x40>
    release(&ptable.lock);
80104454:	83 ec 0c             	sub    $0xc,%esp
80104457:	68 80 9d 11 80       	push   $0x80119d80
8010445c:	e8 3f 09 00 00       	call   80104da0 <release>
    sti();
80104461:	83 c4 10             	add    $0x10,%esp
80104464:	eb 92                	jmp    801043f8 <scheduler+0x28>
80104466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446d:	8d 76 00             	lea    0x0(%esi),%esi

80104470 <sched>:
{
80104470:	f3 0f 1e fb          	endbr32 
80104474:	55                   	push   %ebp
80104475:	89 e5                	mov    %esp,%ebp
80104477:	56                   	push   %esi
80104478:	53                   	push   %ebx
  pushcli();
80104479:	e8 62 07 00 00       	call   80104be0 <pushcli>
  c = mycpu();
8010447e:	e8 dd fb ff ff       	call   80104060 <mycpu>
  p = c->proc;
80104483:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104489:	e8 a2 07 00 00       	call   80104c30 <popcli>
  if (!holding(&ptable.lock))
8010448e:	83 ec 0c             	sub    $0xc,%esp
80104491:	68 80 9d 11 80       	push   $0x80119d80
80104496:	e8 f5 07 00 00       	call   80104c90 <holding>
8010449b:	83 c4 10             	add    $0x10,%esp
8010449e:	85 c0                	test   %eax,%eax
801044a0:	74 41                	je     801044e3 <sched+0x73>
  if (p->state == RUNNING)
801044a2:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801044a6:	74 55                	je     801044fd <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044a8:	9c                   	pushf  
801044a9:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801044aa:	f6 c4 02             	test   $0x2,%ah
801044ad:	75 41                	jne    801044f0 <sched+0x80>
  intena = mycpu()->intena;
801044af:	e8 ac fb ff ff       	call   80104060 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801044b4:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801044b7:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801044bd:	e8 9e fb ff ff       	call   80104060 <mycpu>
801044c2:	83 ec 08             	sub    $0x8,%esp
801044c5:	ff 70 04             	pushl  0x4(%eax)
801044c8:	53                   	push   %ebx
801044c9:	e8 45 0b 00 00       	call   80105013 <swtch>
  mycpu()->intena = intena;
801044ce:	e8 8d fb ff ff       	call   80104060 <mycpu>
}
801044d3:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801044d6:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801044dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044df:	5b                   	pop    %ebx
801044e0:	5e                   	pop    %esi
801044e1:	5d                   	pop    %ebp
801044e2:	c3                   	ret    
    panic("sched ptable.lock");
801044e3:	83 ec 0c             	sub    $0xc,%esp
801044e6:	68 a2 82 10 80       	push   $0x801082a2
801044eb:	e8 a0 be ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801044f0:	83 ec 0c             	sub    $0xc,%esp
801044f3:	68 c2 82 10 80       	push   $0x801082c2
801044f8:	e8 93 be ff ff       	call   80100390 <panic>
    panic("sched running");
801044fd:	83 ec 0c             	sub    $0xc,%esp
80104500:	68 b4 82 10 80       	push   $0x801082b4
80104505:	e8 86 be ff ff       	call   80100390 <panic>
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104510 <exit>:
{
80104510:	f3 0f 1e fb          	endbr32 
80104514:	55                   	push   %ebp
80104515:	89 e5                	mov    %esp,%ebp
80104517:	57                   	push   %edi
80104518:	56                   	push   %esi
80104519:	53                   	push   %ebx
8010451a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010451d:	e8 be 06 00 00       	call   80104be0 <pushcli>
  c = mycpu();
80104522:	e8 39 fb ff ff       	call   80104060 <mycpu>
  p = c->proc;
80104527:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010452d:	e8 fe 06 00 00       	call   80104c30 <popcli>
  if (curproc == initproc)
80104532:	8d 5e 28             	lea    0x28(%esi),%ebx
80104535:	8d 7e 68             	lea    0x68(%esi),%edi
80104538:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010453e:	0f 84 f3 00 00 00    	je     80104637 <exit+0x127>
80104544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd])
80104548:	8b 03                	mov    (%ebx),%eax
8010454a:	85 c0                	test   %eax,%eax
8010454c:	74 12                	je     80104560 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010454e:	83 ec 0c             	sub    $0xc,%esp
80104551:	50                   	push   %eax
80104552:	e8 69 c9 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104557:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010455d:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80104560:	83 c3 04             	add    $0x4,%ebx
80104563:	39 df                	cmp    %ebx,%edi
80104565:	75 e1                	jne    80104548 <exit+0x38>
  begin_op();
80104567:	e8 44 ef ff ff       	call   801034b0 <begin_op>
  iput(curproc->cwd);
8010456c:	83 ec 0c             	sub    $0xc,%esp
8010456f:	ff 76 68             	pushl  0x68(%esi)
80104572:	e8 19 d3 ff ff       	call   80101890 <iput>
  end_op();
80104577:	e8 a4 ef ff ff       	call   80103520 <end_op>
  curproc->cwd = 0;
8010457c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104583:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
8010458a:	e8 51 07 00 00       	call   80104ce0 <acquire>
  wakeup1(curproc->parent);
8010458f:	8b 56 14             	mov    0x14(%esi),%edx
80104592:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104595:	b8 b4 9d 11 80       	mov    $0x80119db4,%eax
8010459a:	eb 0e                	jmp    801045aa <exit+0x9a>
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045a0:	83 c0 7c             	add    $0x7c,%eax
801045a3:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
801045a8:	74 1c                	je     801045c6 <exit+0xb6>
    if (p->state == SLEEPING && p->chan == chan)
801045aa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045ae:	75 f0                	jne    801045a0 <exit+0x90>
801045b0:	3b 50 20             	cmp    0x20(%eax),%edx
801045b3:	75 eb                	jne    801045a0 <exit+0x90>
      p->state = RUNNABLE;
801045b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045bc:	83 c0 7c             	add    $0x7c,%eax
801045bf:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
801045c4:	75 e4                	jne    801045aa <exit+0x9a>
      p->parent = initproc;
801045c6:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045cc:	ba b4 9d 11 80       	mov    $0x80119db4,%edx
801045d1:	eb 10                	jmp    801045e3 <exit+0xd3>
801045d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045d7:	90                   	nop
801045d8:	83 c2 7c             	add    $0x7c,%edx
801045db:	81 fa b4 bc 11 80    	cmp    $0x8011bcb4,%edx
801045e1:	74 3b                	je     8010461e <exit+0x10e>
    if (p->parent == curproc)
801045e3:	39 72 14             	cmp    %esi,0x14(%edx)
801045e6:	75 f0                	jne    801045d8 <exit+0xc8>
      if (p->state == ZOMBIE)
801045e8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801045ec:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
801045ef:	75 e7                	jne    801045d8 <exit+0xc8>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045f1:	b8 b4 9d 11 80       	mov    $0x80119db4,%eax
801045f6:	eb 12                	jmp    8010460a <exit+0xfa>
801045f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ff:	90                   	nop
80104600:	83 c0 7c             	add    $0x7c,%eax
80104603:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
80104608:	74 ce                	je     801045d8 <exit+0xc8>
    if (p->state == SLEEPING && p->chan == chan)
8010460a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010460e:	75 f0                	jne    80104600 <exit+0xf0>
80104610:	3b 48 20             	cmp    0x20(%eax),%ecx
80104613:	75 eb                	jne    80104600 <exit+0xf0>
      p->state = RUNNABLE;
80104615:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010461c:	eb e2                	jmp    80104600 <exit+0xf0>
  curproc->state = ZOMBIE;
8010461e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104625:	e8 46 fe ff ff       	call   80104470 <sched>
  panic("zombie exit");
8010462a:	83 ec 0c             	sub    $0xc,%esp
8010462d:	68 e3 82 10 80       	push   $0x801082e3
80104632:	e8 59 bd ff ff       	call   80100390 <panic>
    panic("init exiting");
80104637:	83 ec 0c             	sub    $0xc,%esp
8010463a:	68 d6 82 10 80       	push   $0x801082d6
8010463f:	e8 4c bd ff ff       	call   80100390 <panic>
80104644:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010464f:	90                   	nop

80104650 <yield>:
{
80104650:	f3 0f 1e fb          	endbr32 
80104654:	55                   	push   %ebp
80104655:	89 e5                	mov    %esp,%ebp
80104657:	53                   	push   %ebx
80104658:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
8010465b:	68 80 9d 11 80       	push   $0x80119d80
80104660:	e8 7b 06 00 00       	call   80104ce0 <acquire>
  pushcli();
80104665:	e8 76 05 00 00       	call   80104be0 <pushcli>
  c = mycpu();
8010466a:	e8 f1 f9 ff ff       	call   80104060 <mycpu>
  p = c->proc;
8010466f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104675:	e8 b6 05 00 00       	call   80104c30 <popcli>
  myproc()->state = RUNNABLE;
8010467a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104681:	e8 ea fd ff ff       	call   80104470 <sched>
  release(&ptable.lock);
80104686:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
8010468d:	e8 0e 07 00 00       	call   80104da0 <release>
}
80104692:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104695:	83 c4 10             	add    $0x10,%esp
80104698:	c9                   	leave  
80104699:	c3                   	ret    
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046a0 <sleep>:
{
801046a0:	f3 0f 1e fb          	endbr32 
801046a4:	55                   	push   %ebp
801046a5:	89 e5                	mov    %esp,%ebp
801046a7:	57                   	push   %edi
801046a8:	56                   	push   %esi
801046a9:	53                   	push   %ebx
801046aa:	83 ec 0c             	sub    $0xc,%esp
801046ad:	8b 7d 08             	mov    0x8(%ebp),%edi
801046b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801046b3:	e8 28 05 00 00       	call   80104be0 <pushcli>
  c = mycpu();
801046b8:	e8 a3 f9 ff ff       	call   80104060 <mycpu>
  p = c->proc;
801046bd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046c3:	e8 68 05 00 00       	call   80104c30 <popcli>
  if (p == 0)
801046c8:	85 db                	test   %ebx,%ebx
801046ca:	0f 84 83 00 00 00    	je     80104753 <sleep+0xb3>
  if (lk == 0)
801046d0:	85 f6                	test   %esi,%esi
801046d2:	74 72                	je     80104746 <sleep+0xa6>
  if (lk != &ptable.lock)
801046d4:	81 fe 80 9d 11 80    	cmp    $0x80119d80,%esi
801046da:	74 4c                	je     80104728 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
801046dc:	83 ec 0c             	sub    $0xc,%esp
801046df:	68 80 9d 11 80       	push   $0x80119d80
801046e4:	e8 f7 05 00 00       	call   80104ce0 <acquire>
    release(lk);
801046e9:	89 34 24             	mov    %esi,(%esp)
801046ec:	e8 af 06 00 00       	call   80104da0 <release>
  p->chan = chan;
801046f1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801046f4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046fb:	e8 70 fd ff ff       	call   80104470 <sched>
  p->chan = 0;
80104700:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104707:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
8010470e:	e8 8d 06 00 00       	call   80104da0 <release>
    acquire(lk);
80104713:	89 75 08             	mov    %esi,0x8(%ebp)
80104716:	83 c4 10             	add    $0x10,%esp
}
80104719:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010471c:	5b                   	pop    %ebx
8010471d:	5e                   	pop    %esi
8010471e:	5f                   	pop    %edi
8010471f:	5d                   	pop    %ebp
    acquire(lk);
80104720:	e9 bb 05 00 00       	jmp    80104ce0 <acquire>
80104725:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104728:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010472b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104732:	e8 39 fd ff ff       	call   80104470 <sched>
  p->chan = 0;
80104737:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010473e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104741:	5b                   	pop    %ebx
80104742:	5e                   	pop    %esi
80104743:	5f                   	pop    %edi
80104744:	5d                   	pop    %ebp
80104745:	c3                   	ret    
    panic("sleep without lk");
80104746:	83 ec 0c             	sub    $0xc,%esp
80104749:	68 f5 82 10 80       	push   $0x801082f5
8010474e:	e8 3d bc ff ff       	call   80100390 <panic>
    panic("sleep");
80104753:	83 ec 0c             	sub    $0xc,%esp
80104756:	68 ef 82 10 80       	push   $0x801082ef
8010475b:	e8 30 bc ff ff       	call   80100390 <panic>

80104760 <wait>:
{
80104760:	f3 0f 1e fb          	endbr32 
80104764:	55                   	push   %ebp
80104765:	89 e5                	mov    %esp,%ebp
80104767:	56                   	push   %esi
80104768:	53                   	push   %ebx
  pushcli();
80104769:	e8 72 04 00 00       	call   80104be0 <pushcli>
  c = mycpu();
8010476e:	e8 ed f8 ff ff       	call   80104060 <mycpu>
  p = c->proc;
80104773:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104779:	e8 b2 04 00 00       	call   80104c30 <popcli>
  acquire(&ptable.lock);
8010477e:	83 ec 0c             	sub    $0xc,%esp
80104781:	68 80 9d 11 80       	push   $0x80119d80
80104786:	e8 55 05 00 00       	call   80104ce0 <acquire>
8010478b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010478e:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104790:	bb b4 9d 11 80       	mov    $0x80119db4,%ebx
80104795:	eb 14                	jmp    801047ab <wait+0x4b>
80104797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479e:	66 90                	xchg   %ax,%ax
801047a0:	83 c3 7c             	add    $0x7c,%ebx
801047a3:	81 fb b4 bc 11 80    	cmp    $0x8011bcb4,%ebx
801047a9:	74 1b                	je     801047c6 <wait+0x66>
      if (p->parent != curproc)
801047ab:	39 73 14             	cmp    %esi,0x14(%ebx)
801047ae:	75 f0                	jne    801047a0 <wait+0x40>
      if (p->state == ZOMBIE)
801047b0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801047b4:	74 32                	je     801047e8 <wait+0x88>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047b6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801047b9:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047be:	81 fb b4 bc 11 80    	cmp    $0x8011bcb4,%ebx
801047c4:	75 e5                	jne    801047ab <wait+0x4b>
    if (!havekids || curproc->killed)
801047c6:	85 c0                	test   %eax,%eax
801047c8:	74 74                	je     8010483e <wait+0xde>
801047ca:	8b 46 24             	mov    0x24(%esi),%eax
801047cd:	85 c0                	test   %eax,%eax
801047cf:	75 6d                	jne    8010483e <wait+0xde>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
801047d1:	83 ec 08             	sub    $0x8,%esp
801047d4:	68 80 9d 11 80       	push   $0x80119d80
801047d9:	56                   	push   %esi
801047da:	e8 c1 fe ff ff       	call   801046a0 <sleep>
    havekids = 0;
801047df:	83 c4 10             	add    $0x10,%esp
801047e2:	eb aa                	jmp    8010478e <wait+0x2e>
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801047e8:	83 ec 0c             	sub    $0xc,%esp
801047eb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801047ee:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801047f1:	e8 8a dd ff ff       	call   80102580 <kfree>
        freevm(p->pgdir);
801047f6:	5a                   	pop    %edx
801047f7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801047fa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104801:	e8 0a 2f 00 00       	call   80107710 <freevm>
        release(&ptable.lock);
80104806:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
        p->pid = 0;
8010480d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104814:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010481b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010481f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104826:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010482d:	e8 6e 05 00 00       	call   80104da0 <release>
        return pid;
80104832:	83 c4 10             	add    $0x10,%esp
}
80104835:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104838:	89 f0                	mov    %esi,%eax
8010483a:	5b                   	pop    %ebx
8010483b:	5e                   	pop    %esi
8010483c:	5d                   	pop    %ebp
8010483d:	c3                   	ret    
      release(&ptable.lock);
8010483e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104841:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104846:	68 80 9d 11 80       	push   $0x80119d80
8010484b:	e8 50 05 00 00       	call   80104da0 <release>
      return -1;
80104850:	83 c4 10             	add    $0x10,%esp
80104853:	eb e0                	jmp    80104835 <wait+0xd5>
80104855:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104860 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	53                   	push   %ebx
80104868:	83 ec 10             	sub    $0x10,%esp
8010486b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010486e:	68 80 9d 11 80       	push   $0x80119d80
80104873:	e8 68 04 00 00       	call   80104ce0 <acquire>
80104878:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010487b:	b8 b4 9d 11 80       	mov    $0x80119db4,%eax
80104880:	eb 10                	jmp    80104892 <wakeup+0x32>
80104882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104888:	83 c0 7c             	add    $0x7c,%eax
8010488b:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
80104890:	74 1c                	je     801048ae <wakeup+0x4e>
    if (p->state == SLEEPING && p->chan == chan)
80104892:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104896:	75 f0                	jne    80104888 <wakeup+0x28>
80104898:	3b 58 20             	cmp    0x20(%eax),%ebx
8010489b:	75 eb                	jne    80104888 <wakeup+0x28>
      p->state = RUNNABLE;
8010489d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048a4:	83 c0 7c             	add    $0x7c,%eax
801048a7:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
801048ac:	75 e4                	jne    80104892 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
801048ae:	c7 45 08 80 9d 11 80 	movl   $0x80119d80,0x8(%ebp)
}
801048b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048b8:	c9                   	leave  
  release(&ptable.lock);
801048b9:	e9 e2 04 00 00       	jmp    80104da0 <release>
801048be:	66 90                	xchg   %ax,%ax

801048c0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
801048c0:	f3 0f 1e fb          	endbr32 
801048c4:	55                   	push   %ebp
801048c5:	89 e5                	mov    %esp,%ebp
801048c7:	53                   	push   %ebx
801048c8:	83 ec 10             	sub    $0x10,%esp
801048cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801048ce:	68 80 9d 11 80       	push   $0x80119d80
801048d3:	e8 08 04 00 00       	call   80104ce0 <acquire>
801048d8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048db:	b8 b4 9d 11 80       	mov    $0x80119db4,%eax
801048e0:	eb 10                	jmp    801048f2 <kill+0x32>
801048e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048e8:	83 c0 7c             	add    $0x7c,%eax
801048eb:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
801048f0:	74 36                	je     80104928 <kill+0x68>
  {
    if (p->pid == pid)
801048f2:	39 58 10             	cmp    %ebx,0x10(%eax)
801048f5:	75 f1                	jne    801048e8 <kill+0x28>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
801048f7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801048fb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
80104902:	75 07                	jne    8010490b <kill+0x4b>
        p->state = RUNNABLE;
80104904:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010490b:	83 ec 0c             	sub    $0xc,%esp
8010490e:	68 80 9d 11 80       	push   $0x80119d80
80104913:	e8 88 04 00 00       	call   80104da0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104918:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010491b:	83 c4 10             	add    $0x10,%esp
8010491e:	31 c0                	xor    %eax,%eax
}
80104920:	c9                   	leave  
80104921:	c3                   	ret    
80104922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104928:	83 ec 0c             	sub    $0xc,%esp
8010492b:	68 80 9d 11 80       	push   $0x80119d80
80104930:	e8 6b 04 00 00       	call   80104da0 <release>
}
80104935:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104938:	83 c4 10             	add    $0x10,%esp
8010493b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104940:	c9                   	leave  
80104941:	c3                   	ret    
80104942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104950 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	57                   	push   %edi
80104958:	56                   	push   %esi
80104959:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010495c:	53                   	push   %ebx
8010495d:	bb 20 9e 11 80       	mov    $0x80119e20,%ebx
80104962:	83 ec 3c             	sub    $0x3c,%esp
80104965:	eb 28                	jmp    8010498f <procdump+0x3f>
80104967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496e:	66 90                	xchg   %ax,%ax
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104970:	83 ec 0c             	sub    $0xc,%esp
80104973:	68 cb 86 10 80       	push   $0x801086cb
80104978:	e8 33 bd ff ff       	call   801006b0 <cprintf>
8010497d:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104980:	83 c3 7c             	add    $0x7c,%ebx
80104983:	81 fb 20 bd 11 80    	cmp    $0x8011bd20,%ebx
80104989:	0f 84 81 00 00 00    	je     80104a10 <procdump+0xc0>
    if (p->state == UNUSED)
8010498f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104992:	85 c0                	test   %eax,%eax
80104994:	74 ea                	je     80104980 <procdump+0x30>
      state = "???";
80104996:	ba 06 83 10 80       	mov    $0x80108306,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010499b:	83 f8 05             	cmp    $0x5,%eax
8010499e:	77 11                	ja     801049b1 <procdump+0x61>
801049a0:	8b 14 85 68 83 10 80 	mov    -0x7fef7c98(,%eax,4),%edx
      state = "???";
801049a7:	b8 06 83 10 80       	mov    $0x80108306,%eax
801049ac:	85 d2                	test   %edx,%edx
801049ae:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801049b1:	53                   	push   %ebx
801049b2:	52                   	push   %edx
801049b3:	ff 73 a4             	pushl  -0x5c(%ebx)
801049b6:	68 0a 83 10 80       	push   $0x8010830a
801049bb:	e8 f0 bc ff ff       	call   801006b0 <cprintf>
    if (p->state == SLEEPING)
801049c0:	83 c4 10             	add    $0x10,%esp
801049c3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801049c7:	75 a7                	jne    80104970 <procdump+0x20>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
801049c9:	83 ec 08             	sub    $0x8,%esp
801049cc:	8d 45 c0             	lea    -0x40(%ebp),%eax
801049cf:	8d 7d c0             	lea    -0x40(%ebp),%edi
801049d2:	50                   	push   %eax
801049d3:	8b 43 b0             	mov    -0x50(%ebx),%eax
801049d6:	8b 40 0c             	mov    0xc(%eax),%eax
801049d9:	83 c0 08             	add    $0x8,%eax
801049dc:	50                   	push   %eax
801049dd:	e8 9e 01 00 00       	call   80104b80 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
801049e2:	83 c4 10             	add    $0x10,%esp
801049e5:	8d 76 00             	lea    0x0(%esi),%esi
801049e8:	8b 17                	mov    (%edi),%edx
801049ea:	85 d2                	test   %edx,%edx
801049ec:	74 82                	je     80104970 <procdump+0x20>
        cprintf(" %p", pc[i]);
801049ee:	83 ec 08             	sub    $0x8,%esp
801049f1:	83 c7 04             	add    $0x4,%edi
801049f4:	52                   	push   %edx
801049f5:	68 81 7a 10 80       	push   $0x80107a81
801049fa:	e8 b1 bc ff ff       	call   801006b0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
801049ff:	83 c4 10             	add    $0x10,%esp
80104a02:	39 fe                	cmp    %edi,%esi
80104a04:	75 e2                	jne    801049e8 <procdump+0x98>
80104a06:	e9 65 ff ff ff       	jmp    80104970 <procdump+0x20>
80104a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a0f:	90                   	nop
  }
}
80104a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a13:	5b                   	pop    %ebx
80104a14:	5e                   	pop    %esi
80104a15:	5f                   	pop    %edi
80104a16:	5d                   	pop    %ebp
80104a17:	c3                   	ret    
80104a18:	66 90                	xchg   %ax,%ax
80104a1a:	66 90                	xchg   %ax,%ax
80104a1c:	66 90                	xchg   %ax,%ax
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a20:	f3 0f 1e fb          	endbr32 
80104a24:	55                   	push   %ebp
80104a25:	89 e5                	mov    %esp,%ebp
80104a27:	53                   	push   %ebx
80104a28:	83 ec 0c             	sub    $0xc,%esp
80104a2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a2e:	68 80 83 10 80       	push   $0x80108380
80104a33:	8d 43 04             	lea    0x4(%ebx),%eax
80104a36:	50                   	push   %eax
80104a37:	e8 24 01 00 00       	call   80104b60 <initlock>
  lk->name = name;
80104a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104a3f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104a45:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104a48:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104a4f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a55:	c9                   	leave  
80104a56:	c3                   	ret    
80104a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	56                   	push   %esi
80104a68:	53                   	push   %ebx
80104a69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a6c:	8d 73 04             	lea    0x4(%ebx),%esi
80104a6f:	83 ec 0c             	sub    $0xc,%esp
80104a72:	56                   	push   %esi
80104a73:	e8 68 02 00 00       	call   80104ce0 <acquire>
  while (lk->locked) {
80104a78:	8b 13                	mov    (%ebx),%edx
80104a7a:	83 c4 10             	add    $0x10,%esp
80104a7d:	85 d2                	test   %edx,%edx
80104a7f:	74 1a                	je     80104a9b <acquiresleep+0x3b>
80104a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104a88:	83 ec 08             	sub    $0x8,%esp
80104a8b:	56                   	push   %esi
80104a8c:	53                   	push   %ebx
80104a8d:	e8 0e fc ff ff       	call   801046a0 <sleep>
  while (lk->locked) {
80104a92:	8b 03                	mov    (%ebx),%eax
80104a94:	83 c4 10             	add    $0x10,%esp
80104a97:	85 c0                	test   %eax,%eax
80104a99:	75 ed                	jne    80104a88 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104a9b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104aa1:	e8 4a f6 ff ff       	call   801040f0 <myproc>
80104aa6:	8b 40 10             	mov    0x10(%eax),%eax
80104aa9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104aac:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104aaf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab2:	5b                   	pop    %ebx
80104ab3:	5e                   	pop    %esi
80104ab4:	5d                   	pop    %ebp
  release(&lk->lk);
80104ab5:	e9 e6 02 00 00       	jmp    80104da0 <release>
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ac0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	56                   	push   %esi
80104ac8:	53                   	push   %ebx
80104ac9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104acc:	8d 73 04             	lea    0x4(%ebx),%esi
80104acf:	83 ec 0c             	sub    $0xc,%esp
80104ad2:	56                   	push   %esi
80104ad3:	e8 08 02 00 00       	call   80104ce0 <acquire>
  lk->locked = 0;
80104ad8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104ade:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ae5:	89 1c 24             	mov    %ebx,(%esp)
80104ae8:	e8 73 fd ff ff       	call   80104860 <wakeup>
  release(&lk->lk);
80104aed:	89 75 08             	mov    %esi,0x8(%ebp)
80104af0:	83 c4 10             	add    $0x10,%esp
}
80104af3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104af6:	5b                   	pop    %ebx
80104af7:	5e                   	pop    %esi
80104af8:	5d                   	pop    %ebp
  release(&lk->lk);
80104af9:	e9 a2 02 00 00       	jmp    80104da0 <release>
80104afe:	66 90                	xchg   %ax,%ax

80104b00 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
80104b05:	89 e5                	mov    %esp,%ebp
80104b07:	57                   	push   %edi
80104b08:	31 ff                	xor    %edi,%edi
80104b0a:	56                   	push   %esi
80104b0b:	53                   	push   %ebx
80104b0c:	83 ec 18             	sub    $0x18,%esp
80104b0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104b12:	8d 73 04             	lea    0x4(%ebx),%esi
80104b15:	56                   	push   %esi
80104b16:	e8 c5 01 00 00       	call   80104ce0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104b1b:	8b 03                	mov    (%ebx),%eax
80104b1d:	83 c4 10             	add    $0x10,%esp
80104b20:	85 c0                	test   %eax,%eax
80104b22:	75 1c                	jne    80104b40 <holdingsleep+0x40>
  release(&lk->lk);
80104b24:	83 ec 0c             	sub    $0xc,%esp
80104b27:	56                   	push   %esi
80104b28:	e8 73 02 00 00       	call   80104da0 <release>
  return r;
}
80104b2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b30:	89 f8                	mov    %edi,%eax
80104b32:	5b                   	pop    %ebx
80104b33:	5e                   	pop    %esi
80104b34:	5f                   	pop    %edi
80104b35:	5d                   	pop    %ebp
80104b36:	c3                   	ret    
80104b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104b40:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104b43:	e8 a8 f5 ff ff       	call   801040f0 <myproc>
80104b48:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b4b:	0f 94 c0             	sete   %al
80104b4e:	0f b6 c0             	movzbl %al,%eax
80104b51:	89 c7                	mov    %eax,%edi
80104b53:	eb cf                	jmp    80104b24 <holdingsleep+0x24>
80104b55:	66 90                	xchg   %ax,%ax
80104b57:	66 90                	xchg   %ax,%ax
80104b59:	66 90                	xchg   %ax,%ax
80104b5b:	66 90                	xchg   %ax,%ax
80104b5d:	66 90                	xchg   %ax,%ax
80104b5f:	90                   	nop

80104b60 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b60:	f3 0f 1e fb          	endbr32 
80104b64:	55                   	push   %ebp
80104b65:	89 e5                	mov    %esp,%ebp
80104b67:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104b73:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104b76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b7d:	5d                   	pop    %ebp
80104b7e:	c3                   	ret    
80104b7f:	90                   	nop

80104b80 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b85:	31 d2                	xor    %edx,%edx
{
80104b87:	89 e5                	mov    %esp,%ebp
80104b89:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104b8a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104b8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104b90:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104b93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b97:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b98:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b9e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ba4:	77 1a                	ja     80104bc0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104ba6:	8b 58 04             	mov    0x4(%eax),%ebx
80104ba9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104bac:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104baf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104bb1:	83 fa 0a             	cmp    $0xa,%edx
80104bb4:	75 e2                	jne    80104b98 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104bb6:	5b                   	pop    %ebx
80104bb7:	5d                   	pop    %ebp
80104bb8:	c3                   	ret    
80104bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104bc0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104bc3:	8d 51 28             	lea    0x28(%ecx),%edx
80104bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104bd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104bd6:	83 c0 04             	add    $0x4,%eax
80104bd9:	39 d0                	cmp    %edx,%eax
80104bdb:	75 f3                	jne    80104bd0 <getcallerpcs+0x50>
}
80104bdd:	5b                   	pop    %ebx
80104bde:	5d                   	pop    %ebp
80104bdf:	c3                   	ret    

80104be0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104be0:	f3 0f 1e fb          	endbr32 
80104be4:	55                   	push   %ebp
80104be5:	89 e5                	mov    %esp,%ebp
80104be7:	53                   	push   %ebx
80104be8:	83 ec 04             	sub    $0x4,%esp
80104beb:	9c                   	pushf  
80104bec:	5b                   	pop    %ebx
  asm volatile("cli");
80104bed:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104bee:	e8 6d f4 ff ff       	call   80104060 <mycpu>
80104bf3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104bf9:	85 c0                	test   %eax,%eax
80104bfb:	74 13                	je     80104c10 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104bfd:	e8 5e f4 ff ff       	call   80104060 <mycpu>
80104c02:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c09:	83 c4 04             	add    $0x4,%esp
80104c0c:	5b                   	pop    %ebx
80104c0d:	5d                   	pop    %ebp
80104c0e:	c3                   	ret    
80104c0f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104c10:	e8 4b f4 ff ff       	call   80104060 <mycpu>
80104c15:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104c1b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104c21:	eb da                	jmp    80104bfd <pushcli+0x1d>
80104c23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c30 <popcli>:

void
popcli(void)
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c3a:	9c                   	pushf  
80104c3b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c3c:	f6 c4 02             	test   $0x2,%ah
80104c3f:	75 31                	jne    80104c72 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c41:	e8 1a f4 ff ff       	call   80104060 <mycpu>
80104c46:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c4d:	78 30                	js     80104c7f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c4f:	e8 0c f4 ff ff       	call   80104060 <mycpu>
80104c54:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c5a:	85 d2                	test   %edx,%edx
80104c5c:	74 02                	je     80104c60 <popcli+0x30>
    sti();
}
80104c5e:	c9                   	leave  
80104c5f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c60:	e8 fb f3 ff ff       	call   80104060 <mycpu>
80104c65:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c6b:	85 c0                	test   %eax,%eax
80104c6d:	74 ef                	je     80104c5e <popcli+0x2e>
  asm volatile("sti");
80104c6f:	fb                   	sti    
}
80104c70:	c9                   	leave  
80104c71:	c3                   	ret    
    panic("popcli - interruptible");
80104c72:	83 ec 0c             	sub    $0xc,%esp
80104c75:	68 8b 83 10 80       	push   $0x8010838b
80104c7a:	e8 11 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104c7f:	83 ec 0c             	sub    $0xc,%esp
80104c82:	68 a2 83 10 80       	push   $0x801083a2
80104c87:	e8 04 b7 ff ff       	call   80100390 <panic>
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c90 <holding>:
{
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	56                   	push   %esi
80104c98:	53                   	push   %ebx
80104c99:	8b 75 08             	mov    0x8(%ebp),%esi
80104c9c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104c9e:	e8 3d ff ff ff       	call   80104be0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104ca3:	8b 06                	mov    (%esi),%eax
80104ca5:	85 c0                	test   %eax,%eax
80104ca7:	75 0f                	jne    80104cb8 <holding+0x28>
  popcli();
80104ca9:	e8 82 ff ff ff       	call   80104c30 <popcli>
}
80104cae:	89 d8                	mov    %ebx,%eax
80104cb0:	5b                   	pop    %ebx
80104cb1:	5e                   	pop    %esi
80104cb2:	5d                   	pop    %ebp
80104cb3:	c3                   	ret    
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104cb8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104cbb:	e8 a0 f3 ff ff       	call   80104060 <mycpu>
80104cc0:	39 c3                	cmp    %eax,%ebx
80104cc2:	0f 94 c3             	sete   %bl
  popcli();
80104cc5:	e8 66 ff ff ff       	call   80104c30 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104cca:	0f b6 db             	movzbl %bl,%ebx
}
80104ccd:	89 d8                	mov    %ebx,%eax
80104ccf:	5b                   	pop    %ebx
80104cd0:	5e                   	pop    %esi
80104cd1:	5d                   	pop    %ebp
80104cd2:	c3                   	ret    
80104cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ce0 <acquire>:
{
80104ce0:	f3 0f 1e fb          	endbr32 
80104ce4:	55                   	push   %ebp
80104ce5:	89 e5                	mov    %esp,%ebp
80104ce7:	56                   	push   %esi
80104ce8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104ce9:	e8 f2 fe ff ff       	call   80104be0 <pushcli>
  if(holding(lk))
80104cee:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cf1:	83 ec 0c             	sub    $0xc,%esp
80104cf4:	53                   	push   %ebx
80104cf5:	e8 96 ff ff ff       	call   80104c90 <holding>
80104cfa:	83 c4 10             	add    $0x10,%esp
80104cfd:	85 c0                	test   %eax,%eax
80104cff:	0f 85 7f 00 00 00    	jne    80104d84 <acquire+0xa4>
80104d05:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104d07:	ba 01 00 00 00       	mov    $0x1,%edx
80104d0c:	eb 05                	jmp    80104d13 <acquire+0x33>
80104d0e:	66 90                	xchg   %ax,%ax
80104d10:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d13:	89 d0                	mov    %edx,%eax
80104d15:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104d18:	85 c0                	test   %eax,%eax
80104d1a:	75 f4                	jne    80104d10 <acquire+0x30>
  __sync_synchronize();
80104d1c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104d21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d24:	e8 37 f3 ff ff       	call   80104060 <mycpu>
80104d29:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104d2c:	89 e8                	mov    %ebp,%eax
80104d2e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d30:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104d36:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104d3c:	77 22                	ja     80104d60 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104d3e:	8b 50 04             	mov    0x4(%eax),%edx
80104d41:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104d45:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104d48:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d4a:	83 fe 0a             	cmp    $0xa,%esi
80104d4d:	75 e1                	jne    80104d30 <acquire+0x50>
}
80104d4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d52:	5b                   	pop    %ebx
80104d53:	5e                   	pop    %esi
80104d54:	5d                   	pop    %ebp
80104d55:	c3                   	ret    
80104d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104d60:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104d64:	83 c3 34             	add    $0x34,%ebx
80104d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d76:	83 c0 04             	add    $0x4,%eax
80104d79:	39 d8                	cmp    %ebx,%eax
80104d7b:	75 f3                	jne    80104d70 <acquire+0x90>
}
80104d7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d80:	5b                   	pop    %ebx
80104d81:	5e                   	pop    %esi
80104d82:	5d                   	pop    %ebp
80104d83:	c3                   	ret    
    panic("acquire");
80104d84:	83 ec 0c             	sub    $0xc,%esp
80104d87:	68 a9 83 10 80       	push   $0x801083a9
80104d8c:	e8 ff b5 ff ff       	call   80100390 <panic>
80104d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9f:	90                   	nop

80104da0 <release>:
{
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	53                   	push   %ebx
80104da8:	83 ec 10             	sub    $0x10,%esp
80104dab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104dae:	53                   	push   %ebx
80104daf:	e8 dc fe ff ff       	call   80104c90 <holding>
80104db4:	83 c4 10             	add    $0x10,%esp
80104db7:	85 c0                	test   %eax,%eax
80104db9:	74 22                	je     80104ddd <release+0x3d>
  lk->pcs[0] = 0;
80104dbb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104dc2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104dc9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104dce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104dd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dd7:	c9                   	leave  
  popcli();
80104dd8:	e9 53 fe ff ff       	jmp    80104c30 <popcli>
    panic("release");
80104ddd:	83 ec 0c             	sub    $0xc,%esp
80104de0:	68 b1 83 10 80       	push   $0x801083b1
80104de5:	e8 a6 b5 ff ff       	call   80100390 <panic>
80104dea:	66 90                	xchg   %ax,%ax
80104dec:	66 90                	xchg   %ax,%ax
80104dee:	66 90                	xchg   %ax,%ax

80104df0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
80104df5:	89 e5                	mov    %esp,%ebp
80104df7:	57                   	push   %edi
80104df8:	8b 55 08             	mov    0x8(%ebp),%edx
80104dfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104dfe:	53                   	push   %ebx
80104dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104e02:	89 d7                	mov    %edx,%edi
80104e04:	09 cf                	or     %ecx,%edi
80104e06:	83 e7 03             	and    $0x3,%edi
80104e09:	75 25                	jne    80104e30 <memset+0x40>
    c &= 0xFF;
80104e0b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104e0e:	c1 e0 18             	shl    $0x18,%eax
80104e11:	89 fb                	mov    %edi,%ebx
80104e13:	c1 e9 02             	shr    $0x2,%ecx
80104e16:	c1 e3 10             	shl    $0x10,%ebx
80104e19:	09 d8                	or     %ebx,%eax
80104e1b:	09 f8                	or     %edi,%eax
80104e1d:	c1 e7 08             	shl    $0x8,%edi
80104e20:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104e22:	89 d7                	mov    %edx,%edi
80104e24:	fc                   	cld    
80104e25:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104e27:	5b                   	pop    %ebx
80104e28:	89 d0                	mov    %edx,%eax
80104e2a:	5f                   	pop    %edi
80104e2b:	5d                   	pop    %ebp
80104e2c:	c3                   	ret    
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104e30:	89 d7                	mov    %edx,%edi
80104e32:	fc                   	cld    
80104e33:	f3 aa                	rep stos %al,%es:(%edi)
80104e35:	5b                   	pop    %ebx
80104e36:	89 d0                	mov    %edx,%eax
80104e38:	5f                   	pop    %edi
80104e39:	5d                   	pop    %ebp
80104e3a:	c3                   	ret    
80104e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e3f:	90                   	nop

80104e40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e40:	f3 0f 1e fb          	endbr32 
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	56                   	push   %esi
80104e48:	8b 75 10             	mov    0x10(%ebp),%esi
80104e4b:	8b 55 08             	mov    0x8(%ebp),%edx
80104e4e:	53                   	push   %ebx
80104e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e52:	85 f6                	test   %esi,%esi
80104e54:	74 2a                	je     80104e80 <memcmp+0x40>
80104e56:	01 c6                	add    %eax,%esi
80104e58:	eb 10                	jmp    80104e6a <memcmp+0x2a>
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104e60:	83 c0 01             	add    $0x1,%eax
80104e63:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104e66:	39 f0                	cmp    %esi,%eax
80104e68:	74 16                	je     80104e80 <memcmp+0x40>
    if(*s1 != *s2)
80104e6a:	0f b6 0a             	movzbl (%edx),%ecx
80104e6d:	0f b6 18             	movzbl (%eax),%ebx
80104e70:	38 d9                	cmp    %bl,%cl
80104e72:	74 ec                	je     80104e60 <memcmp+0x20>
      return *s1 - *s2;
80104e74:	0f b6 c1             	movzbl %cl,%eax
80104e77:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104e79:	5b                   	pop    %ebx
80104e7a:	5e                   	pop    %esi
80104e7b:	5d                   	pop    %ebp
80104e7c:	c3                   	ret    
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi
80104e80:	5b                   	pop    %ebx
  return 0;
80104e81:	31 c0                	xor    %eax,%eax
}
80104e83:	5e                   	pop    %esi
80104e84:	5d                   	pop    %ebp
80104e85:	c3                   	ret    
80104e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8d:	8d 76 00             	lea    0x0(%esi),%esi

80104e90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e90:	f3 0f 1e fb          	endbr32 
80104e94:	55                   	push   %ebp
80104e95:	89 e5                	mov    %esp,%ebp
80104e97:	57                   	push   %edi
80104e98:	8b 55 08             	mov    0x8(%ebp),%edx
80104e9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e9e:	56                   	push   %esi
80104e9f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ea2:	39 d6                	cmp    %edx,%esi
80104ea4:	73 2a                	jae    80104ed0 <memmove+0x40>
80104ea6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104ea9:	39 fa                	cmp    %edi,%edx
80104eab:	73 23                	jae    80104ed0 <memmove+0x40>
80104ead:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104eb0:	85 c9                	test   %ecx,%ecx
80104eb2:	74 13                	je     80104ec7 <memmove+0x37>
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104eb8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104ebc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104ebf:	83 e8 01             	sub    $0x1,%eax
80104ec2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104ec5:	75 f1                	jne    80104eb8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104ec7:	5e                   	pop    %esi
80104ec8:	89 d0                	mov    %edx,%eax
80104eca:	5f                   	pop    %edi
80104ecb:	5d                   	pop    %ebp
80104ecc:	c3                   	ret    
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104ed0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104ed3:	89 d7                	mov    %edx,%edi
80104ed5:	85 c9                	test   %ecx,%ecx
80104ed7:	74 ee                	je     80104ec7 <memmove+0x37>
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104ee0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104ee1:	39 f0                	cmp    %esi,%eax
80104ee3:	75 fb                	jne    80104ee0 <memmove+0x50>
}
80104ee5:	5e                   	pop    %esi
80104ee6:	89 d0                	mov    %edx,%eax
80104ee8:	5f                   	pop    %edi
80104ee9:	5d                   	pop    %ebp
80104eea:	c3                   	ret    
80104eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eef:	90                   	nop

80104ef0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104ef0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104ef4:	eb 9a                	jmp    80104e90 <memmove>
80104ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efd:	8d 76 00             	lea    0x0(%esi),%esi

80104f00 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	56                   	push   %esi
80104f08:	8b 75 10             	mov    0x10(%ebp),%esi
80104f0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f0e:	53                   	push   %ebx
80104f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104f12:	85 f6                	test   %esi,%esi
80104f14:	74 32                	je     80104f48 <strncmp+0x48>
80104f16:	01 c6                	add    %eax,%esi
80104f18:	eb 14                	jmp    80104f2e <strncmp+0x2e>
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f20:	38 da                	cmp    %bl,%dl
80104f22:	75 14                	jne    80104f38 <strncmp+0x38>
    n--, p++, q++;
80104f24:	83 c0 01             	add    $0x1,%eax
80104f27:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104f2a:	39 f0                	cmp    %esi,%eax
80104f2c:	74 1a                	je     80104f48 <strncmp+0x48>
80104f2e:	0f b6 11             	movzbl (%ecx),%edx
80104f31:	0f b6 18             	movzbl (%eax),%ebx
80104f34:	84 d2                	test   %dl,%dl
80104f36:	75 e8                	jne    80104f20 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104f38:	0f b6 c2             	movzbl %dl,%eax
80104f3b:	29 d8                	sub    %ebx,%eax
}
80104f3d:	5b                   	pop    %ebx
80104f3e:	5e                   	pop    %esi
80104f3f:	5d                   	pop    %ebp
80104f40:	c3                   	ret    
80104f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f48:	5b                   	pop    %ebx
    return 0;
80104f49:	31 c0                	xor    %eax,%eax
}
80104f4b:	5e                   	pop    %esi
80104f4c:	5d                   	pop    %ebp
80104f4d:	c3                   	ret    
80104f4e:	66 90                	xchg   %ax,%ax

80104f50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	57                   	push   %edi
80104f58:	56                   	push   %esi
80104f59:	8b 75 08             	mov    0x8(%ebp),%esi
80104f5c:	53                   	push   %ebx
80104f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f60:	89 f2                	mov    %esi,%edx
80104f62:	eb 1b                	jmp    80104f7f <strncpy+0x2f>
80104f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f68:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104f6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104f6f:	83 c2 01             	add    $0x1,%edx
80104f72:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104f76:	89 f9                	mov    %edi,%ecx
80104f78:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f7b:	84 c9                	test   %cl,%cl
80104f7d:	74 09                	je     80104f88 <strncpy+0x38>
80104f7f:	89 c3                	mov    %eax,%ebx
80104f81:	83 e8 01             	sub    $0x1,%eax
80104f84:	85 db                	test   %ebx,%ebx
80104f86:	7f e0                	jg     80104f68 <strncpy+0x18>
    ;
  while(n-- > 0)
80104f88:	89 d1                	mov    %edx,%ecx
80104f8a:	85 c0                	test   %eax,%eax
80104f8c:	7e 15                	jle    80104fa3 <strncpy+0x53>
80104f8e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104f90:	83 c1 01             	add    $0x1,%ecx
80104f93:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104f97:	89 c8                	mov    %ecx,%eax
80104f99:	f7 d0                	not    %eax
80104f9b:	01 d0                	add    %edx,%eax
80104f9d:	01 d8                	add    %ebx,%eax
80104f9f:	85 c0                	test   %eax,%eax
80104fa1:	7f ed                	jg     80104f90 <strncpy+0x40>
  return os;
}
80104fa3:	5b                   	pop    %ebx
80104fa4:	89 f0                	mov    %esi,%eax
80104fa6:	5e                   	pop    %esi
80104fa7:	5f                   	pop    %edi
80104fa8:	5d                   	pop    %ebp
80104fa9:	c3                   	ret    
80104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fb0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	56                   	push   %esi
80104fb8:	8b 55 10             	mov    0x10(%ebp),%edx
80104fbb:	8b 75 08             	mov    0x8(%ebp),%esi
80104fbe:	53                   	push   %ebx
80104fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104fc2:	85 d2                	test   %edx,%edx
80104fc4:	7e 21                	jle    80104fe7 <safestrcpy+0x37>
80104fc6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104fca:	89 f2                	mov    %esi,%edx
80104fcc:	eb 12                	jmp    80104fe0 <safestrcpy+0x30>
80104fce:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104fd0:	0f b6 08             	movzbl (%eax),%ecx
80104fd3:	83 c0 01             	add    $0x1,%eax
80104fd6:	83 c2 01             	add    $0x1,%edx
80104fd9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104fdc:	84 c9                	test   %cl,%cl
80104fde:	74 04                	je     80104fe4 <safestrcpy+0x34>
80104fe0:	39 d8                	cmp    %ebx,%eax
80104fe2:	75 ec                	jne    80104fd0 <safestrcpy+0x20>
    ;
  *s = 0;
80104fe4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104fe7:	89 f0                	mov    %esi,%eax
80104fe9:	5b                   	pop    %ebx
80104fea:	5e                   	pop    %esi
80104feb:	5d                   	pop    %ebp
80104fec:	c3                   	ret    
80104fed:	8d 76 00             	lea    0x0(%esi),%esi

80104ff0 <strlen>:

int
strlen(const char *s)
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ff5:	31 c0                	xor    %eax,%eax
{
80104ff7:	89 e5                	mov    %esp,%ebp
80104ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ffc:	80 3a 00             	cmpb   $0x0,(%edx)
80104fff:	74 10                	je     80105011 <strlen+0x21>
80105001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105008:	83 c0 01             	add    $0x1,%eax
8010500b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010500f:	75 f7                	jne    80105008 <strlen+0x18>
    ;
  return n;
}
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret    

80105013 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105013:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105017:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010501b:	55                   	push   %ebp
  pushl %ebx
8010501c:	53                   	push   %ebx
  pushl %esi
8010501d:	56                   	push   %esi
  pushl %edi
8010501e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010501f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105021:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105023:	5f                   	pop    %edi
  popl %esi
80105024:	5e                   	pop    %esi
  popl %ebx
80105025:	5b                   	pop    %ebx
  popl %ebp
80105026:	5d                   	pop    %ebp
  ret
80105027:	c3                   	ret    
80105028:	66 90                	xchg   %ax,%ax
8010502a:	66 90                	xchg   %ax,%ax
8010502c:	66 90                	xchg   %ax,%ax
8010502e:	66 90                	xchg   %ax,%ax

80105030 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105030:	f3 0f 1e fb          	endbr32 
80105034:	55                   	push   %ebp
80105035:	89 e5                	mov    %esp,%ebp
80105037:	53                   	push   %ebx
80105038:	83 ec 04             	sub    $0x4,%esp
8010503b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010503e:	e8 ad f0 ff ff       	call   801040f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105043:	8b 00                	mov    (%eax),%eax
80105045:	39 d8                	cmp    %ebx,%eax
80105047:	76 17                	jbe    80105060 <fetchint+0x30>
80105049:	8d 53 04             	lea    0x4(%ebx),%edx
8010504c:	39 d0                	cmp    %edx,%eax
8010504e:	72 10                	jb     80105060 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105050:	8b 45 0c             	mov    0xc(%ebp),%eax
80105053:	8b 13                	mov    (%ebx),%edx
80105055:	89 10                	mov    %edx,(%eax)
  return 0;
80105057:	31 c0                	xor    %eax,%eax
}
80105059:	83 c4 04             	add    $0x4,%esp
8010505c:	5b                   	pop    %ebx
8010505d:	5d                   	pop    %ebp
8010505e:	c3                   	ret    
8010505f:	90                   	nop
    return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105065:	eb f2                	jmp    80105059 <fetchint+0x29>
80105067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506e:	66 90                	xchg   %ax,%ax

80105070 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105070:	f3 0f 1e fb          	endbr32 
80105074:	55                   	push   %ebp
80105075:	89 e5                	mov    %esp,%ebp
80105077:	53                   	push   %ebx
80105078:	83 ec 04             	sub    $0x4,%esp
8010507b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010507e:	e8 6d f0 ff ff       	call   801040f0 <myproc>

  if(addr >= curproc->sz)
80105083:	39 18                	cmp    %ebx,(%eax)
80105085:	76 31                	jbe    801050b8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105087:	8b 55 0c             	mov    0xc(%ebp),%edx
8010508a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010508c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010508e:	39 d3                	cmp    %edx,%ebx
80105090:	73 26                	jae    801050b8 <fetchstr+0x48>
80105092:	89 d8                	mov    %ebx,%eax
80105094:	eb 11                	jmp    801050a7 <fetchstr+0x37>
80105096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509d:	8d 76 00             	lea    0x0(%esi),%esi
801050a0:	83 c0 01             	add    $0x1,%eax
801050a3:	39 c2                	cmp    %eax,%edx
801050a5:	76 11                	jbe    801050b8 <fetchstr+0x48>
    if(*s == 0)
801050a7:	80 38 00             	cmpb   $0x0,(%eax)
801050aa:	75 f4                	jne    801050a0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801050ac:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801050af:	29 d8                	sub    %ebx,%eax
}
801050b1:	5b                   	pop    %ebx
801050b2:	5d                   	pop    %ebp
801050b3:	c3                   	ret    
801050b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050b8:	83 c4 04             	add    $0x4,%esp
    return -1;
801050bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050c0:	5b                   	pop    %ebx
801050c1:	5d                   	pop    %ebp
801050c2:	c3                   	ret    
801050c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050d0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801050d0:	f3 0f 1e fb          	endbr32 
801050d4:	55                   	push   %ebp
801050d5:	89 e5                	mov    %esp,%ebp
801050d7:	56                   	push   %esi
801050d8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050d9:	e8 12 f0 ff ff       	call   801040f0 <myproc>
801050de:	8b 55 08             	mov    0x8(%ebp),%edx
801050e1:	8b 40 18             	mov    0x18(%eax),%eax
801050e4:	8b 40 44             	mov    0x44(%eax),%eax
801050e7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050ea:	e8 01 f0 ff ff       	call   801040f0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050ef:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050f2:	8b 00                	mov    (%eax),%eax
801050f4:	39 c6                	cmp    %eax,%esi
801050f6:	73 18                	jae    80105110 <argint+0x40>
801050f8:	8d 53 08             	lea    0x8(%ebx),%edx
801050fb:	39 d0                	cmp    %edx,%eax
801050fd:	72 11                	jb     80105110 <argint+0x40>
  *ip = *(int*)(addr);
801050ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105102:	8b 53 04             	mov    0x4(%ebx),%edx
80105105:	89 10                	mov    %edx,(%eax)
  return 0;
80105107:	31 c0                	xor    %eax,%eax
}
80105109:	5b                   	pop    %ebx
8010510a:	5e                   	pop    %esi
8010510b:	5d                   	pop    %ebp
8010510c:	c3                   	ret    
8010510d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105115:	eb f2                	jmp    80105109 <argint+0x39>
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax

80105120 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	56                   	push   %esi
80105128:	53                   	push   %ebx
80105129:	83 ec 10             	sub    $0x10,%esp
8010512c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010512f:	e8 bc ef ff ff       	call   801040f0 <myproc>
 
  if(argint(n, &i) < 0)
80105134:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105137:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105139:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010513c:	50                   	push   %eax
8010513d:	ff 75 08             	pushl  0x8(%ebp)
80105140:	e8 8b ff ff ff       	call   801050d0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105145:	83 c4 10             	add    $0x10,%esp
80105148:	85 c0                	test   %eax,%eax
8010514a:	78 24                	js     80105170 <argptr+0x50>
8010514c:	85 db                	test   %ebx,%ebx
8010514e:	78 20                	js     80105170 <argptr+0x50>
80105150:	8b 16                	mov    (%esi),%edx
80105152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105155:	39 c2                	cmp    %eax,%edx
80105157:	76 17                	jbe    80105170 <argptr+0x50>
80105159:	01 c3                	add    %eax,%ebx
8010515b:	39 da                	cmp    %ebx,%edx
8010515d:	72 11                	jb     80105170 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010515f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105162:	89 02                	mov    %eax,(%edx)
  return 0;
80105164:	31 c0                	xor    %eax,%eax
}
80105166:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105169:	5b                   	pop    %ebx
8010516a:	5e                   	pop    %esi
8010516b:	5d                   	pop    %ebp
8010516c:	c3                   	ret    
8010516d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105175:	eb ef                	jmp    80105166 <argptr+0x46>
80105177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517e:	66 90                	xchg   %ax,%ax

80105180 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010518a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010518d:	50                   	push   %eax
8010518e:	ff 75 08             	pushl  0x8(%ebp)
80105191:	e8 3a ff ff ff       	call   801050d0 <argint>
80105196:	83 c4 10             	add    $0x10,%esp
80105199:	85 c0                	test   %eax,%eax
8010519b:	78 13                	js     801051b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010519d:	83 ec 08             	sub    $0x8,%esp
801051a0:	ff 75 0c             	pushl  0xc(%ebp)
801051a3:	ff 75 f4             	pushl  -0xc(%ebp)
801051a6:	e8 c5 fe ff ff       	call   80105070 <fetchstr>
801051ab:	83 c4 10             	add    $0x10,%esp
}
801051ae:	c9                   	leave  
801051af:	c3                   	ret    
801051b0:	c9                   	leave  
    return -1;
801051b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051b6:	c3                   	ret    
801051b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051be:	66 90                	xchg   %ax,%ax

801051c0 <syscall>:
[SYS_swapstat] sys_swapstat,
};

void
syscall(void)
{
801051c0:	f3 0f 1e fb          	endbr32 
801051c4:	55                   	push   %ebp
801051c5:	89 e5                	mov    %esp,%ebp
801051c7:	53                   	push   %ebx
801051c8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801051cb:	e8 20 ef ff ff       	call   801040f0 <myproc>
801051d0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801051d2:	8b 40 18             	mov    0x18(%eax),%eax
801051d5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801051d8:	8d 50 ff             	lea    -0x1(%eax),%edx
801051db:	83 fa 17             	cmp    $0x17,%edx
801051de:	77 20                	ja     80105200 <syscall+0x40>
801051e0:	8b 14 85 e0 83 10 80 	mov    -0x7fef7c20(,%eax,4),%edx
801051e7:	85 d2                	test   %edx,%edx
801051e9:	74 15                	je     80105200 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801051eb:	ff d2                	call   *%edx
801051ed:	89 c2                	mov    %eax,%edx
801051ef:	8b 43 18             	mov    0x18(%ebx),%eax
801051f2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801051f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051f8:	c9                   	leave  
801051f9:	c3                   	ret    
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105200:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105201:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105204:	50                   	push   %eax
80105205:	ff 73 10             	pushl  0x10(%ebx)
80105208:	68 b9 83 10 80       	push   $0x801083b9
8010520d:	e8 9e b4 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105212:	8b 43 18             	mov    0x18(%ebx),%eax
80105215:	83 c4 10             	add    $0x10,%esp
80105218:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010521f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105222:	c9                   	leave  
80105223:	c3                   	ret    
80105224:	66 90                	xchg   %ax,%ax
80105226:	66 90                	xchg   %ax,%ax
80105228:	66 90                	xchg   %ax,%ax
8010522a:	66 90                	xchg   %ax,%ax
8010522c:	66 90                	xchg   %ax,%ax
8010522e:	66 90                	xchg   %ax,%ax

80105230 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	57                   	push   %edi
80105234:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105235:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105238:	53                   	push   %ebx
80105239:	83 ec 44             	sub    $0x44,%esp
8010523c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010523f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105242:	57                   	push   %edi
80105243:	50                   	push   %eax
{
80105244:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105247:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010524a:	e8 01 ce ff ff       	call   80102050 <nameiparent>
8010524f:	83 c4 10             	add    $0x10,%esp
80105252:	85 c0                	test   %eax,%eax
80105254:	0f 84 46 01 00 00    	je     801053a0 <create+0x170>
    return 0;
  ilock(dp);
8010525a:	83 ec 0c             	sub    $0xc,%esp
8010525d:	89 c3                	mov    %eax,%ebx
8010525f:	50                   	push   %eax
80105260:	e8 fb c4 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105265:	83 c4 0c             	add    $0xc,%esp
80105268:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010526b:	50                   	push   %eax
8010526c:	57                   	push   %edi
8010526d:	53                   	push   %ebx
8010526e:	e8 3d ca ff ff       	call   80101cb0 <dirlookup>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	89 c6                	mov    %eax,%esi
80105278:	85 c0                	test   %eax,%eax
8010527a:	74 54                	je     801052d0 <create+0xa0>
    iunlockput(dp);
8010527c:	83 ec 0c             	sub    $0xc,%esp
8010527f:	53                   	push   %ebx
80105280:	e8 7b c7 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105285:	89 34 24             	mov    %esi,(%esp)
80105288:	e8 d3 c4 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010528d:	83 c4 10             	add    $0x10,%esp
80105290:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105295:	75 19                	jne    801052b0 <create+0x80>
80105297:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010529c:	75 12                	jne    801052b0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010529e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052a1:	89 f0                	mov    %esi,%eax
801052a3:	5b                   	pop    %ebx
801052a4:	5e                   	pop    %esi
801052a5:	5f                   	pop    %edi
801052a6:	5d                   	pop    %ebp
801052a7:	c3                   	ret    
801052a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052af:	90                   	nop
    iunlockput(ip);
801052b0:	83 ec 0c             	sub    $0xc,%esp
801052b3:	56                   	push   %esi
    return 0;
801052b4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801052b6:	e8 45 c7 ff ff       	call   80101a00 <iunlockput>
    return 0;
801052bb:	83 c4 10             	add    $0x10,%esp
}
801052be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052c1:	89 f0                	mov    %esi,%eax
801052c3:	5b                   	pop    %ebx
801052c4:	5e                   	pop    %esi
801052c5:	5f                   	pop    %edi
801052c6:	5d                   	pop    %ebp
801052c7:	c3                   	ret    
801052c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052cf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801052d0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801052d4:	83 ec 08             	sub    $0x8,%esp
801052d7:	50                   	push   %eax
801052d8:	ff 33                	pushl  (%ebx)
801052da:	e8 01 c3 ff ff       	call   801015e0 <ialloc>
801052df:	83 c4 10             	add    $0x10,%esp
801052e2:	89 c6                	mov    %eax,%esi
801052e4:	85 c0                	test   %eax,%eax
801052e6:	0f 84 cd 00 00 00    	je     801053b9 <create+0x189>
  ilock(ip);
801052ec:	83 ec 0c             	sub    $0xc,%esp
801052ef:	50                   	push   %eax
801052f0:	e8 6b c4 ff ff       	call   80101760 <ilock>
  ip->major = major;
801052f5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801052f9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801052fd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105301:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105305:	b8 01 00 00 00       	mov    $0x1,%eax
8010530a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010530e:	89 34 24             	mov    %esi,(%esp)
80105311:	e8 8a c3 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105316:	83 c4 10             	add    $0x10,%esp
80105319:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010531e:	74 30                	je     80105350 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105320:	83 ec 04             	sub    $0x4,%esp
80105323:	ff 76 04             	pushl  0x4(%esi)
80105326:	57                   	push   %edi
80105327:	53                   	push   %ebx
80105328:	e8 43 cc ff ff       	call   80101f70 <dirlink>
8010532d:	83 c4 10             	add    $0x10,%esp
80105330:	85 c0                	test   %eax,%eax
80105332:	78 78                	js     801053ac <create+0x17c>
  iunlockput(dp);
80105334:	83 ec 0c             	sub    $0xc,%esp
80105337:	53                   	push   %ebx
80105338:	e8 c3 c6 ff ff       	call   80101a00 <iunlockput>
  return ip;
8010533d:	83 c4 10             	add    $0x10,%esp
}
80105340:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105343:	89 f0                	mov    %esi,%eax
80105345:	5b                   	pop    %ebx
80105346:	5e                   	pop    %esi
80105347:	5f                   	pop    %edi
80105348:	5d                   	pop    %ebp
80105349:	c3                   	ret    
8010534a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105350:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105353:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105358:	53                   	push   %ebx
80105359:	e8 42 c3 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010535e:	83 c4 0c             	add    $0xc,%esp
80105361:	ff 76 04             	pushl  0x4(%esi)
80105364:	68 60 84 10 80       	push   $0x80108460
80105369:	56                   	push   %esi
8010536a:	e8 01 cc ff ff       	call   80101f70 <dirlink>
8010536f:	83 c4 10             	add    $0x10,%esp
80105372:	85 c0                	test   %eax,%eax
80105374:	78 18                	js     8010538e <create+0x15e>
80105376:	83 ec 04             	sub    $0x4,%esp
80105379:	ff 73 04             	pushl  0x4(%ebx)
8010537c:	68 5f 84 10 80       	push   $0x8010845f
80105381:	56                   	push   %esi
80105382:	e8 e9 cb ff ff       	call   80101f70 <dirlink>
80105387:	83 c4 10             	add    $0x10,%esp
8010538a:	85 c0                	test   %eax,%eax
8010538c:	79 92                	jns    80105320 <create+0xf0>
      panic("create dots");
8010538e:	83 ec 0c             	sub    $0xc,%esp
80105391:	68 53 84 10 80       	push   $0x80108453
80105396:	e8 f5 af ff ff       	call   80100390 <panic>
8010539b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010539f:	90                   	nop
}
801053a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801053a3:	31 f6                	xor    %esi,%esi
}
801053a5:	5b                   	pop    %ebx
801053a6:	89 f0                	mov    %esi,%eax
801053a8:	5e                   	pop    %esi
801053a9:	5f                   	pop    %edi
801053aa:	5d                   	pop    %ebp
801053ab:	c3                   	ret    
    panic("create: dirlink");
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	68 62 84 10 80       	push   $0x80108462
801053b4:	e8 d7 af ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801053b9:	83 ec 0c             	sub    $0xc,%esp
801053bc:	68 44 84 10 80       	push   $0x80108444
801053c1:	e8 ca af ff ff       	call   80100390 <panic>
801053c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053cd:	8d 76 00             	lea    0x0(%esi),%esi

801053d0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	56                   	push   %esi
801053d4:	89 d6                	mov    %edx,%esi
801053d6:	53                   	push   %ebx
801053d7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801053d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801053dc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801053df:	50                   	push   %eax
801053e0:	6a 00                	push   $0x0
801053e2:	e8 e9 fc ff ff       	call   801050d0 <argint>
801053e7:	83 c4 10             	add    $0x10,%esp
801053ea:	85 c0                	test   %eax,%eax
801053ec:	78 2a                	js     80105418 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053ee:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053f2:	77 24                	ja     80105418 <argfd.constprop.0+0x48>
801053f4:	e8 f7 ec ff ff       	call   801040f0 <myproc>
801053f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053fc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105400:	85 c0                	test   %eax,%eax
80105402:	74 14                	je     80105418 <argfd.constprop.0+0x48>
  if(pfd)
80105404:	85 db                	test   %ebx,%ebx
80105406:	74 02                	je     8010540a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105408:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010540a:	89 06                	mov    %eax,(%esi)
  return 0;
8010540c:	31 c0                	xor    %eax,%eax
}
8010540e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105411:	5b                   	pop    %ebx
80105412:	5e                   	pop    %esi
80105413:	5d                   	pop    %ebp
80105414:	c3                   	ret    
80105415:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541d:	eb ef                	jmp    8010540e <argfd.constprop.0+0x3e>
8010541f:	90                   	nop

80105420 <sys_dup>:
{
80105420:	f3 0f 1e fb          	endbr32 
80105424:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105425:	31 c0                	xor    %eax,%eax
{
80105427:	89 e5                	mov    %esp,%ebp
80105429:	56                   	push   %esi
8010542a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010542b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010542e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105431:	e8 9a ff ff ff       	call   801053d0 <argfd.constprop.0>
80105436:	85 c0                	test   %eax,%eax
80105438:	78 1e                	js     80105458 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010543a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010543d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010543f:	e8 ac ec ff ff       	call   801040f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105448:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010544c:	85 d2                	test   %edx,%edx
8010544e:	74 20                	je     80105470 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105450:	83 c3 01             	add    $0x1,%ebx
80105453:	83 fb 10             	cmp    $0x10,%ebx
80105456:	75 f0                	jne    80105448 <sys_dup+0x28>
}
80105458:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010545b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105460:	89 d8                	mov    %ebx,%eax
80105462:	5b                   	pop    %ebx
80105463:	5e                   	pop    %esi
80105464:	5d                   	pop    %ebp
80105465:	c3                   	ret    
80105466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105470:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105474:	83 ec 0c             	sub    $0xc,%esp
80105477:	ff 75 f4             	pushl  -0xc(%ebp)
8010547a:	e8 f1 b9 ff ff       	call   80100e70 <filedup>
  return fd;
8010547f:	83 c4 10             	add    $0x10,%esp
}
80105482:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105485:	89 d8                	mov    %ebx,%eax
80105487:	5b                   	pop    %ebx
80105488:	5e                   	pop    %esi
80105489:	5d                   	pop    %ebp
8010548a:	c3                   	ret    
8010548b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010548f:	90                   	nop

80105490 <sys_read>:
{
80105490:	f3 0f 1e fb          	endbr32 
80105494:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105495:	31 c0                	xor    %eax,%eax
{
80105497:	89 e5                	mov    %esp,%ebp
80105499:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010549c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010549f:	e8 2c ff ff ff       	call   801053d0 <argfd.constprop.0>
801054a4:	85 c0                	test   %eax,%eax
801054a6:	78 48                	js     801054f0 <sys_read+0x60>
801054a8:	83 ec 08             	sub    $0x8,%esp
801054ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054ae:	50                   	push   %eax
801054af:	6a 02                	push   $0x2
801054b1:	e8 1a fc ff ff       	call   801050d0 <argint>
801054b6:	83 c4 10             	add    $0x10,%esp
801054b9:	85 c0                	test   %eax,%eax
801054bb:	78 33                	js     801054f0 <sys_read+0x60>
801054bd:	83 ec 04             	sub    $0x4,%esp
801054c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054c3:	ff 75 f0             	pushl  -0x10(%ebp)
801054c6:	50                   	push   %eax
801054c7:	6a 01                	push   $0x1
801054c9:	e8 52 fc ff ff       	call   80105120 <argptr>
801054ce:	83 c4 10             	add    $0x10,%esp
801054d1:	85 c0                	test   %eax,%eax
801054d3:	78 1b                	js     801054f0 <sys_read+0x60>
  return fileread(f, p, n);
801054d5:	83 ec 04             	sub    $0x4,%esp
801054d8:	ff 75 f0             	pushl  -0x10(%ebp)
801054db:	ff 75 f4             	pushl  -0xc(%ebp)
801054de:	ff 75 ec             	pushl  -0x14(%ebp)
801054e1:	e8 0a bb ff ff       	call   80100ff0 <fileread>
801054e6:	83 c4 10             	add    $0x10,%esp
}
801054e9:	c9                   	leave  
801054ea:	c3                   	ret    
801054eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054ef:	90                   	nop
801054f0:	c9                   	leave  
    return -1;
801054f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054f6:	c3                   	ret    
801054f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054fe:	66 90                	xchg   %ax,%ax

80105500 <sys_write>:
{
80105500:	f3 0f 1e fb          	endbr32 
80105504:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105505:	31 c0                	xor    %eax,%eax
{
80105507:	89 e5                	mov    %esp,%ebp
80105509:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010550c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010550f:	e8 bc fe ff ff       	call   801053d0 <argfd.constprop.0>
80105514:	85 c0                	test   %eax,%eax
80105516:	78 48                	js     80105560 <sys_write+0x60>
80105518:	83 ec 08             	sub    $0x8,%esp
8010551b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010551e:	50                   	push   %eax
8010551f:	6a 02                	push   $0x2
80105521:	e8 aa fb ff ff       	call   801050d0 <argint>
80105526:	83 c4 10             	add    $0x10,%esp
80105529:	85 c0                	test   %eax,%eax
8010552b:	78 33                	js     80105560 <sys_write+0x60>
8010552d:	83 ec 04             	sub    $0x4,%esp
80105530:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105533:	ff 75 f0             	pushl  -0x10(%ebp)
80105536:	50                   	push   %eax
80105537:	6a 01                	push   $0x1
80105539:	e8 e2 fb ff ff       	call   80105120 <argptr>
8010553e:	83 c4 10             	add    $0x10,%esp
80105541:	85 c0                	test   %eax,%eax
80105543:	78 1b                	js     80105560 <sys_write+0x60>
  return filewrite(f, p, n);
80105545:	83 ec 04             	sub    $0x4,%esp
80105548:	ff 75 f0             	pushl  -0x10(%ebp)
8010554b:	ff 75 f4             	pushl  -0xc(%ebp)
8010554e:	ff 75 ec             	pushl  -0x14(%ebp)
80105551:	e8 3a bb ff ff       	call   80101090 <filewrite>
80105556:	83 c4 10             	add    $0x10,%esp
}
80105559:	c9                   	leave  
8010555a:	c3                   	ret    
8010555b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010555f:	90                   	nop
80105560:	c9                   	leave  
    return -1;
80105561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105566:	c3                   	ret    
80105567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556e:	66 90                	xchg   %ax,%ax

80105570 <sys_close>:
{
80105570:	f3 0f 1e fb          	endbr32 
80105574:	55                   	push   %ebp
80105575:	89 e5                	mov    %esp,%ebp
80105577:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010557a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010557d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105580:	e8 4b fe ff ff       	call   801053d0 <argfd.constprop.0>
80105585:	85 c0                	test   %eax,%eax
80105587:	78 27                	js     801055b0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105589:	e8 62 eb ff ff       	call   801040f0 <myproc>
8010558e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105591:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105594:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010559b:	00 
  fileclose(f);
8010559c:	ff 75 f4             	pushl  -0xc(%ebp)
8010559f:	e8 1c b9 ff ff       	call   80100ec0 <fileclose>
  return 0;
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	31 c0                	xor    %eax,%eax
}
801055a9:	c9                   	leave  
801055aa:	c3                   	ret    
801055ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055af:	90                   	nop
801055b0:	c9                   	leave  
    return -1;
801055b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055b6:	c3                   	ret    
801055b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055be:	66 90                	xchg   %ax,%ax

801055c0 <sys_fstat>:
{
801055c0:	f3 0f 1e fb          	endbr32 
801055c4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801055c5:	31 c0                	xor    %eax,%eax
{
801055c7:	89 e5                	mov    %esp,%ebp
801055c9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801055cc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801055cf:	e8 fc fd ff ff       	call   801053d0 <argfd.constprop.0>
801055d4:	85 c0                	test   %eax,%eax
801055d6:	78 30                	js     80105608 <sys_fstat+0x48>
801055d8:	83 ec 04             	sub    $0x4,%esp
801055db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055de:	6a 14                	push   $0x14
801055e0:	50                   	push   %eax
801055e1:	6a 01                	push   $0x1
801055e3:	e8 38 fb ff ff       	call   80105120 <argptr>
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	85 c0                	test   %eax,%eax
801055ed:	78 19                	js     80105608 <sys_fstat+0x48>
  return filestat(f, st);
801055ef:	83 ec 08             	sub    $0x8,%esp
801055f2:	ff 75 f4             	pushl  -0xc(%ebp)
801055f5:	ff 75 f0             	pushl  -0x10(%ebp)
801055f8:	e8 a3 b9 ff ff       	call   80100fa0 <filestat>
801055fd:	83 c4 10             	add    $0x10,%esp
}
80105600:	c9                   	leave  
80105601:	c3                   	ret    
80105602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105608:	c9                   	leave  
    return -1;
80105609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010560e:	c3                   	ret    
8010560f:	90                   	nop

80105610 <sys_link>:
{
80105610:	f3 0f 1e fb          	endbr32 
80105614:	55                   	push   %ebp
80105615:	89 e5                	mov    %esp,%ebp
80105617:	57                   	push   %edi
80105618:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105619:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010561c:	53                   	push   %ebx
8010561d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105620:	50                   	push   %eax
80105621:	6a 00                	push   $0x0
80105623:	e8 58 fb ff ff       	call   80105180 <argstr>
80105628:	83 c4 10             	add    $0x10,%esp
8010562b:	85 c0                	test   %eax,%eax
8010562d:	0f 88 ff 00 00 00    	js     80105732 <sys_link+0x122>
80105633:	83 ec 08             	sub    $0x8,%esp
80105636:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105639:	50                   	push   %eax
8010563a:	6a 01                	push   $0x1
8010563c:	e8 3f fb ff ff       	call   80105180 <argstr>
80105641:	83 c4 10             	add    $0x10,%esp
80105644:	85 c0                	test   %eax,%eax
80105646:	0f 88 e6 00 00 00    	js     80105732 <sys_link+0x122>
  begin_op();
8010564c:	e8 5f de ff ff       	call   801034b0 <begin_op>
  if((ip = namei(old)) == 0){
80105651:	83 ec 0c             	sub    $0xc,%esp
80105654:	ff 75 d4             	pushl  -0x2c(%ebp)
80105657:	e8 d4 c9 ff ff       	call   80102030 <namei>
8010565c:	83 c4 10             	add    $0x10,%esp
8010565f:	89 c3                	mov    %eax,%ebx
80105661:	85 c0                	test   %eax,%eax
80105663:	0f 84 e8 00 00 00    	je     80105751 <sys_link+0x141>
  ilock(ip);
80105669:	83 ec 0c             	sub    $0xc,%esp
8010566c:	50                   	push   %eax
8010566d:	e8 ee c0 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010567a:	0f 84 b9 00 00 00    	je     80105739 <sys_link+0x129>
  iupdate(ip);
80105680:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105683:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105688:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010568b:	53                   	push   %ebx
8010568c:	e8 0f c0 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105691:	89 1c 24             	mov    %ebx,(%esp)
80105694:	e8 a7 c1 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105699:	58                   	pop    %eax
8010569a:	5a                   	pop    %edx
8010569b:	57                   	push   %edi
8010569c:	ff 75 d0             	pushl  -0x30(%ebp)
8010569f:	e8 ac c9 ff ff       	call   80102050 <nameiparent>
801056a4:	83 c4 10             	add    $0x10,%esp
801056a7:	89 c6                	mov    %eax,%esi
801056a9:	85 c0                	test   %eax,%eax
801056ab:	74 5f                	je     8010570c <sys_link+0xfc>
  ilock(dp);
801056ad:	83 ec 0c             	sub    $0xc,%esp
801056b0:	50                   	push   %eax
801056b1:	e8 aa c0 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801056b6:	8b 03                	mov    (%ebx),%eax
801056b8:	83 c4 10             	add    $0x10,%esp
801056bb:	39 06                	cmp    %eax,(%esi)
801056bd:	75 41                	jne    80105700 <sys_link+0xf0>
801056bf:	83 ec 04             	sub    $0x4,%esp
801056c2:	ff 73 04             	pushl  0x4(%ebx)
801056c5:	57                   	push   %edi
801056c6:	56                   	push   %esi
801056c7:	e8 a4 c8 ff ff       	call   80101f70 <dirlink>
801056cc:	83 c4 10             	add    $0x10,%esp
801056cf:	85 c0                	test   %eax,%eax
801056d1:	78 2d                	js     80105700 <sys_link+0xf0>
  iunlockput(dp);
801056d3:	83 ec 0c             	sub    $0xc,%esp
801056d6:	56                   	push   %esi
801056d7:	e8 24 c3 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
801056dc:	89 1c 24             	mov    %ebx,(%esp)
801056df:	e8 ac c1 ff ff       	call   80101890 <iput>
  end_op();
801056e4:	e8 37 de ff ff       	call   80103520 <end_op>
  return 0;
801056e9:	83 c4 10             	add    $0x10,%esp
801056ec:	31 c0                	xor    %eax,%eax
}
801056ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056f1:	5b                   	pop    %ebx
801056f2:	5e                   	pop    %esi
801056f3:	5f                   	pop    %edi
801056f4:	5d                   	pop    %ebp
801056f5:	c3                   	ret    
801056f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	56                   	push   %esi
80105704:	e8 f7 c2 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105709:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010570c:	83 ec 0c             	sub    $0xc,%esp
8010570f:	53                   	push   %ebx
80105710:	e8 4b c0 ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105715:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010571a:	89 1c 24             	mov    %ebx,(%esp)
8010571d:	e8 7e bf ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105722:	89 1c 24             	mov    %ebx,(%esp)
80105725:	e8 d6 c2 ff ff       	call   80101a00 <iunlockput>
  end_op();
8010572a:	e8 f1 dd ff ff       	call   80103520 <end_op>
  return -1;
8010572f:	83 c4 10             	add    $0x10,%esp
80105732:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105737:	eb b5                	jmp    801056ee <sys_link+0xde>
    iunlockput(ip);
80105739:	83 ec 0c             	sub    $0xc,%esp
8010573c:	53                   	push   %ebx
8010573d:	e8 be c2 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105742:	e8 d9 dd ff ff       	call   80103520 <end_op>
    return -1;
80105747:	83 c4 10             	add    $0x10,%esp
8010574a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574f:	eb 9d                	jmp    801056ee <sys_link+0xde>
    end_op();
80105751:	e8 ca dd ff ff       	call   80103520 <end_op>
    return -1;
80105756:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575b:	eb 91                	jmp    801056ee <sys_link+0xde>
8010575d:	8d 76 00             	lea    0x0(%esi),%esi

80105760 <sys_unlink>:
{
80105760:	f3 0f 1e fb          	endbr32 
80105764:	55                   	push   %ebp
80105765:	89 e5                	mov    %esp,%ebp
80105767:	57                   	push   %edi
80105768:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105769:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010576c:	53                   	push   %ebx
8010576d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105770:	50                   	push   %eax
80105771:	6a 00                	push   $0x0
80105773:	e8 08 fa ff ff       	call   80105180 <argstr>
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	85 c0                	test   %eax,%eax
8010577d:	0f 88 7d 01 00 00    	js     80105900 <sys_unlink+0x1a0>
  begin_op();
80105783:	e8 28 dd ff ff       	call   801034b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105788:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010578b:	83 ec 08             	sub    $0x8,%esp
8010578e:	53                   	push   %ebx
8010578f:	ff 75 c0             	pushl  -0x40(%ebp)
80105792:	e8 b9 c8 ff ff       	call   80102050 <nameiparent>
80105797:	83 c4 10             	add    $0x10,%esp
8010579a:	89 c6                	mov    %eax,%esi
8010579c:	85 c0                	test   %eax,%eax
8010579e:	0f 84 66 01 00 00    	je     8010590a <sys_unlink+0x1aa>
  ilock(dp);
801057a4:	83 ec 0c             	sub    $0xc,%esp
801057a7:	50                   	push   %eax
801057a8:	e8 b3 bf ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801057ad:	58                   	pop    %eax
801057ae:	5a                   	pop    %edx
801057af:	68 60 84 10 80       	push   $0x80108460
801057b4:	53                   	push   %ebx
801057b5:	e8 d6 c4 ff ff       	call   80101c90 <namecmp>
801057ba:	83 c4 10             	add    $0x10,%esp
801057bd:	85 c0                	test   %eax,%eax
801057bf:	0f 84 03 01 00 00    	je     801058c8 <sys_unlink+0x168>
801057c5:	83 ec 08             	sub    $0x8,%esp
801057c8:	68 5f 84 10 80       	push   $0x8010845f
801057cd:	53                   	push   %ebx
801057ce:	e8 bd c4 ff ff       	call   80101c90 <namecmp>
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	85 c0                	test   %eax,%eax
801057d8:	0f 84 ea 00 00 00    	je     801058c8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801057de:	83 ec 04             	sub    $0x4,%esp
801057e1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801057e4:	50                   	push   %eax
801057e5:	53                   	push   %ebx
801057e6:	56                   	push   %esi
801057e7:	e8 c4 c4 ff ff       	call   80101cb0 <dirlookup>
801057ec:	83 c4 10             	add    $0x10,%esp
801057ef:	89 c3                	mov    %eax,%ebx
801057f1:	85 c0                	test   %eax,%eax
801057f3:	0f 84 cf 00 00 00    	je     801058c8 <sys_unlink+0x168>
  ilock(ip);
801057f9:	83 ec 0c             	sub    $0xc,%esp
801057fc:	50                   	push   %eax
801057fd:	e8 5e bf ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105802:	83 c4 10             	add    $0x10,%esp
80105805:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010580a:	0f 8e 23 01 00 00    	jle    80105933 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105810:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105815:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105818:	74 66                	je     80105880 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010581a:	83 ec 04             	sub    $0x4,%esp
8010581d:	6a 10                	push   $0x10
8010581f:	6a 00                	push   $0x0
80105821:	57                   	push   %edi
80105822:	e8 c9 f5 ff ff       	call   80104df0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105827:	6a 10                	push   $0x10
80105829:	ff 75 c4             	pushl  -0x3c(%ebp)
8010582c:	57                   	push   %edi
8010582d:	56                   	push   %esi
8010582e:	e8 2d c3 ff ff       	call   80101b60 <writei>
80105833:	83 c4 20             	add    $0x20,%esp
80105836:	83 f8 10             	cmp    $0x10,%eax
80105839:	0f 85 e7 00 00 00    	jne    80105926 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010583f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105844:	0f 84 96 00 00 00    	je     801058e0 <sys_unlink+0x180>
  iunlockput(dp);
8010584a:	83 ec 0c             	sub    $0xc,%esp
8010584d:	56                   	push   %esi
8010584e:	e8 ad c1 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105853:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105858:	89 1c 24             	mov    %ebx,(%esp)
8010585b:	e8 40 be ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105860:	89 1c 24             	mov    %ebx,(%esp)
80105863:	e8 98 c1 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105868:	e8 b3 dc ff ff       	call   80103520 <end_op>
  return 0;
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	31 c0                	xor    %eax,%eax
}
80105872:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105875:	5b                   	pop    %ebx
80105876:	5e                   	pop    %esi
80105877:	5f                   	pop    %edi
80105878:	5d                   	pop    %ebp
80105879:	c3                   	ret    
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105880:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105884:	76 94                	jbe    8010581a <sys_unlink+0xba>
80105886:	ba 20 00 00 00       	mov    $0x20,%edx
8010588b:	eb 0b                	jmp    80105898 <sys_unlink+0x138>
8010588d:	8d 76 00             	lea    0x0(%esi),%esi
80105890:	83 c2 10             	add    $0x10,%edx
80105893:	39 53 58             	cmp    %edx,0x58(%ebx)
80105896:	76 82                	jbe    8010581a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105898:	6a 10                	push   $0x10
8010589a:	52                   	push   %edx
8010589b:	57                   	push   %edi
8010589c:	53                   	push   %ebx
8010589d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801058a0:	e8 bb c1 ff ff       	call   80101a60 <readi>
801058a5:	83 c4 10             	add    $0x10,%esp
801058a8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801058ab:	83 f8 10             	cmp    $0x10,%eax
801058ae:	75 69                	jne    80105919 <sys_unlink+0x1b9>
    if(de.inum != 0)
801058b0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801058b5:	74 d9                	je     80105890 <sys_unlink+0x130>
    iunlockput(ip);
801058b7:	83 ec 0c             	sub    $0xc,%esp
801058ba:	53                   	push   %ebx
801058bb:	e8 40 c1 ff ff       	call   80101a00 <iunlockput>
    goto bad;
801058c0:	83 c4 10             	add    $0x10,%esp
801058c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058c7:	90                   	nop
  iunlockput(dp);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	56                   	push   %esi
801058cc:	e8 2f c1 ff ff       	call   80101a00 <iunlockput>
  end_op();
801058d1:	e8 4a dc ff ff       	call   80103520 <end_op>
  return -1;
801058d6:	83 c4 10             	add    $0x10,%esp
801058d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058de:	eb 92                	jmp    80105872 <sys_unlink+0x112>
    iupdate(dp);
801058e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801058e3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801058e8:	56                   	push   %esi
801058e9:	e8 b2 bd ff ff       	call   801016a0 <iupdate>
801058ee:	83 c4 10             	add    $0x10,%esp
801058f1:	e9 54 ff ff ff       	jmp    8010584a <sys_unlink+0xea>
801058f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105905:	e9 68 ff ff ff       	jmp    80105872 <sys_unlink+0x112>
    end_op();
8010590a:	e8 11 dc ff ff       	call   80103520 <end_op>
    return -1;
8010590f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105914:	e9 59 ff ff ff       	jmp    80105872 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105919:	83 ec 0c             	sub    $0xc,%esp
8010591c:	68 84 84 10 80       	push   $0x80108484
80105921:	e8 6a aa ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105926:	83 ec 0c             	sub    $0xc,%esp
80105929:	68 96 84 10 80       	push   $0x80108496
8010592e:	e8 5d aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105933:	83 ec 0c             	sub    $0xc,%esp
80105936:	68 72 84 10 80       	push   $0x80108472
8010593b:	e8 50 aa ff ff       	call   80100390 <panic>

80105940 <sys_open>:

int
sys_open(void)
{
80105940:	f3 0f 1e fb          	endbr32 
80105944:	55                   	push   %ebp
80105945:	89 e5                	mov    %esp,%ebp
80105947:	57                   	push   %edi
80105948:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105949:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010594c:	53                   	push   %ebx
8010594d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105950:	50                   	push   %eax
80105951:	6a 00                	push   $0x0
80105953:	e8 28 f8 ff ff       	call   80105180 <argstr>
80105958:	83 c4 10             	add    $0x10,%esp
8010595b:	85 c0                	test   %eax,%eax
8010595d:	0f 88 8a 00 00 00    	js     801059ed <sys_open+0xad>
80105963:	83 ec 08             	sub    $0x8,%esp
80105966:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105969:	50                   	push   %eax
8010596a:	6a 01                	push   $0x1
8010596c:	e8 5f f7 ff ff       	call   801050d0 <argint>
80105971:	83 c4 10             	add    $0x10,%esp
80105974:	85 c0                	test   %eax,%eax
80105976:	78 75                	js     801059ed <sys_open+0xad>
    return -1;

  begin_op();
80105978:	e8 33 db ff ff       	call   801034b0 <begin_op>

  if(omode & O_CREATE){
8010597d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105981:	75 75                	jne    801059f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105983:	83 ec 0c             	sub    $0xc,%esp
80105986:	ff 75 e0             	pushl  -0x20(%ebp)
80105989:	e8 a2 c6 ff ff       	call   80102030 <namei>
8010598e:	83 c4 10             	add    $0x10,%esp
80105991:	89 c6                	mov    %eax,%esi
80105993:	85 c0                	test   %eax,%eax
80105995:	74 7e                	je     80105a15 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105997:	83 ec 0c             	sub    $0xc,%esp
8010599a:	50                   	push   %eax
8010599b:	e8 c0 bd ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801059a0:	83 c4 10             	add    $0x10,%esp
801059a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801059a8:	0f 84 c2 00 00 00    	je     80105a70 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801059ae:	e8 4d b4 ff ff       	call   80100e00 <filealloc>
801059b3:	89 c7                	mov    %eax,%edi
801059b5:	85 c0                	test   %eax,%eax
801059b7:	74 23                	je     801059dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801059b9:	e8 32 e7 ff ff       	call   801040f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801059c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801059c4:	85 d2                	test   %edx,%edx
801059c6:	74 60                	je     80105a28 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801059c8:	83 c3 01             	add    $0x1,%ebx
801059cb:	83 fb 10             	cmp    $0x10,%ebx
801059ce:	75 f0                	jne    801059c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801059d0:	83 ec 0c             	sub    $0xc,%esp
801059d3:	57                   	push   %edi
801059d4:	e8 e7 b4 ff ff       	call   80100ec0 <fileclose>
801059d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801059dc:	83 ec 0c             	sub    $0xc,%esp
801059df:	56                   	push   %esi
801059e0:	e8 1b c0 ff ff       	call   80101a00 <iunlockput>
    end_op();
801059e5:	e8 36 db ff ff       	call   80103520 <end_op>
    return -1;
801059ea:	83 c4 10             	add    $0x10,%esp
801059ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059f2:	eb 6d                	jmp    80105a61 <sys_open+0x121>
801059f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059fe:	31 c9                	xor    %ecx,%ecx
80105a00:	ba 02 00 00 00       	mov    $0x2,%edx
80105a05:	6a 00                	push   $0x0
80105a07:	e8 24 f8 ff ff       	call   80105230 <create>
    if(ip == 0){
80105a0c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105a0f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105a11:	85 c0                	test   %eax,%eax
80105a13:	75 99                	jne    801059ae <sys_open+0x6e>
      end_op();
80105a15:	e8 06 db ff ff       	call   80103520 <end_op>
      return -1;
80105a1a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a1f:	eb 40                	jmp    80105a61 <sys_open+0x121>
80105a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105a28:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105a2b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105a2f:	56                   	push   %esi
80105a30:	e8 0b be ff ff       	call   80101840 <iunlock>
  end_op();
80105a35:	e8 e6 da ff ff       	call   80103520 <end_op>

  f->type = FD_INODE;
80105a3a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a43:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105a46:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105a49:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105a4b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105a52:	f7 d0                	not    %eax
80105a54:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a57:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105a5a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a5d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a64:	89 d8                	mov    %ebx,%eax
80105a66:	5b                   	pop    %ebx
80105a67:	5e                   	pop    %esi
80105a68:	5f                   	pop    %edi
80105a69:	5d                   	pop    %ebp
80105a6a:	c3                   	ret    
80105a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a6f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a70:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a73:	85 c9                	test   %ecx,%ecx
80105a75:	0f 84 33 ff ff ff    	je     801059ae <sys_open+0x6e>
80105a7b:	e9 5c ff ff ff       	jmp    801059dc <sys_open+0x9c>

80105a80 <sys_mkdir>:

int
sys_mkdir(void)
{
80105a80:	f3 0f 1e fb          	endbr32 
80105a84:	55                   	push   %ebp
80105a85:	89 e5                	mov    %esp,%ebp
80105a87:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a8a:	e8 21 da ff ff       	call   801034b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a8f:	83 ec 08             	sub    $0x8,%esp
80105a92:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a95:	50                   	push   %eax
80105a96:	6a 00                	push   $0x0
80105a98:	e8 e3 f6 ff ff       	call   80105180 <argstr>
80105a9d:	83 c4 10             	add    $0x10,%esp
80105aa0:	85 c0                	test   %eax,%eax
80105aa2:	78 34                	js     80105ad8 <sys_mkdir+0x58>
80105aa4:	83 ec 0c             	sub    $0xc,%esp
80105aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aaa:	31 c9                	xor    %ecx,%ecx
80105aac:	ba 01 00 00 00       	mov    $0x1,%edx
80105ab1:	6a 00                	push   $0x0
80105ab3:	e8 78 f7 ff ff       	call   80105230 <create>
80105ab8:	83 c4 10             	add    $0x10,%esp
80105abb:	85 c0                	test   %eax,%eax
80105abd:	74 19                	je     80105ad8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105abf:	83 ec 0c             	sub    $0xc,%esp
80105ac2:	50                   	push   %eax
80105ac3:	e8 38 bf ff ff       	call   80101a00 <iunlockput>
  end_op();
80105ac8:	e8 53 da ff ff       	call   80103520 <end_op>
  return 0;
80105acd:	83 c4 10             	add    $0x10,%esp
80105ad0:	31 c0                	xor    %eax,%eax
}
80105ad2:	c9                   	leave  
80105ad3:	c3                   	ret    
80105ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105ad8:	e8 43 da ff ff       	call   80103520 <end_op>
    return -1;
80105add:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ae2:	c9                   	leave  
80105ae3:	c3                   	ret    
80105ae4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aef:	90                   	nop

80105af0 <sys_mknod>:

int
sys_mknod(void)
{
80105af0:	f3 0f 1e fb          	endbr32 
80105af4:	55                   	push   %ebp
80105af5:	89 e5                	mov    %esp,%ebp
80105af7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105afa:	e8 b1 d9 ff ff       	call   801034b0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105aff:	83 ec 08             	sub    $0x8,%esp
80105b02:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b05:	50                   	push   %eax
80105b06:	6a 00                	push   $0x0
80105b08:	e8 73 f6 ff ff       	call   80105180 <argstr>
80105b0d:	83 c4 10             	add    $0x10,%esp
80105b10:	85 c0                	test   %eax,%eax
80105b12:	78 64                	js     80105b78 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105b14:	83 ec 08             	sub    $0x8,%esp
80105b17:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b1a:	50                   	push   %eax
80105b1b:	6a 01                	push   $0x1
80105b1d:	e8 ae f5 ff ff       	call   801050d0 <argint>
  if((argstr(0, &path)) < 0 ||
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	85 c0                	test   %eax,%eax
80105b27:	78 4f                	js     80105b78 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105b29:	83 ec 08             	sub    $0x8,%esp
80105b2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b2f:	50                   	push   %eax
80105b30:	6a 02                	push   $0x2
80105b32:	e8 99 f5 ff ff       	call   801050d0 <argint>
     argint(1, &major) < 0 ||
80105b37:	83 c4 10             	add    $0x10,%esp
80105b3a:	85 c0                	test   %eax,%eax
80105b3c:	78 3a                	js     80105b78 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105b3e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105b42:	83 ec 0c             	sub    $0xc,%esp
80105b45:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105b49:	ba 03 00 00 00       	mov    $0x3,%edx
80105b4e:	50                   	push   %eax
80105b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b52:	e8 d9 f6 ff ff       	call   80105230 <create>
     argint(2, &minor) < 0 ||
80105b57:	83 c4 10             	add    $0x10,%esp
80105b5a:	85 c0                	test   %eax,%eax
80105b5c:	74 1a                	je     80105b78 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b5e:	83 ec 0c             	sub    $0xc,%esp
80105b61:	50                   	push   %eax
80105b62:	e8 99 be ff ff       	call   80101a00 <iunlockput>
  end_op();
80105b67:	e8 b4 d9 ff ff       	call   80103520 <end_op>
  return 0;
80105b6c:	83 c4 10             	add    $0x10,%esp
80105b6f:	31 c0                	xor    %eax,%eax
}
80105b71:	c9                   	leave  
80105b72:	c3                   	ret    
80105b73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b77:	90                   	nop
    end_op();
80105b78:	e8 a3 d9 ff ff       	call   80103520 <end_op>
    return -1;
80105b7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b82:	c9                   	leave  
80105b83:	c3                   	ret    
80105b84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b8f:	90                   	nop

80105b90 <sys_chdir>:

int
sys_chdir(void)
{
80105b90:	f3 0f 1e fb          	endbr32 
80105b94:	55                   	push   %ebp
80105b95:	89 e5                	mov    %esp,%ebp
80105b97:	56                   	push   %esi
80105b98:	53                   	push   %ebx
80105b99:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b9c:	e8 4f e5 ff ff       	call   801040f0 <myproc>
80105ba1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105ba3:	e8 08 d9 ff ff       	call   801034b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ba8:	83 ec 08             	sub    $0x8,%esp
80105bab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bae:	50                   	push   %eax
80105baf:	6a 00                	push   $0x0
80105bb1:	e8 ca f5 ff ff       	call   80105180 <argstr>
80105bb6:	83 c4 10             	add    $0x10,%esp
80105bb9:	85 c0                	test   %eax,%eax
80105bbb:	78 73                	js     80105c30 <sys_chdir+0xa0>
80105bbd:	83 ec 0c             	sub    $0xc,%esp
80105bc0:	ff 75 f4             	pushl  -0xc(%ebp)
80105bc3:	e8 68 c4 ff ff       	call   80102030 <namei>
80105bc8:	83 c4 10             	add    $0x10,%esp
80105bcb:	89 c3                	mov    %eax,%ebx
80105bcd:	85 c0                	test   %eax,%eax
80105bcf:	74 5f                	je     80105c30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105bd1:	83 ec 0c             	sub    $0xc,%esp
80105bd4:	50                   	push   %eax
80105bd5:	e8 86 bb ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105bda:	83 c4 10             	add    $0x10,%esp
80105bdd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105be2:	75 2c                	jne    80105c10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105be4:	83 ec 0c             	sub    $0xc,%esp
80105be7:	53                   	push   %ebx
80105be8:	e8 53 bc ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105bed:	58                   	pop    %eax
80105bee:	ff 76 68             	pushl  0x68(%esi)
80105bf1:	e8 9a bc ff ff       	call   80101890 <iput>
  end_op();
80105bf6:	e8 25 d9 ff ff       	call   80103520 <end_op>
  curproc->cwd = ip;
80105bfb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105bfe:	83 c4 10             	add    $0x10,%esp
80105c01:	31 c0                	xor    %eax,%eax
}
80105c03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c06:	5b                   	pop    %ebx
80105c07:	5e                   	pop    %esi
80105c08:	5d                   	pop    %ebp
80105c09:	c3                   	ret    
80105c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105c10:	83 ec 0c             	sub    $0xc,%esp
80105c13:	53                   	push   %ebx
80105c14:	e8 e7 bd ff ff       	call   80101a00 <iunlockput>
    end_op();
80105c19:	e8 02 d9 ff ff       	call   80103520 <end_op>
    return -1;
80105c1e:	83 c4 10             	add    $0x10,%esp
80105c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c26:	eb db                	jmp    80105c03 <sys_chdir+0x73>
80105c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop
    end_op();
80105c30:	e8 eb d8 ff ff       	call   80103520 <end_op>
    return -1;
80105c35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c3a:	eb c7                	jmp    80105c03 <sys_chdir+0x73>
80105c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c40 <sys_exec>:

int
sys_exec(void)
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
80105c45:	89 e5                	mov    %esp,%ebp
80105c47:	57                   	push   %edi
80105c48:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c49:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105c4f:	53                   	push   %ebx
80105c50:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c56:	50                   	push   %eax
80105c57:	6a 00                	push   $0x0
80105c59:	e8 22 f5 ff ff       	call   80105180 <argstr>
80105c5e:	83 c4 10             	add    $0x10,%esp
80105c61:	85 c0                	test   %eax,%eax
80105c63:	0f 88 8b 00 00 00    	js     80105cf4 <sys_exec+0xb4>
80105c69:	83 ec 08             	sub    $0x8,%esp
80105c6c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105c72:	50                   	push   %eax
80105c73:	6a 01                	push   $0x1
80105c75:	e8 56 f4 ff ff       	call   801050d0 <argint>
80105c7a:	83 c4 10             	add    $0x10,%esp
80105c7d:	85 c0                	test   %eax,%eax
80105c7f:	78 73                	js     80105cf4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105c81:	83 ec 04             	sub    $0x4,%esp
80105c84:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105c8a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105c8c:	68 80 00 00 00       	push   $0x80
80105c91:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105c97:	6a 00                	push   $0x0
80105c99:	50                   	push   %eax
80105c9a:	e8 51 f1 ff ff       	call   80104df0 <memset>
80105c9f:	83 c4 10             	add    $0x10,%esp
80105ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105ca8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105cae:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105cb5:	83 ec 08             	sub    $0x8,%esp
80105cb8:	57                   	push   %edi
80105cb9:	01 f0                	add    %esi,%eax
80105cbb:	50                   	push   %eax
80105cbc:	e8 6f f3 ff ff       	call   80105030 <fetchint>
80105cc1:	83 c4 10             	add    $0x10,%esp
80105cc4:	85 c0                	test   %eax,%eax
80105cc6:	78 2c                	js     80105cf4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105cc8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105cce:	85 c0                	test   %eax,%eax
80105cd0:	74 36                	je     80105d08 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105cd2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105cd8:	83 ec 08             	sub    $0x8,%esp
80105cdb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105cde:	52                   	push   %edx
80105cdf:	50                   	push   %eax
80105ce0:	e8 8b f3 ff ff       	call   80105070 <fetchstr>
80105ce5:	83 c4 10             	add    $0x10,%esp
80105ce8:	85 c0                	test   %eax,%eax
80105cea:	78 08                	js     80105cf4 <sys_exec+0xb4>
  for(i=0;; i++){
80105cec:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105cef:	83 fb 20             	cmp    $0x20,%ebx
80105cf2:	75 b4                	jne    80105ca8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105cf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cfc:	5b                   	pop    %ebx
80105cfd:	5e                   	pop    %esi
80105cfe:	5f                   	pop    %edi
80105cff:	5d                   	pop    %ebp
80105d00:	c3                   	ret    
80105d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105d08:	83 ec 08             	sub    $0x8,%esp
80105d0b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105d11:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105d18:	00 00 00 00 
  return exec(path, argv);
80105d1c:	50                   	push   %eax
80105d1d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105d23:	e8 58 ad ff ff       	call   80100a80 <exec>
80105d28:	83 c4 10             	add    $0x10,%esp
}
80105d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d2e:	5b                   	pop    %ebx
80105d2f:	5e                   	pop    %esi
80105d30:	5f                   	pop    %edi
80105d31:	5d                   	pop    %ebp
80105d32:	c3                   	ret    
80105d33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d40 <sys_pipe>:

int
sys_pipe(void)
{
80105d40:	f3 0f 1e fb          	endbr32 
80105d44:	55                   	push   %ebp
80105d45:	89 e5                	mov    %esp,%ebp
80105d47:	57                   	push   %edi
80105d48:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d49:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105d4c:	53                   	push   %ebx
80105d4d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d50:	6a 08                	push   $0x8
80105d52:	50                   	push   %eax
80105d53:	6a 00                	push   $0x0
80105d55:	e8 c6 f3 ff ff       	call   80105120 <argptr>
80105d5a:	83 c4 10             	add    $0x10,%esp
80105d5d:	85 c0                	test   %eax,%eax
80105d5f:	78 4e                	js     80105daf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105d61:	83 ec 08             	sub    $0x8,%esp
80105d64:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d67:	50                   	push   %eax
80105d68:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d6b:	50                   	push   %eax
80105d6c:	e8 0f de ff ff       	call   80103b80 <pipealloc>
80105d71:	83 c4 10             	add    $0x10,%esp
80105d74:	85 c0                	test   %eax,%eax
80105d76:	78 37                	js     80105daf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d78:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105d7b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105d7d:	e8 6e e3 ff ff       	call   801040f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105d88:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105d8c:	85 f6                	test   %esi,%esi
80105d8e:	74 30                	je     80105dc0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105d90:	83 c3 01             	add    $0x1,%ebx
80105d93:	83 fb 10             	cmp    $0x10,%ebx
80105d96:	75 f0                	jne    80105d88 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105d98:	83 ec 0c             	sub    $0xc,%esp
80105d9b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d9e:	e8 1d b1 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105da3:	58                   	pop    %eax
80105da4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105da7:	e8 14 b1 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105dac:	83 c4 10             	add    $0x10,%esp
80105daf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db4:	eb 5b                	jmp    80105e11 <sys_pipe+0xd1>
80105db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105dc0:	8d 73 08             	lea    0x8(%ebx),%esi
80105dc3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105dc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105dca:	e8 21 e3 ff ff       	call   801040f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105dcf:	31 d2                	xor    %edx,%edx
80105dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105dd8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105ddc:	85 c9                	test   %ecx,%ecx
80105dde:	74 20                	je     80105e00 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105de0:	83 c2 01             	add    $0x1,%edx
80105de3:	83 fa 10             	cmp    $0x10,%edx
80105de6:	75 f0                	jne    80105dd8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105de8:	e8 03 e3 ff ff       	call   801040f0 <myproc>
80105ded:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105df4:	00 
80105df5:	eb a1                	jmp    80105d98 <sys_pipe+0x58>
80105df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e00:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105e04:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e07:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e09:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e0c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105e0f:	31 c0                	xor    %eax,%eax
}
80105e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e14:	5b                   	pop    %ebx
80105e15:	5e                   	pop    %esi
80105e16:	5f                   	pop    %edi
80105e17:	5d                   	pop    %ebp
80105e18:	c3                   	ret    
80105e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e20 <sys_swapread>:

int sys_swapread(void)
{
80105e20:	f3 0f 1e fb          	endbr32 
80105e24:	55                   	push   %ebp
80105e25:	89 e5                	mov    %esp,%ebp
80105e27:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105e2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e2d:	68 00 10 00 00       	push   $0x1000
80105e32:	50                   	push   %eax
80105e33:	6a 00                	push   $0x0
80105e35:	e8 e6 f2 ff ff       	call   80105120 <argptr>
80105e3a:	83 c4 10             	add    $0x10,%esp
80105e3d:	85 c0                	test   %eax,%eax
80105e3f:	78 2f                	js     80105e70 <sys_swapread+0x50>
80105e41:	83 ec 08             	sub    $0x8,%esp
80105e44:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e47:	50                   	push   %eax
80105e48:	6a 01                	push   $0x1
80105e4a:	e8 81 f2 ff ff       	call   801050d0 <argint>
80105e4f:	83 c4 10             	add    $0x10,%esp
80105e52:	85 c0                	test   %eax,%eax
80105e54:	78 1a                	js     80105e70 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
80105e56:	83 ec 08             	sub    $0x8,%esp
80105e59:	ff 75 f4             	pushl  -0xc(%ebp)
80105e5c:	ff 75 f0             	pushl  -0x10(%ebp)
80105e5f:	e8 0c c2 ff ff       	call   80102070 <swapread>
	return 0;
80105e64:	83 c4 10             	add    $0x10,%esp
80105e67:	31 c0                	xor    %eax,%eax
}
80105e69:	c9                   	leave  
80105e6a:	c3                   	ret    
80105e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e6f:	90                   	nop
80105e70:	c9                   	leave  
		return -1;
80105e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e76:	c3                   	ret    
80105e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7e:	66 90                	xchg   %ax,%ax

80105e80 <sys_swapwrite>:

int sys_swapwrite(void)
{
80105e80:	f3 0f 1e fb          	endbr32 
80105e84:	55                   	push   %ebp
80105e85:	89 e5                	mov    %esp,%ebp
80105e87:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105e8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e8d:	68 00 10 00 00       	push   $0x1000
80105e92:	50                   	push   %eax
80105e93:	6a 00                	push   $0x0
80105e95:	e8 86 f2 ff ff       	call   80105120 <argptr>
80105e9a:	83 c4 10             	add    $0x10,%esp
80105e9d:	85 c0                	test   %eax,%eax
80105e9f:	78 2f                	js     80105ed0 <sys_swapwrite+0x50>
80105ea1:	83 ec 08             	sub    $0x8,%esp
80105ea4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ea7:	50                   	push   %eax
80105ea8:	6a 01                	push   $0x1
80105eaa:	e8 21 f2 ff ff       	call   801050d0 <argint>
80105eaf:	83 c4 10             	add    $0x10,%esp
80105eb2:	85 c0                	test   %eax,%eax
80105eb4:	78 1a                	js     80105ed0 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
80105eb6:	83 ec 08             	sub    $0x8,%esp
80105eb9:	ff 75 f4             	pushl  -0xc(%ebp)
80105ebc:	ff 75 f0             	pushl  -0x10(%ebp)
80105ebf:	e8 3c c2 ff ff       	call   80102100 <swapwrite>
	return 0;
80105ec4:	83 c4 10             	add    $0x10,%esp
80105ec7:	31 c0                	xor    %eax,%eax
}
80105ec9:	c9                   	leave  
80105eca:	c3                   	ret    
80105ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ecf:	90                   	nop
80105ed0:	c9                   	leave  
		return -1;
80105ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ed6:	c3                   	ret    
80105ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ede:	66 90                	xchg   %ax,%ax

80105ee0 <sys_swapstat>:

int sys_swapstat(void)
{
80105ee0:	f3 0f 1e fb          	endbr32 
80105ee4:	55                   	push   %ebp
80105ee5:	89 e5                	mov    %esp,%ebp
80105ee7:	53                   	push   %ebx
	int* nr_read;
	int* nr_write;
	
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105ee8:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
80105eeb:	83 ec 18             	sub    $0x18,%esp
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105eee:	6a 04                	push   $0x4
80105ef0:	50                   	push   %eax
80105ef1:	6a 00                	push   $0x0
80105ef3:	e8 28 f2 ff ff       	call   80105120 <argptr>
80105ef8:	83 c4 10             	add    $0x10,%esp
80105efb:	85 c0                	test   %eax,%eax
80105efd:	75 39                	jne    80105f38 <sys_swapstat+0x58>
			argptr(1, (void*)&nr_write, sizeof(*nr_write)) < 0)
80105eff:	83 ec 04             	sub    $0x4,%esp
80105f02:	89 c3                	mov    %eax,%ebx
80105f04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f07:	6a 04                	push   $0x4
80105f09:	50                   	push   %eax
80105f0a:	6a 01                	push   $0x1
80105f0c:	e8 0f f2 ff ff       	call   80105120 <argptr>
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105f11:	83 c4 10             	add    $0x10,%esp
80105f14:	85 c0                	test   %eax,%eax
80105f16:	78 20                	js     80105f38 <sys_swapstat+0x58>
		return -1;

	*nr_read = nr_sectors_read;
80105f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f1b:	8b 15 c0 19 11 80    	mov    0x801119c0,%edx
80105f21:	89 10                	mov    %edx,(%eax)
	*nr_write = nr_sectors_write;
80105f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f26:	8b 15 e0 19 11 80    	mov    0x801119e0,%edx
80105f2c:	89 10                	mov    %edx,(%eax)
	return 0;
}
80105f2e:	89 d8                	mov    %ebx,%eax
80105f30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f33:	c9                   	leave  
80105f34:	c3                   	ret    
80105f35:	8d 76 00             	lea    0x0(%esi),%esi
		return -1;
80105f38:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f3d:	eb ef                	jmp    80105f2e <sys_swapstat+0x4e>
80105f3f:	90                   	nop

80105f40 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f40:	f3 0f 1e fb          	endbr32 
  return fork();
80105f44:	e9 67 e3 ff ff       	jmp    801042b0 <fork>
80105f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f50 <sys_exit>:
}

int
sys_exit(void)
{
80105f50:	f3 0f 1e fb          	endbr32 
80105f54:	55                   	push   %ebp
80105f55:	89 e5                	mov    %esp,%ebp
80105f57:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f5a:	e8 b1 e5 ff ff       	call   80104510 <exit>
  return 0;  // not reached
}
80105f5f:	31 c0                	xor    %eax,%eax
80105f61:	c9                   	leave  
80105f62:	c3                   	ret    
80105f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f70 <sys_wait>:

int
sys_wait(void)
{
80105f70:	f3 0f 1e fb          	endbr32 
  return wait();
80105f74:	e9 e7 e7 ff ff       	jmp    80104760 <wait>
80105f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f80 <sys_kill>:
}

int
sys_kill(void)
{
80105f80:	f3 0f 1e fb          	endbr32 
80105f84:	55                   	push   %ebp
80105f85:	89 e5                	mov    %esp,%ebp
80105f87:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f8d:	50                   	push   %eax
80105f8e:	6a 00                	push   $0x0
80105f90:	e8 3b f1 ff ff       	call   801050d0 <argint>
80105f95:	83 c4 10             	add    $0x10,%esp
80105f98:	85 c0                	test   %eax,%eax
80105f9a:	78 14                	js     80105fb0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f9c:	83 ec 0c             	sub    $0xc,%esp
80105f9f:	ff 75 f4             	pushl  -0xc(%ebp)
80105fa2:	e8 19 e9 ff ff       	call   801048c0 <kill>
80105fa7:	83 c4 10             	add    $0x10,%esp
}
80105faa:	c9                   	leave  
80105fab:	c3                   	ret    
80105fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fb0:	c9                   	leave  
    return -1;
80105fb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fb6:	c3                   	ret    
80105fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbe:	66 90                	xchg   %ax,%ax

80105fc0 <sys_getpid>:

int
sys_getpid(void)
{
80105fc0:	f3 0f 1e fb          	endbr32 
80105fc4:	55                   	push   %ebp
80105fc5:	89 e5                	mov    %esp,%ebp
80105fc7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105fca:	e8 21 e1 ff ff       	call   801040f0 <myproc>
80105fcf:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fd2:	c9                   	leave  
80105fd3:	c3                   	ret    
80105fd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fdf:	90                   	nop

80105fe0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105fe0:	f3 0f 1e fb          	endbr32 
80105fe4:	55                   	push   %ebp
80105fe5:	89 e5                	mov    %esp,%ebp
80105fe7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105fe8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105feb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105fee:	50                   	push   %eax
80105fef:	6a 00                	push   $0x0
80105ff1:	e8 da f0 ff ff       	call   801050d0 <argint>
80105ff6:	83 c4 10             	add    $0x10,%esp
80105ff9:	85 c0                	test   %eax,%eax
80105ffb:	78 23                	js     80106020 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ffd:	e8 ee e0 ff ff       	call   801040f0 <myproc>
  if(growproc(n) < 0)
80106002:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106005:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106007:	ff 75 f4             	pushl  -0xc(%ebp)
8010600a:	e8 21 e2 ff ff       	call   80104230 <growproc>
8010600f:	83 c4 10             	add    $0x10,%esp
80106012:	85 c0                	test   %eax,%eax
80106014:	78 0a                	js     80106020 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106016:	89 d8                	mov    %ebx,%eax
80106018:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010601b:	c9                   	leave  
8010601c:	c3                   	ret    
8010601d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106020:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106025:	eb ef                	jmp    80106016 <sys_sbrk+0x36>
80106027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602e:	66 90                	xchg   %ax,%ax

80106030 <sys_sleep>:

int
sys_sleep(void)
{
80106030:	f3 0f 1e fb          	endbr32 
80106034:	55                   	push   %ebp
80106035:	89 e5                	mov    %esp,%ebp
80106037:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106038:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010603b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010603e:	50                   	push   %eax
8010603f:	6a 00                	push   $0x0
80106041:	e8 8a f0 ff ff       	call   801050d0 <argint>
80106046:	83 c4 10             	add    $0x10,%esp
80106049:	85 c0                	test   %eax,%eax
8010604b:	0f 88 86 00 00 00    	js     801060d7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106051:	83 ec 0c             	sub    $0xc,%esp
80106054:	68 c0 bc 11 80       	push   $0x8011bcc0
80106059:	e8 82 ec ff ff       	call   80104ce0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010605e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106061:	8b 1d 00 c5 11 80    	mov    0x8011c500,%ebx
  while(ticks - ticks0 < n){
80106067:	83 c4 10             	add    $0x10,%esp
8010606a:	85 d2                	test   %edx,%edx
8010606c:	75 23                	jne    80106091 <sys_sleep+0x61>
8010606e:	eb 50                	jmp    801060c0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106070:	83 ec 08             	sub    $0x8,%esp
80106073:	68 c0 bc 11 80       	push   $0x8011bcc0
80106078:	68 00 c5 11 80       	push   $0x8011c500
8010607d:	e8 1e e6 ff ff       	call   801046a0 <sleep>
  while(ticks - ticks0 < n){
80106082:	a1 00 c5 11 80       	mov    0x8011c500,%eax
80106087:	83 c4 10             	add    $0x10,%esp
8010608a:	29 d8                	sub    %ebx,%eax
8010608c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010608f:	73 2f                	jae    801060c0 <sys_sleep+0x90>
    if(myproc()->killed){
80106091:	e8 5a e0 ff ff       	call   801040f0 <myproc>
80106096:	8b 40 24             	mov    0x24(%eax),%eax
80106099:	85 c0                	test   %eax,%eax
8010609b:	74 d3                	je     80106070 <sys_sleep+0x40>
      release(&tickslock);
8010609d:	83 ec 0c             	sub    $0xc,%esp
801060a0:	68 c0 bc 11 80       	push   $0x8011bcc0
801060a5:	e8 f6 ec ff ff       	call   80104da0 <release>
  }
  release(&tickslock);
  return 0;
}
801060aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801060ad:	83 c4 10             	add    $0x10,%esp
801060b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060b5:	c9                   	leave  
801060b6:	c3                   	ret    
801060b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060be:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801060c0:	83 ec 0c             	sub    $0xc,%esp
801060c3:	68 c0 bc 11 80       	push   $0x8011bcc0
801060c8:	e8 d3 ec ff ff       	call   80104da0 <release>
  return 0;
801060cd:	83 c4 10             	add    $0x10,%esp
801060d0:	31 c0                	xor    %eax,%eax
}
801060d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060d5:	c9                   	leave  
801060d6:	c3                   	ret    
    return -1;
801060d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060dc:	eb f4                	jmp    801060d2 <sys_sleep+0xa2>
801060de:	66 90                	xchg   %ax,%ax

801060e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060e0:	f3 0f 1e fb          	endbr32 
801060e4:	55                   	push   %ebp
801060e5:	89 e5                	mov    %esp,%ebp
801060e7:	53                   	push   %ebx
801060e8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060eb:	68 c0 bc 11 80       	push   $0x8011bcc0
801060f0:	e8 eb eb ff ff       	call   80104ce0 <acquire>
  xticks = ticks;
801060f5:	8b 1d 00 c5 11 80    	mov    0x8011c500,%ebx
  release(&tickslock);
801060fb:	c7 04 24 c0 bc 11 80 	movl   $0x8011bcc0,(%esp)
80106102:	e8 99 ec ff ff       	call   80104da0 <release>
  return xticks;
}
80106107:	89 d8                	mov    %ebx,%eax
80106109:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010610c:	c9                   	leave  
8010610d:	c3                   	ret    

8010610e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010610e:	1e                   	push   %ds
  pushl %es
8010610f:	06                   	push   %es
  pushl %fs
80106110:	0f a0                	push   %fs
  pushl %gs
80106112:	0f a8                	push   %gs
  pushal
80106114:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106115:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106119:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010611b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010611d:	54                   	push   %esp
  call trap
8010611e:	e8 cd 00 00 00       	call   801061f0 <trap>
  addl $4, %esp
80106123:	83 c4 04             	add    $0x4,%esp

80106126 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106126:	61                   	popa   
  popl %gs
80106127:	0f a9                	pop    %gs
  popl %fs
80106129:	0f a1                	pop    %fs
  popl %es
8010612b:	07                   	pop    %es
  popl %ds
8010612c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010612d:	83 c4 08             	add    $0x8,%esp
  iret
80106130:	cf                   	iret   
80106131:	66 90                	xchg   %ax,%ax
80106133:	66 90                	xchg   %ax,%ax
80106135:	66 90                	xchg   %ax,%ax
80106137:	66 90                	xchg   %ax,%ax
80106139:	66 90                	xchg   %ax,%ax
8010613b:	66 90                	xchg   %ax,%ax
8010613d:	66 90                	xchg   %ax,%ax
8010613f:	90                   	nop

80106140 <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
80106140:	f3 0f 1e fb          	endbr32 
80106144:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
80106145:	31 c0                	xor    %eax,%eax
{
80106147:	89 e5                	mov    %esp,%ebp
80106149:	83 ec 08             	sub    $0x8,%esp
8010614c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106150:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106157:	c7 04 c5 02 bd 11 80 	movl   $0x8e000008,-0x7fee42fe(,%eax,8)
8010615e:	08 00 00 8e 
80106162:	66 89 14 c5 00 bd 11 	mov    %dx,-0x7fee4300(,%eax,8)
80106169:	80 
8010616a:	c1 ea 10             	shr    $0x10,%edx
8010616d:	66 89 14 c5 06 bd 11 	mov    %dx,-0x7fee42fa(,%eax,8)
80106174:	80 
  for (i = 0; i < 256; i++)
80106175:	83 c0 01             	add    $0x1,%eax
80106178:	3d 00 01 00 00       	cmp    $0x100,%eax
8010617d:	75 d1                	jne    80106150 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010617f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106182:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106187:	c7 05 02 bf 11 80 08 	movl   $0xef000008,0x8011bf02
8010618e:	00 00 ef 
  initlock(&tickslock, "time");
80106191:	68 a5 84 10 80       	push   $0x801084a5
80106196:	68 c0 bc 11 80       	push   $0x8011bcc0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010619b:	66 a3 00 bf 11 80    	mov    %ax,0x8011bf00
801061a1:	c1 e8 10             	shr    $0x10,%eax
801061a4:	66 a3 06 bf 11 80    	mov    %ax,0x8011bf06
  initlock(&tickslock, "time");
801061aa:	e8 b1 e9 ff ff       	call   80104b60 <initlock>
}
801061af:	83 c4 10             	add    $0x10,%esp
801061b2:	c9                   	leave  
801061b3:	c3                   	ret    
801061b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061bf:	90                   	nop

801061c0 <idtinit>:

void idtinit(void)
{
801061c0:	f3 0f 1e fb          	endbr32 
801061c4:	55                   	push   %ebp
  pd[0] = size-1;
801061c5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061ca:	89 e5                	mov    %esp,%ebp
801061cc:	83 ec 10             	sub    $0x10,%esp
801061cf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061d3:	b8 00 bd 11 80       	mov    $0x8011bd00,%eax
801061d8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061dc:	c1 e8 10             	shr    $0x10,%eax
801061df:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061e3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061e6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801061e9:	c9                   	leave  
801061ea:	c3                   	ret    
801061eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061ef:	90                   	nop

801061f0 <trap>:

void trap(struct trapframe *tf)
{
801061f0:	f3 0f 1e fb          	endbr32 
801061f4:	55                   	push   %ebp
801061f5:	89 e5                	mov    %esp,%ebp
801061f7:	57                   	push   %edi
801061f8:	56                   	push   %esi
801061f9:	53                   	push   %ebx
801061fa:	83 ec 1c             	sub    $0x1c,%esp
801061fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (tf->trapno == T_SYSCALL)
80106200:	8b 43 30             	mov    0x30(%ebx),%eax
80106203:	83 f8 40             	cmp    $0x40,%eax
80106206:	0f 84 ec 01 00 00    	je     801063f8 <trap+0x208>
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
8010620c:	83 e8 0e             	sub    $0xe,%eax
8010620f:	83 f8 31             	cmp    $0x31,%eax
80106212:	77 08                	ja     8010621c <trap+0x2c>
80106214:	3e ff 24 85 4c 85 10 	notrack jmp *-0x7fef7ab4(,%eax,4)
8010621b:	80 
  case T_PGFLT:
    page_fault_handler(myproc()->pgdir, rcr2());
    break;

  default:
    if (myproc() == 0 || (tf->cs & 3) == 0)
8010621c:	e8 cf de ff ff       	call   801040f0 <myproc>
80106221:	85 c0                	test   %eax,%eax
80106223:	0f 84 1e 02 00 00    	je     80106447 <trap+0x257>
80106229:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010622d:	0f 84 14 02 00 00    	je     80106447 <trap+0x257>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106233:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106236:	8b 53 38             	mov    0x38(%ebx),%edx
80106239:	89 4d d8             	mov    %ecx,-0x28(%ebp)
8010623c:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010623f:	e8 8c de ff ff       	call   801040d0 <cpuid>
80106244:	8b 73 30             	mov    0x30(%ebx),%esi
80106247:	89 c7                	mov    %eax,%edi
80106249:	8b 43 34             	mov    0x34(%ebx),%eax
8010624c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010624f:	e8 9c de ff ff       	call   801040f0 <myproc>
80106254:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106257:	e8 94 de ff ff       	call   801040f0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010625c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010625f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106262:	51                   	push   %ecx
80106263:	52                   	push   %edx
80106264:	57                   	push   %edi
80106265:	ff 75 e4             	pushl  -0x1c(%ebp)
80106268:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106269:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010626c:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010626f:	56                   	push   %esi
80106270:	ff 70 10             	pushl  0x10(%eax)
80106273:	68 08 85 10 80       	push   $0x80108508
80106278:	e8 33 a4 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010627d:	83 c4 20             	add    $0x20,%esp
80106280:	e8 6b de ff ff       	call   801040f0 <myproc>
80106285:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010628c:	e8 5f de ff ff       	call   801040f0 <myproc>
80106291:	85 c0                	test   %eax,%eax
80106293:	74 1d                	je     801062b2 <trap+0xc2>
80106295:	e8 56 de ff ff       	call   801040f0 <myproc>
8010629a:	8b 50 24             	mov    0x24(%eax),%edx
8010629d:	85 d2                	test   %edx,%edx
8010629f:	74 11                	je     801062b2 <trap+0xc2>
801062a1:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062a5:	83 e0 03             	and    $0x3,%eax
801062a8:	66 83 f8 03          	cmp    $0x3,%ax
801062ac:	0f 84 7e 01 00 00    	je     80106430 <trap+0x240>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING &&
801062b2:	e8 39 de ff ff       	call   801040f0 <myproc>
801062b7:	85 c0                	test   %eax,%eax
801062b9:	74 0f                	je     801062ca <trap+0xda>
801062bb:	e8 30 de ff ff       	call   801040f0 <myproc>
801062c0:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062c4:	0f 84 16 01 00 00    	je     801063e0 <trap+0x1f0>
      tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801062ca:	e8 21 de ff ff       	call   801040f0 <myproc>
801062cf:	85 c0                	test   %eax,%eax
801062d1:	74 1d                	je     801062f0 <trap+0x100>
801062d3:	e8 18 de ff ff       	call   801040f0 <myproc>
801062d8:	8b 40 24             	mov    0x24(%eax),%eax
801062db:	85 c0                	test   %eax,%eax
801062dd:	74 11                	je     801062f0 <trap+0x100>
801062df:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062e3:	83 e0 03             	and    $0x3,%eax
801062e6:	66 83 f8 03          	cmp    $0x3,%ax
801062ea:	0f 84 31 01 00 00    	je     80106421 <trap+0x231>
    exit();
}
801062f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062f3:	5b                   	pop    %ebx
801062f4:	5e                   	pop    %esi
801062f5:	5f                   	pop    %edi
801062f6:	5d                   	pop    %ebp
801062f7:	c3                   	ret    
    ideintr();
801062f8:	e8 f3 bf ff ff       	call   801022f0 <ideintr>
    lapiceoi();
801062fd:	e8 3e cd ff ff       	call   80103040 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106302:	e8 e9 dd ff ff       	call   801040f0 <myproc>
80106307:	85 c0                	test   %eax,%eax
80106309:	75 8a                	jne    80106295 <trap+0xa5>
8010630b:	eb a5                	jmp    801062b2 <trap+0xc2>
8010630d:	0f 20 d6             	mov    %cr2,%esi
    page_fault_handler(myproc()->pgdir, rcr2());
80106310:	e8 db dd ff ff       	call   801040f0 <myproc>
80106315:	83 ec 08             	sub    $0x8,%esp
80106318:	56                   	push   %esi
80106319:	ff 70 04             	pushl  0x4(%eax)
8010631c:	e8 ef c9 ff ff       	call   80102d10 <page_fault_handler>
    break;
80106321:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106324:	e8 c7 dd ff ff       	call   801040f0 <myproc>
80106329:	85 c0                	test   %eax,%eax
8010632b:	0f 85 64 ff ff ff    	jne    80106295 <trap+0xa5>
80106331:	e9 7c ff ff ff       	jmp    801062b2 <trap+0xc2>
    if (cpuid() == 0)
80106336:	e8 95 dd ff ff       	call   801040d0 <cpuid>
8010633b:	85 c0                	test   %eax,%eax
8010633d:	75 be                	jne    801062fd <trap+0x10d>
      acquire(&tickslock);
8010633f:	83 ec 0c             	sub    $0xc,%esp
80106342:	68 c0 bc 11 80       	push   $0x8011bcc0
80106347:	e8 94 e9 ff ff       	call   80104ce0 <acquire>
      wakeup(&ticks);
8010634c:	c7 04 24 00 c5 11 80 	movl   $0x8011c500,(%esp)
      ticks++;
80106353:	83 05 00 c5 11 80 01 	addl   $0x1,0x8011c500
      wakeup(&ticks);
8010635a:	e8 01 e5 ff ff       	call   80104860 <wakeup>
      release(&tickslock);
8010635f:	c7 04 24 c0 bc 11 80 	movl   $0x8011bcc0,(%esp)
80106366:	e8 35 ea ff ff       	call   80104da0 <release>
8010636b:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010636e:	eb 8d                	jmp    801062fd <trap+0x10d>
    kbdintr();
80106370:	e8 8b cb ff ff       	call   80102f00 <kbdintr>
    lapiceoi();
80106375:	e8 c6 cc ff ff       	call   80103040 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010637a:	e8 71 dd ff ff       	call   801040f0 <myproc>
8010637f:	85 c0                	test   %eax,%eax
80106381:	0f 85 0e ff ff ff    	jne    80106295 <trap+0xa5>
80106387:	e9 26 ff ff ff       	jmp    801062b2 <trap+0xc2>
    uartintr();
8010638c:	e8 5f 02 00 00       	call   801065f0 <uartintr>
    lapiceoi();
80106391:	e8 aa cc ff ff       	call   80103040 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106396:	e8 55 dd ff ff       	call   801040f0 <myproc>
8010639b:	85 c0                	test   %eax,%eax
8010639d:	0f 85 f2 fe ff ff    	jne    80106295 <trap+0xa5>
801063a3:	e9 0a ff ff ff       	jmp    801062b2 <trap+0xc2>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801063a8:	8b 7b 38             	mov    0x38(%ebx),%edi
801063ab:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801063af:	e8 1c dd ff ff       	call   801040d0 <cpuid>
801063b4:	57                   	push   %edi
801063b5:	56                   	push   %esi
801063b6:	50                   	push   %eax
801063b7:	68 b0 84 10 80       	push   $0x801084b0
801063bc:	e8 ef a2 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801063c1:	e8 7a cc ff ff       	call   80103040 <lapiceoi>
    break;
801063c6:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801063c9:	e8 22 dd ff ff       	call   801040f0 <myproc>
801063ce:	85 c0                	test   %eax,%eax
801063d0:	0f 85 bf fe ff ff    	jne    80106295 <trap+0xa5>
801063d6:	e9 d7 fe ff ff       	jmp    801062b2 <trap+0xc2>
801063db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063df:	90                   	nop
  if (myproc() && myproc()->state == RUNNING &&
801063e0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801063e4:	0f 85 e0 fe ff ff    	jne    801062ca <trap+0xda>
    yield();
801063ea:	e8 61 e2 ff ff       	call   80104650 <yield>
801063ef:	e9 d6 fe ff ff       	jmp    801062ca <trap+0xda>
801063f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
801063f8:	e8 f3 dc ff ff       	call   801040f0 <myproc>
801063fd:	8b 70 24             	mov    0x24(%eax),%esi
80106400:	85 f6                	test   %esi,%esi
80106402:	75 3c                	jne    80106440 <trap+0x250>
    myproc()->tf = tf;
80106404:	e8 e7 dc ff ff       	call   801040f0 <myproc>
80106409:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010640c:	e8 af ed ff ff       	call   801051c0 <syscall>
    if (myproc()->killed)
80106411:	e8 da dc ff ff       	call   801040f0 <myproc>
80106416:	8b 48 24             	mov    0x24(%eax),%ecx
80106419:	85 c9                	test   %ecx,%ecx
8010641b:	0f 84 cf fe ff ff    	je     801062f0 <trap+0x100>
}
80106421:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106424:	5b                   	pop    %ebx
80106425:	5e                   	pop    %esi
80106426:	5f                   	pop    %edi
80106427:	5d                   	pop    %ebp
      exit();
80106428:	e9 e3 e0 ff ff       	jmp    80104510 <exit>
8010642d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106430:	e8 db e0 ff ff       	call   80104510 <exit>
80106435:	e9 78 fe ff ff       	jmp    801062b2 <trap+0xc2>
8010643a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106440:	e8 cb e0 ff ff       	call   80104510 <exit>
80106445:	eb bd                	jmp    80106404 <trap+0x214>
80106447:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010644a:	8b 73 38             	mov    0x38(%ebx),%esi
8010644d:	e8 7e dc ff ff       	call   801040d0 <cpuid>
80106452:	83 ec 0c             	sub    $0xc,%esp
80106455:	57                   	push   %edi
80106456:	56                   	push   %esi
80106457:	50                   	push   %eax
80106458:	ff 73 30             	pushl  0x30(%ebx)
8010645b:	68 d4 84 10 80       	push   $0x801084d4
80106460:	e8 4b a2 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106465:	83 c4 14             	add    $0x14,%esp
80106468:	68 aa 84 10 80       	push   $0x801084aa
8010646d:	e8 1e 9f ff ff       	call   80100390 <panic>
80106472:	66 90                	xchg   %ax,%ax
80106474:	66 90                	xchg   %ax,%ax
80106476:	66 90                	xchg   %ax,%ax
80106478:	66 90                	xchg   %ax,%ax
8010647a:	66 90                	xchg   %ax,%ax
8010647c:	66 90                	xchg   %ax,%ax
8010647e:	66 90                	xchg   %ax,%ax

80106480 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106480:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106484:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106489:	85 c0                	test   %eax,%eax
8010648b:	74 1b                	je     801064a8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010648d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106492:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106493:	a8 01                	test   $0x1,%al
80106495:	74 11                	je     801064a8 <uartgetc+0x28>
80106497:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010649c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010649d:	0f b6 c0             	movzbl %al,%eax
801064a0:	c3                   	ret    
801064a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801064a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064ad:	c3                   	ret    
801064ae:	66 90                	xchg   %ax,%ax

801064b0 <uartputc.part.0>:
uartputc(int c)
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	57                   	push   %edi
801064b4:	89 c7                	mov    %eax,%edi
801064b6:	56                   	push   %esi
801064b7:	be fd 03 00 00       	mov    $0x3fd,%esi
801064bc:	53                   	push   %ebx
801064bd:	bb 80 00 00 00       	mov    $0x80,%ebx
801064c2:	83 ec 0c             	sub    $0xc,%esp
801064c5:	eb 1b                	jmp    801064e2 <uartputc.part.0+0x32>
801064c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ce:	66 90                	xchg   %ax,%ax
    microdelay(10);
801064d0:	83 ec 0c             	sub    $0xc,%esp
801064d3:	6a 0a                	push   $0xa
801064d5:	e8 86 cb ff ff       	call   80103060 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064da:	83 c4 10             	add    $0x10,%esp
801064dd:	83 eb 01             	sub    $0x1,%ebx
801064e0:	74 07                	je     801064e9 <uartputc.part.0+0x39>
801064e2:	89 f2                	mov    %esi,%edx
801064e4:	ec                   	in     (%dx),%al
801064e5:	a8 20                	test   $0x20,%al
801064e7:	74 e7                	je     801064d0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064ee:	89 f8                	mov    %edi,%eax
801064f0:	ee                   	out    %al,(%dx)
}
801064f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064f4:	5b                   	pop    %ebx
801064f5:	5e                   	pop    %esi
801064f6:	5f                   	pop    %edi
801064f7:	5d                   	pop    %ebp
801064f8:	c3                   	ret    
801064f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106500 <uartinit>:
{
80106500:	f3 0f 1e fb          	endbr32 
80106504:	55                   	push   %ebp
80106505:	31 c9                	xor    %ecx,%ecx
80106507:	89 c8                	mov    %ecx,%eax
80106509:	89 e5                	mov    %esp,%ebp
8010650b:	57                   	push   %edi
8010650c:	56                   	push   %esi
8010650d:	53                   	push   %ebx
8010650e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106513:	89 da                	mov    %ebx,%edx
80106515:	83 ec 0c             	sub    $0xc,%esp
80106518:	ee                   	out    %al,(%dx)
80106519:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010651e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106523:	89 fa                	mov    %edi,%edx
80106525:	ee                   	out    %al,(%dx)
80106526:	b8 0c 00 00 00       	mov    $0xc,%eax
8010652b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106530:	ee                   	out    %al,(%dx)
80106531:	be f9 03 00 00       	mov    $0x3f9,%esi
80106536:	89 c8                	mov    %ecx,%eax
80106538:	89 f2                	mov    %esi,%edx
8010653a:	ee                   	out    %al,(%dx)
8010653b:	b8 03 00 00 00       	mov    $0x3,%eax
80106540:	89 fa                	mov    %edi,%edx
80106542:	ee                   	out    %al,(%dx)
80106543:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106548:	89 c8                	mov    %ecx,%eax
8010654a:	ee                   	out    %al,(%dx)
8010654b:	b8 01 00 00 00       	mov    $0x1,%eax
80106550:	89 f2                	mov    %esi,%edx
80106552:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106553:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106558:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106559:	3c ff                	cmp    $0xff,%al
8010655b:	74 52                	je     801065af <uartinit+0xaf>
  uart = 1;
8010655d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106564:	00 00 00 
80106567:	89 da                	mov    %ebx,%edx
80106569:	ec                   	in     (%dx),%al
8010656a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010656f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106570:	83 ec 08             	sub    $0x8,%esp
80106573:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106578:	bb 14 86 10 80       	mov    $0x80108614,%ebx
  ioapicenable(IRQ_COM1, 0);
8010657d:	6a 00                	push   $0x0
8010657f:	6a 04                	push   $0x4
80106581:	e8 ba bf ff ff       	call   80102540 <ioapicenable>
80106586:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106589:	b8 78 00 00 00       	mov    $0x78,%eax
8010658e:	eb 04                	jmp    80106594 <uartinit+0x94>
80106590:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106594:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010659a:	85 d2                	test   %edx,%edx
8010659c:	74 08                	je     801065a6 <uartinit+0xa6>
    uartputc(*p);
8010659e:	0f be c0             	movsbl %al,%eax
801065a1:	e8 0a ff ff ff       	call   801064b0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801065a6:	89 f0                	mov    %esi,%eax
801065a8:	83 c3 01             	add    $0x1,%ebx
801065ab:	84 c0                	test   %al,%al
801065ad:	75 e1                	jne    80106590 <uartinit+0x90>
}
801065af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065b2:	5b                   	pop    %ebx
801065b3:	5e                   	pop    %esi
801065b4:	5f                   	pop    %edi
801065b5:	5d                   	pop    %ebp
801065b6:	c3                   	ret    
801065b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065be:	66 90                	xchg   %ax,%ax

801065c0 <uartputc>:
{
801065c0:	f3 0f 1e fb          	endbr32 
801065c4:	55                   	push   %ebp
  if(!uart)
801065c5:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801065cb:	89 e5                	mov    %esp,%ebp
801065cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801065d0:	85 d2                	test   %edx,%edx
801065d2:	74 0c                	je     801065e0 <uartputc+0x20>
}
801065d4:	5d                   	pop    %ebp
801065d5:	e9 d6 fe ff ff       	jmp    801064b0 <uartputc.part.0>
801065da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065e0:	5d                   	pop    %ebp
801065e1:	c3                   	ret    
801065e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065f0 <uartintr>:

void
uartintr(void)
{
801065f0:	f3 0f 1e fb          	endbr32 
801065f4:	55                   	push   %ebp
801065f5:	89 e5                	mov    %esp,%ebp
801065f7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065fa:	68 80 64 10 80       	push   $0x80106480
801065ff:	e8 5c a2 ff ff       	call   80100860 <consoleintr>
}
80106604:	83 c4 10             	add    $0x10,%esp
80106607:	c9                   	leave  
80106608:	c3                   	ret    

80106609 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $0
8010660b:	6a 00                	push   $0x0
  jmp alltraps
8010660d:	e9 fc fa ff ff       	jmp    8010610e <alltraps>

80106612 <vector1>:
.globl vector1
vector1:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $1
80106614:	6a 01                	push   $0x1
  jmp alltraps
80106616:	e9 f3 fa ff ff       	jmp    8010610e <alltraps>

8010661b <vector2>:
.globl vector2
vector2:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $2
8010661d:	6a 02                	push   $0x2
  jmp alltraps
8010661f:	e9 ea fa ff ff       	jmp    8010610e <alltraps>

80106624 <vector3>:
.globl vector3
vector3:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $3
80106626:	6a 03                	push   $0x3
  jmp alltraps
80106628:	e9 e1 fa ff ff       	jmp    8010610e <alltraps>

8010662d <vector4>:
.globl vector4
vector4:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $4
8010662f:	6a 04                	push   $0x4
  jmp alltraps
80106631:	e9 d8 fa ff ff       	jmp    8010610e <alltraps>

80106636 <vector5>:
.globl vector5
vector5:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $5
80106638:	6a 05                	push   $0x5
  jmp alltraps
8010663a:	e9 cf fa ff ff       	jmp    8010610e <alltraps>

8010663f <vector6>:
.globl vector6
vector6:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $6
80106641:	6a 06                	push   $0x6
  jmp alltraps
80106643:	e9 c6 fa ff ff       	jmp    8010610e <alltraps>

80106648 <vector7>:
.globl vector7
vector7:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $7
8010664a:	6a 07                	push   $0x7
  jmp alltraps
8010664c:	e9 bd fa ff ff       	jmp    8010610e <alltraps>

80106651 <vector8>:
.globl vector8
vector8:
  pushl $8
80106651:	6a 08                	push   $0x8
  jmp alltraps
80106653:	e9 b6 fa ff ff       	jmp    8010610e <alltraps>

80106658 <vector9>:
.globl vector9
vector9:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $9
8010665a:	6a 09                	push   $0x9
  jmp alltraps
8010665c:	e9 ad fa ff ff       	jmp    8010610e <alltraps>

80106661 <vector10>:
.globl vector10
vector10:
  pushl $10
80106661:	6a 0a                	push   $0xa
  jmp alltraps
80106663:	e9 a6 fa ff ff       	jmp    8010610e <alltraps>

80106668 <vector11>:
.globl vector11
vector11:
  pushl $11
80106668:	6a 0b                	push   $0xb
  jmp alltraps
8010666a:	e9 9f fa ff ff       	jmp    8010610e <alltraps>

8010666f <vector12>:
.globl vector12
vector12:
  pushl $12
8010666f:	6a 0c                	push   $0xc
  jmp alltraps
80106671:	e9 98 fa ff ff       	jmp    8010610e <alltraps>

80106676 <vector13>:
.globl vector13
vector13:
  pushl $13
80106676:	6a 0d                	push   $0xd
  jmp alltraps
80106678:	e9 91 fa ff ff       	jmp    8010610e <alltraps>

8010667d <vector14>:
.globl vector14
vector14:
  pushl $14
8010667d:	6a 0e                	push   $0xe
  jmp alltraps
8010667f:	e9 8a fa ff ff       	jmp    8010610e <alltraps>

80106684 <vector15>:
.globl vector15
vector15:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $15
80106686:	6a 0f                	push   $0xf
  jmp alltraps
80106688:	e9 81 fa ff ff       	jmp    8010610e <alltraps>

8010668d <vector16>:
.globl vector16
vector16:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $16
8010668f:	6a 10                	push   $0x10
  jmp alltraps
80106691:	e9 78 fa ff ff       	jmp    8010610e <alltraps>

80106696 <vector17>:
.globl vector17
vector17:
  pushl $17
80106696:	6a 11                	push   $0x11
  jmp alltraps
80106698:	e9 71 fa ff ff       	jmp    8010610e <alltraps>

8010669d <vector18>:
.globl vector18
vector18:
  pushl $0
8010669d:	6a 00                	push   $0x0
  pushl $18
8010669f:	6a 12                	push   $0x12
  jmp alltraps
801066a1:	e9 68 fa ff ff       	jmp    8010610e <alltraps>

801066a6 <vector19>:
.globl vector19
vector19:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $19
801066a8:	6a 13                	push   $0x13
  jmp alltraps
801066aa:	e9 5f fa ff ff       	jmp    8010610e <alltraps>

801066af <vector20>:
.globl vector20
vector20:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $20
801066b1:	6a 14                	push   $0x14
  jmp alltraps
801066b3:	e9 56 fa ff ff       	jmp    8010610e <alltraps>

801066b8 <vector21>:
.globl vector21
vector21:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $21
801066ba:	6a 15                	push   $0x15
  jmp alltraps
801066bc:	e9 4d fa ff ff       	jmp    8010610e <alltraps>

801066c1 <vector22>:
.globl vector22
vector22:
  pushl $0
801066c1:	6a 00                	push   $0x0
  pushl $22
801066c3:	6a 16                	push   $0x16
  jmp alltraps
801066c5:	e9 44 fa ff ff       	jmp    8010610e <alltraps>

801066ca <vector23>:
.globl vector23
vector23:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $23
801066cc:	6a 17                	push   $0x17
  jmp alltraps
801066ce:	e9 3b fa ff ff       	jmp    8010610e <alltraps>

801066d3 <vector24>:
.globl vector24
vector24:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $24
801066d5:	6a 18                	push   $0x18
  jmp alltraps
801066d7:	e9 32 fa ff ff       	jmp    8010610e <alltraps>

801066dc <vector25>:
.globl vector25
vector25:
  pushl $0
801066dc:	6a 00                	push   $0x0
  pushl $25
801066de:	6a 19                	push   $0x19
  jmp alltraps
801066e0:	e9 29 fa ff ff       	jmp    8010610e <alltraps>

801066e5 <vector26>:
.globl vector26
vector26:
  pushl $0
801066e5:	6a 00                	push   $0x0
  pushl $26
801066e7:	6a 1a                	push   $0x1a
  jmp alltraps
801066e9:	e9 20 fa ff ff       	jmp    8010610e <alltraps>

801066ee <vector27>:
.globl vector27
vector27:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $27
801066f0:	6a 1b                	push   $0x1b
  jmp alltraps
801066f2:	e9 17 fa ff ff       	jmp    8010610e <alltraps>

801066f7 <vector28>:
.globl vector28
vector28:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $28
801066f9:	6a 1c                	push   $0x1c
  jmp alltraps
801066fb:	e9 0e fa ff ff       	jmp    8010610e <alltraps>

80106700 <vector29>:
.globl vector29
vector29:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $29
80106702:	6a 1d                	push   $0x1d
  jmp alltraps
80106704:	e9 05 fa ff ff       	jmp    8010610e <alltraps>

80106709 <vector30>:
.globl vector30
vector30:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $30
8010670b:	6a 1e                	push   $0x1e
  jmp alltraps
8010670d:	e9 fc f9 ff ff       	jmp    8010610e <alltraps>

80106712 <vector31>:
.globl vector31
vector31:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $31
80106714:	6a 1f                	push   $0x1f
  jmp alltraps
80106716:	e9 f3 f9 ff ff       	jmp    8010610e <alltraps>

8010671b <vector32>:
.globl vector32
vector32:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $32
8010671d:	6a 20                	push   $0x20
  jmp alltraps
8010671f:	e9 ea f9 ff ff       	jmp    8010610e <alltraps>

80106724 <vector33>:
.globl vector33
vector33:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $33
80106726:	6a 21                	push   $0x21
  jmp alltraps
80106728:	e9 e1 f9 ff ff       	jmp    8010610e <alltraps>

8010672d <vector34>:
.globl vector34
vector34:
  pushl $0
8010672d:	6a 00                	push   $0x0
  pushl $34
8010672f:	6a 22                	push   $0x22
  jmp alltraps
80106731:	e9 d8 f9 ff ff       	jmp    8010610e <alltraps>

80106736 <vector35>:
.globl vector35
vector35:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $35
80106738:	6a 23                	push   $0x23
  jmp alltraps
8010673a:	e9 cf f9 ff ff       	jmp    8010610e <alltraps>

8010673f <vector36>:
.globl vector36
vector36:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $36
80106741:	6a 24                	push   $0x24
  jmp alltraps
80106743:	e9 c6 f9 ff ff       	jmp    8010610e <alltraps>

80106748 <vector37>:
.globl vector37
vector37:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $37
8010674a:	6a 25                	push   $0x25
  jmp alltraps
8010674c:	e9 bd f9 ff ff       	jmp    8010610e <alltraps>

80106751 <vector38>:
.globl vector38
vector38:
  pushl $0
80106751:	6a 00                	push   $0x0
  pushl $38
80106753:	6a 26                	push   $0x26
  jmp alltraps
80106755:	e9 b4 f9 ff ff       	jmp    8010610e <alltraps>

8010675a <vector39>:
.globl vector39
vector39:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $39
8010675c:	6a 27                	push   $0x27
  jmp alltraps
8010675e:	e9 ab f9 ff ff       	jmp    8010610e <alltraps>

80106763 <vector40>:
.globl vector40
vector40:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $40
80106765:	6a 28                	push   $0x28
  jmp alltraps
80106767:	e9 a2 f9 ff ff       	jmp    8010610e <alltraps>

8010676c <vector41>:
.globl vector41
vector41:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $41
8010676e:	6a 29                	push   $0x29
  jmp alltraps
80106770:	e9 99 f9 ff ff       	jmp    8010610e <alltraps>

80106775 <vector42>:
.globl vector42
vector42:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $42
80106777:	6a 2a                	push   $0x2a
  jmp alltraps
80106779:	e9 90 f9 ff ff       	jmp    8010610e <alltraps>

8010677e <vector43>:
.globl vector43
vector43:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $43
80106780:	6a 2b                	push   $0x2b
  jmp alltraps
80106782:	e9 87 f9 ff ff       	jmp    8010610e <alltraps>

80106787 <vector44>:
.globl vector44
vector44:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $44
80106789:	6a 2c                	push   $0x2c
  jmp alltraps
8010678b:	e9 7e f9 ff ff       	jmp    8010610e <alltraps>

80106790 <vector45>:
.globl vector45
vector45:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $45
80106792:	6a 2d                	push   $0x2d
  jmp alltraps
80106794:	e9 75 f9 ff ff       	jmp    8010610e <alltraps>

80106799 <vector46>:
.globl vector46
vector46:
  pushl $0
80106799:	6a 00                	push   $0x0
  pushl $46
8010679b:	6a 2e                	push   $0x2e
  jmp alltraps
8010679d:	e9 6c f9 ff ff       	jmp    8010610e <alltraps>

801067a2 <vector47>:
.globl vector47
vector47:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $47
801067a4:	6a 2f                	push   $0x2f
  jmp alltraps
801067a6:	e9 63 f9 ff ff       	jmp    8010610e <alltraps>

801067ab <vector48>:
.globl vector48
vector48:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $48
801067ad:	6a 30                	push   $0x30
  jmp alltraps
801067af:	e9 5a f9 ff ff       	jmp    8010610e <alltraps>

801067b4 <vector49>:
.globl vector49
vector49:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $49
801067b6:	6a 31                	push   $0x31
  jmp alltraps
801067b8:	e9 51 f9 ff ff       	jmp    8010610e <alltraps>

801067bd <vector50>:
.globl vector50
vector50:
  pushl $0
801067bd:	6a 00                	push   $0x0
  pushl $50
801067bf:	6a 32                	push   $0x32
  jmp alltraps
801067c1:	e9 48 f9 ff ff       	jmp    8010610e <alltraps>

801067c6 <vector51>:
.globl vector51
vector51:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $51
801067c8:	6a 33                	push   $0x33
  jmp alltraps
801067ca:	e9 3f f9 ff ff       	jmp    8010610e <alltraps>

801067cf <vector52>:
.globl vector52
vector52:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $52
801067d1:	6a 34                	push   $0x34
  jmp alltraps
801067d3:	e9 36 f9 ff ff       	jmp    8010610e <alltraps>

801067d8 <vector53>:
.globl vector53
vector53:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $53
801067da:	6a 35                	push   $0x35
  jmp alltraps
801067dc:	e9 2d f9 ff ff       	jmp    8010610e <alltraps>

801067e1 <vector54>:
.globl vector54
vector54:
  pushl $0
801067e1:	6a 00                	push   $0x0
  pushl $54
801067e3:	6a 36                	push   $0x36
  jmp alltraps
801067e5:	e9 24 f9 ff ff       	jmp    8010610e <alltraps>

801067ea <vector55>:
.globl vector55
vector55:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $55
801067ec:	6a 37                	push   $0x37
  jmp alltraps
801067ee:	e9 1b f9 ff ff       	jmp    8010610e <alltraps>

801067f3 <vector56>:
.globl vector56
vector56:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $56
801067f5:	6a 38                	push   $0x38
  jmp alltraps
801067f7:	e9 12 f9 ff ff       	jmp    8010610e <alltraps>

801067fc <vector57>:
.globl vector57
vector57:
  pushl $0
801067fc:	6a 00                	push   $0x0
  pushl $57
801067fe:	6a 39                	push   $0x39
  jmp alltraps
80106800:	e9 09 f9 ff ff       	jmp    8010610e <alltraps>

80106805 <vector58>:
.globl vector58
vector58:
  pushl $0
80106805:	6a 00                	push   $0x0
  pushl $58
80106807:	6a 3a                	push   $0x3a
  jmp alltraps
80106809:	e9 00 f9 ff ff       	jmp    8010610e <alltraps>

8010680e <vector59>:
.globl vector59
vector59:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $59
80106810:	6a 3b                	push   $0x3b
  jmp alltraps
80106812:	e9 f7 f8 ff ff       	jmp    8010610e <alltraps>

80106817 <vector60>:
.globl vector60
vector60:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $60
80106819:	6a 3c                	push   $0x3c
  jmp alltraps
8010681b:	e9 ee f8 ff ff       	jmp    8010610e <alltraps>

80106820 <vector61>:
.globl vector61
vector61:
  pushl $0
80106820:	6a 00                	push   $0x0
  pushl $61
80106822:	6a 3d                	push   $0x3d
  jmp alltraps
80106824:	e9 e5 f8 ff ff       	jmp    8010610e <alltraps>

80106829 <vector62>:
.globl vector62
vector62:
  pushl $0
80106829:	6a 00                	push   $0x0
  pushl $62
8010682b:	6a 3e                	push   $0x3e
  jmp alltraps
8010682d:	e9 dc f8 ff ff       	jmp    8010610e <alltraps>

80106832 <vector63>:
.globl vector63
vector63:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $63
80106834:	6a 3f                	push   $0x3f
  jmp alltraps
80106836:	e9 d3 f8 ff ff       	jmp    8010610e <alltraps>

8010683b <vector64>:
.globl vector64
vector64:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $64
8010683d:	6a 40                	push   $0x40
  jmp alltraps
8010683f:	e9 ca f8 ff ff       	jmp    8010610e <alltraps>

80106844 <vector65>:
.globl vector65
vector65:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $65
80106846:	6a 41                	push   $0x41
  jmp alltraps
80106848:	e9 c1 f8 ff ff       	jmp    8010610e <alltraps>

8010684d <vector66>:
.globl vector66
vector66:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $66
8010684f:	6a 42                	push   $0x42
  jmp alltraps
80106851:	e9 b8 f8 ff ff       	jmp    8010610e <alltraps>

80106856 <vector67>:
.globl vector67
vector67:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $67
80106858:	6a 43                	push   $0x43
  jmp alltraps
8010685a:	e9 af f8 ff ff       	jmp    8010610e <alltraps>

8010685f <vector68>:
.globl vector68
vector68:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $68
80106861:	6a 44                	push   $0x44
  jmp alltraps
80106863:	e9 a6 f8 ff ff       	jmp    8010610e <alltraps>

80106868 <vector69>:
.globl vector69
vector69:
  pushl $0
80106868:	6a 00                	push   $0x0
  pushl $69
8010686a:	6a 45                	push   $0x45
  jmp alltraps
8010686c:	e9 9d f8 ff ff       	jmp    8010610e <alltraps>

80106871 <vector70>:
.globl vector70
vector70:
  pushl $0
80106871:	6a 00                	push   $0x0
  pushl $70
80106873:	6a 46                	push   $0x46
  jmp alltraps
80106875:	e9 94 f8 ff ff       	jmp    8010610e <alltraps>

8010687a <vector71>:
.globl vector71
vector71:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $71
8010687c:	6a 47                	push   $0x47
  jmp alltraps
8010687e:	e9 8b f8 ff ff       	jmp    8010610e <alltraps>

80106883 <vector72>:
.globl vector72
vector72:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $72
80106885:	6a 48                	push   $0x48
  jmp alltraps
80106887:	e9 82 f8 ff ff       	jmp    8010610e <alltraps>

8010688c <vector73>:
.globl vector73
vector73:
  pushl $0
8010688c:	6a 00                	push   $0x0
  pushl $73
8010688e:	6a 49                	push   $0x49
  jmp alltraps
80106890:	e9 79 f8 ff ff       	jmp    8010610e <alltraps>

80106895 <vector74>:
.globl vector74
vector74:
  pushl $0
80106895:	6a 00                	push   $0x0
  pushl $74
80106897:	6a 4a                	push   $0x4a
  jmp alltraps
80106899:	e9 70 f8 ff ff       	jmp    8010610e <alltraps>

8010689e <vector75>:
.globl vector75
vector75:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $75
801068a0:	6a 4b                	push   $0x4b
  jmp alltraps
801068a2:	e9 67 f8 ff ff       	jmp    8010610e <alltraps>

801068a7 <vector76>:
.globl vector76
vector76:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $76
801068a9:	6a 4c                	push   $0x4c
  jmp alltraps
801068ab:	e9 5e f8 ff ff       	jmp    8010610e <alltraps>

801068b0 <vector77>:
.globl vector77
vector77:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $77
801068b2:	6a 4d                	push   $0x4d
  jmp alltraps
801068b4:	e9 55 f8 ff ff       	jmp    8010610e <alltraps>

801068b9 <vector78>:
.globl vector78
vector78:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $78
801068bb:	6a 4e                	push   $0x4e
  jmp alltraps
801068bd:	e9 4c f8 ff ff       	jmp    8010610e <alltraps>

801068c2 <vector79>:
.globl vector79
vector79:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $79
801068c4:	6a 4f                	push   $0x4f
  jmp alltraps
801068c6:	e9 43 f8 ff ff       	jmp    8010610e <alltraps>

801068cb <vector80>:
.globl vector80
vector80:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $80
801068cd:	6a 50                	push   $0x50
  jmp alltraps
801068cf:	e9 3a f8 ff ff       	jmp    8010610e <alltraps>

801068d4 <vector81>:
.globl vector81
vector81:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $81
801068d6:	6a 51                	push   $0x51
  jmp alltraps
801068d8:	e9 31 f8 ff ff       	jmp    8010610e <alltraps>

801068dd <vector82>:
.globl vector82
vector82:
  pushl $0
801068dd:	6a 00                	push   $0x0
  pushl $82
801068df:	6a 52                	push   $0x52
  jmp alltraps
801068e1:	e9 28 f8 ff ff       	jmp    8010610e <alltraps>

801068e6 <vector83>:
.globl vector83
vector83:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $83
801068e8:	6a 53                	push   $0x53
  jmp alltraps
801068ea:	e9 1f f8 ff ff       	jmp    8010610e <alltraps>

801068ef <vector84>:
.globl vector84
vector84:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $84
801068f1:	6a 54                	push   $0x54
  jmp alltraps
801068f3:	e9 16 f8 ff ff       	jmp    8010610e <alltraps>

801068f8 <vector85>:
.globl vector85
vector85:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $85
801068fa:	6a 55                	push   $0x55
  jmp alltraps
801068fc:	e9 0d f8 ff ff       	jmp    8010610e <alltraps>

80106901 <vector86>:
.globl vector86
vector86:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $86
80106903:	6a 56                	push   $0x56
  jmp alltraps
80106905:	e9 04 f8 ff ff       	jmp    8010610e <alltraps>

8010690a <vector87>:
.globl vector87
vector87:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $87
8010690c:	6a 57                	push   $0x57
  jmp alltraps
8010690e:	e9 fb f7 ff ff       	jmp    8010610e <alltraps>

80106913 <vector88>:
.globl vector88
vector88:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $88
80106915:	6a 58                	push   $0x58
  jmp alltraps
80106917:	e9 f2 f7 ff ff       	jmp    8010610e <alltraps>

8010691c <vector89>:
.globl vector89
vector89:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $89
8010691e:	6a 59                	push   $0x59
  jmp alltraps
80106920:	e9 e9 f7 ff ff       	jmp    8010610e <alltraps>

80106925 <vector90>:
.globl vector90
vector90:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $90
80106927:	6a 5a                	push   $0x5a
  jmp alltraps
80106929:	e9 e0 f7 ff ff       	jmp    8010610e <alltraps>

8010692e <vector91>:
.globl vector91
vector91:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $91
80106930:	6a 5b                	push   $0x5b
  jmp alltraps
80106932:	e9 d7 f7 ff ff       	jmp    8010610e <alltraps>

80106937 <vector92>:
.globl vector92
vector92:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $92
80106939:	6a 5c                	push   $0x5c
  jmp alltraps
8010693b:	e9 ce f7 ff ff       	jmp    8010610e <alltraps>

80106940 <vector93>:
.globl vector93
vector93:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $93
80106942:	6a 5d                	push   $0x5d
  jmp alltraps
80106944:	e9 c5 f7 ff ff       	jmp    8010610e <alltraps>

80106949 <vector94>:
.globl vector94
vector94:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $94
8010694b:	6a 5e                	push   $0x5e
  jmp alltraps
8010694d:	e9 bc f7 ff ff       	jmp    8010610e <alltraps>

80106952 <vector95>:
.globl vector95
vector95:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $95
80106954:	6a 5f                	push   $0x5f
  jmp alltraps
80106956:	e9 b3 f7 ff ff       	jmp    8010610e <alltraps>

8010695b <vector96>:
.globl vector96
vector96:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $96
8010695d:	6a 60                	push   $0x60
  jmp alltraps
8010695f:	e9 aa f7 ff ff       	jmp    8010610e <alltraps>

80106964 <vector97>:
.globl vector97
vector97:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $97
80106966:	6a 61                	push   $0x61
  jmp alltraps
80106968:	e9 a1 f7 ff ff       	jmp    8010610e <alltraps>

8010696d <vector98>:
.globl vector98
vector98:
  pushl $0
8010696d:	6a 00                	push   $0x0
  pushl $98
8010696f:	6a 62                	push   $0x62
  jmp alltraps
80106971:	e9 98 f7 ff ff       	jmp    8010610e <alltraps>

80106976 <vector99>:
.globl vector99
vector99:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $99
80106978:	6a 63                	push   $0x63
  jmp alltraps
8010697a:	e9 8f f7 ff ff       	jmp    8010610e <alltraps>

8010697f <vector100>:
.globl vector100
vector100:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $100
80106981:	6a 64                	push   $0x64
  jmp alltraps
80106983:	e9 86 f7 ff ff       	jmp    8010610e <alltraps>

80106988 <vector101>:
.globl vector101
vector101:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $101
8010698a:	6a 65                	push   $0x65
  jmp alltraps
8010698c:	e9 7d f7 ff ff       	jmp    8010610e <alltraps>

80106991 <vector102>:
.globl vector102
vector102:
  pushl $0
80106991:	6a 00                	push   $0x0
  pushl $102
80106993:	6a 66                	push   $0x66
  jmp alltraps
80106995:	e9 74 f7 ff ff       	jmp    8010610e <alltraps>

8010699a <vector103>:
.globl vector103
vector103:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $103
8010699c:	6a 67                	push   $0x67
  jmp alltraps
8010699e:	e9 6b f7 ff ff       	jmp    8010610e <alltraps>

801069a3 <vector104>:
.globl vector104
vector104:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $104
801069a5:	6a 68                	push   $0x68
  jmp alltraps
801069a7:	e9 62 f7 ff ff       	jmp    8010610e <alltraps>

801069ac <vector105>:
.globl vector105
vector105:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $105
801069ae:	6a 69                	push   $0x69
  jmp alltraps
801069b0:	e9 59 f7 ff ff       	jmp    8010610e <alltraps>

801069b5 <vector106>:
.globl vector106
vector106:
  pushl $0
801069b5:	6a 00                	push   $0x0
  pushl $106
801069b7:	6a 6a                	push   $0x6a
  jmp alltraps
801069b9:	e9 50 f7 ff ff       	jmp    8010610e <alltraps>

801069be <vector107>:
.globl vector107
vector107:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $107
801069c0:	6a 6b                	push   $0x6b
  jmp alltraps
801069c2:	e9 47 f7 ff ff       	jmp    8010610e <alltraps>

801069c7 <vector108>:
.globl vector108
vector108:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $108
801069c9:	6a 6c                	push   $0x6c
  jmp alltraps
801069cb:	e9 3e f7 ff ff       	jmp    8010610e <alltraps>

801069d0 <vector109>:
.globl vector109
vector109:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $109
801069d2:	6a 6d                	push   $0x6d
  jmp alltraps
801069d4:	e9 35 f7 ff ff       	jmp    8010610e <alltraps>

801069d9 <vector110>:
.globl vector110
vector110:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $110
801069db:	6a 6e                	push   $0x6e
  jmp alltraps
801069dd:	e9 2c f7 ff ff       	jmp    8010610e <alltraps>

801069e2 <vector111>:
.globl vector111
vector111:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $111
801069e4:	6a 6f                	push   $0x6f
  jmp alltraps
801069e6:	e9 23 f7 ff ff       	jmp    8010610e <alltraps>

801069eb <vector112>:
.globl vector112
vector112:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $112
801069ed:	6a 70                	push   $0x70
  jmp alltraps
801069ef:	e9 1a f7 ff ff       	jmp    8010610e <alltraps>

801069f4 <vector113>:
.globl vector113
vector113:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $113
801069f6:	6a 71                	push   $0x71
  jmp alltraps
801069f8:	e9 11 f7 ff ff       	jmp    8010610e <alltraps>

801069fd <vector114>:
.globl vector114
vector114:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $114
801069ff:	6a 72                	push   $0x72
  jmp alltraps
80106a01:	e9 08 f7 ff ff       	jmp    8010610e <alltraps>

80106a06 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $115
80106a08:	6a 73                	push   $0x73
  jmp alltraps
80106a0a:	e9 ff f6 ff ff       	jmp    8010610e <alltraps>

80106a0f <vector116>:
.globl vector116
vector116:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $116
80106a11:	6a 74                	push   $0x74
  jmp alltraps
80106a13:	e9 f6 f6 ff ff       	jmp    8010610e <alltraps>

80106a18 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $117
80106a1a:	6a 75                	push   $0x75
  jmp alltraps
80106a1c:	e9 ed f6 ff ff       	jmp    8010610e <alltraps>

80106a21 <vector118>:
.globl vector118
vector118:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $118
80106a23:	6a 76                	push   $0x76
  jmp alltraps
80106a25:	e9 e4 f6 ff ff       	jmp    8010610e <alltraps>

80106a2a <vector119>:
.globl vector119
vector119:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $119
80106a2c:	6a 77                	push   $0x77
  jmp alltraps
80106a2e:	e9 db f6 ff ff       	jmp    8010610e <alltraps>

80106a33 <vector120>:
.globl vector120
vector120:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $120
80106a35:	6a 78                	push   $0x78
  jmp alltraps
80106a37:	e9 d2 f6 ff ff       	jmp    8010610e <alltraps>

80106a3c <vector121>:
.globl vector121
vector121:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $121
80106a3e:	6a 79                	push   $0x79
  jmp alltraps
80106a40:	e9 c9 f6 ff ff       	jmp    8010610e <alltraps>

80106a45 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $122
80106a47:	6a 7a                	push   $0x7a
  jmp alltraps
80106a49:	e9 c0 f6 ff ff       	jmp    8010610e <alltraps>

80106a4e <vector123>:
.globl vector123
vector123:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $123
80106a50:	6a 7b                	push   $0x7b
  jmp alltraps
80106a52:	e9 b7 f6 ff ff       	jmp    8010610e <alltraps>

80106a57 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $124
80106a59:	6a 7c                	push   $0x7c
  jmp alltraps
80106a5b:	e9 ae f6 ff ff       	jmp    8010610e <alltraps>

80106a60 <vector125>:
.globl vector125
vector125:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $125
80106a62:	6a 7d                	push   $0x7d
  jmp alltraps
80106a64:	e9 a5 f6 ff ff       	jmp    8010610e <alltraps>

80106a69 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $126
80106a6b:	6a 7e                	push   $0x7e
  jmp alltraps
80106a6d:	e9 9c f6 ff ff       	jmp    8010610e <alltraps>

80106a72 <vector127>:
.globl vector127
vector127:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $127
80106a74:	6a 7f                	push   $0x7f
  jmp alltraps
80106a76:	e9 93 f6 ff ff       	jmp    8010610e <alltraps>

80106a7b <vector128>:
.globl vector128
vector128:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $128
80106a7d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a82:	e9 87 f6 ff ff       	jmp    8010610e <alltraps>

80106a87 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $129
80106a89:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a8e:	e9 7b f6 ff ff       	jmp    8010610e <alltraps>

80106a93 <vector130>:
.globl vector130
vector130:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $130
80106a95:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a9a:	e9 6f f6 ff ff       	jmp    8010610e <alltraps>

80106a9f <vector131>:
.globl vector131
vector131:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $131
80106aa1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106aa6:	e9 63 f6 ff ff       	jmp    8010610e <alltraps>

80106aab <vector132>:
.globl vector132
vector132:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $132
80106aad:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ab2:	e9 57 f6 ff ff       	jmp    8010610e <alltraps>

80106ab7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $133
80106ab9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106abe:	e9 4b f6 ff ff       	jmp    8010610e <alltraps>

80106ac3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $134
80106ac5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106aca:	e9 3f f6 ff ff       	jmp    8010610e <alltraps>

80106acf <vector135>:
.globl vector135
vector135:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $135
80106ad1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ad6:	e9 33 f6 ff ff       	jmp    8010610e <alltraps>

80106adb <vector136>:
.globl vector136
vector136:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $136
80106add:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ae2:	e9 27 f6 ff ff       	jmp    8010610e <alltraps>

80106ae7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $137
80106ae9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106aee:	e9 1b f6 ff ff       	jmp    8010610e <alltraps>

80106af3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $138
80106af5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106afa:	e9 0f f6 ff ff       	jmp    8010610e <alltraps>

80106aff <vector139>:
.globl vector139
vector139:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $139
80106b01:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b06:	e9 03 f6 ff ff       	jmp    8010610e <alltraps>

80106b0b <vector140>:
.globl vector140
vector140:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $140
80106b0d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b12:	e9 f7 f5 ff ff       	jmp    8010610e <alltraps>

80106b17 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $141
80106b19:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b1e:	e9 eb f5 ff ff       	jmp    8010610e <alltraps>

80106b23 <vector142>:
.globl vector142
vector142:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $142
80106b25:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b2a:	e9 df f5 ff ff       	jmp    8010610e <alltraps>

80106b2f <vector143>:
.globl vector143
vector143:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $143
80106b31:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b36:	e9 d3 f5 ff ff       	jmp    8010610e <alltraps>

80106b3b <vector144>:
.globl vector144
vector144:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $144
80106b3d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b42:	e9 c7 f5 ff ff       	jmp    8010610e <alltraps>

80106b47 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $145
80106b49:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b4e:	e9 bb f5 ff ff       	jmp    8010610e <alltraps>

80106b53 <vector146>:
.globl vector146
vector146:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $146
80106b55:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b5a:	e9 af f5 ff ff       	jmp    8010610e <alltraps>

80106b5f <vector147>:
.globl vector147
vector147:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $147
80106b61:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b66:	e9 a3 f5 ff ff       	jmp    8010610e <alltraps>

80106b6b <vector148>:
.globl vector148
vector148:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $148
80106b6d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b72:	e9 97 f5 ff ff       	jmp    8010610e <alltraps>

80106b77 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $149
80106b79:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b7e:	e9 8b f5 ff ff       	jmp    8010610e <alltraps>

80106b83 <vector150>:
.globl vector150
vector150:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $150
80106b85:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b8a:	e9 7f f5 ff ff       	jmp    8010610e <alltraps>

80106b8f <vector151>:
.globl vector151
vector151:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $151
80106b91:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b96:	e9 73 f5 ff ff       	jmp    8010610e <alltraps>

80106b9b <vector152>:
.globl vector152
vector152:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $152
80106b9d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106ba2:	e9 67 f5 ff ff       	jmp    8010610e <alltraps>

80106ba7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $153
80106ba9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106bae:	e9 5b f5 ff ff       	jmp    8010610e <alltraps>

80106bb3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $154
80106bb5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106bba:	e9 4f f5 ff ff       	jmp    8010610e <alltraps>

80106bbf <vector155>:
.globl vector155
vector155:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $155
80106bc1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106bc6:	e9 43 f5 ff ff       	jmp    8010610e <alltraps>

80106bcb <vector156>:
.globl vector156
vector156:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $156
80106bcd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bd2:	e9 37 f5 ff ff       	jmp    8010610e <alltraps>

80106bd7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $157
80106bd9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bde:	e9 2b f5 ff ff       	jmp    8010610e <alltraps>

80106be3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $158
80106be5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bea:	e9 1f f5 ff ff       	jmp    8010610e <alltraps>

80106bef <vector159>:
.globl vector159
vector159:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $159
80106bf1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bf6:	e9 13 f5 ff ff       	jmp    8010610e <alltraps>

80106bfb <vector160>:
.globl vector160
vector160:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $160
80106bfd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c02:	e9 07 f5 ff ff       	jmp    8010610e <alltraps>

80106c07 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $161
80106c09:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c0e:	e9 fb f4 ff ff       	jmp    8010610e <alltraps>

80106c13 <vector162>:
.globl vector162
vector162:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $162
80106c15:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c1a:	e9 ef f4 ff ff       	jmp    8010610e <alltraps>

80106c1f <vector163>:
.globl vector163
vector163:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $163
80106c21:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c26:	e9 e3 f4 ff ff       	jmp    8010610e <alltraps>

80106c2b <vector164>:
.globl vector164
vector164:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $164
80106c2d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c32:	e9 d7 f4 ff ff       	jmp    8010610e <alltraps>

80106c37 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $165
80106c39:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c3e:	e9 cb f4 ff ff       	jmp    8010610e <alltraps>

80106c43 <vector166>:
.globl vector166
vector166:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $166
80106c45:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c4a:	e9 bf f4 ff ff       	jmp    8010610e <alltraps>

80106c4f <vector167>:
.globl vector167
vector167:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $167
80106c51:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c56:	e9 b3 f4 ff ff       	jmp    8010610e <alltraps>

80106c5b <vector168>:
.globl vector168
vector168:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $168
80106c5d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c62:	e9 a7 f4 ff ff       	jmp    8010610e <alltraps>

80106c67 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $169
80106c69:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c6e:	e9 9b f4 ff ff       	jmp    8010610e <alltraps>

80106c73 <vector170>:
.globl vector170
vector170:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $170
80106c75:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c7a:	e9 8f f4 ff ff       	jmp    8010610e <alltraps>

80106c7f <vector171>:
.globl vector171
vector171:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $171
80106c81:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c86:	e9 83 f4 ff ff       	jmp    8010610e <alltraps>

80106c8b <vector172>:
.globl vector172
vector172:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $172
80106c8d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c92:	e9 77 f4 ff ff       	jmp    8010610e <alltraps>

80106c97 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $173
80106c99:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c9e:	e9 6b f4 ff ff       	jmp    8010610e <alltraps>

80106ca3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $174
80106ca5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106caa:	e9 5f f4 ff ff       	jmp    8010610e <alltraps>

80106caf <vector175>:
.globl vector175
vector175:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $175
80106cb1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106cb6:	e9 53 f4 ff ff       	jmp    8010610e <alltraps>

80106cbb <vector176>:
.globl vector176
vector176:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $176
80106cbd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cc2:	e9 47 f4 ff ff       	jmp    8010610e <alltraps>

80106cc7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $177
80106cc9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cce:	e9 3b f4 ff ff       	jmp    8010610e <alltraps>

80106cd3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $178
80106cd5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cda:	e9 2f f4 ff ff       	jmp    8010610e <alltraps>

80106cdf <vector179>:
.globl vector179
vector179:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $179
80106ce1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ce6:	e9 23 f4 ff ff       	jmp    8010610e <alltraps>

80106ceb <vector180>:
.globl vector180
vector180:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $180
80106ced:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cf2:	e9 17 f4 ff ff       	jmp    8010610e <alltraps>

80106cf7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $181
80106cf9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cfe:	e9 0b f4 ff ff       	jmp    8010610e <alltraps>

80106d03 <vector182>:
.globl vector182
vector182:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $182
80106d05:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d0a:	e9 ff f3 ff ff       	jmp    8010610e <alltraps>

80106d0f <vector183>:
.globl vector183
vector183:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $183
80106d11:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d16:	e9 f3 f3 ff ff       	jmp    8010610e <alltraps>

80106d1b <vector184>:
.globl vector184
vector184:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $184
80106d1d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d22:	e9 e7 f3 ff ff       	jmp    8010610e <alltraps>

80106d27 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $185
80106d29:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d2e:	e9 db f3 ff ff       	jmp    8010610e <alltraps>

80106d33 <vector186>:
.globl vector186
vector186:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $186
80106d35:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d3a:	e9 cf f3 ff ff       	jmp    8010610e <alltraps>

80106d3f <vector187>:
.globl vector187
vector187:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $187
80106d41:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d46:	e9 c3 f3 ff ff       	jmp    8010610e <alltraps>

80106d4b <vector188>:
.globl vector188
vector188:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $188
80106d4d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d52:	e9 b7 f3 ff ff       	jmp    8010610e <alltraps>

80106d57 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $189
80106d59:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d5e:	e9 ab f3 ff ff       	jmp    8010610e <alltraps>

80106d63 <vector190>:
.globl vector190
vector190:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $190
80106d65:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d6a:	e9 9f f3 ff ff       	jmp    8010610e <alltraps>

80106d6f <vector191>:
.globl vector191
vector191:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $191
80106d71:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d76:	e9 93 f3 ff ff       	jmp    8010610e <alltraps>

80106d7b <vector192>:
.globl vector192
vector192:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $192
80106d7d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d82:	e9 87 f3 ff ff       	jmp    8010610e <alltraps>

80106d87 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $193
80106d89:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d8e:	e9 7b f3 ff ff       	jmp    8010610e <alltraps>

80106d93 <vector194>:
.globl vector194
vector194:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $194
80106d95:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d9a:	e9 6f f3 ff ff       	jmp    8010610e <alltraps>

80106d9f <vector195>:
.globl vector195
vector195:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $195
80106da1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106da6:	e9 63 f3 ff ff       	jmp    8010610e <alltraps>

80106dab <vector196>:
.globl vector196
vector196:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $196
80106dad:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106db2:	e9 57 f3 ff ff       	jmp    8010610e <alltraps>

80106db7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $197
80106db9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106dbe:	e9 4b f3 ff ff       	jmp    8010610e <alltraps>

80106dc3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $198
80106dc5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106dca:	e9 3f f3 ff ff       	jmp    8010610e <alltraps>

80106dcf <vector199>:
.globl vector199
vector199:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $199
80106dd1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106dd6:	e9 33 f3 ff ff       	jmp    8010610e <alltraps>

80106ddb <vector200>:
.globl vector200
vector200:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $200
80106ddd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106de2:	e9 27 f3 ff ff       	jmp    8010610e <alltraps>

80106de7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $201
80106de9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dee:	e9 1b f3 ff ff       	jmp    8010610e <alltraps>

80106df3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $202
80106df5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106dfa:	e9 0f f3 ff ff       	jmp    8010610e <alltraps>

80106dff <vector203>:
.globl vector203
vector203:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $203
80106e01:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e06:	e9 03 f3 ff ff       	jmp    8010610e <alltraps>

80106e0b <vector204>:
.globl vector204
vector204:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $204
80106e0d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e12:	e9 f7 f2 ff ff       	jmp    8010610e <alltraps>

80106e17 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $205
80106e19:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e1e:	e9 eb f2 ff ff       	jmp    8010610e <alltraps>

80106e23 <vector206>:
.globl vector206
vector206:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $206
80106e25:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e2a:	e9 df f2 ff ff       	jmp    8010610e <alltraps>

80106e2f <vector207>:
.globl vector207
vector207:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $207
80106e31:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e36:	e9 d3 f2 ff ff       	jmp    8010610e <alltraps>

80106e3b <vector208>:
.globl vector208
vector208:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $208
80106e3d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e42:	e9 c7 f2 ff ff       	jmp    8010610e <alltraps>

80106e47 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $209
80106e49:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e4e:	e9 bb f2 ff ff       	jmp    8010610e <alltraps>

80106e53 <vector210>:
.globl vector210
vector210:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $210
80106e55:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e5a:	e9 af f2 ff ff       	jmp    8010610e <alltraps>

80106e5f <vector211>:
.globl vector211
vector211:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $211
80106e61:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e66:	e9 a3 f2 ff ff       	jmp    8010610e <alltraps>

80106e6b <vector212>:
.globl vector212
vector212:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $212
80106e6d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e72:	e9 97 f2 ff ff       	jmp    8010610e <alltraps>

80106e77 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $213
80106e79:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e7e:	e9 8b f2 ff ff       	jmp    8010610e <alltraps>

80106e83 <vector214>:
.globl vector214
vector214:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $214
80106e85:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e8a:	e9 7f f2 ff ff       	jmp    8010610e <alltraps>

80106e8f <vector215>:
.globl vector215
vector215:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $215
80106e91:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e96:	e9 73 f2 ff ff       	jmp    8010610e <alltraps>

80106e9b <vector216>:
.globl vector216
vector216:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $216
80106e9d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ea2:	e9 67 f2 ff ff       	jmp    8010610e <alltraps>

80106ea7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $217
80106ea9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106eae:	e9 5b f2 ff ff       	jmp    8010610e <alltraps>

80106eb3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $218
80106eb5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106eba:	e9 4f f2 ff ff       	jmp    8010610e <alltraps>

80106ebf <vector219>:
.globl vector219
vector219:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $219
80106ec1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ec6:	e9 43 f2 ff ff       	jmp    8010610e <alltraps>

80106ecb <vector220>:
.globl vector220
vector220:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $220
80106ecd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ed2:	e9 37 f2 ff ff       	jmp    8010610e <alltraps>

80106ed7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $221
80106ed9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106ede:	e9 2b f2 ff ff       	jmp    8010610e <alltraps>

80106ee3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $222
80106ee5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106eea:	e9 1f f2 ff ff       	jmp    8010610e <alltraps>

80106eef <vector223>:
.globl vector223
vector223:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $223
80106ef1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ef6:	e9 13 f2 ff ff       	jmp    8010610e <alltraps>

80106efb <vector224>:
.globl vector224
vector224:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $224
80106efd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f02:	e9 07 f2 ff ff       	jmp    8010610e <alltraps>

80106f07 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $225
80106f09:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f0e:	e9 fb f1 ff ff       	jmp    8010610e <alltraps>

80106f13 <vector226>:
.globl vector226
vector226:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $226
80106f15:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f1a:	e9 ef f1 ff ff       	jmp    8010610e <alltraps>

80106f1f <vector227>:
.globl vector227
vector227:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $227
80106f21:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f26:	e9 e3 f1 ff ff       	jmp    8010610e <alltraps>

80106f2b <vector228>:
.globl vector228
vector228:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $228
80106f2d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f32:	e9 d7 f1 ff ff       	jmp    8010610e <alltraps>

80106f37 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $229
80106f39:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f3e:	e9 cb f1 ff ff       	jmp    8010610e <alltraps>

80106f43 <vector230>:
.globl vector230
vector230:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $230
80106f45:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f4a:	e9 bf f1 ff ff       	jmp    8010610e <alltraps>

80106f4f <vector231>:
.globl vector231
vector231:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $231
80106f51:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f56:	e9 b3 f1 ff ff       	jmp    8010610e <alltraps>

80106f5b <vector232>:
.globl vector232
vector232:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $232
80106f5d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f62:	e9 a7 f1 ff ff       	jmp    8010610e <alltraps>

80106f67 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $233
80106f69:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f6e:	e9 9b f1 ff ff       	jmp    8010610e <alltraps>

80106f73 <vector234>:
.globl vector234
vector234:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $234
80106f75:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f7a:	e9 8f f1 ff ff       	jmp    8010610e <alltraps>

80106f7f <vector235>:
.globl vector235
vector235:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $235
80106f81:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f86:	e9 83 f1 ff ff       	jmp    8010610e <alltraps>

80106f8b <vector236>:
.globl vector236
vector236:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $236
80106f8d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f92:	e9 77 f1 ff ff       	jmp    8010610e <alltraps>

80106f97 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $237
80106f99:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f9e:	e9 6b f1 ff ff       	jmp    8010610e <alltraps>

80106fa3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $238
80106fa5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106faa:	e9 5f f1 ff ff       	jmp    8010610e <alltraps>

80106faf <vector239>:
.globl vector239
vector239:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $239
80106fb1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106fb6:	e9 53 f1 ff ff       	jmp    8010610e <alltraps>

80106fbb <vector240>:
.globl vector240
vector240:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $240
80106fbd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fc2:	e9 47 f1 ff ff       	jmp    8010610e <alltraps>

80106fc7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $241
80106fc9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106fce:	e9 3b f1 ff ff       	jmp    8010610e <alltraps>

80106fd3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $242
80106fd5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106fda:	e9 2f f1 ff ff       	jmp    8010610e <alltraps>

80106fdf <vector243>:
.globl vector243
vector243:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $243
80106fe1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fe6:	e9 23 f1 ff ff       	jmp    8010610e <alltraps>

80106feb <vector244>:
.globl vector244
vector244:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $244
80106fed:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106ff2:	e9 17 f1 ff ff       	jmp    8010610e <alltraps>

80106ff7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $245
80106ff9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106ffe:	e9 0b f1 ff ff       	jmp    8010610e <alltraps>

80107003 <vector246>:
.globl vector246
vector246:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $246
80107005:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010700a:	e9 ff f0 ff ff       	jmp    8010610e <alltraps>

8010700f <vector247>:
.globl vector247
vector247:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $247
80107011:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107016:	e9 f3 f0 ff ff       	jmp    8010610e <alltraps>

8010701b <vector248>:
.globl vector248
vector248:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $248
8010701d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107022:	e9 e7 f0 ff ff       	jmp    8010610e <alltraps>

80107027 <vector249>:
.globl vector249
vector249:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $249
80107029:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010702e:	e9 db f0 ff ff       	jmp    8010610e <alltraps>

80107033 <vector250>:
.globl vector250
vector250:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $250
80107035:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010703a:	e9 cf f0 ff ff       	jmp    8010610e <alltraps>

8010703f <vector251>:
.globl vector251
vector251:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $251
80107041:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107046:	e9 c3 f0 ff ff       	jmp    8010610e <alltraps>

8010704b <vector252>:
.globl vector252
vector252:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $252
8010704d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107052:	e9 b7 f0 ff ff       	jmp    8010610e <alltraps>

80107057 <vector253>:
.globl vector253
vector253:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $253
80107059:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010705e:	e9 ab f0 ff ff       	jmp    8010610e <alltraps>

80107063 <vector254>:
.globl vector254
vector254:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $254
80107065:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010706a:	e9 9f f0 ff ff       	jmp    8010610e <alltraps>

8010706f <vector255>:
.globl vector255
vector255:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $255
80107071:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107076:	e9 93 f0 ff ff       	jmp    8010610e <alltraps>
8010707b:	66 90                	xchg   %ax,%ax
8010707d:	66 90                	xchg   %ax,%ax
8010707f:	90                   	nop

80107080 <seginit>:
pde_t *kpgdir;      // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void seginit(void)
{
80107080:	f3 0f 1e fb          	endbr32 
80107084:	55                   	push   %ebp
80107085:	89 e5                	mov    %esp,%ebp
80107087:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
8010708a:	e8 41 d0 ff ff       	call   801040d0 <cpuid>
  pd[0] = size-1;
8010708f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107094:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010709a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010709e:	c7 80 58 98 11 80 ff 	movl   $0xffff,-0x7fee67a8(%eax)
801070a5:	ff 00 00 
801070a8:	c7 80 5c 98 11 80 00 	movl   $0xcf9a00,-0x7fee67a4(%eax)
801070af:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070b2:	c7 80 60 98 11 80 ff 	movl   $0xffff,-0x7fee67a0(%eax)
801070b9:	ff 00 00 
801070bc:	c7 80 64 98 11 80 00 	movl   $0xcf9200,-0x7fee679c(%eax)
801070c3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
801070c6:	c7 80 68 98 11 80 ff 	movl   $0xffff,-0x7fee6798(%eax)
801070cd:	ff 00 00 
801070d0:	c7 80 6c 98 11 80 00 	movl   $0xcffa00,-0x7fee6794(%eax)
801070d7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801070da:	c7 80 70 98 11 80 ff 	movl   $0xffff,-0x7fee6790(%eax)
801070e1:	ff 00 00 
801070e4:	c7 80 74 98 11 80 00 	movl   $0xcff200,-0x7fee678c(%eax)
801070eb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801070ee:	05 50 98 11 80       	add    $0x80119850,%eax
  pd[1] = (uint)p;
801070f3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801070f7:	c1 e8 10             	shr    $0x10,%eax
801070fa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801070fe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107101:	0f 01 10             	lgdtl  (%eax)
}
80107104:	c9                   	leave  
80107105:	c3                   	ret    
80107106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010710d:	8d 76 00             	lea    0x0(%esi),%esi

80107110 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107110:	f3 0f 1e fb          	endbr32 
80107114:	55                   	push   %ebp
80107115:	89 e5                	mov    %esp,%ebp
80107117:	57                   	push   %edi
80107118:	56                   	push   %esi
80107119:	53                   	push   %ebx
8010711a:	83 ec 0c             	sub    $0xc,%esp
8010711d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107120:	8b 55 08             	mov    0x8(%ebp),%edx
80107123:	89 fe                	mov    %edi,%esi
80107125:	c1 ee 16             	shr    $0x16,%esi
80107128:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if (*pde & PTE_P)
8010712b:	8b 1e                	mov    (%esi),%ebx
8010712d:	f6 c3 01             	test   $0x1,%bl
80107130:	74 26                	je     80107158 <walkpgdir+0x48>
  {
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
80107132:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107138:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010713e:	89 f8                	mov    %edi,%eax
}
80107140:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107143:	c1 e8 0a             	shr    $0xa,%eax
80107146:	25 fc 0f 00 00       	and    $0xffc,%eax
8010714b:	01 d8                	add    %ebx,%eax
}
8010714d:	5b                   	pop    %ebx
8010714e:	5e                   	pop    %esi
8010714f:	5f                   	pop    %edi
80107150:	5d                   	pop    %ebp
80107151:	c3                   	ret    
80107152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (!alloc || (pgtab = (pte_t *)kalloc()) == 0)
80107158:	8b 45 10             	mov    0x10(%ebp),%eax
8010715b:	85 c0                	test   %eax,%eax
8010715d:	74 31                	je     80107190 <walkpgdir+0x80>
8010715f:	e8 cc ba ff ff       	call   80102c30 <kalloc>
80107164:	89 c3                	mov    %eax,%ebx
80107166:	85 c0                	test   %eax,%eax
80107168:	74 26                	je     80107190 <walkpgdir+0x80>
    memset(pgtab, 0, PGSIZE);
8010716a:	83 ec 04             	sub    $0x4,%esp
8010716d:	68 00 10 00 00       	push   $0x1000
80107172:	6a 00                	push   $0x0
80107174:	50                   	push   %eax
80107175:	e8 76 dc ff ff       	call   80104df0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010717a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107180:	83 c4 10             	add    $0x10,%esp
80107183:	83 c8 07             	or     $0x7,%eax
80107186:	89 06                	mov    %eax,(%esi)
80107188:	eb b4                	jmp    8010713e <walkpgdir+0x2e>
8010718a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80107190:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107193:	31 c0                	xor    %eax,%eax
}
80107195:	5b                   	pop    %ebx
80107196:	5e                   	pop    %esi
80107197:	5f                   	pop    %edi
80107198:	5d                   	pop    %ebp
80107199:	c3                   	ret    
8010719a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071a0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char *)PGROUNDDOWN((uint)va);
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
801071a6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801071aa:	56                   	push   %esi
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
801071ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char *)PGROUNDDOWN((uint)va);
801071b0:	89 d6                	mov    %edx,%esi
{
801071b2:	53                   	push   %ebx
  a = (char *)PGROUNDDOWN((uint)va);
801071b3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801071b9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
801071bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071bf:	8b 45 08             	mov    0x8(%ebp),%eax
801071c2:	29 f0                	sub    %esi,%eax
801071c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071c7:	eb 1f                	jmp    801071e8 <mappages+0x48>
801071c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (;;)
  {
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if (*pte & PTE_P)
801071d0:	f6 00 01             	testb  $0x1,(%eax)
801071d3:	75 45                	jne    8010721a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801071d5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801071d8:	83 cb 01             	or     $0x1,%ebx
801071db:	89 18                	mov    %ebx,(%eax)
    if (a == last)
801071dd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801071e0:	74 2e                	je     80107210 <mappages+0x70>
      break;
    a += PGSIZE;
801071e2:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
801071e8:	83 ec 04             	sub    $0x4,%esp
801071eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071ee:	6a 01                	push   $0x1
801071f0:	56                   	push   %esi
801071f1:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801071f4:	57                   	push   %edi
801071f5:	e8 16 ff ff ff       	call   80107110 <walkpgdir>
801071fa:	83 c4 10             	add    $0x10,%esp
801071fd:	85 c0                	test   %eax,%eax
801071ff:	75 cf                	jne    801071d0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107201:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107204:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107209:	5b                   	pop    %ebx
8010720a:	5e                   	pop    %esi
8010720b:	5f                   	pop    %edi
8010720c:	5d                   	pop    %ebp
8010720d:	c3                   	ret    
8010720e:	66 90                	xchg   %ax,%ax
80107210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107213:	31 c0                	xor    %eax,%eax
}
80107215:	5b                   	pop    %ebx
80107216:	5e                   	pop    %esi
80107217:	5f                   	pop    %edi
80107218:	5d                   	pop    %ebp
80107219:	c3                   	ret    
      panic("remap");
8010721a:	83 ec 0c             	sub    $0xc,%esp
8010721d:	68 1c 86 10 80       	push   $0x8010861c
80107222:	e8 69 91 ff ff       	call   80100390 <panic>
80107227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010722e:	66 90                	xchg   %ax,%ax

80107230 <deallocuvm.part.0>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	89 c6                	mov    %eax,%esi
80107237:	53                   	push   %ebx
80107238:	89 d3                	mov    %edx,%ebx
8010723a:	83 ec 1c             	sub    $0x1c,%esp
8010723d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  int bitmap_offset;

  if (newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107240:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107246:	89 d7                	mov    %edx,%edi
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107248:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  a = PGROUNDUP(newsz);
8010724b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for (; a < oldsz; a += PGSIZE)
80107251:	39 df                	cmp    %ebx,%edi
80107253:	72 49                	jb     8010729e <deallocuvm.part.0+0x6e>
80107255:	e9 8a 00 00 00       	jmp    801072e4 <deallocuvm.part.0+0xb4>
8010725a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (!pte) // pte not exist
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if ((*pte & PTE_P) != 0) // swapped in pages(PTE_P is set)
    {
      pa = PTE_ADDR(*pte);
      if (pa == 0)
80107260:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107266:	0f 84 94 00 00 00    	je     80107300 <deallocuvm.part.0+0xd0>
        panic("kfree");
      char *v = P2V(pa);
      // remove from LRU list
      page_delete(pgdir, (char *)a);
8010726c:	83 ec 08             	sub    $0x8,%esp
      char *v = P2V(pa);
8010726f:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107275:	89 45 e0             	mov    %eax,-0x20(%ebp)
      page_delete(pgdir, (char *)a);
80107278:	57                   	push   %edi
80107279:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010727f:	56                   	push   %esi
80107280:	e8 5b b7 ff ff       	call   801029e0 <page_delete>
      kfree(v);
80107285:	89 1c 24             	mov    %ebx,(%esp)
80107288:	e8 f3 b2 ff ff       	call   80102580 <kfree>
      *pte = 0;
8010728d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107290:	83 c4 10             	add    $0x10,%esp
80107293:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for (; a < oldsz; a += PGSIZE)
80107299:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010729c:	76 46                	jbe    801072e4 <deallocuvm.part.0+0xb4>
    pte = walkpgdir(pgdir, (char *)a, 0);
8010729e:	83 ec 04             	sub    $0x4,%esp
801072a1:	6a 00                	push   $0x0
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	e8 66 fe ff ff       	call   80107110 <walkpgdir>
    if (!pte) // pte not exist
801072aa:	83 c4 10             	add    $0x10,%esp
801072ad:	85 c0                	test   %eax,%eax
801072af:	74 3f                	je     801072f0 <deallocuvm.part.0+0xc0>
    else if ((*pte & PTE_P) != 0) // swapped in pages(PTE_P is set)
801072b1:	8b 18                	mov    (%eax),%ebx
801072b3:	f6 c3 01             	test   $0x1,%bl
801072b6:	75 a8                	jne    80107260 <deallocuvm.part.0+0x30>
    }
    else if (*pte != 0) // swapped out pages(pte is not zero, PTE_P is clear)
801072b8:	81 c7 00 10 00 00    	add    $0x1000,%edi
801072be:	85 db                	test   %ebx,%ebx
801072c0:	74 d7                	je     80107299 <deallocuvm.part.0+0x69>
    {
      // clear in bitmap
      pa = PTE_ADDR(*pte);
      bitmap_offset = (int)(pa >> 12);
      bitmap_modify(bitmap_offset, 0);
801072c2:	83 ec 08             	sub    $0x8,%esp
      bitmap_offset = (int)(pa >> 12);
801072c5:	c1 eb 0c             	shr    $0xc,%ebx
801072c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
      bitmap_modify(bitmap_offset, 0);
801072cb:	6a 00                	push   $0x0
801072cd:	53                   	push   %ebx
801072ce:	e8 ed b9 ff ff       	call   80102cc0 <bitmap_modify>

      // clear page table entry
      *pte = 0;
801072d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
801072d6:	83 c4 10             	add    $0x10,%esp
801072d9:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for (; a < oldsz; a += PGSIZE)
801072df:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801072e2:	77 ba                	ja     8010729e <deallocuvm.part.0+0x6e>
    }
  }
  return newsz;
}
801072e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801072e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ea:	5b                   	pop    %ebx
801072eb:	5e                   	pop    %esi
801072ec:	5f                   	pop    %edi
801072ed:	5d                   	pop    %ebp
801072ee:	c3                   	ret    
801072ef:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801072f0:	89 f9                	mov    %edi,%ecx
801072f2:	81 e1 00 00 c0 ff    	and    $0xffc00000,%ecx
801072f8:	8d b9 00 00 40 00    	lea    0x400000(%ecx),%edi
801072fe:	eb 99                	jmp    80107299 <deallocuvm.part.0+0x69>
        panic("kfree");
80107300:	83 ec 0c             	sub    $0xc,%esp
80107303:	68 07 7d 10 80       	push   $0x80107d07
80107308:	e8 83 90 ff ff       	call   80100390 <panic>
8010730d:	8d 76 00             	lea    0x0(%esi),%esi

80107310 <switchkvm>:
{
80107310:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80107314:	a1 04 c5 11 80       	mov    0x8011c504,%eax
80107319:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010731e:	0f 22 d8             	mov    %eax,%cr3
}
80107321:	c3                   	ret    
80107322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107330 <switchuvm>:
{
80107330:	f3 0f 1e fb          	endbr32 
80107334:	55                   	push   %ebp
80107335:	89 e5                	mov    %esp,%ebp
80107337:	57                   	push   %edi
80107338:	56                   	push   %esi
80107339:	53                   	push   %ebx
8010733a:	83 ec 1c             	sub    $0x1c,%esp
8010733d:	8b 75 08             	mov    0x8(%ebp),%esi
  if (p == 0)
80107340:	85 f6                	test   %esi,%esi
80107342:	0f 84 cb 00 00 00    	je     80107413 <switchuvm+0xe3>
  if (p->kstack == 0)
80107348:	8b 46 08             	mov    0x8(%esi),%eax
8010734b:	85 c0                	test   %eax,%eax
8010734d:	0f 84 da 00 00 00    	je     8010742d <switchuvm+0xfd>
  if (p->pgdir == 0)
80107353:	8b 46 04             	mov    0x4(%esi),%eax
80107356:	85 c0                	test   %eax,%eax
80107358:	0f 84 c2 00 00 00    	je     80107420 <switchuvm+0xf0>
  pushcli();
8010735e:	e8 7d d8 ff ff       	call   80104be0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107363:	e8 f8 cc ff ff       	call   80104060 <mycpu>
80107368:	89 c3                	mov    %eax,%ebx
8010736a:	e8 f1 cc ff ff       	call   80104060 <mycpu>
8010736f:	89 c7                	mov    %eax,%edi
80107371:	e8 ea cc ff ff       	call   80104060 <mycpu>
80107376:	83 c7 08             	add    $0x8,%edi
80107379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010737c:	e8 df cc ff ff       	call   80104060 <mycpu>
80107381:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107384:	ba 67 00 00 00       	mov    $0x67,%edx
80107389:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107390:	83 c0 08             	add    $0x8,%eax
80107393:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort)0xFFFF;
8010739a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010739f:	83 c1 08             	add    $0x8,%ecx
801073a2:	c1 e8 18             	shr    $0x18,%eax
801073a5:	c1 e9 10             	shr    $0x10,%ecx
801073a8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801073ae:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801073b4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801073b9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073c0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801073c5:	e8 96 cc ff ff       	call   80104060 <mycpu>
801073ca:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073d1:	e8 8a cc ff ff       	call   80104060 <mycpu>
801073d6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073da:	8b 5e 08             	mov    0x8(%esi),%ebx
801073dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073e3:	e8 78 cc ff ff       	call   80104060 <mycpu>
801073e8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort)0xFFFF;
801073eb:	e8 70 cc ff ff       	call   80104060 <mycpu>
801073f0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073f4:	b8 28 00 00 00       	mov    $0x28,%eax
801073f9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir)); // switch to process's address space
801073fc:	8b 46 04             	mov    0x4(%esi),%eax
801073ff:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107404:	0f 22 d8             	mov    %eax,%cr3
}
80107407:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010740a:	5b                   	pop    %ebx
8010740b:	5e                   	pop    %esi
8010740c:	5f                   	pop    %edi
8010740d:	5d                   	pop    %ebp
  popcli();
8010740e:	e9 1d d8 ff ff       	jmp    80104c30 <popcli>
    panic("switchuvm: no process");
80107413:	83 ec 0c             	sub    $0xc,%esp
80107416:	68 22 86 10 80       	push   $0x80108622
8010741b:	e8 70 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107420:	83 ec 0c             	sub    $0xc,%esp
80107423:	68 4d 86 10 80       	push   $0x8010864d
80107428:	e8 63 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010742d:	83 ec 0c             	sub    $0xc,%esp
80107430:	68 38 86 10 80       	push   $0x80108638
80107435:	e8 56 8f ff ff       	call   80100390 <panic>
8010743a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107440 <inituvm>:
{
80107440:	f3 0f 1e fb          	endbr32 
80107444:	55                   	push   %ebp
80107445:	89 e5                	mov    %esp,%ebp
80107447:	57                   	push   %edi
80107448:	56                   	push   %esi
80107449:	53                   	push   %ebx
8010744a:	83 ec 1c             	sub    $0x1c,%esp
8010744d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107450:	8b 75 10             	mov    0x10(%ebp),%esi
80107453:	8b 7d 08             	mov    0x8(%ebp),%edi
80107456:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (sz >= PGSIZE)
80107459:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010745f:	77 55                	ja     801074b6 <inituvm+0x76>
  mem = kalloc();
80107461:	e8 ca b7 ff ff       	call   80102c30 <kalloc>
  memset(mem, 0, PGSIZE);
80107466:	83 ec 04             	sub    $0x4,%esp
80107469:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010746e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107470:	6a 00                	push   $0x0
80107472:	50                   	push   %eax
80107473:	e8 78 d9 ff ff       	call   80104df0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107478:	58                   	pop    %eax
80107479:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010747f:	5a                   	pop    %edx
80107480:	6a 06                	push   $0x6
80107482:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107487:	31 d2                	xor    %edx,%edx
80107489:	50                   	push   %eax
8010748a:	89 f8                	mov    %edi,%eax
8010748c:	e8 0f fd ff ff       	call   801071a0 <mappages>
  page_insert(pgdir, 0);
80107491:	59                   	pop    %ecx
80107492:	58                   	pop    %eax
80107493:	6a 00                	push   $0x0
80107495:	57                   	push   %edi
80107496:	e8 f5 b3 ff ff       	call   80102890 <page_insert>
  memmove(mem, init, sz);
8010749b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010749e:	89 75 10             	mov    %esi,0x10(%ebp)
801074a1:	83 c4 10             	add    $0x10,%esp
801074a4:	89 5d 08             	mov    %ebx,0x8(%ebp)
801074a7:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801074aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ad:	5b                   	pop    %ebx
801074ae:	5e                   	pop    %esi
801074af:	5f                   	pop    %edi
801074b0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801074b1:	e9 da d9 ff ff       	jmp    80104e90 <memmove>
    panic("inituvm: more than a page");
801074b6:	83 ec 0c             	sub    $0xc,%esp
801074b9:	68 61 86 10 80       	push   $0x80108661
801074be:	e8 cd 8e ff ff       	call   80100390 <panic>
801074c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074d0 <loaduvm>:
{
801074d0:	f3 0f 1e fb          	endbr32 
801074d4:	55                   	push   %ebp
801074d5:	89 e5                	mov    %esp,%ebp
801074d7:	57                   	push   %edi
801074d8:	56                   	push   %esi
801074d9:	53                   	push   %ebx
801074da:	83 ec 1c             	sub    $0x1c,%esp
801074dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801074e0:	8b 75 18             	mov    0x18(%ebp),%esi
  if ((uint)addr % PGSIZE != 0)
801074e3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801074e8:	0f 85 99 00 00 00    	jne    80107587 <loaduvm+0xb7>
  for (i = 0; i < sz; i += PGSIZE)
801074ee:	01 f0                	add    %esi,%eax
801074f0:	89 f3                	mov    %esi,%ebx
801074f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (readi(ip, P2V(pa), offset + i, n) != n)
801074f5:	8b 45 14             	mov    0x14(%ebp),%eax
801074f8:	01 f0                	add    %esi,%eax
801074fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for (i = 0; i < sz; i += PGSIZE)
801074fd:	85 f6                	test   %esi,%esi
801074ff:	75 15                	jne    80107516 <loaduvm+0x46>
80107501:	eb 6d                	jmp    80107570 <loaduvm+0xa0>
80107503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107507:	90                   	nop
80107508:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010750e:	89 f0                	mov    %esi,%eax
80107510:	29 d8                	sub    %ebx,%eax
80107512:	39 c6                	cmp    %eax,%esi
80107514:	76 5a                	jbe    80107570 <loaduvm+0xa0>
    if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
80107516:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107519:	83 ec 04             	sub    $0x4,%esp
8010751c:	6a 00                	push   $0x0
8010751e:	29 d8                	sub    %ebx,%eax
80107520:	50                   	push   %eax
80107521:	ff 75 08             	pushl  0x8(%ebp)
80107524:	e8 e7 fb ff ff       	call   80107110 <walkpgdir>
80107529:	83 c4 10             	add    $0x10,%esp
8010752c:	85 c0                	test   %eax,%eax
8010752e:	74 4a                	je     8010757a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107530:	8b 00                	mov    (%eax),%eax
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107532:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if (sz - i < PGSIZE)
80107535:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
8010753a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if (sz - i < PGSIZE)
8010753f:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107545:	0f 46 fb             	cmovbe %ebx,%edi
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107548:	29 d9                	sub    %ebx,%ecx
8010754a:	05 00 00 00 80       	add    $0x80000000,%eax
8010754f:	57                   	push   %edi
80107550:	51                   	push   %ecx
80107551:	50                   	push   %eax
80107552:	ff 75 10             	pushl  0x10(%ebp)
80107555:	e8 06 a5 ff ff       	call   80101a60 <readi>
8010755a:	83 c4 10             	add    $0x10,%esp
8010755d:	39 f8                	cmp    %edi,%eax
8010755f:	74 a7                	je     80107508 <loaduvm+0x38>
}
80107561:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107564:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107569:	5b                   	pop    %ebx
8010756a:	5e                   	pop    %esi
8010756b:	5f                   	pop    %edi
8010756c:	5d                   	pop    %ebp
8010756d:	c3                   	ret    
8010756e:	66 90                	xchg   %ax,%ax
80107570:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107573:	31 c0                	xor    %eax,%eax
}
80107575:	5b                   	pop    %ebx
80107576:	5e                   	pop    %esi
80107577:	5f                   	pop    %edi
80107578:	5d                   	pop    %ebp
80107579:	c3                   	ret    
      panic("loaduvm: address should exist");
8010757a:	83 ec 0c             	sub    $0xc,%esp
8010757d:	68 7b 86 10 80       	push   $0x8010867b
80107582:	e8 09 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107587:	83 ec 0c             	sub    $0xc,%esp
8010758a:	68 04 87 10 80       	push   $0x80108704
8010758f:	e8 fc 8d ff ff       	call   80100390 <panic>
80107594:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010759b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010759f:	90                   	nop

801075a0 <allocuvm>:
{
801075a0:	f3 0f 1e fb          	endbr32 
801075a4:	55                   	push   %ebp
801075a5:	89 e5                	mov    %esp,%ebp
801075a7:	57                   	push   %edi
801075a8:	56                   	push   %esi
801075a9:	53                   	push   %ebx
801075aa:	83 ec 1c             	sub    $0x1c,%esp
  if (newsz >= KERNBASE)
801075ad:	8b 45 10             	mov    0x10(%ebp),%eax
{
801075b0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if (newsz >= KERNBASE)
801075b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075b6:	85 c0                	test   %eax,%eax
801075b8:	0f 88 c2 00 00 00    	js     80107680 <allocuvm+0xe0>
  if (newsz < oldsz)
801075be:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801075c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (newsz < oldsz)
801075c4:	0f 82 a6 00 00 00    	jb     80107670 <allocuvm+0xd0>
  a = PGROUNDUP(oldsz);
801075ca:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075d0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a < newsz; a += PGSIZE)
801075d6:	39 75 10             	cmp    %esi,0x10(%ebp)
801075d9:	77 51                	ja     8010762c <allocuvm+0x8c>
801075db:	e9 93 00 00 00       	jmp    80107673 <allocuvm+0xd3>
    memset(mem, 0, PGSIZE);
801075e0:	83 ec 04             	sub    $0x4,%esp
801075e3:	68 00 10 00 00       	push   $0x1000
801075e8:	6a 00                	push   $0x0
801075ea:	50                   	push   %eax
801075eb:	e8 00 d8 ff ff       	call   80104df0 <memset>
    if (mappages(pgdir, (char *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
801075f0:	58                   	pop    %eax
801075f1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075f7:	5a                   	pop    %edx
801075f8:	6a 06                	push   $0x6
801075fa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075ff:	89 f2                	mov    %esi,%edx
80107601:	50                   	push   %eax
80107602:	89 f8                	mov    %edi,%eax
80107604:	e8 97 fb ff ff       	call   801071a0 <mappages>
80107609:	83 c4 10             	add    $0x10,%esp
8010760c:	85 c0                	test   %eax,%eax
8010760e:	0f 88 84 00 00 00    	js     80107698 <allocuvm+0xf8>
    page_insert(pgdir, a);
80107614:	83 ec 08             	sub    $0x8,%esp
80107617:	56                   	push   %esi
  for (; a < newsz; a += PGSIZE)
80107618:	81 c6 00 10 00 00    	add    $0x1000,%esi
    page_insert(pgdir, a);
8010761e:	57                   	push   %edi
8010761f:	e8 6c b2 ff ff       	call   80102890 <page_insert>
  for (; a < newsz; a += PGSIZE)
80107624:	83 c4 10             	add    $0x10,%esp
80107627:	39 75 10             	cmp    %esi,0x10(%ebp)
8010762a:	76 47                	jbe    80107673 <allocuvm+0xd3>
    mem = kalloc();
8010762c:	e8 ff b5 ff ff       	call   80102c30 <kalloc>
80107631:	89 c3                	mov    %eax,%ebx
    if (mem == 0)
80107633:	85 c0                	test   %eax,%eax
80107635:	75 a9                	jne    801075e0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107637:	83 ec 0c             	sub    $0xc,%esp
8010763a:	68 99 86 10 80       	push   $0x80108699
8010763f:	e8 6c 90 ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz)
80107644:	8b 45 0c             	mov    0xc(%ebp),%eax
80107647:	83 c4 10             	add    $0x10,%esp
8010764a:	39 45 10             	cmp    %eax,0x10(%ebp)
8010764d:	74 31                	je     80107680 <allocuvm+0xe0>
8010764f:	8b 55 10             	mov    0x10(%ebp),%edx
80107652:	89 c1                	mov    %eax,%ecx
80107654:	89 f8                	mov    %edi,%eax
80107656:	e8 d5 fb ff ff       	call   80107230 <deallocuvm.part.0>
      return 0;
8010765b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107665:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107668:	5b                   	pop    %ebx
80107669:	5e                   	pop    %esi
8010766a:	5f                   	pop    %edi
8010766b:	5d                   	pop    %ebp
8010766c:	c3                   	ret    
8010766d:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80107670:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107676:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107679:	5b                   	pop    %ebx
8010767a:	5e                   	pop    %esi
8010767b:	5f                   	pop    %edi
8010767c:	5d                   	pop    %ebp
8010767d:	c3                   	ret    
8010767e:	66 90                	xchg   %ax,%ax
    return 0;
80107680:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010768a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010768d:	5b                   	pop    %ebx
8010768e:	5e                   	pop    %esi
8010768f:	5f                   	pop    %edi
80107690:	5d                   	pop    %ebp
80107691:	c3                   	ret    
80107692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107698:	83 ec 0c             	sub    $0xc,%esp
8010769b:	68 b1 86 10 80       	push   $0x801086b1
801076a0:	e8 0b 90 ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz)
801076a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801076a8:	83 c4 10             	add    $0x10,%esp
801076ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801076ae:	74 0c                	je     801076bc <allocuvm+0x11c>
801076b0:	8b 55 10             	mov    0x10(%ebp),%edx
801076b3:	89 c1                	mov    %eax,%ecx
801076b5:	89 f8                	mov    %edi,%eax
801076b7:	e8 74 fb ff ff       	call   80107230 <deallocuvm.part.0>
      kfree(mem);
801076bc:	83 ec 0c             	sub    $0xc,%esp
801076bf:	53                   	push   %ebx
801076c0:	e8 bb ae ff ff       	call   80102580 <kfree>
      return 0;
801076c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801076cc:	83 c4 10             	add    $0x10,%esp
}
801076cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d5:	5b                   	pop    %ebx
801076d6:	5e                   	pop    %esi
801076d7:	5f                   	pop    %edi
801076d8:	5d                   	pop    %ebp
801076d9:	c3                   	ret    
801076da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076e0 <deallocuvm>:
{
801076e0:	f3 0f 1e fb          	endbr32 
801076e4:	55                   	push   %ebp
801076e5:	89 e5                	mov    %esp,%ebp
801076e7:	8b 55 0c             	mov    0xc(%ebp),%edx
801076ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
801076ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if (newsz >= oldsz)
801076f0:	39 d1                	cmp    %edx,%ecx
801076f2:	73 0c                	jae    80107700 <deallocuvm+0x20>
}
801076f4:	5d                   	pop    %ebp
801076f5:	e9 36 fb ff ff       	jmp    80107230 <deallocuvm.part.0>
801076fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107700:	89 d0                	mov    %edx,%eax
80107702:	5d                   	pop    %ebp
80107703:	c3                   	ret    
80107704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop

80107710 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t *pgdir)
{
80107710:	f3 0f 1e fb          	endbr32 
80107714:	55                   	push   %ebp
80107715:	89 e5                	mov    %esp,%ebp
80107717:	57                   	push   %edi
80107718:	56                   	push   %esi
80107719:	53                   	push   %ebx
8010771a:	83 ec 0c             	sub    $0xc,%esp
8010771d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if (pgdir == 0)
80107720:	85 f6                	test   %esi,%esi
80107722:	74 55                	je     80107779 <freevm+0x69>
  if (newsz >= oldsz)
80107724:	31 c9                	xor    %ecx,%ecx
80107726:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010772b:	89 f0                	mov    %esi,%eax
8010772d:	89 f3                	mov    %esi,%ebx
8010772f:	e8 fc fa ff ff       	call   80107230 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for (i = 0; i < NPDENTRIES; i++)
80107734:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010773a:	eb 0b                	jmp    80107747 <freevm+0x37>
8010773c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107740:	83 c3 04             	add    $0x4,%ebx
80107743:	39 df                	cmp    %ebx,%edi
80107745:	74 23                	je     8010776a <freevm+0x5a>
  {
    if (pgdir[i] & PTE_P)
80107747:	8b 03                	mov    (%ebx),%eax
80107749:	a8 01                	test   $0x1,%al
8010774b:	74 f3                	je     80107740 <freevm+0x30>
    {
      char *v = P2V(PTE_ADDR(pgdir[i]));
8010774d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107752:	83 ec 0c             	sub    $0xc,%esp
80107755:	83 c3 04             	add    $0x4,%ebx
      char *v = P2V(PTE_ADDR(pgdir[i]));
80107758:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010775d:	50                   	push   %eax
8010775e:	e8 1d ae ff ff       	call   80102580 <kfree>
80107763:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < NPDENTRIES; i++)
80107766:	39 df                	cmp    %ebx,%edi
80107768:	75 dd                	jne    80107747 <freevm+0x37>
    }
  }
  kfree((char *)pgdir);
8010776a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010776d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107770:	5b                   	pop    %ebx
80107771:	5e                   	pop    %esi
80107772:	5f                   	pop    %edi
80107773:	5d                   	pop    %ebp
  kfree((char *)pgdir);
80107774:	e9 07 ae ff ff       	jmp    80102580 <kfree>
    panic("freevm: no pgdir");
80107779:	83 ec 0c             	sub    $0xc,%esp
8010777c:	68 cd 86 10 80       	push   $0x801086cd
80107781:	e8 0a 8c ff ff       	call   80100390 <panic>
80107786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010778d:	8d 76 00             	lea    0x0(%esi),%esi

80107790 <setupkvm>:
{
80107790:	f3 0f 1e fb          	endbr32 
80107794:	55                   	push   %ebp
80107795:	89 e5                	mov    %esp,%ebp
80107797:	56                   	push   %esi
80107798:	53                   	push   %ebx
  if ((pgdir = (pde_t *)kalloc()) == 0)
80107799:	e8 92 b4 ff ff       	call   80102c30 <kalloc>
8010779e:	89 c6                	mov    %eax,%esi
801077a0:	85 c0                	test   %eax,%eax
801077a2:	74 42                	je     801077e6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801077a4:	83 ec 04             	sub    $0x4,%esp
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077a7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801077ac:	68 00 10 00 00       	push   $0x1000
801077b1:	6a 00                	push   $0x0
801077b3:	50                   	push   %eax
801077b4:	e8 37 d6 ff ff       	call   80104df0 <memset>
801077b9:	83 c4 10             	add    $0x10,%esp
                 (uint)k->phys_start, k->perm) < 0)
801077bc:	8b 43 04             	mov    0x4(%ebx),%eax
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077bf:	83 ec 08             	sub    $0x8,%esp
801077c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801077c5:	ff 73 0c             	pushl  0xc(%ebx)
801077c8:	8b 13                	mov    (%ebx),%edx
801077ca:	50                   	push   %eax
801077cb:	29 c1                	sub    %eax,%ecx
801077cd:	89 f0                	mov    %esi,%eax
801077cf:	e8 cc f9 ff ff       	call   801071a0 <mappages>
801077d4:	83 c4 10             	add    $0x10,%esp
801077d7:	85 c0                	test   %eax,%eax
801077d9:	78 15                	js     801077f0 <setupkvm+0x60>
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077db:	83 c3 10             	add    $0x10,%ebx
801077de:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801077e4:	75 d6                	jne    801077bc <setupkvm+0x2c>
}
801077e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077e9:	89 f0                	mov    %esi,%eax
801077eb:	5b                   	pop    %ebx
801077ec:	5e                   	pop    %esi
801077ed:	5d                   	pop    %ebp
801077ee:	c3                   	ret    
801077ef:	90                   	nop
      freevm(pgdir);
801077f0:	83 ec 0c             	sub    $0xc,%esp
801077f3:	56                   	push   %esi
      return 0;
801077f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801077f6:	e8 15 ff ff ff       	call   80107710 <freevm>
      return 0;
801077fb:	83 c4 10             	add    $0x10,%esp
}
801077fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107801:	89 f0                	mov    %esi,%eax
80107803:	5b                   	pop    %ebx
80107804:	5e                   	pop    %esi
80107805:	5d                   	pop    %ebp
80107806:	c3                   	ret    
80107807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010780e:	66 90                	xchg   %ax,%ax

80107810 <kvmalloc>:
{
80107810:	f3 0f 1e fb          	endbr32 
80107814:	55                   	push   %ebp
80107815:	89 e5                	mov    %esp,%ebp
80107817:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010781a:	e8 71 ff ff ff       	call   80107790 <setupkvm>
8010781f:	a3 04 c5 11 80       	mov    %eax,0x8011c504
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80107824:	05 00 00 00 80       	add    $0x80000000,%eax
80107829:	0f 22 d8             	mov    %eax,%cr3
}
8010782c:	c9                   	leave  
8010782d:	c3                   	ret    
8010782e:	66 90                	xchg   %ax,%ax

80107830 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva)
{
80107830:	f3 0f 1e fb          	endbr32 
80107834:	55                   	push   %ebp
80107835:	89 e5                	mov    %esp,%ebp
80107837:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010783a:	6a 00                	push   $0x0
8010783c:	ff 75 0c             	pushl  0xc(%ebp)
8010783f:	ff 75 08             	pushl  0x8(%ebp)
80107842:	e8 c9 f8 ff ff       	call   80107110 <walkpgdir>
  if (pte == 0)
80107847:	83 c4 10             	add    $0x10,%esp
8010784a:	85 c0                	test   %eax,%eax
8010784c:	74 05                	je     80107853 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010784e:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107851:	c9                   	leave  
80107852:	c3                   	ret    
    panic("clearpteu");
80107853:	83 ec 0c             	sub    $0xc,%esp
80107856:	68 de 86 10 80       	push   $0x801086de
8010785b:	e8 30 8b ff ff       	call   80100390 <panic>

80107860 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *copyuvm(pde_t *pgdir, uint sz)
{
80107860:	f3 0f 1e fb          	endbr32 
80107864:	55                   	push   %ebp
80107865:	89 e5                	mov    %esp,%ebp
80107867:	57                   	push   %edi
80107868:	56                   	push   %esi
80107869:	53                   	push   %ebx
8010786a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if ((d = setupkvm()) == 0)
8010786d:	e8 1e ff ff ff       	call   80107790 <setupkvm>
80107872:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107875:	85 c0                	test   %eax,%eax
80107877:	0f 84 a0 00 00 00    	je     8010791d <copyuvm+0xbd>
    return 0;
  for (i = 0; i < sz; i += PGSIZE)
8010787d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107880:	31 f6                	xor    %esi,%esi
80107882:	85 c9                	test   %ecx,%ecx
80107884:	75 50                	jne    801078d6 <copyuvm+0x76>
80107886:	e9 a5 00 00 00       	jmp    80107930 <copyuvm+0xd0>
8010788b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010788f:	90                   	nop
    //   panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char *)P2V(pa), PGSIZE);
80107890:	83 ec 04             	sub    $0x4,%esp
80107893:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107899:	68 00 10 00 00       	push   $0x1000
8010789e:	57                   	push   %edi
8010789f:	50                   	push   %eax
801078a0:	e8 eb d5 ff ff       	call   80104e90 <memmove>
    if (mappages(d, (void *)i, PGSIZE, V2P(mem), flags) < 0)
801078a5:	58                   	pop    %eax
801078a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078ac:	5a                   	pop    %edx
801078ad:	ff 75 e4             	pushl  -0x1c(%ebp)
801078b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078b5:	89 f2                	mov    %esi,%edx
801078b7:	50                   	push   %eax
801078b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078bb:	e8 e0 f8 ff ff       	call   801071a0 <mappages>
801078c0:	83 c4 10             	add    $0x10,%esp
801078c3:	85 c0                	test   %eax,%eax
801078c5:	0f 88 85 00 00 00    	js     80107950 <copyuvm+0xf0>
  for (i = 0; i < sz; i += PGSIZE)
801078cb:	81 c6 00 10 00 00    	add    $0x1000,%esi
801078d1:	39 75 0c             	cmp    %esi,0xc(%ebp)
801078d4:	76 5a                	jbe    80107930 <copyuvm+0xd0>
    if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
801078d6:	83 ec 04             	sub    $0x4,%esp
801078d9:	6a 00                	push   $0x0
801078db:	56                   	push   %esi
801078dc:	ff 75 08             	pushl  0x8(%ebp)
801078df:	e8 2c f8 ff ff       	call   80107110 <walkpgdir>
801078e4:	83 c4 10             	add    $0x10,%esp
801078e7:	85 c0                	test   %eax,%eax
801078e9:	74 73                	je     8010795e <copyuvm+0xfe>
    pa = PTE_ADDR(*pte);
801078eb:	8b 00                	mov    (%eax),%eax
801078ed:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801078ef:	25 ff 0f 00 00       	and    $0xfff,%eax
801078f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801078f7:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if ((mem = kalloc()) == 0)
801078fd:	e8 2e b3 ff ff       	call   80102c30 <kalloc>
80107902:	89 c3                	mov    %eax,%ebx
80107904:	85 c0                	test   %eax,%eax
80107906:	75 88                	jne    80107890 <copyuvm+0x30>
  // page insert in LRU linked list
  page_insert(pgdir, i);
  return d;

bad:
  freevm(d);
80107908:	83 ec 0c             	sub    $0xc,%esp
8010790b:	ff 75 e0             	pushl  -0x20(%ebp)
8010790e:	e8 fd fd ff ff       	call   80107710 <freevm>
  return 0;
80107913:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010791a:	83 c4 10             	add    $0x10,%esp
}
8010791d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107920:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107923:	5b                   	pop    %ebx
80107924:	5e                   	pop    %esi
80107925:	5f                   	pop    %edi
80107926:	5d                   	pop    %ebp
80107927:	c3                   	ret    
80107928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010792f:	90                   	nop
  page_insert(pgdir, i);
80107930:	83 ec 08             	sub    $0x8,%esp
80107933:	56                   	push   %esi
80107934:	ff 75 08             	pushl  0x8(%ebp)
80107937:	e8 54 af ff ff       	call   80102890 <page_insert>
}
8010793c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;
8010793f:	83 c4 10             	add    $0x10,%esp
}
80107942:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107945:	5b                   	pop    %ebx
80107946:	5e                   	pop    %esi
80107947:	5f                   	pop    %edi
80107948:	5d                   	pop    %ebp
80107949:	c3                   	ret    
8010794a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      kfree(mem);
80107950:	83 ec 0c             	sub    $0xc,%esp
80107953:	53                   	push   %ebx
80107954:	e8 27 ac ff ff       	call   80102580 <kfree>
      goto bad;
80107959:	83 c4 10             	add    $0x10,%esp
8010795c:	eb aa                	jmp    80107908 <copyuvm+0xa8>
      panic("copyuvm: pte should exist");
8010795e:	83 ec 0c             	sub    $0xc,%esp
80107961:	68 e8 86 10 80       	push   $0x801086e8
80107966:	e8 25 8a ff ff       	call   80100390 <panic>
8010796b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010796f:	90                   	nop

80107970 <uva2ka>:

// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva)
{
80107970:	f3 0f 1e fb          	endbr32 
80107974:	55                   	push   %ebp
80107975:	89 e5                	mov    %esp,%ebp
80107977:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010797a:	6a 00                	push   $0x0
8010797c:	ff 75 0c             	pushl  0xc(%ebp)
8010797f:	ff 75 08             	pushl  0x8(%ebp)
80107982:	e8 89 f7 ff ff       	call   80107110 <walkpgdir>
  if ((*pte & PTE_P) == 0)
    return 0;
  if ((*pte & PTE_U) == 0)
80107987:	83 c4 10             	add    $0x10,%esp
  if ((*pte & PTE_P) == 0)
8010798a:	8b 00                	mov    (%eax),%eax
    return 0;
  return (char *)P2V(PTE_ADDR(*pte));
}
8010798c:	c9                   	leave  
  if ((*pte & PTE_U) == 0)
8010798d:	89 c2                	mov    %eax,%edx
  return (char *)P2V(PTE_ADDR(*pte));
8010798f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if ((*pte & PTE_U) == 0)
80107994:	83 e2 05             	and    $0x5,%edx
  return (char *)P2V(PTE_ADDR(*pte));
80107997:	05 00 00 00 80       	add    $0x80000000,%eax
8010799c:	83 fa 05             	cmp    $0x5,%edx
8010799f:	ba 00 00 00 00       	mov    $0x0,%edx
801079a4:	0f 45 c2             	cmovne %edx,%eax
}
801079a7:	c3                   	ret    
801079a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079af:	90                   	nop

801079b0 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801079b0:	f3 0f 1e fb          	endbr32 
801079b4:	55                   	push   %ebp
801079b5:	89 e5                	mov    %esp,%ebp
801079b7:	57                   	push   %edi
801079b8:	56                   	push   %esi
801079b9:	53                   	push   %ebx
801079ba:	83 ec 0c             	sub    $0xc,%esp
801079bd:	8b 75 14             	mov    0x14(%ebp),%esi
801079c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char *)p;
  while (len > 0)
801079c3:	85 f6                	test   %esi,%esi
801079c5:	75 3c                	jne    80107a03 <copyout+0x53>
801079c7:	eb 67                	jmp    80107a30 <copyout+0x80>
801079c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char *)va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801079d0:	8b 55 0c             	mov    0xc(%ebp),%edx
801079d3:	89 fb                	mov    %edi,%ebx
801079d5:	29 d3                	sub    %edx,%ebx
801079d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if (n > len)
801079dd:	39 f3                	cmp    %esi,%ebx
801079df:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801079e2:	29 fa                	sub    %edi,%edx
801079e4:	83 ec 04             	sub    $0x4,%esp
801079e7:	01 c2                	add    %eax,%edx
801079e9:	53                   	push   %ebx
801079ea:	ff 75 10             	pushl  0x10(%ebp)
801079ed:	52                   	push   %edx
801079ee:	e8 9d d4 ff ff       	call   80104e90 <memmove>
    len -= n;
    buf += n;
801079f3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801079f6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while (len > 0)
801079fc:	83 c4 10             	add    $0x10,%esp
801079ff:	29 de                	sub    %ebx,%esi
80107a01:	74 2d                	je     80107a30 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107a03:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
80107a05:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107a08:	89 55 0c             	mov    %edx,0xc(%ebp)
80107a0b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
80107a11:	57                   	push   %edi
80107a12:	ff 75 08             	pushl  0x8(%ebp)
80107a15:	e8 56 ff ff ff       	call   80107970 <uva2ka>
    if (pa0 == 0)
80107a1a:	83 c4 10             	add    $0x10,%esp
80107a1d:	85 c0                	test   %eax,%eax
80107a1f:	75 af                	jne    801079d0 <copyout+0x20>
  }
  return 0;
}
80107a21:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a29:	5b                   	pop    %ebx
80107a2a:	5e                   	pop    %esi
80107a2b:	5f                   	pop    %edi
80107a2c:	5d                   	pop    %ebp
80107a2d:	c3                   	ret    
80107a2e:	66 90                	xchg   %ax,%ax
80107a30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a33:	31 c0                	xor    %eax,%eax
}
80107a35:	5b                   	pop    %ebx
80107a36:	5e                   	pop    %esi
80107a37:	5f                   	pop    %edi
80107a38:	5d                   	pop    %ebp
80107a39:	c3                   	ret    
