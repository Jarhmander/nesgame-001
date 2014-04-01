.ifndef CORE_INC
CORE_INC = 1
;-------------------------------------------------------------------------------

.globalzp r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15
.globalzp i0, i1, i2, i3, i4, i5, i6, i7
.globalzp n0, n1, n2, n3, n4, n5, n6, n7

.global nmi, reset, irq

.macro pusha
    pha
.endmacro

.macro popa
    pla
.endmacro

.macro push a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
    .ifnblank a0
        .if !(.match({a0},a))
            lda a0
        .endif
        pusha
        push a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
    .endif
.endmacro

.macro pop a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
    .ifnblank a0
        pop a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
        popa
        .if !(.match({a0},a))
            sta a0
        .endif
    .endif
.endmacro

.macro mov dest, src
    lda src
    sta dest
.endmacro

.macro movw dest, src
    .if .match(.left(1, {src}),#)
        mov dest+0, #<(.right(.tcount({src})-1,{src}))
        mov dest+1, #>(.right(.tcount({src})-1,{src}))
    .else
        mov dest+0, src+0
        mov dest+1, src+1
    .endif


.endmacro

;-------------------------------------------------------------------------------
.endif ;CORE_INC

