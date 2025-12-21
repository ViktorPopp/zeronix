OUTPUT  = zeronix.iso
SYSROOT = sysroot

XORRISO_FLAGS :=                                             \
	-as mkisofs -b boot/limine/limine-bios-cd.bin            \
	-no-emul-boot -boot-load-size 4 -boot-info-table         \
	--efi-boot boot/limine/limine-uefi-cd.bin                \
	-efi-boot-part --efi-boot-image --protective-msdos-label \
	sysroot -o $(OUTPUT)

QEMU_FLAGS := \
	-m 128M -M smm=off -serial stdio -d int -D qemu.log \
	-no-reboot -no-shutdown -M q35

.PHONY: all
all: $(OUTPUT)

.PHONY: help
help:
	@printf "Zeronix Build System\n\n"
	@printf "\033[1mUSAGE\033[0m\n"
	@printf "  make <command> [flags]\n\n"
	@printf "\033[1mCOMMANDS\033[0m\n"
	@printf "  all:\t\tBuild the entire operating system\n"
	@printf "  help:\t\tShow this message\n"
	@printf "  run:\t\tRun the operating system in QEMU (ISO only)\n"
	@printf "  bear:\t\tGenerate compile_commands.json (used by clangd)\n"
	@printf "  kernel:\tBuild the kernel\n"
	@printf "  deps:\t\tPull all dependencies\n"
	@printf "  clean:\tRemove all build artifacts\n"
	@printf "  nuke:\t\tRemove all dependencies and build artifacts\n\n"
	@printf "\033[1mFLAGS\t\t\t\t\t\tDEFAULT\033[0m\n"
	@printf "  OUTPUT\tISO file output\t\t\tzeronix.iso\n"
	@printf "  SYSROOT\tTemporary sysroot directory\tsysroot\n"

.PHONY: run
run: $(OUTPUT) edk2-ovmf
	@printf ">>> Running in QEMU\n"
	@qemu-system-x86_64                                                                   \
		-drive if=pflash,unit=0,format=raw,file=edk2-ovmf/ovmf-code-x86_64.fd,readonly=on \
		-cdrom $(OUTPUT)                                                                  \
		$(QEMU_FLAGS)

limine/limine:
	@printf ">>> Building limine\n"
	@$(MAKE) -C limine > /dev/null 2>&1

.PHONY: kernel
kernel:
	@printf ">>> Building kernel\n"
	@$(MAKE) -C kernel --no-print-directory

$(OUTPUT): limine/limine kernel
	@printf ">>> Building ISO\n"
	@rm -rf $(SYSROOT)
	@mkdir -p $(SYSROOT)/boot
	@mkdir -p $(SYSROOT)/boot/limine
	@mkdir -p $(SYSROOT)/EFI/BOOT
	@mkdir -p $(SYSROOT)/system
	@cp kernel/bin/kernel.elf $(SYSROOT)/system/
	@cp -r target/* $(SYSROOT)/
	@cp limine/limine-bios.sys limine/limine-bios-cd.bin limine/limine-uefi-cd.bin $(SYSROOT)/boot/limine/
	@cp limine/BOOTX64.EFI $(SYSROOT)/EFI/BOOT/
	@cp limine/BOOTIA32.EFI $(SYSROOT)/EFI/BOOT/
	@printf "  RUN\txorriso\n"
	@xorriso $(XORRISO_FLAGS) > /dev/null 2>&1
	@printf "  RUN\tbios-install\n"
	@./limine/limine bios-install $(OUTPUT) > /dev/null 2>&1
	@rm -rf sysroot

.PHONY: bear
bear: clean
	@printf "=== Generating \`compile_commands.json\` ===\n"
	@bear -- make --no-print-directory

.PHONY: deps
deps:
	@git submodule update --init

.PHONY: clean
clean:
	@$(MAKE) -C kernel clean --no-print-directory
	@rm -rf $(OUTPUT) qemu.log

.PHONY: nuke
nuke: clean
	@$(MAKE) -C kernel nuke --no-print-directory
	@rm -rf limine
	@rm -rf edk2-ovmf
	@rm -rf compile_commands.json

edk2-ovmf:
	@curl -sSL https://github.com/osdev0/edk2-ovmf-nightly/releases/latest/download/edk2-ovmf.tar.gz | gunzip | tar -xf -
