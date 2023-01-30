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

    call    GET_PC_SYMBOL

    call 	MARK_CENTER         # marks the center, if possible
	bgtz 	a1, END_HARD_AI 	# available = 1 => return

	call	EASY_AI

    # call 	MAKE_TRIPLE         # marks a triple, if possible
	# bnez 	s0, fim_do_dificil 	# available = 1 => return
	
	# call 	BLOCK_TRIPLE        # blocks a triple, if possible
	# bnez 	s0, fim_do_dificil 	# available = 1 => return
	
	# call 	MARK_CENTER         # marks the center, if possible
	# bnez 	s0, fim_do_dificil 	# available = 1 => return	
	
	# call 	MARK_OPPOSITE_CORNER    # marks the opposite corner. if PLAYER just marked a corner and it is possible
	# bnez 	s0, fim_do_dificil 	# available = 1 => return
	
	# call 	MARK_SOME_CORNER    # marks a corner, if possible
	# bnez 	s0, fim_do_dificil 	# available = 1 => return
	
	# call 	MARK_EMPTY_SQUARE   # marks an empty house (always possible, since the AIs aren't called it the game tied)

    END_HARD_AI:
	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret	

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
