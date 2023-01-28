#########################################################
#	Imprime o tempo (em ms), numero de ciclos	#
#	e numero de instrucoes na frame 1		#
#########################################################
#	a0 = ciclos					#
#	a1 = tempo					#
#	a2 = instrucoes					#
#########################################################
PrintMedicoes:
	addi	sp, sp, -20	# armazenamento dos registradores
	sw	ra, 0(sp)	# return adress
	sw	a0, 4(sp)	# ciclos
	sw	a1, 8(sp)	# tempo
	sw	a2, 12(sp)	# instrucoes
	sw	a4, 16(sp)	# mudara para 1
	
	
	# impressao dos valores
	# impressao dos ciclos 
	li	a1, 160		# pos. em x
	li	a2, 92		# pos. em y
	li	a3, 59		# cor (verde matrix)
	li	a4, 1		# frame 1
	call	printIntUnsigned
	# impressao do tempo
	lw	a0, 8(sp)	# a0 <- tempo
	li	a1, 160		# pos. em x
	li	a2, 112		# pos. em y
	li	a3, 59		# cor (verde matrix)
	li	a4, 1		# frame 1
	call	printIntUnsigned
	# impressao das instrucoes
	lw	a0, 12(sp)	# a0 <- instrucoes
	li	a1, 160		# pos. em x
	li	a2, 132		# pos. em y
	li	a3, 59		# cor (verde matrix)
	li	a4, 1		# frame 1
	call	printIntUnsigned
	
	# impressao das legendas
	# ciclos
	la	a0, Ciclos	# a0 <- "Ciclos ="
	li	a1, 88		# pos. em x
	li	a2, 92		# pos. em y
	li	a3, 0x47	# cor (verde matrix)
	li	a4, 1		# frame 1
	call	printString
	# tempo
	la	a0, Tempo	# a0 <- "Tempo ="
	li	a1, 96		# pos. em x
	li	a2, 112		# pos. em y
	li	a3, 0x47	# cor (verde matrix)
	li	a4, 1		# frame 1
	call	printString
	la	a0, ms		# a0 <- "ms"
	li	a1, 248		# pos. em x
	li	a2, 112		# pos. em y
	li	a3, 0x3B	# cor (verde matrix)
	li	a4, 1		# frame 1
	call	printString
	# instrucoes
	la	a0, Instrucoes	# a0 <- "Instrucoes ="
	li	a1, 56		# pos. em x
	li	a2, 132		# pos. em y
	li	a3, 0x47	# cor (verde matrix)
	li	a4, 1		# frame 1
	call	printString
	
	
	# recuperacao dos registradores
	lw	ra, 0(sp)	# return adress
	lw	a0, 4(sp)	# ciclos
	lw	a1, 8(sp)	# tempo
	lw	a2, 12(sp)	# instrucoes
	sw	a4, 16(sp)	# mudara para 1
	addi	sp, sp, 20	# fechamento da pilha
	ret			# retorno
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
#########################################################################
# Rotina de tratamento de excecao e interrupcao		v2.1		#
# Lembre-se: Os ecalls originais do Rars possuem precedencia sobre	#
# 	     estes definidos aqui					#
# Os ecalls 1XX usam o BitMap Display e Keyboard Display MMIO Tools	#
# Usar o RARS14_Custom4	(misa)						#
# Marcus Vinicius Lamar							#
# 2020/1								#
#########################################################################

# incluir o MACROSv20.s no início do seu programa!!!!

.data
.align 2

