
CC=gcc
CFLAGS= -g -Wall -shared -fPIC

SDIR = src
ODIR = obj
INCLUDEDIR = include
LIBDIR = lib

FILES = lock #barrier semaphore
SFILES = $(patsubst %, $(SDIR)/%.c, $(FILES))
LIBFILE = synclib

DETECTED_OS = 
OUTFILE = 


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

else ifeq ($(DETECTED_OS), Darwin)
	OUTFILE = $(patsubst %, $(LIBDIR)/%.dylib, $(LIBFILE))

else
		
endif



default: $(SFILES)

	$(info DETECTED_OS is ${DETECTED_OS})

	$(CC) $(CFLAGS) -I $(INCLUDEDIR) $^ -o $(OUTFILE)


