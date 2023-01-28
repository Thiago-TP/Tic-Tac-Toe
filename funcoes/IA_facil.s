# IA media -> marca uma casa aletoria desde que ela esteja desocupada
IA_facil:
	addi 	sp, sp, -4
	sw 	ra, 0(sp)
loop_facil:
	csrr 	a0, time			#  Le time LOW
	#csrr 	a1, timeh 			#  Le time HIGH
	#ret	
	#li 	a7, 30			# tempo em ms de 1/1/1970 ate hoje
	#ecall
	li 	t0, 9 
	rem 	a1, a0, t0           	# a0 mod 9 implica 0 <= a1 <= 8
	jal 	vazia 
	beqz 	a0, loop_facil 	# se a casa estiver ocupada, tenta de novo
	
	jal 	PRINT_PC
fim_facil:	
	lw 	ra, 0(sp)
	addi 	sp, sp, 4
	ret
#
