#############################################################################
#	Prints a given sprite (.data) at a given bmp position of a given frame	#
#   in grayscale. The image is printed out line by line, pixel by pixel.	#
#############################################################################
#	- Inputs -						#
#	a0 = sprite's memory address	#
#	a1 = bmp x position				#
#	a2 = bmp y position				#
#	a3 = frame						#
#####################################
#	- Outputs - 			#
#	printed image on bitmap	#
#############################
PRINT_GRAY:
    # return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	# gets the base address
	li		t0, 0xFF0
	add		t0, t0, a3	# t0 = 0xFF0 or 0xFF1
	slli	t0, t0, 20	# t0 = 0xFF0_00000 or 0xFF1_00000, the base address

	# gets the file dimensions
	lw		t1, 0(a0)	# t1 <- width of the sprite
	lw		t2, 4(a0)	# t2 <- height of the sprite

	# gets the starting address by offsetting the base address
	add		t0, t0, a1	
	li		t3, 320
	mul		t3, t3, a2
	add		t0, t0, t3	# t0 <- base add + x + 320*y, the starting address for actually printing the picture

	# gets the address of first pixel
	addi	t3, a0, 8	# 2 words skipped, first byte reached in .data file

	# sets the invisible color byte
	li		t4, 199

	# prints out a line pixel by pixel, until all lines are done
	GRAY_LINE_LOOP:
		lbu		t5, 0(t3)		# gets the current pixel color
		beq		t5, t4, DONT_GRAY	# invisible color should not be printed
		jal 	GRAY_PIXEL		# turns color gray
		sb		t5, 0(t0)		# prints the pixel on the bmp
	DONT_GRAY:
		addi	t3, t3, 1		# go to next color address
		addi	t0, t0, 1		# go to next bmp address
		addi	t1, t1, -1		# one less pixel to go
		bgtz	t1, GRAY_LINE_LOOP	# keep printing the line if there are any pixels left

		addi	t2, t2, -1		# one less line to go
		lw		t1, 0(a0)		# restarts the pixel count
		addi	t0, t0, 320		# jumps down a line on the bitmap, reaching the right side
		sub 	t0, t0, t1 		# shifts to the left side of the line
		bgtz	t2, GRAY_LINE_LOOP	# keep printing more lines if there are any left
	
    lw      ra, 0(sp)
    addi    sp, sp, 4
	ret							# image has been printed out, we are done	


#################################################################################
#	Takes a byte value of a pixel color and transforms it into its gray version.# 
#	This is achhieved by a arithmetic average of the original RGB value.		#
#	Should only be called by PRINT_GRAY and HIGHLIGHT_WIN.						#					
#################################################################################
#	- Input -		#
#	t5 = byte value	#
#############################
#	- Output -				#
#	t5 = gray byte value	#
#############################
GRAY_PIXEL:	# temporaries t0-t2 must be saved as they're key for PRINT_GRAY and HIGHLIGHT_WIN
	addi	sp, sp, -12
	sw 		t0, 0(sp)
	sw 		t1, 4(sp)
	sw 		t2, 8(sp)

	# gets the original RGB value (t5 = 0b_bb_ggg_rrr)
	srli 	t0, t5, 6		# t0 <- 0b00_000_0bb
	andi 	t1, t5, 0x38	# t1 <- 0b00_ggg_000
	srli 	t1, t1, 3		# t1 <- 0b00_000_ggg
	andi 	t2, t5, 0x07	# t2 <- 0b00_000_rrr

	slli	t0, t0, 6 		# t0 <-  bb*64 = B
	slli 	t1, t1, 5 		# t1 <- ggg*32 = G
	slli	t2, t2, 5 		# t2 <- rrr*32 = R

	# calculates the gray RGB value
    li      t6, 3
	add 	t0, t0, t1		# t0 <- B + G
	add 	t0, t0, t2		# t0 <- B + G + R
	divu	s2, t0, t6		# s2 <- (B + G + R)/3 = Bg = Gg = Rg

	# makes the gray byte from gray RGB
	srli	t0, s2, 6		# t0 <- Bg/64 = bb
	srli	t1, s2, 5		# t1 <- Gg/32 = ggg
	srli	t2, s2, 5		# t2 <- Rg/32 = rrr

	slli	t0, t0, 6		# t0 <- 0b_bb_000_000
	slli	t1, t1, 3		# t1 <- 0b_00_ggg_000
	add 	t5, t0, t1		# t5 <- 0b_bb_ggg_000
	add 	t5, t5, t2 		# t5 <- 0b_bb_ggg_rrr
	
	# conversion to gray done, PRINT_GRAY goes on
	lw 		t0, 0(sp)
	lw 		t1, 4(sp)
	lw 		t2, 8(sp)
	addi	sp, sp, 12
	ret
	