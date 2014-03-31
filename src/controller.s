.include "controller.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
;-------------------------------------------------------------------------------
    .code
read_ctrl_1:
    lda #1
    sta $4016
    sta r0
    lda #0
    sta $4016

:   lda $4016,x
    and #3
    cmp #1
    asl r0
    bcc :-
    lda r0
rts_1:
    rts

.proc read_controller
    tax
    jsr read_ctrl_1
    sta r1
    jsr read_ctrl_1
    cmp r1
    beq rts_1
    jmp read_ctrl_1 ; tail cail
.endproc


;-------------------------------------------------------------------------------

