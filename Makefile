# Compiler flags.
COMMON_CFLAGS = -m32  -g -O2 -std=gnu99 -I. -Iinclude -fno-stack-protector $(CFLAGS) -DARCH=i386
COMMON_LDFLAGS = -g -L. $(LDFLAGS)
ifeq ($(OS),darwin)
	COMMON_CFLAGS += -m32 -D_XOPEN_SOURCE -D_DARWIN_C_SOURCE -DARCH=i386
	COMMON_LDFLAGS += -m32
endif

 # Compiler options
HOST_CC		:= $(CC) -fno-inline -m32  -DARCH=i386
ifeq ($(OS),darwin)
	HOST_CC		:= $(HOST_CC)  -D_XOPEN_SOURCE
endif
HOST_LD		:= $(LD) -arch i386
HOST_AR		:= $(AR)
HOST_LDFLAGS	:= $(COMMON_LDFLAGS)
HOST_CFLAGS	:= $(COMMON_CFLAGS)

# Eliminate default suffix rules
.SUFFIXES:

# Delete target files if there is an error (or make is interrupted)
.DELETE_ON_ERROR:

H_FILES = \
	fmt.h \
	lib.h \
	u.h \
	unix.h \
	utf.h \

LIBS = \
	libmemlayer/libmemlayer.a \
	libmemdraw/libmemdraw.a \
	libdraw/libdraw.a \

# Make sure that 'all' is the first target
all: $(LIBS)

# regenerate .c files from Plan 9 source
AUTOGEN = include libdraw libmemdraw libmemlayer
autogen: $(AUTOGEN:%=%.autogen)
%.autogen:
	test -d "$(plan9)" && ./autogen.sh $(@:%.autogen=%)

# Include Makefrags for subdirectories
include libdraw/Makefrag
include libmemlayer/Makefrag
include libmemdraw/Makefrag

clean:
	rm -f $(CLEAN_FILES)
