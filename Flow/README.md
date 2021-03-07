Opis rozwiązania:

1. Uruchomienie

Budowanie i uruchamianie na maszynie students:

```
make zad2 && ./zad2 < NAZWA_TESTU
```

Gdzie NAZWA_TESTU jest plikiem w formacie z treści zadania. Dostarczone testy: 

tests/test1.in
tests/test2.in

Czyszczenie plików wykonywalnych:
```
make clean
```

2. Pliki

README.md
Makefile
zad2main.c
zad2.asm
tests/

3. Indeksacja

Tablica jest podwójna, składa się z właściwej tablicy zanieczyszczeń,
oraz pomocniczej tablicy wykorzystywanej do jednoczesnego obliczania sum.

Zastosowałem paddingi dookoła tablicy, strażnicy są zerami,
żeby nie musieć sprawdzać dla właściwej tablicy czy wszyscy sąsiedzi istnieją.

Ma ona zatem przykładową postać:

Dla danych na wejściu wymiarów: szer = 7, wys = 5.
Każda z obu tablic ma szerokość równą (szer + 8), wysokość równą (wys + 2).

Schemat tablicy głównej i tablicy pomocniczej:

  0 1 2 3 4 5 6 7 8 9 ...
  - - - - - - - - - - - - - - -
0|0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
1|0 ? ? ? ? ? ? ? 0 0 0 0 0 0 0
2|0 ? ? ? ? ? ? ? 0 0 0 0 0 0 0
3|0 ? ? ? ? ? ? ? 0 0 0 0 0 0 0
4|0 ? ? ? ? ? ? ? 0 0 0 0 0 0 0
5|0 ? ? ? ? ? ? ? 0 0 0 0 0 0 0
6|0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

0|0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
1|0 ? ? ? ? ? ? ? 0 0 0 0 0 0 0
2|0 ? ? ? ? ? ? ? 0 0 0 0 0 0 0
3|0 ? ? ? ? ? ? ? 0 0 0 0 0 0 0
4|0 ? ? ? ? ? ? ? 0 0 0 0 0 0 0
5|0 ? ? ? ? ? ? ? 0 0 0 0 0 0 0
6|0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

Gdzie ? oznacza wartość zanieczyszczenia.

Właściwa część tablicy (wyświetlana część) jest indeksowana:
	w poziomie od 1 do szer,
	w pionie od 1 do wys.

W pamięci jest trzymana jako tablica jednowymiarowa, 
elementom o współrzędnych czytanym od góry do dołu i od lewej do prawej,
przypisujemy indeksy będące kolejnymi liczbami naturalnymi.

Element o współrzędnych [i, j] w gównej tablicy ma zatem:
	indeks = (szer + 8) * i + j.

Jego górny lewy sąsiad o współrzędnych [i - 1, j - 1], ma:
	indeks = (szer + 8) * (i - 1) + (j - 1).

Tablica pomocnicza ma indeksy w pamięci przesunięte o wartość diff = wielkość pojedynczej tablicy:

diff = (szer + 8) * (wys + 2).

Element o współrzędnych [i, j] w pomocniczej tablicy ma zatem:
	indeks = (szer + 8) * i + j + diff.

Jego górny lewy sąsiad o współrzędnych [i - 1, j - 1], ma:
	indeks = (szer + 8) * (i - 1) + (j - 1) + diff.

4. Obliczanie przepływu zanieczyszczeń.

Elementy przychodzące z lewej strony są wpisywane na początku do pierwszej kolumny właściwej tablicy zanieczyszczeń,
poczynając od wiersza 1.

Zanieczyszczenia dzięki SSE obliczane są jednocześnie dla "paczek" czterech kolejnych wartości w poziomie.


(kolejne "paczki" czwórek zaznaczone kolejnymi numerami od 1 do 9), tutaj przydaje się końcowy padding, żeby nie zahaczać o kolejny wiersz, 
iterujemy się po kolenych czwórkach dopóki zostały nam jakieś nieodwiedzone elementy, być może policzymy dodatkowe "dziwne" rzeczy ale to nie ma 
wpływu na właściwą wartość tablicy zanieczyszczeń:

0|0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
1|0 1 1 1 1 2 2 2 0 0 0 0 0 0 0
2|0 3 3 3 3 4 4 4 0 0 0 0 0 0 0
3|0 5 5 5 5 6 6 6 0 0 0 0 0 0 0
4|0 7 7 7 7 8 8 8 0 0 0 0 0 0 0
5|0 9 9 9 9 ? ? ? 0 0 0 0 0 0 0
6|0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

Aby nie alokować za każdym razem dodatkowej pamięci, zastosowałem tablicę pomocniczą,
w której dla każdego elementu najpierw obliczana jest suma sąsiadów (tutaj czasami przydaje się padding 0 na górze i dole):

00
?.
??

lub

??
?.
??

lub

??
?.
00

Następnie wartość w następnym kroku obliczana jest jako:

stara_wartość + (stara_wartość * liczba_sąsiadów - suma_sąsiadów) * waga

co również odbywa się w "paczkach" po cztery kolejne elementy.
