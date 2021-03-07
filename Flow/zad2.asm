        global start
        global step


        section .data

szer dd 0                       ; szerokość właściwej tablicy zanieczyszczeń
szer2 dd 0                      ; szerokość tablicy zanieczyszczeń wraz z zerową kolumną oraz końcowym paddingiem (+8)
wys dd 0                        ; wysokość właściwej tablicy zanieczyszczeń
wys2 dd 0                       ; szerokość tablicy zanieczyszczeń wraz z górnym i dolnym paddingiem (+2)

M dq 0                          ; podwójna tablica zanieczyszczeń (główna + pomocnicza)
waga dd 0                       ; waga z treści zadania
diff dd 0                       ; wielkość jednej tablicy zanieczyszczeń wraz z paddingami
TRZY dd 3.0                     ; stała oznaczająca liczbę sąsiadów na górnym i dolnym wierszu
PIEC dd 5.0                     ; stała oznaczająca liczbę sąsiadów w pozostałych wierszach
JEDEN dd 1.0                    ; stała oznaczająca liczbę sąsiadów dla h = 1

        section .text

start:

        mov     dword [szer], edi
        add     edi, 8
        mov     dword [szer2], edi

        mov     dword [wys], esi
        add     esi, 2
        mov     dword [wys2], esi

        imul    edi, esi
        mov     dword [diff], edi

        mov     qword [M], rdx

        movss   dword [waga], xmm0
        ret


step:
        push    rbp
        mov     rbp, rsp

        mov     dword [rbp-4], 1             
.Loop0:                                         
        mov     eax, dword [wys]
        cmp     dword [rbp-4], eax
        ja      .Loop0End

                                                ; przepisanie nowych wartości do kolumny 0 w tablicy z zanieczyszczeniami

                                                ; rdi - tablica nowych wartości

        xor r9, r9                              ; r9 - kolejny indeks w tablicy nowych wartości
        mov r9d, dword [rbp-4]
        sub r9d, 1

        mov rdx, qword [M]                      ; rdx - tablica z zanieczyszczeniami

        xor r10, r10                            ; r10 - odpowiadający indeks w kolumnie 0 w tablicy z zanieczyszczeniami
        mov r10d, dword [rbp-4]
        imul r10d, dword [szer2]

        movss xmm0, [rdi+4*r9]
        movss [rdx+4*r10], xmm0

        add     dword [rbp-4], 1      
        jmp     .Loop0
.Loop0End:


        mov     dword [rbp-8], 0                ; [rbp-8] - pionowa współrzędna j aktualnej komórki
.Loop2:                                         ; pętla od 0 do wys-1
        mov     eax, dword [wys]
        cmp     dword [rbp-8], eax
        jnb      .Loop2End

        mov     dword [rbp-12], 0               ; [rbp-12] - pozioma współrzędna i aktualnej komórki
.Loop1:                                         ; pętla od 0 do szer-1
        mov     eax, dword [szer]
        cmp     dword [rbp-12], eax
        jnb      .Loop1End

                                                ; aktualna komórka ma współrzędne: j, i = [rbp-8] + 1, [rbp-12] + 1

        mov     rdx, qword [M]

        xor     r9, r9                          ; na r9 będziemy obliczać kolejne indeksy z tablicy sąsiadów aktualnej komórki
        mov     r9d, dword [rbp-8]
        imul    r9d, dword [szer2]
        add     r9d, dword [rbp-12]             ; index = j * szer2 + i

        mov     r10, r9                         ; na r10 będzie indeks aktualnej komórki w tablicy pomocniczej
        add     r10d, dword [szer2]
        add     r10d, 1
        add     r10d, dword [diff]              ; index = (j + 1) * szer2 + (i + 1) + diff

                                                ; obliczanie wyniku naraz dla czterech kolejnych komórek, począwszy od aktualnej

        movups  xmm0, [rdx+4*r9]                ; górny lewy sąsiad

        add     r9d, 1
        movups  xmm1, [rdx+4*r9]                ; górny sąsiad
        addps   xmm0,xmm1

        add     r9d, dword [szer2]
        sub     r9d, 1 
        movups  xmm1, [rdx+4*r9]                ; lewy sąsiad
        addps   xmm0,xmm1

        add     r9d, dword [szer2]
        movups  xmm1, [rdx+4*r9]                ; dolny lewy sąsiad
        addps   xmm0,xmm1

        add     r9d, 1
        movups  xmm1, [rdx+4*r9]                ; dolny sąsiad
        addps   xmm0,xmm1

        movups  [rdx+4*r10], xmm0               ; suma sąsiadów zapisana w tablicy pomocniczej pod indeksem odpowiadającym aktualnej komórce

        add     dword [rbp-12], 4               ; przejście do następnej czwórki kolumn z aktualnego wiersza
        jmp     .Loop1
