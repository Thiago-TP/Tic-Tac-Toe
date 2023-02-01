#############################################################################
#	Prints a given sprite (.data) at a given bmp position of a given frame.	#
#	The image is printed out line by line, pixel by pixel.					#
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
PRINT:
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
	LINE_LOOP:
		lbu		t5, 0(t3)		# gets the current pixel color
		beq		t5, t4, DONT_PRINT	# invisible color should not be printed
		sb		t5, 0(t0)		# prints the pixel on the bmp
	DONT_PRINT:
		addi	t3, t3, 1		# go to next color address
		addi	t0, t0, 1		# go to next bmp address
		addi	t1, t1, -1		# one less pixel to go
		bgtz	t1, LINE_LOOP	# keep printing the line if there are any pixels left

		addi	t2, t2, -1		# one less line to go
		lw		t1, 0(a0)		# restarts the pixel count
		addi	t0, t0, 320		# jumps down a line on the bitmap, reaching the right side
		sub 	t0, t0, t1 		# shifts to the left side of the line
		bgtz	t2, LINE_LOOP	# keep printing more lines if there are any left
		
	ret							# image has been printed out, we are done	
