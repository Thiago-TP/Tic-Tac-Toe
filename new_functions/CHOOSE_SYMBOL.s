#####################################################################################
#	PLAYER chooses SYMBOL, either O and X. This is done through keyboard inputs,	#
#	'a', 'd' and '\n'. The shown frame is switched whenever 'a' or 'd' is pressed.	#
#	Frame 1 has O selected, and frame 0 has X. When '\n' is pressed, SYMBOL will	#
#	be the selected letter, according to the shown frame.							#
#####################################################################################
#	- Inputs -		#
#	keyboard inputs	#
#################################
#	- Outputs -					#
#	s0 (SYMBOL) set as 0 or 1	#
#################################
CHOOSE_SYMBOL:
	# return address shall be preserved as other functions will be called
	addi	sp, sp, -4
	sw		ra, 0(sp)

	# printing of the screens
	li		a3, 1
	call	PRINT_SYMBOL_SCREEN	# frame a3 = 1 screen (O selected, at the left)
	
	li		t0, FRAME_ADDRESS
	sw		a3, 0(t0)			# shows frame 1

	li		a3, 0
	call	PRINT_SYMBOL_SCREEN # frame a3 = 0 screen (X selected, at the right)

	# keypoll
	SYMB_LOOP:
		li		t0, KEY_ADDRESS
		lw		t1, 0(t0)
		andi	t1, t1, 1			# t1 = 1 if there was a keyboard input, 0 if not
		beqz	t1, SYMB_LOOP		# if there was no char input, check the input again
	
	# input processing
	lw		t0, 4(t0)				# t0 receives the input value (should be an ascii byte value)
	li		t1, 'a'
	beq		t0, t1, SWITCH_SYMBOL
	li		t1, 'd'
	beq		t0, t1, SWITCH_SYMBOL
	li		t1, '\n'
	beq		t0, t1, END_CHOOSE_SYMBOL

	j		SYMB_LOOP				# if the char input isn't 'a', 'd' or '\n', keypoll again

	# setting of SYMBOL flag
	END_CHOOSE_SYMBOL:
		li	t0, FRAME_ADDRESS
		lw	s0, 0(t0)				# s0=0 if X was picked, 1 if O

	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret								# symbol was selected, game goes on

# switches shown frame (0->1, 1->0)	
SWITCH_SYMBOL:
	li		t0, FRAME_ADDRESS
	lw		t1, 0(t0)
	xori	t1, t1, 1
	sw		t1, 0(t0)
	j		SYMB_LOOP	# frame was switched, return to keypoll in SYMBOL screen