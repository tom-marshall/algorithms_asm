PHONY: b32

b32:
	yasm -f elf64 -g dwarf2 base32.asm -l base32.lst
	gcc -o base32 base32.o

