.data
	mensagem : .asciiz "Montar_heap\n"
	hpf : .asciiz "heapify chamado\n"
	solicitacao : .asciiz "Insira os 10 valores para o vetor : "
	imprecao : .asciiz "\n Antes de se tornar heap : "
	imprecao_ : .asciiz "\n Forma de heap : "
	imprecao__ : .asciiz "\n Apos o heap_sort : "
	salto_de_linha: .asciiz " "
	#array que tera  um numero N de inteiros, como um inteiro é 4 bytes temos que para armazenar N inteiros precisamos de  4xN bytes
	array : .space 20
	tamanho : .word 5
.text
	.macro pular_linha()
		la $a0, salto_de_linha
		li $v0, 4
		syscall
	.end_macro
	
	.macro pegar_elemento(%pos)
		move $t9, %pos
		mul $t9, $t9, 4
		lb $t8, array($t9)
	.end_macro
	
	.macro imprimir_elemento(%pos)
		pegar_elemento(%pos)
		move $a0, $t8
		li $v0, 1
		syscall
	.end_macro
	
	.macro imprimir_frase(%frase)
		la $a0, %frase
		move $v0, $a0
		li $v0, 4
		syscall
	.end_macro
	
	.macro inserir(%pos,%valor)
		move $t9, %pos
		mul $t9, $t9, 4
		sb %valor, array($t9)
	.end_macro
	
	.macro trocar_elemento(%posA,%posB)
		pegar_elemento(%posA)
		move $t6, $t8
		pegar_elemento(%posB)
		move $t7, $t8
		inserir(%posA,$t7)
		inserir(%posB,$t6)
	.end_macro
	
	main:
		imprimir_frase(solicitacao)
		jal ler_array
		
		imprimir_frase(imprecao)
		jal imprimir_vetor
		
		imprimir_frase(imprecao_)
		jal montar_heap
		jal imprimir_vetor
		
		imprimir_frase(imprecao__)
		lw $s6, tamanho # preservo o valor do tamanho
		jal heap_sort
		
		fim_de_fluxo:
			jal imprimir_vetor
		
			li $v0,10
			syscall
	
	heap_sort:
		blez $s6,heap_sort_fim #caso base
		sub $s6, $s6, 1
		trocar_elemento($zero,$s6)
		move $t0,$zero # valor de $t0 vira 0 pois como houve troca temos que chamar o heapify na posicao 0
		move $s0,$s6
		jal heapify
		j heap_sort # chama a si mesmo 
		
	heap_sort_fim:
		j fim_de_fluxo
	
	
	heapify:
		mul $t1, $t0, 2 #indice do filho esquerdo 2*posicao chamada + 1
		add $t1, $t1, 1
		
		mul $t2, $t0, 2 #indice do filho direito  2*posicao chamada + 2
		add $t2, $t2, 2

		move $t3, $t0 #indice maior elemento
		
		pegar_elemento($t3) #valor do elemento chamado irá para $t4
		move $t4,$t8 
		#verifica se o indice do filho esquerdo é valido
		blt $t1,$s0,esquerdo_valido
		j esquerdo_invalido
		
		esquerdo_valido:
			pegar_elemento($t1) #valor do filho esquerdo irá para $t6
			move $t6,$t8
			bgt $t6,$t4, esquerdo_maior
			j esquerdo_menor
				esquerdo_maior:
					move $t3,$t1  # o maior indice se torna o valor do filho esquerdo, entao tenho que inserir em $t3
					pegar_elemento($t3)
					move $t4,$t8 # atualizo o valor do registrodor que estava armazenando o valor no vetor de $t3, pois o mesmo acaba de udar
					esquerdo_menor:			
		esquerdo_invalido:
		
		blt $t2,$s0,direito_valido #verifica se o indice do filho direito é valido
		j direito_invalido
		
		direito_valido:
			pegar_elemento($t2) #valor do filho direito irá para $t6 da mesma forma
			move $t6,$t8
			bgt $t6,$t4, direito_maior
			j direito_menor
				direito_maior:
					move $t3,$t2 # o maior indice se torna o valor do filho direito, entao tenho que inserir em $t3
				direito_menor:
					
		direito_invalido:
		bne $t3,$t0,indice_diferente #verifica se houve mudança de índice assim, tendo que chamar o heapify novamente para manutencao
		jr $ra
		indice_diferente :
			trocar_elemento($t0,$t3) # troca elemento
			move $t0,$t3
			j heapify # e realiza  as chamada
		
	
	montar_heap:
		lw $s0,tamanho # montar heap funciona realizando chamadas no penultimo nivel da arvore, que deve ser acessado via (tamanho+1)/2
		add $s1,$s0,1
		div $s1,$s1,2
		move $s7,$ra
		montar_heap_:
			bltz $s1,montar_heap_fim
			move $t0,$s1
			jal heapify
			sub $s1, $s1, 1
			j montar_heap_
		
		montar_heap_fim:
			jr $s7
	
	
	ler_array:
		li $t0, 0
		lw $t1,tamanho
		bne $t0,$t1,loop_leitura
		loop_leitura:
			#leitura acontece aqui
			li $v0, 5
			syscall
			inserir($t0,$v0)
			pular_linha()
			add $t0,$t0,1
			beq $t0,$t1,loop_leitura_fim
			j loop_leitura
		loop_leitura_fim:
			jr $ra
	
	
	imprimir_vetor:
		li $t0, 0
		lw $t1,tamanho
		bne $t0,$t1,imprimir_loop
		imprimir_loop:
			imprimir_elemento($t0)
			pular_linha()
			add $t0,$t0,1
			beq $t0,$t1,imprimir_end_loop
			j imprimir_loop
		imprimir_end_loop:
			jr $ra
		
		
	
