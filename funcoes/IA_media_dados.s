# IA media -> ocupa a primeira casa desocupada do tabuleiro,
# verificando de linha a linha
IA_media:
	csrr	s4, cycle	# s4 <- ciclos antes da jogada
	csrr	s5, time	# s5 <- tempo antes da jogada
	csrr	s6, instret	# s6 <- instrucoes antes da jogada
	
	jal	JogadaMedia	# jogada (incluindo print do simbolo)
	
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
	
fpg3:	j 	fpg3		# loop eterno para a fpgrars/fpga

JogadaMedia:
	addi 	sp, sp, -4
	sw 	ra, 0(sp)	
	li 	a1, 0               	# inicia o loop na posicao 0
for_media:
	jal 	vazia
	bnez 	a0, fim_for_media 	# casa desocupada => sai do for
	li 	t0, 8
	blt 	t0, a1, fim_media   	# checagem de seguranca index<=8
	addi 	a1, a1, 1          	# posicao++
	j 	for_media             	# continua o loop
fim_media:	     			# retorno da funcao sem marcar o tabuleiro
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
fim_for_media:
	jal 	PRINT_PC 		# retorno da funcao com marca no tabuleiro
	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#
