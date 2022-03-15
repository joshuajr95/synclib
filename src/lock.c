#define _GNU_SOURCE

#ifndef __GNUC__
#define __asm__ asm
#define __volatile__ volatile
#endif

#include <unistd.h>
#include <lock.h>



int init(lock_t* lock)
{
    lock->held = 0;

    return 0;
}


int acquire(lock_t* lock)
{
    volatile int* isHeld = &(lock->held);
    
    //pid_t threadid = gettid();



// section for inline assembly containing acquire code for x64 architectures
#if defined(__amd64__) || defined(__amd64) || defined(__x86_64__) || defined(__x86_64)

    /*
    __asm__ __volatile__("loop:\n\t");
    __asm__ __volatile__("movq (%%rdi), %%rax\n\t" : : "r" (isHeld): "%rax", "%rcx", "%rdx");
    __asm__ __volatile__("xor %rcx, %rcx\n\t");
    __asm__ __volatile__("mov $1, %rdx\n\t");
    __asm__ __volatile__("lock cmpxchg %rdx, %rcx\n\t");
    __asm__ __volatile__("jnz loop\n\t");
    */

    __asm__ __volatile__("loop:\n\t");
    __asm__ __volatile__("movq $0, %%rax\n\t" : : : "%rax");
    __asm__ __volatile__("movq $1, %%rcx\n\t" : : : "%rcx");
    __asm__ __volatile__("lock cmpxchgq %%rcx, (%%rdi)\n\t" : : "m" (isHeld));
    __asm__ __volatile__("jnz loop\n\t");
    

    /*__asm__ goto ("jnz loopb\n\t"
                :
                : 
                : :loop);*/

// section for inline assembly containing acquire code for x86 architectures
#elif defined(i386) || defined(__i386) || defined(__i386__)



// aquire code for ARM 32-bit architectures
#elif defined(__arm__)


// acquire code for ARM 64-bit architectures
#elif defined(__aarch64__)

#else


#endif

    return 0;
}


int release(lock_t* lock)
{
    lock->held = 0;

    return 0;
}