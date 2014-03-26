.include "configure.inc"
.include "core.inc"

; Must be placed in a config file, with the NES header config
.export CHRROM_SZ = $2000 * CHRROM_SZ8K;
.export PRGROM_SZ = $4000 * PRGROM_SZ16K;

    .code

reset:
    bit $2002
    bpl reset
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

    inc n0
    rti
irq:
    lda i0
    sta r8
    rti


    .segment "BANK00"
some_routine:
    lda r0
    sta $4000
    rts

