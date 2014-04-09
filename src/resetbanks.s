.include "resetbanks.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
.include "mapper69.inc"
.include "init.inc"
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
.proc init_swbank
    swbankprg_nosave init   ; make init visible
                            ; bank EXRAM (optional, not done)
    rts 
.endproc
;-------------------------------------------------------------------------------
.proc main_swbank
    .import main
    swbankprg_nosave main   ; make main visible
    rts
.endproc
;-------------------------------------------------------------------------------

