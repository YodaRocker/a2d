;;; ============================================================
;;; Resources
;;; ============================================================

        .org $D000

.scope

L2000           := $2000
L98D4           := $98D4
L9984           := $9984

        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   $FE, $1F, $00
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   $FE, $1F, $00
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   $FE, $1F, $00
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   $FE, $1F, $00
        .byte   $FF
        .byte   $FF
        .byte   0
        .byte   0
        .byte   $1E,$1F,$40
        .byte   $07
        .byte   $F0,$00
        .byte   $00
        .byte   $1E,$1F,$60
        .byte   $03
        .byte   $60


        .byte   $00
        .byte   $00
        .byte   $FE,$1F,$F0
        .byte   $F3
        .byte   $4F
        .byte   $00
        .byte   $00
        .byte   $FE,$1F,$F8
        .byte   $F3
        .byte   $4F
        .byte   $00
        .byte   $00
        .byte   $FE,$1F,$FC
        .byte   $FF
        .byte   $4F
        .byte   $00
        .byte   $00
        .byte   $FE,$1F,$FC
        .byte   $FF
        .byte   $67
        .byte   $00
        .byte   $00
        .byte   $FE,$1F,$FC
        .byte   $FF
        .byte   $F3
        .byte   $00
        .byte   $00
        .byte   $FE,$1F,$FC
        .byte   $FF
        .byte   $F9,$00,$00
        .byte   $FE,$1F,$FC
        .byte   $FF
        .byte   $FC
        .byte   $00
        .byte   $00
        .byte   $FE,$1F,$FC
        .byte   $3F
        .byte   $FE,$00,$00
        .byte   $FE,$1F,$FC
        .byte   $1F
        .byte   $FF

        .byte   0
        .byte   0
        .byte   $FE,$1F,$FC
        .byte   $1F
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $3E,$00,$FE
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $FE,$03,$FF
        .byte   $1F
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $FE,$43,$FF
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $0E,$60,$FF
        .byte   $FF
        .byte   $3F
        .byte   $00
        .byte   $00
        .byte   $FE,$03,$00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FE,$03,$00


        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   $14
        .byte   0



        .byte   $08
        .byte   $00
        .byte   $00
        .byte   $D0,$07
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $24,$00
        .byte   $17
        .byte   $00
        .byte   $41,$00
        .byte   $57
        .byte   $00
        .byte   $E5,$01
        .byte   $8E,$00,$04
        .byte   $00
        .byte   $02
        .byte   $00
        .byte   $A0,$01
        .byte   $35,$00
        .byte   $05,$00
        .byte   $03
        .byte   $00
        .byte   $9F
        .byte   $01,$34
        .byte   $00
LD0D0:
LD0D1   := * + 1
        .byte   $41,$00
LD0D2:
        .byte   $57
        .byte   $00
        .byte   $00
        .byte   $20,$80,$00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00


LD0DC:
LD0DD := *+1
        .byte   $A4,$01
LD0DE:
        .byte   $37
        .byte   $00


        PASCAL_STRING "Cancel    Esc"
        PASCAL_STRING {"OK            ", CHAR_RETURN}
        PASCAL_STRING "Try Again  A"

cancel_rect:
        DEFINE_RECT 300, 37, 400, 48
cancel_pos:
        DEFINE_POINT 305, 47

try_again_rect:
        DEFINE_RECT 20, 37, 120, 48
try_again_pos:
        DEFINE_POINT 25,47

        DEFINE_POINT 190,16
        DEFINE_POINT 75,29


        PASCAL_STRING "System Error number XX"

LD142:  .byte   0
LD143:  .byte   0
LD144:  .byte   0

;;; ============================================================


str_selector_unable_to_run:
        PASCAL_STRING "The Selector is unable to run the program."
str_io_error:
        PASCAL_STRING "I/O Error"
str_no_device:
        PASCAL_STRING "No device connected."
