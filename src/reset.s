.include "reset.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
.include "init.inc"
.include "resetbanks.inc"
;-------------------------------------------------------------------------------

.import main

;-------------------------------------------------------------------------------
.proc reset
    ; __pre_init_0
    sei             ; Disable NMI and IRQs (for warm boot, mind that the
    ldx #$0         ; famicom's PPU doesn't have its reset pin connected to CPU
    stx $2000       ; reset so the PPU might be in the middle of a frame)
    stx $2001       ; Disable rendering (for warm boot)

    dex             ; S = $FF
    txs             ;

    bit $2002       ; Clear the flag if set (for warm boot)
:   bit $2002       ; First wait for V-blank
    bpl :-

    ; __pre_init_1
    jsr init_swbank ; Bank init, then call it
    jsr init        ;

:   bit $2002       ; Second wait for V-blank
    bpl :-          ;

    mov $2000, #$80 ; Enable NMI (this V-blank however is completely missed)
    
    ; main
    jsr main_swbank ; bank main and call it
    jsr main        ;

:   jmp :-          ; If/when main is done, stall.

.endproc
;-------------------------------------------------------------------------------

