# Stuart Leal Quesda	
# B53777				
	.text		
main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)


	# Prueba 1: Imprimir las matrix y el resultado final de mult

	# Imprimir nueva prueba
	la $a0, prueba
	li $v0, 4
	syscall

	# Cargar matrices para impresion
	la $a0, Matrix1 # Cargar posicion de la matriz 1
	jal imprimir_matriz
	la $a0, Matrix2 # Cargar la posicion de la segunda matrix
	jal imprimir_matriz 

	# IMPRIMIR FRASE RESULTADO
	la $a0, frase2
	li $v0, 4 # string
	syscall

	# CALCULAR EL RESULTADO
	la $a0, Matrix1
	la $a1, Matrix2
	jal mult_matrix
	add $a0, $0, $v0
	jal imprimir_matriz

	# Prueba 2: Imprimir las matrix y el resultado final de mult

	# Imprimir nueva prueba
	la $a0, prueba
	li $v0, 4
	syscall

	# Cargar matrices para imression
	la $a0, Matrix3 # Cargar posicion de la matriz 3
	jal imprimir_matriz
	la $a0, Matrix4 # Cargar la posicion de la segunda matrix
	jal imprimir_matriz 
	
	
	# IMPRIMIR FRASE RESULTADO
	la $a0, frase2
	li $v0, 4 # string
	syscall

	# CALCULAR EL RESULTADO
	la $a0, Matrix3
	la $a1, Matrix4
	jal mult_matrix
	add $a0, $0, $v0
	jal imprimir_matriz

	# Prueba de fallo - IMPRIMIR

	# Imprimir nueva prueba
	la $a0, prueba
	li $v0, 4
	syscall
	
	# Cargar matrices para impresion
	la $a0, Matrix2
	jal imprimir_matriz
	la $a0, Matrix3
	jal imprimir_matriz

	# Prueba de fallo - cargar para mult
	la $a0, Matrix2
	la $a1, Matrix3
	jal mult_matrix
	beq $v0, 0, fin_fallo
	add $a0, $0, $v0
	jal imprimir_matriz
	j fin
fin_fallo:
	li $v0, 4
	la $a0, fallo
	syscall

fin:	
	# Devolver ra de la pila y devolver pila
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

mult_matrix:
	# recibo a0 matrix1
	# a1 matrix 2
	# en v0 se va el resultado
	# 0 si no se puede mult
	# direccion del array si si

	# Paso 1: revisar si son compatibles
	lw $t0, 0($a0)
	lw $t1, 4($a0)
	lw $t2, 0($a1)
	lw $t3, 4($a1)

	# Iniciar v0 en 0
	add $v0, $0, $0

	# bne
	bne $t1, $t2, fin_mult # Si no son iguales va a fin

	# Paso 2: llamar memoria para el resultado
	mult $t0, $t3
	mflo $t4
	addi $t5, $0, 8
	mult $t4, $t5
	mflo $t4
	add $t4, $t4, $t5 # Se guarda en t4 la cantidad de bytes
	# Aca se pide la memoria al sistema
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	add $a0, $0, $t4
	li $v0, 9
	syscall
	
	# Devolver a0
	lw $a0, 0($sp)
	addi $sp, $sp, 4

	# Paso 3: Guardar los valores resultantes de fila y columna
	sw $t0, 0($v0)
	sw $t3, 4($v0)

	# Paso 4: iniciar la mult
	li $t4, 0 # i
	li $t5, 0 # j
	li $t6, 0 # contador
	li $t7, 1 # desfase
	add $s0, $0, $t1
	add $s1, $0, $t3
	#addi $s0, $s0, -1 #contador maximo
loop_mult_1:
	# Iteracion para sumar i++
	# Encontrar (i+jxcolumnas+desfase)x8
	mult $t5, $t3
	mflo $t8 # cargar jxcolumnas
	add $t8, $t8, $t4
	add $t8, $t8, $t7 # i+jxcolumnas+desfase
	sll $t8, $t8, 3 # multiplicar por 8
	add $t8, $v0, $t8 # (j+jxcolumnas+desfase)x8 + v0
	#sdc1 $0, 0($t8) # Cargar cero para limpiar
	#add.d $
