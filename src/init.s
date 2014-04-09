.include "init.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
;-------------------------------------------------------------------------------

    .data

    .segment "EXDATA"

    .segment "PRGBK00"

;-------------------------------------------------------------------------------
.proc init
    .import __BSS_SIZE__, __BSS_LOAD__
    .import __DATA_SIZE__, __DATA_LOAD__, __DATA_RUN__
    .import __EXDATA_SIZE__, __EXDATA_LOAD__, __EXDATA_RUN__
    .import __CONSTRUCTOR_TABLE__, __CONSTRUCTOR_COUNT__

    push r8, r9, r10, r11

    movw r0, #__BSS_LOAD__
    movw r2, #0
    movw r4, #__BSS_SIZE__
    jsr  memset

init_datafill:
    movw r0, #__DATA_RUN__
    movw r2, #__DATA_LOAD__ + $8000
    movw r4, #__DATA_SIZE__
    jsr  memcpy
    
    movw r0, #__EXDATA_RUN__
    movw r2, #__EXDATA_LOAD__ + $8000
    movw r4, #__EXDATA_SIZE__
    jsr  memcpy
init_callctors:
    movw r8,  #(__CONSTRUCTOR_TABLE__ + (__CONSTRUCTOR_COUNT__ - 1) * 2)
    movw r10, #(65536 - __CONSTRUCTOR_COUNT__)
    bne  @loop
    lda  r10
    beq  exit
@loop:
    ldy  #0
    mov  r0, {(r8), y}
    iny
    mov  r1, {(r8), y}
    ijsr r0

    lda  r8
    sec
    sbc  #2
    sta  r8
    lda  r9
    sbc  #0
    sta  r9

    inc  r10
    bne  @loop
    inc  r11
    bne  @loop
exit:
    pop  r8, r9, r10, r11
    rts
.endproc
;-------------------------------------------------------------------------------