.Loop1End:

        add     dword [rbp-8], 1                ; następny wiersz
        jmp     .Loop2
.Loop2End:



        mov     dword [rbp-8], 1                ; [rbp-8] - pionowa współrzędna j aktualnej komórki
.Loop3:                                         ; pętla od 1 do wys
        mov     eax, dword [wys]
        cmp     dword [rbp-8], eax
        ja      .Loop3End

        mov     dword [rbp-12], 1               ; [rbp-12] - pozioma współrzędna i aktualnej komórki
.Loop4:                                         ; pętla od 1 do szer
        mov     eax, dword [szer]
        cmp     dword [rbp-12], eax
        ja      .Loop4End

        mov     rdx, qword [M]

        xor     r9, r9                          ; na r9 będzie indeks aktualnej komórki
        mov     r9d, dword [rbp-8]
        imul    r9d, dword [szer2]
        add     r9d, dword [rbp-12]             ; index = j * szer2 + i

        movups  xmm0, [rdx+4*r9]                ; wektor czterech kolejnych starych wartości

                                                ; sprawdzenie ile jest sąsiadów dla aktualnych komórek

        movss   xmm1, dword [JEDEN]
        cmp     dword [wys], 1
        je .afterL0

        cmp     dword [rbp-8], 1                ; czy pierwszy wiersz
        je .L0 

        mov     eax, dword [wys]
        cmp     dword [rbp-8], eax              ; czy ostatni wiersz
        je .L0 

        movss   xmm1, dword [PIEC]              ; jeśli ani pierwszy ani ostatni to mamy 5 sąsiadów
        jmp .afterL0

.L0:
        movss   xmm1, dword [TRZY]              ; w przeciwnym razie mamy 3 sąsiadów

.afterL0:
                                                ; w zależności od liczby sąsiadów dla kolejnych elementów z aktualnego wiersza mamy
        shufps  xmm1, xmm1, 00h                 ; wektor [5, 5, 5, 5] lub [3, 3, 3, 3] 

        mulps   xmm1, xmm0                      ; wektor pięciokrotności/trzykrotności czterech kolejnych starych wartości

        mov     r10, r9                         ; na r10 będzie indeks odpowiadający aktualnej komórce w tablicy pomocniczej (jest większa o wartość diff)
        add     r10d, dword [diff]

        movups  xmm0, [rdx+4*r10]               ; wektor sum sąsiadów, dla czterech kolejnych elementów

        subps   xmm0, xmm1                      ; suma różnic sąsiadów, dla czterech kolejnych elementów

        movss   xmm1, dword [waga]
        shufps  xmm1, xmm1, 00h                 ; wektor [waga, waga, waga, waga]

        mulps   xmm0, xmm1                      ; suma różnic sąsiadów przemnożonych przez wagę

        movups  xmm1, [rdx+4*r9]
        addps   xmm0, xmm1                      ; aktualne wartości zwiększone o sumę różnic pomnożone przez wagę

        movups [rdx+4*r9], xmm0

        add     dword [rbp-12], 4               ; następna czwórka kolumn z danego wiersza
        jmp     .Loop4
.Loop4End:

        add     dword [rbp-8], 1                ; następny wiersz
        jmp     .Loop3
.Loop3End:

        pop     rbp
        ret