#####################################################
#	Prints a frame of the DIFFICULTY choice screen.	#
#	The bitmap is first cleared, then the messages 	#
#	and symbols are painted over					#
#####################################################
#	- Input -					#
#	a3 = desired frame (0 or 1)	#
#################################
#	- Output -		#
#	printed screen	#
#####################
PRINT_DIFFICULTY_SCREEN:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	# first, the screen is blackened
    call    BLACK_SCREEN	

	# print tutorial messages
	la		a0, CHOOSE_SYMBOL_MSG1
	li		a1, 88
	li		a2, 33
	li		a4, TIE_MSG_COLOR
	call	PRINT_STRING	# "Move the cursor with AD,"
	
	la		a0, CHOOSE_SYMBOL_MSG2
	li		a1, 58
	addi	a2, a2, 12
	call	PRINT_STRING	# "and confirm your symbol with ENTER"

	# printing of the difficulty symbols
	la		a0, SQUARE		# 64x64 sprite of BOARD tile
	li		a1, 32
	li		a2, 88
	call	PRINT
	la		a0, GREEN_SHELL	# 64x64 sprite of EASY difficulty
	call	PRINT

	la		a0, SQUARE		# 64x64 sprite of BOARD tile
	li		a1, 128
	call	PRINT
	la		a0, RED_SHELL	# 64x64 sprite of MEDIUM difficulty
	call	PRINT

	la		a0, SQUARE		# 64x64 sprite of BOARD tile
	li		a1, 224
	call	PRINT
	la		a0, SPIKY_SHELL	# 64x64 sprite of HARD difficulty
	call	PRINT

	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret						# screen ready, CHOOSE_DIFFICULTY goes on