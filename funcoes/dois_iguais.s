# verifica se duas casas sao iguais ao int a4 dado
# assume-se que a2 =/= a3 sao adjacentes
#################################################
#       a0 -> 1 se iguais, 0 se nao		#
#	a2 -> indice de uma casa 		#
#	a3 -> indice da outra casa		#
#	a4 -> valor a ser buscado no board      #
#################################################
dois_iguais:
	addi 	sp, sp, -4
	sw 	ra, 0(sp)
	
	la 	t0, BOARD
	slli 	t1, a2, 2
	add 	t1, t1, t0 
	lw 	t1, 0(t1)                	# t1 = board[a2]
	slli 	t2, a3, 2 
	add 	t2, t2, t0 
	lw 	t2, 0(t2)                	# t2 = board[a3]
	bne 	t1, a4, fim_dois_iguais 	# board[a2] = a4? continua:fim
	bne 	t2, a4, fim_dois_iguais 	# board[a3] = a4? continua:fim
	li 	a0, 1               		# retorna 1 se ambas as casas forem =
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
fim_dois_iguais:
	li 	a0, 0                    	# retorna 0 se nao
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret