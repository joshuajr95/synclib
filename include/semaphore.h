/*
 * File: semaphore.h
 * Author: Joshua Jacobs-Rebhun
 * Date: March 15, 2022
 * 
 * Semaphore header file
 */


#ifndef SEMAPHORE_H
#define SEMAPHORE_H

#include <lock.h>

typedef struct semaphore_t
{
    // flag variable used to signal whether or not a process should proceed
    // 0 implies waiting processes cannot proceed, while > 0 implies waiting
    // processes can proceed
    volatile int flag;

    // lock provides mutual exlusion for when processes need to increment or
    // decrement the flag variable
    lock_t sem_lock;

} semaphore_t;


int semaphore_init(semaphore_t* sem, int initial_value);

int semaphore_wait(semaphore_t* sem);

int semaphore_signal(semaphore_t* sem);






#endif