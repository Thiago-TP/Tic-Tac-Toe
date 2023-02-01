#########################################################
#   Generates BOARD index value from bmp (x, y) tuple   #
#########################################################
#   - Inputs -          #
#   a1 = bmp x position #
#   a2 = bmp y position #
#################################
#   - Output -                  #
#   t0 = index value (0 to 8)   #
#################################
CONVERT_POS_TO_IND:    
    addi    t0, a1, -64     # t0 = 0, 64 or 128
    srli    t0, t0, 6       # t0 = 0, 1 or 2
    addi    t1, a2, -24     # t1 = 0, 64 or 128
    srli    t1, t1, 6       # t1 = 0, 1 or 2
    li      t2, 3
    mul     t1, t1, t2      # t1 = 0, 3 or 6
    add     t0, t0, t1      # t0 = 0, 1, ..., 8 = BOARD index
    ret                     # convertion done, game goes on

#########################################################
#   Generates bmp (x, y) tuple from BOARD index value   #
#########################################################
#   - Input -                   #
#   a0 = index value (0 to 8)   #
#################################
#   - Outputs -         #
#   a1 = bmp x position #
#   a2 = bmp y position #
#########################
CONVERT_IND_TO_POS:
    li      t0, 3
    remu    a1, a0, t0      # a1 <- index offset in x (0, 1, or 2)
    divu    a2, a0, t0      # a2 <- index offset in y (0, 1, or 2)
    slli    a1, a1, 6       # a1 <- bmp offset in x (0, 64, or 128)
    slli    a2, a2, 6       # a2 <- bmp offset in y (0, 64, or 128)
    addi    a1, a1, 64      # a1 <- final bmp x position (64, 128, or 192)
    addi    a2, a2, 24      # a2 <- final bmp x position (24, 88, or 152)
    ret                     # convertion done, game goes on