# verifica pelo BOARD se uma casa esta vazia
#################################################
#	a0 = 0 se nao, 1 se sim		        #
#	a1 = endereco da casa			#
#################################################
vazia:	la 	t0, BOARD 
	slli 	t1, a1, 2
	add 	t0, t0, t1
	lw 	t0, 0(t0)      	# t0 = BOARD[a1]
	beqz 	t0, ta_vazia 	# BOARD[a1]=0? casa vazia:casa ocupada
	li 	a0, 0          	# casa ocupada => a0=0
	ret
ta_vazia:
	li 	a0, 1          	# casa vazia => a0=1
	ret