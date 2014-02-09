Synchronization
===============

To avoid `thread interference` and `memory consistency errors`, synchronization can be used.

Synchronization itself however can introduce `thread contention`, in which 2 or more threads try to access the same resource simultaneously and cause the Java runtime to execute 1 or more threads slowly.

Thread Interference
-------------------

Consider the following Counter class:

    class Counter {
        private int c = 0;

        public void increment() {
            c++;
        }

        public void decrement() {
            c--;
        }

        public int value() {
            return c;
        }

    }

Interference can occur if two operations, running in different threads acting on the same data, interleave.

An operation like `c++`, might be decomposed into the steps:

1) Retrieve the current value of `c`
2) Increment the retrieved value by 1
3) Store the incremented value back in `c`

If Thread A and Thread B both invoke `increment()` at about the same time, the following might happen:

1) Thread A: Retrieve c.
2) Thread B: Retrieve c.
3) Thread A: Increment retrieved value; result is 1.
4) Thread B: Decrement retrieved value; result is -1.
5) Thread A: Store result in c; c is now 1.
6) Thread B: Store result in c; c is now -1.

Thus, Thread A's result is lost; overwritten by B. There are various, unpredictable results that could occur however.


Memory Consistency Errors
-------------------------

Different threads may have inconsistent views of what should be the same data. They can be avoided through a `happens-before` relationship, a guarantee that memory writes by one specific statement are visible to another specific statement. e.g., if a counter is incremented and then printed out in the same thread, one can be sure the incremented value would be printed; this may not happen as expected if the two operations were in 2 different threads.

Synchronization can create `happens-before` relationships.

Additionally `thread.start()`, every statement before this line that has a `happens-before` relationship with this line ALSO has a `happens-before` relationship with the lines in the `thread` that is started.

`thread.join()` also has a similar effect (all the statements executed by the terminated thread are visible to the thread that performed the join).

Methods can have the keyword `synchronized` in their declaration, which makes it so that:

1) Two invocations on the same object can NOT interleave. When 1 thread executes the synchronized method, all other threads block (suspend execution) until the first thread is done with the object.

2) When a synchronized method exits, it establishes a `happens-before` relationship with any subsequent invocation of a synchronized method for the same object. So all changes to the state of the object are visible to all threads.

n.b.: constructors can't be synchronized (only the thread that creates an object should have access to it while it is being constructed)

Tip: if an object is visible to more than one thread, all reads or writes to that object's variables should be done through synchronized methods (final fields can be in non-synchronized methods safely however).


Intrinsic Locks and Synchronization
-----------------------------------

Intrinsic/monitor locks enforce exclusive access to an object's state and establish happens-before relationships. Every object has an intrinsic lock associated with it. A thread that needs exclusive and consistent access to an object's fields must acquire the object's intrinsic lock before accessing them, and then releasing the lock when it's done with them. As long as a thread owns an intrinsic lock for an object, other threads attempt to acquire the lock will block.

When a thread invokes a synchronized method, it automatically acquires the intrinsic lock for the method's object and releases it when the method returns. The lock release occurs even if the return was caused by an uncaught exception. For static synchronized methods, the thread acquires the intrinsic lock for the `Class` object associated with the class. Access to the class's static fields is controlled by a lock independent of the lock for any instance of the class.


Synchronized Statements:

- must specify the object that provides the intrinsic lock

    public void addName(String name) {
        synchronized(this) {
            lastName = name;
            nameCount++;
        }
        nameList.add(name);
    }

the `addName` method needs to synchronize changes to `lastName` and `nameCount`, but also needs to avoid synchronizing invocations of other objects' methods. (Invoking other objects' methods from synchronized code can create problems)

A class `MsLunch` has 2 instance fields c1 and c2 that are never used together. All updates of these fields must be synchronized; but there's no reason to prevent an update of c1 from being interleaved with an update of c2. Doing so would create unnecessary blocking and reduce concurrency. Thus, create 2 objects solely to provide locks.

    public class MsLunch {
        private long c1 = 0;
        private long c2 = 0;
        private Object lock1 = new Object();
        private Object lock2 = new Object();

        public void inc1() {
            synchronized(lock1) {
                c1++;
            }
        }

        public void inc2() {
            synchronized(lock2) {
                c2++;
            }
        }
    }

Reentrant Synchronization:

A thread can acquire a lock that it already owns. Allowing a thread to acquire the same lock more than once enables `reentrant synchronization` where synchronized code invokes a method that also contains synchronized code, and both sets of code use the same lock. e.g.

    synchronized(lock1) {
        someSynchronizedMethod();
    }


Atomic Access
-------------

An atomic action is one that effectively happens all at once; it either does happen, or doesn't happen; it doesn't stop in the middle. An increment operation is not atomic. Reads and writes are atomic for reference variables and most primitives (except `long` and `double`)

Reads and writes are atomic for all variables declared `volatile`

Atomic actions can't be interleaved, so they can be used without fear of thread interference. Memory consistency errors however are still possible. Using `volatile` reduces the risk of memory consistency errors, since any write to a volatile variable establishes a happens-before relationship with subsequent reads of that variable. 
