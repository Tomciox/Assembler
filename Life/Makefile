all: convay

convay: convaymain.c convayb.o
	gcc -o convay convaymain.c convayb.o -no-pie

.SECONDARY:

%.o: %.asm
	nasm -f elf64 -F dwarf -g $<

%: %.o
	ld $< -o $@ -lc --dynamic-linker=/lib64/ld-linux-x86-64.so.2


clean:
	rm -rf convay *.o
