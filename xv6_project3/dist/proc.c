#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"

struct
{
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;
struct mmr mmr_arr[100];

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int cpuid()
{
  return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *mycpu(void)
{
  int apicid, i;

  if (readeflags() & FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i)
  {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *myproc(void)
{
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//  Look in the process table for an UNUSED proc.
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  // initialize memory mapped region
  for (int i = 0; i < 100; i++)
  {
    mmr_arr[i].fd = 0;
    mmr_arr[i].pid = 0;
    mmr_arr[i].offset = 0;
    mmr_arr[i].length = 0;
    mmr_arr[i].flags = 0;
    mmr_arr[i].start_addr = 0;
    mmr_arr[i].valid = 0;
    mmr_arr[i].pt_valid = 0;
  }

  release(&ptable.lock);

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
  {
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe *)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//  Set up first user process.
void userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  initproc = p;
  if ((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0; // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if (n > 0)
  {
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  else if (n < 0)
  {
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0)
  {
    return -1;
  }

  // Copy process state from proc.
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
  {
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for (i = 0; i < NOFILE; i++)
    if (curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if (curproc == initproc)
    panic("init exiting");

  for (int i = 0; i < 100; i++)
  {
    if (mmr_arr[i].valid == 1)
    {
      munmap((void *)(mmr_arr[i].start_addr), mmr_arr[i].length);
      mmr_arr[i].valid = 0;
    }
  }

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++)
  {
    if (curproc->ofile[fd])
    {
      // need to unmap all file, free pages prj3
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->parent == curproc)
    {
      p->parent = initproc;
      if (p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->parent != curproc)
        continue;
      havekids = 1;
      if (p->state == ZOMBIE)
      {
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || curproc->killed)
    {
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
  }
}

//  Per-CPU process scheduler.
//  Each CPU calls scheduler() after setting itself up.
//  Scheduler never returns.  It loops, doing:
//   - choose a process to run
//   - swtch to start running that process
//   - eventually that process transfers control
//       via swtch back to the scheduler.
void scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;

  for (;;)
  {
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&ptable.lock))
    panic("sched ptable.lock");
  if (mycpu()->ncli != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (readeflags() & FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void yield(void)
{
  acquire(&ptable.lock); // DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first)
  {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if (p == 0)
    panic("sleep");

  if (lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if (lk != &ptable.lock)
  {                        // DOC: sleeplock0
    acquire(&ptable.lock); // DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if (lk != &ptable.lock)
  { // DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//  Wake up all processes sleeping on chan.
//  The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
  static char *states[] = {
      [UNUSED] "unused",
      [EMBRYO] "embryo",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if (p->state == SLEEPING)
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

void *mmap(int fd, int offset, int length, int flags)
{
  struct proc *p = myproc(); // get process
  void *v_addr;              // virtual address
  struct file *f = 0;        // initialize with 0 (not file-backed)
  if (fd != -1)
  {
    f = p->ofile[fd];
    if ((flags & MAP_POPULATE) != 0)
    {
      if (((flags & MAP_PROT_READ) != 0) && !((int)(f->readable)))
        return MAP_FAILED;
      if (((flags & MAP_PROT_WRITE) != 0) && !((int)(f->writable)))
        return MAP_FAILED;
    }
  }
  uint v_addr_temp;

  // size miss
  if ((length % PGSIZE) != 0)
  {
    return MAP_FAILED;
  }

  // get empty mmr
  int empty_mmr_point = -1;
  for (int i = 0; i < 100; i++)
  {
    if (mmr_arr[i].valid != 1)
    {
      empty_mmr_point = i;
      break;
    }
  }

  // Region reserved
  int region_get = 0;
  for (v_addr_temp = PGROUNDDOWN(KERNBASE) - PGSIZE; v_addr_temp >= PGROUNDUP(p->sz); v_addr_temp -= PGSIZE)
  {
    for (int i = 0; i < 100; i++)
    {
      if (i == 99)
      {
        region_get = 1;
      }
      if (mmr_arr[i].valid != 1)
      {
        continue; // valid region check
      }
      if (mmr_arr[i].pid != p->pid)
      {
        continue; // same process check
      }
      if (mmr_arr[i].start_addr < v_addr_temp)
      {
        if (mmr_arr[i].start_addr + mmr_arr[i].length <= v_addr_temp)
        {
          continue; // upper region check
        }
      }
      if (v_addr_temp < mmr_arr[i].start_addr)
      {
        if (v_addr_temp + length <= mmr_arr[i].start_addr)
        {
          continue; // lower region check
        }
      }
      region_get = 0;
      break;
    }
    if (region_get == 1)
    {
      v_addr = (void *)v_addr_temp;
      mmr_arr[empty_mmr_point].fd = fd;
      mmr_arr[empty_mmr_point].pid = p->pid;
      mmr_arr[empty_mmr_point].offset = offset;
      mmr_arr[empty_mmr_point].length = length;
      mmr_arr[empty_mmr_point].flags = flags;
      mmr_arr[empty_mmr_point].start_addr = v_addr_temp;
      mmr_arr[empty_mmr_point].valid = 1;
      mmr_arr[empty_mmr_point].pt_valid = 0;
      break; // reserved region
    }
  }
  if (region_get == 0)
  {
    return MAP_FAILED; // not enough region
  }

  // cprintf("=============INFO of Struct==============\n");
  // cprintf("fd : %d\n", mmr_arr[empty_mmr_point].fd);
  // cprintf("length : %d\n", mmr_arr[empty_mmr_point].length);
  // cprintf("start_addr : %x\n", mmr_arr[empty_mmr_point].start_addr);
  // cprintf("valid : %d\n", mmr_arr[empty_mmr_point].valid);
  // cprintf("flags : %x\n", mmr_arr[empty_mmr_point].flags);
  // Flag for each activation
  int cur_page = 0;
  char *p_addr = 0;
  if ((flags & MAP_POPULATE) == 0) // Demand Paging
  {
    // cprintf("=============Demand Paging==============\n");
    // cprintf("Vitrtual address return is : %x\n", v_addr);
    return v_addr;
  }
  else // Prepaginig
  {
    // cprintf("==============Prepaging===============\n");
    int origin = f->off;
    walkpgdir(p->pgdir, (void *)v_addr_temp, 1);
    mmr_arr[empty_mmr_point].pt_valid = 1;
    for (cur_page = 0; cur_page < length; cur_page += PGSIZE)
    {
      p_addr = kalloc();
      if (p_addr == 0)
      {
        return MAP_FAILED; // not allocated
      }
      memset(p_addr, 0, PGSIZE); // init with 0
      if (fd != -1)
      {
        f->off = offset + cur_page;
        fileread(f, p_addr, PGSIZE); // fill file data
      }
      if ((flags & MAP_PROT_WRITE) != 0)
      {
        // cprintf("mappage write vaddr: %x\n", v_addr_temp + cur_page);
        // cprintf("mappage write paddr: %x\n", p_addr);
        // cprintf("mappage protect bit : %x\n", PTE_P | PTE_U | PTE_W);
        mappages(p->pgdir, (void *)(v_addr_temp + cur_page), PGSIZE, V2P(p_addr), (PTE_P | PTE_W | PTE_U));
      }
      else if ((flags & MAP_PROT_READ) != 0)
      {
        // cprintf("mappage read vaddr: %x\n", v_addr_temp + cur_page);
        // cprintf("mappage read paddr: %x\n", p_addr);
        // cprintf("mappage protect bit : %x\n", PTE_P | PTE_U);
        mappages(p->pgdir, (void *)(v_addr_temp + cur_page), PGSIZE, V2P(p_addr), (PTE_P | PTE_U));
      }
      else
      {
        return MAP_FAILED;
      }
    }
    if (fd != -1)
    {
      f->off = origin;
    }
  }
  return v_addr;
}

int munmap(void *addr, int length)
{
  // can use fd (mmap -> munmap -> close)
  struct proc *p = myproc();
  if (((int)addr % PGSIZE) != 0)
  {
    // cprintf("addr error\n");
    return -1;
  }
  if ((length % PGSIZE) != 0)
  {
    // cprintf("len error\n");
    return -1;
  }
  int i;
  // cprintf("===================Unmap start======================\n");
  // cprintf("unmap addr %x\n", addr);
  // cprintf("unmap length %d\n", length);
  for (i = 0; i < 100; i++)
  {
    if (mmr_arr[i].valid != 1)
    {
      continue;
    }
    if (mmr_arr[i].pid != p->pid)
    {
      continue;
    }
    if (mmr_arr[i].start_addr == (int)addr)
    {
      break;
    }
    if (i == 100)
    {
      // cprintf("not any mapping\n");
      return 0;
    }
  }
  // cprintf("=============Unmap Info================\n");
  // cprintf("fd : %d\n", mmr_arr[i].fd);
  // cprintf("length : %d\n", mmr_arr[i].length);
  // cprintf("start_addr : %x\n", mmr_arr[i].start_addr);
  // cprintf("valid : %d\n", mmr_arr[i].valid);
  // cprintf("flags : %x\n", mmr_arr[i].flags);

  struct file *f = 0;
  int origin = 0;
  if (mmr_arr[i].fd != -1)
  {
    f = p->ofile[(mmr_arr[i].fd)];
    origin = f->off;
  }

  int cur_page = 0;
  pte_t *pte;
  for (cur_page = 0; cur_page < length; cur_page += PGSIZE)
  {
    pte = walkpgdir(p->pgdir, (void *)(addr + cur_page), 0);
    if (pte == 0)
      return -1;
    if ((*pte & PTE_P) == 0)
      continue;
    uint p_addr = PTE_ADDR(*pte) | ((int)(addr + cur_page) & 0XFFF);
    // cprintf("pte convert : %x\n", P2V(PTE_ADDR(*pte)));
    // cprintf("addr + cur_page %x\n", (int)(addr + cur_page));
    // cprintf("addr + cur_page & 0XFFF : %d\n", (int)(addr + cur_page) & 0XFFF);
    // cprintf("physical addr : %x\n", P2V(p_addr));
    if (mmr_arr[i].fd != -1)
    {
      if (((uint)pte & MAP_PROT_WRITE) != 0)
      {
        // cprintf("File write occur!\n");
        f->off = origin + cur_page + (int)addr - mmr_arr[i].start_addr;
        // cprintf("offset : %d\n", (f->off));
        filewrite(f, P2V(p_addr), PGSIZE);
      }
    }
    // cprintf("p_addr p2v : %x\n", P2V(p_addr));
    kfree(P2V(p_addr));
    *pte = 0;
    mmr_arr[i].valid = 0;
  }
  if (mmr_arr[i].fd != -1)
  {
    f->off = origin;
  }
  // cprintf("==============Unmap finished==============\n");
  return 0;

  // check condition(addr, length 4KB multi)
  // check file backed or not
  // filed backed & write -> write back
  // physical page allocated & page table constructed
  // free physical page & page table entry init 0
  // no mapping -> return 0
}

int page_fault_handler(uint addr, uint err)
{
  // cprintf("===========Page Fault start============\n");
  // cprintf("fault addr : %x\n", addr);
  // cprintf("err : %d\n", err);
  struct proc *p = myproc();
  // check area
  // addr(pa) -> walkpgdir -> addr(virt)
  // checking mapped : invalid -> kill / valid -> concur
  int i;
  for (i = 0; i < 100; i++)
  {
    // cprintf("check struct : %d\n", i);
    if (i >= 99)
    {
      // cprintf("Kill process occur!\n");
      kill(p->pid);
      return 0;
    }
    if (mmr_arr[i].valid != 1)
    {
      continue;
    }
    if (mmr_arr[i].pid != p->pid)
    {
      continue;
    }
    if ((mmr_arr[i].start_addr <= addr) && (addr <= (mmr_arr[i].start_addr + mmr_arr[i].length)))
    {
      // cprintf("info of struct\n");
      // cprintf("fd : %d\n", mmr_arr[i].fd);
      // cprintf("length : %d\n", mmr_arr[i].length);
      // cprintf("start_addr : %x\n", mmr_arr[i].start_addr);
      // cprintf("valid : %d\n", mmr_arr[i].valid);
      // cprintf("flags : %x\n", mmr_arr[i].flags);
      break;
    }
  }

  // invalid process
  // alloocate physical page(use kalloc)
  // if (walkpgdir(p->pgdir, (void *)addr, 1) == 0)
  if (!mmr_arr[i].pt_valid)
  {
    walkpgdir(p->pgdir, (void *)PGROUNDDOWN(addr), 1);
    mmr_arr[i].pt_valid = 1;
  }
  int origin = 0;
  char *p_addr = 0;
  p_addr = kalloc();
  if (p_addr == 0)
  {
    // cprintf("pm alloc failed\n");
    return -1;
  }
  memset(p_addr, 0, PGSIZE);
  struct file *f = 0;
  if (mmr_arr[i].fd != -1) // file-backed
  {
    f = p->ofile[(mmr_arr[i].fd)];
    origin = f->off;
    f->off = mmr_arr[i].offset + ((addr - mmr_arr[i].start_addr) / PGSIZE) * PGSIZE;
    // f->off = mmr_arr[i].offset;
    fileread(f, p_addr, PGSIZE);
  }
  if ((mmr_arr[i].flags & MAP_PROT_WRITE) != 0)
  {
    // cprintf("pagefault mappage write vaddr: %x\n", PGROUNDDOWN(addr));
    // cprintf("pagefault mappage write paddr: %x\n", p_addr);
    // cprintf("pagefault protect bit : %x\n", PTE_P | PTE_U | PTE_W);
    mappages(p->pgdir, (void *)PGROUNDDOWN(addr), PGSIZE, V2P(p_addr), (PTE_P | PTE_W | PTE_U));
  }
  else if ((mmr_arr[i].flags & MAP_PROT_READ) != 0)
  {
    // cprintf("pagefault mappage read vaddr: %x\n", PGROUNDDOWN(addr));
    // cprintf("pagefault mappage read paddr: %x\n", p_addr);
    // cprintf("pagefault protect bit : %x\n", PTE_P | PTE_U);
    mappages(p->pgdir, (void *)PGROUNDDOWN(addr), PGSIZE, V2P(p_addr), (PTE_P | PTE_U));
  }
  else
  {
    // cprintf("not read or write protection\n");
    return -1;
  }

  if (mmr_arr[i].fd != -1)
  {
    f->off = origin;
  }

  // valid
  // err -> write / maped region read
  // modify protection bit with valid R/W
  // tlb entry flush
  if (!mmr_arr[i].pt_valid)
  {
    if ((err == 2) && ((mmr_arr[i].flags & MAP_PROT_WRITE) == 0)) // tlb flush
    {
      // cprintf("flush occur\n");
      mappages(p->pgdir, (void *)PGROUNDDOWN(addr), PGSIZE, V2P(walkpgdir(p->pgdir, (void *)addr, 0)), PTE_P | PTE_W | PTE_U);
      lcr3(V2P(p->pgdir));
    }
  }

  // cprintf("==============Pagefault handler Finished===============\n");
  return 0;
}