loop_mult_2:
	# Iteracion para hacer la mult
	# En este punto $t1 y $t2 ya no se necesitan
	# Vamos a usarlos
	# Cargar en $t1 el dato correspondiente del loop
	# De la primera matriz
	# Y en $t2 el dato correspondiente del loop
	# De la segunda matriz
	# Multiplicar y guardar en $t8 + =
	# salirse si cont = colmnas m_1

	# numero de la matrix1
	mult $t5, $s0
	mflo $t1 # cargar jxcolumnas
	add $t1, $t1, $t6 #(cont+jxcolumnas)
	add $t1, $t1, $t7 #(cont+jxcolumnas+desfase)
	sll $t1, $t1, 3 # multiplicar por 8
	add $t1, $t1, $a0 # sumar v0
	ldc1 $f0, 0($t1) # Cargar el primer numero
	
	# numero de la matrix2
	mult $t6, $s1
	mflo $t2 # # cargar cont*columnas
	add $t2, $t2, $t4
	add $t2, $t2, $t7 # (j+contxcolumnas+desfase)
	sll $t2, $t2, 3 # multiplicar por 8
	add $t2, $t2, $a1 # agregar v0
	ldc1 $f2, 0($t2)

	# multiplicar
	mul.d $f4, $f0, $f2

	# Cargar el valor de la posicion
	ldc1 $f6, 0($t8)
	add.d $f6, $f4, $f6 # agregar el valor de esta iteracion
	sdc1 $f6, 0($t8)
	
	addi $t6, $t6, 1 # sumarle 1 al contador
	
	beq $t6, $s0, fin_loop_mult_2
	j loop_mult_2
fin_loop_mult_2:
	li $t6, 0 # Devovler contador a cero
	addi $t4, $t4, 1 # agregar 1 a i
	beq $t4, $t3, fin_loop_mult_1
	j loop_mult_1
	
fin_loop_mult_1:
	li $t4, 0 # i = 0
	addi $t5, $t5, 1 # agregar 1 a j
	beq $t5, $t0, fin_mult
	j loop_mult_1
	
fin_mult:
	jr $ra
	
imprimir_matriz:
	# imprimir la matriz
	add $t9, $0, $a0 # guardar a0
	lw $t0, 0($t9)
	lw $t1, 4($t9)
	li $t2, 0 # i
	li $t3, 0 # j

loop_1:
	li $v0, 4
	la $a0, frase1
	syscall
loop_2:
	li $t4, 1 # desfase # Desfase para que empiece en a0 + 8
	# multiplicar j x columnas
	mult $t1, $t3 # mult de columnas por filas
	mflo $t5 # Cargar jxcolumnas
	add $t5, $t5, $t2 # i + jxcolumnas
	add $t4, $t4, $t5 # i +jxcolumas + desfase
	sll $t4, $t4, 3 # multiplicar por 8
	add $t4, $t4, $t9 # a0 + (i+jxcolumnas+desfase)x8
	li $v0, 3 # cargar int
	ldc1 $f12, 0($t4) # cargar el numero
	syscall # imprimir
	li $v0, 4 # cargar string
	la $a0, tab # cargar el tab
	syscall # imprimir el tab
	addi $t2, $t2, 1 # agregar 1 a i
	beq $t2, $t1, fin_loop2
	j loop_2
fin_loop2:
	li $v0, 4
	la $a0, enter
	syscall
	li $t2, 0 # i = 0
	addi $t3, $t3, 1 # agregar 1 a j
	beq $t3, $t0, fin_loop1
	j loop_2
fin_loop1:
			
fin_imprimir_matriz:
	jr $ra

	.data 0x10000000
comma: .asciiz ", "
var: .word 8
ptr: .word 0

	.data 0x10000010
Matrix1:
	.word 2, 3
	.double 1.0, 2.0, 3.0, 4.0, 5.0, 6.0

	.data 0x10000100
Matrix2:
	.word 3,2
	.double 6.0, 5.0, 4.0, 3.0, 2.0, 1.0

	.data 0x10001000
Matrix3:
	.word 3,3
	.double 3.0, 2.0, 1.0, 1.0, 1.0, 3.0, 0.0, 2.0, 1.0

	.data 0x10010000
Matrix4:
	.word 3,1
	.double 2.0, 1.0, 3.0
	
	.data
tab:
	.asciiz "\t"
enter:
	.asciiz "\n"
frase1:
	.asciiz "\nImprimiendo matrix\n"
frase2:
	.asciiz "\nResultado\n"
fallo:
	.asciiz "\n WARNING! Las matrices no son compatibles \n"
prueba:
	.asciiz "\n NUEVA PRUEBA: \n"
