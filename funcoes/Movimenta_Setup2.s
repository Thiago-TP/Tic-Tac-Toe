#################################################
#	a6 = posicao inicial do nav no sprite	#
#	a0 = quantidade movimento		#
#################################################
#################################################
#	t0 = enderecos de sprite		#
#	t1 = variavel temporaria da nova pos	#
#	t2 = limite do navegador		#
#################################################	
#################################################
#	a0 = retorna 0 ou 1 ou 2		#
#################################################
						
			
Movimenta_Setup2:
	addi 	sp, sp, -4 		# aloca memoria na pilha
	sw 	ra, 0(sp) 		# salva o ponteiro de retorno nan pilha
	li 	a2, 113 		# y = 113
	add	t1, a0, a6
	li	t2, 3
	bgeu	t1, t2, Fim_mov2
	mv 	a7, a0
	la 	a0, Image13
	li	t3, 1
	li	a1, 88
	blt	a6, t3, pula1_mov2
	la 	a0, Image14
	li	t3, 2
	li	a1, 140
	blt	a6, t3, pula1_mov2
	la 	a0, Image16
	li	a1, 192
pula1_mov2:
	add	a6, a6, a7 		# troca o valor do registrador em a6 que indica qual dificuldade estamos selecionando
	mv	a7, t1
	call	PRINT
	mv	t1, a7
	la 	a0, Image12
	li	t3, 1
	li	a1, 88
	blt	t1, t3, pula2_mov2
	la 	a0, Image15
	li	t3, 2
	li	a1, 140
	blt	t1, t3, pula2_mov2
	la 	a0, Image17
	li	a1, 192
pula2_mov2:
	call	PRINT
Fim_mov2:
	mv 	a0, a6			# retorna a0 como sendo o valor em a6
	lw 	ra, 0(sp) 		# recupero o ponteiro de retorno da pilha	
	addi 	sp, sp, 4 		# desaloco memoria da pilha
	ret 				# retorna para o programa que chamou a funcao