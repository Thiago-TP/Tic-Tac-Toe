#############################################
#	Analyzes BOARD for winning combinations	#
#############################################
#	- Inputs -	#
#	BOARD		#
#############################
#	- Outputs -				#
#	a0=1 if there's a win, 	#
#      0 if a draw, 		#
#	   -1 if else			#
#############################
CHECK_END:
	# return address shall be preserved as other functions will be called
	addi	sp, sp, -4
	sw		ra, 0(sp)

	li		a0, -1

	call	CHECK_TIE
	beqz	a0, END_CHECK

	call	CHECK_LINES
	bgtz	a0, END_CHECK

	call	CHECK_COLUMNS
	bgtz	a0, END_CHECK

	call	CHECK_DIAGONALS

	END_CHECK:
		# recovering of return address 
		lw		ra, 0(sp)
		addi	sp, sp, 4
		ret								# check done, game goes on


CHECK_LINES:
	# return address shall be preserved as other functions will be called
	addi	sp, sp, -4
	sw		ra, 0(sp)

	la		t0, BOARD
	li 		t4, 3
	LINES_LOOP:
		call	CHECK_LINE
		bgtz	a0, END_CHECK_LINES
		addi	t0, t0, 3
		addi	t4, t4, -1
		bgtz	t4, LINES_LOOP
	END_CHECK_LINES:
		# recovering of return address 
		lw		ra, 0(sp)
		addi	sp, sp, 4
		ret	

CHECK_LINE:
	lbu 	t1, 0(t0)
	lbu 	t2, 1(t0)
	lbu 	t3, 2(t0)
	beqz	t1, END_CHECK_LINE
	bne		t1, t2, END_CHECK_LINE
	bne		t2, t3, END_CHECK_LINE
	li		a0, 1
	END_CHECK_LINE:
		ret


CHECK_COLUMNS:
	# return address shall be preserved as other functions will be called
	addi	sp, sp, -4
	sw		ra, 0(sp)

	la		t0, BOARD
	li		t4, 3
	COLUMNS_LOOP:
		call	CHECK_COLUMN
		bgtz	a0, END_CHECK_COLUMNS
		addi	t0, t0, 1
		addi	t4, t4, -1
		bgtz	t4, COLUMNS_LOOP
	END_CHECK_COLUMNS:
		# recovering of return address 
		lw		ra, 0(sp)
		addi	sp, sp, 4
		ret	

CHECK_COLUMN:
	lbu 	t1, 0(t0)
	lbu 	t2, 3(t0)
	lbu 	t3, 6(t0)
	beqz	t1, END_CHECK_COLUMN
	bne		t1, t2, END_CHECK_COLUMN
	bne		t2, t3, END_CHECK_COLUMN
	li		a0, 1
	END_CHECK_COLUMN:
		ret


CHECK_DIAGONALS:
	la		t0, BOARD
	lb		t1, 0(t0)
	lb		t2, 4(t0)
	lb		t3, 8(t0)
	beqz	t1, NEXT_DIAGONAL
	bne		t1, t2, NEXT_DIAGONAL
	bne		t2, t3, NEXT_DIAGONAL
	li		a0, 1
	j		END_CHECK_DIAGONALS

	NEXT_DIAGONAL:
		lb		t1, 2(t0)
		lb		t2, 4(t0)
		lb		t3, 6(t0)
		beqz	t1, END_CHECK_DIAGONALS
		bne		t1, t2, END_CHECK_DIAGONALS
		bne		t2, t3, END_CHECK_DIAGONALS
		li		a0, 1	
	END_CHECK_DIAGONALS:
		ret


CHECK_TIE:
	la		t0, BOARD
	li 		t1, 9
	TIE_LOOP:
		lbu		t2, 0(t0)
		beqz	t2, END_CHECK_TIE 
		addi	t0, t0, 1
		addi	t1, t1, -1
		bgtz	t1, TIE_LOOP
	li	a0, 0
	END_CHECK_TIE:
		ret