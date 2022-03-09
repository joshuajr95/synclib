

#ifndef LOCK_H
#define LOCK_H



typedef struct lock_t
{
    volatile int held = 0;

} lock_t;



int acquire(lock_t* lock);


int release(lock_t* lock);




#endif