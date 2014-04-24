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
; | Write line (*)          | $00|<addr_hi>, <addr_lo>, <rlen>, <data> [...]  |
; | Write col               | $40|<addr_hi>, <addr_lo>, <rlen>, <data> [...]  |
; | Write continue          | $80|<rlen>, <data> [...]       <rlen> mask: $3F |
; | Update background color | $C0                                             |
; | Update all palette      | $C1                                             |
; | Set rendering           | $C2                                             |
; | Set scroll              | $C3, <ppuctrl>, <scroll_x>, <scroll_y>          |
; | Change mirroring        | $C4|<mirrorbits>         <mirrorbits> mask: $03 |
; | Change CHR banks        | $C8|<sel>, <banknum>            <sel> mask: $07 |
; | Update palette group    | $D0|<sel>                       <sel> mask: $07 |
; +-------------------------+-------------------------------------------------+
;
; (*): if <addr_hi> is $3F (points the palette) and <addr_lo> is >= $20, then
;      palette buffer is also updated.
;
; Detailed description
; -----------------------------------------------------------------------------
; _Write line_:
;  %00hhhhhh llllllll rsssssss [data ...]
;  Data: $00 $00 $00
;  Mask: $3F $FF $FF
;
;   Sets increment to 1 and sets PPU address to %00hhhhhhllllllll. Writes
;   sssssss bytes to $2007. If hhhhhh = $3F (palette address) and
;   llllllll >= $20 then update palette buffer too with this data. Regardless of
;   how the palette is updated with this command, it won't do any special
;   treatment to the background palette mirrors.
;
;   If r is 0, the following sssssss bytes will be copied (normal mode);
;   otherwise, the next byte is copied sssssss times (repeat mode).
;
; _Write col_:
;  %01hhhhhh llllllll rsssssss [data ...]
;  Data: $40 $00 $00
;  Mask: $3F $FF $FF
;
;   Set increment to 32 and sets PPU address to %00hhhhhhllllllll. Writes
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
; _Unassigned $D8:_
;  %11011xxx
;  Data: $D8
;  Mask: $07
;
;   3 bits of unassigned codes. Does not use; future expansion.
;
; _Unassigned $E0:_
;  %111xxxxx
;  Data: $E0
;  Mask: $1F
;
;   5 bits of unassigned codes. Does not use; future expansion.
;

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
    cmp #$3F
    bcc update_line
    beq update_palette_inline

    ; PPU write col
    ; %01xxxxxx
    ldx n1
    stx $2000

    and #$3F
PPU_write:
    sta $2006
    lda PPU_buff, y
PPU_write_next:
    sta $2006
    iny
    lda PPU_buff, y
    bmi PPU_repeat_write
    iny
PPU_write_no_set_addr:
    lsr A
    beq PPU_write_1
    tax
    bcc @loop

    mov $2007, {PPU_buff, y}
    iny
@loop:
    mov $2007, {PPU_buff, y}
    iny
    mov $2007, {PPU_buff, y}
    iny
    dex
    bne @loop

    cpy video_bufferptrW
    bne PPU_loop
    jmp end_updates
PPU_write_1:
    mov $2007, {PPU_buff, y}
check_loop_iny:
    iny
    cpy video_bufferptrW
    bne PPU_loop
    jmp end_updates

PPU_repeat_write:
    iny
    and #$7F
PPU_repeat_write_no_set_addr:
    lsr A
    beq PPU_write_1
    tax
    lda PPU_buff, y
    iny
    bcc @loop
    sta $2007
@loop:
    sta $2007
    sta $2007
    dex
    bne @loop

check_loop:
    cpy video_bufferptrW
    bne PPU_loop
    jmp end_updates

update_line:
    ; %00xxxxxx
    ldx n0
    stx $2000
    jmp PPU_write

update_palette_inline:
    ; %00111111 ($3F)
    ldx n0
    stx $2000

    sta $2006
    lda PPU_buff, y
    iny
    cmp #$20
    bcs PPU_write_next  ; Normal update
    ; Update palette AND palette buffer
    and #$1F
    sta $2006
    tax
    iny
    lda PPU_buff, y
    bmi update_palette_inline_repeat
    beq check_loop_iny
    iny
    sta n2
@loop:
    mov $2007, {PPU_buff, y}
    sta palette, x
    inx
    iny
    dec n2
    bne @loop

    jmp check_loop

update_palette_inline_repeat:
    iny
    and #$7F
    beq check_loop_iny
    sta n2
    lda PPU_buff, y
    iny
@loop:
    sta $2007
    sta palette, x
    inx
    dec n2
    bne @loop

    jmp check_loop

update_extra:
    ; Normal palette update and extra (extension)
    iny
    cmp #$C0
    bcc update_cur_addr
    cmp #$D0
    bcc extra_upd_C0
    cmp #$E0
    bcs extra_upd_E0
    ; Update palette group
    ; %1101-ppp
    ; NOTE: change the code if %11011xxx is to be used; now it doesn't check
    ; the - bit.
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

    jmp check_loop
extra_upd_C0:
    ; Some actions. See C0_jumptable
    ; %1100xxxx
    and #$0F
    tax
    mov n2, {C0_jumptable_lo, x}
    mov n3, {C0_jumptable_hi, x}
    jmp (n2)

update_cur_addr:
    ; Write data without setting PPU address
    ; pattern => %10xxxxxx
    and #$3F
    cmp #$20
    bcs :+
    jmp PPU_write_no_set_addr
:   and #$1F
    jmp PPU_repeat_write_no_set_addr

extra_upd_E0:
    ; Do nothing, yet.
    ; pattern => %111xxxxx (5 coding bits free)
    jmp check_loop

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

; - - - - - - - - - - - - - - -
; $C0
upd_background:
    mov $2006, #$3F
    mov $2006, #0
    mov $2007, palette+0

    jmp check_loop

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
    ldx #7
    sty n2
    ldy #4
    ; clc implied by bcc that branched here
@loop:
    bit $2007
    mov $2007, {palette+1,y}
    mov $2007, {palette+2,y}
    mov $2007, {palette+3,y}
    tya
    adc #4
    tay
    dex
    bne @loop

    ldy n2
    jmp check_loop

; - - - - - - - - - - - - - - -
; $C2
upd_set_scroll:
    mov video_ppuctrl, {PPU_buff, y}
    iny
    mov scroll_x,      {PPU_buff, y}
    iny
    mov scroll_y,      {PPU_buff, y}
    iny
    jmp check_loop
; - - - - - - - - - - - - - - -
; $C3
upd_set_rendering:
    lda video_ppumask
    sta $2001
    jmp check_loop
; - - - - - - - - - - - - - - -
; $C4-$C7
upd_set_mirroring:
    mov $8000, #$C
    txa
    and #$3
    sta $A000
    jmp check_loop
; - - - - - - - - - - - - - - -
; $C8-$CF
upd_set_chrbank:
    txa
    and #$7
    sta $8000
    lda PPU_buff, y
    iny
    sta $A000
    jmp check_loop
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

