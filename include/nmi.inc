.ifndef NMI_INC
NMI_INC = 1
;-------------------------------------------------------------------------------


.globalzp frame_cnt     ; word-sized
                        ; code should not modify this

.global wait_vblank
.global wait_vblank_setppumask

;-------------------------------------------------------------------------------
.endif ; NMI_INC
