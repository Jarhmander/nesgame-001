.ifndef CONFIGURE_INC
.define CONFIGURE_INC
;-------------------------------------------------------------------------------

.export PRGROM_SZ16K : ABS = $1
.export CHRROM_SZ8K  : ABS = $0
.exportzp FLAGS6 =$50
.exportzp FLAGS7 =$40
.export PRGRAM_SZ8K  : ABS = $0
.exportzp FLAGS9 =$0
.exportzp FLAGS10 =$0

;-------------------------------------------------------------------------------
.endif ;CONFIGURE_INC

