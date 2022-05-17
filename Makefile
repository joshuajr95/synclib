
CC=gcc

# do not compile with debugging info for production code since it facilitates reverse-engineering
# i.e. -g is bad for production code
CFLAGS= -Wall --verbose
LFLAGS= 

SDIR = src
ODIR = obj
INCLUDEDIR = include
LIBDIR = lib

FILES = lock barrier semaphore
SFILES = $(patsubst %, $(SDIR)/%.c, $(FILES))
OFILES = $(patsubst %, $(ODIR)/%.o, $(FILES))
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
		LFLAGS += -shared

	else ifeq ($(DETECTED_OS), Darwin)
		CFLAGS += -D OSX
		LFLAGS += -dynamiclib
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



default: $(OFILES)

	$(info DETECTED_OS is ${DETECTED_OS})

	if [ ! -d $(LIBDIR) ]; then mkdir $(LIBDIR); fi

	$(CC) $(CFLAGS) $^ $(LFLAGS) -o $(OUTFILE)


$(ODIR)/%.o: $(SDIR)/%.c

	if [ ! -d $(ODIR) ]; then mkdir $(ODIR); fi

	$(CC) -c $(CFLAGS) -I $(INCLUDEDIR) -fPIC $^ -o $@

.PHONY: clean install uninstall


clean:
	rm -rf $(LIBDIR)
	rm -rf $(ODIR)


install:

	cp $(OUTFILE) $(INSTALL_PATH)
	
	for f in ${FILES}; do \
		cp ${INCLUDEDIR}/$$f.h ${SYSTEM_INCLUDE_DIR}/$$f.h ; \
	done

#	export LIBRARY_PATH=$$LIBRARY_PATH:$$DYLIB_DIR

#	echo "export LIBRARY_PATH=$$LIBRARY_PATH:${DYLIB_DIR}" >> ~/.bashrc
#	echo "export LIBRARY_PATH=$$LIBRARY_PATH:${DYLIB_DIR}" >> ~/.bash_profile

#	if [ -e "~/.zshrc" ]; then \
		echo "export LIBRARY_PATH=$$LIBRARY_PATH:$$DYLIB_DIR" >> ~/.zshrc; \
		echo "export LIBRARY_PATH=$$LIBRARY_PATH:$$DYLIB_DIR" >> ~/.zprofile; \
	fi

	


uninstall:

	if [ -e $(INSTALL_PATH) ]; then rm $(INSTALL_PATH); fi

	for f in ${FILES}; do \
		if [ -e ${SYSTEM_INCLUDE_DIR}/$$f.h ]; then rm ${SYSTEM_INCLUDE_DIR}/$$f.h; fi; \
	done