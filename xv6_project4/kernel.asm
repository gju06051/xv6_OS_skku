
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
8010002d:	b8 30 39 10 80       	mov    $0x80103930,%eax
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
80100050:	68 a0 7b 10 80       	push   $0x80107ba0
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 61 4c 00 00       	call   80104cc0 <initlock>
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
80100092:	68 a7 7b 10 80       	push   $0x80107ba7
80100097:	50                   	push   %eax
80100098:	e8 e3 4a 00 00       	call   80104b80 <initsleeplock>
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
801000e8:	e8 53 4d 00 00       	call   80104e40 <acquire>
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
80100162:	e8 99 4d 00 00       	call   80104f00 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 4a 00 00       	call   80104bc0 <acquiresleep>
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
801001a3:	68 ae 7b 10 80       	push   $0x80107bae
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
801001c2:	e8 99 4a 00 00       	call   80104c60 <holdingsleep>
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
801001e0:	68 bf 7b 10 80       	push   $0x80107bbf
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
80100203:	e8 58 4a 00 00       	call   80104c60 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 08 4a 00 00       	call   80104c20 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 1c 4c 00 00       	call   80104e40 <acquire>
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
80100270:	e9 8b 4c 00 00       	jmp    80104f00 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 c6 7b 10 80       	push   $0x80107bc6
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
801002b1:	e8 8a 4b 00 00       	call   80104e40 <acquire>
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
801002e5:	e8 16 45 00 00       	call   80104800 <sleep>
    while (input.r == input.w)
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if (myproc()->killed)
801002fa:	e8 51 3f 00 00       	call   80104250 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 ed 4b 00 00       	call   80104f00 <release>
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
80100365:	e8 96 4b 00 00       	call   80104f00 <release>
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
801003ad:	e8 de 2d 00 00       	call   80103190 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 cd 7b 10 80       	push   $0x80107bcd
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 81 8a 10 80 	movl   $0x80108a81,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ff 48 00 00       	call   80104ce0 <getcallerpcs>
  for (i = 0; i < 10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 e1 7b 10 80       	push   $0x80107be1
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
8010042a:	e8 f1 62 00 00       	call   80106720 <uartputc>
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
80100515:	e8 06 62 00 00       	call   80106720 <uartputc>
    uartputc(' ');
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 fa 61 00 00       	call   80106720 <uartputc>
    uartputc('\b');
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ee 61 00 00       	call   80106720 <uartputc>
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
80100561:	e8 8a 4a 00 00       	call   80104ff0 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 d5 49 00 00       	call   80104f50 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 e5 7b 10 80       	push   $0x80107be5
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
801005c9:	0f b6 92 10 7c 10 80 	movzbl -0x7fef83f0(%edx),%edx
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
8010065f:	e8 dc 47 00 00       	call   80104e40 <acquire>
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
80100697:	e8 64 48 00 00       	call   80104f00 <release>
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
8010077d:	bb f8 7b 10 80       	mov    $0x80107bf8,%ebx
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
801007bd:	e8 7e 46 00 00       	call   80104e40 <acquire>
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
80100828:	e8 d3 46 00 00       	call   80104f00 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 ff 7b 10 80       	push   $0x80107bff
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
80100877:	e8 c4 45 00 00       	call   80104e40 <acquire>
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
801009cf:	e8 2c 45 00 00       	call   80104f00 <release>
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
801009ff:	e9 ac 40 00 00       	jmp    80104ab0 <procdump>
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
80100a20:	e8 9b 3f 00 00       	call   801049c0 <wakeup>
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
80100a3a:	68 08 7c 10 80       	push   $0x80107c08
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 77 42 00 00       	call   80104cc0 <initlock>

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
80100a90:	e8 bb 37 00 00       	call   80104250 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 80 2b 00 00       	call   80103620 <begin_op>

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
80100ae3:	e8 a8 2b 00 00       	call   80103690 <end_op>
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
80100b0c:	e8 ef 6d 00 00       	call   80107900 <setupkvm>
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
80100b73:	e8 98 6b 00 00       	call   80107710 <allocuvm>
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
80100ba9:	e8 92 6a 00 00       	call   80107640 <loaduvm>
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
80100beb:	e8 90 6c 00 00       	call   80107880 <freevm>
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
80100c21:	e8 6a 2a 00 00       	call   80103690 <end_op>
  if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 d9 6a 00 00       	call   80107710 <allocuvm>
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
80100c53:	e8 48 6d 00 00       	call   801079a0 <clearpteu>
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
80100ca3:	e8 a8 44 00 00       	call   80105150 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 95 44 00 00       	call   80105150 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 44 6e 00 00       	call   80107b10 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 9a 6b 00 00       	call   80107880 <freevm>
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
80100d33:	e8 d8 6d 00 00       	call   80107b10 <copyout>
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
80100d71:	e8 9a 43 00 00       	call   80105110 <safestrcpy>
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
80100d9d:	e8 fe 66 00 00       	call   801074a0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 d6 6a 00 00       	call   80107880 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 d7 28 00 00       	call   80103690 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 21 7c 10 80       	push   $0x80107c21
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
80100dea:	68 2d 7c 10 80       	push   $0x80107c2d
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 c7 3e 00 00       	call   80104cc0 <initlock>
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
80100e15:	e8 26 40 00 00       	call   80104e40 <acquire>
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
80100e41:	e8 ba 40 00 00       	call   80104f00 <release>
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
80100e5a:	e8 a1 40 00 00       	call   80104f00 <release>
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
80100e83:	e8 b8 3f 00 00       	call   80104e40 <acquire>
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
80100ea0:	e8 5b 40 00 00       	call   80104f00 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 34 7c 10 80       	push   $0x80107c34
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
80100ed5:	e8 66 3f 00 00       	call   80104e40 <acquire>
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
80100f10:	e8 eb 3f 00 00       	call   80104f00 <release>

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
80100f3e:	e9 bd 3f 00 00       	jmp    80104f00 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 d3 26 00 00       	call   80103620 <begin_op>
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
80100f62:	e9 29 27 00 00       	jmp    80103690 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 72 2e 00 00       	call   80103df0 <pipeclose>
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
80100f8c:	68 3c 7c 10 80       	push   $0x80107c3c
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
80101065:	e9 26 2f 00 00       	jmp    80103f90 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 46 7c 10 80       	push   $0x80107c46
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
801010f1:	e8 9a 25 00 00       	call   80103690 <end_op>

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
8010111a:	e8 01 25 00 00       	call   80103620 <begin_op>
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
80101151:	e8 3a 25 00 00       	call   80103690 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 4f 7c 10 80       	push   $0x80107c4f
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
80101191:	e9 fa 2c 00 00       	jmp    80103e90 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 55 7c 10 80       	push   $0x80107c55
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
80101254:	68 5f 7c 10 80       	push   $0x80107c5f
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
8010126d:	e8 8e 25 00 00       	call   80103800 <log_write>
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
80101295:	e8 b6 3c 00 00       	call   80104f50 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 5e 25 00 00       	call   80103800 <log_write>
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
801012da:	e8 61 3b 00 00       	call   80104e40 <acquire>
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
80101347:	e8 b4 3b 00 00       	call   80104f00 <release>

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
80101375:	e8 86 3b 00 00       	call   80104f00 <release>
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
801013a2:	68 75 7c 10 80       	push   $0x80107c75
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
80101425:	e8 d6 23 00 00       	call   80103800 <log_write>
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
8010146b:	68 85 7c 10 80       	push   $0x80107c85
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
801014a5:	e8 46 3b 00 00       	call   80104ff0 <memmove>
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
8010151a:	e8 e1 22 00 00       	call   80103800 <log_write>
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
80101534:	68 98 7c 10 80       	push   $0x80107c98
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
80101550:	68 ab 7c 10 80       	push   $0x80107cab
80101555:	68 00 1a 11 80       	push   $0x80111a00
8010155a:	e8 61 37 00 00       	call   80104cc0 <initlock>
  for (i = 0; i < NINODE; i++)
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 b2 7c 10 80       	push   $0x80107cb2
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 04 36 00 00       	call   80104b80 <initsleeplock>
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
801015c1:	68 50 7d 10 80       	push   $0x80107d50
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
8010165e:	e8 ed 38 00 00       	call   80104f50 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp); // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 8b 21 00 00       	call   80103800 <log_write>
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
80101693:	68 b8 7c 10 80       	push   $0x80107cb8
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
80101705:	e8 e6 38 00 00       	call   80104ff0 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 ee 20 00 00       	call   80103800 <log_write>
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
80101743:	e8 f8 36 00 00       	call   80104e40 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101753:	e8 a8 37 00 00       	call   80104f00 <release>
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
80101786:	e8 35 34 00 00       	call   80104bc0 <acquiresleep>
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
801017f8:	e8 f3 37 00 00       	call   80104ff0 <memmove>
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
8010181d:	68 d0 7c 10 80       	push   $0x80107cd0
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 ca 7c 10 80       	push   $0x80107cca
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
80101857:	e8 04 34 00 00       	call   80104c60 <holdingsleep>
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
80101873:	e9 a8 33 00 00       	jmp    80104c20 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 df 7c 10 80       	push   $0x80107cdf
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
801018a4:	e8 17 33 00 00       	call   80104bc0 <acquiresleep>
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
801018be:	e8 5d 33 00 00       	call   80104c20 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801018ca:	e8 71 35 00 00       	call   80104e40 <acquire>
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
801018e4:	e9 17 36 00 00       	jmp    80104f00 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 00 1a 11 80       	push   $0x80111a00
801018f8:	e8 43 35 00 00       	call   80104e40 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101907:	e8 f4 35 00 00       	call   80104f00 <release>
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
80101b07:	e8 e4 34 00 00       	call   80104ff0 <memmove>
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
80101c03:	e8 e8 33 00 00       	call   80104ff0 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 f0 1b 00 00       	call   80103800 <log_write>
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
80101ca2:	e8 b9 33 00 00       	call   80105060 <strncmp>
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
80101d05:	e8 56 33 00 00       	call   80105060 <strncmp>
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
80101d4a:	68 f9 7c 10 80       	push   $0x80107cf9
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 e7 7c 10 80       	push   $0x80107ce7
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
80101d8a:	e8 c1 24 00 00       	call   80104250 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 00 1a 11 80       	push   $0x80111a00
80101d9c:	e8 9f 30 00 00       	call   80104e40 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101dac:	e8 4f 31 00 00       	call   80104f00 <release>
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
80101e17:	e8 d4 31 00 00       	call   80104ff0 <memmove>
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
80101ea3:	e8 48 31 00 00       	call   80104ff0 <memmove>
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
80101fd5:	e8 d6 30 00 00       	call   801050b0 <strncpy>
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
80102013:	68 08 7d 10 80       	push   $0x80107d08
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 0a 88 10 80       	push   $0x8010880a
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
801020ca:	e8 21 2f 00 00       	call   80104ff0 <memmove>
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
801020ea:	68 15 7d 10 80       	push   $0x80107d15
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
8010215a:	e8 91 2e 00 00       	call   80104ff0 <memmove>
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
80102182:	68 32 7d 10 80       	push   $0x80107d32
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
80102242:	68 ac 7d 10 80       	push   $0x80107dac
80102247:	e8 44 e1 ff ff       	call   80100390 <panic>
    panic("idestart");
8010224c:	83 ec 0c             	sub    $0xc,%esp
8010224f:	68 a3 7d 10 80       	push   $0x80107da3
80102254:	e8 37 e1 ff ff       	call   80100390 <panic>
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102260 <ideinit>:
{
80102260:	f3 0f 1e fb          	endbr32 
80102264:	55                   	push   %ebp
80102265:	89 e5                	mov    %esp,%ebp
80102267:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010226a:	68 be 7d 10 80       	push   $0x80107dbe
8010226f:	68 80 b5 10 80       	push   $0x8010b580
80102274:	e8 47 2a 00 00       	call   80104cc0 <initlock>
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
80102302:	e8 39 2b 00 00       	call   80104e40 <acquire>

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
8010235d:	e8 5e 26 00 00       	call   801049c0 <wakeup>

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
8010237b:	e8 80 2b 00 00       	call   80104f00 <release>

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
801023a2:	e8 b9 28 00 00       	call   80104c60 <holdingsleep>
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
801023dc:	e8 5f 2a 00 00       	call   80104e40 <acquire>

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
80102429:	e8 d2 23 00 00       	call   80104800 <sleep>
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
80102446:	e9 b5 2a 00 00       	jmp    80104f00 <release>
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
8010246a:	68 ed 7d 10 80       	push   $0x80107ded
8010246f:	e8 1c df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	68 d8 7d 10 80       	push   $0x80107dd8
8010247c:	e8 0f df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102481:	83 ec 0c             	sub    $0xc,%esp
80102484:	68 c2 7d 10 80       	push   $0x80107dc2
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
801024de:	68 0c 7e 10 80       	push   $0x80107e0c
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
801025c1:	e8 8a 29 00 00       	call   80104f50 <memset>

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
80102608:	e8 33 28 00 00       	call   80104e40 <acquire>
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
80102625:	e9 d6 28 00 00       	jmp    80104f00 <release>
      cprintf("PGROUND Need\n");
8010262a:	83 ec 0c             	sub    $0xc,%esp
8010262d:	68 59 7e 10 80       	push   $0x80107e59
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
8010264d:	68 67 7e 10 80       	push   $0x80107e67
80102652:	e8 39 dd ff ff       	call   80100390 <panic>
      cprintf("physical addr is upper than PHYSTOP");
80102657:	83 ec 0c             	sub    $0xc,%esp
8010265a:	68 d8 7e 10 80       	push   $0x80107ed8
8010265f:	e8 4c e0 ff ff       	call   801006b0 <cprintf>
80102664:	83 c4 10             	add    $0x10,%esp
80102667:	eb e1                	jmp    8010264a <kfree+0xca>
      cprintf("virtual addr is under end\n");
80102669:	83 ec 0c             	sub    $0xc,%esp
8010266c:	68 3e 7e 10 80       	push   $0x80107e3e
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
801026df:	68 6d 7e 10 80       	push   $0x80107e6d
801026e4:	68 60 36 11 80       	push   $0x80113660
801026e9:	e8 d2 25 00 00       	call   80104cc0 <initlock>
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
801027f3:	68 fc 7e 10 80       	push   $0x80107efc
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
  int pte_n_a = 0;
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
80102836:	7e 77                	jle    801028af <lru_print+0x8f>
80102838:	31 f6                	xor    %esi,%esi
8010283a:	eb 2e                	jmp    8010286a <lru_print+0x4a>
8010283c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    // pte_n_a = *pte & PTE_A;
    if (p_page->vaddr == 0)
      cprintf("LRU entry %d, pgdir : %x, vaddr : 0000, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);

    else
      cprintf("LRU entry %d, pgdir : %x, vaddr : %x, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);
80102840:	83 ec 04             	sub    $0x4,%esp
80102843:	ff 30                	pushl  (%eax)
80102845:	6a 00                	push   $0x0
80102847:	ff 73 10             	pushl  0x10(%ebx)
8010284a:	52                   	push   %edx
8010284b:	ff 73 08             	pushl  0x8(%ebx)
8010284e:	56                   	push   %esi
  for (int i = 0; i < num_lru_pages; i++)
8010284f:	83 c6 01             	add    $0x1,%esi
      cprintf("LRU entry %d, pgdir : %x, vaddr : %x, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);
80102852:	68 80 7f 10 80       	push   $0x80107f80
80102857:	e8 54 de ff ff       	call   801006b0 <cprintf>
    p_page = p_page->prev;
8010285c:	8b 5b 04             	mov    0x4(%ebx),%ebx
      cprintf("LRU entry %d, pgdir : %x, vaddr : %x, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);
8010285f:	83 c4 20             	add    $0x20,%esp
  for (int i = 0; i < num_lru_pages; i++)
80102862:	39 35 a0 46 11 80    	cmp    %esi,0x801146a0
80102868:	7e 45                	jle    801028af <lru_print+0x8f>
    pte = walkpgdir(p_page->pgdir, p_page->vaddr, 0);
8010286a:	83 ec 04             	sub    $0x4,%esp
8010286d:	6a 00                	push   $0x0
8010286f:	ff 73 0c             	pushl  0xc(%ebx)
80102872:	ff 73 08             	pushl  0x8(%ebx)
80102875:	e8 f6 49 00 00       	call   80107270 <walkpgdir>
    if (p_page->vaddr == 0)
8010287a:	8b 53 0c             	mov    0xc(%ebx),%edx
8010287d:	83 c4 10             	add    $0x10,%esp
80102880:	85 d2                	test   %edx,%edx
80102882:	75 bc                	jne    80102840 <lru_print+0x20>
      cprintf("LRU entry %d, pgdir : %x, vaddr : 0000, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);
80102884:	83 ec 04             	sub    $0x4,%esp
80102887:	ff 30                	pushl  (%eax)
80102889:	6a 00                	push   $0x0
8010288b:	ff 73 10             	pushl  0x10(%ebx)
8010288e:	6a 00                	push   $0x0
80102890:	ff 73 08             	pushl  0x8(%ebx)
80102893:	56                   	push   %esi
  for (int i = 0; i < num_lru_pages; i++)
80102894:	83 c6 01             	add    $0x1,%esi
      cprintf("LRU entry %d, pgdir : %x, vaddr : 0000, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);
80102897:	68 38 7f 10 80       	push   $0x80107f38
8010289c:	e8 0f de ff ff       	call   801006b0 <cprintf>
    p_page = p_page->prev;
801028a1:	8b 5b 04             	mov    0x4(%ebx),%ebx
801028a4:	83 c4 20             	add    $0x20,%esp
  for (int i = 0; i < num_lru_pages; i++)
801028a7:	39 35 a0 46 11 80    	cmp    %esi,0x801146a0
801028ad:	7f bb                	jg     8010286a <lru_print+0x4a>
  }
}
801028af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028b2:	5b                   	pop    %ebx
801028b3:	5e                   	pop    %esi
801028b4:	5d                   	pop    %ebp
801028b5:	c3                   	ret    
801028b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028bd:	8d 76 00             	lea    0x0(%esi),%esi

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
80102948:	68 c8 7f 10 80       	push   $0x80107fc8
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
801029ad:	68 c8 7f 10 80       	push   $0x80107fc8
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
801029cf:	e8 9c 48 00 00       	call   80107270 <walkpgdir>
801029d4:	c7 45 08 72 7e 10 80 	movl   $0x80107e72,0x8(%ebp)
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
801029f4:	68 08 80 10 80       	push   $0x80108008
801029f9:	e8 b2 dc ff ff       	call   801006b0 <cprintf>
801029fe:	83 c4 10             	add    $0x10,%esp
80102a01:	eb b7                	jmp    801029ba <page_insert+0xfa>
80102a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a07:	90                   	nop
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", num_lru_pages, new_page->pgdir, new_page->vaddr);
80102a08:	52                   	push   %edx
80102a09:	51                   	push   %ecx
80102a0a:	56                   	push   %esi
80102a0b:	68 08 80 10 80       	push   $0x80108008
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
80102a62:	8b 35 a0 46 11 80    	mov    0x801146a0,%esi
{
80102a68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  temp_head = page_lru_head;
80102a6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for (int i = 0; i < num_lru_pages; i++) // search lru with vaddr, pgdir
80102a6e:	85 f6                	test   %esi,%esi
80102a70:	0f 8e 8f 00 00 00    	jle    80102b05 <page_delete+0xb5>
80102a76:	31 ff                	xor    %edi,%edi
80102a78:	31 d2                	xor    %edx,%edx
80102a7a:	eb 13                	jmp    80102a8f <page_delete+0x3f>
80102a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a80:	83 c2 01             	add    $0x1,%edx
      // cprintf("================Page delete end================\n");
      return 0;
    }
    else
    {
      page_lru_head = page_lru_head->prev;
80102a83:	8b 40 04             	mov    0x4(%eax),%eax
  for (int i = 0; i < num_lru_pages; i++) // search lru with vaddr, pgdir
80102a86:	bf 01 00 00 00       	mov    $0x1,%edi
80102a8b:	39 f2                	cmp    %esi,%edx
80102a8d:	74 71                	je     80102b00 <page_delete+0xb0>
    if ((p_page->pgdir == pgdir) && (PTE_ADDR(p_page->vaddr) == (uint)vaddr))
80102a8f:	39 58 08             	cmp    %ebx,0x8(%eax)
80102a92:	75 ec                	jne    80102a80 <page_delete+0x30>
80102a94:	8b 48 0c             	mov    0xc(%eax),%ecx
80102a97:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80102a9d:	39 4d 0c             	cmp    %ecx,0xc(%ebp)
80102aa0:	75 de                	jne    80102a80 <page_delete+0x30>
80102aa2:	89 f9                	mov    %edi,%ecx
80102aa4:	84 c9                	test   %cl,%cl
80102aa6:	74 05                	je     80102aad <page_delete+0x5d>
80102aa8:	a3 a4 46 11 80       	mov    %eax,0x801146a4
      b_page = p_page->next;
80102aad:	8b 10                	mov    (%eax),%edx
      f_page = p_page->prev;
80102aaf:	8b 48 04             	mov    0x4(%eax),%ecx
      page_lru_head = temp_head->prev;
80102ab2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      f_page->next = b_page;
80102ab5:	89 11                	mov    %edx,(%ecx)
      num_lru_pages--;
80102ab7:	8b 3d a0 46 11 80    	mov    0x801146a0,%edi
      b_page->prev = f_page;
80102abd:	89 4a 04             	mov    %ecx,0x4(%edx)
      p_page->use = 0;
80102ac0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
      page_lru_head = temp_head->prev;
80102ac7:	8b 4e 04             	mov    0x4(%esi),%ecx
      num_lru_pages--;
80102aca:	8d 57 ff             	lea    -0x1(%edi),%edx
80102acd:	89 15 a0 46 11 80    	mov    %edx,0x801146a0
      page_lru_head = temp_head->prev;
80102ad3:	89 0d a4 46 11 80    	mov    %ecx,0x801146a4
      if (vaddr == 0)
80102ad9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102adc:	85 c9                	test   %ecx,%ecx
80102ade:	74 64                	je     80102b44 <page_delete+0xf4>
        cprintf("Page Delete | num_lru_pages : %d, pgdir : %x, vaddr : %x\n", num_lru_pages, p_page->pgdir, p_page->vaddr);
80102ae0:	ff 70 0c             	pushl  0xc(%eax)
80102ae3:	ff 70 08             	pushl  0x8(%eax)
80102ae6:	52                   	push   %edx
80102ae7:	68 80 80 10 80       	push   $0x80108080
80102aec:	e8 bf db ff ff       	call   801006b0 <cprintf>
80102af1:	83 c4 10             	add    $0x10,%esp
  // for (int i = 0; i < PGSIZE; i++)
  // {
  //   cprintf("Bitmap[%d] : %x\n", i, bitmap[i]);
  // }
  return -1;
}
80102af4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80102af7:	31 c0                	xor    %eax,%eax
}
80102af9:	5b                   	pop    %ebx
80102afa:	5e                   	pop    %esi
80102afb:	5f                   	pop    %edi
80102afc:	5d                   	pop    %ebp
80102afd:	c3                   	ret    
80102afe:	66 90                	xchg   %ax,%ax
80102b00:	a3 a4 46 11 80       	mov    %eax,0x801146a4
  cprintf("=================================LRU linked list TOP=================================\n");
80102b05:	83 ec 0c             	sub    $0xc,%esp
80102b08:	68 bc 80 10 80       	push   $0x801080bc
80102b0d:	e8 9e db ff ff       	call   801006b0 <cprintf>
  cprintf("Page delete target | pgdir : %x | vaddr : %x\n", pgdir, vaddr);
80102b12:	83 c4 0c             	add    $0xc,%esp
80102b15:	ff 75 0c             	pushl  0xc(%ebp)
80102b18:	53                   	push   %ebx
80102b19:	68 14 81 10 80       	push   $0x80108114
80102b1e:	e8 8d db ff ff       	call   801006b0 <cprintf>
  lru_print();
80102b23:	e8 f8 fc ff ff       	call   80102820 <lru_print>
  cprintf("=================================LRU linked list BOT=================================\n");
80102b28:	c7 04 24 44 81 10 80 	movl   $0x80108144,(%esp)
80102b2f:	e8 7c db ff ff       	call   801006b0 <cprintf>
  return -1;
80102b34:	83 c4 10             	add    $0x10,%esp
80102b37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102b3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b3f:	5b                   	pop    %ebx
80102b40:	5e                   	pop    %esi
80102b41:	5f                   	pop    %edi
80102b42:	5d                   	pop    %ebp
80102b43:	c3                   	ret    
        cprintf("Page Delete | num_lru_pages : %d, pgdir : %x, vaddr : 0000\n", num_lru_pages, p_page->pgdir);
80102b44:	83 ec 04             	sub    $0x4,%esp
80102b47:	ff 70 08             	pushl  0x8(%eax)
80102b4a:	52                   	push   %edx
80102b4b:	68 44 80 10 80       	push   $0x80108044
80102b50:	e8 5b db ff ff       	call   801006b0 <cprintf>
80102b55:	83 c4 10             	add    $0x10,%esp
      return 0;
80102b58:	31 c0                	xor    %eax,%eax
80102b5a:	eb e0                	jmp    80102b3c <page_delete+0xec>
80102b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b60 <swapout>:

char *swapout(void)
{
80102b60:	f3 0f 1e fb          	endbr32 
80102b64:	55                   	push   %ebp
80102b65:	89 e5                	mov    %esp,%ebp
80102b67:	57                   	push   %edi
80102b68:	56                   	push   %esi
80102b69:	53                   	push   %ebx
80102b6a:	83 ec 1c             	sub    $0x1c,%esp
  char *mem;
  int bitmap_offset_get = 0;
  // cprintf("================swap out start================\n");

  int bitmap_offset = 0;
  if (num_lru_pages == 0)
80102b6d:	8b 35 a0 46 11 80    	mov    0x801146a0,%esi
80102b73:	85 f6                	test   %esi,%esi
80102b75:	0f 84 b6 01 00 00    	je     80102d31 <swapout+0x1d1>
  {
    panic("OOM Error");
  }

  // get bitmap free
  for (int i = 0; i < PGSIZE; i++)
80102b7b:	31 db                	xor    %ebx,%ebx
80102b7d:	8d 76 00             	lea    0x0(%esi),%esi
    if (bitmap_offset_get)
      break;
    for (int j = 0; j < 8; j++)
    {
      //  get low bit in bitmap
      if ((set_bit & bitmap[i]) == 0)
80102b80:	0f b6 8b a0 36 11 80 	movzbl -0x7feec960(%ebx),%ecx
    for (int j = 0; j < 8; j++)
80102b87:	31 c0                	xor    %eax,%eax
    set_bit = 1;
80102b89:	ba 01 00 00 00       	mov    $0x1,%edx
80102b8e:	66 90                	xchg   %ax,%ax
      if ((set_bit & bitmap[i]) == 0)
80102b90:	84 d1                	test   %dl,%cl
80102b92:	74 24                	je     80102bb8 <swapout+0x58>
    for (int j = 0; j < 8; j++)
80102b94:	83 c0 01             	add    $0x1,%eax
        break;
      }
      else
      {
        // shift to next bit for check
        set_bit = set_bit << 1;
80102b97:	01 d2                	add    %edx,%edx
    for (int j = 0; j < 8; j++)
80102b99:	83 f8 08             	cmp    $0x8,%eax
80102b9c:	75 f2                	jne    80102b90 <swapout+0x30>
  for (int i = 0; i < PGSIZE; i++)
80102b9e:	83 c3 01             	add    $0x1,%ebx
80102ba1:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
80102ba7:	75 d7                	jne    80102b80 <swapout+0x20>
80102ba9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102bb0:	eb 0c                	jmp    80102bbe <swapout+0x5e>
80102bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bitmap_offset = 8 * i + j;
80102bb8:	8d 04 d8             	lea    (%eax,%ebx,8),%eax
80102bbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    p_page = p_page->prev;
  }
  cprintf("============page entry bottom\n");
  */
  // victim page process
  for (int i = 0; i < num_lru_pages + 10; i++)
80102bbe:	83 fe f7             	cmp    $0xfffffff7,%esi
80102bc1:	0f 8c 4c 01 00 00    	jl     80102d13 <swapout+0x1b3>
80102bc7:	8b 3d a4 46 11 80    	mov    0x801146a4,%edi
80102bcd:	31 f6                	xor    %esi,%esi
80102bcf:	eb 2d                	jmp    80102bfe <swapout+0x9e>
80102bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    else // ref bit high
    {
      // clear the flag
      // cprintf("clear flag occur\n");
      *pte = *pte & (~PTE_A);
80102bd8:	83 e3 df             	and    $0xffffffdf,%ebx
  for (int i = 0; i < num_lru_pages + 10; i++)
80102bdb:	83 c6 01             	add    $0x1,%esi
      *pte = *pte & (~PTE_A);
80102bde:	89 18                	mov    %ebx,(%eax)
      // go to previous page
      page_lru_head = page_lru_head->prev;
80102be0:	a1 a4 46 11 80       	mov    0x801146a4,%eax
80102be5:	8b 78 04             	mov    0x4(%eax),%edi
  for (int i = 0; i < num_lru_pages + 10; i++)
80102be8:	a1 a0 46 11 80       	mov    0x801146a0,%eax
80102bed:	83 c0 09             	add    $0x9,%eax
      page_lru_head = page_lru_head->prev;
80102bf0:	89 3d a4 46 11 80    	mov    %edi,0x801146a4
  for (int i = 0; i < num_lru_pages + 10; i++)
80102bf6:	39 c6                	cmp    %eax,%esi
80102bf8:	0f 8f 15 01 00 00    	jg     80102d13 <swapout+0x1b3>
    pte = walkpgdir(p_page->pgdir, p_page->vaddr, 0);
80102bfe:	83 ec 04             	sub    $0x4,%esp
80102c01:	6a 00                	push   $0x0
80102c03:	ff 77 0c             	pushl  0xc(%edi)
80102c06:	ff 77 08             	pushl  0x8(%edi)
80102c09:	e8 62 46 00 00       	call   80107270 <walkpgdir>
    if ((*pte != 0) && ((*pte & PTE_A) == 0)) // ref bit low
80102c0e:	83 c4 10             	add    $0x10,%esp
    mem = P2V((PTE_ADDR(*pte)));
80102c11:	8b 18                	mov    (%eax),%ebx
    if ((*pte != 0) && ((*pte & PTE_A) == 0)) // ref bit low
80102c13:	85 db                	test   %ebx,%ebx
80102c15:	74 c1                	je     80102bd8 <swapout+0x78>
80102c17:	f6 c3 20             	test   $0x20,%bl
80102c1a:	75 bc                	jne    80102bd8 <swapout+0x78>
      if (p_page->vaddr == 0)
80102c1c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80102c1f:	89 d9                	mov    %ebx,%ecx
80102c21:	8b 57 0c             	mov    0xc(%edi),%edx
80102c24:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c27:	81 e1 fe 0f 00 00    	and    $0xffe,%ecx
80102c2d:	c1 e6 0c             	shl    $0xc,%esi
80102c30:	09 f1                	or     %esi,%ecx
80102c32:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80102c35:	8b 4f 08             	mov    0x8(%edi),%ecx
80102c38:	85 d2                	test   %edx,%edx
80102c3a:	0f 84 b9 00 00 00    	je     80102cf9 <swapout+0x199>
        cprintf("Swapout victim page | pgdir : %x, vaddr : %x, PTE : %x, Modified PTE : %x\n", p_page->pgdir, p_page->vaddr, *pte, (((bitmap_offset << 12) | PTE_FLAGS(*pte)) & (~PTE_P)));
80102c40:	83 ec 0c             	sub    $0xc,%esp
80102c43:	ff 75 e0             	pushl  -0x20(%ebp)
80102c46:	53                   	push   %ebx
80102c47:	52                   	push   %edx
80102c48:	51                   	push   %ecx
80102c49:	68 3c 82 10 80       	push   $0x8010823c
80102c4e:	e8 5d da ff ff       	call   801006b0 <cprintf>
80102c53:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102c56:	83 c4 20             	add    $0x20,%esp
    mem = P2V((PTE_ADDR(*pte)));
80102c59:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
      swapwrite(mem, bitmap_offset);
80102c5f:	83 ec 08             	sub    $0x8,%esp
80102c62:	ff 75 e4             	pushl  -0x1c(%ebp)
    mem = P2V((PTE_ADDR(*pte)));
80102c65:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
      swapwrite(mem, bitmap_offset);
80102c6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c6e:	53                   	push   %ebx
80102c6f:	e8 8c f4 ff ff       	call   80102100 <swapwrite>
      *pte = (bitmap_offset << 12) | PTE_FLAGS(*pte);
80102c74:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102c77:	8b 10                	mov    (%eax),%edx
80102c79:	81 e2 fe 0f 00 00    	and    $0xffe,%edx
      *pte = *pte & (~PTE_P);
80102c7f:	09 f2                	or     %esi,%edx
80102c81:	89 10                	mov    %edx,(%eax)
      lcr3(V2P(p_page->pgdir));
80102c83:	8b 47 08             	mov    0x8(%edi),%eax
80102c86:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80102c8b:	0f 22 d8             	mov    %eax,%cr3
      page_lru_head = page_lru_head->prev;
80102c8e:	a1 a4 46 11 80       	mov    0x801146a4,%eax
  {
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
  }
  else // set
  {
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] | (1 << bitmap_offset % 8);
80102c93:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      page_lru_head = page_lru_head->prev;
80102c96:	8b 48 04             	mov    0x4(%eax),%ecx
80102c99:	89 0d a4 46 11 80    	mov    %ecx,0x801146a4
      page_lru_head->next = p_page->next;
80102c9f:	8b 07                	mov    (%edi),%eax
80102ca1:	89 01                	mov    %eax,(%ecx)
      p_page->next->prev = page_lru_head;
80102ca3:	8b 0d a4 46 11 80    	mov    0x801146a4,%ecx
80102ca9:	89 48 04             	mov    %ecx,0x4(%eax)
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] | (1 << bitmap_offset % 8);
80102cac:	89 f0                	mov    %esi,%eax
80102cae:	83 e6 07             	and    $0x7,%esi
80102cb1:	89 f1                	mov    %esi,%ecx
80102cb3:	be 01 00 00 00       	mov    $0x1,%esi
80102cb8:	c1 f8 03             	sar    $0x3,%eax
      kfree(mem);
80102cbb:	89 1c 24             	mov    %ebx,(%esp)
      kmem.use_lock = 0;
80102cbe:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102cc5:	00 00 00 
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] | (1 << bitmap_offset % 8);
80102cc8:	d3 e6                	shl    %cl,%esi
80102cca:	89 f1                	mov    %esi,%ecx
80102ccc:	08 88 a0 36 11 80    	or     %cl,-0x7feec960(%eax)
      kfree(mem);
80102cd2:	e8 a9 f8 ff ff       	call   80102580 <kfree>
      num_lru_pages--;
80102cd7:	83 2d a0 46 11 80 01 	subl   $0x1,0x801146a0
}
80102cde:	89 d8                	mov    %ebx,%eax
      kmem.use_lock = 1;
80102ce0:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
80102ce7:	00 00 00 
      p_page->use = 0;
80102cea:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
}
80102cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cf4:	5b                   	pop    %ebx
80102cf5:	5e                   	pop    %esi
80102cf6:	5f                   	pop    %edi
80102cf7:	5d                   	pop    %ebp
80102cf8:	c3                   	ret    
        cprintf("Swapout victim page | pgdir : %x,vaddr : 0000, PTE : %x, Modified PTE : %x\n", p_page->pgdir, *pte, (((bitmap_offset << 12) | PTE_FLAGS(*pte)) & (~PTE_P)));
80102cf9:	ff 75 e0             	pushl  -0x20(%ebp)
80102cfc:	53                   	push   %ebx
80102cfd:	51                   	push   %ecx
80102cfe:	68 f0 81 10 80       	push   $0x801081f0
80102d03:	e8 a8 d9 ff ff       	call   801006b0 <cprintf>
80102d08:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d0b:	83 c4 10             	add    $0x10,%esp
80102d0e:	e9 46 ff ff ff       	jmp    80102c59 <swapout+0xf9>
  cprintf("================swap out err================\n");
80102d13:	83 ec 0c             	sub    $0xc,%esp
80102d16:	68 9c 81 10 80       	push   $0x8010819c
80102d1b:	e8 90 d9 ff ff       	call   801006b0 <cprintf>
  lru_print();
80102d20:	e8 fb fa ff ff       	call   80102820 <lru_print>
  panic("swap out err not found zero page");
80102d25:	c7 04 24 cc 81 10 80 	movl   $0x801081cc,(%esp)
80102d2c:	e8 5f d6 ff ff       	call   80100390 <panic>
    panic("OOM Error");
80102d31:	83 ec 0c             	sub    $0xc,%esp
80102d34:	68 7c 7e 10 80       	push   $0x80107e7c
80102d39:	e8 52 d6 ff ff       	call   80100390 <panic>
80102d3e:	66 90                	xchg   %ax,%ax

80102d40 <kalloc>:
{
80102d40:	f3 0f 1e fb          	endbr32 
80102d44:	55                   	push   %ebp
80102d45:	89 e5                	mov    %esp,%ebp
80102d47:	83 ec 18             	sub    $0x18,%esp
  if (kmem.use_lock)
80102d4a:	a1 94 36 11 80       	mov    0x80113694,%eax
80102d4f:	85 c0                	test   %eax,%eax
80102d51:	75 65                	jne    80102db8 <kalloc+0x78>
  r = kmem.freelist;
80102d53:	a1 98 36 11 80       	mov    0x80113698,%eax
  if (r)
80102d58:	85 c0                	test   %eax,%eax
80102d5a:	74 2e                	je     80102d8a <kalloc+0x4a>
    kmem.freelist = r->next;
80102d5c:	8b 10                	mov    (%eax),%edx
  num_free_pages--;
80102d5e:	83 2d a8 46 11 80 01 	subl   $0x1,0x801146a8
    kmem.freelist = r->next;
80102d65:	89 15 98 36 11 80    	mov    %edx,0x80113698
}
80102d6b:	c9                   	leave  
80102d6c:	c3                   	ret    
80102d6d:	8d 76 00             	lea    0x0(%esi),%esi
    if (kmem.use_lock)
80102d70:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx
80102d76:	85 c9                	test   %ecx,%ecx
80102d78:	74 10                	je     80102d8a <kalloc+0x4a>
      release(&kmem.lock);
80102d7a:	83 ec 0c             	sub    $0xc,%esp
80102d7d:	68 60 36 11 80       	push   $0x80113660
80102d82:	e8 79 21 00 00       	call   80104f00 <release>
80102d87:	83 c4 10             	add    $0x10,%esp
    cprintf("No free physical page -> ");
80102d8a:	83 ec 0c             	sub    $0xc,%esp
80102d8d:	68 86 7e 10 80       	push   $0x80107e86
80102d92:	e8 19 d9 ff ff       	call   801006b0 <cprintf>
    r = (struct run *)swapout();
80102d97:	e8 c4 fd ff ff       	call   80102b60 <swapout>
    if (kmem.use_lock)
80102d9c:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102da2:	83 c4 10             	add    $0x10,%esp
80102da5:	85 d2                	test   %edx,%edx
80102da7:	75 5f                	jne    80102e08 <kalloc+0xc8>
  num_free_pages--;
80102da9:	83 2d a8 46 11 80 01 	subl   $0x1,0x801146a8
}
80102db0:	c9                   	leave  
80102db1:	c3                   	ret    
80102db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102db8:	83 ec 0c             	sub    $0xc,%esp
80102dbb:	68 60 36 11 80       	push   $0x80113660
80102dc0:	e8 7b 20 00 00       	call   80104e40 <acquire>
  r = kmem.freelist;
80102dc5:	a1 98 36 11 80       	mov    0x80113698,%eax
  if (r)
80102dca:	83 c4 10             	add    $0x10,%esp
80102dcd:	85 c0                	test   %eax,%eax
80102dcf:	74 9f                	je     80102d70 <kalloc+0x30>
    kmem.freelist = r->next;
80102dd1:	8b 08                	mov    (%eax),%ecx
80102dd3:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102dd9:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  num_free_pages--;
80102ddf:	83 2d a8 46 11 80 01 	subl   $0x1,0x801146a8
  if (kmem.use_lock)
80102de6:	85 d2                	test   %edx,%edx
80102de8:	74 81                	je     80102d6b <kalloc+0x2b>
    release(&kmem.lock);
80102dea:	83 ec 0c             	sub    $0xc,%esp
80102ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102df0:	68 60 36 11 80       	push   $0x80113660
80102df5:	e8 06 21 00 00       	call   80104f00 <release>
  return (char *)r;
80102dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102dfd:	83 c4 10             	add    $0x10,%esp
}
80102e00:	c9                   	leave  
80102e01:	c3                   	ret    
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&kmem.lock);
80102e08:	83 ec 0c             	sub    $0xc,%esp
80102e0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102e0e:	68 60 36 11 80       	push   $0x80113660
80102e13:	e8 28 20 00 00       	call   80104e40 <acquire>
80102e18:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	eb b9                	jmp    80102ddf <kalloc+0x9f>
80102e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e2d:	8d 76 00             	lea    0x0(%esi),%esi

80102e30 <bitmap_modify>:
{
80102e30:	f3 0f 1e fb          	endbr32 
80102e34:	55                   	push   %ebp
80102e35:	89 e5                	mov    %esp,%ebp
80102e37:	53                   	push   %ebx
80102e38:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102e3b:	85 c9                	test   %ecx,%ecx
80102e3d:	8d 41 07             	lea    0x7(%ecx),%eax
80102e40:	89 cb                	mov    %ecx,%ebx
80102e42:	0f 49 c1             	cmovns %ecx,%eax
80102e45:	c1 fb 1f             	sar    $0x1f,%ebx
80102e48:	c1 eb 1d             	shr    $0x1d,%ebx
80102e4b:	01 d9                	add    %ebx,%ecx
80102e4d:	c1 f8 03             	sar    $0x3,%eax
80102e50:	83 e1 07             	and    $0x7,%ecx
80102e53:	0f b6 90 a0 36 11 80 	movzbl -0x7feec960(%eax),%edx
80102e5a:	29 d9                	sub    %ebx,%ecx
80102e5c:	bb 01 00 00 00       	mov    $0x1,%ebx
80102e61:	d3 e3                	shl    %cl,%ebx
80102e63:	89 d9                	mov    %ebx,%ecx
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102e65:	89 d3                	mov    %edx,%ebx
80102e67:	09 cb                	or     %ecx,%ebx
80102e69:	f7 d1                	not    %ecx
80102e6b:	21 ca                	and    %ecx,%edx
80102e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102e70:	85 c9                	test   %ecx,%ecx
80102e72:	0f 45 d3             	cmovne %ebx,%edx
  }
  // cprintf("================bitmap modify end================\n");
}
80102e75:	5b                   	pop    %ebx
80102e76:	5d                   	pop    %ebp
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102e77:	88 90 a0 36 11 80    	mov    %dl,-0x7feec960(%eax)
}
80102e7d:	c3                   	ret    
80102e7e:	66 90                	xchg   %ax,%ax

80102e80 <page_fault_handler>:

int page_fault_handler(pde_t *pgdir, uint vaddr)
{
80102e80:	f3 0f 1e fb          	endbr32 
80102e84:	55                   	push   %ebp
80102e85:	89 e5                	mov    %esp,%ebp
80102e87:	57                   	push   %edi
80102e88:	56                   	push   %esi
80102e89:	53                   	push   %ebx
80102e8a:	83 ec 24             	sub    $0x24,%esp
80102e8d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *mem;
  pte_t *pte;
  int bitmap_offset;

  // PTE check
  cprintf("Page Fault Occur at %x -> ", vaddr);
80102e90:	56                   	push   %esi
80102e91:	68 a0 7e 10 80       	push   $0x80107ea0
80102e96:	e8 15 d8 ff ff       	call   801006b0 <cprintf>
  pte = walkpgdir(pgdir, (void *)vaddr, 0);
80102e9b:	83 c4 0c             	add    $0xc,%esp
80102e9e:	6a 00                	push   $0x0
80102ea0:	56                   	push   %esi
80102ea1:	ff 75 08             	pushl  0x8(%ebp)
80102ea4:	e8 c7 43 00 00       	call   80107270 <walkpgdir>
  if ((*pte != 0) && ((*pte & PTE_P) == 0)) // page-fault occur where swapped out page
80102ea9:	83 c4 10             	add    $0x10,%esp
  pte = walkpgdir(pgdir, (void *)vaddr, 0);
80102eac:	89 c3                	mov    %eax,%ebx
  if ((*pte != 0) && ((*pte & PTE_P) == 0)) // page-fault occur where swapped out page
80102eae:	8b 00                	mov    (%eax),%eax
80102eb0:	85 c0                	test   %eax,%eax
80102eb2:	74 04                	je     80102eb8 <page_fault_handler+0x38>
80102eb4:	a8 01                	test   $0x1,%al
80102eb6:	74 28                	je     80102ee0 <page_fault_handler+0x60>
    bitmap_modify(bitmap_offset, 0);
    // cprintf("================Page fault(swappable) end================\n");
  }
  else // page fault occur not exist
  {
    cprintf("================Page fault(non swappable) start================\n");
80102eb8:	83 ec 0c             	sub    $0xc,%esp
80102ebb:	68 ac 82 10 80       	push   $0x801082ac
80102ec0:	e8 eb d7 ff ff       	call   801006b0 <cprintf>
    // generate page table
    pte = walkpgdir(pgdir, (void *)vaddr, 1);
    // mapping physical page with virtual page
    mappages(pgdir, vaddr, PGSIZE, V2P(mem), PTE_P | PTE_W | PTE_U);
    */
    cprintf("================Page fault(non swappable) end================\n");
80102ec5:	c7 04 24 f0 82 10 80 	movl   $0x801082f0,(%esp)
80102ecc:	e8 df d7 ff ff       	call   801006b0 <cprintf>
80102ed1:	83 c4 10             	add    $0x10,%esp
  }
  // cprintf("================Page fault end================\n");

  return 0;
80102ed4:	31 c0                	xor    %eax,%eax
80102ed6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ed9:	5b                   	pop    %ebx
80102eda:	5e                   	pop    %esi
80102edb:	5f                   	pop    %edi
80102edc:	5d                   	pop    %ebp
80102edd:	c3                   	ret    
80102ede:	66 90                	xchg   %ax,%ax
    cprintf("Mem alloc -> ");
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 bb 7e 10 80       	push   $0x80107ebb
80102ee8:	e8 c3 d7 ff ff       	call   801006b0 <cprintf>
    mem = kalloc();
80102eed:	e8 4e fe ff ff       	call   80102d40 <kalloc>
    if (mem == 0)
80102ef2:	83 c4 10             	add    $0x10,%esp
    mem = kalloc();
80102ef5:	89 c7                	mov    %eax,%edi
    if (mem == 0)
80102ef7:	85 c0                	test   %eax,%eax
80102ef9:	74 72                	je     80102f6d <page_fault_handler+0xed>
    memset(mem, 0, PGSIZE);
80102efb:	83 ec 04             	sub    $0x4,%esp
80102efe:	68 00 10 00 00       	push   $0x1000
80102f03:	6a 00                	push   $0x0
80102f05:	50                   	push   %eax
80102f06:	e8 45 20 00 00       	call   80104f50 <memset>
    bitmap_offset = (PTE_ADDR(*pte)) >> 12;
80102f0b:	8b 03                	mov    (%ebx),%eax
    swapread(mem, bitmap_offset);
80102f0d:	5a                   	pop    %edx
80102f0e:	59                   	pop    %ecx
    bitmap_offset = (PTE_ADDR(*pte)) >> 12;
80102f0f:	c1 e8 0c             	shr    $0xc,%eax
    swapread(mem, bitmap_offset);
80102f12:	50                   	push   %eax
80102f13:	57                   	push   %edi
80102f14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102f17:	e8 54 f1 ff ff       	call   80102070 <swapread>
    cprintf("Swap read -> ");
80102f1c:	c7 04 24 c9 7e 10 80 	movl   $0x80107ec9,(%esp)
80102f23:	e8 88 d7 ff ff       	call   801006b0 <cprintf>
    *pte = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
80102f28:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80102f2e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80102f34:	83 ca 07             	or     $0x7,%edx
80102f37:	89 13                	mov    %edx,(%ebx)
    page_insert(pgdir, vaddr);
80102f39:	5b                   	pop    %ebx
80102f3a:	5f                   	pop    %edi
80102f3b:	56                   	push   %esi
80102f3c:	ff 75 08             	pushl  0x8(%ebp)
80102f3f:	e8 7c f9 ff ff       	call   801028c0 <page_insert>
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
80102f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102f47:	83 c4 10             	add    $0x10,%esp
80102f4a:	89 c2                	mov    %eax,%edx
80102f4c:	83 e0 07             	and    $0x7,%eax
80102f4f:	89 c1                	mov    %eax,%ecx
80102f51:	b8 01 00 00 00       	mov    $0x1,%eax
80102f56:	c1 fa 03             	sar    $0x3,%edx
80102f59:	d3 e0                	shl    %cl,%eax
80102f5b:	f7 d0                	not    %eax
80102f5d:	20 82 a0 36 11 80    	and    %al,-0x7feec960(%edx)
80102f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102f66:	31 c0                	xor    %eax,%eax
80102f68:	5b                   	pop    %ebx
80102f69:	5e                   	pop    %esi
80102f6a:	5f                   	pop    %edi
80102f6b:	5d                   	pop    %ebp
80102f6c:	c3                   	ret    
      cprintf("page fault allocate out of memory\n");
80102f6d:	83 ec 0c             	sub    $0xc,%esp
80102f70:	68 88 82 10 80       	push   $0x80108288
80102f75:	e8 36 d7 ff ff       	call   801006b0 <cprintf>
      return -1;
80102f7a:	83 c4 10             	add    $0x10,%esp
80102f7d:	83 c8 ff             	or     $0xffffffff,%eax
80102f80:	e9 51 ff ff ff       	jmp    80102ed6 <page_fault_handler+0x56>
80102f85:	66 90                	xchg   %ax,%ax
80102f87:	66 90                	xchg   %ax,%ax
80102f89:	66 90                	xchg   %ax,%ax
80102f8b:	66 90                	xchg   %ax,%ax
80102f8d:	66 90                	xchg   %ax,%ax
80102f8f:	90                   	nop

80102f90 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102f90:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f94:	ba 64 00 00 00       	mov    $0x64,%edx
80102f99:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102f9a:	a8 01                	test   $0x1,%al
80102f9c:	0f 84 be 00 00 00    	je     80103060 <kbdgetc+0xd0>
{
80102fa2:	55                   	push   %ebp
80102fa3:	ba 60 00 00 00       	mov    $0x60,%edx
80102fa8:	89 e5                	mov    %esp,%ebp
80102faa:	53                   	push   %ebx
80102fab:	ec                   	in     (%dx),%al
  return data;
80102fac:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102fb2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102fb5:	3c e0                	cmp    $0xe0,%al
80102fb7:	74 57                	je     80103010 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102fb9:	89 d9                	mov    %ebx,%ecx
80102fbb:	83 e1 40             	and    $0x40,%ecx
80102fbe:	84 c0                	test   %al,%al
80102fc0:	78 5e                	js     80103020 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102fc2:	85 c9                	test   %ecx,%ecx
80102fc4:	74 09                	je     80102fcf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102fc6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102fc9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102fcc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102fcf:	0f b6 8a 60 84 10 80 	movzbl -0x7fef7ba0(%edx),%ecx
  shift ^= togglecode[data];
80102fd6:	0f b6 82 60 83 10 80 	movzbl -0x7fef7ca0(%edx),%eax
  shift |= shiftcode[data];
80102fdd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102fdf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102fe1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102fe3:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102fe9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102fec:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102fef:	8b 04 85 40 83 10 80 	mov    -0x7fef7cc0(,%eax,4),%eax
80102ff6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102ffa:	74 0b                	je     80103007 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102ffc:	8d 50 9f             	lea    -0x61(%eax),%edx
80102fff:	83 fa 19             	cmp    $0x19,%edx
80103002:	77 44                	ja     80103048 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103004:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103007:	5b                   	pop    %ebx
80103008:	5d                   	pop    %ebp
80103009:	c3                   	ret    
8010300a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80103010:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103013:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103015:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010301b:	5b                   	pop    %ebx
8010301c:	5d                   	pop    %ebp
8010301d:	c3                   	ret    
8010301e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80103020:	83 e0 7f             	and    $0x7f,%eax
80103023:	85 c9                	test   %ecx,%ecx
80103025:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80103028:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010302a:	0f b6 8a 60 84 10 80 	movzbl -0x7fef7ba0(%edx),%ecx
80103031:	83 c9 40             	or     $0x40,%ecx
80103034:	0f b6 c9             	movzbl %cl,%ecx
80103037:	f7 d1                	not    %ecx
80103039:	21 d9                	and    %ebx,%ecx
}
8010303b:	5b                   	pop    %ebx
8010303c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010303d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80103043:	c3                   	ret    
80103044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80103048:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010304b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010304e:	5b                   	pop    %ebx
8010304f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80103050:	83 f9 1a             	cmp    $0x1a,%ecx
80103053:	0f 42 c2             	cmovb  %edx,%eax
}
80103056:	c3                   	ret    
80103057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010305e:	66 90                	xchg   %ax,%ax
    return -1;
80103060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103065:	c3                   	ret    
80103066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010306d:	8d 76 00             	lea    0x0(%esi),%esi

80103070 <kbdintr>:

void
kbdintr(void)
{
80103070:	f3 0f 1e fb          	endbr32 
80103074:	55                   	push   %ebp
80103075:	89 e5                	mov    %esp,%ebp
80103077:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010307a:	68 90 2f 10 80       	push   $0x80102f90
8010307f:	e8 dc d7 ff ff       	call   80100860 <consoleintr>
}
80103084:	83 c4 10             	add    $0x10,%esp
80103087:	c9                   	leave  
80103088:	c3                   	ret    
80103089:	66 90                	xchg   %ax,%ax
8010308b:	66 90                	xchg   %ax,%ax
8010308d:	66 90                	xchg   %ax,%ax
8010308f:	90                   	nop

80103090 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80103090:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80103094:	a1 c0 96 11 80       	mov    0x801196c0,%eax
80103099:	85 c0                	test   %eax,%eax
8010309b:	0f 84 c7 00 00 00    	je     80103168 <lapicinit+0xd8>
  lapic[index] = value;
801030a1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801030a8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030ae:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801030b5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030b8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030bb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801030c2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801030c5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030c8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801030cf:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801030d2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030d5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801030dc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030df:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030e2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801030e9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030ec:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801030ef:	8b 50 30             	mov    0x30(%eax),%edx
801030f2:	c1 ea 10             	shr    $0x10,%edx
801030f5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801030fb:	75 73                	jne    80103170 <lapicinit+0xe0>
  lapic[index] = value;
801030fd:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103104:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103107:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010310a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103111:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103114:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103117:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010311e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103121:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103124:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010312b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010312e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103131:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103138:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010313b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010313e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103145:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103148:	8b 50 20             	mov    0x20(%eax),%edx
8010314b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103150:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103156:	80 e6 10             	and    $0x10,%dh
80103159:	75 f5                	jne    80103150 <lapicinit+0xc0>
  lapic[index] = value;
8010315b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103162:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103165:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103168:	c3                   	ret    
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103170:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103177:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010317a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010317d:	e9 7b ff ff ff       	jmp    801030fd <lapicinit+0x6d>
80103182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103190 <lapicid>:

int
lapicid(void)
{
80103190:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80103194:	a1 c0 96 11 80       	mov    0x801196c0,%eax
80103199:	85 c0                	test   %eax,%eax
8010319b:	74 0b                	je     801031a8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010319d:	8b 40 20             	mov    0x20(%eax),%eax
801031a0:	c1 e8 18             	shr    $0x18,%eax
801031a3:	c3                   	ret    
801031a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801031a8:	31 c0                	xor    %eax,%eax
}
801031aa:	c3                   	ret    
801031ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop

801031b0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801031b0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801031b4:	a1 c0 96 11 80       	mov    0x801196c0,%eax
801031b9:	85 c0                	test   %eax,%eax
801031bb:	74 0d                	je     801031ca <lapiceoi+0x1a>
  lapic[index] = value;
801031bd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801031c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031c7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801031ca:	c3                   	ret    
801031cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031cf:	90                   	nop

801031d0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801031d0:	f3 0f 1e fb          	endbr32 
}
801031d4:	c3                   	ret    
801031d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801031e0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801031e0:	f3 0f 1e fb          	endbr32 
801031e4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031e5:	b8 0f 00 00 00       	mov    $0xf,%eax
801031ea:	ba 70 00 00 00       	mov    $0x70,%edx
801031ef:	89 e5                	mov    %esp,%ebp
801031f1:	53                   	push   %ebx
801031f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801031f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801031f8:	ee                   	out    %al,(%dx)
801031f9:	b8 0a 00 00 00       	mov    $0xa,%eax
801031fe:	ba 71 00 00 00       	mov    $0x71,%edx
80103203:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103204:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103206:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103209:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010320f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103211:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103214:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103216:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103219:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010321c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103222:	a1 c0 96 11 80       	mov    0x801196c0,%eax
80103227:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010322d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103230:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103237:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010323a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010323d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103244:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103247:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010324a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103250:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103253:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103259:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010325c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103262:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103265:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010326b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010326c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010326f:	5d                   	pop    %ebp
80103270:	c3                   	ret    
80103271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010327f:	90                   	nop

80103280 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103280:	f3 0f 1e fb          	endbr32 
80103284:	55                   	push   %ebp
80103285:	b8 0b 00 00 00       	mov    $0xb,%eax
8010328a:	ba 70 00 00 00       	mov    $0x70,%edx
8010328f:	89 e5                	mov    %esp,%ebp
80103291:	57                   	push   %edi
80103292:	56                   	push   %esi
80103293:	53                   	push   %ebx
80103294:	83 ec 4c             	sub    $0x4c,%esp
80103297:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103298:	ba 71 00 00 00       	mov    $0x71,%edx
8010329d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010329e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032a1:	bb 70 00 00 00       	mov    $0x70,%ebx
801032a6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032b0:	31 c0                	xor    %eax,%eax
801032b2:	89 da                	mov    %ebx,%edx
801032b4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032b5:	b9 71 00 00 00       	mov    $0x71,%ecx
801032ba:	89 ca                	mov    %ecx,%edx
801032bc:	ec                   	in     (%dx),%al
801032bd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c0:	89 da                	mov    %ebx,%edx
801032c2:	b8 02 00 00 00       	mov    $0x2,%eax
801032c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032c8:	89 ca                	mov    %ecx,%edx
801032ca:	ec                   	in     (%dx),%al
801032cb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032ce:	89 da                	mov    %ebx,%edx
801032d0:	b8 04 00 00 00       	mov    $0x4,%eax
801032d5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032d6:	89 ca                	mov    %ecx,%edx
801032d8:	ec                   	in     (%dx),%al
801032d9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032dc:	89 da                	mov    %ebx,%edx
801032de:	b8 07 00 00 00       	mov    $0x7,%eax
801032e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032e4:	89 ca                	mov    %ecx,%edx
801032e6:	ec                   	in     (%dx),%al
801032e7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032ea:	89 da                	mov    %ebx,%edx
801032ec:	b8 08 00 00 00       	mov    $0x8,%eax
801032f1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032f2:	89 ca                	mov    %ecx,%edx
801032f4:	ec                   	in     (%dx),%al
801032f5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032f7:	89 da                	mov    %ebx,%edx
801032f9:	b8 09 00 00 00       	mov    $0x9,%eax
801032fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032ff:	89 ca                	mov    %ecx,%edx
80103301:	ec                   	in     (%dx),%al
80103302:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103304:	89 da                	mov    %ebx,%edx
80103306:	b8 0a 00 00 00       	mov    $0xa,%eax
8010330b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010330c:	89 ca                	mov    %ecx,%edx
8010330e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010330f:	84 c0                	test   %al,%al
80103311:	78 9d                	js     801032b0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103313:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103317:	89 fa                	mov    %edi,%edx
80103319:	0f b6 fa             	movzbl %dl,%edi
8010331c:	89 f2                	mov    %esi,%edx
8010331e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103321:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103325:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103328:	89 da                	mov    %ebx,%edx
8010332a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010332d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103330:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103334:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103337:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010333a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010333e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103341:	31 c0                	xor    %eax,%eax
80103343:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103344:	89 ca                	mov    %ecx,%edx
80103346:	ec                   	in     (%dx),%al
80103347:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010334a:	89 da                	mov    %ebx,%edx
8010334c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010334f:	b8 02 00 00 00       	mov    $0x2,%eax
80103354:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103355:	89 ca                	mov    %ecx,%edx
80103357:	ec                   	in     (%dx),%al
80103358:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010335b:	89 da                	mov    %ebx,%edx
8010335d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103360:	b8 04 00 00 00       	mov    $0x4,%eax
80103365:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103366:	89 ca                	mov    %ecx,%edx
80103368:	ec                   	in     (%dx),%al
80103369:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336c:	89 da                	mov    %ebx,%edx
8010336e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103371:	b8 07 00 00 00       	mov    $0x7,%eax
80103376:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103377:	89 ca                	mov    %ecx,%edx
80103379:	ec                   	in     (%dx),%al
8010337a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010337d:	89 da                	mov    %ebx,%edx
8010337f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103382:	b8 08 00 00 00       	mov    $0x8,%eax
80103387:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103388:	89 ca                	mov    %ecx,%edx
8010338a:	ec                   	in     (%dx),%al
8010338b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010338e:	89 da                	mov    %ebx,%edx
80103390:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103393:	b8 09 00 00 00       	mov    $0x9,%eax
80103398:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103399:	89 ca                	mov    %ecx,%edx
8010339b:	ec                   	in     (%dx),%al
8010339c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010339f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801033a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801033a5:	8d 45 d0             	lea    -0x30(%ebp),%eax
801033a8:	6a 18                	push   $0x18
801033aa:	50                   	push   %eax
801033ab:	8d 45 b8             	lea    -0x48(%ebp),%eax
801033ae:	50                   	push   %eax
801033af:	e8 ec 1b 00 00       	call   80104fa0 <memcmp>
801033b4:	83 c4 10             	add    $0x10,%esp
801033b7:	85 c0                	test   %eax,%eax
801033b9:	0f 85 f1 fe ff ff    	jne    801032b0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801033bf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801033c3:	75 78                	jne    8010343d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801033c5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801033c8:	89 c2                	mov    %eax,%edx
801033ca:	83 e0 0f             	and    $0xf,%eax
801033cd:	c1 ea 04             	shr    $0x4,%edx
801033d0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033d3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033d6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801033d9:	8b 45 bc             	mov    -0x44(%ebp),%eax
801033dc:	89 c2                	mov    %eax,%edx
801033de:	83 e0 0f             	and    $0xf,%eax
801033e1:	c1 ea 04             	shr    $0x4,%edx
801033e4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033e7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033ea:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801033ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
801033f0:	89 c2                	mov    %eax,%edx
801033f2:	83 e0 0f             	and    $0xf,%eax
801033f5:	c1 ea 04             	shr    $0x4,%edx
801033f8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033fb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103401:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103404:	89 c2                	mov    %eax,%edx
80103406:	83 e0 0f             	and    $0xf,%eax
80103409:	c1 ea 04             	shr    $0x4,%edx
8010340c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010340f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103412:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103415:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103418:	89 c2                	mov    %eax,%edx
8010341a:	83 e0 0f             	and    $0xf,%eax
8010341d:	c1 ea 04             	shr    $0x4,%edx
80103420:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103423:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103426:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103429:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010342c:	89 c2                	mov    %eax,%edx
8010342e:	83 e0 0f             	and    $0xf,%eax
80103431:	c1 ea 04             	shr    $0x4,%edx
80103434:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103437:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010343a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010343d:	8b 75 08             	mov    0x8(%ebp),%esi
80103440:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103443:	89 06                	mov    %eax,(%esi)
80103445:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103448:	89 46 04             	mov    %eax,0x4(%esi)
8010344b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010344e:	89 46 08             	mov    %eax,0x8(%esi)
80103451:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103454:	89 46 0c             	mov    %eax,0xc(%esi)
80103457:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010345a:	89 46 10             	mov    %eax,0x10(%esi)
8010345d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103460:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103463:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010346a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010346d:	5b                   	pop    %ebx
8010346e:	5e                   	pop    %esi
8010346f:	5f                   	pop    %edi
80103470:	5d                   	pop    %ebp
80103471:	c3                   	ret    
80103472:	66 90                	xchg   %ax,%ax
80103474:	66 90                	xchg   %ax,%ax
80103476:	66 90                	xchg   %ax,%ax
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103480:	8b 0d 28 97 11 80    	mov    0x80119728,%ecx
80103486:	85 c9                	test   %ecx,%ecx
80103488:	0f 8e 8a 00 00 00    	jle    80103518 <install_trans+0x98>
{
8010348e:	55                   	push   %ebp
8010348f:	89 e5                	mov    %esp,%ebp
80103491:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103492:	31 ff                	xor    %edi,%edi
{
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 0c             	sub    $0xc,%esp
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801034a0:	a1 14 97 11 80       	mov    0x80119714,%eax
801034a5:	83 ec 08             	sub    $0x8,%esp
801034a8:	01 f8                	add    %edi,%eax
801034aa:	83 c0 01             	add    $0x1,%eax
801034ad:	50                   	push   %eax
801034ae:	ff 35 24 97 11 80    	pushl  0x80119724
801034b4:	e8 17 cc ff ff       	call   801000d0 <bread>
801034b9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801034bb:	58                   	pop    %eax
801034bc:	5a                   	pop    %edx
801034bd:	ff 34 bd 2c 97 11 80 	pushl  -0x7fee68d4(,%edi,4)
801034c4:	ff 35 24 97 11 80    	pushl  0x80119724
  for (tail = 0; tail < log.lh.n; tail++) {
801034ca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801034cd:	e8 fe cb ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034d2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801034d5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034d7:	8d 46 5c             	lea    0x5c(%esi),%eax
801034da:	68 00 02 00 00       	push   $0x200
801034df:	50                   	push   %eax
801034e0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801034e3:	50                   	push   %eax
801034e4:	e8 07 1b 00 00       	call   80104ff0 <memmove>
    bwrite(dbuf);  // write dst to disk
801034e9:	89 1c 24             	mov    %ebx,(%esp)
801034ec:	e8 bf cc ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801034f1:	89 34 24             	mov    %esi,(%esp)
801034f4:	e8 f7 cc ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801034f9:	89 1c 24             	mov    %ebx,(%esp)
801034fc:	e8 ef cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103501:	83 c4 10             	add    $0x10,%esp
80103504:	39 3d 28 97 11 80    	cmp    %edi,0x80119728
8010350a:	7f 94                	jg     801034a0 <install_trans+0x20>
  }
}
8010350c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010350f:	5b                   	pop    %ebx
80103510:	5e                   	pop    %esi
80103511:	5f                   	pop    %edi
80103512:	5d                   	pop    %ebp
80103513:	c3                   	ret    
80103514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103518:	c3                   	ret    
80103519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103520 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	53                   	push   %ebx
80103524:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103527:	ff 35 14 97 11 80    	pushl  0x80119714
8010352d:	ff 35 24 97 11 80    	pushl  0x80119724
80103533:	e8 98 cb ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103538:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010353b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010353d:	a1 28 97 11 80       	mov    0x80119728,%eax
80103542:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103545:	85 c0                	test   %eax,%eax
80103547:	7e 19                	jle    80103562 <write_head+0x42>
80103549:	31 d2                	xor    %edx,%edx
8010354b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010354f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103550:	8b 0c 95 2c 97 11 80 	mov    -0x7fee68d4(,%edx,4),%ecx
80103557:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010355b:	83 c2 01             	add    $0x1,%edx
8010355e:	39 d0                	cmp    %edx,%eax
80103560:	75 ee                	jne    80103550 <write_head+0x30>
  }
  bwrite(buf);
80103562:	83 ec 0c             	sub    $0xc,%esp
80103565:	53                   	push   %ebx
80103566:	e8 45 cc ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010356b:	89 1c 24             	mov    %ebx,(%esp)
8010356e:	e8 7d cc ff ff       	call   801001f0 <brelse>
}
80103573:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103576:	83 c4 10             	add    $0x10,%esp
80103579:	c9                   	leave  
8010357a:	c3                   	ret    
8010357b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010357f:	90                   	nop

80103580 <initlog>:
{
80103580:	f3 0f 1e fb          	endbr32 
80103584:	55                   	push   %ebp
80103585:	89 e5                	mov    %esp,%ebp
80103587:	53                   	push   %ebx
80103588:	83 ec 2c             	sub    $0x2c,%esp
8010358b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010358e:	68 60 85 10 80       	push   $0x80108560
80103593:	68 e0 96 11 80       	push   $0x801196e0
80103598:	e8 23 17 00 00       	call   80104cc0 <initlock>
  readsb(dev, &sb);
8010359d:	58                   	pop    %eax
8010359e:	8d 45 dc             	lea    -0x24(%ebp),%eax
801035a1:	5a                   	pop    %edx
801035a2:	50                   	push   %eax
801035a3:	53                   	push   %ebx
801035a4:	e8 d7 de ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
801035a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801035ac:	59                   	pop    %ecx
  log.dev = dev;
801035ad:	89 1d 24 97 11 80    	mov    %ebx,0x80119724
  log.size = sb.nlog;
801035b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801035b6:	a3 14 97 11 80       	mov    %eax,0x80119714
  log.size = sb.nlog;
801035bb:	89 15 18 97 11 80    	mov    %edx,0x80119718
  struct buf *buf = bread(log.dev, log.start);
801035c1:	5a                   	pop    %edx
801035c2:	50                   	push   %eax
801035c3:	53                   	push   %ebx
801035c4:	e8 07 cb ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801035c9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801035cc:	8b 48 5c             	mov    0x5c(%eax),%ecx
801035cf:	89 0d 28 97 11 80    	mov    %ecx,0x80119728
  for (i = 0; i < log.lh.n; i++) {
801035d5:	85 c9                	test   %ecx,%ecx
801035d7:	7e 19                	jle    801035f2 <initlog+0x72>
801035d9:	31 d2                	xor    %edx,%edx
801035db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035df:	90                   	nop
    log.lh.block[i] = lh->block[i];
801035e0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801035e4:	89 1c 95 2c 97 11 80 	mov    %ebx,-0x7fee68d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801035eb:	83 c2 01             	add    $0x1,%edx
801035ee:	39 d1                	cmp    %edx,%ecx
801035f0:	75 ee                	jne    801035e0 <initlog+0x60>
  brelse(buf);
801035f2:	83 ec 0c             	sub    $0xc,%esp
801035f5:	50                   	push   %eax
801035f6:	e8 f5 cb ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801035fb:	e8 80 fe ff ff       	call   80103480 <install_trans>
  log.lh.n = 0;
80103600:	c7 05 28 97 11 80 00 	movl   $0x0,0x80119728
80103607:	00 00 00 
  write_head(); // clear the log
8010360a:	e8 11 ff ff ff       	call   80103520 <write_head>
}
8010360f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103612:	83 c4 10             	add    $0x10,%esp
80103615:	c9                   	leave  
80103616:	c3                   	ret    
80103617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010361e:	66 90                	xchg   %ax,%ax

80103620 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103620:	f3 0f 1e fb          	endbr32 
80103624:	55                   	push   %ebp
80103625:	89 e5                	mov    %esp,%ebp
80103627:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010362a:	68 e0 96 11 80       	push   $0x801196e0
8010362f:	e8 0c 18 00 00       	call   80104e40 <acquire>
80103634:	83 c4 10             	add    $0x10,%esp
80103637:	eb 1c                	jmp    80103655 <begin_op+0x35>
80103639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103640:	83 ec 08             	sub    $0x8,%esp
80103643:	68 e0 96 11 80       	push   $0x801196e0
80103648:	68 e0 96 11 80       	push   $0x801196e0
8010364d:	e8 ae 11 00 00       	call   80104800 <sleep>
80103652:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103655:	a1 20 97 11 80       	mov    0x80119720,%eax
8010365a:	85 c0                	test   %eax,%eax
8010365c:	75 e2                	jne    80103640 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010365e:	a1 1c 97 11 80       	mov    0x8011971c,%eax
80103663:	8b 15 28 97 11 80    	mov    0x80119728,%edx
80103669:	83 c0 01             	add    $0x1,%eax
8010366c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010366f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103672:	83 fa 1e             	cmp    $0x1e,%edx
80103675:	7f c9                	jg     80103640 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103677:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010367a:	a3 1c 97 11 80       	mov    %eax,0x8011971c
      release(&log.lock);
8010367f:	68 e0 96 11 80       	push   $0x801196e0
80103684:	e8 77 18 00 00       	call   80104f00 <release>
      break;
    }
  }
}
80103689:	83 c4 10             	add    $0x10,%esp
8010368c:	c9                   	leave  
8010368d:	c3                   	ret    
8010368e:	66 90                	xchg   %ax,%ax

80103690 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103690:	f3 0f 1e fb          	endbr32 
80103694:	55                   	push   %ebp
80103695:	89 e5                	mov    %esp,%ebp
80103697:	57                   	push   %edi
80103698:	56                   	push   %esi
80103699:	53                   	push   %ebx
8010369a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010369d:	68 e0 96 11 80       	push   $0x801196e0
801036a2:	e8 99 17 00 00       	call   80104e40 <acquire>
  log.outstanding -= 1;
801036a7:	a1 1c 97 11 80       	mov    0x8011971c,%eax
  if(log.committing)
801036ac:	8b 35 20 97 11 80    	mov    0x80119720,%esi
801036b2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801036b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801036b8:	89 1d 1c 97 11 80    	mov    %ebx,0x8011971c
  if(log.committing)
801036be:	85 f6                	test   %esi,%esi
801036c0:	0f 85 1e 01 00 00    	jne    801037e4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801036c6:	85 db                	test   %ebx,%ebx
801036c8:	0f 85 f2 00 00 00    	jne    801037c0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801036ce:	c7 05 20 97 11 80 01 	movl   $0x1,0x80119720
801036d5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801036d8:	83 ec 0c             	sub    $0xc,%esp
801036db:	68 e0 96 11 80       	push   $0x801196e0
801036e0:	e8 1b 18 00 00       	call   80104f00 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801036e5:	8b 0d 28 97 11 80    	mov    0x80119728,%ecx
801036eb:	83 c4 10             	add    $0x10,%esp
801036ee:	85 c9                	test   %ecx,%ecx
801036f0:	7f 3e                	jg     80103730 <end_op+0xa0>
    acquire(&log.lock);
801036f2:	83 ec 0c             	sub    $0xc,%esp
801036f5:	68 e0 96 11 80       	push   $0x801196e0
801036fa:	e8 41 17 00 00       	call   80104e40 <acquire>
    wakeup(&log);
801036ff:	c7 04 24 e0 96 11 80 	movl   $0x801196e0,(%esp)
    log.committing = 0;
80103706:	c7 05 20 97 11 80 00 	movl   $0x0,0x80119720
8010370d:	00 00 00 
    wakeup(&log);
80103710:	e8 ab 12 00 00       	call   801049c0 <wakeup>
    release(&log.lock);
80103715:	c7 04 24 e0 96 11 80 	movl   $0x801196e0,(%esp)
8010371c:	e8 df 17 00 00       	call   80104f00 <release>
80103721:	83 c4 10             	add    $0x10,%esp
}
80103724:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103727:	5b                   	pop    %ebx
80103728:	5e                   	pop    %esi
80103729:	5f                   	pop    %edi
8010372a:	5d                   	pop    %ebp
8010372b:	c3                   	ret    
8010372c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103730:	a1 14 97 11 80       	mov    0x80119714,%eax
80103735:	83 ec 08             	sub    $0x8,%esp
80103738:	01 d8                	add    %ebx,%eax
8010373a:	83 c0 01             	add    $0x1,%eax
8010373d:	50                   	push   %eax
8010373e:	ff 35 24 97 11 80    	pushl  0x80119724
80103744:	e8 87 c9 ff ff       	call   801000d0 <bread>
80103749:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010374b:	58                   	pop    %eax
8010374c:	5a                   	pop    %edx
8010374d:	ff 34 9d 2c 97 11 80 	pushl  -0x7fee68d4(,%ebx,4)
80103754:	ff 35 24 97 11 80    	pushl  0x80119724
  for (tail = 0; tail < log.lh.n; tail++) {
8010375a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010375d:	e8 6e c9 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103762:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103765:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103767:	8d 40 5c             	lea    0x5c(%eax),%eax
8010376a:	68 00 02 00 00       	push   $0x200
8010376f:	50                   	push   %eax
80103770:	8d 46 5c             	lea    0x5c(%esi),%eax
80103773:	50                   	push   %eax
80103774:	e8 77 18 00 00       	call   80104ff0 <memmove>
    bwrite(to);  // write the log
80103779:	89 34 24             	mov    %esi,(%esp)
8010377c:	e8 2f ca ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103781:	89 3c 24             	mov    %edi,(%esp)
80103784:	e8 67 ca ff ff       	call   801001f0 <brelse>
    brelse(to);
80103789:	89 34 24             	mov    %esi,(%esp)
8010378c:	e8 5f ca ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103791:	83 c4 10             	add    $0x10,%esp
80103794:	3b 1d 28 97 11 80    	cmp    0x80119728,%ebx
8010379a:	7c 94                	jl     80103730 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010379c:	e8 7f fd ff ff       	call   80103520 <write_head>
    install_trans(); // Now install writes to home locations
801037a1:	e8 da fc ff ff       	call   80103480 <install_trans>
    log.lh.n = 0;
801037a6:	c7 05 28 97 11 80 00 	movl   $0x0,0x80119728
801037ad:	00 00 00 
    write_head();    // Erase the transaction from the log
801037b0:	e8 6b fd ff ff       	call   80103520 <write_head>
801037b5:	e9 38 ff ff ff       	jmp    801036f2 <end_op+0x62>
801037ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	68 e0 96 11 80       	push   $0x801196e0
801037c8:	e8 f3 11 00 00       	call   801049c0 <wakeup>
  release(&log.lock);
801037cd:	c7 04 24 e0 96 11 80 	movl   $0x801196e0,(%esp)
801037d4:	e8 27 17 00 00       	call   80104f00 <release>
801037d9:	83 c4 10             	add    $0x10,%esp
}
801037dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037df:	5b                   	pop    %ebx
801037e0:	5e                   	pop    %esi
801037e1:	5f                   	pop    %edi
801037e2:	5d                   	pop    %ebp
801037e3:	c3                   	ret    
    panic("log.committing");
801037e4:	83 ec 0c             	sub    $0xc,%esp
801037e7:	68 64 85 10 80       	push   $0x80108564
801037ec:	e8 9f cb ff ff       	call   80100390 <panic>
801037f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037ff:	90                   	nop

80103800 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103800:	f3 0f 1e fb          	endbr32 
80103804:	55                   	push   %ebp
80103805:	89 e5                	mov    %esp,%ebp
80103807:	53                   	push   %ebx
80103808:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010380b:	8b 15 28 97 11 80    	mov    0x80119728,%edx
{
80103811:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103814:	83 fa 1d             	cmp    $0x1d,%edx
80103817:	0f 8f 91 00 00 00    	jg     801038ae <log_write+0xae>
8010381d:	a1 18 97 11 80       	mov    0x80119718,%eax
80103822:	83 e8 01             	sub    $0x1,%eax
80103825:	39 c2                	cmp    %eax,%edx
80103827:	0f 8d 81 00 00 00    	jge    801038ae <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010382d:	a1 1c 97 11 80       	mov    0x8011971c,%eax
80103832:	85 c0                	test   %eax,%eax
80103834:	0f 8e 81 00 00 00    	jle    801038bb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010383a:	83 ec 0c             	sub    $0xc,%esp
8010383d:	68 e0 96 11 80       	push   $0x801196e0
80103842:	e8 f9 15 00 00       	call   80104e40 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103847:	8b 15 28 97 11 80    	mov    0x80119728,%edx
8010384d:	83 c4 10             	add    $0x10,%esp
80103850:	85 d2                	test   %edx,%edx
80103852:	7e 4e                	jle    801038a2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103854:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103857:	31 c0                	xor    %eax,%eax
80103859:	eb 0c                	jmp    80103867 <log_write+0x67>
8010385b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010385f:	90                   	nop
80103860:	83 c0 01             	add    $0x1,%eax
80103863:	39 c2                	cmp    %eax,%edx
80103865:	74 29                	je     80103890 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103867:	39 0c 85 2c 97 11 80 	cmp    %ecx,-0x7fee68d4(,%eax,4)
8010386e:	75 f0                	jne    80103860 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103870:	89 0c 85 2c 97 11 80 	mov    %ecx,-0x7fee68d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103877:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010387a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010387d:	c7 45 08 e0 96 11 80 	movl   $0x801196e0,0x8(%ebp)
}
80103884:	c9                   	leave  
  release(&log.lock);
80103885:	e9 76 16 00 00       	jmp    80104f00 <release>
8010388a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103890:	89 0c 95 2c 97 11 80 	mov    %ecx,-0x7fee68d4(,%edx,4)
    log.lh.n++;
80103897:	83 c2 01             	add    $0x1,%edx
8010389a:	89 15 28 97 11 80    	mov    %edx,0x80119728
801038a0:	eb d5                	jmp    80103877 <log_write+0x77>
  log.lh.block[i] = b->blockno;
801038a2:	8b 43 08             	mov    0x8(%ebx),%eax
801038a5:	a3 2c 97 11 80       	mov    %eax,0x8011972c
  if (i == log.lh.n)
801038aa:	75 cb                	jne    80103877 <log_write+0x77>
801038ac:	eb e9                	jmp    80103897 <log_write+0x97>
    panic("too big a transaction");
801038ae:	83 ec 0c             	sub    $0xc,%esp
801038b1:	68 73 85 10 80       	push   $0x80108573
801038b6:	e8 d5 ca ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801038bb:	83 ec 0c             	sub    $0xc,%esp
801038be:	68 89 85 10 80       	push   $0x80108589
801038c3:	e8 c8 ca ff ff       	call   80100390 <panic>
801038c8:	66 90                	xchg   %ax,%ax
801038ca:	66 90                	xchg   %ax,%ax
801038cc:	66 90                	xchg   %ax,%ax
801038ce:	66 90                	xchg   %ax,%ax

801038d0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
801038d4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801038d7:	e8 54 09 00 00       	call   80104230 <cpuid>
801038dc:	89 c3                	mov    %eax,%ebx
801038de:	e8 4d 09 00 00       	call   80104230 <cpuid>
801038e3:	83 ec 04             	sub    $0x4,%esp
801038e6:	53                   	push   %ebx
801038e7:	50                   	push   %eax
801038e8:	68 a4 85 10 80       	push   $0x801085a4
801038ed:	e8 be cd ff ff       	call   801006b0 <cprintf>
  idtinit();                    // load idt register
801038f2:	e8 29 2a 00 00       	call   80106320 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801038f7:	e8 c4 08 00 00       	call   801041c0 <mycpu>
801038fc:	89 c2                	mov    %eax,%edx
  asm volatile("lock; xchgl %0, %1" :
801038fe:	b8 01 00 00 00       	mov    $0x1,%eax
80103903:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();                  // start running processes
8010390a:	e8 21 0c 00 00       	call   80104530 <scheduler>
8010390f:	90                   	nop

80103910 <mpenter>:
{
80103910:	f3 0f 1e fb          	endbr32 
80103914:	55                   	push   %ebp
80103915:	89 e5                	mov    %esp,%ebp
80103917:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010391a:	e8 61 3b 00 00       	call   80107480 <switchkvm>
  seginit();
8010391f:	e8 bc 38 00 00       	call   801071e0 <seginit>
  lapicinit();
80103924:	e8 67 f7 ff ff       	call   80103090 <lapicinit>
  mpmain();
80103929:	e8 a2 ff ff ff       	call   801038d0 <mpmain>
8010392e:	66 90                	xchg   %ax,%ax

80103930 <main>:
{
80103930:	f3 0f 1e fb          	endbr32 
80103934:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103938:	83 e4 f0             	and    $0xfffffff0,%esp
8010393b:	ff 71 fc             	pushl  -0x4(%ecx)
8010393e:	55                   	push   %ebp
8010393f:	89 e5                	mov    %esp,%ebp
80103941:	53                   	push   %ebx
80103942:	51                   	push   %ecx
  kinit1(end, P2V(4 * 1024 * 1024));          // phys page allocator
80103943:	83 ec 08             	sub    $0x8,%esp
80103946:	68 00 00 40 80       	push   $0x80400000
8010394b:	68 08 c5 11 80       	push   $0x8011c508
80103950:	e8 7b ed ff ff       	call   801026d0 <kinit1>
  kvmalloc();                                 // kernel page table
80103955:	e8 26 40 00 00       	call   80107980 <kvmalloc>
  mpinit();                                   // detect other processors
8010395a:	e8 81 01 00 00       	call   80103ae0 <mpinit>
  lapicinit();                                // interrupt controller
8010395f:	e8 2c f7 ff ff       	call   80103090 <lapicinit>
  seginit();                                  // segment descriptors
80103964:	e8 77 38 00 00       	call   801071e0 <seginit>
  picinit();                                  // disable pic
80103969:	e8 52 03 00 00       	call   80103cc0 <picinit>
  ioapicinit();                               // another interrupt controller
8010396e:	e8 1d eb ff ff       	call   80102490 <ioapicinit>
  consoleinit();                              // console hardware
80103973:	e8 b8 d0 ff ff       	call   80100a30 <consoleinit>
  uartinit();                                 // serial port
80103978:	e8 e3 2c 00 00       	call   80106660 <uartinit>
  pinit();                                    // process table
8010397d:	e8 1e 08 00 00       	call   801041a0 <pinit>
  tvinit();                                   // trap vectors
80103982:	e8 19 29 00 00       	call   801062a0 <tvinit>
  binit();                                    // buffer cache
80103987:	e8 b4 c6 ff ff       	call   80100040 <binit>
  fileinit();                                 // file table
8010398c:	e8 4f d4 ff ff       	call   80100de0 <fileinit>
  ideinit();                                  // disk
80103991:	e8 ca e8 ff ff       	call   80102260 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103996:	83 c4 0c             	add    $0xc,%esp
80103999:	68 8a 00 00 00       	push   $0x8a
8010399e:	68 8c b4 10 80       	push   $0x8010b48c
801039a3:	68 00 70 00 80       	push   $0x80007000
801039a8:	e8 43 16 00 00       	call   80104ff0 <memmove>

  for (c = cpus; c < cpus + ncpu; c++)
801039ad:	83 c4 10             	add    $0x10,%esp
801039b0:	69 05 60 9d 11 80 b0 	imul   $0xb0,0x80119d60,%eax
801039b7:	00 00 00 
801039ba:	05 e0 97 11 80       	add    $0x801197e0,%eax
801039bf:	3d e0 97 11 80       	cmp    $0x801197e0,%eax
801039c4:	76 7a                	jbe    80103a40 <main+0x110>
801039c6:	bb e0 97 11 80       	mov    $0x801197e0,%ebx
801039cb:	eb 1c                	jmp    801039e9 <main+0xb9>
801039cd:	8d 76 00             	lea    0x0(%esi),%esi
801039d0:	69 05 60 9d 11 80 b0 	imul   $0xb0,0x80119d60,%eax
801039d7:	00 00 00 
801039da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801039e0:	05 e0 97 11 80       	add    $0x801197e0,%eax
801039e5:	39 c3                	cmp    %eax,%ebx
801039e7:	73 57                	jae    80103a40 <main+0x110>
  {
    if (c == mycpu()) // We've started already.
801039e9:	e8 d2 07 00 00       	call   801041c0 <mycpu>
801039ee:	39 c3                	cmp    %eax,%ebx
801039f0:	74 de                	je     801039d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801039f2:	e8 49 f3 ff ff       	call   80102d40 <kalloc>
    *(void **)(code - 4) = stack + KSTACKSIZE;
    *(void (**)(void))(code - 8) = mpenter;
    *(int **)(code - 12) = (void *)V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801039f7:	83 ec 08             	sub    $0x8,%esp
    *(void (**)(void))(code - 8) = mpenter;
801039fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103910,0x80006ff8
80103a01:	39 10 80 
    *(int **)(code - 12) = (void *)V2P(entrypgdir);
80103a04:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103a0b:	a0 10 00 
    *(void **)(code - 4) = stack + KSTACKSIZE;
80103a0e:	05 00 10 00 00       	add    $0x1000,%eax
80103a13:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103a18:	0f b6 03             	movzbl (%ebx),%eax
80103a1b:	68 00 70 00 00       	push   $0x7000
80103a20:	50                   	push   %eax
80103a21:	e8 ba f7 ff ff       	call   801031e0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while (c->started == 0)
80103a26:	83 c4 10             	add    $0x10,%esp
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a30:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103a36:	85 c0                	test   %eax,%eax
80103a38:	74 f6                	je     80103a30 <main+0x100>
80103a3a:	eb 94                	jmp    801039d0 <main+0xa0>
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
80103a40:	83 ec 08             	sub    $0x8,%esp
80103a43:	68 00 00 40 80       	push   $0x80400000
80103a48:	68 00 00 40 80       	push   $0x80400000
80103a4d:	e8 4e ed ff ff       	call   801027a0 <kinit2>
  userinit();                                 // first user process
80103a52:	e8 29 08 00 00       	call   80104280 <userinit>
  mpmain();                                   // finish this processor's setup
80103a57:	e8 74 fe ff ff       	call   801038d0 <mpmain>
80103a5c:	66 90                	xchg   %ax,%ax
80103a5e:	66 90                	xchg   %ax,%ax

80103a60 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	57                   	push   %edi
80103a64:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103a65:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103a6b:	53                   	push   %ebx
  e = addr+len;
80103a6c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103a6f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103a72:	39 de                	cmp    %ebx,%esi
80103a74:	72 10                	jb     80103a86 <mpsearch1+0x26>
80103a76:	eb 50                	jmp    80103ac8 <mpsearch1+0x68>
80103a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a7f:	90                   	nop
80103a80:	89 fe                	mov    %edi,%esi
80103a82:	39 fb                	cmp    %edi,%ebx
80103a84:	76 42                	jbe    80103ac8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a86:	83 ec 04             	sub    $0x4,%esp
80103a89:	8d 7e 10             	lea    0x10(%esi),%edi
80103a8c:	6a 04                	push   $0x4
80103a8e:	68 b8 85 10 80       	push   $0x801085b8
80103a93:	56                   	push   %esi
80103a94:	e8 07 15 00 00       	call   80104fa0 <memcmp>
80103a99:	83 c4 10             	add    $0x10,%esp
80103a9c:	85 c0                	test   %eax,%eax
80103a9e:	75 e0                	jne    80103a80 <mpsearch1+0x20>
80103aa0:	89 f2                	mov    %esi,%edx
80103aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103aa8:	0f b6 0a             	movzbl (%edx),%ecx
80103aab:	83 c2 01             	add    $0x1,%edx
80103aae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103ab0:	39 fa                	cmp    %edi,%edx
80103ab2:	75 f4                	jne    80103aa8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ab4:	84 c0                	test   %al,%al
80103ab6:	75 c8                	jne    80103a80 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103abb:	89 f0                	mov    %esi,%eax
80103abd:	5b                   	pop    %ebx
80103abe:	5e                   	pop    %esi
80103abf:	5f                   	pop    %edi
80103ac0:	5d                   	pop    %ebp
80103ac1:	c3                   	ret    
80103ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ac8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103acb:	31 f6                	xor    %esi,%esi
}
80103acd:	5b                   	pop    %ebx
80103ace:	89 f0                	mov    %esi,%eax
80103ad0:	5e                   	pop    %esi
80103ad1:	5f                   	pop    %edi
80103ad2:	5d                   	pop    %ebp
80103ad3:	c3                   	ret    
80103ad4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103adf:	90                   	nop

80103ae0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103ae0:	f3 0f 1e fb          	endbr32 
80103ae4:	55                   	push   %ebp
80103ae5:	89 e5                	mov    %esp,%ebp
80103ae7:	57                   	push   %edi
80103ae8:	56                   	push   %esi
80103ae9:	53                   	push   %ebx
80103aea:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103aed:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103af4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103afb:	c1 e0 08             	shl    $0x8,%eax
80103afe:	09 d0                	or     %edx,%eax
80103b00:	c1 e0 04             	shl    $0x4,%eax
80103b03:	75 1b                	jne    80103b20 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b05:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103b0c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103b13:	c1 e0 08             	shl    $0x8,%eax
80103b16:	09 d0                	or     %edx,%eax
80103b18:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103b1b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103b20:	ba 00 04 00 00       	mov    $0x400,%edx
80103b25:	e8 36 ff ff ff       	call   80103a60 <mpsearch1>
80103b2a:	89 c6                	mov    %eax,%esi
80103b2c:	85 c0                	test   %eax,%eax
80103b2e:	0f 84 4c 01 00 00    	je     80103c80 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b34:	8b 5e 04             	mov    0x4(%esi),%ebx
80103b37:	85 db                	test   %ebx,%ebx
80103b39:	0f 84 61 01 00 00    	je     80103ca0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80103b3f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b42:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103b48:	6a 04                	push   $0x4
80103b4a:	68 bd 85 10 80       	push   $0x801085bd
80103b4f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b53:	e8 48 14 00 00       	call   80104fa0 <memcmp>
80103b58:	83 c4 10             	add    $0x10,%esp
80103b5b:	85 c0                	test   %eax,%eax
80103b5d:	0f 85 3d 01 00 00    	jne    80103ca0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103b63:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103b6a:	3c 01                	cmp    $0x1,%al
80103b6c:	74 08                	je     80103b76 <mpinit+0x96>
80103b6e:	3c 04                	cmp    $0x4,%al
80103b70:	0f 85 2a 01 00 00    	jne    80103ca0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103b76:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103b7d:	66 85 d2             	test   %dx,%dx
80103b80:	74 26                	je     80103ba8 <mpinit+0xc8>
80103b82:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103b85:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103b87:	31 d2                	xor    %edx,%edx
80103b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103b90:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103b97:	83 c0 01             	add    $0x1,%eax
80103b9a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103b9c:	39 f8                	cmp    %edi,%eax
80103b9e:	75 f0                	jne    80103b90 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103ba0:	84 d2                	test   %dl,%dl
80103ba2:	0f 85 f8 00 00 00    	jne    80103ca0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103ba8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103bae:	a3 c0 96 11 80       	mov    %eax,0x801196c0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bb3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103bb9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103bc0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bc5:	03 55 e4             	add    -0x1c(%ebp),%edx
80103bc8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bcf:	90                   	nop
80103bd0:	39 c2                	cmp    %eax,%edx
80103bd2:	76 15                	jbe    80103be9 <mpinit+0x109>
    switch(*p){
80103bd4:	0f b6 08             	movzbl (%eax),%ecx
80103bd7:	80 f9 02             	cmp    $0x2,%cl
80103bda:	74 5c                	je     80103c38 <mpinit+0x158>
80103bdc:	77 42                	ja     80103c20 <mpinit+0x140>
80103bde:	84 c9                	test   %cl,%cl
80103be0:	74 6e                	je     80103c50 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103be2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103be5:	39 c2                	cmp    %eax,%edx
80103be7:	77 eb                	ja     80103bd4 <mpinit+0xf4>
80103be9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103bec:	85 db                	test   %ebx,%ebx
80103bee:	0f 84 b9 00 00 00    	je     80103cad <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103bf4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103bf8:	74 15                	je     80103c0f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bfa:	b8 70 00 00 00       	mov    $0x70,%eax
80103bff:	ba 22 00 00 00       	mov    $0x22,%edx
80103c04:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c05:	ba 23 00 00 00       	mov    $0x23,%edx
80103c0a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103c0b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c0e:	ee                   	out    %al,(%dx)
  }
}
80103c0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c12:	5b                   	pop    %ebx
80103c13:	5e                   	pop    %esi
80103c14:	5f                   	pop    %edi
80103c15:	5d                   	pop    %ebp
80103c16:	c3                   	ret    
80103c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c1e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103c20:	83 e9 03             	sub    $0x3,%ecx
80103c23:	80 f9 01             	cmp    $0x1,%cl
80103c26:	76 ba                	jbe    80103be2 <mpinit+0x102>
80103c28:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103c2f:	eb 9f                	jmp    80103bd0 <mpinit+0xf0>
80103c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103c38:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103c3c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103c3f:	88 0d c0 97 11 80    	mov    %cl,0x801197c0
      continue;
80103c45:	eb 89                	jmp    80103bd0 <mpinit+0xf0>
80103c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c4e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103c50:	8b 0d 60 9d 11 80    	mov    0x80119d60,%ecx
80103c56:	83 f9 07             	cmp    $0x7,%ecx
80103c59:	7f 19                	jg     80103c74 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c5b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103c61:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103c65:	83 c1 01             	add    $0x1,%ecx
80103c68:	89 0d 60 9d 11 80    	mov    %ecx,0x80119d60
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c6e:	88 9f e0 97 11 80    	mov    %bl,-0x7fee6820(%edi)
      p += sizeof(struct mpproc);
80103c74:	83 c0 14             	add    $0x14,%eax
      continue;
80103c77:	e9 54 ff ff ff       	jmp    80103bd0 <mpinit+0xf0>
80103c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103c80:	ba 00 00 01 00       	mov    $0x10000,%edx
80103c85:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103c8a:	e8 d1 fd ff ff       	call   80103a60 <mpsearch1>
80103c8f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c91:	85 c0                	test   %eax,%eax
80103c93:	0f 85 9b fe ff ff    	jne    80103b34 <mpinit+0x54>
80103c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103ca0:	83 ec 0c             	sub    $0xc,%esp
80103ca3:	68 c2 85 10 80       	push   $0x801085c2
80103ca8:	e8 e3 c6 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103cad:	83 ec 0c             	sub    $0xc,%esp
80103cb0:	68 dc 85 10 80       	push   $0x801085dc
80103cb5:	e8 d6 c6 ff ff       	call   80100390 <panic>
80103cba:	66 90                	xchg   %ax,%ax
80103cbc:	66 90                	xchg   %ax,%ax
80103cbe:	66 90                	xchg   %ax,%ax

80103cc0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103cc0:	f3 0f 1e fb          	endbr32 
80103cc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cc9:	ba 21 00 00 00       	mov    $0x21,%edx
80103cce:	ee                   	out    %al,(%dx)
80103ccf:	ba a1 00 00 00       	mov    $0xa1,%edx
80103cd4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103cd5:	c3                   	ret    
80103cd6:	66 90                	xchg   %ax,%ax
80103cd8:	66 90                	xchg   %ax,%ax
80103cda:	66 90                	xchg   %ax,%ax
80103cdc:	66 90                	xchg   %ax,%ax
80103cde:	66 90                	xchg   %ax,%ax

80103ce0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103ce0:	f3 0f 1e fb          	endbr32 
80103ce4:	55                   	push   %ebp
80103ce5:	89 e5                	mov    %esp,%ebp
80103ce7:	57                   	push   %edi
80103ce8:	56                   	push   %esi
80103ce9:	53                   	push   %ebx
80103cea:	83 ec 0c             	sub    $0xc,%esp
80103ced:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103cf0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103cf3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103cf9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103cff:	e8 fc d0 ff ff       	call   80100e00 <filealloc>
80103d04:	89 03                	mov    %eax,(%ebx)
80103d06:	85 c0                	test   %eax,%eax
80103d08:	0f 84 ac 00 00 00    	je     80103dba <pipealloc+0xda>
80103d0e:	e8 ed d0 ff ff       	call   80100e00 <filealloc>
80103d13:	89 06                	mov    %eax,(%esi)
80103d15:	85 c0                	test   %eax,%eax
80103d17:	0f 84 8b 00 00 00    	je     80103da8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103d1d:	e8 1e f0 ff ff       	call   80102d40 <kalloc>
80103d22:	89 c7                	mov    %eax,%edi
80103d24:	85 c0                	test   %eax,%eax
80103d26:	0f 84 b4 00 00 00    	je     80103de0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103d2c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d33:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103d36:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103d39:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d40:	00 00 00 
  p->nwrite = 0;
80103d43:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d4a:	00 00 00 
  p->nread = 0;
80103d4d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d54:	00 00 00 
  initlock(&p->lock, "pipe");
80103d57:	68 fb 85 10 80       	push   $0x801085fb
80103d5c:	50                   	push   %eax
80103d5d:	e8 5e 0f 00 00       	call   80104cc0 <initlock>
  (*f0)->type = FD_PIPE;
80103d62:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103d64:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103d67:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d6d:	8b 03                	mov    (%ebx),%eax
80103d6f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d73:	8b 03                	mov    (%ebx),%eax
80103d75:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d79:	8b 03                	mov    (%ebx),%eax
80103d7b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d7e:	8b 06                	mov    (%esi),%eax
80103d80:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d86:	8b 06                	mov    (%esi),%eax
80103d88:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d8c:	8b 06                	mov    (%esi),%eax
80103d8e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d92:	8b 06                	mov    (%esi),%eax
80103d94:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103d9a:	31 c0                	xor    %eax,%eax
}
80103d9c:	5b                   	pop    %ebx
80103d9d:	5e                   	pop    %esi
80103d9e:	5f                   	pop    %edi
80103d9f:	5d                   	pop    %ebp
80103da0:	c3                   	ret    
80103da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103da8:	8b 03                	mov    (%ebx),%eax
80103daa:	85 c0                	test   %eax,%eax
80103dac:	74 1e                	je     80103dcc <pipealloc+0xec>
    fileclose(*f0);
80103dae:	83 ec 0c             	sub    $0xc,%esp
80103db1:	50                   	push   %eax
80103db2:	e8 09 d1 ff ff       	call   80100ec0 <fileclose>
80103db7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103dba:	8b 06                	mov    (%esi),%eax
80103dbc:	85 c0                	test   %eax,%eax
80103dbe:	74 0c                	je     80103dcc <pipealloc+0xec>
    fileclose(*f1);
80103dc0:	83 ec 0c             	sub    $0xc,%esp
80103dc3:	50                   	push   %eax
80103dc4:	e8 f7 d0 ff ff       	call   80100ec0 <fileclose>
80103dc9:	83 c4 10             	add    $0x10,%esp
}
80103dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103dcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103dd4:	5b                   	pop    %ebx
80103dd5:	5e                   	pop    %esi
80103dd6:	5f                   	pop    %edi
80103dd7:	5d                   	pop    %ebp
80103dd8:	c3                   	ret    
80103dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103de0:	8b 03                	mov    (%ebx),%eax
80103de2:	85 c0                	test   %eax,%eax
80103de4:	75 c8                	jne    80103dae <pipealloc+0xce>
80103de6:	eb d2                	jmp    80103dba <pipealloc+0xda>
80103de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103def:	90                   	nop

80103df0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103df0:	f3 0f 1e fb          	endbr32 
80103df4:	55                   	push   %ebp
80103df5:	89 e5                	mov    %esp,%ebp
80103df7:	56                   	push   %esi
80103df8:	53                   	push   %ebx
80103df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103dfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103dff:	83 ec 0c             	sub    $0xc,%esp
80103e02:	53                   	push   %ebx
80103e03:	e8 38 10 00 00       	call   80104e40 <acquire>
  if(writable){
80103e08:	83 c4 10             	add    $0x10,%esp
80103e0b:	85 f6                	test   %esi,%esi
80103e0d:	74 41                	je     80103e50 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103e0f:	83 ec 0c             	sub    $0xc,%esp
80103e12:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103e18:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103e1f:	00 00 00 
    wakeup(&p->nread);
80103e22:	50                   	push   %eax
80103e23:	e8 98 0b 00 00       	call   801049c0 <wakeup>
80103e28:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e2b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103e31:	85 d2                	test   %edx,%edx
80103e33:	75 0a                	jne    80103e3f <pipeclose+0x4f>
80103e35:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103e3b:	85 c0                	test   %eax,%eax
80103e3d:	74 31                	je     80103e70 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103e3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103e42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e45:	5b                   	pop    %ebx
80103e46:	5e                   	pop    %esi
80103e47:	5d                   	pop    %ebp
    release(&p->lock);
80103e48:	e9 b3 10 00 00       	jmp    80104f00 <release>
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103e50:	83 ec 0c             	sub    $0xc,%esp
80103e53:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103e59:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103e60:	00 00 00 
    wakeup(&p->nwrite);
80103e63:	50                   	push   %eax
80103e64:	e8 57 0b 00 00       	call   801049c0 <wakeup>
80103e69:	83 c4 10             	add    $0x10,%esp
80103e6c:	eb bd                	jmp    80103e2b <pipeclose+0x3b>
80103e6e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103e70:	83 ec 0c             	sub    $0xc,%esp
80103e73:	53                   	push   %ebx
80103e74:	e8 87 10 00 00       	call   80104f00 <release>
    kfree((char*)p);
80103e79:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103e7c:	83 c4 10             	add    $0x10,%esp
}
80103e7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e82:	5b                   	pop    %ebx
80103e83:	5e                   	pop    %esi
80103e84:	5d                   	pop    %ebp
    kfree((char*)p);
80103e85:	e9 f6 e6 ff ff       	jmp    80102580 <kfree>
80103e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e90 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e90:	f3 0f 1e fb          	endbr32 
80103e94:	55                   	push   %ebp
80103e95:	89 e5                	mov    %esp,%ebp
80103e97:	57                   	push   %edi
80103e98:	56                   	push   %esi
80103e99:	53                   	push   %ebx
80103e9a:	83 ec 28             	sub    $0x28,%esp
80103e9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103ea0:	53                   	push   %ebx
80103ea1:	e8 9a 0f 00 00       	call   80104e40 <acquire>
  for(i = 0; i < n; i++){
80103ea6:	8b 45 10             	mov    0x10(%ebp),%eax
80103ea9:	83 c4 10             	add    $0x10,%esp
80103eac:	85 c0                	test   %eax,%eax
80103eae:	0f 8e bc 00 00 00    	jle    80103f70 <pipewrite+0xe0>
80103eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103eb7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103ebd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103ec3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ec6:	03 45 10             	add    0x10(%ebp),%eax
80103ec9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ecc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ed2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ed8:	89 ca                	mov    %ecx,%edx
80103eda:	05 00 02 00 00       	add    $0x200,%eax
80103edf:	39 c1                	cmp    %eax,%ecx
80103ee1:	74 3b                	je     80103f1e <pipewrite+0x8e>
80103ee3:	eb 63                	jmp    80103f48 <pipewrite+0xb8>
80103ee5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103ee8:	e8 63 03 00 00       	call   80104250 <myproc>
80103eed:	8b 48 24             	mov    0x24(%eax),%ecx
80103ef0:	85 c9                	test   %ecx,%ecx
80103ef2:	75 34                	jne    80103f28 <pipewrite+0x98>
      wakeup(&p->nread);
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	57                   	push   %edi
80103ef8:	e8 c3 0a 00 00       	call   801049c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103efd:	58                   	pop    %eax
80103efe:	5a                   	pop    %edx
80103eff:	53                   	push   %ebx
80103f00:	56                   	push   %esi
80103f01:	e8 fa 08 00 00       	call   80104800 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f06:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103f0c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103f12:	83 c4 10             	add    $0x10,%esp
80103f15:	05 00 02 00 00       	add    $0x200,%eax
80103f1a:	39 c2                	cmp    %eax,%edx
80103f1c:	75 2a                	jne    80103f48 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103f1e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103f24:	85 c0                	test   %eax,%eax
80103f26:	75 c0                	jne    80103ee8 <pipewrite+0x58>
        release(&p->lock);
80103f28:	83 ec 0c             	sub    $0xc,%esp
80103f2b:	53                   	push   %ebx
80103f2c:	e8 cf 0f 00 00       	call   80104f00 <release>
        return -1;
80103f31:	83 c4 10             	add    $0x10,%esp
80103f34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103f39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f3c:	5b                   	pop    %ebx
80103f3d:	5e                   	pop    %esi
80103f3e:	5f                   	pop    %edi
80103f3f:	5d                   	pop    %ebp
80103f40:	c3                   	ret    
80103f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f48:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103f4b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103f4e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103f54:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103f5a:	0f b6 06             	movzbl (%esi),%eax
80103f5d:	83 c6 01             	add    $0x1,%esi
80103f60:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103f63:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103f67:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103f6a:	0f 85 5c ff ff ff    	jne    80103ecc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f70:	83 ec 0c             	sub    $0xc,%esp
80103f73:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103f79:	50                   	push   %eax
80103f7a:	e8 41 0a 00 00       	call   801049c0 <wakeup>
  release(&p->lock);
80103f7f:	89 1c 24             	mov    %ebx,(%esp)
80103f82:	e8 79 0f 00 00       	call   80104f00 <release>
  return n;
80103f87:	8b 45 10             	mov    0x10(%ebp),%eax
80103f8a:	83 c4 10             	add    $0x10,%esp
80103f8d:	eb aa                	jmp    80103f39 <pipewrite+0xa9>
80103f8f:	90                   	nop

80103f90 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f90:	f3 0f 1e fb          	endbr32 
80103f94:	55                   	push   %ebp
80103f95:	89 e5                	mov    %esp,%ebp
80103f97:	57                   	push   %edi
80103f98:	56                   	push   %esi
80103f99:	53                   	push   %ebx
80103f9a:	83 ec 18             	sub    $0x18,%esp
80103f9d:	8b 75 08             	mov    0x8(%ebp),%esi
80103fa0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103fa3:	56                   	push   %esi
80103fa4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103faa:	e8 91 0e 00 00       	call   80104e40 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103faf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103fb5:	83 c4 10             	add    $0x10,%esp
80103fb8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103fbe:	74 33                	je     80103ff3 <piperead+0x63>
80103fc0:	eb 3b                	jmp    80103ffd <piperead+0x6d>
80103fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103fc8:	e8 83 02 00 00       	call   80104250 <myproc>
80103fcd:	8b 48 24             	mov    0x24(%eax),%ecx
80103fd0:	85 c9                	test   %ecx,%ecx
80103fd2:	0f 85 88 00 00 00    	jne    80104060 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103fd8:	83 ec 08             	sub    $0x8,%esp
80103fdb:	56                   	push   %esi
80103fdc:	53                   	push   %ebx
80103fdd:	e8 1e 08 00 00       	call   80104800 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fe2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103fe8:	83 c4 10             	add    $0x10,%esp
80103feb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103ff1:	75 0a                	jne    80103ffd <piperead+0x6d>
80103ff3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103ff9:	85 c0                	test   %eax,%eax
80103ffb:	75 cb                	jne    80103fc8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ffd:	8b 55 10             	mov    0x10(%ebp),%edx
80104000:	31 db                	xor    %ebx,%ebx
80104002:	85 d2                	test   %edx,%edx
80104004:	7f 28                	jg     8010402e <piperead+0x9e>
80104006:	eb 34                	jmp    8010403c <piperead+0xac>
80104008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010400f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104010:	8d 48 01             	lea    0x1(%eax),%ecx
80104013:	25 ff 01 00 00       	and    $0x1ff,%eax
80104018:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010401e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104023:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104026:	83 c3 01             	add    $0x1,%ebx
80104029:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010402c:	74 0e                	je     8010403c <piperead+0xac>
    if(p->nread == p->nwrite)
8010402e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104034:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010403a:	75 d4                	jne    80104010 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010403c:	83 ec 0c             	sub    $0xc,%esp
8010403f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104045:	50                   	push   %eax
80104046:	e8 75 09 00 00       	call   801049c0 <wakeup>
  release(&p->lock);
8010404b:	89 34 24             	mov    %esi,(%esp)
8010404e:	e8 ad 0e 00 00       	call   80104f00 <release>
  return i;
80104053:	83 c4 10             	add    $0x10,%esp
}
80104056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104059:	89 d8                	mov    %ebx,%eax
8010405b:	5b                   	pop    %ebx
8010405c:	5e                   	pop    %esi
8010405d:	5f                   	pop    %edi
8010405e:	5d                   	pop    %ebp
8010405f:	c3                   	ret    
      release(&p->lock);
80104060:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104063:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104068:	56                   	push   %esi
80104069:	e8 92 0e 00 00       	call   80104f00 <release>
      return -1;
8010406e:	83 c4 10             	add    $0x10,%esp
}
80104071:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104074:	89 d8                	mov    %ebx,%eax
80104076:	5b                   	pop    %ebx
80104077:	5e                   	pop    %esi
80104078:	5f                   	pop    %edi
80104079:	5d                   	pop    %ebp
8010407a:	c3                   	ret    
8010407b:	66 90                	xchg   %ax,%ax
8010407d:	66 90                	xchg   %ax,%ax
8010407f:	90                   	nop

80104080 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104084:	bb b4 9d 11 80       	mov    $0x80119db4,%ebx
{
80104089:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010408c:	68 80 9d 11 80       	push   $0x80119d80
80104091:	e8 aa 0d 00 00       	call   80104e40 <acquire>
80104096:	83 c4 10             	add    $0x10,%esp
80104099:	eb 10                	jmp    801040ab <allocproc+0x2b>
8010409b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010409f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a0:	83 c3 7c             	add    $0x7c,%ebx
801040a3:	81 fb b4 bc 11 80    	cmp    $0x8011bcb4,%ebx
801040a9:	74 75                	je     80104120 <allocproc+0xa0>
    if (p->state == UNUSED)
801040ab:	8b 43 0c             	mov    0xc(%ebx),%eax
801040ae:	85 c0                	test   %eax,%eax
801040b0:	75 ee                	jne    801040a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801040b2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801040b7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801040ba:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801040c1:	89 43 10             	mov    %eax,0x10(%ebx)
801040c4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801040c7:	68 80 9d 11 80       	push   $0x80119d80
  p->pid = nextpid++;
801040cc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801040d2:	e8 29 0e 00 00       	call   80104f00 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
801040d7:	e8 64 ec ff ff       	call   80102d40 <kalloc>
801040dc:	83 c4 10             	add    $0x10,%esp
801040df:	89 43 08             	mov    %eax,0x8(%ebx)
801040e2:	85 c0                	test   %eax,%eax
801040e4:	74 53                	je     80104139 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801040e6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
801040ec:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801040ef:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801040f4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
801040f7:	c7 40 14 86 62 10 80 	movl   $0x80106286,0x14(%eax)
  p->context = (struct context *)sp;
801040fe:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104101:	6a 14                	push   $0x14
80104103:	6a 00                	push   $0x0
80104105:	50                   	push   %eax
80104106:	e8 45 0e 00 00       	call   80104f50 <memset>
  p->context->eip = (uint)forkret;
8010410b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010410e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104111:	c7 40 10 50 41 10 80 	movl   $0x80104150,0x10(%eax)
}
80104118:	89 d8                	mov    %ebx,%eax
8010411a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010411d:	c9                   	leave  
8010411e:	c3                   	ret    
8010411f:	90                   	nop
  release(&ptable.lock);
80104120:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104123:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104125:	68 80 9d 11 80       	push   $0x80119d80
8010412a:	e8 d1 0d 00 00       	call   80104f00 <release>
}
8010412f:	89 d8                	mov    %ebx,%eax
  return 0;
80104131:	83 c4 10             	add    $0x10,%esp
}
80104134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104137:	c9                   	leave  
80104138:	c3                   	ret    
    p->state = UNUSED;
80104139:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104140:	31 db                	xor    %ebx,%ebx
}
80104142:	89 d8                	mov    %ebx,%eax
80104144:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104147:	c9                   	leave  
80104148:	c3                   	ret    
80104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104150 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010415a:	68 80 9d 11 80       	push   $0x80119d80
8010415f:	e8 9c 0d 00 00       	call   80104f00 <release>

  if (first)
80104164:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104169:	83 c4 10             	add    $0x10,%esp
8010416c:	85 c0                	test   %eax,%eax
8010416e:	75 08                	jne    80104178 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104170:	c9                   	leave  
80104171:	c3                   	ret    
80104172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104178:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010417f:	00 00 00 
    iinit(ROOTDEV);
80104182:	83 ec 0c             	sub    $0xc,%esp
80104185:	6a 01                	push   $0x1
80104187:	e8 b4 d3 ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
8010418c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104193:	e8 e8 f3 ff ff       	call   80103580 <initlog>
}
80104198:	83 c4 10             	add    $0x10,%esp
8010419b:	c9                   	leave  
8010419c:	c3                   	ret    
8010419d:	8d 76 00             	lea    0x0(%esi),%esi

801041a0 <pinit>:
{
801041a0:	f3 0f 1e fb          	endbr32 
801041a4:	55                   	push   %ebp
801041a5:	89 e5                	mov    %esp,%ebp
801041a7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801041aa:	68 00 86 10 80       	push   $0x80108600
801041af:	68 80 9d 11 80       	push   $0x80119d80
801041b4:	e8 07 0b 00 00       	call   80104cc0 <initlock>
}
801041b9:	83 c4 10             	add    $0x10,%esp
801041bc:	c9                   	leave  
801041bd:	c3                   	ret    
801041be:	66 90                	xchg   %ax,%ax

801041c0 <mycpu>:
{
801041c0:	f3 0f 1e fb          	endbr32 
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	56                   	push   %esi
801041c8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041c9:	9c                   	pushf  
801041ca:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801041cb:	f6 c4 02             	test   $0x2,%ah
801041ce:	75 4a                	jne    8010421a <mycpu+0x5a>
  apicid = lapicid();
801041d0:	e8 bb ef ff ff       	call   80103190 <lapicid>
  for (i = 0; i < ncpu; ++i)
801041d5:	8b 35 60 9d 11 80    	mov    0x80119d60,%esi
  apicid = lapicid();
801041db:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i)
801041dd:	85 f6                	test   %esi,%esi
801041df:	7e 2c                	jle    8010420d <mycpu+0x4d>
801041e1:	31 d2                	xor    %edx,%edx
801041e3:	eb 0a                	jmp    801041ef <mycpu+0x2f>
801041e5:	8d 76 00             	lea    0x0(%esi),%esi
801041e8:	83 c2 01             	add    $0x1,%edx
801041eb:	39 f2                	cmp    %esi,%edx
801041ed:	74 1e                	je     8010420d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801041ef:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801041f5:	0f b6 81 e0 97 11 80 	movzbl -0x7fee6820(%ecx),%eax
801041fc:	39 d8                	cmp    %ebx,%eax
801041fe:	75 e8                	jne    801041e8 <mycpu+0x28>
}
80104200:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104203:	8d 81 e0 97 11 80    	lea    -0x7fee6820(%ecx),%eax
}
80104209:	5b                   	pop    %ebx
8010420a:	5e                   	pop    %esi
8010420b:	5d                   	pop    %ebp
8010420c:	c3                   	ret    
  panic("unknown apicid\n");
8010420d:	83 ec 0c             	sub    $0xc,%esp
80104210:	68 07 86 10 80       	push   $0x80108607
80104215:	e8 76 c1 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010421a:	83 ec 0c             	sub    $0xc,%esp
8010421d:	68 e0 86 10 80       	push   $0x801086e0
80104222:	e8 69 c1 ff ff       	call   80100390 <panic>
80104227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010422e:	66 90                	xchg   %ax,%ax

80104230 <cpuid>:
{
80104230:	f3 0f 1e fb          	endbr32 
80104234:	55                   	push   %ebp
80104235:	89 e5                	mov    %esp,%ebp
80104237:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
8010423a:	e8 81 ff ff ff       	call   801041c0 <mycpu>
}
8010423f:	c9                   	leave  
  return mycpu() - cpus;
80104240:	2d e0 97 11 80       	sub    $0x801197e0,%eax
80104245:	c1 f8 04             	sar    $0x4,%eax
80104248:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010424e:	c3                   	ret    
8010424f:	90                   	nop

80104250 <myproc>:
{
80104250:	f3 0f 1e fb          	endbr32 
80104254:	55                   	push   %ebp
80104255:	89 e5                	mov    %esp,%ebp
80104257:	53                   	push   %ebx
80104258:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010425b:	e8 e0 0a 00 00       	call   80104d40 <pushcli>
  c = mycpu();
80104260:	e8 5b ff ff ff       	call   801041c0 <mycpu>
  p = c->proc;
80104265:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010426b:	e8 20 0b 00 00       	call   80104d90 <popcli>
}
80104270:	83 c4 04             	add    $0x4,%esp
80104273:	89 d8                	mov    %ebx,%eax
80104275:	5b                   	pop    %ebx
80104276:	5d                   	pop    %ebp
80104277:	c3                   	ret    
80104278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010427f:	90                   	nop

80104280 <userinit>:
{
80104280:	f3 0f 1e fb          	endbr32 
80104284:	55                   	push   %ebp
80104285:	89 e5                	mov    %esp,%ebp
80104287:	53                   	push   %ebx
80104288:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010428b:	e8 f0 fd ff ff       	call   80104080 <allocproc>
80104290:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104292:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if ((p->pgdir = setupkvm()) == 0)
80104297:	e8 64 36 00 00       	call   80107900 <setupkvm>
8010429c:	89 43 04             	mov    %eax,0x4(%ebx)
8010429f:	85 c0                	test   %eax,%eax
801042a1:	0f 84 d6 00 00 00    	je     8010437d <userinit+0xfd>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
801042a7:	83 ec 04             	sub    $0x4,%esp
801042aa:	68 2c 00 00 00       	push   $0x2c
801042af:	68 60 b4 10 80       	push   $0x8010b460
801042b4:	68 30 86 10 80       	push   $0x80108630
801042b9:	e8 f2 c3 ff ff       	call   801006b0 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801042be:	83 c4 0c             	add    $0xc,%esp
801042c1:	68 2c 00 00 00       	push   $0x2c
801042c6:	68 60 b4 10 80       	push   $0x8010b460
801042cb:	ff 73 04             	pushl  0x4(%ebx)
801042ce:	e8 dd 32 00 00       	call   801075b0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801042d3:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801042d6:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801042dc:	6a 4c                	push   $0x4c
801042de:	6a 00                	push   $0x0
801042e0:	ff 73 18             	pushl  0x18(%ebx)
801042e3:	e8 68 0c 00 00       	call   80104f50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042e8:	8b 43 18             	mov    0x18(%ebx),%eax
801042eb:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801042f0:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042f3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042f8:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042fc:	8b 43 18             	mov    0x18(%ebx),%eax
801042ff:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104303:	8b 43 18             	mov    0x18(%ebx),%eax
80104306:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010430a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010430e:	8b 43 18             	mov    0x18(%ebx),%eax
80104311:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104315:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104319:	8b 43 18             	mov    0x18(%ebx),%eax
8010431c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104323:	8b 43 18             	mov    0x18(%ebx),%eax
80104326:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
8010432d:	8b 43 18             	mov    0x18(%ebx),%eax
80104330:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104337:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010433a:	6a 10                	push   $0x10
8010433c:	68 37 86 10 80       	push   $0x80108637
80104341:	50                   	push   %eax
80104342:	e8 c9 0d 00 00       	call   80105110 <safestrcpy>
  p->cwd = namei("/");
80104347:	c7 04 24 40 86 10 80 	movl   $0x80108640,(%esp)
8010434e:	e8 dd dc ff ff       	call   80102030 <namei>
80104353:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104356:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
8010435d:	e8 de 0a 00 00       	call   80104e40 <acquire>
  p->state = RUNNABLE;
80104362:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104369:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
80104370:	e8 8b 0b 00 00       	call   80104f00 <release>
}
80104375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104378:	83 c4 10             	add    $0x10,%esp
8010437b:	c9                   	leave  
8010437c:	c3                   	ret    
    panic("userinit: out of memory?");
8010437d:	83 ec 0c             	sub    $0xc,%esp
80104380:	68 17 86 10 80       	push   $0x80108617
80104385:	e8 06 c0 ff ff       	call   80100390 <panic>
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104390 <growproc>:
{
80104390:	f3 0f 1e fb          	endbr32 
80104394:	55                   	push   %ebp
80104395:	89 e5                	mov    %esp,%ebp
80104397:	56                   	push   %esi
80104398:	53                   	push   %ebx
80104399:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010439c:	e8 9f 09 00 00       	call   80104d40 <pushcli>
  c = mycpu();
801043a1:	e8 1a fe ff ff       	call   801041c0 <mycpu>
  p = c->proc;
801043a6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043ac:	e8 df 09 00 00       	call   80104d90 <popcli>
  sz = curproc->sz;
801043b1:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
801043b3:	85 f6                	test   %esi,%esi
801043b5:	7f 19                	jg     801043d0 <growproc+0x40>
  else if (n < 0)
801043b7:	75 37                	jne    801043f0 <growproc+0x60>
  switchuvm(curproc);
801043b9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801043bc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801043be:	53                   	push   %ebx
801043bf:	e8 dc 30 00 00       	call   801074a0 <switchuvm>
  return 0;
801043c4:	83 c4 10             	add    $0x10,%esp
801043c7:	31 c0                	xor    %eax,%eax
}
801043c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043cc:	5b                   	pop    %ebx
801043cd:	5e                   	pop    %esi
801043ce:	5d                   	pop    %ebp
801043cf:	c3                   	ret    
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043d0:	83 ec 04             	sub    $0x4,%esp
801043d3:	01 c6                	add    %eax,%esi
801043d5:	56                   	push   %esi
801043d6:	50                   	push   %eax
801043d7:	ff 73 04             	pushl  0x4(%ebx)
801043da:	e8 31 33 00 00       	call   80107710 <allocuvm>
801043df:	83 c4 10             	add    $0x10,%esp
801043e2:	85 c0                	test   %eax,%eax
801043e4:	75 d3                	jne    801043b9 <growproc+0x29>
      return -1;
801043e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043eb:	eb dc                	jmp    801043c9 <growproc+0x39>
801043ed:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043f0:	83 ec 04             	sub    $0x4,%esp
801043f3:	01 c6                	add    %eax,%esi
801043f5:	56                   	push   %esi
801043f6:	50                   	push   %eax
801043f7:	ff 73 04             	pushl  0x4(%ebx)
801043fa:	e8 51 34 00 00       	call   80107850 <deallocuvm>
801043ff:	83 c4 10             	add    $0x10,%esp
80104402:	85 c0                	test   %eax,%eax
80104404:	75 b3                	jne    801043b9 <growproc+0x29>
80104406:	eb de                	jmp    801043e6 <growproc+0x56>
80104408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440f:	90                   	nop

80104410 <fork>:
{
80104410:	f3 0f 1e fb          	endbr32 
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	57                   	push   %edi
80104418:	56                   	push   %esi
80104419:	53                   	push   %ebx
8010441a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010441d:	e8 1e 09 00 00       	call   80104d40 <pushcli>
  c = mycpu();
80104422:	e8 99 fd ff ff       	call   801041c0 <mycpu>
  p = c->proc;
80104427:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010442d:	e8 5e 09 00 00       	call   80104d90 <popcli>
  if ((np = allocproc()) == 0)
80104432:	e8 49 fc ff ff       	call   80104080 <allocproc>
80104437:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010443a:	85 c0                	test   %eax,%eax
8010443c:	0f 84 bb 00 00 00    	je     801044fd <fork+0xed>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80104442:	83 ec 08             	sub    $0x8,%esp
80104445:	ff 33                	pushl  (%ebx)
80104447:	89 c7                	mov    %eax,%edi
80104449:	ff 73 04             	pushl  0x4(%ebx)
8010444c:	e8 7f 35 00 00       	call   801079d0 <copyuvm>
80104451:	83 c4 10             	add    $0x10,%esp
80104454:	89 47 04             	mov    %eax,0x4(%edi)
80104457:	85 c0                	test   %eax,%eax
80104459:	0f 84 a5 00 00 00    	je     80104504 <fork+0xf4>
  np->sz = curproc->sz;
8010445f:	8b 03                	mov    (%ebx),%eax
80104461:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104464:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104466:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104469:	89 c8                	mov    %ecx,%eax
8010446b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010446e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104473:	8b 73 18             	mov    0x18(%ebx),%esi
80104476:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80104478:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010447a:	8b 40 18             	mov    0x18(%eax),%eax
8010447d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[i])
80104488:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010448c:	85 c0                	test   %eax,%eax
8010448e:	74 13                	je     801044a3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104490:	83 ec 0c             	sub    $0xc,%esp
80104493:	50                   	push   %eax
80104494:	e8 d7 c9 ff ff       	call   80100e70 <filedup>
80104499:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010449c:	83 c4 10             	add    $0x10,%esp
8010449f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
801044a3:	83 c6 01             	add    $0x1,%esi
801044a6:	83 fe 10             	cmp    $0x10,%esi
801044a9:	75 dd                	jne    80104488 <fork+0x78>
  np->cwd = idup(curproc->cwd);
801044ab:	83 ec 0c             	sub    $0xc,%esp
801044ae:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801044b1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801044b4:	e8 77 d2 ff ff       	call   80101730 <idup>
801044b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801044bc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801044bf:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801044c2:	8d 47 6c             	lea    0x6c(%edi),%eax
801044c5:	6a 10                	push   $0x10
801044c7:	53                   	push   %ebx
801044c8:	50                   	push   %eax
801044c9:	e8 42 0c 00 00       	call   80105110 <safestrcpy>
  pid = np->pid;
801044ce:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801044d1:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
801044d8:	e8 63 09 00 00       	call   80104e40 <acquire>
  np->state = RUNNABLE;
801044dd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801044e4:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
801044eb:	e8 10 0a 00 00       	call   80104f00 <release>
  return pid;
801044f0:	83 c4 10             	add    $0x10,%esp
}
801044f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044f6:	89 d8                	mov    %ebx,%eax
801044f8:	5b                   	pop    %ebx
801044f9:	5e                   	pop    %esi
801044fa:	5f                   	pop    %edi
801044fb:	5d                   	pop    %ebp
801044fc:	c3                   	ret    
    return -1;
801044fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104502:	eb ef                	jmp    801044f3 <fork+0xe3>
    kfree(np->kstack);
80104504:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104507:	83 ec 0c             	sub    $0xc,%esp
8010450a:	ff 73 08             	pushl  0x8(%ebx)
8010450d:	e8 6e e0 ff ff       	call   80102580 <kfree>
    np->kstack = 0;
80104512:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104519:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010451c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104523:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104528:	eb c9                	jmp    801044f3 <fork+0xe3>
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104530 <scheduler>:
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	57                   	push   %edi
80104538:	56                   	push   %esi
80104539:	53                   	push   %ebx
8010453a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010453d:	e8 7e fc ff ff       	call   801041c0 <mycpu>
  c->proc = 0;
80104542:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104549:	00 00 00 
  struct cpu *c = mycpu();
8010454c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010454e:	8d 78 04             	lea    0x4(%eax),%edi
80104551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104558:	fb                   	sti    
    acquire(&ptable.lock);
80104559:	83 ec 0c             	sub    $0xc,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010455c:	bb b4 9d 11 80       	mov    $0x80119db4,%ebx
    acquire(&ptable.lock);
80104561:	68 80 9d 11 80       	push   $0x80119d80
80104566:	e8 d5 08 00 00       	call   80104e40 <acquire>
8010456b:	83 c4 10             	add    $0x10,%esp
8010456e:	66 90                	xchg   %ax,%ax
      if (p->state != RUNNABLE)
80104570:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104574:	75 33                	jne    801045a9 <scheduler+0x79>
      switchuvm(p);
80104576:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104579:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010457f:	53                   	push   %ebx
80104580:	e8 1b 2f 00 00       	call   801074a0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104585:	58                   	pop    %eax
80104586:	5a                   	pop    %edx
80104587:	ff 73 1c             	pushl  0x1c(%ebx)
8010458a:	57                   	push   %edi
      p->state = RUNNING;
8010458b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104592:	e8 dc 0b 00 00       	call   80105173 <swtch>
      switchkvm();
80104597:	e8 e4 2e 00 00       	call   80107480 <switchkvm>
      c->proc = 0;
8010459c:	83 c4 10             	add    $0x10,%esp
8010459f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801045a6:	00 00 00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045a9:	83 c3 7c             	add    $0x7c,%ebx
801045ac:	81 fb b4 bc 11 80    	cmp    $0x8011bcb4,%ebx
801045b2:	75 bc                	jne    80104570 <scheduler+0x40>
    release(&ptable.lock);
801045b4:	83 ec 0c             	sub    $0xc,%esp
801045b7:	68 80 9d 11 80       	push   $0x80119d80
801045bc:	e8 3f 09 00 00       	call   80104f00 <release>
    sti();
801045c1:	83 c4 10             	add    $0x10,%esp
801045c4:	eb 92                	jmp    80104558 <scheduler+0x28>
801045c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045cd:	8d 76 00             	lea    0x0(%esi),%esi

801045d0 <sched>:
{
801045d0:	f3 0f 1e fb          	endbr32 
801045d4:	55                   	push   %ebp
801045d5:	89 e5                	mov    %esp,%ebp
801045d7:	56                   	push   %esi
801045d8:	53                   	push   %ebx
  pushcli();
801045d9:	e8 62 07 00 00       	call   80104d40 <pushcli>
  c = mycpu();
801045de:	e8 dd fb ff ff       	call   801041c0 <mycpu>
  p = c->proc;
801045e3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045e9:	e8 a2 07 00 00       	call   80104d90 <popcli>
  if (!holding(&ptable.lock))
801045ee:	83 ec 0c             	sub    $0xc,%esp
801045f1:	68 80 9d 11 80       	push   $0x80119d80
801045f6:	e8 f5 07 00 00       	call   80104df0 <holding>
801045fb:	83 c4 10             	add    $0x10,%esp
801045fe:	85 c0                	test   %eax,%eax
80104600:	74 41                	je     80104643 <sched+0x73>
  if (p->state == RUNNING)
80104602:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104606:	74 55                	je     8010465d <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104608:	9c                   	pushf  
80104609:	58                   	pop    %eax
  if (readeflags() & FL_IF)
8010460a:	f6 c4 02             	test   $0x2,%ah
8010460d:	75 41                	jne    80104650 <sched+0x80>
  intena = mycpu()->intena;
8010460f:	e8 ac fb ff ff       	call   801041c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104614:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104617:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010461d:	e8 9e fb ff ff       	call   801041c0 <mycpu>
80104622:	83 ec 08             	sub    $0x8,%esp
80104625:	ff 70 04             	pushl  0x4(%eax)
80104628:	53                   	push   %ebx
80104629:	e8 45 0b 00 00       	call   80105173 <swtch>
  mycpu()->intena = intena;
8010462e:	e8 8d fb ff ff       	call   801041c0 <mycpu>
}
80104633:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104636:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010463c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010463f:	5b                   	pop    %ebx
80104640:	5e                   	pop    %esi
80104641:	5d                   	pop    %ebp
80104642:	c3                   	ret    
    panic("sched ptable.lock");
80104643:	83 ec 0c             	sub    $0xc,%esp
80104646:	68 42 86 10 80       	push   $0x80108642
8010464b:	e8 40 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80104650:	83 ec 0c             	sub    $0xc,%esp
80104653:	68 62 86 10 80       	push   $0x80108662
80104658:	e8 33 bd ff ff       	call   80100390 <panic>
    panic("sched running");
8010465d:	83 ec 0c             	sub    $0xc,%esp
80104660:	68 54 86 10 80       	push   $0x80108654
80104665:	e8 26 bd ff ff       	call   80100390 <panic>
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104670 <exit>:
{
80104670:	f3 0f 1e fb          	endbr32 
80104674:	55                   	push   %ebp
80104675:	89 e5                	mov    %esp,%ebp
80104677:	57                   	push   %edi
80104678:	56                   	push   %esi
80104679:	53                   	push   %ebx
8010467a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010467d:	e8 be 06 00 00       	call   80104d40 <pushcli>
  c = mycpu();
80104682:	e8 39 fb ff ff       	call   801041c0 <mycpu>
  p = c->proc;
80104687:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010468d:	e8 fe 06 00 00       	call   80104d90 <popcli>
  if (curproc == initproc)
80104692:	8d 5e 28             	lea    0x28(%esi),%ebx
80104695:	8d 7e 68             	lea    0x68(%esi),%edi
80104698:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010469e:	0f 84 f3 00 00 00    	je     80104797 <exit+0x127>
801046a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd])
801046a8:	8b 03                	mov    (%ebx),%eax
801046aa:	85 c0                	test   %eax,%eax
801046ac:	74 12                	je     801046c0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801046ae:	83 ec 0c             	sub    $0xc,%esp
801046b1:	50                   	push   %eax
801046b2:	e8 09 c8 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
801046b7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801046bd:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
801046c0:	83 c3 04             	add    $0x4,%ebx
801046c3:	39 df                	cmp    %ebx,%edi
801046c5:	75 e1                	jne    801046a8 <exit+0x38>
  begin_op();
801046c7:	e8 54 ef ff ff       	call   80103620 <begin_op>
  iput(curproc->cwd);
801046cc:	83 ec 0c             	sub    $0xc,%esp
801046cf:	ff 76 68             	pushl  0x68(%esi)
801046d2:	e8 b9 d1 ff ff       	call   80101890 <iput>
  end_op();
801046d7:	e8 b4 ef ff ff       	call   80103690 <end_op>
  curproc->cwd = 0;
801046dc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801046e3:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
801046ea:	e8 51 07 00 00       	call   80104e40 <acquire>
  wakeup1(curproc->parent);
801046ef:	8b 56 14             	mov    0x14(%esi),%edx
801046f2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046f5:	b8 b4 9d 11 80       	mov    $0x80119db4,%eax
801046fa:	eb 0e                	jmp    8010470a <exit+0x9a>
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104700:	83 c0 7c             	add    $0x7c,%eax
80104703:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
80104708:	74 1c                	je     80104726 <exit+0xb6>
    if (p->state == SLEEPING && p->chan == chan)
8010470a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010470e:	75 f0                	jne    80104700 <exit+0x90>
80104710:	3b 50 20             	cmp    0x20(%eax),%edx
80104713:	75 eb                	jne    80104700 <exit+0x90>
      p->state = RUNNABLE;
80104715:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010471c:	83 c0 7c             	add    $0x7c,%eax
8010471f:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
80104724:	75 e4                	jne    8010470a <exit+0x9a>
      p->parent = initproc;
80104726:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010472c:	ba b4 9d 11 80       	mov    $0x80119db4,%edx
80104731:	eb 10                	jmp    80104743 <exit+0xd3>
80104733:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104737:	90                   	nop
80104738:	83 c2 7c             	add    $0x7c,%edx
8010473b:	81 fa b4 bc 11 80    	cmp    $0x8011bcb4,%edx
80104741:	74 3b                	je     8010477e <exit+0x10e>
    if (p->parent == curproc)
80104743:	39 72 14             	cmp    %esi,0x14(%edx)
80104746:	75 f0                	jne    80104738 <exit+0xc8>
      if (p->state == ZOMBIE)
80104748:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010474c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
8010474f:	75 e7                	jne    80104738 <exit+0xc8>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104751:	b8 b4 9d 11 80       	mov    $0x80119db4,%eax
80104756:	eb 12                	jmp    8010476a <exit+0xfa>
80104758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475f:	90                   	nop
80104760:	83 c0 7c             	add    $0x7c,%eax
80104763:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
80104768:	74 ce                	je     80104738 <exit+0xc8>
    if (p->state == SLEEPING && p->chan == chan)
8010476a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010476e:	75 f0                	jne    80104760 <exit+0xf0>
80104770:	3b 48 20             	cmp    0x20(%eax),%ecx
80104773:	75 eb                	jne    80104760 <exit+0xf0>
      p->state = RUNNABLE;
80104775:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010477c:	eb e2                	jmp    80104760 <exit+0xf0>
  curproc->state = ZOMBIE;
8010477e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104785:	e8 46 fe ff ff       	call   801045d0 <sched>
  panic("zombie exit");
8010478a:	83 ec 0c             	sub    $0xc,%esp
8010478d:	68 83 86 10 80       	push   $0x80108683
80104792:	e8 f9 bb ff ff       	call   80100390 <panic>
    panic("init exiting");
80104797:	83 ec 0c             	sub    $0xc,%esp
8010479a:	68 76 86 10 80       	push   $0x80108676
8010479f:	e8 ec bb ff ff       	call   80100390 <panic>
801047a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047af:	90                   	nop

801047b0 <yield>:
{
801047b0:	f3 0f 1e fb          	endbr32 
801047b4:	55                   	push   %ebp
801047b5:	89 e5                	mov    %esp,%ebp
801047b7:	53                   	push   %ebx
801047b8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
801047bb:	68 80 9d 11 80       	push   $0x80119d80
801047c0:	e8 7b 06 00 00       	call   80104e40 <acquire>
  pushcli();
801047c5:	e8 76 05 00 00       	call   80104d40 <pushcli>
  c = mycpu();
801047ca:	e8 f1 f9 ff ff       	call   801041c0 <mycpu>
  p = c->proc;
801047cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047d5:	e8 b6 05 00 00       	call   80104d90 <popcli>
  myproc()->state = RUNNABLE;
801047da:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801047e1:	e8 ea fd ff ff       	call   801045d0 <sched>
  release(&ptable.lock);
801047e6:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
801047ed:	e8 0e 07 00 00       	call   80104f00 <release>
}
801047f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f5:	83 c4 10             	add    $0x10,%esp
801047f8:	c9                   	leave  
801047f9:	c3                   	ret    
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104800 <sleep>:
{
80104800:	f3 0f 1e fb          	endbr32 
80104804:	55                   	push   %ebp
80104805:	89 e5                	mov    %esp,%ebp
80104807:	57                   	push   %edi
80104808:	56                   	push   %esi
80104809:	53                   	push   %ebx
8010480a:	83 ec 0c             	sub    $0xc,%esp
8010480d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104810:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104813:	e8 28 05 00 00       	call   80104d40 <pushcli>
  c = mycpu();
80104818:	e8 a3 f9 ff ff       	call   801041c0 <mycpu>
  p = c->proc;
8010481d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104823:	e8 68 05 00 00       	call   80104d90 <popcli>
  if (p == 0)
80104828:	85 db                	test   %ebx,%ebx
8010482a:	0f 84 83 00 00 00    	je     801048b3 <sleep+0xb3>
  if (lk == 0)
80104830:	85 f6                	test   %esi,%esi
80104832:	74 72                	je     801048a6 <sleep+0xa6>
  if (lk != &ptable.lock)
80104834:	81 fe 80 9d 11 80    	cmp    $0x80119d80,%esi
8010483a:	74 4c                	je     80104888 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
8010483c:	83 ec 0c             	sub    $0xc,%esp
8010483f:	68 80 9d 11 80       	push   $0x80119d80
80104844:	e8 f7 05 00 00       	call   80104e40 <acquire>
    release(lk);
80104849:	89 34 24             	mov    %esi,(%esp)
8010484c:	e8 af 06 00 00       	call   80104f00 <release>
  p->chan = chan;
80104851:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104854:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010485b:	e8 70 fd ff ff       	call   801045d0 <sched>
  p->chan = 0;
80104860:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104867:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
8010486e:	e8 8d 06 00 00       	call   80104f00 <release>
    acquire(lk);
80104873:	89 75 08             	mov    %esi,0x8(%ebp)
80104876:	83 c4 10             	add    $0x10,%esp
}
80104879:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010487c:	5b                   	pop    %ebx
8010487d:	5e                   	pop    %esi
8010487e:	5f                   	pop    %edi
8010487f:	5d                   	pop    %ebp
    acquire(lk);
80104880:	e9 bb 05 00 00       	jmp    80104e40 <acquire>
80104885:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104888:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010488b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104892:	e8 39 fd ff ff       	call   801045d0 <sched>
  p->chan = 0;
80104897:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010489e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048a1:	5b                   	pop    %ebx
801048a2:	5e                   	pop    %esi
801048a3:	5f                   	pop    %edi
801048a4:	5d                   	pop    %ebp
801048a5:	c3                   	ret    
    panic("sleep without lk");
801048a6:	83 ec 0c             	sub    $0xc,%esp
801048a9:	68 95 86 10 80       	push   $0x80108695
801048ae:	e8 dd ba ff ff       	call   80100390 <panic>
    panic("sleep");
801048b3:	83 ec 0c             	sub    $0xc,%esp
801048b6:	68 8f 86 10 80       	push   $0x8010868f
801048bb:	e8 d0 ba ff ff       	call   80100390 <panic>

801048c0 <wait>:
{
801048c0:	f3 0f 1e fb          	endbr32 
801048c4:	55                   	push   %ebp
801048c5:	89 e5                	mov    %esp,%ebp
801048c7:	56                   	push   %esi
801048c8:	53                   	push   %ebx
  pushcli();
801048c9:	e8 72 04 00 00       	call   80104d40 <pushcli>
  c = mycpu();
801048ce:	e8 ed f8 ff ff       	call   801041c0 <mycpu>
  p = c->proc;
801048d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801048d9:	e8 b2 04 00 00       	call   80104d90 <popcli>
  acquire(&ptable.lock);
801048de:	83 ec 0c             	sub    $0xc,%esp
801048e1:	68 80 9d 11 80       	push   $0x80119d80
801048e6:	e8 55 05 00 00       	call   80104e40 <acquire>
801048eb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801048ee:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048f0:	bb b4 9d 11 80       	mov    $0x80119db4,%ebx
801048f5:	eb 14                	jmp    8010490b <wait+0x4b>
801048f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fe:	66 90                	xchg   %ax,%ax
80104900:	83 c3 7c             	add    $0x7c,%ebx
80104903:	81 fb b4 bc 11 80    	cmp    $0x8011bcb4,%ebx
80104909:	74 1b                	je     80104926 <wait+0x66>
      if (p->parent != curproc)
8010490b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010490e:	75 f0                	jne    80104900 <wait+0x40>
      if (p->state == ZOMBIE)
80104910:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104914:	74 32                	je     80104948 <wait+0x88>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104916:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104919:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010491e:	81 fb b4 bc 11 80    	cmp    $0x8011bcb4,%ebx
80104924:	75 e5                	jne    8010490b <wait+0x4b>
    if (!havekids || curproc->killed)
80104926:	85 c0                	test   %eax,%eax
80104928:	74 74                	je     8010499e <wait+0xde>
8010492a:	8b 46 24             	mov    0x24(%esi),%eax
8010492d:	85 c0                	test   %eax,%eax
8010492f:	75 6d                	jne    8010499e <wait+0xde>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
80104931:	83 ec 08             	sub    $0x8,%esp
80104934:	68 80 9d 11 80       	push   $0x80119d80
80104939:	56                   	push   %esi
8010493a:	e8 c1 fe ff ff       	call   80104800 <sleep>
    havekids = 0;
8010493f:	83 c4 10             	add    $0x10,%esp
80104942:	eb aa                	jmp    801048ee <wait+0x2e>
80104944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104948:	83 ec 0c             	sub    $0xc,%esp
8010494b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010494e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104951:	e8 2a dc ff ff       	call   80102580 <kfree>
        freevm(p->pgdir);
80104956:	5a                   	pop    %edx
80104957:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010495a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104961:	e8 1a 2f 00 00       	call   80107880 <freevm>
        release(&ptable.lock);
80104966:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
        p->pid = 0;
8010496d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104974:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010497b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010497f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104986:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010498d:	e8 6e 05 00 00       	call   80104f00 <release>
        return pid;
80104992:	83 c4 10             	add    $0x10,%esp
}
80104995:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104998:	89 f0                	mov    %esi,%eax
8010499a:	5b                   	pop    %ebx
8010499b:	5e                   	pop    %esi
8010499c:	5d                   	pop    %ebp
8010499d:	c3                   	ret    
      release(&ptable.lock);
8010499e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801049a1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801049a6:	68 80 9d 11 80       	push   $0x80119d80
801049ab:	e8 50 05 00 00       	call   80104f00 <release>
      return -1;
801049b0:	83 c4 10             	add    $0x10,%esp
801049b3:	eb e0                	jmp    80104995 <wait+0xd5>
801049b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	53                   	push   %ebx
801049c8:	83 ec 10             	sub    $0x10,%esp
801049cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801049ce:	68 80 9d 11 80       	push   $0x80119d80
801049d3:	e8 68 04 00 00       	call   80104e40 <acquire>
801049d8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049db:	b8 b4 9d 11 80       	mov    $0x80119db4,%eax
801049e0:	eb 10                	jmp    801049f2 <wakeup+0x32>
801049e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049e8:	83 c0 7c             	add    $0x7c,%eax
801049eb:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
801049f0:	74 1c                	je     80104a0e <wakeup+0x4e>
    if (p->state == SLEEPING && p->chan == chan)
801049f2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049f6:	75 f0                	jne    801049e8 <wakeup+0x28>
801049f8:	3b 58 20             	cmp    0x20(%eax),%ebx
801049fb:	75 eb                	jne    801049e8 <wakeup+0x28>
      p->state = RUNNABLE;
801049fd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a04:	83 c0 7c             	add    $0x7c,%eax
80104a07:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
80104a0c:	75 e4                	jne    801049f2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
80104a0e:	c7 45 08 80 9d 11 80 	movl   $0x80119d80,0x8(%ebp)
}
80104a15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a18:	c9                   	leave  
  release(&ptable.lock);
80104a19:	e9 e2 04 00 00       	jmp    80104f00 <release>
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104a20:	f3 0f 1e fb          	endbr32 
80104a24:	55                   	push   %ebp
80104a25:	89 e5                	mov    %esp,%ebp
80104a27:	53                   	push   %ebx
80104a28:	83 ec 10             	sub    $0x10,%esp
80104a2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104a2e:	68 80 9d 11 80       	push   $0x80119d80
80104a33:	e8 08 04 00 00       	call   80104e40 <acquire>
80104a38:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a3b:	b8 b4 9d 11 80       	mov    $0x80119db4,%eax
80104a40:	eb 10                	jmp    80104a52 <kill+0x32>
80104a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a48:	83 c0 7c             	add    $0x7c,%eax
80104a4b:	3d b4 bc 11 80       	cmp    $0x8011bcb4,%eax
80104a50:	74 36                	je     80104a88 <kill+0x68>
  {
    if (p->pid == pid)
80104a52:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a55:	75 f1                	jne    80104a48 <kill+0x28>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104a57:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104a5b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
80104a62:	75 07                	jne    80104a6b <kill+0x4b>
        p->state = RUNNABLE;
80104a64:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104a6b:	83 ec 0c             	sub    $0xc,%esp
80104a6e:	68 80 9d 11 80       	push   $0x80119d80
80104a73:	e8 88 04 00 00       	call   80104f00 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104a78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104a7b:	83 c4 10             	add    $0x10,%esp
80104a7e:	31 c0                	xor    %eax,%eax
}
80104a80:	c9                   	leave  
80104a81:	c3                   	ret    
80104a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104a88:	83 ec 0c             	sub    $0xc,%esp
80104a8b:	68 80 9d 11 80       	push   $0x80119d80
80104a90:	e8 6b 04 00 00       	call   80104f00 <release>
}
80104a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104a98:	83 c4 10             	add    $0x10,%esp
80104a9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104aa0:	c9                   	leave  
80104aa1:	c3                   	ret    
80104aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ab0 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104ab0:	f3 0f 1e fb          	endbr32 
80104ab4:	55                   	push   %ebp
80104ab5:	89 e5                	mov    %esp,%ebp
80104ab7:	57                   	push   %edi
80104ab8:	56                   	push   %esi
80104ab9:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104abc:	53                   	push   %ebx
80104abd:	bb 20 9e 11 80       	mov    $0x80119e20,%ebx
80104ac2:	83 ec 3c             	sub    $0x3c,%esp
80104ac5:	eb 28                	jmp    80104aef <procdump+0x3f>
80104ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ace:	66 90                	xchg   %ax,%ax
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ad0:	83 ec 0c             	sub    $0xc,%esp
80104ad3:	68 81 8a 10 80       	push   $0x80108a81
80104ad8:	e8 d3 bb ff ff       	call   801006b0 <cprintf>
80104add:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ae0:	83 c3 7c             	add    $0x7c,%ebx
80104ae3:	81 fb 20 bd 11 80    	cmp    $0x8011bd20,%ebx
80104ae9:	0f 84 81 00 00 00    	je     80104b70 <procdump+0xc0>
    if (p->state == UNUSED)
80104aef:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104af2:	85 c0                	test   %eax,%eax
80104af4:	74 ea                	je     80104ae0 <procdump+0x30>
      state = "???";
80104af6:	ba a6 86 10 80       	mov    $0x801086a6,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104afb:	83 f8 05             	cmp    $0x5,%eax
80104afe:	77 11                	ja     80104b11 <procdump+0x61>
80104b00:	8b 14 85 08 87 10 80 	mov    -0x7fef78f8(,%eax,4),%edx
      state = "???";
80104b07:	b8 a6 86 10 80       	mov    $0x801086a6,%eax
80104b0c:	85 d2                	test   %edx,%edx
80104b0e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104b11:	53                   	push   %ebx
80104b12:	52                   	push   %edx
80104b13:	ff 73 a4             	pushl  -0x5c(%ebx)
80104b16:	68 aa 86 10 80       	push   $0x801086aa
80104b1b:	e8 90 bb ff ff       	call   801006b0 <cprintf>
    if (p->state == SLEEPING)
80104b20:	83 c4 10             	add    $0x10,%esp
80104b23:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104b27:	75 a7                	jne    80104ad0 <procdump+0x20>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104b29:	83 ec 08             	sub    $0x8,%esp
80104b2c:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b2f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104b32:	50                   	push   %eax
80104b33:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104b36:	8b 40 0c             	mov    0xc(%eax),%eax
80104b39:	83 c0 08             	add    $0x8,%eax
80104b3c:	50                   	push   %eax
80104b3d:	e8 9e 01 00 00       	call   80104ce0 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104b42:	83 c4 10             	add    $0x10,%esp
80104b45:	8d 76 00             	lea    0x0(%esi),%esi
80104b48:	8b 17                	mov    (%edi),%edx
80104b4a:	85 d2                	test   %edx,%edx
80104b4c:	74 82                	je     80104ad0 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104b4e:	83 ec 08             	sub    $0x8,%esp
80104b51:	83 c7 04             	add    $0x4,%edi
80104b54:	52                   	push   %edx
80104b55:	68 e1 7b 10 80       	push   $0x80107be1
80104b5a:	e8 51 bb ff ff       	call   801006b0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104b5f:	83 c4 10             	add    $0x10,%esp
80104b62:	39 fe                	cmp    %edi,%esi
80104b64:	75 e2                	jne    80104b48 <procdump+0x98>
80104b66:	e9 65 ff ff ff       	jmp    80104ad0 <procdump+0x20>
80104b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b6f:	90                   	nop
  }
}
80104b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b73:	5b                   	pop    %ebx
80104b74:	5e                   	pop    %esi
80104b75:	5f                   	pop    %edi
80104b76:	5d                   	pop    %ebp
80104b77:	c3                   	ret    
80104b78:	66 90                	xchg   %ax,%ax
80104b7a:	66 90                	xchg   %ax,%ax
80104b7c:	66 90                	xchg   %ax,%ax
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	53                   	push   %ebx
80104b88:	83 ec 0c             	sub    $0xc,%esp
80104b8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b8e:	68 20 87 10 80       	push   $0x80108720
80104b93:	8d 43 04             	lea    0x4(%ebx),%eax
80104b96:	50                   	push   %eax
80104b97:	e8 24 01 00 00       	call   80104cc0 <initlock>
  lk->name = name;
80104b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b9f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ba5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104ba8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104baf:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104bb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb5:	c9                   	leave  
80104bb6:	c3                   	ret    
80104bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104bc0:	f3 0f 1e fb          	endbr32 
80104bc4:	55                   	push   %ebp
80104bc5:	89 e5                	mov    %esp,%ebp
80104bc7:	56                   	push   %esi
80104bc8:	53                   	push   %ebx
80104bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bcc:	8d 73 04             	lea    0x4(%ebx),%esi
80104bcf:	83 ec 0c             	sub    $0xc,%esp
80104bd2:	56                   	push   %esi
80104bd3:	e8 68 02 00 00       	call   80104e40 <acquire>
  while (lk->locked) {
80104bd8:	8b 13                	mov    (%ebx),%edx
80104bda:	83 c4 10             	add    $0x10,%esp
80104bdd:	85 d2                	test   %edx,%edx
80104bdf:	74 1a                	je     80104bfb <acquiresleep+0x3b>
80104be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104be8:	83 ec 08             	sub    $0x8,%esp
80104beb:	56                   	push   %esi
80104bec:	53                   	push   %ebx
80104bed:	e8 0e fc ff ff       	call   80104800 <sleep>
  while (lk->locked) {
80104bf2:	8b 03                	mov    (%ebx),%eax
80104bf4:	83 c4 10             	add    $0x10,%esp
80104bf7:	85 c0                	test   %eax,%eax
80104bf9:	75 ed                	jne    80104be8 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104bfb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c01:	e8 4a f6 ff ff       	call   80104250 <myproc>
80104c06:	8b 40 10             	mov    0x10(%eax),%eax
80104c09:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c0c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c12:	5b                   	pop    %ebx
80104c13:	5e                   	pop    %esi
80104c14:	5d                   	pop    %ebp
  release(&lk->lk);
80104c15:	e9 e6 02 00 00       	jmp    80104f00 <release>
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c20 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c20:	f3 0f 1e fb          	endbr32 
80104c24:	55                   	push   %ebp
80104c25:	89 e5                	mov    %esp,%ebp
80104c27:	56                   	push   %esi
80104c28:	53                   	push   %ebx
80104c29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c2c:	8d 73 04             	lea    0x4(%ebx),%esi
80104c2f:	83 ec 0c             	sub    $0xc,%esp
80104c32:	56                   	push   %esi
80104c33:	e8 08 02 00 00       	call   80104e40 <acquire>
  lk->locked = 0;
80104c38:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104c3e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c45:	89 1c 24             	mov    %ebx,(%esp)
80104c48:	e8 73 fd ff ff       	call   801049c0 <wakeup>
  release(&lk->lk);
80104c4d:	89 75 08             	mov    %esi,0x8(%ebp)
80104c50:	83 c4 10             	add    $0x10,%esp
}
80104c53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c56:	5b                   	pop    %ebx
80104c57:	5e                   	pop    %esi
80104c58:	5d                   	pop    %ebp
  release(&lk->lk);
80104c59:	e9 a2 02 00 00       	jmp    80104f00 <release>
80104c5e:	66 90                	xchg   %ax,%ax

80104c60 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c60:	f3 0f 1e fb          	endbr32 
80104c64:	55                   	push   %ebp
80104c65:	89 e5                	mov    %esp,%ebp
80104c67:	57                   	push   %edi
80104c68:	31 ff                	xor    %edi,%edi
80104c6a:	56                   	push   %esi
80104c6b:	53                   	push   %ebx
80104c6c:	83 ec 18             	sub    $0x18,%esp
80104c6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104c72:	8d 73 04             	lea    0x4(%ebx),%esi
80104c75:	56                   	push   %esi
80104c76:	e8 c5 01 00 00       	call   80104e40 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c7b:	8b 03                	mov    (%ebx),%eax
80104c7d:	83 c4 10             	add    $0x10,%esp
80104c80:	85 c0                	test   %eax,%eax
80104c82:	75 1c                	jne    80104ca0 <holdingsleep+0x40>
  release(&lk->lk);
80104c84:	83 ec 0c             	sub    $0xc,%esp
80104c87:	56                   	push   %esi
80104c88:	e8 73 02 00 00       	call   80104f00 <release>
  return r;
}
80104c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c90:	89 f8                	mov    %edi,%eax
80104c92:	5b                   	pop    %ebx
80104c93:	5e                   	pop    %esi
80104c94:	5f                   	pop    %edi
80104c95:	5d                   	pop    %ebp
80104c96:	c3                   	ret    
80104c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104ca0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104ca3:	e8 a8 f5 ff ff       	call   80104250 <myproc>
80104ca8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104cab:	0f 94 c0             	sete   %al
80104cae:	0f b6 c0             	movzbl %al,%eax
80104cb1:	89 c7                	mov    %eax,%edi
80104cb3:	eb cf                	jmp    80104c84 <holdingsleep+0x24>
80104cb5:	66 90                	xchg   %ax,%ax
80104cb7:	66 90                	xchg   %ax,%ax
80104cb9:	66 90                	xchg   %ax,%ax
80104cbb:	66 90                	xchg   %ax,%ax
80104cbd:	66 90                	xchg   %ax,%ax
80104cbf:	90                   	nop

80104cc0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
80104cc5:	89 e5                	mov    %esp,%ebp
80104cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104cca:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104ccd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104cd3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104cd6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104cdd:	5d                   	pop    %ebp
80104cde:	c3                   	ret    
80104cdf:	90                   	nop

80104ce0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ce0:	f3 0f 1e fb          	endbr32 
80104ce4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ce5:	31 d2                	xor    %edx,%edx
{
80104ce7:	89 e5                	mov    %esp,%ebp
80104ce9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104cea:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ced:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104cf0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104cf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cf7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cf8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104cfe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d04:	77 1a                	ja     80104d20 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d06:	8b 58 04             	mov    0x4(%eax),%ebx
80104d09:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d0c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d0f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d11:	83 fa 0a             	cmp    $0xa,%edx
80104d14:	75 e2                	jne    80104cf8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d16:	5b                   	pop    %ebx
80104d17:	5d                   	pop    %ebp
80104d18:	c3                   	ret    
80104d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104d20:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d23:	8d 51 28             	lea    0x28(%ecx),%edx
80104d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104d30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d36:	83 c0 04             	add    $0x4,%eax
80104d39:	39 d0                	cmp    %edx,%eax
80104d3b:	75 f3                	jne    80104d30 <getcallerpcs+0x50>
}
80104d3d:	5b                   	pop    %ebx
80104d3e:	5d                   	pop    %ebp
80104d3f:	c3                   	ret    

80104d40 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
80104d45:	89 e5                	mov    %esp,%ebp
80104d47:	53                   	push   %ebx
80104d48:	83 ec 04             	sub    $0x4,%esp
80104d4b:	9c                   	pushf  
80104d4c:	5b                   	pop    %ebx
  asm volatile("cli");
80104d4d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d4e:	e8 6d f4 ff ff       	call   801041c0 <mycpu>
80104d53:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d59:	85 c0                	test   %eax,%eax
80104d5b:	74 13                	je     80104d70 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104d5d:	e8 5e f4 ff ff       	call   801041c0 <mycpu>
80104d62:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d69:	83 c4 04             	add    $0x4,%esp
80104d6c:	5b                   	pop    %ebx
80104d6d:	5d                   	pop    %ebp
80104d6e:	c3                   	ret    
80104d6f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104d70:	e8 4b f4 ff ff       	call   801041c0 <mycpu>
80104d75:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d7b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104d81:	eb da                	jmp    80104d5d <pushcli+0x1d>
80104d83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d90 <popcli>:

void
popcli(void)
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d9a:	9c                   	pushf  
80104d9b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d9c:	f6 c4 02             	test   $0x2,%ah
80104d9f:	75 31                	jne    80104dd2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104da1:	e8 1a f4 ff ff       	call   801041c0 <mycpu>
80104da6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104dad:	78 30                	js     80104ddf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104daf:	e8 0c f4 ff ff       	call   801041c0 <mycpu>
80104db4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104dba:	85 d2                	test   %edx,%edx
80104dbc:	74 02                	je     80104dc0 <popcli+0x30>
    sti();
}
80104dbe:	c9                   	leave  
80104dbf:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104dc0:	e8 fb f3 ff ff       	call   801041c0 <mycpu>
80104dc5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104dcb:	85 c0                	test   %eax,%eax
80104dcd:	74 ef                	je     80104dbe <popcli+0x2e>
  asm volatile("sti");
80104dcf:	fb                   	sti    
}
80104dd0:	c9                   	leave  
80104dd1:	c3                   	ret    
    panic("popcli - interruptible");
80104dd2:	83 ec 0c             	sub    $0xc,%esp
80104dd5:	68 2b 87 10 80       	push   $0x8010872b
80104dda:	e8 b1 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104ddf:	83 ec 0c             	sub    $0xc,%esp
80104de2:	68 42 87 10 80       	push   $0x80108742
80104de7:	e8 a4 b5 ff ff       	call   80100390 <panic>
80104dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104df0 <holding>:
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
80104df5:	89 e5                	mov    %esp,%ebp
80104df7:	56                   	push   %esi
80104df8:	53                   	push   %ebx
80104df9:	8b 75 08             	mov    0x8(%ebp),%esi
80104dfc:	31 db                	xor    %ebx,%ebx
  pushcli();
80104dfe:	e8 3d ff ff ff       	call   80104d40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e03:	8b 06                	mov    (%esi),%eax
80104e05:	85 c0                	test   %eax,%eax
80104e07:	75 0f                	jne    80104e18 <holding+0x28>
  popcli();
80104e09:	e8 82 ff ff ff       	call   80104d90 <popcli>
}
80104e0e:	89 d8                	mov    %ebx,%eax
80104e10:	5b                   	pop    %ebx
80104e11:	5e                   	pop    %esi
80104e12:	5d                   	pop    %ebp
80104e13:	c3                   	ret    
80104e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e18:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e1b:	e8 a0 f3 ff ff       	call   801041c0 <mycpu>
80104e20:	39 c3                	cmp    %eax,%ebx
80104e22:	0f 94 c3             	sete   %bl
  popcli();
80104e25:	e8 66 ff ff ff       	call   80104d90 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104e2a:	0f b6 db             	movzbl %bl,%ebx
}
80104e2d:	89 d8                	mov    %ebx,%eax
80104e2f:	5b                   	pop    %ebx
80104e30:	5e                   	pop    %esi
80104e31:	5d                   	pop    %ebp
80104e32:	c3                   	ret    
80104e33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e40 <acquire>:
{
80104e40:	f3 0f 1e fb          	endbr32 
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	56                   	push   %esi
80104e48:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104e49:	e8 f2 fe ff ff       	call   80104d40 <pushcli>
  if(holding(lk))
80104e4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e51:	83 ec 0c             	sub    $0xc,%esp
80104e54:	53                   	push   %ebx
80104e55:	e8 96 ff ff ff       	call   80104df0 <holding>
80104e5a:	83 c4 10             	add    $0x10,%esp
80104e5d:	85 c0                	test   %eax,%eax
80104e5f:	0f 85 7f 00 00 00    	jne    80104ee4 <acquire+0xa4>
80104e65:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e67:	ba 01 00 00 00       	mov    $0x1,%edx
80104e6c:	eb 05                	jmp    80104e73 <acquire+0x33>
80104e6e:	66 90                	xchg   %ax,%ax
80104e70:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e73:	89 d0                	mov    %edx,%eax
80104e75:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104e78:	85 c0                	test   %eax,%eax
80104e7a:	75 f4                	jne    80104e70 <acquire+0x30>
  __sync_synchronize();
80104e7c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e84:	e8 37 f3 ff ff       	call   801041c0 <mycpu>
80104e89:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104e8c:	89 e8                	mov    %ebp,%eax
80104e8e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e90:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104e96:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104e9c:	77 22                	ja     80104ec0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104e9e:	8b 50 04             	mov    0x4(%eax),%edx
80104ea1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104ea5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104ea8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104eaa:	83 fe 0a             	cmp    $0xa,%esi
80104ead:	75 e1                	jne    80104e90 <acquire+0x50>
}
80104eaf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eb2:	5b                   	pop    %ebx
80104eb3:	5e                   	pop    %esi
80104eb4:	5d                   	pop    %ebp
80104eb5:	c3                   	ret    
80104eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104ec0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104ec4:	83 c3 34             	add    $0x34,%ebx
80104ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ece:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ed0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ed6:	83 c0 04             	add    $0x4,%eax
80104ed9:	39 d8                	cmp    %ebx,%eax
80104edb:	75 f3                	jne    80104ed0 <acquire+0x90>
}
80104edd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee0:	5b                   	pop    %ebx
80104ee1:	5e                   	pop    %esi
80104ee2:	5d                   	pop    %ebp
80104ee3:	c3                   	ret    
    panic("acquire");
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	68 49 87 10 80       	push   $0x80108749
80104eec:	e8 9f b4 ff ff       	call   80100390 <panic>
80104ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eff:	90                   	nop

80104f00 <release>:
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	53                   	push   %ebx
80104f08:	83 ec 10             	sub    $0x10,%esp
80104f0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104f0e:	53                   	push   %ebx
80104f0f:	e8 dc fe ff ff       	call   80104df0 <holding>
80104f14:	83 c4 10             	add    $0x10,%esp
80104f17:	85 c0                	test   %eax,%eax
80104f19:	74 22                	je     80104f3d <release+0x3d>
  lk->pcs[0] = 0;
80104f1b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f22:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f29:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f2e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f37:	c9                   	leave  
  popcli();
80104f38:	e9 53 fe ff ff       	jmp    80104d90 <popcli>
    panic("release");
80104f3d:	83 ec 0c             	sub    $0xc,%esp
80104f40:	68 51 87 10 80       	push   $0x80108751
80104f45:	e8 46 b4 ff ff       	call   80100390 <panic>
80104f4a:	66 90                	xchg   %ax,%ax
80104f4c:	66 90                	xchg   %ax,%ax
80104f4e:	66 90                	xchg   %ax,%ax

80104f50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	57                   	push   %edi
80104f58:	8b 55 08             	mov    0x8(%ebp),%edx
80104f5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f5e:	53                   	push   %ebx
80104f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104f62:	89 d7                	mov    %edx,%edi
80104f64:	09 cf                	or     %ecx,%edi
80104f66:	83 e7 03             	and    $0x3,%edi
80104f69:	75 25                	jne    80104f90 <memset+0x40>
    c &= 0xFF;
80104f6b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f6e:	c1 e0 18             	shl    $0x18,%eax
80104f71:	89 fb                	mov    %edi,%ebx
80104f73:	c1 e9 02             	shr    $0x2,%ecx
80104f76:	c1 e3 10             	shl    $0x10,%ebx
80104f79:	09 d8                	or     %ebx,%eax
80104f7b:	09 f8                	or     %edi,%eax
80104f7d:	c1 e7 08             	shl    $0x8,%edi
80104f80:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f82:	89 d7                	mov    %edx,%edi
80104f84:	fc                   	cld    
80104f85:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104f87:	5b                   	pop    %ebx
80104f88:	89 d0                	mov    %edx,%eax
80104f8a:	5f                   	pop    %edi
80104f8b:	5d                   	pop    %ebp
80104f8c:	c3                   	ret    
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104f90:	89 d7                	mov    %edx,%edi
80104f92:	fc                   	cld    
80104f93:	f3 aa                	rep stos %al,%es:(%edi)
80104f95:	5b                   	pop    %ebx
80104f96:	89 d0                	mov    %edx,%eax
80104f98:	5f                   	pop    %edi
80104f99:	5d                   	pop    %ebp
80104f9a:	c3                   	ret    
80104f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f9f:	90                   	nop

80104fa0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104fa0:	f3 0f 1e fb          	endbr32 
80104fa4:	55                   	push   %ebp
80104fa5:	89 e5                	mov    %esp,%ebp
80104fa7:	56                   	push   %esi
80104fa8:	8b 75 10             	mov    0x10(%ebp),%esi
80104fab:	8b 55 08             	mov    0x8(%ebp),%edx
80104fae:	53                   	push   %ebx
80104faf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104fb2:	85 f6                	test   %esi,%esi
80104fb4:	74 2a                	je     80104fe0 <memcmp+0x40>
80104fb6:	01 c6                	add    %eax,%esi
80104fb8:	eb 10                	jmp    80104fca <memcmp+0x2a>
80104fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104fc0:	83 c0 01             	add    $0x1,%eax
80104fc3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104fc6:	39 f0                	cmp    %esi,%eax
80104fc8:	74 16                	je     80104fe0 <memcmp+0x40>
    if(*s1 != *s2)
80104fca:	0f b6 0a             	movzbl (%edx),%ecx
80104fcd:	0f b6 18             	movzbl (%eax),%ebx
80104fd0:	38 d9                	cmp    %bl,%cl
80104fd2:	74 ec                	je     80104fc0 <memcmp+0x20>
      return *s1 - *s2;
80104fd4:	0f b6 c1             	movzbl %cl,%eax
80104fd7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104fd9:	5b                   	pop    %ebx
80104fda:	5e                   	pop    %esi
80104fdb:	5d                   	pop    %ebp
80104fdc:	c3                   	ret    
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
80104fe0:	5b                   	pop    %ebx
  return 0;
80104fe1:	31 c0                	xor    %eax,%eax
}
80104fe3:	5e                   	pop    %esi
80104fe4:	5d                   	pop    %ebp
80104fe5:	c3                   	ret    
80104fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fed:	8d 76 00             	lea    0x0(%esi),%esi

80104ff0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	57                   	push   %edi
80104ff8:	8b 55 08             	mov    0x8(%ebp),%edx
80104ffb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ffe:	56                   	push   %esi
80104fff:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105002:	39 d6                	cmp    %edx,%esi
80105004:	73 2a                	jae    80105030 <memmove+0x40>
80105006:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105009:	39 fa                	cmp    %edi,%edx
8010500b:	73 23                	jae    80105030 <memmove+0x40>
8010500d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105010:	85 c9                	test   %ecx,%ecx
80105012:	74 13                	je     80105027 <memmove+0x37>
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105018:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010501c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010501f:	83 e8 01             	sub    $0x1,%eax
80105022:	83 f8 ff             	cmp    $0xffffffff,%eax
80105025:	75 f1                	jne    80105018 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105027:	5e                   	pop    %esi
80105028:	89 d0                	mov    %edx,%eax
8010502a:	5f                   	pop    %edi
8010502b:	5d                   	pop    %ebp
8010502c:	c3                   	ret    
8010502d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105030:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105033:	89 d7                	mov    %edx,%edi
80105035:	85 c9                	test   %ecx,%ecx
80105037:	74 ee                	je     80105027 <memmove+0x37>
80105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105040:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105041:	39 f0                	cmp    %esi,%eax
80105043:	75 fb                	jne    80105040 <memmove+0x50>
}
80105045:	5e                   	pop    %esi
80105046:	89 d0                	mov    %edx,%eax
80105048:	5f                   	pop    %edi
80105049:	5d                   	pop    %ebp
8010504a:	c3                   	ret    
8010504b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010504f:	90                   	nop

80105050 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105050:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105054:	eb 9a                	jmp    80104ff0 <memmove>
80105056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505d:	8d 76 00             	lea    0x0(%esi),%esi

80105060 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105060:	f3 0f 1e fb          	endbr32 
80105064:	55                   	push   %ebp
80105065:	89 e5                	mov    %esp,%ebp
80105067:	56                   	push   %esi
80105068:	8b 75 10             	mov    0x10(%ebp),%esi
8010506b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010506e:	53                   	push   %ebx
8010506f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105072:	85 f6                	test   %esi,%esi
80105074:	74 32                	je     801050a8 <strncmp+0x48>
80105076:	01 c6                	add    %eax,%esi
80105078:	eb 14                	jmp    8010508e <strncmp+0x2e>
8010507a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105080:	38 da                	cmp    %bl,%dl
80105082:	75 14                	jne    80105098 <strncmp+0x38>
    n--, p++, q++;
80105084:	83 c0 01             	add    $0x1,%eax
80105087:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010508a:	39 f0                	cmp    %esi,%eax
8010508c:	74 1a                	je     801050a8 <strncmp+0x48>
8010508e:	0f b6 11             	movzbl (%ecx),%edx
80105091:	0f b6 18             	movzbl (%eax),%ebx
80105094:	84 d2                	test   %dl,%dl
80105096:	75 e8                	jne    80105080 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105098:	0f b6 c2             	movzbl %dl,%eax
8010509b:	29 d8                	sub    %ebx,%eax
}
8010509d:	5b                   	pop    %ebx
8010509e:	5e                   	pop    %esi
8010509f:	5d                   	pop    %ebp
801050a0:	c3                   	ret    
801050a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050a8:	5b                   	pop    %ebx
    return 0;
801050a9:	31 c0                	xor    %eax,%eax
}
801050ab:	5e                   	pop    %esi
801050ac:	5d                   	pop    %ebp
801050ad:	c3                   	ret    
801050ae:	66 90                	xchg   %ax,%ax

801050b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801050b0:	f3 0f 1e fb          	endbr32 
801050b4:	55                   	push   %ebp
801050b5:	89 e5                	mov    %esp,%ebp
801050b7:	57                   	push   %edi
801050b8:	56                   	push   %esi
801050b9:	8b 75 08             	mov    0x8(%ebp),%esi
801050bc:	53                   	push   %ebx
801050bd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801050c0:	89 f2                	mov    %esi,%edx
801050c2:	eb 1b                	jmp    801050df <strncpy+0x2f>
801050c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050c8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801050cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801050cf:	83 c2 01             	add    $0x1,%edx
801050d2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801050d6:	89 f9                	mov    %edi,%ecx
801050d8:	88 4a ff             	mov    %cl,-0x1(%edx)
801050db:	84 c9                	test   %cl,%cl
801050dd:	74 09                	je     801050e8 <strncpy+0x38>
801050df:	89 c3                	mov    %eax,%ebx
801050e1:	83 e8 01             	sub    $0x1,%eax
801050e4:	85 db                	test   %ebx,%ebx
801050e6:	7f e0                	jg     801050c8 <strncpy+0x18>
    ;
  while(n-- > 0)
801050e8:	89 d1                	mov    %edx,%ecx
801050ea:	85 c0                	test   %eax,%eax
801050ec:	7e 15                	jle    80105103 <strncpy+0x53>
801050ee:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801050f0:	83 c1 01             	add    $0x1,%ecx
801050f3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801050f7:	89 c8                	mov    %ecx,%eax
801050f9:	f7 d0                	not    %eax
801050fb:	01 d0                	add    %edx,%eax
801050fd:	01 d8                	add    %ebx,%eax
801050ff:	85 c0                	test   %eax,%eax
80105101:	7f ed                	jg     801050f0 <strncpy+0x40>
  return os;
}
80105103:	5b                   	pop    %ebx
80105104:	89 f0                	mov    %esi,%eax
80105106:	5e                   	pop    %esi
80105107:	5f                   	pop    %edi
80105108:	5d                   	pop    %ebp
80105109:	c3                   	ret    
8010510a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105110 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105110:	f3 0f 1e fb          	endbr32 
80105114:	55                   	push   %ebp
80105115:	89 e5                	mov    %esp,%ebp
80105117:	56                   	push   %esi
80105118:	8b 55 10             	mov    0x10(%ebp),%edx
8010511b:	8b 75 08             	mov    0x8(%ebp),%esi
8010511e:	53                   	push   %ebx
8010511f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105122:	85 d2                	test   %edx,%edx
80105124:	7e 21                	jle    80105147 <safestrcpy+0x37>
80105126:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010512a:	89 f2                	mov    %esi,%edx
8010512c:	eb 12                	jmp    80105140 <safestrcpy+0x30>
8010512e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105130:	0f b6 08             	movzbl (%eax),%ecx
80105133:	83 c0 01             	add    $0x1,%eax
80105136:	83 c2 01             	add    $0x1,%edx
80105139:	88 4a ff             	mov    %cl,-0x1(%edx)
8010513c:	84 c9                	test   %cl,%cl
8010513e:	74 04                	je     80105144 <safestrcpy+0x34>
80105140:	39 d8                	cmp    %ebx,%eax
80105142:	75 ec                	jne    80105130 <safestrcpy+0x20>
    ;
  *s = 0;
80105144:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105147:	89 f0                	mov    %esi,%eax
80105149:	5b                   	pop    %ebx
8010514a:	5e                   	pop    %esi
8010514b:	5d                   	pop    %ebp
8010514c:	c3                   	ret    
8010514d:	8d 76 00             	lea    0x0(%esi),%esi

80105150 <strlen>:

int
strlen(const char *s)
{
80105150:	f3 0f 1e fb          	endbr32 
80105154:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105155:	31 c0                	xor    %eax,%eax
{
80105157:	89 e5                	mov    %esp,%ebp
80105159:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010515c:	80 3a 00             	cmpb   $0x0,(%edx)
8010515f:	74 10                	je     80105171 <strlen+0x21>
80105161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105168:	83 c0 01             	add    $0x1,%eax
8010516b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010516f:	75 f7                	jne    80105168 <strlen+0x18>
    ;
  return n;
}
80105171:	5d                   	pop    %ebp
80105172:	c3                   	ret    

80105173 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105173:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105177:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010517b:	55                   	push   %ebp
  pushl %ebx
8010517c:	53                   	push   %ebx
  pushl %esi
8010517d:	56                   	push   %esi
  pushl %edi
8010517e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010517f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105181:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105183:	5f                   	pop    %edi
  popl %esi
80105184:	5e                   	pop    %esi
  popl %ebx
80105185:	5b                   	pop    %ebx
  popl %ebp
80105186:	5d                   	pop    %ebp
  ret
80105187:	c3                   	ret    
80105188:	66 90                	xchg   %ax,%ax
8010518a:	66 90                	xchg   %ax,%ax
8010518c:	66 90                	xchg   %ax,%ax
8010518e:	66 90                	xchg   %ax,%ax

80105190 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105190:	f3 0f 1e fb          	endbr32 
80105194:	55                   	push   %ebp
80105195:	89 e5                	mov    %esp,%ebp
80105197:	53                   	push   %ebx
80105198:	83 ec 04             	sub    $0x4,%esp
8010519b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010519e:	e8 ad f0 ff ff       	call   80104250 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051a3:	8b 00                	mov    (%eax),%eax
801051a5:	39 d8                	cmp    %ebx,%eax
801051a7:	76 17                	jbe    801051c0 <fetchint+0x30>
801051a9:	8d 53 04             	lea    0x4(%ebx),%edx
801051ac:	39 d0                	cmp    %edx,%eax
801051ae:	72 10                	jb     801051c0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801051b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801051b3:	8b 13                	mov    (%ebx),%edx
801051b5:	89 10                	mov    %edx,(%eax)
  return 0;
801051b7:	31 c0                	xor    %eax,%eax
}
801051b9:	83 c4 04             	add    $0x4,%esp
801051bc:	5b                   	pop    %ebx
801051bd:	5d                   	pop    %ebp
801051be:	c3                   	ret    
801051bf:	90                   	nop
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c5:	eb f2                	jmp    801051b9 <fetchint+0x29>
801051c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ce:	66 90                	xchg   %ax,%ax

801051d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801051d0:	f3 0f 1e fb          	endbr32 
801051d4:	55                   	push   %ebp
801051d5:	89 e5                	mov    %esp,%ebp
801051d7:	53                   	push   %ebx
801051d8:	83 ec 04             	sub    $0x4,%esp
801051db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801051de:	e8 6d f0 ff ff       	call   80104250 <myproc>

  if(addr >= curproc->sz)
801051e3:	39 18                	cmp    %ebx,(%eax)
801051e5:	76 31                	jbe    80105218 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801051e7:	8b 55 0c             	mov    0xc(%ebp),%edx
801051ea:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801051ec:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801051ee:	39 d3                	cmp    %edx,%ebx
801051f0:	73 26                	jae    80105218 <fetchstr+0x48>
801051f2:	89 d8                	mov    %ebx,%eax
801051f4:	eb 11                	jmp    80105207 <fetchstr+0x37>
801051f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051fd:	8d 76 00             	lea    0x0(%esi),%esi
80105200:	83 c0 01             	add    $0x1,%eax
80105203:	39 c2                	cmp    %eax,%edx
80105205:	76 11                	jbe    80105218 <fetchstr+0x48>
    if(*s == 0)
80105207:	80 38 00             	cmpb   $0x0,(%eax)
8010520a:	75 f4                	jne    80105200 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010520c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010520f:	29 d8                	sub    %ebx,%eax
}
80105211:	5b                   	pop    %ebx
80105212:	5d                   	pop    %ebp
80105213:	c3                   	ret    
80105214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105218:	83 c4 04             	add    $0x4,%esp
    return -1;
8010521b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105220:	5b                   	pop    %ebx
80105221:	5d                   	pop    %ebp
80105222:	c3                   	ret    
80105223:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010522a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105230 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105230:	f3 0f 1e fb          	endbr32 
80105234:	55                   	push   %ebp
80105235:	89 e5                	mov    %esp,%ebp
80105237:	56                   	push   %esi
80105238:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105239:	e8 12 f0 ff ff       	call   80104250 <myproc>
8010523e:	8b 55 08             	mov    0x8(%ebp),%edx
80105241:	8b 40 18             	mov    0x18(%eax),%eax
80105244:	8b 40 44             	mov    0x44(%eax),%eax
80105247:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010524a:	e8 01 f0 ff ff       	call   80104250 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010524f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105252:	8b 00                	mov    (%eax),%eax
80105254:	39 c6                	cmp    %eax,%esi
80105256:	73 18                	jae    80105270 <argint+0x40>
80105258:	8d 53 08             	lea    0x8(%ebx),%edx
8010525b:	39 d0                	cmp    %edx,%eax
8010525d:	72 11                	jb     80105270 <argint+0x40>
  *ip = *(int*)(addr);
8010525f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105262:	8b 53 04             	mov    0x4(%ebx),%edx
80105265:	89 10                	mov    %edx,(%eax)
  return 0;
80105267:	31 c0                	xor    %eax,%eax
}
80105269:	5b                   	pop    %ebx
8010526a:	5e                   	pop    %esi
8010526b:	5d                   	pop    %ebp
8010526c:	c3                   	ret    
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105275:	eb f2                	jmp    80105269 <argint+0x39>
80105277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527e:	66 90                	xchg   %ax,%ax

80105280 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105280:	f3 0f 1e fb          	endbr32 
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
80105287:	56                   	push   %esi
80105288:	53                   	push   %ebx
80105289:	83 ec 10             	sub    $0x10,%esp
8010528c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010528f:	e8 bc ef ff ff       	call   80104250 <myproc>
 
  if(argint(n, &i) < 0)
80105294:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105297:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105299:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010529c:	50                   	push   %eax
8010529d:	ff 75 08             	pushl  0x8(%ebp)
801052a0:	e8 8b ff ff ff       	call   80105230 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801052a5:	83 c4 10             	add    $0x10,%esp
801052a8:	85 c0                	test   %eax,%eax
801052aa:	78 24                	js     801052d0 <argptr+0x50>
801052ac:	85 db                	test   %ebx,%ebx
801052ae:	78 20                	js     801052d0 <argptr+0x50>
801052b0:	8b 16                	mov    (%esi),%edx
801052b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b5:	39 c2                	cmp    %eax,%edx
801052b7:	76 17                	jbe    801052d0 <argptr+0x50>
801052b9:	01 c3                	add    %eax,%ebx
801052bb:	39 da                	cmp    %ebx,%edx
801052bd:	72 11                	jb     801052d0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801052bf:	8b 55 0c             	mov    0xc(%ebp),%edx
801052c2:	89 02                	mov    %eax,(%edx)
  return 0;
801052c4:	31 c0                	xor    %eax,%eax
}
801052c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052c9:	5b                   	pop    %ebx
801052ca:	5e                   	pop    %esi
801052cb:	5d                   	pop    %ebp
801052cc:	c3                   	ret    
801052cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d5:	eb ef                	jmp    801052c6 <argptr+0x46>
801052d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052de:	66 90                	xchg   %ax,%ax

801052e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801052e0:	f3 0f 1e fb          	endbr32 
801052e4:	55                   	push   %ebp
801052e5:	89 e5                	mov    %esp,%ebp
801052e7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801052ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ed:	50                   	push   %eax
801052ee:	ff 75 08             	pushl  0x8(%ebp)
801052f1:	e8 3a ff ff ff       	call   80105230 <argint>
801052f6:	83 c4 10             	add    $0x10,%esp
801052f9:	85 c0                	test   %eax,%eax
801052fb:	78 13                	js     80105310 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801052fd:	83 ec 08             	sub    $0x8,%esp
80105300:	ff 75 0c             	pushl  0xc(%ebp)
80105303:	ff 75 f4             	pushl  -0xc(%ebp)
80105306:	e8 c5 fe ff ff       	call   801051d0 <fetchstr>
8010530b:	83 c4 10             	add    $0x10,%esp
}
8010530e:	c9                   	leave  
8010530f:	c3                   	ret    
80105310:	c9                   	leave  
    return -1;
80105311:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105316:	c3                   	ret    
80105317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531e:	66 90                	xchg   %ax,%ax

80105320 <syscall>:
[SYS_swapstat] sys_swapstat,
};

void
syscall(void)
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
80105325:	89 e5                	mov    %esp,%ebp
80105327:	53                   	push   %ebx
80105328:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010532b:	e8 20 ef ff ff       	call   80104250 <myproc>
80105330:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105332:	8b 40 18             	mov    0x18(%eax),%eax
80105335:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105338:	8d 50 ff             	lea    -0x1(%eax),%edx
8010533b:	83 fa 17             	cmp    $0x17,%edx
8010533e:	77 20                	ja     80105360 <syscall+0x40>
80105340:	8b 14 85 80 87 10 80 	mov    -0x7fef7880(,%eax,4),%edx
80105347:	85 d2                	test   %edx,%edx
80105349:	74 15                	je     80105360 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010534b:	ff d2                	call   *%edx
8010534d:	89 c2                	mov    %eax,%edx
8010534f:	8b 43 18             	mov    0x18(%ebx),%eax
80105352:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105358:	c9                   	leave  
80105359:	c3                   	ret    
8010535a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105360:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105361:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105364:	50                   	push   %eax
80105365:	ff 73 10             	pushl  0x10(%ebx)
80105368:	68 59 87 10 80       	push   $0x80108759
8010536d:	e8 3e b3 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105372:	8b 43 18             	mov    0x18(%ebx),%eax
80105375:	83 c4 10             	add    $0x10,%esp
80105378:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010537f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105382:	c9                   	leave  
80105383:	c3                   	ret    
80105384:	66 90                	xchg   %ax,%ax
80105386:	66 90                	xchg   %ax,%ax
80105388:	66 90                	xchg   %ax,%ax
8010538a:	66 90                	xchg   %ax,%ax
8010538c:	66 90                	xchg   %ax,%ax
8010538e:	66 90                	xchg   %ax,%ax

80105390 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105395:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105398:	53                   	push   %ebx
80105399:	83 ec 44             	sub    $0x44,%esp
8010539c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010539f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801053a2:	57                   	push   %edi
801053a3:	50                   	push   %eax
{
801053a4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801053a7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801053aa:	e8 a1 cc ff ff       	call   80102050 <nameiparent>
801053af:	83 c4 10             	add    $0x10,%esp
801053b2:	85 c0                	test   %eax,%eax
801053b4:	0f 84 46 01 00 00    	je     80105500 <create+0x170>
    return 0;
  ilock(dp);
801053ba:	83 ec 0c             	sub    $0xc,%esp
801053bd:	89 c3                	mov    %eax,%ebx
801053bf:	50                   	push   %eax
801053c0:	e8 9b c3 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801053c5:	83 c4 0c             	add    $0xc,%esp
801053c8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801053cb:	50                   	push   %eax
801053cc:	57                   	push   %edi
801053cd:	53                   	push   %ebx
801053ce:	e8 dd c8 ff ff       	call   80101cb0 <dirlookup>
801053d3:	83 c4 10             	add    $0x10,%esp
801053d6:	89 c6                	mov    %eax,%esi
801053d8:	85 c0                	test   %eax,%eax
801053da:	74 54                	je     80105430 <create+0xa0>
    iunlockput(dp);
801053dc:	83 ec 0c             	sub    $0xc,%esp
801053df:	53                   	push   %ebx
801053e0:	e8 1b c6 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
801053e5:	89 34 24             	mov    %esi,(%esp)
801053e8:	e8 73 c3 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801053ed:	83 c4 10             	add    $0x10,%esp
801053f0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801053f5:	75 19                	jne    80105410 <create+0x80>
801053f7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801053fc:	75 12                	jne    80105410 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801053fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105401:	89 f0                	mov    %esi,%eax
80105403:	5b                   	pop    %ebx
80105404:	5e                   	pop    %esi
80105405:	5f                   	pop    %edi
80105406:	5d                   	pop    %ebp
80105407:	c3                   	ret    
80105408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540f:	90                   	nop
    iunlockput(ip);
80105410:	83 ec 0c             	sub    $0xc,%esp
80105413:	56                   	push   %esi
    return 0;
80105414:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105416:	e8 e5 c5 ff ff       	call   80101a00 <iunlockput>
    return 0;
8010541b:	83 c4 10             	add    $0x10,%esp
}
8010541e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105421:	89 f0                	mov    %esi,%eax
80105423:	5b                   	pop    %ebx
80105424:	5e                   	pop    %esi
80105425:	5f                   	pop    %edi
80105426:	5d                   	pop    %ebp
80105427:	c3                   	ret    
80105428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105430:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105434:	83 ec 08             	sub    $0x8,%esp
80105437:	50                   	push   %eax
80105438:	ff 33                	pushl  (%ebx)
8010543a:	e8 a1 c1 ff ff       	call   801015e0 <ialloc>
8010543f:	83 c4 10             	add    $0x10,%esp
80105442:	89 c6                	mov    %eax,%esi
80105444:	85 c0                	test   %eax,%eax
80105446:	0f 84 cd 00 00 00    	je     80105519 <create+0x189>
  ilock(ip);
8010544c:	83 ec 0c             	sub    $0xc,%esp
8010544f:	50                   	push   %eax
80105450:	e8 0b c3 ff ff       	call   80101760 <ilock>
  ip->major = major;
80105455:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105459:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010545d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105461:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105465:	b8 01 00 00 00       	mov    $0x1,%eax
8010546a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010546e:	89 34 24             	mov    %esi,(%esp)
80105471:	e8 2a c2 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105476:	83 c4 10             	add    $0x10,%esp
80105479:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010547e:	74 30                	je     801054b0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105480:	83 ec 04             	sub    $0x4,%esp
80105483:	ff 76 04             	pushl  0x4(%esi)
80105486:	57                   	push   %edi
80105487:	53                   	push   %ebx
80105488:	e8 e3 ca ff ff       	call   80101f70 <dirlink>
8010548d:	83 c4 10             	add    $0x10,%esp
80105490:	85 c0                	test   %eax,%eax
80105492:	78 78                	js     8010550c <create+0x17c>
  iunlockput(dp);
80105494:	83 ec 0c             	sub    $0xc,%esp
80105497:	53                   	push   %ebx
80105498:	e8 63 c5 ff ff       	call   80101a00 <iunlockput>
  return ip;
8010549d:	83 c4 10             	add    $0x10,%esp
}
801054a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054a3:	89 f0                	mov    %esi,%eax
801054a5:	5b                   	pop    %ebx
801054a6:	5e                   	pop    %esi
801054a7:	5f                   	pop    %edi
801054a8:	5d                   	pop    %ebp
801054a9:	c3                   	ret    
801054aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801054b0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801054b3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801054b8:	53                   	push   %ebx
801054b9:	e8 e2 c1 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801054be:	83 c4 0c             	add    $0xc,%esp
801054c1:	ff 76 04             	pushl  0x4(%esi)
801054c4:	68 00 88 10 80       	push   $0x80108800
801054c9:	56                   	push   %esi
801054ca:	e8 a1 ca ff ff       	call   80101f70 <dirlink>
801054cf:	83 c4 10             	add    $0x10,%esp
801054d2:	85 c0                	test   %eax,%eax
801054d4:	78 18                	js     801054ee <create+0x15e>
801054d6:	83 ec 04             	sub    $0x4,%esp
801054d9:	ff 73 04             	pushl  0x4(%ebx)
801054dc:	68 ff 87 10 80       	push   $0x801087ff
801054e1:	56                   	push   %esi
801054e2:	e8 89 ca ff ff       	call   80101f70 <dirlink>
801054e7:	83 c4 10             	add    $0x10,%esp
801054ea:	85 c0                	test   %eax,%eax
801054ec:	79 92                	jns    80105480 <create+0xf0>
      panic("create dots");
801054ee:	83 ec 0c             	sub    $0xc,%esp
801054f1:	68 f3 87 10 80       	push   $0x801087f3
801054f6:	e8 95 ae ff ff       	call   80100390 <panic>
801054fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054ff:	90                   	nop
}
80105500:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105503:	31 f6                	xor    %esi,%esi
}
80105505:	5b                   	pop    %ebx
80105506:	89 f0                	mov    %esi,%eax
80105508:	5e                   	pop    %esi
80105509:	5f                   	pop    %edi
8010550a:	5d                   	pop    %ebp
8010550b:	c3                   	ret    
    panic("create: dirlink");
8010550c:	83 ec 0c             	sub    $0xc,%esp
8010550f:	68 02 88 10 80       	push   $0x80108802
80105514:	e8 77 ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105519:	83 ec 0c             	sub    $0xc,%esp
8010551c:	68 e4 87 10 80       	push   $0x801087e4
80105521:	e8 6a ae ff ff       	call   80100390 <panic>
80105526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552d:	8d 76 00             	lea    0x0(%esi),%esi

80105530 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	56                   	push   %esi
80105534:	89 d6                	mov    %edx,%esi
80105536:	53                   	push   %ebx
80105537:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105539:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010553c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010553f:	50                   	push   %eax
80105540:	6a 00                	push   $0x0
80105542:	e8 e9 fc ff ff       	call   80105230 <argint>
80105547:	83 c4 10             	add    $0x10,%esp
8010554a:	85 c0                	test   %eax,%eax
8010554c:	78 2a                	js     80105578 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010554e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105552:	77 24                	ja     80105578 <argfd.constprop.0+0x48>
80105554:	e8 f7 ec ff ff       	call   80104250 <myproc>
80105559:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010555c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105560:	85 c0                	test   %eax,%eax
80105562:	74 14                	je     80105578 <argfd.constprop.0+0x48>
  if(pfd)
80105564:	85 db                	test   %ebx,%ebx
80105566:	74 02                	je     8010556a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105568:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010556a:	89 06                	mov    %eax,(%esi)
  return 0;
8010556c:	31 c0                	xor    %eax,%eax
}
8010556e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105571:	5b                   	pop    %ebx
80105572:	5e                   	pop    %esi
80105573:	5d                   	pop    %ebp
80105574:	c3                   	ret    
80105575:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557d:	eb ef                	jmp    8010556e <argfd.constprop.0+0x3e>
8010557f:	90                   	nop

80105580 <sys_dup>:
{
80105580:	f3 0f 1e fb          	endbr32 
80105584:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105585:	31 c0                	xor    %eax,%eax
{
80105587:	89 e5                	mov    %esp,%ebp
80105589:	56                   	push   %esi
8010558a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010558b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010558e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105591:	e8 9a ff ff ff       	call   80105530 <argfd.constprop.0>
80105596:	85 c0                	test   %eax,%eax
80105598:	78 1e                	js     801055b8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010559a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010559d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010559f:	e8 ac ec ff ff       	call   80104250 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801055a8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055ac:	85 d2                	test   %edx,%edx
801055ae:	74 20                	je     801055d0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801055b0:	83 c3 01             	add    $0x1,%ebx
801055b3:	83 fb 10             	cmp    $0x10,%ebx
801055b6:	75 f0                	jne    801055a8 <sys_dup+0x28>
}
801055b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801055bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801055c0:	89 d8                	mov    %ebx,%eax
801055c2:	5b                   	pop    %ebx
801055c3:	5e                   	pop    %esi
801055c4:	5d                   	pop    %ebp
801055c5:	c3                   	ret    
801055c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801055d0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801055d4:	83 ec 0c             	sub    $0xc,%esp
801055d7:	ff 75 f4             	pushl  -0xc(%ebp)
801055da:	e8 91 b8 ff ff       	call   80100e70 <filedup>
  return fd;
801055df:	83 c4 10             	add    $0x10,%esp
}
801055e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055e5:	89 d8                	mov    %ebx,%eax
801055e7:	5b                   	pop    %ebx
801055e8:	5e                   	pop    %esi
801055e9:	5d                   	pop    %ebp
801055ea:	c3                   	ret    
801055eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055ef:	90                   	nop

801055f0 <sys_read>:
{
801055f0:	f3 0f 1e fb          	endbr32 
801055f4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055f5:	31 c0                	xor    %eax,%eax
{
801055f7:	89 e5                	mov    %esp,%ebp
801055f9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055fc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055ff:	e8 2c ff ff ff       	call   80105530 <argfd.constprop.0>
80105604:	85 c0                	test   %eax,%eax
80105606:	78 48                	js     80105650 <sys_read+0x60>
80105608:	83 ec 08             	sub    $0x8,%esp
8010560b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010560e:	50                   	push   %eax
8010560f:	6a 02                	push   $0x2
80105611:	e8 1a fc ff ff       	call   80105230 <argint>
80105616:	83 c4 10             	add    $0x10,%esp
80105619:	85 c0                	test   %eax,%eax
8010561b:	78 33                	js     80105650 <sys_read+0x60>
8010561d:	83 ec 04             	sub    $0x4,%esp
80105620:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105623:	ff 75 f0             	pushl  -0x10(%ebp)
80105626:	50                   	push   %eax
80105627:	6a 01                	push   $0x1
80105629:	e8 52 fc ff ff       	call   80105280 <argptr>
8010562e:	83 c4 10             	add    $0x10,%esp
80105631:	85 c0                	test   %eax,%eax
80105633:	78 1b                	js     80105650 <sys_read+0x60>
  return fileread(f, p, n);
80105635:	83 ec 04             	sub    $0x4,%esp
80105638:	ff 75 f0             	pushl  -0x10(%ebp)
8010563b:	ff 75 f4             	pushl  -0xc(%ebp)
8010563e:	ff 75 ec             	pushl  -0x14(%ebp)
80105641:	e8 aa b9 ff ff       	call   80100ff0 <fileread>
80105646:	83 c4 10             	add    $0x10,%esp
}
80105649:	c9                   	leave  
8010564a:	c3                   	ret    
8010564b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010564f:	90                   	nop
80105650:	c9                   	leave  
    return -1;
80105651:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105656:	c3                   	ret    
80105657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565e:	66 90                	xchg   %ax,%ax

80105660 <sys_write>:
{
80105660:	f3 0f 1e fb          	endbr32 
80105664:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105665:	31 c0                	xor    %eax,%eax
{
80105667:	89 e5                	mov    %esp,%ebp
80105669:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010566c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010566f:	e8 bc fe ff ff       	call   80105530 <argfd.constprop.0>
80105674:	85 c0                	test   %eax,%eax
80105676:	78 48                	js     801056c0 <sys_write+0x60>
80105678:	83 ec 08             	sub    $0x8,%esp
8010567b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010567e:	50                   	push   %eax
8010567f:	6a 02                	push   $0x2
80105681:	e8 aa fb ff ff       	call   80105230 <argint>
80105686:	83 c4 10             	add    $0x10,%esp
80105689:	85 c0                	test   %eax,%eax
8010568b:	78 33                	js     801056c0 <sys_write+0x60>
8010568d:	83 ec 04             	sub    $0x4,%esp
80105690:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105693:	ff 75 f0             	pushl  -0x10(%ebp)
80105696:	50                   	push   %eax
80105697:	6a 01                	push   $0x1
80105699:	e8 e2 fb ff ff       	call   80105280 <argptr>
8010569e:	83 c4 10             	add    $0x10,%esp
801056a1:	85 c0                	test   %eax,%eax
801056a3:	78 1b                	js     801056c0 <sys_write+0x60>
  return filewrite(f, p, n);
801056a5:	83 ec 04             	sub    $0x4,%esp
801056a8:	ff 75 f0             	pushl  -0x10(%ebp)
801056ab:	ff 75 f4             	pushl  -0xc(%ebp)
801056ae:	ff 75 ec             	pushl  -0x14(%ebp)
801056b1:	e8 da b9 ff ff       	call   80101090 <filewrite>
801056b6:	83 c4 10             	add    $0x10,%esp
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

801056d0 <sys_close>:
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801056da:	8d 55 f4             	lea    -0xc(%ebp),%edx
801056dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056e0:	e8 4b fe ff ff       	call   80105530 <argfd.constprop.0>
801056e5:	85 c0                	test   %eax,%eax
801056e7:	78 27                	js     80105710 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801056e9:	e8 62 eb ff ff       	call   80104250 <myproc>
801056ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801056f1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801056f4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801056fb:	00 
  fileclose(f);
801056fc:	ff 75 f4             	pushl  -0xc(%ebp)
801056ff:	e8 bc b7 ff ff       	call   80100ec0 <fileclose>
  return 0;
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	31 c0                	xor    %eax,%eax
}
80105709:	c9                   	leave  
8010570a:	c3                   	ret    
8010570b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010570f:	90                   	nop
80105710:	c9                   	leave  
    return -1;
80105711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105716:	c3                   	ret    
80105717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571e:	66 90                	xchg   %ax,%ax

80105720 <sys_fstat>:
{
80105720:	f3 0f 1e fb          	endbr32 
80105724:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105725:	31 c0                	xor    %eax,%eax
{
80105727:	89 e5                	mov    %esp,%ebp
80105729:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010572c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010572f:	e8 fc fd ff ff       	call   80105530 <argfd.constprop.0>
80105734:	85 c0                	test   %eax,%eax
80105736:	78 30                	js     80105768 <sys_fstat+0x48>
80105738:	83 ec 04             	sub    $0x4,%esp
8010573b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010573e:	6a 14                	push   $0x14
80105740:	50                   	push   %eax
80105741:	6a 01                	push   $0x1
80105743:	e8 38 fb ff ff       	call   80105280 <argptr>
80105748:	83 c4 10             	add    $0x10,%esp
8010574b:	85 c0                	test   %eax,%eax
8010574d:	78 19                	js     80105768 <sys_fstat+0x48>
  return filestat(f, st);
8010574f:	83 ec 08             	sub    $0x8,%esp
80105752:	ff 75 f4             	pushl  -0xc(%ebp)
80105755:	ff 75 f0             	pushl  -0x10(%ebp)
80105758:	e8 43 b8 ff ff       	call   80100fa0 <filestat>
8010575d:	83 c4 10             	add    $0x10,%esp
}
80105760:	c9                   	leave  
80105761:	c3                   	ret    
80105762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105768:	c9                   	leave  
    return -1;
80105769:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010576e:	c3                   	ret    
8010576f:	90                   	nop

80105770 <sys_link>:
{
80105770:	f3 0f 1e fb          	endbr32 
80105774:	55                   	push   %ebp
80105775:	89 e5                	mov    %esp,%ebp
80105777:	57                   	push   %edi
80105778:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105779:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010577c:	53                   	push   %ebx
8010577d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105780:	50                   	push   %eax
80105781:	6a 00                	push   $0x0
80105783:	e8 58 fb ff ff       	call   801052e0 <argstr>
80105788:	83 c4 10             	add    $0x10,%esp
8010578b:	85 c0                	test   %eax,%eax
8010578d:	0f 88 ff 00 00 00    	js     80105892 <sys_link+0x122>
80105793:	83 ec 08             	sub    $0x8,%esp
80105796:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105799:	50                   	push   %eax
8010579a:	6a 01                	push   $0x1
8010579c:	e8 3f fb ff ff       	call   801052e0 <argstr>
801057a1:	83 c4 10             	add    $0x10,%esp
801057a4:	85 c0                	test   %eax,%eax
801057a6:	0f 88 e6 00 00 00    	js     80105892 <sys_link+0x122>
  begin_op();
801057ac:	e8 6f de ff ff       	call   80103620 <begin_op>
  if((ip = namei(old)) == 0){
801057b1:	83 ec 0c             	sub    $0xc,%esp
801057b4:	ff 75 d4             	pushl  -0x2c(%ebp)
801057b7:	e8 74 c8 ff ff       	call   80102030 <namei>
801057bc:	83 c4 10             	add    $0x10,%esp
801057bf:	89 c3                	mov    %eax,%ebx
801057c1:	85 c0                	test   %eax,%eax
801057c3:	0f 84 e8 00 00 00    	je     801058b1 <sys_link+0x141>
  ilock(ip);
801057c9:	83 ec 0c             	sub    $0xc,%esp
801057cc:	50                   	push   %eax
801057cd:	e8 8e bf ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
801057d2:	83 c4 10             	add    $0x10,%esp
801057d5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057da:	0f 84 b9 00 00 00    	je     80105899 <sys_link+0x129>
  iupdate(ip);
801057e0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801057e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801057e8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801057eb:	53                   	push   %ebx
801057ec:	e8 af be ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801057f1:	89 1c 24             	mov    %ebx,(%esp)
801057f4:	e8 47 c0 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801057f9:	58                   	pop    %eax
801057fa:	5a                   	pop    %edx
801057fb:	57                   	push   %edi
801057fc:	ff 75 d0             	pushl  -0x30(%ebp)
801057ff:	e8 4c c8 ff ff       	call   80102050 <nameiparent>
80105804:	83 c4 10             	add    $0x10,%esp
80105807:	89 c6                	mov    %eax,%esi
80105809:	85 c0                	test   %eax,%eax
8010580b:	74 5f                	je     8010586c <sys_link+0xfc>
  ilock(dp);
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	50                   	push   %eax
80105811:	e8 4a bf ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105816:	8b 03                	mov    (%ebx),%eax
80105818:	83 c4 10             	add    $0x10,%esp
8010581b:	39 06                	cmp    %eax,(%esi)
8010581d:	75 41                	jne    80105860 <sys_link+0xf0>
8010581f:	83 ec 04             	sub    $0x4,%esp
80105822:	ff 73 04             	pushl  0x4(%ebx)
80105825:	57                   	push   %edi
80105826:	56                   	push   %esi
80105827:	e8 44 c7 ff ff       	call   80101f70 <dirlink>
8010582c:	83 c4 10             	add    $0x10,%esp
8010582f:	85 c0                	test   %eax,%eax
80105831:	78 2d                	js     80105860 <sys_link+0xf0>
  iunlockput(dp);
80105833:	83 ec 0c             	sub    $0xc,%esp
80105836:	56                   	push   %esi
80105837:	e8 c4 c1 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
8010583c:	89 1c 24             	mov    %ebx,(%esp)
8010583f:	e8 4c c0 ff ff       	call   80101890 <iput>
  end_op();
80105844:	e8 47 de ff ff       	call   80103690 <end_op>
  return 0;
80105849:	83 c4 10             	add    $0x10,%esp
8010584c:	31 c0                	xor    %eax,%eax
}
8010584e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105851:	5b                   	pop    %ebx
80105852:	5e                   	pop    %esi
80105853:	5f                   	pop    %edi
80105854:	5d                   	pop    %ebp
80105855:	c3                   	ret    
80105856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105860:	83 ec 0c             	sub    $0xc,%esp
80105863:	56                   	push   %esi
80105864:	e8 97 c1 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105869:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010586c:	83 ec 0c             	sub    $0xc,%esp
8010586f:	53                   	push   %ebx
80105870:	e8 eb be ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105875:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010587a:	89 1c 24             	mov    %ebx,(%esp)
8010587d:	e8 1e be ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105882:	89 1c 24             	mov    %ebx,(%esp)
80105885:	e8 76 c1 ff ff       	call   80101a00 <iunlockput>
  end_op();
8010588a:	e8 01 de ff ff       	call   80103690 <end_op>
  return -1;
8010588f:	83 c4 10             	add    $0x10,%esp
80105892:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105897:	eb b5                	jmp    8010584e <sys_link+0xde>
    iunlockput(ip);
80105899:	83 ec 0c             	sub    $0xc,%esp
8010589c:	53                   	push   %ebx
8010589d:	e8 5e c1 ff ff       	call   80101a00 <iunlockput>
    end_op();
801058a2:	e8 e9 dd ff ff       	call   80103690 <end_op>
    return -1;
801058a7:	83 c4 10             	add    $0x10,%esp
801058aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058af:	eb 9d                	jmp    8010584e <sys_link+0xde>
    end_op();
801058b1:	e8 da dd ff ff       	call   80103690 <end_op>
    return -1;
801058b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058bb:	eb 91                	jmp    8010584e <sys_link+0xde>
801058bd:	8d 76 00             	lea    0x0(%esi),%esi

801058c0 <sys_unlink>:
{
801058c0:	f3 0f 1e fb          	endbr32 
801058c4:	55                   	push   %ebp
801058c5:	89 e5                	mov    %esp,%ebp
801058c7:	57                   	push   %edi
801058c8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801058c9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801058cc:	53                   	push   %ebx
801058cd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801058d0:	50                   	push   %eax
801058d1:	6a 00                	push   $0x0
801058d3:	e8 08 fa ff ff       	call   801052e0 <argstr>
801058d8:	83 c4 10             	add    $0x10,%esp
801058db:	85 c0                	test   %eax,%eax
801058dd:	0f 88 7d 01 00 00    	js     80105a60 <sys_unlink+0x1a0>
  begin_op();
801058e3:	e8 38 dd ff ff       	call   80103620 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058e8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801058eb:	83 ec 08             	sub    $0x8,%esp
801058ee:	53                   	push   %ebx
801058ef:	ff 75 c0             	pushl  -0x40(%ebp)
801058f2:	e8 59 c7 ff ff       	call   80102050 <nameiparent>
801058f7:	83 c4 10             	add    $0x10,%esp
801058fa:	89 c6                	mov    %eax,%esi
801058fc:	85 c0                	test   %eax,%eax
801058fe:	0f 84 66 01 00 00    	je     80105a6a <sys_unlink+0x1aa>
  ilock(dp);
80105904:	83 ec 0c             	sub    $0xc,%esp
80105907:	50                   	push   %eax
80105908:	e8 53 be ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010590d:	58                   	pop    %eax
8010590e:	5a                   	pop    %edx
8010590f:	68 00 88 10 80       	push   $0x80108800
80105914:	53                   	push   %ebx
80105915:	e8 76 c3 ff ff       	call   80101c90 <namecmp>
8010591a:	83 c4 10             	add    $0x10,%esp
8010591d:	85 c0                	test   %eax,%eax
8010591f:	0f 84 03 01 00 00    	je     80105a28 <sys_unlink+0x168>
80105925:	83 ec 08             	sub    $0x8,%esp
80105928:	68 ff 87 10 80       	push   $0x801087ff
8010592d:	53                   	push   %ebx
8010592e:	e8 5d c3 ff ff       	call   80101c90 <namecmp>
80105933:	83 c4 10             	add    $0x10,%esp
80105936:	85 c0                	test   %eax,%eax
80105938:	0f 84 ea 00 00 00    	je     80105a28 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010593e:	83 ec 04             	sub    $0x4,%esp
80105941:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105944:	50                   	push   %eax
80105945:	53                   	push   %ebx
80105946:	56                   	push   %esi
80105947:	e8 64 c3 ff ff       	call   80101cb0 <dirlookup>
8010594c:	83 c4 10             	add    $0x10,%esp
8010594f:	89 c3                	mov    %eax,%ebx
80105951:	85 c0                	test   %eax,%eax
80105953:	0f 84 cf 00 00 00    	je     80105a28 <sys_unlink+0x168>
  ilock(ip);
80105959:	83 ec 0c             	sub    $0xc,%esp
8010595c:	50                   	push   %eax
8010595d:	e8 fe bd ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010596a:	0f 8e 23 01 00 00    	jle    80105a93 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105970:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105975:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105978:	74 66                	je     801059e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010597a:	83 ec 04             	sub    $0x4,%esp
8010597d:	6a 10                	push   $0x10
8010597f:	6a 00                	push   $0x0
80105981:	57                   	push   %edi
80105982:	e8 c9 f5 ff ff       	call   80104f50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105987:	6a 10                	push   $0x10
80105989:	ff 75 c4             	pushl  -0x3c(%ebp)
8010598c:	57                   	push   %edi
8010598d:	56                   	push   %esi
8010598e:	e8 cd c1 ff ff       	call   80101b60 <writei>
80105993:	83 c4 20             	add    $0x20,%esp
80105996:	83 f8 10             	cmp    $0x10,%eax
80105999:	0f 85 e7 00 00 00    	jne    80105a86 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010599f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059a4:	0f 84 96 00 00 00    	je     80105a40 <sys_unlink+0x180>
  iunlockput(dp);
801059aa:	83 ec 0c             	sub    $0xc,%esp
801059ad:	56                   	push   %esi
801059ae:	e8 4d c0 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
801059b3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801059b8:	89 1c 24             	mov    %ebx,(%esp)
801059bb:	e8 e0 bc ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801059c0:	89 1c 24             	mov    %ebx,(%esp)
801059c3:	e8 38 c0 ff ff       	call   80101a00 <iunlockput>
  end_op();
801059c8:	e8 c3 dc ff ff       	call   80103690 <end_op>
  return 0;
801059cd:	83 c4 10             	add    $0x10,%esp
801059d0:	31 c0                	xor    %eax,%eax
}
801059d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059d5:	5b                   	pop    %ebx
801059d6:	5e                   	pop    %esi
801059d7:	5f                   	pop    %edi
801059d8:	5d                   	pop    %ebp
801059d9:	c3                   	ret    
801059da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801059e4:	76 94                	jbe    8010597a <sys_unlink+0xba>
801059e6:	ba 20 00 00 00       	mov    $0x20,%edx
801059eb:	eb 0b                	jmp    801059f8 <sys_unlink+0x138>
801059ed:	8d 76 00             	lea    0x0(%esi),%esi
801059f0:	83 c2 10             	add    $0x10,%edx
801059f3:	39 53 58             	cmp    %edx,0x58(%ebx)
801059f6:	76 82                	jbe    8010597a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059f8:	6a 10                	push   $0x10
801059fa:	52                   	push   %edx
801059fb:	57                   	push   %edi
801059fc:	53                   	push   %ebx
801059fd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105a00:	e8 5b c0 ff ff       	call   80101a60 <readi>
80105a05:	83 c4 10             	add    $0x10,%esp
80105a08:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105a0b:	83 f8 10             	cmp    $0x10,%eax
80105a0e:	75 69                	jne    80105a79 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105a10:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105a15:	74 d9                	je     801059f0 <sys_unlink+0x130>
    iunlockput(ip);
80105a17:	83 ec 0c             	sub    $0xc,%esp
80105a1a:	53                   	push   %ebx
80105a1b:	e8 e0 bf ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105a20:	83 c4 10             	add    $0x10,%esp
80105a23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a27:	90                   	nop
  iunlockput(dp);
80105a28:	83 ec 0c             	sub    $0xc,%esp
80105a2b:	56                   	push   %esi
80105a2c:	e8 cf bf ff ff       	call   80101a00 <iunlockput>
  end_op();
80105a31:	e8 5a dc ff ff       	call   80103690 <end_op>
  return -1;
80105a36:	83 c4 10             	add    $0x10,%esp
80105a39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3e:	eb 92                	jmp    801059d2 <sys_unlink+0x112>
    iupdate(dp);
80105a40:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105a43:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105a48:	56                   	push   %esi
80105a49:	e8 52 bc ff ff       	call   801016a0 <iupdate>
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	e9 54 ff ff ff       	jmp    801059aa <sys_unlink+0xea>
80105a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a65:	e9 68 ff ff ff       	jmp    801059d2 <sys_unlink+0x112>
    end_op();
80105a6a:	e8 21 dc ff ff       	call   80103690 <end_op>
    return -1;
80105a6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a74:	e9 59 ff ff ff       	jmp    801059d2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105a79:	83 ec 0c             	sub    $0xc,%esp
80105a7c:	68 24 88 10 80       	push   $0x80108824
80105a81:	e8 0a a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105a86:	83 ec 0c             	sub    $0xc,%esp
80105a89:	68 36 88 10 80       	push   $0x80108836
80105a8e:	e8 fd a8 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a93:	83 ec 0c             	sub    $0xc,%esp
80105a96:	68 12 88 10 80       	push   $0x80108812
80105a9b:	e8 f0 a8 ff ff       	call   80100390 <panic>

80105aa0 <sys_open>:

int
sys_open(void)
{
80105aa0:	f3 0f 1e fb          	endbr32 
80105aa4:	55                   	push   %ebp
80105aa5:	89 e5                	mov    %esp,%ebp
80105aa7:	57                   	push   %edi
80105aa8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105aa9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105aac:	53                   	push   %ebx
80105aad:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ab0:	50                   	push   %eax
80105ab1:	6a 00                	push   $0x0
80105ab3:	e8 28 f8 ff ff       	call   801052e0 <argstr>
80105ab8:	83 c4 10             	add    $0x10,%esp
80105abb:	85 c0                	test   %eax,%eax
80105abd:	0f 88 8a 00 00 00    	js     80105b4d <sys_open+0xad>
80105ac3:	83 ec 08             	sub    $0x8,%esp
80105ac6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ac9:	50                   	push   %eax
80105aca:	6a 01                	push   $0x1
80105acc:	e8 5f f7 ff ff       	call   80105230 <argint>
80105ad1:	83 c4 10             	add    $0x10,%esp
80105ad4:	85 c0                	test   %eax,%eax
80105ad6:	78 75                	js     80105b4d <sys_open+0xad>
    return -1;

  begin_op();
80105ad8:	e8 43 db ff ff       	call   80103620 <begin_op>

  if(omode & O_CREATE){
80105add:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ae1:	75 75                	jne    80105b58 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105ae3:	83 ec 0c             	sub    $0xc,%esp
80105ae6:	ff 75 e0             	pushl  -0x20(%ebp)
80105ae9:	e8 42 c5 ff ff       	call   80102030 <namei>
80105aee:	83 c4 10             	add    $0x10,%esp
80105af1:	89 c6                	mov    %eax,%esi
80105af3:	85 c0                	test   %eax,%eax
80105af5:	74 7e                	je     80105b75 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105af7:	83 ec 0c             	sub    $0xc,%esp
80105afa:	50                   	push   %eax
80105afb:	e8 60 bc ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b00:	83 c4 10             	add    $0x10,%esp
80105b03:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b08:	0f 84 c2 00 00 00    	je     80105bd0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b0e:	e8 ed b2 ff ff       	call   80100e00 <filealloc>
80105b13:	89 c7                	mov    %eax,%edi
80105b15:	85 c0                	test   %eax,%eax
80105b17:	74 23                	je     80105b3c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105b19:	e8 32 e7 ff ff       	call   80104250 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b1e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105b20:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b24:	85 d2                	test   %edx,%edx
80105b26:	74 60                	je     80105b88 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105b28:	83 c3 01             	add    $0x1,%ebx
80105b2b:	83 fb 10             	cmp    $0x10,%ebx
80105b2e:	75 f0                	jne    80105b20 <sys_open+0x80>
    if(f)
      fileclose(f);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	57                   	push   %edi
80105b34:	e8 87 b3 ff ff       	call   80100ec0 <fileclose>
80105b39:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105b3c:	83 ec 0c             	sub    $0xc,%esp
80105b3f:	56                   	push   %esi
80105b40:	e8 bb be ff ff       	call   80101a00 <iunlockput>
    end_op();
80105b45:	e8 46 db ff ff       	call   80103690 <end_op>
    return -1;
80105b4a:	83 c4 10             	add    $0x10,%esp
80105b4d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b52:	eb 6d                	jmp    80105bc1 <sys_open+0x121>
80105b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105b58:	83 ec 0c             	sub    $0xc,%esp
80105b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b5e:	31 c9                	xor    %ecx,%ecx
80105b60:	ba 02 00 00 00       	mov    $0x2,%edx
80105b65:	6a 00                	push   $0x0
80105b67:	e8 24 f8 ff ff       	call   80105390 <create>
    if(ip == 0){
80105b6c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105b6f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b71:	85 c0                	test   %eax,%eax
80105b73:	75 99                	jne    80105b0e <sys_open+0x6e>
      end_op();
80105b75:	e8 16 db ff ff       	call   80103690 <end_op>
      return -1;
80105b7a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b7f:	eb 40                	jmp    80105bc1 <sys_open+0x121>
80105b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b88:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b8b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b8f:	56                   	push   %esi
80105b90:	e8 ab bc ff ff       	call   80101840 <iunlock>
  end_op();
80105b95:	e8 f6 da ff ff       	call   80103690 <end_op>

  f->type = FD_INODE;
80105b9a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105ba0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ba3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105ba6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105ba9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105bab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105bb2:	f7 d0                	not    %eax
80105bb4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bb7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105bba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bbd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bc4:	89 d8                	mov    %ebx,%eax
80105bc6:	5b                   	pop    %ebx
80105bc7:	5e                   	pop    %esi
80105bc8:	5f                   	pop    %edi
80105bc9:	5d                   	pop    %ebp
80105bca:	c3                   	ret    
80105bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bd0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105bd3:	85 c9                	test   %ecx,%ecx
80105bd5:	0f 84 33 ff ff ff    	je     80105b0e <sys_open+0x6e>
80105bdb:	e9 5c ff ff ff       	jmp    80105b3c <sys_open+0x9c>

80105be0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105be0:	f3 0f 1e fb          	endbr32 
80105be4:	55                   	push   %ebp
80105be5:	89 e5                	mov    %esp,%ebp
80105be7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105bea:	e8 31 da ff ff       	call   80103620 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105bef:	83 ec 08             	sub    $0x8,%esp
80105bf2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bf5:	50                   	push   %eax
80105bf6:	6a 00                	push   $0x0
80105bf8:	e8 e3 f6 ff ff       	call   801052e0 <argstr>
80105bfd:	83 c4 10             	add    $0x10,%esp
80105c00:	85 c0                	test   %eax,%eax
80105c02:	78 34                	js     80105c38 <sys_mkdir+0x58>
80105c04:	83 ec 0c             	sub    $0xc,%esp
80105c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c0a:	31 c9                	xor    %ecx,%ecx
80105c0c:	ba 01 00 00 00       	mov    $0x1,%edx
80105c11:	6a 00                	push   $0x0
80105c13:	e8 78 f7 ff ff       	call   80105390 <create>
80105c18:	83 c4 10             	add    $0x10,%esp
80105c1b:	85 c0                	test   %eax,%eax
80105c1d:	74 19                	je     80105c38 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c1f:	83 ec 0c             	sub    $0xc,%esp
80105c22:	50                   	push   %eax
80105c23:	e8 d8 bd ff ff       	call   80101a00 <iunlockput>
  end_op();
80105c28:	e8 63 da ff ff       	call   80103690 <end_op>
  return 0;
80105c2d:	83 c4 10             	add    $0x10,%esp
80105c30:	31 c0                	xor    %eax,%eax
}
80105c32:	c9                   	leave  
80105c33:	c3                   	ret    
80105c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105c38:	e8 53 da ff ff       	call   80103690 <end_op>
    return -1;
80105c3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c42:	c9                   	leave  
80105c43:	c3                   	ret    
80105c44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop

80105c50 <sys_mknod>:

int
sys_mknod(void)
{
80105c50:	f3 0f 1e fb          	endbr32 
80105c54:	55                   	push   %ebp
80105c55:	89 e5                	mov    %esp,%ebp
80105c57:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c5a:	e8 c1 d9 ff ff       	call   80103620 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c5f:	83 ec 08             	sub    $0x8,%esp
80105c62:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c65:	50                   	push   %eax
80105c66:	6a 00                	push   $0x0
80105c68:	e8 73 f6 ff ff       	call   801052e0 <argstr>
80105c6d:	83 c4 10             	add    $0x10,%esp
80105c70:	85 c0                	test   %eax,%eax
80105c72:	78 64                	js     80105cd8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105c74:	83 ec 08             	sub    $0x8,%esp
80105c77:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c7a:	50                   	push   %eax
80105c7b:	6a 01                	push   $0x1
80105c7d:	e8 ae f5 ff ff       	call   80105230 <argint>
  if((argstr(0, &path)) < 0 ||
80105c82:	83 c4 10             	add    $0x10,%esp
80105c85:	85 c0                	test   %eax,%eax
80105c87:	78 4f                	js     80105cd8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105c89:	83 ec 08             	sub    $0x8,%esp
80105c8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c8f:	50                   	push   %eax
80105c90:	6a 02                	push   $0x2
80105c92:	e8 99 f5 ff ff       	call   80105230 <argint>
     argint(1, &major) < 0 ||
80105c97:	83 c4 10             	add    $0x10,%esp
80105c9a:	85 c0                	test   %eax,%eax
80105c9c:	78 3a                	js     80105cd8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c9e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105ca2:	83 ec 0c             	sub    $0xc,%esp
80105ca5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105ca9:	ba 03 00 00 00       	mov    $0x3,%edx
80105cae:	50                   	push   %eax
80105caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105cb2:	e8 d9 f6 ff ff       	call   80105390 <create>
     argint(2, &minor) < 0 ||
80105cb7:	83 c4 10             	add    $0x10,%esp
80105cba:	85 c0                	test   %eax,%eax
80105cbc:	74 1a                	je     80105cd8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105cbe:	83 ec 0c             	sub    $0xc,%esp
80105cc1:	50                   	push   %eax
80105cc2:	e8 39 bd ff ff       	call   80101a00 <iunlockput>
  end_op();
80105cc7:	e8 c4 d9 ff ff       	call   80103690 <end_op>
  return 0;
80105ccc:	83 c4 10             	add    $0x10,%esp
80105ccf:	31 c0                	xor    %eax,%eax
}
80105cd1:	c9                   	leave  
80105cd2:	c3                   	ret    
80105cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cd7:	90                   	nop
    end_op();
80105cd8:	e8 b3 d9 ff ff       	call   80103690 <end_op>
    return -1;
80105cdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ce2:	c9                   	leave  
80105ce3:	c3                   	ret    
80105ce4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cef:	90                   	nop

80105cf0 <sys_chdir>:

int
sys_chdir(void)
{
80105cf0:	f3 0f 1e fb          	endbr32 
80105cf4:	55                   	push   %ebp
80105cf5:	89 e5                	mov    %esp,%ebp
80105cf7:	56                   	push   %esi
80105cf8:	53                   	push   %ebx
80105cf9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105cfc:	e8 4f e5 ff ff       	call   80104250 <myproc>
80105d01:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105d03:	e8 18 d9 ff ff       	call   80103620 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d08:	83 ec 08             	sub    $0x8,%esp
80105d0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d0e:	50                   	push   %eax
80105d0f:	6a 00                	push   $0x0
80105d11:	e8 ca f5 ff ff       	call   801052e0 <argstr>
80105d16:	83 c4 10             	add    $0x10,%esp
80105d19:	85 c0                	test   %eax,%eax
80105d1b:	78 73                	js     80105d90 <sys_chdir+0xa0>
80105d1d:	83 ec 0c             	sub    $0xc,%esp
80105d20:	ff 75 f4             	pushl  -0xc(%ebp)
80105d23:	e8 08 c3 ff ff       	call   80102030 <namei>
80105d28:	83 c4 10             	add    $0x10,%esp
80105d2b:	89 c3                	mov    %eax,%ebx
80105d2d:	85 c0                	test   %eax,%eax
80105d2f:	74 5f                	je     80105d90 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d31:	83 ec 0c             	sub    $0xc,%esp
80105d34:	50                   	push   %eax
80105d35:	e8 26 ba ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105d3a:	83 c4 10             	add    $0x10,%esp
80105d3d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d42:	75 2c                	jne    80105d70 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d44:	83 ec 0c             	sub    $0xc,%esp
80105d47:	53                   	push   %ebx
80105d48:	e8 f3 ba ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105d4d:	58                   	pop    %eax
80105d4e:	ff 76 68             	pushl  0x68(%esi)
80105d51:	e8 3a bb ff ff       	call   80101890 <iput>
  end_op();
80105d56:	e8 35 d9 ff ff       	call   80103690 <end_op>
  curproc->cwd = ip;
80105d5b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105d5e:	83 c4 10             	add    $0x10,%esp
80105d61:	31 c0                	xor    %eax,%eax
}
80105d63:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d66:	5b                   	pop    %ebx
80105d67:	5e                   	pop    %esi
80105d68:	5d                   	pop    %ebp
80105d69:	c3                   	ret    
80105d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105d70:	83 ec 0c             	sub    $0xc,%esp
80105d73:	53                   	push   %ebx
80105d74:	e8 87 bc ff ff       	call   80101a00 <iunlockput>
    end_op();
80105d79:	e8 12 d9 ff ff       	call   80103690 <end_op>
    return -1;
80105d7e:	83 c4 10             	add    $0x10,%esp
80105d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d86:	eb db                	jmp    80105d63 <sys_chdir+0x73>
80105d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8f:	90                   	nop
    end_op();
80105d90:	e8 fb d8 ff ff       	call   80103690 <end_op>
    return -1;
80105d95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d9a:	eb c7                	jmp    80105d63 <sys_chdir+0x73>
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_exec>:

int
sys_exec(void)
{
80105da0:	f3 0f 1e fb          	endbr32 
80105da4:	55                   	push   %ebp
80105da5:	89 e5                	mov    %esp,%ebp
80105da7:	57                   	push   %edi
80105da8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105da9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105daf:	53                   	push   %ebx
80105db0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105db6:	50                   	push   %eax
80105db7:	6a 00                	push   $0x0
80105db9:	e8 22 f5 ff ff       	call   801052e0 <argstr>
80105dbe:	83 c4 10             	add    $0x10,%esp
80105dc1:	85 c0                	test   %eax,%eax
80105dc3:	0f 88 8b 00 00 00    	js     80105e54 <sys_exec+0xb4>
80105dc9:	83 ec 08             	sub    $0x8,%esp
80105dcc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105dd2:	50                   	push   %eax
80105dd3:	6a 01                	push   $0x1
80105dd5:	e8 56 f4 ff ff       	call   80105230 <argint>
80105dda:	83 c4 10             	add    $0x10,%esp
80105ddd:	85 c0                	test   %eax,%eax
80105ddf:	78 73                	js     80105e54 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105de1:	83 ec 04             	sub    $0x4,%esp
80105de4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105dea:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105dec:	68 80 00 00 00       	push   $0x80
80105df1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105df7:	6a 00                	push   $0x0
80105df9:	50                   	push   %eax
80105dfa:	e8 51 f1 ff ff       	call   80104f50 <memset>
80105dff:	83 c4 10             	add    $0x10,%esp
80105e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e08:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e0e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105e15:	83 ec 08             	sub    $0x8,%esp
80105e18:	57                   	push   %edi
80105e19:	01 f0                	add    %esi,%eax
80105e1b:	50                   	push   %eax
80105e1c:	e8 6f f3 ff ff       	call   80105190 <fetchint>
80105e21:	83 c4 10             	add    $0x10,%esp
80105e24:	85 c0                	test   %eax,%eax
80105e26:	78 2c                	js     80105e54 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105e28:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e2e:	85 c0                	test   %eax,%eax
80105e30:	74 36                	je     80105e68 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e32:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e38:	83 ec 08             	sub    $0x8,%esp
80105e3b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e3e:	52                   	push   %edx
80105e3f:	50                   	push   %eax
80105e40:	e8 8b f3 ff ff       	call   801051d0 <fetchstr>
80105e45:	83 c4 10             	add    $0x10,%esp
80105e48:	85 c0                	test   %eax,%eax
80105e4a:	78 08                	js     80105e54 <sys_exec+0xb4>
  for(i=0;; i++){
80105e4c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e4f:	83 fb 20             	cmp    $0x20,%ebx
80105e52:	75 b4                	jne    80105e08 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e5c:	5b                   	pop    %ebx
80105e5d:	5e                   	pop    %esi
80105e5e:	5f                   	pop    %edi
80105e5f:	5d                   	pop    %ebp
80105e60:	c3                   	ret    
80105e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105e68:	83 ec 08             	sub    $0x8,%esp
80105e6b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105e71:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e78:	00 00 00 00 
  return exec(path, argv);
80105e7c:	50                   	push   %eax
80105e7d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e83:	e8 f8 ab ff ff       	call   80100a80 <exec>
80105e88:	83 c4 10             	add    $0x10,%esp
}
80105e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e8e:	5b                   	pop    %ebx
80105e8f:	5e                   	pop    %esi
80105e90:	5f                   	pop    %edi
80105e91:	5d                   	pop    %ebp
80105e92:	c3                   	ret    
80105e93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ea0 <sys_pipe>:

int
sys_pipe(void)
{
80105ea0:	f3 0f 1e fb          	endbr32 
80105ea4:	55                   	push   %ebp
80105ea5:	89 e5                	mov    %esp,%ebp
80105ea7:	57                   	push   %edi
80105ea8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ea9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105eac:	53                   	push   %ebx
80105ead:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105eb0:	6a 08                	push   $0x8
80105eb2:	50                   	push   %eax
80105eb3:	6a 00                	push   $0x0
80105eb5:	e8 c6 f3 ff ff       	call   80105280 <argptr>
80105eba:	83 c4 10             	add    $0x10,%esp
80105ebd:	85 c0                	test   %eax,%eax
80105ebf:	78 4e                	js     80105f0f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ec1:	83 ec 08             	sub    $0x8,%esp
80105ec4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ec7:	50                   	push   %eax
80105ec8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ecb:	50                   	push   %eax
80105ecc:	e8 0f de ff ff       	call   80103ce0 <pipealloc>
80105ed1:	83 c4 10             	add    $0x10,%esp
80105ed4:	85 c0                	test   %eax,%eax
80105ed6:	78 37                	js     80105f0f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ed8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105edb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105edd:	e8 6e e3 ff ff       	call   80104250 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105ee8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105eec:	85 f6                	test   %esi,%esi
80105eee:	74 30                	je     80105f20 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105ef0:	83 c3 01             	add    $0x1,%ebx
80105ef3:	83 fb 10             	cmp    $0x10,%ebx
80105ef6:	75 f0                	jne    80105ee8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105ef8:	83 ec 0c             	sub    $0xc,%esp
80105efb:	ff 75 e0             	pushl  -0x20(%ebp)
80105efe:	e8 bd af ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105f03:	58                   	pop    %eax
80105f04:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f07:	e8 b4 af ff ff       	call   80100ec0 <fileclose>
    return -1;
80105f0c:	83 c4 10             	add    $0x10,%esp
80105f0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f14:	eb 5b                	jmp    80105f71 <sys_pipe+0xd1>
80105f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f1d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105f20:	8d 73 08             	lea    0x8(%ebx),%esi
80105f23:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105f2a:	e8 21 e3 ff ff       	call   80104250 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f2f:	31 d2                	xor    %edx,%edx
80105f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105f38:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f3c:	85 c9                	test   %ecx,%ecx
80105f3e:	74 20                	je     80105f60 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105f40:	83 c2 01             	add    $0x1,%edx
80105f43:	83 fa 10             	cmp    $0x10,%edx
80105f46:	75 f0                	jne    80105f38 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105f48:	e8 03 e3 ff ff       	call   80104250 <myproc>
80105f4d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105f54:	00 
80105f55:	eb a1                	jmp    80105ef8 <sys_pipe+0x58>
80105f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f5e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105f60:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105f64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f67:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f69:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f6c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f6f:	31 c0                	xor    %eax,%eax
}
80105f71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f74:	5b                   	pop    %ebx
80105f75:	5e                   	pop    %esi
80105f76:	5f                   	pop    %edi
80105f77:	5d                   	pop    %ebp
80105f78:	c3                   	ret    
80105f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f80 <sys_swapread>:

int sys_swapread(void)
{
80105f80:	f3 0f 1e fb          	endbr32 
80105f84:	55                   	push   %ebp
80105f85:	89 e5                	mov    %esp,%ebp
80105f87:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105f8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f8d:	68 00 10 00 00       	push   $0x1000
80105f92:	50                   	push   %eax
80105f93:	6a 00                	push   $0x0
80105f95:	e8 e6 f2 ff ff       	call   80105280 <argptr>
80105f9a:	83 c4 10             	add    $0x10,%esp
80105f9d:	85 c0                	test   %eax,%eax
80105f9f:	78 2f                	js     80105fd0 <sys_swapread+0x50>
80105fa1:	83 ec 08             	sub    $0x8,%esp
80105fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fa7:	50                   	push   %eax
80105fa8:	6a 01                	push   $0x1
80105faa:	e8 81 f2 ff ff       	call   80105230 <argint>
80105faf:	83 c4 10             	add    $0x10,%esp
80105fb2:	85 c0                	test   %eax,%eax
80105fb4:	78 1a                	js     80105fd0 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
80105fb6:	83 ec 08             	sub    $0x8,%esp
80105fb9:	ff 75 f4             	pushl  -0xc(%ebp)
80105fbc:	ff 75 f0             	pushl  -0x10(%ebp)
80105fbf:	e8 ac c0 ff ff       	call   80102070 <swapread>
	return 0;
80105fc4:	83 c4 10             	add    $0x10,%esp
80105fc7:	31 c0                	xor    %eax,%eax
}
80105fc9:	c9                   	leave  
80105fca:	c3                   	ret    
80105fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fcf:	90                   	nop
80105fd0:	c9                   	leave  
		return -1;
80105fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fd6:	c3                   	ret    
80105fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fde:	66 90                	xchg   %ax,%ax

80105fe0 <sys_swapwrite>:

int sys_swapwrite(void)
{
80105fe0:	f3 0f 1e fb          	endbr32 
80105fe4:	55                   	push   %ebp
80105fe5:	89 e5                	mov    %esp,%ebp
80105fe7:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105fea:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fed:	68 00 10 00 00       	push   $0x1000
80105ff2:	50                   	push   %eax
80105ff3:	6a 00                	push   $0x0
80105ff5:	e8 86 f2 ff ff       	call   80105280 <argptr>
80105ffa:	83 c4 10             	add    $0x10,%esp
80105ffd:	85 c0                	test   %eax,%eax
80105fff:	78 2f                	js     80106030 <sys_swapwrite+0x50>
80106001:	83 ec 08             	sub    $0x8,%esp
80106004:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106007:	50                   	push   %eax
80106008:	6a 01                	push   $0x1
8010600a:	e8 21 f2 ff ff       	call   80105230 <argint>
8010600f:	83 c4 10             	add    $0x10,%esp
80106012:	85 c0                	test   %eax,%eax
80106014:	78 1a                	js     80106030 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
80106016:	83 ec 08             	sub    $0x8,%esp
80106019:	ff 75 f4             	pushl  -0xc(%ebp)
8010601c:	ff 75 f0             	pushl  -0x10(%ebp)
8010601f:	e8 dc c0 ff ff       	call   80102100 <swapwrite>
	return 0;
80106024:	83 c4 10             	add    $0x10,%esp
80106027:	31 c0                	xor    %eax,%eax
}
80106029:	c9                   	leave  
8010602a:	c3                   	ret    
8010602b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010602f:	90                   	nop
80106030:	c9                   	leave  
		return -1;
80106031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106036:	c3                   	ret    
80106037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603e:	66 90                	xchg   %ax,%ax

80106040 <sys_swapstat>:

int sys_swapstat(void)
{
80106040:	f3 0f 1e fb          	endbr32 
80106044:	55                   	push   %ebp
80106045:	89 e5                	mov    %esp,%ebp
80106047:	53                   	push   %ebx
	int* nr_read;
	int* nr_write;
	
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80106048:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
8010604b:	83 ec 18             	sub    $0x18,%esp
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
8010604e:	6a 04                	push   $0x4
80106050:	50                   	push   %eax
80106051:	6a 00                	push   $0x0
80106053:	e8 28 f2 ff ff       	call   80105280 <argptr>
80106058:	83 c4 10             	add    $0x10,%esp
8010605b:	85 c0                	test   %eax,%eax
8010605d:	75 39                	jne    80106098 <sys_swapstat+0x58>
			argptr(1, (void*)&nr_write, sizeof(*nr_write)) < 0)
8010605f:	83 ec 04             	sub    $0x4,%esp
80106062:	89 c3                	mov    %eax,%ebx
80106064:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106067:	6a 04                	push   $0x4
80106069:	50                   	push   %eax
8010606a:	6a 01                	push   $0x1
8010606c:	e8 0f f2 ff ff       	call   80105280 <argptr>
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80106071:	83 c4 10             	add    $0x10,%esp
80106074:	85 c0                	test   %eax,%eax
80106076:	78 20                	js     80106098 <sys_swapstat+0x58>
		return -1;

	*nr_read = nr_sectors_read;
80106078:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010607b:	8b 15 c0 19 11 80    	mov    0x801119c0,%edx
80106081:	89 10                	mov    %edx,(%eax)
	*nr_write = nr_sectors_write;
80106083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106086:	8b 15 e0 19 11 80    	mov    0x801119e0,%edx
8010608c:	89 10                	mov    %edx,(%eax)
	return 0;
}
8010608e:	89 d8                	mov    %ebx,%eax
80106090:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106093:	c9                   	leave  
80106094:	c3                   	ret    
80106095:	8d 76 00             	lea    0x0(%esi),%esi
		return -1;
80106098:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010609d:	eb ef                	jmp    8010608e <sys_swapstat+0x4e>
8010609f:	90                   	nop

801060a0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801060a0:	f3 0f 1e fb          	endbr32 
  return fork();
801060a4:	e9 67 e3 ff ff       	jmp    80104410 <fork>
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060b0 <sys_exit>:
}

int
sys_exit(void)
{
801060b0:	f3 0f 1e fb          	endbr32 
801060b4:	55                   	push   %ebp
801060b5:	89 e5                	mov    %esp,%ebp
801060b7:	83 ec 08             	sub    $0x8,%esp
  exit();
801060ba:	e8 b1 e5 ff ff       	call   80104670 <exit>
  return 0;  // not reached
}
801060bf:	31 c0                	xor    %eax,%eax
801060c1:	c9                   	leave  
801060c2:	c3                   	ret    
801060c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060d0 <sys_wait>:

int
sys_wait(void)
{
801060d0:	f3 0f 1e fb          	endbr32 
  return wait();
801060d4:	e9 e7 e7 ff ff       	jmp    801048c0 <wait>
801060d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060e0 <sys_kill>:
}

int
sys_kill(void)
{
801060e0:	f3 0f 1e fb          	endbr32 
801060e4:	55                   	push   %ebp
801060e5:	89 e5                	mov    %esp,%ebp
801060e7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801060ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060ed:	50                   	push   %eax
801060ee:	6a 00                	push   $0x0
801060f0:	e8 3b f1 ff ff       	call   80105230 <argint>
801060f5:	83 c4 10             	add    $0x10,%esp
801060f8:	85 c0                	test   %eax,%eax
801060fa:	78 14                	js     80106110 <sys_kill+0x30>
    return -1;
  return kill(pid);
801060fc:	83 ec 0c             	sub    $0xc,%esp
801060ff:	ff 75 f4             	pushl  -0xc(%ebp)
80106102:	e8 19 e9 ff ff       	call   80104a20 <kill>
80106107:	83 c4 10             	add    $0x10,%esp
}
8010610a:	c9                   	leave  
8010610b:	c3                   	ret    
8010610c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106110:	c9                   	leave  
    return -1;
80106111:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106116:	c3                   	ret    
80106117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010611e:	66 90                	xchg   %ax,%ax

80106120 <sys_getpid>:

int
sys_getpid(void)
{
80106120:	f3 0f 1e fb          	endbr32 
80106124:	55                   	push   %ebp
80106125:	89 e5                	mov    %esp,%ebp
80106127:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010612a:	e8 21 e1 ff ff       	call   80104250 <myproc>
8010612f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106132:	c9                   	leave  
80106133:	c3                   	ret    
80106134:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010613b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010613f:	90                   	nop

80106140 <sys_sbrk>:

int
sys_sbrk(void)
{
80106140:	f3 0f 1e fb          	endbr32 
80106144:	55                   	push   %ebp
80106145:	89 e5                	mov    %esp,%ebp
80106147:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106148:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010614b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010614e:	50                   	push   %eax
8010614f:	6a 00                	push   $0x0
80106151:	e8 da f0 ff ff       	call   80105230 <argint>
80106156:	83 c4 10             	add    $0x10,%esp
80106159:	85 c0                	test   %eax,%eax
8010615b:	78 23                	js     80106180 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010615d:	e8 ee e0 ff ff       	call   80104250 <myproc>
  if(growproc(n) < 0)
80106162:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106165:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106167:	ff 75 f4             	pushl  -0xc(%ebp)
8010616a:	e8 21 e2 ff ff       	call   80104390 <growproc>
8010616f:	83 c4 10             	add    $0x10,%esp
80106172:	85 c0                	test   %eax,%eax
80106174:	78 0a                	js     80106180 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106176:	89 d8                	mov    %ebx,%eax
80106178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010617b:	c9                   	leave  
8010617c:	c3                   	ret    
8010617d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106180:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106185:	eb ef                	jmp    80106176 <sys_sbrk+0x36>
80106187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010618e:	66 90                	xchg   %ax,%ax

80106190 <sys_sleep>:

int
sys_sleep(void)
{
80106190:	f3 0f 1e fb          	endbr32 
80106194:	55                   	push   %ebp
80106195:	89 e5                	mov    %esp,%ebp
80106197:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106198:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010619b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010619e:	50                   	push   %eax
8010619f:	6a 00                	push   $0x0
801061a1:	e8 8a f0 ff ff       	call   80105230 <argint>
801061a6:	83 c4 10             	add    $0x10,%esp
801061a9:	85 c0                	test   %eax,%eax
801061ab:	0f 88 86 00 00 00    	js     80106237 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801061b1:	83 ec 0c             	sub    $0xc,%esp
801061b4:	68 c0 bc 11 80       	push   $0x8011bcc0
801061b9:	e8 82 ec ff ff       	call   80104e40 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801061be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801061c1:	8b 1d 00 c5 11 80    	mov    0x8011c500,%ebx
  while(ticks - ticks0 < n){
801061c7:	83 c4 10             	add    $0x10,%esp
801061ca:	85 d2                	test   %edx,%edx
801061cc:	75 23                	jne    801061f1 <sys_sleep+0x61>
801061ce:	eb 50                	jmp    80106220 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801061d0:	83 ec 08             	sub    $0x8,%esp
801061d3:	68 c0 bc 11 80       	push   $0x8011bcc0
801061d8:	68 00 c5 11 80       	push   $0x8011c500
801061dd:	e8 1e e6 ff ff       	call   80104800 <sleep>
  while(ticks - ticks0 < n){
801061e2:	a1 00 c5 11 80       	mov    0x8011c500,%eax
801061e7:	83 c4 10             	add    $0x10,%esp
801061ea:	29 d8                	sub    %ebx,%eax
801061ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801061ef:	73 2f                	jae    80106220 <sys_sleep+0x90>
    if(myproc()->killed){
801061f1:	e8 5a e0 ff ff       	call   80104250 <myproc>
801061f6:	8b 40 24             	mov    0x24(%eax),%eax
801061f9:	85 c0                	test   %eax,%eax
801061fb:	74 d3                	je     801061d0 <sys_sleep+0x40>
      release(&tickslock);
801061fd:	83 ec 0c             	sub    $0xc,%esp
80106200:	68 c0 bc 11 80       	push   $0x8011bcc0
80106205:	e8 f6 ec ff ff       	call   80104f00 <release>
  }
  release(&tickslock);
  return 0;
}
8010620a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010620d:	83 c4 10             	add    $0x10,%esp
80106210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106215:	c9                   	leave  
80106216:	c3                   	ret    
80106217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010621e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106220:	83 ec 0c             	sub    $0xc,%esp
80106223:	68 c0 bc 11 80       	push   $0x8011bcc0
80106228:	e8 d3 ec ff ff       	call   80104f00 <release>
  return 0;
8010622d:	83 c4 10             	add    $0x10,%esp
80106230:	31 c0                	xor    %eax,%eax
}
80106232:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106235:	c9                   	leave  
80106236:	c3                   	ret    
    return -1;
80106237:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623c:	eb f4                	jmp    80106232 <sys_sleep+0xa2>
8010623e:	66 90                	xchg   %ax,%ax

80106240 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106240:	f3 0f 1e fb          	endbr32 
80106244:	55                   	push   %ebp
80106245:	89 e5                	mov    %esp,%ebp
80106247:	53                   	push   %ebx
80106248:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010624b:	68 c0 bc 11 80       	push   $0x8011bcc0
80106250:	e8 eb eb ff ff       	call   80104e40 <acquire>
  xticks = ticks;
80106255:	8b 1d 00 c5 11 80    	mov    0x8011c500,%ebx
  release(&tickslock);
8010625b:	c7 04 24 c0 bc 11 80 	movl   $0x8011bcc0,(%esp)
80106262:	e8 99 ec ff ff       	call   80104f00 <release>
  return xticks;
}
80106267:	89 d8                	mov    %ebx,%eax
80106269:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010626c:	c9                   	leave  
8010626d:	c3                   	ret    

8010626e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010626e:	1e                   	push   %ds
  pushl %es
8010626f:	06                   	push   %es
  pushl %fs
80106270:	0f a0                	push   %fs
  pushl %gs
80106272:	0f a8                	push   %gs
  pushal
80106274:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106275:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106279:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010627b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010627d:	54                   	push   %esp
  call trap
8010627e:	e8 cd 00 00 00       	call   80106350 <trap>
  addl $4, %esp
80106283:	83 c4 04             	add    $0x4,%esp

80106286 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106286:	61                   	popa   
  popl %gs
80106287:	0f a9                	pop    %gs
  popl %fs
80106289:	0f a1                	pop    %fs
  popl %es
8010628b:	07                   	pop    %es
  popl %ds
8010628c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010628d:	83 c4 08             	add    $0x8,%esp
  iret
80106290:	cf                   	iret   
80106291:	66 90                	xchg   %ax,%ax
80106293:	66 90                	xchg   %ax,%ax
80106295:	66 90                	xchg   %ax,%ax
80106297:	66 90                	xchg   %ax,%ax
80106299:	66 90                	xchg   %ax,%ax
8010629b:	66 90                	xchg   %ax,%ax
8010629d:	66 90                	xchg   %ax,%ax
8010629f:	90                   	nop

801062a0 <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
801062a0:	f3 0f 1e fb          	endbr32 
801062a4:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
801062a5:	31 c0                	xor    %eax,%eax
{
801062a7:	89 e5                	mov    %esp,%ebp
801062a9:	83 ec 08             	sub    $0x8,%esp
801062ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
801062b0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801062b7:	c7 04 c5 02 bd 11 80 	movl   $0x8e000008,-0x7fee42fe(,%eax,8)
801062be:	08 00 00 8e 
801062c2:	66 89 14 c5 00 bd 11 	mov    %dx,-0x7fee4300(,%eax,8)
801062c9:	80 
801062ca:	c1 ea 10             	shr    $0x10,%edx
801062cd:	66 89 14 c5 06 bd 11 	mov    %dx,-0x7fee42fa(,%eax,8)
801062d4:	80 
  for (i = 0; i < 256; i++)
801062d5:	83 c0 01             	add    $0x1,%eax
801062d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801062dd:	75 d1                	jne    801062b0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801062df:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801062e2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801062e7:	c7 05 02 bf 11 80 08 	movl   $0xef000008,0x8011bf02
801062ee:	00 00 ef 
  initlock(&tickslock, "time");
801062f1:	68 45 88 10 80       	push   $0x80108845
801062f6:	68 c0 bc 11 80       	push   $0x8011bcc0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801062fb:	66 a3 00 bf 11 80    	mov    %ax,0x8011bf00
80106301:	c1 e8 10             	shr    $0x10,%eax
80106304:	66 a3 06 bf 11 80    	mov    %ax,0x8011bf06
  initlock(&tickslock, "time");
8010630a:	e8 b1 e9 ff ff       	call   80104cc0 <initlock>
}
8010630f:	83 c4 10             	add    $0x10,%esp
80106312:	c9                   	leave  
80106313:	c3                   	ret    
80106314:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010631b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010631f:	90                   	nop

80106320 <idtinit>:

void idtinit(void)
{
80106320:	f3 0f 1e fb          	endbr32 
80106324:	55                   	push   %ebp
  pd[0] = size-1;
80106325:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010632a:	89 e5                	mov    %esp,%ebp
8010632c:	83 ec 10             	sub    $0x10,%esp
8010632f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106333:	b8 00 bd 11 80       	mov    $0x8011bd00,%eax
80106338:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010633c:	c1 e8 10             	shr    $0x10,%eax
8010633f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106343:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106346:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106349:	c9                   	leave  
8010634a:	c3                   	ret    
8010634b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010634f:	90                   	nop

80106350 <trap>:

void trap(struct trapframe *tf)
{
80106350:	f3 0f 1e fb          	endbr32 
80106354:	55                   	push   %ebp
80106355:	89 e5                	mov    %esp,%ebp
80106357:	57                   	push   %edi
80106358:	56                   	push   %esi
80106359:	53                   	push   %ebx
8010635a:	83 ec 1c             	sub    $0x1c,%esp
8010635d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (tf->trapno == T_SYSCALL)
80106360:	8b 43 30             	mov    0x30(%ebx),%eax
80106363:	83 f8 40             	cmp    $0x40,%eax
80106366:	0f 84 ec 01 00 00    	je     80106558 <trap+0x208>
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
8010636c:	83 e8 0e             	sub    $0xe,%eax
8010636f:	83 f8 31             	cmp    $0x31,%eax
80106372:	77 08                	ja     8010637c <trap+0x2c>
80106374:	3e ff 24 85 ec 88 10 	notrack jmp *-0x7fef7714(,%eax,4)
8010637b:	80 
  case T_PGFLT:
    page_fault_handler(myproc()->pgdir, rcr2());
    break;

  default:
    if (myproc() == 0 || (tf->cs & 3) == 0)
8010637c:	e8 cf de ff ff       	call   80104250 <myproc>
80106381:	85 c0                	test   %eax,%eax
80106383:	0f 84 1e 02 00 00    	je     801065a7 <trap+0x257>
80106389:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010638d:	0f 84 14 02 00 00    	je     801065a7 <trap+0x257>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106393:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106396:	8b 53 38             	mov    0x38(%ebx),%edx
80106399:	89 4d d8             	mov    %ecx,-0x28(%ebp)
8010639c:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010639f:	e8 8c de ff ff       	call   80104230 <cpuid>
801063a4:	8b 73 30             	mov    0x30(%ebx),%esi
801063a7:	89 c7                	mov    %eax,%edi
801063a9:	8b 43 34             	mov    0x34(%ebx),%eax
801063ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801063af:	e8 9c de ff ff       	call   80104250 <myproc>
801063b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063b7:	e8 94 de ff ff       	call   80104250 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063bc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063c2:	51                   	push   %ecx
801063c3:	52                   	push   %edx
801063c4:	57                   	push   %edi
801063c5:	ff 75 e4             	pushl  -0x1c(%ebp)
801063c8:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801063c9:	8b 75 e0             	mov    -0x20(%ebp),%esi
801063cc:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063cf:	56                   	push   %esi
801063d0:	ff 70 10             	pushl  0x10(%eax)
801063d3:	68 a8 88 10 80       	push   $0x801088a8
801063d8:	e8 d3 a2 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801063dd:	83 c4 20             	add    $0x20,%esp
801063e0:	e8 6b de ff ff       	call   80104250 <myproc>
801063e5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801063ec:	e8 5f de ff ff       	call   80104250 <myproc>
801063f1:	85 c0                	test   %eax,%eax
801063f3:	74 1d                	je     80106412 <trap+0xc2>
801063f5:	e8 56 de ff ff       	call   80104250 <myproc>
801063fa:	8b 50 24             	mov    0x24(%eax),%edx
801063fd:	85 d2                	test   %edx,%edx
801063ff:	74 11                	je     80106412 <trap+0xc2>
80106401:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106405:	83 e0 03             	and    $0x3,%eax
80106408:	66 83 f8 03          	cmp    $0x3,%ax
8010640c:	0f 84 7e 01 00 00    	je     80106590 <trap+0x240>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING &&
80106412:	e8 39 de ff ff       	call   80104250 <myproc>
80106417:	85 c0                	test   %eax,%eax
80106419:	74 0f                	je     8010642a <trap+0xda>
8010641b:	e8 30 de ff ff       	call   80104250 <myproc>
80106420:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106424:	0f 84 16 01 00 00    	je     80106540 <trap+0x1f0>
      tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010642a:	e8 21 de ff ff       	call   80104250 <myproc>
8010642f:	85 c0                	test   %eax,%eax
80106431:	74 1d                	je     80106450 <trap+0x100>
80106433:	e8 18 de ff ff       	call   80104250 <myproc>
80106438:	8b 40 24             	mov    0x24(%eax),%eax
8010643b:	85 c0                	test   %eax,%eax
8010643d:	74 11                	je     80106450 <trap+0x100>
8010643f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106443:	83 e0 03             	and    $0x3,%eax
80106446:	66 83 f8 03          	cmp    $0x3,%ax
8010644a:	0f 84 31 01 00 00    	je     80106581 <trap+0x231>
    exit();
}
80106450:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106453:	5b                   	pop    %ebx
80106454:	5e                   	pop    %esi
80106455:	5f                   	pop    %edi
80106456:	5d                   	pop    %ebp
80106457:	c3                   	ret    
    ideintr();
80106458:	e8 93 be ff ff       	call   801022f0 <ideintr>
    lapiceoi();
8010645d:	e8 4e cd ff ff       	call   801031b0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106462:	e8 e9 dd ff ff       	call   80104250 <myproc>
80106467:	85 c0                	test   %eax,%eax
80106469:	75 8a                	jne    801063f5 <trap+0xa5>
8010646b:	eb a5                	jmp    80106412 <trap+0xc2>
8010646d:	0f 20 d6             	mov    %cr2,%esi
    page_fault_handler(myproc()->pgdir, rcr2());
80106470:	e8 db dd ff ff       	call   80104250 <myproc>
80106475:	83 ec 08             	sub    $0x8,%esp
80106478:	56                   	push   %esi
80106479:	ff 70 04             	pushl  0x4(%eax)
8010647c:	e8 ff c9 ff ff       	call   80102e80 <page_fault_handler>
    break;
80106481:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106484:	e8 c7 dd ff ff       	call   80104250 <myproc>
80106489:	85 c0                	test   %eax,%eax
8010648b:	0f 85 64 ff ff ff    	jne    801063f5 <trap+0xa5>
80106491:	e9 7c ff ff ff       	jmp    80106412 <trap+0xc2>
    if (cpuid() == 0)
80106496:	e8 95 dd ff ff       	call   80104230 <cpuid>
8010649b:	85 c0                	test   %eax,%eax
8010649d:	75 be                	jne    8010645d <trap+0x10d>
      acquire(&tickslock);
8010649f:	83 ec 0c             	sub    $0xc,%esp
801064a2:	68 c0 bc 11 80       	push   $0x8011bcc0
801064a7:	e8 94 e9 ff ff       	call   80104e40 <acquire>
      wakeup(&ticks);
801064ac:	c7 04 24 00 c5 11 80 	movl   $0x8011c500,(%esp)
      ticks++;
801064b3:	83 05 00 c5 11 80 01 	addl   $0x1,0x8011c500
      wakeup(&ticks);
801064ba:	e8 01 e5 ff ff       	call   801049c0 <wakeup>
      release(&tickslock);
801064bf:	c7 04 24 c0 bc 11 80 	movl   $0x8011bcc0,(%esp)
801064c6:	e8 35 ea ff ff       	call   80104f00 <release>
801064cb:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801064ce:	eb 8d                	jmp    8010645d <trap+0x10d>
    kbdintr();
801064d0:	e8 9b cb ff ff       	call   80103070 <kbdintr>
    lapiceoi();
801064d5:	e8 d6 cc ff ff       	call   801031b0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801064da:	e8 71 dd ff ff       	call   80104250 <myproc>
801064df:	85 c0                	test   %eax,%eax
801064e1:	0f 85 0e ff ff ff    	jne    801063f5 <trap+0xa5>
801064e7:	e9 26 ff ff ff       	jmp    80106412 <trap+0xc2>
    uartintr();
801064ec:	e8 5f 02 00 00       	call   80106750 <uartintr>
    lapiceoi();
801064f1:	e8 ba cc ff ff       	call   801031b0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801064f6:	e8 55 dd ff ff       	call   80104250 <myproc>
801064fb:	85 c0                	test   %eax,%eax
801064fd:	0f 85 f2 fe ff ff    	jne    801063f5 <trap+0xa5>
80106503:	e9 0a ff ff ff       	jmp    80106412 <trap+0xc2>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106508:	8b 7b 38             	mov    0x38(%ebx),%edi
8010650b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010650f:	e8 1c dd ff ff       	call   80104230 <cpuid>
80106514:	57                   	push   %edi
80106515:	56                   	push   %esi
80106516:	50                   	push   %eax
80106517:	68 50 88 10 80       	push   $0x80108850
8010651c:	e8 8f a1 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106521:	e8 8a cc ff ff       	call   801031b0 <lapiceoi>
    break;
80106526:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106529:	e8 22 dd ff ff       	call   80104250 <myproc>
8010652e:	85 c0                	test   %eax,%eax
80106530:	0f 85 bf fe ff ff    	jne    801063f5 <trap+0xa5>
80106536:	e9 d7 fe ff ff       	jmp    80106412 <trap+0xc2>
8010653b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010653f:	90                   	nop
  if (myproc() && myproc()->state == RUNNING &&
80106540:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106544:	0f 85 e0 fe ff ff    	jne    8010642a <trap+0xda>
    yield();
8010654a:	e8 61 e2 ff ff       	call   801047b0 <yield>
8010654f:	e9 d6 fe ff ff       	jmp    8010642a <trap+0xda>
80106554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
80106558:	e8 f3 dc ff ff       	call   80104250 <myproc>
8010655d:	8b 70 24             	mov    0x24(%eax),%esi
80106560:	85 f6                	test   %esi,%esi
80106562:	75 3c                	jne    801065a0 <trap+0x250>
    myproc()->tf = tf;
80106564:	e8 e7 dc ff ff       	call   80104250 <myproc>
80106569:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010656c:	e8 af ed ff ff       	call   80105320 <syscall>
    if (myproc()->killed)
80106571:	e8 da dc ff ff       	call   80104250 <myproc>
80106576:	8b 48 24             	mov    0x24(%eax),%ecx
80106579:	85 c9                	test   %ecx,%ecx
8010657b:	0f 84 cf fe ff ff    	je     80106450 <trap+0x100>
}
80106581:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106584:	5b                   	pop    %ebx
80106585:	5e                   	pop    %esi
80106586:	5f                   	pop    %edi
80106587:	5d                   	pop    %ebp
      exit();
80106588:	e9 e3 e0 ff ff       	jmp    80104670 <exit>
8010658d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106590:	e8 db e0 ff ff       	call   80104670 <exit>
80106595:	e9 78 fe ff ff       	jmp    80106412 <trap+0xc2>
8010659a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801065a0:	e8 cb e0 ff ff       	call   80104670 <exit>
801065a5:	eb bd                	jmp    80106564 <trap+0x214>
801065a7:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801065aa:	8b 73 38             	mov    0x38(%ebx),%esi
801065ad:	e8 7e dc ff ff       	call   80104230 <cpuid>
801065b2:	83 ec 0c             	sub    $0xc,%esp
801065b5:	57                   	push   %edi
801065b6:	56                   	push   %esi
801065b7:	50                   	push   %eax
801065b8:	ff 73 30             	pushl  0x30(%ebx)
801065bb:	68 74 88 10 80       	push   $0x80108874
801065c0:	e8 eb a0 ff ff       	call   801006b0 <cprintf>
      panic("trap");
801065c5:	83 c4 14             	add    $0x14,%esp
801065c8:	68 4a 88 10 80       	push   $0x8010884a
801065cd:	e8 be 9d ff ff       	call   80100390 <panic>
801065d2:	66 90                	xchg   %ax,%ax
801065d4:	66 90                	xchg   %ax,%ax
801065d6:	66 90                	xchg   %ax,%ax
801065d8:	66 90                	xchg   %ax,%ax
801065da:	66 90                	xchg   %ax,%ax
801065dc:	66 90                	xchg   %ax,%ax
801065de:	66 90                	xchg   %ax,%ax

801065e0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801065e0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801065e4:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801065e9:	85 c0                	test   %eax,%eax
801065eb:	74 1b                	je     80106608 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065ed:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065f2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801065f3:	a8 01                	test   $0x1,%al
801065f5:	74 11                	je     80106608 <uartgetc+0x28>
801065f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065fc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801065fd:	0f b6 c0             	movzbl %al,%eax
80106600:	c3                   	ret    
80106601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010660d:	c3                   	ret    
8010660e:	66 90                	xchg   %ax,%ax

80106610 <uartputc.part.0>:
uartputc(int c)
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	57                   	push   %edi
80106614:	89 c7                	mov    %eax,%edi
80106616:	56                   	push   %esi
80106617:	be fd 03 00 00       	mov    $0x3fd,%esi
8010661c:	53                   	push   %ebx
8010661d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106622:	83 ec 0c             	sub    $0xc,%esp
80106625:	eb 1b                	jmp    80106642 <uartputc.part.0+0x32>
80106627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010662e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106630:	83 ec 0c             	sub    $0xc,%esp
80106633:	6a 0a                	push   $0xa
80106635:	e8 96 cb ff ff       	call   801031d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010663a:	83 c4 10             	add    $0x10,%esp
8010663d:	83 eb 01             	sub    $0x1,%ebx
80106640:	74 07                	je     80106649 <uartputc.part.0+0x39>
80106642:	89 f2                	mov    %esi,%edx
80106644:	ec                   	in     (%dx),%al
80106645:	a8 20                	test   $0x20,%al
80106647:	74 e7                	je     80106630 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106649:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010664e:	89 f8                	mov    %edi,%eax
80106650:	ee                   	out    %al,(%dx)
}
80106651:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106654:	5b                   	pop    %ebx
80106655:	5e                   	pop    %esi
80106656:	5f                   	pop    %edi
80106657:	5d                   	pop    %ebp
80106658:	c3                   	ret    
80106659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106660 <uartinit>:
{
80106660:	f3 0f 1e fb          	endbr32 
80106664:	55                   	push   %ebp
80106665:	31 c9                	xor    %ecx,%ecx
80106667:	89 c8                	mov    %ecx,%eax
80106669:	89 e5                	mov    %esp,%ebp
8010666b:	57                   	push   %edi
8010666c:	56                   	push   %esi
8010666d:	53                   	push   %ebx
8010666e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106673:	89 da                	mov    %ebx,%edx
80106675:	83 ec 0c             	sub    $0xc,%esp
80106678:	ee                   	out    %al,(%dx)
80106679:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010667e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106683:	89 fa                	mov    %edi,%edx
80106685:	ee                   	out    %al,(%dx)
80106686:	b8 0c 00 00 00       	mov    $0xc,%eax
8010668b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106690:	ee                   	out    %al,(%dx)
80106691:	be f9 03 00 00       	mov    $0x3f9,%esi
80106696:	89 c8                	mov    %ecx,%eax
80106698:	89 f2                	mov    %esi,%edx
8010669a:	ee                   	out    %al,(%dx)
8010669b:	b8 03 00 00 00       	mov    $0x3,%eax
801066a0:	89 fa                	mov    %edi,%edx
801066a2:	ee                   	out    %al,(%dx)
801066a3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801066a8:	89 c8                	mov    %ecx,%eax
801066aa:	ee                   	out    %al,(%dx)
801066ab:	b8 01 00 00 00       	mov    $0x1,%eax
801066b0:	89 f2                	mov    %esi,%edx
801066b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066b3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801066b8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801066b9:	3c ff                	cmp    $0xff,%al
801066bb:	74 52                	je     8010670f <uartinit+0xaf>
  uart = 1;
801066bd:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801066c4:	00 00 00 
801066c7:	89 da                	mov    %ebx,%edx
801066c9:	ec                   	in     (%dx),%al
801066ca:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066cf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801066d0:	83 ec 08             	sub    $0x8,%esp
801066d3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801066d8:	bb b4 89 10 80       	mov    $0x801089b4,%ebx
  ioapicenable(IRQ_COM1, 0);
801066dd:	6a 00                	push   $0x0
801066df:	6a 04                	push   $0x4
801066e1:	e8 5a be ff ff       	call   80102540 <ioapicenable>
801066e6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801066e9:	b8 78 00 00 00       	mov    $0x78,%eax
801066ee:	eb 04                	jmp    801066f4 <uartinit+0x94>
801066f0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801066f4:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801066fa:	85 d2                	test   %edx,%edx
801066fc:	74 08                	je     80106706 <uartinit+0xa6>
    uartputc(*p);
801066fe:	0f be c0             	movsbl %al,%eax
80106701:	e8 0a ff ff ff       	call   80106610 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106706:	89 f0                	mov    %esi,%eax
80106708:	83 c3 01             	add    $0x1,%ebx
8010670b:	84 c0                	test   %al,%al
8010670d:	75 e1                	jne    801066f0 <uartinit+0x90>
}
8010670f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106712:	5b                   	pop    %ebx
80106713:	5e                   	pop    %esi
80106714:	5f                   	pop    %edi
80106715:	5d                   	pop    %ebp
80106716:	c3                   	ret    
80106717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010671e:	66 90                	xchg   %ax,%ax

80106720 <uartputc>:
{
80106720:	f3 0f 1e fb          	endbr32 
80106724:	55                   	push   %ebp
  if(!uart)
80106725:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010672b:	89 e5                	mov    %esp,%ebp
8010672d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106730:	85 d2                	test   %edx,%edx
80106732:	74 0c                	je     80106740 <uartputc+0x20>
}
80106734:	5d                   	pop    %ebp
80106735:	e9 d6 fe ff ff       	jmp    80106610 <uartputc.part.0>
8010673a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106740:	5d                   	pop    %ebp
80106741:	c3                   	ret    
80106742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106750 <uartintr>:

void
uartintr(void)
{
80106750:	f3 0f 1e fb          	endbr32 
80106754:	55                   	push   %ebp
80106755:	89 e5                	mov    %esp,%ebp
80106757:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010675a:	68 e0 65 10 80       	push   $0x801065e0
8010675f:	e8 fc a0 ff ff       	call   80100860 <consoleintr>
}
80106764:	83 c4 10             	add    $0x10,%esp
80106767:	c9                   	leave  
80106768:	c3                   	ret    

80106769 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $0
8010676b:	6a 00                	push   $0x0
  jmp alltraps
8010676d:	e9 fc fa ff ff       	jmp    8010626e <alltraps>

80106772 <vector1>:
.globl vector1
vector1:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $1
80106774:	6a 01                	push   $0x1
  jmp alltraps
80106776:	e9 f3 fa ff ff       	jmp    8010626e <alltraps>

8010677b <vector2>:
.globl vector2
vector2:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $2
8010677d:	6a 02                	push   $0x2
  jmp alltraps
8010677f:	e9 ea fa ff ff       	jmp    8010626e <alltraps>

80106784 <vector3>:
.globl vector3
vector3:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $3
80106786:	6a 03                	push   $0x3
  jmp alltraps
80106788:	e9 e1 fa ff ff       	jmp    8010626e <alltraps>

8010678d <vector4>:
.globl vector4
vector4:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $4
8010678f:	6a 04                	push   $0x4
  jmp alltraps
80106791:	e9 d8 fa ff ff       	jmp    8010626e <alltraps>

80106796 <vector5>:
.globl vector5
vector5:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $5
80106798:	6a 05                	push   $0x5
  jmp alltraps
8010679a:	e9 cf fa ff ff       	jmp    8010626e <alltraps>

8010679f <vector6>:
.globl vector6
vector6:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $6
801067a1:	6a 06                	push   $0x6
  jmp alltraps
801067a3:	e9 c6 fa ff ff       	jmp    8010626e <alltraps>

801067a8 <vector7>:
.globl vector7
vector7:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $7
801067aa:	6a 07                	push   $0x7
  jmp alltraps
801067ac:	e9 bd fa ff ff       	jmp    8010626e <alltraps>

801067b1 <vector8>:
.globl vector8
vector8:
  pushl $8
801067b1:	6a 08                	push   $0x8
  jmp alltraps
801067b3:	e9 b6 fa ff ff       	jmp    8010626e <alltraps>

801067b8 <vector9>:
.globl vector9
vector9:
  pushl $0
801067b8:	6a 00                	push   $0x0
  pushl $9
801067ba:	6a 09                	push   $0x9
  jmp alltraps
801067bc:	e9 ad fa ff ff       	jmp    8010626e <alltraps>

801067c1 <vector10>:
.globl vector10
vector10:
  pushl $10
801067c1:	6a 0a                	push   $0xa
  jmp alltraps
801067c3:	e9 a6 fa ff ff       	jmp    8010626e <alltraps>

801067c8 <vector11>:
.globl vector11
vector11:
  pushl $11
801067c8:	6a 0b                	push   $0xb
  jmp alltraps
801067ca:	e9 9f fa ff ff       	jmp    8010626e <alltraps>

801067cf <vector12>:
.globl vector12
vector12:
  pushl $12
801067cf:	6a 0c                	push   $0xc
  jmp alltraps
801067d1:	e9 98 fa ff ff       	jmp    8010626e <alltraps>

801067d6 <vector13>:
.globl vector13
vector13:
  pushl $13
801067d6:	6a 0d                	push   $0xd
  jmp alltraps
801067d8:	e9 91 fa ff ff       	jmp    8010626e <alltraps>

801067dd <vector14>:
.globl vector14
vector14:
  pushl $14
801067dd:	6a 0e                	push   $0xe
  jmp alltraps
801067df:	e9 8a fa ff ff       	jmp    8010626e <alltraps>

801067e4 <vector15>:
.globl vector15
vector15:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $15
801067e6:	6a 0f                	push   $0xf
  jmp alltraps
801067e8:	e9 81 fa ff ff       	jmp    8010626e <alltraps>

801067ed <vector16>:
.globl vector16
vector16:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $16
801067ef:	6a 10                	push   $0x10
  jmp alltraps
801067f1:	e9 78 fa ff ff       	jmp    8010626e <alltraps>

801067f6 <vector17>:
.globl vector17
vector17:
  pushl $17
801067f6:	6a 11                	push   $0x11
  jmp alltraps
801067f8:	e9 71 fa ff ff       	jmp    8010626e <alltraps>

801067fd <vector18>:
.globl vector18
vector18:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $18
801067ff:	6a 12                	push   $0x12
  jmp alltraps
80106801:	e9 68 fa ff ff       	jmp    8010626e <alltraps>

80106806 <vector19>:
.globl vector19
vector19:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $19
80106808:	6a 13                	push   $0x13
  jmp alltraps
8010680a:	e9 5f fa ff ff       	jmp    8010626e <alltraps>

8010680f <vector20>:
.globl vector20
vector20:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $20
80106811:	6a 14                	push   $0x14
  jmp alltraps
80106813:	e9 56 fa ff ff       	jmp    8010626e <alltraps>

80106818 <vector21>:
.globl vector21
vector21:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $21
8010681a:	6a 15                	push   $0x15
  jmp alltraps
8010681c:	e9 4d fa ff ff       	jmp    8010626e <alltraps>

80106821 <vector22>:
.globl vector22
vector22:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $22
80106823:	6a 16                	push   $0x16
  jmp alltraps
80106825:	e9 44 fa ff ff       	jmp    8010626e <alltraps>

8010682a <vector23>:
.globl vector23
vector23:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $23
8010682c:	6a 17                	push   $0x17
  jmp alltraps
8010682e:	e9 3b fa ff ff       	jmp    8010626e <alltraps>

80106833 <vector24>:
.globl vector24
vector24:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $24
80106835:	6a 18                	push   $0x18
  jmp alltraps
80106837:	e9 32 fa ff ff       	jmp    8010626e <alltraps>

8010683c <vector25>:
.globl vector25
vector25:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $25
8010683e:	6a 19                	push   $0x19
  jmp alltraps
80106840:	e9 29 fa ff ff       	jmp    8010626e <alltraps>

80106845 <vector26>:
.globl vector26
vector26:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $26
80106847:	6a 1a                	push   $0x1a
  jmp alltraps
80106849:	e9 20 fa ff ff       	jmp    8010626e <alltraps>

8010684e <vector27>:
.globl vector27
vector27:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $27
80106850:	6a 1b                	push   $0x1b
  jmp alltraps
80106852:	e9 17 fa ff ff       	jmp    8010626e <alltraps>

80106857 <vector28>:
.globl vector28
vector28:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $28
80106859:	6a 1c                	push   $0x1c
  jmp alltraps
8010685b:	e9 0e fa ff ff       	jmp    8010626e <alltraps>

80106860 <vector29>:
.globl vector29
vector29:
  pushl $0
80106860:	6a 00                	push   $0x0
  pushl $29
80106862:	6a 1d                	push   $0x1d
  jmp alltraps
80106864:	e9 05 fa ff ff       	jmp    8010626e <alltraps>

80106869 <vector30>:
.globl vector30
vector30:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $30
8010686b:	6a 1e                	push   $0x1e
  jmp alltraps
8010686d:	e9 fc f9 ff ff       	jmp    8010626e <alltraps>

80106872 <vector31>:
.globl vector31
vector31:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $31
80106874:	6a 1f                	push   $0x1f
  jmp alltraps
80106876:	e9 f3 f9 ff ff       	jmp    8010626e <alltraps>

8010687b <vector32>:
.globl vector32
vector32:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $32
8010687d:	6a 20                	push   $0x20
  jmp alltraps
8010687f:	e9 ea f9 ff ff       	jmp    8010626e <alltraps>

80106884 <vector33>:
.globl vector33
vector33:
  pushl $0
80106884:	6a 00                	push   $0x0
  pushl $33
80106886:	6a 21                	push   $0x21
  jmp alltraps
80106888:	e9 e1 f9 ff ff       	jmp    8010626e <alltraps>

8010688d <vector34>:
.globl vector34
vector34:
  pushl $0
8010688d:	6a 00                	push   $0x0
  pushl $34
8010688f:	6a 22                	push   $0x22
  jmp alltraps
80106891:	e9 d8 f9 ff ff       	jmp    8010626e <alltraps>

80106896 <vector35>:
.globl vector35
vector35:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $35
80106898:	6a 23                	push   $0x23
  jmp alltraps
8010689a:	e9 cf f9 ff ff       	jmp    8010626e <alltraps>

8010689f <vector36>:
.globl vector36
vector36:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $36
801068a1:	6a 24                	push   $0x24
  jmp alltraps
801068a3:	e9 c6 f9 ff ff       	jmp    8010626e <alltraps>

801068a8 <vector37>:
.globl vector37
vector37:
  pushl $0
801068a8:	6a 00                	push   $0x0
  pushl $37
801068aa:	6a 25                	push   $0x25
  jmp alltraps
801068ac:	e9 bd f9 ff ff       	jmp    8010626e <alltraps>

801068b1 <vector38>:
.globl vector38
vector38:
  pushl $0
801068b1:	6a 00                	push   $0x0
  pushl $38
801068b3:	6a 26                	push   $0x26
  jmp alltraps
801068b5:	e9 b4 f9 ff ff       	jmp    8010626e <alltraps>

801068ba <vector39>:
.globl vector39
vector39:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $39
801068bc:	6a 27                	push   $0x27
  jmp alltraps
801068be:	e9 ab f9 ff ff       	jmp    8010626e <alltraps>

801068c3 <vector40>:
.globl vector40
vector40:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $40
801068c5:	6a 28                	push   $0x28
  jmp alltraps
801068c7:	e9 a2 f9 ff ff       	jmp    8010626e <alltraps>

801068cc <vector41>:
.globl vector41
vector41:
  pushl $0
801068cc:	6a 00                	push   $0x0
  pushl $41
801068ce:	6a 29                	push   $0x29
  jmp alltraps
801068d0:	e9 99 f9 ff ff       	jmp    8010626e <alltraps>

801068d5 <vector42>:
.globl vector42
vector42:
  pushl $0
801068d5:	6a 00                	push   $0x0
  pushl $42
801068d7:	6a 2a                	push   $0x2a
  jmp alltraps
801068d9:	e9 90 f9 ff ff       	jmp    8010626e <alltraps>

801068de <vector43>:
.globl vector43
vector43:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $43
801068e0:	6a 2b                	push   $0x2b
  jmp alltraps
801068e2:	e9 87 f9 ff ff       	jmp    8010626e <alltraps>

801068e7 <vector44>:
.globl vector44
vector44:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $44
801068e9:	6a 2c                	push   $0x2c
  jmp alltraps
801068eb:	e9 7e f9 ff ff       	jmp    8010626e <alltraps>

801068f0 <vector45>:
.globl vector45
vector45:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $45
801068f2:	6a 2d                	push   $0x2d
  jmp alltraps
801068f4:	e9 75 f9 ff ff       	jmp    8010626e <alltraps>

801068f9 <vector46>:
.globl vector46
vector46:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $46
801068fb:	6a 2e                	push   $0x2e
  jmp alltraps
801068fd:	e9 6c f9 ff ff       	jmp    8010626e <alltraps>

80106902 <vector47>:
.globl vector47
vector47:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $47
80106904:	6a 2f                	push   $0x2f
  jmp alltraps
80106906:	e9 63 f9 ff ff       	jmp    8010626e <alltraps>

8010690b <vector48>:
.globl vector48
vector48:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $48
8010690d:	6a 30                	push   $0x30
  jmp alltraps
8010690f:	e9 5a f9 ff ff       	jmp    8010626e <alltraps>

80106914 <vector49>:
.globl vector49
vector49:
  pushl $0
80106914:	6a 00                	push   $0x0
  pushl $49
80106916:	6a 31                	push   $0x31
  jmp alltraps
80106918:	e9 51 f9 ff ff       	jmp    8010626e <alltraps>

8010691d <vector50>:
.globl vector50
vector50:
  pushl $0
8010691d:	6a 00                	push   $0x0
  pushl $50
8010691f:	6a 32                	push   $0x32
  jmp alltraps
80106921:	e9 48 f9 ff ff       	jmp    8010626e <alltraps>

80106926 <vector51>:
.globl vector51
vector51:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $51
80106928:	6a 33                	push   $0x33
  jmp alltraps
8010692a:	e9 3f f9 ff ff       	jmp    8010626e <alltraps>

8010692f <vector52>:
.globl vector52
vector52:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $52
80106931:	6a 34                	push   $0x34
  jmp alltraps
80106933:	e9 36 f9 ff ff       	jmp    8010626e <alltraps>

80106938 <vector53>:
.globl vector53
vector53:
  pushl $0
80106938:	6a 00                	push   $0x0
  pushl $53
8010693a:	6a 35                	push   $0x35
  jmp alltraps
8010693c:	e9 2d f9 ff ff       	jmp    8010626e <alltraps>

80106941 <vector54>:
.globl vector54
vector54:
  pushl $0
80106941:	6a 00                	push   $0x0
  pushl $54
80106943:	6a 36                	push   $0x36
  jmp alltraps
80106945:	e9 24 f9 ff ff       	jmp    8010626e <alltraps>

8010694a <vector55>:
.globl vector55
vector55:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $55
8010694c:	6a 37                	push   $0x37
  jmp alltraps
8010694e:	e9 1b f9 ff ff       	jmp    8010626e <alltraps>

80106953 <vector56>:
.globl vector56
vector56:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $56
80106955:	6a 38                	push   $0x38
  jmp alltraps
80106957:	e9 12 f9 ff ff       	jmp    8010626e <alltraps>

8010695c <vector57>:
.globl vector57
vector57:
  pushl $0
8010695c:	6a 00                	push   $0x0
  pushl $57
8010695e:	6a 39                	push   $0x39
  jmp alltraps
80106960:	e9 09 f9 ff ff       	jmp    8010626e <alltraps>

80106965 <vector58>:
.globl vector58
vector58:
  pushl $0
80106965:	6a 00                	push   $0x0
  pushl $58
80106967:	6a 3a                	push   $0x3a
  jmp alltraps
80106969:	e9 00 f9 ff ff       	jmp    8010626e <alltraps>

8010696e <vector59>:
.globl vector59
vector59:
  pushl $0
8010696e:	6a 00                	push   $0x0
  pushl $59
80106970:	6a 3b                	push   $0x3b
  jmp alltraps
80106972:	e9 f7 f8 ff ff       	jmp    8010626e <alltraps>

80106977 <vector60>:
.globl vector60
vector60:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $60
80106979:	6a 3c                	push   $0x3c
  jmp alltraps
8010697b:	e9 ee f8 ff ff       	jmp    8010626e <alltraps>

80106980 <vector61>:
.globl vector61
vector61:
  pushl $0
80106980:	6a 00                	push   $0x0
  pushl $61
80106982:	6a 3d                	push   $0x3d
  jmp alltraps
80106984:	e9 e5 f8 ff ff       	jmp    8010626e <alltraps>

80106989 <vector62>:
.globl vector62
vector62:
  pushl $0
80106989:	6a 00                	push   $0x0
  pushl $62
8010698b:	6a 3e                	push   $0x3e
  jmp alltraps
8010698d:	e9 dc f8 ff ff       	jmp    8010626e <alltraps>

80106992 <vector63>:
.globl vector63
vector63:
  pushl $0
80106992:	6a 00                	push   $0x0
  pushl $63
80106994:	6a 3f                	push   $0x3f
  jmp alltraps
80106996:	e9 d3 f8 ff ff       	jmp    8010626e <alltraps>

8010699b <vector64>:
.globl vector64
vector64:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $64
8010699d:	6a 40                	push   $0x40
  jmp alltraps
8010699f:	e9 ca f8 ff ff       	jmp    8010626e <alltraps>

801069a4 <vector65>:
.globl vector65
vector65:
  pushl $0
801069a4:	6a 00                	push   $0x0
  pushl $65
801069a6:	6a 41                	push   $0x41
  jmp alltraps
801069a8:	e9 c1 f8 ff ff       	jmp    8010626e <alltraps>

801069ad <vector66>:
.globl vector66
vector66:
  pushl $0
801069ad:	6a 00                	push   $0x0
  pushl $66
801069af:	6a 42                	push   $0x42
  jmp alltraps
801069b1:	e9 b8 f8 ff ff       	jmp    8010626e <alltraps>

801069b6 <vector67>:
.globl vector67
vector67:
  pushl $0
801069b6:	6a 00                	push   $0x0
  pushl $67
801069b8:	6a 43                	push   $0x43
  jmp alltraps
801069ba:	e9 af f8 ff ff       	jmp    8010626e <alltraps>

801069bf <vector68>:
.globl vector68
vector68:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $68
801069c1:	6a 44                	push   $0x44
  jmp alltraps
801069c3:	e9 a6 f8 ff ff       	jmp    8010626e <alltraps>

801069c8 <vector69>:
.globl vector69
vector69:
  pushl $0
801069c8:	6a 00                	push   $0x0
  pushl $69
801069ca:	6a 45                	push   $0x45
  jmp alltraps
801069cc:	e9 9d f8 ff ff       	jmp    8010626e <alltraps>

801069d1 <vector70>:
.globl vector70
vector70:
  pushl $0
801069d1:	6a 00                	push   $0x0
  pushl $70
801069d3:	6a 46                	push   $0x46
  jmp alltraps
801069d5:	e9 94 f8 ff ff       	jmp    8010626e <alltraps>

801069da <vector71>:
.globl vector71
vector71:
  pushl $0
801069da:	6a 00                	push   $0x0
  pushl $71
801069dc:	6a 47                	push   $0x47
  jmp alltraps
801069de:	e9 8b f8 ff ff       	jmp    8010626e <alltraps>

801069e3 <vector72>:
.globl vector72
vector72:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $72
801069e5:	6a 48                	push   $0x48
  jmp alltraps
801069e7:	e9 82 f8 ff ff       	jmp    8010626e <alltraps>

801069ec <vector73>:
.globl vector73
vector73:
  pushl $0
801069ec:	6a 00                	push   $0x0
  pushl $73
801069ee:	6a 49                	push   $0x49
  jmp alltraps
801069f0:	e9 79 f8 ff ff       	jmp    8010626e <alltraps>

801069f5 <vector74>:
.globl vector74
vector74:
  pushl $0
801069f5:	6a 00                	push   $0x0
  pushl $74
801069f7:	6a 4a                	push   $0x4a
  jmp alltraps
801069f9:	e9 70 f8 ff ff       	jmp    8010626e <alltraps>

801069fe <vector75>:
.globl vector75
vector75:
  pushl $0
801069fe:	6a 00                	push   $0x0
  pushl $75
80106a00:	6a 4b                	push   $0x4b
  jmp alltraps
80106a02:	e9 67 f8 ff ff       	jmp    8010626e <alltraps>

80106a07 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $76
80106a09:	6a 4c                	push   $0x4c
  jmp alltraps
80106a0b:	e9 5e f8 ff ff       	jmp    8010626e <alltraps>

80106a10 <vector77>:
.globl vector77
vector77:
  pushl $0
80106a10:	6a 00                	push   $0x0
  pushl $77
80106a12:	6a 4d                	push   $0x4d
  jmp alltraps
80106a14:	e9 55 f8 ff ff       	jmp    8010626e <alltraps>

80106a19 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a19:	6a 00                	push   $0x0
  pushl $78
80106a1b:	6a 4e                	push   $0x4e
  jmp alltraps
80106a1d:	e9 4c f8 ff ff       	jmp    8010626e <alltraps>

80106a22 <vector79>:
.globl vector79
vector79:
  pushl $0
80106a22:	6a 00                	push   $0x0
  pushl $79
80106a24:	6a 4f                	push   $0x4f
  jmp alltraps
80106a26:	e9 43 f8 ff ff       	jmp    8010626e <alltraps>

80106a2b <vector80>:
.globl vector80
vector80:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $80
80106a2d:	6a 50                	push   $0x50
  jmp alltraps
80106a2f:	e9 3a f8 ff ff       	jmp    8010626e <alltraps>

80106a34 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a34:	6a 00                	push   $0x0
  pushl $81
80106a36:	6a 51                	push   $0x51
  jmp alltraps
80106a38:	e9 31 f8 ff ff       	jmp    8010626e <alltraps>

80106a3d <vector82>:
.globl vector82
vector82:
  pushl $0
80106a3d:	6a 00                	push   $0x0
  pushl $82
80106a3f:	6a 52                	push   $0x52
  jmp alltraps
80106a41:	e9 28 f8 ff ff       	jmp    8010626e <alltraps>

80106a46 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a46:	6a 00                	push   $0x0
  pushl $83
80106a48:	6a 53                	push   $0x53
  jmp alltraps
80106a4a:	e9 1f f8 ff ff       	jmp    8010626e <alltraps>

80106a4f <vector84>:
.globl vector84
vector84:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $84
80106a51:	6a 54                	push   $0x54
  jmp alltraps
80106a53:	e9 16 f8 ff ff       	jmp    8010626e <alltraps>

80106a58 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a58:	6a 00                	push   $0x0
  pushl $85
80106a5a:	6a 55                	push   $0x55
  jmp alltraps
80106a5c:	e9 0d f8 ff ff       	jmp    8010626e <alltraps>

80106a61 <vector86>:
.globl vector86
vector86:
  pushl $0
80106a61:	6a 00                	push   $0x0
  pushl $86
80106a63:	6a 56                	push   $0x56
  jmp alltraps
80106a65:	e9 04 f8 ff ff       	jmp    8010626e <alltraps>

80106a6a <vector87>:
.globl vector87
vector87:
  pushl $0
80106a6a:	6a 00                	push   $0x0
  pushl $87
80106a6c:	6a 57                	push   $0x57
  jmp alltraps
80106a6e:	e9 fb f7 ff ff       	jmp    8010626e <alltraps>

80106a73 <vector88>:
.globl vector88
vector88:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $88
80106a75:	6a 58                	push   $0x58
  jmp alltraps
80106a77:	e9 f2 f7 ff ff       	jmp    8010626e <alltraps>

80106a7c <vector89>:
.globl vector89
vector89:
  pushl $0
80106a7c:	6a 00                	push   $0x0
  pushl $89
80106a7e:	6a 59                	push   $0x59
  jmp alltraps
80106a80:	e9 e9 f7 ff ff       	jmp    8010626e <alltraps>

80106a85 <vector90>:
.globl vector90
vector90:
  pushl $0
80106a85:	6a 00                	push   $0x0
  pushl $90
80106a87:	6a 5a                	push   $0x5a
  jmp alltraps
80106a89:	e9 e0 f7 ff ff       	jmp    8010626e <alltraps>

80106a8e <vector91>:
.globl vector91
vector91:
  pushl $0
80106a8e:	6a 00                	push   $0x0
  pushl $91
80106a90:	6a 5b                	push   $0x5b
  jmp alltraps
80106a92:	e9 d7 f7 ff ff       	jmp    8010626e <alltraps>

80106a97 <vector92>:
.globl vector92
vector92:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $92
80106a99:	6a 5c                	push   $0x5c
  jmp alltraps
80106a9b:	e9 ce f7 ff ff       	jmp    8010626e <alltraps>

80106aa0 <vector93>:
.globl vector93
vector93:
  pushl $0
80106aa0:	6a 00                	push   $0x0
  pushl $93
80106aa2:	6a 5d                	push   $0x5d
  jmp alltraps
80106aa4:	e9 c5 f7 ff ff       	jmp    8010626e <alltraps>

80106aa9 <vector94>:
.globl vector94
vector94:
  pushl $0
80106aa9:	6a 00                	push   $0x0
  pushl $94
80106aab:	6a 5e                	push   $0x5e
  jmp alltraps
80106aad:	e9 bc f7 ff ff       	jmp    8010626e <alltraps>

80106ab2 <vector95>:
.globl vector95
vector95:
  pushl $0
80106ab2:	6a 00                	push   $0x0
  pushl $95
80106ab4:	6a 5f                	push   $0x5f
  jmp alltraps
80106ab6:	e9 b3 f7 ff ff       	jmp    8010626e <alltraps>

80106abb <vector96>:
.globl vector96
vector96:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $96
80106abd:	6a 60                	push   $0x60
  jmp alltraps
80106abf:	e9 aa f7 ff ff       	jmp    8010626e <alltraps>

80106ac4 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ac4:	6a 00                	push   $0x0
  pushl $97
80106ac6:	6a 61                	push   $0x61
  jmp alltraps
80106ac8:	e9 a1 f7 ff ff       	jmp    8010626e <alltraps>

80106acd <vector98>:
.globl vector98
vector98:
  pushl $0
80106acd:	6a 00                	push   $0x0
  pushl $98
80106acf:	6a 62                	push   $0x62
  jmp alltraps
80106ad1:	e9 98 f7 ff ff       	jmp    8010626e <alltraps>

80106ad6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ad6:	6a 00                	push   $0x0
  pushl $99
80106ad8:	6a 63                	push   $0x63
  jmp alltraps
80106ada:	e9 8f f7 ff ff       	jmp    8010626e <alltraps>

80106adf <vector100>:
.globl vector100
vector100:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $100
80106ae1:	6a 64                	push   $0x64
  jmp alltraps
80106ae3:	e9 86 f7 ff ff       	jmp    8010626e <alltraps>

80106ae8 <vector101>:
.globl vector101
vector101:
  pushl $0
80106ae8:	6a 00                	push   $0x0
  pushl $101
80106aea:	6a 65                	push   $0x65
  jmp alltraps
80106aec:	e9 7d f7 ff ff       	jmp    8010626e <alltraps>

80106af1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106af1:	6a 00                	push   $0x0
  pushl $102
80106af3:	6a 66                	push   $0x66
  jmp alltraps
80106af5:	e9 74 f7 ff ff       	jmp    8010626e <alltraps>

80106afa <vector103>:
.globl vector103
vector103:
  pushl $0
80106afa:	6a 00                	push   $0x0
  pushl $103
80106afc:	6a 67                	push   $0x67
  jmp alltraps
80106afe:	e9 6b f7 ff ff       	jmp    8010626e <alltraps>

80106b03 <vector104>:
.globl vector104
vector104:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $104
80106b05:	6a 68                	push   $0x68
  jmp alltraps
80106b07:	e9 62 f7 ff ff       	jmp    8010626e <alltraps>

80106b0c <vector105>:
.globl vector105
vector105:
  pushl $0
80106b0c:	6a 00                	push   $0x0
  pushl $105
80106b0e:	6a 69                	push   $0x69
  jmp alltraps
80106b10:	e9 59 f7 ff ff       	jmp    8010626e <alltraps>

80106b15 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b15:	6a 00                	push   $0x0
  pushl $106
80106b17:	6a 6a                	push   $0x6a
  jmp alltraps
80106b19:	e9 50 f7 ff ff       	jmp    8010626e <alltraps>

80106b1e <vector107>:
.globl vector107
vector107:
  pushl $0
80106b1e:	6a 00                	push   $0x0
  pushl $107
80106b20:	6a 6b                	push   $0x6b
  jmp alltraps
80106b22:	e9 47 f7 ff ff       	jmp    8010626e <alltraps>

80106b27 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $108
80106b29:	6a 6c                	push   $0x6c
  jmp alltraps
80106b2b:	e9 3e f7 ff ff       	jmp    8010626e <alltraps>

80106b30 <vector109>:
.globl vector109
vector109:
  pushl $0
80106b30:	6a 00                	push   $0x0
  pushl $109
80106b32:	6a 6d                	push   $0x6d
  jmp alltraps
80106b34:	e9 35 f7 ff ff       	jmp    8010626e <alltraps>

80106b39 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b39:	6a 00                	push   $0x0
  pushl $110
80106b3b:	6a 6e                	push   $0x6e
  jmp alltraps
80106b3d:	e9 2c f7 ff ff       	jmp    8010626e <alltraps>

80106b42 <vector111>:
.globl vector111
vector111:
  pushl $0
80106b42:	6a 00                	push   $0x0
  pushl $111
80106b44:	6a 6f                	push   $0x6f
  jmp alltraps
80106b46:	e9 23 f7 ff ff       	jmp    8010626e <alltraps>

80106b4b <vector112>:
.globl vector112
vector112:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $112
80106b4d:	6a 70                	push   $0x70
  jmp alltraps
80106b4f:	e9 1a f7 ff ff       	jmp    8010626e <alltraps>

80106b54 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b54:	6a 00                	push   $0x0
  pushl $113
80106b56:	6a 71                	push   $0x71
  jmp alltraps
80106b58:	e9 11 f7 ff ff       	jmp    8010626e <alltraps>

80106b5d <vector114>:
.globl vector114
vector114:
  pushl $0
80106b5d:	6a 00                	push   $0x0
  pushl $114
80106b5f:	6a 72                	push   $0x72
  jmp alltraps
80106b61:	e9 08 f7 ff ff       	jmp    8010626e <alltraps>

80106b66 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b66:	6a 00                	push   $0x0
  pushl $115
80106b68:	6a 73                	push   $0x73
  jmp alltraps
80106b6a:	e9 ff f6 ff ff       	jmp    8010626e <alltraps>

80106b6f <vector116>:
.globl vector116
vector116:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $116
80106b71:	6a 74                	push   $0x74
  jmp alltraps
80106b73:	e9 f6 f6 ff ff       	jmp    8010626e <alltraps>

80106b78 <vector117>:
.globl vector117
vector117:
  pushl $0
80106b78:	6a 00                	push   $0x0
  pushl $117
80106b7a:	6a 75                	push   $0x75
  jmp alltraps
80106b7c:	e9 ed f6 ff ff       	jmp    8010626e <alltraps>

80106b81 <vector118>:
.globl vector118
vector118:
  pushl $0
80106b81:	6a 00                	push   $0x0
  pushl $118
80106b83:	6a 76                	push   $0x76
  jmp alltraps
80106b85:	e9 e4 f6 ff ff       	jmp    8010626e <alltraps>

80106b8a <vector119>:
.globl vector119
vector119:
  pushl $0
80106b8a:	6a 00                	push   $0x0
  pushl $119
80106b8c:	6a 77                	push   $0x77
  jmp alltraps
80106b8e:	e9 db f6 ff ff       	jmp    8010626e <alltraps>

80106b93 <vector120>:
.globl vector120
vector120:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $120
80106b95:	6a 78                	push   $0x78
  jmp alltraps
80106b97:	e9 d2 f6 ff ff       	jmp    8010626e <alltraps>

80106b9c <vector121>:
.globl vector121
vector121:
  pushl $0
80106b9c:	6a 00                	push   $0x0
  pushl $121
80106b9e:	6a 79                	push   $0x79
  jmp alltraps
80106ba0:	e9 c9 f6 ff ff       	jmp    8010626e <alltraps>

80106ba5 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ba5:	6a 00                	push   $0x0
  pushl $122
80106ba7:	6a 7a                	push   $0x7a
  jmp alltraps
80106ba9:	e9 c0 f6 ff ff       	jmp    8010626e <alltraps>

80106bae <vector123>:
.globl vector123
vector123:
  pushl $0
80106bae:	6a 00                	push   $0x0
  pushl $123
80106bb0:	6a 7b                	push   $0x7b
  jmp alltraps
80106bb2:	e9 b7 f6 ff ff       	jmp    8010626e <alltraps>

80106bb7 <vector124>:
.globl vector124
vector124:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $124
80106bb9:	6a 7c                	push   $0x7c
  jmp alltraps
80106bbb:	e9 ae f6 ff ff       	jmp    8010626e <alltraps>

80106bc0 <vector125>:
.globl vector125
vector125:
  pushl $0
80106bc0:	6a 00                	push   $0x0
  pushl $125
80106bc2:	6a 7d                	push   $0x7d
  jmp alltraps
80106bc4:	e9 a5 f6 ff ff       	jmp    8010626e <alltraps>

80106bc9 <vector126>:
.globl vector126
vector126:
  pushl $0
80106bc9:	6a 00                	push   $0x0
  pushl $126
80106bcb:	6a 7e                	push   $0x7e
  jmp alltraps
80106bcd:	e9 9c f6 ff ff       	jmp    8010626e <alltraps>

80106bd2 <vector127>:
.globl vector127
vector127:
  pushl $0
80106bd2:	6a 00                	push   $0x0
  pushl $127
80106bd4:	6a 7f                	push   $0x7f
  jmp alltraps
80106bd6:	e9 93 f6 ff ff       	jmp    8010626e <alltraps>

80106bdb <vector128>:
.globl vector128
vector128:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $128
80106bdd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106be2:	e9 87 f6 ff ff       	jmp    8010626e <alltraps>

80106be7 <vector129>:
.globl vector129
vector129:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $129
80106be9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106bee:	e9 7b f6 ff ff       	jmp    8010626e <alltraps>

80106bf3 <vector130>:
.globl vector130
vector130:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $130
80106bf5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106bfa:	e9 6f f6 ff ff       	jmp    8010626e <alltraps>

80106bff <vector131>:
.globl vector131
vector131:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $131
80106c01:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c06:	e9 63 f6 ff ff       	jmp    8010626e <alltraps>

80106c0b <vector132>:
.globl vector132
vector132:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $132
80106c0d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c12:	e9 57 f6 ff ff       	jmp    8010626e <alltraps>

80106c17 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $133
80106c19:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c1e:	e9 4b f6 ff ff       	jmp    8010626e <alltraps>

80106c23 <vector134>:
.globl vector134
vector134:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $134
80106c25:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c2a:	e9 3f f6 ff ff       	jmp    8010626e <alltraps>

80106c2f <vector135>:
.globl vector135
vector135:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $135
80106c31:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c36:	e9 33 f6 ff ff       	jmp    8010626e <alltraps>

80106c3b <vector136>:
.globl vector136
vector136:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $136
80106c3d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c42:	e9 27 f6 ff ff       	jmp    8010626e <alltraps>

80106c47 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $137
80106c49:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c4e:	e9 1b f6 ff ff       	jmp    8010626e <alltraps>

80106c53 <vector138>:
.globl vector138
vector138:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $138
80106c55:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c5a:	e9 0f f6 ff ff       	jmp    8010626e <alltraps>

80106c5f <vector139>:
.globl vector139
vector139:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $139
80106c61:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c66:	e9 03 f6 ff ff       	jmp    8010626e <alltraps>

80106c6b <vector140>:
.globl vector140
vector140:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $140
80106c6d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c72:	e9 f7 f5 ff ff       	jmp    8010626e <alltraps>

80106c77 <vector141>:
.globl vector141
vector141:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $141
80106c79:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106c7e:	e9 eb f5 ff ff       	jmp    8010626e <alltraps>

80106c83 <vector142>:
.globl vector142
vector142:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $142
80106c85:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106c8a:	e9 df f5 ff ff       	jmp    8010626e <alltraps>

80106c8f <vector143>:
.globl vector143
vector143:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $143
80106c91:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106c96:	e9 d3 f5 ff ff       	jmp    8010626e <alltraps>

80106c9b <vector144>:
.globl vector144
vector144:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $144
80106c9d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106ca2:	e9 c7 f5 ff ff       	jmp    8010626e <alltraps>

80106ca7 <vector145>:
.globl vector145
vector145:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $145
80106ca9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106cae:	e9 bb f5 ff ff       	jmp    8010626e <alltraps>

80106cb3 <vector146>:
.globl vector146
vector146:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $146
80106cb5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106cba:	e9 af f5 ff ff       	jmp    8010626e <alltraps>

80106cbf <vector147>:
.globl vector147
vector147:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $147
80106cc1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106cc6:	e9 a3 f5 ff ff       	jmp    8010626e <alltraps>

80106ccb <vector148>:
.globl vector148
vector148:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $148
80106ccd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106cd2:	e9 97 f5 ff ff       	jmp    8010626e <alltraps>

80106cd7 <vector149>:
.globl vector149
vector149:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $149
80106cd9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106cde:	e9 8b f5 ff ff       	jmp    8010626e <alltraps>

80106ce3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $150
80106ce5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106cea:	e9 7f f5 ff ff       	jmp    8010626e <alltraps>

80106cef <vector151>:
.globl vector151
vector151:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $151
80106cf1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106cf6:	e9 73 f5 ff ff       	jmp    8010626e <alltraps>

80106cfb <vector152>:
.globl vector152
vector152:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $152
80106cfd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d02:	e9 67 f5 ff ff       	jmp    8010626e <alltraps>

80106d07 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $153
80106d09:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d0e:	e9 5b f5 ff ff       	jmp    8010626e <alltraps>

80106d13 <vector154>:
.globl vector154
vector154:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $154
80106d15:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d1a:	e9 4f f5 ff ff       	jmp    8010626e <alltraps>

80106d1f <vector155>:
.globl vector155
vector155:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $155
80106d21:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d26:	e9 43 f5 ff ff       	jmp    8010626e <alltraps>

80106d2b <vector156>:
.globl vector156
vector156:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $156
80106d2d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d32:	e9 37 f5 ff ff       	jmp    8010626e <alltraps>

80106d37 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $157
80106d39:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d3e:	e9 2b f5 ff ff       	jmp    8010626e <alltraps>

80106d43 <vector158>:
.globl vector158
vector158:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $158
80106d45:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d4a:	e9 1f f5 ff ff       	jmp    8010626e <alltraps>

80106d4f <vector159>:
.globl vector159
vector159:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $159
80106d51:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d56:	e9 13 f5 ff ff       	jmp    8010626e <alltraps>

80106d5b <vector160>:
.globl vector160
vector160:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $160
80106d5d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d62:	e9 07 f5 ff ff       	jmp    8010626e <alltraps>

80106d67 <vector161>:
.globl vector161
vector161:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $161
80106d69:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d6e:	e9 fb f4 ff ff       	jmp    8010626e <alltraps>

80106d73 <vector162>:
.globl vector162
vector162:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $162
80106d75:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106d7a:	e9 ef f4 ff ff       	jmp    8010626e <alltraps>

80106d7f <vector163>:
.globl vector163
vector163:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $163
80106d81:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106d86:	e9 e3 f4 ff ff       	jmp    8010626e <alltraps>

80106d8b <vector164>:
.globl vector164
vector164:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $164
80106d8d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106d92:	e9 d7 f4 ff ff       	jmp    8010626e <alltraps>

80106d97 <vector165>:
.globl vector165
vector165:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $165
80106d99:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106d9e:	e9 cb f4 ff ff       	jmp    8010626e <alltraps>

80106da3 <vector166>:
.globl vector166
vector166:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $166
80106da5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106daa:	e9 bf f4 ff ff       	jmp    8010626e <alltraps>

80106daf <vector167>:
.globl vector167
vector167:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $167
80106db1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106db6:	e9 b3 f4 ff ff       	jmp    8010626e <alltraps>

80106dbb <vector168>:
.globl vector168
vector168:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $168
80106dbd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106dc2:	e9 a7 f4 ff ff       	jmp    8010626e <alltraps>

80106dc7 <vector169>:
.globl vector169
vector169:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $169
80106dc9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106dce:	e9 9b f4 ff ff       	jmp    8010626e <alltraps>

80106dd3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $170
80106dd5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106dda:	e9 8f f4 ff ff       	jmp    8010626e <alltraps>

80106ddf <vector171>:
.globl vector171
vector171:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $171
80106de1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106de6:	e9 83 f4 ff ff       	jmp    8010626e <alltraps>

80106deb <vector172>:
.globl vector172
vector172:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $172
80106ded:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106df2:	e9 77 f4 ff ff       	jmp    8010626e <alltraps>

80106df7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $173
80106df9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106dfe:	e9 6b f4 ff ff       	jmp    8010626e <alltraps>

80106e03 <vector174>:
.globl vector174
vector174:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $174
80106e05:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e0a:	e9 5f f4 ff ff       	jmp    8010626e <alltraps>

80106e0f <vector175>:
.globl vector175
vector175:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $175
80106e11:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e16:	e9 53 f4 ff ff       	jmp    8010626e <alltraps>

80106e1b <vector176>:
.globl vector176
vector176:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $176
80106e1d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e22:	e9 47 f4 ff ff       	jmp    8010626e <alltraps>

80106e27 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $177
80106e29:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e2e:	e9 3b f4 ff ff       	jmp    8010626e <alltraps>

80106e33 <vector178>:
.globl vector178
vector178:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $178
80106e35:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e3a:	e9 2f f4 ff ff       	jmp    8010626e <alltraps>

80106e3f <vector179>:
.globl vector179
vector179:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $179
80106e41:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e46:	e9 23 f4 ff ff       	jmp    8010626e <alltraps>

80106e4b <vector180>:
.globl vector180
vector180:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $180
80106e4d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e52:	e9 17 f4 ff ff       	jmp    8010626e <alltraps>

80106e57 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $181
80106e59:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e5e:	e9 0b f4 ff ff       	jmp    8010626e <alltraps>

80106e63 <vector182>:
.globl vector182
vector182:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $182
80106e65:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e6a:	e9 ff f3 ff ff       	jmp    8010626e <alltraps>

80106e6f <vector183>:
.globl vector183
vector183:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $183
80106e71:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106e76:	e9 f3 f3 ff ff       	jmp    8010626e <alltraps>

80106e7b <vector184>:
.globl vector184
vector184:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $184
80106e7d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106e82:	e9 e7 f3 ff ff       	jmp    8010626e <alltraps>

80106e87 <vector185>:
.globl vector185
vector185:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $185
80106e89:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106e8e:	e9 db f3 ff ff       	jmp    8010626e <alltraps>

80106e93 <vector186>:
.globl vector186
vector186:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $186
80106e95:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106e9a:	e9 cf f3 ff ff       	jmp    8010626e <alltraps>

80106e9f <vector187>:
.globl vector187
vector187:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $187
80106ea1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ea6:	e9 c3 f3 ff ff       	jmp    8010626e <alltraps>

80106eab <vector188>:
.globl vector188
vector188:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $188
80106ead:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106eb2:	e9 b7 f3 ff ff       	jmp    8010626e <alltraps>

80106eb7 <vector189>:
.globl vector189
vector189:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $189
80106eb9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106ebe:	e9 ab f3 ff ff       	jmp    8010626e <alltraps>

80106ec3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $190
80106ec5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106eca:	e9 9f f3 ff ff       	jmp    8010626e <alltraps>

80106ecf <vector191>:
.globl vector191
vector191:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $191
80106ed1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106ed6:	e9 93 f3 ff ff       	jmp    8010626e <alltraps>

80106edb <vector192>:
.globl vector192
vector192:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $192
80106edd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106ee2:	e9 87 f3 ff ff       	jmp    8010626e <alltraps>

80106ee7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $193
80106ee9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106eee:	e9 7b f3 ff ff       	jmp    8010626e <alltraps>

80106ef3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $194
80106ef5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106efa:	e9 6f f3 ff ff       	jmp    8010626e <alltraps>

80106eff <vector195>:
.globl vector195
vector195:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $195
80106f01:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f06:	e9 63 f3 ff ff       	jmp    8010626e <alltraps>

80106f0b <vector196>:
.globl vector196
vector196:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $196
80106f0d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f12:	e9 57 f3 ff ff       	jmp    8010626e <alltraps>

80106f17 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $197
80106f19:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f1e:	e9 4b f3 ff ff       	jmp    8010626e <alltraps>

80106f23 <vector198>:
.globl vector198
vector198:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $198
80106f25:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f2a:	e9 3f f3 ff ff       	jmp    8010626e <alltraps>

80106f2f <vector199>:
.globl vector199
vector199:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $199
80106f31:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f36:	e9 33 f3 ff ff       	jmp    8010626e <alltraps>

80106f3b <vector200>:
.globl vector200
vector200:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $200
80106f3d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f42:	e9 27 f3 ff ff       	jmp    8010626e <alltraps>

80106f47 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $201
80106f49:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f4e:	e9 1b f3 ff ff       	jmp    8010626e <alltraps>

80106f53 <vector202>:
.globl vector202
vector202:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $202
80106f55:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f5a:	e9 0f f3 ff ff       	jmp    8010626e <alltraps>

80106f5f <vector203>:
.globl vector203
vector203:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $203
80106f61:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f66:	e9 03 f3 ff ff       	jmp    8010626e <alltraps>

80106f6b <vector204>:
.globl vector204
vector204:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $204
80106f6d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f72:	e9 f7 f2 ff ff       	jmp    8010626e <alltraps>

80106f77 <vector205>:
.globl vector205
vector205:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $205
80106f79:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106f7e:	e9 eb f2 ff ff       	jmp    8010626e <alltraps>

80106f83 <vector206>:
.globl vector206
vector206:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $206
80106f85:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106f8a:	e9 df f2 ff ff       	jmp    8010626e <alltraps>

80106f8f <vector207>:
.globl vector207
vector207:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $207
80106f91:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106f96:	e9 d3 f2 ff ff       	jmp    8010626e <alltraps>

80106f9b <vector208>:
.globl vector208
vector208:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $208
80106f9d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106fa2:	e9 c7 f2 ff ff       	jmp    8010626e <alltraps>

80106fa7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $209
80106fa9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106fae:	e9 bb f2 ff ff       	jmp    8010626e <alltraps>

80106fb3 <vector210>:
.globl vector210
vector210:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $210
80106fb5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106fba:	e9 af f2 ff ff       	jmp    8010626e <alltraps>

80106fbf <vector211>:
.globl vector211
vector211:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $211
80106fc1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106fc6:	e9 a3 f2 ff ff       	jmp    8010626e <alltraps>

80106fcb <vector212>:
.globl vector212
vector212:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $212
80106fcd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106fd2:	e9 97 f2 ff ff       	jmp    8010626e <alltraps>

80106fd7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $213
80106fd9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106fde:	e9 8b f2 ff ff       	jmp    8010626e <alltraps>

80106fe3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $214
80106fe5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106fea:	e9 7f f2 ff ff       	jmp    8010626e <alltraps>

80106fef <vector215>:
.globl vector215
vector215:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $215
80106ff1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ff6:	e9 73 f2 ff ff       	jmp    8010626e <alltraps>

80106ffb <vector216>:
.globl vector216
vector216:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $216
80106ffd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107002:	e9 67 f2 ff ff       	jmp    8010626e <alltraps>

80107007 <vector217>:
.globl vector217
vector217:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $217
80107009:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010700e:	e9 5b f2 ff ff       	jmp    8010626e <alltraps>

80107013 <vector218>:
.globl vector218
vector218:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $218
80107015:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010701a:	e9 4f f2 ff ff       	jmp    8010626e <alltraps>

8010701f <vector219>:
.globl vector219
vector219:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $219
80107021:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107026:	e9 43 f2 ff ff       	jmp    8010626e <alltraps>

8010702b <vector220>:
.globl vector220
vector220:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $220
8010702d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107032:	e9 37 f2 ff ff       	jmp    8010626e <alltraps>

80107037 <vector221>:
.globl vector221
vector221:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $221
80107039:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010703e:	e9 2b f2 ff ff       	jmp    8010626e <alltraps>

80107043 <vector222>:
.globl vector222
vector222:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $222
80107045:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010704a:	e9 1f f2 ff ff       	jmp    8010626e <alltraps>

8010704f <vector223>:
.globl vector223
vector223:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $223
80107051:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107056:	e9 13 f2 ff ff       	jmp    8010626e <alltraps>

8010705b <vector224>:
.globl vector224
vector224:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $224
8010705d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107062:	e9 07 f2 ff ff       	jmp    8010626e <alltraps>

80107067 <vector225>:
.globl vector225
vector225:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $225
80107069:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010706e:	e9 fb f1 ff ff       	jmp    8010626e <alltraps>

80107073 <vector226>:
.globl vector226
vector226:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $226
80107075:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010707a:	e9 ef f1 ff ff       	jmp    8010626e <alltraps>

8010707f <vector227>:
.globl vector227
vector227:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $227
80107081:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107086:	e9 e3 f1 ff ff       	jmp    8010626e <alltraps>

8010708b <vector228>:
.globl vector228
vector228:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $228
8010708d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107092:	e9 d7 f1 ff ff       	jmp    8010626e <alltraps>

80107097 <vector229>:
.globl vector229
vector229:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $229
80107099:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010709e:	e9 cb f1 ff ff       	jmp    8010626e <alltraps>

801070a3 <vector230>:
.globl vector230
vector230:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $230
801070a5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801070aa:	e9 bf f1 ff ff       	jmp    8010626e <alltraps>

801070af <vector231>:
.globl vector231
vector231:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $231
801070b1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801070b6:	e9 b3 f1 ff ff       	jmp    8010626e <alltraps>

801070bb <vector232>:
.globl vector232
vector232:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $232
801070bd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801070c2:	e9 a7 f1 ff ff       	jmp    8010626e <alltraps>

801070c7 <vector233>:
.globl vector233
vector233:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $233
801070c9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801070ce:	e9 9b f1 ff ff       	jmp    8010626e <alltraps>

801070d3 <vector234>:
.globl vector234
vector234:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $234
801070d5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801070da:	e9 8f f1 ff ff       	jmp    8010626e <alltraps>

801070df <vector235>:
.globl vector235
vector235:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $235
801070e1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801070e6:	e9 83 f1 ff ff       	jmp    8010626e <alltraps>

801070eb <vector236>:
.globl vector236
vector236:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $236
801070ed:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801070f2:	e9 77 f1 ff ff       	jmp    8010626e <alltraps>

801070f7 <vector237>:
.globl vector237
vector237:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $237
801070f9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801070fe:	e9 6b f1 ff ff       	jmp    8010626e <alltraps>

80107103 <vector238>:
.globl vector238
vector238:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $238
80107105:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010710a:	e9 5f f1 ff ff       	jmp    8010626e <alltraps>

8010710f <vector239>:
.globl vector239
vector239:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $239
80107111:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107116:	e9 53 f1 ff ff       	jmp    8010626e <alltraps>

8010711b <vector240>:
.globl vector240
vector240:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $240
8010711d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107122:	e9 47 f1 ff ff       	jmp    8010626e <alltraps>

80107127 <vector241>:
.globl vector241
vector241:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $241
80107129:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010712e:	e9 3b f1 ff ff       	jmp    8010626e <alltraps>

80107133 <vector242>:
.globl vector242
vector242:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $242
80107135:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010713a:	e9 2f f1 ff ff       	jmp    8010626e <alltraps>

8010713f <vector243>:
.globl vector243
vector243:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $243
80107141:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107146:	e9 23 f1 ff ff       	jmp    8010626e <alltraps>

8010714b <vector244>:
.globl vector244
vector244:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $244
8010714d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107152:	e9 17 f1 ff ff       	jmp    8010626e <alltraps>

80107157 <vector245>:
.globl vector245
vector245:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $245
80107159:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010715e:	e9 0b f1 ff ff       	jmp    8010626e <alltraps>

80107163 <vector246>:
.globl vector246
vector246:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $246
80107165:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010716a:	e9 ff f0 ff ff       	jmp    8010626e <alltraps>

8010716f <vector247>:
.globl vector247
vector247:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $247
80107171:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107176:	e9 f3 f0 ff ff       	jmp    8010626e <alltraps>

8010717b <vector248>:
.globl vector248
vector248:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $248
8010717d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107182:	e9 e7 f0 ff ff       	jmp    8010626e <alltraps>

80107187 <vector249>:
.globl vector249
vector249:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $249
80107189:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010718e:	e9 db f0 ff ff       	jmp    8010626e <alltraps>

80107193 <vector250>:
.globl vector250
vector250:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $250
80107195:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010719a:	e9 cf f0 ff ff       	jmp    8010626e <alltraps>

8010719f <vector251>:
.globl vector251
vector251:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $251
801071a1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801071a6:	e9 c3 f0 ff ff       	jmp    8010626e <alltraps>

801071ab <vector252>:
.globl vector252
vector252:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $252
801071ad:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801071b2:	e9 b7 f0 ff ff       	jmp    8010626e <alltraps>

801071b7 <vector253>:
.globl vector253
vector253:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $253
801071b9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801071be:	e9 ab f0 ff ff       	jmp    8010626e <alltraps>

801071c3 <vector254>:
.globl vector254
vector254:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $254
801071c5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801071ca:	e9 9f f0 ff ff       	jmp    8010626e <alltraps>

801071cf <vector255>:
.globl vector255
vector255:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $255
801071d1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801071d6:	e9 93 f0 ff ff       	jmp    8010626e <alltraps>
801071db:	66 90                	xchg   %ax,%ax
801071dd:	66 90                	xchg   %ax,%ax
801071df:	90                   	nop

801071e0 <seginit>:
pde_t *kpgdir;      // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void seginit(void)
{
801071e0:	f3 0f 1e fb          	endbr32 
801071e4:	55                   	push   %ebp
801071e5:	89 e5                	mov    %esp,%ebp
801071e7:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801071ea:	e8 41 d0 ff ff       	call   80104230 <cpuid>
  pd[0] = size-1;
801071ef:	ba 2f 00 00 00       	mov    $0x2f,%edx
801071f4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801071fa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
801071fe:	c7 80 58 98 11 80 ff 	movl   $0xffff,-0x7fee67a8(%eax)
80107205:	ff 00 00 
80107208:	c7 80 5c 98 11 80 00 	movl   $0xcf9a00,-0x7fee67a4(%eax)
8010720f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107212:	c7 80 60 98 11 80 ff 	movl   $0xffff,-0x7fee67a0(%eax)
80107219:	ff 00 00 
8010721c:	c7 80 64 98 11 80 00 	movl   $0xcf9200,-0x7fee679c(%eax)
80107223:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80107226:	c7 80 68 98 11 80 ff 	movl   $0xffff,-0x7fee6798(%eax)
8010722d:	ff 00 00 
80107230:	c7 80 6c 98 11 80 00 	movl   $0xcffa00,-0x7fee6794(%eax)
80107237:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010723a:	c7 80 70 98 11 80 ff 	movl   $0xffff,-0x7fee6790(%eax)
80107241:	ff 00 00 
80107244:	c7 80 74 98 11 80 00 	movl   $0xcff200,-0x7fee678c(%eax)
8010724b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010724e:	05 50 98 11 80       	add    $0x80119850,%eax
  pd[1] = (uint)p;
80107253:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107257:	c1 e8 10             	shr    $0x10,%eax
8010725a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010725e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107261:	0f 01 10             	lgdtl  (%eax)
}
80107264:	c9                   	leave  
80107265:	c3                   	ret    
80107266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726d:	8d 76 00             	lea    0x0(%esi),%esi

80107270 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107270:	f3 0f 1e fb          	endbr32 
80107274:	55                   	push   %ebp
80107275:	89 e5                	mov    %esp,%ebp
80107277:	57                   	push   %edi
80107278:	56                   	push   %esi
80107279:	53                   	push   %ebx
8010727a:	83 ec 0c             	sub    $0xc,%esp
8010727d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107280:	8b 55 08             	mov    0x8(%ebp),%edx
80107283:	89 fe                	mov    %edi,%esi
80107285:	c1 ee 16             	shr    $0x16,%esi
80107288:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if (*pde & PTE_P)
8010728b:	8b 1e                	mov    (%esi),%ebx
8010728d:	f6 c3 01             	test   $0x1,%bl
80107290:	74 26                	je     801072b8 <walkpgdir+0x48>
  {
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
80107292:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107298:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010729e:	89 f8                	mov    %edi,%eax
}
801072a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801072a3:	c1 e8 0a             	shr    $0xa,%eax
801072a6:	25 fc 0f 00 00       	and    $0xffc,%eax
801072ab:	01 d8                	add    %ebx,%eax
}
801072ad:	5b                   	pop    %ebx
801072ae:	5e                   	pop    %esi
801072af:	5f                   	pop    %edi
801072b0:	5d                   	pop    %ebp
801072b1:	c3                   	ret    
801072b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (!alloc || (pgtab = (pte_t *)kalloc()) == 0)
801072b8:	8b 45 10             	mov    0x10(%ebp),%eax
801072bb:	85 c0                	test   %eax,%eax
801072bd:	74 31                	je     801072f0 <walkpgdir+0x80>
801072bf:	e8 7c ba ff ff       	call   80102d40 <kalloc>
801072c4:	89 c3                	mov    %eax,%ebx
801072c6:	85 c0                	test   %eax,%eax
801072c8:	74 26                	je     801072f0 <walkpgdir+0x80>
    memset(pgtab, 0, PGSIZE);
801072ca:	83 ec 04             	sub    $0x4,%esp
801072cd:	68 00 10 00 00       	push   $0x1000
801072d2:	6a 00                	push   $0x0
801072d4:	50                   	push   %eax
801072d5:	e8 76 dc ff ff       	call   80104f50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801072da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072e0:	83 c4 10             	add    $0x10,%esp
801072e3:	83 c8 07             	or     $0x7,%eax
801072e6:	89 06                	mov    %eax,(%esi)
801072e8:	eb b4                	jmp    8010729e <walkpgdir+0x2e>
801072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
801072f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801072f3:	31 c0                	xor    %eax,%eax
}
801072f5:	5b                   	pop    %ebx
801072f6:	5e                   	pop    %esi
801072f7:	5f                   	pop    %edi
801072f8:	5d                   	pop    %ebp
801072f9:	c3                   	ret    
801072fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107300 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	57                   	push   %edi
80107304:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char *)PGROUNDDOWN((uint)va);
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80107306:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010730a:	56                   	push   %esi
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
8010730b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char *)PGROUNDDOWN((uint)va);
80107310:	89 d6                	mov    %edx,%esi
{
80107312:	53                   	push   %ebx
  a = (char *)PGROUNDDOWN((uint)va);
80107313:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107319:	83 ec 1c             	sub    $0x1c,%esp
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
8010731c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010731f:	8b 45 08             	mov    0x8(%ebp),%eax
80107322:	29 f0                	sub    %esi,%eax
80107324:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107327:	eb 1f                	jmp    80107348 <mappages+0x48>
80107329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (;;)
  {
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if (*pte & PTE_P)
80107330:	f6 00 01             	testb  $0x1,(%eax)
80107333:	75 45                	jne    8010737a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107335:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107338:	83 cb 01             	or     $0x1,%ebx
8010733b:	89 18                	mov    %ebx,(%eax)
    if (a == last)
8010733d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107340:	74 2e                	je     80107370 <mappages+0x70>
      break;
    a += PGSIZE;
80107342:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
80107348:	83 ec 04             	sub    $0x4,%esp
8010734b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010734e:	6a 01                	push   $0x1
80107350:	56                   	push   %esi
80107351:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107354:	57                   	push   %edi
80107355:	e8 16 ff ff ff       	call   80107270 <walkpgdir>
8010735a:	83 c4 10             	add    $0x10,%esp
8010735d:	85 c0                	test   %eax,%eax
8010735f:	75 cf                	jne    80107330 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107361:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107369:	5b                   	pop    %ebx
8010736a:	5e                   	pop    %esi
8010736b:	5f                   	pop    %edi
8010736c:	5d                   	pop    %ebp
8010736d:	c3                   	ret    
8010736e:	66 90                	xchg   %ax,%ax
80107370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107373:	31 c0                	xor    %eax,%eax
}
80107375:	5b                   	pop    %ebx
80107376:	5e                   	pop    %esi
80107377:	5f                   	pop    %edi
80107378:	5d                   	pop    %ebp
80107379:	c3                   	ret    
      panic("remap");
8010737a:	83 ec 0c             	sub    $0xc,%esp
8010737d:	68 bc 89 10 80       	push   $0x801089bc
80107382:	e8 09 90 ff ff       	call   80100390 <panic>
80107387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010738e:	66 90                	xchg   %ax,%ax

80107390 <deallocuvm.part.0>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
80107395:	89 c6                	mov    %eax,%esi
80107397:	53                   	push   %ebx
80107398:	89 d3                	mov    %edx,%ebx
8010739a:	83 ec 1c             	sub    $0x1c,%esp
8010739d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  int bitmap_offset;

  if (newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801073a0:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801073a6:	89 d7                	mov    %edx,%edi
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801073a8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  a = PGROUNDUP(newsz);
801073ab:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for (; a < oldsz; a += PGSIZE)
801073b1:	39 df                	cmp    %ebx,%edi
801073b3:	72 55                	jb     8010740a <deallocuvm.part.0+0x7a>
801073b5:	e9 96 00 00 00       	jmp    80107450 <deallocuvm.part.0+0xc0>
801073ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (!pte) // pte not exist
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if ((*pte & PTE_P) != 0) // swapped in pages(PTE_P is set)
    {
      pa = PTE_ADDR(*pte);
      if (pa == 0)
801073c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801073c6:	0f 84 a4 00 00 00    	je     80107470 <deallocuvm.part.0+0xe0>
        panic("kfree");
      char *v = P2V(pa);
      // remove from LRU list
      cprintf("delete lru page call\n");
801073cc:	83 ec 0c             	sub    $0xc,%esp
801073cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
      char *v = P2V(pa);
801073d2:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
      cprintf("delete lru page call\n");
801073d8:	68 c2 89 10 80       	push   $0x801089c2
801073dd:	e8 ce 92 ff ff       	call   801006b0 <cprintf>
      page_delete(pgdir, (char *)a);
801073e2:	58                   	pop    %eax
801073e3:	5a                   	pop    %edx
801073e4:	57                   	push   %edi
801073e5:	56                   	push   %esi
801073e6:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073ec:	e8 5f b6 ff ff       	call   80102a50 <page_delete>
      kfree(v);
801073f1:	89 1c 24             	mov    %ebx,(%esp)
801073f4:	e8 87 b1 ff ff       	call   80102580 <kfree>
      *pte = 0;
801073f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
801073fc:	83 c4 10             	add    $0x10,%esp
801073ff:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for (; a < oldsz; a += PGSIZE)
80107405:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107408:	76 46                	jbe    80107450 <deallocuvm.part.0+0xc0>
    pte = walkpgdir(pgdir, (char *)a, 0);
8010740a:	83 ec 04             	sub    $0x4,%esp
8010740d:	6a 00                	push   $0x0
8010740f:	57                   	push   %edi
80107410:	56                   	push   %esi
80107411:	e8 5a fe ff ff       	call   80107270 <walkpgdir>
    if (!pte) // pte not exist
80107416:	83 c4 10             	add    $0x10,%esp
80107419:	85 c0                	test   %eax,%eax
8010741b:	74 43                	je     80107460 <deallocuvm.part.0+0xd0>
    else if ((*pte & PTE_P) != 0) // swapped in pages(PTE_P is set)
8010741d:	8b 18                	mov    (%eax),%ebx
8010741f:	f6 c3 01             	test   $0x1,%bl
80107422:	75 9c                	jne    801073c0 <deallocuvm.part.0+0x30>
    }
    else if (*pte != 0) // swapped out pages(pte is not zero, PTE_P is clear)
80107424:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010742a:	85 db                	test   %ebx,%ebx
8010742c:	74 d7                	je     80107405 <deallocuvm.part.0+0x75>
    {
      // clear in bitmap
      pa = PTE_ADDR(*pte);
      bitmap_offset = (int)(pa >> 12);
      bitmap_modify(bitmap_offset, 0);
8010742e:	83 ec 08             	sub    $0x8,%esp
      bitmap_offset = (int)(pa >> 12);
80107431:	c1 eb 0c             	shr    $0xc,%ebx
80107434:	89 45 e0             	mov    %eax,-0x20(%ebp)
      bitmap_modify(bitmap_offset, 0);
80107437:	6a 00                	push   $0x0
80107439:	53                   	push   %ebx
8010743a:	e8 f1 b9 ff ff       	call   80102e30 <bitmap_modify>
      // page_delete(pgdir, (char *)a);
      // clear page table entry
      *pte = 0;
8010743f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107442:	83 c4 10             	add    $0x10,%esp
80107445:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for (; a < oldsz; a += PGSIZE)
8010744b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010744e:	77 ba                	ja     8010740a <deallocuvm.part.0+0x7a>
    }
  }
  return newsz;
}
80107450:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107453:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107456:	5b                   	pop    %ebx
80107457:	5e                   	pop    %esi
80107458:	5f                   	pop    %edi
80107459:	5d                   	pop    %ebp
8010745a:	c3                   	ret    
8010745b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010745f:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107460:	89 f9                	mov    %edi,%ecx
80107462:	81 e1 00 00 c0 ff    	and    $0xffc00000,%ecx
80107468:	8d b9 00 00 40 00    	lea    0x400000(%ecx),%edi
8010746e:	eb 95                	jmp    80107405 <deallocuvm.part.0+0x75>
        panic("kfree");
80107470:	83 ec 0c             	sub    $0xc,%esp
80107473:	68 67 7e 10 80       	push   $0x80107e67
80107478:	e8 13 8f ff ff       	call   80100390 <panic>
8010747d:	8d 76 00             	lea    0x0(%esi),%esi

80107480 <switchkvm>:
{
80107480:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80107484:	a1 04 c5 11 80       	mov    0x8011c504,%eax
80107489:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010748e:	0f 22 d8             	mov    %eax,%cr3
}
80107491:	c3                   	ret    
80107492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074a0 <switchuvm>:
{
801074a0:	f3 0f 1e fb          	endbr32 
801074a4:	55                   	push   %ebp
801074a5:	89 e5                	mov    %esp,%ebp
801074a7:	57                   	push   %edi
801074a8:	56                   	push   %esi
801074a9:	53                   	push   %ebx
801074aa:	83 ec 1c             	sub    $0x1c,%esp
801074ad:	8b 75 08             	mov    0x8(%ebp),%esi
  if (p == 0)
801074b0:	85 f6                	test   %esi,%esi
801074b2:	0f 84 cb 00 00 00    	je     80107583 <switchuvm+0xe3>
  if (p->kstack == 0)
801074b8:	8b 46 08             	mov    0x8(%esi),%eax
801074bb:	85 c0                	test   %eax,%eax
801074bd:	0f 84 da 00 00 00    	je     8010759d <switchuvm+0xfd>
  if (p->pgdir == 0)
801074c3:	8b 46 04             	mov    0x4(%esi),%eax
801074c6:	85 c0                	test   %eax,%eax
801074c8:	0f 84 c2 00 00 00    	je     80107590 <switchuvm+0xf0>
  pushcli();
801074ce:	e8 6d d8 ff ff       	call   80104d40 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074d3:	e8 e8 cc ff ff       	call   801041c0 <mycpu>
801074d8:	89 c3                	mov    %eax,%ebx
801074da:	e8 e1 cc ff ff       	call   801041c0 <mycpu>
801074df:	89 c7                	mov    %eax,%edi
801074e1:	e8 da cc ff ff       	call   801041c0 <mycpu>
801074e6:	83 c7 08             	add    $0x8,%edi
801074e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074ec:	e8 cf cc ff ff       	call   801041c0 <mycpu>
801074f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801074f4:	ba 67 00 00 00       	mov    $0x67,%edx
801074f9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107500:	83 c0 08             	add    $0x8,%eax
80107503:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort)0xFFFF;
8010750a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010750f:	83 c1 08             	add    $0x8,%ecx
80107512:	c1 e8 18             	shr    $0x18,%eax
80107515:	c1 e9 10             	shr    $0x10,%ecx
80107518:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010751e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107524:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107529:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107530:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107535:	e8 86 cc ff ff       	call   801041c0 <mycpu>
8010753a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107541:	e8 7a cc ff ff       	call   801041c0 <mycpu>
80107546:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010754a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010754d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107553:	e8 68 cc ff ff       	call   801041c0 <mycpu>
80107558:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort)0xFFFF;
8010755b:	e8 60 cc ff ff       	call   801041c0 <mycpu>
80107560:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107564:	b8 28 00 00 00       	mov    $0x28,%eax
80107569:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir)); // switch to process's address space
8010756c:	8b 46 04             	mov    0x4(%esi),%eax
8010756f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107574:	0f 22 d8             	mov    %eax,%cr3
}
80107577:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010757a:	5b                   	pop    %ebx
8010757b:	5e                   	pop    %esi
8010757c:	5f                   	pop    %edi
8010757d:	5d                   	pop    %ebp
  popcli();
8010757e:	e9 0d d8 ff ff       	jmp    80104d90 <popcli>
    panic("switchuvm: no process");
80107583:	83 ec 0c             	sub    $0xc,%esp
80107586:	68 d8 89 10 80       	push   $0x801089d8
8010758b:	e8 00 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107590:	83 ec 0c             	sub    $0xc,%esp
80107593:	68 03 8a 10 80       	push   $0x80108a03
80107598:	e8 f3 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010759d:	83 ec 0c             	sub    $0xc,%esp
801075a0:	68 ee 89 10 80       	push   $0x801089ee
801075a5:	e8 e6 8d ff ff       	call   80100390 <panic>
801075aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075b0 <inituvm>:
{
801075b0:	f3 0f 1e fb          	endbr32 
801075b4:	55                   	push   %ebp
801075b5:	89 e5                	mov    %esp,%ebp
801075b7:	57                   	push   %edi
801075b8:	56                   	push   %esi
801075b9:	53                   	push   %ebx
801075ba:	83 ec 1c             	sub    $0x1c,%esp
801075bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801075c0:	8b 75 10             	mov    0x10(%ebp),%esi
801075c3:	8b 7d 08             	mov    0x8(%ebp),%edi
801075c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (sz >= PGSIZE)
801075c9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801075cf:	77 55                	ja     80107626 <inituvm+0x76>
  mem = kalloc();
801075d1:	e8 6a b7 ff ff       	call   80102d40 <kalloc>
  memset(mem, 0, PGSIZE);
801075d6:	83 ec 04             	sub    $0x4,%esp
801075d9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801075de:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801075e0:	6a 00                	push   $0x0
801075e2:	50                   	push   %eax
801075e3:	e8 68 d9 ff ff       	call   80104f50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
801075e8:	58                   	pop    %eax
801075e9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075ef:	5a                   	pop    %edx
801075f0:	6a 06                	push   $0x6
801075f2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075f7:	31 d2                	xor    %edx,%edx
801075f9:	50                   	push   %eax
801075fa:	89 f8                	mov    %edi,%eax
801075fc:	e8 ff fc ff ff       	call   80107300 <mappages>
  page_insert(pgdir, 0);
80107601:	59                   	pop    %ecx
80107602:	58                   	pop    %eax
80107603:	6a 00                	push   $0x0
80107605:	57                   	push   %edi
80107606:	e8 b5 b2 ff ff       	call   801028c0 <page_insert>
  memmove(mem, init, sz);
8010760b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010760e:	89 75 10             	mov    %esi,0x10(%ebp)
80107611:	83 c4 10             	add    $0x10,%esp
80107614:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107617:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010761a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010761d:	5b                   	pop    %ebx
8010761e:	5e                   	pop    %esi
8010761f:	5f                   	pop    %edi
80107620:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107621:	e9 ca d9 ff ff       	jmp    80104ff0 <memmove>
    panic("inituvm: more than a page");
80107626:	83 ec 0c             	sub    $0xc,%esp
80107629:	68 17 8a 10 80       	push   $0x80108a17
8010762e:	e8 5d 8d ff ff       	call   80100390 <panic>
80107633:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010763a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107640 <loaduvm>:
{
80107640:	f3 0f 1e fb          	endbr32 
80107644:	55                   	push   %ebp
80107645:	89 e5                	mov    %esp,%ebp
80107647:	57                   	push   %edi
80107648:	56                   	push   %esi
80107649:	53                   	push   %ebx
8010764a:	83 ec 1c             	sub    $0x1c,%esp
8010764d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107650:	8b 75 18             	mov    0x18(%ebp),%esi
  if ((uint)addr % PGSIZE != 0)
80107653:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107658:	0f 85 99 00 00 00    	jne    801076f7 <loaduvm+0xb7>
  for (i = 0; i < sz; i += PGSIZE)
8010765e:	01 f0                	add    %esi,%eax
80107660:	89 f3                	mov    %esi,%ebx
80107662:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107665:	8b 45 14             	mov    0x14(%ebp),%eax
80107668:	01 f0                	add    %esi,%eax
8010766a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for (i = 0; i < sz; i += PGSIZE)
8010766d:	85 f6                	test   %esi,%esi
8010766f:	75 15                	jne    80107686 <loaduvm+0x46>
80107671:	eb 6d                	jmp    801076e0 <loaduvm+0xa0>
80107673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107677:	90                   	nop
80107678:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010767e:	89 f0                	mov    %esi,%eax
80107680:	29 d8                	sub    %ebx,%eax
80107682:	39 c6                	cmp    %eax,%esi
80107684:	76 5a                	jbe    801076e0 <loaduvm+0xa0>
    if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
80107686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107689:	83 ec 04             	sub    $0x4,%esp
8010768c:	6a 00                	push   $0x0
8010768e:	29 d8                	sub    %ebx,%eax
80107690:	50                   	push   %eax
80107691:	ff 75 08             	pushl  0x8(%ebp)
80107694:	e8 d7 fb ff ff       	call   80107270 <walkpgdir>
80107699:	83 c4 10             	add    $0x10,%esp
8010769c:	85 c0                	test   %eax,%eax
8010769e:	74 4a                	je     801076ea <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801076a0:	8b 00                	mov    (%eax),%eax
    if (readi(ip, P2V(pa), offset + i, n) != n)
801076a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if (sz - i < PGSIZE)
801076a5:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801076aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if (sz - i < PGSIZE)
801076af:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801076b5:	0f 46 fb             	cmovbe %ebx,%edi
    if (readi(ip, P2V(pa), offset + i, n) != n)
801076b8:	29 d9                	sub    %ebx,%ecx
801076ba:	05 00 00 00 80       	add    $0x80000000,%eax
801076bf:	57                   	push   %edi
801076c0:	51                   	push   %ecx
801076c1:	50                   	push   %eax
801076c2:	ff 75 10             	pushl  0x10(%ebp)
801076c5:	e8 96 a3 ff ff       	call   80101a60 <readi>
801076ca:	83 c4 10             	add    $0x10,%esp
801076cd:	39 f8                	cmp    %edi,%eax
801076cf:	74 a7                	je     80107678 <loaduvm+0x38>
}
801076d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076d9:	5b                   	pop    %ebx
801076da:	5e                   	pop    %esi
801076db:	5f                   	pop    %edi
801076dc:	5d                   	pop    %ebp
801076dd:	c3                   	ret    
801076de:	66 90                	xchg   %ax,%ax
801076e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076e3:	31 c0                	xor    %eax,%eax
}
801076e5:	5b                   	pop    %ebx
801076e6:	5e                   	pop    %esi
801076e7:	5f                   	pop    %edi
801076e8:	5d                   	pop    %ebp
801076e9:	c3                   	ret    
      panic("loaduvm: address should exist");
801076ea:	83 ec 0c             	sub    $0xc,%esp
801076ed:	68 31 8a 10 80       	push   $0x80108a31
801076f2:	e8 99 8c ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801076f7:	83 ec 0c             	sub    $0xc,%esp
801076fa:	68 b8 8a 10 80       	push   $0x80108ab8
801076ff:	e8 8c 8c ff ff       	call   80100390 <panic>
80107704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop

80107710 <allocuvm>:
{
80107710:	f3 0f 1e fb          	endbr32 
80107714:	55                   	push   %ebp
80107715:	89 e5                	mov    %esp,%ebp
80107717:	57                   	push   %edi
80107718:	56                   	push   %esi
80107719:	53                   	push   %ebx
8010771a:	83 ec 1c             	sub    $0x1c,%esp
  if (newsz >= KERNBASE)
8010771d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107720:	8b 7d 08             	mov    0x8(%ebp),%edi
  if (newsz >= KERNBASE)
80107723:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107726:	85 c0                	test   %eax,%eax
80107728:	0f 88 c2 00 00 00    	js     801077f0 <allocuvm+0xe0>
  if (newsz < oldsz)
8010772e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107731:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (newsz < oldsz)
80107734:	0f 82 a6 00 00 00    	jb     801077e0 <allocuvm+0xd0>
  a = PGROUNDUP(oldsz);
8010773a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107740:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a < newsz; a += PGSIZE)
80107746:	39 75 10             	cmp    %esi,0x10(%ebp)
80107749:	77 51                	ja     8010779c <allocuvm+0x8c>
8010774b:	e9 93 00 00 00       	jmp    801077e3 <allocuvm+0xd3>
    memset(mem, 0, PGSIZE);
80107750:	83 ec 04             	sub    $0x4,%esp
80107753:	68 00 10 00 00       	push   $0x1000
80107758:	6a 00                	push   $0x0
8010775a:	50                   	push   %eax
8010775b:	e8 f0 d7 ff ff       	call   80104f50 <memset>
    if (mappages(pgdir, (char *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
80107760:	58                   	pop    %eax
80107761:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107767:	5a                   	pop    %edx
80107768:	6a 06                	push   $0x6
8010776a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010776f:	89 f2                	mov    %esi,%edx
80107771:	50                   	push   %eax
80107772:	89 f8                	mov    %edi,%eax
80107774:	e8 87 fb ff ff       	call   80107300 <mappages>
80107779:	83 c4 10             	add    $0x10,%esp
8010777c:	85 c0                	test   %eax,%eax
8010777e:	0f 88 84 00 00 00    	js     80107808 <allocuvm+0xf8>
    page_insert(pgdir, a);
80107784:	83 ec 08             	sub    $0x8,%esp
80107787:	56                   	push   %esi
  for (; a < newsz; a += PGSIZE)
80107788:	81 c6 00 10 00 00    	add    $0x1000,%esi
    page_insert(pgdir, a);
8010778e:	57                   	push   %edi
8010778f:	e8 2c b1 ff ff       	call   801028c0 <page_insert>
  for (; a < newsz; a += PGSIZE)
80107794:	83 c4 10             	add    $0x10,%esp
80107797:	39 75 10             	cmp    %esi,0x10(%ebp)
8010779a:	76 47                	jbe    801077e3 <allocuvm+0xd3>
    mem = kalloc();
8010779c:	e8 9f b5 ff ff       	call   80102d40 <kalloc>
801077a1:	89 c3                	mov    %eax,%ebx
    if (mem == 0)
801077a3:	85 c0                	test   %eax,%eax
801077a5:	75 a9                	jne    80107750 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801077a7:	83 ec 0c             	sub    $0xc,%esp
801077aa:	68 4f 8a 10 80       	push   $0x80108a4f
801077af:	e8 fc 8e ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz)
801077b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801077b7:	83 c4 10             	add    $0x10,%esp
801077ba:	39 45 10             	cmp    %eax,0x10(%ebp)
801077bd:	74 31                	je     801077f0 <allocuvm+0xe0>
801077bf:	8b 55 10             	mov    0x10(%ebp),%edx
801077c2:	89 c1                	mov    %eax,%ecx
801077c4:	89 f8                	mov    %edi,%eax
801077c6:	e8 c5 fb ff ff       	call   80107390 <deallocuvm.part.0>
      return 0;
801077cb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077d8:	5b                   	pop    %ebx
801077d9:	5e                   	pop    %esi
801077da:	5f                   	pop    %edi
801077db:	5d                   	pop    %ebp
801077dc:	c3                   	ret    
801077dd:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
801077e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801077e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077e9:	5b                   	pop    %ebx
801077ea:	5e                   	pop    %esi
801077eb:	5f                   	pop    %edi
801077ec:	5d                   	pop    %ebp
801077ed:	c3                   	ret    
801077ee:	66 90                	xchg   %ax,%ax
    return 0;
801077f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077fd:	5b                   	pop    %ebx
801077fe:	5e                   	pop    %esi
801077ff:	5f                   	pop    %edi
80107800:	5d                   	pop    %ebp
80107801:	c3                   	ret    
80107802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107808:	83 ec 0c             	sub    $0xc,%esp
8010780b:	68 67 8a 10 80       	push   $0x80108a67
80107810:	e8 9b 8e ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz)
80107815:	8b 45 0c             	mov    0xc(%ebp),%eax
80107818:	83 c4 10             	add    $0x10,%esp
8010781b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010781e:	74 0c                	je     8010782c <allocuvm+0x11c>
80107820:	8b 55 10             	mov    0x10(%ebp),%edx
80107823:	89 c1                	mov    %eax,%ecx
80107825:	89 f8                	mov    %edi,%eax
80107827:	e8 64 fb ff ff       	call   80107390 <deallocuvm.part.0>
      kfree(mem);
8010782c:	83 ec 0c             	sub    $0xc,%esp
8010782f:	53                   	push   %ebx
80107830:	e8 4b ad ff ff       	call   80102580 <kfree>
      return 0;
80107835:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010783c:	83 c4 10             	add    $0x10,%esp
}
8010783f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107842:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107845:	5b                   	pop    %ebx
80107846:	5e                   	pop    %esi
80107847:	5f                   	pop    %edi
80107848:	5d                   	pop    %ebp
80107849:	c3                   	ret    
8010784a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107850 <deallocuvm>:
{
80107850:	f3 0f 1e fb          	endbr32 
80107854:	55                   	push   %ebp
80107855:	89 e5                	mov    %esp,%ebp
80107857:	8b 55 0c             	mov    0xc(%ebp),%edx
8010785a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010785d:	8b 45 08             	mov    0x8(%ebp),%eax
  if (newsz >= oldsz)
80107860:	39 d1                	cmp    %edx,%ecx
80107862:	73 0c                	jae    80107870 <deallocuvm+0x20>
}
80107864:	5d                   	pop    %ebp
80107865:	e9 26 fb ff ff       	jmp    80107390 <deallocuvm.part.0>
8010786a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107870:	89 d0                	mov    %edx,%eax
80107872:	5d                   	pop    %ebp
80107873:	c3                   	ret    
80107874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010787b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010787f:	90                   	nop

80107880 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t *pgdir)
{
80107880:	f3 0f 1e fb          	endbr32 
80107884:	55                   	push   %ebp
80107885:	89 e5                	mov    %esp,%ebp
80107887:	57                   	push   %edi
80107888:	56                   	push   %esi
80107889:	53                   	push   %ebx
8010788a:	83 ec 0c             	sub    $0xc,%esp
8010788d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if (pgdir == 0)
80107890:	85 f6                	test   %esi,%esi
80107892:	74 55                	je     801078e9 <freevm+0x69>
  if (newsz >= oldsz)
80107894:	31 c9                	xor    %ecx,%ecx
80107896:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010789b:	89 f0                	mov    %esi,%eax
8010789d:	89 f3                	mov    %esi,%ebx
8010789f:	e8 ec fa ff ff       	call   80107390 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for (i = 0; i < NPDENTRIES; i++)
801078a4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801078aa:	eb 0b                	jmp    801078b7 <freevm+0x37>
801078ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078b0:	83 c3 04             	add    $0x4,%ebx
801078b3:	39 df                	cmp    %ebx,%edi
801078b5:	74 23                	je     801078da <freevm+0x5a>
  {
    if (pgdir[i] & PTE_P)
801078b7:	8b 03                	mov    (%ebx),%eax
801078b9:	a8 01                	test   $0x1,%al
801078bb:	74 f3                	je     801078b0 <freevm+0x30>
    {
      char *v = P2V(PTE_ADDR(pgdir[i]));
801078bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801078c2:	83 ec 0c             	sub    $0xc,%esp
801078c5:	83 c3 04             	add    $0x4,%ebx
      char *v = P2V(PTE_ADDR(pgdir[i]));
801078c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801078cd:	50                   	push   %eax
801078ce:	e8 ad ac ff ff       	call   80102580 <kfree>
801078d3:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < NPDENTRIES; i++)
801078d6:	39 df                	cmp    %ebx,%edi
801078d8:	75 dd                	jne    801078b7 <freevm+0x37>
    }
  }
  kfree((char *)pgdir);
801078da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801078dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078e0:	5b                   	pop    %ebx
801078e1:	5e                   	pop    %esi
801078e2:	5f                   	pop    %edi
801078e3:	5d                   	pop    %ebp
  kfree((char *)pgdir);
801078e4:	e9 97 ac ff ff       	jmp    80102580 <kfree>
    panic("freevm: no pgdir");
801078e9:	83 ec 0c             	sub    $0xc,%esp
801078ec:	68 83 8a 10 80       	push   $0x80108a83
801078f1:	e8 9a 8a ff ff       	call   80100390 <panic>
801078f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078fd:	8d 76 00             	lea    0x0(%esi),%esi

80107900 <setupkvm>:
{
80107900:	f3 0f 1e fb          	endbr32 
80107904:	55                   	push   %ebp
80107905:	89 e5                	mov    %esp,%ebp
80107907:	56                   	push   %esi
80107908:	53                   	push   %ebx
  if ((pgdir = (pde_t *)kalloc()) == 0)
80107909:	e8 32 b4 ff ff       	call   80102d40 <kalloc>
8010790e:	89 c6                	mov    %eax,%esi
80107910:	85 c0                	test   %eax,%eax
80107912:	74 42                	je     80107956 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107914:	83 ec 04             	sub    $0x4,%esp
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107917:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010791c:	68 00 10 00 00       	push   $0x1000
80107921:	6a 00                	push   $0x0
80107923:	50                   	push   %eax
80107924:	e8 27 d6 ff ff       	call   80104f50 <memset>
80107929:	83 c4 10             	add    $0x10,%esp
                 (uint)k->phys_start, k->perm) < 0)
8010792c:	8b 43 04             	mov    0x4(%ebx),%eax
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010792f:	83 ec 08             	sub    $0x8,%esp
80107932:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107935:	ff 73 0c             	pushl  0xc(%ebx)
80107938:	8b 13                	mov    (%ebx),%edx
8010793a:	50                   	push   %eax
8010793b:	29 c1                	sub    %eax,%ecx
8010793d:	89 f0                	mov    %esi,%eax
8010793f:	e8 bc f9 ff ff       	call   80107300 <mappages>
80107944:	83 c4 10             	add    $0x10,%esp
80107947:	85 c0                	test   %eax,%eax
80107949:	78 15                	js     80107960 <setupkvm+0x60>
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010794b:	83 c3 10             	add    $0x10,%ebx
8010794e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107954:	75 d6                	jne    8010792c <setupkvm+0x2c>
}
80107956:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107959:	89 f0                	mov    %esi,%eax
8010795b:	5b                   	pop    %ebx
8010795c:	5e                   	pop    %esi
8010795d:	5d                   	pop    %ebp
8010795e:	c3                   	ret    
8010795f:	90                   	nop
      freevm(pgdir);
80107960:	83 ec 0c             	sub    $0xc,%esp
80107963:	56                   	push   %esi
      return 0;
80107964:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107966:	e8 15 ff ff ff       	call   80107880 <freevm>
      return 0;
8010796b:	83 c4 10             	add    $0x10,%esp
}
8010796e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107971:	89 f0                	mov    %esi,%eax
80107973:	5b                   	pop    %ebx
80107974:	5e                   	pop    %esi
80107975:	5d                   	pop    %ebp
80107976:	c3                   	ret    
80107977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010797e:	66 90                	xchg   %ax,%ax

80107980 <kvmalloc>:
{
80107980:	f3 0f 1e fb          	endbr32 
80107984:	55                   	push   %ebp
80107985:	89 e5                	mov    %esp,%ebp
80107987:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010798a:	e8 71 ff ff ff       	call   80107900 <setupkvm>
8010798f:	a3 04 c5 11 80       	mov    %eax,0x8011c504
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80107994:	05 00 00 00 80       	add    $0x80000000,%eax
80107999:	0f 22 d8             	mov    %eax,%cr3
}
8010799c:	c9                   	leave  
8010799d:	c3                   	ret    
8010799e:	66 90                	xchg   %ax,%ax

801079a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva)
{
801079a0:	f3 0f 1e fb          	endbr32 
801079a4:	55                   	push   %ebp
801079a5:	89 e5                	mov    %esp,%ebp
801079a7:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801079aa:	6a 00                	push   $0x0
801079ac:	ff 75 0c             	pushl  0xc(%ebp)
801079af:	ff 75 08             	pushl  0x8(%ebp)
801079b2:	e8 b9 f8 ff ff       	call   80107270 <walkpgdir>
  if (pte == 0)
801079b7:	83 c4 10             	add    $0x10,%esp
801079ba:	85 c0                	test   %eax,%eax
801079bc:	74 05                	je     801079c3 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
801079be:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801079c1:	c9                   	leave  
801079c2:	c3                   	ret    
    panic("clearpteu");
801079c3:	83 ec 0c             	sub    $0xc,%esp
801079c6:	68 94 8a 10 80       	push   $0x80108a94
801079cb:	e8 c0 89 ff ff       	call   80100390 <panic>

801079d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *copyuvm(pde_t *pgdir, uint sz)
{
801079d0:	f3 0f 1e fb          	endbr32 
801079d4:	55                   	push   %ebp
801079d5:	89 e5                	mov    %esp,%ebp
801079d7:	57                   	push   %edi
801079d8:	56                   	push   %esi
801079d9:	53                   	push   %ebx
801079da:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if ((d = setupkvm()) == 0)
801079dd:	e8 1e ff ff ff       	call   80107900 <setupkvm>
801079e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079e5:	85 c0                	test   %eax,%eax
801079e7:	0f 84 af 00 00 00    	je     80107a9c <copyuvm+0xcc>
    return 0;
  for (i = 0; i < sz; i += PGSIZE)
801079ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801079f0:	85 c9                	test   %ecx,%ecx
801079f2:	0f 84 a4 00 00 00    	je     80107a9c <copyuvm+0xcc>
801079f8:	31 db                	xor    %ebx,%ebx
801079fa:	eb 55                	jmp    80107a51 <copyuvm+0x81>
801079fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //   panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char *)P2V(pa), PGSIZE);
80107a00:	83 ec 04             	sub    $0x4,%esp
80107a03:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a09:	68 00 10 00 00       	push   $0x1000
80107a0e:	57                   	push   %edi
80107a0f:	50                   	push   %eax
80107a10:	e8 db d5 ff ff       	call   80104ff0 <memmove>
    if (mappages(d, (void *)i, PGSIZE, V2P(mem), flags) < 0)
80107a15:	58                   	pop    %eax
80107a16:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107a1c:	5a                   	pop    %edx
80107a1d:	ff 75 e0             	pushl  -0x20(%ebp)
80107a20:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a25:	89 da                	mov    %ebx,%edx
80107a27:	50                   	push   %eax
80107a28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a2b:	e8 d0 f8 ff ff       	call   80107300 <mappages>
80107a30:	83 c4 10             	add    $0x10,%esp
80107a33:	85 c0                	test   %eax,%eax
80107a35:	78 79                	js     80107ab0 <copyuvm+0xe0>
    {
      kfree(mem);
      goto bad;
    }
    page_insert(d, i);
80107a37:	83 ec 08             	sub    $0x8,%esp
80107a3a:	53                   	push   %ebx
  for (i = 0; i < sz; i += PGSIZE)
80107a3b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    page_insert(d, i);
80107a41:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a44:	e8 77 ae ff ff       	call   801028c0 <page_insert>
  for (i = 0; i < sz; i += PGSIZE)
80107a49:	83 c4 10             	add    $0x10,%esp
80107a4c:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107a4f:	76 4b                	jbe    80107a9c <copyuvm+0xcc>
    if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
80107a51:	83 ec 04             	sub    $0x4,%esp
80107a54:	6a 00                	push   $0x0
80107a56:	53                   	push   %ebx
80107a57:	ff 75 08             	pushl  0x8(%ebp)
80107a5a:	e8 11 f8 ff ff       	call   80107270 <walkpgdir>
80107a5f:	83 c4 10             	add    $0x10,%esp
80107a62:	85 c0                	test   %eax,%eax
80107a64:	74 58                	je     80107abe <copyuvm+0xee>
    pa = PTE_ADDR(*pte);
80107a66:	8b 00                	mov    (%eax),%eax
80107a68:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107a6a:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    pa = PTE_ADDR(*pte);
80107a72:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if ((mem = kalloc()) == 0)
80107a78:	e8 c3 b2 ff ff       	call   80102d40 <kalloc>
80107a7d:	89 c6                	mov    %eax,%esi
80107a7f:	85 c0                	test   %eax,%eax
80107a81:	0f 85 79 ff ff ff    	jne    80107a00 <copyuvm+0x30>
  }
  // page insert in LRU linked list
  return d;

bad:
  freevm(d);
80107a87:	83 ec 0c             	sub    $0xc,%esp
80107a8a:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a8d:	e8 ee fd ff ff       	call   80107880 <freevm>
  return 0;
80107a92:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107a99:	83 c4 10             	add    $0x10,%esp
}
80107a9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107aa2:	5b                   	pop    %ebx
80107aa3:	5e                   	pop    %esi
80107aa4:	5f                   	pop    %edi
80107aa5:	5d                   	pop    %ebp
80107aa6:	c3                   	ret    
80107aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aae:	66 90                	xchg   %ax,%ax
      kfree(mem);
80107ab0:	83 ec 0c             	sub    $0xc,%esp
80107ab3:	56                   	push   %esi
80107ab4:	e8 c7 aa ff ff       	call   80102580 <kfree>
      goto bad;
80107ab9:	83 c4 10             	add    $0x10,%esp
80107abc:	eb c9                	jmp    80107a87 <copyuvm+0xb7>
      panic("copyuvm: pte should exist");
80107abe:	83 ec 0c             	sub    $0xc,%esp
80107ac1:	68 9e 8a 10 80       	push   $0x80108a9e
80107ac6:	e8 c5 88 ff ff       	call   80100390 <panic>
80107acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107acf:	90                   	nop

80107ad0 <uva2ka>:

// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva)
{
80107ad0:	f3 0f 1e fb          	endbr32 
80107ad4:	55                   	push   %ebp
80107ad5:	89 e5                	mov    %esp,%ebp
80107ad7:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107ada:	6a 00                	push   $0x0
80107adc:	ff 75 0c             	pushl  0xc(%ebp)
80107adf:	ff 75 08             	pushl  0x8(%ebp)
80107ae2:	e8 89 f7 ff ff       	call   80107270 <walkpgdir>
  if ((*pte & PTE_P) == 0)
    return 0;
  if ((*pte & PTE_U) == 0)
80107ae7:	83 c4 10             	add    $0x10,%esp
  if ((*pte & PTE_P) == 0)
80107aea:	8b 00                	mov    (%eax),%eax
    return 0;
  return (char *)P2V(PTE_ADDR(*pte));
}
80107aec:	c9                   	leave  
  if ((*pte & PTE_U) == 0)
80107aed:	89 c2                	mov    %eax,%edx
  return (char *)P2V(PTE_ADDR(*pte));
80107aef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if ((*pte & PTE_U) == 0)
80107af4:	83 e2 05             	and    $0x5,%edx
  return (char *)P2V(PTE_ADDR(*pte));
80107af7:	05 00 00 00 80       	add    $0x80000000,%eax
80107afc:	83 fa 05             	cmp    $0x5,%edx
80107aff:	ba 00 00 00 00       	mov    $0x0,%edx
80107b04:	0f 45 c2             	cmovne %edx,%eax
}
80107b07:	c3                   	ret    
80107b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b0f:	90                   	nop

80107b10 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b10:	f3 0f 1e fb          	endbr32 
80107b14:	55                   	push   %ebp
80107b15:	89 e5                	mov    %esp,%ebp
80107b17:	57                   	push   %edi
80107b18:	56                   	push   %esi
80107b19:	53                   	push   %ebx
80107b1a:	83 ec 0c             	sub    $0xc,%esp
80107b1d:	8b 75 14             	mov    0x14(%ebp),%esi
80107b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char *)p;
  while (len > 0)
80107b23:	85 f6                	test   %esi,%esi
80107b25:	75 3c                	jne    80107b63 <copyout+0x53>
80107b27:	eb 67                	jmp    80107b90 <copyout+0x80>
80107b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char *)va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107b30:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b33:	89 fb                	mov    %edi,%ebx
80107b35:	29 d3                	sub    %edx,%ebx
80107b37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if (n > len)
80107b3d:	39 f3                	cmp    %esi,%ebx
80107b3f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b42:	29 fa                	sub    %edi,%edx
80107b44:	83 ec 04             	sub    $0x4,%esp
80107b47:	01 c2                	add    %eax,%edx
80107b49:	53                   	push   %ebx
80107b4a:	ff 75 10             	pushl  0x10(%ebp)
80107b4d:	52                   	push   %edx
80107b4e:	e8 9d d4 ff ff       	call   80104ff0 <memmove>
    len -= n;
    buf += n;
80107b53:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107b56:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while (len > 0)
80107b5c:	83 c4 10             	add    $0x10,%esp
80107b5f:	29 de                	sub    %ebx,%esi
80107b61:	74 2d                	je     80107b90 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107b63:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
80107b65:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107b68:	89 55 0c             	mov    %edx,0xc(%ebp)
80107b6b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
80107b71:	57                   	push   %edi
80107b72:	ff 75 08             	pushl  0x8(%ebp)
80107b75:	e8 56 ff ff ff       	call   80107ad0 <uva2ka>
    if (pa0 == 0)
80107b7a:	83 c4 10             	add    $0x10,%esp
80107b7d:	85 c0                	test   %eax,%eax
80107b7f:	75 af                	jne    80107b30 <copyout+0x20>
  }
  return 0;
}
80107b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b89:	5b                   	pop    %ebx
80107b8a:	5e                   	pop    %esi
80107b8b:	5f                   	pop    %edi
80107b8c:	5d                   	pop    %ebp
80107b8d:	c3                   	ret    
80107b8e:	66 90                	xchg   %ax,%ax
80107b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b93:	31 c0                	xor    %eax,%eax
}
80107b95:	5b                   	pop    %ebx
80107b96:	5e                   	pop    %esi
80107b97:	5f                   	pop    %edi
80107b98:	5d                   	pop    %ebp
80107b99:	c3                   	ret    
