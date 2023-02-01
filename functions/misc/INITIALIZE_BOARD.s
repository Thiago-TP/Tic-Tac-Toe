INITIALIZE_BOARD:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	# gets the current frame being shown
	li		t0, FRAME_ADDRESS
	lw		a3, 0(t0)
	xori	a3, a3, 1

	# prints difficulty choice screens
	call	PRINT_BOARD_SCREEN	# prints board on the occult frame

	# prints CURSOR on the upper left corner SQUARE
	la      a0, CURSOR 
    li      a1, 64      # x bmp position
    li      a2, 24      # y bmp position
    call    PRINT
	li		t0, FRAME_ADDRESS
	sw		a3, 0(t0)			# switches frame

	xori	a3, a3, 1
	call	PRINT_BOARD_SCREEN	# prints board on the remaining frame

	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret							# screen ready, game goes on
	