;;; ============================================================
;;; Overlay for Selector Edit - drives File Picker dialog
;;;
;;; Compiled as part of desktop.s
;;; ============================================================

.proc selector_overlay
        .org $7000

.proc init
        stx     which_run_list
        sty     copy_when
        jsr     file_dialog::create_common_dialog
        jsr     L7101
        jsr     L70AD
        jsr     file_dialog::device_on_line
        lda     path_buf0
        beq     L7056
        ldy     path_buf0
L7021:  lda     path_buf0,y
        sta     file_dialog::path_buf,y
        dey
        bpl     L7021
        jsr     file_dialog::L5F49
        ldy     path_buf0
L7030:  lda     path_buf0,y
        cmp     #'/'
        beq     L7044
        dey
        cpy     #$01
        bne     L7030
        lda     #$00
        sta     path_buf0
        jmp     L7056

L7044:  ldx     #$00
L7046:  iny
        inx
        lda     path_buf0,y
        sta     L709D,x
        cpy     path_buf0
        bne     L7046
        stx     L709D
L7056:  jsr     file_dialog::L5F5B
        lda     #$00
        bcs     L706A
        addr_call file_dialog::L6516, L709D
        sta     selected_index
        jsr     file_dialog::L6586
L706A:  jsr     file_dialog::update_scrollbar2
        jsr     file_dialog::update_disk_name
        jsr     file_dialog::draw_list_entries
        lda     path_buf0
        bne     L707B
        jsr     file_dialog::jt_prep_path
L707B:  copy    #1, path_buf2
        copy    #' ', path_buf2+1
        jsr     file_dialog::jt_redraw_input
        jsr     file_dialog::redraw_f2
        copy    #1, path_buf2
        copy    #' ', path_buf2+1
        lda     #$FF
        sta     LD8EC
        jmp     file_dialog::event_loop

L709D:  .res 16, 0

.endproc

;;; ============================================================

.proc L70AD
        ldx     jt_pathname
L70B0:  lda     jt_pathname+1,x
        sta     file_dialog::jump_table,x
        dex
        lda     jt_pathname+1,x
        sta     file_dialog::jump_table,x
        dex
        dex
        bpl     L70B0
        lda     #$00
        sta     file_dialog::L51AE
        lda     #$80
        sta     file_dialog::L5104
        copy    #1, path_buf2
        copy    #kGlyphInsertionPoint, path_buf2+1
        lda     winfo_file_dialog
        jsr     file_dialog::set_port_for_window
        lda     which_run_list
        jsr     toggle_run_list_button
        lda     copy_when
        jsr     toggle_copy_when_button
        lda     #$80
        sta     file_dialog::L5103
        copy16  #handle_click, file_dialog::click_handler_hook+1
        copy16  #handle_key, file_dialog::handle_key::key_meta_digit+1
        rts
.endproc

;;; ============================================================

.proc L7101
        lda     winfo_file_dialog
        jsr     file_dialog::set_port_for_window
        lda     path_buf0
        beq     L7116
        addr_call file_dialog::L5E0A, edit_an_entry_label
        jmp     L711D

