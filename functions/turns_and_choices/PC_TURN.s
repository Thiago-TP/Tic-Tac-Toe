#####################################################################################
#	PC marks its piece on the board according to the selected AI and sSYMBOL.		#
#	EASY AI moves randomly, MEDIUM will try to fill the first available line, and	#
#	HARD will interrupt PLAYER's victory, as well as try to make its own.			#
#####################################################################################
#	- Inputs -			#
#	s1=DIFFICULTY flag	#
#################################
#	- Outputs -					#
#	square marking animation	#
#################################
PC_TURN:
	# return address shall be preserved as other functions will be called
    addi    sp, sp, -4
    sw      ra, 0(sp)

	# plays according to the selected DIFFICULTY
	bltz	s1, GOTO_EASY_AI
	beqz	s1, GOTO_MEDIUM_AI

	call	HARD_AI
	
	END_PC_TURN:
	# recovering of return address 
	lw		ra, 0(sp)
	addi	sp, sp, 4
	ret	

GOTO_EASY_AI:	call	EASY_AI
				j		END_PC_TURN
GOTO_MEDIUM_AI:	call	MEDIUM_AI
				j		END_PC_TURN