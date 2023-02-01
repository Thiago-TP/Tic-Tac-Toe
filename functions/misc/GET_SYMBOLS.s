GET_PC_SYMBOL:
	la		a4, X_SYMBOL
	beqz	s0, PC_GOT_O	
	ret
	PC_GOT_O:	la		a4, O_SYMBOL
				ret

GET_PLAYER_SYMBOL:
	la		a4, O_SYMBOL
	beqz	s0, PLAYER_GOT_O	
	ret
	PLAYER_GOT_O:	la  a4, X_SYMBOL
				    ret