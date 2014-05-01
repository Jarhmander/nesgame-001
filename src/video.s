.include "video.inc"
;-------------------------------------------------------------------------------
.include "core.inc"
;-------------------------------------------------------------------------------

    .constructor video_ctor

    .segment "OAM"
OAM:                .res OAM_size

    .segment "PPUBUFF"
PPU_buff:           .res PPU_buff_size

    .bss
palette:            .res palette_size

    .zeropage
OAM_ready:          .res 1
video_bufferptrR:   .res 1
video_bufferptrW:   .res 1
video_ppuctrl:      .res 1
video_ppumask:      .res 1
scroll_x:           .res 1
scroll_y:           .res 1

    .code

crossover_write = 8

;-------------------------------------------------------------------------------
.proc do_PPU_updates
; If OAM_ready is <> 0, sprite DMA will occur.
; Data pushed to PPU_buff will be examined.
; If rendering is enabled (video_ppumask & $18 <> 0) then scroll is reset at
; the end.
;
; Operation and Byte Encoding in Buffer
; =====================================
;
; Summary
; ------------------------------------------------------------
;
; +-------------------------+-------------------------------------------------+
; | Operation               | Encoding                                        |
; +-------------------------+-------------------------------------------------+
; | Write line              | $00|<addr_hi>, <addr_lo>, <rlen>, <data> [...]  |
; | Write col               | $40|<addr_hi>, <addr_lo>, <rlen>, <data> [...]  |
; | Write continue          | $80|<rlen>, <data> [...]       <rlen> mask: $3F |
; | Update background color | $C0                                             |
; | Update all palette      | $C1                                             |
; | Set rendering           | $C2                                             |
; | Set scroll              | $C3, <ppuctrl>, <scroll_x>, <scroll_y>          |
; | Change mirroring        | $C4|<mirrorbits>         <mirrorbits> mask: $03 |
; | Change CHR banks        | $C8|<sel>, <banknum>            <sel> mask: $07 |
; | Update palette group    | $D0|<sel>                       <sel> mask: $07 |
; | Update attribute col    | $D8|<len>, <addr_hi>, <addr_lo>, <data> [...]   |
; |                         |                                 <len> mask: $07 |
; +-------------------------+-------------------------------------------------+
;
; Detailed description
; -----------------------------------------------------------------------------
; _Write line_:
;  %00hhhhhh llllllll rsssssss [data ...]
;  Data: $00 $00 $00
;  Mask: $3F $FF $FF
;
;   Sets increment to 1 and sets PPU address to %00hhhhhh:llllllll. Writes
;   sssssss bytes to $2007. If r is 0, the following sssssss bytes will be
;   copied (normal mode); otherwise, the next byte is copied sssssss times
;   (repeat mode).
;
; _Write col_:
;  %01hhhhhh llllllll rsssssss [data ...]
;  Data: $40 $00 $00
;  Mask: $3F $FF $FF
;
;   Set increment to 32 and sets PPU address to %00hhhhhh:llllllll. Writes
;   sssssss bytes to $2007 The meaning of r is the same as the previous command.
;
; _Write continue:_
;  %10rsssss [data ...]
;  Data: $80
;  Mask: $3F
;
;   Leave $2000 and $2006 untouched and write sssss bytes to $2007. Useful to
;   switch normal/repeat mode. The meaning of r is the same as the previous
;   commands.
;
; _Update background color:_
;  %11000000
;  Data: $C0
;  Mask: $00
;
;   Sets background color to palette[0]. The next PPU address is unpredictable
;   because address increment isn't updated.
;
; _Update all palette:_
;  %11000001
;  Data: $C1
;  Mask: $00
;
;   All the NES palette is updated to the contents of palette. The background
;   palette mirrors are all skipped unlike the above Write line/col commands.
;
; _Set scroll:_
;  %11000010
;  Data: $C2 $00 $00 $00
;  Mask: $00 $FF $FF $FF
;
;   Copy the next data to video_ppuctrl, scroll_x and scroll_y. If rendering is
;   enabled, scroll registers are reset at the end of PPU_updates.
;
; _Set rendering:_
;  %11000011
;  Data: $C3
;  Mask: $00
;
;   Copy video_ppumask to $2001, changing rendering settings.
;
; _Change mirroring:_
;  %110001mm
;  Data: $C4
;  Mask: $03
;
;   Changes nametable mirroring. Updates FME-7 register $C.
;   m = 0: Vertical
;   m = 1: Horizontal
;   m = 2: One-screen nametable A ($2000)
;   m = 3: One-screen nametable B ($2400)
;
; _Change CHR banks:_
;  %11001ccc nnnnnnnn
;  Data: $C8
;  Mask: $07 $FF
;
;   Change CHR-ROM bank ccc to nnnnnnnn. Updates FME-7 register ccc to
;   nnnnnnnn.
;
; _Update palette group:_
;  %11010ppp
;  Data: $D0
;  Mask: $07
;
;   The NES palette at $3F00 + ppp*4 is updated with palette[ppp*4]. It does
;   not affect the background color nor any of its mirrors.
;
; _Write attribute table col:_
;  %11011lll 00hhhhhh llllllll [data...]
;  Data: $D8 $00 $00
;  Mask: $07 $FF $FF
;
;   Writes the following l+1 bytes at %hhhhhh:llllllll in 8 bytes increments (So
;   it updates a column in attribute area).
;
; _Unassigned $E0:_
;  %111xxxxx
;  Data: $E0
;  Mask: $1F
;
;   5 bits of unassigned codes. Does not use; future expansion.
;
.macro check_loop_short
    cpy video_bufferptrW
    bne PPU_loop
    jmp end_updates
