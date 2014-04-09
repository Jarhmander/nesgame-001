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
    sei             ; Disable NMI and IRQs
    ldx #$0         ;
    stx $2000       ;

    dex             ; S = $FF
    txs             ;

:   bit $2002       ; First wait for V-blank
    bpl :-

    ; __pre_init_1
    jsr init_swbank ; Bank init, then call it
    jsr init        ;

:   bit $2002       ; Second wait for V-blank
    bpl :-          ;

    lda #$80        ; Enable NMI
    sta $2000       ; This V-blank will be missed however
    
    ; main
    jsr main_swbank ; bank main and call it
    jsr main        ;

:   jmp :-          ; If/when main is done, stall.

.endproc
;-------------------------------------------------------------------------------

