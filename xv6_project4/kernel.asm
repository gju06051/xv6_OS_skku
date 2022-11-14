
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
8010002d:	b8 e0 38 10 80       	mov    $0x801038e0,%eax
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
80100050:	68 60 7b 10 80       	push   $0x80107b60
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 11 4c 00 00       	call   80104c70 <initlock>
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
80100092:	68 67 7b 10 80       	push   $0x80107b67
80100097:	50                   	push   %eax
80100098:	e8 93 4a 00 00       	call   80104b30 <initsleeplock>
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
801000e8:	e8 03 4d 00 00       	call   80104df0 <acquire>
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
80100162:	e8 49 4d 00 00       	call   80104eb0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 49 00 00       	call   80104b70 <acquiresleep>
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
801001a3:	68 6e 7b 10 80       	push   $0x80107b6e
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
801001c2:	e8 49 4a 00 00       	call   80104c10 <holdingsleep>
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
801001e0:	68 7f 7b 10 80       	push   $0x80107b7f
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
80100203:	e8 08 4a 00 00       	call   80104c10 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 b8 49 00 00       	call   80104bd0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 cc 4b 00 00       	call   80104df0 <acquire>
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
80100270:	e9 3b 4c 00 00       	jmp    80104eb0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 86 7b 10 80       	push   $0x80107b86
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
801002b1:	e8 3a 4b 00 00       	call   80104df0 <acquire>
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
801002e5:	e8 c6 44 00 00       	call   801047b0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 01 3f 00 00       	call   80104200 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 9d 4b 00 00       	call   80104eb0 <release>
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
80100365:	e8 46 4b 00 00       	call   80104eb0 <release>
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
801003ad:	e8 8e 2d 00 00       	call   80103140 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 8d 7b 10 80       	push   $0x80107b8d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 01 8a 10 80 	movl   $0x80108a01,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 af 48 00 00       	call   80104c90 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 a1 7b 10 80       	push   $0x80107ba1
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
8010042a:	e8 a1 62 00 00       	call   801066d0 <uartputc>
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
80100515:	e8 b6 61 00 00       	call   801066d0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 aa 61 00 00       	call   801066d0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 9e 61 00 00       	call   801066d0 <uartputc>
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
80100561:	e8 3a 4a 00 00       	call   80104fa0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 85 49 00 00       	call   80104f00 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 a5 7b 10 80       	push   $0x80107ba5
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
801005c9:	0f b6 92 d0 7b 10 80 	movzbl -0x7fef8430(%edx),%edx
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
8010065f:	e8 8c 47 00 00       	call   80104df0 <acquire>
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
80100697:	e8 14 48 00 00       	call   80104eb0 <release>
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
8010077d:	bb b8 7b 10 80       	mov    $0x80107bb8,%ebx
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
801007bd:	e8 2e 46 00 00       	call   80104df0 <acquire>
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
80100828:	e8 83 46 00 00       	call   80104eb0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 bf 7b 10 80       	push   $0x80107bbf
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
80100877:	e8 74 45 00 00       	call   80104df0 <acquire>
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
801009cf:	e8 dc 44 00 00       	call   80104eb0 <release>
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
801009ff:	e9 5c 40 00 00       	jmp    80104a60 <procdump>
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
80100a20:	e8 4b 3f 00 00       	call   80104970 <wakeup>
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
80100a3a:	68 c8 7b 10 80       	push   $0x80107bc8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 27 42 00 00       	call   80104c70 <initlock>

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
80100a90:	e8 6b 37 00 00       	call   80104200 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 30 2b 00 00       	call   801035d0 <begin_op>

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
80100ae3:	e8 58 2b 00 00       	call   80103640 <end_op>
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
80100b0c:	e8 9f 6d 00 00       	call   801078b0 <setupkvm>
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
80100b73:	e8 48 6b 00 00       	call   801076c0 <allocuvm>
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
80100ba9:	e8 42 6a 00 00       	call   801075f0 <loaduvm>
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
80100beb:	e8 40 6c 00 00       	call   80107830 <freevm>
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
80100c21:	e8 1a 2a 00 00       	call   80103640 <end_op>
  if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 89 6a 00 00       	call   801076c0 <allocuvm>
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
80100c53:	e8 f8 6c 00 00       	call   80107950 <clearpteu>
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
80100ca3:	e8 58 44 00 00       	call   80105100 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 45 44 00 00       	call   80105100 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 f4 6d 00 00       	call   80107ac0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 4a 6b 00 00       	call   80107830 <freevm>
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
80100d33:	e8 88 6d 00 00       	call   80107ac0 <copyout>
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
80100d71:	e8 4a 43 00 00       	call   801050c0 <safestrcpy>
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
80100d9d:	e8 ae 66 00 00       	call   80107450 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 86 6a 00 00       	call   80107830 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 87 28 00 00       	call   80103640 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 e1 7b 10 80       	push   $0x80107be1
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
80100dea:	68 ed 7b 10 80       	push   $0x80107bed
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 77 3e 00 00       	call   80104c70 <initlock>
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
80100e15:	e8 d6 3f 00 00       	call   80104df0 <acquire>
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
80100e41:	e8 6a 40 00 00       	call   80104eb0 <release>
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
80100e5a:	e8 51 40 00 00       	call   80104eb0 <release>
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
80100e83:	e8 68 3f 00 00       	call   80104df0 <acquire>
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
80100ea0:	e8 0b 40 00 00       	call   80104eb0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 f4 7b 10 80       	push   $0x80107bf4
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
80100ed5:	e8 16 3f 00 00       	call   80104df0 <acquire>
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
80100f10:	e8 9b 3f 00 00       	call   80104eb0 <release>

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
80100f3e:	e9 6d 3f 00 00       	jmp    80104eb0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 83 26 00 00       	call   801035d0 <begin_op>
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
80100f62:	e9 d9 26 00 00       	jmp    80103640 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 22 2e 00 00       	call   80103da0 <pipeclose>
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
80100f8c:	68 fc 7b 10 80       	push   $0x80107bfc
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
80101065:	e9 d6 2e 00 00       	jmp    80103f40 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 06 7c 10 80       	push   $0x80107c06
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
801010f1:	e8 4a 25 00 00       	call   80103640 <end_op>

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
8010111a:	e8 b1 24 00 00       	call   801035d0 <begin_op>
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
80101151:	e8 ea 24 00 00       	call   80103640 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 0f 7c 10 80       	push   $0x80107c0f
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
80101191:	e9 aa 2c 00 00       	jmp    80103e40 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 15 7c 10 80       	push   $0x80107c15
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
80101254:	68 1f 7c 10 80       	push   $0x80107c1f
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
8010126d:	e8 3e 25 00 00       	call   801037b0 <log_write>
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
80101295:	e8 66 3c 00 00       	call   80104f00 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 0e 25 00 00       	call   801037b0 <log_write>
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
801012da:	e8 11 3b 00 00       	call   80104df0 <acquire>
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
80101347:	e8 64 3b 00 00       	call   80104eb0 <release>

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
80101375:	e8 36 3b 00 00       	call   80104eb0 <release>
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
801013a2:	68 35 7c 10 80       	push   $0x80107c35
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
80101425:	e8 86 23 00 00       	call   801037b0 <log_write>
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
8010146b:	68 45 7c 10 80       	push   $0x80107c45
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
801014a5:	e8 f6 3a 00 00       	call   80104fa0 <memmove>
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
8010151a:	e8 91 22 00 00       	call   801037b0 <log_write>
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
80101534:	68 58 7c 10 80       	push   $0x80107c58
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
80101550:	68 6b 7c 10 80       	push   $0x80107c6b
80101555:	68 00 1a 11 80       	push   $0x80111a00
8010155a:	e8 11 37 00 00       	call   80104c70 <initlock>
  for (i = 0; i < NINODE; i++)
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 72 7c 10 80       	push   $0x80107c72
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 b4 35 00 00       	call   80104b30 <initsleeplock>
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
801015c1:	68 10 7d 10 80       	push   $0x80107d10
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
8010165e:	e8 9d 38 00 00       	call   80104f00 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp); // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 3b 21 00 00       	call   801037b0 <log_write>
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
80101693:	68 78 7c 10 80       	push   $0x80107c78
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
80101705:	e8 96 38 00 00       	call   80104fa0 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 9e 20 00 00       	call   801037b0 <log_write>
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
80101743:	e8 a8 36 00 00       	call   80104df0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101753:	e8 58 37 00 00       	call   80104eb0 <release>
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
80101786:	e8 e5 33 00 00       	call   80104b70 <acquiresleep>
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
801017f8:	e8 a3 37 00 00       	call   80104fa0 <memmove>
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
8010181d:	68 90 7c 10 80       	push   $0x80107c90
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 8a 7c 10 80       	push   $0x80107c8a
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
80101857:	e8 b4 33 00 00       	call   80104c10 <holdingsleep>
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
80101873:	e9 58 33 00 00       	jmp    80104bd0 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 9f 7c 10 80       	push   $0x80107c9f
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
801018a4:	e8 c7 32 00 00       	call   80104b70 <acquiresleep>
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
801018be:	e8 0d 33 00 00       	call   80104bd0 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801018ca:	e8 21 35 00 00       	call   80104df0 <acquire>
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
801018e4:	e9 c7 35 00 00       	jmp    80104eb0 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 00 1a 11 80       	push   $0x80111a00
801018f8:	e8 f3 34 00 00       	call   80104df0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101907:	e8 a4 35 00 00       	call   80104eb0 <release>
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
80101b07:	e8 94 34 00 00       	call   80104fa0 <memmove>
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
80101c03:	e8 98 33 00 00       	call   80104fa0 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 a0 1b 00 00       	call   801037b0 <log_write>
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
80101ca2:	e8 69 33 00 00       	call   80105010 <strncmp>
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
80101d05:	e8 06 33 00 00       	call   80105010 <strncmp>
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
80101d4a:	68 b9 7c 10 80       	push   $0x80107cb9
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 a7 7c 10 80       	push   $0x80107ca7
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
80101d8a:	e8 71 24 00 00       	call   80104200 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 00 1a 11 80       	push   $0x80111a00
80101d9c:	e8 4f 30 00 00       	call   80104df0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101dac:	e8 ff 30 00 00       	call   80104eb0 <release>
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
80101e17:	e8 84 31 00 00       	call   80104fa0 <memmove>
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
80101ea3:	e8 f8 30 00 00       	call   80104fa0 <memmove>
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
80101fd5:	e8 86 30 00 00       	call   80105060 <strncpy>
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
80102013:	68 c8 7c 10 80       	push   $0x80107cc8
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 8a 87 10 80       	push   $0x8010878a
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
801020ca:	e8 d1 2e 00 00       	call   80104fa0 <memmove>
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
801020ea:	68 d5 7c 10 80       	push   $0x80107cd5
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
8010215a:	e8 41 2e 00 00       	call   80104fa0 <memmove>
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
80102182:	68 f2 7c 10 80       	push   $0x80107cf2
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
80102242:	68 6c 7d 10 80       	push   $0x80107d6c
80102247:	e8 44 e1 ff ff       	call   80100390 <panic>
    panic("idestart");
8010224c:	83 ec 0c             	sub    $0xc,%esp
8010224f:	68 63 7d 10 80       	push   $0x80107d63
80102254:	e8 37 e1 ff ff       	call   80100390 <panic>
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102260 <ideinit>:
{
80102260:	f3 0f 1e fb          	endbr32 
80102264:	55                   	push   %ebp
80102265:	89 e5                	mov    %esp,%ebp
80102267:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010226a:	68 7e 7d 10 80       	push   $0x80107d7e
8010226f:	68 80 b5 10 80       	push   $0x8010b580
80102274:	e8 f7 29 00 00       	call   80104c70 <initlock>
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
80102302:	e8 e9 2a 00 00       	call   80104df0 <acquire>

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
8010235d:	e8 0e 26 00 00       	call   80104970 <wakeup>

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
8010237b:	e8 30 2b 00 00       	call   80104eb0 <release>

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
801023a2:	e8 69 28 00 00       	call   80104c10 <holdingsleep>
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
801023dc:	e8 0f 2a 00 00       	call   80104df0 <acquire>

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
80102429:	e8 82 23 00 00       	call   801047b0 <sleep>
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
80102446:	e9 65 2a 00 00       	jmp    80104eb0 <release>
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
8010246a:	68 ad 7d 10 80       	push   $0x80107dad
8010246f:	e8 1c df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	68 98 7d 10 80       	push   $0x80107d98
8010247c:	e8 0f df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102481:	83 ec 0c             	sub    $0xc,%esp
80102484:	68 82 7d 10 80       	push   $0x80107d82
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
801024de:	68 cc 7d 10 80       	push   $0x80107dcc
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
801025c1:	e8 3a 29 00 00       	call   80104f00 <memset>

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
80102608:	e8 e3 27 00 00       	call   80104df0 <acquire>
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
80102625:	e9 86 28 00 00       	jmp    80104eb0 <release>
      cprintf("PGROUND Need\n");
8010262a:	83 ec 0c             	sub    $0xc,%esp
8010262d:	68 19 7e 10 80       	push   $0x80107e19
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
8010264d:	68 27 7e 10 80       	push   $0x80107e27
80102652:	e8 39 dd ff ff       	call   80100390 <panic>
      cprintf("physical addr is upper than PHYSTOP");
80102657:	83 ec 0c             	sub    $0xc,%esp
8010265a:	68 98 7e 10 80       	push   $0x80107e98
8010265f:	e8 4c e0 ff ff       	call   801006b0 <cprintf>
80102664:	83 c4 10             	add    $0x10,%esp
80102667:	eb e1                	jmp    8010264a <kfree+0xca>
      cprintf("virtual addr is under end\n");
80102669:	83 ec 0c             	sub    $0xc,%esp
8010266c:	68 fe 7d 10 80       	push   $0x80107dfe
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
801026df:	68 2d 7e 10 80       	push   $0x80107e2d
801026e4:	68 60 36 11 80       	push   $0x80113660
801026e9:	e8 82 25 00 00       	call   80104c70 <initlock>
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
  cprintf("kinit2 finished | num_free_page : %d, num_lru_page : %d\n", num_free_pages, num_lru_pages);
801027e4:	83 ec 04             	sub    $0x4,%esp
801027e7:	ff 35 a0 46 11 80    	pushl  0x801146a0
801027ed:	ff 35 a8 46 11 80    	pushl  0x801146a8
801027f3:	68 bc 7e 10 80       	push   $0x80107ebc
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
80102836:	7e 7b                	jle    801028b3 <lru_print+0x93>
80102838:	31 f6                	xor    %esi,%esi
8010283a:	eb 2f                	jmp    8010286b <lru_print+0x4b>
8010283c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    pte = walkpgdir(p_page->pgdir, p_page->vaddr, 0);
    if (p_page->vaddr == 0)
      cprintf("LRU entry %d, pgdir : %x, vaddr : 0000, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, *pte & PTE_A, *pte);
    else
      cprintf("LRU entry %d, pgdir : %x, vaddr : %x, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, *pte & PTE_A, *pte);
80102840:	83 ec 04             	sub    $0x4,%esp
80102843:	50                   	push   %eax
80102844:	83 e0 20             	and    $0x20,%eax
80102847:	50                   	push   %eax
80102848:	ff 73 10             	pushl  0x10(%ebx)
8010284b:	52                   	push   %edx
8010284c:	ff 73 08             	pushl  0x8(%ebx)
8010284f:	56                   	push   %esi
  for (int i = 0; i < num_lru_pages; i++)
80102850:	83 c6 01             	add    $0x1,%esi
      cprintf("LRU entry %d, pgdir : %x, vaddr : %x, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, *pte & PTE_A, *pte);
80102853:	68 40 7f 10 80       	push   $0x80107f40
80102858:	e8 53 de ff ff       	call   801006b0 <cprintf>
    p_page = p_page->prev;
8010285d:	8b 5b 04             	mov    0x4(%ebx),%ebx
      cprintf("LRU entry %d, pgdir : %x, vaddr : %x, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, *pte & PTE_A, *pte);
80102860:	83 c4 20             	add    $0x20,%esp
  for (int i = 0; i < num_lru_pages; i++)
80102863:	39 35 a0 46 11 80    	cmp    %esi,0x801146a0
80102869:	7e 48                	jle    801028b3 <lru_print+0x93>
    pte = walkpgdir(p_page->pgdir, p_page->vaddr, 0);
8010286b:	83 ec 04             	sub    $0x4,%esp
8010286e:	6a 00                	push   $0x0
80102870:	ff 73 0c             	pushl  0xc(%ebx)
80102873:	ff 73 08             	pushl  0x8(%ebx)
80102876:	e8 a5 49 00 00       	call   80107220 <walkpgdir>
    if (p_page->vaddr == 0)
8010287b:	8b 53 0c             	mov    0xc(%ebx),%edx
8010287e:	83 c4 10             	add    $0x10,%esp
      cprintf("LRU entry %d, pgdir : %x, vaddr : 0000, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, *pte & PTE_A, *pte);
80102881:	8b 00                	mov    (%eax),%eax
    if (p_page->vaddr == 0)
80102883:	85 d2                	test   %edx,%edx
80102885:	75 b9                	jne    80102840 <lru_print+0x20>
      cprintf("LRU entry %d, pgdir : %x, vaddr : 0000, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, *pte & PTE_A, *pte);
80102887:	83 ec 04             	sub    $0x4,%esp
8010288a:	50                   	push   %eax
8010288b:	83 e0 20             	and    $0x20,%eax
8010288e:	50                   	push   %eax
8010288f:	ff 73 10             	pushl  0x10(%ebx)
80102892:	6a 00                	push   $0x0
80102894:	ff 73 08             	pushl  0x8(%ebx)
80102897:	56                   	push   %esi
  for (int i = 0; i < num_lru_pages; i++)
80102898:	83 c6 01             	add    $0x1,%esi
      cprintf("LRU entry %d, pgdir : %x, vaddr : 0000, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, *pte & PTE_A, *pte);
8010289b:	68 f8 7e 10 80       	push   $0x80107ef8
801028a0:	e8 0b de ff ff       	call   801006b0 <cprintf>
    p_page = p_page->prev;
801028a5:	8b 5b 04             	mov    0x4(%ebx),%ebx
801028a8:	83 c4 20             	add    $0x20,%esp
  for (int i = 0; i < num_lru_pages; i++)
801028ab:	39 35 a0 46 11 80    	cmp    %esi,0x801146a0
801028b1:	7f b8                	jg     8010286b <lru_print+0x4b>
  }
}
801028b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028b6:	5b                   	pop    %ebx
801028b7:	5e                   	pop    %esi
801028b8:	5d                   	pop    %ebp
801028b9:	c3                   	ret    
801028ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028c0 <page_insert>:

void page_insert(pde_t *pgdir, uint vaddr)
{
801028c0:	f3 0f 1e fb          	endbr32 
801028c4:	55                   	push   %ebp
801028c5:	b8 d0 46 11 80       	mov    $0x801146d0,%eax
801028ca:	89 e5                	mov    %esp,%ebp
801028cc:	57                   	push   %edi
801028cd:	56                   	push   %esi
801028ce:	53                   	push   %ebx
  // cprintf("================Page insert start================\n");
  struct page *new_page, *next_page;
  // lru entry insert
  for (int i = 0; i < (PHYSTOP / PGSIZE); i++)
801028cf:	31 db                	xor    %ebx,%ebx
{
801028d1:	83 ec 1c             	sub    $0x1c,%esp
801028d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
801028d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801028da:	eb 16                	jmp    801028f2 <page_insert+0x32>
801028dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (int i = 0; i < (PHYSTOP / PGSIZE); i++)
801028e0:	83 c3 01             	add    $0x1,%ebx
801028e3:	83 c0 14             	add    $0x14,%eax
801028e6:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801028ec:	0f 84 4e 01 00 00    	je     80102a40 <page_insert+0x180>
  {
    // search not using page
    new_page = &pages[i];
    if (new_page->use == 0)
801028f2:	8b 30                	mov    (%eax),%esi
801028f4:	85 f6                	test   %esi,%esi
801028f6:	75 e8                	jne    801028e0 <page_insert+0x20>
    new_page = &pages[i];
801028f8:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
    {
      break;
    }
  }

  if (num_lru_pages == 0)
801028fb:	8b 35 a0 46 11 80    	mov    0x801146a0,%esi
    new_page = &pages[i];
80102901:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
80102908:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010290b:	8d 87 c0 46 11 80    	lea    -0x7feeb940(%edi),%eax
  if (num_lru_pages == 0)
80102911:	85 f6                	test   %esi,%esi
80102913:	75 4b                	jne    80102960 <page_insert+0xa0>
  {
    // case of first lru entry
    page_lru_head = new_page;
80102915:	a3 a4 46 11 80       	mov    %eax,0x801146a4
    page_lru_head->prev = new_page;
8010291a:	89 40 04             	mov    %eax,0x4(%eax)
    page_lru_head->next = new_page;
8010291d:	89 87 c0 46 11 80    	mov    %eax,-0x7feeb940(%edi)

    // page entry setting
    num_lru_pages++;
80102923:	c7 05 a0 46 11 80 01 	movl   $0x1,0x801146a0
8010292a:	00 00 00 
    new_page->pgdir = pgdir;
8010292d:	89 48 08             	mov    %ecx,0x8(%eax)
    new_page->vaddr = (char *)vaddr;
80102930:	89 50 0c             	mov    %edx,0xc(%eax)
    new_page->use = 1;
80102933:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    if (vaddr == 0)
8010293a:	85 d2                	test   %edx,%edx
8010293c:	0f 85 ae 00 00 00    	jne    801029f0 <page_insert+0x130>
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : 0000, ", num_lru_pages, new_page->pgdir);
80102942:	83 ec 04             	sub    $0x4,%esp
80102945:	51                   	push   %ecx
80102946:	6a 01                	push   $0x1
80102948:	68 88 7f 10 80       	push   $0x80107f88
8010294d:	e8 5e dd ff ff       	call   801006b0 <cprintf>
80102952:	83 c4 10             	add    $0x10,%esp
80102955:	eb 63                	jmp    801029ba <page_insert+0xfa>
80102957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295e:	66 90                	xchg   %ax,%ax
    else
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", num_lru_pages, new_page->pgdir, new_page->vaddr);
  }
  else if (num_lru_pages == 1)
80102960:	8b 3d a4 46 11 80    	mov    0x801146a4,%edi
80102966:	83 fe 01             	cmp    $0x1,%esi
80102969:	0f 84 b1 00 00 00    	je     80102a20 <page_insert+0x160>
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", num_lru_pages, new_page->pgdir, new_page->vaddr);
  }
  else
  {
    // case of above third lru entry
    next_page = page_lru_head->next;
8010296f:	8b 37                	mov    (%edi),%esi

    page_lru_head->next = new_page;
80102971:	89 07                	mov    %eax,(%edi)
    new_page->prev = page_lru_head;
80102973:	8b 3d a4 46 11 80    	mov    0x801146a4,%edi
80102979:	89 78 04             	mov    %edi,0x4(%eax)

    new_page->next = next_page;
8010297c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010297f:	89 b7 c0 46 11 80    	mov    %esi,-0x7feeb940(%edi)
    next_page->prev = new_page;
80102985:	89 46 04             	mov    %eax,0x4(%esi)

    num_lru_pages++;
80102988:	8b 3d a0 46 11 80    	mov    0x801146a0,%edi
    // page entry setting
    new_page->pgdir = pgdir;
8010298e:	89 48 08             	mov    %ecx,0x8(%eax)
    new_page->vaddr = (char *)vaddr;
80102991:	89 50 0c             	mov    %edx,0xc(%eax)
    num_lru_pages++;
80102994:	8d 77 01             	lea    0x1(%edi),%esi
    new_page->use = 1;
80102997:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    num_lru_pages++;
8010299e:	89 35 a0 46 11 80    	mov    %esi,0x801146a0
    if (vaddr == 0)
801029a4:	85 d2                	test   %edx,%edx
801029a6:	75 60                	jne    80102a08 <page_insert+0x148>
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : 0000, ", num_lru_pages, new_page->pgdir);
801029a8:	83 ec 04             	sub    $0x4,%esp
801029ab:	51                   	push   %ecx
801029ac:	56                   	push   %esi
801029ad:	68 88 7f 10 80       	push   $0x80107f88
801029b2:	e8 f9 dc ff ff       	call   801006b0 <cprintf>
801029b7:	83 c4 10             	add    $0x10,%esp
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", num_lru_pages, new_page->pgdir, new_page->vaddr);
  }
  // cprintf("====lru entry top====\n");
  // lru_print();
  // cprintf("====lru entry bottom====\n");
  cprintf("PTE : %x\n", walkpgdir(new_page->pgdir, new_page->vaddr, 0));
801029ba:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
801029bd:	83 ec 04             	sub    $0x4,%esp
801029c0:	8d 04 85 c0 46 11 80 	lea    -0x7feeb940(,%eax,4),%eax
801029c7:	6a 00                	push   $0x0
801029c9:	ff 70 0c             	pushl  0xc(%eax)
801029cc:	ff 70 08             	pushl  0x8(%eax)
801029cf:	e8 4c 48 00 00       	call   80107220 <walkpgdir>
801029d4:	c7 45 08 32 7e 10 80 	movl   $0x80107e32,0x8(%ebp)
801029db:	83 c4 10             	add    $0x10,%esp
801029de:	89 45 0c             	mov    %eax,0xc(%ebp)

  // cprintf("================Page insert finished================\n");
}
801029e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029e4:	5b                   	pop    %ebx
801029e5:	5e                   	pop    %esi
801029e6:	5f                   	pop    %edi
801029e7:	5d                   	pop    %ebp
  cprintf("PTE : %x\n", walkpgdir(new_page->pgdir, new_page->vaddr, 0));
801029e8:	e9 c3 dc ff ff       	jmp    801006b0 <cprintf>
801029ed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", num_lru_pages, new_page->pgdir, new_page->vaddr);
801029f0:	52                   	push   %edx
801029f1:	51                   	push   %ecx
801029f2:	6a 01                	push   $0x1
801029f4:	68 c8 7f 10 80       	push   $0x80107fc8
801029f9:	e8 b2 dc ff ff       	call   801006b0 <cprintf>
801029fe:	83 c4 10             	add    $0x10,%esp
80102a01:	eb b7                	jmp    801029ba <page_insert+0xfa>
80102a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a07:	90                   	nop
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", num_lru_pages, new_page->pgdir, new_page->vaddr);
80102a08:	52                   	push   %edx
80102a09:	51                   	push   %ecx
80102a0a:	56                   	push   %esi
80102a0b:	68 c8 7f 10 80       	push   $0x80107fc8
80102a10:	e8 9b dc ff ff       	call   801006b0 <cprintf>
80102a15:	83 c4 10             	add    $0x10,%esp
80102a18:	eb a0                	jmp    801029ba <page_insert+0xfa>
80102a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    page_lru_head->next = new_page;
80102a20:	89 07                	mov    %eax,(%edi)
    new_page->next = page_lru_head;
80102a22:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    page_lru_head->prev = new_page;
80102a25:	8b 35 a4 46 11 80    	mov    0x801146a4,%esi
80102a2b:	89 46 04             	mov    %eax,0x4(%esi)
    new_page->prev = page_lru_head;
80102a2e:	89 70 04             	mov    %esi,0x4(%eax)
    new_page->next = page_lru_head;
80102a31:	89 b7 c0 46 11 80    	mov    %esi,-0x7feeb940(%edi)
    num_lru_pages++;
80102a37:	e9 4c ff ff ff       	jmp    80102988 <page_insert+0xc8>
80102a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a40:	bb ff 03 00 00       	mov    $0x3ff,%ebx
80102a45:	e9 ae fe ff ff       	jmp    801028f8 <page_insert+0x38>
80102a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a50 <page_delete>:

int page_delete(pde_t *pgdir, char *vaddr)
{
80102a50:	f3 0f 1e fb          	endbr32 
80102a54:	55                   	push   %ebp
80102a55:	89 e5                	mov    %esp,%ebp
80102a57:	57                   	push   %edi
80102a58:	56                   	push   %esi
80102a59:	53                   	push   %ebx
80102a5a:	83 ec 1c             	sub    $0x1c,%esp
  struct page *p_page, *temp_head, *f_page, *b_page;
  // cprintf("================Page delete start================\n");

  temp_head = page_lru_head;
80102a5d:	a1 a4 46 11 80       	mov    0x801146a4,%eax
  // cprintf("page delete target | pgdir : %x | vaddr : %x\n", pgdir, vaddr);
  for (int i = 0; i < num_lru_pages; i++) // search lru with vaddr, pgdir
80102a62:	8b 0d a0 46 11 80    	mov    0x801146a0,%ecx
{
80102a68:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a6b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  temp_head = page_lru_head;
80102a6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for (int i = 0; i < num_lru_pages; i++) // search lru with vaddr, pgdir
80102a71:	85 c9                	test   %ecx,%ecx
80102a73:	0f 8e 84 00 00 00    	jle    80102afd <page_delete+0xad>
80102a79:	31 f6                	xor    %esi,%esi
80102a7b:	31 d2                	xor    %edx,%edx
80102a7d:	eb 10                	jmp    80102a8f <page_delete+0x3f>
80102a7f:	90                   	nop
80102a80:	83 c2 01             	add    $0x1,%edx
      // cprintf("================Page delete end================\n");
      return 0;
    }
    else
    {
      page_lru_head = page_lru_head->prev;
80102a83:	8b 40 04             	mov    0x4(%eax),%eax
  for (int i = 0; i < num_lru_pages; i++) // search lru with vaddr, pgdir
80102a86:	be 01 00 00 00       	mov    $0x1,%esi
80102a8b:	39 ca                	cmp    %ecx,%edx
80102a8d:	74 69                	je     80102af8 <page_delete+0xa8>
    if ((p_page->pgdir == pgdir) && (p_page->vaddr == vaddr))
80102a8f:	39 58 08             	cmp    %ebx,0x8(%eax)
80102a92:	75 ec                	jne    80102a80 <page_delete+0x30>
80102a94:	39 78 0c             	cmp    %edi,0xc(%eax)
80102a97:	75 e7                	jne    80102a80 <page_delete+0x30>
80102a99:	89 f3                	mov    %esi,%ebx
80102a9b:	84 db                	test   %bl,%bl
80102a9d:	74 05                	je     80102aa4 <page_delete+0x54>
80102a9f:	a3 a4 46 11 80       	mov    %eax,0x801146a4
      b_page = p_page->next;
80102aa4:	8b 10                	mov    (%eax),%edx
      f_page = p_page->prev;
80102aa6:	8b 48 04             	mov    0x4(%eax),%ecx
      page_lru_head = temp_head->prev;
80102aa9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
      f_page->next = b_page;
80102aac:	89 11                	mov    %edx,(%ecx)
      num_lru_pages--;
80102aae:	8b 35 a0 46 11 80    	mov    0x801146a0,%esi
      b_page->prev = f_page;
80102ab4:	89 4a 04             	mov    %ecx,0x4(%edx)
      p_page->use = 0;
80102ab7:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
      page_lru_head = temp_head->prev;
80102abe:	8b 4b 04             	mov    0x4(%ebx),%ecx
      num_lru_pages--;
80102ac1:	8d 56 ff             	lea    -0x1(%esi),%edx
80102ac4:	89 15 a0 46 11 80    	mov    %edx,0x801146a0
      page_lru_head = temp_head->prev;
80102aca:	89 0d a4 46 11 80    	mov    %ecx,0x801146a4
      if (vaddr == 0)
80102ad0:	85 ff                	test   %edi,%edi
80102ad2:	74 57                	je     80102b2b <page_delete+0xdb>
        cprintf("Page Delete | num_lru_pages : %d, pgdir : %x, vaddr : %x\n", num_lru_pages, p_page->pgdir, p_page->vaddr);
80102ad4:	ff 70 0c             	pushl  0xc(%eax)
80102ad7:	ff 70 08             	pushl  0x8(%eax)
80102ada:	52                   	push   %edx
80102adb:	68 40 80 10 80       	push   $0x80108040
80102ae0:	e8 cb db ff ff       	call   801006b0 <cprintf>
80102ae5:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("=================================LRU linked list TOP=================================\n");
  lru_print();
  cprintf("=================================LRU linked list BOT=================================\n");
  return -1;
}
80102ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80102aeb:	31 c0                	xor    %eax,%eax
}
80102aed:	5b                   	pop    %ebx
80102aee:	5e                   	pop    %esi
80102aef:	5f                   	pop    %edi
80102af0:	5d                   	pop    %ebp
80102af1:	c3                   	ret    
80102af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102af8:	a3 a4 46 11 80       	mov    %eax,0x801146a4
  cprintf("=================================LRU linked list TOP=================================\n");
80102afd:	83 ec 0c             	sub    $0xc,%esp
80102b00:	68 7c 80 10 80       	push   $0x8010807c
80102b05:	e8 a6 db ff ff       	call   801006b0 <cprintf>
  lru_print();
80102b0a:	e8 11 fd ff ff       	call   80102820 <lru_print>
  cprintf("=================================LRU linked list BOT=================================\n");
80102b0f:	c7 04 24 d4 80 10 80 	movl   $0x801080d4,(%esp)
80102b16:	e8 95 db ff ff       	call   801006b0 <cprintf>
  return -1;
80102b1b:	83 c4 10             	add    $0x10,%esp
80102b1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102b23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b26:	5b                   	pop    %ebx
80102b27:	5e                   	pop    %esi
80102b28:	5f                   	pop    %edi
80102b29:	5d                   	pop    %ebp
80102b2a:	c3                   	ret    
        cprintf("Page Delete | num_lru_pages : %d, pgdir : %x, vaddr : 0000\n", num_lru_pages, p_page->pgdir);
80102b2b:	83 ec 04             	sub    $0x4,%esp
80102b2e:	ff 70 08             	pushl  0x8(%eax)
80102b31:	52                   	push   %edx
80102b32:	68 04 80 10 80       	push   $0x80108004
80102b37:	e8 74 db ff ff       	call   801006b0 <cprintf>
80102b3c:	83 c4 10             	add    $0x10,%esp
      return 0;
80102b3f:	31 c0                	xor    %eax,%eax
80102b41:	eb e0                	jmp    80102b23 <page_delete+0xd3>
80102b43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b50 <swapout>:

char *swapout(void)
{
80102b50:	f3 0f 1e fb          	endbr32 
80102b54:	55                   	push   %ebp
80102b55:	89 e5                	mov    %esp,%ebp
80102b57:	57                   	push   %edi
80102b58:	56                   	push   %esi
80102b59:	53                   	push   %ebx
80102b5a:	83 ec 1c             	sub    $0x1c,%esp
  char *mem;
  int bitmap_offset_get = 0;
  // cprintf("================swap out start================\n");

  int bitmap_offset = 0;
  if (num_lru_pages == 0)
80102b5d:	8b 35 a0 46 11 80    	mov    0x801146a0,%esi
80102b63:	85 f6                	test   %esi,%esi
80102b65:	0f 84 b6 01 00 00    	je     80102d21 <swapout+0x1d1>
  {
    panic("OOM Error");
  }

  // get bitmap free
  for (int i = 0; i < PGSIZE; i++)
80102b6b:	31 db                	xor    %ebx,%ebx
80102b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if (bitmap_offset_get)
      break;
    for (int j = 0; j < 8; j++)
    {
      //  get low bit in bitmap
      if ((set_bit & bitmap[i]) == 0)
80102b70:	0f b6 8b a0 36 11 80 	movzbl -0x7feec960(%ebx),%ecx
    for (int j = 0; j < 8; j++)
80102b77:	31 c0                	xor    %eax,%eax
    set_bit = 1;
80102b79:	ba 01 00 00 00       	mov    $0x1,%edx
80102b7e:	66 90                	xchg   %ax,%ax
      if ((set_bit & bitmap[i]) == 0)
80102b80:	84 d1                	test   %dl,%cl
80102b82:	74 24                	je     80102ba8 <swapout+0x58>
    for (int j = 0; j < 8; j++)
80102b84:	83 c0 01             	add    $0x1,%eax
        break;
      }
      else
      {
        // shift to next bit for check
        set_bit = set_bit << 1;
80102b87:	01 d2                	add    %edx,%edx
    for (int j = 0; j < 8; j++)
80102b89:	83 f8 08             	cmp    $0x8,%eax
80102b8c:	75 f2                	jne    80102b80 <swapout+0x30>
  for (int i = 0; i < PGSIZE; i++)
80102b8e:	83 c3 01             	add    $0x1,%ebx
80102b91:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
80102b97:	75 d7                	jne    80102b70 <swapout+0x20>
80102b99:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102ba0:	eb 0c                	jmp    80102bae <swapout+0x5e>
80102ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bitmap_offset = 8 * i + j;
80102ba8:	8d 04 d8             	lea    (%eax,%ebx,8),%eax
80102bab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    p_page = p_page->prev;
  }
  cprintf("============page entry bottom\n");
  */
  // victim page process
  for (int i = 0; i < num_lru_pages + 10; i++)
80102bae:	83 fe f7             	cmp    $0xfffffff7,%esi
80102bb1:	0f 8c 4c 01 00 00    	jl     80102d03 <swapout+0x1b3>
80102bb7:	8b 3d a4 46 11 80    	mov    0x801146a4,%edi
80102bbd:	31 f6                	xor    %esi,%esi
80102bbf:	eb 2d                	jmp    80102bee <swapout+0x9e>
80102bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    else // ref bit high
    {
      // clear the flag
      // cprintf("clear flag occur\n");
      *pte = *pte & (~PTE_A);
80102bc8:	83 e3 df             	and    $0xffffffdf,%ebx
  for (int i = 0; i < num_lru_pages + 10; i++)
80102bcb:	83 c6 01             	add    $0x1,%esi
      *pte = *pte & (~PTE_A);
80102bce:	89 18                	mov    %ebx,(%eax)
      // go to previous page
      page_lru_head = page_lru_head->prev;
80102bd0:	a1 a4 46 11 80       	mov    0x801146a4,%eax
80102bd5:	8b 78 04             	mov    0x4(%eax),%edi
  for (int i = 0; i < num_lru_pages + 10; i++)
80102bd8:	a1 a0 46 11 80       	mov    0x801146a0,%eax
80102bdd:	83 c0 09             	add    $0x9,%eax
      page_lru_head = page_lru_head->prev;
80102be0:	89 3d a4 46 11 80    	mov    %edi,0x801146a4
  for (int i = 0; i < num_lru_pages + 10; i++)
80102be6:	39 c6                	cmp    %eax,%esi
80102be8:	0f 8f 15 01 00 00    	jg     80102d03 <swapout+0x1b3>
    pte = walkpgdir(p_page->pgdir, p_page->vaddr, 0);
80102bee:	83 ec 04             	sub    $0x4,%esp
80102bf1:	6a 00                	push   $0x0
80102bf3:	ff 77 0c             	pushl  0xc(%edi)
80102bf6:	ff 77 08             	pushl  0x8(%edi)
80102bf9:	e8 22 46 00 00       	call   80107220 <walkpgdir>
    if ((*pte != 0) && ((*pte & PTE_A) == 0)) // ref bit low
80102bfe:	83 c4 10             	add    $0x10,%esp
    mem = P2V((PTE_ADDR(*pte)));
80102c01:	8b 18                	mov    (%eax),%ebx
    if ((*pte != 0) && ((*pte & PTE_A) == 0)) // ref bit low
80102c03:	85 db                	test   %ebx,%ebx
80102c05:	74 c1                	je     80102bc8 <swapout+0x78>
80102c07:	f6 c3 20             	test   $0x20,%bl
80102c0a:	75 bc                	jne    80102bc8 <swapout+0x78>
      if (p_page->vaddr == 0)
80102c0c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80102c0f:	89 d9                	mov    %ebx,%ecx
80102c11:	8b 57 0c             	mov    0xc(%edi),%edx
80102c14:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c17:	81 e1 fe 0f 00 00    	and    $0xffe,%ecx
80102c1d:	c1 e6 0c             	shl    $0xc,%esi
80102c20:	09 f1                	or     %esi,%ecx
80102c22:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80102c25:	8b 4f 08             	mov    0x8(%edi),%ecx
80102c28:	85 d2                	test   %edx,%edx
80102c2a:	0f 84 b9 00 00 00    	je     80102ce9 <swapout+0x199>
        cprintf("Swapout victim page | pgdir : %x, vaddr : %x, PTE : %x, Modified PTE : %x\n", p_page->pgdir, p_page->vaddr, *pte, (((bitmap_offset << 12) | PTE_FLAGS(*pte)) & (~PTE_P)));
80102c30:	83 ec 0c             	sub    $0xc,%esp
80102c33:	ff 75 e0             	pushl  -0x20(%ebp)
80102c36:	53                   	push   %ebx
80102c37:	52                   	push   %edx
80102c38:	51                   	push   %ecx
80102c39:	68 cc 81 10 80       	push   $0x801081cc
80102c3e:	e8 6d da ff ff       	call   801006b0 <cprintf>
80102c43:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102c46:	83 c4 20             	add    $0x20,%esp
    mem = P2V((PTE_ADDR(*pte)));
80102c49:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
      swapwrite(mem, bitmap_offset);
80102c4f:	83 ec 08             	sub    $0x8,%esp
80102c52:	ff 75 e4             	pushl  -0x1c(%ebp)
    mem = P2V((PTE_ADDR(*pte)));
80102c55:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
      swapwrite(mem, bitmap_offset);
80102c5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c5e:	53                   	push   %ebx
80102c5f:	e8 9c f4 ff ff       	call   80102100 <swapwrite>
      *pte = (bitmap_offset << 12) | PTE_FLAGS(*pte);
80102c64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102c67:	8b 10                	mov    (%eax),%edx
80102c69:	81 e2 fe 0f 00 00    	and    $0xffe,%edx
      *pte = *pte & (~PTE_P);
80102c6f:	09 f2                	or     %esi,%edx
80102c71:	89 10                	mov    %edx,(%eax)
      lcr3(V2P(p_page->pgdir));
80102c73:	8b 47 08             	mov    0x8(%edi),%eax
80102c76:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80102c7b:	0f 22 d8             	mov    %eax,%cr3
      page_lru_head = page_lru_head->prev;
80102c7e:	a1 a4 46 11 80       	mov    0x801146a4,%eax
  {
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
  }
  else // set
  {
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] | (1 << bitmap_offset % 8);
80102c83:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      page_lru_head = page_lru_head->prev;
80102c86:	8b 48 04             	mov    0x4(%eax),%ecx
80102c89:	89 0d a4 46 11 80    	mov    %ecx,0x801146a4
      page_lru_head->next = p_page->next;
80102c8f:	8b 07                	mov    (%edi),%eax
80102c91:	89 01                	mov    %eax,(%ecx)
      p_page->next->prev = page_lru_head;
80102c93:	8b 0d a4 46 11 80    	mov    0x801146a4,%ecx
80102c99:	89 48 04             	mov    %ecx,0x4(%eax)
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] | (1 << bitmap_offset % 8);
80102c9c:	89 f0                	mov    %esi,%eax
80102c9e:	83 e6 07             	and    $0x7,%esi
80102ca1:	89 f1                	mov    %esi,%ecx
80102ca3:	be 01 00 00 00       	mov    $0x1,%esi
80102ca8:	c1 f8 03             	sar    $0x3,%eax
      kfree(mem);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
      kmem.use_lock = 0;
80102cae:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102cb5:	00 00 00 
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] | (1 << bitmap_offset % 8);
80102cb8:	d3 e6                	shl    %cl,%esi
80102cba:	89 f1                	mov    %esi,%ecx
80102cbc:	08 88 a0 36 11 80    	or     %cl,-0x7feec960(%eax)
      kfree(mem);
80102cc2:	e8 b9 f8 ff ff       	call   80102580 <kfree>
      num_lru_pages--;
80102cc7:	83 2d a0 46 11 80 01 	subl   $0x1,0x801146a0
}
80102cce:	89 d8                	mov    %ebx,%eax
      kmem.use_lock = 1;
80102cd0:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
80102cd7:	00 00 00 
      p_page->use = 0;
80102cda:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
}
80102ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ce4:	5b                   	pop    %ebx
80102ce5:	5e                   	pop    %esi
80102ce6:	5f                   	pop    %edi
80102ce7:	5d                   	pop    %ebp
80102ce8:	c3                   	ret    
        cprintf("Swapout victim page | pgdir : %x,vaddr : 0000, PTE : %x, Modified PTE : %x\n", p_page->pgdir, *pte, (((bitmap_offset << 12) | PTE_FLAGS(*pte)) & (~PTE_P)));
80102ce9:	ff 75 e0             	pushl  -0x20(%ebp)
80102cec:	53                   	push   %ebx
80102ced:	51                   	push   %ecx
80102cee:	68 80 81 10 80       	push   $0x80108180
80102cf3:	e8 b8 d9 ff ff       	call   801006b0 <cprintf>
80102cf8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102cfb:	83 c4 10             	add    $0x10,%esp
80102cfe:	e9 46 ff ff ff       	jmp    80102c49 <swapout+0xf9>
  cprintf("================swap out err================\n");
80102d03:	83 ec 0c             	sub    $0xc,%esp
80102d06:	68 2c 81 10 80       	push   $0x8010812c
80102d0b:	e8 a0 d9 ff ff       	call   801006b0 <cprintf>
  lru_print();
80102d10:	e8 0b fb ff ff       	call   80102820 <lru_print>
  panic("swap out err not found zero page");
80102d15:	c7 04 24 5c 81 10 80 	movl   $0x8010815c,(%esp)
80102d1c:	e8 6f d6 ff ff       	call   80100390 <panic>
    panic("OOM Error");
80102d21:	83 ec 0c             	sub    $0xc,%esp
80102d24:	68 3c 7e 10 80       	push   $0x80107e3c
80102d29:	e8 62 d6 ff ff       	call   80100390 <panic>
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <kalloc>:
{
80102d30:	f3 0f 1e fb          	endbr32 
80102d34:	55                   	push   %ebp
80102d35:	89 e5                	mov    %esp,%ebp
80102d37:	83 ec 18             	sub    $0x18,%esp
  if (kmem.use_lock)
80102d3a:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx
80102d40:	85 c9                	test   %ecx,%ecx
80102d42:	75 4c                	jne    80102d90 <kalloc+0x60>
  if (num_free_pages <= 0)
80102d44:	8b 15 a8 46 11 80    	mov    0x801146a8,%edx
80102d4a:	85 d2                	test   %edx,%edx
80102d4c:	7e 5c                	jle    80102daa <kalloc+0x7a>
    r = kmem.freelist;
80102d4e:	a1 98 36 11 80       	mov    0x80113698,%eax
    if (r)
80102d53:	85 c0                	test   %eax,%eax
80102d55:	74 69                	je     80102dc0 <kalloc+0x90>
      kmem.freelist = r->next;
80102d57:	8b 08                	mov    (%eax),%ecx
80102d59:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  num_free_pages--;
80102d5f:	83 ea 01             	sub    $0x1,%edx
80102d62:	89 15 a8 46 11 80    	mov    %edx,0x801146a8
  if (kmem.use_lock)
80102d68:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102d6e:	85 d2                	test   %edx,%edx
80102d70:	75 06                	jne    80102d78 <kalloc+0x48>
}
80102d72:	c9                   	leave  
80102d73:	c3                   	ret    
80102d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
80102d78:	83 ec 0c             	sub    $0xc,%esp
80102d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d7e:	68 60 36 11 80       	push   $0x80113660
80102d83:	e8 28 21 00 00       	call   80104eb0 <release>
80102d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d8b:	83 c4 10             	add    $0x10,%esp
}
80102d8e:	c9                   	leave  
80102d8f:	c3                   	ret    
    acquire(&kmem.lock);
80102d90:	83 ec 0c             	sub    $0xc,%esp
80102d93:	68 60 36 11 80       	push   $0x80113660
80102d98:	e8 53 20 00 00       	call   80104df0 <acquire>
  if (num_free_pages <= 0)
80102d9d:	8b 15 a8 46 11 80    	mov    0x801146a8,%edx
    acquire(&kmem.lock);
80102da3:	83 c4 10             	add    $0x10,%esp
  if (num_free_pages <= 0)
80102da6:	85 d2                	test   %edx,%edx
80102da8:	7f a4                	jg     80102d4e <kalloc+0x1e>
    r = (struct run *)swapout();
80102daa:	e8 a1 fd ff ff       	call   80102b50 <swapout>
80102daf:	8b 15 a8 46 11 80    	mov    0x801146a8,%edx
80102db5:	eb a8                	jmp    80102d5f <kalloc+0x2f>
80102db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dbe:	66 90                	xchg   %ax,%ax
      cprintf("No free physical page -> ");
80102dc0:	83 ec 0c             	sub    $0xc,%esp
80102dc3:	68 46 7e 10 80       	push   $0x80107e46
80102dc8:	e8 e3 d8 ff ff       	call   801006b0 <cprintf>
      r = (struct run *)swapout();
80102dcd:	e8 7e fd ff ff       	call   80102b50 <swapout>
80102dd2:	8b 15 a8 46 11 80    	mov    0x801146a8,%edx
80102dd8:	83 c4 10             	add    $0x10,%esp
80102ddb:	eb 82                	jmp    80102d5f <kalloc+0x2f>
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi

80102de0 <bitmap_modify>:
{
80102de0:	f3 0f 1e fb          	endbr32 
80102de4:	55                   	push   %ebp
80102de5:	89 e5                	mov    %esp,%ebp
80102de7:	53                   	push   %ebx
80102de8:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102deb:	85 c9                	test   %ecx,%ecx
80102ded:	8d 41 07             	lea    0x7(%ecx),%eax
80102df0:	89 cb                	mov    %ecx,%ebx
80102df2:	0f 49 c1             	cmovns %ecx,%eax
80102df5:	c1 fb 1f             	sar    $0x1f,%ebx
80102df8:	c1 eb 1d             	shr    $0x1d,%ebx
80102dfb:	01 d9                	add    %ebx,%ecx
80102dfd:	c1 f8 03             	sar    $0x3,%eax
80102e00:	83 e1 07             	and    $0x7,%ecx
80102e03:	0f b6 90 a0 36 11 80 	movzbl -0x7feec960(%eax),%edx
80102e0a:	29 d9                	sub    %ebx,%ecx
80102e0c:	bb 01 00 00 00       	mov    $0x1,%ebx
80102e11:	d3 e3                	shl    %cl,%ebx
80102e13:	89 d9                	mov    %ebx,%ecx
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102e15:	89 d3                	mov    %edx,%ebx
80102e17:	09 cb                	or     %ecx,%ebx
80102e19:	f7 d1                	not    %ecx
80102e1b:	21 ca                	and    %ecx,%edx
80102e1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102e20:	85 c9                	test   %ecx,%ecx
80102e22:	0f 45 d3             	cmovne %ebx,%edx
  }
  // cprintf("================bitmap modify end================\n");
}
80102e25:	5b                   	pop    %ebx
80102e26:	5d                   	pop    %ebp
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102e27:	88 90 a0 36 11 80    	mov    %dl,-0x7feec960(%eax)
}
80102e2d:	c3                   	ret    
80102e2e:	66 90                	xchg   %ax,%ax

80102e30 <page_fault_handler>:

int page_fault_handler(pde_t *pgdir, uint vaddr)
{
80102e30:	f3 0f 1e fb          	endbr32 
80102e34:	55                   	push   %ebp
80102e35:	89 e5                	mov    %esp,%ebp
80102e37:	57                   	push   %edi
80102e38:	56                   	push   %esi
80102e39:	53                   	push   %ebx
80102e3a:	83 ec 24             	sub    $0x24,%esp
80102e3d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *mem;
  pte_t *pte;
  int bitmap_offset;

  // PTE check
  cprintf("Page Fault Occur at %x -> ", vaddr);
80102e40:	56                   	push   %esi
80102e41:	68 60 7e 10 80       	push   $0x80107e60
80102e46:	e8 65 d8 ff ff       	call   801006b0 <cprintf>
  pte = walkpgdir(pgdir, (void *)vaddr, 0);
80102e4b:	83 c4 0c             	add    $0xc,%esp
80102e4e:	6a 00                	push   $0x0
80102e50:	56                   	push   %esi
80102e51:	ff 75 08             	pushl  0x8(%ebp)
80102e54:	e8 c7 43 00 00       	call   80107220 <walkpgdir>
  if ((*pte != 0) && ((*pte & PTE_P) == 0)) // page-fault occur where swapped out page
80102e59:	83 c4 10             	add    $0x10,%esp
  pte = walkpgdir(pgdir, (void *)vaddr, 0);
80102e5c:	89 c3                	mov    %eax,%ebx
  if ((*pte != 0) && ((*pte & PTE_P) == 0)) // page-fault occur where swapped out page
80102e5e:	8b 00                	mov    (%eax),%eax
80102e60:	85 c0                	test   %eax,%eax
80102e62:	74 04                	je     80102e68 <page_fault_handler+0x38>
80102e64:	a8 01                	test   $0x1,%al
80102e66:	74 28                	je     80102e90 <page_fault_handler+0x60>
    bitmap_modify(bitmap_offset, 0);
    // cprintf("================Page fault(swappable) end================\n");
  }
  else // page fault occur not exist
  {
    cprintf("================Page fault(non swappable) start================\n");
80102e68:	83 ec 0c             	sub    $0xc,%esp
80102e6b:	68 3c 82 10 80       	push   $0x8010823c
80102e70:	e8 3b d8 ff ff       	call   801006b0 <cprintf>
    // generate page table
    pte = walkpgdir(pgdir, (void *)vaddr, 1);
    // mapping physical page with virtual page
    mappages(pgdir, vaddr, PGSIZE, V2P(mem), PTE_P | PTE_W | PTE_U);
    */
    cprintf("================Page fault(non swappable) end================\n");
80102e75:	c7 04 24 80 82 10 80 	movl   $0x80108280,(%esp)
80102e7c:	e8 2f d8 ff ff       	call   801006b0 <cprintf>
80102e81:	83 c4 10             	add    $0x10,%esp
  }
  // cprintf("================Page fault end================\n");

  return 0;
80102e84:	31 c0                	xor    %eax,%eax
80102e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e89:	5b                   	pop    %ebx
80102e8a:	5e                   	pop    %esi
80102e8b:	5f                   	pop    %edi
80102e8c:	5d                   	pop    %ebp
80102e8d:	c3                   	ret    
80102e8e:	66 90                	xchg   %ax,%ax
    cprintf("Mem alloc -> ");
80102e90:	83 ec 0c             	sub    $0xc,%esp
80102e93:	68 7b 7e 10 80       	push   $0x80107e7b
80102e98:	e8 13 d8 ff ff       	call   801006b0 <cprintf>
    mem = kalloc();
80102e9d:	e8 8e fe ff ff       	call   80102d30 <kalloc>
    if (mem == 0)
80102ea2:	83 c4 10             	add    $0x10,%esp
    mem = kalloc();
80102ea5:	89 c7                	mov    %eax,%edi
    if (mem == 0)
80102ea7:	85 c0                	test   %eax,%eax
80102ea9:	74 72                	je     80102f1d <page_fault_handler+0xed>
    memset(mem, 0, PGSIZE);
80102eab:	83 ec 04             	sub    $0x4,%esp
80102eae:	68 00 10 00 00       	push   $0x1000
80102eb3:	6a 00                	push   $0x0
80102eb5:	50                   	push   %eax
80102eb6:	e8 45 20 00 00       	call   80104f00 <memset>
    bitmap_offset = (PTE_ADDR(*pte)) >> 12;
80102ebb:	8b 03                	mov    (%ebx),%eax
    swapread(mem, bitmap_offset);
80102ebd:	5a                   	pop    %edx
80102ebe:	59                   	pop    %ecx
    bitmap_offset = (PTE_ADDR(*pte)) >> 12;
80102ebf:	c1 e8 0c             	shr    $0xc,%eax
    swapread(mem, bitmap_offset);
80102ec2:	50                   	push   %eax
80102ec3:	57                   	push   %edi
80102ec4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102ec7:	e8 a4 f1 ff ff       	call   80102070 <swapread>
    cprintf("Swap read -> ");
80102ecc:	c7 04 24 89 7e 10 80 	movl   $0x80107e89,(%esp)
80102ed3:	e8 d8 d7 ff ff       	call   801006b0 <cprintf>
    *pte = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
80102ed8:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80102ede:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80102ee4:	83 ca 07             	or     $0x7,%edx
80102ee7:	89 13                	mov    %edx,(%ebx)
    page_insert(pgdir, vaddr);
80102ee9:	5b                   	pop    %ebx
80102eea:	5f                   	pop    %edi
80102eeb:	56                   	push   %esi
80102eec:	ff 75 08             	pushl  0x8(%ebp)
80102eef:	e8 cc f9 ff ff       	call   801028c0 <page_insert>
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102ef4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102ef7:	83 c4 10             	add    $0x10,%esp
80102efa:	89 c2                	mov    %eax,%edx
80102efc:	83 e0 07             	and    $0x7,%eax
80102eff:	89 c1                	mov    %eax,%ecx
80102f01:	b8 01 00 00 00       	mov    $0x1,%eax
80102f06:	c1 fa 03             	sar    $0x3,%edx
80102f09:	d3 e0                	shl    %cl,%eax
80102f0b:	f7 d0                	not    %eax
80102f0d:	20 82 a0 36 11 80    	and    %al,-0x7feec960(%edx)
80102f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102f16:	31 c0                	xor    %eax,%eax
80102f18:	5b                   	pop    %ebx
80102f19:	5e                   	pop    %esi
80102f1a:	5f                   	pop    %edi
80102f1b:	5d                   	pop    %ebp
80102f1c:	c3                   	ret    
      cprintf("page fault allocate out of memory\n");
80102f1d:	83 ec 0c             	sub    $0xc,%esp
80102f20:	68 18 82 10 80       	push   $0x80108218
80102f25:	e8 86 d7 ff ff       	call   801006b0 <cprintf>
      return -1;
80102f2a:	83 c4 10             	add    $0x10,%esp
80102f2d:	83 c8 ff             	or     $0xffffffff,%eax
80102f30:	e9 51 ff ff ff       	jmp    80102e86 <page_fault_handler+0x56>
80102f35:	66 90                	xchg   %ax,%ax
80102f37:	66 90                	xchg   %ax,%ax
80102f39:	66 90                	xchg   %ax,%ax
80102f3b:	66 90                	xchg   %ax,%ax
80102f3d:	66 90                	xchg   %ax,%ax
80102f3f:	90                   	nop

80102f40 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102f40:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f44:	ba 64 00 00 00       	mov    $0x64,%edx
80102f49:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102f4a:	a8 01                	test   $0x1,%al
80102f4c:	0f 84 be 00 00 00    	je     80103010 <kbdgetc+0xd0>
{
80102f52:	55                   	push   %ebp
80102f53:	ba 60 00 00 00       	mov    $0x60,%edx
80102f58:	89 e5                	mov    %esp,%ebp
80102f5a:	53                   	push   %ebx
80102f5b:	ec                   	in     (%dx),%al
  return data;
80102f5c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102f62:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102f65:	3c e0                	cmp    $0xe0,%al
80102f67:	74 57                	je     80102fc0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102f69:	89 d9                	mov    %ebx,%ecx
80102f6b:	83 e1 40             	and    $0x40,%ecx
80102f6e:	84 c0                	test   %al,%al
80102f70:	78 5e                	js     80102fd0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102f72:	85 c9                	test   %ecx,%ecx
80102f74:	74 09                	je     80102f7f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f76:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102f79:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102f7c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102f7f:	0f b6 8a e0 83 10 80 	movzbl -0x7fef7c20(%edx),%ecx
  shift ^= togglecode[data];
80102f86:	0f b6 82 e0 82 10 80 	movzbl -0x7fef7d20(%edx),%eax
  shift |= shiftcode[data];
80102f8d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102f8f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f91:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102f93:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102f99:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102f9c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f9f:	8b 04 85 c0 82 10 80 	mov    -0x7fef7d40(,%eax,4),%eax
80102fa6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102faa:	74 0b                	je     80102fb7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102fac:	8d 50 9f             	lea    -0x61(%eax),%edx
80102faf:	83 fa 19             	cmp    $0x19,%edx
80102fb2:	77 44                	ja     80102ff8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102fb4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102fb7:	5b                   	pop    %ebx
80102fb8:	5d                   	pop    %ebp
80102fb9:	c3                   	ret    
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102fc0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102fc3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102fc5:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
80102fcb:	5b                   	pop    %ebx
80102fcc:	5d                   	pop    %ebp
80102fcd:	c3                   	ret    
80102fce:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102fd0:	83 e0 7f             	and    $0x7f,%eax
80102fd3:	85 c9                	test   %ecx,%ecx
80102fd5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102fd8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102fda:	0f b6 8a e0 83 10 80 	movzbl -0x7fef7c20(%edx),%ecx
80102fe1:	83 c9 40             	or     $0x40,%ecx
80102fe4:	0f b6 c9             	movzbl %cl,%ecx
80102fe7:	f7 d1                	not    %ecx
80102fe9:	21 d9                	and    %ebx,%ecx
}
80102feb:	5b                   	pop    %ebx
80102fec:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102fed:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102ff3:	c3                   	ret    
80102ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102ff8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102ffb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102ffe:	5b                   	pop    %ebx
80102fff:	5d                   	pop    %ebp
      c += 'a' - 'A';
80103000:	83 f9 1a             	cmp    $0x1a,%ecx
80103003:	0f 42 c2             	cmovb  %edx,%eax
}
80103006:	c3                   	ret    
80103007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010300e:	66 90                	xchg   %ax,%ax
    return -1;
80103010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103015:	c3                   	ret    
80103016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010301d:	8d 76 00             	lea    0x0(%esi),%esi

80103020 <kbdintr>:

void
kbdintr(void)
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010302a:	68 40 2f 10 80       	push   $0x80102f40
8010302f:	e8 2c d8 ff ff       	call   80100860 <consoleintr>
}
80103034:	83 c4 10             	add    $0x10,%esp
80103037:	c9                   	leave  
80103038:	c3                   	ret    
80103039:	66 90                	xchg   %ax,%ax
8010303b:	66 90                	xchg   %ax,%ax
8010303d:	66 90                	xchg   %ax,%ax
8010303f:	90                   	nop

80103040 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80103040:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80103044:	a1 c0 96 11 80       	mov    0x801196c0,%eax
80103049:	85 c0                	test   %eax,%eax
8010304b:	0f 84 c7 00 00 00    	je     80103118 <lapicinit+0xd8>
  lapic[index] = value;
80103051:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103058:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010305b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010305e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103065:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103068:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010306b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103072:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103075:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103078:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010307f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103082:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103085:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010308c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010308f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103092:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103099:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010309c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010309f:	8b 50 30             	mov    0x30(%eax),%edx
801030a2:	c1 ea 10             	shr    $0x10,%edx
801030a5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801030ab:	75 73                	jne    80103120 <lapicinit+0xe0>
  lapic[index] = value;
801030ad:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801030b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030ba:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801030c1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030c7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801030ce:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030d4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801030db:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030e1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801030e8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030ee:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801030f5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801030f8:	8b 50 20             	mov    0x20(%eax),%edx
801030fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030ff:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103100:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103106:	80 e6 10             	and    $0x10,%dh
80103109:	75 f5                	jne    80103100 <lapicinit+0xc0>
  lapic[index] = value;
8010310b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103112:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103115:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103118:	c3                   	ret    
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103120:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103127:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010312a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010312d:	e9 7b ff ff ff       	jmp    801030ad <lapicinit+0x6d>
80103132:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103140 <lapicid>:

int
lapicid(void)
{
80103140:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80103144:	a1 c0 96 11 80       	mov    0x801196c0,%eax
80103149:	85 c0                	test   %eax,%eax
8010314b:	74 0b                	je     80103158 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010314d:	8b 40 20             	mov    0x20(%eax),%eax
80103150:	c1 e8 18             	shr    $0x18,%eax
80103153:	c3                   	ret    
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80103158:	31 c0                	xor    %eax,%eax
}
8010315a:	c3                   	ret    
8010315b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop

80103160 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103160:	f3 0f 1e fb          	endbr32 
  if(lapic)
80103164:	a1 c0 96 11 80       	mov    0x801196c0,%eax
80103169:	85 c0                	test   %eax,%eax
8010316b:	74 0d                	je     8010317a <lapiceoi+0x1a>
  lapic[index] = value;
8010316d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103174:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103177:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010317a:	c3                   	ret    
8010317b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010317f:	90                   	nop

80103180 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103180:	f3 0f 1e fb          	endbr32 
}
80103184:	c3                   	ret    
80103185:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010318c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103190 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103190:	f3 0f 1e fb          	endbr32 
80103194:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103195:	b8 0f 00 00 00       	mov    $0xf,%eax
8010319a:	ba 70 00 00 00       	mov    $0x70,%edx
8010319f:	89 e5                	mov    %esp,%ebp
801031a1:	53                   	push   %ebx
801031a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801031a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801031a8:	ee                   	out    %al,(%dx)
801031a9:	b8 0a 00 00 00       	mov    $0xa,%eax
801031ae:	ba 71 00 00 00       	mov    $0x71,%edx
801031b3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801031b4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801031b6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801031b9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801031bf:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801031c1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801031c4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801031c6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801031c9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801031cc:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801031d2:	a1 c0 96 11 80       	mov    0x801196c0,%eax
801031d7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031dd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031e0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801031e7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031ea:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031ed:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801031f4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031f7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031fa:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103200:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103203:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103209:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010320c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103212:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103215:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010321b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010321c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010321f:	5d                   	pop    %ebp
80103220:	c3                   	ret    
80103221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010322f:	90                   	nop

80103230 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103230:	f3 0f 1e fb          	endbr32 
80103234:	55                   	push   %ebp
80103235:	b8 0b 00 00 00       	mov    $0xb,%eax
8010323a:	ba 70 00 00 00       	mov    $0x70,%edx
8010323f:	89 e5                	mov    %esp,%ebp
80103241:	57                   	push   %edi
80103242:	56                   	push   %esi
80103243:	53                   	push   %ebx
80103244:	83 ec 4c             	sub    $0x4c,%esp
80103247:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103248:	ba 71 00 00 00       	mov    $0x71,%edx
8010324d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010324e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103251:	bb 70 00 00 00       	mov    $0x70,%ebx
80103256:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103260:	31 c0                	xor    %eax,%eax
80103262:	89 da                	mov    %ebx,%edx
80103264:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103265:	b9 71 00 00 00       	mov    $0x71,%ecx
8010326a:	89 ca                	mov    %ecx,%edx
8010326c:	ec                   	in     (%dx),%al
8010326d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103270:	89 da                	mov    %ebx,%edx
80103272:	b8 02 00 00 00       	mov    $0x2,%eax
80103277:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103278:	89 ca                	mov    %ecx,%edx
8010327a:	ec                   	in     (%dx),%al
8010327b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010327e:	89 da                	mov    %ebx,%edx
80103280:	b8 04 00 00 00       	mov    $0x4,%eax
80103285:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103286:	89 ca                	mov    %ecx,%edx
80103288:	ec                   	in     (%dx),%al
80103289:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010328c:	89 da                	mov    %ebx,%edx
8010328e:	b8 07 00 00 00       	mov    $0x7,%eax
80103293:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103294:	89 ca                	mov    %ecx,%edx
80103296:	ec                   	in     (%dx),%al
80103297:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010329a:	89 da                	mov    %ebx,%edx
8010329c:	b8 08 00 00 00       	mov    $0x8,%eax
801032a1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032a2:	89 ca                	mov    %ecx,%edx
801032a4:	ec                   	in     (%dx),%al
801032a5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032a7:	89 da                	mov    %ebx,%edx
801032a9:	b8 09 00 00 00       	mov    $0x9,%eax
801032ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032af:	89 ca                	mov    %ecx,%edx
801032b1:	ec                   	in     (%dx),%al
801032b2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032b4:	89 da                	mov    %ebx,%edx
801032b6:	b8 0a 00 00 00       	mov    $0xa,%eax
801032bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032bc:	89 ca                	mov    %ecx,%edx
801032be:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801032bf:	84 c0                	test   %al,%al
801032c1:	78 9d                	js     80103260 <cmostime+0x30>
  return inb(CMOS_RETURN);
801032c3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801032c7:	89 fa                	mov    %edi,%edx
801032c9:	0f b6 fa             	movzbl %dl,%edi
801032cc:	89 f2                	mov    %esi,%edx
801032ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
801032d1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801032d5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032d8:	89 da                	mov    %ebx,%edx
801032da:	89 7d c8             	mov    %edi,-0x38(%ebp)
801032dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
801032e0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801032e4:	89 75 cc             	mov    %esi,-0x34(%ebp)
801032e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
801032ea:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801032ee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801032f1:	31 c0                	xor    %eax,%eax
801032f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032f4:	89 ca                	mov    %ecx,%edx
801032f6:	ec                   	in     (%dx),%al
801032f7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032fa:	89 da                	mov    %ebx,%edx
801032fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
801032ff:	b8 02 00 00 00       	mov    $0x2,%eax
80103304:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103305:	89 ca                	mov    %ecx,%edx
80103307:	ec                   	in     (%dx),%al
80103308:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010330b:	89 da                	mov    %ebx,%edx
8010330d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103310:	b8 04 00 00 00       	mov    $0x4,%eax
80103315:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103316:	89 ca                	mov    %ecx,%edx
80103318:	ec                   	in     (%dx),%al
80103319:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331c:	89 da                	mov    %ebx,%edx
8010331e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103321:	b8 07 00 00 00       	mov    $0x7,%eax
80103326:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103327:	89 ca                	mov    %ecx,%edx
80103329:	ec                   	in     (%dx),%al
8010332a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332d:	89 da                	mov    %ebx,%edx
8010332f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103332:	b8 08 00 00 00       	mov    $0x8,%eax
80103337:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103338:	89 ca                	mov    %ecx,%edx
8010333a:	ec                   	in     (%dx),%al
8010333b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010333e:	89 da                	mov    %ebx,%edx
80103340:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103343:	b8 09 00 00 00       	mov    $0x9,%eax
80103348:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103349:	89 ca                	mov    %ecx,%edx
8010334b:	ec                   	in     (%dx),%al
8010334c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010334f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103352:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103355:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103358:	6a 18                	push   $0x18
8010335a:	50                   	push   %eax
8010335b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010335e:	50                   	push   %eax
8010335f:	e8 ec 1b 00 00       	call   80104f50 <memcmp>
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 c0                	test   %eax,%eax
80103369:	0f 85 f1 fe ff ff    	jne    80103260 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010336f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103373:	75 78                	jne    801033ed <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103375:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103378:	89 c2                	mov    %eax,%edx
8010337a:	83 e0 0f             	and    $0xf,%eax
8010337d:	c1 ea 04             	shr    $0x4,%edx
80103380:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103383:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103386:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103389:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010338c:	89 c2                	mov    %eax,%edx
8010338e:	83 e0 0f             	and    $0xf,%eax
80103391:	c1 ea 04             	shr    $0x4,%edx
80103394:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103397:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010339a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010339d:	8b 45 c0             	mov    -0x40(%ebp),%eax
801033a0:	89 c2                	mov    %eax,%edx
801033a2:	83 e0 0f             	and    $0xf,%eax
801033a5:	c1 ea 04             	shr    $0x4,%edx
801033a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033ae:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801033b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801033b4:	89 c2                	mov    %eax,%edx
801033b6:	83 e0 0f             	and    $0xf,%eax
801033b9:	c1 ea 04             	shr    $0x4,%edx
801033bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033c2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801033c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801033c8:	89 c2                	mov    %eax,%edx
801033ca:	83 e0 0f             	and    $0xf,%eax
801033cd:	c1 ea 04             	shr    $0x4,%edx
801033d0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033d3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033d6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801033d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801033dc:	89 c2                	mov    %eax,%edx
801033de:	83 e0 0f             	and    $0xf,%eax
801033e1:	c1 ea 04             	shr    $0x4,%edx
801033e4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033e7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801033ed:	8b 75 08             	mov    0x8(%ebp),%esi
801033f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801033f3:	89 06                	mov    %eax,(%esi)
801033f5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801033f8:	89 46 04             	mov    %eax,0x4(%esi)
801033fb:	8b 45 c0             	mov    -0x40(%ebp),%eax
801033fe:	89 46 08             	mov    %eax,0x8(%esi)
80103401:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103404:	89 46 0c             	mov    %eax,0xc(%esi)
80103407:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010340a:	89 46 10             	mov    %eax,0x10(%esi)
8010340d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103410:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103413:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010341a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010341d:	5b                   	pop    %ebx
8010341e:	5e                   	pop    %esi
8010341f:	5f                   	pop    %edi
80103420:	5d                   	pop    %ebp
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103430:	8b 0d 28 97 11 80    	mov    0x80119728,%ecx
80103436:	85 c9                	test   %ecx,%ecx
80103438:	0f 8e 8a 00 00 00    	jle    801034c8 <install_trans+0x98>
{
8010343e:	55                   	push   %ebp
8010343f:	89 e5                	mov    %esp,%ebp
80103441:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103442:	31 ff                	xor    %edi,%edi
{
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103450:	a1 14 97 11 80       	mov    0x80119714,%eax
80103455:	83 ec 08             	sub    $0x8,%esp
80103458:	01 f8                	add    %edi,%eax
8010345a:	83 c0 01             	add    $0x1,%eax
8010345d:	50                   	push   %eax
8010345e:	ff 35 24 97 11 80    	pushl  0x80119724
80103464:	e8 67 cc ff ff       	call   801000d0 <bread>
80103469:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010346b:	58                   	pop    %eax
8010346c:	5a                   	pop    %edx
8010346d:	ff 34 bd 2c 97 11 80 	pushl  -0x7fee68d4(,%edi,4)
80103474:	ff 35 24 97 11 80    	pushl  0x80119724
  for (tail = 0; tail < log.lh.n; tail++) {
8010347a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010347d:	e8 4e cc ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103482:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103485:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103487:	8d 46 5c             	lea    0x5c(%esi),%eax
8010348a:	68 00 02 00 00       	push   $0x200
8010348f:	50                   	push   %eax
80103490:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103493:	50                   	push   %eax
80103494:	e8 07 1b 00 00       	call   80104fa0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103499:	89 1c 24             	mov    %ebx,(%esp)
8010349c:	e8 0f cd ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801034a1:	89 34 24             	mov    %esi,(%esp)
801034a4:	e8 47 cd ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801034a9:	89 1c 24             	mov    %ebx,(%esp)
801034ac:	e8 3f cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801034b1:	83 c4 10             	add    $0x10,%esp
801034b4:	39 3d 28 97 11 80    	cmp    %edi,0x80119728
801034ba:	7f 94                	jg     80103450 <install_trans+0x20>
  }
}
801034bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034bf:	5b                   	pop    %ebx
801034c0:	5e                   	pop    %esi
801034c1:	5f                   	pop    %edi
801034c2:	5d                   	pop    %ebp
801034c3:	c3                   	ret    
801034c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034c8:	c3                   	ret    
801034c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034d0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	53                   	push   %ebx
801034d4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801034d7:	ff 35 14 97 11 80    	pushl  0x80119714
801034dd:	ff 35 24 97 11 80    	pushl  0x80119724
801034e3:	e8 e8 cb ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801034e8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801034eb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801034ed:	a1 28 97 11 80       	mov    0x80119728,%eax
801034f2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801034f5:	85 c0                	test   %eax,%eax
801034f7:	7e 19                	jle    80103512 <write_head+0x42>
801034f9:	31 d2                	xor    %edx,%edx
801034fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103500:	8b 0c 95 2c 97 11 80 	mov    -0x7fee68d4(,%edx,4),%ecx
80103507:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010350b:	83 c2 01             	add    $0x1,%edx
8010350e:	39 d0                	cmp    %edx,%eax
80103510:	75 ee                	jne    80103500 <write_head+0x30>
  }
  bwrite(buf);
80103512:	83 ec 0c             	sub    $0xc,%esp
80103515:	53                   	push   %ebx
80103516:	e8 95 cc ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010351b:	89 1c 24             	mov    %ebx,(%esp)
8010351e:	e8 cd cc ff ff       	call   801001f0 <brelse>
}
80103523:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103526:	83 c4 10             	add    $0x10,%esp
80103529:	c9                   	leave  
8010352a:	c3                   	ret    
8010352b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010352f:	90                   	nop

80103530 <initlog>:
{
80103530:	f3 0f 1e fb          	endbr32 
80103534:	55                   	push   %ebp
80103535:	89 e5                	mov    %esp,%ebp
80103537:	53                   	push   %ebx
80103538:	83 ec 2c             	sub    $0x2c,%esp
8010353b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010353e:	68 e0 84 10 80       	push   $0x801084e0
80103543:	68 e0 96 11 80       	push   $0x801196e0
80103548:	e8 23 17 00 00       	call   80104c70 <initlock>
  readsb(dev, &sb);
8010354d:	58                   	pop    %eax
8010354e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103551:	5a                   	pop    %edx
80103552:	50                   	push   %eax
80103553:	53                   	push   %ebx
80103554:	e8 27 df ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
80103559:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010355c:	59                   	pop    %ecx
  log.dev = dev;
8010355d:	89 1d 24 97 11 80    	mov    %ebx,0x80119724
  log.size = sb.nlog;
80103563:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103566:	a3 14 97 11 80       	mov    %eax,0x80119714
  log.size = sb.nlog;
8010356b:	89 15 18 97 11 80    	mov    %edx,0x80119718
  struct buf *buf = bread(log.dev, log.start);
80103571:	5a                   	pop    %edx
80103572:	50                   	push   %eax
80103573:	53                   	push   %ebx
80103574:	e8 57 cb ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103579:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010357c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010357f:	89 0d 28 97 11 80    	mov    %ecx,0x80119728
  for (i = 0; i < log.lh.n; i++) {
80103585:	85 c9                	test   %ecx,%ecx
80103587:	7e 19                	jle    801035a2 <initlog+0x72>
80103589:	31 d2                	xor    %edx,%edx
8010358b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010358f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103590:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103594:	89 1c 95 2c 97 11 80 	mov    %ebx,-0x7fee68d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010359b:	83 c2 01             	add    $0x1,%edx
8010359e:	39 d1                	cmp    %edx,%ecx
801035a0:	75 ee                	jne    80103590 <initlog+0x60>
  brelse(buf);
801035a2:	83 ec 0c             	sub    $0xc,%esp
801035a5:	50                   	push   %eax
801035a6:	e8 45 cc ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801035ab:	e8 80 fe ff ff       	call   80103430 <install_trans>
  log.lh.n = 0;
801035b0:	c7 05 28 97 11 80 00 	movl   $0x0,0x80119728
801035b7:	00 00 00 
  write_head(); // clear the log
801035ba:	e8 11 ff ff ff       	call   801034d0 <write_head>
}
801035bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035c2:	83 c4 10             	add    $0x10,%esp
801035c5:	c9                   	leave  
801035c6:	c3                   	ret    
801035c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801035d0:	f3 0f 1e fb          	endbr32 
801035d4:	55                   	push   %ebp
801035d5:	89 e5                	mov    %esp,%ebp
801035d7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801035da:	68 e0 96 11 80       	push   $0x801196e0
801035df:	e8 0c 18 00 00       	call   80104df0 <acquire>
801035e4:	83 c4 10             	add    $0x10,%esp
801035e7:	eb 1c                	jmp    80103605 <begin_op+0x35>
801035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801035f0:	83 ec 08             	sub    $0x8,%esp
801035f3:	68 e0 96 11 80       	push   $0x801196e0
801035f8:	68 e0 96 11 80       	push   $0x801196e0
801035fd:	e8 ae 11 00 00       	call   801047b0 <sleep>
80103602:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103605:	a1 20 97 11 80       	mov    0x80119720,%eax
8010360a:	85 c0                	test   %eax,%eax
8010360c:	75 e2                	jne    801035f0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010360e:	a1 1c 97 11 80       	mov    0x8011971c,%eax
80103613:	8b 15 28 97 11 80    	mov    0x80119728,%edx
80103619:	83 c0 01             	add    $0x1,%eax
8010361c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010361f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103622:	83 fa 1e             	cmp    $0x1e,%edx
80103625:	7f c9                	jg     801035f0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103627:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010362a:	a3 1c 97 11 80       	mov    %eax,0x8011971c
      release(&log.lock);
8010362f:	68 e0 96 11 80       	push   $0x801196e0
80103634:	e8 77 18 00 00       	call   80104eb0 <release>
      break;
    }
  }
}
80103639:	83 c4 10             	add    $0x10,%esp
8010363c:	c9                   	leave  
8010363d:	c3                   	ret    
8010363e:	66 90                	xchg   %ax,%ax

80103640 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103640:	f3 0f 1e fb          	endbr32 
80103644:	55                   	push   %ebp
80103645:	89 e5                	mov    %esp,%ebp
80103647:	57                   	push   %edi
80103648:	56                   	push   %esi
80103649:	53                   	push   %ebx
8010364a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010364d:	68 e0 96 11 80       	push   $0x801196e0
80103652:	e8 99 17 00 00       	call   80104df0 <acquire>
  log.outstanding -= 1;
80103657:	a1 1c 97 11 80       	mov    0x8011971c,%eax
  if(log.committing)
8010365c:	8b 35 20 97 11 80    	mov    0x80119720,%esi
80103662:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103665:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103668:	89 1d 1c 97 11 80    	mov    %ebx,0x8011971c
  if(log.committing)
8010366e:	85 f6                	test   %esi,%esi
80103670:	0f 85 1e 01 00 00    	jne    80103794 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103676:	85 db                	test   %ebx,%ebx
80103678:	0f 85 f2 00 00 00    	jne    80103770 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010367e:	c7 05 20 97 11 80 01 	movl   $0x1,0x80119720
80103685:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	68 e0 96 11 80       	push   $0x801196e0
80103690:	e8 1b 18 00 00       	call   80104eb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103695:	8b 0d 28 97 11 80    	mov    0x80119728,%ecx
8010369b:	83 c4 10             	add    $0x10,%esp
8010369e:	85 c9                	test   %ecx,%ecx
801036a0:	7f 3e                	jg     801036e0 <end_op+0xa0>
    acquire(&log.lock);
801036a2:	83 ec 0c             	sub    $0xc,%esp
801036a5:	68 e0 96 11 80       	push   $0x801196e0
801036aa:	e8 41 17 00 00       	call   80104df0 <acquire>
    wakeup(&log);
801036af:	c7 04 24 e0 96 11 80 	movl   $0x801196e0,(%esp)
    log.committing = 0;
801036b6:	c7 05 20 97 11 80 00 	movl   $0x0,0x80119720
801036bd:	00 00 00 
    wakeup(&log);
801036c0:	e8 ab 12 00 00       	call   80104970 <wakeup>
    release(&log.lock);
801036c5:	c7 04 24 e0 96 11 80 	movl   $0x801196e0,(%esp)
801036cc:	e8 df 17 00 00       	call   80104eb0 <release>
801036d1:	83 c4 10             	add    $0x10,%esp
}
801036d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036d7:	5b                   	pop    %ebx
801036d8:	5e                   	pop    %esi
801036d9:	5f                   	pop    %edi
801036da:	5d                   	pop    %ebp
801036db:	c3                   	ret    
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036e0:	a1 14 97 11 80       	mov    0x80119714,%eax
801036e5:	83 ec 08             	sub    $0x8,%esp
801036e8:	01 d8                	add    %ebx,%eax
801036ea:	83 c0 01             	add    $0x1,%eax
801036ed:	50                   	push   %eax
801036ee:	ff 35 24 97 11 80    	pushl  0x80119724
801036f4:	e8 d7 c9 ff ff       	call   801000d0 <bread>
801036f9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036fb:	58                   	pop    %eax
801036fc:	5a                   	pop    %edx
801036fd:	ff 34 9d 2c 97 11 80 	pushl  -0x7fee68d4(,%ebx,4)
80103704:	ff 35 24 97 11 80    	pushl  0x80119724
  for (tail = 0; tail < log.lh.n; tail++) {
8010370a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010370d:	e8 be c9 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103712:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103715:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103717:	8d 40 5c             	lea    0x5c(%eax),%eax
8010371a:	68 00 02 00 00       	push   $0x200
8010371f:	50                   	push   %eax
80103720:	8d 46 5c             	lea    0x5c(%esi),%eax
80103723:	50                   	push   %eax
80103724:	e8 77 18 00 00       	call   80104fa0 <memmove>
    bwrite(to);  // write the log
80103729:	89 34 24             	mov    %esi,(%esp)
8010372c:	e8 7f ca ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103731:	89 3c 24             	mov    %edi,(%esp)
80103734:	e8 b7 ca ff ff       	call   801001f0 <brelse>
    brelse(to);
80103739:	89 34 24             	mov    %esi,(%esp)
8010373c:	e8 af ca ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103741:	83 c4 10             	add    $0x10,%esp
80103744:	3b 1d 28 97 11 80    	cmp    0x80119728,%ebx
8010374a:	7c 94                	jl     801036e0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010374c:	e8 7f fd ff ff       	call   801034d0 <write_head>
    install_trans(); // Now install writes to home locations
80103751:	e8 da fc ff ff       	call   80103430 <install_trans>
    log.lh.n = 0;
80103756:	c7 05 28 97 11 80 00 	movl   $0x0,0x80119728
8010375d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103760:	e8 6b fd ff ff       	call   801034d0 <write_head>
80103765:	e9 38 ff ff ff       	jmp    801036a2 <end_op+0x62>
8010376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103770:	83 ec 0c             	sub    $0xc,%esp
80103773:	68 e0 96 11 80       	push   $0x801196e0
80103778:	e8 f3 11 00 00       	call   80104970 <wakeup>
  release(&log.lock);
8010377d:	c7 04 24 e0 96 11 80 	movl   $0x801196e0,(%esp)
80103784:	e8 27 17 00 00       	call   80104eb0 <release>
80103789:	83 c4 10             	add    $0x10,%esp
}
8010378c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010378f:	5b                   	pop    %ebx
80103790:	5e                   	pop    %esi
80103791:	5f                   	pop    %edi
80103792:	5d                   	pop    %ebp
80103793:	c3                   	ret    
    panic("log.committing");
80103794:	83 ec 0c             	sub    $0xc,%esp
80103797:	68 e4 84 10 80       	push   $0x801084e4
8010379c:	e8 ef cb ff ff       	call   80100390 <panic>
801037a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037af:	90                   	nop

801037b0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801037b0:	f3 0f 1e fb          	endbr32 
801037b4:	55                   	push   %ebp
801037b5:	89 e5                	mov    %esp,%ebp
801037b7:	53                   	push   %ebx
801037b8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037bb:	8b 15 28 97 11 80    	mov    0x80119728,%edx
{
801037c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037c4:	83 fa 1d             	cmp    $0x1d,%edx
801037c7:	0f 8f 91 00 00 00    	jg     8010385e <log_write+0xae>
801037cd:	a1 18 97 11 80       	mov    0x80119718,%eax
801037d2:	83 e8 01             	sub    $0x1,%eax
801037d5:	39 c2                	cmp    %eax,%edx
801037d7:	0f 8d 81 00 00 00    	jge    8010385e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801037dd:	a1 1c 97 11 80       	mov    0x8011971c,%eax
801037e2:	85 c0                	test   %eax,%eax
801037e4:	0f 8e 81 00 00 00    	jle    8010386b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801037ea:	83 ec 0c             	sub    $0xc,%esp
801037ed:	68 e0 96 11 80       	push   $0x801196e0
801037f2:	e8 f9 15 00 00       	call   80104df0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801037f7:	8b 15 28 97 11 80    	mov    0x80119728,%edx
801037fd:	83 c4 10             	add    $0x10,%esp
80103800:	85 d2                	test   %edx,%edx
80103802:	7e 4e                	jle    80103852 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103804:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103807:	31 c0                	xor    %eax,%eax
80103809:	eb 0c                	jmp    80103817 <log_write+0x67>
8010380b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010380f:	90                   	nop
80103810:	83 c0 01             	add    $0x1,%eax
80103813:	39 c2                	cmp    %eax,%edx
80103815:	74 29                	je     80103840 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103817:	39 0c 85 2c 97 11 80 	cmp    %ecx,-0x7fee68d4(,%eax,4)
8010381e:	75 f0                	jne    80103810 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103820:	89 0c 85 2c 97 11 80 	mov    %ecx,-0x7fee68d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103827:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010382a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010382d:	c7 45 08 e0 96 11 80 	movl   $0x801196e0,0x8(%ebp)
}
80103834:	c9                   	leave  
  release(&log.lock);
80103835:	e9 76 16 00 00       	jmp    80104eb0 <release>
8010383a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103840:	89 0c 95 2c 97 11 80 	mov    %ecx,-0x7fee68d4(,%edx,4)
    log.lh.n++;
80103847:	83 c2 01             	add    $0x1,%edx
8010384a:	89 15 28 97 11 80    	mov    %edx,0x80119728
80103850:	eb d5                	jmp    80103827 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103852:	8b 43 08             	mov    0x8(%ebx),%eax
80103855:	a3 2c 97 11 80       	mov    %eax,0x8011972c
  if (i == log.lh.n)
8010385a:	75 cb                	jne    80103827 <log_write+0x77>
8010385c:	eb e9                	jmp    80103847 <log_write+0x97>
    panic("too big a transaction");
8010385e:	83 ec 0c             	sub    $0xc,%esp
80103861:	68 f3 84 10 80       	push   $0x801084f3
80103866:	e8 25 cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010386b:	83 ec 0c             	sub    $0xc,%esp
8010386e:	68 09 85 10 80       	push   $0x80108509
80103873:	e8 18 cb ff ff       	call   80100390 <panic>
80103878:	66 90                	xchg   %ax,%ax
8010387a:	66 90                	xchg   %ax,%ax
8010387c:	66 90                	xchg   %ax,%ax
8010387e:	66 90                	xchg   %ax,%ax

80103880 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	53                   	push   %ebx
80103884:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103887:	e8 54 09 00 00       	call   801041e0 <cpuid>
8010388c:	89 c3                	mov    %eax,%ebx
8010388e:	e8 4d 09 00 00       	call   801041e0 <cpuid>
80103893:	83 ec 04             	sub    $0x4,%esp
80103896:	53                   	push   %ebx
80103897:	50                   	push   %eax
80103898:	68 24 85 10 80       	push   $0x80108524
8010389d:	e8 0e ce ff ff       	call   801006b0 <cprintf>
  idtinit();                    // load idt register
801038a2:	e8 29 2a 00 00       	call   801062d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801038a7:	e8 c4 08 00 00       	call   80104170 <mycpu>
801038ac:	89 c2                	mov    %eax,%edx
  asm volatile("lock; xchgl %0, %1" :
801038ae:	b8 01 00 00 00       	mov    $0x1,%eax
801038b3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();                  // start running processes
801038ba:	e8 21 0c 00 00       	call   801044e0 <scheduler>
801038bf:	90                   	nop

801038c0 <mpenter>:
{
801038c0:	f3 0f 1e fb          	endbr32 
801038c4:	55                   	push   %ebp
801038c5:	89 e5                	mov    %esp,%ebp
801038c7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801038ca:	e8 61 3b 00 00       	call   80107430 <switchkvm>
  seginit();
801038cf:	e8 bc 38 00 00       	call   80107190 <seginit>
  lapicinit();
801038d4:	e8 67 f7 ff ff       	call   80103040 <lapicinit>
  mpmain();
801038d9:	e8 a2 ff ff ff       	call   80103880 <mpmain>
801038de:	66 90                	xchg   %ax,%ax

801038e0 <main>:
{
801038e0:	f3 0f 1e fb          	endbr32 
801038e4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801038e8:	83 e4 f0             	and    $0xfffffff0,%esp
801038eb:	ff 71 fc             	pushl  -0x4(%ecx)
801038ee:	55                   	push   %ebp
801038ef:	89 e5                	mov    %esp,%ebp
801038f1:	53                   	push   %ebx
801038f2:	51                   	push   %ecx
  kinit1(end, P2V(4 * 1024 * 1024));          // phys page allocator
801038f3:	83 ec 08             	sub    $0x8,%esp
801038f6:	68 00 00 40 80       	push   $0x80400000
801038fb:	68 08 c5 11 80       	push   $0x8011c508
80103900:	e8 cb ed ff ff       	call   801026d0 <kinit1>
  kvmalloc();                                 // kernel page table
80103905:	e8 26 40 00 00       	call   80107930 <kvmalloc>
  mpinit();                                   // detect other processors
8010390a:	e8 81 01 00 00       	call   80103a90 <mpinit>
  lapicinit();                                // interrupt controller
8010390f:	e8 2c f7 ff ff       	call   80103040 <lapicinit>
  seginit();                                  // segment descriptors
80103914:	e8 77 38 00 00       	call   80107190 <seginit>
  picinit();                                  // disable pic
80103919:	e8 52 03 00 00       	call   80103c70 <picinit>
  ioapicinit();                               // another interrupt controller
8010391e:	e8 6d eb ff ff       	call   80102490 <ioapicinit>
  consoleinit();                              // console hardware
80103923:	e8 08 d1 ff ff       	call   80100a30 <consoleinit>
  uartinit();                                 // serial port
80103928:	e8 e3 2c 00 00       	call   80106610 <uartinit>
  pinit();                                    // process table
8010392d:	e8 1e 08 00 00       	call   80104150 <pinit>
  tvinit();                                   // trap vectors
80103932:	e8 19 29 00 00       	call   80106250 <tvinit>
  binit();                                    // buffer cache
80103937:	e8 04 c7 ff ff       	call   80100040 <binit>
  fileinit();                                 // file table
8010393c:	e8 9f d4 ff ff       	call   80100de0 <fileinit>
  ideinit();                                  // disk
80103941:	e8 1a e9 ff ff       	call   80102260 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103946:	83 c4 0c             	add    $0xc,%esp
80103949:	68 8a 00 00 00       	push   $0x8a
8010394e:	68 8c b4 10 80       	push   $0x8010b48c
80103953:	68 00 70 00 80       	push   $0x80007000
80103958:	e8 43 16 00 00       	call   80104fa0 <memmove>

  for (c = cpus; c < cpus + ncpu; c++)
8010395d:	83 c4 10             	add    $0x10,%esp
80103960:	69 05 60 9d 11 80 b0 	imul   $0xb0,0x80119d60,%eax
80103967:	00 00 00 
8010396a:	05 e0 97 11 80       	add    $0x801197e0,%eax
8010396f:	3d e0 97 11 80       	cmp    $0x801197e0,%eax
80103974:	76 7a                	jbe    801039f0 <main+0x110>
80103976:	bb e0 97 11 80       	mov    $0x801197e0,%ebx
8010397b:	eb 1c                	jmp    80103999 <main+0xb9>
8010397d:	8d 76 00             	lea    0x0(%esi),%esi
80103980:	69 05 60 9d 11 80 b0 	imul   $0xb0,0x80119d60,%eax
80103987:	00 00 00 
8010398a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103990:	05 e0 97 11 80       	add    $0x801197e0,%eax
80103995:	39 c3                	cmp    %eax,%ebx
80103997:	73 57                	jae    801039f0 <main+0x110>
  {
    if (c == mycpu()) // We've started already.
80103999:	e8 d2 07 00 00       	call   80104170 <mycpu>
8010399e:	39 c3                	cmp    %eax,%ebx
801039a0:	74 de                	je     80103980 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801039a2:	e8 89 f3 ff ff       	call   80102d30 <kalloc>
    *(void **)(code - 4) = stack + KSTACKSIZE;
    *(void (**)(void))(code - 8) = mpenter;
    *(int **)(code - 12) = (void *)V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801039a7:	83 ec 08             	sub    $0x8,%esp
    *(void (**)(void))(code - 8) = mpenter;
801039aa:	c7 05 f8 6f 00 80 c0 	movl   $0x801038c0,0x80006ff8
801039b1:	38 10 80 
    *(int **)(code - 12) = (void *)V2P(entrypgdir);
801039b4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801039bb:	a0 10 00 
    *(void **)(code - 4) = stack + KSTACKSIZE;
801039be:	05 00 10 00 00       	add    $0x1000,%eax
801039c3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801039c8:	0f b6 03             	movzbl (%ebx),%eax
801039cb:	68 00 70 00 00       	push   $0x7000
801039d0:	50                   	push   %eax
801039d1:	e8 ba f7 ff ff       	call   80103190 <lapicstartap>

    // wait for cpu to finish mpmain()
    while (c->started == 0)
801039d6:	83 c4 10             	add    $0x10,%esp
801039d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039e0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801039e6:	85 c0                	test   %eax,%eax
801039e8:	74 f6                	je     801039e0 <main+0x100>
801039ea:	eb 94                	jmp    80103980 <main+0xa0>
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
801039f0:	83 ec 08             	sub    $0x8,%esp
801039f3:	68 00 00 40 80       	push   $0x80400000
801039f8:	68 00 00 40 80       	push   $0x80400000
801039fd:	e8 9e ed ff ff       	call   801027a0 <kinit2>
  userinit();                                 // first user process
80103a02:	e8 29 08 00 00       	call   80104230 <userinit>
  mpmain();                                   // finish this processor's setup
80103a07:	e8 74 fe ff ff       	call   80103880 <mpmain>
80103a0c:	66 90                	xchg   %ax,%ax
80103a0e:	66 90                	xchg   %ax,%ax

80103a10 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	57                   	push   %edi
80103a14:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103a15:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103a1b:	53                   	push   %ebx
  e = addr+len;
80103a1c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103a1f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103a22:	39 de                	cmp    %ebx,%esi
80103a24:	72 10                	jb     80103a36 <mpsearch1+0x26>
80103a26:	eb 50                	jmp    80103a78 <mpsearch1+0x68>
80103a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a2f:	90                   	nop
80103a30:	89 fe                	mov    %edi,%esi
80103a32:	39 fb                	cmp    %edi,%ebx
80103a34:	76 42                	jbe    80103a78 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a36:	83 ec 04             	sub    $0x4,%esp
80103a39:	8d 7e 10             	lea    0x10(%esi),%edi
80103a3c:	6a 04                	push   $0x4
80103a3e:	68 38 85 10 80       	push   $0x80108538
80103a43:	56                   	push   %esi
80103a44:	e8 07 15 00 00       	call   80104f50 <memcmp>
80103a49:	83 c4 10             	add    $0x10,%esp
80103a4c:	85 c0                	test   %eax,%eax
80103a4e:	75 e0                	jne    80103a30 <mpsearch1+0x20>
80103a50:	89 f2                	mov    %esi,%edx
80103a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103a58:	0f b6 0a             	movzbl (%edx),%ecx
80103a5b:	83 c2 01             	add    $0x1,%edx
80103a5e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103a60:	39 fa                	cmp    %edi,%edx
80103a62:	75 f4                	jne    80103a58 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a64:	84 c0                	test   %al,%al
80103a66:	75 c8                	jne    80103a30 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a6b:	89 f0                	mov    %esi,%eax
80103a6d:	5b                   	pop    %ebx
80103a6e:	5e                   	pop    %esi
80103a6f:	5f                   	pop    %edi
80103a70:	5d                   	pop    %ebp
80103a71:	c3                   	ret    
80103a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103a7b:	31 f6                	xor    %esi,%esi
}
80103a7d:	5b                   	pop    %ebx
80103a7e:	89 f0                	mov    %esi,%eax
80103a80:	5e                   	pop    %esi
80103a81:	5f                   	pop    %edi
80103a82:	5d                   	pop    %ebp
80103a83:	c3                   	ret    
80103a84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a8f:	90                   	nop

80103a90 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103a90:	f3 0f 1e fb          	endbr32 
80103a94:	55                   	push   %ebp
80103a95:	89 e5                	mov    %esp,%ebp
80103a97:	57                   	push   %edi
80103a98:	56                   	push   %esi
80103a99:	53                   	push   %ebx
80103a9a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a9d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103aa4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103aab:	c1 e0 08             	shl    $0x8,%eax
80103aae:	09 d0                	or     %edx,%eax
80103ab0:	c1 e0 04             	shl    $0x4,%eax
80103ab3:	75 1b                	jne    80103ad0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103ab5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103abc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103ac3:	c1 e0 08             	shl    $0x8,%eax
80103ac6:	09 d0                	or     %edx,%eax
80103ac8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103acb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103ad0:	ba 00 04 00 00       	mov    $0x400,%edx
80103ad5:	e8 36 ff ff ff       	call   80103a10 <mpsearch1>
80103ada:	89 c6                	mov    %eax,%esi
80103adc:	85 c0                	test   %eax,%eax
80103ade:	0f 84 4c 01 00 00    	je     80103c30 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ae4:	8b 5e 04             	mov    0x4(%esi),%ebx
80103ae7:	85 db                	test   %ebx,%ebx
80103ae9:	0f 84 61 01 00 00    	je     80103c50 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80103aef:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103af2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103af8:	6a 04                	push   $0x4
80103afa:	68 3d 85 10 80       	push   $0x8010853d
80103aff:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b03:	e8 48 14 00 00       	call   80104f50 <memcmp>
80103b08:	83 c4 10             	add    $0x10,%esp
80103b0b:	85 c0                	test   %eax,%eax
80103b0d:	0f 85 3d 01 00 00    	jne    80103c50 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103b13:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103b1a:	3c 01                	cmp    $0x1,%al
80103b1c:	74 08                	je     80103b26 <mpinit+0x96>
80103b1e:	3c 04                	cmp    $0x4,%al
80103b20:	0f 85 2a 01 00 00    	jne    80103c50 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103b26:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103b2d:	66 85 d2             	test   %dx,%dx
80103b30:	74 26                	je     80103b58 <mpinit+0xc8>
80103b32:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103b35:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103b37:	31 d2                	xor    %edx,%edx
80103b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103b40:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103b47:	83 c0 01             	add    $0x1,%eax
80103b4a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103b4c:	39 f8                	cmp    %edi,%eax
80103b4e:	75 f0                	jne    80103b40 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103b50:	84 d2                	test   %dl,%dl
80103b52:	0f 85 f8 00 00 00    	jne    80103c50 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103b58:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103b5e:	a3 c0 96 11 80       	mov    %eax,0x801196c0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b63:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103b69:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103b70:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b75:	03 55 e4             	add    -0x1c(%ebp),%edx
80103b78:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b7f:	90                   	nop
80103b80:	39 c2                	cmp    %eax,%edx
80103b82:	76 15                	jbe    80103b99 <mpinit+0x109>
    switch(*p){
80103b84:	0f b6 08             	movzbl (%eax),%ecx
80103b87:	80 f9 02             	cmp    $0x2,%cl
80103b8a:	74 5c                	je     80103be8 <mpinit+0x158>
80103b8c:	77 42                	ja     80103bd0 <mpinit+0x140>
80103b8e:	84 c9                	test   %cl,%cl
80103b90:	74 6e                	je     80103c00 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103b92:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b95:	39 c2                	cmp    %eax,%edx
80103b97:	77 eb                	ja     80103b84 <mpinit+0xf4>
80103b99:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103b9c:	85 db                	test   %ebx,%ebx
80103b9e:	0f 84 b9 00 00 00    	je     80103c5d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103ba4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103ba8:	74 15                	je     80103bbf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103baa:	b8 70 00 00 00       	mov    $0x70,%eax
80103baf:	ba 22 00 00 00       	mov    $0x22,%edx
80103bb4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103bb5:	ba 23 00 00 00       	mov    $0x23,%edx
80103bba:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103bbb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bbe:	ee                   	out    %al,(%dx)
  }
}
80103bbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bc2:	5b                   	pop    %ebx
80103bc3:	5e                   	pop    %esi
80103bc4:	5f                   	pop    %edi
80103bc5:	5d                   	pop    %ebp
80103bc6:	c3                   	ret    
80103bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bce:	66 90                	xchg   %ax,%ax
    switch(*p){
80103bd0:	83 e9 03             	sub    $0x3,%ecx
80103bd3:	80 f9 01             	cmp    $0x1,%cl
80103bd6:	76 ba                	jbe    80103b92 <mpinit+0x102>
80103bd8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103bdf:	eb 9f                	jmp    80103b80 <mpinit+0xf0>
80103be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103be8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103bec:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103bef:	88 0d c0 97 11 80    	mov    %cl,0x801197c0
      continue;
80103bf5:	eb 89                	jmp    80103b80 <mpinit+0xf0>
80103bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bfe:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103c00:	8b 0d 60 9d 11 80    	mov    0x80119d60,%ecx
80103c06:	83 f9 07             	cmp    $0x7,%ecx
80103c09:	7f 19                	jg     80103c24 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c0b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103c11:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103c15:	83 c1 01             	add    $0x1,%ecx
80103c18:	89 0d 60 9d 11 80    	mov    %ecx,0x80119d60
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c1e:	88 9f e0 97 11 80    	mov    %bl,-0x7fee6820(%edi)
      p += sizeof(struct mpproc);
80103c24:	83 c0 14             	add    $0x14,%eax
      continue;
80103c27:	e9 54 ff ff ff       	jmp    80103b80 <mpinit+0xf0>
80103c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103c30:	ba 00 00 01 00       	mov    $0x10000,%edx
80103c35:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103c3a:	e8 d1 fd ff ff       	call   80103a10 <mpsearch1>
80103c3f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c41:	85 c0                	test   %eax,%eax
80103c43:	0f 85 9b fe ff ff    	jne    80103ae4 <mpinit+0x54>
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103c50:	83 ec 0c             	sub    $0xc,%esp
80103c53:	68 42 85 10 80       	push   $0x80108542
80103c58:	e8 33 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103c5d:	83 ec 0c             	sub    $0xc,%esp
80103c60:	68 5c 85 10 80       	push   $0x8010855c
80103c65:	e8 26 c7 ff ff       	call   80100390 <panic>
80103c6a:	66 90                	xchg   %ax,%ax
80103c6c:	66 90                	xchg   %ax,%ax
80103c6e:	66 90                	xchg   %ax,%ax

80103c70 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103c70:	f3 0f 1e fb          	endbr32 
80103c74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c79:	ba 21 00 00 00       	mov    $0x21,%edx
80103c7e:	ee                   	out    %al,(%dx)
80103c7f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103c84:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103c85:	c3                   	ret    
80103c86:	66 90                	xchg   %ax,%ax
80103c88:	66 90                	xchg   %ax,%ax
80103c8a:	66 90                	xchg   %ax,%ax
80103c8c:	66 90                	xchg   %ax,%ax
80103c8e:	66 90                	xchg   %ax,%ax

80103c90 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c90:	f3 0f 1e fb          	endbr32 
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	57                   	push   %edi
80103c98:	56                   	push   %esi
80103c99:	53                   	push   %ebx
80103c9a:	83 ec 0c             	sub    $0xc,%esp
80103c9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ca0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103ca3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ca9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103caf:	e8 4c d1 ff ff       	call   80100e00 <filealloc>
80103cb4:	89 03                	mov    %eax,(%ebx)
80103cb6:	85 c0                	test   %eax,%eax
80103cb8:	0f 84 ac 00 00 00    	je     80103d6a <pipealloc+0xda>
80103cbe:	e8 3d d1 ff ff       	call   80100e00 <filealloc>
80103cc3:	89 06                	mov    %eax,(%esi)
80103cc5:	85 c0                	test   %eax,%eax
80103cc7:	0f 84 8b 00 00 00    	je     80103d58 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103ccd:	e8 5e f0 ff ff       	call   80102d30 <kalloc>
80103cd2:	89 c7                	mov    %eax,%edi
80103cd4:	85 c0                	test   %eax,%eax
80103cd6:	0f 84 b4 00 00 00    	je     80103d90 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103cdc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103ce3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103ce6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103ce9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103cf0:	00 00 00 
  p->nwrite = 0;
80103cf3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cfa:	00 00 00 
  p->nread = 0;
80103cfd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d04:	00 00 00 
  initlock(&p->lock, "pipe");
80103d07:	68 7b 85 10 80       	push   $0x8010857b
80103d0c:	50                   	push   %eax
80103d0d:	e8 5e 0f 00 00       	call   80104c70 <initlock>
  (*f0)->type = FD_PIPE;
80103d12:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103d14:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103d17:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d1d:	8b 03                	mov    (%ebx),%eax
80103d1f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d23:	8b 03                	mov    (%ebx),%eax
80103d25:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d29:	8b 03                	mov    (%ebx),%eax
80103d2b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d2e:	8b 06                	mov    (%esi),%eax
80103d30:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d36:	8b 06                	mov    (%esi),%eax
80103d38:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d3c:	8b 06                	mov    (%esi),%eax
80103d3e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d42:	8b 06                	mov    (%esi),%eax
80103d44:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103d47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103d4a:	31 c0                	xor    %eax,%eax
}
80103d4c:	5b                   	pop    %ebx
80103d4d:	5e                   	pop    %esi
80103d4e:	5f                   	pop    %edi
80103d4f:	5d                   	pop    %ebp
80103d50:	c3                   	ret    
80103d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103d58:	8b 03                	mov    (%ebx),%eax
80103d5a:	85 c0                	test   %eax,%eax
80103d5c:	74 1e                	je     80103d7c <pipealloc+0xec>
    fileclose(*f0);
80103d5e:	83 ec 0c             	sub    $0xc,%esp
80103d61:	50                   	push   %eax
80103d62:	e8 59 d1 ff ff       	call   80100ec0 <fileclose>
80103d67:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103d6a:	8b 06                	mov    (%esi),%eax
80103d6c:	85 c0                	test   %eax,%eax
80103d6e:	74 0c                	je     80103d7c <pipealloc+0xec>
    fileclose(*f1);
80103d70:	83 ec 0c             	sub    $0xc,%esp
80103d73:	50                   	push   %eax
80103d74:	e8 47 d1 ff ff       	call   80100ec0 <fileclose>
80103d79:	83 c4 10             	add    $0x10,%esp
}
80103d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103d7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d84:	5b                   	pop    %ebx
80103d85:	5e                   	pop    %esi
80103d86:	5f                   	pop    %edi
80103d87:	5d                   	pop    %ebp
80103d88:	c3                   	ret    
80103d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103d90:	8b 03                	mov    (%ebx),%eax
80103d92:	85 c0                	test   %eax,%eax
80103d94:	75 c8                	jne    80103d5e <pipealloc+0xce>
80103d96:	eb d2                	jmp    80103d6a <pipealloc+0xda>
80103d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d9f:	90                   	nop

80103da0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103da0:	f3 0f 1e fb          	endbr32 
80103da4:	55                   	push   %ebp
80103da5:	89 e5                	mov    %esp,%ebp
80103da7:	56                   	push   %esi
80103da8:	53                   	push   %ebx
80103da9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103dac:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103daf:	83 ec 0c             	sub    $0xc,%esp
80103db2:	53                   	push   %ebx
80103db3:	e8 38 10 00 00       	call   80104df0 <acquire>
  if(writable){
80103db8:	83 c4 10             	add    $0x10,%esp
80103dbb:	85 f6                	test   %esi,%esi
80103dbd:	74 41                	je     80103e00 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103dbf:	83 ec 0c             	sub    $0xc,%esp
80103dc2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103dc8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103dcf:	00 00 00 
    wakeup(&p->nread);
80103dd2:	50                   	push   %eax
80103dd3:	e8 98 0b 00 00       	call   80104970 <wakeup>
80103dd8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103ddb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103de1:	85 d2                	test   %edx,%edx
80103de3:	75 0a                	jne    80103def <pipeclose+0x4f>
80103de5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103deb:	85 c0                	test   %eax,%eax
80103ded:	74 31                	je     80103e20 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103def:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103df5:	5b                   	pop    %ebx
80103df6:	5e                   	pop    %esi
80103df7:	5d                   	pop    %ebp
    release(&p->lock);
80103df8:	e9 b3 10 00 00       	jmp    80104eb0 <release>
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103e00:	83 ec 0c             	sub    $0xc,%esp
80103e03:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103e09:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103e10:	00 00 00 
    wakeup(&p->nwrite);
80103e13:	50                   	push   %eax
80103e14:	e8 57 0b 00 00       	call   80104970 <wakeup>
80103e19:	83 c4 10             	add    $0x10,%esp
80103e1c:	eb bd                	jmp    80103ddb <pipeclose+0x3b>
80103e1e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103e20:	83 ec 0c             	sub    $0xc,%esp
80103e23:	53                   	push   %ebx
80103e24:	e8 87 10 00 00       	call   80104eb0 <release>
    kfree((char*)p);
80103e29:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103e2c:	83 c4 10             	add    $0x10,%esp
}
80103e2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e32:	5b                   	pop    %ebx
80103e33:	5e                   	pop    %esi
80103e34:	5d                   	pop    %ebp
    kfree((char*)p);
80103e35:	e9 46 e7 ff ff       	jmp    80102580 <kfree>
80103e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e40 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e40:	f3 0f 1e fb          	endbr32 
80103e44:	55                   	push   %ebp
80103e45:	89 e5                	mov    %esp,%ebp
80103e47:	57                   	push   %edi
80103e48:	56                   	push   %esi
80103e49:	53                   	push   %ebx
80103e4a:	83 ec 28             	sub    $0x28,%esp
80103e4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103e50:	53                   	push   %ebx
80103e51:	e8 9a 0f 00 00       	call   80104df0 <acquire>
  for(i = 0; i < n; i++){
80103e56:	8b 45 10             	mov    0x10(%ebp),%eax
80103e59:	83 c4 10             	add    $0x10,%esp
80103e5c:	85 c0                	test   %eax,%eax
80103e5e:	0f 8e bc 00 00 00    	jle    80103f20 <pipewrite+0xe0>
80103e64:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e67:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103e6d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103e73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e76:	03 45 10             	add    0x10(%ebp),%eax
80103e79:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e7c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e82:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e88:	89 ca                	mov    %ecx,%edx
80103e8a:	05 00 02 00 00       	add    $0x200,%eax
80103e8f:	39 c1                	cmp    %eax,%ecx
80103e91:	74 3b                	je     80103ece <pipewrite+0x8e>
80103e93:	eb 63                	jmp    80103ef8 <pipewrite+0xb8>
80103e95:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103e98:	e8 63 03 00 00       	call   80104200 <myproc>
80103e9d:	8b 48 24             	mov    0x24(%eax),%ecx
80103ea0:	85 c9                	test   %ecx,%ecx
80103ea2:	75 34                	jne    80103ed8 <pipewrite+0x98>
      wakeup(&p->nread);
80103ea4:	83 ec 0c             	sub    $0xc,%esp
80103ea7:	57                   	push   %edi
80103ea8:	e8 c3 0a 00 00       	call   80104970 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ead:	58                   	pop    %eax
80103eae:	5a                   	pop    %edx
80103eaf:	53                   	push   %ebx
80103eb0:	56                   	push   %esi
80103eb1:	e8 fa 08 00 00       	call   801047b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103eb6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103ebc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103ec2:	83 c4 10             	add    $0x10,%esp
80103ec5:	05 00 02 00 00       	add    $0x200,%eax
80103eca:	39 c2                	cmp    %eax,%edx
80103ecc:	75 2a                	jne    80103ef8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103ece:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103ed4:	85 c0                	test   %eax,%eax
80103ed6:	75 c0                	jne    80103e98 <pipewrite+0x58>
        release(&p->lock);
80103ed8:	83 ec 0c             	sub    $0xc,%esp
80103edb:	53                   	push   %ebx
80103edc:	e8 cf 0f 00 00       	call   80104eb0 <release>
        return -1;
80103ee1:	83 c4 10             	add    $0x10,%esp
80103ee4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eec:	5b                   	pop    %ebx
80103eed:	5e                   	pop    %esi
80103eee:	5f                   	pop    %edi
80103eef:	5d                   	pop    %ebp
80103ef0:	c3                   	ret    
80103ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ef8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103efb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103efe:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103f04:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103f0a:	0f b6 06             	movzbl (%esi),%eax
80103f0d:	83 c6 01             	add    $0x1,%esi
80103f10:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103f13:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103f17:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103f1a:	0f 85 5c ff ff ff    	jne    80103e7c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f20:	83 ec 0c             	sub    $0xc,%esp
80103f23:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103f29:	50                   	push   %eax
80103f2a:	e8 41 0a 00 00       	call   80104970 <wakeup>
  release(&p->lock);
80103f2f:	89 1c 24             	mov    %ebx,(%esp)
80103f32:	e8 79 0f 00 00       	call   80104eb0 <release>
  return n;
80103f37:	8b 45 10             	mov    0x10(%ebp),%eax
80103f3a:	83 c4 10             	add    $0x10,%esp
80103f3d:	eb aa                	jmp    80103ee9 <pipewrite+0xa9>
80103f3f:	90                   	nop

80103f40 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f40:	f3 0f 1e fb          	endbr32 
80103f44:	55                   	push   %ebp
80103f45:	89 e5                	mov    %esp,%ebp
80103f47:	57                   	push   %edi
80103f48:	56                   	push   %esi
80103f49:	53                   	push   %ebx
80103f4a:	83 ec 18             	sub    $0x18,%esp
80103f4d:	8b 75 08             	mov    0x8(%ebp),%esi
80103f50:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103f53:	56                   	push   %esi
80103f54:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103f5a:	e8 91 0e 00 00       	call   80104df0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f5f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103f65:	83 c4 10             	add    $0x10,%esp
80103f68:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103f6e:	74 33                	je     80103fa3 <piperead+0x63>
80103f70:	eb 3b                	jmp    80103fad <piperead+0x6d>
80103f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103f78:	e8 83 02 00 00       	call   80104200 <myproc>
80103f7d:	8b 48 24             	mov    0x24(%eax),%ecx
80103f80:	85 c9                	test   %ecx,%ecx
80103f82:	0f 85 88 00 00 00    	jne    80104010 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f88:	83 ec 08             	sub    $0x8,%esp
80103f8b:	56                   	push   %esi
80103f8c:	53                   	push   %ebx
80103f8d:	e8 1e 08 00 00       	call   801047b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f92:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103f98:	83 c4 10             	add    $0x10,%esp
80103f9b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103fa1:	75 0a                	jne    80103fad <piperead+0x6d>
80103fa3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103fa9:	85 c0                	test   %eax,%eax
80103fab:	75 cb                	jne    80103f78 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fad:	8b 55 10             	mov    0x10(%ebp),%edx
80103fb0:	31 db                	xor    %ebx,%ebx
80103fb2:	85 d2                	test   %edx,%edx
80103fb4:	7f 28                	jg     80103fde <piperead+0x9e>
80103fb6:	eb 34                	jmp    80103fec <piperead+0xac>
80103fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fbf:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103fc0:	8d 48 01             	lea    0x1(%eax),%ecx
80103fc3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103fc8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103fce:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103fd3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fd6:	83 c3 01             	add    $0x1,%ebx
80103fd9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103fdc:	74 0e                	je     80103fec <piperead+0xac>
    if(p->nread == p->nwrite)
80103fde:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103fe4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103fea:	75 d4                	jne    80103fc0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fec:	83 ec 0c             	sub    $0xc,%esp
80103fef:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103ff5:	50                   	push   %eax
80103ff6:	e8 75 09 00 00       	call   80104970 <wakeup>
  release(&p->lock);
80103ffb:	89 34 24             	mov    %esi,(%esp)
80103ffe:	e8 ad 0e 00 00       	call   80104eb0 <release>
  return i;
80104003:	83 c4 10             	add    $0x10,%esp
}
80104006:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104009:	89 d8                	mov    %ebx,%eax
8010400b:	5b                   	pop    %ebx
8010400c:	5e                   	pop    %esi
8010400d:	5f                   	pop    %edi
8010400e:	5d                   	pop    %ebp
8010400f:	c3                   	ret    
      release(&p->lock);
80104010:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104013:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104018:	56                   	push   %esi
80104019:	e8 92 0e 00 00       	call   80104eb0 <release>
      return -1;
8010401e:	83 c4 10             	add    $0x10,%esp
}
80104021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104024:	89 d8                	mov    %ebx,%eax
80104026:	5b                   	pop    %ebx
80104027:	5e                   	pop    %esi
80104028:	5f                   	pop    %edi
80104029:	5d                   	pop    %ebp
8010402a:	c3                   	ret    
8010402b:	66 90                	xchg   %ax,%ax
8010402d:	66 90                	xchg   %ax,%ax
8010402f:	90                   	nop

80104030 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104034:	bb b4 9d 11 80       	mov    $0x80119db4,%ebx
{
80104039:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010403c:	68 80 9d 11 80       	push   $0x80119d80
80104041:	e8 aa 0d 00 00       	call   80104df0 <acquire>
80104046:	83 c4 10             	add    $0x10,%esp
80104049:	eb 10                	jmp    8010405b <allocproc+0x2b>
8010404b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010404f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104050:	83 c3 7c             	add    $0x7c,%ebx
80104053:	81 fb b4 bc 11 80    	cmp    $0x8011bcb4,%ebx
80104059:	74 75                	je     801040d0 <allocproc+0xa0>
    if (p->state == UNUSED)
8010405b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010405e:	85 c0                	test   %eax,%eax
80104060:	75 ee                	jne    80104050 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104062:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80104067:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010406a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104071:	89 43 10             	mov    %eax,0x10(%ebx)
80104074:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104077:	68 80 9d 11 80       	push   $0x80119d80
  p->pid = nextpid++;
8010407c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104082:	e8 29 0e 00 00       	call   80104eb0 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
80104087:	e8 a4 ec ff ff       	call   80102d30 <kalloc>
8010408c:	83 c4 10             	add    $0x10,%esp
8010408f:	89 43 08             	mov    %eax,0x8(%ebx)
80104092:	85 c0                	test   %eax,%eax
80104094:	74 53                	je     801040e9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104096:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
8010409c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010409f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801040a4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
801040a7:	c7 40 14 36 62 10 80 	movl   $0x80106236,0x14(%eax)
  p->context = (struct context *)sp;
801040ae:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801040b1:	6a 14                	push   $0x14
801040b3:	6a 00                	push   $0x0
801040b5:	50                   	push   %eax
801040b6:	e8 45 0e 00 00       	call   80104f00 <memset>
  p->context->eip = (uint)forkret;
801040bb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801040be:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801040c1:	c7 40 10 00 41 10 80 	movl   $0x80104100,0x10(%eax)
}
801040c8:	89 d8                	mov    %ebx,%eax
801040ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040cd:	c9                   	leave  
801040ce:	c3                   	ret    
801040cf:	90                   	nop
  release(&ptable.lock);
801040d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801040d3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801040d5:	68 80 9d 11 80       	push   $0x80119d80
801040da:	e8 d1 0d 00 00       	call   80104eb0 <release>
}
801040df:	89 d8                	mov    %ebx,%eax
  return 0;
801040e1:	83 c4 10             	add    $0x10,%esp
}
801040e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040e7:	c9                   	leave  
801040e8:	c3                   	ret    
    p->state = UNUSED;
801040e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801040f0:	31 db                	xor    %ebx,%ebx
}
801040f2:	89 d8                	mov    %ebx,%eax
801040f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f7:	c9                   	leave  
801040f8:	c3                   	ret    
801040f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104100 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010410a:	68 80 9d 11 80       	push   $0x80119d80
8010410f:	e8 9c 0d 00 00       	call   80104eb0 <release>

  if (first)
80104114:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104119:	83 c4 10             	add    $0x10,%esp
8010411c:	85 c0                	test   %eax,%eax
8010411e:	75 08                	jne    80104128 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104120:	c9                   	leave  
80104121:	c3                   	ret    
80104122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104128:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010412f:	00 00 00 
    iinit(ROOTDEV);
80104132:	83 ec 0c             	sub    $0xc,%esp
80104135:	6a 01                	push   $0x1
80104137:	e8 04 d4 ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
8010413c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104143:	e8 e8 f3 ff ff       	call   80103530 <initlog>
}
80104148:	83 c4 10             	add    $0x10,%esp
8010414b:	c9                   	leave  
8010414c:	c3                   	ret    
8010414d:	8d 76 00             	lea    0x0(%esi),%esi

80104150 <pinit>:
{
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010415a:	68 80 85 10 80       	push   $0x80108580
8010415f:	68 80 9d 11 80       	push   $0x80119d80
80104164:	e8 07 0b 00 00       	call   80104c70 <initlock>
}
80104169:	83 c4 10             	add    $0x10,%esp
8010416c:	c9                   	leave  
8010416d:	c3                   	ret    
8010416e:	66 90                	xchg   %ax,%ax

80104170 <mycpu>:
{
80104170:	f3 0f 1e fb          	endbr32 
80104174:	55                   	push   %ebp
80104175:	89 e5                	mov    %esp,%ebp
80104177:	56                   	push   %esi
80104178:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104179:	9c                   	pushf  
8010417a:	58                   	pop    %eax
  if (readeflags() & FL_IF)
8010417b:	f6 c4 02             	test   $0x2,%ah
8010417e:	75 4a                	jne    801041ca <mycpu+0x5a>
  apicid = lapicid();
80104180:	e8 bb ef ff ff       	call   80103140 <lapicid>
  for (i = 0; i < ncpu; ++i)
80104185:	8b 35 60 9d 11 80    	mov    0x80119d60,%esi
  apicid = lapicid();
8010418b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i)
8010418d:	85 f6                	test   %esi,%esi
8010418f:	7e 2c                	jle    801041bd <mycpu+0x4d>
80104191:	31 d2                	xor    %edx,%edx
80104193:	eb 0a                	jmp    8010419f <mycpu+0x2f>
80104195:	8d 76 00             	lea    0x0(%esi),%esi
80104198:	83 c2 01             	add    $0x1,%edx
8010419b:	39 f2                	cmp    %esi,%edx
8010419d:	74 1e                	je     801041bd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010419f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801041a5:	0f b6 81 e0 97 11 80 	movzbl -0x7fee6820(%ecx),%eax
801041ac:	39 d8                	cmp    %ebx,%eax
801041ae:	75 e8                	jne    80104198 <mycpu+0x28>
}
801041b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801041b3:	8d 81 e0 97 11 80    	lea    -0x7fee6820(%ecx),%eax
}
801041b9:	5b                   	pop    %ebx
801041ba:	5e                   	pop    %esi
801041bb:	5d                   	pop    %ebp
801041bc:	c3                   	ret    
  panic("unknown apicid\n");
801041bd:	83 ec 0c             	sub    $0xc,%esp
801041c0:	68 87 85 10 80       	push   $0x80108587
801041c5:	e8 c6 c1 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801041ca:	83 ec 0c             	sub    $0xc,%esp
801041cd:	68 60 86 10 80       	push   $0x80108660
801041d2:	e8 b9 c1 ff ff       	call   80100390 <panic>
801041d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041de:	66 90                	xchg   %ax,%ax

801041e0 <cpuid>:
{
801041e0:	f3 0f 1e fb          	endbr32 
801041e4:	55                   	push   %ebp
801041e5:	89 e5                	mov    %esp,%ebp
801041e7:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
801041ea:	e8 81 ff ff ff       	call   80104170 <mycpu>
}
801041ef:	c9                   	leave  
  return mycpu() - cpus;
801041f0:	2d e0 97 11 80       	sub    $0x801197e0,%eax
801041f5:	c1 f8 04             	sar    $0x4,%eax
801041f8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801041fe:	c3                   	ret    
801041ff:	90                   	nop

80104200 <myproc>:
{
80104200:	f3 0f 1e fb          	endbr32 
80104204:	55                   	push   %ebp
80104205:	89 e5                	mov    %esp,%ebp
80104207:	53                   	push   %ebx
80104208:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010420b:	e8 e0 0a 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
80104210:	e8 5b ff ff ff       	call   80104170 <mycpu>
  p = c->proc;
80104215:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010421b:	e8 20 0b 00 00       	call   80104d40 <popcli>
}
80104220:	83 c4 04             	add    $0x4,%esp
80104223:	89 d8                	mov    %ebx,%eax
80104225:	5b                   	pop    %ebx
80104226:	5d                   	pop    %ebp
80104227:	c3                   	ret    
80104228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010422f:	90                   	nop

80104230 <userinit>:
{
80104230:	f3 0f 1e fb          	endbr32 
80104234:	55                   	push   %ebp
80104235:	89 e5                	mov    %esp,%ebp
80104237:	53                   	push   %ebx
80104238:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010423b:	e8 f0 fd ff ff       	call   80104030 <allocproc>
80104240:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104242:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if ((p->pgdir = setupkvm()) == 0)
80104247:	e8 64 36 00 00       	call   801078b0 <setupkvm>
8010424c:	89 43 04             	mov    %eax,0x4(%ebx)
8010424f:	85 c0                	test   %eax,%eax
80104251:	0f 84 d6 00 00 00    	je     8010432d <userinit+0xfd>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
80104257:	83 ec 04             	sub    $0x4,%esp
8010425a:	68 2c 00 00 00       	push   $0x2c
8010425f:	68 60 b4 10 80       	push   $0x8010b460
80104264:	68 b0 85 10 80       	push   $0x801085b0
80104269:	e8 42 c4 ff ff       	call   801006b0 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010426e:	83 c4 0c             	add    $0xc,%esp
80104271:	68 2c 00 00 00       	push   $0x2c
80104276:	68 60 b4 10 80       	push   $0x8010b460
8010427b:	ff 73 04             	pushl  0x4(%ebx)
8010427e:	e8 dd 32 00 00       	call   80107560 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104283:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104286:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010428c:	6a 4c                	push   $0x4c
8010428e:	6a 00                	push   $0x0
80104290:	ff 73 18             	pushl  0x18(%ebx)
80104293:	e8 68 0c 00 00       	call   80104f00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104298:	8b 43 18             	mov    0x18(%ebx),%eax
8010429b:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801042a0:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042a3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042a8:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042ac:	8b 43 18             	mov    0x18(%ebx),%eax
801042af:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801042b3:	8b 43 18             	mov    0x18(%ebx),%eax
801042b6:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801042ba:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801042be:	8b 43 18             	mov    0x18(%ebx),%eax
801042c1:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801042c5:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801042c9:	8b 43 18             	mov    0x18(%ebx),%eax
801042cc:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801042d3:	8b 43 18             	mov    0x18(%ebx),%eax
801042d6:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
801042dd:	8b 43 18             	mov    0x18(%ebx),%eax
801042e0:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801042e7:	8d 43 6c             	lea    0x6c(%ebx),%eax
801042ea:	6a 10                	push   $0x10
801042ec:	68 b7 85 10 80       	push   $0x801085b7
801042f1:	50                   	push   %eax
801042f2:	e8 c9 0d 00 00       	call   801050c0 <safestrcpy>
  p->cwd = namei("/");
801042f7:	c7 04 24 c0 85 10 80 	movl   $0x801085c0,(%esp)
801042fe:	e8 2d dd ff ff       	call   80102030 <namei>
80104303:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104306:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
8010430d:	e8 de 0a 00 00       	call   80104df0 <acquire>
  p->state = RUNNABLE;
80104312:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104319:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
80104320:	e8 8b 0b 00 00       	call   80104eb0 <release>
}
80104325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104328:	83 c4 10             	add    $0x10,%esp
8010432b:	c9                   	leave  
8010432c:	c3                   	ret    
    panic("userinit: out of memory?");
8010432d:	83 ec 0c             	sub    $0xc,%esp
80104330:	68 97 85 10 80       	push   $0x80108597
80104335:	e8 56 c0 ff ff       	call   80100390 <panic>
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <growproc>:
{
80104340:	f3 0f 1e fb          	endbr32 
80104344:	55                   	push   %ebp
80104345:	89 e5                	mov    %esp,%ebp
80104347:	56                   	push   %esi
80104348:	53                   	push   %ebx
80104349:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010434c:	e8 9f 09 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
80104351:	e8 1a fe ff ff       	call   80104170 <mycpu>
  p = c->proc;
80104356:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010435c:	e8 df 09 00 00       	call   80104d40 <popcli>
  sz = curproc->sz;
80104361:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80104363:	85 f6                	test   %esi,%esi
80104365:	7f 19                	jg     80104380 <growproc+0x40>
  else if (n < 0)
80104367:	75 37                	jne    801043a0 <growproc+0x60>
  switchuvm(curproc);
80104369:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010436c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010436e:	53                   	push   %ebx
8010436f:	e8 dc 30 00 00       	call   80107450 <switchuvm>
  return 0;
80104374:	83 c4 10             	add    $0x10,%esp
80104377:	31 c0                	xor    %eax,%eax
}
80104379:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010437c:	5b                   	pop    %ebx
8010437d:	5e                   	pop    %esi
8010437e:	5d                   	pop    %ebp
8010437f:	c3                   	ret    
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104380:	83 ec 04             	sub    $0x4,%esp
80104383:	01 c6                	add    %eax,%esi
80104385:	56                   	push   %esi
80104386:	50                   	push   %eax
80104387:	ff 73 04             	pushl  0x4(%ebx)
8010438a:	e8 31 33 00 00       	call   801076c0 <allocuvm>
8010438f:	83 c4 10             	add    $0x10,%esp
80104392:	85 c0                	test   %eax,%eax
80104394:	75 d3                	jne    80104369 <growproc+0x29>
      return -1;
80104396:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010439b:	eb dc                	jmp    80104379 <growproc+0x39>
8010439d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043a0:	83 ec 04             	sub    $0x4,%esp
801043a3:	01 c6                	add    %eax,%esi
801043a5:	56                   	push   %esi
801043a6:	50                   	push   %eax
801043a7:	ff 73 04             	pushl  0x4(%ebx)
801043aa:	e8 51 34 00 00       	call   80107800 <deallocuvm>
801043af:	83 c4 10             	add    $0x10,%esp
801043b2:	85 c0                	test   %eax,%eax
801043b4:	75 b3                	jne    80104369 <growproc+0x29>
801043b6:	eb de                	jmp    80104396 <growproc+0x56>
801043b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043bf:	90                   	nop

801043c0 <fork>:
{
801043c0:	f3 0f 1e fb          	endbr32 
801043c4:	55                   	push   %ebp
801043c5:	89 e5                	mov    %esp,%ebp
801043c7:	57                   	push   %edi
801043c8:	56                   	push   %esi
801043c9:	53                   	push   %ebx
801043ca:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801043cd:	e8 1e 09 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
801043d2:	e8 99 fd ff ff       	call   80104170 <mycpu>
  p = c->proc;
801043d7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043dd:	e8 5e 09 00 00       	call   80104d40 <popcli>
  if ((np = allocproc()) == 0)
801043e2:	e8 49 fc ff ff       	call   80104030 <allocproc>
801043e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043ea:	85 c0                	test   %eax,%eax
801043ec:	0f 84 bb 00 00 00    	je     801044ad <fork+0xed>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
801043f2:	83 ec 08             	sub    $0x8,%esp
801043f5:	ff 33                	pushl  (%ebx)
801043f7:	89 c7                	mov    %eax,%edi
801043f9:	ff 73 04             	pushl  0x4(%ebx)
801043fc:	e8 7f 35 00 00       	call   80107980 <copyuvm>
80104401:	83 c4 10             	add    $0x10,%esp
80104404:	89 47 04             	mov    %eax,0x4(%edi)
80104407:	85 c0                	test   %eax,%eax
80104409:	0f 84 a5 00 00 00    	je     801044b4 <fork+0xf4>
  np->sz = curproc->sz;
8010440f:	8b 03                	mov    (%ebx),%eax
80104411:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104414:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104416:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104419:	89 c8                	mov    %ecx,%eax
8010441b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010441e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104423:	8b 73 18             	mov    0x18(%ebx),%esi
80104426:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80104428:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010442a:	8b 40 18             	mov    0x18(%eax),%eax
8010442d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
80104434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[i])
80104438:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010443c:	85 c0                	test   %eax,%eax
8010443e:	74 13                	je     80104453 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	50                   	push   %eax
80104444:	e8 27 ca ff ff       	call   80100e70 <filedup>
80104449:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010444c:	83 c4 10             	add    $0x10,%esp
8010444f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80104453:	83 c6 01             	add    $0x1,%esi
80104456:	83 fe 10             	cmp    $0x10,%esi
80104459:	75 dd                	jne    80104438 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010445b:	83 ec 0c             	sub    $0xc,%esp
8010445e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104461:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104464:	e8 c7 d2 ff ff       	call   80101730 <idup>
80104469:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010446c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010446f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104472:	8d 47 6c             	lea    0x6c(%edi),%eax
80104475:	6a 10                	push   $0x10
80104477:	53                   	push   %ebx
80104478:	50                   	push   %eax
80104479:	e8 42 0c 00 00       	call   801050c0 <safestrcpy>
  pid = np->pid;
8010447e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104481:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
80104488:	e8 63 09 00 00       	call   80104df0 <acquire>
  np->state = RUNNABLE;
8010448d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104494:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
8010449b:	e8 10 0a 00 00       	call   80104eb0 <release>
  return pid;
801044a0:	83 c4 10             	add    $0x10,%esp
}
801044a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044a6:	89 d8                	mov    %ebx,%eax
801044a8:	5b                   	pop    %ebx
801044a9:	5e                   	pop    %esi
801044aa:	5f                   	pop    %edi
801044ab:	5d                   	pop    %ebp
801044ac:	c3                   	ret    
    return -1;
801044ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801044b2:	eb ef                	jmp    801044a3 <fork+0xe3>
    kfree(np->kstack);
801044b4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801044b7:	83 ec 0c             	sub    $0xc,%esp
801044ba:	ff 73 08             	pushl  0x8(%ebx)
801044bd:	e8 be e0 ff ff       	call   80102580 <kfree>
    np->kstack = 0;
801044c2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801044c9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801044cc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801044d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801044d8:	eb c9                	jmp    801044a3 <fork+0xe3>
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <scheduler>:
{
801044e0:	f3 0f 1e fb          	endbr32 
801044e4:	55                   	push   %ebp
801044e5:	89 e5                	mov    %esp,%ebp
801044e7:	57                   	push   %edi
801044e8:	56                   	push   %esi
801044e9:	53                   	push   %ebx
801044ea:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801044ed:	e8 7e fc ff ff       	call   80104170 <mycpu>
  c->proc = 0;
801044f2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801044f9:	00 00 00 
  struct cpu *c = mycpu();
801044fc:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801044fe:	8d 78 04             	lea    0x4(%eax),%edi
80104501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104508:	fb                   	sti    
    acquire(&ptable.lock);
80104509:	83 ec 0c             	sub    $0xc,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010450c:	bb b4 9d 11 80       	mov    $0x80119db4,%ebx
    acquire(&ptable.lock);
80104511:	68 80 9d 11 80       	push   $0x80119d80
80104516:	e8 d5 08 00 00       	call   80104df0 <acquire>
8010451b:	83 c4 10             	add    $0x10,%esp
8010451e:	66 90                	xchg   %ax,%ax
      if (p->state != RUNNABLE)
80104520:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104524:	75 33                	jne    80104559 <scheduler+0x79>
      switchuvm(p);
80104526:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104529:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010452f:	53                   	push   %ebx
80104530:	e8 1b 2f 00 00       	call   80107450 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104535:	58                   	pop    %eax
80104536:	5a                   	pop    %edx
80104537:	ff 73 1c             	pushl  0x1c(%ebx)
8010453a:	57                   	push   %edi
      p->state = RUNNING;
8010453b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104542:	e8 dc 0b 00 00       	call   80105123 <swtch>
      switchkvm();
80104547:	e8 e4 2e 00 00       	call   80107430 <switchkvm>
      c->proc = 0;
8010454c:	83 c4 10             	add    $0x10,%esp
8010454f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104556:	00 00 00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104559:	83 c3 7c             	add    $0x7c,%ebx
8010455c:	81 fb b4 bc 11 80    	cmp    $0x8011bcb4,%ebx
80104562:	75 bc                	jne    80104520 <scheduler+0x40>
    release(&ptable.lock);
80104564:	83 ec 0c             	sub    $0xc,%esp
80104567:	68 80 9d 11 80       	push   $0x80119d80
8010456c:	e8 3f 09 00 00       	call   80104eb0 <release>
    sti();
80104571:	83 c4 10             	add    $0x10,%esp
80104574:	eb 92                	jmp    80104508 <scheduler+0x28>
80104576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457d:	8d 76 00             	lea    0x0(%esi),%esi

80104580 <sched>:
{
80104580:	f3 0f 1e fb          	endbr32 
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	56                   	push   %esi
80104588:	53                   	push   %ebx
  pushcli();
80104589:	e8 62 07 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
8010458e:	e8 dd fb ff ff       	call   80104170 <mycpu>
  p = c->proc;
80104593:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104599:	e8 a2 07 00 00       	call   80104d40 <popcli>
  if (!holding(&ptable.lock))
8010459e:	83 ec 0c             	sub    $0xc,%esp
801045a1:	68 80 9d 11 80       	push   $0x80119d80
801045a6:	e8 f5 07 00 00       	call   80104da0 <holding>
801045ab:	83 c4 10             	add    $0x10,%esp
801045ae:	85 c0                	test   %eax,%eax
801045b0:	74 41                	je     801045f3 <sched+0x73>
  if (p->state == RUNNING)
801045b2:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801045b6:	74 55                	je     8010460d <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045b8:	9c                   	pushf  
801045b9:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801045ba:	f6 c4 02             	test   $0x2,%ah
801045bd:	75 41                	jne    80104600 <sched+0x80>
  intena = mycpu()->intena;
801045bf:	e8 ac fb ff ff       	call   80104170 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801045c4:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801045c7:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801045cd:	e8 9e fb ff ff       	call   80104170 <mycpu>
801045d2:	83 ec 08             	sub    $0x8,%esp
801045d5:	ff 70 04             	pushl  0x4(%eax)
801045d8:	53                   	push   %ebx
801045d9:	e8 45 0b 00 00       	call   80105123 <swtch>
  mycpu()->intena = intena;
801045de:	e8 8d fb ff ff       	call   80104170 <mycpu>
}
801045e3:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801045e6:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801045ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045ef:	5b                   	pop    %ebx
801045f0:	5e                   	pop    %esi
801045f1:	5d                   	pop    %ebp
801045f2:	c3                   	ret    
    panic("sched ptable.lock");
801045f3:	83 ec 0c             	sub    $0xc,%esp
801045f6:	68 c2 85 10 80       	push   $0x801085c2
801045fb:	e8 90 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80104600:	83 ec 0c             	sub    $0xc,%esp
80104603:	68 e2 85 10 80       	push   $0x801085e2
80104608:	e8 83 bd ff ff       	call   80100390 <panic>
    panic("sched running");
8010460d:	83 ec 0c             	sub    $0xc,%esp
80104610:	68 d4 85 10 80       	push   $0x801085d4
80104615:	e8 76 bd ff ff       	call   80100390 <panic>
8010461a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104620 <exit>:
{
80104620:	f3 0f 1e fb          	endbr32 
80104624:	55                   	push   %ebp
80104625:	89 e5                	mov    %esp,%ebp
80104627:	57                   	push   %edi
80104628:	56                   	push   %esi
80104629:	53                   	push   %ebx
8010462a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010462d:	e8 be 06 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
80104632:	e8 39 fb ff ff       	call   80104170 <mycpu>
  p = c->proc;
80104637:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010463d:	e8 fe 06 00 00       	call   80104d40 <popcli>
  if (curproc == initproc)
80104642:	8d 5e 28             	lea    0x28(%esi),%ebx
80104645:	8d 7e 68             	lea    0x68(%esi),%edi
80104648:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010464e:	0f 84 f3 00 00 00    	je     80104747 <exit+0x127>
80104654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd])
80104658:	8b 03                	mov    (%ebx),%eax
8010465a:	85 c0                	test   %eax,%eax
8010465c:	74 12                	je     80104670 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010465e:	83 ec 0c             	sub    $0xc,%esp
80104661:	50                   	push   %eax
80104662:	e8 59 c8 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104667:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010466d:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80104670:	83 c3 04             	add    $0x4,%ebx
80104673:	39 df                	cmp    %ebx,%edi
80104675:	75 e1                	jne    80104658 <exit+0x38>
  begin_op();
80104677:	e8 54 ef ff ff       	call   801035d0 <begin_op>
  iput(curproc->cwd);
8010467c:	83 ec 0c             	sub    $0xc,%esp
8010467f:	ff 76 68             	pushl  0x68(%esi)
80104682:	e8 09 d2 ff ff       	call   80101890 <iput>
  end_op();
80104687:	e8 b4 ef ff ff       	call   80103640 <end_op>
  curproc->cwd = 0;
8010468c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104693:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
8010469a:	e8 51 07 00 00       	call   80104df0 <acquire>
  wakeup1(curproc->parent);
8010469f:	8b 56 14             	mov    0x14(%esi),%edx
801046a2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046a5:	b8 b4 9d 11 80       	mov    $0x80119db4,%eax
801046aa:	eb 0e                	jmp    801046ba <exit+0x9a>
801046ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b0:	83 c0 7c             	add    $0x7c,%eax
801046b3:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
801046b8:	74 1c                	je     801046d6 <exit+0xb6>
    if (p->state == SLEEPING && p->chan == chan)
801046ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046be:	75 f0                	jne    801046b0 <exit+0x90>
801046c0:	3b 50 20             	cmp    0x20(%eax),%edx
801046c3:	75 eb                	jne    801046b0 <exit+0x90>
      p->state = RUNNABLE;
801046c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046cc:	83 c0 7c             	add    $0x7c,%eax
801046cf:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
801046d4:	75 e4                	jne    801046ba <exit+0x9a>
      p->parent = initproc;
801046d6:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046dc:	ba b4 9d 11 80       	mov    $0x80119db4,%edx
801046e1:	eb 10                	jmp    801046f3 <exit+0xd3>
801046e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e7:	90                   	nop
801046e8:	83 c2 7c             	add    $0x7c,%edx
801046eb:	81 fa b4 bc 11 80    	cmp    $0x8011bcb4,%edx
801046f1:	74 3b                	je     8010472e <exit+0x10e>
    if (p->parent == curproc)
801046f3:	39 72 14             	cmp    %esi,0x14(%edx)
801046f6:	75 f0                	jne    801046e8 <exit+0xc8>
      if (p->state == ZOMBIE)
801046f8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801046fc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
801046ff:	75 e7                	jne    801046e8 <exit+0xc8>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104701:	b8 b4 9d 11 80       	mov    $0x80119db4,%eax
80104706:	eb 12                	jmp    8010471a <exit+0xfa>
80104708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop
80104710:	83 c0 7c             	add    $0x7c,%eax
80104713:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
80104718:	74 ce                	je     801046e8 <exit+0xc8>
    if (p->state == SLEEPING && p->chan == chan)
8010471a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010471e:	75 f0                	jne    80104710 <exit+0xf0>
80104720:	3b 48 20             	cmp    0x20(%eax),%ecx
80104723:	75 eb                	jne    80104710 <exit+0xf0>
      p->state = RUNNABLE;
80104725:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010472c:	eb e2                	jmp    80104710 <exit+0xf0>
  curproc->state = ZOMBIE;
8010472e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104735:	e8 46 fe ff ff       	call   80104580 <sched>
  panic("zombie exit");
8010473a:	83 ec 0c             	sub    $0xc,%esp
8010473d:	68 03 86 10 80       	push   $0x80108603
80104742:	e8 49 bc ff ff       	call   80100390 <panic>
    panic("init exiting");
80104747:	83 ec 0c             	sub    $0xc,%esp
8010474a:	68 f6 85 10 80       	push   $0x801085f6
8010474f:	e8 3c bc ff ff       	call   80100390 <panic>
80104754:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010475f:	90                   	nop

80104760 <yield>:
{
80104760:	f3 0f 1e fb          	endbr32 
80104764:	55                   	push   %ebp
80104765:	89 e5                	mov    %esp,%ebp
80104767:	53                   	push   %ebx
80104768:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
8010476b:	68 80 9d 11 80       	push   $0x80119d80
80104770:	e8 7b 06 00 00       	call   80104df0 <acquire>
  pushcli();
80104775:	e8 76 05 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
8010477a:	e8 f1 f9 ff ff       	call   80104170 <mycpu>
  p = c->proc;
8010477f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104785:	e8 b6 05 00 00       	call   80104d40 <popcli>
  myproc()->state = RUNNABLE;
8010478a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104791:	e8 ea fd ff ff       	call   80104580 <sched>
  release(&ptable.lock);
80104796:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
8010479d:	e8 0e 07 00 00       	call   80104eb0 <release>
}
801047a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047a5:	83 c4 10             	add    $0x10,%esp
801047a8:	c9                   	leave  
801047a9:	c3                   	ret    
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047b0 <sleep>:
{
801047b0:	f3 0f 1e fb          	endbr32 
801047b4:	55                   	push   %ebp
801047b5:	89 e5                	mov    %esp,%ebp
801047b7:	57                   	push   %edi
801047b8:	56                   	push   %esi
801047b9:	53                   	push   %ebx
801047ba:	83 ec 0c             	sub    $0xc,%esp
801047bd:	8b 7d 08             	mov    0x8(%ebp),%edi
801047c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801047c3:	e8 28 05 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
801047c8:	e8 a3 f9 ff ff       	call   80104170 <mycpu>
  p = c->proc;
801047cd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047d3:	e8 68 05 00 00       	call   80104d40 <popcli>
  if (p == 0)
801047d8:	85 db                	test   %ebx,%ebx
801047da:	0f 84 83 00 00 00    	je     80104863 <sleep+0xb3>
  if (lk == 0)
801047e0:	85 f6                	test   %esi,%esi
801047e2:	74 72                	je     80104856 <sleep+0xa6>
  if (lk != &ptable.lock)
801047e4:	81 fe 80 9d 11 80    	cmp    $0x80119d80,%esi
801047ea:	74 4c                	je     80104838 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
801047ec:	83 ec 0c             	sub    $0xc,%esp
801047ef:	68 80 9d 11 80       	push   $0x80119d80
801047f4:	e8 f7 05 00 00       	call   80104df0 <acquire>
    release(lk);
801047f9:	89 34 24             	mov    %esi,(%esp)
801047fc:	e8 af 06 00 00       	call   80104eb0 <release>
  p->chan = chan;
80104801:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104804:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010480b:	e8 70 fd ff ff       	call   80104580 <sched>
  p->chan = 0;
80104810:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104817:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
8010481e:	e8 8d 06 00 00       	call   80104eb0 <release>
    acquire(lk);
80104823:	89 75 08             	mov    %esi,0x8(%ebp)
80104826:	83 c4 10             	add    $0x10,%esp
}
80104829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010482c:	5b                   	pop    %ebx
8010482d:	5e                   	pop    %esi
8010482e:	5f                   	pop    %edi
8010482f:	5d                   	pop    %ebp
    acquire(lk);
80104830:	e9 bb 05 00 00       	jmp    80104df0 <acquire>
80104835:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104838:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010483b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104842:	e8 39 fd ff ff       	call   80104580 <sched>
  p->chan = 0;
80104847:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010484e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104851:	5b                   	pop    %ebx
80104852:	5e                   	pop    %esi
80104853:	5f                   	pop    %edi
80104854:	5d                   	pop    %ebp
80104855:	c3                   	ret    
    panic("sleep without lk");
80104856:	83 ec 0c             	sub    $0xc,%esp
80104859:	68 15 86 10 80       	push   $0x80108615
8010485e:	e8 2d bb ff ff       	call   80100390 <panic>
    panic("sleep");
80104863:	83 ec 0c             	sub    $0xc,%esp
80104866:	68 0f 86 10 80       	push   $0x8010860f
8010486b:	e8 20 bb ff ff       	call   80100390 <panic>

80104870 <wait>:
{
80104870:	f3 0f 1e fb          	endbr32 
80104874:	55                   	push   %ebp
80104875:	89 e5                	mov    %esp,%ebp
80104877:	56                   	push   %esi
80104878:	53                   	push   %ebx
  pushcli();
80104879:	e8 72 04 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
8010487e:	e8 ed f8 ff ff       	call   80104170 <mycpu>
  p = c->proc;
80104883:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104889:	e8 b2 04 00 00       	call   80104d40 <popcli>
  acquire(&ptable.lock);
8010488e:	83 ec 0c             	sub    $0xc,%esp
80104891:	68 80 9d 11 80       	push   $0x80119d80
80104896:	e8 55 05 00 00       	call   80104df0 <acquire>
8010489b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010489e:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048a0:	bb b4 9d 11 80       	mov    $0x80119db4,%ebx
801048a5:	eb 14                	jmp    801048bb <wait+0x4b>
801048a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ae:	66 90                	xchg   %ax,%ax
801048b0:	83 c3 7c             	add    $0x7c,%ebx
801048b3:	81 fb b4 bc 11 80    	cmp    $0x8011bcb4,%ebx
801048b9:	74 1b                	je     801048d6 <wait+0x66>
      if (p->parent != curproc)
801048bb:	39 73 14             	cmp    %esi,0x14(%ebx)
801048be:	75 f0                	jne    801048b0 <wait+0x40>
      if (p->state == ZOMBIE)
801048c0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801048c4:	74 32                	je     801048f8 <wait+0x88>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048c6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801048c9:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048ce:	81 fb b4 bc 11 80    	cmp    $0x8011bcb4,%ebx
801048d4:	75 e5                	jne    801048bb <wait+0x4b>
    if (!havekids || curproc->killed)
801048d6:	85 c0                	test   %eax,%eax
801048d8:	74 74                	je     8010494e <wait+0xde>
801048da:	8b 46 24             	mov    0x24(%esi),%eax
801048dd:	85 c0                	test   %eax,%eax
801048df:	75 6d                	jne    8010494e <wait+0xde>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
801048e1:	83 ec 08             	sub    $0x8,%esp
801048e4:	68 80 9d 11 80       	push   $0x80119d80
801048e9:	56                   	push   %esi
801048ea:	e8 c1 fe ff ff       	call   801047b0 <sleep>
    havekids = 0;
801048ef:	83 c4 10             	add    $0x10,%esp
801048f2:	eb aa                	jmp    8010489e <wait+0x2e>
801048f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801048f8:	83 ec 0c             	sub    $0xc,%esp
801048fb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801048fe:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104901:	e8 7a dc ff ff       	call   80102580 <kfree>
        freevm(p->pgdir);
80104906:	5a                   	pop    %edx
80104907:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010490a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104911:	e8 1a 2f 00 00       	call   80107830 <freevm>
        release(&ptable.lock);
80104916:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
        p->pid = 0;
8010491d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104924:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010492b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010492f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104936:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010493d:	e8 6e 05 00 00       	call   80104eb0 <release>
        return pid;
80104942:	83 c4 10             	add    $0x10,%esp
}
80104945:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104948:	89 f0                	mov    %esi,%eax
8010494a:	5b                   	pop    %ebx
8010494b:	5e                   	pop    %esi
8010494c:	5d                   	pop    %ebp
8010494d:	c3                   	ret    
      release(&ptable.lock);
8010494e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104951:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104956:	68 80 9d 11 80       	push   $0x80119d80
8010495b:	e8 50 05 00 00       	call   80104eb0 <release>
      return -1;
80104960:	83 c4 10             	add    $0x10,%esp
80104963:	eb e0                	jmp    80104945 <wait+0xd5>
80104965:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104970 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104970:	f3 0f 1e fb          	endbr32 
80104974:	55                   	push   %ebp
80104975:	89 e5                	mov    %esp,%ebp
80104977:	53                   	push   %ebx
80104978:	83 ec 10             	sub    $0x10,%esp
8010497b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010497e:	68 80 9d 11 80       	push   $0x80119d80
80104983:	e8 68 04 00 00       	call   80104df0 <acquire>
80104988:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010498b:	b8 b4 9d 11 80       	mov    $0x80119db4,%eax
80104990:	eb 10                	jmp    801049a2 <wakeup+0x32>
80104992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104998:	83 c0 7c             	add    $0x7c,%eax
8010499b:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
801049a0:	74 1c                	je     801049be <wakeup+0x4e>
    if (p->state == SLEEPING && p->chan == chan)
801049a2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049a6:	75 f0                	jne    80104998 <wakeup+0x28>
801049a8:	3b 58 20             	cmp    0x20(%eax),%ebx
801049ab:	75 eb                	jne    80104998 <wakeup+0x28>
      p->state = RUNNABLE;
801049ad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049b4:	83 c0 7c             	add    $0x7c,%eax
801049b7:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
801049bc:	75 e4                	jne    801049a2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
801049be:	c7 45 08 80 9d 11 80 	movl   $0x80119d80,0x8(%ebp)
}
801049c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049c8:	c9                   	leave  
  release(&ptable.lock);
801049c9:	e9 e2 04 00 00       	jmp    80104eb0 <release>
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
801049d0:	f3 0f 1e fb          	endbr32 
801049d4:	55                   	push   %ebp
801049d5:	89 e5                	mov    %esp,%ebp
801049d7:	53                   	push   %ebx
801049d8:	83 ec 10             	sub    $0x10,%esp
801049db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801049de:	68 80 9d 11 80       	push   $0x80119d80
801049e3:	e8 08 04 00 00       	call   80104df0 <acquire>
801049e8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049eb:	b8 b4 9d 11 80       	mov    $0x80119db4,%eax
801049f0:	eb 10                	jmp    80104a02 <kill+0x32>
801049f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049f8:	83 c0 7c             	add    $0x7c,%eax
801049fb:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
80104a00:	74 36                	je     80104a38 <kill+0x68>
  {
    if (p->pid == pid)
80104a02:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a05:	75 f1                	jne    801049f8 <kill+0x28>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104a07:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104a0b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
80104a12:	75 07                	jne    80104a1b <kill+0x4b>
        p->state = RUNNABLE;
80104a14:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104a1b:	83 ec 0c             	sub    $0xc,%esp
80104a1e:	68 80 9d 11 80       	push   $0x80119d80
80104a23:	e8 88 04 00 00       	call   80104eb0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104a28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104a2b:	83 c4 10             	add    $0x10,%esp
80104a2e:	31 c0                	xor    %eax,%eax
}
80104a30:	c9                   	leave  
80104a31:	c3                   	ret    
80104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104a38:	83 ec 0c             	sub    $0xc,%esp
80104a3b:	68 80 9d 11 80       	push   $0x80119d80
80104a40:	e8 6b 04 00 00       	call   80104eb0 <release>
}
80104a45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104a48:	83 c4 10             	add    $0x10,%esp
80104a4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a50:	c9                   	leave  
80104a51:	c3                   	ret    
80104a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a60 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	57                   	push   %edi
80104a68:	56                   	push   %esi
80104a69:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104a6c:	53                   	push   %ebx
80104a6d:	bb 20 9e 11 80       	mov    $0x80119e20,%ebx
80104a72:	83 ec 3c             	sub    $0x3c,%esp
80104a75:	eb 28                	jmp    80104a9f <procdump+0x3f>
80104a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7e:	66 90                	xchg   %ax,%ax
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104a80:	83 ec 0c             	sub    $0xc,%esp
80104a83:	68 01 8a 10 80       	push   $0x80108a01
80104a88:	e8 23 bc ff ff       	call   801006b0 <cprintf>
80104a8d:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a90:	83 c3 7c             	add    $0x7c,%ebx
80104a93:	81 fb 20 bd 11 80    	cmp    $0x8011bd20,%ebx
80104a99:	0f 84 81 00 00 00    	je     80104b20 <procdump+0xc0>
    if (p->state == UNUSED)
80104a9f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104aa2:	85 c0                	test   %eax,%eax
80104aa4:	74 ea                	je     80104a90 <procdump+0x30>
      state = "???";
80104aa6:	ba 26 86 10 80       	mov    $0x80108626,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104aab:	83 f8 05             	cmp    $0x5,%eax
80104aae:	77 11                	ja     80104ac1 <procdump+0x61>
80104ab0:	8b 14 85 88 86 10 80 	mov    -0x7fef7978(,%eax,4),%edx
      state = "???";
80104ab7:	b8 26 86 10 80       	mov    $0x80108626,%eax
80104abc:	85 d2                	test   %edx,%edx
80104abe:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104ac1:	53                   	push   %ebx
80104ac2:	52                   	push   %edx
80104ac3:	ff 73 a4             	pushl  -0x5c(%ebx)
80104ac6:	68 2a 86 10 80       	push   $0x8010862a
80104acb:	e8 e0 bb ff ff       	call   801006b0 <cprintf>
    if (p->state == SLEEPING)
80104ad0:	83 c4 10             	add    $0x10,%esp
80104ad3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104ad7:	75 a7                	jne    80104a80 <procdump+0x20>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104ad9:	83 ec 08             	sub    $0x8,%esp
80104adc:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104adf:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104ae2:	50                   	push   %eax
80104ae3:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104ae6:	8b 40 0c             	mov    0xc(%eax),%eax
80104ae9:	83 c0 08             	add    $0x8,%eax
80104aec:	50                   	push   %eax
80104aed:	e8 9e 01 00 00       	call   80104c90 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104af2:	83 c4 10             	add    $0x10,%esp
80104af5:	8d 76 00             	lea    0x0(%esi),%esi
80104af8:	8b 17                	mov    (%edi),%edx
80104afa:	85 d2                	test   %edx,%edx
80104afc:	74 82                	je     80104a80 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104afe:	83 ec 08             	sub    $0x8,%esp
80104b01:	83 c7 04             	add    $0x4,%edi
80104b04:	52                   	push   %edx
80104b05:	68 a1 7b 10 80       	push   $0x80107ba1
80104b0a:	e8 a1 bb ff ff       	call   801006b0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104b0f:	83 c4 10             	add    $0x10,%esp
80104b12:	39 fe                	cmp    %edi,%esi
80104b14:	75 e2                	jne    80104af8 <procdump+0x98>
80104b16:	e9 65 ff ff ff       	jmp    80104a80 <procdump+0x20>
80104b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b1f:	90                   	nop
  }
}
80104b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b23:	5b                   	pop    %ebx
80104b24:	5e                   	pop    %esi
80104b25:	5f                   	pop    %edi
80104b26:	5d                   	pop    %ebp
80104b27:	c3                   	ret    
80104b28:	66 90                	xchg   %ax,%ax
80104b2a:	66 90                	xchg   %ax,%ax
80104b2c:	66 90                	xchg   %ax,%ax
80104b2e:	66 90                	xchg   %ax,%ax

80104b30 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b30:	f3 0f 1e fb          	endbr32 
80104b34:	55                   	push   %ebp
80104b35:	89 e5                	mov    %esp,%ebp
80104b37:	53                   	push   %ebx
80104b38:	83 ec 0c             	sub    $0xc,%esp
80104b3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b3e:	68 a0 86 10 80       	push   $0x801086a0
80104b43:	8d 43 04             	lea    0x4(%ebx),%eax
80104b46:	50                   	push   %eax
80104b47:	e8 24 01 00 00       	call   80104c70 <initlock>
  lk->name = name;
80104b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b55:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b58:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b5f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b65:	c9                   	leave  
80104b66:	c3                   	ret    
80104b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6e:	66 90                	xchg   %ax,%ax

80104b70 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b70:	f3 0f 1e fb          	endbr32 
80104b74:	55                   	push   %ebp
80104b75:	89 e5                	mov    %esp,%ebp
80104b77:	56                   	push   %esi
80104b78:	53                   	push   %ebx
80104b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b7c:	8d 73 04             	lea    0x4(%ebx),%esi
80104b7f:	83 ec 0c             	sub    $0xc,%esp
80104b82:	56                   	push   %esi
80104b83:	e8 68 02 00 00       	call   80104df0 <acquire>
  while (lk->locked) {
80104b88:	8b 13                	mov    (%ebx),%edx
80104b8a:	83 c4 10             	add    $0x10,%esp
80104b8d:	85 d2                	test   %edx,%edx
80104b8f:	74 1a                	je     80104bab <acquiresleep+0x3b>
80104b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104b98:	83 ec 08             	sub    $0x8,%esp
80104b9b:	56                   	push   %esi
80104b9c:	53                   	push   %ebx
80104b9d:	e8 0e fc ff ff       	call   801047b0 <sleep>
  while (lk->locked) {
80104ba2:	8b 03                	mov    (%ebx),%eax
80104ba4:	83 c4 10             	add    $0x10,%esp
80104ba7:	85 c0                	test   %eax,%eax
80104ba9:	75 ed                	jne    80104b98 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104bab:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104bb1:	e8 4a f6 ff ff       	call   80104200 <myproc>
80104bb6:	8b 40 10             	mov    0x10(%eax),%eax
80104bb9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104bbc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104bbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bc2:	5b                   	pop    %ebx
80104bc3:	5e                   	pop    %esi
80104bc4:	5d                   	pop    %ebp
  release(&lk->lk);
80104bc5:	e9 e6 02 00 00       	jmp    80104eb0 <release>
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bd0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104bd0:	f3 0f 1e fb          	endbr32 
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	56                   	push   %esi
80104bd8:	53                   	push   %ebx
80104bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bdc:	8d 73 04             	lea    0x4(%ebx),%esi
80104bdf:	83 ec 0c             	sub    $0xc,%esp
80104be2:	56                   	push   %esi
80104be3:	e8 08 02 00 00       	call   80104df0 <acquire>
  lk->locked = 0;
80104be8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104bee:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104bf5:	89 1c 24             	mov    %ebx,(%esp)
80104bf8:	e8 73 fd ff ff       	call   80104970 <wakeup>
  release(&lk->lk);
80104bfd:	89 75 08             	mov    %esi,0x8(%ebp)
80104c00:	83 c4 10             	add    $0x10,%esp
}
80104c03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c06:	5b                   	pop    %ebx
80104c07:	5e                   	pop    %esi
80104c08:	5d                   	pop    %ebp
  release(&lk->lk);
80104c09:	e9 a2 02 00 00       	jmp    80104eb0 <release>
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c10:	f3 0f 1e fb          	endbr32 
80104c14:	55                   	push   %ebp
80104c15:	89 e5                	mov    %esp,%ebp
80104c17:	57                   	push   %edi
80104c18:	31 ff                	xor    %edi,%edi
80104c1a:	56                   	push   %esi
80104c1b:	53                   	push   %ebx
80104c1c:	83 ec 18             	sub    $0x18,%esp
80104c1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104c22:	8d 73 04             	lea    0x4(%ebx),%esi
80104c25:	56                   	push   %esi
80104c26:	e8 c5 01 00 00       	call   80104df0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c2b:	8b 03                	mov    (%ebx),%eax
80104c2d:	83 c4 10             	add    $0x10,%esp
80104c30:	85 c0                	test   %eax,%eax
80104c32:	75 1c                	jne    80104c50 <holdingsleep+0x40>
  release(&lk->lk);
80104c34:	83 ec 0c             	sub    $0xc,%esp
80104c37:	56                   	push   %esi
80104c38:	e8 73 02 00 00       	call   80104eb0 <release>
  return r;
}
80104c3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c40:	89 f8                	mov    %edi,%eax
80104c42:	5b                   	pop    %ebx
80104c43:	5e                   	pop    %esi
80104c44:	5f                   	pop    %edi
80104c45:	5d                   	pop    %ebp
80104c46:	c3                   	ret    
80104c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104c50:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c53:	e8 a8 f5 ff ff       	call   80104200 <myproc>
80104c58:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c5b:	0f 94 c0             	sete   %al
80104c5e:	0f b6 c0             	movzbl %al,%eax
80104c61:	89 c7                	mov    %eax,%edi
80104c63:	eb cf                	jmp    80104c34 <holdingsleep+0x24>
80104c65:	66 90                	xchg   %ax,%ax
80104c67:	66 90                	xchg   %ax,%ax
80104c69:	66 90                	xchg   %ax,%ax
80104c6b:	66 90                	xchg   %ax,%ax
80104c6d:	66 90                	xchg   %ax,%ax
80104c6f:	90                   	nop

80104c70 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c83:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c8d:	5d                   	pop    %ebp
80104c8e:	c3                   	ret    
80104c8f:	90                   	nop

80104c90 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c95:	31 d2                	xor    %edx,%edx
{
80104c97:	89 e5                	mov    %esp,%ebp
80104c99:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c9a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104ca0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104ca3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ca7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ca8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104cae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cb4:	77 1a                	ja     80104cd0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cb6:	8b 58 04             	mov    0x4(%eax),%ebx
80104cb9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104cbc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104cbf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104cc1:	83 fa 0a             	cmp    $0xa,%edx
80104cc4:	75 e2                	jne    80104ca8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104cc6:	5b                   	pop    %ebx
80104cc7:	5d                   	pop    %ebp
80104cc8:	c3                   	ret    
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104cd0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104cd3:	8d 51 28             	lea    0x28(%ecx),%edx
80104cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104ce0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ce6:	83 c0 04             	add    $0x4,%eax
80104ce9:	39 d0                	cmp    %edx,%eax
80104ceb:	75 f3                	jne    80104ce0 <getcallerpcs+0x50>
}
80104ced:	5b                   	pop    %ebx
80104cee:	5d                   	pop    %ebp
80104cef:	c3                   	ret    

80104cf0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104cf0:	f3 0f 1e fb          	endbr32 
80104cf4:	55                   	push   %ebp
80104cf5:	89 e5                	mov    %esp,%ebp
80104cf7:	53                   	push   %ebx
80104cf8:	83 ec 04             	sub    $0x4,%esp
80104cfb:	9c                   	pushf  
80104cfc:	5b                   	pop    %ebx
  asm volatile("cli");
80104cfd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104cfe:	e8 6d f4 ff ff       	call   80104170 <mycpu>
80104d03:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d09:	85 c0                	test   %eax,%eax
80104d0b:	74 13                	je     80104d20 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104d0d:	e8 5e f4 ff ff       	call   80104170 <mycpu>
80104d12:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d19:	83 c4 04             	add    $0x4,%esp
80104d1c:	5b                   	pop    %ebx
80104d1d:	5d                   	pop    %ebp
80104d1e:	c3                   	ret    
80104d1f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104d20:	e8 4b f4 ff ff       	call   80104170 <mycpu>
80104d25:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d2b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104d31:	eb da                	jmp    80104d0d <pushcli+0x1d>
80104d33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d40 <popcli>:

void
popcli(void)
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
80104d45:	89 e5                	mov    %esp,%ebp
80104d47:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d4a:	9c                   	pushf  
80104d4b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d4c:	f6 c4 02             	test   $0x2,%ah
80104d4f:	75 31                	jne    80104d82 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d51:	e8 1a f4 ff ff       	call   80104170 <mycpu>
80104d56:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d5d:	78 30                	js     80104d8f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d5f:	e8 0c f4 ff ff       	call   80104170 <mycpu>
80104d64:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d6a:	85 d2                	test   %edx,%edx
80104d6c:	74 02                	je     80104d70 <popcli+0x30>
    sti();
}
80104d6e:	c9                   	leave  
80104d6f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d70:	e8 fb f3 ff ff       	call   80104170 <mycpu>
80104d75:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d7b:	85 c0                	test   %eax,%eax
80104d7d:	74 ef                	je     80104d6e <popcli+0x2e>
  asm volatile("sti");
80104d7f:	fb                   	sti    
}
80104d80:	c9                   	leave  
80104d81:	c3                   	ret    
    panic("popcli - interruptible");
80104d82:	83 ec 0c             	sub    $0xc,%esp
80104d85:	68 ab 86 10 80       	push   $0x801086ab
80104d8a:	e8 01 b6 ff ff       	call   80100390 <panic>
    panic("popcli");
80104d8f:	83 ec 0c             	sub    $0xc,%esp
80104d92:	68 c2 86 10 80       	push   $0x801086c2
80104d97:	e8 f4 b5 ff ff       	call   80100390 <panic>
80104d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104da0 <holding>:
{
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	56                   	push   %esi
80104da8:	53                   	push   %ebx
80104da9:	8b 75 08             	mov    0x8(%ebp),%esi
80104dac:	31 db                	xor    %ebx,%ebx
  pushcli();
80104dae:	e8 3d ff ff ff       	call   80104cf0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104db3:	8b 06                	mov    (%esi),%eax
80104db5:	85 c0                	test   %eax,%eax
80104db7:	75 0f                	jne    80104dc8 <holding+0x28>
  popcli();
80104db9:	e8 82 ff ff ff       	call   80104d40 <popcli>
}
80104dbe:	89 d8                	mov    %ebx,%eax
80104dc0:	5b                   	pop    %ebx
80104dc1:	5e                   	pop    %esi
80104dc2:	5d                   	pop    %ebp
80104dc3:	c3                   	ret    
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104dc8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104dcb:	e8 a0 f3 ff ff       	call   80104170 <mycpu>
80104dd0:	39 c3                	cmp    %eax,%ebx
80104dd2:	0f 94 c3             	sete   %bl
  popcli();
80104dd5:	e8 66 ff ff ff       	call   80104d40 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104dda:	0f b6 db             	movzbl %bl,%ebx
}
80104ddd:	89 d8                	mov    %ebx,%eax
80104ddf:	5b                   	pop    %ebx
80104de0:	5e                   	pop    %esi
80104de1:	5d                   	pop    %ebp
80104de2:	c3                   	ret    
80104de3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104df0 <acquire>:
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
80104df5:	89 e5                	mov    %esp,%ebp
80104df7:	56                   	push   %esi
80104df8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104df9:	e8 f2 fe ff ff       	call   80104cf0 <pushcli>
  if(holding(lk))
80104dfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e01:	83 ec 0c             	sub    $0xc,%esp
80104e04:	53                   	push   %ebx
80104e05:	e8 96 ff ff ff       	call   80104da0 <holding>
80104e0a:	83 c4 10             	add    $0x10,%esp
80104e0d:	85 c0                	test   %eax,%eax
80104e0f:	0f 85 7f 00 00 00    	jne    80104e94 <acquire+0xa4>
80104e15:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e17:	ba 01 00 00 00       	mov    $0x1,%edx
80104e1c:	eb 05                	jmp    80104e23 <acquire+0x33>
80104e1e:	66 90                	xchg   %ax,%ax
80104e20:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e23:	89 d0                	mov    %edx,%eax
80104e25:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104e28:	85 c0                	test   %eax,%eax
80104e2a:	75 f4                	jne    80104e20 <acquire+0x30>
  __sync_synchronize();
80104e2c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e34:	e8 37 f3 ff ff       	call   80104170 <mycpu>
80104e39:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104e3c:	89 e8                	mov    %ebp,%eax
80104e3e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e40:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104e46:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104e4c:	77 22                	ja     80104e70 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104e4e:	8b 50 04             	mov    0x4(%eax),%edx
80104e51:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104e55:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104e58:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e5a:	83 fe 0a             	cmp    $0xa,%esi
80104e5d:	75 e1                	jne    80104e40 <acquire+0x50>
}
80104e5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e62:	5b                   	pop    %ebx
80104e63:	5e                   	pop    %esi
80104e64:	5d                   	pop    %ebp
80104e65:	c3                   	ret    
80104e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104e70:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104e74:	83 c3 34             	add    $0x34,%ebx
80104e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e86:	83 c0 04             	add    $0x4,%eax
80104e89:	39 d8                	cmp    %ebx,%eax
80104e8b:	75 f3                	jne    80104e80 <acquire+0x90>
}
80104e8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e90:	5b                   	pop    %ebx
80104e91:	5e                   	pop    %esi
80104e92:	5d                   	pop    %ebp
80104e93:	c3                   	ret    
    panic("acquire");
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	68 c9 86 10 80       	push   $0x801086c9
80104e9c:	e8 ef b4 ff ff       	call   80100390 <panic>
80104ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eaf:	90                   	nop

80104eb0 <release>:
{
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	53                   	push   %ebx
80104eb8:	83 ec 10             	sub    $0x10,%esp
80104ebb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104ebe:	53                   	push   %ebx
80104ebf:	e8 dc fe ff ff       	call   80104da0 <holding>
80104ec4:	83 c4 10             	add    $0x10,%esp
80104ec7:	85 c0                	test   %eax,%eax
80104ec9:	74 22                	je     80104eed <release+0x3d>
  lk->pcs[0] = 0;
80104ecb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104ed2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ed9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104ede:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ee7:	c9                   	leave  
  popcli();
80104ee8:	e9 53 fe ff ff       	jmp    80104d40 <popcli>
    panic("release");
80104eed:	83 ec 0c             	sub    $0xc,%esp
80104ef0:	68 d1 86 10 80       	push   $0x801086d1
80104ef5:	e8 96 b4 ff ff       	call   80100390 <panic>
80104efa:	66 90                	xchg   %ax,%ax
80104efc:	66 90                	xchg   %ax,%ax
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	57                   	push   %edi
80104f08:	8b 55 08             	mov    0x8(%ebp),%edx
80104f0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f0e:	53                   	push   %ebx
80104f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104f12:	89 d7                	mov    %edx,%edi
80104f14:	09 cf                	or     %ecx,%edi
80104f16:	83 e7 03             	and    $0x3,%edi
80104f19:	75 25                	jne    80104f40 <memset+0x40>
    c &= 0xFF;
80104f1b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f1e:	c1 e0 18             	shl    $0x18,%eax
80104f21:	89 fb                	mov    %edi,%ebx
80104f23:	c1 e9 02             	shr    $0x2,%ecx
80104f26:	c1 e3 10             	shl    $0x10,%ebx
80104f29:	09 d8                	or     %ebx,%eax
80104f2b:	09 f8                	or     %edi,%eax
80104f2d:	c1 e7 08             	shl    $0x8,%edi
80104f30:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f32:	89 d7                	mov    %edx,%edi
80104f34:	fc                   	cld    
80104f35:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104f37:	5b                   	pop    %ebx
80104f38:	89 d0                	mov    %edx,%eax
80104f3a:	5f                   	pop    %edi
80104f3b:	5d                   	pop    %ebp
80104f3c:	c3                   	ret    
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104f40:	89 d7                	mov    %edx,%edi
80104f42:	fc                   	cld    
80104f43:	f3 aa                	rep stos %al,%es:(%edi)
80104f45:	5b                   	pop    %ebx
80104f46:	89 d0                	mov    %edx,%eax
80104f48:	5f                   	pop    %edi
80104f49:	5d                   	pop    %ebp
80104f4a:	c3                   	ret    
80104f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f4f:	90                   	nop

80104f50 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	56                   	push   %esi
80104f58:	8b 75 10             	mov    0x10(%ebp),%esi
80104f5b:	8b 55 08             	mov    0x8(%ebp),%edx
80104f5e:	53                   	push   %ebx
80104f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f62:	85 f6                	test   %esi,%esi
80104f64:	74 2a                	je     80104f90 <memcmp+0x40>
80104f66:	01 c6                	add    %eax,%esi
80104f68:	eb 10                	jmp    80104f7a <memcmp+0x2a>
80104f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104f70:	83 c0 01             	add    $0x1,%eax
80104f73:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104f76:	39 f0                	cmp    %esi,%eax
80104f78:	74 16                	je     80104f90 <memcmp+0x40>
    if(*s1 != *s2)
80104f7a:	0f b6 0a             	movzbl (%edx),%ecx
80104f7d:	0f b6 18             	movzbl (%eax),%ebx
80104f80:	38 d9                	cmp    %bl,%cl
80104f82:	74 ec                	je     80104f70 <memcmp+0x20>
      return *s1 - *s2;
80104f84:	0f b6 c1             	movzbl %cl,%eax
80104f87:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104f89:	5b                   	pop    %ebx
80104f8a:	5e                   	pop    %esi
80104f8b:	5d                   	pop    %ebp
80104f8c:	c3                   	ret    
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi
80104f90:	5b                   	pop    %ebx
  return 0;
80104f91:	31 c0                	xor    %eax,%eax
}
80104f93:	5e                   	pop    %esi
80104f94:	5d                   	pop    %ebp
80104f95:	c3                   	ret    
80104f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi

80104fa0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104fa0:	f3 0f 1e fb          	endbr32 
80104fa4:	55                   	push   %ebp
80104fa5:	89 e5                	mov    %esp,%ebp
80104fa7:	57                   	push   %edi
80104fa8:	8b 55 08             	mov    0x8(%ebp),%edx
80104fab:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104fae:	56                   	push   %esi
80104faf:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fb2:	39 d6                	cmp    %edx,%esi
80104fb4:	73 2a                	jae    80104fe0 <memmove+0x40>
80104fb6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104fb9:	39 fa                	cmp    %edi,%edx
80104fbb:	73 23                	jae    80104fe0 <memmove+0x40>
80104fbd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104fc0:	85 c9                	test   %ecx,%ecx
80104fc2:	74 13                	je     80104fd7 <memmove+0x37>
80104fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104fc8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104fcc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104fcf:	83 e8 01             	sub    $0x1,%eax
80104fd2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104fd5:	75 f1                	jne    80104fc8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104fd7:	5e                   	pop    %esi
80104fd8:	89 d0                	mov    %edx,%eax
80104fda:	5f                   	pop    %edi
80104fdb:	5d                   	pop    %ebp
80104fdc:	c3                   	ret    
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104fe0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104fe3:	89 d7                	mov    %edx,%edi
80104fe5:	85 c9                	test   %ecx,%ecx
80104fe7:	74 ee                	je     80104fd7 <memmove+0x37>
80104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104ff0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104ff1:	39 f0                	cmp    %esi,%eax
80104ff3:	75 fb                	jne    80104ff0 <memmove+0x50>
}
80104ff5:	5e                   	pop    %esi
80104ff6:	89 d0                	mov    %edx,%eax
80104ff8:	5f                   	pop    %edi
80104ff9:	5d                   	pop    %ebp
80104ffa:	c3                   	ret    
80104ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fff:	90                   	nop

80105000 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105000:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105004:	eb 9a                	jmp    80104fa0 <memmove>
80105006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500d:	8d 76 00             	lea    0x0(%esi),%esi

80105010 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105010:	f3 0f 1e fb          	endbr32 
80105014:	55                   	push   %ebp
80105015:	89 e5                	mov    %esp,%ebp
80105017:	56                   	push   %esi
80105018:	8b 75 10             	mov    0x10(%ebp),%esi
8010501b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010501e:	53                   	push   %ebx
8010501f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105022:	85 f6                	test   %esi,%esi
80105024:	74 32                	je     80105058 <strncmp+0x48>
80105026:	01 c6                	add    %eax,%esi
80105028:	eb 14                	jmp    8010503e <strncmp+0x2e>
8010502a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105030:	38 da                	cmp    %bl,%dl
80105032:	75 14                	jne    80105048 <strncmp+0x38>
    n--, p++, q++;
80105034:	83 c0 01             	add    $0x1,%eax
80105037:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010503a:	39 f0                	cmp    %esi,%eax
8010503c:	74 1a                	je     80105058 <strncmp+0x48>
8010503e:	0f b6 11             	movzbl (%ecx),%edx
80105041:	0f b6 18             	movzbl (%eax),%ebx
80105044:	84 d2                	test   %dl,%dl
80105046:	75 e8                	jne    80105030 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105048:	0f b6 c2             	movzbl %dl,%eax
8010504b:	29 d8                	sub    %ebx,%eax
}
8010504d:	5b                   	pop    %ebx
8010504e:	5e                   	pop    %esi
8010504f:	5d                   	pop    %ebp
80105050:	c3                   	ret    
80105051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105058:	5b                   	pop    %ebx
    return 0;
80105059:	31 c0                	xor    %eax,%eax
}
8010505b:	5e                   	pop    %esi
8010505c:	5d                   	pop    %ebp
8010505d:	c3                   	ret    
8010505e:	66 90                	xchg   %ax,%ax

80105060 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105060:	f3 0f 1e fb          	endbr32 
80105064:	55                   	push   %ebp
80105065:	89 e5                	mov    %esp,%ebp
80105067:	57                   	push   %edi
80105068:	56                   	push   %esi
80105069:	8b 75 08             	mov    0x8(%ebp),%esi
8010506c:	53                   	push   %ebx
8010506d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105070:	89 f2                	mov    %esi,%edx
80105072:	eb 1b                	jmp    8010508f <strncpy+0x2f>
80105074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105078:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010507c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010507f:	83 c2 01             	add    $0x1,%edx
80105082:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105086:	89 f9                	mov    %edi,%ecx
80105088:	88 4a ff             	mov    %cl,-0x1(%edx)
8010508b:	84 c9                	test   %cl,%cl
8010508d:	74 09                	je     80105098 <strncpy+0x38>
8010508f:	89 c3                	mov    %eax,%ebx
80105091:	83 e8 01             	sub    $0x1,%eax
80105094:	85 db                	test   %ebx,%ebx
80105096:	7f e0                	jg     80105078 <strncpy+0x18>
    ;
  while(n-- > 0)
80105098:	89 d1                	mov    %edx,%ecx
8010509a:	85 c0                	test   %eax,%eax
8010509c:	7e 15                	jle    801050b3 <strncpy+0x53>
8010509e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801050a0:	83 c1 01             	add    $0x1,%ecx
801050a3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801050a7:	89 c8                	mov    %ecx,%eax
801050a9:	f7 d0                	not    %eax
801050ab:	01 d0                	add    %edx,%eax
801050ad:	01 d8                	add    %ebx,%eax
801050af:	85 c0                	test   %eax,%eax
801050b1:	7f ed                	jg     801050a0 <strncpy+0x40>
  return os;
}
801050b3:	5b                   	pop    %ebx
801050b4:	89 f0                	mov    %esi,%eax
801050b6:	5e                   	pop    %esi
801050b7:	5f                   	pop    %edi
801050b8:	5d                   	pop    %ebp
801050b9:	c3                   	ret    
801050ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	56                   	push   %esi
801050c8:	8b 55 10             	mov    0x10(%ebp),%edx
801050cb:	8b 75 08             	mov    0x8(%ebp),%esi
801050ce:	53                   	push   %ebx
801050cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801050d2:	85 d2                	test   %edx,%edx
801050d4:	7e 21                	jle    801050f7 <safestrcpy+0x37>
801050d6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801050da:	89 f2                	mov    %esi,%edx
801050dc:	eb 12                	jmp    801050f0 <safestrcpy+0x30>
801050de:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801050e0:	0f b6 08             	movzbl (%eax),%ecx
801050e3:	83 c0 01             	add    $0x1,%eax
801050e6:	83 c2 01             	add    $0x1,%edx
801050e9:	88 4a ff             	mov    %cl,-0x1(%edx)
801050ec:	84 c9                	test   %cl,%cl
801050ee:	74 04                	je     801050f4 <safestrcpy+0x34>
801050f0:	39 d8                	cmp    %ebx,%eax
801050f2:	75 ec                	jne    801050e0 <safestrcpy+0x20>
    ;
  *s = 0;
801050f4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801050f7:	89 f0                	mov    %esi,%eax
801050f9:	5b                   	pop    %ebx
801050fa:	5e                   	pop    %esi
801050fb:	5d                   	pop    %ebp
801050fc:	c3                   	ret    
801050fd:	8d 76 00             	lea    0x0(%esi),%esi

80105100 <strlen>:

int
strlen(const char *s)
{
80105100:	f3 0f 1e fb          	endbr32 
80105104:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105105:	31 c0                	xor    %eax,%eax
{
80105107:	89 e5                	mov    %esp,%ebp
80105109:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010510c:	80 3a 00             	cmpb   $0x0,(%edx)
8010510f:	74 10                	je     80105121 <strlen+0x21>
80105111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105118:	83 c0 01             	add    $0x1,%eax
8010511b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010511f:	75 f7                	jne    80105118 <strlen+0x18>
    ;
  return n;
}
80105121:	5d                   	pop    %ebp
80105122:	c3                   	ret    

80105123 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105123:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105127:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010512b:	55                   	push   %ebp
  pushl %ebx
8010512c:	53                   	push   %ebx
  pushl %esi
8010512d:	56                   	push   %esi
  pushl %edi
8010512e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010512f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105131:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105133:	5f                   	pop    %edi
  popl %esi
80105134:	5e                   	pop    %esi
  popl %ebx
80105135:	5b                   	pop    %ebx
  popl %ebp
80105136:	5d                   	pop    %ebp
  ret
80105137:	c3                   	ret    
80105138:	66 90                	xchg   %ax,%ax
8010513a:	66 90                	xchg   %ax,%ax
8010513c:	66 90                	xchg   %ax,%ax
8010513e:	66 90                	xchg   %ax,%ax

80105140 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105140:	f3 0f 1e fb          	endbr32 
80105144:	55                   	push   %ebp
80105145:	89 e5                	mov    %esp,%ebp
80105147:	53                   	push   %ebx
80105148:	83 ec 04             	sub    $0x4,%esp
8010514b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010514e:	e8 ad f0 ff ff       	call   80104200 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105153:	8b 00                	mov    (%eax),%eax
80105155:	39 d8                	cmp    %ebx,%eax
80105157:	76 17                	jbe    80105170 <fetchint+0x30>
80105159:	8d 53 04             	lea    0x4(%ebx),%edx
8010515c:	39 d0                	cmp    %edx,%eax
8010515e:	72 10                	jb     80105170 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105160:	8b 45 0c             	mov    0xc(%ebp),%eax
80105163:	8b 13                	mov    (%ebx),%edx
80105165:	89 10                	mov    %edx,(%eax)
  return 0;
80105167:	31 c0                	xor    %eax,%eax
}
80105169:	83 c4 04             	add    $0x4,%esp
8010516c:	5b                   	pop    %ebx
8010516d:	5d                   	pop    %ebp
8010516e:	c3                   	ret    
8010516f:	90                   	nop
    return -1;
80105170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105175:	eb f2                	jmp    80105169 <fetchint+0x29>
80105177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517e:	66 90                	xchg   %ax,%ax

80105180 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	53                   	push   %ebx
80105188:	83 ec 04             	sub    $0x4,%esp
8010518b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010518e:	e8 6d f0 ff ff       	call   80104200 <myproc>

  if(addr >= curproc->sz)
80105193:	39 18                	cmp    %ebx,(%eax)
80105195:	76 31                	jbe    801051c8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105197:	8b 55 0c             	mov    0xc(%ebp),%edx
8010519a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010519c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010519e:	39 d3                	cmp    %edx,%ebx
801051a0:	73 26                	jae    801051c8 <fetchstr+0x48>
801051a2:	89 d8                	mov    %ebx,%eax
801051a4:	eb 11                	jmp    801051b7 <fetchstr+0x37>
801051a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
801051b0:	83 c0 01             	add    $0x1,%eax
801051b3:	39 c2                	cmp    %eax,%edx
801051b5:	76 11                	jbe    801051c8 <fetchstr+0x48>
    if(*s == 0)
801051b7:	80 38 00             	cmpb   $0x0,(%eax)
801051ba:	75 f4                	jne    801051b0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801051bc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801051bf:	29 d8                	sub    %ebx,%eax
}
801051c1:	5b                   	pop    %ebx
801051c2:	5d                   	pop    %ebp
801051c3:	c3                   	ret    
801051c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051c8:	83 c4 04             	add    $0x4,%esp
    return -1;
801051cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051d0:	5b                   	pop    %ebx
801051d1:	5d                   	pop    %ebp
801051d2:	c3                   	ret    
801051d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801051e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	56                   	push   %esi
801051e8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051e9:	e8 12 f0 ff ff       	call   80104200 <myproc>
801051ee:	8b 55 08             	mov    0x8(%ebp),%edx
801051f1:	8b 40 18             	mov    0x18(%eax),%eax
801051f4:	8b 40 44             	mov    0x44(%eax),%eax
801051f7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051fa:	e8 01 f0 ff ff       	call   80104200 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051ff:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105202:	8b 00                	mov    (%eax),%eax
80105204:	39 c6                	cmp    %eax,%esi
80105206:	73 18                	jae    80105220 <argint+0x40>
80105208:	8d 53 08             	lea    0x8(%ebx),%edx
8010520b:	39 d0                	cmp    %edx,%eax
8010520d:	72 11                	jb     80105220 <argint+0x40>
  *ip = *(int*)(addr);
8010520f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105212:	8b 53 04             	mov    0x4(%ebx),%edx
80105215:	89 10                	mov    %edx,(%eax)
  return 0;
80105217:	31 c0                	xor    %eax,%eax
}
80105219:	5b                   	pop    %ebx
8010521a:	5e                   	pop    %esi
8010521b:	5d                   	pop    %ebp
8010521c:	c3                   	ret    
8010521d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105225:	eb f2                	jmp    80105219 <argint+0x39>
80105227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010522e:	66 90                	xchg   %ax,%ax

80105230 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105230:	f3 0f 1e fb          	endbr32 
80105234:	55                   	push   %ebp
80105235:	89 e5                	mov    %esp,%ebp
80105237:	56                   	push   %esi
80105238:	53                   	push   %ebx
80105239:	83 ec 10             	sub    $0x10,%esp
8010523c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010523f:	e8 bc ef ff ff       	call   80104200 <myproc>
 
  if(argint(n, &i) < 0)
80105244:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105247:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105249:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010524c:	50                   	push   %eax
8010524d:	ff 75 08             	pushl  0x8(%ebp)
80105250:	e8 8b ff ff ff       	call   801051e0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105255:	83 c4 10             	add    $0x10,%esp
80105258:	85 c0                	test   %eax,%eax
8010525a:	78 24                	js     80105280 <argptr+0x50>
8010525c:	85 db                	test   %ebx,%ebx
8010525e:	78 20                	js     80105280 <argptr+0x50>
80105260:	8b 16                	mov    (%esi),%edx
80105262:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105265:	39 c2                	cmp    %eax,%edx
80105267:	76 17                	jbe    80105280 <argptr+0x50>
80105269:	01 c3                	add    %eax,%ebx
8010526b:	39 da                	cmp    %ebx,%edx
8010526d:	72 11                	jb     80105280 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010526f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105272:	89 02                	mov    %eax,(%edx)
  return 0;
80105274:	31 c0                	xor    %eax,%eax
}
80105276:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105279:	5b                   	pop    %ebx
8010527a:	5e                   	pop    %esi
8010527b:	5d                   	pop    %ebp
8010527c:	c3                   	ret    
8010527d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105285:	eb ef                	jmp    80105276 <argptr+0x46>
80105287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528e:	66 90                	xchg   %ax,%ax

80105290 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105290:	f3 0f 1e fb          	endbr32 
80105294:	55                   	push   %ebp
80105295:	89 e5                	mov    %esp,%ebp
80105297:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010529a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010529d:	50                   	push   %eax
8010529e:	ff 75 08             	pushl  0x8(%ebp)
801052a1:	e8 3a ff ff ff       	call   801051e0 <argint>
801052a6:	83 c4 10             	add    $0x10,%esp
801052a9:	85 c0                	test   %eax,%eax
801052ab:	78 13                	js     801052c0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801052ad:	83 ec 08             	sub    $0x8,%esp
801052b0:	ff 75 0c             	pushl  0xc(%ebp)
801052b3:	ff 75 f4             	pushl  -0xc(%ebp)
801052b6:	e8 c5 fe ff ff       	call   80105180 <fetchstr>
801052bb:	83 c4 10             	add    $0x10,%esp
}
801052be:	c9                   	leave  
801052bf:	c3                   	ret    
801052c0:	c9                   	leave  
    return -1;
801052c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052c6:	c3                   	ret    
801052c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ce:	66 90                	xchg   %ax,%ax

801052d0 <syscall>:
[SYS_swapstat] sys_swapstat,
};

void
syscall(void)
{
801052d0:	f3 0f 1e fb          	endbr32 
801052d4:	55                   	push   %ebp
801052d5:	89 e5                	mov    %esp,%ebp
801052d7:	53                   	push   %ebx
801052d8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801052db:	e8 20 ef ff ff       	call   80104200 <myproc>
801052e0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801052e2:	8b 40 18             	mov    0x18(%eax),%eax
801052e5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801052e8:	8d 50 ff             	lea    -0x1(%eax),%edx
801052eb:	83 fa 17             	cmp    $0x17,%edx
801052ee:	77 20                	ja     80105310 <syscall+0x40>
801052f0:	8b 14 85 00 87 10 80 	mov    -0x7fef7900(,%eax,4),%edx
801052f7:	85 d2                	test   %edx,%edx
801052f9:	74 15                	je     80105310 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801052fb:	ff d2                	call   *%edx
801052fd:	89 c2                	mov    %eax,%edx
801052ff:	8b 43 18             	mov    0x18(%ebx),%eax
80105302:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105308:	c9                   	leave  
80105309:	c3                   	ret    
8010530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105310:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105311:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105314:	50                   	push   %eax
80105315:	ff 73 10             	pushl  0x10(%ebx)
80105318:	68 d9 86 10 80       	push   $0x801086d9
8010531d:	e8 8e b3 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105322:	8b 43 18             	mov    0x18(%ebx),%eax
80105325:	83 c4 10             	add    $0x10,%esp
80105328:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010532f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105332:	c9                   	leave  
80105333:	c3                   	ret    
80105334:	66 90                	xchg   %ax,%ax
80105336:	66 90                	xchg   %ax,%ax
80105338:	66 90                	xchg   %ax,%ax
8010533a:	66 90                	xchg   %ax,%ax
8010533c:	66 90                	xchg   %ax,%ax
8010533e:	66 90                	xchg   %ax,%ax

80105340 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	57                   	push   %edi
80105344:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105345:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105348:	53                   	push   %ebx
80105349:	83 ec 44             	sub    $0x44,%esp
8010534c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010534f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105352:	57                   	push   %edi
80105353:	50                   	push   %eax
{
80105354:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105357:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010535a:	e8 f1 cc ff ff       	call   80102050 <nameiparent>
8010535f:	83 c4 10             	add    $0x10,%esp
80105362:	85 c0                	test   %eax,%eax
80105364:	0f 84 46 01 00 00    	je     801054b0 <create+0x170>
    return 0;
  ilock(dp);
8010536a:	83 ec 0c             	sub    $0xc,%esp
8010536d:	89 c3                	mov    %eax,%ebx
8010536f:	50                   	push   %eax
80105370:	e8 eb c3 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105375:	83 c4 0c             	add    $0xc,%esp
80105378:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010537b:	50                   	push   %eax
8010537c:	57                   	push   %edi
8010537d:	53                   	push   %ebx
8010537e:	e8 2d c9 ff ff       	call   80101cb0 <dirlookup>
80105383:	83 c4 10             	add    $0x10,%esp
80105386:	89 c6                	mov    %eax,%esi
80105388:	85 c0                	test   %eax,%eax
8010538a:	74 54                	je     801053e0 <create+0xa0>
    iunlockput(dp);
8010538c:	83 ec 0c             	sub    $0xc,%esp
8010538f:	53                   	push   %ebx
80105390:	e8 6b c6 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105395:	89 34 24             	mov    %esi,(%esp)
80105398:	e8 c3 c3 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010539d:	83 c4 10             	add    $0x10,%esp
801053a0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801053a5:	75 19                	jne    801053c0 <create+0x80>
801053a7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801053ac:	75 12                	jne    801053c0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801053ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053b1:	89 f0                	mov    %esi,%eax
801053b3:	5b                   	pop    %ebx
801053b4:	5e                   	pop    %esi
801053b5:	5f                   	pop    %edi
801053b6:	5d                   	pop    %ebp
801053b7:	c3                   	ret    
801053b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053bf:	90                   	nop
    iunlockput(ip);
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	56                   	push   %esi
    return 0;
801053c4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801053c6:	e8 35 c6 ff ff       	call   80101a00 <iunlockput>
    return 0;
801053cb:	83 c4 10             	add    $0x10,%esp
}
801053ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d1:	89 f0                	mov    %esi,%eax
801053d3:	5b                   	pop    %ebx
801053d4:	5e                   	pop    %esi
801053d5:	5f                   	pop    %edi
801053d6:	5d                   	pop    %ebp
801053d7:	c3                   	ret    
801053d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053df:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801053e0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801053e4:	83 ec 08             	sub    $0x8,%esp
801053e7:	50                   	push   %eax
801053e8:	ff 33                	pushl  (%ebx)
801053ea:	e8 f1 c1 ff ff       	call   801015e0 <ialloc>
801053ef:	83 c4 10             	add    $0x10,%esp
801053f2:	89 c6                	mov    %eax,%esi
801053f4:	85 c0                	test   %eax,%eax
801053f6:	0f 84 cd 00 00 00    	je     801054c9 <create+0x189>
  ilock(ip);
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	50                   	push   %eax
80105400:	e8 5b c3 ff ff       	call   80101760 <ilock>
  ip->major = major;
80105405:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105409:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010540d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105411:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105415:	b8 01 00 00 00       	mov    $0x1,%eax
8010541a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010541e:	89 34 24             	mov    %esi,(%esp)
80105421:	e8 7a c2 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105426:	83 c4 10             	add    $0x10,%esp
80105429:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010542e:	74 30                	je     80105460 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105430:	83 ec 04             	sub    $0x4,%esp
80105433:	ff 76 04             	pushl  0x4(%esi)
80105436:	57                   	push   %edi
80105437:	53                   	push   %ebx
80105438:	e8 33 cb ff ff       	call   80101f70 <dirlink>
8010543d:	83 c4 10             	add    $0x10,%esp
80105440:	85 c0                	test   %eax,%eax
80105442:	78 78                	js     801054bc <create+0x17c>
  iunlockput(dp);
80105444:	83 ec 0c             	sub    $0xc,%esp
80105447:	53                   	push   %ebx
80105448:	e8 b3 c5 ff ff       	call   80101a00 <iunlockput>
  return ip;
8010544d:	83 c4 10             	add    $0x10,%esp
}
80105450:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105453:	89 f0                	mov    %esi,%eax
80105455:	5b                   	pop    %ebx
80105456:	5e                   	pop    %esi
80105457:	5f                   	pop    %edi
80105458:	5d                   	pop    %ebp
80105459:	c3                   	ret    
8010545a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105460:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105463:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105468:	53                   	push   %ebx
80105469:	e8 32 c2 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010546e:	83 c4 0c             	add    $0xc,%esp
80105471:	ff 76 04             	pushl  0x4(%esi)
80105474:	68 80 87 10 80       	push   $0x80108780
80105479:	56                   	push   %esi
8010547a:	e8 f1 ca ff ff       	call   80101f70 <dirlink>
8010547f:	83 c4 10             	add    $0x10,%esp
80105482:	85 c0                	test   %eax,%eax
80105484:	78 18                	js     8010549e <create+0x15e>
80105486:	83 ec 04             	sub    $0x4,%esp
80105489:	ff 73 04             	pushl  0x4(%ebx)
8010548c:	68 7f 87 10 80       	push   $0x8010877f
80105491:	56                   	push   %esi
80105492:	e8 d9 ca ff ff       	call   80101f70 <dirlink>
80105497:	83 c4 10             	add    $0x10,%esp
8010549a:	85 c0                	test   %eax,%eax
8010549c:	79 92                	jns    80105430 <create+0xf0>
      panic("create dots");
8010549e:	83 ec 0c             	sub    $0xc,%esp
801054a1:	68 73 87 10 80       	push   $0x80108773
801054a6:	e8 e5 ae ff ff       	call   80100390 <panic>
801054ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054af:	90                   	nop
}
801054b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801054b3:	31 f6                	xor    %esi,%esi
}
801054b5:	5b                   	pop    %ebx
801054b6:	89 f0                	mov    %esi,%eax
801054b8:	5e                   	pop    %esi
801054b9:	5f                   	pop    %edi
801054ba:	5d                   	pop    %ebp
801054bb:	c3                   	ret    
    panic("create: dirlink");
801054bc:	83 ec 0c             	sub    $0xc,%esp
801054bf:	68 82 87 10 80       	push   $0x80108782
801054c4:	e8 c7 ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801054c9:	83 ec 0c             	sub    $0xc,%esp
801054cc:	68 64 87 10 80       	push   $0x80108764
801054d1:	e8 ba ae ff ff       	call   80100390 <panic>
801054d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054dd:	8d 76 00             	lea    0x0(%esi),%esi

801054e0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	56                   	push   %esi
801054e4:	89 d6                	mov    %edx,%esi
801054e6:	53                   	push   %ebx
801054e7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801054e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801054ec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054ef:	50                   	push   %eax
801054f0:	6a 00                	push   $0x0
801054f2:	e8 e9 fc ff ff       	call   801051e0 <argint>
801054f7:	83 c4 10             	add    $0x10,%esp
801054fa:	85 c0                	test   %eax,%eax
801054fc:	78 2a                	js     80105528 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054fe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105502:	77 24                	ja     80105528 <argfd.constprop.0+0x48>
80105504:	e8 f7 ec ff ff       	call   80104200 <myproc>
80105509:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010550c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105510:	85 c0                	test   %eax,%eax
80105512:	74 14                	je     80105528 <argfd.constprop.0+0x48>
  if(pfd)
80105514:	85 db                	test   %ebx,%ebx
80105516:	74 02                	je     8010551a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105518:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010551a:	89 06                	mov    %eax,(%esi)
  return 0;
8010551c:	31 c0                	xor    %eax,%eax
}
8010551e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105521:	5b                   	pop    %ebx
80105522:	5e                   	pop    %esi
80105523:	5d                   	pop    %ebp
80105524:	c3                   	ret    
80105525:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105528:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010552d:	eb ef                	jmp    8010551e <argfd.constprop.0+0x3e>
8010552f:	90                   	nop

80105530 <sys_dup>:
{
80105530:	f3 0f 1e fb          	endbr32 
80105534:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105535:	31 c0                	xor    %eax,%eax
{
80105537:	89 e5                	mov    %esp,%ebp
80105539:	56                   	push   %esi
8010553a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010553b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010553e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105541:	e8 9a ff ff ff       	call   801054e0 <argfd.constprop.0>
80105546:	85 c0                	test   %eax,%eax
80105548:	78 1e                	js     80105568 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010554a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010554d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010554f:	e8 ac ec ff ff       	call   80104200 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105558:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010555c:	85 d2                	test   %edx,%edx
8010555e:	74 20                	je     80105580 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105560:	83 c3 01             	add    $0x1,%ebx
80105563:	83 fb 10             	cmp    $0x10,%ebx
80105566:	75 f0                	jne    80105558 <sys_dup+0x28>
}
80105568:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010556b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105570:	89 d8                	mov    %ebx,%eax
80105572:	5b                   	pop    %ebx
80105573:	5e                   	pop    %esi
80105574:	5d                   	pop    %ebp
80105575:	c3                   	ret    
80105576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105580:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105584:	83 ec 0c             	sub    $0xc,%esp
80105587:	ff 75 f4             	pushl  -0xc(%ebp)
8010558a:	e8 e1 b8 ff ff       	call   80100e70 <filedup>
  return fd;
8010558f:	83 c4 10             	add    $0x10,%esp
}
80105592:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105595:	89 d8                	mov    %ebx,%eax
80105597:	5b                   	pop    %ebx
80105598:	5e                   	pop    %esi
80105599:	5d                   	pop    %ebp
8010559a:	c3                   	ret    
8010559b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010559f:	90                   	nop

801055a0 <sys_read>:
{
801055a0:	f3 0f 1e fb          	endbr32 
801055a4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055a5:	31 c0                	xor    %eax,%eax
{
801055a7:	89 e5                	mov    %esp,%ebp
801055a9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055ac:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055af:	e8 2c ff ff ff       	call   801054e0 <argfd.constprop.0>
801055b4:	85 c0                	test   %eax,%eax
801055b6:	78 48                	js     80105600 <sys_read+0x60>
801055b8:	83 ec 08             	sub    $0x8,%esp
801055bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055be:	50                   	push   %eax
801055bf:	6a 02                	push   $0x2
801055c1:	e8 1a fc ff ff       	call   801051e0 <argint>
801055c6:	83 c4 10             	add    $0x10,%esp
801055c9:	85 c0                	test   %eax,%eax
801055cb:	78 33                	js     80105600 <sys_read+0x60>
801055cd:	83 ec 04             	sub    $0x4,%esp
801055d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055d3:	ff 75 f0             	pushl  -0x10(%ebp)
801055d6:	50                   	push   %eax
801055d7:	6a 01                	push   $0x1
801055d9:	e8 52 fc ff ff       	call   80105230 <argptr>
801055de:	83 c4 10             	add    $0x10,%esp
801055e1:	85 c0                	test   %eax,%eax
801055e3:	78 1b                	js     80105600 <sys_read+0x60>
  return fileread(f, p, n);
801055e5:	83 ec 04             	sub    $0x4,%esp
801055e8:	ff 75 f0             	pushl  -0x10(%ebp)
801055eb:	ff 75 f4             	pushl  -0xc(%ebp)
801055ee:	ff 75 ec             	pushl  -0x14(%ebp)
801055f1:	e8 fa b9 ff ff       	call   80100ff0 <fileread>
801055f6:	83 c4 10             	add    $0x10,%esp
}
801055f9:	c9                   	leave  
801055fa:	c3                   	ret    
801055fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop
80105600:	c9                   	leave  
    return -1;
80105601:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105606:	c3                   	ret    
80105607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560e:	66 90                	xchg   %ax,%ax

80105610 <sys_write>:
{
80105610:	f3 0f 1e fb          	endbr32 
80105614:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105615:	31 c0                	xor    %eax,%eax
{
80105617:	89 e5                	mov    %esp,%ebp
80105619:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010561c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010561f:	e8 bc fe ff ff       	call   801054e0 <argfd.constprop.0>
80105624:	85 c0                	test   %eax,%eax
80105626:	78 48                	js     80105670 <sys_write+0x60>
80105628:	83 ec 08             	sub    $0x8,%esp
8010562b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010562e:	50                   	push   %eax
8010562f:	6a 02                	push   $0x2
80105631:	e8 aa fb ff ff       	call   801051e0 <argint>
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	85 c0                	test   %eax,%eax
8010563b:	78 33                	js     80105670 <sys_write+0x60>
8010563d:	83 ec 04             	sub    $0x4,%esp
80105640:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105643:	ff 75 f0             	pushl  -0x10(%ebp)
80105646:	50                   	push   %eax
80105647:	6a 01                	push   $0x1
80105649:	e8 e2 fb ff ff       	call   80105230 <argptr>
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	85 c0                	test   %eax,%eax
80105653:	78 1b                	js     80105670 <sys_write+0x60>
  return filewrite(f, p, n);
80105655:	83 ec 04             	sub    $0x4,%esp
80105658:	ff 75 f0             	pushl  -0x10(%ebp)
8010565b:	ff 75 f4             	pushl  -0xc(%ebp)
8010565e:	ff 75 ec             	pushl  -0x14(%ebp)
80105661:	e8 2a ba ff ff       	call   80101090 <filewrite>
80105666:	83 c4 10             	add    $0x10,%esp
}
80105669:	c9                   	leave  
8010566a:	c3                   	ret    
8010566b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010566f:	90                   	nop
80105670:	c9                   	leave  
    return -1;
80105671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105676:	c3                   	ret    
80105677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567e:	66 90                	xchg   %ax,%ax

80105680 <sys_close>:
{
80105680:	f3 0f 1e fb          	endbr32 
80105684:	55                   	push   %ebp
80105685:	89 e5                	mov    %esp,%ebp
80105687:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010568a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010568d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105690:	e8 4b fe ff ff       	call   801054e0 <argfd.constprop.0>
80105695:	85 c0                	test   %eax,%eax
80105697:	78 27                	js     801056c0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105699:	e8 62 eb ff ff       	call   80104200 <myproc>
8010569e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801056a1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801056a4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801056ab:	00 
  fileclose(f);
801056ac:	ff 75 f4             	pushl  -0xc(%ebp)
801056af:	e8 0c b8 ff ff       	call   80100ec0 <fileclose>
  return 0;
801056b4:	83 c4 10             	add    $0x10,%esp
801056b7:	31 c0                	xor    %eax,%eax
}
801056b9:	c9                   	leave  
801056ba:	c3                   	ret    
801056bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056bf:	90                   	nop
801056c0:	c9                   	leave  
    return -1;
801056c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056c6:	c3                   	ret    
801056c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ce:	66 90                	xchg   %ax,%ax

801056d0 <sys_fstat>:
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056d5:	31 c0                	xor    %eax,%eax
{
801056d7:	89 e5                	mov    %esp,%ebp
801056d9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056dc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801056df:	e8 fc fd ff ff       	call   801054e0 <argfd.constprop.0>
801056e4:	85 c0                	test   %eax,%eax
801056e6:	78 30                	js     80105718 <sys_fstat+0x48>
801056e8:	83 ec 04             	sub    $0x4,%esp
801056eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ee:	6a 14                	push   $0x14
801056f0:	50                   	push   %eax
801056f1:	6a 01                	push   $0x1
801056f3:	e8 38 fb ff ff       	call   80105230 <argptr>
801056f8:	83 c4 10             	add    $0x10,%esp
801056fb:	85 c0                	test   %eax,%eax
801056fd:	78 19                	js     80105718 <sys_fstat+0x48>
  return filestat(f, st);
801056ff:	83 ec 08             	sub    $0x8,%esp
80105702:	ff 75 f4             	pushl  -0xc(%ebp)
80105705:	ff 75 f0             	pushl  -0x10(%ebp)
80105708:	e8 93 b8 ff ff       	call   80100fa0 <filestat>
8010570d:	83 c4 10             	add    $0x10,%esp
}
80105710:	c9                   	leave  
80105711:	c3                   	ret    
80105712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105718:	c9                   	leave  
    return -1;
80105719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010571e:	c3                   	ret    
8010571f:	90                   	nop

80105720 <sys_link>:
{
80105720:	f3 0f 1e fb          	endbr32 
80105724:	55                   	push   %ebp
80105725:	89 e5                	mov    %esp,%ebp
80105727:	57                   	push   %edi
80105728:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105729:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010572c:	53                   	push   %ebx
8010572d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105730:	50                   	push   %eax
80105731:	6a 00                	push   $0x0
80105733:	e8 58 fb ff ff       	call   80105290 <argstr>
80105738:	83 c4 10             	add    $0x10,%esp
8010573b:	85 c0                	test   %eax,%eax
8010573d:	0f 88 ff 00 00 00    	js     80105842 <sys_link+0x122>
80105743:	83 ec 08             	sub    $0x8,%esp
80105746:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105749:	50                   	push   %eax
8010574a:	6a 01                	push   $0x1
8010574c:	e8 3f fb ff ff       	call   80105290 <argstr>
80105751:	83 c4 10             	add    $0x10,%esp
80105754:	85 c0                	test   %eax,%eax
80105756:	0f 88 e6 00 00 00    	js     80105842 <sys_link+0x122>
  begin_op();
8010575c:	e8 6f de ff ff       	call   801035d0 <begin_op>
  if((ip = namei(old)) == 0){
80105761:	83 ec 0c             	sub    $0xc,%esp
80105764:	ff 75 d4             	pushl  -0x2c(%ebp)
80105767:	e8 c4 c8 ff ff       	call   80102030 <namei>
8010576c:	83 c4 10             	add    $0x10,%esp
8010576f:	89 c3                	mov    %eax,%ebx
80105771:	85 c0                	test   %eax,%eax
80105773:	0f 84 e8 00 00 00    	je     80105861 <sys_link+0x141>
  ilock(ip);
80105779:	83 ec 0c             	sub    $0xc,%esp
8010577c:	50                   	push   %eax
8010577d:	e8 de bf ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105782:	83 c4 10             	add    $0x10,%esp
80105785:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010578a:	0f 84 b9 00 00 00    	je     80105849 <sys_link+0x129>
  iupdate(ip);
80105790:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105793:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105798:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010579b:	53                   	push   %ebx
8010579c:	e8 ff be ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801057a1:	89 1c 24             	mov    %ebx,(%esp)
801057a4:	e8 97 c0 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801057a9:	58                   	pop    %eax
801057aa:	5a                   	pop    %edx
801057ab:	57                   	push   %edi
801057ac:	ff 75 d0             	pushl  -0x30(%ebp)
801057af:	e8 9c c8 ff ff       	call   80102050 <nameiparent>
801057b4:	83 c4 10             	add    $0x10,%esp
801057b7:	89 c6                	mov    %eax,%esi
801057b9:	85 c0                	test   %eax,%eax
801057bb:	74 5f                	je     8010581c <sys_link+0xfc>
  ilock(dp);
801057bd:	83 ec 0c             	sub    $0xc,%esp
801057c0:	50                   	push   %eax
801057c1:	e8 9a bf ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801057c6:	8b 03                	mov    (%ebx),%eax
801057c8:	83 c4 10             	add    $0x10,%esp
801057cb:	39 06                	cmp    %eax,(%esi)
801057cd:	75 41                	jne    80105810 <sys_link+0xf0>
801057cf:	83 ec 04             	sub    $0x4,%esp
801057d2:	ff 73 04             	pushl  0x4(%ebx)
801057d5:	57                   	push   %edi
801057d6:	56                   	push   %esi
801057d7:	e8 94 c7 ff ff       	call   80101f70 <dirlink>
801057dc:	83 c4 10             	add    $0x10,%esp
801057df:	85 c0                	test   %eax,%eax
801057e1:	78 2d                	js     80105810 <sys_link+0xf0>
  iunlockput(dp);
801057e3:	83 ec 0c             	sub    $0xc,%esp
801057e6:	56                   	push   %esi
801057e7:	e8 14 c2 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
801057ec:	89 1c 24             	mov    %ebx,(%esp)
801057ef:	e8 9c c0 ff ff       	call   80101890 <iput>
  end_op();
801057f4:	e8 47 de ff ff       	call   80103640 <end_op>
  return 0;
801057f9:	83 c4 10             	add    $0x10,%esp
801057fc:	31 c0                	xor    %eax,%eax
}
801057fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105801:	5b                   	pop    %ebx
80105802:	5e                   	pop    %esi
80105803:	5f                   	pop    %edi
80105804:	5d                   	pop    %ebp
80105805:	c3                   	ret    
80105806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	56                   	push   %esi
80105814:	e8 e7 c1 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105819:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010581c:	83 ec 0c             	sub    $0xc,%esp
8010581f:	53                   	push   %ebx
80105820:	e8 3b bf ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105825:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010582a:	89 1c 24             	mov    %ebx,(%esp)
8010582d:	e8 6e be ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105832:	89 1c 24             	mov    %ebx,(%esp)
80105835:	e8 c6 c1 ff ff       	call   80101a00 <iunlockput>
  end_op();
8010583a:	e8 01 de ff ff       	call   80103640 <end_op>
  return -1;
8010583f:	83 c4 10             	add    $0x10,%esp
80105842:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105847:	eb b5                	jmp    801057fe <sys_link+0xde>
    iunlockput(ip);
80105849:	83 ec 0c             	sub    $0xc,%esp
8010584c:	53                   	push   %ebx
8010584d:	e8 ae c1 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105852:	e8 e9 dd ff ff       	call   80103640 <end_op>
    return -1;
80105857:	83 c4 10             	add    $0x10,%esp
8010585a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585f:	eb 9d                	jmp    801057fe <sys_link+0xde>
    end_op();
80105861:	e8 da dd ff ff       	call   80103640 <end_op>
    return -1;
80105866:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586b:	eb 91                	jmp    801057fe <sys_link+0xde>
8010586d:	8d 76 00             	lea    0x0(%esi),%esi

80105870 <sys_unlink>:
{
80105870:	f3 0f 1e fb          	endbr32 
80105874:	55                   	push   %ebp
80105875:	89 e5                	mov    %esp,%ebp
80105877:	57                   	push   %edi
80105878:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105879:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010587c:	53                   	push   %ebx
8010587d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105880:	50                   	push   %eax
80105881:	6a 00                	push   $0x0
80105883:	e8 08 fa ff ff       	call   80105290 <argstr>
80105888:	83 c4 10             	add    $0x10,%esp
8010588b:	85 c0                	test   %eax,%eax
8010588d:	0f 88 7d 01 00 00    	js     80105a10 <sys_unlink+0x1a0>
  begin_op();
80105893:	e8 38 dd ff ff       	call   801035d0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105898:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010589b:	83 ec 08             	sub    $0x8,%esp
8010589e:	53                   	push   %ebx
8010589f:	ff 75 c0             	pushl  -0x40(%ebp)
801058a2:	e8 a9 c7 ff ff       	call   80102050 <nameiparent>
801058a7:	83 c4 10             	add    $0x10,%esp
801058aa:	89 c6                	mov    %eax,%esi
801058ac:	85 c0                	test   %eax,%eax
801058ae:	0f 84 66 01 00 00    	je     80105a1a <sys_unlink+0x1aa>
  ilock(dp);
801058b4:	83 ec 0c             	sub    $0xc,%esp
801058b7:	50                   	push   %eax
801058b8:	e8 a3 be ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058bd:	58                   	pop    %eax
801058be:	5a                   	pop    %edx
801058bf:	68 80 87 10 80       	push   $0x80108780
801058c4:	53                   	push   %ebx
801058c5:	e8 c6 c3 ff ff       	call   80101c90 <namecmp>
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	85 c0                	test   %eax,%eax
801058cf:	0f 84 03 01 00 00    	je     801059d8 <sys_unlink+0x168>
801058d5:	83 ec 08             	sub    $0x8,%esp
801058d8:	68 7f 87 10 80       	push   $0x8010877f
801058dd:	53                   	push   %ebx
801058de:	e8 ad c3 ff ff       	call   80101c90 <namecmp>
801058e3:	83 c4 10             	add    $0x10,%esp
801058e6:	85 c0                	test   %eax,%eax
801058e8:	0f 84 ea 00 00 00    	je     801059d8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801058ee:	83 ec 04             	sub    $0x4,%esp
801058f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801058f4:	50                   	push   %eax
801058f5:	53                   	push   %ebx
801058f6:	56                   	push   %esi
801058f7:	e8 b4 c3 ff ff       	call   80101cb0 <dirlookup>
801058fc:	83 c4 10             	add    $0x10,%esp
801058ff:	89 c3                	mov    %eax,%ebx
80105901:	85 c0                	test   %eax,%eax
80105903:	0f 84 cf 00 00 00    	je     801059d8 <sys_unlink+0x168>
  ilock(ip);
80105909:	83 ec 0c             	sub    $0xc,%esp
8010590c:	50                   	push   %eax
8010590d:	e8 4e be ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105912:	83 c4 10             	add    $0x10,%esp
80105915:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010591a:	0f 8e 23 01 00 00    	jle    80105a43 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105920:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105925:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105928:	74 66                	je     80105990 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010592a:	83 ec 04             	sub    $0x4,%esp
8010592d:	6a 10                	push   $0x10
8010592f:	6a 00                	push   $0x0
80105931:	57                   	push   %edi
80105932:	e8 c9 f5 ff ff       	call   80104f00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105937:	6a 10                	push   $0x10
80105939:	ff 75 c4             	pushl  -0x3c(%ebp)
8010593c:	57                   	push   %edi
8010593d:	56                   	push   %esi
8010593e:	e8 1d c2 ff ff       	call   80101b60 <writei>
80105943:	83 c4 20             	add    $0x20,%esp
80105946:	83 f8 10             	cmp    $0x10,%eax
80105949:	0f 85 e7 00 00 00    	jne    80105a36 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010594f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105954:	0f 84 96 00 00 00    	je     801059f0 <sys_unlink+0x180>
  iunlockput(dp);
8010595a:	83 ec 0c             	sub    $0xc,%esp
8010595d:	56                   	push   %esi
8010595e:	e8 9d c0 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105963:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105968:	89 1c 24             	mov    %ebx,(%esp)
8010596b:	e8 30 bd ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105970:	89 1c 24             	mov    %ebx,(%esp)
80105973:	e8 88 c0 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105978:	e8 c3 dc ff ff       	call   80103640 <end_op>
  return 0;
8010597d:	83 c4 10             	add    $0x10,%esp
80105980:	31 c0                	xor    %eax,%eax
}
80105982:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105985:	5b                   	pop    %ebx
80105986:	5e                   	pop    %esi
80105987:	5f                   	pop    %edi
80105988:	5d                   	pop    %ebp
80105989:	c3                   	ret    
8010598a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105990:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105994:	76 94                	jbe    8010592a <sys_unlink+0xba>
80105996:	ba 20 00 00 00       	mov    $0x20,%edx
8010599b:	eb 0b                	jmp    801059a8 <sys_unlink+0x138>
8010599d:	8d 76 00             	lea    0x0(%esi),%esi
801059a0:	83 c2 10             	add    $0x10,%edx
801059a3:	39 53 58             	cmp    %edx,0x58(%ebx)
801059a6:	76 82                	jbe    8010592a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059a8:	6a 10                	push   $0x10
801059aa:	52                   	push   %edx
801059ab:	57                   	push   %edi
801059ac:	53                   	push   %ebx
801059ad:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801059b0:	e8 ab c0 ff ff       	call   80101a60 <readi>
801059b5:	83 c4 10             	add    $0x10,%esp
801059b8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801059bb:	83 f8 10             	cmp    $0x10,%eax
801059be:	75 69                	jne    80105a29 <sys_unlink+0x1b9>
    if(de.inum != 0)
801059c0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801059c5:	74 d9                	je     801059a0 <sys_unlink+0x130>
    iunlockput(ip);
801059c7:	83 ec 0c             	sub    $0xc,%esp
801059ca:	53                   	push   %ebx
801059cb:	e8 30 c0 ff ff       	call   80101a00 <iunlockput>
    goto bad;
801059d0:	83 c4 10             	add    $0x10,%esp
801059d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059d7:	90                   	nop
  iunlockput(dp);
801059d8:	83 ec 0c             	sub    $0xc,%esp
801059db:	56                   	push   %esi
801059dc:	e8 1f c0 ff ff       	call   80101a00 <iunlockput>
  end_op();
801059e1:	e8 5a dc ff ff       	call   80103640 <end_op>
  return -1;
801059e6:	83 c4 10             	add    $0x10,%esp
801059e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ee:	eb 92                	jmp    80105982 <sys_unlink+0x112>
    iupdate(dp);
801059f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801059f3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801059f8:	56                   	push   %esi
801059f9:	e8 a2 bc ff ff       	call   801016a0 <iupdate>
801059fe:	83 c4 10             	add    $0x10,%esp
80105a01:	e9 54 ff ff ff       	jmp    8010595a <sys_unlink+0xea>
80105a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a15:	e9 68 ff ff ff       	jmp    80105982 <sys_unlink+0x112>
    end_op();
80105a1a:	e8 21 dc ff ff       	call   80103640 <end_op>
    return -1;
80105a1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a24:	e9 59 ff ff ff       	jmp    80105982 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105a29:	83 ec 0c             	sub    $0xc,%esp
80105a2c:	68 a4 87 10 80       	push   $0x801087a4
80105a31:	e8 5a a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105a36:	83 ec 0c             	sub    $0xc,%esp
80105a39:	68 b6 87 10 80       	push   $0x801087b6
80105a3e:	e8 4d a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a43:	83 ec 0c             	sub    $0xc,%esp
80105a46:	68 92 87 10 80       	push   $0x80108792
80105a4b:	e8 40 a9 ff ff       	call   80100390 <panic>

80105a50 <sys_open>:

int
sys_open(void)
{
80105a50:	f3 0f 1e fb          	endbr32 
80105a54:	55                   	push   %ebp
80105a55:	89 e5                	mov    %esp,%ebp
80105a57:	57                   	push   %edi
80105a58:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a59:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a5c:	53                   	push   %ebx
80105a5d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a60:	50                   	push   %eax
80105a61:	6a 00                	push   $0x0
80105a63:	e8 28 f8 ff ff       	call   80105290 <argstr>
80105a68:	83 c4 10             	add    $0x10,%esp
80105a6b:	85 c0                	test   %eax,%eax
80105a6d:	0f 88 8a 00 00 00    	js     80105afd <sys_open+0xad>
80105a73:	83 ec 08             	sub    $0x8,%esp
80105a76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a79:	50                   	push   %eax
80105a7a:	6a 01                	push   $0x1
80105a7c:	e8 5f f7 ff ff       	call   801051e0 <argint>
80105a81:	83 c4 10             	add    $0x10,%esp
80105a84:	85 c0                	test   %eax,%eax
80105a86:	78 75                	js     80105afd <sys_open+0xad>
    return -1;

  begin_op();
80105a88:	e8 43 db ff ff       	call   801035d0 <begin_op>

  if(omode & O_CREATE){
80105a8d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a91:	75 75                	jne    80105b08 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a93:	83 ec 0c             	sub    $0xc,%esp
80105a96:	ff 75 e0             	pushl  -0x20(%ebp)
80105a99:	e8 92 c5 ff ff       	call   80102030 <namei>
80105a9e:	83 c4 10             	add    $0x10,%esp
80105aa1:	89 c6                	mov    %eax,%esi
80105aa3:	85 c0                	test   %eax,%eax
80105aa5:	74 7e                	je     80105b25 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105aa7:	83 ec 0c             	sub    $0xc,%esp
80105aaa:	50                   	push   %eax
80105aab:	e8 b0 bc ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ab0:	83 c4 10             	add    $0x10,%esp
80105ab3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ab8:	0f 84 c2 00 00 00    	je     80105b80 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105abe:	e8 3d b3 ff ff       	call   80100e00 <filealloc>
80105ac3:	89 c7                	mov    %eax,%edi
80105ac5:	85 c0                	test   %eax,%eax
80105ac7:	74 23                	je     80105aec <sys_open+0x9c>
  struct proc *curproc = myproc();
80105ac9:	e8 32 e7 ff ff       	call   80104200 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ace:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105ad0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ad4:	85 d2                	test   %edx,%edx
80105ad6:	74 60                	je     80105b38 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105ad8:	83 c3 01             	add    $0x1,%ebx
80105adb:	83 fb 10             	cmp    $0x10,%ebx
80105ade:	75 f0                	jne    80105ad0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	57                   	push   %edi
80105ae4:	e8 d7 b3 ff ff       	call   80100ec0 <fileclose>
80105ae9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105aec:	83 ec 0c             	sub    $0xc,%esp
80105aef:	56                   	push   %esi
80105af0:	e8 0b bf ff ff       	call   80101a00 <iunlockput>
    end_op();
80105af5:	e8 46 db ff ff       	call   80103640 <end_op>
    return -1;
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b02:	eb 6d                	jmp    80105b71 <sys_open+0x121>
80105b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105b08:	83 ec 0c             	sub    $0xc,%esp
80105b0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b0e:	31 c9                	xor    %ecx,%ecx
80105b10:	ba 02 00 00 00       	mov    $0x2,%edx
80105b15:	6a 00                	push   $0x0
80105b17:	e8 24 f8 ff ff       	call   80105340 <create>
    if(ip == 0){
80105b1c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105b1f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b21:	85 c0                	test   %eax,%eax
80105b23:	75 99                	jne    80105abe <sys_open+0x6e>
      end_op();
80105b25:	e8 16 db ff ff       	call   80103640 <end_op>
      return -1;
80105b2a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b2f:	eb 40                	jmp    80105b71 <sys_open+0x121>
80105b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b38:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b3b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b3f:	56                   	push   %esi
80105b40:	e8 fb bc ff ff       	call   80101840 <iunlock>
  end_op();
80105b45:	e8 f6 da ff ff       	call   80103640 <end_op>

  f->type = FD_INODE;
80105b4a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b53:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b56:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b59:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b5b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b62:	f7 d0                	not    %eax
80105b64:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b67:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b6a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b6d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b74:	89 d8                	mov    %ebx,%eax
80105b76:	5b                   	pop    %ebx
80105b77:	5e                   	pop    %esi
80105b78:	5f                   	pop    %edi
80105b79:	5d                   	pop    %ebp
80105b7a:	c3                   	ret    
80105b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b7f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b80:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b83:	85 c9                	test   %ecx,%ecx
80105b85:	0f 84 33 ff ff ff    	je     80105abe <sys_open+0x6e>
80105b8b:	e9 5c ff ff ff       	jmp    80105aec <sys_open+0x9c>

80105b90 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b90:	f3 0f 1e fb          	endbr32 
80105b94:	55                   	push   %ebp
80105b95:	89 e5                	mov    %esp,%ebp
80105b97:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b9a:	e8 31 da ff ff       	call   801035d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b9f:	83 ec 08             	sub    $0x8,%esp
80105ba2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ba5:	50                   	push   %eax
80105ba6:	6a 00                	push   $0x0
80105ba8:	e8 e3 f6 ff ff       	call   80105290 <argstr>
80105bad:	83 c4 10             	add    $0x10,%esp
80105bb0:	85 c0                	test   %eax,%eax
80105bb2:	78 34                	js     80105be8 <sys_mkdir+0x58>
80105bb4:	83 ec 0c             	sub    $0xc,%esp
80105bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bba:	31 c9                	xor    %ecx,%ecx
80105bbc:	ba 01 00 00 00       	mov    $0x1,%edx
80105bc1:	6a 00                	push   $0x0
80105bc3:	e8 78 f7 ff ff       	call   80105340 <create>
80105bc8:	83 c4 10             	add    $0x10,%esp
80105bcb:	85 c0                	test   %eax,%eax
80105bcd:	74 19                	je     80105be8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bcf:	83 ec 0c             	sub    $0xc,%esp
80105bd2:	50                   	push   %eax
80105bd3:	e8 28 be ff ff       	call   80101a00 <iunlockput>
  end_op();
80105bd8:	e8 63 da ff ff       	call   80103640 <end_op>
  return 0;
80105bdd:	83 c4 10             	add    $0x10,%esp
80105be0:	31 c0                	xor    %eax,%eax
}
80105be2:	c9                   	leave  
80105be3:	c3                   	ret    
80105be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105be8:	e8 53 da ff ff       	call   80103640 <end_op>
    return -1;
80105bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bf2:	c9                   	leave  
80105bf3:	c3                   	ret    
80105bf4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bff:	90                   	nop

80105c00 <sys_mknod>:

int
sys_mknod(void)
{
80105c00:	f3 0f 1e fb          	endbr32 
80105c04:	55                   	push   %ebp
80105c05:	89 e5                	mov    %esp,%ebp
80105c07:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c0a:	e8 c1 d9 ff ff       	call   801035d0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c0f:	83 ec 08             	sub    $0x8,%esp
80105c12:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c15:	50                   	push   %eax
80105c16:	6a 00                	push   $0x0
80105c18:	e8 73 f6 ff ff       	call   80105290 <argstr>
80105c1d:	83 c4 10             	add    $0x10,%esp
80105c20:	85 c0                	test   %eax,%eax
80105c22:	78 64                	js     80105c88 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105c24:	83 ec 08             	sub    $0x8,%esp
80105c27:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c2a:	50                   	push   %eax
80105c2b:	6a 01                	push   $0x1
80105c2d:	e8 ae f5 ff ff       	call   801051e0 <argint>
  if((argstr(0, &path)) < 0 ||
80105c32:	83 c4 10             	add    $0x10,%esp
80105c35:	85 c0                	test   %eax,%eax
80105c37:	78 4f                	js     80105c88 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105c39:	83 ec 08             	sub    $0x8,%esp
80105c3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c3f:	50                   	push   %eax
80105c40:	6a 02                	push   $0x2
80105c42:	e8 99 f5 ff ff       	call   801051e0 <argint>
     argint(1, &major) < 0 ||
80105c47:	83 c4 10             	add    $0x10,%esp
80105c4a:	85 c0                	test   %eax,%eax
80105c4c:	78 3a                	js     80105c88 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c4e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c52:	83 ec 0c             	sub    $0xc,%esp
80105c55:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c59:	ba 03 00 00 00       	mov    $0x3,%edx
80105c5e:	50                   	push   %eax
80105c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c62:	e8 d9 f6 ff ff       	call   80105340 <create>
     argint(2, &minor) < 0 ||
80105c67:	83 c4 10             	add    $0x10,%esp
80105c6a:	85 c0                	test   %eax,%eax
80105c6c:	74 1a                	je     80105c88 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c6e:	83 ec 0c             	sub    $0xc,%esp
80105c71:	50                   	push   %eax
80105c72:	e8 89 bd ff ff       	call   80101a00 <iunlockput>
  end_op();
80105c77:	e8 c4 d9 ff ff       	call   80103640 <end_op>
  return 0;
80105c7c:	83 c4 10             	add    $0x10,%esp
80105c7f:	31 c0                	xor    %eax,%eax
}
80105c81:	c9                   	leave  
80105c82:	c3                   	ret    
80105c83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c87:	90                   	nop
    end_op();
80105c88:	e8 b3 d9 ff ff       	call   80103640 <end_op>
    return -1;
80105c8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c92:	c9                   	leave  
80105c93:	c3                   	ret    
80105c94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c9f:	90                   	nop

80105ca0 <sys_chdir>:

int
sys_chdir(void)
{
80105ca0:	f3 0f 1e fb          	endbr32 
80105ca4:	55                   	push   %ebp
80105ca5:	89 e5                	mov    %esp,%ebp
80105ca7:	56                   	push   %esi
80105ca8:	53                   	push   %ebx
80105ca9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105cac:	e8 4f e5 ff ff       	call   80104200 <myproc>
80105cb1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105cb3:	e8 18 d9 ff ff       	call   801035d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105cb8:	83 ec 08             	sub    $0x8,%esp
80105cbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cbe:	50                   	push   %eax
80105cbf:	6a 00                	push   $0x0
80105cc1:	e8 ca f5 ff ff       	call   80105290 <argstr>
80105cc6:	83 c4 10             	add    $0x10,%esp
80105cc9:	85 c0                	test   %eax,%eax
80105ccb:	78 73                	js     80105d40 <sys_chdir+0xa0>
80105ccd:	83 ec 0c             	sub    $0xc,%esp
80105cd0:	ff 75 f4             	pushl  -0xc(%ebp)
80105cd3:	e8 58 c3 ff ff       	call   80102030 <namei>
80105cd8:	83 c4 10             	add    $0x10,%esp
80105cdb:	89 c3                	mov    %eax,%ebx
80105cdd:	85 c0                	test   %eax,%eax
80105cdf:	74 5f                	je     80105d40 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105ce1:	83 ec 0c             	sub    $0xc,%esp
80105ce4:	50                   	push   %eax
80105ce5:	e8 76 ba ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cf2:	75 2c                	jne    80105d20 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105cf4:	83 ec 0c             	sub    $0xc,%esp
80105cf7:	53                   	push   %ebx
80105cf8:	e8 43 bb ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105cfd:	58                   	pop    %eax
80105cfe:	ff 76 68             	pushl  0x68(%esi)
80105d01:	e8 8a bb ff ff       	call   80101890 <iput>
  end_op();
80105d06:	e8 35 d9 ff ff       	call   80103640 <end_op>
  curproc->cwd = ip;
80105d0b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105d0e:	83 c4 10             	add    $0x10,%esp
80105d11:	31 c0                	xor    %eax,%eax
}
80105d13:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d16:	5b                   	pop    %ebx
80105d17:	5e                   	pop    %esi
80105d18:	5d                   	pop    %ebp
80105d19:	c3                   	ret    
80105d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105d20:	83 ec 0c             	sub    $0xc,%esp
80105d23:	53                   	push   %ebx
80105d24:	e8 d7 bc ff ff       	call   80101a00 <iunlockput>
    end_op();
80105d29:	e8 12 d9 ff ff       	call   80103640 <end_op>
    return -1;
80105d2e:	83 c4 10             	add    $0x10,%esp
80105d31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d36:	eb db                	jmp    80105d13 <sys_chdir+0x73>
80105d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3f:	90                   	nop
    end_op();
80105d40:	e8 fb d8 ff ff       	call   80103640 <end_op>
    return -1;
80105d45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d4a:	eb c7                	jmp    80105d13 <sys_chdir+0x73>
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_exec>:

int
sys_exec(void)
{
80105d50:	f3 0f 1e fb          	endbr32 
80105d54:	55                   	push   %ebp
80105d55:	89 e5                	mov    %esp,%ebp
80105d57:	57                   	push   %edi
80105d58:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d59:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d5f:	53                   	push   %ebx
80105d60:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d66:	50                   	push   %eax
80105d67:	6a 00                	push   $0x0
80105d69:	e8 22 f5 ff ff       	call   80105290 <argstr>
80105d6e:	83 c4 10             	add    $0x10,%esp
80105d71:	85 c0                	test   %eax,%eax
80105d73:	0f 88 8b 00 00 00    	js     80105e04 <sys_exec+0xb4>
80105d79:	83 ec 08             	sub    $0x8,%esp
80105d7c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d82:	50                   	push   %eax
80105d83:	6a 01                	push   $0x1
80105d85:	e8 56 f4 ff ff       	call   801051e0 <argint>
80105d8a:	83 c4 10             	add    $0x10,%esp
80105d8d:	85 c0                	test   %eax,%eax
80105d8f:	78 73                	js     80105e04 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d91:	83 ec 04             	sub    $0x4,%esp
80105d94:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105d9a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d9c:	68 80 00 00 00       	push   $0x80
80105da1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105da7:	6a 00                	push   $0x0
80105da9:	50                   	push   %eax
80105daa:	e8 51 f1 ff ff       	call   80104f00 <memset>
80105daf:	83 c4 10             	add    $0x10,%esp
80105db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105db8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105dbe:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105dc5:	83 ec 08             	sub    $0x8,%esp
80105dc8:	57                   	push   %edi
80105dc9:	01 f0                	add    %esi,%eax
80105dcb:	50                   	push   %eax
80105dcc:	e8 6f f3 ff ff       	call   80105140 <fetchint>
80105dd1:	83 c4 10             	add    $0x10,%esp
80105dd4:	85 c0                	test   %eax,%eax
80105dd6:	78 2c                	js     80105e04 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105dd8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105dde:	85 c0                	test   %eax,%eax
80105de0:	74 36                	je     80105e18 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105de2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105de8:	83 ec 08             	sub    $0x8,%esp
80105deb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105dee:	52                   	push   %edx
80105def:	50                   	push   %eax
80105df0:	e8 8b f3 ff ff       	call   80105180 <fetchstr>
80105df5:	83 c4 10             	add    $0x10,%esp
80105df8:	85 c0                	test   %eax,%eax
80105dfa:	78 08                	js     80105e04 <sys_exec+0xb4>
  for(i=0;; i++){
80105dfc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105dff:	83 fb 20             	cmp    $0x20,%ebx
80105e02:	75 b4                	jne    80105db8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105e04:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e0c:	5b                   	pop    %ebx
80105e0d:	5e                   	pop    %esi
80105e0e:	5f                   	pop    %edi
80105e0f:	5d                   	pop    %ebp
80105e10:	c3                   	ret    
80105e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105e18:	83 ec 08             	sub    $0x8,%esp
80105e1b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105e21:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e28:	00 00 00 00 
  return exec(path, argv);
80105e2c:	50                   	push   %eax
80105e2d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e33:	e8 48 ac ff ff       	call   80100a80 <exec>
80105e38:	83 c4 10             	add    $0x10,%esp
}
80105e3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e3e:	5b                   	pop    %ebx
80105e3f:	5e                   	pop    %esi
80105e40:	5f                   	pop    %edi
80105e41:	5d                   	pop    %ebp
80105e42:	c3                   	ret    
80105e43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e50 <sys_pipe>:

int
sys_pipe(void)
{
80105e50:	f3 0f 1e fb          	endbr32 
80105e54:	55                   	push   %ebp
80105e55:	89 e5                	mov    %esp,%ebp
80105e57:	57                   	push   %edi
80105e58:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e59:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e5c:	53                   	push   %ebx
80105e5d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e60:	6a 08                	push   $0x8
80105e62:	50                   	push   %eax
80105e63:	6a 00                	push   $0x0
80105e65:	e8 c6 f3 ff ff       	call   80105230 <argptr>
80105e6a:	83 c4 10             	add    $0x10,%esp
80105e6d:	85 c0                	test   %eax,%eax
80105e6f:	78 4e                	js     80105ebf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e71:	83 ec 08             	sub    $0x8,%esp
80105e74:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e77:	50                   	push   %eax
80105e78:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e7b:	50                   	push   %eax
80105e7c:	e8 0f de ff ff       	call   80103c90 <pipealloc>
80105e81:	83 c4 10             	add    $0x10,%esp
80105e84:	85 c0                	test   %eax,%eax
80105e86:	78 37                	js     80105ebf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e88:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e8b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e8d:	e8 6e e3 ff ff       	call   80104200 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105e98:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e9c:	85 f6                	test   %esi,%esi
80105e9e:	74 30                	je     80105ed0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105ea0:	83 c3 01             	add    $0x1,%ebx
80105ea3:	83 fb 10             	cmp    $0x10,%ebx
80105ea6:	75 f0                	jne    80105e98 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105ea8:	83 ec 0c             	sub    $0xc,%esp
80105eab:	ff 75 e0             	pushl  -0x20(%ebp)
80105eae:	e8 0d b0 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105eb3:	58                   	pop    %eax
80105eb4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105eb7:	e8 04 b0 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105ebc:	83 c4 10             	add    $0x10,%esp
80105ebf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec4:	eb 5b                	jmp    80105f21 <sys_pipe+0xd1>
80105ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ecd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105ed0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ed3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ed7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105eda:	e8 21 e3 ff ff       	call   80104200 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105edf:	31 d2                	xor    %edx,%edx
80105ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105ee8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105eec:	85 c9                	test   %ecx,%ecx
80105eee:	74 20                	je     80105f10 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105ef0:	83 c2 01             	add    $0x1,%edx
80105ef3:	83 fa 10             	cmp    $0x10,%edx
80105ef6:	75 f0                	jne    80105ee8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105ef8:	e8 03 e3 ff ff       	call   80104200 <myproc>
80105efd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105f04:	00 
80105f05:	eb a1                	jmp    80105ea8 <sys_pipe+0x58>
80105f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105f10:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105f14:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f17:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f19:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f1c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f1f:	31 c0                	xor    %eax,%eax
}
80105f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f24:	5b                   	pop    %ebx
80105f25:	5e                   	pop    %esi
80105f26:	5f                   	pop    %edi
80105f27:	5d                   	pop    %ebp
80105f28:	c3                   	ret    
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f30 <sys_swapread>:

int sys_swapread(void)
{
80105f30:	f3 0f 1e fb          	endbr32 
80105f34:	55                   	push   %ebp
80105f35:	89 e5                	mov    %esp,%ebp
80105f37:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105f3a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f3d:	68 00 10 00 00       	push   $0x1000
80105f42:	50                   	push   %eax
80105f43:	6a 00                	push   $0x0
80105f45:	e8 e6 f2 ff ff       	call   80105230 <argptr>
80105f4a:	83 c4 10             	add    $0x10,%esp
80105f4d:	85 c0                	test   %eax,%eax
80105f4f:	78 2f                	js     80105f80 <sys_swapread+0x50>
80105f51:	83 ec 08             	sub    $0x8,%esp
80105f54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f57:	50                   	push   %eax
80105f58:	6a 01                	push   $0x1
80105f5a:	e8 81 f2 ff ff       	call   801051e0 <argint>
80105f5f:	83 c4 10             	add    $0x10,%esp
80105f62:	85 c0                	test   %eax,%eax
80105f64:	78 1a                	js     80105f80 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
80105f66:	83 ec 08             	sub    $0x8,%esp
80105f69:	ff 75 f4             	pushl  -0xc(%ebp)
80105f6c:	ff 75 f0             	pushl  -0x10(%ebp)
80105f6f:	e8 fc c0 ff ff       	call   80102070 <swapread>
	return 0;
80105f74:	83 c4 10             	add    $0x10,%esp
80105f77:	31 c0                	xor    %eax,%eax
}
80105f79:	c9                   	leave  
80105f7a:	c3                   	ret    
80105f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f7f:	90                   	nop
80105f80:	c9                   	leave  
		return -1;
80105f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f86:	c3                   	ret    
80105f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <sys_swapwrite>:

int sys_swapwrite(void)
{
80105f90:	f3 0f 1e fb          	endbr32 
80105f94:	55                   	push   %ebp
80105f95:	89 e5                	mov    %esp,%ebp
80105f97:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105f9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f9d:	68 00 10 00 00       	push   $0x1000
80105fa2:	50                   	push   %eax
80105fa3:	6a 00                	push   $0x0
80105fa5:	e8 86 f2 ff ff       	call   80105230 <argptr>
80105faa:	83 c4 10             	add    $0x10,%esp
80105fad:	85 c0                	test   %eax,%eax
80105faf:	78 2f                	js     80105fe0 <sys_swapwrite+0x50>
80105fb1:	83 ec 08             	sub    $0x8,%esp
80105fb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fb7:	50                   	push   %eax
80105fb8:	6a 01                	push   $0x1
80105fba:	e8 21 f2 ff ff       	call   801051e0 <argint>
80105fbf:	83 c4 10             	add    $0x10,%esp
80105fc2:	85 c0                	test   %eax,%eax
80105fc4:	78 1a                	js     80105fe0 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
80105fc6:	83 ec 08             	sub    $0x8,%esp
80105fc9:	ff 75 f4             	pushl  -0xc(%ebp)
80105fcc:	ff 75 f0             	pushl  -0x10(%ebp)
80105fcf:	e8 2c c1 ff ff       	call   80102100 <swapwrite>
	return 0;
80105fd4:	83 c4 10             	add    $0x10,%esp
80105fd7:	31 c0                	xor    %eax,%eax
}
80105fd9:	c9                   	leave  
80105fda:	c3                   	ret    
80105fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fdf:	90                   	nop
80105fe0:	c9                   	leave  
		return -1;
80105fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fe6:	c3                   	ret    
80105fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <sys_swapstat>:

int sys_swapstat(void)
{
80105ff0:	f3 0f 1e fb          	endbr32 
80105ff4:	55                   	push   %ebp
80105ff5:	89 e5                	mov    %esp,%ebp
80105ff7:	53                   	push   %ebx
	int* nr_read;
	int* nr_write;
	
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105ff8:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
80105ffb:	83 ec 18             	sub    $0x18,%esp
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105ffe:	6a 04                	push   $0x4
80106000:	50                   	push   %eax
80106001:	6a 00                	push   $0x0
80106003:	e8 28 f2 ff ff       	call   80105230 <argptr>
80106008:	83 c4 10             	add    $0x10,%esp
8010600b:	85 c0                	test   %eax,%eax
8010600d:	75 39                	jne    80106048 <sys_swapstat+0x58>
			argptr(1, (void*)&nr_write, sizeof(*nr_write)) < 0)
8010600f:	83 ec 04             	sub    $0x4,%esp
80106012:	89 c3                	mov    %eax,%ebx
80106014:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106017:	6a 04                	push   $0x4
80106019:	50                   	push   %eax
8010601a:	6a 01                	push   $0x1
8010601c:	e8 0f f2 ff ff       	call   80105230 <argptr>
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80106021:	83 c4 10             	add    $0x10,%esp
80106024:	85 c0                	test   %eax,%eax
80106026:	78 20                	js     80106048 <sys_swapstat+0x58>
		return -1;

	*nr_read = nr_sectors_read;
80106028:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010602b:	8b 15 c0 19 11 80    	mov    0x801119c0,%edx
80106031:	89 10                	mov    %edx,(%eax)
	*nr_write = nr_sectors_write;
80106033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106036:	8b 15 e0 19 11 80    	mov    0x801119e0,%edx
8010603c:	89 10                	mov    %edx,(%eax)
	return 0;
}
8010603e:	89 d8                	mov    %ebx,%eax
80106040:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106043:	c9                   	leave  
80106044:	c3                   	ret    
80106045:	8d 76 00             	lea    0x0(%esi),%esi
		return -1;
80106048:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010604d:	eb ef                	jmp    8010603e <sys_swapstat+0x4e>
8010604f:	90                   	nop

80106050 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106050:	f3 0f 1e fb          	endbr32 
  return fork();
80106054:	e9 67 e3 ff ff       	jmp    801043c0 <fork>
80106059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106060 <sys_exit>:
}

int
sys_exit(void)
{
80106060:	f3 0f 1e fb          	endbr32 
80106064:	55                   	push   %ebp
80106065:	89 e5                	mov    %esp,%ebp
80106067:	83 ec 08             	sub    $0x8,%esp
  exit();
8010606a:	e8 b1 e5 ff ff       	call   80104620 <exit>
  return 0;  // not reached
}
8010606f:	31 c0                	xor    %eax,%eax
80106071:	c9                   	leave  
80106072:	c3                   	ret    
80106073:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106080 <sys_wait>:

int
sys_wait(void)
{
80106080:	f3 0f 1e fb          	endbr32 
  return wait();
80106084:	e9 e7 e7 ff ff       	jmp    80104870 <wait>
80106089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106090 <sys_kill>:
}

int
sys_kill(void)
{
80106090:	f3 0f 1e fb          	endbr32 
80106094:	55                   	push   %ebp
80106095:	89 e5                	mov    %esp,%ebp
80106097:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010609a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010609d:	50                   	push   %eax
8010609e:	6a 00                	push   $0x0
801060a0:	e8 3b f1 ff ff       	call   801051e0 <argint>
801060a5:	83 c4 10             	add    $0x10,%esp
801060a8:	85 c0                	test   %eax,%eax
801060aa:	78 14                	js     801060c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801060ac:	83 ec 0c             	sub    $0xc,%esp
801060af:	ff 75 f4             	pushl  -0xc(%ebp)
801060b2:	e8 19 e9 ff ff       	call   801049d0 <kill>
801060b7:	83 c4 10             	add    $0x10,%esp
}
801060ba:	c9                   	leave  
801060bb:	c3                   	ret    
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060c0:	c9                   	leave  
    return -1;
801060c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060c6:	c3                   	ret    
801060c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ce:	66 90                	xchg   %ax,%ax

801060d0 <sys_getpid>:

int
sys_getpid(void)
{
801060d0:	f3 0f 1e fb          	endbr32 
801060d4:	55                   	push   %ebp
801060d5:	89 e5                	mov    %esp,%ebp
801060d7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801060da:	e8 21 e1 ff ff       	call   80104200 <myproc>
801060df:	8b 40 10             	mov    0x10(%eax),%eax
}
801060e2:	c9                   	leave  
801060e3:	c3                   	ret    
801060e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060ef:	90                   	nop

801060f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801060f0:	f3 0f 1e fb          	endbr32 
801060f4:	55                   	push   %ebp
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801060f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060fb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801060fe:	50                   	push   %eax
801060ff:	6a 00                	push   $0x0
80106101:	e8 da f0 ff ff       	call   801051e0 <argint>
80106106:	83 c4 10             	add    $0x10,%esp
80106109:	85 c0                	test   %eax,%eax
8010610b:	78 23                	js     80106130 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010610d:	e8 ee e0 ff ff       	call   80104200 <myproc>
  if(growproc(n) < 0)
80106112:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106115:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106117:	ff 75 f4             	pushl  -0xc(%ebp)
8010611a:	e8 21 e2 ff ff       	call   80104340 <growproc>
8010611f:	83 c4 10             	add    $0x10,%esp
80106122:	85 c0                	test   %eax,%eax
80106124:	78 0a                	js     80106130 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106126:	89 d8                	mov    %ebx,%eax
80106128:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010612b:	c9                   	leave  
8010612c:	c3                   	ret    
8010612d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106130:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106135:	eb ef                	jmp    80106126 <sys_sbrk+0x36>
80106137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010613e:	66 90                	xchg   %ax,%ax

80106140 <sys_sleep>:

int
sys_sleep(void)
{
80106140:	f3 0f 1e fb          	endbr32 
80106144:	55                   	push   %ebp
80106145:	89 e5                	mov    %esp,%ebp
80106147:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106148:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010614b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010614e:	50                   	push   %eax
8010614f:	6a 00                	push   $0x0
80106151:	e8 8a f0 ff ff       	call   801051e0 <argint>
80106156:	83 c4 10             	add    $0x10,%esp
80106159:	85 c0                	test   %eax,%eax
8010615b:	0f 88 86 00 00 00    	js     801061e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106161:	83 ec 0c             	sub    $0xc,%esp
80106164:	68 c0 bc 11 80       	push   $0x8011bcc0
80106169:	e8 82 ec ff ff       	call   80104df0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010616e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106171:	8b 1d 00 c5 11 80    	mov    0x8011c500,%ebx
  while(ticks - ticks0 < n){
80106177:	83 c4 10             	add    $0x10,%esp
8010617a:	85 d2                	test   %edx,%edx
8010617c:	75 23                	jne    801061a1 <sys_sleep+0x61>
8010617e:	eb 50                	jmp    801061d0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106180:	83 ec 08             	sub    $0x8,%esp
80106183:	68 c0 bc 11 80       	push   $0x8011bcc0
80106188:	68 00 c5 11 80       	push   $0x8011c500
8010618d:	e8 1e e6 ff ff       	call   801047b0 <sleep>
  while(ticks - ticks0 < n){
80106192:	a1 00 c5 11 80       	mov    0x8011c500,%eax
80106197:	83 c4 10             	add    $0x10,%esp
8010619a:	29 d8                	sub    %ebx,%eax
8010619c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010619f:	73 2f                	jae    801061d0 <sys_sleep+0x90>
    if(myproc()->killed){
801061a1:	e8 5a e0 ff ff       	call   80104200 <myproc>
801061a6:	8b 40 24             	mov    0x24(%eax),%eax
801061a9:	85 c0                	test   %eax,%eax
801061ab:	74 d3                	je     80106180 <sys_sleep+0x40>
      release(&tickslock);
801061ad:	83 ec 0c             	sub    $0xc,%esp
801061b0:	68 c0 bc 11 80       	push   $0x8011bcc0
801061b5:	e8 f6 ec ff ff       	call   80104eb0 <release>
  }
  release(&tickslock);
  return 0;
}
801061ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801061bd:	83 c4 10             	add    $0x10,%esp
801061c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061c5:	c9                   	leave  
801061c6:	c3                   	ret    
801061c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801061d0:	83 ec 0c             	sub    $0xc,%esp
801061d3:	68 c0 bc 11 80       	push   $0x8011bcc0
801061d8:	e8 d3 ec ff ff       	call   80104eb0 <release>
  return 0;
801061dd:	83 c4 10             	add    $0x10,%esp
801061e0:	31 c0                	xor    %eax,%eax
}
801061e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061e5:	c9                   	leave  
801061e6:	c3                   	ret    
    return -1;
801061e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ec:	eb f4                	jmp    801061e2 <sys_sleep+0xa2>
801061ee:	66 90                	xchg   %ax,%ax

801061f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801061f0:	f3 0f 1e fb          	endbr32 
801061f4:	55                   	push   %ebp
801061f5:	89 e5                	mov    %esp,%ebp
801061f7:	53                   	push   %ebx
801061f8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801061fb:	68 c0 bc 11 80       	push   $0x8011bcc0
80106200:	e8 eb eb ff ff       	call   80104df0 <acquire>
  xticks = ticks;
80106205:	8b 1d 00 c5 11 80    	mov    0x8011c500,%ebx
  release(&tickslock);
8010620b:	c7 04 24 c0 bc 11 80 	movl   $0x8011bcc0,(%esp)
80106212:	e8 99 ec ff ff       	call   80104eb0 <release>
  return xticks;
}
80106217:	89 d8                	mov    %ebx,%eax
80106219:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010621c:	c9                   	leave  
8010621d:	c3                   	ret    

8010621e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010621e:	1e                   	push   %ds
  pushl %es
8010621f:	06                   	push   %es
  pushl %fs
80106220:	0f a0                	push   %fs
  pushl %gs
80106222:	0f a8                	push   %gs
  pushal
80106224:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106225:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106229:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010622b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010622d:	54                   	push   %esp
  call trap
8010622e:	e8 cd 00 00 00       	call   80106300 <trap>
  addl $4, %esp
80106233:	83 c4 04             	add    $0x4,%esp

80106236 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106236:	61                   	popa   
  popl %gs
80106237:	0f a9                	pop    %gs
  popl %fs
80106239:	0f a1                	pop    %fs
  popl %es
8010623b:	07                   	pop    %es
  popl %ds
8010623c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010623d:	83 c4 08             	add    $0x8,%esp
  iret
80106240:	cf                   	iret   
80106241:	66 90                	xchg   %ax,%ax
80106243:	66 90                	xchg   %ax,%ax
80106245:	66 90                	xchg   %ax,%ax
80106247:	66 90                	xchg   %ax,%ax
80106249:	66 90                	xchg   %ax,%ax
8010624b:	66 90                	xchg   %ax,%ax
8010624d:	66 90                	xchg   %ax,%ax
8010624f:	90                   	nop

80106250 <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
80106250:	f3 0f 1e fb          	endbr32 
80106254:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
80106255:	31 c0                	xor    %eax,%eax
{
80106257:	89 e5                	mov    %esp,%ebp
80106259:	83 ec 08             	sub    $0x8,%esp
8010625c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106260:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106267:	c7 04 c5 02 bd 11 80 	movl   $0x8e000008,-0x7fee42fe(,%eax,8)
8010626e:	08 00 00 8e 
80106272:	66 89 14 c5 00 bd 11 	mov    %dx,-0x7fee4300(,%eax,8)
80106279:	80 
8010627a:	c1 ea 10             	shr    $0x10,%edx
8010627d:	66 89 14 c5 06 bd 11 	mov    %dx,-0x7fee42fa(,%eax,8)
80106284:	80 
  for (i = 0; i < 256; i++)
80106285:	83 c0 01             	add    $0x1,%eax
80106288:	3d 00 01 00 00       	cmp    $0x100,%eax
8010628d:	75 d1                	jne    80106260 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010628f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106292:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106297:	c7 05 02 bf 11 80 08 	movl   $0xef000008,0x8011bf02
8010629e:	00 00 ef 
  initlock(&tickslock, "time");
801062a1:	68 c5 87 10 80       	push   $0x801087c5
801062a6:	68 c0 bc 11 80       	push   $0x8011bcc0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801062ab:	66 a3 00 bf 11 80    	mov    %ax,0x8011bf00
801062b1:	c1 e8 10             	shr    $0x10,%eax
801062b4:	66 a3 06 bf 11 80    	mov    %ax,0x8011bf06
  initlock(&tickslock, "time");
801062ba:	e8 b1 e9 ff ff       	call   80104c70 <initlock>
}
801062bf:	83 c4 10             	add    $0x10,%esp
801062c2:	c9                   	leave  
801062c3:	c3                   	ret    
801062c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062cf:	90                   	nop

801062d0 <idtinit>:

void idtinit(void)
{
801062d0:	f3 0f 1e fb          	endbr32 
801062d4:	55                   	push   %ebp
  pd[0] = size-1;
801062d5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801062da:	89 e5                	mov    %esp,%ebp
801062dc:	83 ec 10             	sub    $0x10,%esp
801062df:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801062e3:	b8 00 bd 11 80       	mov    $0x8011bd00,%eax
801062e8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801062ec:	c1 e8 10             	shr    $0x10,%eax
801062ef:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801062f3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801062f6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801062f9:	c9                   	leave  
801062fa:	c3                   	ret    
801062fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062ff:	90                   	nop

80106300 <trap>:

void trap(struct trapframe *tf)
{
80106300:	f3 0f 1e fb          	endbr32 
80106304:	55                   	push   %ebp
80106305:	89 e5                	mov    %esp,%ebp
80106307:	57                   	push   %edi
80106308:	56                   	push   %esi
80106309:	53                   	push   %ebx
8010630a:	83 ec 1c             	sub    $0x1c,%esp
8010630d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (tf->trapno == T_SYSCALL)
80106310:	8b 43 30             	mov    0x30(%ebx),%eax
80106313:	83 f8 40             	cmp    $0x40,%eax
80106316:	0f 84 ec 01 00 00    	je     80106508 <trap+0x208>
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
8010631c:	83 e8 0e             	sub    $0xe,%eax
8010631f:	83 f8 31             	cmp    $0x31,%eax
80106322:	77 08                	ja     8010632c <trap+0x2c>
80106324:	3e ff 24 85 6c 88 10 	notrack jmp *-0x7fef7794(,%eax,4)
8010632b:	80 
  case T_PGFLT:
    page_fault_handler(myproc()->pgdir, rcr2());
    break;

  default:
    if (myproc() == 0 || (tf->cs & 3) == 0)
8010632c:	e8 cf de ff ff       	call   80104200 <myproc>
80106331:	85 c0                	test   %eax,%eax
80106333:	0f 84 1e 02 00 00    	je     80106557 <trap+0x257>
80106339:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010633d:	0f 84 14 02 00 00    	je     80106557 <trap+0x257>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106343:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106346:	8b 53 38             	mov    0x38(%ebx),%edx
80106349:	89 4d d8             	mov    %ecx,-0x28(%ebp)
8010634c:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010634f:	e8 8c de ff ff       	call   801041e0 <cpuid>
80106354:	8b 73 30             	mov    0x30(%ebx),%esi
80106357:	89 c7                	mov    %eax,%edi
80106359:	8b 43 34             	mov    0x34(%ebx),%eax
8010635c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010635f:	e8 9c de ff ff       	call   80104200 <myproc>
80106364:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106367:	e8 94 de ff ff       	call   80104200 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010636c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010636f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106372:	51                   	push   %ecx
80106373:	52                   	push   %edx
80106374:	57                   	push   %edi
80106375:	ff 75 e4             	pushl  -0x1c(%ebp)
80106378:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106379:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010637c:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010637f:	56                   	push   %esi
80106380:	ff 70 10             	pushl  0x10(%eax)
80106383:	68 28 88 10 80       	push   $0x80108828
80106388:	e8 23 a3 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010638d:	83 c4 20             	add    $0x20,%esp
80106390:	e8 6b de ff ff       	call   80104200 <myproc>
80106395:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010639c:	e8 5f de ff ff       	call   80104200 <myproc>
801063a1:	85 c0                	test   %eax,%eax
801063a3:	74 1d                	je     801063c2 <trap+0xc2>
801063a5:	e8 56 de ff ff       	call   80104200 <myproc>
801063aa:	8b 50 24             	mov    0x24(%eax),%edx
801063ad:	85 d2                	test   %edx,%edx
801063af:	74 11                	je     801063c2 <trap+0xc2>
801063b1:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801063b5:	83 e0 03             	and    $0x3,%eax
801063b8:	66 83 f8 03          	cmp    $0x3,%ax
801063bc:	0f 84 7e 01 00 00    	je     80106540 <trap+0x240>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING &&
801063c2:	e8 39 de ff ff       	call   80104200 <myproc>
801063c7:	85 c0                	test   %eax,%eax
801063c9:	74 0f                	je     801063da <trap+0xda>
801063cb:	e8 30 de ff ff       	call   80104200 <myproc>
801063d0:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801063d4:	0f 84 16 01 00 00    	je     801064f0 <trap+0x1f0>
      tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801063da:	e8 21 de ff ff       	call   80104200 <myproc>
801063df:	85 c0                	test   %eax,%eax
801063e1:	74 1d                	je     80106400 <trap+0x100>
801063e3:	e8 18 de ff ff       	call   80104200 <myproc>
801063e8:	8b 40 24             	mov    0x24(%eax),%eax
801063eb:	85 c0                	test   %eax,%eax
801063ed:	74 11                	je     80106400 <trap+0x100>
801063ef:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801063f3:	83 e0 03             	and    $0x3,%eax
801063f6:	66 83 f8 03          	cmp    $0x3,%ax
801063fa:	0f 84 31 01 00 00    	je     80106531 <trap+0x231>
    exit();
}
80106400:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106403:	5b                   	pop    %ebx
80106404:	5e                   	pop    %esi
80106405:	5f                   	pop    %edi
80106406:	5d                   	pop    %ebp
80106407:	c3                   	ret    
    ideintr();
80106408:	e8 e3 be ff ff       	call   801022f0 <ideintr>
    lapiceoi();
8010640d:	e8 4e cd ff ff       	call   80103160 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106412:	e8 e9 dd ff ff       	call   80104200 <myproc>
80106417:	85 c0                	test   %eax,%eax
80106419:	75 8a                	jne    801063a5 <trap+0xa5>
8010641b:	eb a5                	jmp    801063c2 <trap+0xc2>
8010641d:	0f 20 d6             	mov    %cr2,%esi
    page_fault_handler(myproc()->pgdir, rcr2());
80106420:	e8 db dd ff ff       	call   80104200 <myproc>
80106425:	83 ec 08             	sub    $0x8,%esp
80106428:	56                   	push   %esi
80106429:	ff 70 04             	pushl  0x4(%eax)
8010642c:	e8 ff c9 ff ff       	call   80102e30 <page_fault_handler>
    break;
80106431:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106434:	e8 c7 dd ff ff       	call   80104200 <myproc>
80106439:	85 c0                	test   %eax,%eax
8010643b:	0f 85 64 ff ff ff    	jne    801063a5 <trap+0xa5>
80106441:	e9 7c ff ff ff       	jmp    801063c2 <trap+0xc2>
    if (cpuid() == 0)
80106446:	e8 95 dd ff ff       	call   801041e0 <cpuid>
8010644b:	85 c0                	test   %eax,%eax
8010644d:	75 be                	jne    8010640d <trap+0x10d>
      acquire(&tickslock);
8010644f:	83 ec 0c             	sub    $0xc,%esp
80106452:	68 c0 bc 11 80       	push   $0x8011bcc0
80106457:	e8 94 e9 ff ff       	call   80104df0 <acquire>
      wakeup(&ticks);
8010645c:	c7 04 24 00 c5 11 80 	movl   $0x8011c500,(%esp)
      ticks++;
80106463:	83 05 00 c5 11 80 01 	addl   $0x1,0x8011c500
      wakeup(&ticks);
8010646a:	e8 01 e5 ff ff       	call   80104970 <wakeup>
      release(&tickslock);
8010646f:	c7 04 24 c0 bc 11 80 	movl   $0x8011bcc0,(%esp)
80106476:	e8 35 ea ff ff       	call   80104eb0 <release>
8010647b:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010647e:	eb 8d                	jmp    8010640d <trap+0x10d>
    kbdintr();
80106480:	e8 9b cb ff ff       	call   80103020 <kbdintr>
    lapiceoi();
80106485:	e8 d6 cc ff ff       	call   80103160 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010648a:	e8 71 dd ff ff       	call   80104200 <myproc>
8010648f:	85 c0                	test   %eax,%eax
80106491:	0f 85 0e ff ff ff    	jne    801063a5 <trap+0xa5>
80106497:	e9 26 ff ff ff       	jmp    801063c2 <trap+0xc2>
    uartintr();
8010649c:	e8 5f 02 00 00       	call   80106700 <uartintr>
    lapiceoi();
801064a1:	e8 ba cc ff ff       	call   80103160 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801064a6:	e8 55 dd ff ff       	call   80104200 <myproc>
801064ab:	85 c0                	test   %eax,%eax
801064ad:	0f 85 f2 fe ff ff    	jne    801063a5 <trap+0xa5>
801064b3:	e9 0a ff ff ff       	jmp    801063c2 <trap+0xc2>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064b8:	8b 7b 38             	mov    0x38(%ebx),%edi
801064bb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801064bf:	e8 1c dd ff ff       	call   801041e0 <cpuid>
801064c4:	57                   	push   %edi
801064c5:	56                   	push   %esi
801064c6:	50                   	push   %eax
801064c7:	68 d0 87 10 80       	push   $0x801087d0
801064cc:	e8 df a1 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801064d1:	e8 8a cc ff ff       	call   80103160 <lapiceoi>
    break;
801064d6:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801064d9:	e8 22 dd ff ff       	call   80104200 <myproc>
801064de:	85 c0                	test   %eax,%eax
801064e0:	0f 85 bf fe ff ff    	jne    801063a5 <trap+0xa5>
801064e6:	e9 d7 fe ff ff       	jmp    801063c2 <trap+0xc2>
801064eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064ef:	90                   	nop
  if (myproc() && myproc()->state == RUNNING &&
801064f0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801064f4:	0f 85 e0 fe ff ff    	jne    801063da <trap+0xda>
    yield();
801064fa:	e8 61 e2 ff ff       	call   80104760 <yield>
801064ff:	e9 d6 fe ff ff       	jmp    801063da <trap+0xda>
80106504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
80106508:	e8 f3 dc ff ff       	call   80104200 <myproc>
8010650d:	8b 70 24             	mov    0x24(%eax),%esi
80106510:	85 f6                	test   %esi,%esi
80106512:	75 3c                	jne    80106550 <trap+0x250>
    myproc()->tf = tf;
80106514:	e8 e7 dc ff ff       	call   80104200 <myproc>
80106519:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010651c:	e8 af ed ff ff       	call   801052d0 <syscall>
    if (myproc()->killed)
80106521:	e8 da dc ff ff       	call   80104200 <myproc>
80106526:	8b 48 24             	mov    0x24(%eax),%ecx
80106529:	85 c9                	test   %ecx,%ecx
8010652b:	0f 84 cf fe ff ff    	je     80106400 <trap+0x100>
}
80106531:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106534:	5b                   	pop    %ebx
80106535:	5e                   	pop    %esi
80106536:	5f                   	pop    %edi
80106537:	5d                   	pop    %ebp
      exit();
80106538:	e9 e3 e0 ff ff       	jmp    80104620 <exit>
8010653d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106540:	e8 db e0 ff ff       	call   80104620 <exit>
80106545:	e9 78 fe ff ff       	jmp    801063c2 <trap+0xc2>
8010654a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106550:	e8 cb e0 ff ff       	call   80104620 <exit>
80106555:	eb bd                	jmp    80106514 <trap+0x214>
80106557:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010655a:	8b 73 38             	mov    0x38(%ebx),%esi
8010655d:	e8 7e dc ff ff       	call   801041e0 <cpuid>
80106562:	83 ec 0c             	sub    $0xc,%esp
80106565:	57                   	push   %edi
80106566:	56                   	push   %esi
80106567:	50                   	push   %eax
80106568:	ff 73 30             	pushl  0x30(%ebx)
8010656b:	68 f4 87 10 80       	push   $0x801087f4
80106570:	e8 3b a1 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106575:	83 c4 14             	add    $0x14,%esp
80106578:	68 ca 87 10 80       	push   $0x801087ca
8010657d:	e8 0e 9e ff ff       	call   80100390 <panic>
80106582:	66 90                	xchg   %ax,%ax
80106584:	66 90                	xchg   %ax,%ax
80106586:	66 90                	xchg   %ax,%ax
80106588:	66 90                	xchg   %ax,%ax
8010658a:	66 90                	xchg   %ax,%ax
8010658c:	66 90                	xchg   %ax,%ax
8010658e:	66 90                	xchg   %ax,%ax

80106590 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106590:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106594:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106599:	85 c0                	test   %eax,%eax
8010659b:	74 1b                	je     801065b8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010659d:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065a2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801065a3:	a8 01                	test   $0x1,%al
801065a5:	74 11                	je     801065b8 <uartgetc+0x28>
801065a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065ac:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801065ad:	0f b6 c0             	movzbl %al,%eax
801065b0:	c3                   	ret    
801065b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801065b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065bd:	c3                   	ret    
801065be:	66 90                	xchg   %ax,%ax

801065c0 <uartputc.part.0>:
uartputc(int c)
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	57                   	push   %edi
801065c4:	89 c7                	mov    %eax,%edi
801065c6:	56                   	push   %esi
801065c7:	be fd 03 00 00       	mov    $0x3fd,%esi
801065cc:	53                   	push   %ebx
801065cd:	bb 80 00 00 00       	mov    $0x80,%ebx
801065d2:	83 ec 0c             	sub    $0xc,%esp
801065d5:	eb 1b                	jmp    801065f2 <uartputc.part.0+0x32>
801065d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065de:	66 90                	xchg   %ax,%ax
    microdelay(10);
801065e0:	83 ec 0c             	sub    $0xc,%esp
801065e3:	6a 0a                	push   $0xa
801065e5:	e8 96 cb ff ff       	call   80103180 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065ea:	83 c4 10             	add    $0x10,%esp
801065ed:	83 eb 01             	sub    $0x1,%ebx
801065f0:	74 07                	je     801065f9 <uartputc.part.0+0x39>
801065f2:	89 f2                	mov    %esi,%edx
801065f4:	ec                   	in     (%dx),%al
801065f5:	a8 20                	test   $0x20,%al
801065f7:	74 e7                	je     801065e0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065f9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065fe:	89 f8                	mov    %edi,%eax
80106600:	ee                   	out    %al,(%dx)
}
80106601:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106604:	5b                   	pop    %ebx
80106605:	5e                   	pop    %esi
80106606:	5f                   	pop    %edi
80106607:	5d                   	pop    %ebp
80106608:	c3                   	ret    
80106609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106610 <uartinit>:
{
80106610:	f3 0f 1e fb          	endbr32 
80106614:	55                   	push   %ebp
80106615:	31 c9                	xor    %ecx,%ecx
80106617:	89 c8                	mov    %ecx,%eax
80106619:	89 e5                	mov    %esp,%ebp
8010661b:	57                   	push   %edi
8010661c:	56                   	push   %esi
8010661d:	53                   	push   %ebx
8010661e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106623:	89 da                	mov    %ebx,%edx
80106625:	83 ec 0c             	sub    $0xc,%esp
80106628:	ee                   	out    %al,(%dx)
80106629:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010662e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106633:	89 fa                	mov    %edi,%edx
80106635:	ee                   	out    %al,(%dx)
80106636:	b8 0c 00 00 00       	mov    $0xc,%eax
8010663b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106640:	ee                   	out    %al,(%dx)
80106641:	be f9 03 00 00       	mov    $0x3f9,%esi
80106646:	89 c8                	mov    %ecx,%eax
80106648:	89 f2                	mov    %esi,%edx
8010664a:	ee                   	out    %al,(%dx)
8010664b:	b8 03 00 00 00       	mov    $0x3,%eax
80106650:	89 fa                	mov    %edi,%edx
80106652:	ee                   	out    %al,(%dx)
80106653:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106658:	89 c8                	mov    %ecx,%eax
8010665a:	ee                   	out    %al,(%dx)
8010665b:	b8 01 00 00 00       	mov    $0x1,%eax
80106660:	89 f2                	mov    %esi,%edx
80106662:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106663:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106668:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106669:	3c ff                	cmp    $0xff,%al
8010666b:	74 52                	je     801066bf <uartinit+0xaf>
  uart = 1;
8010666d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106674:	00 00 00 
80106677:	89 da                	mov    %ebx,%edx
80106679:	ec                   	in     (%dx),%al
8010667a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010667f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106680:	83 ec 08             	sub    $0x8,%esp
80106683:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106688:	bb 34 89 10 80       	mov    $0x80108934,%ebx
  ioapicenable(IRQ_COM1, 0);
8010668d:	6a 00                	push   $0x0
8010668f:	6a 04                	push   $0x4
80106691:	e8 aa be ff ff       	call   80102540 <ioapicenable>
80106696:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106699:	b8 78 00 00 00       	mov    $0x78,%eax
8010669e:	eb 04                	jmp    801066a4 <uartinit+0x94>
801066a0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801066a4:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801066aa:	85 d2                	test   %edx,%edx
801066ac:	74 08                	je     801066b6 <uartinit+0xa6>
    uartputc(*p);
801066ae:	0f be c0             	movsbl %al,%eax
801066b1:	e8 0a ff ff ff       	call   801065c0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801066b6:	89 f0                	mov    %esi,%eax
801066b8:	83 c3 01             	add    $0x1,%ebx
801066bb:	84 c0                	test   %al,%al
801066bd:	75 e1                	jne    801066a0 <uartinit+0x90>
}
801066bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066c2:	5b                   	pop    %ebx
801066c3:	5e                   	pop    %esi
801066c4:	5f                   	pop    %edi
801066c5:	5d                   	pop    %ebp
801066c6:	c3                   	ret    
801066c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ce:	66 90                	xchg   %ax,%ax

801066d0 <uartputc>:
{
801066d0:	f3 0f 1e fb          	endbr32 
801066d4:	55                   	push   %ebp
  if(!uart)
801066d5:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801066db:	89 e5                	mov    %esp,%ebp
801066dd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801066e0:	85 d2                	test   %edx,%edx
801066e2:	74 0c                	je     801066f0 <uartputc+0x20>
}
801066e4:	5d                   	pop    %ebp
801066e5:	e9 d6 fe ff ff       	jmp    801065c0 <uartputc.part.0>
801066ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801066f0:	5d                   	pop    %ebp
801066f1:	c3                   	ret    
801066f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106700 <uartintr>:

void
uartintr(void)
{
80106700:	f3 0f 1e fb          	endbr32 
80106704:	55                   	push   %ebp
80106705:	89 e5                	mov    %esp,%ebp
80106707:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010670a:	68 90 65 10 80       	push   $0x80106590
8010670f:	e8 4c a1 ff ff       	call   80100860 <consoleintr>
}
80106714:	83 c4 10             	add    $0x10,%esp
80106717:	c9                   	leave  
80106718:	c3                   	ret    

80106719 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $0
8010671b:	6a 00                	push   $0x0
  jmp alltraps
8010671d:	e9 fc fa ff ff       	jmp    8010621e <alltraps>

80106722 <vector1>:
.globl vector1
vector1:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $1
80106724:	6a 01                	push   $0x1
  jmp alltraps
80106726:	e9 f3 fa ff ff       	jmp    8010621e <alltraps>

8010672b <vector2>:
.globl vector2
vector2:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $2
8010672d:	6a 02                	push   $0x2
  jmp alltraps
8010672f:	e9 ea fa ff ff       	jmp    8010621e <alltraps>

80106734 <vector3>:
.globl vector3
vector3:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $3
80106736:	6a 03                	push   $0x3
  jmp alltraps
80106738:	e9 e1 fa ff ff       	jmp    8010621e <alltraps>

8010673d <vector4>:
.globl vector4
vector4:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $4
8010673f:	6a 04                	push   $0x4
  jmp alltraps
80106741:	e9 d8 fa ff ff       	jmp    8010621e <alltraps>

80106746 <vector5>:
.globl vector5
vector5:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $5
80106748:	6a 05                	push   $0x5
  jmp alltraps
8010674a:	e9 cf fa ff ff       	jmp    8010621e <alltraps>

8010674f <vector6>:
.globl vector6
vector6:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $6
80106751:	6a 06                	push   $0x6
  jmp alltraps
80106753:	e9 c6 fa ff ff       	jmp    8010621e <alltraps>

80106758 <vector7>:
.globl vector7
vector7:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $7
8010675a:	6a 07                	push   $0x7
  jmp alltraps
8010675c:	e9 bd fa ff ff       	jmp    8010621e <alltraps>

80106761 <vector8>:
.globl vector8
vector8:
  pushl $8
80106761:	6a 08                	push   $0x8
  jmp alltraps
80106763:	e9 b6 fa ff ff       	jmp    8010621e <alltraps>

80106768 <vector9>:
.globl vector9
vector9:
  pushl $0
80106768:	6a 00                	push   $0x0
  pushl $9
8010676a:	6a 09                	push   $0x9
  jmp alltraps
8010676c:	e9 ad fa ff ff       	jmp    8010621e <alltraps>

80106771 <vector10>:
.globl vector10
vector10:
  pushl $10
80106771:	6a 0a                	push   $0xa
  jmp alltraps
80106773:	e9 a6 fa ff ff       	jmp    8010621e <alltraps>

80106778 <vector11>:
.globl vector11
vector11:
  pushl $11
80106778:	6a 0b                	push   $0xb
  jmp alltraps
8010677a:	e9 9f fa ff ff       	jmp    8010621e <alltraps>

8010677f <vector12>:
.globl vector12
vector12:
  pushl $12
8010677f:	6a 0c                	push   $0xc
  jmp alltraps
80106781:	e9 98 fa ff ff       	jmp    8010621e <alltraps>

80106786 <vector13>:
.globl vector13
vector13:
  pushl $13
80106786:	6a 0d                	push   $0xd
  jmp alltraps
80106788:	e9 91 fa ff ff       	jmp    8010621e <alltraps>

8010678d <vector14>:
.globl vector14
vector14:
  pushl $14
8010678d:	6a 0e                	push   $0xe
  jmp alltraps
8010678f:	e9 8a fa ff ff       	jmp    8010621e <alltraps>

80106794 <vector15>:
.globl vector15
vector15:
  pushl $0
80106794:	6a 00                	push   $0x0
  pushl $15
80106796:	6a 0f                	push   $0xf
  jmp alltraps
80106798:	e9 81 fa ff ff       	jmp    8010621e <alltraps>

8010679d <vector16>:
.globl vector16
vector16:
  pushl $0
8010679d:	6a 00                	push   $0x0
  pushl $16
8010679f:	6a 10                	push   $0x10
  jmp alltraps
801067a1:	e9 78 fa ff ff       	jmp    8010621e <alltraps>

801067a6 <vector17>:
.globl vector17
vector17:
  pushl $17
801067a6:	6a 11                	push   $0x11
  jmp alltraps
801067a8:	e9 71 fa ff ff       	jmp    8010621e <alltraps>

801067ad <vector18>:
.globl vector18
vector18:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $18
801067af:	6a 12                	push   $0x12
  jmp alltraps
801067b1:	e9 68 fa ff ff       	jmp    8010621e <alltraps>

801067b6 <vector19>:
.globl vector19
vector19:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $19
801067b8:	6a 13                	push   $0x13
  jmp alltraps
801067ba:	e9 5f fa ff ff       	jmp    8010621e <alltraps>

801067bf <vector20>:
.globl vector20
vector20:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $20
801067c1:	6a 14                	push   $0x14
  jmp alltraps
801067c3:	e9 56 fa ff ff       	jmp    8010621e <alltraps>

801067c8 <vector21>:
.globl vector21
vector21:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $21
801067ca:	6a 15                	push   $0x15
  jmp alltraps
801067cc:	e9 4d fa ff ff       	jmp    8010621e <alltraps>

801067d1 <vector22>:
.globl vector22
vector22:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $22
801067d3:	6a 16                	push   $0x16
  jmp alltraps
801067d5:	e9 44 fa ff ff       	jmp    8010621e <alltraps>

801067da <vector23>:
.globl vector23
vector23:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $23
801067dc:	6a 17                	push   $0x17
  jmp alltraps
801067de:	e9 3b fa ff ff       	jmp    8010621e <alltraps>

801067e3 <vector24>:
.globl vector24
vector24:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $24
801067e5:	6a 18                	push   $0x18
  jmp alltraps
801067e7:	e9 32 fa ff ff       	jmp    8010621e <alltraps>

801067ec <vector25>:
.globl vector25
vector25:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $25
801067ee:	6a 19                	push   $0x19
  jmp alltraps
801067f0:	e9 29 fa ff ff       	jmp    8010621e <alltraps>

801067f5 <vector26>:
.globl vector26
vector26:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $26
801067f7:	6a 1a                	push   $0x1a
  jmp alltraps
801067f9:	e9 20 fa ff ff       	jmp    8010621e <alltraps>

801067fe <vector27>:
.globl vector27
vector27:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $27
80106800:	6a 1b                	push   $0x1b
  jmp alltraps
80106802:	e9 17 fa ff ff       	jmp    8010621e <alltraps>

80106807 <vector28>:
.globl vector28
vector28:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $28
80106809:	6a 1c                	push   $0x1c
  jmp alltraps
8010680b:	e9 0e fa ff ff       	jmp    8010621e <alltraps>

80106810 <vector29>:
.globl vector29
vector29:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $29
80106812:	6a 1d                	push   $0x1d
  jmp alltraps
80106814:	e9 05 fa ff ff       	jmp    8010621e <alltraps>

80106819 <vector30>:
.globl vector30
vector30:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $30
8010681b:	6a 1e                	push   $0x1e
  jmp alltraps
8010681d:	e9 fc f9 ff ff       	jmp    8010621e <alltraps>

80106822 <vector31>:
.globl vector31
vector31:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $31
80106824:	6a 1f                	push   $0x1f
  jmp alltraps
80106826:	e9 f3 f9 ff ff       	jmp    8010621e <alltraps>

8010682b <vector32>:
.globl vector32
vector32:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $32
8010682d:	6a 20                	push   $0x20
  jmp alltraps
8010682f:	e9 ea f9 ff ff       	jmp    8010621e <alltraps>

80106834 <vector33>:
.globl vector33
vector33:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $33
80106836:	6a 21                	push   $0x21
  jmp alltraps
80106838:	e9 e1 f9 ff ff       	jmp    8010621e <alltraps>

8010683d <vector34>:
.globl vector34
vector34:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $34
8010683f:	6a 22                	push   $0x22
  jmp alltraps
80106841:	e9 d8 f9 ff ff       	jmp    8010621e <alltraps>

80106846 <vector35>:
.globl vector35
vector35:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $35
80106848:	6a 23                	push   $0x23
  jmp alltraps
8010684a:	e9 cf f9 ff ff       	jmp    8010621e <alltraps>

8010684f <vector36>:
.globl vector36
vector36:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $36
80106851:	6a 24                	push   $0x24
  jmp alltraps
80106853:	e9 c6 f9 ff ff       	jmp    8010621e <alltraps>

80106858 <vector37>:
.globl vector37
vector37:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $37
8010685a:	6a 25                	push   $0x25
  jmp alltraps
8010685c:	e9 bd f9 ff ff       	jmp    8010621e <alltraps>

80106861 <vector38>:
.globl vector38
vector38:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $38
80106863:	6a 26                	push   $0x26
  jmp alltraps
80106865:	e9 b4 f9 ff ff       	jmp    8010621e <alltraps>

8010686a <vector39>:
.globl vector39
vector39:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $39
8010686c:	6a 27                	push   $0x27
  jmp alltraps
8010686e:	e9 ab f9 ff ff       	jmp    8010621e <alltraps>

80106873 <vector40>:
.globl vector40
vector40:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $40
80106875:	6a 28                	push   $0x28
  jmp alltraps
80106877:	e9 a2 f9 ff ff       	jmp    8010621e <alltraps>

8010687c <vector41>:
.globl vector41
vector41:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $41
8010687e:	6a 29                	push   $0x29
  jmp alltraps
80106880:	e9 99 f9 ff ff       	jmp    8010621e <alltraps>

80106885 <vector42>:
.globl vector42
vector42:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $42
80106887:	6a 2a                	push   $0x2a
  jmp alltraps
80106889:	e9 90 f9 ff ff       	jmp    8010621e <alltraps>

8010688e <vector43>:
.globl vector43
vector43:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $43
80106890:	6a 2b                	push   $0x2b
  jmp alltraps
80106892:	e9 87 f9 ff ff       	jmp    8010621e <alltraps>

80106897 <vector44>:
.globl vector44
vector44:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $44
80106899:	6a 2c                	push   $0x2c
  jmp alltraps
8010689b:	e9 7e f9 ff ff       	jmp    8010621e <alltraps>

801068a0 <vector45>:
.globl vector45
vector45:
  pushl $0
801068a0:	6a 00                	push   $0x0
  pushl $45
801068a2:	6a 2d                	push   $0x2d
  jmp alltraps
801068a4:	e9 75 f9 ff ff       	jmp    8010621e <alltraps>

801068a9 <vector46>:
.globl vector46
vector46:
  pushl $0
801068a9:	6a 00                	push   $0x0
  pushl $46
801068ab:	6a 2e                	push   $0x2e
  jmp alltraps
801068ad:	e9 6c f9 ff ff       	jmp    8010621e <alltraps>

801068b2 <vector47>:
.globl vector47
vector47:
  pushl $0
801068b2:	6a 00                	push   $0x0
  pushl $47
801068b4:	6a 2f                	push   $0x2f
  jmp alltraps
801068b6:	e9 63 f9 ff ff       	jmp    8010621e <alltraps>

801068bb <vector48>:
.globl vector48
vector48:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $48
801068bd:	6a 30                	push   $0x30
  jmp alltraps
801068bf:	e9 5a f9 ff ff       	jmp    8010621e <alltraps>

801068c4 <vector49>:
.globl vector49
vector49:
  pushl $0
801068c4:	6a 00                	push   $0x0
  pushl $49
801068c6:	6a 31                	push   $0x31
  jmp alltraps
801068c8:	e9 51 f9 ff ff       	jmp    8010621e <alltraps>

801068cd <vector50>:
.globl vector50
vector50:
  pushl $0
801068cd:	6a 00                	push   $0x0
  pushl $50
801068cf:	6a 32                	push   $0x32
  jmp alltraps
801068d1:	e9 48 f9 ff ff       	jmp    8010621e <alltraps>

801068d6 <vector51>:
.globl vector51
vector51:
  pushl $0
801068d6:	6a 00                	push   $0x0
  pushl $51
801068d8:	6a 33                	push   $0x33
  jmp alltraps
801068da:	e9 3f f9 ff ff       	jmp    8010621e <alltraps>

801068df <vector52>:
.globl vector52
vector52:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $52
801068e1:	6a 34                	push   $0x34
  jmp alltraps
801068e3:	e9 36 f9 ff ff       	jmp    8010621e <alltraps>

801068e8 <vector53>:
.globl vector53
vector53:
  pushl $0
801068e8:	6a 00                	push   $0x0
  pushl $53
801068ea:	6a 35                	push   $0x35
  jmp alltraps
801068ec:	e9 2d f9 ff ff       	jmp    8010621e <alltraps>

801068f1 <vector54>:
.globl vector54
vector54:
  pushl $0
801068f1:	6a 00                	push   $0x0
  pushl $54
801068f3:	6a 36                	push   $0x36
  jmp alltraps
801068f5:	e9 24 f9 ff ff       	jmp    8010621e <alltraps>

801068fa <vector55>:
.globl vector55
vector55:
  pushl $0
801068fa:	6a 00                	push   $0x0
  pushl $55
801068fc:	6a 37                	push   $0x37
  jmp alltraps
801068fe:	e9 1b f9 ff ff       	jmp    8010621e <alltraps>

80106903 <vector56>:
.globl vector56
vector56:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $56
80106905:	6a 38                	push   $0x38
  jmp alltraps
80106907:	e9 12 f9 ff ff       	jmp    8010621e <alltraps>

8010690c <vector57>:
.globl vector57
vector57:
  pushl $0
8010690c:	6a 00                	push   $0x0
  pushl $57
8010690e:	6a 39                	push   $0x39
  jmp alltraps
80106910:	e9 09 f9 ff ff       	jmp    8010621e <alltraps>

80106915 <vector58>:
.globl vector58
vector58:
  pushl $0
80106915:	6a 00                	push   $0x0
  pushl $58
80106917:	6a 3a                	push   $0x3a
  jmp alltraps
80106919:	e9 00 f9 ff ff       	jmp    8010621e <alltraps>

8010691e <vector59>:
.globl vector59
vector59:
  pushl $0
8010691e:	6a 00                	push   $0x0
  pushl $59
80106920:	6a 3b                	push   $0x3b
  jmp alltraps
80106922:	e9 f7 f8 ff ff       	jmp    8010621e <alltraps>

80106927 <vector60>:
.globl vector60
vector60:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $60
80106929:	6a 3c                	push   $0x3c
  jmp alltraps
8010692b:	e9 ee f8 ff ff       	jmp    8010621e <alltraps>

80106930 <vector61>:
.globl vector61
vector61:
  pushl $0
80106930:	6a 00                	push   $0x0
  pushl $61
80106932:	6a 3d                	push   $0x3d
  jmp alltraps
80106934:	e9 e5 f8 ff ff       	jmp    8010621e <alltraps>

80106939 <vector62>:
.globl vector62
vector62:
  pushl $0
80106939:	6a 00                	push   $0x0
  pushl $62
8010693b:	6a 3e                	push   $0x3e
  jmp alltraps
8010693d:	e9 dc f8 ff ff       	jmp    8010621e <alltraps>

80106942 <vector63>:
.globl vector63
vector63:
  pushl $0
80106942:	6a 00                	push   $0x0
  pushl $63
80106944:	6a 3f                	push   $0x3f
  jmp alltraps
80106946:	e9 d3 f8 ff ff       	jmp    8010621e <alltraps>

8010694b <vector64>:
.globl vector64
vector64:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $64
8010694d:	6a 40                	push   $0x40
  jmp alltraps
8010694f:	e9 ca f8 ff ff       	jmp    8010621e <alltraps>

80106954 <vector65>:
.globl vector65
vector65:
  pushl $0
80106954:	6a 00                	push   $0x0
  pushl $65
80106956:	6a 41                	push   $0x41
  jmp alltraps
80106958:	e9 c1 f8 ff ff       	jmp    8010621e <alltraps>

8010695d <vector66>:
.globl vector66
vector66:
  pushl $0
8010695d:	6a 00                	push   $0x0
  pushl $66
8010695f:	6a 42                	push   $0x42
  jmp alltraps
80106961:	e9 b8 f8 ff ff       	jmp    8010621e <alltraps>

80106966 <vector67>:
.globl vector67
vector67:
  pushl $0
80106966:	6a 00                	push   $0x0
  pushl $67
80106968:	6a 43                	push   $0x43
  jmp alltraps
8010696a:	e9 af f8 ff ff       	jmp    8010621e <alltraps>

8010696f <vector68>:
.globl vector68
vector68:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $68
80106971:	6a 44                	push   $0x44
  jmp alltraps
80106973:	e9 a6 f8 ff ff       	jmp    8010621e <alltraps>

80106978 <vector69>:
.globl vector69
vector69:
  pushl $0
80106978:	6a 00                	push   $0x0
  pushl $69
8010697a:	6a 45                	push   $0x45
  jmp alltraps
8010697c:	e9 9d f8 ff ff       	jmp    8010621e <alltraps>

80106981 <vector70>:
.globl vector70
vector70:
  pushl $0
80106981:	6a 00                	push   $0x0
  pushl $70
80106983:	6a 46                	push   $0x46
  jmp alltraps
80106985:	e9 94 f8 ff ff       	jmp    8010621e <alltraps>

8010698a <vector71>:
.globl vector71
vector71:
  pushl $0
8010698a:	6a 00                	push   $0x0
  pushl $71
8010698c:	6a 47                	push   $0x47
  jmp alltraps
8010698e:	e9 8b f8 ff ff       	jmp    8010621e <alltraps>

80106993 <vector72>:
.globl vector72
vector72:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $72
80106995:	6a 48                	push   $0x48
  jmp alltraps
80106997:	e9 82 f8 ff ff       	jmp    8010621e <alltraps>

8010699c <vector73>:
.globl vector73
vector73:
  pushl $0
8010699c:	6a 00                	push   $0x0
  pushl $73
8010699e:	6a 49                	push   $0x49
  jmp alltraps
801069a0:	e9 79 f8 ff ff       	jmp    8010621e <alltraps>

801069a5 <vector74>:
.globl vector74
vector74:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $74
801069a7:	6a 4a                	push   $0x4a
  jmp alltraps
801069a9:	e9 70 f8 ff ff       	jmp    8010621e <alltraps>

801069ae <vector75>:
.globl vector75
vector75:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $75
801069b0:	6a 4b                	push   $0x4b
  jmp alltraps
801069b2:	e9 67 f8 ff ff       	jmp    8010621e <alltraps>

801069b7 <vector76>:
.globl vector76
vector76:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $76
801069b9:	6a 4c                	push   $0x4c
  jmp alltraps
801069bb:	e9 5e f8 ff ff       	jmp    8010621e <alltraps>

801069c0 <vector77>:
.globl vector77
vector77:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $77
801069c2:	6a 4d                	push   $0x4d
  jmp alltraps
801069c4:	e9 55 f8 ff ff       	jmp    8010621e <alltraps>

801069c9 <vector78>:
.globl vector78
vector78:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $78
801069cb:	6a 4e                	push   $0x4e
  jmp alltraps
801069cd:	e9 4c f8 ff ff       	jmp    8010621e <alltraps>

801069d2 <vector79>:
.globl vector79
vector79:
  pushl $0
801069d2:	6a 00                	push   $0x0
  pushl $79
801069d4:	6a 4f                	push   $0x4f
  jmp alltraps
801069d6:	e9 43 f8 ff ff       	jmp    8010621e <alltraps>

801069db <vector80>:
.globl vector80
vector80:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $80
801069dd:	6a 50                	push   $0x50
  jmp alltraps
801069df:	e9 3a f8 ff ff       	jmp    8010621e <alltraps>

801069e4 <vector81>:
.globl vector81
vector81:
  pushl $0
801069e4:	6a 00                	push   $0x0
  pushl $81
801069e6:	6a 51                	push   $0x51
  jmp alltraps
801069e8:	e9 31 f8 ff ff       	jmp    8010621e <alltraps>

801069ed <vector82>:
.globl vector82
vector82:
  pushl $0
801069ed:	6a 00                	push   $0x0
  pushl $82
801069ef:	6a 52                	push   $0x52
  jmp alltraps
801069f1:	e9 28 f8 ff ff       	jmp    8010621e <alltraps>

801069f6 <vector83>:
.globl vector83
vector83:
  pushl $0
801069f6:	6a 00                	push   $0x0
  pushl $83
801069f8:	6a 53                	push   $0x53
  jmp alltraps
801069fa:	e9 1f f8 ff ff       	jmp    8010621e <alltraps>

801069ff <vector84>:
.globl vector84
vector84:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $84
80106a01:	6a 54                	push   $0x54
  jmp alltraps
80106a03:	e9 16 f8 ff ff       	jmp    8010621e <alltraps>

80106a08 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a08:	6a 00                	push   $0x0
  pushl $85
80106a0a:	6a 55                	push   $0x55
  jmp alltraps
80106a0c:	e9 0d f8 ff ff       	jmp    8010621e <alltraps>

80106a11 <vector86>:
.globl vector86
vector86:
  pushl $0
80106a11:	6a 00                	push   $0x0
  pushl $86
80106a13:	6a 56                	push   $0x56
  jmp alltraps
80106a15:	e9 04 f8 ff ff       	jmp    8010621e <alltraps>

80106a1a <vector87>:
.globl vector87
vector87:
  pushl $0
80106a1a:	6a 00                	push   $0x0
  pushl $87
80106a1c:	6a 57                	push   $0x57
  jmp alltraps
80106a1e:	e9 fb f7 ff ff       	jmp    8010621e <alltraps>

80106a23 <vector88>:
.globl vector88
vector88:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $88
80106a25:	6a 58                	push   $0x58
  jmp alltraps
80106a27:	e9 f2 f7 ff ff       	jmp    8010621e <alltraps>

80106a2c <vector89>:
.globl vector89
vector89:
  pushl $0
80106a2c:	6a 00                	push   $0x0
  pushl $89
80106a2e:	6a 59                	push   $0x59
  jmp alltraps
80106a30:	e9 e9 f7 ff ff       	jmp    8010621e <alltraps>

80106a35 <vector90>:
.globl vector90
vector90:
  pushl $0
80106a35:	6a 00                	push   $0x0
  pushl $90
80106a37:	6a 5a                	push   $0x5a
  jmp alltraps
80106a39:	e9 e0 f7 ff ff       	jmp    8010621e <alltraps>

80106a3e <vector91>:
.globl vector91
vector91:
  pushl $0
80106a3e:	6a 00                	push   $0x0
  pushl $91
80106a40:	6a 5b                	push   $0x5b
  jmp alltraps
80106a42:	e9 d7 f7 ff ff       	jmp    8010621e <alltraps>

80106a47 <vector92>:
.globl vector92
vector92:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $92
80106a49:	6a 5c                	push   $0x5c
  jmp alltraps
80106a4b:	e9 ce f7 ff ff       	jmp    8010621e <alltraps>

80106a50 <vector93>:
.globl vector93
vector93:
  pushl $0
80106a50:	6a 00                	push   $0x0
  pushl $93
80106a52:	6a 5d                	push   $0x5d
  jmp alltraps
80106a54:	e9 c5 f7 ff ff       	jmp    8010621e <alltraps>

80106a59 <vector94>:
.globl vector94
vector94:
  pushl $0
80106a59:	6a 00                	push   $0x0
  pushl $94
80106a5b:	6a 5e                	push   $0x5e
  jmp alltraps
80106a5d:	e9 bc f7 ff ff       	jmp    8010621e <alltraps>

80106a62 <vector95>:
.globl vector95
vector95:
  pushl $0
80106a62:	6a 00                	push   $0x0
  pushl $95
80106a64:	6a 5f                	push   $0x5f
  jmp alltraps
80106a66:	e9 b3 f7 ff ff       	jmp    8010621e <alltraps>

80106a6b <vector96>:
.globl vector96
vector96:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $96
80106a6d:	6a 60                	push   $0x60
  jmp alltraps
80106a6f:	e9 aa f7 ff ff       	jmp    8010621e <alltraps>

80106a74 <vector97>:
.globl vector97
vector97:
  pushl $0
80106a74:	6a 00                	push   $0x0
  pushl $97
80106a76:	6a 61                	push   $0x61
  jmp alltraps
80106a78:	e9 a1 f7 ff ff       	jmp    8010621e <alltraps>

80106a7d <vector98>:
.globl vector98
vector98:
  pushl $0
80106a7d:	6a 00                	push   $0x0
  pushl $98
80106a7f:	6a 62                	push   $0x62
  jmp alltraps
80106a81:	e9 98 f7 ff ff       	jmp    8010621e <alltraps>

80106a86 <vector99>:
.globl vector99
vector99:
  pushl $0
80106a86:	6a 00                	push   $0x0
  pushl $99
80106a88:	6a 63                	push   $0x63
  jmp alltraps
80106a8a:	e9 8f f7 ff ff       	jmp    8010621e <alltraps>

80106a8f <vector100>:
.globl vector100
vector100:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $100
80106a91:	6a 64                	push   $0x64
  jmp alltraps
80106a93:	e9 86 f7 ff ff       	jmp    8010621e <alltraps>

80106a98 <vector101>:
.globl vector101
vector101:
  pushl $0
80106a98:	6a 00                	push   $0x0
  pushl $101
80106a9a:	6a 65                	push   $0x65
  jmp alltraps
80106a9c:	e9 7d f7 ff ff       	jmp    8010621e <alltraps>

80106aa1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106aa1:	6a 00                	push   $0x0
  pushl $102
80106aa3:	6a 66                	push   $0x66
  jmp alltraps
80106aa5:	e9 74 f7 ff ff       	jmp    8010621e <alltraps>

80106aaa <vector103>:
.globl vector103
vector103:
  pushl $0
80106aaa:	6a 00                	push   $0x0
  pushl $103
80106aac:	6a 67                	push   $0x67
  jmp alltraps
80106aae:	e9 6b f7 ff ff       	jmp    8010621e <alltraps>

80106ab3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $104
80106ab5:	6a 68                	push   $0x68
  jmp alltraps
80106ab7:	e9 62 f7 ff ff       	jmp    8010621e <alltraps>

80106abc <vector105>:
.globl vector105
vector105:
  pushl $0
80106abc:	6a 00                	push   $0x0
  pushl $105
80106abe:	6a 69                	push   $0x69
  jmp alltraps
80106ac0:	e9 59 f7 ff ff       	jmp    8010621e <alltraps>

80106ac5 <vector106>:
.globl vector106
vector106:
  pushl $0
80106ac5:	6a 00                	push   $0x0
  pushl $106
80106ac7:	6a 6a                	push   $0x6a
  jmp alltraps
80106ac9:	e9 50 f7 ff ff       	jmp    8010621e <alltraps>

80106ace <vector107>:
.globl vector107
vector107:
  pushl $0
80106ace:	6a 00                	push   $0x0
  pushl $107
80106ad0:	6a 6b                	push   $0x6b
  jmp alltraps
80106ad2:	e9 47 f7 ff ff       	jmp    8010621e <alltraps>

80106ad7 <vector108>:
.globl vector108
vector108:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $108
80106ad9:	6a 6c                	push   $0x6c
  jmp alltraps
80106adb:	e9 3e f7 ff ff       	jmp    8010621e <alltraps>

80106ae0 <vector109>:
.globl vector109
vector109:
  pushl $0
80106ae0:	6a 00                	push   $0x0
  pushl $109
80106ae2:	6a 6d                	push   $0x6d
  jmp alltraps
80106ae4:	e9 35 f7 ff ff       	jmp    8010621e <alltraps>

80106ae9 <vector110>:
.globl vector110
vector110:
  pushl $0
80106ae9:	6a 00                	push   $0x0
  pushl $110
80106aeb:	6a 6e                	push   $0x6e
  jmp alltraps
80106aed:	e9 2c f7 ff ff       	jmp    8010621e <alltraps>

80106af2 <vector111>:
.globl vector111
vector111:
  pushl $0
80106af2:	6a 00                	push   $0x0
  pushl $111
80106af4:	6a 6f                	push   $0x6f
  jmp alltraps
80106af6:	e9 23 f7 ff ff       	jmp    8010621e <alltraps>

80106afb <vector112>:
.globl vector112
vector112:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $112
80106afd:	6a 70                	push   $0x70
  jmp alltraps
80106aff:	e9 1a f7 ff ff       	jmp    8010621e <alltraps>

80106b04 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b04:	6a 00                	push   $0x0
  pushl $113
80106b06:	6a 71                	push   $0x71
  jmp alltraps
80106b08:	e9 11 f7 ff ff       	jmp    8010621e <alltraps>

80106b0d <vector114>:
.globl vector114
vector114:
  pushl $0
80106b0d:	6a 00                	push   $0x0
  pushl $114
80106b0f:	6a 72                	push   $0x72
  jmp alltraps
80106b11:	e9 08 f7 ff ff       	jmp    8010621e <alltraps>

80106b16 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b16:	6a 00                	push   $0x0
  pushl $115
80106b18:	6a 73                	push   $0x73
  jmp alltraps
80106b1a:	e9 ff f6 ff ff       	jmp    8010621e <alltraps>

80106b1f <vector116>:
.globl vector116
vector116:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $116
80106b21:	6a 74                	push   $0x74
  jmp alltraps
80106b23:	e9 f6 f6 ff ff       	jmp    8010621e <alltraps>

80106b28 <vector117>:
.globl vector117
vector117:
  pushl $0
80106b28:	6a 00                	push   $0x0
  pushl $117
80106b2a:	6a 75                	push   $0x75
  jmp alltraps
80106b2c:	e9 ed f6 ff ff       	jmp    8010621e <alltraps>

80106b31 <vector118>:
.globl vector118
vector118:
  pushl $0
80106b31:	6a 00                	push   $0x0
  pushl $118
80106b33:	6a 76                	push   $0x76
  jmp alltraps
80106b35:	e9 e4 f6 ff ff       	jmp    8010621e <alltraps>

80106b3a <vector119>:
.globl vector119
vector119:
  pushl $0
80106b3a:	6a 00                	push   $0x0
  pushl $119
80106b3c:	6a 77                	push   $0x77
  jmp alltraps
80106b3e:	e9 db f6 ff ff       	jmp    8010621e <alltraps>

80106b43 <vector120>:
.globl vector120
vector120:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $120
80106b45:	6a 78                	push   $0x78
  jmp alltraps
80106b47:	e9 d2 f6 ff ff       	jmp    8010621e <alltraps>

80106b4c <vector121>:
.globl vector121
vector121:
  pushl $0
80106b4c:	6a 00                	push   $0x0
  pushl $121
80106b4e:	6a 79                	push   $0x79
  jmp alltraps
80106b50:	e9 c9 f6 ff ff       	jmp    8010621e <alltraps>

80106b55 <vector122>:
.globl vector122
vector122:
  pushl $0
80106b55:	6a 00                	push   $0x0
  pushl $122
80106b57:	6a 7a                	push   $0x7a
  jmp alltraps
80106b59:	e9 c0 f6 ff ff       	jmp    8010621e <alltraps>

80106b5e <vector123>:
.globl vector123
vector123:
  pushl $0
80106b5e:	6a 00                	push   $0x0
  pushl $123
80106b60:	6a 7b                	push   $0x7b
  jmp alltraps
80106b62:	e9 b7 f6 ff ff       	jmp    8010621e <alltraps>

80106b67 <vector124>:
.globl vector124
vector124:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $124
80106b69:	6a 7c                	push   $0x7c
  jmp alltraps
80106b6b:	e9 ae f6 ff ff       	jmp    8010621e <alltraps>

80106b70 <vector125>:
.globl vector125
vector125:
  pushl $0
80106b70:	6a 00                	push   $0x0
  pushl $125
80106b72:	6a 7d                	push   $0x7d
  jmp alltraps
80106b74:	e9 a5 f6 ff ff       	jmp    8010621e <alltraps>

80106b79 <vector126>:
.globl vector126
vector126:
  pushl $0
80106b79:	6a 00                	push   $0x0
  pushl $126
80106b7b:	6a 7e                	push   $0x7e
  jmp alltraps
80106b7d:	e9 9c f6 ff ff       	jmp    8010621e <alltraps>

80106b82 <vector127>:
.globl vector127
vector127:
  pushl $0
80106b82:	6a 00                	push   $0x0
  pushl $127
80106b84:	6a 7f                	push   $0x7f
  jmp alltraps
80106b86:	e9 93 f6 ff ff       	jmp    8010621e <alltraps>

80106b8b <vector128>:
.globl vector128
vector128:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $128
80106b8d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106b92:	e9 87 f6 ff ff       	jmp    8010621e <alltraps>

80106b97 <vector129>:
.globl vector129
vector129:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $129
80106b99:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106b9e:	e9 7b f6 ff ff       	jmp    8010621e <alltraps>

80106ba3 <vector130>:
.globl vector130
vector130:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $130
80106ba5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106baa:	e9 6f f6 ff ff       	jmp    8010621e <alltraps>

80106baf <vector131>:
.globl vector131
vector131:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $131
80106bb1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106bb6:	e9 63 f6 ff ff       	jmp    8010621e <alltraps>

80106bbb <vector132>:
.globl vector132
vector132:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $132
80106bbd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106bc2:	e9 57 f6 ff ff       	jmp    8010621e <alltraps>

80106bc7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $133
80106bc9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106bce:	e9 4b f6 ff ff       	jmp    8010621e <alltraps>

80106bd3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $134
80106bd5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106bda:	e9 3f f6 ff ff       	jmp    8010621e <alltraps>

80106bdf <vector135>:
.globl vector135
vector135:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $135
80106be1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106be6:	e9 33 f6 ff ff       	jmp    8010621e <alltraps>

80106beb <vector136>:
.globl vector136
vector136:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $136
80106bed:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106bf2:	e9 27 f6 ff ff       	jmp    8010621e <alltraps>

80106bf7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $137
80106bf9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106bfe:	e9 1b f6 ff ff       	jmp    8010621e <alltraps>

80106c03 <vector138>:
.globl vector138
vector138:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $138
80106c05:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c0a:	e9 0f f6 ff ff       	jmp    8010621e <alltraps>

80106c0f <vector139>:
.globl vector139
vector139:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $139
80106c11:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c16:	e9 03 f6 ff ff       	jmp    8010621e <alltraps>

80106c1b <vector140>:
.globl vector140
vector140:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $140
80106c1d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c22:	e9 f7 f5 ff ff       	jmp    8010621e <alltraps>

80106c27 <vector141>:
.globl vector141
vector141:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $141
80106c29:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106c2e:	e9 eb f5 ff ff       	jmp    8010621e <alltraps>

80106c33 <vector142>:
.globl vector142
vector142:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $142
80106c35:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106c3a:	e9 df f5 ff ff       	jmp    8010621e <alltraps>

80106c3f <vector143>:
.globl vector143
vector143:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $143
80106c41:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106c46:	e9 d3 f5 ff ff       	jmp    8010621e <alltraps>

80106c4b <vector144>:
.globl vector144
vector144:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $144
80106c4d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106c52:	e9 c7 f5 ff ff       	jmp    8010621e <alltraps>

80106c57 <vector145>:
.globl vector145
vector145:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $145
80106c59:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106c5e:	e9 bb f5 ff ff       	jmp    8010621e <alltraps>

80106c63 <vector146>:
.globl vector146
vector146:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $146
80106c65:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106c6a:	e9 af f5 ff ff       	jmp    8010621e <alltraps>

80106c6f <vector147>:
.globl vector147
vector147:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $147
80106c71:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106c76:	e9 a3 f5 ff ff       	jmp    8010621e <alltraps>

80106c7b <vector148>:
.globl vector148
vector148:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $148
80106c7d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106c82:	e9 97 f5 ff ff       	jmp    8010621e <alltraps>

80106c87 <vector149>:
.globl vector149
vector149:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $149
80106c89:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106c8e:	e9 8b f5 ff ff       	jmp    8010621e <alltraps>

80106c93 <vector150>:
.globl vector150
vector150:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $150
80106c95:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106c9a:	e9 7f f5 ff ff       	jmp    8010621e <alltraps>

80106c9f <vector151>:
.globl vector151
vector151:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $151
80106ca1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106ca6:	e9 73 f5 ff ff       	jmp    8010621e <alltraps>

80106cab <vector152>:
.globl vector152
vector152:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $152
80106cad:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106cb2:	e9 67 f5 ff ff       	jmp    8010621e <alltraps>

80106cb7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $153
80106cb9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106cbe:	e9 5b f5 ff ff       	jmp    8010621e <alltraps>

80106cc3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $154
80106cc5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106cca:	e9 4f f5 ff ff       	jmp    8010621e <alltraps>

80106ccf <vector155>:
.globl vector155
vector155:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $155
80106cd1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106cd6:	e9 43 f5 ff ff       	jmp    8010621e <alltraps>

80106cdb <vector156>:
.globl vector156
vector156:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $156
80106cdd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106ce2:	e9 37 f5 ff ff       	jmp    8010621e <alltraps>

80106ce7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $157
80106ce9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106cee:	e9 2b f5 ff ff       	jmp    8010621e <alltraps>

80106cf3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $158
80106cf5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106cfa:	e9 1f f5 ff ff       	jmp    8010621e <alltraps>

80106cff <vector159>:
.globl vector159
vector159:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $159
80106d01:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d06:	e9 13 f5 ff ff       	jmp    8010621e <alltraps>

80106d0b <vector160>:
.globl vector160
vector160:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $160
80106d0d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d12:	e9 07 f5 ff ff       	jmp    8010621e <alltraps>

80106d17 <vector161>:
.globl vector161
vector161:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $161
80106d19:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d1e:	e9 fb f4 ff ff       	jmp    8010621e <alltraps>

80106d23 <vector162>:
.globl vector162
vector162:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $162
80106d25:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106d2a:	e9 ef f4 ff ff       	jmp    8010621e <alltraps>

80106d2f <vector163>:
.globl vector163
vector163:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $163
80106d31:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106d36:	e9 e3 f4 ff ff       	jmp    8010621e <alltraps>

80106d3b <vector164>:
.globl vector164
vector164:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $164
80106d3d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106d42:	e9 d7 f4 ff ff       	jmp    8010621e <alltraps>

80106d47 <vector165>:
.globl vector165
vector165:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $165
80106d49:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106d4e:	e9 cb f4 ff ff       	jmp    8010621e <alltraps>

80106d53 <vector166>:
.globl vector166
vector166:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $166
80106d55:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106d5a:	e9 bf f4 ff ff       	jmp    8010621e <alltraps>

80106d5f <vector167>:
.globl vector167
vector167:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $167
80106d61:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106d66:	e9 b3 f4 ff ff       	jmp    8010621e <alltraps>

80106d6b <vector168>:
.globl vector168
vector168:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $168
80106d6d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106d72:	e9 a7 f4 ff ff       	jmp    8010621e <alltraps>

80106d77 <vector169>:
.globl vector169
vector169:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $169
80106d79:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106d7e:	e9 9b f4 ff ff       	jmp    8010621e <alltraps>

80106d83 <vector170>:
.globl vector170
vector170:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $170
80106d85:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106d8a:	e9 8f f4 ff ff       	jmp    8010621e <alltraps>

80106d8f <vector171>:
.globl vector171
vector171:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $171
80106d91:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106d96:	e9 83 f4 ff ff       	jmp    8010621e <alltraps>

80106d9b <vector172>:
.globl vector172
vector172:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $172
80106d9d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106da2:	e9 77 f4 ff ff       	jmp    8010621e <alltraps>

80106da7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $173
80106da9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106dae:	e9 6b f4 ff ff       	jmp    8010621e <alltraps>

80106db3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $174
80106db5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106dba:	e9 5f f4 ff ff       	jmp    8010621e <alltraps>

80106dbf <vector175>:
.globl vector175
vector175:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $175
80106dc1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106dc6:	e9 53 f4 ff ff       	jmp    8010621e <alltraps>

80106dcb <vector176>:
.globl vector176
vector176:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $176
80106dcd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106dd2:	e9 47 f4 ff ff       	jmp    8010621e <alltraps>

80106dd7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $177
80106dd9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106dde:	e9 3b f4 ff ff       	jmp    8010621e <alltraps>

80106de3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $178
80106de5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106dea:	e9 2f f4 ff ff       	jmp    8010621e <alltraps>

80106def <vector179>:
.globl vector179
vector179:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $179
80106df1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106df6:	e9 23 f4 ff ff       	jmp    8010621e <alltraps>

80106dfb <vector180>:
.globl vector180
vector180:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $180
80106dfd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e02:	e9 17 f4 ff ff       	jmp    8010621e <alltraps>

80106e07 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $181
80106e09:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e0e:	e9 0b f4 ff ff       	jmp    8010621e <alltraps>

80106e13 <vector182>:
.globl vector182
vector182:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $182
80106e15:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e1a:	e9 ff f3 ff ff       	jmp    8010621e <alltraps>

80106e1f <vector183>:
.globl vector183
vector183:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $183
80106e21:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106e26:	e9 f3 f3 ff ff       	jmp    8010621e <alltraps>

80106e2b <vector184>:
.globl vector184
vector184:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $184
80106e2d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106e32:	e9 e7 f3 ff ff       	jmp    8010621e <alltraps>

80106e37 <vector185>:
.globl vector185
vector185:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $185
80106e39:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106e3e:	e9 db f3 ff ff       	jmp    8010621e <alltraps>

80106e43 <vector186>:
.globl vector186
vector186:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $186
80106e45:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106e4a:	e9 cf f3 ff ff       	jmp    8010621e <alltraps>

80106e4f <vector187>:
.globl vector187
vector187:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $187
80106e51:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106e56:	e9 c3 f3 ff ff       	jmp    8010621e <alltraps>

80106e5b <vector188>:
.globl vector188
vector188:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $188
80106e5d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106e62:	e9 b7 f3 ff ff       	jmp    8010621e <alltraps>

80106e67 <vector189>:
.globl vector189
vector189:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $189
80106e69:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106e6e:	e9 ab f3 ff ff       	jmp    8010621e <alltraps>

80106e73 <vector190>:
.globl vector190
vector190:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $190
80106e75:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106e7a:	e9 9f f3 ff ff       	jmp    8010621e <alltraps>

80106e7f <vector191>:
.globl vector191
vector191:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $191
80106e81:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106e86:	e9 93 f3 ff ff       	jmp    8010621e <alltraps>

80106e8b <vector192>:
.globl vector192
vector192:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $192
80106e8d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106e92:	e9 87 f3 ff ff       	jmp    8010621e <alltraps>

80106e97 <vector193>:
.globl vector193
vector193:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $193
80106e99:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106e9e:	e9 7b f3 ff ff       	jmp    8010621e <alltraps>

80106ea3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $194
80106ea5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106eaa:	e9 6f f3 ff ff       	jmp    8010621e <alltraps>

80106eaf <vector195>:
.globl vector195
vector195:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $195
80106eb1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106eb6:	e9 63 f3 ff ff       	jmp    8010621e <alltraps>

80106ebb <vector196>:
.globl vector196
vector196:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $196
80106ebd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106ec2:	e9 57 f3 ff ff       	jmp    8010621e <alltraps>

80106ec7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $197
80106ec9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106ece:	e9 4b f3 ff ff       	jmp    8010621e <alltraps>

80106ed3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $198
80106ed5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106eda:	e9 3f f3 ff ff       	jmp    8010621e <alltraps>

80106edf <vector199>:
.globl vector199
vector199:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $199
80106ee1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ee6:	e9 33 f3 ff ff       	jmp    8010621e <alltraps>

80106eeb <vector200>:
.globl vector200
vector200:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $200
80106eed:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106ef2:	e9 27 f3 ff ff       	jmp    8010621e <alltraps>

80106ef7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $201
80106ef9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106efe:	e9 1b f3 ff ff       	jmp    8010621e <alltraps>

80106f03 <vector202>:
.globl vector202
vector202:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $202
80106f05:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f0a:	e9 0f f3 ff ff       	jmp    8010621e <alltraps>

80106f0f <vector203>:
.globl vector203
vector203:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $203
80106f11:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f16:	e9 03 f3 ff ff       	jmp    8010621e <alltraps>

80106f1b <vector204>:
.globl vector204
vector204:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $204
80106f1d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f22:	e9 f7 f2 ff ff       	jmp    8010621e <alltraps>

80106f27 <vector205>:
.globl vector205
vector205:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $205
80106f29:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106f2e:	e9 eb f2 ff ff       	jmp    8010621e <alltraps>

80106f33 <vector206>:
.globl vector206
vector206:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $206
80106f35:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106f3a:	e9 df f2 ff ff       	jmp    8010621e <alltraps>

80106f3f <vector207>:
.globl vector207
vector207:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $207
80106f41:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106f46:	e9 d3 f2 ff ff       	jmp    8010621e <alltraps>

80106f4b <vector208>:
.globl vector208
vector208:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $208
80106f4d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106f52:	e9 c7 f2 ff ff       	jmp    8010621e <alltraps>

80106f57 <vector209>:
.globl vector209
vector209:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $209
80106f59:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106f5e:	e9 bb f2 ff ff       	jmp    8010621e <alltraps>

80106f63 <vector210>:
.globl vector210
vector210:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $210
80106f65:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106f6a:	e9 af f2 ff ff       	jmp    8010621e <alltraps>

80106f6f <vector211>:
.globl vector211
vector211:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $211
80106f71:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106f76:	e9 a3 f2 ff ff       	jmp    8010621e <alltraps>

80106f7b <vector212>:
.globl vector212
vector212:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $212
80106f7d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106f82:	e9 97 f2 ff ff       	jmp    8010621e <alltraps>

80106f87 <vector213>:
.globl vector213
vector213:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $213
80106f89:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106f8e:	e9 8b f2 ff ff       	jmp    8010621e <alltraps>

80106f93 <vector214>:
.globl vector214
vector214:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $214
80106f95:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106f9a:	e9 7f f2 ff ff       	jmp    8010621e <alltraps>

80106f9f <vector215>:
.globl vector215
vector215:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $215
80106fa1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106fa6:	e9 73 f2 ff ff       	jmp    8010621e <alltraps>

80106fab <vector216>:
.globl vector216
vector216:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $216
80106fad:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106fb2:	e9 67 f2 ff ff       	jmp    8010621e <alltraps>

80106fb7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $217
80106fb9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106fbe:	e9 5b f2 ff ff       	jmp    8010621e <alltraps>

80106fc3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $218
80106fc5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106fca:	e9 4f f2 ff ff       	jmp    8010621e <alltraps>

80106fcf <vector219>:
.globl vector219
vector219:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $219
80106fd1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106fd6:	e9 43 f2 ff ff       	jmp    8010621e <alltraps>

80106fdb <vector220>:
.globl vector220
vector220:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $220
80106fdd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106fe2:	e9 37 f2 ff ff       	jmp    8010621e <alltraps>

80106fe7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $221
80106fe9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106fee:	e9 2b f2 ff ff       	jmp    8010621e <alltraps>

80106ff3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $222
80106ff5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ffa:	e9 1f f2 ff ff       	jmp    8010621e <alltraps>

80106fff <vector223>:
.globl vector223
vector223:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $223
80107001:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107006:	e9 13 f2 ff ff       	jmp    8010621e <alltraps>

8010700b <vector224>:
.globl vector224
vector224:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $224
8010700d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107012:	e9 07 f2 ff ff       	jmp    8010621e <alltraps>

80107017 <vector225>:
.globl vector225
vector225:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $225
80107019:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010701e:	e9 fb f1 ff ff       	jmp    8010621e <alltraps>

80107023 <vector226>:
.globl vector226
vector226:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $226
80107025:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010702a:	e9 ef f1 ff ff       	jmp    8010621e <alltraps>

8010702f <vector227>:
.globl vector227
vector227:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $227
80107031:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107036:	e9 e3 f1 ff ff       	jmp    8010621e <alltraps>

8010703b <vector228>:
.globl vector228
vector228:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $228
8010703d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107042:	e9 d7 f1 ff ff       	jmp    8010621e <alltraps>

80107047 <vector229>:
.globl vector229
vector229:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $229
80107049:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010704e:	e9 cb f1 ff ff       	jmp    8010621e <alltraps>

80107053 <vector230>:
.globl vector230
vector230:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $230
80107055:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010705a:	e9 bf f1 ff ff       	jmp    8010621e <alltraps>

8010705f <vector231>:
.globl vector231
vector231:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $231
80107061:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107066:	e9 b3 f1 ff ff       	jmp    8010621e <alltraps>

8010706b <vector232>:
.globl vector232
vector232:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $232
8010706d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107072:	e9 a7 f1 ff ff       	jmp    8010621e <alltraps>

80107077 <vector233>:
.globl vector233
vector233:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $233
80107079:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010707e:	e9 9b f1 ff ff       	jmp    8010621e <alltraps>

80107083 <vector234>:
.globl vector234
vector234:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $234
80107085:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010708a:	e9 8f f1 ff ff       	jmp    8010621e <alltraps>

8010708f <vector235>:
.globl vector235
vector235:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $235
80107091:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107096:	e9 83 f1 ff ff       	jmp    8010621e <alltraps>

8010709b <vector236>:
.globl vector236
vector236:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $236
8010709d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801070a2:	e9 77 f1 ff ff       	jmp    8010621e <alltraps>

801070a7 <vector237>:
.globl vector237
vector237:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $237
801070a9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801070ae:	e9 6b f1 ff ff       	jmp    8010621e <alltraps>

801070b3 <vector238>:
.globl vector238
vector238:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $238
801070b5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801070ba:	e9 5f f1 ff ff       	jmp    8010621e <alltraps>

801070bf <vector239>:
.globl vector239
vector239:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $239
801070c1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801070c6:	e9 53 f1 ff ff       	jmp    8010621e <alltraps>

801070cb <vector240>:
.globl vector240
vector240:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $240
801070cd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801070d2:	e9 47 f1 ff ff       	jmp    8010621e <alltraps>

801070d7 <vector241>:
.globl vector241
vector241:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $241
801070d9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801070de:	e9 3b f1 ff ff       	jmp    8010621e <alltraps>

801070e3 <vector242>:
.globl vector242
vector242:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $242
801070e5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801070ea:	e9 2f f1 ff ff       	jmp    8010621e <alltraps>

801070ef <vector243>:
.globl vector243
vector243:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $243
801070f1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801070f6:	e9 23 f1 ff ff       	jmp    8010621e <alltraps>

801070fb <vector244>:
.globl vector244
vector244:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $244
801070fd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107102:	e9 17 f1 ff ff       	jmp    8010621e <alltraps>

80107107 <vector245>:
.globl vector245
vector245:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $245
80107109:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010710e:	e9 0b f1 ff ff       	jmp    8010621e <alltraps>

80107113 <vector246>:
.globl vector246
vector246:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $246
80107115:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010711a:	e9 ff f0 ff ff       	jmp    8010621e <alltraps>

8010711f <vector247>:
.globl vector247
vector247:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $247
80107121:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107126:	e9 f3 f0 ff ff       	jmp    8010621e <alltraps>

8010712b <vector248>:
.globl vector248
vector248:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $248
8010712d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107132:	e9 e7 f0 ff ff       	jmp    8010621e <alltraps>

80107137 <vector249>:
.globl vector249
vector249:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $249
80107139:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010713e:	e9 db f0 ff ff       	jmp    8010621e <alltraps>

80107143 <vector250>:
.globl vector250
vector250:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $250
80107145:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010714a:	e9 cf f0 ff ff       	jmp    8010621e <alltraps>

8010714f <vector251>:
.globl vector251
vector251:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $251
80107151:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107156:	e9 c3 f0 ff ff       	jmp    8010621e <alltraps>

8010715b <vector252>:
.globl vector252
vector252:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $252
8010715d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107162:	e9 b7 f0 ff ff       	jmp    8010621e <alltraps>

80107167 <vector253>:
.globl vector253
vector253:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $253
80107169:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010716e:	e9 ab f0 ff ff       	jmp    8010621e <alltraps>

80107173 <vector254>:
.globl vector254
vector254:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $254
80107175:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010717a:	e9 9f f0 ff ff       	jmp    8010621e <alltraps>

8010717f <vector255>:
.globl vector255
vector255:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $255
80107181:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107186:	e9 93 f0 ff ff       	jmp    8010621e <alltraps>
8010718b:	66 90                	xchg   %ax,%ax
8010718d:	66 90                	xchg   %ax,%ax
8010718f:	90                   	nop

80107190 <seginit>:
pde_t *kpgdir;      // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void seginit(void)
{
80107190:	f3 0f 1e fb          	endbr32 
80107194:	55                   	push   %ebp
80107195:	89 e5                	mov    %esp,%ebp
80107197:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
8010719a:	e8 41 d0 ff ff       	call   801041e0 <cpuid>
  pd[0] = size-1;
8010719f:	ba 2f 00 00 00       	mov    $0x2f,%edx
801071a4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801071aa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
801071ae:	c7 80 58 98 11 80 ff 	movl   $0xffff,-0x7fee67a8(%eax)
801071b5:	ff 00 00 
801071b8:	c7 80 5c 98 11 80 00 	movl   $0xcf9a00,-0x7fee67a4(%eax)
801071bf:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071c2:	c7 80 60 98 11 80 ff 	movl   $0xffff,-0x7fee67a0(%eax)
801071c9:	ff 00 00 
801071cc:	c7 80 64 98 11 80 00 	movl   $0xcf9200,-0x7fee679c(%eax)
801071d3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
801071d6:	c7 80 68 98 11 80 ff 	movl   $0xffff,-0x7fee6798(%eax)
801071dd:	ff 00 00 
801071e0:	c7 80 6c 98 11 80 00 	movl   $0xcffa00,-0x7fee6794(%eax)
801071e7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071ea:	c7 80 70 98 11 80 ff 	movl   $0xffff,-0x7fee6790(%eax)
801071f1:	ff 00 00 
801071f4:	c7 80 74 98 11 80 00 	movl   $0xcff200,-0x7fee678c(%eax)
801071fb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801071fe:	05 50 98 11 80       	add    $0x80119850,%eax
  pd[1] = (uint)p;
80107203:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107207:	c1 e8 10             	shr    $0x10,%eax
8010720a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010720e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107211:	0f 01 10             	lgdtl  (%eax)
}
80107214:	c9                   	leave  
80107215:	c3                   	ret    
80107216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721d:	8d 76 00             	lea    0x0(%esi),%esi

80107220 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107220:	f3 0f 1e fb          	endbr32 
80107224:	55                   	push   %ebp
80107225:	89 e5                	mov    %esp,%ebp
80107227:	57                   	push   %edi
80107228:	56                   	push   %esi
80107229:	53                   	push   %ebx
8010722a:	83 ec 0c             	sub    $0xc,%esp
8010722d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107230:	8b 55 08             	mov    0x8(%ebp),%edx
80107233:	89 fe                	mov    %edi,%esi
80107235:	c1 ee 16             	shr    $0x16,%esi
80107238:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if (*pde & PTE_P)
8010723b:	8b 1e                	mov    (%esi),%ebx
8010723d:	f6 c3 01             	test   $0x1,%bl
80107240:	74 26                	je     80107268 <walkpgdir+0x48>
  {
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
80107242:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107248:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010724e:	89 f8                	mov    %edi,%eax
}
80107250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107253:	c1 e8 0a             	shr    $0xa,%eax
80107256:	25 fc 0f 00 00       	and    $0xffc,%eax
8010725b:	01 d8                	add    %ebx,%eax
}
8010725d:	5b                   	pop    %ebx
8010725e:	5e                   	pop    %esi
8010725f:	5f                   	pop    %edi
80107260:	5d                   	pop    %ebp
80107261:	c3                   	ret    
80107262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (!alloc || (pgtab = (pte_t *)kalloc()) == 0)
80107268:	8b 45 10             	mov    0x10(%ebp),%eax
8010726b:	85 c0                	test   %eax,%eax
8010726d:	74 31                	je     801072a0 <walkpgdir+0x80>
8010726f:	e8 bc ba ff ff       	call   80102d30 <kalloc>
80107274:	89 c3                	mov    %eax,%ebx
80107276:	85 c0                	test   %eax,%eax
80107278:	74 26                	je     801072a0 <walkpgdir+0x80>
    memset(pgtab, 0, PGSIZE);
8010727a:	83 ec 04             	sub    $0x4,%esp
8010727d:	68 00 10 00 00       	push   $0x1000
80107282:	6a 00                	push   $0x0
80107284:	50                   	push   %eax
80107285:	e8 76 dc ff ff       	call   80104f00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010728a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107290:	83 c4 10             	add    $0x10,%esp
80107293:	83 c8 07             	or     $0x7,%eax
80107296:	89 06                	mov    %eax,(%esi)
80107298:	eb b4                	jmp    8010724e <walkpgdir+0x2e>
8010729a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
801072a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801072a3:	31 c0                	xor    %eax,%eax
}
801072a5:	5b                   	pop    %ebx
801072a6:	5e                   	pop    %esi
801072a7:	5f                   	pop    %edi
801072a8:	5d                   	pop    %ebp
801072a9:	c3                   	ret    
801072aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char *)PGROUNDDOWN((uint)va);
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
801072b6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801072ba:	56                   	push   %esi
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
801072bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char *)PGROUNDDOWN((uint)va);
801072c0:	89 d6                	mov    %edx,%esi
{
801072c2:	53                   	push   %ebx
  a = (char *)PGROUNDDOWN((uint)va);
801072c3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801072c9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
801072cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072cf:	8b 45 08             	mov    0x8(%ebp),%eax
801072d2:	29 f0                	sub    %esi,%eax
801072d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072d7:	eb 1f                	jmp    801072f8 <mappages+0x48>
801072d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (;;)
  {
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if (*pte & PTE_P)
801072e0:	f6 00 01             	testb  $0x1,(%eax)
801072e3:	75 45                	jne    8010732a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801072e5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801072e8:	83 cb 01             	or     $0x1,%ebx
801072eb:	89 18                	mov    %ebx,(%eax)
    if (a == last)
801072ed:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801072f0:	74 2e                	je     80107320 <mappages+0x70>
      break;
    a += PGSIZE;
801072f2:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
801072f8:	83 ec 04             	sub    $0x4,%esp
801072fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072fe:	6a 01                	push   $0x1
80107300:	56                   	push   %esi
80107301:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107304:	57                   	push   %edi
80107305:	e8 16 ff ff ff       	call   80107220 <walkpgdir>
8010730a:	83 c4 10             	add    $0x10,%esp
8010730d:	85 c0                	test   %eax,%eax
8010730f:	75 cf                	jne    801072e0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107311:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107314:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107319:	5b                   	pop    %ebx
8010731a:	5e                   	pop    %esi
8010731b:	5f                   	pop    %edi
8010731c:	5d                   	pop    %ebp
8010731d:	c3                   	ret    
8010731e:	66 90                	xchg   %ax,%ax
80107320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107323:	31 c0                	xor    %eax,%eax
}
80107325:	5b                   	pop    %ebx
80107326:	5e                   	pop    %esi
80107327:	5f                   	pop    %edi
80107328:	5d                   	pop    %ebp
80107329:	c3                   	ret    
      panic("remap");
8010732a:	83 ec 0c             	sub    $0xc,%esp
8010732d:	68 3c 89 10 80       	push   $0x8010893c
80107332:	e8 59 90 ff ff       	call   80100390 <panic>
80107337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733e:	66 90                	xchg   %ax,%ax

80107340 <deallocuvm.part.0>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	89 c6                	mov    %eax,%esi
80107347:	53                   	push   %ebx
80107348:	89 d3                	mov    %edx,%ebx
8010734a:	83 ec 1c             	sub    $0x1c,%esp
8010734d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  int bitmap_offset;

  if (newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107350:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107356:	89 d7                	mov    %edx,%edi
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107358:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  a = PGROUNDUP(newsz);
8010735b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for (; a < oldsz; a += PGSIZE)
80107361:	39 df                	cmp    %ebx,%edi
80107363:	72 55                	jb     801073ba <deallocuvm.part.0+0x7a>
80107365:	e9 96 00 00 00       	jmp    80107400 <deallocuvm.part.0+0xc0>
8010736a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (!pte) // pte not exist
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if ((*pte & PTE_P) != 0) // swapped in pages(PTE_P is set)
    {
      pa = PTE_ADDR(*pte);
      if (pa == 0)
80107370:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107376:	0f 84 a4 00 00 00    	je     80107420 <deallocuvm.part.0+0xe0>
        panic("kfree");
      char *v = P2V(pa);
      // remove from LRU list
      cprintf("delete lru page call\n");
8010737c:	83 ec 0c             	sub    $0xc,%esp
8010737f:	89 45 e0             	mov    %eax,-0x20(%ebp)
      char *v = P2V(pa);
80107382:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
      cprintf("delete lru page call\n");
80107388:	68 42 89 10 80       	push   $0x80108942
8010738d:	e8 1e 93 ff ff       	call   801006b0 <cprintf>
      page_delete(pgdir, (char *)a);
80107392:	58                   	pop    %eax
80107393:	5a                   	pop    %edx
80107394:	57                   	push   %edi
80107395:	56                   	push   %esi
80107396:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010739c:	e8 af b6 ff ff       	call   80102a50 <page_delete>
      kfree(v);
801073a1:	89 1c 24             	mov    %ebx,(%esp)
801073a4:	e8 d7 b1 ff ff       	call   80102580 <kfree>
      *pte = 0;
801073a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
801073ac:	83 c4 10             	add    $0x10,%esp
801073af:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for (; a < oldsz; a += PGSIZE)
801073b5:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801073b8:	76 46                	jbe    80107400 <deallocuvm.part.0+0xc0>
    pte = walkpgdir(pgdir, (char *)a, 0);
801073ba:	83 ec 04             	sub    $0x4,%esp
801073bd:	6a 00                	push   $0x0
801073bf:	57                   	push   %edi
801073c0:	56                   	push   %esi
801073c1:	e8 5a fe ff ff       	call   80107220 <walkpgdir>
    if (!pte) // pte not exist
801073c6:	83 c4 10             	add    $0x10,%esp
801073c9:	85 c0                	test   %eax,%eax
801073cb:	74 43                	je     80107410 <deallocuvm.part.0+0xd0>
    else if ((*pte & PTE_P) != 0) // swapped in pages(PTE_P is set)
801073cd:	8b 18                	mov    (%eax),%ebx
801073cf:	f6 c3 01             	test   $0x1,%bl
801073d2:	75 9c                	jne    80107370 <deallocuvm.part.0+0x30>
    }
    else if (*pte != 0) // swapped out pages(pte is not zero, PTE_P is clear)
801073d4:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073da:	85 db                	test   %ebx,%ebx
801073dc:	74 d7                	je     801073b5 <deallocuvm.part.0+0x75>
    {
      // clear in bitmap
      pa = PTE_ADDR(*pte);
      bitmap_offset = (int)(pa >> 12);
      bitmap_modify(bitmap_offset, 0);
801073de:	83 ec 08             	sub    $0x8,%esp
      bitmap_offset = (int)(pa >> 12);
801073e1:	c1 eb 0c             	shr    $0xc,%ebx
801073e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
      bitmap_modify(bitmap_offset, 0);
801073e7:	6a 00                	push   $0x0
801073e9:	53                   	push   %ebx
801073ea:	e8 f1 b9 ff ff       	call   80102de0 <bitmap_modify>

      // clear page table entry
      *pte = 0;
801073ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
801073f2:	83 c4 10             	add    $0x10,%esp
801073f5:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for (; a < oldsz; a += PGSIZE)
801073fb:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801073fe:	77 ba                	ja     801073ba <deallocuvm.part.0+0x7a>
    }
  }
  return newsz;
}
80107400:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107403:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107406:	5b                   	pop    %ebx
80107407:	5e                   	pop    %esi
80107408:	5f                   	pop    %edi
80107409:	5d                   	pop    %ebp
8010740a:	c3                   	ret    
8010740b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010740f:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107410:	89 f9                	mov    %edi,%ecx
80107412:	81 e1 00 00 c0 ff    	and    $0xffc00000,%ecx
80107418:	8d b9 00 00 40 00    	lea    0x400000(%ecx),%edi
8010741e:	eb 95                	jmp    801073b5 <deallocuvm.part.0+0x75>
        panic("kfree");
80107420:	83 ec 0c             	sub    $0xc,%esp
80107423:	68 27 7e 10 80       	push   $0x80107e27
80107428:	e8 63 8f ff ff       	call   80100390 <panic>
8010742d:	8d 76 00             	lea    0x0(%esi),%esi

80107430 <switchkvm>:
{
80107430:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80107434:	a1 04 c5 11 80       	mov    0x8011c504,%eax
80107439:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010743e:	0f 22 d8             	mov    %eax,%cr3
}
80107441:	c3                   	ret    
80107442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107450 <switchuvm>:
{
80107450:	f3 0f 1e fb          	endbr32 
80107454:	55                   	push   %ebp
80107455:	89 e5                	mov    %esp,%ebp
80107457:	57                   	push   %edi
80107458:	56                   	push   %esi
80107459:	53                   	push   %ebx
8010745a:	83 ec 1c             	sub    $0x1c,%esp
8010745d:	8b 75 08             	mov    0x8(%ebp),%esi
  if (p == 0)
80107460:	85 f6                	test   %esi,%esi
80107462:	0f 84 cb 00 00 00    	je     80107533 <switchuvm+0xe3>
  if (p->kstack == 0)
80107468:	8b 46 08             	mov    0x8(%esi),%eax
8010746b:	85 c0                	test   %eax,%eax
8010746d:	0f 84 da 00 00 00    	je     8010754d <switchuvm+0xfd>
  if (p->pgdir == 0)
80107473:	8b 46 04             	mov    0x4(%esi),%eax
80107476:	85 c0                	test   %eax,%eax
80107478:	0f 84 c2 00 00 00    	je     80107540 <switchuvm+0xf0>
  pushcli();
8010747e:	e8 6d d8 ff ff       	call   80104cf0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107483:	e8 e8 cc ff ff       	call   80104170 <mycpu>
80107488:	89 c3                	mov    %eax,%ebx
8010748a:	e8 e1 cc ff ff       	call   80104170 <mycpu>
8010748f:	89 c7                	mov    %eax,%edi
80107491:	e8 da cc ff ff       	call   80104170 <mycpu>
80107496:	83 c7 08             	add    $0x8,%edi
80107499:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010749c:	e8 cf cc ff ff       	call   80104170 <mycpu>
801074a1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801074a4:	ba 67 00 00 00       	mov    $0x67,%edx
801074a9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801074b0:	83 c0 08             	add    $0x8,%eax
801074b3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort)0xFFFF;
801074ba:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074bf:	83 c1 08             	add    $0x8,%ecx
801074c2:	c1 e8 18             	shr    $0x18,%eax
801074c5:	c1 e9 10             	shr    $0x10,%ecx
801074c8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801074ce:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801074d4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801074d9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801074e0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801074e5:	e8 86 cc ff ff       	call   80104170 <mycpu>
801074ea:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801074f1:	e8 7a cc ff ff       	call   80104170 <mycpu>
801074f6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801074fa:	8b 5e 08             	mov    0x8(%esi),%ebx
801074fd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107503:	e8 68 cc ff ff       	call   80104170 <mycpu>
80107508:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort)0xFFFF;
8010750b:	e8 60 cc ff ff       	call   80104170 <mycpu>
80107510:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107514:	b8 28 00 00 00       	mov    $0x28,%eax
80107519:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir)); // switch to process's address space
8010751c:	8b 46 04             	mov    0x4(%esi),%eax
8010751f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107524:	0f 22 d8             	mov    %eax,%cr3
}
80107527:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010752a:	5b                   	pop    %ebx
8010752b:	5e                   	pop    %esi
8010752c:	5f                   	pop    %edi
8010752d:	5d                   	pop    %ebp
  popcli();
8010752e:	e9 0d d8 ff ff       	jmp    80104d40 <popcli>
    panic("switchuvm: no process");
80107533:	83 ec 0c             	sub    $0xc,%esp
80107536:	68 58 89 10 80       	push   $0x80108958
8010753b:	e8 50 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107540:	83 ec 0c             	sub    $0xc,%esp
80107543:	68 83 89 10 80       	push   $0x80108983
80107548:	e8 43 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010754d:	83 ec 0c             	sub    $0xc,%esp
80107550:	68 6e 89 10 80       	push   $0x8010896e
80107555:	e8 36 8e ff ff       	call   80100390 <panic>
8010755a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107560 <inituvm>:
{
80107560:	f3 0f 1e fb          	endbr32 
80107564:	55                   	push   %ebp
80107565:	89 e5                	mov    %esp,%ebp
80107567:	57                   	push   %edi
80107568:	56                   	push   %esi
80107569:	53                   	push   %ebx
8010756a:	83 ec 1c             	sub    $0x1c,%esp
8010756d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107570:	8b 75 10             	mov    0x10(%ebp),%esi
80107573:	8b 7d 08             	mov    0x8(%ebp),%edi
80107576:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (sz >= PGSIZE)
80107579:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010757f:	77 55                	ja     801075d6 <inituvm+0x76>
  mem = kalloc();
80107581:	e8 aa b7 ff ff       	call   80102d30 <kalloc>
  memset(mem, 0, PGSIZE);
80107586:	83 ec 04             	sub    $0x4,%esp
80107589:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010758e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107590:	6a 00                	push   $0x0
80107592:	50                   	push   %eax
80107593:	e8 68 d9 ff ff       	call   80104f00 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107598:	58                   	pop    %eax
80107599:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010759f:	5a                   	pop    %edx
801075a0:	6a 06                	push   $0x6
801075a2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075a7:	31 d2                	xor    %edx,%edx
801075a9:	50                   	push   %eax
801075aa:	89 f8                	mov    %edi,%eax
801075ac:	e8 ff fc ff ff       	call   801072b0 <mappages>
  page_insert(pgdir, 0);
801075b1:	59                   	pop    %ecx
801075b2:	58                   	pop    %eax
801075b3:	6a 00                	push   $0x0
801075b5:	57                   	push   %edi
801075b6:	e8 05 b3 ff ff       	call   801028c0 <page_insert>
  memmove(mem, init, sz);
801075bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075be:	89 75 10             	mov    %esi,0x10(%ebp)
801075c1:	83 c4 10             	add    $0x10,%esp
801075c4:	89 5d 08             	mov    %ebx,0x8(%ebp)
801075c7:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801075ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075cd:	5b                   	pop    %ebx
801075ce:	5e                   	pop    %esi
801075cf:	5f                   	pop    %edi
801075d0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801075d1:	e9 ca d9 ff ff       	jmp    80104fa0 <memmove>
    panic("inituvm: more than a page");
801075d6:	83 ec 0c             	sub    $0xc,%esp
801075d9:	68 97 89 10 80       	push   $0x80108997
801075de:	e8 ad 8d ff ff       	call   80100390 <panic>
801075e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075f0 <loaduvm>:
{
801075f0:	f3 0f 1e fb          	endbr32 
801075f4:	55                   	push   %ebp
801075f5:	89 e5                	mov    %esp,%ebp
801075f7:	57                   	push   %edi
801075f8:	56                   	push   %esi
801075f9:	53                   	push   %ebx
801075fa:	83 ec 1c             	sub    $0x1c,%esp
801075fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107600:	8b 75 18             	mov    0x18(%ebp),%esi
  if ((uint)addr % PGSIZE != 0)
80107603:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107608:	0f 85 99 00 00 00    	jne    801076a7 <loaduvm+0xb7>
  for (i = 0; i < sz; i += PGSIZE)
8010760e:	01 f0                	add    %esi,%eax
80107610:	89 f3                	mov    %esi,%ebx
80107612:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107615:	8b 45 14             	mov    0x14(%ebp),%eax
80107618:	01 f0                	add    %esi,%eax
8010761a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for (i = 0; i < sz; i += PGSIZE)
8010761d:	85 f6                	test   %esi,%esi
8010761f:	75 15                	jne    80107636 <loaduvm+0x46>
80107621:	eb 6d                	jmp    80107690 <loaduvm+0xa0>
80107623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107627:	90                   	nop
80107628:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010762e:	89 f0                	mov    %esi,%eax
80107630:	29 d8                	sub    %ebx,%eax
80107632:	39 c6                	cmp    %eax,%esi
80107634:	76 5a                	jbe    80107690 <loaduvm+0xa0>
    if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
80107636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107639:	83 ec 04             	sub    $0x4,%esp
8010763c:	6a 00                	push   $0x0
8010763e:	29 d8                	sub    %ebx,%eax
80107640:	50                   	push   %eax
80107641:	ff 75 08             	pushl  0x8(%ebp)
80107644:	e8 d7 fb ff ff       	call   80107220 <walkpgdir>
80107649:	83 c4 10             	add    $0x10,%esp
8010764c:	85 c0                	test   %eax,%eax
8010764e:	74 4a                	je     8010769a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107650:	8b 00                	mov    (%eax),%eax
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107652:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if (sz - i < PGSIZE)
80107655:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
8010765a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if (sz - i < PGSIZE)
8010765f:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107665:	0f 46 fb             	cmovbe %ebx,%edi
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107668:	29 d9                	sub    %ebx,%ecx
8010766a:	05 00 00 00 80       	add    $0x80000000,%eax
8010766f:	57                   	push   %edi
80107670:	51                   	push   %ecx
80107671:	50                   	push   %eax
80107672:	ff 75 10             	pushl  0x10(%ebp)
80107675:	e8 e6 a3 ff ff       	call   80101a60 <readi>
8010767a:	83 c4 10             	add    $0x10,%esp
8010767d:	39 f8                	cmp    %edi,%eax
8010767f:	74 a7                	je     80107628 <loaduvm+0x38>
}
80107681:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107684:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107689:	5b                   	pop    %ebx
8010768a:	5e                   	pop    %esi
8010768b:	5f                   	pop    %edi
8010768c:	5d                   	pop    %ebp
8010768d:	c3                   	ret    
8010768e:	66 90                	xchg   %ax,%ax
80107690:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107693:	31 c0                	xor    %eax,%eax
}
80107695:	5b                   	pop    %ebx
80107696:	5e                   	pop    %esi
80107697:	5f                   	pop    %edi
80107698:	5d                   	pop    %ebp
80107699:	c3                   	ret    
      panic("loaduvm: address should exist");
8010769a:	83 ec 0c             	sub    $0xc,%esp
8010769d:	68 b1 89 10 80       	push   $0x801089b1
801076a2:	e8 e9 8c ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801076a7:	83 ec 0c             	sub    $0xc,%esp
801076aa:	68 38 8a 10 80       	push   $0x80108a38
801076af:	e8 dc 8c ff ff       	call   80100390 <panic>
801076b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076bf:	90                   	nop

801076c0 <allocuvm>:
{
801076c0:	f3 0f 1e fb          	endbr32 
801076c4:	55                   	push   %ebp
801076c5:	89 e5                	mov    %esp,%ebp
801076c7:	57                   	push   %edi
801076c8:	56                   	push   %esi
801076c9:	53                   	push   %ebx
801076ca:	83 ec 1c             	sub    $0x1c,%esp
  if (newsz >= KERNBASE)
801076cd:	8b 45 10             	mov    0x10(%ebp),%eax
{
801076d0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if (newsz >= KERNBASE)
801076d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076d6:	85 c0                	test   %eax,%eax
801076d8:	0f 88 c2 00 00 00    	js     801077a0 <allocuvm+0xe0>
  if (newsz < oldsz)
801076de:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801076e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (newsz < oldsz)
801076e4:	0f 82 a6 00 00 00    	jb     80107790 <allocuvm+0xd0>
  a = PGROUNDUP(oldsz);
801076ea:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801076f0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a < newsz; a += PGSIZE)
801076f6:	39 75 10             	cmp    %esi,0x10(%ebp)
801076f9:	77 51                	ja     8010774c <allocuvm+0x8c>
801076fb:	e9 93 00 00 00       	jmp    80107793 <allocuvm+0xd3>
    memset(mem, 0, PGSIZE);
80107700:	83 ec 04             	sub    $0x4,%esp
80107703:	68 00 10 00 00       	push   $0x1000
80107708:	6a 00                	push   $0x0
8010770a:	50                   	push   %eax
8010770b:	e8 f0 d7 ff ff       	call   80104f00 <memset>
    if (mappages(pgdir, (char *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
80107710:	58                   	pop    %eax
80107711:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107717:	5a                   	pop    %edx
80107718:	6a 06                	push   $0x6
8010771a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010771f:	89 f2                	mov    %esi,%edx
80107721:	50                   	push   %eax
80107722:	89 f8                	mov    %edi,%eax
80107724:	e8 87 fb ff ff       	call   801072b0 <mappages>
80107729:	83 c4 10             	add    $0x10,%esp
8010772c:	85 c0                	test   %eax,%eax
8010772e:	0f 88 84 00 00 00    	js     801077b8 <allocuvm+0xf8>
    page_insert(pgdir, a);
80107734:	83 ec 08             	sub    $0x8,%esp
80107737:	56                   	push   %esi
  for (; a < newsz; a += PGSIZE)
80107738:	81 c6 00 10 00 00    	add    $0x1000,%esi
    page_insert(pgdir, a);
8010773e:	57                   	push   %edi
8010773f:	e8 7c b1 ff ff       	call   801028c0 <page_insert>
  for (; a < newsz; a += PGSIZE)
80107744:	83 c4 10             	add    $0x10,%esp
80107747:	39 75 10             	cmp    %esi,0x10(%ebp)
8010774a:	76 47                	jbe    80107793 <allocuvm+0xd3>
    mem = kalloc();
8010774c:	e8 df b5 ff ff       	call   80102d30 <kalloc>
80107751:	89 c3                	mov    %eax,%ebx
    if (mem == 0)
80107753:	85 c0                	test   %eax,%eax
80107755:	75 a9                	jne    80107700 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107757:	83 ec 0c             	sub    $0xc,%esp
8010775a:	68 cf 89 10 80       	push   $0x801089cf
8010775f:	e8 4c 8f ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz)
80107764:	8b 45 0c             	mov    0xc(%ebp),%eax
80107767:	83 c4 10             	add    $0x10,%esp
8010776a:	39 45 10             	cmp    %eax,0x10(%ebp)
8010776d:	74 31                	je     801077a0 <allocuvm+0xe0>
8010776f:	8b 55 10             	mov    0x10(%ebp),%edx
80107772:	89 c1                	mov    %eax,%ecx
80107774:	89 f8                	mov    %edi,%eax
80107776:	e8 c5 fb ff ff       	call   80107340 <deallocuvm.part.0>
      return 0;
8010777b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107785:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107788:	5b                   	pop    %ebx
80107789:	5e                   	pop    %esi
8010778a:	5f                   	pop    %edi
8010778b:	5d                   	pop    %ebp
8010778c:	c3                   	ret    
8010778d:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80107790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107796:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107799:	5b                   	pop    %ebx
8010779a:	5e                   	pop    %esi
8010779b:	5f                   	pop    %edi
8010779c:	5d                   	pop    %ebp
8010779d:	c3                   	ret    
8010779e:	66 90                	xchg   %ax,%ax
    return 0;
801077a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ad:	5b                   	pop    %ebx
801077ae:	5e                   	pop    %esi
801077af:	5f                   	pop    %edi
801077b0:	5d                   	pop    %ebp
801077b1:	c3                   	ret    
801077b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801077b8:	83 ec 0c             	sub    $0xc,%esp
801077bb:	68 e7 89 10 80       	push   $0x801089e7
801077c0:	e8 eb 8e ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz)
801077c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801077c8:	83 c4 10             	add    $0x10,%esp
801077cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801077ce:	74 0c                	je     801077dc <allocuvm+0x11c>
801077d0:	8b 55 10             	mov    0x10(%ebp),%edx
801077d3:	89 c1                	mov    %eax,%ecx
801077d5:	89 f8                	mov    %edi,%eax
801077d7:	e8 64 fb ff ff       	call   80107340 <deallocuvm.part.0>
      kfree(mem);
801077dc:	83 ec 0c             	sub    $0xc,%esp
801077df:	53                   	push   %ebx
801077e0:	e8 9b ad ff ff       	call   80102580 <kfree>
      return 0;
801077e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801077ec:	83 c4 10             	add    $0x10,%esp
}
801077ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077f5:	5b                   	pop    %ebx
801077f6:	5e                   	pop    %esi
801077f7:	5f                   	pop    %edi
801077f8:	5d                   	pop    %ebp
801077f9:	c3                   	ret    
801077fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107800 <deallocuvm>:
{
80107800:	f3 0f 1e fb          	endbr32 
80107804:	55                   	push   %ebp
80107805:	89 e5                	mov    %esp,%ebp
80107807:	8b 55 0c             	mov    0xc(%ebp),%edx
8010780a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010780d:	8b 45 08             	mov    0x8(%ebp),%eax
  if (newsz >= oldsz)
80107810:	39 d1                	cmp    %edx,%ecx
80107812:	73 0c                	jae    80107820 <deallocuvm+0x20>
}
80107814:	5d                   	pop    %ebp
80107815:	e9 26 fb ff ff       	jmp    80107340 <deallocuvm.part.0>
8010781a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107820:	89 d0                	mov    %edx,%eax
80107822:	5d                   	pop    %ebp
80107823:	c3                   	ret    
80107824:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010782b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010782f:	90                   	nop

80107830 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t *pgdir)
{
80107830:	f3 0f 1e fb          	endbr32 
80107834:	55                   	push   %ebp
80107835:	89 e5                	mov    %esp,%ebp
80107837:	57                   	push   %edi
80107838:	56                   	push   %esi
80107839:	53                   	push   %ebx
8010783a:	83 ec 0c             	sub    $0xc,%esp
8010783d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if (pgdir == 0)
80107840:	85 f6                	test   %esi,%esi
80107842:	74 55                	je     80107899 <freevm+0x69>
  if (newsz >= oldsz)
80107844:	31 c9                	xor    %ecx,%ecx
80107846:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010784b:	89 f0                	mov    %esi,%eax
8010784d:	89 f3                	mov    %esi,%ebx
8010784f:	e8 ec fa ff ff       	call   80107340 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for (i = 0; i < NPDENTRIES; i++)
80107854:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010785a:	eb 0b                	jmp    80107867 <freevm+0x37>
8010785c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107860:	83 c3 04             	add    $0x4,%ebx
80107863:	39 df                	cmp    %ebx,%edi
80107865:	74 23                	je     8010788a <freevm+0x5a>
  {
    if (pgdir[i] & PTE_P)
80107867:	8b 03                	mov    (%ebx),%eax
80107869:	a8 01                	test   $0x1,%al
8010786b:	74 f3                	je     80107860 <freevm+0x30>
    {
      char *v = P2V(PTE_ADDR(pgdir[i]));
8010786d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107872:	83 ec 0c             	sub    $0xc,%esp
80107875:	83 c3 04             	add    $0x4,%ebx
      char *v = P2V(PTE_ADDR(pgdir[i]));
80107878:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010787d:	50                   	push   %eax
8010787e:	e8 fd ac ff ff       	call   80102580 <kfree>
80107883:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < NPDENTRIES; i++)
80107886:	39 df                	cmp    %ebx,%edi
80107888:	75 dd                	jne    80107867 <freevm+0x37>
    }
  }
  kfree((char *)pgdir);
8010788a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010788d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107890:	5b                   	pop    %ebx
80107891:	5e                   	pop    %esi
80107892:	5f                   	pop    %edi
80107893:	5d                   	pop    %ebp
  kfree((char *)pgdir);
80107894:	e9 e7 ac ff ff       	jmp    80102580 <kfree>
    panic("freevm: no pgdir");
80107899:	83 ec 0c             	sub    $0xc,%esp
8010789c:	68 03 8a 10 80       	push   $0x80108a03
801078a1:	e8 ea 8a ff ff       	call   80100390 <panic>
801078a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ad:	8d 76 00             	lea    0x0(%esi),%esi

801078b0 <setupkvm>:
{
801078b0:	f3 0f 1e fb          	endbr32 
801078b4:	55                   	push   %ebp
801078b5:	89 e5                	mov    %esp,%ebp
801078b7:	56                   	push   %esi
801078b8:	53                   	push   %ebx
  if ((pgdir = (pde_t *)kalloc()) == 0)
801078b9:	e8 72 b4 ff ff       	call   80102d30 <kalloc>
801078be:	89 c6                	mov    %eax,%esi
801078c0:	85 c0                	test   %eax,%eax
801078c2:	74 42                	je     80107906 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801078c4:	83 ec 04             	sub    $0x4,%esp
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078c7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801078cc:	68 00 10 00 00       	push   $0x1000
801078d1:	6a 00                	push   $0x0
801078d3:	50                   	push   %eax
801078d4:	e8 27 d6 ff ff       	call   80104f00 <memset>
801078d9:	83 c4 10             	add    $0x10,%esp
                 (uint)k->phys_start, k->perm) < 0)
801078dc:	8b 43 04             	mov    0x4(%ebx),%eax
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801078df:	83 ec 08             	sub    $0x8,%esp
801078e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801078e5:	ff 73 0c             	pushl  0xc(%ebx)
801078e8:	8b 13                	mov    (%ebx),%edx
801078ea:	50                   	push   %eax
801078eb:	29 c1                	sub    %eax,%ecx
801078ed:	89 f0                	mov    %esi,%eax
801078ef:	e8 bc f9 ff ff       	call   801072b0 <mappages>
801078f4:	83 c4 10             	add    $0x10,%esp
801078f7:	85 c0                	test   %eax,%eax
801078f9:	78 15                	js     80107910 <setupkvm+0x60>
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078fb:	83 c3 10             	add    $0x10,%ebx
801078fe:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107904:	75 d6                	jne    801078dc <setupkvm+0x2c>
}
80107906:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107909:	89 f0                	mov    %esi,%eax
8010790b:	5b                   	pop    %ebx
8010790c:	5e                   	pop    %esi
8010790d:	5d                   	pop    %ebp
8010790e:	c3                   	ret    
8010790f:	90                   	nop
      freevm(pgdir);
80107910:	83 ec 0c             	sub    $0xc,%esp
80107913:	56                   	push   %esi
      return 0;
80107914:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107916:	e8 15 ff ff ff       	call   80107830 <freevm>
      return 0;
8010791b:	83 c4 10             	add    $0x10,%esp
}
8010791e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107921:	89 f0                	mov    %esi,%eax
80107923:	5b                   	pop    %ebx
80107924:	5e                   	pop    %esi
80107925:	5d                   	pop    %ebp
80107926:	c3                   	ret    
80107927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010792e:	66 90                	xchg   %ax,%ax

80107930 <kvmalloc>:
{
80107930:	f3 0f 1e fb          	endbr32 
80107934:	55                   	push   %ebp
80107935:	89 e5                	mov    %esp,%ebp
80107937:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010793a:	e8 71 ff ff ff       	call   801078b0 <setupkvm>
8010793f:	a3 04 c5 11 80       	mov    %eax,0x8011c504
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80107944:	05 00 00 00 80       	add    $0x80000000,%eax
80107949:	0f 22 d8             	mov    %eax,%cr3
}
8010794c:	c9                   	leave  
8010794d:	c3                   	ret    
8010794e:	66 90                	xchg   %ax,%ax

80107950 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva)
{
80107950:	f3 0f 1e fb          	endbr32 
80107954:	55                   	push   %ebp
80107955:	89 e5                	mov    %esp,%ebp
80107957:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010795a:	6a 00                	push   $0x0
8010795c:	ff 75 0c             	pushl  0xc(%ebp)
8010795f:	ff 75 08             	pushl  0x8(%ebp)
80107962:	e8 b9 f8 ff ff       	call   80107220 <walkpgdir>
  if (pte == 0)
80107967:	83 c4 10             	add    $0x10,%esp
8010796a:	85 c0                	test   %eax,%eax
8010796c:	74 05                	je     80107973 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010796e:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107971:	c9                   	leave  
80107972:	c3                   	ret    
    panic("clearpteu");
80107973:	83 ec 0c             	sub    $0xc,%esp
80107976:	68 14 8a 10 80       	push   $0x80108a14
8010797b:	e8 10 8a ff ff       	call   80100390 <panic>

80107980 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *copyuvm(pde_t *pgdir, uint sz)
{
80107980:	f3 0f 1e fb          	endbr32 
80107984:	55                   	push   %ebp
80107985:	89 e5                	mov    %esp,%ebp
80107987:	57                   	push   %edi
80107988:	56                   	push   %esi
80107989:	53                   	push   %ebx
8010798a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if ((d = setupkvm()) == 0)
8010798d:	e8 1e ff ff ff       	call   801078b0 <setupkvm>
80107992:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107995:	85 c0                	test   %eax,%eax
80107997:	0f 84 af 00 00 00    	je     80107a4c <copyuvm+0xcc>
    return 0;
  for (i = 0; i < sz; i += PGSIZE)
8010799d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801079a0:	85 c9                	test   %ecx,%ecx
801079a2:	0f 84 a4 00 00 00    	je     80107a4c <copyuvm+0xcc>
801079a8:	31 db                	xor    %ebx,%ebx
801079aa:	eb 55                	jmp    80107a01 <copyuvm+0x81>
801079ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //   panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char *)P2V(pa), PGSIZE);
801079b0:	83 ec 04             	sub    $0x4,%esp
801079b3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801079b9:	68 00 10 00 00       	push   $0x1000
801079be:	57                   	push   %edi
801079bf:	50                   	push   %eax
801079c0:	e8 db d5 ff ff       	call   80104fa0 <memmove>
    if (mappages(d, (void *)i, PGSIZE, V2P(mem), flags) < 0)
801079c5:	58                   	pop    %eax
801079c6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801079cc:	5a                   	pop    %edx
801079cd:	ff 75 e4             	pushl  -0x1c(%ebp)
801079d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079d5:	89 da                	mov    %ebx,%edx
801079d7:	50                   	push   %eax
801079d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079db:	e8 d0 f8 ff ff       	call   801072b0 <mappages>
801079e0:	83 c4 10             	add    $0x10,%esp
801079e3:	85 c0                	test   %eax,%eax
801079e5:	78 79                	js     80107a60 <copyuvm+0xe0>
    {
      kfree(mem);
      goto bad;
    }
    page_insert(pgdir, i);
801079e7:	83 ec 08             	sub    $0x8,%esp
801079ea:	53                   	push   %ebx
  for (i = 0; i < sz; i += PGSIZE)
801079eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    page_insert(pgdir, i);
801079f1:	ff 75 08             	pushl  0x8(%ebp)
801079f4:	e8 c7 ae ff ff       	call   801028c0 <page_insert>
  for (i = 0; i < sz; i += PGSIZE)
801079f9:	83 c4 10             	add    $0x10,%esp
801079fc:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
801079ff:	76 4b                	jbe    80107a4c <copyuvm+0xcc>
    if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
80107a01:	83 ec 04             	sub    $0x4,%esp
80107a04:	6a 00                	push   $0x0
80107a06:	53                   	push   %ebx
80107a07:	ff 75 08             	pushl  0x8(%ebp)
80107a0a:	e8 11 f8 ff ff       	call   80107220 <walkpgdir>
80107a0f:	83 c4 10             	add    $0x10,%esp
80107a12:	85 c0                	test   %eax,%eax
80107a14:	74 58                	je     80107a6e <copyuvm+0xee>
    pa = PTE_ADDR(*pte);
80107a16:	8b 00                	mov    (%eax),%eax
80107a18:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107a1a:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107a22:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if ((mem = kalloc()) == 0)
80107a28:	e8 03 b3 ff ff       	call   80102d30 <kalloc>
80107a2d:	89 c6                	mov    %eax,%esi
80107a2f:	85 c0                	test   %eax,%eax
80107a31:	0f 85 79 ff ff ff    	jne    801079b0 <copyuvm+0x30>
  }
  // page insert in LRU linked list
  return d;

bad:
  freevm(d);
80107a37:	83 ec 0c             	sub    $0xc,%esp
80107a3a:	ff 75 e0             	pushl  -0x20(%ebp)
80107a3d:	e8 ee fd ff ff       	call   80107830 <freevm>
  return 0;
80107a42:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a49:	83 c4 10             	add    $0x10,%esp
}
80107a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a52:	5b                   	pop    %ebx
80107a53:	5e                   	pop    %esi
80107a54:	5f                   	pop    %edi
80107a55:	5d                   	pop    %ebp
80107a56:	c3                   	ret    
80107a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a5e:	66 90                	xchg   %ax,%ax
      kfree(mem);
80107a60:	83 ec 0c             	sub    $0xc,%esp
80107a63:	56                   	push   %esi
80107a64:	e8 17 ab ff ff       	call   80102580 <kfree>
      goto bad;
80107a69:	83 c4 10             	add    $0x10,%esp
80107a6c:	eb c9                	jmp    80107a37 <copyuvm+0xb7>
      panic("copyuvm: pte should exist");
80107a6e:	83 ec 0c             	sub    $0xc,%esp
80107a71:	68 1e 8a 10 80       	push   $0x80108a1e
80107a76:	e8 15 89 ff ff       	call   80100390 <panic>
80107a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a7f:	90                   	nop

80107a80 <uva2ka>:

// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva)
{
80107a80:	f3 0f 1e fb          	endbr32 
80107a84:	55                   	push   %ebp
80107a85:	89 e5                	mov    %esp,%ebp
80107a87:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a8a:	6a 00                	push   $0x0
80107a8c:	ff 75 0c             	pushl  0xc(%ebp)
80107a8f:	ff 75 08             	pushl  0x8(%ebp)
80107a92:	e8 89 f7 ff ff       	call   80107220 <walkpgdir>
  if ((*pte & PTE_P) == 0)
    return 0;
  if ((*pte & PTE_U) == 0)
80107a97:	83 c4 10             	add    $0x10,%esp
  if ((*pte & PTE_P) == 0)
80107a9a:	8b 00                	mov    (%eax),%eax
    return 0;
  return (char *)P2V(PTE_ADDR(*pte));
}
80107a9c:	c9                   	leave  
  if ((*pte & PTE_U) == 0)
80107a9d:	89 c2                	mov    %eax,%edx
  return (char *)P2V(PTE_ADDR(*pte));
80107a9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if ((*pte & PTE_U) == 0)
80107aa4:	83 e2 05             	and    $0x5,%edx
  return (char *)P2V(PTE_ADDR(*pte));
80107aa7:	05 00 00 00 80       	add    $0x80000000,%eax
80107aac:	83 fa 05             	cmp    $0x5,%edx
80107aaf:	ba 00 00 00 00       	mov    $0x0,%edx
80107ab4:	0f 45 c2             	cmovne %edx,%eax
}
80107ab7:	c3                   	ret    
80107ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107abf:	90                   	nop

80107ac0 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107ac0:	f3 0f 1e fb          	endbr32 
80107ac4:	55                   	push   %ebp
80107ac5:	89 e5                	mov    %esp,%ebp
80107ac7:	57                   	push   %edi
80107ac8:	56                   	push   %esi
80107ac9:	53                   	push   %ebx
80107aca:	83 ec 0c             	sub    $0xc,%esp
80107acd:	8b 75 14             	mov    0x14(%ebp),%esi
80107ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char *)p;
  while (len > 0)
80107ad3:	85 f6                	test   %esi,%esi
80107ad5:	75 3c                	jne    80107b13 <copyout+0x53>
80107ad7:	eb 67                	jmp    80107b40 <copyout+0x80>
80107ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char *)va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ae3:	89 fb                	mov    %edi,%ebx
80107ae5:	29 d3                	sub    %edx,%ebx
80107ae7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if (n > len)
80107aed:	39 f3                	cmp    %esi,%ebx
80107aef:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107af2:	29 fa                	sub    %edi,%edx
80107af4:	83 ec 04             	sub    $0x4,%esp
80107af7:	01 c2                	add    %eax,%edx
80107af9:	53                   	push   %ebx
80107afa:	ff 75 10             	pushl  0x10(%ebp)
80107afd:	52                   	push   %edx
80107afe:	e8 9d d4 ff ff       	call   80104fa0 <memmove>
    len -= n;
    buf += n;
80107b03:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107b06:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while (len > 0)
80107b0c:	83 c4 10             	add    $0x10,%esp
80107b0f:	29 de                	sub    %ebx,%esi
80107b11:	74 2d                	je     80107b40 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107b13:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
80107b15:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107b18:	89 55 0c             	mov    %edx,0xc(%ebp)
80107b1b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
80107b21:	57                   	push   %edi
80107b22:	ff 75 08             	pushl  0x8(%ebp)
80107b25:	e8 56 ff ff ff       	call   80107a80 <uva2ka>
    if (pa0 == 0)
80107b2a:	83 c4 10             	add    $0x10,%esp
80107b2d:	85 c0                	test   %eax,%eax
80107b2f:	75 af                	jne    80107ae0 <copyout+0x20>
  }
  return 0;
}
80107b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b39:	5b                   	pop    %ebx
80107b3a:	5e                   	pop    %esi
80107b3b:	5f                   	pop    %edi
80107b3c:	5d                   	pop    %ebp
80107b3d:	c3                   	ret    
80107b3e:	66 90                	xchg   %ax,%ax
80107b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b43:	31 c0                	xor    %eax,%eax
}
80107b45:	5b                   	pop    %ebx
80107b46:	5e                   	pop    %esi
80107b47:	5f                   	pop    %edi
80107b48:	5d                   	pop    %ebp
80107b49:	c3                   	ret    