str_pathname_does_not_exist:
        PASCAL_STRING "Part of the pathname doesn't exist."
str_insert_source_disk:
        PASCAL_STRING "Please insert source disk."
str_file_not_found:
        PASCAL_STRING "The file cannot be found."
str_insert_system_disk:
        PASCAL_STRING "Please insert the system disk"
str_basic_system_not_found:
        PASCAL_STRING "BASIC.SYSTEM not found"

kNumErrorMessages = 8

num_error_messages:
        .byte   kNumErrorMessages



error_message_index_table:
        .byte   AlertID::selector_unable_to_run
        .byte   AlertID::io_error
        .byte   AlertID::no_device
        .byte   AlertID::pathname_does_not_exist
        .byte   AlertID::insert_source_disk
        .byte   AlertID::file_not_found
        .byte   AlertID::insert_system_disk
        .byte   AlertID::basic_system_not_found
        ASSERT_TABLE_SIZE error_message_index_table, kNumErrorMessages

error_message_table:
        .addr   str_selector_unable_to_run
        .addr   str_io_error
        .addr   str_no_device
        .addr   str_pathname_does_not_exist
        .addr   str_insert_source_disk
        .addr   str_file_not_found
        .addr   str_insert_system_disk
        .addr   str_basic_system_not_found
        ASSERT_ADDRESS_TABLE_SIZE error_message_table, kNumErrorMessages

LD236:
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $80
        .byte   $00
        .byte   $80
        .byte   $00

        ASSERT_ADDRESS $D23E

        .byte   $48
        .byte   $AD,$29,$91
        .byte   $F0,$04
        .byte   $68
        .byte   $A9,$01,$60


        jsr     L98D4
        MGTK_CALL MGTK::InitPort, selector5::grafport2
        MGTK_CALL MGTK::SetPort, selector5::grafport2
        lda     LD0D0
        ldx     LD0D1
        jsr     LD725
        sty     LD764
        sta     LD767
        lda     LD0D0
        clc
        adc     LD0DC
        pha
        lda     LD0D1
        adc     LD0DD
        tax
        pla
        jsr     LD725
        sty     LD766
        sta     LD768
        lda     LD0D2
        sta     LD763
        clc
        adc     LD0DE
        sta     LD765
        MGTK_CALL MGTK::HideCursor
        jsr     LD5A2
        MGTK_CALL MGTK::ShowCursor
        ldx     #.sizeof(MGTK::Point)-1
        lda     #0
LD29F:  sta     selector5::grafport2+MGTK::GrafPort::viewloc,x
        sta     selector5::grafport2+MGTK::GrafPort::maprect,x
        dex
        bpl     LD29F
        copy16  #$0226, $8F8F
        copy16  #$00B9, $8F91
        MGTK_CALL MGTK::SetPort, selector5::grafport2
        MGTK_CALL MGTK::SetPenMode, selector5::pencopy
        MGTK_CALL MGTK::PaintRect, $D0B8
        MGTK_CALL MGTK::SetPenMode, selector5::penXOR
        MGTK_CALL MGTK::FrameRect, $D0B8
        MGTK_CALL MGTK::SetPortBits, $D0D0
        MGTK_CALL MGTK::FrameRect, $D0C0
        MGTK_CALL MGTK::FrameRect, $D0C8
        MGTK_CALL MGTK::SetPenMode, selector5::pencopy
        MGTK_CALL MGTK::HideCursor
        MGTK_CALL MGTK::PaintBits, $D0A8
        MGTK_CALL MGTK::ShowCursor
        pla
        ldy     #$00
LD307:  cmp     error_message_index_table,y
        beq     LD314
        iny
        cpy     num_error_messages
        bne     LD307
        ldy     #$00
