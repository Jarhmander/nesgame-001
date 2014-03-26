#
# Linker script for mapper 69 (FME-7 & Sunsoft-5B)
# by Jarhmander (James-Adam Renquinha Henri)
#

SYMBOLS {
    PRGROM_SZ:    type = import, addrsize = long;
    CHRROM_SZ:    type = import, addrsize = long;
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

# attributes:
#  load (mandatory) = MEM
#  type   = rw ro zp bss
#  define = yes
#  file   = "file" %O (default)
#  run    = MEM
#  align  = value \
#  start  = ADDR   > define none or one, never more than one
#  offset = value /

SEGMENTS {
    # RAM segments
    REG:        load = ZEROPAGE, type = zp;
    ZP:         load = ZEROPAGE, type = zp, optional = yes;
    BSS:        load = NESRAM, type = bss, define = yes;
    EXRAM:      load = EXRAM, type = bss, optional = yes;

    # Must stay here!
    NESHEADER:  load = RES_DUMMYNESHEADER,   type = ro;

    # The various PRG banks, care should be taken to use the same number of 
    # banks that the iNES header tells
    BANK00:     load = PRGROM, type = ro, define = yes, align_load = $2000,
                run = ROMSB0;

    # Must stay here!
    # Fixed last bank
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

