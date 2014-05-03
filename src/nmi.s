.include "nmi.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
.include "mapper69.inc"
.include "video.inc"
.include "audio.inc"
.include "controller.inc"
;-------------------------------------------------------------------------------

    .zeropage
frame_count:    .res 2
nmi2irq_time:   .res 2

    .code

;-------------------------------------------------------------------------------
.proc nmi
    push A, X, Y
    ; setup next IRQ
    lda nmi2irq_time+0
    ldx nmi2irq_time+1
    jsr set_next_irq

    ; check if NMI reentered? ...
    ; ...
    ; inline?
    jsr do_PPU_updates

    inc frame_count
    beq :+
    inc frame_count+1
:
    ; read controller
    jsr update_controller

    ; sound engine
    swbankprg_nosave sound_engine
    jsr sound_engine

    ; restore mapper regs
    ldx #8
:   stx $8000
    mov $A000, {mapper_prgbanks-8, x}
    inx
    cpx #(mapper_prgbanks_size + 8)
    bcc :-

    mov $8000, mapper_cmdreg

    ; prolog
    pop A, X, Y
    rti
.endproc
;-------------------------------------------------------------------------------
; void wait_vblank_setppumask(uint8_t ppumask) __noclobber__
;
.proc wait_vblank_setppumask
    sta video_ppumask
    ; inline tail call
.endproc
;-------------------------------------------------------------------------------
; void wait_vblank(void) __noclobber__
;
.proc wait_vblank
    ldx frame_count
:   cpx frame_count
    beq :-
    rts
.endproc
;-------------------------------------------------------------------------------

