        global start
        global run


        section .data
T dq 0
wys dd 0
szer dd 0

        section .text

start:
        mov     dword [szer], esi
        mov     dword [wys], edi
        mov     qword [T], rdx
        ret


run:
        push    rbp
        mov     rbp, rsp
                                                ; edi - liczba kroków symulacji


        mov     dword [rbp-4], 0                ; [rbp-4] - numer aktualnego kroku symulacji 
.Loop0:                                         ; pętla po kolejnych krokach symulacji
        cmp     dword [rbp-4], edi
        jnb     .Loop0End


        mov     dword [rbp-8], 1                ; [rbp-8] - pionowa współrzędna i aktualnej komórki
.Loop2:                                         ; pętla od 1 do wys
        mov     eax, dword [wys]
        cmp     dword [rbp-8], eax
        ja      .Loop2End

        mov     dword [rbp-12], 1               ; [rbp-12] - pozioma współrzędna j aktualnej komórki
.Loop1:                                         ; pętla od 1 do szer
        mov     eax, dword [szer]
        cmp     dword [rbp-12], eax
        ja      .Loop1End

                                                ; aktualna komórka ma współrzędne: i, j = [rbp-8], [rbp-12]

        mov     rdx, qword [T]
        
        xor     r9, r9                          ; na r9 będziemy obliczać kolejne indeksy z tablicy sąsiadów komórki: i, j
        mov     r9d, dword [szer]
        add     r9d, 2
        mov     eax, dword [rbp-8]
        sub     eax, 1
        imul    r9d, eax
        add     r9d, dword [rbp-12]
        sub     r9d, 1                       
        
                                                ; na rax obliczamy sumę wartości sąsiadów komórki o współrzędnych: i, j
        mov     eax, dword [rdx+r9*4]           ; górny lewy sąsiad: indeks = (szer + 2) * (i - 1) + j - 1

        add     r9d, 1                          
        add     eax, dword [rdx+r9*4]           ; górny sąsiad: indeks = (szer + 2) * (i - 1) + j

        add     r9d, 1                          
        add     eax, dword [rdx+r9*4]           ; górny prawy sąsiad: indeks = (szer + 2) * (i - 1) + j + 1

        add     r9d, dword [szer]               
        add     eax, dword [rdx+r9*4]           ; lewy sąsiad: indeks = (szer + 2) * i + j - 1

        add     r9d, 2                          
        add     eax, dword [rdx+r9*4]           ; prawy sąsiad: indeks = (szer + 2) * i + j + 1

        add     r9d, dword [szer]               
        add     eax, dword [rdx+r9*4]           ; dolny lewy sąsiad: indeks = (szer + 2) * (i + 1) + j - 1

        add     r9d, 1                          
        add     eax, dword [rdx+r9*4]           ; dolny sąsiad: indeks = (szer + 2) * (i + 1) + j

        add     r9d, 1                          
        add     eax, dword [rdx+r9*4]           ; dolny prawy sąsiad: indeks = (szer + 2) * (i + 1) + j + 1

        and     eax, 15                         ; suma wartości sąsiadów z poprzedniej epoki

        xor     r9, r9                          ; na r9 obliczymy indeks z tablicy aktualnej komórki o współrzędnych: i, j
        mov     r9d, dword [szer]
        add     r9d, 2
        imul    r9d, dword [rbp-8]
        add     r9d, dword [rbp-12]             ; indeks = (szer + 2) * i + j

        mov     ecx, dword [rdx+r9*4]           ; wartość aktualnej komórki o współrzędnych: i, j

        cmp     ecx, 1                          ; czy martwa?
        jne     .L6
        cmp     eax, 2                          ; czy ma 2 sąsiadów?
        je      .L7
        cmp     eax, 3                          ; czy nie ma 3 sąsiadów?
        jne     .L8
.L7:                                            
        add     dword [rdx+r9*4], 16            ; jeśli jest żywa oraz ma 2 lub 3 sąsiadów, powinna pozostać żywa w następnej epoce
        jmp     .L8
.L6:
        cmp     eax, 3                          ; czy nie ma 3 sąsiadów?
        jne     .L8
        add     dword [rdx+r9*4], 16            ; jeśli jest martwa ale ma 3 sąsiadów, powinna ożyć w następnej epoce
.L8:


        add     dword [rbp-12], 1               ; następna kolumna
        jmp     .Loop1
.Loop1End:


        add     dword [rbp-8], 1                ; następny wiersz
        jmp     .Loop2
.Loop2End:


        mov     dword [rbp-8], 1                ; [rbp-8] - pionowa współrzędna i aktualnej komórki
.Loop3:                                         ; pętla od 1 do wys
        mov     eax, dword [wys]
        cmp     dword [rbp-8], eax
        ja      .Loop3End


        mov     dword [rbp-12], 1               ; [rbp-12] - pozioma współrzędna j aktualnej komórki
.Loop4:                                         ; pętla od 1 do szer
        mov     eax, dword [szer]
        cmp     dword [rbp-12], eax
        ja      .Loop4End


        xor     r9, r9                          ; na r9 obliczymy indeks z tablicy aktualnej komórki: i, j
        mov     r9d, dword [szer]
        add     r9d, 2
        imul    r9d, dword [rbp-8]
        add     r9d, dword [rbp-12]             ; indeks = (szer + 2) * i + j
        shr     dword [rdx+r9*4], 4             ; obliczamy wartość komórki w następnej epoce, dzieląc przez 16


        add     dword [rbp-12], 1               ; następna kolumna
        jmp     .Loop4
.Loop4End:


        add     dword [rbp-8], 1                ; następny wiersz
        jmp     .Loop3
.Loop3End:


        add     dword [rbp-4], 1                ; następna epoka
        jmp     .Loop0
.Loop0End:


        pop     rbp
        ret