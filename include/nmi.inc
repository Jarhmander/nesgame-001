.ifndef NMI_INC
NMI_INC = 1
;-------------------------------------------------------------------------------


.globalzp frame_cnt     ; word-sized
                        ; code should not modify this

.globalzp nmi2irq_time  ; word-sized
                        ; Basically, it's what get reloaded in FME-7 IRQ counter
                        ; at the start of the NMI routine.
; Routines
; void wait_vblank(void) __noclobber__
.global wait_vblank

; void wait_vblank_setppumask(uint8_t ppumask) __noclobber__
.global wait_vblank_setppumask

;-------------------------------------------------------------------------------
.endif ; NMI_INC
