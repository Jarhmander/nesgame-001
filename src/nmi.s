.include "nmi.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
.include "mapper69.inc"
.include "video.inc"
.include "audio.inc"
;-------------------------------------------------------------------------------

    .zeropage
frame_count:    .res 2

    .code

;-------------------------------------------------------------------------------
.proc nmi
    push A, X, Y
    ; setup next IRQ (TODO)

    ; check if NMI reentered? ...
    ; ...

    jsr do_PPU_updates

    inc frame_count
    beq :+
    inc frame_count+1
:
    ; read controller

    ; sound engine

    ; restore mapper reg
    mov $8000, mapper_cmdreg

    ; prolog
    pop A, X, Y
    rti
.endproc
;-------------------------------------------------------------------------------
.proc wait_vblank
    ldx frame_count
:   cpx frame_count
    beq :-
    rts
.endproc
;-------------------------------------------------------------------------------
.proc wait_vblank_setppumask
    jsr wait_vblank
    sta video_ppumask
    sta $2001
    rts
.endproc
;-------------------------------------------------------------------------------

