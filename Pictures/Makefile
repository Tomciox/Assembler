# Makefile
all: zad3

zad3: zad3.o
	gcc -o zad3 zad3main.c zad3.o -lm
zad3.o : zad3.s
	as -o zad3.o zad3.s
clean:
	rm -vf zad3 *.o

