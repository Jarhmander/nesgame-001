.ifndef COMMON_INC
COMMON_INC = 1
;-------------------------------------------------------------------------------

.repeat 8,I
    .global .ident(.sprintf("ijsr_r%d",I*2))
.endrepeat

.global memcpy
.global memset

;-------------------------------------------------------------------------------
.endif ;COMMON_INC
