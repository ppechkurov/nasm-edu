MAKEFLAGS += --no-print-directory

src/modules/strings/%.o: src/modules/strings/%.asm
	nasm -f elf32 $< -g
strings: src/modules/strings/strlen.o src/modules/strings/print.o

modules: strings

obj/%.o: src/**/%.asm modules
	nasm -f elf32 $< -o $@ -g

bin/%: obj/%.o
	ld -m elf_i386 $< \
		src/modules/strings/strlen.o \
		src/modules/strings/print.o \
		-o $@

asm: bin/$(bin)

.PHONY: watch
watch:
	@$(MAKE) clean
	@watchexec --watch src/$(bin) "make asm bin=$(bin) && echo && $(bin)"

.PHONY: clean
clean:
	rm bin/* obj/* -rf
	find . -name '*.o' -delete

.PHONY: init
init:
	@mkdir {bin,obj} -p
