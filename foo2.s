;-------------------------------------------------------------------------------
.include "core.inc"
;-------------------------------------------------------------------------------

.constructor foo0, 8
.constructor foo1
.constructor foo2

    .segment "PRGBK00"

.proc foo0
    mov  $4015, #$0F

    mov  $4000, #$FF
    movw $4002, #428
    rts
.endproc

.proc foo1
    mov  $4004, #$FF
    movw $4006, #429
    rts
.endproc

.proc foo2
    mov  $4008, #$FF
    movw $400A, #214
    rts
.endproc

