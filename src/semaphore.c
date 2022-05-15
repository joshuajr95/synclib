
#include <semaphore.h>




int semaphore_init(semaphore_t* sem, int initial_value)
{
    sem->flag = initial_value;

    init(&sem->sem_lock);

    return 0;
}


int semaphore_wait(semaphore_t* sem)
{

// label is used for rare case of possible interleaving of instructions when
// decrementing the semaphore flag value. May be a better way of implementing this
bad_wait:

    // wait for the signal operation to increment the flag
    while(sem->flag == 0);

    // acquire and release of semaphore lock ensures mutual exclusion when
    // modifying the value of the flag variable
    acquire(&sem->sem_lock);

    // This conditional is in case of interleaving of instructions above.
    // Since the while loop is not atomic, it is possible for two threads
    // to exit the while loop on only 1 signal operation. The first thread
    // to get here will skip this section, decrement the flag, and release
    // the lock. The next thread will execute this section and redo the wait.
    if(sem->flag == 0)
    {
        release(&sem->sem_lock);
        goto bad_wait;
    }

    sem->flag--;
    release(&sem->sem_lock);

    return 0;
}


int semaphore_signal(semaphore_t* sem)
{
    acquire(&sem->sem_lock);
    sem->flag++;
    release(&sem->sem_lock);

    return 0;
}