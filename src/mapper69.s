.include "mapper69.inc"
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
    stx $8000
    sta $A000
    rts
.endproc
;-------------------------------------------------------------------------------

