.include "nmi.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
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

    pop A, X, Y
    rti
.endproc
;-------------------------------------------------------------------------------
.proc wait_vblank
    lda frame_count
:   cmp frame_count
    beq :-
    rts
.endproc
;-------------------------------------------------------------------------------

