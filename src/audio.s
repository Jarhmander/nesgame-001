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

; ADSR:
env:        .res 1
flags:      .res 1
attack:     .res 1
decay:      .res 1
sustain:    .res 1
release:    .res 1

vol:        .res 1

mode:       .res 1

vol_init = 63

att_init = 46
dec_init = 100
sus_init = 11
rel_init = 10

note_spc = 7
noff_spc = 4
; noff < note


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
;
.proc sound_engine
    ;
    lda mode
    beq play_mode
    jmp button_mode
play_mode:
    lda time1
    beq :++
    dec time1
    cmp #note_spc-noff_spc+1
    bcs :+
    mov flags, #2
:   jmp do_vol
:   lda #note_spc
    sta time1
    ldy #0
    sty flags
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
    mov n0, env
    mov n1, flags
    mov n2, attack
    mov n3, decay
    mov n4, sustain
    mov n5, release
    jsr ADSR
    sta env
    ldx n1
    stx flags
    ldx vol
    jsr APU_volume
    ora #$B0
    sta $4000

    lda #$0C
    and btn_press
    cmp #$04
    bcc @next
    beq :++
    lda vol
    clc
    adc #1
    cmp #64
    bcc :+
    lda #63
:   sta vol
    rts
:   dec vol
    bpl exit
    lda #0
    sta vol
    rts
@next:
    lda #$10
    bit btn_press
    beq exit
    inc mode
exit:
    rts
button_mode:
    lda #$C0
    bit btn_press
    beq :+
    lda #0
    sta flags
    jmp @nextb
:   bit btn_down
    bne @nextb
    lda #2
    sta flags
@nextb:
    lda #$10
    bit btn_press
    beq :+
    dec mode
:   lda #$0C
    and btn_press
    cmp #$4
    bcc @next
    beq :+
    inc vol
    lda vol
    cmp #64
    bcc @next
    lda #63
    sta vol
    jmp @next
:   dec vol
    bpl @next
    lda #0
    sta vol
@next:
    mov n0, env
    mov n1, flags
    mov n2, attack
    mov n3, decay
    mov n4, sustain
    mov n5, release
    jsr ADSR
    sta env
    ldx n1
    stx flags
    ldx vol
    jsr APU_volume
    ora #$B0
    sta $4000

    rts
.endproc
;-------------------------------------------------------------------------------
; uint8_t APU_volume(uint8_t env, uint8_t vol) __nmi__
;
.proc APU_volume
    lsr A
    lsr A
    ora #$C0
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
; floor(logspace(log10(.99),log10(15.99),64))
; each step is ~.38356dB
    .byte  0,  1,  1,  1,  1,  1,  1,  1
    .byte  1,  1,  1,  1,  1,  1,  1,  1
    .byte  2,  2,  2,  2,  2,  2,  2,  2
    .byte  2,  2,  3,  3,  3,  3,  3,  3
    .byte  4,  4,  4,  4,  4,  5,  5,  5
    .byte  5,  6,  6,  6,  6,  7,  7,  7
    .byte  8,  8,  9,  9,  9, 10, 10, 11
    .byte 11, 12, 12, 13, 14, 14, 15, 15
.endproc
;-------------------------------------------------------------------------------
; ADSR(uint8_t cur_env, flags, a, d, s, r) __nmi__
;                                                 -> uint8_t env, cur_env, flags
;
.proc ADSR
    lda n1  ; flags (relocate)
    and #3
    cmp #1
    beq decay
    bcs release
attack:
    lda n0  ; current envelope (relocate)
    clc
    adc n2  ; Attack rate (relocate)
    bcs :+
    rts     ; A = env
:   inc n1  ; flags (relocate)

    lda #$FF
    jmp nofixenv
;   sbc n3  ; decay rate (relocate)
;   jmp sustain_chk
decay:
    lda n0  ; current envelope (relocate)
    sec
    sbc n3  ; decay rate (relocate)
    bcc fixenv
sustain_chk:
    cmp n4  ; sustain level (relocate)
    bcs nofixenv
fixenv:
    lda n4  ; sustain level (relocate)
nofixenv:
    rts     ; A = env
release:
    lda n0  ; current envelope (relocate)
    sec
    sbc n5  ; release rate (relocate)
    bcs :+
    lda #0
:   rts
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

    mov attack,     #att_init
    mov decay,      #dec_init
    mov sustain,    #sus_init
    mov release,    #rel_init
    mov flags,      #0
    mov env,        #0
    mov mode,       #0
    rts
.endproc
;-------------------------------------------------------------------------------

