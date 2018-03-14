all:
	yasm -f elf64 -g dwarf2 palindrome.asm -l palindrome.lst
	ld -o palindrome palindrome.o
