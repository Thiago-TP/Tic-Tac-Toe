#########################################################################
#	PLAYER uses keyboard inputs to move CURSOR and select a difficulty.	#
#	The difficulty symbols are equally spaced 64x64 sprites. 			#
#	Both frames are used to guarantee smooth animation.					#
#	Trails are cleaned by STASH_BACKGROUND and RETURN_BACKGROUND.		#
#########################################################################
#	- Input -						#
#	keyboard chars 'a', 'd', '\n'	#
#####################################################################
#	- Output -														#
#	setting of s1 = difficulty value (-1=EASY, 0=MEDIUM, 1=HARD)	#
#####################################################################
CHOOSE_DIFFICULTY:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	# gets the current frame being shown
	li		t0, FRAME_ADDRESS
	lw		a3, 0(t0)
	xori	a3, a3, 1				# inverts it

	# print difficulty choice screens
	call	PRINT_DIFFICULTY_SCREEN	# prints board on the occult frame

	# print "EASY selected"
	la		a0, CHOOSE_DIFFICULTY_MSG1
	li 		a1, 25
	li 		a2, 185
	li		a4, TIE_MSG_COLOR
	call	PRINT_STRING

	# print CURSOR
	la		a0, CURSOR
	li 		a1, 32
	li 		a2, 88
	call	PRINT

	li		t0, FRAME_ADDRESS
	sw		a3, 0(t0)				# switches frame

	xori	a3, a3, 1
	call	PRINT_DIFFICULTY_SCREEN	# prints board on the remaining frame

	# initializes cursor position for interaction with PLAYER
	la	a0, CURSOR
	li	a1, 32						# x bmp position
	li 	a2, 88						# y bmp position

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
		addi	s1, a1, -128		# a1 = 32, 128 or 224 => s1 = -96, 0 or 96
		li 		t0, 96
		div		s1, s1, t0			# s1 = -1 if EASY was chosen, 0 if MEDIUM, 1 if HARD
	
	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret								# screen ready, game goes on

DIFF_LEFT:
	# if we're are already at the left, keypoll again
	li		t0, 32
	ble 	a1, t0, DIFF_LOOP	
	
	# puts background in stack for future cleaning
	call	STASH_BACKGROUND

	# prints cursor on the updated position
	addi	a1, a1, -96
	call	PRINT

	# prints "DIFFICULTY selected" message
	call	PRINT_DIFFICULTY_MESSAGE

	# switches shown frame, showing new position
	li 		t0, FRAME_ADDRESS
	sw 		a3, 0(t0)

	# cleans CURSOR trail
	addi	a1, a1, 96
	call	RETURN_BACKGROUND
	addi	a1, a1, -96

	# cleans message trail
	xori 	a3, a3, 1
	call	CLEAN_MESSAGE_TRAIL

	# movement done, return to keypoll
	j   	DIFF_LOOP

DIFF_RIGHT:
	# if we're are already at the right, keypoll again
	li		t0, 224
	bge 	a1, t0, DIFF_LOOP	
	
	# puts background in stack for future cleaning
	call	STASH_BACKGROUND

	# prints cursor on the updated position
	addi	a1, a1, 96
	call	PRINT
	
	# prints "DIFFICULTY selected" message
	call	PRINT_DIFFICULTY_MESSAGE

	# switches frame, showing new position
	li 		t0, FRAME_ADDRESS
	sw 		a3, 0(t0)

	# cleans CURSOR trail
	addi	a1, a1, -96
	call	RETURN_BACKGROUND
	addi	a1, a1, 96 

	# cleans message trail
	xori 	a3, a3, 1
	call	CLEAN_MESSAGE_TRAIL

	# movement done, return to keypoll
	j   	DIFF_LOOP


#################################################################################################
#	Print an indication of currently selected difficulty according to the position of CURSOR.	#
#################################################################################################
#	- Input -						#
# 	a1 = bmp x position				#
#	a3 = printing frame (0, or 1)	#
#####################################
#	- Output -		#
#	printed message	#
#####################
PRINT_DIFFICULTY_MESSAGE:
	addi 	sp, sp, -16
	sw		ra, 0(sp)
	sw		a0, 4(sp)
	sw		a1, 8(sp)
	sw		a2, 12(sp)

	li 		a2, 185 
	li 		a4, TIE_MSG_COLOR

	li 		t0, 128 
	blt 	a1, t0, PRINT_EASY_SELECTED
	beq 	a1, t0, PRINT_MEDIUM_SELECTED

	la 		a0, CHOOSE_DIFFICULTY_MSG3		# "HARD selected"
	li 		a1, 217

	END_PRINT_DIFFICULTY_MESSAGE:
		call	PRINT_STRING

		lw		ra, 0(sp)
		lw		a0, 4(sp)
		lw		a1, 8(sp)
		lw		a2, 12(sp)
		addi 	sp, sp, 16
		ret

PRINT_EASY_SELECTED:	la 		a0, CHOOSE_DIFFICULTY_MSG1		# "EASY selected"
						li 		a1, 25
						j		END_PRINT_DIFFICULTY_MESSAGE
PRINT_MEDIUM_SELECTED:	la 		a0, CHOOSE_DIFFICULTY_MSG2		# "MEDIUM selected"
						li 		a1, 115
						j		END_PRINT_DIFFICULTY_MESSAGE


#####################################################################
#	Cleans the the trails left by messages on the right and left.	#
#	The middle message leaves no trail.								#
#####################################################################
#	- Input -			#
#	a3 = printing frame	#
#################################################
#	- Output -									#
#	covered (blackened) messages on frame a3	#
#################################################
CLEAN_MESSAGE_TRAIL:
	addi 	sp, sp, -16
	sw		ra, 0(sp)
	sw		a0, 4(sp)
	sw		a1, 8(sp)
	sw		a2, 12(sp)

	la 		a0, CHOOSE_DIFFICULTY_MSG1	# "EASY selected"
	li		a1, 25 
	li 		a2, 185
	li 		a4, 0						# all black font color 
	call 	PRINT_STRING				# covers "EASY selected"

	la 		a0, CHOOSE_DIFFICULTY_MSG3	# "HARD selected"
	li		a1, 217 
	call 	PRINT_STRING				# covers "HARD selected"

	lw		ra, 0(sp)
	lw		a0, 4(sp)
	lw		a1, 8(sp)
	lw		a2, 12(sp)
	addi 	sp, sp, 16
	ret