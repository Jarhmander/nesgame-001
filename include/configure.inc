.ifndef CONFIGURE_INC
.define CONFIGURE_INC
;-------------------------------------------------------------------------------
.include "nes-header.inc"
;-------------------------------------------------------------------------------

.macro nesconfig mirroring, mapper, batterybackedsram
    .local tflag6, tflag7, isok

    isok .set 1
    
    .if .xmatch(mirroring,vert) .or .xmatch(mirroring,vertical)
        tflag6 .set 0
    .elseif .xmatch(mirroring,horz) .or .xmatch(mirroring,horizontal)
        tflag6 .set 1
    .elseif .xmatch(mirroring,4) .or .xmatch(mirroring,4-screen)
        tflag6 .set 8
    .else
        .error .sprintf("nesconfig: unsupported mirroring '%s'",.string(mirroring))
        isok .set 0
    .endif

    .if !.const(mapper)
        .error .sprintf("nesconfig: mapper is not a constant expression (%s)", .string(mapper))
        isok .set 0
    .elseif mapper > 256 .or mapper < 0
        .error .sprintf("nesconfig: invalid mapper specification (%d)",mapper)
        isok .set 0
    .else
        tflag6 .set (tflag6 | ((mapper & $0F) << 4))
        tflag7 .set (mapper & $F0)
    .endif

    .if .blank(batterybackedsram) .or .xmatch(batterybackedsram,off)
        ; ok, do nothing!
    .elseif .xmatch(batterybackedsram,on)
        tflag7 .set (tflag7 | 2)
    .else
        .error .sprintf("nesconfig: invalid battery backed SRAM switch (on/off expected)")
        isok .set 0
    .endif

    .if isok
        .exportzp __FLAGS6__ = tflag6
        .exportzp __FLAGS7__ = tflag7
        .importzp __CFG_MAPPER__
        .assert mapper = __CFG_MAPPER__, lderror, .sprintf("nesconfig: you selected the wrong linker script for this mapper (%d); use mapper%d.ld, if it exists",mapper,mapper)
        isok .set 0
    .endif
.endmacro

.macro mac_helper__initunitialized varo, init, vari
    .if .blank (vari)
        varo .set init
    .else
        varo .set vari
    .endif
.endmacro

.macro nessize nprgrombank_16K, nchrbank_8K, nprgrambank_8K
    .local rom, ram, chr

    ; Note: if rprgrombank_16K is blank or 0, the 1st assert below will fire
    mac_helper__initunitialized rom, 0, nprgrombank_16K
    mac_helper__initunitialized ram, 0, nprgrambank_8K
    mac_helper__initunitialized chr, 0, nchrbank_8K

    .assert rom >= 1 .and rom < 256, error, "nessize: invalid number of PRG-ROM 16K banks"
    .assert chr >= 0 .and chr < 256, error, "nessize: invalid number of CHR 8K banks"
    .assert ram >= 0 .and ram < 256, error, "nessize: invalid number of PRG-RAM 8K banks"

    .export __PRGROM_SZ16K__ : abs = rom
    .export __CHRROM_SZ8K__  : abs = chr
    .export __PRGRAM_SZ8K__  : abs = ram
.endmacro

;-------------------------------------------------------------------------------
.endif ;CONFIGURE_INC

