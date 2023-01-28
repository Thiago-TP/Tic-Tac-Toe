#####################################################
#   Prints the board of the game at a given frame   #
#####################################################
#   - Inputs -  #
#   a0 = frame  #
#####################
#   - Outputs -     #
#   printed board   #
#####################
PRINT_BOARD:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    call    BLACK_SCREEN

    # preparation of variables for printing of squares
    mv  a3, a0      # frame
    la  a0, SQUARE  # board tile sprite
    li  a1, 64      # bmp x position
    li  a2, 24      # bmp y position
    li  a4, 3       # matrixcol counter
    li  a5, 3       # line counter
    BOARD_LINE_LOOP:  
        call    PRINT       # prints a tile
        addi    a1, a1, 64  # sets up the x position of the next tile
        addi    a4, a4, -1  # one less tile to go
        bgtz    a4, BOARD_LINE_LOOP # if there are any tiles left in the line, loop back

        li      a4, 3       # resets the column counter
        li      a1, 64
        addi    a2, a2, 64  # sets up the x position of the next tile
        addi    a5, a5, -1  # one less line to go
        bgtz    a5, BOARD_LINE_LOOP # if there are any lines left, loop back
    
    # prints decoration characters
    la      a0, mariozin
    li      a1, 24
    li      a2, 224
    call    PRINT           # 16x16 mario on the left

    la      a0, bowserzin
    li      a1, 272
    li      a2, 208
    call    PRINT           # 32x32 bowser on the right    
    mv      a0, a3          # a0 gets its value back

    # recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret						# screen ready, game goes on
    