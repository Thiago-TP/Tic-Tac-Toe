#################################################
#	a0 = quantidade movimento		#
#	a1 = endereco da primeira label		#
#	a2 = endereco da segunda label		#
#	a4 = endereco da terceira label		#
#	a5 = endereco da quarta label		#
#################################################	
#################################################
#	a0 = retorna 0 ou 1			#
#################################################
			
Movimenta_Setup1:
	addi 	sp, sp, -4 	# aloca memoria na pilha
	sw 	ra, 0(sp) 	# salva o ponteiro de retorno na pilha
	mv	a7, a2
	li 	a2, 113 	# y = 113
	bltz	a0, pula_mov1 	# se a quantidade de movimento for negativa eu estou na esquerda caso contrario na direita
	mv 	a0, a1 		# endereco do sprite que quero imprimir
	li	a1, 88 		# x = 88
	call 	PRINT 		# chamo a funcao para imprimir
	mv	a0, a7 		# endereco do sprite que quero imprimir
	li	a1, 192 	# x = 192
	call 	PRINT 		# chamo a funcao para imprimir
	li	a0, 1 		# troca o resultado da funcao Movimenta_Setup
	j 	Fim_mov1 	# pulo para o final da funcao Movimenta_Setup
pula_mov1:
	mv 	a0, a4 		# endereco do sprite que quero imprimir
	li	a1, 192 	# x = 192
	call 	PRINT 		# chamo a PRINT
	mv 	a0, a5 		# endereco do sprite que quero imprimir funcao para imprimir
	li	a1, 88 		# x = 88
	call 	PRINT 		# chamo a funcao para imprimir
	li	a0, 0		# troca o resultado da funcao movimenta_setup
Fim_mov1:	
	lw 	ra, 0(sp) 	# recupero o ponteiro de retorno da pilha	
	addi 	sp, sp, 4 	# desaloco memoria da pilha
	ret 			# retorna para o programa que chamou a funcao