MAKEFLAGS += --no-print-directory

obj/%.o: src/**/%.asm
	nasm -f elf32 $< -o $@

bin/%: obj/%.o
	ld -m elf_i386 $< -o $@

asm: bin/$(bin)

.PHONY: watch
watch:
	@$(MAKE) clean
	@watchexec --watch src/$(bin) "make asm bin=$(bin) && echo && $(bin)"

.PHONY: clean
clean:
	rm bin/* obj/* -rf

.PHONY: init
init:
	@mkdir {bin,obj} -p