LD314:  tya
        asl     a
        tay
        lda     error_message_table,y
        sta     LD143
        lda     error_message_table+1,y
        sta     LD144
        tya
        lsr     a
        tay
        lda     LD236,y
        sta     LD142
        MGTK_CALL MGTK::SetPenMode, selector5::penXOR
        bit     LD142
        bpl     LD365
        MGTK_CALL MGTK::FrameRect, try_again_rect
        MGTK_CALL MGTK::MoveTo, try_again_pos
        addr_call L9984, $D0E0
        bit     LD142
        bvs     LD365
        MGTK_CALL MGTK::FrameRect, cancel_rect
        MGTK_CALL MGTK::MoveTo, cancel_pos
        addr_call L9984, $D0FE
        jmp     LD378

LD365:  MGTK_CALL MGTK::FrameRect, cancel_rect
        MGTK_CALL MGTK::MoveTo, cancel_pos
        addr_call L9984, $D0EE
LD378:  MGTK_CALL MGTK::MoveTo, $D127
        lda     LD143
        ldx     LD144
        jsr     L9984


event_loop:
        MGTK_CALL MGTK::GetEvent, selector5::event_params
        lda     selector5::event_kind
        cmp     #MGTK::EventKind::button_down
        bne     :+
        jmp     LD3F7

:       cmp     #MGTK::EventKind::key_down
        bne     event_loop
        lda     selector5::event_key
        and     #CHAR_MASK
        bit     LD142
        bpl     LD3DF
        cmp     #CHAR_ESCAPE
        bne     LD3BA
        MGTK_CALL MGTK::SetPenMode, selector5::penXOR
        MGTK_CALL MGTK::PaintRect, try_again_rect
        lda     #$01
        jmp     LD434

LD3BA:  bit     LD142
        bvs     LD3DF
        cmp     #'a'
        bne     LD3D4
LD3C3:  MGTK_CALL MGTK::SetPenMode, selector5::penXOR
        MGTK_CALL MGTK::PaintRect, cancel_rect
        lda     #$00
        jmp     LD434

LD3D4:  cmp     #'A'
        beq     LD3C3
        cmp     #CHAR_RETURN
        beq     LD3C3
        jmp     event_loop

LD3DF:  cmp     #CHAR_RETURN
        bne     LD3F4
        MGTK_CALL MGTK::SetPenMode, selector5::penXOR
        MGTK_CALL MGTK::PaintRect, cancel_rect
        lda     #$00
        jmp     LD434

LD3F4:  jmp     event_loop

LD3F7:  jsr     LD57B
        MGTK_CALL MGTK::MoveTo, selector5::event_coords
        bit     LD142
        bpl     LD424
        MGTK_CALL MGTK::InRect, try_again_rect
        cmp     #MGTK::inrect_inside
        bne     LD412
        jmp     LD4AD

LD412:  bit     LD142
        bvs     LD424
        MGTK_CALL MGTK::InRect, cancel_rect
        cmp     #MGTK::inrect_inside
        bne     LD431
        jmp     LD446

LD424:  MGTK_CALL MGTK::InRect, cancel_rect
        cmp     #MGTK::inrect_inside
        bne     LD431
        jmp     LD514

LD431:  jmp     event_loop

LD434:  pha
        MGTK_CALL MGTK::HideCursor
        jsr     LD5F7
        MGTK_CALL MGTK::ShowCursor
        pla
        rts

LD446:  MGTK_CALL MGTK::SetPenMode, selector5::penXOR
        MGTK_CALL MGTK::PaintRect, cancel_rect
        lda     #$00
        sta     LD4AC
LD457:  MGTK_CALL MGTK::GetEvent, selector5::event_params
        lda     selector5::event_kind
        cmp     #MGTK::EventKind::button_up
        beq     LD49F
        jsr     LD57B
        MGTK_CALL MGTK::MoveTo, selector5::event_coords
        MGTK_CALL MGTK::InRect, cancel_rect
        cmp     #MGTK::inrect_inside
        beq     LD47F
        lda     LD4AC
        beq     LD487
        jmp     LD457

