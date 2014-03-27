#
# Linker script for mapper 69 (FME-7 & Sunsoft-5B)
# by Jarhmander (James-Adam Renquinha Henri)
#

SYMBOLS {
    PRGROM_SZ16K: type = import, addrsize = abs;
    CHRROM_SZ8K:  type = import, addrsize = abs;
    FLAGS9:       type = weak, value = 0, addrsize = zp;
    FLAGS10:      type = weak, value = 0, addrsize = zp;
    PRGROM_SZ:    type = export, value = $4000 * PRGROM_SZ16K;
    CHRROM_SZ:    type = export, value = $2000 * CHRROM_SZ8K;
    PRGRAM_SZ:    type = export, value = $2000 * PRGRAM_SZ8K;
}

# attributes:
#  start = ADDR
#  size  = LEN
#  define= yes
#  type = ro rw
#  fill = yes
#  fillval= value
MEMORY {
    # Dummy region: reserved for NES header
    RES_DUMMYNESHEADER:
        start  = 0  size = $10, type = ro;

    PRGROM:
    # Another somewhat dummy region. Use multiples of 16K ($4000)
        start = $10000000,
        fill = yes,
        size  = PRGROM_SZ - $2000;

    ZEROPAGE:
        start  = 0,    size = 256,  type = rw;
    STACK:
        start  = $100, size = 256,  type = rw;
    NESRAM:
        start  = $200, size = $600, type = rw;

    EXRAM:
        start  = $6000, size = $2000, type = rw;

    ROMSB0:
        start  = $8000, size = $2000,
        type   = ro,
        define = yes;
    ROMSB1:
        start = $A000, size = $2000,
        type   = ro,
        define = yes;
    ROMSB2:
        start = $C000, size = $2000,
        type   = ro,
        define = yes;
    ROMFB0:
        start = $E000, size = $2000,
        type   = ro,
        define = yes;

    CHRROM:
    # Another somewhat dummy region. Use multiples of 8K ($2000)
        start = $10000000,
        size  = CHRROM_SZ;
}

SEGMENTS {
    # RAM segments
    REG:        load = ZEROPAGE, type = zp;
    ZEROPAGE:   load = ZEROPAGE, type = zp;
    BSS:        load = NESRAM, type = bss, define = yes;
    EXRAM:      load = EXRAM, type = bss, optional = yes;

    # Must stay here!
    NESHEADER:  load = RES_DUMMYNESHEADER,   type = ro;

    # The various PRG banks, care should be taken to use no more than the number
    # of banks that the emulator 
    PRGBK00:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK01:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK02:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK03:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK04:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK05:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK06:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK07:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK08:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK09:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK10:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK11:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK12:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK13:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK14:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK15:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK16:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK17:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK18:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK19:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK20:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK21:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK22:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK23:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK24:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK25:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK26:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK27:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK28:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK29:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK30:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK31:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK32:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK33:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK34:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK35:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK36:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK37:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK38:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK39:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK40:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK41:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK42:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK43:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK44:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK45:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK46:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK47:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK48:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK49:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK50:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK51:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK52:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK53:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK54:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK55:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK56:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK57:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK58:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK59:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK60:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK61:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK62:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;
    PRGBK63:     load = PRGROM, type = ro, define = yes, align_load = $2000, optional = yes, run = ROMSB0;

    # Must stay here!
    # Fixed last PRG-ROM bank
    RODATA:     load = ROMFB0, run = ROMFB0, type = ro, align = $2000;
    DATA:       load = ROMFB0, run = NESRAM, type = rw, define = yes;
    CODE:       load = ROMFB0, run = ROMFB0, type = ro;
    VECTORS:    load = ROMFB0, run = ROMFB0, type = ro, offset = $1FFA;

    # CHR-ROM segments

}

# features:
# order = increasing decreasing
#FEATURES {
#    CONDES: segment = RODATA,
#                type = constructor,
#                label = __CONSTRUCTOR_TABLE__,
#                count = __CONSTRUCTOR_COUNT__;
#}

