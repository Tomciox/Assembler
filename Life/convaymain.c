#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

extern void start(int, int, int*);
extern void run(int);

const int TIMES = 200; 									// liczba powtórzeń symulacji
const int KROKI = 1; 									// liczba kroków (epok) w jednym powtórzeniu symulacji (pomiędzy wypisywaniami)
const int SLEEP = 1; 									// pauza w sekundach po wypisaniu

int main() {
	int wys, szer;
	scanf("%d%d", &szer, &wys);

	int *T = (int *)malloc(sizeof(int) * (wys + 2) * (szer + 2));

	for (int i = 0; i < (wys + 2) * (szer + 2); ++i) {
		T[i] = 0;
	}

	for (int i = 1; i <= wys; ++i) {
		for (int j = 1; j <= szer; ++j) {
			int idx = (szer + 2) * i + j;
			scanf("%d", &T[idx]);
		}
	}

	start(wys, szer, T); 								// inicjalizacja tablicy

	for (int i = 0; i < TIMES; ++i) {
		run(KROKI); 									// symulacja jednego kroku

		sleep(SLEEP);
		printf("\e[1;1H\e[2J");

		for (int i = 1; i <= wys; ++i) {
			for (int j = 1; j <= szer; ++j) {
				int idx = (szer + 2) * i + j;
				printf("%c ", T[idx] ? '#' : ' ');
			}
			printf("\n");
		}
		printf("\n");
	}

	free(T);

	return 0;

}
