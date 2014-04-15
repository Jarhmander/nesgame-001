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

;-------------------------------------------------------------------------------
.proc main
    ldy video_bufferptrW
    push_PPU y+, #$C1
    sty video_bufferptrW
    jsr wait_vblank

    lda video_ppuctrl
    and #<~$4
    sta $2000
    movw r0, #$2000
    movw r2, #0
    movw r4, #$400
    jsr memset_vram

    ldy video_bufferptrW
    inc OAM_ready
    push_PPU y+, #$C3
    push_PPU y+, #$C1
    push_PPU y+, #$C6
    push_PPU y+, #$21
    push_PPU y+, #$E8
    push_PPU y+, #$88
    push_PPU y+, #$21
    push_PPU y+, #$A4
    push_PPU y+, #$30
    push_PPU y+, #$84
    push_PPU y+, #$22
    push_PPU y+, #$23
    push_PPU y+, #$24
    push_PPU y+, #$31
    push_PPU y+, #$61
    push_PPU y+, #$70
    push_PPU y+, #$83
    push_PPU y+, #$24
    push_PPU y+, #$C8
    push_PPU y+, #$00
    mov palette+ 3, #$20

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

    mov palette+3, #$10
    push_PPU y+, #$D0
    sty video_bufferptrW
    ldx #6
    jsr wait_x_frames

    mov palette+3, #$0
    push_PPU y+, #$D0
    sty video_bufferptrW
    ldx #6
    jsr wait_x_frames

    mov palette+3, #$2D
    push_PPU y+, #$D0
    sty video_bufferptrW
    ldx #6
    jsr wait_x_frames

    mov palette+3, #$1D
    push_PPU y+, #$D0
    sty video_bufferptrW
    ldx #6
    jsr wait_x_frames
    ; Quit and stall!
    rts

wait_x_frames:
    stx r0
:   jsr wait_vblank
    dec r0
    bne :-
    rts
.endproc
;-------------------------------------------------------------------------------

