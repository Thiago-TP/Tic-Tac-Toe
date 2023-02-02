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
    