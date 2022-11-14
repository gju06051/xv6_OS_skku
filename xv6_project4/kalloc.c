// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld

struct run
{
  struct run *next;
};

struct
{
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
} kmem;

struct
{
  struct spinlock lock;
  int use_lock;
  struct page pages[PHYSTOP / PGSIZE];
  struct page *page_lru_head;
  int num_free_pages;
  int num_lru_pages;
} lru;

struct
{
  struct spinlock lock;
  int use_lock;
  char bitmap_arr[4096];
} bitmap;

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  initlock(&lru.lock, "lru");
  lru.use_lock = 0;
  initlock(&bitmap.lock, "bitmap");
  bitmap.use_lock = 0;

  // initialize page policy argument
  lru.num_free_pages = 0;
  lru.num_lru_pages = 0;
  bitmap.bitmap_arr[0] = 1;
  for (int i = 2; i < PGSIZE; i++)
  {
    bitmap[i] = 0;
  }
  for (int i = 0; i < PHYSTOP / PGSIZE; i++)
  {
    pages[i].use = 0;
  }
  freerange(vstart, vend);
}

void kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  cprintf("kinit2 finished | num_free_page : %d, num_lru_page : %d\n", num_free_pages, num_lru_pages);
  kmem.use_lock = 1;
}

