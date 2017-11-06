# Stuart Leal Quesada
# B53777
	.text
main:
	# Guardar en la pila ra
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# Cargar ptr list en a0
	la $a0, ptrList
	
	# Probar initialize
	jal initialize

	# Probar insert
	# Cargar numero
	li.s $f0, 10.0
	jal insert

	li.s $f0, 20.0
	jal insert
	
	# Devolver cola y devolverse
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
initialize:
	# Recibe en a0 ptr list
	# Devuelve en v0 1

	# Guardar 0 en ptrlist
	lw $0, 0($a0)

	# Devolver 1
	li $v0, 1

	jr $ra
insert:
	# Recibe en a0 ptr list
	# Recibe en f0 dato
	# Devuelve en v0 1 si fue exitoso
	
	# Guardar en la pila a0
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	# Guardar direccion de ptrList
	add $t0, $0, $a0

	# Pedir memoria
	addi $a0, $0, 8
	li $v0, 9
	syscall

	# Ahora en v0 esta la direccion
	s.d $f0, 0($v0)

	# Encontrar la direccion de memoria
	# Primero guardo un contador 	
	addi $t1, $0, 0

	# Guardo a0 en t1 para iterar
	add $t1, $t1, $t0

find_last:
	# Cargar el dato de la posicion
	lw $t2, 0($t1)
	beq $t2, $0, encontrado

	# Si no es cero, tiene una direccion
	add $t1, $t2, $0

	# Volver al loop
	j find_last
	
encontrado:	
	# Guardar la direccion en el ultimo puntero
	addi $v0, $v0, 4 # mover a la palabra del puntero
	sw $v0, 0($t1)

	# Devolver cola y devolverse
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	# Regresar
	jr $ra
	
delete:
	# Recibe en a0 ptr list
	# Devuelve en f0 dato

invert:
	# Recibe en a0 ptr list
	

# Inicializar la memoria para el pointer list.
	.data
ptrList:
	.word 0
