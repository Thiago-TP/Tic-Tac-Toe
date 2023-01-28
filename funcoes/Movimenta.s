#################################################
#	a0 = offset				#
#	a1 = imediato				#
#################################################

Movimenta:
	addi 	sp, sp, -4 				# aloca espaco na pilha
	sw 	ra, 0(sp) 				# salva o endereco de retorno
	la 	t0, CURSOR_POSITION 			# carrega a posicao atual do personagem
	la 	t1, CURSOR_OLD_POSITION 		# carrega a posicao antiga do personagem 
	lw 	t2, 0(t0) 				# grava no registrador t2 as duas posicoes 
	sw 	t2, 0(t1) 				# salva no endereco da posicao antiga do personagem a localizacao atual
	add	t0, t0, a0
	lh 	t1, 0(t0) 				# grava no registrador t1 o valor dentro do endereco t0+offsset
	add 	t1, t1, a1 				# adiciona o imediato em t1
	mv 	t3, a0 					# carrega o valor de offset no registrador t3
	slti 	t3, t3, 1 				# seta t3 com 0 ou 1 depedendo do se o t3 for menor que o imediato 1
	li 	t4, 60 					# carrega o imediato 320 no registrador t4
	bnez 	t3, escolhelimite2 			# se t3 nao for igual a zero vai para a label indicada
	 li 	t4, 24 					# carrega o imediato 240 no registrador t4
escolhelimite2:	
	bltu 	t1, t4, Game_Loop 			# condicao que verifica os limites
	li 	t4, 263 				# carrega o imediato 320 no registrador t4
	bnez 	t3, escolhelimite1 			# se t3 nao for igual a zero vai para a label indicada
	 li 	t4, 227 				# carrega o imediato 240 no registrador t4
escolhelimite1:	
	bgeu 	t1, t4, Game_Loop 			# condicao que verifica se os limites estao entre 0 e 320 ou 240
	sh 	t1, 0(t0) 				# grava no endereco t0+offset o valor no registrador t1
	li	a3,0
	la 	t0, Image5 				# carrega o sprite com o seletor
	
	mv 	a0, t0 	# carrega o sprite especicado no endereco da label
	la 	a4, CURSOR_POSITION 	# carrega o endereco da label posicao personagem
	lh 	a1, 0(a4) 	# atribui o primeiro valor da posicao em a1
	lh 	a2, 2(a4) 	# atribui o primeiro valor da posicao em a2
	
	call 	PRINTSeletor 				# chama a funcao print
	li	a3, 1
	call	PRINTSeletor
	la	t0, CasaSemMiolo#Image4#
	li	a3, 0
	
	mv 	a0, t0 	# carrega o sprite especicado no endereco da label
	la 	a4, CURSOR_OLD_POSITION 	# carrega o endereco da label posicao personagem
	lh 	a1, 0(a4) 	# atribui o primeiro valor da posicao em a1
	lh 	a2, 2(a4) 	# atribui o primeiro valor da posicao em a2
	
	call 	PRINTSeletor 				# chama a funcao print
	li	a3, 1
	call	PRINTSeletor
	lw 	ra, 0(sp) 				# recupera o valor do ponteiro de retorno
	addi 	sp, sp, 4 				# desoloca memoria na pilha
	ret 						# retorna para o programa que chamou a funcao