void freerange(void *vstart, void *vend)
{
  char *p;
  p = (char *)PGROUNDUP((uint)vstart);
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
    kfree(p);
}
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(char *v)
{
  struct run *r;

  if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
  {
    if ((uint)v % PGSIZE)
      cprintf("PGROUND Need\n");
    if (v < end)
      cprintf("virtual addr is under end\n");
    if (V2P(v) >= PHYSTOP)
      cprintf("physical addr is upper than PHYSTOP");
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if (kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run *)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  num_free_pages++;
  if (kmem.use_lock)
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char *
kalloc(void)
{
  struct run *r;
  if (kmem.use_lock)
    acquire(&kmem.lock);

  r = kmem.freelist;
  //  if(!r && reclaim())
  //	  goto try_again;
  if (r)
    kmem.freelist = r->next;
  else
  {
    if (kmem.use_lock)
      release(&kmem.lock);

    cprintf("No free physical page -> ");
    r = (struct run *)swapout();

    if (kmem.use_lock)
      acquire(&kmem.lock);
  }

  num_free_pages--;
  if (kmem.use_lock)
    release(&kmem.lock);
  return (char *)r;
}
void lru_print(void)
{
  struct page *p_page;
  pte_t *pte;
  int pte_n_a = 0;
  p_page = page_lru_head;
  for (int i = 0; i < num_lru_pages; i++)
  {
    pte = walkpgdir(p_page->pgdir, p_page->vaddr, 0);
    // pte_n_a = *pte & PTE_A;
    if (p_page->vaddr == 0)
      cprintf("LRU entry %d, pgdir : %x, vaddr : 0000, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);

    else
      cprintf("LRU entry %d, pgdir : %x, vaddr : %x, use : %d, PTE_A : %x, PTE : %x\n", i, p_page->pgdir, p_page->vaddr, p_page->use, (pte_n_a != 0), *pte);
    p_page = p_page->prev;
  }
}

void page_insert(pde_t *pgdir, uint vaddr)
{
  // cprintf("================Page insert start================\n");
  struct page *new_page, *next_page;
  // lru entry insert
  for (int i = 0; i < (PHYSTOP / PGSIZE); i++)
  {
    // search not using page
    new_page = &pages[i];
    if (new_page->use == 0)
    {
      break;
    }
  }

  if (num_lru_pages == 0)
  {
    // case of first lru entry
    page_lru_head = new_page;
    page_lru_head->prev = new_page;
    page_lru_head->next = new_page;

    // page entry setting
    num_lru_pages++;
    new_page->pgdir = pgdir;
    new_page->vaddr = (char *)vaddr;
    new_page->use = 1;
    if (vaddr == 0)
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : 0000, ", num_lru_pages, new_page->pgdir);
    else
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", num_lru_pages, new_page->pgdir, new_page->vaddr);
  }
  else if (num_lru_pages == 1)
  {
    // case of second lru entry
    next_page = new_page;

    page_lru_head->next = new_page;
    page_lru_head->prev = new_page;
    new_page->prev = page_lru_head;
    new_page->next = page_lru_head;

    num_lru_pages++;
    // page entry setting
    new_page->pgdir = pgdir;
    new_page->vaddr = (char *)vaddr;
    new_page->use = 1;
    if (vaddr == 0)
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : 0000, ", num_lru_pages, new_page->pgdir);
    else
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", num_lru_pages, new_page->pgdir, new_page->vaddr);
  }
  else
  {
    // case of above third lru entry
    next_page = page_lru_head->next;

    page_lru_head->next = new_page;
    new_page->prev = page_lru_head;

    new_page->next = next_page;
    next_page->prev = new_page;

    num_lru_pages++;
    // page entry setting
    new_page->pgdir = pgdir;
    new_page->vaddr = (char *)vaddr;
    new_page->use = 1;
    if (vaddr == 0)
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : 0000, ", num_lru_pages, new_page->pgdir);
    else
      cprintf("Page insert | num_lru_pages : %d, pgdir : %x, vaddr : %x, ", num_lru_pages, new_page->pgdir, new_page->vaddr);
  }
  // cprintf("====lru entry top====\n");
  // lru_print();
  // cprintf("====lru entry bottom====\n");
  cprintf("PTE : %x\n", walkpgdir(new_page->pgdir, new_page->vaddr, 0));

  // cprintf("================Page insert finished================\n");
}

int page_delete(pde_t *pgdir, char *vaddr)
{
  struct page *p_page, *temp_head, *f_page, *b_page;
  // cprintf("================Page delete start================\n");

  temp_head = page_lru_head;
  // cprintf("page delete target | pgdir : %x | vaddr : %x\n", pgdir, vaddr);
  for (int i = 0; i < num_lru_pages; i++) // search lru with vaddr, pgdir
  {
    p_page = page_lru_head;
    // cprintf("p_page | pgdir : %x | vaddr : %x\n", p_page->pgdir, p_page->vaddr);
    if ((p_page->pgdir == pgdir) && (PTE_ADDR(p_page->vaddr) == (uint)vaddr))
    {

      // delete page from linked list
      f_page = p_page->prev;
      b_page = p_page->next;

      f_page->next = b_page;
      b_page->prev = f_page;

      // clear use bit
      p_page->use = 0;
      // page count down
      num_lru_pages--;
      // restore head
      page_lru_head = temp_head->prev;
      if (vaddr == 0)
        cprintf("Page Delete | num_lru_pages : %d, pgdir : %x, vaddr : 0000\n", num_lru_pages, p_page->pgdir);
      else
        cprintf("Page Delete | num_lru_pages : %d, pgdir : %x, vaddr : %x\n", num_lru_pages, p_page->pgdir, p_page->vaddr);
      // cprintf("================Page delete end================\n");
      return 0;
    }
    else
    {
      page_lru_head = page_lru_head->prev;
    }
  }
  cprintf("=================================LRU linked list TOP=================================\n");
  cprintf("Page delete target | pgdir : %x | vaddr : %x\n", pgdir, vaddr);
  lru_print();
  cprintf("=================================LRU linked list BOT=================================\n");
  // for (int i = 0; i < PGSIZE; i++)
  // {
  //   cprintf("Bitmap[%d] : %x\n", i, bitmap[i]);
  // }
  return -1;
}

char *swapout(void)
{
  struct page *p_page;
  pte_t *pte;
  char set_bit;
  char *mem;
  int bitmap_offset_get = 0;
  // cprintf("================swap out start================\n");

  int bitmap_offset = 0;
  if (num_lru_pages == 0)
  {
    panic("OOM Error");
  }

  // get bitmap free
  for (int i = 0; i < PGSIZE; i++)
  {
    set_bit = 1;
    if (bitmap_offset_get)
      break;
    for (int j = 0; j < 8; j++)
    {
      //  get low bit in bitmap
      if ((set_bit & bitmap[i]) == 0)
      {
        // get idx of bitmap
        bitmap_offset = 8 * i + j;
        bitmap_offset_get = 1;
        break;
      }
      else
      {
        // shift to next bit for check
        set_bit = set_bit << 1;
      }
    }
  }
  /*
  cprintf("============page entry top\n");
  p_page = page_lru_head;
  for (int i = 0; i < num_lru_pages; i++)
  {
    cprintf("present page info | pgdir : %x | vaddr : %x | PTE_ADDR : %x\n", p_page->pgdir, p_page->vaddr, PTE_ADDR(walkpgdir(p_page->pgdir, p_page->vaddr, 0)));
    p_page = p_page->prev;
  }
  cprintf("============page entry bottom\n");
  */
  // victim page process
  for (int i = 0; i < num_lru_pages + 10; i++)
  {
    p_page = page_lru_head;
    pte = walkpgdir(p_page->pgdir, p_page->vaddr, 0);
    mem = P2V((PTE_ADDR(*pte)));
    if ((*pte != 0) && ((*pte & PTE_A) == 0)) // ref bit low
    {
      // cprintf("==============victim page start==============\n");
      if (p_page->vaddr == 0)
        cprintf("Swapout victim page | pgdir : %x,vaddr : 0000, PTE : %x, Modified PTE : %x\n", p_page->pgdir, *pte, (((bitmap_offset << 12) | PTE_FLAGS(*pte)) & (~PTE_P)));
      else
        cprintf("Swapout victim page | pgdir : %x, vaddr : %x, PTE : %x, Modified PTE : %x\n", p_page->pgdir, p_page->vaddr, *pte, (((bitmap_offset << 12) | PTE_FLAGS(*pte)) & (~PTE_P)));
      // swapwrite to write the vicitm page to the swap space
      swapwrite(mem, bitmap_offset);
      // cprintf("swap write occur\n");
      // Write the swap space offset into the PFN field of the PTE
      *pte = (bitmap_offset << 12) | PTE_FLAGS(*pte);
      // cprintf("pte modify occur\n");
      // Clear the PTE_P
      *pte = *pte & (~PTE_P);
      // cprintf("PTE_P clear occur\n");
      // Flush TLB
      lcr3(V2P(p_page->pgdir));
      // cprintf("flush occur\n");
      // go to previous page
      page_lru_head = page_lru_head->prev;
      // Remove the victim page from LRU list
      page_lru_head->next = p_page->next;
      p_page->next->prev = page_lru_head;
      // cprintf("page out of lru occur\n");
      // Set up the corresponding bit in bitmap
      bitmap_modify(bitmap_offset, 1);
      // cprintf("bitmap modify occur\n");
      // free the victim page
      if (kmem.use_lock)
        acquire(&kmem.lock);
      kfree(mem);
      kmem.use_lock = 1;
      if (kmem.use_lock)
        release(&kmem.lock);
      // cprintf("kfree occur\n");
      // page structure initialize for next use
      p_page->use = 0;
      num_lru_pages--;
      // cprintf("==============victim page end==============\n");
      // cprintf("================swap out end================\n");
      return mem;
    }
    else // ref bit high
    {
      // clear the flag
      // cprintf("clear flag occur\n");
      *pte = *pte & (~PTE_A);
      // go to previous page
      page_lru_head = page_lru_head->prev;
    }
  }
  cprintf("================swap out err================\n");
  lru_print();

  panic("swap out err not found zero page");
}

void bitmap_modify(int bitmap_offset, int set)
{
  // cprintf("================bitmap modify start================\n");

  if (set == 0) // unset
  {
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] & (~(1 << bitmap_offset % 8));
  }
  else // set
  {
    bitmap[bitmap_offset / 8] = bitmap[bitmap_offset / 8] | (1 << bitmap_offset % 8);
  }
  // cprintf("================bitmap modify end================\n");
}

int page_fault_handler(pde_t *pgdir, uint vaddr)
{
  char *mem;
  pte_t *pte;
  int bitmap_offset;

  // PTE check
  cprintf("Page Fault Occur at %x -> ", vaddr);
  pte = walkpgdir(pgdir, (void *)vaddr, 0);
  if ((*pte != 0) && ((*pte & PTE_P) == 0)) // page-fault occur where swapped out page
  {
    // cprintf("================Page fault(swappable) start================\n");
    // allocate physical page
    cprintf("Mem alloc -> ");
    mem = kalloc();
    if (mem == 0)
    {
      cprintf("page fault allocate out of memory\n");
      return -1;
    }
    memset(mem, 0, PGSIZE);
    // get bitmap offset
    bitmap_offset = (PTE_ADDR(*pte)) >> 12;
    // swapread to the page from swap space
    swapread(mem, bitmap_offset);
    cprintf("Swap read -> ");
    // change PTE value with physical address & PTE_P set - do not call mappages(already mapped)
    *pte = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
    // cprintf("PTE : %x\n", *pte);
    // cprintf("PTE by walkpgdir : %x\n", walkpgdir(pgdir, (void *)vaddr, 0));
    // insert the page into LRU list
    page_insert(pgdir, vaddr);
    // clear the corresponding bit in the
    bitmap_modify(bitmap_offset, 0);
    // cprintf("================Page fault(swappable) end================\n");
  }
  else // page fault occur not exist
  {
    cprintf("================Page fault(non swappable) start================\n");
    /*
    // allocate physical page
    mem = kalloc();
    if (mem == 0)
    {
      cprintf("page fault allocate out of memory\n");
      return -1;
    }
    // generate page table
    pte = walkpgdir(pgdir, (void *)vaddr, 1);
    // mapping physical page with virtual page
    mappages(pgdir, vaddr, PGSIZE, V2P(mem), PTE_P | PTE_W | PTE_U);
    */
    cprintf("================Page fault(non swappable) end================\n");
  }
  // cprintf("================Page fault end================\n");

  return 0;
}