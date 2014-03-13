LIBDIR := lib
SRCDIR := src
INCDIR := inc
EXDIR := examples

UNQLITE_SRC := $(SRCDIR)/unqlite.c
UNQLITE_OBJ := $(SRCDIR)/unqlite.o
UNQLITE_LIB := $(LIBDIR)/libunqlite.a
UNQLITE_MT_LIB := $(LIBDIR)/libunqlite-mt.a
UNQLITE_MT_OBJ := $(SRCDIR)/unqlite-mt.o

LIBS := $(UNQLITE_LIB) $(UNQLITE_MT_LIB)
OBJS := $(UNQLITE_OBJ) $(UNQLITE_MT_OBJ)

GCC := gcc
CFLAGS := -m32 -pipe -fPIC -g -O3 -fno-exceptions -fstack-protector -Wl,-z,relro -Wl,-z,now -fvisibility=hidden
UNQLITE_FLAGS := -DJX9_ENABLE_MATH_FUNC -DUNQLITE_ENABLE_JX9_HASH_IO
UNQLITE_MT_FLAGS := $(UNQLITE_FLAGS) -DUNQLITE_ENABLE_THREADS

FBC := fbc
RM := rm -f

all : $(LIBS)

.PHONY : clean
clean :
	@$(RM) $(LIBS) $(OBJS)
	@cd $(EXDIR) && make clean

.PHONY : examples
examples : $(LIBS)
	+@cd $(EXDIR) && make

$(UNQLITE_LIB) : $(UNQLITE_OBJ)
	@$(FBC) -lib $(UNQLITE_OBJ) -x $(UNQLITE_LIB)

$(UNQLITE_OBJ) : $(UNQLITE_SRC)
	@$(GCC) $(CFLAGS) $(UNQLITE_FLAGS) -c $(UNQLITE_SRC) -o $(UNQLITE_OBJ)

$(UNQLITE_MT_LIB) : $(UNQLITE_MT_OBJ)
	@$(FBC) -mt -lib $(UNQLITE_MT_OBJ) -x $(UNQLITE_MT_LIB)

$(UNQLITE_MT_OBJ) : $(UNQLITE_SRC)
	@$(GCC) $(CFLAGS) $(UNQLITE_MT_FLAGS) -c $(UNQLITE_SRC) -o $(UNQLITE_MT_OBJ)
