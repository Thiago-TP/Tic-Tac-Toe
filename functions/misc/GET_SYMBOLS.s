#############################################################
#	Loads in a4 the sprite label of PC SYMBOL according to	#
#	PLAYER's choice at the beginning of the game (s0).		#
#############################################################
#	- Input -						#
#	s0=0 if player chose X, 1 if O	#
#####################################
#	- Output -				#
#	a4 = PC sprite label	#
#############################
GET_PC_SYMBOL:
	la		a4, X_SYMBOL
	beqz	s0, PC_GOT_O	
	ret
	PC_GOT_O:	la		a4, O_SYMBOL
				ret


#################################################################
#	Loads in a4 the sprite label of PLAYER SYMBOL according to	#
#	PLAYER's choice at the beginning of the game (s0).			#
#################################################################
#	- Input -						#
#	s0=0 if player chose X, 1 if O	#
#####################################
#	- Output -					#
#	a4 = PLAYER sprite label	#
#################################
GET_PLAYER_SYMBOL:
	la		a4, O_SYMBOL
	beqz	s0, PLAYER_GOT_O	
	ret
	PLAYER_GOT_O:	la  a4, X_SYMBOL
				    ret