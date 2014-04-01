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

.proc memcpy
    movw r6, r0
    ldx  r4
    bne  :+
    lda  r5
    beq  exit
:   ldy  #0
@loop:
    mov  {(r6),y}, {(r2),y}
    iny
    bne  :+
    inc  r7
    inc  r3
:   cpx  #0
    bne  :+
    dec  r5
    dex
    jmp  @loop
:   dex
    bne  @loop
    cpx  r5
    bne  @loop
exit:
    rts
.endproc

.proc memset
    movw r6, r0
    ldx  r2
    bne  :+
    lda  r3
    beq  exit
:   ldy  #0
    lda  r4
@loop:
    sta  (r6),y
    iny
    beq  :+
    inc  r7
:   cpx  #0
    bne  :+
    dec  r3
    dex
    jmp  @loop
:   dex
    bne  @loop
    cpx  r3
    bne  @loop
exit:
    rts
.endproc

