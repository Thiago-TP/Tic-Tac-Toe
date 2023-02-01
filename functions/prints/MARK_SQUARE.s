###################################################################
#   Animates the falling of the given symbol to a desired SQUARE  #
###################################################################
#   - Inputs -                      #
#   a1 = x bmp position of SQUARE   #
#   a2 = y bmp position of SQUARE   #
#   a3 = currently hidden frame     #
#   a4 = SYMBOL sprite              #
#####################################
#   - Outputs -                 #
#   falling animation           #
#   updating of BOARD struct    #
#################################
MARK_SQUARE:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -12
    sw      ra, 0(sp)
    sw      s2, 4(sp)
    sw      a0, 8(sp)

    # cleans CURSOR
    call    STASH_BACKGROUND
    li      t0, FRAME_ADDRESS
    sw      a3, 0(t0)
    call    RETURN_BACKGROUND
    
    # moves y position into saved register for later comparison
    mv      s2, a2

    # falling animation into position (a1, s2)
    mv      a0, a4
    li      a2, 0   # initial height  
    li      a5, 64  # stashed background width
    li      a6, 64  # stashed background height
    FALL_LOOP:
        # stashes the background of current position for clean up later
        call    STASH_BACKGROUND
        
        # updates the SYMBOL, switching the frame
        addi    a2, a2, 1
        call    PRINT
        li      t0, FRAME_ADDRESS
        sw      a3, 0(t0)

        xori    a3, a3, 1
        
        # cleans up trail at the previous frame
        addi    a2, a2, -1
        call    RETURN_BACKGROUND
        addi    a2, a2, 1
        blt     a2, s2, FALL_LOOP   # keep falling if bottom has not been hit

    # printing of symbol on both frames
    mv      a2, s2
    call    PRINT

    # recovering of return address 
	lw		ra, 0(sp)
    lw      s2, 4(sp)
    lw      a0, 8(sp)
	addi	sp, sp, 12
	ret
