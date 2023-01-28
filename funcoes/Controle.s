#################################################
#	t0 = bit de controle do teclado		#
#	t1 = endereco do KDMMIO			#
#	t2 = valor da tecla teclada		#
#	t0 = valor de teclas possiveis		#
#	Nao retorna nada			#
#################################################

Controle:
	addi 	sp, sp, -4 		# aloca espaco na pilha
	sw 	ra, 0(sp) 		# guarda o ponteiro de retorno

	li	t1, 500
	csrr 	t0, time		# le o tempo do sistema
	add 	t1, t0, t1		# soma com o tempo solicitado
SleepLoop1:	
	csrr	t0, time		# le o tempo do sistema
	sltu	t2, t0, t1
	bne	t2, zero, SleepLoop1	# t0<t1 ?	
	#bltu	t0, t1, SleepLoop
	
	li 	t1, 0xFF200000 		# carrega o endereco de controle do KDMMIO
	lw 	t0, 0(t1) 		# Le bit de Controle Teclado
	
	#li	t2, 't'
	#beq	t0, t2, shortcut
	#shortcut:
	#mv	s3, x0
	#j	Pula20Partidas	
	
	andi 	t0, t0, 0x0001 		# mascara o bit menos significativo
   	beq 	t0, zero, FIM 		# Se nao ha tecla pressionada entao vai para FIM
  	mv	s5, t1
  	la 	a4, posicao_seletor 	# carrega a posicao do seletor no  tabuleiro
	lh 	a1, 0(a4) 		# atribui o primeiro valor da posicao em a1
	lh 	a2, 2(a4) 		# atribui o primeiro valor da posicao em a2
	addi	t0, a2, -24
	li	t1, 68
	div	t0, t0, t1
	mv 	t2, t0
	li	t0, 3
	mul	t2, t2, t0
  	mv	a4, t2
  	addi	t0, a1, -60
	li	t1, 68
	div	t0, t0, t1
	mv	a5, t0
	add	t2, t2, t0
	mv	a6, t2
	slli	t2, t2, 2
	la	t0, BOARD
	add	t0, t0, t2
  	lw	t0, 0(t0)
  	mv	t1, s5
  	mv	s5, t0 			# salva o valor que esta naquela posicao do Board
  	lw 	t2, 4(t1) 		# le o valor da tecla tecla  	
	li 	t0, '\n'
	bne 	t0, t2, Char_Esquerda 	# verifica se a tecla clicada eh igual a \n
	la 	a0, Image2 		# carrega o simbolo O no registrador a0
	beqz 	s7, pula_controle 	# pula para a label pula controle se o simbolo escolhido for diferente de zero
	la	a0, Image3 		# carrega o simbolo X no registrador a0
pula_controle:
	bnez	s5, FIM
	call 	PRINT_animado 		# chama a funcao para printar o simbolo
	la 	a0, Image5
	call 	PRINTSeletor
	jal 	bmp_vira_indice 	# posicao no bitmap gera indice no BOARD, cujo conteúdo muda para "2" (0 -> 2) 
	addi 	s11, s11, -1
	li 	s8, 1 			# peca do usuario eh impressa => vez eh agora do PC
	li 	a7, 2
	call 	ganhou 			# recebe como argumento o registrador a7, a6,a4 e a5 qual simbolo quero testar a vitoria
	# index do board, linha, coluna
	j	FIM
Char_Esquerda:
   	li 	t0, 'a' 		# carrega o codigo ascii de a no registrador t0
  	bne 	t0, t2, Char_Cima 	# verifica se o valor de t0 nao é igual ao valor em t2 e se nao for pula pra label
  	li	a0, 0
  	li	a1, -68
  	call	Movimenta 		# chama o macro Movimenta
  	j	FIM
Char_Cima:
 	li 	t0, 'w' 		# carrega o codigo ascii de w no registrador t0
  	bne 	t0, t2, Char_Direita  	# verifica se o valor de t0 nao é igual ao valor em t2 e se nao for pula pra label
  	li	a0, 2
  	li	a1, -68
  	call	Movimenta 		# chama o macro Movimenta
  	j	FIM	
Char_Direita:  	
	li 	t0, 'd' 		# carrega o codigo ascii de d no registrador t0
  	bne 	t0, t2, Char_Baixo  	# verifica se o valor de t0 nao é igual ao valor em t2 e se nao for pula pra label
  	li	a0, 0
  	li	a1, 68
  	call	Movimenta 		# chama o macro Movimenta
  	j	FIM
Char_Baixo:  	
	li 	t0, 's' 		# carrega o codigo ascii de s no registrador t0
	bne 	t0, t2, FIM  		# verifica se o valor de t0 nao é igual ao valor em t2 e se nao for pula pra label
	li	a0, 2
  	li	a1, 68
	call	Movimenta 		# chama o macro Movimenta
  	j	FIM
FIM:	
	lw 	ra, 0(sp) 		# recupera o ponteiro de retorno
	addi 	sp, sp, 4 		# desaloca memoria na pilha
	slti	t0, s10, 5
	bnez	t0, condicao_1
	j	Exit
condicao_1:
	ret 				# retorna para o programa que chamou a funcao
	

