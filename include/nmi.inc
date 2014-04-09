.ifndef NMI_INC
NMI_INC = 1
;-------------------------------------------------------------------------------


.globalzp frame_cnt     ; word-sized
                        ; code should not modify this

.global wait_vblank

;-------------------------------------------------------------------------------
.endif ; NMI_INC
