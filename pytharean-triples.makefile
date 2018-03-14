all:
	yasm -f elf64 -g dwarf2 pytharean-triples.asm -l pytharean-triples.lst
	gcc -o pytharean-triples pytharean-triples.o
