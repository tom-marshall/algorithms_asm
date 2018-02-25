gcf:
	nasm -f elf64 -g -F stabs gcf.asm -l gcf.lst
	ld -o gcf gcf.o

