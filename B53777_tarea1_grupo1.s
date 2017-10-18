# Stuart Leal Quesada
# B53777
# Estructura basica
# i = 0
# v0 = a[i]
# v1 = a[i]
# while a[i] != 0:
#   if a[i] < v0:
#     v0 = a[i]
#   if v1 > a[i]:
#     v1 = a[i]
#   i++

.text
main:
	la $a0, word # Cargar posicion del array
	jal iterar # Ir a la funcion iterar
	jal imprimir # Funcion imprimir
	li $v0, 10
	syscall
		
iterar:	
	addi $s0, $s0, 0 # s0 = i = 0
	add $s0, $a0, $s0 # i = 0 + a0
	lw $v0, 0($s0) # v0 = a[0]
	lw $v1, 0($s0) # v1 = a[1]
while:
	lw $s1, 0($s0) # s1 = a[i]
	beq $s1, $0, fin # fin if a[i] == 0
	slt $t0, $s1, $v0 # if a[i] < v0 t0 = 1
	slt $t1, $v1, $s1 # if v1 < a[1] t1 = 1
	addi $s0, $s0, 4 # i = i+a
	bne $t0, 1, else_max # if t0 != 1 elsemax
	add $v0, $s1, $0 # v0 = a[i]
else_max:
	bne $t1, 1, while # if t1 != while
	add $v1, $s1, $0 # v1 = a[i]
	j while
fin:
	jr $ra

# Definir la funcion para imprimir las variables a0, v0, v1
imprimir:
	add $s0, $0, $a0
	add $s1, $0, $v0
	add $s2, $0, $v1
	li $v0, 4 # 4 string
	la $a0, array # Cargar array
	syscall
	li $v0, 1 # int
	la $s0, word # Cargar word
	addi $t1, $0, 4 # t1 = i = 4
for:
	lw $a0, ($s0) # cargar el valor del array
	syscall
	add $s0, $s0, $t1 # sumarle i
	beq $a0, $0, for_end # irse al final si el valor es cero
	li $v0, 4 # string 
	la $a0, espacio # cargar un espacio
	syscall # imprimir
	li $v0, 1 # int de nuevo
	j for
for_end:
	li $v0, 4 # string 
	la $a0, enter # guardar el enter
	syscall # imprimir el enter
	la $a0, minimo # cargar minimo
	syscall # imprimir minimo
	li $v0, 1 # int # cargar un int
	add $a0, $s1, $0 # guardar en a0 el minimo
	syscall # imprimir
	li $v0, 4 # string
	la $a0, enter # guardar enter
	syscall # imprimir
	li $v0, 4 # string
	la $a0, maximo # imprimir maximo
	syscall # imrpimir 
	li $v0, 1 # int
	add $a0, $s2, $0 # guardar el valor del maximo
	syscall # imprimir
	jr $ra
		
.data
word:
  .word 87 , 216 , -54, 751 , 1 , 36 , 1225 , -446, -6695, -8741, 101 , 9635 , -9896, 4 , 2008 , -99, -6, 1 , 544 , 6 , 7899 , 74 , -42, -9, 0
enter:
  .asciiz "\n"
espacio:
  .asciiz " "
minimo:
  .asciiz "Valor minimo: "
maximo:
  .asciiz "Valor maximo: "
array:
  .asciiz "El valor del array despues de la ejecucion "
