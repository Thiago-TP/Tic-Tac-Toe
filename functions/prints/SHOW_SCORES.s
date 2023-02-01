#############################################################################
#   Prints out the current number of wins, losses, ties and games played    #
#   on the BOARD screen. Must be called by PRINT_BOARD_SCREEN               #
#############################################################################
#   - Inputs -              #
#   a3 = printing frame     #
#   THE_BIG_COUNTER struct  #
#############################
#   - Output -          #
#   printed out scores  #
#########################
SHOW_SCORES:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -8
    sw      ra, 0(sp)
    sw		s1, 4(sp)

    # prints counters messages
    la      a0, BOARD_MSG1          # ""Use WASD to move, ENTER to play""
    li      a1, 67
    li      a2, 1
    li      a4, TIE_MSG_COLOR
    call    PRINT_STRING

    la      a0, BOARD_MSG2          # "Wins:"
    li      a1, 17
    li      a2, 110
    li      a4, GOOD_MSG_COLOR
    call    PRINT_STRING

    la      a0, BOARD_MSG3          # "Losses:"
    li      a1, 267
    li      a4, BAD_MSG_COLOR
    call    PRINT_STRING

    la      a0, BOARD_MSG4          # "Ties:"
    li      a1, 139
    li      a2, 217
    li      a4, TIE_MSG_COLOR
    call    PRINT_STRING

    la      a0, BOARD_MSG5          # "Games played:"
    li      a1, 115
    li      a2, 13
    call    PRINT_STRING

    # gets the big counter value
    la      t0, THE_BIG_COUNTER
    lw      t0, 0(t0)               # t0 <- 0xww_ll_tt_gg

    # gets each counter separately
    srli    s1, t0, 24              # s1 <- 0x00_00_00_ww = win counter
    slli    s2, t0, 8
    srli    s2, s2, 24              # s2 <- 0x00_00_00_ll = loss counter
    slli    s3, t0, 16
    srli    s3, s3, 24              # s3 <- 0x00_00_00_tt = tie counter
    slli    s4, t0, 24
    srli    s4, s4, 24              # s4 <- 0x00_00_00_gg = games played counter

    # prints each number in its appropriate location
    addi    a0, s1, 48              # win count
    li      a1, 29
    li      a2, 122
    li      a4, GOOD_MSG_COLOR
    call    PRINT_CHAR

    addi    a0, s2, 48              # loss counter
    li      a1, 285
    li      a4, BAD_MSG_COLOR
    call    PRINT_CHAR

    addi    a0, s3, 48              # tie counter
    li      a1, 175
    li      a2, 217
    li      a4, TIE_MSG_COLOR
    call    PRINT_CHAR

    addi    a0, s4, 48              # game counter
    li      a1, 199
    li      a2, 13
    call    PRINT_CHAR
    # recovering of return address 
	lw		ra, 0(sp)
    lw		s1, 4(sp)
	addi	sp, sp, 8
	ret						# screen ready, game goes on
    