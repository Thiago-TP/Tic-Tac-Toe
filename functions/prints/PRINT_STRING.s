#####################################################
#	Prints a given string in a given bmp position	#
#	of a given frame with a given color.			#
#####################################################
#	- Inputs -                  #
#  	a0	=  endereco da string	#
#  	a1	=  x                    #
#  	a2	=  y                    #
#  	a3	=  frame	    	    #
#	a4 	= cor					#
#####################################
#	- Outputs -						#
#	printed string on the bitmap	#
#####################################

PRINT_STRING:	
	addi	sp, sp, -8		# aloca espaco
    sw		ra, 0(sp)		# salva ra
    sw		a1, 4(sp)		# salva a1

    mv		s2, a0          # s2 = endereco do caractere na string

	LOOP_PRINT_STRING:
		lb		a0, 0(s2)                 	# le em a0 o caracter a ser impresso

		beqz     a0, FIM_PRINT_STRING		# string ASCIIZ termina com NULL

		call    PRINT_CHAR       			# imprime char
				
		addi    a1, a1, 6                 	# incrementa a coluna
		li 		t6, 318						# 314 = 320 - 6		
		blt		a1, t6, NAO_PULA_LINHA	    # se ainda tiver lugar na linha
		addi    a2, a2, 10                 	# incrementa a linha
		mv    	a1, zero					# volta a coluna zero

		NAO_PULA_LINHA:	
			addi    s2, s2, 1	# proximo caractere
		
		j       LOOP_PRINT_STRING       	# volta ao loop

	FIM_PRINT_STRING:	
		mv 		a0, s2
		
		lw      ra, 0(sp)   # recupera ra
		lw 		a1, 4(sp)	# recupera a1
    	addi    sp, sp, 8	# libera espaco
		ret      	    	# retorna