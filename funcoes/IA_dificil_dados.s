# IA dificil -> reage as jogadas do usuario numa estrategia quase perfeita
# A ordem das operacoes eh fixa e exclusiva, dai os branchs e jumps
IA_dificil:	
	csrr	s4, cycle	# s4 <- ciclos antes da jogada
	csrr	s5, time	# s5 <- tempo antes da jogada
	csrr	s6, instret	# s6 <- instrucoes antes da jogada
	
	jal	JogadaDificil	# jogada (incluindo print do simbolo)
	
	csrr	a0, cycle	# t0 <- ciclos pos jogada
	csrr	a1, time	# t1 <- tempo pos jogada
	csrr	a2, instret	# t2 <- instrucoes pos jogada
	
	sub	a0, a0, s4	# a0 <- ciclos da jogada
	sub	a1, a1, s5	# a1 <- tempo da jogada
	sub	a2, a2, s6	# a2 <- instrucoes da jogada
	
	li	a3, 1
	call	PrintFundo	# tela preta no frame 1
	li	t6, 0xFF200604	# t6 <- endereco de escolha de frame
	sw	a3, 0(t6)	# mostra a frame 1
	
	call	PrintMedicoes	# imprime os dados
	
fpg1:	j 	fpg1		# loop eterno para a fpgrars/fpga
	  
JogadaDificil:
	addi 	sp, sp, -4
	sw 	ra, 0(sp)
	
	jal 	ganhar              	# alinha 3 pc_char
	bnez 	s0, fim_do_dificil 	# available = 1 => return
	
	jal 	bloquear            	# bloqueia 3 user_char
	bnez 	s0, fim_do_dificil 	# available = 1 => return
	
	jal 	centro              	# joga no centro
	bnez 	s0, fim_do_dificil 	# available = 1 => return	
	
	jal 	canto_oposto        	# joga em canto oposto
	bnez 	s0, fim_do_dificil 	# available = 1 => return
	
	jal 	canto_vazio         	# joga em canto vazio
	bnez 	s0, fim_do_dificil 	# available = 1 => return
	
	jal 	lado_vazio          	# joga em lado vazio

fim_do_dificil:
	mv 	s0, x0 			# available=0
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#

# marca o primeiro lado vazio lido
lado_vazio: # lados = 2, 4, 6 ou 8
	addi 	sp, sp, -4
	sw 	ra, 0(sp)
	
	li 	a1, 1 
	jal 	vazia 
	beqz 	a0, lado_4 		# lado 2 vazio? proximo lado : marca
	jal 	PRINT_PC 		# marca a casa a1 e poe available=1
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
lado_4:	li 	a1, 3 
	jal 	vazia 
	beqz 	a0, lado_6 		# lado 4 vazio? proximo lado : marca
	jal 	PRINT_PC 		# marca a casa a1 e poe available=1
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
lado_6:	li 	a1, 5 
	jal 	vazia 
	beqz 	a0, lado_8 		# lado 6 vazio? proximo lado : marca
	jal 	PRINT_PC 		# marca a casa a1 e poe available=1
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
lado_8:	li 	a1, 7 
	jal 	vazia 
	beqz 	a0, fim_do_lado_vazio 	# lado 8 vazio? marca : fim
	jal 	PRINT_PC 		# marca a casa a1 e poe available=1

fim_do_lado_vazio:
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#

# marca o primeiro canto vazio lido
canto_vazio: # cantos = 1, 3, 7 ou 9
	addi 	sp, sp, -4
	sw 	ra, 0(sp)
	
	li 	a1, 0 
	jal 	vazia 
	beqz 	a0, canto_3 		# canto 1 vazio? proximo lado : marca
	jal 	PRINT_PC 		# marca a casa a1 e poe available=1
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
canto_3:
	li 	a1, 2 
	jal 	vazia 
	beqz 	a0, canto_7 		# canto 3 vazio? proximo lado : marca
	jal 	PRINT_PC 		# marca a casa a1 e poe available=1
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
canto_7:	
	li 	a1, 6 
	jal 	vazia 
	beqz 	a0, canto_9 		# canto 7 vazio? proximo lado : marca
	jal 	PRINT_PC 		# marca a casa a1 e poe available=1
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
canto_9:
	li 	a1, 8 
	jal 	vazia 
	beqz 	a0, fim_do_canto_vazio 	# canto 9 vazio? marca : fim
	jal 	PRINT_PC 		# marca a casa a1 e poe available=1

fim_do_canto_vazio:
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#

