#####################################################
#   Highlights the winning line, if there was one   #
#####################################################
#   - Inputs -          #
#   a0 = game state     #
#   WIN_COMBO struct    #
#########################
#   - Outputs -     #
#   fancy screen    #
#####################
HIGHLIGHT_WIN:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -8
    sw      ra, 0(sp)
    sw      a0, 4(sp)

    beqz    a0, NO_HIGHLIGHT 

    # get winning indexes's values
    la      t0, WIN_COMBO
    lbu     a4, 0(t0)         
    lbu     a5, 1(t0)
    lbu     a6, 2(t0)
  
    li 		t0, FRAME_ADDRESS
    li      t1, 1
	sw		t1, 0(t0)					# shows frame 1

    li      a0, 9
    HIGHLIGHT_LOOP:
        addi    a0, a0, -1              # try the next index
        beq     a0, a4, DONT_HIGHLIGHT  # if index houses a winning SYMBOL, go to the next index
        beq     a0, a5, DONT_HIGHLIGHT
        beq     a0, a6, DONT_HIGHLIGHT
        call    CONVERT_IND_TO_POS
        call    GRAY_TILE               # index does not house a winning piece -> turns it gray
        DONT_HIGHLIGHT:
            bgtz    a0, HIGHLIGHT_LOOP      # keeps going until all indexes have ben checked
    
    # shows frame 0
    li      t0, FRAME_ADDRESS
    sw      zero, 0(t0)
    fpg:    j fpg
    
    NO_HIGHLIGHT:
        # recovering of return address 
        lw		ra, 0(sp)
        lw		a0, 4(sp)
        addi	sp, sp, 8
        ret						# screen ready, game goes on
    
#################################################################################
#   Turns 64x64 sprite, located in given bmp position and frame, gray.          #
#   This is done by transferring same position pixels from frame 1 to frame 0.  #
#################################################################################
#   - Inputs -          #
#   a1 = x bmp position #
#   a2 = y bmp position #
#########################
GRAY_TILE:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    li      t0, 0xFF000000
    li      t1, 0x00100000
    add     t0, t0, a1 
    li      t2, 320
    mul     t2, t2, a2 
    add     t0, t0, t2      # t0 <- frame 0 starting address of sprite
    add     t1, t1, t0      # t1 <- frame 1 starting address of sprite

    li      t2, 64          # tile width 
    li      t3, 64          # tile height
    GRAY_TILE_LOOP: 
        lbu     t5, 0(t1)   # gets a pixel from frame 1
        mv      a7, t1
        call    GRAY_PIXEL  # turns pixel gray
        mv      t1, a7
        sb      t5, 0(t0)   # puts it in frame 0 
        addi    t0, t0, 1   # go to next pixel position in frame 0
        addi    t1, t1, 1   # go to next pixel position in frame 1
        addi    t2, t2, -1  # one less pixel to go
        bgtz    t2, GRAY_TILE_LOOP  # if there are pixels left on the line, keep going

        li      t2, 64      # restarts the line
        addi    t0, t0, 256
        addi    t1, t1, 256
        # sub     t0, t0, t2  # gets the address of the first pixel on the line below at frame 0
        # sub     t1, t1, t2  # gets the address of the first pixel on the line below at frame 1
        addi    t3, t3, -1  # one less line to go
        bgtz    t3, GRAY_TILE_LOOP  # if there are lines left on the sprite, keep going
    
    lw      ra, 0(sp)
    addi    sp, sp, 4
	ret						# image has been grayed out, we are done
