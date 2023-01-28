jogada_pc:
	addi	sp, sp, -4
	sw 	ra, 0(sp)
	slti 	t0, s1, 1
	beqz 	t0, pula_IA1
	jal 	IA_facil		# pula para cada IA. Se ela nao foi a escolhida, retorna sem fazer nada          
	j 	Fim_IA
pula_IA1:
	slti 	t0, s1, 2
	beqz 	t0, pula_IA2
	jal 	IA_media
	j 	Fim_IA
pula_IA2:
	jal 	IA_dificil			 
Fim_IA:
	li 	s8, 0               # turn = 0 => vez eh do usuario
	li 	s0, 0               # available = 0
	
	lw 	ra, 0(sp)	
	addi 	sp, sp, 4
	slti	t0, s4, 5	
	bnez	t0, condicao_2
	j	Exit
condicao_2:
	ret
