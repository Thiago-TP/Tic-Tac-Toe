#############################################################################
#	Goes through BOARD from index 8 to 0 until it finds an empty SQUARE,	#
#	at which point it marks that spot, updating the BOARD.					#
#	Such a spot is guaranteed to appear as no AI will be called				#
#	in the case of a draw.													#
#############################################################################
#	- Inputs -		#
#	BOARD struct	#
#####################
#	- Outputs -	#
#	PC play		#
#################
MEDIUM_AI:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	li 	a0, 8               		# start at index 8, the SQUARE at the right bottom corner
	MEDIUM_AI_LOOP:
		la      t1, BOARD
		add     t0, a0, t1          # t0 = address of SQUARE in BOARD
		lbu     t1, 0(t0)           # t1 = status of SQUARE

		beqz 	t1, EMPTY_SQUARE 	# SQUARE is empty => go mark it
		addi 	a0, a0, -1         
		bgtz 	a0, MEDIUM_AI_LOOP 	# checks next index
	
	END_MEDIUM_AI:	     			# SYMBOL marked, game goes on
		lw 		ra, 0(sp)
		addi 	sp, sp, 4
		ret
	
	EMPTY_SQUARE:
		li 		t1, 2
		sb		t1, 0(t0)			# updates BOARD
		call	CONVERT_IND_TO_POS	# calculates (a1, a2) according to the index in a0
		call 	GET_PC_SYMBOL		# loads in a4 the SYMBOL of PC
		call 	MARK_SQUARE			# retorno da funcao com marca no tabuleiro
		j		END_MEDIUM_AI