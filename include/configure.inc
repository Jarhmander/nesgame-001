.ifndef CONFIGURE_INC
CONFIGURE_INC = 1
;-------------------------------------------------------------------------------
.include "nes-header.inc"
;-------------------------------------------------------------------------------

;
; Macros to configure the NES file.
;
; They should both be used exactly *once* in *one* translation unit 
; (read: `.s' file), otherwise you'll get linker errors.
; Evoke them in the top of `main.s', for example.
;

;;******************************************************************************
; nesconfig mirroring, mapper, batterybackedsram
;
;  Configure mirroring, mapper and battery backed sram option for the NES file.
;
;   mirroring : configure the mirroring.
;               vert | vertical   => vertical mirroring
;               horz | horizontal => horizontal mirroring
;               4    | 4-screen   => 4-screen mirroring
;               Note: for some mapper numbers, the horizontal/vertical 
;               mirroring selection is irrelevant.
;
;   mapper    : mapper number, 0 <= mapper < 256
;               Note: if your linker script doesn't match the choosen mapper,
;               you'll get an error; use the right linker script.
;
;   batterybackedsram
;             : is SRAM, if present, is battery backed?
;               off | no  => not battery backed
;               on  | yes => battery backed (need a .sav file in PowerPak)
;               Note: if not specified, default to "off".
;
;   Example:
;
;     nesconfig vert, 0     ; vertical mirroring, mapper 0, no battery backup
;
                   
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

    .if .blank(batterybackedsram) .or .xmatch(batterybackedsram,off) .or .xmatch(batterybackedsram,no)
        ; ok, do nothing!
    .elseif .xmatch(batterybackedsram,on) .or .xmatch(batterybackedsram,yes)
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

;;******************************************************************************
; nessize nprgrombank_16K, nchrbank_8K, nprgrambank_8K
;
;  Configure the size of the resulting NES file. The first argument is 
;  mandatory, the others are optional and default to 0.
;
;   nprgrombank_16K :
;                   Size of PRG-ROM in 16K units, 1 <= value < 256
;
;   nchrbank_8K   : Size of CHR-ROM/RAM in 8K units, 0 <= value < 256
;                   Note: if 0, it means there is 8K of CHR-RAM.
;
;   nprgrambank_8K: Size of PRG-RAM in 8K units, 0 <= value < 256
;                   Note: "For compatibility",  0 still means 8K, for an
;                   emulator. However, one should not use SRAM if this value is
;                   0; if you really want 8K of SRAM, put 1 here.
;
;   Example:
;
;     nessize 1,0,0     ; 16K PRG-ROM, 8K CHR-RAM, no PRG-RAM (see above)
;

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

; Helper macro
; TODO: should be moved to a file containing similar helper macros
.macro mac_helper__initunitialized varo, init, vari
    .if .blank (vari)
        varo .set init
    .else
        varo .set vari
    .endif
.endmacro

;-------------------------------------------------------------------------------
.endif ;CONFIGURE_INC

