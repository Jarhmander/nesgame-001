.include "audio.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
;-------------------------------------------------------------------------------
.include "controller.inc" ; HACK
;-------------------------------------------------------------------------------

    .constructor sound_ctor

    .segment "DMCBYTE"
dmcsilent:  .byte $55

    .zeropage
time1:      .res 1
soundptr:   .res 2
env:        .res 1
vol:        .res 1

vol_init = 31
env_rate = 15
note_spc = 17

    .segment "PRGBK01"

some_notes: .byte 0,  7, 10, 15, 10, 7, 0, 15
            .byte 0,  7, 10, 14, 10, 7, 0, 14
            .byte 0,  7, 10, 12, 10, 7, 0, 12
            .byte 0,  7, 10, 19, 10, 7, 0, 19
some_notes_size = * - some_notes

notes: .word 427, 403, 380, 359, 338, 319, 301, 284, 268, 253, 239, 225
       .word 213, 201, 189, 179, 169, 159, 150, 142, 134, 126, 119, 112

;-------------------------------------------------------------------------------
; void sound_engine(void) __nmi__
.proc sound_engine
    ;
    lda time1
    beq :+
    dec time1
    jmp do_vol
:   lda #note_spc
    sta time1
    mov env, #$FF
    ldy #0
    lda (soundptr), y
    asl
    tax
    movw $4002, {notes, x}
    inc soundptr
    bne :+
    inc soundptr+1
:   lda soundptr
    cmp #<(some_notes + some_notes_size)
    bne do_vol
    movw soundptr, #some_notes

do_vol:
    lda env
    ldx vol
    jsr APU_volume
    ora #$B0
    sta $4000
    lda env
    sec
    sbc #env_rate
    bcs :+
    lda #0
:   sta env

    lda #$0C
    and btn_press
    cmp #$04
    bcc exit
    beq :++
    lda vol
    clc
    adc #1
    cmp #32
    bcc :+
    lda #31
:   sta vol
    rts
:   dec vol
    bpl exit
    lda #0
    sta vol

exit:
    rts
.endproc
;-------------------------------------------------------------------------------
; uint8_t APU_volume(uint8_t env, uint8_t vol) __nmi__
;
.proc APU_volume
    lsr A
    lsr A
    lsr A
    ora #$E0
    sec
    stx n0
    adc n0 ; contains volume (5 lsb)
    bcc :+
    tax
    lda APU_voltable, X
    rts
:   lda #0
    rts
APU_voltable:
    .byte 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4
    .byte 4, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10, 11, 12, 13, 14, 15
.endproc
;-------------------------------------------------------------------------------
    .segment "PRGBK00"
.proc sound_ctor
    ; Init regs
    ldx #0              ; Stop all sound, and re-enable
    stx $4015
    mov $4015, #$0F
    mov $4017, #$C0     ; 5-step mode, no frame IRQs
    mov $4001, #$8      ; Sweep negated
    sta $4005
    mov $400C, #$30     ; For noise, vol = 0, constant volume and length
    sta $400F           ; counter halt, then start silent note
                        ; (so we never have to write to $400F afterward).
    sta $4011           ; Set DMC counter somewhat mid-valued
    mov $4012, #<(dmcsilent >> 6)
    stx $4013           ; Init sample address to silent byte

    ; Init engine
    ; (TODO)
    mov time1, #0
    movw soundptr, #some_notes
    mov vol, #vol_init

    rts
.endproc
;-------------------------------------------------------------------------------

