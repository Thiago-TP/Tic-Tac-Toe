#################################################
#	Leaves the whole screen at frame a3 black.	#
#################################################
#	- Inputs -	#
#	a3 = 0 or 1	#
#################
BLACK_SCREEN:	
	li		t0, 0xFF000000	# memory address of firt pixel in frame 0
	li		t1, 0xFF012C00	# memory address of last pixel in frame 0
	beqz	a3, BLK_SCR_LOOP
	li		t0, 0xFF100000	# memory address of firt pixel in frame 1
	li		t1, 0xFF112C00	# memory address of last pixel in frame 1

	BLK_SCR_LOOP:	
		sw		zero, 0(t0)				# blackens 4 pixels
		addi	t0, t0, 4				# gets the memoery address of the next pixel quadruple
		blt		t0, t1, BLK_SCR_LOOP	# if not all pixels have been blackened, blacken 4 more

	ret									# whole screen is now black, we are done