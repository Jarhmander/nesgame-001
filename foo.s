.include "configure.inc"
.include "core.inc"
.include "init.inc"
.include "mapper69.inc"
;-------------------------------------------------------------------------------

nesconfig horz, 69, off
nessize 4, 1

    .code

reset:
    ; __pre_init_0
    sei
    ldx #$0
    stx $2000

    dex
    txs

:   bit $2002
    bpl :-

    ; __pre_init_1
    swbankprg_nosave init
    jsr init

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

    swbankprg_nosave some_routine
    jsr some_routine

    rti
irq:
    lda i0
    sta r8
    rti

    .byte "CODE"

    .segment "PRGBK00"
some_other_routine:
    lda n1
    clc
    adc #1
    cmp #3
    bne :+
    lda #0
    inc n0
:   sta n1
    rts
    .byte "PRGBK00"

    .segment "PRGBK01"
some_routine:
    swbankprg_nosave some_other_routine
    jsr some_other_routine
    rts

    .byte "PRGBK01"

    .segment "CHRROM"
    .byte "CHRROM"
;-------------------------------------------------------------------------------

