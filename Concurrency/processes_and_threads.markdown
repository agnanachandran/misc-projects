Processes and Threads
=====================

Two basic units of execution: processes and threads

Computers typically have many active processes and threads. Processing time for a single core is shared among processes and threads through `time slicing`.

A single core implies only one thread can execute at a time.


Process
-------

A *process* has a self-contained execution environment. A process has a private set of basic run-time resources; each process has its own memory space.

A program can have a set of processes that communicate with each other through IPC (Inter process communication) resources, like pipes and sockets.



Threads
-------

Sometimes called lightweight processes. Both processes and threads provide an execution environment, but creating a new thread requires fewer resources than creating a new process. Threads exist within a process; every process has at least 1 thread. Threads share the process's resources, including memory and open files.

From the programmer's POV, you start with 1 thread; the main thread. It can create additional threads.

Each thread is associated with an instance of the `Thread` class.


Thread Objects
==============

One can directly control thread creation and management through instantiating a `Thread` each time the application needs to do something asynchronously.

One can also abstract thread management through the use of an `executor`.


Defining and Starting a Thread
==============================

An application that creates an instance of Thread must provide the code that runs in the thread through the `run()` method.

2 ways:

Implement `Runnable`, an interface that only contains the run() method, and can be passed to the `Thread` constructor

1) Providing a `Runnable` object:

    public class HelloRunnable implements Runnable {

        public void run() {
            System.out.println("Hello from a thread!");
        }

        public static void main(String args[]) {
            // Pass 
            (new Thread(new HelloRunnable())).start();
        }

    }

2) Subclass `Thread` (which itself implements `Runnable`, but its implementation does nothing)

    public class HelloThread extends Thread {


        public void run() {
            System.out.println("Hello from a thread!");
        }

        public static void main(String args[]) {
            (new HelloThread()).start();
        }

    }

Calling `Thread.start()` starts the new thread.


The first idiom is more general, since the Runnable object can subclass a class other than Thread; the second idiom is easier to use in simple applications, but is limited by the fact that your class must be a descendent of `Thread`.


Pausing Execution with Sleep
============================

Refer to `SleepMessages.java` for an example of using `Thread.sleep(int ms)`


Joins
=====

The `thread.join()` method (optionally takes a waiting period), pauses the current thread to wait for the completion of another thread.

For example, if the main thread calls t.join(), where t is a thread object, the main thread will wait until t's execution is complete; likewise, t.join(1000) will wait 1000 ms (1 second) for t to finish, and then the main thread will continue working.

