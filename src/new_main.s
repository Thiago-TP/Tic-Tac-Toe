.data	
	BOARD:					.byte 	0, 0, 0,	# state matrix of each board square 
									0, 0, 0, 	# 0=empty square, 1=occupied ny PLAYER, 2=occupied by PC
									0, 0, 0	
	WIN_COMBO:				.byte -1, -1, -1	# indexes of the winning combination (initialized as -1 to avoid pseudo win)
	CURSOR_POSITION:		.half 50, 100 		# keeps the desired (x, y) bitmap position of the cursor for animation purposes
	CURSOR_OLD_POSITION:	.half 50, 100		# keeps the current (x, y) bitmap position of the cursor for animation purposes
	
	.eqv	FRAME_ADDRESS	0xFF200604			# memory address where value of frame being shown is kept
	.eqv	KEY_ADDRESS		0xFF200000			# memory address where value of keyboard input is kept

	.eqv	TIE_MSG_COLOR	0x00540035			# neutral message color 
	.eqv	BAD_MSG_COLOR	0x00020007			# bad news message color 
	.eqv	GOOD_MSG_COLOR	0x00500038			# good news message color
	
	# communication messages
	CHOOSE_SYMBOL_MSG1:	.string		"Move the cursor with AD,"
	CHOOSE_SYMBOL_MSG2:	.string		"and confirm your symbol with ENTER"
	CHOOSE_SYMBOL_MSG3:	.string		"O selected"
	CHOOSE_SYMBOL_MSG4:	.string		"X selected"

	CHOOSE_DIFFICULTY_MSG1:	.string	"EASY selected"
	CHOOSE_DIFFICULTY_MSG2:	.string	"MEDIUM selected"
	CHOOSE_DIFFICULTY_MSG3:	.string	"HARD selected"

	BOARD_MSG1:	.string	"Use WASD to move, ENTER to play"
	BOARD_MSG2:	.string "Wins:"
	BOARD_MSG3:	.string "Losses:"
	BOARD_MSG4:	.string "Ties:"
	BOARD_MSG5:	.string "Games played:"

	# counter of wins (0xww), losses (0xll), ties (0xtt), and games played (0xgg)
	THE_BIG_COUNTER:	.word	0x00000000	# 0xww_ll_tt_gg
.text
################################# Main Program ####################################
#	
#	LOOP control registers
#	s0	- SYMBOL:		0 if PLAYER chose X, 1 if O
#	s1	- DIFFICULTY:	-1 if PLAYER chose EASY, 0 if MEDIUM, 1 if HARD
#
	MAIN:	call	INITIALIZE_VARIABLES
			call	CHOOSE_SYMBOL
			call	CHOOSE_DIFFICULTY
			call	INITIALIZE_BOARD
		
		LOOP:	call	PLAYER_TURN
		 		call	CHECK_END
				bgez	a0, END

		 		call	PC_TURN
		 		call	CHECK_END
				bgez	a0, END
		 		j		LOOP

		END:	j	END_SCREEN

.include "new_all.s"
	











MEDIUM_AI:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	call	EASY_AI

	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret	

HARD_AI:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	call	EASY_AI

	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret	






















END_SCREEN:
	j END_SCREEN  # jump to LOOP
