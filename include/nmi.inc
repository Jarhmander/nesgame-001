.ifndef NMI_INC
NMI_INC = 1
;-------------------------------------------------------------------------------


.globalzp frame_cnt     ; word-sized
                        ; code should not modify this

; Routines
; void wait_vblank(void) __noclobber__
.global wait_vblank

; void wait_vblank_setppumask(uint8_t ppumask) __noclobber__
.global wait_vblank_setppumask

;-------------------------------------------------------------------------------
.endif ; NMI_INC
