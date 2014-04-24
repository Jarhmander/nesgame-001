.ifndef MAPPER69_INC
MAPPER69_INC = 1
;-------------------------------------------------------------------------------

; This is a temp var that retain the last write to $8000, the command select
; register. If an IRQ or NMI fire, and want to write to some mapper's registers,
; they do so and restore before exit the last value written to $8000, ensuring
; that the interrupted code will always write to the correct mapper register
; afterward.
.globalzp mapper_cmdreg

; This is a small array that retains the last values written to mapper regs
; 8-11
.globalzp mapper_prgbanks
mapper_prgbanks_size = 4

; Routines
; void swbankprg_save(uint8_t bank, uint8_t area) __noclobber__
; (bank : [8-11])
.global swbankprg_save

; void mapper_write(uint8_t value, uint8_t mapper_reg) __noclobber__
.global mapper_write

; Macros

; Makes addr visible by the NES runtime address space by switching the bank
; where addr is located into its expected runtime address.

.macro swbankprg_check addr
    .assert >.bank(*) <> >.bank(addr) .or .bank(*) = .bank(addr), lderror, .sprintf("swbank: switching '%s' into its runtime address would switch into current runtime address", .string(addr))
    .assert .bank(addr) <> $FFFF, lderror, .sprintf("swbank: symbol '%s' is located in the fixed bank; you cannot bankswitch the fixed bank", .string(addr))
.endmacro

.macro swbankprg addr
    swbankprg_check addr

    ldx #(8 + >.bank(addr))
    lda #<.bank(addr)
    jsr swbankprg_save
.endmacro

.macro swbankprg_nosave addr
    swbankprg_check addr

    lda #(8 + >.bank(addr))
    sta $8000

    lda #<.bank(addr)
    sta $A000
.endmacro

;-------------------------------------------------------------------------------
.endif ; MAPPER69_INC

