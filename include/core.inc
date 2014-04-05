.ifndef CORE_INC
CORE_INC = 1
;-------------------------------------------------------------------------------
.include "common.inc"
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

.macro pushp
    php
.endmacro

.macro popp
    plp
.endmacro

.macro push a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
    .ifnblank a0
        .if .xmatch({a0},p) .or .xmatch({a0},P)
            pushp
        .else
            .if .match({a0},x)
                txa
            .elseif .match({a0},y)
                tya
            .elseif .match(.left(1,{a0}),=)
                lda #>(.right(.tcount({a0})-1,{a0}))
                pusha
                lda #<(.right(.tcount({a0})-1,{a0}))
            .elseif !(.match({a0},a))
                lda a0
            .endif
            pusha
        .endif
        push a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
    .endif
.endmacro

.macro pop a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
    .ifnblank a0
        pop a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
        .if .xmatch({a0},p) .or .xmatch({a0},P)
            popp
        .else
            popa
            .if .match({a0},x)
                tax
            .elseif .match({a0},y)
                tay
            .elseif !(.match({a0},a))
                sta a0
            .endif
        .endif
    .endif
.endmacro

.macro mov dest, src
    lda src
    sta dest
.endmacro

.macro movw dest, src
    .local sepd, seps
    sepd .set 0
    seps .set 0

    .if .match({.right(2,{dest})},{,x}) .or .match({.right(2,{dest})},{,y})
        sepd .set 2
    .endif
    .if .match({.right(2,{src})},{,x}) .or .match({.right(2,{src})},{,y})
        seps .set 2
    .endif
    
    .if .match(.left(1, {src}),#)
        mov {.left(.tcount({dest})-sepd,dest)+0 .right(sepd,dest)}, #<(.right(.tcount({src})-1,{src}))
        mov {.left(.tcount({dest})-sepd,dest)+1 .right(sepd,dest)}, #>(.right(.tcount({src})-1,{src}))
    .else
        mov {.left(.tcount({dest})-sepd,dest)+0 .right(sepd,dest)}, {.left(.tcount({src})-seps,src)+0 .right(seps,src)}
        mov {.left(.tcount({dest})-sepd,dest)+1 .right(sepd,dest)}, {.left(.tcount({src})-seps,src)+1 .right(seps,src)}
    .endif
.endmacro

.macro ijsr regw
    jsr .ident(.sprintf("ijsr_%s",.string(regw)))
.endmacro

;-------------------------------------------------------------------------------
.endif ;CORE_INC

