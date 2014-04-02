
.repeat 64,I
.import .ident(.sprintf("__PRGBK%02d_LOAD__",I))
.import .ident(.sprintf("__PRGBK%02d_SIZE__",I))

    .segment .sprintf("PRGBK%02d",I)

.assert .ident(.sprintf("__PRGBK%02d_SIZE__",I)) = 0 .or .ident(.sprintf("__PRGBK%02d_LOAD__",I)) = (I << 13), lderror, .sprintf("checkbanks: bank %d expected at 0x%08X", I, (I << 13))

.endrepeat
