#################################################################
#	Initialization of variables to guarantee smooth rematches.	#
#################################################################
#	- Inputs -	#
#	None		#
#################
#	- Outputs -	#
#	Happiness	#
#################
INITIALIZE_VARIABLES:
	# zeroing (emptying) of BOARD
	la	t0, BOARD
	sw	zero, 0(t0)		# zeroes houses 0 to 3
	sw	zero, 4(t0)		# zeroes houses 4 to 7
	sb	zero, 8(t0) 	# zeroes house 8

	# zeroing of control registers
	li	s0, -1			# SYMBOL flag		(-1 => no symbol chosen)
	li	s1, 0			# DIFFICULTY flag	(0 => standard difficulty)

	# initialization of WIN_COMBO
	la	t0, WIN_COMBO
	li	t1, -1
	sb	t1, 0(t0)		# sets index 0 as -1
	sb	t1, 1(t0)		# sets index 1 as -1
	sb	t1, 2(t0)		# sets index 2 as -1

	# initialization of CURSOR positions
	la	t0, CURSOR_POSITION
	li	t1, 64					# neutral x bmp position
	li	t2, 24					# neutral y bmp position
	sh	t1, 0(t0)				# sets desired CURSOR x position as 60
	sh	t2, 2(t0)				# sets desired CURSOR y position as 24
	la	t0, CURSOR_OLD_POSITION
	sh	t1, 0(t0)				# sets current CURSOR x position as 60
	sh	t2, 2(t0)				# sets current CURSOR y position as 24

	# shown frame set as 0
	li	t0, FRAME_ADDRESS		
	sw	zero, 0(t0)				# shows frame 0
	
	ret							# initialization done