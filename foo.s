.include "configure.inc"
.include "core.inc"


nesconfig horz, 69, off
nessize 1

    .code
reset:
    bit $2002
    bpl reset

    ; FME-7: select bank 0 at $8000-9FFF
    ldy #9
    lda #0
    sty $8000
    sta $A000

:   bit $2002
    bpl :-

    lda #0
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

    lda #$3F
    sta $2006
    lda #0
    sta $2006

    jsr some_routine
    rti
irq:
    lda i0
    sta r8
    rti

    .segment "PRGBK00"
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