# se o usuario jogou no canto e o oposto esta vazio, 
# esse canto oposto eh marcado
canto_oposto: # cantos opostos = 1<->9, 3<->7
	addi	sp, sp, -4
	sw	ra, 0(sp)
	
	bnez 	s9, oposto_3 		# user square = 1? continua : proximo canto
	li 	a1, 8
	jal 	vazia
	beqz 	a0, oposto_3 		# casa 9 vazia? marca : proximo canto
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
oposto_3:
	li 	t0, 2 
	bne 	s9, t0, oposto_7 	# user square = 3? continua:proximo canto
	li 	a1, 6
	jal 	vazia
	beqz 	a0, oposto_7 		# casa 7 vazia? marca:proximo canto
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
oposto_7:
	li 	t0, 6 
	bne 	s9, t0, oposto_9 	# user square = 7? continua:proximo canto
	li 	a1, 2
	jal 	vazia
	beqz 	a0, oposto_9 		# casa 3 vazia? marca:proximo canto
	jal 	PRINT_PC
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
oposto_9:
	li 	t0, 8 
	bne 	s9, t0, fim_do_oposto 	# user square = 9? continua:proximo canto
	li 	a1, 0
	jal 	vazia
	beqz 	a0, fim_do_oposto 	# casa 1 vazia? marca:fim
	jal 	PRINT_PC

fim_do_oposto:	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret 
#

# marca o centro se este estiver vazio
centro: # centro = 5
	addi 	sp, sp, -4
	sw 	ra, 0(sp)
	
	li 	a1, 4
	jal 	vazia
	beqz 	a0, fim_do_centro	
	jal 	PRINT_PC
	
fim_do_centro:	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#

# verifica se duas casas adjacentes sao user_char e 
# marca a terceira com pc_char, se estiver vazia	
bloquear:
	addi 	sp, sp, -4
	sw 	ra, 0(sp)
	
	li 	a4, 2 			# 1 no board => PC, 2 no board => USER
	jal 	ganhar_ou_bloquear
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#
	
# verifica se duas casas adjacentes sao pc_char e 
# marca a terceira com pc_char, se estiver vazia	
ganhar:
	addi 	sp, sp, -4
	sw 	ra, 0(sp)
	
	li 	a4, 1 			# 1 no board => PC, 2 no board => USER
	jal 	ganhar_ou_bloquear
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#

# verifica se duas casas adjacentes sao iguais e
# marca a terceira com pc_char
ganhar_ou_bloquear: # a4 = s2 v s3 = user_char v pc_char eh o caracter das iguais
#12(3)
	addi 	sp, sp, -4
	sw 	ra, 0(sp)
	
	li 	a2, 0
	li 	a3, 1
	jal 	dois_iguais
	beqz 	a0, linha_23 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 2 			# a1 vira indice 2 para a funcao vazia
	jal 	vazia 			# verifica se a casa 3 esta livre
	beqz 	a0, linha_23 		# livre? marca : proxima "adjacencia"
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#(1)23
linha_23:
	li 	a2, 1
	li 	a3, 2
	jal 	dois_iguais
	beqz 	a0, linha_13 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 0 			# a1 vira indice 0 para a funcao vazia
	jal 	vazia 			# verifica se a casa 1 esta livre
	beqz 	a0, linha_13 		# livre ? marca : proxima "adjacencia"
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#1(2)3
linha_13:
	li 	a2, 0
	li 	a3, 2
	jal 	dois_iguais
	beqz 	a0, linha_45 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 1 			# a1 vira indice 1 para a funcao vazia
	jal 	vazia 			# verifica se a casa 2 esta livre
	beqz 	a0, linha_45 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi	sp, sp, 4
	ret
#45(6)
linha_45:
	li 	a2, 3
	li 	a3, 4
	jal 	dois_iguais
	beqz 	a0, linha_56 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 5 			# a1 vira indice 5 para a funcao vazia
	jal 	vazia 			# verifica se a casa 6 esta livre
	beqz 	a0, linha_56 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
#(4)56
linha_56:
	li 	a2, 4
	li 	a3, 5
	jal 	dois_iguais
	beqz 	a0, linha_46 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 3 			# a1 vira indice 5 para a funcao vazia
	jal 	vazia 			# verifica se a casa 4 esta livre
	beqz 	a0, linha_46 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#4(5)6
linha_46:
	li 	a2, 3
	li 	a3, 5
	jal 	dois_iguais
	beqz 	a0, linha_78 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 4 			# a1 vira indice 5 para a funcao vazia
	jal 	vazia 			# verifica se a casa 6 esta livre
	beqz 	a0, linha_78 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#78(9)
linha_78:
	li 	a2, 6
	li 	a3, 7
	jal 	dois_iguais
	beqz 	a0, linha_89 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 8 			# a1 vira indice 8 para a funcao vazia
	jal 	vazia 			# verifica se a casa 9 esta livre
	beqz 	a0, linha_89 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#(7)89
linha_89:
	li 	a2, 7
	li 	a3, 8
	jal 	dois_iguais
	beqz 	a0, linha_79 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 6 			# a1 vira indice 6 para a funcao vazia
	jal 	vazia 			# verifica se a casa 7 esta livre
	beqz 	a0, linha_79 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#7(8)9
linha_79:
	li 	a2, 6
	li 	a3, 8
	jal 	dois_iguais
	beqz 	a0, col_14 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 7 			# a1 vira indice 7 para a funcao vazia
	jal 	vazia 			# verifica se a casa 8 esta livre
	beqz 	a0, col_14 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
