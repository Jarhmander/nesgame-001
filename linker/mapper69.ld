#
# Linker script for mapper 69 (FME-7 & Sunsoft-5B)
# by Jarhmander (James-Adam Renquinha Henri)
#

SYMBOLS {
    # Import those symbols from nes-header
    __PRGROM_SZ16K__ : type = import, addrsize = abs;
    __CHRROM_SZ8K__ :  type = import, addrsize = abs;

    # Default values for those flags
    __FLAGS9__ :       type = weak, value = 0, addrsize = zp;
    __FLAGS10__ :      type = weak, value = 0, addrsize = zp;

    # Export mapper value for configure.inc
    __CFG_MAPPER__ :   type = export, value = 69, addrsize = zp;

    # Symbols used by the linker script; could be useful outside
    __PRGROM_SZ__ :    type = export, value = $4000 * __PRGROM_SZ16K__;
    __CHRROM_SZ__ :    type = export, value = $2000 * __CHRROM_SZ8K__;
    __PRGRAM_SZ__ :    type = export, value = $2000 * __PRGRAM_SZ8K__;
}

MEMORY {
    # Dummy region: reserved for NES header
    RES_DUMMYNESHEADER:
        start  = 0  size = $10, type = ro;

    PRGROM:
    # Another somewhat dummy region. Use multiples of 16K ($4000)
        start = $0,
        fill = yes,
        size  = __PRGROM_SZ__ - $2000; # last 8K is the fixed bank

    ZEROPAGE:
        start  = 0,    size = 256,  type = rw;
    STACK:
        start  = $100, size = 256,  type = rw;
    NESRAM:
        start  = $200, size = $400, type = rw;
    PPUBUFF:
        start  = $600, size = $100, type = rw;
    OAM:
        start  = $700, size = $100, type = rw;

    EXRAM:
        start  = $6000, size = $2000, type = rw;

    # fixed bank
    # Give it a special reserved bank attribute
    ROMFB0: start = $E000, size = $2000, type = ro, bank = $FFFF;

    # Overlays for rom
    # Very verbose, vim was especially handy here...
    #
    # Bank encoding: 
    #    high byte: load address area (0 = $6000, 1 = $8000, 2 = $A000, 3 = $E000)
    #    low  byte: bank number
    #
    ROMSB00AT6000:   start = $6000, size = $2000, type = ro, bank = $000;
      ROMSB00AT8000: start = $8000, size = $2000, type = ro, bank = $100;
      ROMSB00ATA000: start = $A000, size = $2000, type = ro, bank = $200;
      ROMSB00ATC000: start = $C000, size = $2000, type = ro, bank = $300;
    ROMSB01AT6000:   start = $6000, size = $2000, type = ro, bank = $001;
      ROMSB01AT8000: start = $8000, size = $2000, type = ro, bank = $101;
      ROMSB01ATA000: start = $A000, size = $2000, type = ro, bank = $201;
      ROMSB01ATC000: start = $C000, size = $2000, type = ro, bank = $301;
    ROMSB02AT6000:   start = $6000, size = $2000, type = ro, bank = $002;
      ROMSB02AT8000: start = $8000, size = $2000, type = ro, bank = $102;
      ROMSB02ATA000: start = $A000, size = $2000, type = ro, bank = $202;
      ROMSB02ATC000: start = $C000, size = $2000, type = ro, bank = $302;
    ROMSB03AT6000:   start = $6000, size = $2000, type = ro, bank = $003;
      ROMSB03AT8000: start = $8000, size = $2000, type = ro, bank = $103;
      ROMSB03ATA000: start = $A000, size = $2000, type = ro, bank = $203;
      ROMSB03ATC000: start = $C000, size = $2000, type = ro, bank = $303;
    ROMSB04AT6000:   start = $6000, size = $2000, type = ro, bank = $004;
      ROMSB04AT8000: start = $8000, size = $2000, type = ro, bank = $104;
      ROMSB04ATA000: start = $A000, size = $2000, type = ro, bank = $204;
      ROMSB04ATC000: start = $C000, size = $2000, type = ro, bank = $304;
    ROMSB05AT6000:   start = $6000, size = $2000, type = ro, bank = $005;
      ROMSB05AT8000: start = $8000, size = $2000, type = ro, bank = $105;
      ROMSB05ATA000: start = $A000, size = $2000, type = ro, bank = $205;
      ROMSB05ATC000: start = $C000, size = $2000, type = ro, bank = $305;
    ROMSB06AT6000:   start = $6000, size = $2000, type = ro, bank = $006;
      ROMSB06AT8000: start = $8000, size = $2000, type = ro, bank = $106;
      ROMSB06ATA000: start = $A000, size = $2000, type = ro, bank = $206;
      ROMSB06ATC000: start = $C000, size = $2000, type = ro, bank = $306;
    ROMSB07AT6000:   start = $6000, size = $2000, type = ro, bank = $007;
      ROMSB07AT8000: start = $8000, size = $2000, type = ro, bank = $107;
      ROMSB07ATA000: start = $A000, size = $2000, type = ro, bank = $207;
      ROMSB07ATC000: start = $C000, size = $2000, type = ro, bank = $307;
    ROMSB08AT6000:   start = $6000, size = $2000, type = ro, bank = $008;
      ROMSB08AT8000: start = $8000, size = $2000, type = ro, bank = $108;
      ROMSB08ATA000: start = $A000, size = $2000, type = ro, bank = $208;
      ROMSB08ATC000: start = $C000, size = $2000, type = ro, bank = $308;
    ROMSB09AT6000:   start = $6000, size = $2000, type = ro, bank = $009;
      ROMSB09AT8000: start = $8000, size = $2000, type = ro, bank = $109;
      ROMSB09ATA000: start = $A000, size = $2000, type = ro, bank = $209;
      ROMSB09ATC000: start = $C000, size = $2000, type = ro, bank = $309;
    ROMSB10AT6000:   start = $6000, size = $2000, type = ro, bank = $00a;
      ROMSB10AT8000: start = $8000, size = $2000, type = ro, bank = $10a;
      ROMSB10ATA000: start = $A000, size = $2000, type = ro, bank = $20a;
      ROMSB10ATC000: start = $C000, size = $2000, type = ro, bank = $30a;
    ROMSB11AT6000:   start = $6000, size = $2000, type = ro, bank = $00b;
      ROMSB11AT8000: start = $8000, size = $2000, type = ro, bank = $10b;
      ROMSB11ATA000: start = $A000, size = $2000, type = ro, bank = $20b;
      ROMSB11ATC000: start = $C000, size = $2000, type = ro, bank = $30b;
    ROMSB12AT6000:   start = $6000, size = $2000, type = ro, bank = $00c;
      ROMSB12AT8000: start = $8000, size = $2000, type = ro, bank = $10c;
      ROMSB12ATA000: start = $A000, size = $2000, type = ro, bank = $20c;
      ROMSB12ATC000: start = $C000, size = $2000, type = ro, bank = $30c;
    ROMSB13AT6000:   start = $6000, size = $2000, type = ro, bank = $00d;
      ROMSB13AT8000: start = $8000, size = $2000, type = ro, bank = $10d;
      ROMSB13ATA000: start = $A000, size = $2000, type = ro, bank = $20d;
      ROMSB13ATC000: start = $C000, size = $2000, type = ro, bank = $30d;
    ROMSB14AT6000:   start = $6000, size = $2000, type = ro, bank = $00e;
      ROMSB14AT8000: start = $8000, size = $2000, type = ro, bank = $10e;
      ROMSB14ATA000: start = $A000, size = $2000, type = ro, bank = $20e;
      ROMSB14ATC000: start = $C000, size = $2000, type = ro, bank = $30e;
    ROMSB15AT6000:   start = $6000, size = $2000, type = ro, bank = $00f;
      ROMSB15AT8000: start = $8000, size = $2000, type = ro, bank = $10f;
      ROMSB15ATA000: start = $A000, size = $2000, type = ro, bank = $20f;
      ROMSB15ATC000: start = $C000, size = $2000, type = ro, bank = $30f;
    ROMSB16AT6000:   start = $6000, size = $2000, type = ro, bank = $010;
      ROMSB16AT8000: start = $8000, size = $2000, type = ro, bank = $110;
      ROMSB16ATA000: start = $A000, size = $2000, type = ro, bank = $210;
      ROMSB16ATC000: start = $C000, size = $2000, type = ro, bank = $310;
    ROMSB17AT6000:   start = $6000, size = $2000, type = ro, bank = $011;
      ROMSB17AT8000: start = $8000, size = $2000, type = ro, bank = $111;
      ROMSB17ATA000: start = $A000, size = $2000, type = ro, bank = $211;
      ROMSB17ATC000: start = $C000, size = $2000, type = ro, bank = $311;
    ROMSB18AT6000:   start = $6000, size = $2000, type = ro, bank = $012;
      ROMSB18AT8000: start = $8000, size = $2000, type = ro, bank = $112;
      ROMSB18ATA000: start = $A000, size = $2000, type = ro, bank = $212;
      ROMSB18ATC000: start = $C000, size = $2000, type = ro, bank = $312;
    ROMSB19AT6000:   start = $6000, size = $2000, type = ro, bank = $013;
      ROMSB19AT8000: start = $8000, size = $2000, type = ro, bank = $113;
      ROMSB19ATA000: start = $A000, size = $2000, type = ro, bank = $213;
      ROMSB19ATC000: start = $C000, size = $2000, type = ro, bank = $313;
    ROMSB20AT6000:   start = $6000, size = $2000, type = ro, bank = $014;
      ROMSB20AT8000: start = $8000, size = $2000, type = ro, bank = $114;
      ROMSB20ATA000: start = $A000, size = $2000, type = ro, bank = $214;
      ROMSB20ATC000: start = $C000, size = $2000, type = ro, bank = $314;
    ROMSB21AT6000:   start = $6000, size = $2000, type = ro, bank = $015;
      ROMSB21AT8000: start = $8000, size = $2000, type = ro, bank = $115;
      ROMSB21ATA000: start = $A000, size = $2000, type = ro, bank = $215;
      ROMSB21ATC000: start = $C000, size = $2000, type = ro, bank = $315;
    ROMSB22AT6000:   start = $6000, size = $2000, type = ro, bank = $016;
      ROMSB22AT8000: start = $8000, size = $2000, type = ro, bank = $116;
      ROMSB22ATA000: start = $A000, size = $2000, type = ro, bank = $216;
      ROMSB22ATC000: start = $C000, size = $2000, type = ro, bank = $316;
    ROMSB23AT6000:   start = $6000, size = $2000, type = ro, bank = $017;
      ROMSB23AT8000: start = $8000, size = $2000, type = ro, bank = $117;
      ROMSB23ATA000: start = $A000, size = $2000, type = ro, bank = $217;
      ROMSB23ATC000: start = $C000, size = $2000, type = ro, bank = $317;
    ROMSB24AT6000:   start = $6000, size = $2000, type = ro, bank = $018;
      ROMSB24AT8000: start = $8000, size = $2000, type = ro, bank = $118;
      ROMSB24ATA000: start = $A000, size = $2000, type = ro, bank = $218;
      ROMSB24ATC000: start = $C000, size = $2000, type = ro, bank = $318;
    ROMSB25AT6000:   start = $6000, size = $2000, type = ro, bank = $019;
      ROMSB25AT8000: start = $8000, size = $2000, type = ro, bank = $119;
      ROMSB25ATA000: start = $A000, size = $2000, type = ro, bank = $219;
      ROMSB25ATC000: start = $C000, size = $2000, type = ro, bank = $319;
    ROMSB26AT6000:   start = $6000, size = $2000, type = ro, bank = $01a;
      ROMSB26AT8000: start = $8000, size = $2000, type = ro, bank = $11a;
      ROMSB26ATA000: start = $A000, size = $2000, type = ro, bank = $21a;
      ROMSB26ATC000: start = $C000, size = $2000, type = ro, bank = $31a;
    ROMSB27AT6000:   start = $6000, size = $2000, type = ro, bank = $01b;
      ROMSB27AT8000: start = $8000, size = $2000, type = ro, bank = $11b;
      ROMSB27ATA000: start = $A000, size = $2000, type = ro, bank = $21b;
      ROMSB27ATC000: start = $C000, size = $2000, type = ro, bank = $31b;
    ROMSB28AT6000:   start = $6000, size = $2000, type = ro, bank = $01c;
      ROMSB28AT8000: start = $8000, size = $2000, type = ro, bank = $11c;
      ROMSB28ATA000: start = $A000, size = $2000, type = ro, bank = $21c;
      ROMSB28ATC000: start = $C000, size = $2000, type = ro, bank = $31c;
    ROMSB29AT6000:   start = $6000, size = $2000, type = ro, bank = $01d;
      ROMSB29AT8000: start = $8000, size = $2000, type = ro, bank = $11d;
      ROMSB29ATA000: start = $A000, size = $2000, type = ro, bank = $21d;
      ROMSB29ATC000: start = $C000, size = $2000, type = ro, bank = $31d;
    ROMSB30AT6000:   start = $6000, size = $2000, type = ro, bank = $01e;
      ROMSB30AT8000: start = $8000, size = $2000, type = ro, bank = $11e;
      ROMSB30ATA000: start = $A000, size = $2000, type = ro, bank = $21e;
      ROMSB30ATC000: start = $C000, size = $2000, type = ro, bank = $31e;
    ROMSB31AT6000:   start = $6000, size = $2000, type = ro, bank = $01f;
      ROMSB31AT8000: start = $8000, size = $2000, type = ro, bank = $11f;
      ROMSB31ATA000: start = $A000, size = $2000, type = ro, bank = $21f;
      ROMSB31ATC000: start = $C000, size = $2000, type = ro, bank = $31f;
    ROMSB32AT6000:   start = $6000, size = $2000, type = ro, bank = $020;
      ROMSB32AT8000: start = $8000, size = $2000, type = ro, bank = $120;
      ROMSB32ATA000: start = $A000, size = $2000, type = ro, bank = $220;
      ROMSB32ATC000: start = $C000, size = $2000, type = ro, bank = $320;
    ROMSB33AT6000:   start = $6000, size = $2000, type = ro, bank = $021;
      ROMSB33AT8000: start = $8000, size = $2000, type = ro, bank = $121;
      ROMSB33ATA000: start = $A000, size = $2000, type = ro, bank = $221;
      ROMSB33ATC000: start = $C000, size = $2000, type = ro, bank = $321;
    ROMSB34AT6000:   start = $6000, size = $2000, type = ro, bank = $022;
      ROMSB34AT8000: start = $8000, size = $2000, type = ro, bank = $122;
      ROMSB34ATA000: start = $A000, size = $2000, type = ro, bank = $222;
      ROMSB34ATC000: start = $C000, size = $2000, type = ro, bank = $322;
    ROMSB35AT6000:   start = $6000, size = $2000, type = ro, bank = $023;
      ROMSB35AT8000: start = $8000, size = $2000, type = ro, bank = $123;
      ROMSB35ATA000: start = $A000, size = $2000, type = ro, bank = $223;
      ROMSB35ATC000: start = $C000, size = $2000, type = ro, bank = $323;
    ROMSB36AT6000:   start = $6000, size = $2000, type = ro, bank = $024;
      ROMSB36AT8000: start = $8000, size = $2000, type = ro, bank = $124;
      ROMSB36ATA000: start = $A000, size = $2000, type = ro, bank = $224;
      ROMSB36ATC000: start = $C000, size = $2000, type = ro, bank = $324;
    ROMSB37AT6000:   start = $6000, size = $2000, type = ro, bank = $025;
      ROMSB37AT8000: start = $8000, size = $2000, type = ro, bank = $125;
      ROMSB37ATA000: start = $A000, size = $2000, type = ro, bank = $225;
      ROMSB37ATC000: start = $C000, size = $2000, type = ro, bank = $325;
    ROMSB38AT6000:   start = $6000, size = $2000, type = ro, bank = $026;
      ROMSB38AT8000: start = $8000, size = $2000, type = ro, bank = $126;
      ROMSB38ATA000: start = $A000, size = $2000, type = ro, bank = $226;
      ROMSB38ATC000: start = $C000, size = $2000, type = ro, bank = $326;
    ROMSB39AT6000:   start = $6000, size = $2000, type = ro, bank = $027;
      ROMSB39AT8000: start = $8000, size = $2000, type = ro, bank = $127;
      ROMSB39ATA000: start = $A000, size = $2000, type = ro, bank = $227;
      ROMSB39ATC000: start = $C000, size = $2000, type = ro, bank = $327;
    ROMSB40AT6000:   start = $6000, size = $2000, type = ro, bank = $028;
      ROMSB40AT8000: start = $8000, size = $2000, type = ro, bank = $128;
      ROMSB40ATA000: start = $A000, size = $2000, type = ro, bank = $228;
      ROMSB40ATC000: start = $C000, size = $2000, type = ro, bank = $328;
    ROMSB41AT6000:   start = $6000, size = $2000, type = ro, bank = $029;
      ROMSB41AT8000: start = $8000, size = $2000, type = ro, bank = $129;
      ROMSB41ATA000: start = $A000, size = $2000, type = ro, bank = $229;
      ROMSB41ATC000: start = $C000, size = $2000, type = ro, bank = $329;
    ROMSB42AT6000:   start = $6000, size = $2000, type = ro, bank = $02a;
      ROMSB42AT8000: start = $8000, size = $2000, type = ro, bank = $12a;
      ROMSB42ATA000: start = $A000, size = $2000, type = ro, bank = $22a;
      ROMSB42ATC000: start = $C000, size = $2000, type = ro, bank = $32a;
    ROMSB43AT6000:   start = $6000, size = $2000, type = ro, bank = $02b;
      ROMSB43AT8000: start = $8000, size = $2000, type = ro, bank = $12b;
      ROMSB43ATA000: start = $A000, size = $2000, type = ro, bank = $22b;
      ROMSB43ATC000: start = $C000, size = $2000, type = ro, bank = $32b;
    ROMSB44AT6000:   start = $6000, size = $2000, type = ro, bank = $02c;
      ROMSB44AT8000: start = $8000, size = $2000, type = ro, bank = $12c;
      ROMSB44ATA000: start = $A000, size = $2000, type = ro, bank = $22c;
      ROMSB44ATC000: start = $C000, size = $2000, type = ro, bank = $32c;
    ROMSB45AT6000:   start = $6000, size = $2000, type = ro, bank = $02d;
      ROMSB45AT8000: start = $8000, size = $2000, type = ro, bank = $12d;
      ROMSB45ATA000: start = $A000, size = $2000, type = ro, bank = $22d;
      ROMSB45ATC000: start = $C000, size = $2000, type = ro, bank = $32d;
    ROMSB46AT6000:   start = $6000, size = $2000, type = ro, bank = $02e;
      ROMSB46AT8000: start = $8000, size = $2000, type = ro, bank = $12e;
      ROMSB46ATA000: start = $A000, size = $2000, type = ro, bank = $22e;
      ROMSB46ATC000: start = $C000, size = $2000, type = ro, bank = $32e;
    ROMSB47AT6000:   start = $6000, size = $2000, type = ro, bank = $02f;
      ROMSB47AT8000: start = $8000, size = $2000, type = ro, bank = $12f;
      ROMSB47ATA000: start = $A000, size = $2000, type = ro, bank = $22f;
      ROMSB47ATC000: start = $C000, size = $2000, type = ro, bank = $32f;
    ROMSB48AT6000:   start = $6000, size = $2000, type = ro, bank = $030;
      ROMSB48AT8000: start = $8000, size = $2000, type = ro, bank = $130;
      ROMSB48ATA000: start = $A000, size = $2000, type = ro, bank = $230;
      ROMSB48ATC000: start = $C000, size = $2000, type = ro, bank = $330;
    ROMSB49AT6000:   start = $6000, size = $2000, type = ro, bank = $031;
      ROMSB49AT8000: start = $8000, size = $2000, type = ro, bank = $131;
      ROMSB49ATA000: start = $A000, size = $2000, type = ro, bank = $231;
      ROMSB49ATC000: start = $C000, size = $2000, type = ro, bank = $331;
    ROMSB50AT6000:   start = $6000, size = $2000, type = ro, bank = $032;
      ROMSB50AT8000: start = $8000, size = $2000, type = ro, bank = $132;
      ROMSB50ATA000: start = $A000, size = $2000, type = ro, bank = $232;
      ROMSB50ATC000: start = $C000, size = $2000, type = ro, bank = $332;
    ROMSB51AT6000:   start = $6000, size = $2000, type = ro, bank = $033;
      ROMSB51AT8000: start = $8000, size = $2000, type = ro, bank = $133;
      ROMSB51ATA000: start = $A000, size = $2000, type = ro, bank = $233;
      ROMSB51ATC000: start = $C000, size = $2000, type = ro, bank = $333;
    ROMSB52AT6000:   start = $6000, size = $2000, type = ro, bank = $034;
      ROMSB52AT8000: start = $8000, size = $2000, type = ro, bank = $134;
      ROMSB52ATA000: start = $A000, size = $2000, type = ro, bank = $234;
      ROMSB52ATC000: start = $C000, size = $2000, type = ro, bank = $334;
    ROMSB53AT6000:   start = $6000, size = $2000, type = ro, bank = $035;
      ROMSB53AT8000: start = $8000, size = $2000, type = ro, bank = $135;
      ROMSB53ATA000: start = $A000, size = $2000, type = ro, bank = $235;
      ROMSB53ATC000: start = $C000, size = $2000, type = ro, bank = $335;
    ROMSB54AT6000:   start = $6000, size = $2000, type = ro, bank = $036;
      ROMSB54AT8000: start = $8000, size = $2000, type = ro, bank = $136;
      ROMSB54ATA000: start = $A000, size = $2000, type = ro, bank = $236;
      ROMSB54ATC000: start = $C000, size = $2000, type = ro, bank = $336;
    ROMSB55AT6000:   start = $6000, size = $2000, type = ro, bank = $037;
      ROMSB55AT8000: start = $8000, size = $2000, type = ro, bank = $137;
      ROMSB55ATA000: start = $A000, size = $2000, type = ro, bank = $237;
      ROMSB55ATC000: start = $C000, size = $2000, type = ro, bank = $337;
    ROMSB56AT6000:   start = $6000, size = $2000, type = ro, bank = $038;
      ROMSB56AT8000: start = $8000, size = $2000, type = ro, bank = $138;
      ROMSB56ATA000: start = $A000, size = $2000, type = ro, bank = $238;
      ROMSB56ATC000: start = $C000, size = $2000, type = ro, bank = $338;
    ROMSB57AT6000:   start = $6000, size = $2000, type = ro, bank = $039;
      ROMSB57AT8000: start = $8000, size = $2000, type = ro, bank = $139;
      ROMSB57ATA000: start = $A000, size = $2000, type = ro, bank = $239;
      ROMSB57ATC000: start = $C000, size = $2000, type = ro, bank = $339;
    ROMSB58AT6000:   start = $6000, size = $2000, type = ro, bank = $03a;
      ROMSB58AT8000: start = $8000, size = $2000, type = ro, bank = $13a;
      ROMSB58ATA000: start = $A000, size = $2000, type = ro, bank = $23a;
      ROMSB58ATC000: start = $C000, size = $2000, type = ro, bank = $33a;
    ROMSB59AT6000:   start = $6000, size = $2000, type = ro, bank = $03b;
      ROMSB59AT8000: start = $8000, size = $2000, type = ro, bank = $13b;
      ROMSB59ATA000: start = $A000, size = $2000, type = ro, bank = $23b;
      ROMSB59ATC000: start = $C000, size = $2000, type = ro, bank = $33b;
    ROMSB60AT6000:   start = $6000, size = $2000, type = ro, bank = $03c;
      ROMSB60AT8000: start = $8000, size = $2000, type = ro, bank = $13c;
      ROMSB60ATA000: start = $A000, size = $2000, type = ro, bank = $23c;
      ROMSB60ATC000: start = $C000, size = $2000, type = ro, bank = $33c;
    ROMSB61AT6000:   start = $6000, size = $2000, type = ro, bank = $03d;
      ROMSB61AT8000: start = $8000, size = $2000, type = ro, bank = $13d;
      ROMSB61ATA000: start = $A000, size = $2000, type = ro, bank = $23d;
      ROMSB61ATC000: start = $C000, size = $2000, type = ro, bank = $33d;
    ROMSB62AT6000:   start = $6000, size = $2000, type = ro, bank = $03e;
      ROMSB62AT8000: start = $8000, size = $2000, type = ro, bank = $13e;
      ROMSB62ATA000: start = $A000, size = $2000, type = ro, bank = $23e;
      ROMSB62ATC000: start = $C000, size = $2000, type = ro, bank = $33e;
    ROMSB63AT6000:   start = $6000, size = $2000, type = ro, bank = $03f;
      ROMSB63AT8000: start = $8000, size = $2000, type = ro, bank = $13f;
      ROMSB63ATA000: start = $A000, size = $2000, type = ro, bank = $23f;
      ROMSB63ATC000: start = $C000, size = $2000, type = ro, bank = $33f;

    CHRROM:
    # Another somewhat dummy region. Use multiples of 8K ($2000)
        start = $10000000,
        size  = __CHRROM_SZ__,
        fill  = yes;
}

