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

; HACK, should be defined!
.export irq : abs := 0

    .segment "PRGBK00"

initppu:
    .byte $C3, $C1, $C6     ; rendering on, update palette, ScrnA mirroring.
    .byte $C8, 0, $C9, 1    ; Banking CHR

initppu_size = * - initppu

initppu2:
    .dbyt $2000 + 4 + (15 << 5)
    .byte 23, 4, "THIS IS JARHMANDER!!!", 4
    .dbyt $2000 + 4 + (14 << 5)
    .byte 1, 6
    .byte $80|$20|21,5
    .byte $81, 7
    .dbyt $2000 + 4 + (16 << 5)
    .byte 1, 8
    .byte $80|$20|21,5
    .byte $81, 9


initppu2_size = * - initppu2

;-------------------------------------------------------------------------------
.proc main
    ldy video_bufferptrW
    push_PPU y+, #$C1
    sty video_bufferptrW
    jsr wait_vblank

    mov video_ppumask, #$1E
    lda video_ppuctrl
    and #<~$4
    sta $2000
    movw r0, #$2000
    movw r2, #0
    movw r4, #$400
    jsr memset_vram

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


    sty video_bufferptrW
    jsr wait_vblank

    sty  r0
    movw r1, #initppu2
    mov  r3, #<initppu2_size
    jsr memcpy_ppu
    tay
    sty video_bufferptrW
    ldx #60
    jsr wait_x_frames

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

    ldy video_bufferptrW
    mov palette, #1
    push_PPU y+, #$C0
    sty video_bufferptrW
    ldx #3
    jsr wait_x_frames

    mov palette, #$11
    push_PPU y+, #$C0
    sty video_bufferptrW
    ldx #3
    jsr wait_x_frames

    mov palette, #$21
    push_PPU y+, #$C0
    sty video_bufferptrW

    ldx #180
    jsr wait_x_frames

    mov palette, #$11
    push_PPU y+, #$C0
    sty video_bufferptrW
    ldx #5
    jsr wait_x_frames

    mov palette, #$01
    push_PPU y+, #$C0
    sty video_bufferptrW
    ldx #5
    jsr wait_x_frames

    mov palette, #$0F
    push_PPU y+, #$C0
    sty video_bufferptrW
    ldx #60
    jsr wait_x_frames

    ; Quit and stall!
    rts

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