L7116:  addr_call file_dialog::L5E0A, add_an_entry_label
L711D:  addr_call file_dialog::L5E6F, enter_the_full_pathname_label2
        MGTK_RELAY_CALL MGTK::SetPenMode, penXOR ; penXOR
        MGTK_RELAY_CALL MGTK::FrameRect, file_dialog_res::input1_rect
        MGTK_RELAY_CALL MGTK::FrameRect, file_dialog_res::input2_rect
        addr_call file_dialog::L5E57, enter_the_full_pathname_label1
        addr_call file_dialog::L5E6F, enter_the_name_to_appear_label
        MGTK_RELAY_CALL MGTK::MoveTo, pos_add_a_new_entry_to_label
        addr_call file_dialog::draw_string, add_a_new_entry_to_label
        MGTK_RELAY_CALL MGTK::MoveTo, pos_run_list_label
        addr_call file_dialog::draw_string, run_list_label
        MGTK_RELAY_CALL MGTK::MoveTo, pos_other_run_list_label
        addr_call file_dialog::draw_string, other_run_list_label
        MGTK_RELAY_CALL MGTK::MoveTo, pos_down_load_label
        addr_call file_dialog::draw_string, down_load_label
        MGTK_RELAY_CALL MGTK::MoveTo, pos_at_first_boot_label
        addr_call file_dialog::draw_string, at_first_boot_label
        MGTK_RELAY_CALL MGTK::MoveTo, pos_at_first_use_label
        addr_call file_dialog::draw_string, at_first_use_label
        MGTK_RELAY_CALL MGTK::MoveTo, pos_never_label
        addr_call file_dialog::draw_string, never_label
        MGTK_RELAY_CALL MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL MGTK::FrameRect, rect_run_list_radiobtn
        MGTK_RELAY_CALL MGTK::FrameRect, rect_other_run_list_radiobtn
        MGTK_RELAY_CALL MGTK::FrameRect, rect_at_first_boot_radiobtn
        MGTK_RELAY_CALL MGTK::FrameRect, rect_at_first_use_radiobtn
        MGTK_RELAY_CALL MGTK::FrameRect, rect_never_radiobtn
        MGTK_RELAY_CALL MGTK::InitPort, main_grafport
        MGTK_RELAY_CALL MGTK::SetPort, main_grafport
        rts
.endproc

;;; ============================================================

        ;; Unused
        .byte   0

jt_pathname:
        .byte file_dialog::kJumpTableSize-1
        jump_table_entry handle_ok_filename
        jump_table_entry handle_cancel_filename
        jump_table_entry file_dialog::blink_f1_ip
        jump_table_entry file_dialog::redraw_f1
        jump_table_entry file_dialog::strip_f1_path_segment
        jump_table_entry file_dialog::handle_f1_selection_change
        jump_table_entry file_dialog::prep_path_buf0
        jump_table_entry file_dialog::handle_f1_other_key
        jump_table_entry file_dialog::handle_f1_delete_key
        jump_table_entry file_dialog::handle_f1_left_key
        jump_table_entry file_dialog::handle_f1_right_key
        jump_table_entry file_dialog::handle_f1_meta_left_key
        jump_table_entry file_dialog::handle_f1_meta_right_key
        jump_table_entry file_dialog::handle_f1_click
        .assert * - jt_pathname = file_dialog::kJumpTableSize+1, error, "Table size error"

jt_entry_name:
        .byte file_dialog::kJumpTableSize-1
        jump_table_entry handle_ok_name
        jump_table_entry handle_cancel_name
        jump_table_entry file_dialog::blink_f2_ip
        jump_table_entry file_dialog::redraw_f2
        jump_table_entry file_dialog::strip_f2_path_segment
        jump_table_entry file_dialog::handle_f2_selection_change
        jump_table_entry file_dialog::prep_path_buf1
        jump_table_entry file_dialog::handle_f2_other_key
        jump_table_entry file_dialog::handle_f2_delete_key
        jump_table_entry file_dialog::handle_f2_left_key
        jump_table_entry file_dialog::handle_f2_right_key
        jump_table_entry file_dialog::handle_f2_meta_left_key
        jump_table_entry file_dialog::handle_f2_meta_right_key
        jump_table_entry file_dialog::handle_f2_click
        .assert * - jt_entry_name = file_dialog::kJumpTableSize+1, error, "Table size error"

;;; ============================================================

.proc handle_ok_filename
        copy    #1, path_buf2
        copy    #' ', path_buf2+1
        jsr     file_dialog::jt_redraw_input
        ldx     jt_entry_name
L726D:  lda     jt_entry_name+1,x
        sta     file_dialog::jump_table,x
        dex
        lda     jt_entry_name+1,x
        sta     file_dialog::jump_table,x
        dex
        dex
        bpl     L726D
        lda     #$80
        sta     file_dialog::L51AE
        sta     file_dialog::L5105
        lda     LD8F0
        sta     LD8F1
        lda     #$00
        sta     LD8F0
        lda     path_buf1
        bne     L72BF
        lda     #$00
        sta     path_buf1
        ldx     path_buf0
        beq     L72BF
