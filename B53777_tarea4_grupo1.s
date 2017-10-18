# Stuart Leal Quesda	
# B53777				
	.text		
main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $a0, Matrix1 # Cargar posicion de la matriz 1
	jal imprimir_matriz
	la $a0, Matrix2 # Cargar la posicion de la segunda matrix
	jal imprimir_matriz 
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
mult_matrixz:
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

	.data 0x10001000
Matrix2:
	.word 3,2
	.double 6.0, 5.0, 4.0, 3.0, 2.0, 1.0

	.data
tab:
	.asciiz "\t"
enter:
	.asciiz "\n"
frase1:
	.asciiz "\nImprimiendo matrix\n"
frase2:
	.asciiz "\nResultado\n"
