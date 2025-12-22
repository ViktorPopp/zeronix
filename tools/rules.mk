$(OBJDIR)/%.c.o: $(SRCDIR)/%.c
	@$(MKDIR)
	@printf "  CC\t$<\n"
	@$(CC) $(CFLAGS) -MMD -MP -MF $(OBJDIR)/$*.c.d -c -o $@ $<

$(OBJDIR)/%.asm.o: $(SRCDIR)/%.asm
	@$(MKDIR)
	@printf "  AS\t$<\n"
	@$(AS) $(ASFLAGS) $< -o $@

$(BINDIR)/$(TARGET): $(OBJ)
	@$(MKDIR)
	@printf "  LD\t$@\n"
	@$(LD) $(LDFLAGS) -o $@ $^
