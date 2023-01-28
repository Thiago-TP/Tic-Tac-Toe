#############################################################
#	Prints a frame of the SYMBOL choice screen.				#
#	The O symbol should be at the left, and X at the right.	#
#	Frame 1 leaves O selected, whereas frame 0 leaves X.	#
#	This function should be called by CHOOSE_SYMBOL only.	#
#############################################################
#	- Inputs -					#
#	a0 = desired frame (0 or 1)	#
#	- Output -					#
#	printed screen				#
#################################
PRINT_SYMBOL_SCREEN:
	# return address shall be preserved as other functions will be called
	addi	sp, sp, -4
	sw		ra, 0(sp)

	# turn the whole screen black 
	call	BLACK_SCREEN

	# print tutorial messages
	mv		a3, a0
	la		a0, CHOOSE_SYMBOL_MSG1
	li		a1, 88
	li		a2, 33
	li		a4, 0x0054c735
	call	PRINT_STRING

	la		a0, CHOOSE_SYMBOL_MSG2
	li		a1, 58
	addi	a2, a2, 12
	call	PRINT_STRING

	# print selection messages
	li		a2, 191
	bnez	a3, O_SELECTED
	la		a0, CHOOSE_SYMBOL_MSG4
	li		a1, 194
	j		X_SELECTED 	
	O_SELECTED:
		la		a0, CHOOSE_SYMBOL_MSG3
		li		a1, 66
	X_SELECTED:
	call	PRINT_STRING

	# prints the O symbol on the left
	la		a0, SQUARE	    # 64x64 board house sprite 
	li		a1, 64			# bmp x position of O
	li		a2, 88			# bmp y position of O, X
	call	PRINT
    la		a0, O_SYMBOL	# 64x64 symbol sprite
    call	PRINT

	# prints the X symbol on the right
	la		a0, SQUARE	
	li		a1, 192			# bmp x position of X
	call	PRINT
    la		a0, X_SYMBOL	# 64x64 sprite
    call	PRINT

	# CURSOR x position is defined
	la		a0, CURSOR
	bnez	a3, HOVER_O
	j   	END_PRINT_SYMB_SCR	# X is left selected
	HOVER_O:
		li	    a1, 64			# O is left selected

    END_PRINT_SYMB_SCR:
	    call	PRINT			# CURSOR is printed hovering over designed symbol	
	
	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret							# screen ready, CHOOSE_SYMBOL goes on