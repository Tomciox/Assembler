Moje rozwiązanie trzyma matrycę jako jednowymiarową tablicę wielkości:

size = 3 * height * width

##UWAGA##

Zmiana nazwy pliku (dopisanie 'Y') działa tylko w przypadku jeśli plik jest podany na równi z programem (ze względu na modyfikację ścieżki w C).

Zadziała:
./zad3 apple.ppm R 1000 && emacs Yapple.ppm

Nie zadziała:
./zad3 ../apple.ppm R 1000 && emacs ../Yapple.ppm