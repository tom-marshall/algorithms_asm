gcf:
	yasm -f elf64 -g dwarf2 -l gcf.lst gcf.asm
	ld -o gcf gcf.o

soe:
	yasm -f elf64 -g dwarf2 -l sieve_of_eratosthenes.lst sieve_of_eratosthenes.asm
	gcc -no-pie -fno-pie -o sieve_of_eratosthenes sieve_of_eratosthenes.o

pal:
	yasm -f elf64 -g dwarf2 palindrome.asm -l palindrome.lst
	ld -o palindrome palindrome.o
