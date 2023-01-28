.data	
	BOARD: 				.word 0, 0, 0, 0, 0, 0, 0, 0, 0
.eqv	porradopipeline			0
	posicao_seletor: 		.half 60, 24 
	posicao_seletor_velha: 		.half 60, 24
.text

####################################### MACROS ##########################################

.macro CarregaSprite(%sprite,%posicao)
	mv 	a0, %sprite 	# carrega o sprite especicado no endereco da label
	la 	a4, %posicao 	# carrega o endereco da label posicao personagem
	lh 	a1, 0(a4) 	# atribui o primeiro valor da posicao em a1
	lh 	a2, 2(a4) 	# atribui o primeiro valor da posicao em a2
.end_macro

################################# Programa Principal ####################################

Setup:	
	call	PrintTelaDificuldades		
	li	s7, 0 				# inicia com o valor do simbolo escolhido pelo jogador como zero
	call	PrintTelaSimbolos
	li	a0, 0
LOOP1:
	la	a1, Image10 			# O selecionado
	la	a2, Image7 			# X nao selecionado
	la	a4, Image8 			# X selecionado
	la	a5, Image9 			# O nao selecionado
	li 	t1, 0xFF200000 			# carrega o endereco de controle do KDMMIO
	lw 	t0, 0(t1) 			# le bit de Controle Teclado
	andi 	t0, t0, 0x0001 			# mascara o bit menos significativo
   	beq 	t0, zero, FIM_Setup1 		# se nao ha tecla pressionada entao vai para FIM
  	lw 	t2, 4(t1) 			# le o valor da tecla teclada
	li 	t0, '\n' 			# carrega o valor da tecla enter em t0
	bne 	t0, t2, Char_Esquerda_Setup1 	# se t2 nao foi igual a t0 pula para a label
	add 	s7, s7, a0 			# ate aqui a0 ainda eh o resultado de Movimenta_Setup
	j	Exit_Setup1 			# pula para a label Exit_Setup
Char_Esquerda_Setup1:
   	li 	t0, 'a' 			# carrega o codigo ascii de a no registrador t0
  	bne 	t0, t2, Char_Direita_Setup1 	# verifica se o valor de t0 nao eh igual ao valor em t2 e se nao for pula pra label
  	li 	a0, -1 				# carrega em a0 -1 para indicar que esta indo para esquerda
  	call	Movimenta_Setup1 		# chama a funcao movimenta para movimentar o navegador
Char_Direita_Setup1:  	
	li 	t0, 'd' 			# carrega o codigo ascii de d no registrador t0
  	bne 	t0, t2, FIM_Setup1 		# verifica se o valor de t0 nao eh igual ao valor em t2 e se nao for pula pra label
  	li 	a0, 1 				# carrega em a0 1 para indicar que esta indo para direita
  	call	Movimenta_Setup1 		# chama a funcao movimenta para movimentar o navegador
FIM_Setup1:	
	j 	LOOP1 				# pula para a label LOOP1
Exit_Setup1:
	li	a3, 1 				# troca o frame que estava
	li 	t0, 0xFF200604 			# endereco usado para informar para o bit display que trocamos de frame
	li	s1, 0 				# inicializa a onde o navegador esta
	sw 	a3, 0(t0) 			# salva no endereco que informa que trocamos de frame o conteudo de a3
	li	a3, 0 				# frame = 0
	call	PrintTabuleiro			# imprime o fundo no frame em a3 (0 ou 1)
	li 	a3, 1 				# estabelece o frame em que o loop2 vai atuar
	li	a6, 0 				# carrega em a6 o argumento da funcao Movimenta_Setup2
	li	a0, 0
LOOP2:
	li 	t1, 0xFF200000 			# carrega o endereco de controle do KDMMIO
	
	lw 	t0, 0(t1) 			# le bit de Controle Teclado
	andi 	t0, t0, 0x0001 			# mascara o bit menos significativo
   	beq 	t0, zero, FIM_Setup2 		# se nao ha tecla pressionada entao vai para FIM
  	lw 	t2, 4(t1) 			# le o valor da tecla teclada
	li 	t0, '\n' 			# carrega o valor da tecla enter em t0
	bne 	t0, t2, Char_Esquerda_Setup2 	# se t2 nao foi igual a t0 pula para a label
	add 	s1, s1, a0 			# ate aqui a0 ainda eh o resultado de Movimenta_Setup
	j	Exit_Setup2 			# pula para a label Exit_Setup
Char_Esquerda_Setup2:
   	li 	t0, 'a' 			# carrega o codigo ascii de a no registrador t0
  	bne 	t0, t2,Char_Direita_Setup2 	# verifica se o valor de t0 nao eh igual ao valor em t2 e se nao for pula pra label
  	li 	a0, -1 				# carrega em a0 -1 para indicar que esta indo para esquerda
  	call	Movimenta_Setup2 		# chama a funcao movimenta para movimentar o navegador
