# Notes:
# -m is machine specific flags
# -f is machine independent flags
# -W is related to warnings
#
# Everything here is also amd64/x86_64 only

MKDIR = mkdir -p $(@D)

CC = clang
AS = nasm
LD = ld

CFLAGS := \
	-Wall \
	-Wextra \
	-std=c23 \
	-ffreestanding \
	-m64 \
	-march=x86-64

ASFLAGS := \
	-Wall \
	-f elf64

LDFLAGS := \
	-m elf_x86_64

CFLAGS_DISABLE_SIMD := \
	-mno-mmx \
	-mno-3dnow \
	-mno-80387 \
	-mno-sse \
	-mno-sse2 \
	-mno-sse3 \
	-mno-ssse3 \
	-mno-sse4

ifeq ($(DEBUG),1)
	CFLAGS += -O0 -g
else
	CFLAGS += -O3
endif

SRC = $(shell find src -name "*.c" -o -name "*.s")
OBJ = $(patsubst src/%, $(OBJDIR)/%.o, $(SRC))
DEP = $(OBJ:.o=.d)

BINDIR = bin
OBJDIR = obj
SRCDIR = src

-include $(DEP)
