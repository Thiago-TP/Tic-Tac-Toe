.data	
	BOARD:					.byte 	0, 0, 0,	# state matrix of each board square 
									0, 0, 0, 	# 0=empty square, 1=occupied ny PLAYER, 2=occupied by PC
									0, 0, 0	
	WIN_COMBO:				.byte -1, -1, -1	# indexes of the winning combination (initialized as -1 to avoid pseudo win)
	CURSOR_POSITION:		.half 64, 24 		# keeps the desired (x, y) bitmap position of the cursor for animation purposes
	CURSOR_OLD_POSITION:	.half 64, 24		# keeps the current (x, y) bitmap position of the cursor for animation purposes
	
	.eqv	FRAME_ADDRESS	0xFF200604			# memory address where value of frame being shown is kept
	.eqv	KEY_ADDRESS		0xFF200000			# memory address where value of keyboard input is kept
	
	CHOOSE_SYMBOL_MSG1:	.string		"Move the cursor with AD,"
	CHOOSE_SYMBOL_MSG2:	.string		"and confirm your symbol with ENTER"
	CHOOSE_SYMBOL_MSG3:	.string		"O selected"
	CHOOSE_SYMBOL_MSG4:	.string		"X selected"


.text
################################# Main Program ####################################
#	
#	LOOP control registers
#	s0	- SYMBOL:		0 if PLAYER chose X, 1 if O
#	s1	- DIFFICULTY:	-1 if PLAYER chose EASY, 0 if MEDIUM, 1 if HARD
#	s2	-
#
	MAIN:	call	INITIALIZE_VARIABLES
			call	CHOOSE_SYMBOL
			call	CHOOSE_DIFFICULTY
			call	INITIALIZE_BOARD
		fpg:	j fpg
		
		# LOOP:	call	PLAYER_TURN
		# 		j 		CHECK_END
		# 		call	PC_TURN
		# 		j		CHECK_END
		# 		j		LOOP		
		# END:	j	END_SCREEN

.include "new_all.s"

PRINT_DIFFICULTY_SCREEN:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    call    BLACK_SCREEN

	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret						# screen ready, CHOOSE_DIFFICULTY goes on
