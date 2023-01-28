# atualiza no BOARD que o jogador ocupou a casa relacionada a a1 e a2
bmp_vira_indice:
	addi	sp, sp, -4
	sw	ra, 0(sp)
	
	li 	t0, 68      	# dimensao do pulo (68x68)
	div 	t1, a1, t0 	# t1 <- a1 // 68 
	div 	t0, a2, t0 	# t0 <- a2 // 68
	li 	t2, 3
	mul 	t0, t0, t2 	# t0 <- 3*y
	add 	t0, t0, t1 	# t0 <- 3*y + x = indice
	
	mv 	s9, t0		# user_char <- indice
	
	la 	t1, BOARD
	slli 	t0, t0, 2 	# t2 <- 4*t0
	add 	t1, t1, t0 	# t1 <- endereco do board[indice]
	li 	t2, 2
	sw 	t2, 0(t1)	# board[indice] = 2
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret