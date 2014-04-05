; Goal: 4x4->4 msb, mask: 0x0F x 0xF0 => (0x0F 0x00)[0]; lsbyte ignored
; First multiplicand is volume, the other is the enveloppe generator
; Alloc:
    A => egen
    X => vol
; Code:
mul4x4_APU_bmi:
    bvc d2
    bvs d1

mul4x4_APU:
    eor #$F0    ; 2
    and #$F0    ; 4
    sta r1      ; 7
    tay         ; 9
    txa         ; 11
    clc         ; 13
    bit r1      ; 16
    bmi mul4x4_bmi
    bvs d4      ; 20

d8: ror A       ; 22
d4: ror A       ; 24
d2: ror A       ; 26
d1: sta r2      ; 29
    ror r2      ; 34
    lsr r1      ; 39
    lsr r1      ; 44

    lsr r1      ; 49
    bcs :+      ; 51
    adc r2      ; 54
    adc #0      ; 56
:   sta r0      ; 59
    ror r0      ; 64
    ror r2      ; 69
    lsr r1      ; 74
    bcs :+      ; 76
    adc r2      ; 79
    adc #0      ; 81
:   cpy #$40    ; 83
    bcc @ov     ; 85
    and #$0F    ; 87
    rts         ; 93
@ov:
    and #$1F    ; 86
    cmp #$10    ; 88
    bcc @ok     ; 90
    lda #$0F    ; 92
@ok:
    rts         ; 98



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
; exit: A (result), X (unchanged), r0 (old A >> 4), r1 (X << 4), P (C=1,N=A(7),Z=(A=0),V undefined)
mul4x4:
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
:   cmp #0      ; 71
    rts         ; 73
