.include "video.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
;-------------------------------------------------------------------------------

    .code

;-------------------------------------------------------------------------------
.proc do_PPU_updates
    
; do_PPU_updates()
; - exit if not ready
; - sprite dma
; - while data in PPU_buff: interpret data, update VRAM address, set inc, write.
;  (It could be a bit more specialised, like update palette, nametable and 
; attributes separately)

    rts
.endproc
;-------------------------------------------------------------------------------
