#########################################################################
#	Destacks sprite a5xa6 at bmp position (a1, a2) in hidden frame	#
#########################################################################
RETURN_BACKGROUND:
	li 	t0, 0xFF0 	# carrega 0xFF0 em t0
       	li	t1, FRAME_ADDRESS
       	lw	t1, 0(t1)
       	xori	t1, t1, 1	# t1 <- valor do outro frame
        add 	t0, t0, t1 	# adiciona o frame a FF0 
        slli 	t0, t0, 20 	# shift de 20 bits pra esquerda      
      
        add   	t0, t0, a1  	# adiciona x ao t0
        li    	t1, 320     	# t1 = 320
        mul   	t1, t1, a2 	# multiplica y por t1
        add   	t0, t0, t1 	# coloca o endereco em t0      
      
        mv  	t1, zero      	# zera t1
        mv  	t2, zero      	# zera t2
        mv 	t3, a5     	# carrega a largura em t3
        mv 	t4, a6     	# carrega a altura em t4 
        
        mul	t6, t3, t4	# t6 <- quantidade de pixels
        add	t6, sp, t6  	# t6  <- endereco do primeiro byte do fundo
      
        RETURN_LINE:
                addi  	t6, t6, -1  # vai para o proximo pixel do fundo
                lbu   	t5, 0(t6)   # carrega em t5 um byte da pilha
                sb    	t5, 0(t0)   # imprime no bitmap um byte da imagem
                addi  	t0, t0, 1   # incrementa endereco do bitmap
                addi  	t2, t2, 1   # incrementa contador de coluna
                blt   	t2, t3, RETURN_LINE # cont da coluna < largura ?      
        
                addi  	t0, t0, 320 	# t0 += 320
                sub   	t0, t0, t3  	# t0 -= largura da imagem
                mv    	t2, zero    	# zera t2 (cont de coluna)
                addi  	t1, t1, 1   	# incrementa contador de linha
                bgt   	t4, t1, RETURN_LINE # altura > contador de linha ?
        
        # ajusta a pilha
        mul	t6, t3, t4	# t6 <- quantidade de pixels
        add	sp, sp, t6  	# sp fecha
        ret               	# retorna
