.include "common.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
;-------------------------------------------------------------------------------

    .code

.repeat 8,I

.proc .ident(.sprintf("ijsr_r%d",I))
    jmp (.ident(.sprintf("r%d",I)))
.endproc

.endrepeat

;-------------------------------------------------------------------------------
; void *memcpy(void *dest, const void *src, size_t len)
; returns: dest
;
.proc memcpy
    ldx r4      ; X = r4
    cpx #1      ; r5 = r5 + !!X
    lda r5
    adc #0
    bne :+
    bcc exit    ; if C is clear and result is 0, then r5:r4 is 0
:   sta r5

    lda r2      ; r3:r2 = r3:r2 - r0
    sec         ; Adjust src ptr (see below)
    sbc r0
    sta r2
    lda r3
    sbc #0
    sta r3
    ldy r0      ; y = r0, r7:r6 = r1 << 8
    mov r6, #0  ; ...so the indexed indirect load will never cross a page.
    mov r7, r1  ; We don't care that the indirect indexed store crosses pages,
                ; because they always takes 6 cycles regardless of page
                ; crossing; src ptr was adjusted before.
@loop:
    mov  {(r6),y}, {(r2),y}
    iny
    bne  :+
    inc  r7
    inc  r3
:   dex
    bne @loop
    dec r5
    bne @loop
exit:
    rts
.endproc
;-------------------------------------------------------------------------------
; void *memset(void *mem, int c, size_t len)
; returns: mem
;
.proc memset
    ldx r4      ; X = r4
    cpx #1      ; r5 = r5 + !!X
    lda r5
    adc #0
    bne :+
    bcc exit    ; if C is clear and result is 0, then r5:r4 is 0
:   sta r5

    movw r6, r0
    lda  r2
    ldy  #0
@loop:
    sta  (r6),y
    iny
    bne  :+
    inc  r7
:   dex
    bne  @loop
    dec  r5
    bne  @loop
exit:
    rts
.endproc
;-------------------------------------------------------------------------------
; void memcpy_vram(unsigned vramaddr, const void *src, size_t len)
; returns: nothing
.proc memcpy_vram
    ldx r4      ; X = r4
    cpx #1      ; r5 = r5 + !!X
    lda r5
    adc #0
    bne :+
    bcc exit    ; if C is clear and result is 0, then r5:r4 is 0
:   sta r5

    ldy r2
    mov r2, #0
    bit $2002
    mov $2006, r0
    mov $2006, r1
@loop:
    mov $2007, {(r2), y}
    iny
    bne :+
    inc r3
:   dex
    bne @loop
    dec r5
    bne @loop
exit:
    rts
.endproc
;-------------------------------------------------------------------------------
; void memset_vram(unsigned vramaddr, const void *src, size_t len)
; returns: nothing
;
.proc memset_vram
    ldx r4      ; X = r4
    cpx #1      ; r5 = r5 + !!X
    lda r5
    adc #0
    bne :+
    bcc exit    ; if C is clear and result is 0, then r5:r4 is 0
:   tay

    bit $2002
    mov $2006, r0
    mov $2006, r1
@loop:
    mov $2007, r2
    dex
    bne @loop
    dey
    bne @loop

exit:
    rts
.endproc
;-------------------------------------------------------------------------------

