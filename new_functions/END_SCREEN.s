#############################################################
#	Prints a screen for each outcome: win, loss and tie.	#
#	Follows the same logic as PRINT_SYMBOL_SCREEN.			#
#############################################################
#	- Input -							#
#	a0 = state of game					#
#		 0=tie, 1=PLAYER won, 2=PC won	#
#########################################
END_SCREEN:
	# prints the end screen according to a0 on both frames
	li 		t0, FRAME_ADDRESS
	sw		zero, 0(t0)					# shows frame 0 
	li		a3, 1
	call	PRINT_END_SCREEN

	li 		t0, FRAME_ADDRESS
	sw 		a3, 0(t0)
	li 		a3, 0
	call	PRINT_END_SCREEN

	# keypoll
	FINAL_KEYPOLL:
		li		t0, KEY_ADDRESS
		lw		t1, 0(t0)
		andi	t1, t1, 1				# t1 = 1 if there was a keyboard input, 0 if not
		beqz	t1, FINAL_KEYPOLL		# if there was no char input, check the input again
	
	# input processing
	lw		t0, 4(t0)					# t0 receives the input value (should be an ascii byte value)
	li		t1, 'a'
	beq		t0, t1, SWITCH_ANSWER
	li		t1, 'd'
	beq		t0, t1, SWITCH_ANSWER
	li		t1, '\n'
	beq		t0, t1, END_GAME_CYCLE

	j		FINAL_KEYPOLL				# if the char input isn't 'a', 'd' or '\n', keypoll again

	# setting of RESTART flag
	END_GAME_CYCLE:
		li		t0, FRAME_ADDRESS
		lw		a0, 0(t0)				# a0=0 if NO was picked, 1 if YES
	
		bnez	a0, MAIN				# if YES was picked, restart de game from the beginning

		# blackens the hidden frame 
		xori 	a3, a0, 1
		call	BLACK_SCREEN
		
		# prints last message
		la		a0, END_MSG7			# "THANK YOU FOR PLAYING!"
		li 		a1, 94
		li		a2, 110
		li 		a4, GOOD_MSG_COLOR
		call	PRINT_STRING

		# shows message, freezes the game
		li  	t0, FRAME_ADDRESS
		sw		a3, 0(t0)
		ENDLESS_LOOP:	j	ENDLESS_LOOP	

# switches shown frame (0->1, 1->0)	
SWITCH_ANSWER:
	li		t0, FRAME_ADDRESS
	lw		t1, 0(t0)
	xori	t1, t1, 1
	sw		t1, 0(t0)
	j		FINAL_KEYPOLL				# frame was switched, return to keypoll in SYMBOL screen
