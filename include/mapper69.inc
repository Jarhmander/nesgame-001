.ifndef MAPPER69_INC
.define MAPPER69_INC
;-------------------------------------------------------------------------------

; This is a temp var that retain the last write to $8000, the command select 
; register. If an IRQ or NMI fire, and want to write to some mapper's registers,
; they do so and restore before exit the last value written to $8000, ensuring 
; that the interrupted code will always write to the correct mapper register 
; afterward.
.globalzp mapper_cmdreg

; Makes addr visible by the NES runtime address space by switching the bank 
; where addr is located into its expected runtime address.

.macro swbankprg_check addr
    .assert >.bank(*) <> >.bank(addr), lderror, .sprintf("swbank: switching '%s' into its runtime address would switch into current runtime address", .string(addr))
    .assert .bank(addr) <> $FFFF, lderror, .sprintf("swbank: symbol '%s' is located in the fixed bank; you cannot bankswitch the fixed bank", .string(addr))
.endmacro

.macro swbankprg addr
    swbankprg_check addr

    lda #(8 + >.bank(addr))
    sta mapper_cmdreg
    sta $8000

    lda #<.bank(addr)
    sta $A000
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