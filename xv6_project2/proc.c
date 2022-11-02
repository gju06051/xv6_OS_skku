#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct
{
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
int weight[MAX_NICE - MIN_NICE + 1] = {3121, 2501, 1991, 1586, 1277, 1024, 820, 655, 526, 423, 335};
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

// PAGEBREAK: 32
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
  p->nice = 0; // default nice value 0
  p->runtime = 0;
  p->vruntime = 0;
  p->time_slice = 0;
  p->ovf_flag = 0;

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

// PAGEBREAK: 32
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
  struct proc *np;                 // next process pointer
  struct proc *curproc = myproc(); // current process pointer, myproc() for getting process pointer

  // Allocate process.
  if ((np = allocproc()) == 0) // if allocation failed, terminate fork
  {
    return -1;
  }

  // Copy process state from proc.
  // copyuvm : Given a parent process's page table,
  // create a copy of it for a child.
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
  np->nice = curproc->nice;         // inherit nice value from parent
  np->vruntime = curproc->vruntime; // inherit vruntime from parent
  np->ovf_flag = curproc->ovf_flag; // inherit overflow flag

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

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++)
  {
    if (curproc->ofile[fd])
    {
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

// PAGEBREAK: 42
//  Per-CPU process scheduler.
//  Each CPU calls scheduler() after setting itself up.
//  Scheduler never returns.  It loops, doing:
//   - choose a process to run
//   - swtch to start running that process
//   - eventually that process transfers control
//       via swtch back to the scheduler.
void scheduler(void)
{
  struct proc *p, *p1_search;
  struct cpu *c = mycpu();
  c->proc = 0;

  for (;;)
  {
    // Enable interrupts on this processor.
    sti();
    struct proc *p2_min;
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      // check process if not, check next process
      if (p->state != RUNNABLE)
        continue;

      // CFS (Completely Fair Scheduler)
      p2_min = p;
      for (p1_search = ptable.proc; p1_search < &ptable.proc[NPROC]; p1_search++)
      {
        if (p1_search->state != RUNNABLE)
          continue;
        if (p2_min->ovf_flag >= p1_search->ovf_flag)
          if (p2_min->vruntime > p1_search->vruntime)
            p2_min = p1_search;
      }
      p = p2_min;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
      p->time_slice = gettime_slice(p);
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

// PAGEBREAK!
//  Wake up all processes sleeping on chan.
//  The ptable lock must be held.
static void wakeup1(void *chan)
{
  struct proc *p, *min_vrun_p;

  // get current process weight
  int cur_weight = getweight(0);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state != RUNNING)
      continue;
    cur_weight = getweight(p->nice);
  }

  // get minimum vruntime of process
  min_vrun_p = ptable.proc;
  int min_vruntime = 0;
  int min_vrun_flag = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state != RUNNABLE)
      continue;
    if (min_vrun_p->ovf_flag >= p->ovf_flag)
      if (min_vrun_p->vruntime > p->vruntime)
        min_vrun_p = p;
  }
  min_vruntime = min_vrun_p->vruntime;
  min_vrun_flag = min_vrun_p->ovf_flag;

  // wakeup process with vruntime update
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == SLEEPING && p->chan == chan)
    {
      p->state = RUNNABLE;
      if ((min_vrun_flag > 0) & (min_vruntime - TICK_SIZE * (getweight(0) / cur_weight) < 0))
      {
        p->ovf_flag = min_vrun_flag - 1;
        p->vruntime = INT_MAX - TICK_SIZE * (getweight(0) / cur_weight) + min_vruntime;
      }
      else
        p->vruntime = min_vruntime - TICK_SIZE * (getweight(0) / cur_weight);
    }
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

// PAGEBREAK: 36
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

