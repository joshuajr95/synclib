# synclib
This is a simple thread synchronization library. It contains code for a simple spinlock, a sense-reversing barrer, and a semaphore. It cannot do anything very advanced so don't even try.


__This library does not work on Windows.__


### Build Instructions:

1. Download the code from github.
2. Using terminal, navigate to the top-level directory (folder) of the project.
3. Type `make`. This builds the dynamically-linked library file from the source code. You should see directories called `obj` and `lib` appear in the current directory. The library file is in `lib`.
4. Type `make install`. This installs the dynamically-linked library (.so on Linux and .dylib on Mac)
    as well as the required headers in the proper directories in the filesystem so that the GCC compiler
    can find them.
5. To check if the headers installed correctly, type `ls /usr/local/include`. You should see `lock.h`, `barrier.h`, and `semaphore.h` among the other headers in the directory.
6. To check if the shared library was installed correctly, type `ls /usr/local/lib`. You should see a library called `libsync.so` (on Linux) or `libsync.dylib` (on Mac).


### To uninstall:

1. Navigate back to the top-level directory using terminal
2. Type `make uninstall`.


### Using the library in your code:

1. There are three C headers that contain struct and function definitions: `lock.h`, `barrier.h`, and `semaphore.h`. To include the headers in your code use `#include <header>`.
2. To compile your code, simply compile normally and then when linking pass the `-lsync` flag to `gcc`. 