# synclib
thread synchronization library


Build Instructions:

1.) Download the code from github.
2.) Using terminal, navigate to the top-level directory (folder) of the project.
3.) Type 'make'. This builds the dynamically-linked library file from the source code.
4.) Type 'make install'. This installs the dynamically-linked library (.so on Linux and .dylib on Mac)
    as well as the required headers in the proper directories in the filesystem so that the GCC compiler
    can find them.


To uninstall:

1.) Navigate back to the top-level directory using terminal
2.) Type 'make uninstall'.