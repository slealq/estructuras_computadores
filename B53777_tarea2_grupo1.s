# Stuart Leal Quesada

.text		
main:
	la $a0, frase2 # Cargar la frase 1, 2, 3 (Deberian dar que son palindromos)
	# O cargar la frase 4 que no es un palindromo
	jal palindromo
	jal respuesta
	li $v0, 10
	syscall
	
palindromo:
	# La funcion hara lo siguiente:
	# Primero contara cuantos caracteres tiene la frase
	# Luego le restara 1 para tener asi la direccion del ultimo caracter
	# Cargara el primer y ultimo caracter
	# Revisa si los caracteres son un espacio o no
	# Si alguno de los dos es un espacio, le suma uno, o le resta uno
	# Para avanzar de izquierda a derecha o de derecha a izquiera
	# Si alguno de los dos caracteres es menor a 91, entonces
	# Le suma 32 para hacer el caracter una minuscula
	# Finalmente si el caracter fuera NULL entonces termina
	# Ahora compara los caracteres
	# Si son iguales sigue
	# Si son diferentes entonces hace v0 = 0 y termina el programa
	addi $sp, $sp, -4 # Hacer espacio para ra
	sw $ra, 0($sp)
	addi $t0, $0, 0
count_loop:
	# Aca se cuenta hasta que encuentre el caracter null
	add $t1, $a0, $t0
	lb $t2, 0($t1)
	beq $t2, $0, count_fin
	addi $t0, $t0, 1 # t0 tiene la longitud del palindromo
	j count_loop
count_fin:
	# Se le resta uno para tener la posicion del ultimo caracter
	addi $t0, $t0, -1
	jal analyze
	lw $ra, 0($sp)
	addi $sp, $sp, 4 # Devolver la pila
	jr $ra

analyze:
	# Aca se hace el analisis de los caracteres de derecha a izquierda y viceversa
	addi $sp, $sp, -4 # Hacer espacio para ra
	sw $ra, 0($sp)
	# leer a1 para el tamaño del frase
	# OJO el tamaño esta en t0 der-izq
	addi $t1, $0, 0 # Iniciar contador para izq-der
	#Iniciar pos de memoria en primero y ultimo
	add $t1, $t1, $a0
	add $t0, $t0, $a0
	# hacer i++ hasta que encuentre a null y pasarlo por a1
	addi $t9, $0, 32 # Valor de 32 para el espacio
	addi $t8, $0, 91 # Valor de 91 para comparar si es Upper o lower
	addi $t7, $0, 1 # Setear el valor a 1 para saber si es o no palindromo
	addi $s0, $0, 1 # Valor de 1 para comparacion slt
analyze_loop:
	lb $t2, 0($t1) # Este es izq-der
	lb $t3, 0($t0) # Este es el valor der-izq
	beq $t2, $0, an_fin
	# si es espacio sumar uno o restar uno al contador
izq_der:	
	bne $t2, $t9, der_izq
	add $t1, $t1, 1 # Sumar 1 al contador izq_der
	lb $t2, 0($t1) # Volver a cargar
der_izq:
	bne $t3, $t9, analyze_comp
	add $t0, $t0, -1 # Restar 1 al contador der_izq
	lb $t3, 0($t0)
analyze_comp:
	# si es mayor a 91 sumarle 32 para hacerla minuscula
	slt $t4, $t2, $t8
an_iz_der:	
	bne $s0, $t4, an_der_iz
	add $t2, $t2, $t9
an_der_iz:
	slt $t4, $t3, $t8
	bne $s0, $t4, an_finale
	add $t3, $t3, $t9
an_finale:	
	# si son el mismo valor no hacer nada
	addi $t0, $t0, -1
	addi $t1, $t1, 1
	bne $t2, $t3, an_sumar
	j analyze_loop
an_sumar:		
	# sin son de valores diferentes settera t0 a 0
	addi $t7, $0, 0
	# finalmente, guardar t0 en v0 y terminar
an_fin:
	add $v0, $0, $t7 # Si es palindromo t7 = 1
	lw $ra, 0($sp)
	addi $sp, $sp, 4 # Devolver la pila
	jr $ra

respuesta:
	# Funcion basica para imprimir el resultado en consola
	add $s0, $v0, $0
	addi $sp, $sp, -4 # Agregar a la pila
	sw $ra, 0($sp) # Cargar a la pila ra
	li $v0, 4
	bne $0, $s0, imprimir_pal
	la $a0, nopalindromo
	syscall
regresar:
	lw $ra, 0($sp) # Cargar a la pila ra
	addi $sp, $sp, 4 # Devolver la pila
	jr $ra
imprimir_pal:
	la $a0, palindromo_r
	syscall
	j regresar

.data
palindromo_r:
	.asciiz "La frase elegida es un palindromo"
nopalindromo:
	.asciiz "La frase elegida NO es un palindromo"
	
frase1:
	.asciiz "La ruta natural"

frase2:
	.asciiz "Se VAN sus naves"

frase3:
	.asciiz "La ruta nos aporto Otro paso natural"
frase4:
	.asciiz "Esto no es un palindromo"