LD47F:  lda     LD4AC
        bne     LD487
        jmp     LD457

LD487:  MGTK_CALL MGTK::SetPenMode, selector5::penXOR
        MGTK_CALL MGTK::PaintRect, cancel_rect
        lda     LD4AC
        clc
        adc     #$80
        sta     LD4AC
        jmp     LD457

LD49F:  lda     LD4AC
        beq     LD4A7
        jmp     event_loop

LD4A7:  lda     #$00
        jmp     LD434

LD4AC:  .byte   0
LD4AD:  MGTK_CALL MGTK::SetPenMode, selector5::penXOR
        MGTK_CALL MGTK::PaintRect, try_again_rect
        lda     #$00
        sta     LD513
LD4BE:  MGTK_CALL MGTK::GetEvent, selector5::event_params
        lda     selector5::event_kind
        cmp     #MGTK::EventKind::button_up
        beq     LD506
        jsr     LD57B
        MGTK_CALL MGTK::MoveTo, selector5::event_coords
        MGTK_CALL MGTK::InRect, try_again_rect
        cmp     #MGTK::inrect_inside
        beq     LD4E6
        lda     LD513
        beq     LD4EE
        jmp     LD4BE

LD4E6:  lda     LD513
        bne     LD4EE
        jmp     LD4BE

LD4EE:  MGTK_CALL MGTK::SetPenMode, selector5::penXOR
        MGTK_CALL MGTK::PaintRect, try_again_rect
        lda     LD513
        clc
        adc     #$80
        sta     LD513
        jmp     LD4BE

LD506:  lda     LD513
        beq     LD50E
        jmp     event_loop

LD50E:  lda     #$01
        jmp     LD434

LD513:  .byte   0
LD514:  lda     #$00
        sta     LD57A
        MGTK_CALL MGTK::SetPenMode, selector5::penXOR
        MGTK_CALL MGTK::PaintRect, cancel_rect
LD525:  MGTK_CALL MGTK::GetEvent, selector5::event_params
        lda     selector5::event_kind
        cmp     #MGTK::EventKind::button_up
        beq     LD56D
        jsr     LD57B
        MGTK_CALL MGTK::MoveTo, selector5::event_coords
        MGTK_CALL MGTK::InRect, cancel_rect
        cmp     #MGTK::inrect_inside
        beq     LD54D
        lda     LD57A
        beq     LD555
        jmp     LD525

LD54D:  lda     LD57A
        bne     LD555
        jmp     LD525

LD555:  MGTK_CALL MGTK::SetPenMode, selector5::penXOR
        MGTK_CALL MGTK::PaintRect, cancel_rect
        lda     LD57A
        clc
        adc     #$80
        sta     LD57A
        jmp     LD525

LD56D:  lda     LD57A
        beq     LD575
        jmp     event_loop

LD575:  lda     #$00
        jmp     LD434

LD57A:  .byte   0
LD57B:  sub16   selector5::event_xcoord, LD0D0, selector5::event_xcoord
        sub16   selector5::event_ycoord, LD0D2, selector5::event_ycoord
        rts

LD5A2:  copy16  #$0800, LD5D1
        lda     LD763
        jsr     LD6AA
        lda     LD765
        sec
        sbc     LD763
        tax
        inx
LD5BB:  lda     LD764
        sta     LD5F6
LD5C1:  lda     LD5F6
        lsr     a
        tay
        sta     LOWSCR
        bcs     LD5CE
        sta     HISCR
LD5CE:  lda     ($06),y
LD5D1           := * + 1
LD5D2           := * + 2
        sta     dummy1234
        inc16   LD5D1
        lda     LD5F6
        cmp     LD766
        bcs     LD5E8
        inc     LD5F6
        bne     LD5C1
LD5E8:  jsr     LD6EC
        dex
        bne     LD5BB
        lda     LD5D1
        ldx     LD5D2
        rts

        .byte   0
