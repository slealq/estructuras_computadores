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

	# Imprimir
	jal print
	
	# Insertar 20
	li.s $f0, 20.0
	jal insert

	# Imprimir
	jal print
	
	# Insertar 30
	li.s $f0, 30.0
	jal insert

	# Imprimir
	jal print

	# Insertar 40
	li.s $f0, 40.0
	jal insert

	# Imprimir
	jal print

	# INVERTIR
	jal invert

	# Imprimir
	jal print
	
	# Delete
	jal delete

	# Imprimir
	jal print

	# Delete
	jal delete
	
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
	s.s $f0, 0($v0)

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

	# Guardar en la pila a0
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	# Guardar direccion de ptrList
	add $t0, $0, $a0
	add $t1, $t0, $0
	
encontrar_peni:
	# Cargar el dato de la posicion
	lw $t2, 0($t1)
	beq $t2, $0, encontrado_peni

	# Guardar el penultimo puntero en t0
	add $t0, $t1, $0
	
	# Si no es cero, tiene una direccion
	add $t1, $t2, $0

	# Volver al loop
	j encontrar_peni

encontrado_peni:
	# Encontro el ultimo
	# En este punto, t1 tiene la direccion del ptr del ultimo
	l.s $f0, -4($t1)

	# Ahora eliminar el puntero
	sw $0, 0($t0)
	
	# Devolver cola y devolverse
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	# Regresar
	jr $ra
		
invert:
	# Recibe en a0 ptr list

	# Primero apilar
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	lw $t0, 0($a0)

	# Si esta vacio
	beq $t0, $0, invert_fin

	# para el primer nodo
	lw $t1, 0($t0)
	sw $0, 0($t0) # hacer que el primer nodo apunte a 0
	
invert_loop:
	beq $t1, $0, invert_fin
	move $t3, $t0
	move $t0, $t1
	lw $t1, 0($t1)
	sw $t3, 0($t0)
	sw $t0, 0($a0)
	
	j invert_loop

invert_fin:
	# Termina. Devolver pila y regresar
	# Devolver cola y devolverse
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	# Regresar
	jr $ra
	
print:
	# Guardar en la pila a0
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)

	# Guardar direccion en ptrlist
	add $t0, $0, $a0

	lw $t0, 0($t0)
	
print_loop:
	beq $t0, $0, print_end
	
	l.s $f12, -4($t0)
	li $v0, 2
	syscall

	la $a0, espacio
	li $v0, 4
	syscall

	lw $t0, 0($t0)
	j print_loop

print_end:
	la $a0, enter
	li $v0, 4
	syscall
	
	# Devolver cola y devolverse
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	# Regresar
	jr $ra

# Inicializar la memoria para el pointer list.
	.data
ptrList:
	.word 0

espacio:
	.asciiz " "
enter:
	.asciiz "\n"
