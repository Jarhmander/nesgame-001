.include "configure.inc"
.include "core.inc"
.include "init.inc"
.include "mapper69.inc"
;-------------------------------------------------------------------------------

nesconfig horz, 69, off
nessize 4, 1

.export main
.export irq : abs := 0

    .segment "PRGBK00"

;-------------------------------------------------------------------------------
.proc main
    movw n0, #0
    mov  $2001, #$1E
:   jmp :-
    rts
.endproc
;-------------------------------------------------------------------------------
.code
.proc nmi
    push A,X,Y
    lda #$3F
    sta $2006
    lda #0
    sta $2006

    lda n0
    sta $2007


    lda #60
    cmp n1
    dec n1
    bcs :+
    sta n1
    inc n0
:     

    mov $8000, mapper_cmdreg
    pop A,X,Y
    rti
.endproc
;-------------------------------------------------------------------------------

