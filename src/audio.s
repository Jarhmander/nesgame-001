.include "audio.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
;-------------------------------------------------------------------------------

    .constructor sound_ctor

    .segment "DMCBYTE"
dmcsilent:  .byte $55

    .zeropage
time1:      .res 1
soundptr:   .res 2
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
    rts
:   lda #6
    sta time1
    ldy #0
    lda (soundptr), y
    asl
    tax
    mov  $4000, #$81
    movw $4002, {notes, x}
    inc soundptr
    bne :+
    inc soundptr+1
:   lda soundptr
    cmp #<(some_notes + some_notes_size)
    bne exit
    movw soundptr, #some_notes

exit:
    rts
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

    rts
.endproc
;-------------------------------------------------------------------------------