# Tabela de caracteres desenhados segundo a fonte 8x8 pixels do ZX-Spectrum
LabelTabChar:
.word 	0x00000000, 0x00000000, 0x10101010, 0x00100010, 0x00002828, 0x00000000, 0x28FE2828, 0x002828FE, 
	0x38503C10, 0x00107814, 0x10686400, 0x00004C2C, 0x28102818, 0x003A4446, 0x00001010, 0x00000000, 
	0x20201008, 0x00081020, 0x08081020, 0x00201008, 0x38549210, 0x00109254, 0xFE101010, 0x00101010, 
	0x00000000, 0x10081818, 0xFE000000, 0x00000000, 0x00000000, 0x18180000, 0x10080402, 0x00804020, 
	0x54444438, 0x00384444, 0x10103010, 0x00381010, 0x08044438, 0x007C2010, 0x18044438, 0x00384404, 
	0x7C482818, 0x001C0808, 0x7840407C, 0x00384404, 0x78404438, 0x00384444, 0x1008047C, 0x00202020, 
	0x38444438, 0x00384444, 0x3C444438, 0x00384404, 0x00181800, 0x00001818, 0x00181800, 0x10081818, 
	0x20100804, 0x00040810, 0x00FE0000, 0x000000FE, 0x04081020, 0x00201008, 0x08044438, 0x00100010, 
	0x545C4438, 0x0038405C, 0x7C444438, 0x00444444, 0x78444478, 0x00784444, 0x40404438, 0x00384440,
	0x44444478, 0x00784444, 0x7840407C, 0x007C4040, 0x7C40407C, 0x00404040, 0x5C404438, 0x00384444, 
	0x7C444444, 0x00444444, 0x10101038, 0x00381010, 0x0808081C, 0x00304848, 0x70484444, 0x00444448, 
	0x20202020, 0x003C2020, 0x92AAC682, 0x00828282, 0x54546444, 0x0044444C, 0x44444438, 0x00384444, 
	0x38242438, 0x00202020, 0x44444438, 0x0C384444, 0x78444478, 0x00444850, 0x38404438, 0x00384404, 
	0x1010107C, 0x00101010, 0x44444444, 0x00384444, 0x28444444, 0x00101028, 0x54828282, 0x00282854, 
	0x10284444, 0x00444428, 0x10284444, 0x00101010, 0x1008047C, 0x007C4020, 0x20202038, 0x00382020, 
	0x10204080, 0x00020408, 0x08080838, 0x00380808, 0x00442810, 0x00000000, 0x00000000, 0xFE000000, 
	0x00000810, 0x00000000, 0x3C043800, 0x003A4444, 0x24382020, 0x00582424, 0x201C0000, 0x001C2020, 
	0x48380808, 0x00344848, 0x44380000, 0x0038407C, 0x70202418, 0x00202020, 0x443A0000, 0x38043C44, 
	0x64584040, 0x00444444, 0x10001000, 0x00101010, 0x10001000, 0x60101010, 0x28242020, 0x00242830, 
	0x08080818, 0x00080808, 0x49B60000, 0x00414149, 0x24580000, 0x00242424, 0x44380000, 0x00384444, 
	0x24580000, 0x20203824, 0x48340000, 0x08083848, 0x302C0000, 0x00202020, 0x201C0000, 0x00380418, 
	0x10381000, 0x00101010, 0x48480000, 0x00344848, 0x44440000, 0x00102844, 0x82820000, 0x0044AA92, 
	0x28440000, 0x00442810, 0x24240000, 0x38041C24, 0x043C0000, 0x003C1008, 0x2010100C, 0x000C1010, 
	0x10101010, 0x00101010, 0x04080830, 0x00300808, 0x92600000, 0x0000000C, 0x243C1818, 0xA55A7E3C, 
	0x99FF5A81, 0x99663CFF, 0x10280000, 0x00000028, 0x10081020, 0x00081020

.align 2

#buffer do ReadString, ReadFloat, SDread, etc. 512 caracteres/bytes
TempBuffer:
.space 512

# tabela de conversao hexa para ascii
TabelaHexASCII:		.string "0123456789ABCDEF  "
NumDesnormP:		.string "+desnorm"
NumDesnormN:		.string "-desnorm"
NumZero:		.string "0.00000000"
NumInfP:		.string "+Infinity"
NumInfN:		.string "-Infinity"
NumNaN:			.string "NaN"

.text
#####################################
#  PrintSring                       #
#  a0    =  endereco da string      #
#  a1    =  x                       #
#  a2    =  y                       #
#  a3    =  cor		    	    #
#####################################

printString:	addi	sp, sp, -8			# aloca espaco
    		sw	ra, 0(sp)			# salva ra
    		sw	s0, 4(sp)			# salva s0
    		mv	s0, a0              		# s0 = endereco do caractere na string

loopprintString:lb	a0, 0(s0)                 	# le em a0 o caracter a ser impresso

    		beq     a0, zero, fimloopprintString	# string ASCIIZ termina com NULL

    		call     printChar       		# imprime char
    		
		addi    a1, a1, 8                 	# incrementa a coluna
		li 	t6, 313
		blt	a1, t6, NaoPulaLinha	    	# se ainda tiver lugar na linha
    		addi    a2, a2, 8                 	# incrementa a linha
    		mv    	a1, zero			# volta a coluna zero

NaoPulaLinha:	addi    s0, s0, 1			# proximo caractere
    		j       loopprintString       		# volta ao loop

fimloopprintString:	lw      ra, 0(sp)    		# recupera ra
			lw 	s0, 4(sp)		# recupera s0 original
    			addi    sp, sp, 8		# libera espaco
fimprintString:	ret      	    			# retorna


