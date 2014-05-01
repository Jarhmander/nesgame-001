.include "controller.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
;-------------------------------------------------------------------------------

    .zeropage

btn_down:       .res 1
btn_toggle:     .res 1
btn_press:      .res 1
btn_release:    .res 1

    .code

;-------------------------------------------------------------------------------
.proc read_ctrl_1
    lda #1
    sta $4016
    sta n0
    lda #0
    sta $4016

:   lda $4016,x
    and #3
    cmp #1
    rol n0
    bcc :-
    lda n0
exit:
    rts
.endproc
;-------------------------------------------------------------------------------
; uint8_t read_controller(uint8_t controller) __nmi__
;
.proc read_controller
    tax
    jsr read_ctrl_1
    sta n1
    jsr read_ctrl_1
    cmp n1
    beq read_ctrl_1::exit
    jmp read_ctrl_1         ; tail cail
.endproc
;-------------------------------------------------------------------------------
; void update_controller(void) __nmi__
;
.proc update_controller
    lda #0
    jsr read_controller
    ; A, B, Select, Start, Up, Down, Left, Right.
    sta n0
    eor btn_down
    sta btn_toggle
    and n0
    sta btn_press
    eor btn_toggle
    sta btn_release
    lda n0
    sta btn_down
    rts
.endproc
;-------------------------------------------------------------------------------