L72A0:  lda     path_buf0,x
        cmp     #'/'
        beq     L72AD
        dex
        bne     L72A0
        jmp     L72BF

L72AD:  ldy     #0
:       iny
        inx
        lda     path_buf0,x
        sta     path_buf1,y
        cpx     path_buf0
        bne     :-

        sty     path_buf1
L72BF:  copy    #1, path_buf2
        copy    #kGlyphInsertionPoint, path_buf2+1
        jsr     file_dialog::jt_redraw_input
        rts
.endproc

;;; ============================================================
;;; Close window and finish (via saved_stack) if OK
;;; Outputs: A = 0 if OK
;;;          X = which run list (1=run list, 2=other run list)
;;;          Y = copy when (1=boot, 2=use, 3=never)

.proc handle_ok_name
        addr_call file_dialog::L647C, path_buf0
        bne     L72E2
        lda     path_buf1
        beq     L72E7
        cmp     #$0F            ; Max selector name length
        bcs     L72E8
        jmp     L72EE

L72E2:  lda     #ERR_INVALID_PATHNAME
        jsr     JUMP_TABLE_ALERT_0
L72E7:  rts

L72E8:  lda     #kErrNameTooLong
        jsr     JUMP_TABLE_ALERT_0
        rts

L72EE:  MGTK_RELAY_CALL MGTK::InitPort, main_grafport
        MGTK_RELAY_CALL MGTK::SetPort, main_grafport
        MGTK_RELAY_CALL MGTK::CloseWindow, winfo_file_dialog_listbox
        MGTK_RELAY_CALL MGTK::CloseWindow, winfo_file_dialog
        sta     LD8EC
        jsr     file_dialog::set_cursor_pointer
        copy16  #file_dialog::noop, file_dialog::handle_key::key_meta_digit+1

        ldx     file_dialog::stash_stack
        txs
        ldx     which_run_list
        ldy     copy_when
        return  #0
.endproc

;;; ============================================================

.proc handle_cancel_filename
        MGTK_RELAY_CALL MGTK::InitPort, main_grafport
        MGTK_RELAY_CALL MGTK::SetPort, main_grafport
        MGTK_RELAY_CALL MGTK::CloseWindow, winfo_file_dialog_listbox
        MGTK_RELAY_CALL MGTK::CloseWindow, winfo_file_dialog
        lda     #0
        sta     LD8EC
        jsr     file_dialog::set_cursor_pointer
        copy16  #file_dialog::noop, file_dialog::handle_key::key_meta_digit+1
        ldx     file_dialog::stash_stack
        txs
        return  #$FF
.endproc

;;; ============================================================

.proc handle_cancel_name
        copy    #1, path_buf2
        copy    #' ', path_buf2+1
        jsr     file_dialog::jt_redraw_input
        ldx     jt_pathname
L737C:  lda     jt_pathname+1,x
        sta     file_dialog::jump_table,x
        dex
        lda     jt_pathname+1,x
        sta     file_dialog::jump_table,x
        dex
        dex
        bpl     L737C
        copy    #1, path_buf2
        copy    #kGlyphInsertionPoint, path_buf2+1
        jsr     file_dialog::jt_redraw_input
        lda     #$00
        sta     file_dialog::L5105
        sta     file_dialog::L51AE
        lda     LD8F1
        sta     LD8F0
        rts
.endproc

;;; ============================================================

which_run_list:
        .byte   0
copy_when:
        .byte   0

;;; ============================================================

.proc handle_click
        MGTK_RELAY_CALL MGTK::InRect, rect_run_list_ctrl
        cmp     #MGTK::inrect_inside
        bne     :+
        jmp     click_run_list_ctrl
:       MGTK_RELAY_CALL MGTK::InRect, rect_other_run_list_ctrl
        cmp     #MGTK::inrect_inside
        bne     :+
        jmp     click_other_run_list_ctrl
:       MGTK_RELAY_CALL MGTK::InRect, rect_at_first_boot_ctrl
        cmp     #MGTK::inrect_inside
        bne     :+
        jmp     click_at_first_boot_ctrl