#14(7)
col_14:
	li 	a2, 0
	li 	a3, 3
	jal 	dois_iguais
	beqz 	a0, col_47 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 6 			# a1 vira indice 6 para a funcao vazia
	jal 	vazia 			# verifica se a casa 7 esta livre
	beqz 	a0, col_47 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#(1)47
col_47:
	li 	a2, 3
	li 	a3, 6
	jal 	dois_iguais
	beqz 	a0, col_17 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 0 			# a1 vira indice 0 para a funcao vazia
	jal 	vazia 			# verifica se a casa 1 esta livre
	beqz 	a0, col_17 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
#1(4)7
col_17:
	li 	a2, 0
	li 	a3, 6
	jal 	dois_iguais
	beqz 	a0, col_25 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 3 			# a1 vira indice 3 para a funcao vazia
	jal 	vazia 			# verifica se a casa 4 esta livre
	beqz 	a0, col_25 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#25(8)
col_25:
	li 	a2, 1
	li 	a3, 4
	jal 	dois_iguais
	beqz 	a0, col_58 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 7 			# a1 vira indice 7 para a funcao vazia
	jal 	vazia 			# verifica se a casa 8 esta livre
	beqz 	a0, col_58 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
#(2)58
col_58:
	li 	a2, 4
	li 	a3, 7
	jal 	dois_iguais
	beqz 	a0, col_28 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 1 			# a1 vira indice 1 para a funcao vazia
	jal 	vazia 			# verifica se a casa 2 esta livre
	beqz 	a0, col_28 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
#2(5)8
col_28:
	li 	a2, 1
	li 	a3, 7
	jal 	dois_iguais
	beqz 	a0, col_36 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 4 			# a1 vira indice 4 para a funcao vazia
	jal 	vazia 			# verifica se a casa 5 esta livre
	beqz 	a0, col_36 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#36(9)
col_36:
	li 	a2, 2
	li 	a3, 5
	jal 	dois_iguais
	beqz 	a0, col_69 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 8 			# a1 vira indice 8 para a funcao vazia
	jal 	vazia 			# verifica se a casa 9 esta livre
	beqz 	a0, col_69 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#(3)69
col_69:
	li 	a2, 5
	li 	a3, 8
	jal 	dois_iguais
	beqz 	a0, col_39 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 2 			# a1 vira indice 2 para a funcao vazia
	jal 	vazia 			# verifica se a casa 3 esta livre
	beqz 	a0, col_39 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
#3(6)9
col_39:
	li 	a2, 2
	li 	a3, 8
	jal 	dois_iguais
	beqz 	a0, diag_15 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 5 			# a1 vira indice 5 para a funcao vazia
	jal 	vazia 			# verifica se a casa 6 esta livre
	beqz 	a0, diag_15 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
#15(9)
diag_15:
	li 	a2, 0
	li 	a3, 4
	jal 	dois_iguais
	beqz 	a0, diag_59 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 8 			# a1 vira indice 8 para a funcao vazia
	jal 	vazia 			# verifica se a casa 9 esta livre
	beqz 	a0, diag_59 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#(1)59
diag_59:
	li 	a2, 4
	li 	a3, 8
	jal 	dois_iguais
	beqz 	a0, diag_19 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 0 			# a1 vira indice 0 para a funcao vazia
	jal 	vazia 			# verifica se a casa 1 esta livre
	beqz 	a0, diag_19 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi	sp, sp, 4
	ret
#1(5)9
diag_19:
	li 	a2, 0
	li 	a3, 8
	jal 	dois_iguais
	beqz 	a0, diag_35 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 4 			# a1 vira indice 4 para a funcao vazia
	jal 	vazia 			# verifica se a casa 5 esta livre
	beqz 	a0, diag_35 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret		
#35(7)
diag_35:
	li 	a2, 2
	li 	a3, 4
	jal 	dois_iguais
	beqz 	a0, diag_57 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 6 			# a1 vira indice 4 para a funcao vazia
	jal 	vazia 			# verifica se a casa 5 esta livre
	beqz 	a0, diag_57 		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
#(3)57
diag_57:
	li 	a2, 4
	li 	a3, 6
	jal 	dois_iguais
	beqz 	a0, diag_37 		# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 2 			# a1 vira indice 2 para a funcao vazia
	jal 	vazia 			# verifica se a casa 3 esta livre
	beqz 	a0, diag_37		# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret	
#3(5)7
diag_37:
	li 	a2, 2
	li 	a3, 6
	jal 	dois_iguais
	beqz 	a0, fim_do_g_ou_b 	# dois iguais ? continua:proxima "adjacencia"
	li 	a1, 4 			# a1 vira indice 4 para a funcao vazia
	jal 	vazia 			# verifica se a casa 5 esta livre
	beqz 	a0, fim_do_g_ou_b 	# livre ? marca : proxima "adjacencia"	
	jal 	PRINT_PC

fim_do_g_ou_b:
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#
