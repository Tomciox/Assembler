.text
.global transform

transform:
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        sub     sp, sp, #28

        str     r0, [fp, #-16]  @ r0 - picture
        str     r1, [fp, #-20]  @ r1 - size
                                @ r2 - color
        str     r3, [fp, #-28]  @ r3 - weight

        cmp     r2, #82         @ if (color == 'R')
        bne     .L2
        mov     r3, #0          
        str     r3, [fp, #-8]   @ i = 0
        b       .L5
.L2:
        cmp     r2, #71         @ else if (color == 'G')
        bne     .L4
        mov     r3, #1          
        str     r3, [fp, #-8]   @ i = 1
        b       .L5
.L4:                            @ else 
        mov     r3, #2
        str     r3, [fp, #-8]   @ i = 2
        b       .L5
.L8:
        ldr     r3, [fp, #-8]
        mov     r3, r3, asl #2
        ldr     r2, [fp, #-16]
        add     r3, r2, r3      @ picture[i] (destination)

        ldr     r2, [fp, #-8]
        mov     r2, r2, asl #2
        ldr     r1, [fp, #-16]
        add     r2, r1, r2
        ldr     r1, [r2, #0]    @ picture[i] (value)

        ldr     r2, [fp, #-28]
        add     r2, r1, r2      
        str     r2, [r3, #0]    @ picture[i] = picture[i] + weight

        ldr     r3, [fp, #-8]
        mov     r3, r3, asl #2
        ldr     r2, [fp, #-16]
        add     r3, r2, r3
        ldr     r3, [r3, #0]    @ picture[i] (value)
        cmp     r3, #0          @ if (picture[i] < 0)
        bge     .L6

        ldr     r3, [fp, #-8]
        mov     r3, r3, asl #2
        ldr     r2, [fp, #-16]
        add     r3, r2, r3      @ picture[i] (destination)
        mov     r2, #0
        str     r2, [r3, #0]    @ picture[i] = 0
.L6:
        ldr     r3, [fp, #-8]
        mov     r3, r3, asl #2
        ldr     r2, [fp, #-16]
        add     r3, r2, r3
        ldr     r3, [r3, #0]    @ picture[i] (value)
        cmp     r3, #255        @ if (picture[i] > 255)
        ble     .L7

        ldr     r3, [fp, #-8]
        mov     r3, r3, asl #2
        ldr     r2, [fp, #-16]
        add     r3, r2, r3      @ picture[i] (destination)
        mov     r2, #255        @ picture[i] = 255
        str     r2, [r3, #0]
.L7:
        ldr     r3, [fp, #-8]
        add     r3, r3, #3
        str     r3, [fp, #-8]   @ i += 3
.L5:
        ldr     r2, [fp, #-8]
        ldr     r3, [fp, #-20]
        cmp     r2, r3          @ while (i < size)
        blt     .L8
        add     sp, fp, #0
        ldmfd   sp!, {fp}
        bx      lr