SEGMENTS {
    # RAM segments
    REG:      load = ZEROPAGE, type = zp;
    ZEROPAGE: load = ZEROPAGE, type = zp;
    BSS:      load = NESRAM,   type = bss, define = yes;
    EXRAM:    load = EXRAM,    type = bss, optional = yes;
    PPUBUFF:  load = PPUBUFF,  type = bss;
    OAM:      load = OAM,      type = bss;

    # Mandatory NES header
    NESHEADER:  load = RES_DUMMYNESHEADER,   type = ro;

    # The various PRG banks, one may change the run address to another ROMSB0ATx000 
    PRGBK00:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB00AT8000;
    DATA:     load = PRGROM, run = NESRAM, type = rw, define = yes;
    EXDATA:   load = PRGROM, run = EXRAM,  type = rw, define = yes, optional = yes;
              
    PRGBK01:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB01ATC000;
    PRGBK02:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB02AT8000;
    PRGBK03:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB03AT8000;
    PRGBK04:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB04AT8000;
    PRGBK05:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB05AT8000;
    PRGBK06:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB06AT8000;
    PRGBK07:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB07AT8000;
    PRGBK08:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB08AT8000;
    PRGBK09:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB09AT8000;
    PRGBK10:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB10AT8000;
    PRGBK11:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB11AT8000;
    PRGBK12:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB12AT8000;
    PRGBK13:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB13AT8000;
    PRGBK14:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB14AT8000;
    PRGBK15:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB15AT8000;
    PRGBK16:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB16AT8000;
    PRGBK17:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB17AT8000;
    PRGBK18:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB18AT8000;
    PRGBK19:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB19AT8000;
    PRGBK20:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB20AT8000;
    PRGBK21:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB21AT8000;
    PRGBK22:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB22AT8000;
    PRGBK23:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB23AT8000;
    PRGBK24:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB24AT8000;
    PRGBK25:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB25AT8000;
    PRGBK26:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB26AT8000;
    PRGBK27:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB27AT8000;
    PRGBK28:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB28AT8000;
    PRGBK29:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB29AT8000;
    PRGBK30:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB30AT8000;
    PRGBK31:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB31AT8000;
    PRGBK32:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB32AT8000;
    PRGBK33:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB33AT8000;
    PRGBK34:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB34AT8000;
    PRGBK35:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB35AT8000;
    PRGBK36:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB36AT8000;
    PRGBK37:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB37AT8000;
    PRGBK38:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB38AT8000;
    PRGBK39:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB39AT8000;
    PRGBK40:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB40AT8000;
    PRGBK41:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB41AT8000;
    PRGBK42:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB42AT8000;
    PRGBK43:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB43AT8000;
    PRGBK44:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB44AT8000;
    PRGBK45:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB45AT8000;
    PRGBK46:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB46AT8000;
    PRGBK47:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB47AT8000;
    PRGBK48:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB48AT8000;
    PRGBK49:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB49AT8000;
    PRGBK50:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB50AT8000;
    PRGBK51:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB51AT8000;
    PRGBK52:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB52AT8000;
    PRGBK53:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB53AT8000;
    PRGBK54:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB54AT8000;
    PRGBK55:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB55AT8000;
    PRGBK56:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB56AT8000;
    PRGBK57:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB57AT8000;
    PRGBK58:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB58AT8000;
    PRGBK59:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB59AT8000;
    PRGBK60:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB60AT8000;
    PRGBK61:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB61AT8000;
    PRGBK62:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB62AT8000;
    PRGBK63:  load = PRGROM, type = ro, define = yes, align_load = $2000, align = $2000, optional = yes, run = ROMSB63AT8000;

    # Fixed last PRG-ROM bank
    # The DATA segment can be moved to PRGBK00.
    DMCBYTE:    load = ROMFB0, run = ROMFB0, type = ro, align = $2000;
    RODATA:     load = ROMFB0, run = ROMFB0, type = ro;
#    DATA:       load = ROMFB0, run = NESRAM, type = rw, define = yes;
    CODE:       load = ROMFB0, run = ROMFB0, type = ro;
    VECTORS:    load = ROMFB0, run = ROMFB0, type = ro, offset = $1FFA;

    # CHR-ROM segments...
    # ... We assume an external tool will deal with banking, so we do not here.
    CHRROM:     load = CHRROM, type = ro, optional = yes;
}

# features:
FEATURES {
    CONDES:     segment = PRGBK00,
                type    = constructor,
                order   = increasing,
                label   = __CONSTRUCTOR_TABLE__,
                count   = __CONSTRUCTOR_COUNT__;
}