Char_Direita_Setup2:  	
	li 	t0, 'd' 			# carrega o codigo ascii de d no registrador t0
  	bne 	t0, t2,FIM_Setup2 		# verifica se o valor de t0 nao eh igual ao valor em t2 e se nao for pula pra label
  	li 	a0, 1 				# carrega em a0 1 para indicar que esta indo para direita
  	call	Movimenta_Setup2 		# chama a funcao movimenta para movimentar o navegador
FIM_Setup2:	
	j 	LOOP2 				# pula para a label LOOP2
Exit_Setup2:
	li	a3, 0 				# troca o frame ques estava
	li 	t0, 0xFF200604 			# endereco usado para informar para o bit display que trocamos de frame
	sw 	a3, 0(t0) 			# salva no endereco que informa que trocamos de frame o conteudo de a3

	li	a3, 1 				# frame = 1
	call	PrintTabuleiro
	
	li	s10, 0
	li	s4, 0
	li	s3, 0
	li 	s11, 9
	li	s8, 0
	la 	a0, Image5 			# carrega o endereco do seletor
	li 	a1, 60 				# x = 0
	li 	a2, 24 				# y = 0
	li	a3, 0
	call 	PRINTSeletor 			# chama a funcao print
	
	
	
Game_Loop:	
	call	Controle 			# chama a funcao controle que controla os movimentos do jogador
	add	t0, s3, s4
	add	t0, t0, s10
	slti	t1, t0, 20
	bnez	t1, PulaExit
	j	Exit
PulaExit:
	beqz	s11, Empate
Voltaempate:
	beqz	s8, Fim   			# turn = 0 => vez eh do usuario
	call 	jogada_pc 			# chama a funcao jogada pc que controla os movimentos da maquina
Fim:	
	j 	Game_Loop 			# faz um loop infinito

Empate:
	addi	s3, s3, 1
	j	Reinicia_Board
volta:
	li	s11, 9
	slti	t0, s3, 20
	bnez	t0, condicao_3
	j	Exit
condicao_3:
	j	Voltaempate
Aumenta_Score:
	slti	t0, a7, 2
	li	a1, 100
	li	a2, 8
	beqz 	t0, DecideQuemAumenta1	
	li 	a1, 296
	addi	s4, s4, 1
	mv 	t1, s4
	j	DecideQuemAumenta2
DecideQuemAumenta1:
	addi	s10, s10, 1
	mv 	t1, s10
DecideQuemAumenta2:
	mv	s9, t1
	li	t0, 1
	bne	s9, t0, pula_1
	la	a0, Image18 			# 1
pula_1:
	li	t0, 2
	bne	s9, t0, pula_2
	la	a0, Image19 			# 2
pula_2:	
	li	t0, 3
	bne	s9, t0, pula_3
	la	a0, Image20 			# 3
pula_3:
	li	t0, 4
	bne	s9, t0, pula_4
	la	a0, Image21 			# 4
pula_4:
	li	t0, 5
	bne	s9, t0, Imprime
	la	a0, Image22 			# 5
Imprime:
	li	a3, 0
	call	PRINT
	li	a3, 1
	call	PRINT
Reinicia_Board:
	li	t1, 60
	li	t2, 24
	li	t3, 3
Loop_reinicia1:
	li	t4, 3
Loop_reinicia2:
	la	a0, Casa			# casa branca Image23
	mv	a1, t1
	mv	a2, t2
	li	a3, 0
	mv	a7, t1
	mv	a6, t2
	mv	a5, t4
	mv	a4, t3
	call	PRINT
	li	a3, 1
	call	PRINT
	mv	t4, a5
	mv	t3, a4
	mv 	t1, a7
	mv	t2, a6
	addi	t4, t4, -1
	addi	t1, t1, 68
	bnez	t4, Loop_reinicia2
	addi	t1, t1, -204
	addi	t3, t3, -1
	addi	t2, t2, 68
	bnez	t3, Loop_reinicia1
	la	t0, posicao_seletor
	li	t1, 60
	sh	t1, 0(t0)
	li	t1, 24
	sh	t1, 2(t0)
	la	t0, posicao_seletor_velha
	li	t1, 60
	sh	t1, 0(t0)
	li	t1, 24
	sh	t1, 2(t0)
	la	t0, BOARD
	li	t2, 0
Loop_limpaBoard:
	sw	zero, 0(t0)
	addi	t0, t0, 4
	addi	t2, t2, 1
	slti	t3, t2, 9
	bnez	t3, Loop_limpaBoard
	la 	a0, Image5 			# carrega o seletor
	li	a3, 1
	li 	a1, 60 				# x = 0
	li 	a2, 24 				# y = 0
	call 	PRINTSeletor
	li	a3, 0
	call 	PRINTSeletor 			# chama a funcao print
	beqz	s11, volta
	li	s11, 9
	j	Fim_ganha

