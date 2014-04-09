.include "configure.inc"
.include "core.inc"
.include "init.inc"
.include "mapper69.inc"
;-------------------------------------------------------------------------------

nesconfig horz, 69, off
nessize 4, 1

.export main

; HACK, should be defined!
.export irq : abs := 0

    .segment "PRGBK00"

;-------------------------------------------------------------------------------
.proc main
    mov  $2000, #$80
    mov  $2006, #$3F
    mov  $2006, #$00

    ldy #32
    lda #$15
:   sta $2007
    dey
    bne :-

    mov  $2001, #$1E


    ; Quit and stall!
    rts
.endproc
;-------------------------------------------------------------------------------

