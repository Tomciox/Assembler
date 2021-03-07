#include <stdlib.h>
#include <stdio.h>

extern void start(int szer_, int wys_, float *M_, float waga_);
extern void step(float T[]);

// ---------------------------
/*
int szer, szer2, wys, wys2, diff;
float *M, waga;


void start(int szer_, int wys_, float *M_, float waga_) {
	szer = szer_;
	szer2 = szer_ + 8;
	wys = wys_;
	wys2 = wys_ + 2;

	diff = szer2 * wys2;

	M = M_;
	waga = waga_;
}

void step(float T[]) {
	int i, j;

	for (i = 1; i <= wys; ++i) {
		M[i * szer2] = T[i - 1];
	}

	for (j = 0; j < wys; ++j) {
		for (i = 0; i < szer; ++i) {
			int idx = j * szer2 + i;
			int idx2 = idx + szer2 + 1 + diff;

			M[idx2] = M[idx];

			idx += 1;
			M[idx2] += M[idx];

			idx += szer2 - 1;
			M[idx2] += M[idx];

			idx += szer2;
			M[idx2] += M[idx];

			idx += 1;
			M[idx2] += M[idx];
		}
	}

	for (j = 1; j <= wys; ++j) {
		for (i = 1; i <= szer; ++i) {
			int idx = j * szer2 + i;
			int idx2 = idx + diff;

			M[idx] += (5 * M[idx] - M[idx2]) * waga;
		}
	}
}
*/

// ---------------------------


// funkcja wypisująca zawartość tablicy,
// bez górnego i dolnego paddingu, bez zerowego wiersza, bez końcowego paddingu

void print(int wys_, int szer_, float *M_) {
	int i, j;

	for (j = 1; j <= wys_; ++j) {
		for (i = 1; i <= szer_; ++i) {
			printf("%f ", M_[j * (szer_ + 8) + i]);
		}
		printf("\n");
	}
	printf("\n");

}


int main() {

	int szer_, wys_;
	float *M_, waga_;

	scanf("%d%d%f", &szer_, &wys_, &waga_);

	int szer2_ = szer_ + 8, wys2_ = wys_ + 2;

	M_ = (float *)malloc(sizeof(float) * szer2_ * wys2_ * 2);

	int i, j;

	// wyzerowanie całej tablicy
	for (i = 0; i < szer2_ * wys2_ * 2; ++i) {
		M_[i] = 0.0;
	}

	// wczytanie początkowych wartości zanieczyszczeń na odpowiednie miejsca
	for (j = 1; j <= wys_; ++j) {
		for (i = 1; i <= szer_; ++i) {
			scanf("%f", &M_[j * szer2_ + i]);
		}
	}

	// print(wys_, szer_, M_);

	start(szer_, wys_, M_, waga_);

	int ile_krokow;
	scanf("%d", &ile_krokow);

	float *T_ = (float *)malloc(sizeof(float) * wys_);

	for (i = 0; i < ile_krokow; ++i) {

		for (j = 0; j < wys_; ++j) {
			scanf("%f", &T_[j]);
		}

		step(T_);

		print(wys_, szer_, M_);

	}

	free(T_);
	free(M_);

	return 0;
}