LD5F6:  .byte   0
LD5F7:  copy16  #$0800, LD656
        ldx     LD767
        ldy     LD768
        lda     #$FF
        cpx     #$00
        beq     LD612
LD60D:  clc
        rol     a
        dex
        bne     LD60D
LD612:  sta     LD6A6
        eor     #$FF
        sta     LD6A7
        lda     #$01
        cpy     #$00
        beq     LD625
LD620:  sec
        rol     a
        dey
        bne     LD620
LD625:  sta     LD6A8
        eor     #$FF
        sta     LD6A9
        lda     LD763
        jsr     LD6AA
        lda     LD765
        sec
        sbc     LD763
        tax
        inx
        lda     LD764
        sta     LD6A5
LD642:  lda     LD764
        sta     LD6A5
LD648:  lda     LD6A5
        lsr     a
        tay
        sta     LOWSCR
        bcs     LD655
        sta     HISCR
LD655:
LD656           := * + 1
        lda     $0800
        pha
        lda     LD6A5
        cmp     LD764
        beq     LD677
        cmp     LD766
        bne     LD685
        lda     ($06),y
        and     LD6A9
        sta     ($06),y
        pla
        and     LD6A8
        ora     ($06),y
        pha
        jmp     LD685

LD677:  lda     ($06),y
        and     LD6A7
        sta     ($06),y
        pla
        and     LD6A6
        ora     ($06),y
        pha
LD685:  pla
        sta     ($06),y
        inc16   LD656
        lda     LD6A5
        cmp     LD766
        bcs     LD69D
        inc     LD6A5
        bne     LD648
LD69D:  jsr     LD6EC
        dex
        bne     LD642
        rts

        .byte   0
LD6A5:  .byte   0
LD6A6:  .byte   0
LD6A7:  .byte   0
LD6A8:  .byte   0
LD6A9:  .byte   0
LD6AA:  sta     LD769
        and     #$07
        sta     LD74A
        lda     LD769
        and     #$38
        sta     LD749
        lda     LD769
        and     #$C0
        sta     LD748
        jsr     LD6C6
        rts

LD6C6:  lda     LD748
        lsr     a
        lsr     a
        ora     LD748
        pha
        lda     LD749
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        sta     LD6EB
        pla
        ror     a
        sta     $06
        lda     LD74A
        asl     a
        asl     a
        ora     LD6EB
        ora     #$20
        sta     $07
        clc
        rts

LD6EB:  .byte   0
LD6EC:  lda     LD74A
        cmp     #$07
        beq     LD6F9
        inc     LD74A
        jmp     LD6C6

LD6F9:  lda     #$00
        sta     LD74A
        lda     LD749
        cmp     #$38
        beq     LD70E
        clc
        adc     #$08
        sta     LD749
        jmp     LD6C6

LD70E:  lda     #$00
        sta     LD749
        lda     LD748
        clc
        adc     #$40
        sta     LD748
        cmp     #$C0
        beq     LD723
        jmp     LD6C6

LD723:  sec
        rts

LD725:  ldy     #$00
        cpx     #$02
        bne     LD730
        ldy     #$49
        clc
        adc     #$01
LD730:  cpx     #$01
        bne     LD73E
        ldy     #$24
        clc
        adc     #$04
        bcc     LD73E
        iny
        sbc     #$07
LD73E:  cmp     #$07
        bcc     LD747
        sbc     #$07
        iny
        bne     LD73E
LD747:  rts

LD748:  .byte   0
LD749:  .byte   0
LD74A:  .byte   0
        .byte   $FF
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
LD763:  .byte   0
LD764:  .byte   0
LD765:  .byte   0
LD766:  .byte   0
LD767:  .byte   0
LD768:  .byte   0
LD769:  .byte   0

.endscope

        .incbin "inc/junk4.dat"

        ASSERT_ADDRESS $D800
