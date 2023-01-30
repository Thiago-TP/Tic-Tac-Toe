#############################################################################
#   PC analyzes BOARD and tries to make the best immediate move,            #
#   while avoiding a loss. The move is decided from a queue of attempts.    #
#   This AI is vulnerable to 2-steps-ahead strategies form the PLAYER.      #
#############################################################################
#   - Inputs -      #
#   BOARD struct    #
#####################
#   - Output -  #
#   PC play     #
#################
HARD_AI:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    call    GET_PC_SYMBOL       # loads in a4 PC's sprite

    call 	MARK_CENTER         # marks the center, if possible
	bgtz 	a1, END_HARD_AI 	# move available => we're done

    call 	MARK_OPPOSITE_CORNER    # marks the opposite corner. if PLAYER just marked a corner and it is possible
	bgtz 	a1, END_HARD_AI 	# move available => we're done

    call 	MARK_SOME_CORNER    # marks a corner, if possible
	bgtz 	a1, END_HARD_AI 	# move available => we're done

    call 	MARK_EMPTY_SQUARE   # marks an empty house (always possible, since the AIs aren't called it the game tied)

    # call 	MAKE_TRIPLE         # marks a triple, if possible
	# bnez 	s0, fim_do_dificil 	# move available => we're done
	
	# call 	BLOCK_TRIPLE        # blocks a triple, if possible
	# bnez 	s0, fim_do_dificil 	# move available => we're done
	
    END_HARD_AI:
	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret	

#####################################################
#   PC plays in the center if it is not occupied    #
#####################################################
#   - Input -       #
#   BOARD struct    #
#####################
#   - Output -  #
#   PC play     #
#################
MARK_CENTER:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    li      a0, 4
    call    CHECK_SQUARE
    beqz    a1, CENTER_FILLED

    call    CONVERT_IND_TO_POS
    call    MARK_SQUARE

    CENTER_FILLED:
    # recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret	

#############################################
#   PC plays in the first available corner  #
#############################################
#   - Input -       #
#   BOARD struct    #
#####################
#   - Output -  #
#   PC play     #
#################
MARK_SOME_CORNER:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    li      a0, 0
    call    CHECK_SQUARE
    bnez    a1, FREE_CORNER

    li      a0, 2
    call    CHECK_SQUARE
    bnez    a1, FREE_CORNER

    li      a0, 6
    call    CHECK_SQUARE
    bnez    a1, FREE_CORNER

    li      a0, 8
    call    CHECK_SQUARE
    bnez    a1, FREE_CORNER
    j       CORNERS_FILLED

    FREE_CORNER:
        call    CONVERT_IND_TO_POS
        call    MARK_SQUARE

    CORNERS_FILLED:
    # recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret


#############################################
#   PC plays in the first available corner  #
#############################################
#   - Input -       #
#   BOARD struct    #
#####################
#   - Output -  #
#   PC play     #
#################
MARK_OPPOSITE_CORNER:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    li      t0, 8
    call    CHECK_CORNER
    bnez    t0, CORNER_2
    li      a0, 0
    call    CHECK_SQUARE
    bnez    a1, FREE_OPPOSITE_CORNER

    CORNER_2:
        li      t0, 6
        call    CHECK_CORNER
        bnez    t0, CORNER_6
        li      a0, 2
        call    CHECK_SQUARE
        bnez    a1, FREE_OPPOSITE_CORNER

    CORNER_6:
        li      t0, 2
        call    CHECK_CORNER
        bnez    t0, CORNER_8
        li      a0, 6
        call    CHECK_SQUARE
        bnez    a1, FREE_OPPOSITE_CORNER

    CORNER_8:
        li      t0, 0
        call    CHECK_CORNER
        bnez    t0, OPPOSITE_CORNERS_FILLED
        li      a0, 8
        call    CHECK_SQUARE
        bnez    a1, FREE_OPPOSITE_CORNER

    j       OPPOSITE_CORNERS_FILLED

    FREE_OPPOSITE_CORNER:
        call    CONVERT_IND_TO_POS
        call    MARK_SQUARE

    OPPOSITE_CORNERS_FILLED:
    # recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret


#########################################################
#   Sees if BOARD at index a0 is empty (has value 0).   #
#   If so, marks it as occupied by PC.                  #
#########################################################
#   - Input -                           #
#   a0 = BOARD index (0, 1, ..., or 8)  #
#########################################
#   - Output -                  #
#   a1 = 1 if empty, 0 if not   # <- EMPTY flag
#################################
CHECK_SQUARE:
    la      t0, BOARD
    add     t0, t0, a0 
    lbu     t1, 0(t0)
    bnez    t1, SQUARE_FILLED

    li      t1, 2
    sb      t1, 0(t0)
    li      a1, 1
    END_CHECK_SQUARE:
    ret

SQUARE_FILLED:  li  a1, 0
                j   END_CHECK_SQUARE

CHECK_CORNER:
    la      t1, BOARD
    add     t0, t0, t1
    lbu     t0, 0(t0)   # t0 = 0, 1, or 2 (empty, player, pc)
    addi    t0, t0, -1  # t0 = -1, 0, or 1
    ret


##################################################################
#   Marks the first available spot in BOARD with PC's SYMBOL.    #
##################################################################
#   - Input -       #
#   BOARD struct    #
#####################
#   - Output -  #
#   PC play     #
#################
MARK_EMPTY_SQUARE:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    li      a1, 0
	li 		a0, 9
	SEARCH_LOOP:
        addi    a0, a0, -1
		call    CHECK_SQUARE
		beqz	a1, SEARCH_LOOP
    
    call    CONVERT_IND_TO_POS
    call    MARK_SQUARE
    
    # recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret
