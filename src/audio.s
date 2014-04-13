.include "audio.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
;-------------------------------------------------------------------------------

    .constructor sound_ctor

    .segment "DMCBYTE"
dmcsilent: .byte $55

    .segment "PRGBK01"

;-------------------------------------------------------------------------------
.proc sound_engine
    ; (TODO)
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

    rts
.endproc
;-------------------------------------------------------------------------------

