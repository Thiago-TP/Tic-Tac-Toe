# IA media -> marca uma casa aletoria desde que ela esteja desocupada
IA_facil:
	csrr	s4, cycle	# s4 <- ciclos antes da jogada
	csrr	s5, time	# s5 <- tempo antes da jogada
	csrr	s6, instret	# s6 <- instrucoes antes da jogada
	
	jal	JogadaFacil	# jogada (incluindo print do simbolo)
	
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
	
fpg2:	j 	fpg2		# loop eterno para a fpgrars/fpga
		
JogadaFacil:				
	addi 	sp, sp, -4
	sw 	ra, 0(sp)
loop_facil:
	csrr 	a0, time		#  le time LOW
	li 	t0, 9 
	rem 	a1, a0, t0		# a0 mod 9 implica 0 <= a1 <= 8
	jal 	vazia 
	beqz 	a0, loop_facil 		# se a casa estiver ocupada, tenta de novo
	
	jal 	PRINT_PC
fim_facil:	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#
