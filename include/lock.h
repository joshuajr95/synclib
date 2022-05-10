/*
 * File: lock.h
 * Author: Joshua Jacobs-Rebhun
 * Date: March 16, 2022
 * 
 * Header for the spinlock and any others.
 */

#ifndef LOCK_H
#define LOCK_H



typedef struct lock_t
{
    volatile int held; // = 0;

} lock_t;


int init(lock_t* lock);

int acquire(lock_t* lock);

int release(lock_t* lock);




#endif