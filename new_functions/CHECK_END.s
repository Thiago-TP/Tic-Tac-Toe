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

	call	CHECK_LINES
	bgtz	a0, END_CHECK

	call	CHECK_COLUMNS
	bgtz	a0, END_CHECK

	call	CHECK_DIAGONALS
	bgtz	a0, END_CHECK

	call	CHECK_TIE

	END_CHECK:
		call	UPDATE_COUNTERS
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
	mv		a0, t1
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
	mv		a0, t1
	END_CHECK_COLUMN:
		ret


CHECK_DIAGONALS:
	# checking of main diagonal
	la		t0, BOARD
	lb		t1, 0(t0)
	lb		t2, 4(t0)
	lb		t3, 8(t0)
	beqz	t1, NEXT_DIAGONAL
	bne		t1, t2, NEXT_DIAGONAL
	bne		t2, t3, NEXT_DIAGONAL
	mv		a0, t1
	j		END_CHECK_DIAGONALS

	NEXT_DIAGONAL:
		lb		t1, 2(t0)
		lb		t2, 4(t0)
		lb		t3, 6(t0)
		beqz	t1, END_CHECK_DIAGONALS
		bne		t1, t2, END_CHECK_DIAGONALS
		bne		t2, t3, END_CHECK_DIAGONALS
		mv		a0, t1	
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


#########################################################
#	Updates THE_BIG_COUNTER struct according to a value	#
#	0 -> tie, 1 -> win, 2-> loss, -1 -> none			#
#########################################################
#	- Input -				#
#	a0 = game status value	#
#####################################################
#	- Output -										#
#	updated THE_BIG_COUNTER	(possibly unchanged)	#
#####################################################
UPDATE_COUNTERS:
	# nobody won or tied -> change nothing
	bltz 	a0, NO_CHANGE

	# gets each counter separately
	la		t0, THE_BIG_COUNTER
	lw		t0, 0(t0)
    srli    t1, t0, 24              # t1 <- 0x00_00_00_ww = win counter
    slli    t2, t0, 8
    srli    t2, t2, 24              # t2 <- 0x00_00_00_ll = loss counter
    slli    t3, t0, 16
    srli    t3, t0, 24              # t3 <- 0x00_00_00_tt = tie counter
    slli    t4, t0, 24
    srli    t4, t0, 24              # t4 <- 0x00_00_00_gg = games played counter

	addi	t4, t4, 1				# one more game has ended
	
	updates each counter according to a0
	beqz	a0, GOTO_TIE
	li 		t5, 1
	beq		a0, t5, GOTO_WIN

	addi	t2, t2, 1				# another day, another L
	REASSEMBLE_BIG_COUNTER:
		slli	t1, t1, 24			# t1 <- 0xww_00_00_00
		slli	t2, t2, 16			# t2 <- 0x00_ll_00_00
		slli	t3, t3, 8			# t3 <- 0x00_00_tt_00

		add 	t1, t1, t2			# t1 <- 0xww_ll_00_00
		add 	t1, t1, t3			# t1 <- 0xww_ll_tt_00
		add 	t1, t1, t4			# t1 <- 0xww_ll_tt_gg

		la		t0, THE_BIG_COUNTER
		sw		t1, 0(t0)			# updates THE_BIG_STRUCT

	NO_CHANGE:
		ret

GOTO_TIE:	addi 	t3, t3, 1		# one more draw
			j		REASSEMBLE_BIG_COUNTER
GOTO_WIN:	addi 	t1, t1, 1		# one more win
			j		REASSEMBLE_BIG_COUNTER
