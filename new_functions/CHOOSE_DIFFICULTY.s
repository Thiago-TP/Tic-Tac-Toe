CHOOSE_DIFFICULTY:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	# gets the current frame being shown
	li		t0, FRAME_ADDRESS
	lw		a0, 0(t0)
	xori	a0, a0, 1

	# print difficulty choice screens
	call	PRINT_DIFFICULTY_SCREEN	# prints board on the occult frame
	li		t0, FRAME_ADDRESS
	sw		a0, 0(t0)				# switches frame

	xori	a0, a0, 1
	call	PRINT_DIFFICULTY_SCREEN	# prints board on the remaining frame

	# keypoll
	DIFF_LOOP:
		li		t0, KEY_ADDRESS
		lw		t1, 0(t0)
		andi	t1, t1, 1			# t1 = 1 if there was a keyboard input, 0 if not
		beqz	t1, DIFF_LOOP		# if there was no char input, check the input again
	
	# input processing
	lw		t0, 4(t0)				# t0 receives the input value (should be an ascii byte value)
	li		t1, 'a'
	beq		t0, t1, DIFF_LEFT
	li		t1, 'd'
	beq		t0, t1, DIFF_RIGHT
	li		t1, '\n'
	beq		t0, t1, END_CHOOSE_DIFFICULTY

	j		DIFF_LOOP				# if the char input isn't 'a', 'd' or '\n', keypoll again

	END_CHOOSE_DIFFICULTY:
	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret							# screen ready, game goes on

DIFF_LEFT:
    j   DIFF_LOOP     
    # gets current CURSOR position
    # sets x position to the left
    # prints the CURSOR on the new position
    # erases the CURSOR on its old position
    # synchronizes the position structs
DIFF_RIGHT:
    j   DIFF_LOOP 