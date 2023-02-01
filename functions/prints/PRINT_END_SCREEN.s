#############################################
#	Prints one frame of the end screen.		#
#	Should only be called by END_SCREEN.	#
#####################################################
#	- Input -										#
#	a0 = state of the game (0=tie, 1=win, 2=loss)	#
#	a3 = frame										#
#####################################################
#	- Output -		#
#	Printed frame	#
#####################
PRINT_END_SCREEN:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -8
    sw      ra, 0(sp)
    sw      a0, 4(sp)

	# blackens the screen
	call	BLACK_SCREEN
	
	# prints messages common to every ending
	la		a0, END_MSG1	# "Play again?"
	li 		a1, 127
	li 		a2, 76
	li 		a4, TIE_MSG_COLOR
	call	PRINT_STRING
	
	la		a0, END_MSG2	# "YES"
	li 		a1, 130
	li 		a2, 160
	li		a4, GOOD_MSG_COLOR
	beqz	a3, YES_SHOULD_BE_GRAY
	PRINT_YES:
		call	PRINT_STRING
	
	la		a0, END_MSG3	# "NO"
	li 		a1, 172
	li		a4, BAD_MSG_COLOR
	bnez	a3, NO_SHOULD_BE_GRAY
	PRINT_NO:
		call	PRINT_STRING

	# print the decoration critter character according to the ending 
	# (tie=Peach, win=Mario, loss=Bowser) + "YOU X" message
	lw      a0, 4(sp)
	call	PRINT_MASCOT

	# we are done, return to END_SCREEN
	lw		ra, 0(sp)
    lw      a0, 4(sp)
	addi	sp, sp, 8
	ret	

YES_SHOULD_BE_GRAY:	li	a4, GRAY_MSG_COLOR
					j 	PRINT_YES
NO_SHOULD_BE_GRAY:	li	a4, GRAY_MSG_COLOR
					j 	PRINT_NO


#####################################################
#	Prints the character according to the ending 	#
#	(tie=Peach, win=Mario, loss=Bowser).			#
#####################################################
PRINT_MASCOT:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -8
    sw      ra, 0(sp)
    sw      a0, 4(sp)

	li 		a2, 60

	beqz	a0, GOTO_PEACH
	li 		t0, 1
	beq		a0, t0, GOTO_MARIO

	la		a0, END_MSG5	# "YOU LOST!"
	li 		a1, 133
	li		a4, BAD_MSG_COLOR
	call	PRINT_STRING

	la 		a0, BOWSER
	li 		a1, 140

	PRINT_CRITTER:
		li 		a2, 92
		call	PRINT

	lw		ra, 0(sp)
    lw      a0, 4(sp)
	addi	sp, sp, 8
	ret	

GOTO_PEACH:	la		a0, END_MSG6	# "TIE!"
			li 		a1, 148
			li		a4, TIE_MSG_COLOR
			call	PRINT_STRING
			
			la 		a0, PEACH
			li 		a1, 148
			j		PRINT_CRITTER

GOTO_MARIO:	la		a0, END_MSG4	# "YOU WON!"
			li 		a1, 136
			li		a4, GOOD_MSG_COLOR
			call	PRINT_STRING
			
			la 		a0, MARIO
			li 		a1, 152
			j		PRINT_CRITTER