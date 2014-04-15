.ifndef COMMON_INC
COMMON_INC = 1
;-------------------------------------------------------------------------------

.repeat 8,I
    .global .ident(.sprintf("ijsr_r%d",I*2))
.endrepeat

; Routines
; void *memcpy(void *dest, const void *src, size_t len)
.global memcpy

; void *memset(void *dest, int c, size_t len)
.global memset

; void memcpy_vram(unsigned vramdest, const void *src, size_t len)
.global memcpy_vram

; void memset_vram(unsigned vramdest, int c, size_t len)
.global memset_vram


;-------------------------------------------------------------------------------
.endif ;COMMON_INC
