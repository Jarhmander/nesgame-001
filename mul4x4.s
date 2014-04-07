.include "core.inc"
;-------------------------------------------------------------------------------

; Goal: 4x4->4 msb, mask: 0x0F x 0xF0 => (0x0F 0x00)[0]; lsbyte ignored
; First multiplicand is volume, the other comes from the enveloppe generator
; Alloc:
;    A => egen
;    X => vol
; Code:
.export mul4x4_APU
.export mul4x4

.proc mul4x4_APU
    eor #$F0    ; 2
    and #$F0    ; 4
    sta r0      ; 7
    tay         ; 9
    asl A       ; 11
    asl A       ; 13
    sta r1      ; 16
    txa         ; 18
    clc         ; 20
    bit r0      ; 23
    bpl lowbit  ; 25
    bvc d4      ; 27

d8: ror A       ; 29
d4: ror A       ; 31
d2: ror A       ; 33
d1: sta r2      ; 36
    ror r2      ; 41

    asl r1      ; 46
    bcs :+      ; 48
    adc r2      ; 51
    adc #0      ; 53
:   sta r0      ; 56
    ror r0      ; 61
    ror r2      ; 66
    asl r1      ; 71
    bcs :+      ; 73
    adc r2      ; 76
    adc #0      ; 78
:   cpy #$40    ; 80
    bcc @ov     ; 82
    and #$0F    ; 84
    rts         ; 90
@ov:
    and #$1F    ; 83
    cmp #$10    ; 85
    bcc @ok     ; 87
    lda #$0F    ; 89
@ok:
    rts         ; 95
lowbit:
    bvs d2
    bvc d1
.endproc



;  C  7  6  5  4  3  2  1  0
;  0 |0  0  0  0  v3 v2 v1 v0
;  v0|0  0  0  0  0  v3 v2 v1  A
;  v1|v0 0  0  0  0  0  v3 v2  r2 A
;  v2|v1 v0 0  0  0  0  0  v3     r2 A
;  v3|v2 v1 v0 0  0  0  0  0         r2

; A (u4) * X (s8) => A (s8) ( -8 <= X <= 8; bigger range if A is constrained to lower values )
; A (u4) * X (u8) => A (u8) ( X <= 17; bigger range if A is constrained to lower values )
; The upper bits of A are ignored, no masking necessary
; uses: A,X,r0,r1
; exit: A (result), X (unchanged), r0 (old A >> 4), r1 (X << 3), P (undefined)
.proc mul4x4
    eor #$0F    ; 2
    sta r0      ; 5
    stx r1      ; 8
    lda #0      ; 10

    lsr r0      ; 15
    bcs :+      ; 17
    adc r1      ; 20
:   asl r1      ; 25
    lsr r0      ; 30
    bcs :+      ; 32
    adc r1      ; 35
:   asl r1      ; 40
    lsr r0      ; 45
    bcs :+      ; 47
    adc r1      ; 50
:   asl r1      ; 55
    lsr r0      ; 60
    bcs :+      ; 62
    adc r1      ; 65
:   rts         ; 71
.endproc
;-------------------------------------------------------------------------------
