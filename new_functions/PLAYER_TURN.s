#########################################################################################
#	Keypolls PLAYER input and puts their symbol on the selected square, if possible.	#
#	If not, keypolls again.																#
#########################################################################################
#	- Inputs -				#
#	PLAYER's keyboard input	#
#################################
#	- Outputs -					#
#	square marking animation	#
#################################
PLAYER_TURN:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    # initializes CURSOR (a3 = frame already initiated in INITIALIZE_BOARD)
    la      a0, CURSOR 
    li      a1, 64      # x bmp position
    li      a2, 24      # y bmp position
    xori    a3, a3, 1
    call    PRINT
    li      t0, FRAME_ADDRESS
    sw      a3, 0(t0)
    xori    a3, a3, 1
    li      a5, 64      # stashed sprite length
    li      a6, 64      # stashed sprite height

	# main keypoll of the game
	GAME_KEYPOLL:
		li		t0, KEY_ADDRESS
		lw		t1, 0(t0)
		andi	t1, t1, 1			# t1 = 1 if there was a keyboard input, 0 if not
		beqz	t1, GAME_KEYPOLL	# if there was no char input, check the input again
	
	# input processing
	lw		t0, 4(t0)				# t0 receives the input value (should be an ascii byte value)
	li		t1, 'w'
	beq		t0, t1, CURSOR_UP
	li		t1, 'a'
	beq		t0, t1, CURSOR_LEFT
	li		t1, 's'
	beq		t0, t1, CURSOR_DOWN
	li		t1, 'd'
	beq		t0, t1, CURSOR_RIGHT
	li		t1, '\n'
	beq		t0, t1, TRY_SQUARE

	j		GAME_KEYPOLL			# if the char input isn't 'wasd' or '\n', keypoll again
	
    END_PLAYER_TURN:
	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret

CURSOR_UP:
    # if already at the top, don't move up
    li      t0, 24
    beq     a2, t0, GAME_KEYPOLL
    # stashes the background of current position for clean up later
    call    STASH_BACKGROUND
    # updates the cursor, switching the frame
    addi    a2, a2, -64
    call    PRINT
    li      t0, FRAME_ADDRESS
    sw      a3, 0(t0)
    xori    a3, a3, 1
    # cleans up trail at the previous frame
    addi    a2, a2, 64
    call    RETURN_BACKGROUND
    addi    a2, a2, -64
    # animation done, keypoll again
    j       GAME_KEYPOLL

CURSOR_DOWN:
    # if already at the bottom, don't move down
    li      t0, 152
    beq     a2, t0, GAME_KEYPOLL
    # stashes the background of current position for clean up later
    call    STASH_BACKGROUND
    # updates the cursor, switching the frame
    addi    a2, a2, 64
    call    PRINT
    li      t0, FRAME_ADDRESS
    sw      a3, 0(t0)
    xori    a3, a3, 1
    # cleans up trail at the previous frame
    addi    a2, a2, -64
    call    RETURN_BACKGROUND
    addi    a2, a2, 64
    # animation done, keypoll again
    j       GAME_KEYPOLL

CURSOR_LEFT:
    # if already at the left, don't move left
    li      t0, 64
    beq     a1, t0, GAME_KEYPOLL
    # stashes the background of current position for clean up later
    call    STASH_BACKGROUND
    # updates the cursor, switching the frame
    addi    a1, a1, -64
    call    PRINT
    li      t0, FRAME_ADDRESS
    sw      a3, 0(t0)
    xori    a3, a3, 1
    # cleans up trail at the previous frame
    addi    a1, a1, 64
    call    RETURN_BACKGROUND
    addi    a1, a1, -64
    # animation done, keypoll again
    j       GAME_KEYPOLL

CURSOR_RIGHT:
    # if already at the left, don't move left
    li      t0, 192
    beq     a1, t0, GAME_KEYPOLL
    # stashes the background of current position for clean up later
    call    STASH_BACKGROUND
    # updates the cursor, switching the frame
    addi    a1, a1, 64
    call    PRINT
    li      t0, FRAME_ADDRESS
    sw      a3, 0(t0)
    xori    a3, a3, 1
    # cleans up trail at the previous frame
    addi    a1, a1, -64
    call    RETURN_BACKGROUND
    addi    a1, a1, 64
    # animation done, keypoll again
    j       GAME_KEYPOLL

TRY_SQUARE: 
    li      s2, 1
    la      a4, O_SYMBOL
    # sees if SQUARE is occupied, marks it if not
    call    CONVERT_POS_TO_IND  # converts bmp position to BOARD index
    
    la      t1, BOARD
    add     t0, t0, t1          # t0 = address of SQUARE in BOARD
    lbu     t1, 0(t0)           # t1 = status of SQUARE

    bnez    t1, GAME_KEYPOLL    # if occupied, keypoll again
    sb      s2, 0(t0)           # updates BOARD

    beqz    s0, PLAYER_CHOSE_X

    call    MARK_SQUARE         # marks the current SQUARE, if empty (animation included)
    
    # animation done, keypoll again
    j       END_PLAYER_TURN
    
    PLAYER_CHOSE_X:
        la      a4, X_SYMBOL
        call    MARK_SQUARE         # marks the current SQUARE, if empty (animation included)
        
        # animation done, turn's over
        j       END_PLAYER_TURN