all: zad2

zad2: zad2main.c zad2.o
	gcc -o zad2 zad2main.c zad2.o -no-pie

.SECONDARY:

%.o: %.asm
	nasm -f elf64 -F dwarf -g $<

%: %.o
	ld $< -o $@ -lc --dynamic-linker=/lib64/ld-linux-x86-64.so.2


clean:
	rm -rf zad2 *.o
