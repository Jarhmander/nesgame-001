.include "video.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
;-------------------------------------------------------------------------------

    .constructor video_ctor

    .segment "OAM"
OAM: .res 256

    .code

;-------------------------------------------------------------------------------
.proc do_PPU_updates
    
; do_PPU_updates()
; - exit if not ready
; - sprite dma
; - while data in PPU_buff: interpret data, update VRAM address, set inc, write.
;  (It could be a bit more specialised, like update palette, nametable and 
; attributes separately)
; - reset scroll (!)
    rts
.endproc
;-------------------------------------------------------------------------------
.proc video_ctor
    movw r0, #OAM
    movw r2, #$FF
    movw r4, #256
    jsr memset
    mov $2003, #0
    rts
.endproc
;-------------------------------------------------------------------------------

