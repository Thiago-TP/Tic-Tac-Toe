#############################################################################
#   For each line, column and diagonal, checks if theres an empty SQUARE    #
#   among 2 same valued, occupied, ones.                                    #
#############################################################################
#   - Inputs -                              #
#   s11 = desired value of occupied SQUAREs #
#############################################
#   - Outputs - #
#   PC play     #
#################
MAKE_OR_BLOCK_TRIPLE:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    # triple among lines
    call    TRIPLE_IN_LINES
    bgtz    a1, END_MAKE_OR_BLOCK_TRIPLE

    # triple among columns
    call    TRIPLE_IN_COLUMNS
    bgtz    a1, END_MAKE_OR_BLOCK_TRIPLE

    # triple among diagonals
    call    TRIPLE_IN_DIAGONALS

    END_MAKE_OR_BLOCK_TRIPLE:
    # recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret


TRIPLE_IN_LINES:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    li      a1, 0
    la      t0, BOARD
    
    call    TRIPLE_IN_LINE
    bgtz    a1, END_TRIPLE_IN_LINES
        
    addi    t0, t0, 3
    call    TRIPLE_IN_LINE
    bgtz    a1, END_TRIPLE_IN_LINES

    addi    t0, t0, 3
    call    TRIPLE_IN_LINE
    bgtz    a1, END_TRIPLE_IN_LINES

    END_TRIPLE_IN_LINES:
        # recovering of return address 
        lw		ra, 0(sp)
        addi	sp, sp, 4
        ret
TRIPLE_IN_COLUMNS:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    li      a1, 0
    la      t0, BOARD
    
    call    TRIPLE_IN_COLUMN
    bgtz    a1, END_TRIPLE_IN_COLUMNS
        
    addi    t0, t0, 3
    call    TRIPLE_IN_COLUMN
    bgtz    a1, END_TRIPLE_IN_COLUMNS

    addi    t0, t0, 3
    call    TRIPLE_IN_COLUMN
    bgtz    a1, END_TRIPLE_IN_COLUMNS

    END_TRIPLE_IN_COLUMNS:
        # recovering of return address 
        lw		ra, 0(sp)
        addi	sp, sp, 4
        ret
TRIPLE_IN_DIAGONALS:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    la      t0, BOARD
    call    TRIPLE_IN_MAIN_DIAGONAL
    bgtz    a1, END_TRIPLE_IN_DIAGONALS

    la      t0, BOARD
    call    TRIPLE_IN_OTHER_DIAGONAL

    END_TRIPLE_IN_DIAGONALS:
        # recovering of return address 
        lw		ra, 0(sp)
        addi	sp, sp, 4
        ret


TRIPLE_IN_LINE:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    lbu     t1, 0(t0)
    lbu     t2, 1(t0)
    lbu     t3, 2(t0)
    li      t4, 0
    li      t5, 1
    li      t6, 2
    beqz    t1, CASE_0XX
    beqz    t2, CASE_X0X
    beqz    t3, CASE_XX0
    # recovering of return address 
    lw		ra, 0(sp)
    addi	sp, sp, 4
    ret
TRIPLE_IN_COLUMN:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    lbu     t1, 0(t0)
    lbu     t2, 3(t0)
    lbu     t3, 6(t0)
    li      t4, 0
    li      t5, 3
    li      t6, 6
    beqz    t1, CASE_0XX
    beqz    t2, CASE_X0X
    beqz    t3, CASE_XX0
    # recovering of return address 
    lw		ra, 0(sp)
    addi	sp, sp, 4
    ret
TRIPLE_IN_MAIN_DIAGONAL:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    lbu     t1, 0(t0)
    lbu     t2, 4(t0)
    lbu     t3, 8(t0)
    li      t4, 0
    li      t5, 4
    li      t6, 8
    beqz    t1, CASE_0XX
    beqz    t2, CASE_X0X
    beqz    t3, CASE_XX0
    # recovering of return address 
    lw		ra, 0(sp)
    addi	sp, sp, 4
    ret
TRIPLE_IN_OTHER_DIAGONAL:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

    lbu     t1, 2(t0)
    lbu     t2, 4(t0)
    lbu     t3, 6(t0)
    li      t4, 2
    li      t5, 4
    li      t6, 6
    beqz    t1, CASE_0XX
    beqz    t2, CASE_X0X
    beqz    t3, CASE_XX0
    # recovering of return address 
    lw		ra, 0(sp)
    addi	sp, sp, 4
    ret

CASE_0XX:   bne     t2, t3, END_CHECK_TRIPLE
            bne     s11, t2, END_CHECK_TRIPLE
            
            la      a0, BOARD
            sub     a0, t0, a0
            add     a0, a0, t4
            call    CONVERT_IND_TO_POS
            call    MARK_SQUARE
            
            call    CONVERT_POS_TO_IND
            la      t1, BOARD
            add     t0, t0, t1
            li      t1, 2
            sb      t1, 0(t0)   
            j       END_CHECK_TRIPLE 

CASE_X0X:   bne     t1, t3, END_CHECK_TRIPLE
            bne     s11, t1, END_CHECK_TRIPLE
            
            la      a0, BOARD
            sub     a0, t0, a0
            add     a0, a0, t5
            call    CONVERT_IND_TO_POS
            call    MARK_SQUARE

            call    CONVERT_POS_TO_IND
            la      t1, BOARD
            add     t0, t0, t1
            li      t1, 2
            sb      t1, 0(t0) 
            j       END_CHECK_TRIPLE  

CASE_XX0:   bne     t1, t2, END_CHECK_TRIPLE
            bne     s11, t1, END_CHECK_TRIPLE
            
            la      a0, BOARD
            sub     a0, t0, a0
            add     a0, a0, t6
            call    CONVERT_IND_TO_POS
            call    MARK_SQUARE

            call    CONVERT_POS_TO_IND
            la      t1, BOARD
            add     t0, t0, t1
            li      t1, 2
            sb      t1, 0(t0) 
            j       END_CHECK_TRIPLE 

END_CHECK_TRIPLE:
    # recovering of return address 
    lw		ra, 0(sp)
    addi	sp, sp, 4
    ret     