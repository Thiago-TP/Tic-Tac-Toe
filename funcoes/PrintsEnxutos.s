#	enche o frame a3 (0 ou 1) de preto (que dlc)
PrintFundo:	
	li	t0, 0x00000000
	li	t1, 0xFF000000
	li	t2, 0xFF012C00
	beqz	a3, LoopPreto
	li	t1, 0xFF100000
	li	t2, 0xFF112C00
LoopPreto:	
	beq	t1, t2, FundoFim
	sw	t0, 0(t1)
	addi	t1, t1, 4
	j 	LoopPreto
FundoFim:
	ret


#	imprime a tela de escolha de simbolos no frame 0	
PrintTelaSimbolos:
	addi 	sp, sp, -4
	sw	ra, 0(sp)
	
	mv	a3, x0
	call	PrintFundo
	
	la	a0, Image9
	li	a1, 88
	li	a2, 113
	call 	PRINT
	la	a0, Image8
	li	a1, 192
	call 	PRINT
	la	a0, chooseSymb
	li	a1, 0
	li	a2, 77
	call 	PRINT
	
	lw	ra, 0(sp)
	addi	sp, sp, 4
	ret


#	imprime a tela de escolha de dificuldades no frame 1
PrintTelaDificuldades:
	addi 	sp, sp, -4
	sw	ra, 0(sp)
	
	li	a3, 1
	call	PrintFundo
	
	la	a0, Image12
	li	a1, 88
	li	a2, 113
	call 	PRINT
	la	a0, Image14
	li	a1, 140
	call 	PRINT
	la	a0, Image16
	li	a1, 192
	call 	PRINT
	la	a0, chooseDiff
	li	a1, 0
	li	a2, 77
	call 	PRINT
	
	lw	ra, 0(sp)
	addi	sp, sp, 4
	ret


#	imprime o tabuleiro vazio nas frames 0 e 1
PrintTabuleiro:	
	addi 	sp, sp, -4
	sw	ra, 0(sp)

	call	PrintFundo
	#	print do placar inicial
	la	a0, Placar
	li	a1, 0
	li	a2, 8
	call 	PRINT	
	# prints smol brain das casas do tabuleiro
	la	a0, Casa
	li	a1, 60		# canto superior esquerdo
	li	a2, 24
	call 	PRINT
	li	a1, 128		# aresta superior 
	call 	PRINT
	li	a1, 196		# canto superior direito 
	call 	PRINT	
	li	a1, 60		# aresta esquerda 
	li	a2, 92
	call 	PRINT
	li	a1, 128		# miolo
	call 	PRINT	
	li	a1, 196		# aresta direita 
	call 	PRINT
	li	a1, 60		# canto inferior esquerdo
	li	a2, 160
	call 	PRINT
	li	a1, 128		# aresta inferior
	call 	PRINT
	li	a1, 196		# canto infeiror direito 
	call 	PRINT
	# print dos personagens nos cantos
	la	a0, mariozin	# mario
	li	a1, 20		
	li	a2, 210
	call 	PRINT
	la	a0, bowserzin	# bowser
	li	a1, 280	
	li	a2, 194	
	call 	PRINT
	
	# fim da funcao
	lw	ra, 0(sp)
	addi	sp, sp, 4
	ret

#	imprime a tela de vitoria no frame 0
PrintTelaWin:
	addi 	sp, sp, -4
	sw	ra, 0(sp)
	
	mv	a3, x0
	call	PrintFundo
	
	la	a0, PlayAgain
	li	a1, 0
	li	a2, 95
	call 	PRINT	
	la	a0, Mario
	li	a1, 155
	li	a2, 60
	call 	PrintByte	
	
	lw	ra, 0(sp)
	addi	sp, sp, 4
	ret

#	imprime a tela de empate no frame 0	
PrintTelaDraw:
	addi 	sp, sp, -4
	sw	ra, 0(sp)
	
	mv	a3, x0
	call	PrintFundo
	
	la	a0, PlayAgain
	li	a1, 0
	li	a2, 95
	call 	PRINT	
	la	a0, Peach
	li	a1, 150
	li	a2, 40
	call 	PrintByte	
	
	lw	ra, 0(sp)
	addi	sp, sp, 4
	ret

#	imprime a tela de derrota no frame 0
PrintTelaLose:
	addi 	sp, sp, -4
	sw	ra, 0(sp)
	
	mv	a3, x0
	call	PrintFundo
	
	la	a0, PlayAgain
	li	a1, 0
	li	a2, 95
	call 	PRINT	
	la	a0, Bowser
	li	a1, 142
	li	a2, 40
	call 	PrintByte	
	
	lw	ra, 0(sp)
	addi	sp, sp, 4
	ret	
