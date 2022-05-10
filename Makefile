
CC=gcc

# do not compile with debugging info for production code since it facilitates reverse-engineering
# i.e. -g is bad for production code
CFLAGS= -Wall -shared -fPIC

SDIR = src
ODIR = obj
INCLUDEDIR = include
LIBDIR = lib

FILES = lock barrier semaphore
SFILES = $(patsubst %, $(SDIR)/%.c, $(FILES))
LIBFILE = libsync

DETECTED_OS = 
OUTFILE = 

DYLIB_DIR = 
INSTALL_PATH = 

SYSTEM_INCLUDE_DIR = 


ifeq ($(OS), Windows_NT)
	DETECTED_OS =  WINDOWS
	CFLAGS += -D WIN32

else
	DETECTED_OS = $(strip $(shell uname -s))


	ifeq ($(DETECTED_OS), Linux)
		CFLAGS += -D LINUX

	else ifeq ($(DETECTED_OS), Darwin)
		CFLAGS += -D OSX
	endif

endif


ifeq ($(DETECTED_OS), WINDOWS)
	OUTFILE = $(patsubst %, $(LIBDIR)/%.dll, $(LIBFILE))

else ifeq ($(DETECTED_OS), Linux)
	OUTFILE = $(patsubst %, $(LIBDIR)/%.so, $(LIBFILE))
	DYLIB_DIR = /usr/local/lib
	INSTALL_PATH = $(patsubst %, $(DYLIB_DIR)/%.so, $(LIBFILE))
	SYSTEM_INCLUDE_DIR = /usr/local/include

else ifeq ($(DETECTED_OS), Darwin)
	OUTFILE = $(patsubst %, $(LIBDIR)/%.dylib, $(LIBFILE))
	DYLIB_DIR = /usr/local/lib
	INSTALL_PATH = $(patsubst %, $(DYLIB_DIR)/%.dylib, $(LIBFILE))
	SYSTEM_INCLUDE_DIR = /usr/local/include

else
	
endif



default: $(SFILES)

	$(info DETECTED_OS is ${DETECTED_OS})

	if [ ! -d $(LIBDIR) ]; then mkdir $(LIBDIR); fi

	$(CC) $(CFLAGS) -I $(INCLUDEDIR) $^ -o $(OUTFILE)



.PHONY: clean install uninstall


clean:
	rm -rf $(LIBDIR)


install:

	cp $(OUTFILE) $(INSTALL_PATH)
	
	for f in $(FILES); do \
		cp $(INCLUDEDIR)/$(f).h $(SYSTEM_INCLUDE_DIR)/$(f).h ; \
	done


uninstall:

	if [ -e $(INSTALL_PATH) ]; then rm $(INSTALL_PATH); fi
