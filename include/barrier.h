/*
 * File: barrier.h
 * Author: Joshua Jacobs-Rebhun
 * Date: March 8, 2022
 */

#ifndef BARRIER_H
#define BARRIER_H

#include "lock.h"

/*
 * Struct that implements a sense-reversal barrier
 */
typedef struct barrier_t
{
    // number of threads that are using the barrier
    const volatile int numThreads;

    // current count of threads that have reached the barrier
    volatile int count;

    // lock for achieving atomic access of the barrier count variable
    lock_t countLock;

} barrier_t;


/*
 * This function initializes the barrier struct to be used by
 * a certain number of threads. Both parameters passed in by the user
 */
int barrier_init(barrier_t* barrier, int numThreads);


/*
 * Waits on the barrier.
 */
int barrier_wait(barrier_t* barrier);



#endif