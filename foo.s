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
    movw i0, #$E000
    push =bla-1
    rts

jumpback:
    lda #$1E
    sta $2001
    lda #$80
    sta $2000

    lda #$40
    sta $4017
    jsr enable_irq
    cli
:   jmp :-

bla:
    jmp jumpback

nmi:
    push A,X,Y
    lda #$3F
    sta $2006
    lda #0
    sta $2006

    lda n0
    sta $2007

    swbankprg_nosave some_routine
    jsr some_routine
    mov $8000, mapper_cmdreg
    pop A,X,Y
    rti

irq:
    push A,X,Y

    jsr enable_irq

    ldy i2
    mov $4011, {(i0),Y}
    iny
    sty i2

    pop  A,X,Y
    rti

enable_irq:
    lda #$0d
    sta mapper_cmdreg
    sta $8000
    lda #0
    sta $A000
    lda #$0E
    sta mapper_cmdreg
    sta $8000
    lda #$04
    sta $A000
    lda #$0F
    sta mapper_cmdreg
    sta $8000
    lda #$03
    sta $A000
    lda #$0D
    sta mapper_cmdreg
    sta $8000
    lda #$FF
    sta $A000
    rts

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

    .segment "PRGBK02"
    .byte "Some data goes here..."

    .segment "CHRROM"
    .byte "CHRROM"
;-------------------------------------------------------------------------------

