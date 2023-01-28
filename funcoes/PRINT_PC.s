#################################################################################
#	imprime o char do PC na primeira casa desocupada vista, atualiza BOARD	#
#################################################################################
#	a1 = indice do BOARD onde a impressao deve ser feita	#
#################################################################
PRINT_PC:   
	addi 	sp, sp, -4
	sw 	ra, 0(sp)
	
	li 	s0, 1      	# seta available=1 (somente para a IA_dificil)
	# board[a1] deve ser atualizado
	la 	t0, BOARD
	slli 	t1, a1, 2
	add 	t0, t0, t1 	# t0 = endereco de board[a1]
	li 	t1, 1       	# t1 = 1
	sw 	t1, 0(t0)   	# board[a1] = 1 (0 para vago, 1 para PC e 2 para USER)
	# mapeamento indice do board -> posicao no bitmap
	# queremos deslocar a posicao inicial (x0, y0) em 
	# (+ux. +vy), u e v inteiros que dependem do indice a1 
	# por inspecao, encontrei que (generalizar para tabuleiro m x n)
	# u = a1  % 3 (n?)
	# v = a1 // 3 (m?)
	li 	t2, 3       	# setando t2 = 3 para div e mul
	rem 	t3, a1, t2 	# t3 <- u
	div 	t4, a1, t2 	# t4 <- v 
	mv 	a6, a1
	li 	a4, 3
	mul 	a4, a4, t4
	mv 	a5,t3
	# valores de x e y em t2 e t5
	li 	t0, 68      	# t0 <- tamanho do pulo em x
	li 	t1, 68     	# t1 <- tamanho do pulo em y
	mul 	t3, t3, t0 	# t3 <- ux 
	mul 	t4, t4, t1 	# t4 <- vy 
	li 	t0, 60      	# t0 <- x0 = 60 => pos. de referencia em x
	li 	t1, 24      	# t1 <- y0 = 25 => pos. de referencia em y
	add 	t3, t3, t0 	# t3 <- ux + x0 => pos. inicial em x
	add 	t4, t4, t1 	# t3 <- vy + y0 => pos. inicial em y	
	# impressao no bitmap
	
	la 	a0, Image2	# Image2 = O
	bnez 	s7, pula_PC
	la 	a0, Image3 	# Image3 = X
pula_PC:
	mv 	a1, t3     	# carrega o endereco correto de x no bitmap para impressao 
	mv 	a2, t4     	# carrega o endereco correto de y no bitmap para impressao
	li 	a3, 0      	# frame de impressao
	call 	PRINT_animado   # chama a funcao para printar o simbolo
	addi 	s11, s11, -1    # occupied++ 
	li 	a7, 1 		# passa qual o simbolo que quero testar se ganhou
	call 	ganhou
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
