DEFAULTS_MK = ../tools/defaults.mk
RULES_MK    = ../tools/rules.mk

include $(DEFAULTS_MK)

TARGET = kernel.elf

CFLAGS += \
	$(CFLAGS_DISABLE_SIMD) \
	-fno-omit-frame-pointer \
	-fno-stack-protector \
	-fno-stack-check \
	-mno-red-zone \
	-mcmodel=kernel \
	-I src/include \
	-I libs \
	-MMD \
	-MP

LDFLAGS += \
	-nostdlib \
	-static \
	-z max-page-size=0x1000 \
	-T linker.lds

include $(RULES_MK)

.PHONY: all
all: $(BINDIR)/$(TARGET)

.PHONY: clean
clean:
	@rm -rf $(BINDIR) $(OBJDIR)

.PHONY: nuke
nuke: clean
	@rm -rf libs/
