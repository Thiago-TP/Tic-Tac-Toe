CHOOSE_DIFFICULTY:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	# gets the current frame being shown
	li		t0, FRAME_ADDRESS
	lw		a3, 0(t0)
	xori	a3, a3, 1

	# print difficulty choice screens
	call	PRINT_DIFFICULTY_SCREEN	# prints board on the occult frame

	# print "EASY selected"
	la		a0, CHOOSE_DIFFICULTY_MSG1
	li 		a1, 31
	li 		a2, 185
	li		a4, TIE_MSG_COLOR
	call	PRINT_STRING

	# print CURSOR
	la		a0, SMALL_CURSOR
	li 		a1, 50
	li 		a2, 100
	call	PRINT

	li		t0, FRAME_ADDRESS
	sw		a3, 0(t0)				# switches frame

	xori	a3, a3, 1
	call	PRINT_DIFFICULTY_SCREEN	# prints board on the remaining frame

	# initializes cursor position for interaction with PLAYER
	la	t0, CURSOR_OLD_POSITION
	li	t1, 50						# x bmp position
	li 	t2, 100						# y bmp position
	sh	t1, 0(t0)
	sh	t2, 2(t0)
	la	t0, CURSOR_POSITION
	sh	t1, 0(t0)
	sh	t2, 2(t0)

	la		a0, SMALL_CURSOR

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
	# sets the difficulty flag
	la		t0, CURSOR_OLD_POSITION
	lhu		t0, 0(t0)				# t0 = 50, 140 or 230
	addi	s1, t0, -140			# s1 = -90, 0 or 90
	li 		t0, 90
	div		s1, s1, t0			# s1 = -1 if EASY was chosen, 0 if MEDIUM, 1 if HARD
	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret								# screen ready, game goes on

DIFF_LEFT:	
    # gets current CURSOR position
	la		t0, CURSOR_OLD_POSITION
	lhu		a1, 0(t0)

    # sets x position to the left
	li		t0, 50
	ble 	a1, t0, DIFF_LOOP	# if we're are already at the left, keypoll again
	addi	a1, a1, -90
	
    # prints the CURSOR on the new position, and the message
	call	UPDATE_SMALL_CURSOR 

    # synchronizes the position structs
	la		t0, CURSOR_OLD_POSITION
	sh		a1, 0(t0)
	la		t0, CURSOR_POSITION
	sh		a1, 0(t0)

    # erases the CURSOR on its old position
	li		t0, 90				# offset on x axis for cleaning
	call	CLEAN_OLD_SMALL_CURSOR

	# movement done, return to keypoll
	la		a0, SMALL_CURSOR
	j   	DIFF_LOOP

DIFF_RIGHT:
	# gets current CURSOR position
	la		t0, CURSOR_OLD_POSITION
	lhu		a1, 0(t0)

    # sets x position to the left
	li		t0, 230
	bge 	a1, t0, DIFF_LOOP	# if we're are already at the right, keypoll again
	addi	a1, a1, 90
	
    # prints the CURSOR on the new position, and the message
	call	UPDATE_SMALL_CURSOR 

	# erases the CURSOR on its old position
	li		t0, -90				# offset on x axis for cleaning
	call	CLEAN_OLD_SMALL_CURSOR

	# movement done, return to keypoll
	la		a0, SMALL_CURSOR
	j   	DIFF_LOOP


UPDATE_SMALL_CURSOR:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	mv		s1, a1
	call	PRINT
	call	PICK_DIFFICULTY_MSG
	li 		a2, 185
	call	PRINT_STRING
	mv		a1, s1
	li 		a2, 100

	li		t0, FRAME_ADDRESS
	sw		a3, 0(t0)			# reveals frame
	xori	a3, a3, 1			# inverts frame in preparation for next CURSOR movement	

    # synchronizes the position structs
	la		t0, CURSOR_OLD_POSITION
	sh		a1, 0(t0)
	la		t0, CURSOR_POSITION
	sh		a1, 0(t0)

	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret								# screen ready, game goes on

PICK_DIFFICULTY_MSG:
	li		t0, 140
	blt		a1, t0, DIFF_MSG1
	beq		a1, t0, DIFF_MSG2
	
	la		a0, CHOOSE_DIFFICULTY_MSG3
	addi 	a1, a1, -19

	END_PICK_DIFFICULTY_MSG:
		ret
	DIFF_MSG1:	la	a0, CHOOSE_DIFFICULTY_MSG1
				addi 	a1, a1, -19
				j	END_PICK_DIFFICULTY_MSG
	DIFF_MSG2:	la	a0, CHOOSE_DIFFICULTY_MSG2
				addi 	a1, a1, -25
				j	END_PICK_DIFFICULTY_MSG


CLEAN_OLD_SMALL_CURSOR:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	la		a0, SMALL_CURSOR_HUSK
	add		a1, a1, t0
	call	PRINT

	# erases the old message
	la		a0, CHOOSE_DIFFICULTY_MSG2
	addi 	a1, a1, -19
	li 		a2, 185
	li		a4, 0
	call	PRINT_STRING
	addi 	a1, a1, 19
	li 		a2, 100
	li		a4, TIE_MSG_COLOR

	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret								# screen ready, game goes on