#########################################################
#  PrintChar                                            #
#  a0 = char(ASCII)                                     #
#  a1 = x                                               #
#  a2 = y                                               #
#  a3 = cores (0x0000bbff) 	b = fundo, f = frente	#
#  a4 = frame (0 ou 1)					#
#########################################################
#   t0 = i                                             	#
#   t1 = j                                             	#
#   t2 = endereco do char na memoria                   	#
#   t3 = metade do char (2a e depois 1a)               	#
#   t4 = endereco para impressao                       	#
#   t5 = background color                              	#
#   t6 = foreground color                              	#
#########################################################
#	t9 foi convertido para s9 pois nao ha registradores temporarios sobrando dentro desta funcao


printChar:	li 	t4, 0xFF	# t4 temporario
		slli 	t4, t4, 8	# t4 = 0x0000FF00 (no RARS, nao podemos fazer diretamente "andi rd, rs1, 0xFF00")
		and    	t5, a3, t4   	# t5 obtem cor de fundo
    		srli	t5, t5, 8	# numero da cor de fundo
		andi   	t6, a3, 0xFF    # t6 obtem cor de frente

		li 	tp, ' '
		blt 	a0, tp, printChar.NAOIMPRIMIVEL	# ascii menor que 32 nao eh imprimivel
		li 	tp, '~'
		bgt	a0, tp, printChar.NAOIMPRIMIVEL	# ascii Maior que 126  nao eh imprimivel
    		j       printChar.IMPRIMIVEL
    
printChar.NAOIMPRIMIVEL: li      a0, 32		# Imprime espaco

printChar.IMPRIMIVEL:	li	tp, 320		# Num colunas 320
			#TEM_M(s8,printChar.mul1)
			#MULTIPLY(t4,tp,a2)
			#j printChar.mul1d
printChar.mul1:		mul     t4, tp, a2			# multiplica a2x320  t4 = coordenada y
printChar.mul1d:	add     t4, t4, a1               	# t4 = 320*y + x
			addi    t4, t4, 7                 	# t4 = 320*y + (x+7)
			li      tp, 0xFF000000         		# Endereco de inicio da memoria VGA0
			beq 	a4, zero, printChar.PULAFRAME	# Verifica qual o frame a ser usado em a4
			li      tp, 0xFF100000         		# Endereco de inicio da memoria VGA1
printChar.PULAFRAME:	add     t4, t4, tp               	# t4 = endereco de impressao do ultimo pixel da primeira linha do char
			addi    t2, a0, -32               	# indice do char na memoria
			slli    t2, t2, 3                 	# offset em bytes em relacao ao endereco inicial
			la      t3, LabelTabChar		# endereco dos caracteres na memoria
			add     t2, t2, t3               	# endereco do caractere na memoria
			lw      t3, 0(t2)                 	# carrega a primeira word do char
			li 	t0, 4				# i=4

printChar.forChar1I:	beq     t0, zero, printChar.endForChar1I # if(i == 0) end for i
    			addi    t1, zero, 8               	# j = 8

printChar.forChar1J:	beq     t1, zero, printChar.endForChar1J # if(j == 0) end for j
        		andi    s9, t3, 0x001			# primeiro bit do caracter
        		srli    t3, t3, 1             		# retira o primeiro bit
        		beq     s9, zero, printChar.printCharPixelbg1	# pixel eh fundo?
        		sb      t6, 0(t4)             		# imprime pixel com cor de frente
        		j       printChar.endCharPixel1
printChar.printCharPixelbg1:	sb      t5, 0(t4)                # imprime pixel com cor de fundo
printChar.endCharPixel1: addi    t1, t1, -1                	# j--
    			addi    t4, t4, -1                	# t4 aponta um pixel para a esquerda
    			j       printChar.forChar1J		# vollta novo pixel

printChar.endForChar1J: addi    t0, t0, -1 		# i--
    			addi    t4, t4, 328           	# 2**12 + 8
    			j       printChar.forChar1I	# volta ao loop

printChar.endForChar1I:	lw      t3, 4(t2)           	# carrega a segunda word do char
			li 	t0, 4			# i = 4
printChar.forChar2I:    beq     t0, zero, printChar.endForChar2I  # if(i == 0) end for i
    			addi    t1, zero, 8             # j = 8

printChar.forChar2J:	beq	t1, zero, printChar.endForChar2J # if(j == 0) end for j
        		andi    s9, t3, 0x001	    		# pixel a ser impresso
        		srli    t3, t3, 1                 	# desloca para o proximo
        		beq     s9, zero, printChar.printCharPixelbg2 # pixel eh fundo?
        		sb      t6, 0(t4)			# imprime cor frente
        		j       printChar.endCharPixel2		# volta ao loop

printChar.printCharPixelbg2:	sb      t5, 0(t4)		# imprime cor de fundo

printChar.endCharPixel2:	addi    t1, t1, -1		# j--
    				addi    t4, t4, -1              # t4 aponta um pixel para a esquerda
    				j       printChar.forChar2J

printChar.endForChar2J:	addi	t0, t0, -1 		# i--
    			addi    t4, t4, 328		#
    			j       printChar.forChar2I	# volta ao loop