:       MGTK_RELAY_CALL MGTK::InRect, rect_at_first_use_ctrl
        cmp     #MGTK::inrect_inside
        bne     :+
        jmp     click_at_first_use_ctrl
:       MGTK_RELAY_CALL MGTK::InRect, rect_never_ctrl
        cmp     #MGTK::inrect_inside
        bne     :+
        jmp     click_never_ctrl
:       return  #0
.endproc

.proc click_run_list_ctrl
        lda     which_run_list
        cmp     #1
        beq     :+
        jsr     toggle_run_list_button
        lda     #1
        sta     which_run_list
        jsr     toggle_run_list_button
:       return  #$FF
.endproc

.proc click_other_run_list_ctrl
        lda     which_run_list
        cmp     #2
        beq     :+
        jsr     toggle_run_list_button
        lda     #2
        sta     which_run_list
        jsr     toggle_run_list_button
:       return  #$FF
.endproc

.proc click_at_first_boot_ctrl
        lda     copy_when
        cmp     #1
        beq     :+
        jsr     toggle_copy_when_button
        lda     #1
        sta     copy_when
        jsr     toggle_copy_when_button
:       return  #$FF
.endproc

.proc click_at_first_use_ctrl
        lda     copy_when
        cmp     #2
        beq     :+
        jsr     toggle_copy_when_button
        lda     #2
        sta     copy_when
        jsr     toggle_copy_when_button
:       return  #$FF
.endproc

.proc click_never_ctrl
        lda     copy_when
        cmp     #3
        beq     :+
        jsr     toggle_copy_when_button
        lda     #3
        sta     copy_when
        jsr     toggle_copy_when_button
:       return  #$FF
.endproc

;;; ============================================================

.proc toggle_run_list_button
        cmp     #1
        bne     :+
        addr_call draw_inset_rect, rect_run_list_radiobtn
        rts

:       addr_call draw_inset_rect, rect_other_run_list_radiobtn
        rts
.endproc

.proc toggle_copy_when_button
        cmp     #1
        bne     :+
        addr_call draw_inset_rect, rect_at_first_boot_radiobtn
        rts

:       cmp     #2
        bne     :+
        addr_call draw_inset_rect, rect_at_first_use_radiobtn
        rts

:       addr_call draw_inset_rect, rect_never_radiobtn
        rts
.endproc

;;; ============================================================
;;; Draw rect inset by 2px. Pointer to Rect in A,X.

.proc draw_inset_rect
        ptr := $06

        ;; Copy to scratch rect
        stax    ptr
        ldy     #.sizeof(MGTK::Rect)-1
:       lda     (ptr),y
        sta     rect_scratch,y
        dey
        bpl     :-

        lda     rect_scratch::x1
        clc
        adc     #2
        sta     rect_scratch::x1
        bcc     :+
        inc     rect_scratch::x1+1

:       lda     rect_scratch::y1
        clc
        adc     #2
        sta     rect_scratch::y1
        bcc     :+
        inc     rect_scratch::y1+1

:       lda     rect_scratch::x2
        sec
        sbc     #2
        sta     rect_scratch::x2
        bcs     :+
        dec     rect_scratch::x2+1

:       lda     rect_scratch::y2
        sec
        sbc     #2
        sta     rect_scratch::y2
        bcs     :+
        dec     rect_scratch::y2+1

:       MGTK_RELAY_CALL MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL MGTK::PaintRect, rect_scratch
        rts
.endproc

;;; ============================================================

.proc handle_key
        lda     winfo_file_dialog
        jsr     file_dialog::set_port_for_window
        lda     event_modifiers
        bne     :+
        rts

:       lda     event_key
        and     #CHAR_MASK
        cmp     #'1'
        bne     :+
        jmp     click_run_list_ctrl

:       cmp     #'2'
        bne     :+
        jmp     click_other_run_list_ctrl

:       cmp     #'3'
        bne     :+
        jmp     click_at_first_boot_ctrl

:       cmp     #'4'
        bne     :+
        jmp     click_at_first_use_ctrl

:       cmp     #'5'
        bne     :+
        jmp     click_never_ctrl

:       rts
.endproc

;;; ============================================================

        PAD_TO $7800
.endproc ; selector_overlay
