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

BINDIR = bin
OBJDIR = obj
SRCDIR = src

SRC_C := $(shell find $(SRCDIR) -name "*.c" | sort)
SRC_ASM := $(shell find $(SRCDIR) -name "*.asm" | sort)

OBJ_C := $(SRC_C:$(SRCDIR)/%.c=$(OBJDIR)/%.c.o)
OBJ_ASM := $(SRC_ASM:$(SRCDIR)/%.asm=$(OBJDIR)/%.asm.o)
OBJ := $(OBJ_C) $(OBJ_ASM)

DEP := $(OBJ_C:.o=.d)

-include $(DEP)
