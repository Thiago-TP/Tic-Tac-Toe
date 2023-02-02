.data	
	BOARD:					.byte 	0, 0, 0,	# state matrix of each board square 
									0, 0, 0, 	# 0=empty square, 1=occupied ny PLAYER, 2=occupied by PC
									0, 0, 0	
	WIN_COMBO:				.byte	-1,-1,-1	# indexes of the winning combination (initialized as -1 to avoid pseudo win)
	
	.eqv	FRAME_ADDRESS	0xFF200604			# memory address where value of frame being shown is kept
	.eqv	KEY_ADDRESS		0xFF200000			# memory address where value of keyboard input is kept

	.eqv	TIE_MSG_COLOR	0x00540035			# standard message color 
	.eqv	BAD_MSG_COLOR	0x00020007			# bad news message color 
	.eqv	GOOD_MSG_COLOR	0x00500038			# good news message color
	.eqv 	GRAY_MSG_COLOR	0x00090052			# "currently unselected" message color

	# counter of wins (0xww), losses (0xll), ties (0xtt), games played (0xgg)
	THE_BIG_COUNTER:	.word	0x00000000	# 0xww_ll_tt_gg
	
	# communication messages
	CHOOSE_SYMBOL_MSG1:	.string	"Move the cursor with AD,"
	CHOOSE_SYMBOL_MSG2:	.string	"and confirm your symbol with ENTER"
	CHOOSE_SYMBOL_MSG3:	.string	"O selected"
	CHOOSE_SYMBOL_MSG4:	.string	"X selected"

	CHOOSE_DIFFICULTY_MSG1:	.string	"EASY selected"
	CHOOSE_DIFFICULTY_MSG2:	.string	"MEDIUM selected"
	CHOOSE_DIFFICULTY_MSG3:	.string	"HARD selected"

	BOARD_MSG1:	.string	"Use WASD to move, ENTER to play"
	BOARD_MSG2:	.string "Wins:"
	BOARD_MSG3:	.string "Losses:"
	BOARD_MSG4:	.string "Ties:"
	BOARD_MSG5:	.string "Games played:"

	END_MSG1:	.string "Play again?"
	END_MSG2:	.string "YES"
	END_MSG3:	.string "NO"
	END_MSG4:	.string "YOU WON!"
	END_MSG5:	.string "YOU LOST!"
	END_MSG6:	.string "TIE!"
	END_MSG7:	.string "THANK YOU FOR PLAYING!"

.text
#-------------------------------# Main Program #-------------------------------#
	#########################################################################	
	#						LOOP control registers							#
	#########################################################################
	#	s0	- SYMBOL:		0 if PLAYER chose X, 1 if O						#
	#	s1	- DIFFICULTY:	-1 if PLAYER chose EASY, 0 if MEDIUM, 1 if HARD	#
	#########################################################################
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

		END:	call	HIGHLIGHT_WIN
				j		END_SCREEN

.include "all_includer.s"
