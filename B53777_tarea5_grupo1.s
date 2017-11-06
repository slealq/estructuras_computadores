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
	li $t0, 10
	swc1 $f0, 0($t0)
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

	# Guardar direccion de ptrList
	add $t0, $0, $a0

	# Pedir memoria
	addi $a0, $0, 8
	li $v0, 9
	syscall

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
