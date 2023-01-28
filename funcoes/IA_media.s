# IA media -> ocupa a primeira casa desocupada do tabuleiro,
# verificando de linha a linha
IA_media:
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
