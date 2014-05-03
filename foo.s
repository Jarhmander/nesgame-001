.include "configure.inc"
.include "core.inc"
.include "init.inc"
.include "nmi.inc"
.include "video.inc"
.include "mapper69.inc"
;-------------------------------------------------------------------------------

nesconfig horz, 69, off
nessize 4, 1

.export main


    .segment "PRGBK00"

initppu:
    .byte $C3, $C1, $C5     ; rendering on, update palette, horiz. mirroring.
    .byte $C8, 0, $C9, 1    ; Banking CHR

initppu_size = * - initppu

initppu2:
    .dbyt $2000 + 4 + (15 << 5)
    .byte 24, 4, "THIS IS JARHMANDER !!!", 4
    .dbyt $2000 + 4 + (14 << 5)
    .byte 1, 6
    .byte $80|$20|22,5
    .byte $81, 7
    .dbyt $2000 + 4 + (16 << 5)
    .byte 1, 8
    .byte $80|$20|22,5
    .byte $81, 9


initppu2_size = * - initppu2

status_bar_info:
    .byte "(THIS IS A STATUS BAR)"
status_bar_info_size = * - status_bar_info
;-------------------------------------------------------------------------------
.proc main
    ldy video_bufferptrW
    push_PPU y+, #$C1
    push_PPU y+, #$C4
    sty video_bufferptrW
    mov nmi2irq_time+1,  #$FF
    jsr wait_vblank

    mov i4, #8  ; only bit2-3 are significative, 2 bits of nametable address
    mov i5, #$40; bit0-2 and bit6-7 are significative, fine-Y scroll and 2msb of
                ; coarse Y scroll
    mov i6, #0  ; only bit0-2 are significative, x fine scroll
    mov i7, #$E0; bit0-4 set coarse x, bit5-7 set 3lsb of coarse y

    lda video_ppuctrl
    and #<~$4
    sta $2000
    movw r0, #$2000
    movw r2, #0
    movw r4, #$800
    jsr memset_vram

    movw r0, #$2000 + (1 << 10) + 5 + (17 << 5)
    movw r2, #status_bar_info
    movw r4, #status_bar_info_size
    jsr memcpy_vram

    mov $2006, #>($2000 + (1<<10) + 0 + (15<<5))
    mov $2006, #<($2000 + (1<<10) + 0 + (15<<5))
    mov $2007, #6
    lda #5
    ldx #30
:   sta $2007
    dex
    bne :-
    mov $2007, #7

    lda video_ppuctrl
    ora #4
    sta $2000
    mov $2006, #>($2000 + (1<<10) + 0 + (16<<5))
    mov $2006, #<($2000 + (1<<10) + 0 + (16<<5))
    ldx #4
    stx $2007
    stx $2007
    stx $2007

    mov $2006, #>($2000 + (1<<10) + 31+ (16<<5))
    mov $2006, #<($2000 + (1<<10) + 31+ (16<<5))
    stx $2007
    stx $2007
    stx $2007

    lda #<~4
    and video_ppuctrl
    sta $2000
    mov $2006, #>($2000 + (1<<10) + 0 + (19<<5))
    mov $2006, #<($2000 + (1<<10) + 0 + (19<<5))
    mov $2007, #8
    lda #5
    ldx #30
:   sta $2007
    dex
    bne :-
    mov $2007, #9

    ldy video_bufferptrW
    inc OAM_ready

    sty  r0
    movw r1, #initppu
    mov  r3, #<initppu_size
    jsr memcpy_ppu
    tay
    mov palette+ 1, #$2D
    mov palette+ 2, #$3D
    mov palette+ 3, #$20

    movw nmi2irq_time, #((20+(240-8*6+2))*341)/3-28-10-80
    cli

    mov video_ppumask, #$1E
    sty video_bufferptrW
    jsr wait_vblank

    ; write text
    sty  r0
    movw r1, #initppu2
    mov  r3, #<initppu2_size
    jsr memcpy_ppu
    tay
    sty video_bufferptrW
    ldx #60
    jsr wait_x_frames

    ; Scroll thingy
    ldy #20
:   inc scroll_x
    jsr wait_vblank
    dey
    bne :-

    ldy #20
:   dec scroll_x
    inc scroll_y
    jsr wait_vblank
    dey
    bne :-

    ldy #20
:   dec scroll_x
    dec scroll_y
    jsr wait_vblank
    dey
    bne :-

    ldy #20
:   inc scroll_x
    jsr wait_vblank
    dey
    bne :-

    ldx #60
    jsr wait_x_frames

    ; Fade thingy
    ldy video_bufferptrW
    mov palette+ 0, #1
    mov palette+ 1, #$11
    mov palette+ 2, #$21

    push_PPU y+, #$C0
    push_PPU y+, #$D0
    sty video_bufferptrW
    ldx #3
    jsr wait_x_frames

    mov palette+ 0, #$11
    mov palette+ 1, #$21
    mov palette+ 2, #$31

    push_PPU y+, #$C0
    push_PPU y+, #$D0
    sty video_bufferptrW
    ldx #3
    jsr wait_x_frames

    mov palette+ 0, #$21
    mov palette+ 1, #$31
    mov palette+ 2, #$30

    push_PPU y+, #$C0
    push_PPU y+, #$D0
    sty video_bufferptrW
    ldx #180
    jsr wait_x_frames


    mov palette+ 0, #$11
    mov palette+ 1, #$21
    mov palette+ 2, #$31

    push_PPU y+, #$C0
    push_PPU y+, #$D0
    sty video_bufferptrW
    ldx #5
    jsr wait_x_frames

    mov palette+ 0, #1
    mov palette+ 1, #$11
    mov palette+ 2, #$21

    push_PPU y+, #$C0
    push_PPU y+, #$D0
    sty video_bufferptrW
    ldx #5
    jsr wait_x_frames

    mov palette+ 0, #$0F
    mov palette+ 1, #$2D
    mov palette+ 2, #$3D

    push_PPU y+, #$C0
    push_PPU y+, #$D0

    sty video_bufferptrW
    ldx #60
    jsr wait_x_frames

    movw r8,  #0
    mov  r10, #0
@endloop:
    jsr wait_vblank
    lda #3
    clc
    adc r8
    sta r8
    lda #0
    adc r9
    sta r9
    clc
    lda r8
    adc r10
    sta r10
    lda r9
    adc scroll_x
    sta scroll_x
    jmp @endloop

wait_x_frames:
    stx r0
:   jsr wait_vblank
    dec r0
    bne :-
    rts

; uint8_t memcpy_ppu(uint8_t dest, const void *src, uint8_t len)
memcpy_ppu:
    ldx r0
    ldy #0
:   lda (r1),y
    push_PPU x+
    iny
    bne :+
    inc r2
:   dec r3
    bne :--
    txa
    rts
.endproc
;-------------------------------------------------------------------------------
.proc irq
    push A,X
    mov $2006, i4
    mov $2005, i5
    mov $2005, i6
    mov $2006, i7
    ldx #$D
    lda #0
    stx $8000
    sta $A000
    pop  A,X
    rti
.endproc
;-------------------------------------------------------------------------------

