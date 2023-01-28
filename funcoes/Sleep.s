############################################
#  Sleep                            	   #
#  a0    =    Tempo em ms             	   #
############################################
Sleep:  
	addi	sp, sp, -12
	sw	t0, 0(sp)
	sw	t1, 4(sp)
	sw	t2, 8(sp)
	
	csrr 	t0, time		# le o tempo do sistema
	add 	t1, t0, a0		# soma com o tempo solicitado
SleepLoop:	
	csrr	t0, time		# le o tempo do sistema
	sltu	t2, t0, t1
	bne	t2, zero, SleepLoop	# t0<t1 ?	
	#bltu	t0, t1, SleepLoop
	ret
	
	lw	t0, 0(sp)
	lw	t1, 4(sp)
	sw	t2, 12(sp)
	addi	sp, sp, 12
	ret