.endmacro
.macro check_loop
    cpy video_bufferptrW
    beq :+
    jmp PPU_loop
:   jmp end_updates
.endmacro

    ; do_PPU_updates()
    ; - exit if not ready
    ; - sprite dma
    lda OAM_ready
    beq PPU_update
    lda #>OAM
    sta $4014           ; Sprite DMA!

PPU_update:
    ; - while data in PPU_buff: interpret data, update VRAM address, set inc, write.
    ldy video_bufferptrR
    cpy video_bufferptrW
    bne :+
    jmp set_scroll

:   lda video_ppuctrl
    and #<~$04
    sta n0      ; n0 = inc 1 (line)
    ora #$04
    sta n1      ; n1 = inc 32 (col)

    bit $2002   ; reset 2x write latch (can be removed if care is taken in main
                ; (Never push data while playing with $2006/$2007)
    sty n7      ; Not useful for the code, but useful for debugging if things
                ; goes wrong. It will be easier to see where command list
                ; begins
PPU_loop:
    lda PPU_buff, y
    bpl :+
    jmp update_extra
:
    ; PPU write line/col
    ; %0?xxxxxx
    iny
    ldx n0
    cmp #$40
    bcc :+
    ldx n1
:   stx $2000

    and #$3F
PPU_write:
    sta $2006
    lda PPU_buff, y
    sta $2006
    iny
    lda PPU_buff, y
    bmi PPU_repeat_write
    cmp #crossover_write
    bcc PPU_write_small

    and #$1F
    tax
    mov n2, {PPU_unr_write_lo, x}
    mov n3, {PPU_unr_write_hi, x}
    lda PPU_buff, y
    iny
    jmp (n2)

PPU_repeat_write:
    and #$7F
    cmp #crossover_write
    bcc PPU_repeat_write_small
    sta n4
    and #$1F
    tax
    mov n2, {PPU_unr_repeat_write_lo, x}
    mov n3, {PPU_unr_repeat_write_hi, x}
    lda n4
    iny
    ldx PPU_buff, y
    iny
    jmp (n2)

PPU_write_small:
    iny
PPU_write_small_no_iny:
    lsr A
    tax
    bcc @loop
    inx
    jmp @loop2
@loop:
    mov $2007, {PPU_buff, y}
    iny
@loop2:
    mov $2007, {PPU_buff, y}
    iny
    dex
    bne @loop

    check_loop_short

PPU_repeat_write_small:
    iny
PPU_repeat_write_small_no_iny:
    lsr A
    tax
    lda PPU_buff, y
    iny
    bcc @loop
    inx
    jmp @loop
@loop:
    sta $2007
@loop2:
    sta $2007
    dex
    bne @loop
    check_loop

update_extra:
    ; Normal palette update and extra (extension)
    iny
    cmp #$C0
    bcs :+
    jmp update_cur_addr
:   cmp #$D0
    bcc extra_upd_C0
    cmp #$E0
    bcs extra_upd_E0
    cmp #$D8
    bcc upd_palette_group
    ; attribute col update
    and #$07
    tax
    lda PPU_buff, y
    iny
    sta n2
    lda PPU_buff, y
    iny
    cpx #4
    bcc @f0t4
    cpx #6
    bcc @f4t6
    cpx #7
    bcc @do6 ;33
    clc
    jmp @do7 ;37
@f0t4:
    cpx #2
    bcc @f0t2
    cpx #3
    bcc @do2 ;34
    clc
    jmp @do3 ;38
@f4t6:
    cpx #5
    bcc @do4 ;34
    clc
    jmp @do5 ;38
@f0t2:
    cpx #1
    bcc @do0 ;35
    clc
    jmp @do1 ;39
    .repeat 8,I
.ident(.sprintf("@do%d",I)):
    jmp .ident(.sprintf("attribute_col_unr_%d",I))
    .endrepeat

extra_upd_C0:
    ; Some actions. See C0_jumptable
    ; %1100xxxx
    and #$0F
    tax
    mov n2, {C0_jumptable_lo, x}
    mov n3, {C0_jumptable_hi, x}
    jmp (n2)

extra_upd_E0:
    ; Do nothing, yet.
    ; pattern => %111xxxxx (5 coding bits free)
    check_loop

upd_palette_group:
    ; %11010xxx
    and #$07
    asl
    asl
    tax
    inx
    mov $2000, n0
    mov $2006, #$3F
    stx $2006
    mov $2007, {palette+0, x}
    mov $2007, {palette+1, x}
    mov $2007, {palette+2, x}

    check_loop

update_cur_addr:
    ; Write data without setting PPU address
    ; pattern => %10xxxxxx
    and #$3F
    cmp #$20
    bcs @repeat
    cmp #crossover_write
    bcc :+
    tax
    mov n2, {PPU_unr_write_lo, x}
    mov n3, {PPU_unr_write_hi, x}
    lda #0
    jmp (n2)
:   jmp PPU_write_small_no_iny
@repeat:
    and #$1F
    cmp #crossover_write
    bcc :+
    tax
    mov n2, {PPU_unr_repeat_write_lo, x}
    mov n3, {PPU_unr_repeat_write_hi, x}
    lda #0
    jmp (n2)
:   jmp PPU_repeat_write_small_no_iny

; - - - - - - - - - - - - - - -
; $C0
upd_background:
    mov $2006, #$3F
    mov $2006, #0
    mov $2007, palette+0

    check_loop

; - - - - - - - - - - - - - - -
; $C1
upd_all_palette:
    mov $2000, n0
    mov $2006, #$3F
    mov $2006, #0
    mov $2007, palette+0
    mov $2007, palette+1
    mov $2007, palette+2
    mov $2007, palette+3
    .repeat 7, I
    bit $2007
    mov $2007, palette+5+I*4
    mov $2007, palette+6+I*4
    mov $2007, palette+7+I*4
    .endrepeat
    check_loop

; - - - - - - - - - - - - - - -
; $C2
upd_set_scroll:
    mov video_ppuctrl, {PPU_buff, y}
    iny
    mov scroll_x,      {PPU_buff, y}
    iny
    mov scroll_y,      {PPU_buff, y}
    iny
    check_loop
; - - - - - - - - - - - - - - -
; $C3
upd_set_rendering:
    lda video_ppumask
    sta $2001
    check_loop
; - - - - - - - - - - - - - - -
; $C4-$C7
upd_set_mirroring:
    mov $8000, #$C
    txa
    and #$3
    sta $A000
    check_loop
; - - - - - - - - - - - - - - -
; $C8-$CF
upd_set_chrbank:
    txa
    and #$7
    sta $8000
    lda PPU_buff, y
    iny
    sta $A000
    check_loop
; - - - - - - - - - - - - - - -
C0_jumptable_lo:
    .lobytes upd_background, upd_all_palette, upd_set_scroll, upd_set_rendering
    .lobytes upd_set_mirroring, upd_set_mirroring, upd_set_mirroring, upd_set_mirroring
    .lobytes upd_set_chrbank, upd_set_chrbank, upd_set_chrbank, upd_set_chrbank
    .lobytes upd_set_chrbank, upd_set_chrbank, upd_set_chrbank, upd_set_chrbank
C0_jumptable_hi:
    .hibytes upd_background, upd_all_palette, upd_set_scroll, upd_set_rendering
    .hibytes upd_set_mirroring, upd_set_mirroring, upd_set_mirroring, upd_set_mirroring
    .hibytes upd_set_chrbank, upd_set_chrbank, upd_set_chrbank, upd_set_chrbank
    .hibytes upd_set_chrbank, upd_set_chrbank, upd_set_chrbank, upd_set_chrbank

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
PPU_unr_write:
    .repeat 32,I
    ldx PPU_buff, y
    stx $2007
    iny
.ident(.sprintf("PPU_unr_write_%d",I)):
    .endrepeat
    sbc #32
    bcc :+
    jmp PPU_unr_write
:
    check_loop

PPU_unr_write_lo:
.repeat 32,I
    .lobytes .ident(.sprintf("PPU_unr_write_%d",31-I))
.endrepeat
PPU_unr_write_hi:
.repeat 32,I
    .hibytes .ident(.sprintf("PPU_unr_write_%d",31-I))
.endrepeat
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
PPU_unr_repeat_write:
    .repeat 32,I
    stx $2007
.ident(.sprintf("PPU_unr_repeat_write_%d",I)):
    .endrepeat
    sbc #32
    bcc :+
    jmp PPU_unr_repeat_write
:
    check_loop

PPU_unr_repeat_write_lo:
.repeat 32,I
    .lobytes .ident(.sprintf("PPU_unr_repeat_write_%d",31-I))
.endrepeat
PPU_unr_repeat_write_hi:
.repeat 32,I
    .hibytes .ident(.sprintf("PPU_unr_repeat_write_%d",31-I))
.endrepeat
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
.repeat 8,I
.ident(.sprintf("attribute_col_unr_%d",7-I)):
    ldx n2          ;  3
    stx $2006       ;  7
    sta $2006       ; 11
    ldx PPU_buff, y ; 15
    iny             ; 17
    stx $2007       ; 21
    adc #8          ; 23
.endrepeat
    check_loop

;==============================
end_updates:
    sty video_bufferptrR
set_scroll:
    lda #$18
    bit video_ppumask
    beq exit
    ; - reset scroll
    ; only happens if rendering is enabled
    mov $2000, video_ppuctrl
    mov $2005, scroll_x
    mov $2005, scroll_y

exit:
    rts
.endproc
;-------------------------------------------------------------------------------
.proc video_ctor
    movw r0, #OAM               ; Init OAM
    movw r2, #$FF               ; memset(OAM, 0xFF, sizeof(OAM))
    movw r4, #OAM_size
    jsr memset

    movw r0, #palette           ; Init palette (buffer) to all black
    movw r2, #$0F               ; memset(palette, 0x0F, sizeof(palette))
    movw r4, #palette_size
    jsr memset

    mov  OAM_ready, #0          ; Init some vars
    mov  video_bufferptrR, #0
    mov  video_bufferptrW, #0
    mov  video_ppuctrl, #$80
    mov  video_ppumask, #0
    mov  scroll_x, #0
    mov  scroll_y, #0

    mov $2003, #0
    rts
.endproc
;-------------------------------------------------------------------------------

