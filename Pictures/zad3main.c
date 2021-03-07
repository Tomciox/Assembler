#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void transform(int *, int, char, int);

int main(int argc, char **argv) {

	if (argc != 4) {
		printf("Niepoprawna liczba argumentów!\n");
		exit(0);
	}

	FILE* file = fopen(argv[1], "r");

	char format[3];
	int width, height, range;

	fscanf(file, "%s", format);
	fscanf(file, "%d%d", &height, &width);
	fscanf(file, "%d", &range);

	int size = 3 * height * width;

	int *picture = (int*) malloc(sizeof(int) * size);

	int i;
	for (i = 0; i < size; ++i) {
		fscanf(file, "%d", &picture[i]);
	}

	fclose(file);

	transform(picture, size, argv[2][0], atoi(argv[3]));

	char *y = (char *)malloc(sizeof(char) * 2);
	y[0] = 'Y';
	y[1] = '\0';

	FILE *yfile = fopen(strcat(y, argv[1]), "w");

	fprintf(yfile, "%s\n", format);
	fprintf(yfile, "%d %d\n", height, width);
	fprintf(yfile, "%d\n", range);

	for (i = 0; i < size; ++i) {
		fprintf(yfile, "%d ", picture[i]);
	}

	fclose(yfile);
	free(y);
	free(picture);

	return 0;
}