Exit:	
	add	t0, s3, s4
	add	t0, t0, s10
	slti	t1, t0, 20
	bnez	t1, Pula20Partidas
	blt	s10, s4, EscolheGanhador1
	bgt	s10, s4, EscolheGanhador2
	add 	s3, s3, s10
	add 	s3, s3, s4
Pula20Partidas:
	li	t0, 20
	bne	s3, t0, pula_empate
	la	s9, Tie 			# tie branco Image29
	la	s10, Tie2 			# tie amarelo Image30
	li	t1, 0
	
pula_empate:
	li	t0, 5
	bne	s4, t0, pula_perde
EscolheGanhador1:
	la	s9, Over 			# game over branco Image31
	la	s10, Over2 			# game over vermelho Image32
	li	t1, -1
pula_perde:
	li	t0, 5
	bne	s10, t0, Fim_decideGanhador
EscolheGanhador2:
	la	s9, Win 			# you win branco Image29
	la	s10, Win2	 		# you win verde Image30
	li	t1, 1
# ate aqui coloquei nos registradores os respectivos enderecos das label em cada caso
Fim_decideGanhador:
	bgtz	t1, gotoWin
	bltz	t1, gotoLose
	call 	PrintTelaDraw
	j	continua
gotoWin:
	call 	PrintTelaWin
	j	continua	
gotoLose:
	call 	PrintTelaLose
continua:	
	mv	a0, s9
	li	a1, 0#128
	li	a2, 14#14
	call	PRINT
  	li 	a2, 113 			# y = 113	
	li	a1, 88 				# x = 88		
	la	a0, Image25 			# Yes vermelho		
	call 	PRINT 			
	la 	a0, Image27 			# No vermelho		
 	li	a1, 192			
  	call	PRINT			
	li	s7, 0
	li	s6, 0
LOOP3:
	xori	s6, s6, 1
	beqz	s6, Troca
	li	a1, 0	#128
	li	a2, 14	#14
	mv	a0, s10
	call 	PRINT
	
	li	a0, 150
	jal 	Sleep
	mv	a0, s10
	
	j 	FimTroca
Troca:	li	a1, 0	#128
	li	a2, 14	#14
	mv	a0, s9
	call 	PRINT
	
	li	a0, 150
	jal 	Sleep
	mv	a0, s9
	
FimTroca:
	la	a1, Image26
	la	a2, Image28
	la	a4, Image27
	la	a5, Image25
	li 	t1, 0xFF200000 			# carrega o endereco de controle do KDMMIO
	lw 	t0, 0(t1) 			# le bit de Controle Teclado
	andi 	t0, t0, 0x0001 			# mascara o bit menos significativo
   	beq 	t0, zero, FIM_Reset 		# Se nao ha tecla pressionada entao vai para FIM
  	lw 	t2, 4(t1) 			# le o valor da tecla teclada
	li 	t0, '\n' 			# carrega o valor da tecla enter em t0
	bne 	t0, t2, Char_Esquerda_Reset 	# se t2 nao foi igual a t0 pula para a label
	j	Exit_Reset 			# pula para a label Exit_Setup
Char_Esquerda_Reset:
   	li 	t0, 'a' 			# carrega o codigo ascii de a no registrador t0
  	bne 	t0, t2, Char_Direita_Reset 	# verifica se o valor de t0 nao eh igual ao valor em t2 e se nao for pula pra label
 	li 	a0, -1 				# carrega em a0 -1 para indicar que esta indo para esquerda
  	call	Movimenta_Setup1 		# chama a funcao movimenta para movimentar o navegador
  	mv 	s7, a0 				# ate aqui a0 ainda eh o resultado de Movimenta_Setup
Char_Direita_Reset:  	
	li 	t0, 'd' 			# carrega o codigo ascii de d no registrador t0
  	bne 	t0, t2, FIM_Reset 		# verifica se o valor de t0 nao eh igual ao valor em t2 e se nao for pula pra label
 	li 	a0, 1 				# carrega 1 em a0 para indicar que esta indo para direita
  	call	Movimenta_Setup1 		# chama a funcao movimenta para movimentar o navegador
  	mv 	s7, a0 				# ate aqui a0 ainda eh o resultado de Movimenta_Setup
FIM_Reset:	
	j 	LOOP3 				# pula para a label LOOP3
Exit_Reset:					# fim do jogo :(
	beqz	s7, Setup
	li	a7, 10
	ecall	

.include "all.s"	# inclui todos os .s e .data necessarios para o jogo
