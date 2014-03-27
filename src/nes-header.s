.include "nes-header.inc"
;-------------------------------------------------------------------------------
.segment "NESHEADER"
    ; Based on NESDev wiki (http://wiki.nesdev.com/w/index.php/INES)

                            ; offset |  Description
                            ;------------------------------------------------------
    .byte "NES", $1A        ; 0-3    | "Magic word"
    .byte <__PRGROM_SZ16K__ ; 4      | PRG-ROM size in 16K increments
    .byte <__CHRROM_SZ8K__  ; 5      | CHR-ROM size in 8K increments (0 = CHR-RAM)
    .byte __FLAGS6__        ; 6      | Mapper, trainer, SRAM, mirroring (see below)
    .byte __FLAGS7__        ; 7      | Mapper, version, system (see below)
    .byte <__PRGRAM_SZ8K__  ; 8      | PRG-RAM size in 8K increments
    .byte __FLAGS9__        ; 9      | TV system (see below)
    .byte __FLAGS10__       ; 10     | Rarely supported flags (see below)
    .byte 0,0,0,0,0         ; 11-15  | Reserved (0 for compatibility)

; FLAGS6:
;
;    76543210
;    ||||||||
;    ||||+||+- 0xx0: vertical arrangement/horizontal mirroring (CIRAM A10 = PPU A11)
;    |||| ||   0xx1: horizontal arrangement/vertical mirroring (CIRAM A10 = PPU A10)
;    |||| ||   1xxx: four-screen VRAM
;    |||| |+-- 1: SRAM in CPU $6000-$7FFF, if present, is battery backed
;    |||| +--- 1: 512-byte trainer at $7000-$71FF (stored before PRG data)
;    ++++----- Lower nybble of mapper number
;
;----
; FLAGS7:
;
;    76543210
;    ||||||||
;    |||||||+- VS Unisystem
;    ||||||+-- PlayChoice-10 (8KB of Hint Screen data stored after CHR data)
;    ||||++--- If equal to 2, flags 8-15 are in NES 2.0 format
;    ++++----- Upper nybble of mapper number
;
;----
; FLAGS9:
;
;    76543210
;    ||||||||
;    |||||||+- TV system (0: NTSC; 1: PAL)
;    +++++++-- Reserved, set to zero
;
;----
; FLAGS10:
;
;    76543210
;      ||  ||
;      ||  ++- TV system (0: NTSC; 2: PAL; 1/3: dual compatible)
;      |+----- SRAM in CPU $6000-$7FFF is 0: present; 1: not present
;      +------ 0: Board has no bus conflicts; 1: Board has bus conflicts
;
; These flags are not in the "official" specifications, so it is not widely 
; supported.
;
;-------------------------------------------------------------------------------

