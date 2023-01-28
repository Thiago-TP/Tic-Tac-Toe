# verifica se a maquina ou o jogador ganhou
#################################################
#       a4 -> linha*3				#
#	a5 -> coluna		 		#
#	a6 -> P(linha,coluna)			#
#	a7 -> Indica quem esta usando a funcao	#
#################################################

ganhou:
	addi 	sp, sp, -4 		# aloca espaco na pilha
	sw 	ra, 0(sp) 		# salva o endereco de retorno
	andi	t0, a6, 1
	bnez	t0, IMPAR
PAR:	
	la	t0, BOARD
	li	t1, 8
	add	t1, t0, t1
	li	t2, 2
	li	t6, 0
Loop_ganha_D1:
	lw	t4, 0(t0)
	bne	t4, a7, Fim_D1
	addi	t0, t0, 16
	addi	t6, t6, 1
	addi	t2, t2, -1
	slti	t3, t2, 0
	beqz	t3, Loop_ganha_D1
	li	t2, 3
	beq	t6, t2, Aumenta_Score
Fim_D1:
	li	t6, 0
	li	t2, 2
Loop_ganha_D2:
	lw	t4, 0(t1)
	bne	t4, a7, IMPAR
	addi	t1, t1, 8
	addi	t6, t6, 1
	addi	t2, t2, -1
	slti	t3, t2, 0
	beqz	t3, Loop_ganha_D2
	li	t2, 3
	beq	t6, t2, Aumenta_Score
IMPAR:	
	la	t0, BOARD
	slli	a4, a4, 2
	add	t1, t0, a4
	li	t6, 0
	li	t2, 2
Loop_ganha_L:
	lw	t4, 0(t1)
	bne	t4, a7, Fim_Impar
	addi	t6, t6, 1
	addi	t1, t1, 4
	addi	t2, t2, -1
	slti	t3, t2, 0
	beqz	t3, Loop_ganha_L
	li	t2, 3
	beq	t6, t2, Aumenta_Score
Fim_Impar:
	slli	a5, a5, 2
	add	t1, t0, a5
	li	t2, 2
	li	t6, 0
Loop_ganha_C:
	lw	t4, 0(t1)
	bne	t4, a7, Fim_ganha
	addi	t6, t6, 1
	addi	t1, t1, 12
	addi	t2, t2, -1
	slti	t3, t2, 0
	beqz	t3, Loop_ganha_C
	li	t2, 3
	beq	t6, t2, Aumenta_Score
Fim_ganha:
	lw 	ra, 0(sp) 		# recupera o valor do ponteiro de retorno
	addi 	sp, sp, 4 		# desoloca memoria na pilha
	ret