Liveness
========

A concurrent application's ability to execute in a timely manner is known as its liveliness. 2 problems that can occur are `deadlock` and `starvation and livelock`.

Deadlock
--------

This is when 2 or more threads are blocked, waiting for each other forever.

For example; refer to the `DeadlockExample` class. When `DeadlockExample` runs, it is likely that both threads will be blocked when they attempt to invoke `bowback()`, waiting for each other to exit `bow`.

Starvation
----------

A thread may be unable to gain regular access to shared resources and is unable to make progress. This happens when shared resources are made unavailable for long periods by "greedy" threads. 

For example, suppose an object provides a synchronized method that often takes a long time to return. If one thread invokes this method frequently, other threads that also need frequent synchronized access to the same object will often be blocked.
