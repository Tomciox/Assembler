Opis rozwiązania:

1. Uruchomienie

Budowanie i uruchamianie na maszynie students:

```
make convay && ./convay < NAZWA_TESTU
```

Gdzie NAZWA_TESTU jest plikiem w formacie z treści zadania. Dostarczone testy: 

tests/toad.in, 
tests/fountain.in, 
tests/glider_gun.in, 
tests/diehard.in.

Czyszczenie plików wykonywalnych:
```
make clean
```

2. Pliki

Makefile
convaymain.c
convayb.asm
tests/

3. Indeksacja

Zastosowałem strażników dookoła planszy, strażnicy są zerami,
żeby nie musieć sprawdzać dla właściwej tablicy czy sąsiedzi istnieją.

Ma ona zatem przykładową postać:

Dla danych wymiarów: szer = 7, wys = 5

  0 1 2 3 4 5 6 7 8
  - - - - - - - - -
0|0 0 0 0 0 0 0 0 0
1|0 ? ? ? ? ? ? ? 0
2|0 ? ? ? ? ? ? ? 0
3|0 ? ? ? ? ? ? ? 0
4|0 ? ? ? ? ? ? ? 0
5|0 ? ? ? ? ? ? ? 0
6|0 0 0 0 0 0 0 0 0

Gdzie ? oznacza wartość 0 lub 1.

Cała tablica jest indeksowana:
	w poziomie od 0 do szer + 1,
	w pionie od 0 do wys + 1.

Właściwa część tablicy (wyświetlana część) jest indeksowana:
	w poziomie od 1 do szer,
	w pionie od 1 do wys.

W pamięci jest trzymana jako tablica jednowymiarowa, 
elementom o współrzędnych czytanym od góry do dołu i od lewej do prawej,
przypisujemy indeksy będące kolejnymi liczbami naturalnymi.

Element o współrzędnych [i, j] ma zatem:
	indeks = (szer + 2) * i + j.

Zatem np. jego górny lewy sąsiad o współrzędnych [i - 1, j - 1], ma:
	indeks = (szer + 2) * (i - 1) + (j - 1).

4. Obliczanie kolejnej epoki.

Aby nie alokować żadnej dodatkowej pamięci, zastosowałem trzymanie wartości aktualnej epoki, 
oraz obliczanie następnej epoki w tej samej tablicy, co się 'zmieści' ponieważ same wartości sumy sądiadów są małe.

Najniższe 4 bity trzymają wartość z poprzedniej epoki.
Wobec tego, obliczając stan danej komórki w następnej epoce, bierzemy sumę sąsiadów modulo 16,
żeby pominąć ewentualnie policzone już wartości poprzednich sąsiadów dla następnej epoki.
Jeśli komórka ma być żywa w następnej epoce, dodajemy do niej wartość 16.

Na samym końcu, kiedy mamy już policzony stan każdej komórki w następnej epoce,
dzielimy wartość każdej komórki przez 16.

Przykład:

Dla stanu początkowego:
 0   1   0   0
 0   1   1   0
 0   1   1   0
 0   0   1   0

Dodajemy 16 do każej komórki która powinna być żywa w następnej epoce:
 0  17  16   0
16   1   1   0
 0   1   1  16
 0  16  17   0

Dzielimy przez 16, aby obliczyć stany w następnej epoce:
 0   1   1   0
 1   0   0   0
 0   0   0   1
 0   1   1   0

Obliczając w dowolnym momencie sumę sąsiadów dla pewnej komórki, liczymy ją modulo 16,
zatem ewentualne zwiększenia poprzednich sąsiadów o 16 nie wpływają na wartość tej sumy.