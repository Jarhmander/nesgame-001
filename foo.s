.include "configure.inc"
.include "core.inc"
;-------------------------------------------------------------------------------

nesconfig horz, 69, off
nessize 4, 1

    .code
reset:
    bit $2002
    bpl reset

:   bit $2002
    bpl :-

    lda #$1E
    sta $2001
    lda #$80
    sta $2000

:   jmp :-

nmi:
    lda #$3F
    sta $2006
    lda #0
    sta $2006

    lda n0
    sta $2007

    ; FME-7: select bank of some_routine where it expects to be run.
    ldy #(8 + >.bank(some_routine))
    lda #<.bank(some_routine)
    sty $8000
    sta $A000

    jsr some_routine
    rti
irq:
    lda i0
    sta r8
    rti

    .byte "CODE"

    .segment "PRGBK00"
    .byte "PRGBK00"

    .segment "PRGBK01"
some_routine:
    lda n1
    clc
    adc #1
    cmp #30
    bne :+
    lda #0
    inc n0
:   sta n1
    rts

    .byte "PRGBK01"

    .segment "CHRROM"
    .byte "CHRROM"
;-------------------------------------------------------------------------------