// ps functiond
int ps(void)
{
  struct proc *p;
  int max_name_len = 0;
  // Enables interrupts
  sti();

  // Loop over process table looking for process with pid
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (max_name_len < strlen(p->name))
      max_name_len = strlen(p->name);
  }
  cprintf("name");
  for (int i = 0; i < max_name_len - 4; i++)
  {
    cprintf(" ");
  }
  cprintf("\t\tpid\tstate\t\tpriority\truntime/weight\truntime\t\tvruntime\ttick %d\n", ticks * TICK_SIZE);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == SLEEPING)
    {
      ps_align_front(p, max_name_len);
      cprintf("\tSLEEPING");
      ps_align_back(p);
    }
    else if (p->state == RUNNING)
    {
      ps_align_front(p, max_name_len);
      cprintf("\tRUNNING ");
      ps_align_back(p);
    }
    else if (p->state == RUNNABLE)
    {
      ps_align_front(p, max_name_len);
      cprintf("\tRUNNABLE");
      ps_align_back(p);
    }
    else if (p->state == ZOMBIE)
    {
      ps_align_front(p, max_name_len);
      cprintf("\tZOMBIE  ");
      ps_align_back(p);
    }
  }
  release(&ptable.lock);
  return 0;
}

// setnice function
int setnice(int pid, int nice)
{

  struct proc *p;
  if (nice < MIN_NICE || nice > MAX_NICE)
  {
    return -1;
  }
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->nice = nice;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

// getnice function
int getnice(int pid)
{
  int nice;
  struct proc *p;
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      nice = p->nice;
      release(&ptable.lock);
      return nice;
    }
  }
  release(&ptable.lock);
  return -1;
}

int getweight(int nice)
{
  if (nice < MIN_NICE || nice > MAX_NICE)
  {
    return -1;
  }
  else
  {
    return weight[nice - MIN_NICE];
  }
}

int gettime_slice(struct proc *np)
{
  struct proc *p;
  double time_slice_d = 0;
  int time_slice_i = 0;
  // add next process weight(this operation start after state change)
  // runnable weight
  int total_weight = getweight(np->nice);
  // get total weight
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state != RUNNABLE)
      continue;
    total_weight += getweight(p->nice);
  }
  // double type time slice
  time_slice_d = SCHED_LATENCY * getweight(np->nice) / total_weight;

  // ceil time slice to int
  time_slice_i = (int)time_slice_d;
  if (time_slice_d < 0 || time_slice_d == (double)time_slice_i)
    return time_slice_i;
  else
    return time_slice_i + 1;
}

// update virtual runtime
void update_vruntime(void)
{
  int update_val = TICK_SIZE * getweight(0) / getweight(myproc()->nice);

  // overflow case
  if (myproc()->vruntime > INT_MAX - update_val)
  {
    myproc()->ovf_flag += 1;
    myproc()->vruntime = (myproc()->vruntime - INT_MAX) + update_val;
  }
  else
    myproc()->vruntime += update_val;
}

// print function for ps aliging not affected by length of name
void ps_align_front(struct proc *p, int max_len)
{
  // name part
  int blank = max_len - strlen(p->name);
  cprintf("%s", p->name);
  for (int i = 0; i < blank; i++)
  {
    cprintf(" ");
  }
  // pid
  cprintf("\t\t%d", p->pid);
}

// print function for ps aliging not affected by length of name
void ps_align_back(struct proc *p)
{
  // print priority, runtime/weight, runtime
  cprintf("\t%d\t\t%d\t\t%d", p->nice, (int)((p->runtime) / getweight(p->nice)), p->runtime);

  // print vruntime with overflow converage
  int div_num = 1 + (p->ovf_flag / 9);
  int max_val = INT_MAX;
  int vrun_val = p->vruntime;
  if (p->ovf_flag > 0)
  {
    for (int i = 0; i < div_num; i++)
    {
      max_val = max_val / 10;
      vrun_val = vrun_val / 10;
    }
    cprintf("\t\t%d", max_val + vrun_val);
    for (int j = 0; j < div_num; j++)
    {
      cprintf("0");
    }
  }
  else
  {
    cprintf("\t\t%d", p->vruntime);
  }
  cprintf("\n");
}