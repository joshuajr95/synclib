/*
 * Implementation of the sense-reversal barrier defined in barrier.h
 */

#include <stdbool.h>
#include <barrier.h>


int barrier_init(barrier_t* barrier, int numThreads, int start_count)
{
    barrier->numThreads = numThreads;
    barrier->count = start_count;
    barrier->sense = false;

    init(&barrier->countLock);
}


int barrier_wait(barrier_t* barrier)
{
    acquire(&barrier->countLock);

    if(barrier->count == barrier->numThreads - 1)
    {
        barrier->count = 0;
        barrier->sense = !barrier->sense;
        release(&barrier->countLock);
    }

    else
    {
        bool prev_sense = barrier->sense;

        barrier->count++;
        release(&barrier->countLock);

        while(barrier->sense == prev_sense);
    }

}