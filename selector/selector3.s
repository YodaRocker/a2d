;;; ============================================================
;;; Loader
;;; ============================================================

        .org $2000

;;; Loads the Invoker (page 2/3), Selector App (at $4000...$9FFF),
;;; and Resources (Aux LC), then invokes the app.

.scope

        jmp     start

        resources_load_addr := $3400
        resources_final_addr := $D000

        ;; ProDOS parameter blocks

        DEFINE_OPEN_PARAMS open_params, str_selector, $3000
        DEFINE_READ_PARAMS read_params1, INVOKER, $160
        DEFINE_READ_PARAMS read_params2, MGTK, $6000
        DEFINE_READ_PARAMS read_params3, resources_load_addr, $800

        DEFINE_SET_MARK_PARAMS set_mark_params, $600
        DEFINE_CLOSE_PARAMS close_params

str_selector:
        PASCAL_STRING "Selector"

.macro  WRAPPED_MLI_CALL op, params
        php
        sei
        MLI_CALL op, params
        plp
        and     #$FF            ; restore Z flag
.endmacro

start:
        ;; Clear ProDOS memory bitmap
        lda     #0
        ldx     #$17
:       sta     BITMAP+1,x
        dex
        bpl     :-

        ;; Open up Selectot itself
        WRAPPED_MLI_CALL OPEN, open_params
        beq     L2049
        brk

L2049:  lda     open_params::ref_num
        sta     set_mark_params::ref_num
        sta     read_params1::ref_num
        sta     read_params2::ref_num
        sta     read_params3::ref_num

        ;; Read various segments into final or temp locations
        WRAPPED_MLI_CALL SET_MARK, set_mark_params
        beq     :+
        brk
:       WRAPPED_MLI_CALL READ, read_params1
        beq     :+
        brk
:       WRAPPED_MLI_CALL READ, read_params2
        beq     :+
        brk
:       WRAPPED_MLI_CALL READ, read_params3
        beq     :+
        brk
:
        ;; Copy Resources segment to Aux LC1
        sta     ALTZPON
        lda     LCBANK1
        lda     LCBANK1

        ldx     #0
:       .repeat 8, i
        lda     resources_load_addr + ($100 * i),x
        sta     resources_final_addr + ($100 * i),x
        .endrepeat
        inx
        bne     :-

        sta     ALTZPOFF
        sta     ROMIN2

        WRAPPED_MLI_CALL CLOSE, close_params

        ;; Invoke the Selector application
        jmp     START

.endscope

        .incbin "inc/junk.dat"

        ASSERT_ADDRESS $2200
