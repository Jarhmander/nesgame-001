.ifndef CONTROLLER_INC
CONTROLLER_INC = 1
;-------------------------------------------------------------------------------

.globalzp btn_down, btn_toggle, btn_press, btn_release

; Routines
; uint8_t read_controller(uint8_t controller) __nmi__
.global read_controller

; void update_controller(void) __nmi__
.global update_controller

;-------------------------------------------------------------------------------
.endif ; CONTROLLER_INC
