#################################################################################
#	Takes a SQUARE at random. If empty, marks it with the appropriate SYMBOL	#
#################################################################################
#	- Inputs -		#
#	BOARD struct	#
#####################
#	- Output -	#
#	PC play		#
#################
EASY_AI:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	# generates a pseudorandom number (index) between 0 and 8
	RAND_INT_LOOP:
		csrr	t0, time 
		li 		t1, 9
		remu	a0, t0, t1

		# sees if index's SQUARE is empty
		la      t1, BOARD
		add     t0, a0, t1          # t0 = address of SQUARE in BOARD
		lbu     t1, 0(t0)           # t1 = status of SQUARE
		bnez    t1, RAND_INT_LOOP	# if occupied, keypoll again
	
	li		t1, 2
	sb      t1, 0(t0)           	# updates BOARD
	call	CONVERT_IND_TO_POS		# calculates (a1, a2) according to the index in a0

	call 	GET_PC_SYMBOL
	call	MARK_SQUARE

	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret	
		