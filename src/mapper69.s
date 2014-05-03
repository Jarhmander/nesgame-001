.include "mapper69.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
;-------------------------------------------------------------------------------

    .zeropage
    mapper_cmdreg:      .res 1
    mapper_prgbanks:    .res mapper_prgbanks_size

    .code

;-------------------------------------------------------------------------------
; void swbankprg_save(uint8_t bank, uint8_t area) __noclobber__
;
.proc swbankprg_save
    sta mapper_prgbanks-8, x
    ; inline tail call
.endproc
;-------------------------------------------------------------------------------
; void mapper_write(uint8_t value, uint8_t mapper_reg) __noclobber__
;
.proc mapper_write
    stx mapper_cmdreg
nosave:
    stx $8000
    sta $A000
    rts
.endproc
;-------------------------------------------------------------------------------
; void set_next_irq(uint8_t lo, uint8_t hi) __noclobber__
;
.proc set_next_irq
    ldy #$0D
    sty $8000
    ldy #0
    sty $A000
    ldy #$0E
    sty $8000
    sta $A000
    iny
    sty $8000
    stx $A000
    lda #$81
    ldx #$D
    ; tail call
    jmp mapper_write::nosave
.endproc
;-------------------------------------------------------------------------------

