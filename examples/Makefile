INCDIR := ../inc
LIBDIR := ../lib
RM := rm -f
FBC := fbc

ifeq ($(OS),Windows_NT)
	EXE_EXT := exe
else
	EXE_EXT := bin
endif

EXAMPLE_SRC := unqlite-fb.bas
EXAMPLE_BIN := $(patsubst %.bas,%.$(EXE_EXT),$(EXAMPLE_SRC))

all : $(EXAMPLE_BIN)

%.$(EXE_EXT) : %.bas
	@$(FBC) -i $(INCDIR) -p $(LIBDIR) $< -x $@

.PHONY : clean
clean :
	@$(RM) $(EXAMPLE_BIN)
