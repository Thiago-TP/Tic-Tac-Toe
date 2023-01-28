PRINT_animado:
	addi 	sp, sp, -24 		# desloca memoria na pilha
	mv 	t0, sp
	sw 	ra, 0(sp) 		# recupera o valor do ponteiro de retorno
	sw	a6, 4(sp)
	sw	a5, 8(sp)
	sw	a4, 12(sp)
	sw	s3, 16(sp)
	sw	s0, 20(sp)
	lw 	t4, 0(a0) 		# carrega a largura em t4
	lw	t5, 4(a0)
	li 	a6, 0xFF0 		# carrega 0xFF0 em t0
	add 	a6, a6, a3 		# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
	slli 	a6, a6, 20 		# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
	add 	a6, a6, a1 		# adiciona x ao t0
	#li	t3, 320
	#li	t1, 0 
	#mul	t3, t3, t1
	#add	a6, a6, t3
	mv	t2, zero
	mv	t3, zero
	mv	s9, sp
	addi	a3, a2, 68
SalvaSprite:
	addi	sp, sp, -4
	lw	t6, 0(a6) 		# carrega do bit map e coloca na pilha
	sw	t6, 0(sp)
	addi	a6, a6, 4
	addi	t3, t3, 4
	blt 	t3, t4, SalvaSprite 	# se contador da coluna < largura, continue imprimindo
	addi 	a6, a6, 320 		# t0 += 320
	sub 	a6, a6, t4 		# t0 -= largura da imagem
	# ^ isso serve pra "pular" de linha no bitmap display
	mv 	t3, zero		# zera t3 (contador de coluna)
	addi	t2, t2, 1	
	bgt	a3, t2, SalvaSprite 	# se altura > contador de linha, continue imprimindo
	li	a7, 0
	li	s3, 0
Loop:
	xori	s0, s0,1
	mv 	a3, s0
	li 	a6, 0xFF0 		# carrega 0xFF0 em t0
	add 	a6, a6, a3 		# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
	slli 	a6, a6, 20 		# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
	add 	a6, a6, a1 		# adiciona x ao t0
	li	t3, 320
	mv	t1, a7 			#lembrar de aumentar esse t1
	mul	t3, t3, t1
	add	a6, a6, t3
	mv	t2, zero
	mv	t3, zero
	addi	t1, a0, 8
	mv	a3, t0
PRINT_LINHA_animado:
	lb 	t6, 0(t1) 		# carrega em t6 uma word (4 pixeis) da imagem
	li	t0, -57
	beq	t0, t6, pula_animado
	sb	t6, 0(a6) 		# imprime no bitmap a word (4 pixeis) da imagem
pula_animado:
	addi 	a6, a6, 1		# incrementa endereco do bitmap
	addi 	t1, t1, 1		# incrementa endereco da imagem
	addi 	t3, t3, 1		# incrementa contador de coluna
	blt 	t3, t4, PRINT_LINHA_animado # se contador da coluna < largura, continue imprimindo
	addi 	a6, a6, 320 		# t0 += 320
	sub 	a6, a6, t4 		# t0 -= largura da imagem
	# ^ isso serve pra "pular" de linha no bitmap display
	mv 	t3, zero		# zera t3 (contador de coluna)
	addi 	t2, t2, 1		# incrementa contador de linha
	bgt 	t5, t2, PRINT_LINHA_animado # se altura > contador de linha, continue imprimindo
	li 	t0, 0xFF200604		# carrega em t0 o endereco de troca de frame
	sw 	s0, 0(t0)
	mv	t0,a3			
	mv	a3,s0
	xori	a3,a3,1
	li 	a6, 0xFF0 		# carrega 0xFF0 em t0
	add 	a6, a6, a3 		# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
	slli 	a6, a6, 20 		# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
	add 	a6, a6, a1 		# adiciona x ao t0
	li	t3, 320
	mv	t1, s3 			# lembrar de aumentar esse t1
	mul	t3, t3, t1
	add	a6, a6, t3
	mv	t2, zero
	mv	t3, zero	
RecuperaSprite:
	addi	s9, s9, -4
	lw	t6, 0(s9) 		# carrega a word que foi salva na pilha
	sw 	t6, 0(a6) 		# imprime no bitmap a word (4 pixeis) que foi salva na pilha
	addi 	a6, a6, 4		# incrementa endereco do bitmap
	addi	t3, t3, 4
	blt 	t3, t4, RecuperaSprite  # se contador da coluna < largura, continue imprimindo
	addi 	a6, a6, 320 		# t0 += 320
	sub 	a6, a6, t4 		# t0 -= largura da imagem
	# ^ isso serve pra "pular" de linha no bitmap display
	mv 	t3, zero		# zera t3 (contador de coluna)
	addi 	t2, t2, 1	
	bgt 	t5, t2, RecuperaSprite 	# se altura > contador de linha, continue imprimindo
	
	li	t1, 4624
	ble	a7, s3, pula_incrementa
	li	t1, 4488
	addi	s3, s3, 2
pula_incrementa:
	addi	a7, a7, 2
	add	s9, t1, s9
	ble	a7, a2, Loop

	mv	sp, t0
	
	xori 	s0, s0, 1
	mv 	a3, s0
	
	call 	PRINTSeletor
	
	li 	s0, 0
	li 	t0, 0xFF200604		# carrega em t0 o endereco de troca de frame
	sw 	s0, 0(t0)

	lw 	ra, 0(sp) 		# recupera o valor do ponteiro de retorno
	lw	a6, 4(sp)
	lw	a5, 8(sp)
	lw	a4, 12(sp)
	lw	s3, 16(sp)
	lw	s0, 20(sp)
	addi 	sp, sp, 24 		# desoloca memoria na pilha
	ret
