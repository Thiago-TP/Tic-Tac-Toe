INITIALIZE_BOARD:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	# gets the current frame being shown
	li		t0, FRAME_ADDRESS
	lw		a0, 0(t0)
	xori	a0, a0, 1

	# print difficulty choice screens
	call	PRINT_BOARD			# prints board on the occult frame
	li		t0, FRAME_ADDRESS
	sw		a0, 0(t0)			# switches frame

	xori	a0, a0, 1
	call	PRINT_BOARD			# prints board on the remaining frame

	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret							# screen ready, game goes on
	