printChar.endForChar2I:	ret				# retorna


# Sugestao para nomes de loops: Sempre comecar com o nome da sub-rotina, então adicionar um '.', seguido do nome do loop . Garante que o nome do loop será único, se as sub-rotinas
# tiverem nomes diferentes.

#############################################
#  PrintIntUnsigned                         #
#  a0    =    valor inteiro                 #
#  a1    =    x                             #
#  a2    =    y  			    #
#  a3    =    cor                           #
#  a4    =    frame			    #
#############################################

printIntUnsigned:	addi 	sp, sp, -4		# Aloca espaco
		sw 	ra, 0(sp)			# salva ra
		la 	t0, TempBuffer			# carrega o Endereco do Buffer da String
		
		li 	t2, 10				# carrega numero 10
		li 	t1, 0				# carrega numero de digitos com 0

printIntUnsigned.loop1:	#TEM_M(s8,printIntUnsigned.pula1)
			#DIVU10(t4,a0)
			#REMU10(t3,a0)
			#j	printIntUnsigned.pula1d
printIntUnsigned.pula1:	divu 	t4, a0, t2			# divide por 10 (quociente)
			remu 	t3, a0, t2			# resto
printIntUnsigned.pula1d:addi 	sp, sp, -4			# aloca espaco na pilha
		sw 	t3, 0(sp)			# coloca resto na pilha
		mv 	a0, t4				# atualiza o numero com o quociente
		addi 	t1, t1, 1			# incrementa o contador de digitos
		bne 	a0, zero, printIntUnsigned.loop1# verifica se o numero eh zero
				
printIntUnsigned.loop2:	lw 	t2, 0(sp)		# le digito da pilha
		addi 	sp, sp, 4			# libera espaco
		addi 	t2, t2, 48			# converte o digito para ascii
		sb 	t2, 0(t0)			# coloca caractere no buffer
		addi 	t0, t0, 1			# incrementa endereco do buffer
		addi 	t1, t1, -1			# decrementa contador de digitos
		bne 	t1, zero, printIntUnsigned.loop2# eh o ultimo?
		sb 	zero, 0(t0)			# insere \NULL na string
		
		la 	a0, TempBuffer			# Endereco do buffer da srting
		call 	printString			# chama o print string
				
		lw 	ra, 0(sp)			# recupera a
		addi 	sp, sp, 4			# libera espaco
printIntUnsigned.fim:	ret

#############################################
#  PrintInt                                 #
#  a0    =    valor inteiro                 #
#  a1    =    x                             #
#  a2    =    y  			    #
#  a3    =    cor                           #
#############################################

printInt:	addi 	sp, sp, -4			# Aloca espaco
		sw 	ra, 0(sp)			# salva ra
		la 	t0, TempBuffer			# carrega o Endereco do Buffer da String
		
		bge 	a0, zero, ehposprintInt		# Se eh positvo
		li 	t1, '-'				# carrega o sinal -
		sb 	t1, 0(t0)			# coloca no buffer
		addi 	t0, t0, 1			# incrementa endereco do buffer
		sub 	a0, zero, a0			# torna o numero positivo
		
ehposprintInt:  li 	t2, 10				# carrega numero 10
		li 	t1, 0				# carrega numero de digitos com 0
		
loop1printInt:	#TEM_M(s8,printInt.pula1)
		#DIV10(t4,a0)
		#REM10(t3,a0)
		#j 	printInt.pula1d
printInt.pula1:	div 	t4, a0, t2			# divide por 10 (quociente)
		rem 	t3, a0, t2			# resto
printInt.pula1d:addi 	sp, sp, -4			# aloca espaco na pilha
		sw 	t3, 0(sp)			# coloca resto na pilha
		mv 	a0, t4				# atualiza o numero com o quociente
		addi 	t1, t1, 1			# incrementa o contador de digitos
		bne 	a0, zero, loop1printInt		# verifica se o numero eh zero
				
loop2printInt:	lw 	t2, 0(sp)			# le digito da pilha
		addi 	sp, sp, 4			# libera espaco
		addi 	t2, t2, 48			# converte o digito para ascii
		sb 	t2, 0(t0)			# coloca caractere no buffer
		addi 	t0, t0, 1			# incrementa endereco do buffer
		addi 	t1, t1, -1			# decrementa contador de digitos
		bne 	t1, zero, loop2printInt		# eh o ultimo?
		sb 	zero, 0(t0)			# insere \NULL na string
		
		la 	a0, TempBuffer			# Endereco do buffer da srting
		jal 	printString			# chama o print string
				
		lw 	ra, 0(sp)			# recupera a
		addi 	sp, sp, 4			# libera espaco
fimprintInt:	ret					# retorna
