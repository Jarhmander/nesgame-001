.ifndef VIDEO_INC
VIDEO_INC = 1
;-------------------------------------------------------------------------------

; Vars:
.global OAM
OAM_size = 256
.global palette
palette_size = 32

.global PPU_buff
PPU_buff_size = 256

.globalzp OAM_ready
.globalzp video_bufferptrR
.globalzp video_bufferptrW
.globalzp video_ppuctrl
.globalzp video_ppumask
.globalzp scroll_x, scroll_y

.globalzp video_callback    ; 3 bytes
; Routines:
; void do_PPU_updates() __nmi__
.global do_PPU_updates

; Macros
;
.macro push_PPU indexsp, value
    .local postinc, preinc, indexpos
    postinc  .set 0
    preinc   .set 0
    indexpos .set 0

    .if .tcount({indexsp}) > 2 .or .blank(indexsp)
        .error "push_PPU: syntax error"
    .elseif .match({.left(1,{indexsp})},+)
        preinc   .set 1
        indexpos .set 1
    .elseif .match({.right(1,{indexsp})},+)
        postinc  .set 1
    .endif

    .assert .match({.mid(indexpos,1,{indexsp})},x) .or .match({.mid(indexpos,1,{indexsp})},y), error, "push_PPU: invalid index specification"

    .if preinc
        .if .match(.mid(indexpos,1,{indexsp}),x)
            inx
        .else
            iny
        .endif
     .endif

     .ifnblank value
        lda value
     .endif
     sta PPU_buff, .mid(indexpos,1,{indexsp})

    .if postinc
        .if .match(.mid(indexpos,1,{indexsp}),x)
            inx
        .else
            iny
        .endif
     .endif
.endmacro

;-------------------------------------------------------------------------------
.endif ; VIDEO_INC

