.include "core.inc"
;-------------------------------------------------------------------------------

.segment "REG" : zeropage

r0:     .res 1
r1:     .res 1
r2:     .res 1
r3:     .res 1
r4:     .res 1
r5:     .res 1
r6:     .res 1
r7:     .res 1
r8:     .res 1
r9:     .res 1
r10:    .res 1
r11:    .res 1
r12:    .res 1
r13:    .res 1
r14:    .res 1
r15:    .res 1

n0:     .res 1
n1:     .res 1
n2:     .res 1
n3:     .res 1
n4:     .res 1
n5:     .res 1
n6:     .res 1
n7:     .res 1

i0:     .res 1
i1:     .res 1
i2:     .res 1
i3:     .res 1
i4:     .res 1
i5:     .res 1
i6:     .res 1
i7:     .res 1

    .segment "VECTORS"
.addr nmi, reset, irq

;-------------------------------------------------------------------------------

