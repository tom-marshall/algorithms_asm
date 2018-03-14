all:
	yasm -f elf64 -g dwarf2 -l gcf.lst gcf.asm
	ld -o gcf gcf.o

