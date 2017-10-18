# Stuart Leal Quesada
# B53777
# Nota: Se toma como ejemplo la rotacion
# De 1 bit vista en clase
# Ademas el codigo va explicado por cada seccion
# Los numeros finales estan en decimal
# Pero haciendo la conversion a binario
# Se puede verificar facilmente el funcionamiento
# Con la siguiente pagina
# http://www.binaryconvert.com/result_signed_int.html?decimal=050048
# Correcto del metodo
.text
main:
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  la $a0, word
  la $a1, pal
  lw $a1, 0($a1)
  li $a2, 20
  jal imprimir
  jal sraMP
  jal imprimir
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra

# Funcion para realizar la rotacion
sraMP:
  # apilar
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  # a0 direccion del arreglo
  # a1 numero de palabras
  # a2 numero de bits a desplazar
  # Primero se debe revisar si el numero esta dentro del rango
  addi $t1, $0, 0
  addi $t0, $0, 32
  mult $a1, $t0 # multiplicar NP * 32
  mflo $t0 # Resultado
  slt $t1, $t0, $a2 # set si to < NP * 32
  bne $t1, $0, sraFIN
  slt $t1, $a2, $0 # set si a2 < 0
  bne $t1, $0, sraFIN
  # Valor para la funcion exitosa
  addi $v0, $0, 1
  addi $s0, $0, 0
revisar:
  # Revisar el bit MSB de la MSW para ver si el
  # numero es positivo o negativo
  addi $t0, $0, 0
  add $t0, $a1, $0
  addi $t0, $t0, -1
  sll $t0, $t0, 2
  addu $t0, $t0, $a0 # direccion del MSW
  lw $t0, 0($t0)
  li $t1, 0x80000000 # Mascara para ver el primer bit
  and $t0, $t0, $t1 # t0 puede ser 0x80000000 o 0x00000000
  bne $t0, $0, uno # si es cero entonces el numero es positivo
  addi $a3, $0, 0 # poner un cero para hacer la rotacion normal
  j sraloop # Saltar al loop metiendo ceros
uno:
  addi $a3, $0, 1 # si es 0x80000000 entonces hacer la rotacion metiendo unos
sraloop:
  beq $s0, $a2, srafin
  jal srauno
  addi $s0, $s0, 1
  j sraloop
sraFIN:
  addi $v0, $0, 0
srafin:
  # devolver pila
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra

# Funcion para rotar una vez hacia la derecha
# Recibe en a3 el numero a introducir
# A parte de recibir en a0 la direccion base
# Y en a1 el numero de palabras
srauno:
  # Metodo auxiliar que realiza un sra de multiple presion a una posicion
  # Si de desea hacer a varias posiciones n se debe llamar este metodo n veces
  addi $sp, $sp, -12 # Tres espacios
  sw $a1, 8($sp)
  sw $a3, 4($sp)
  sw $v0, 0($sp)
  # Recibe tres parametros
  # a0 direccion base del numero de multiple precision
  # a1 numero de palabras
  # a3 meter 1 o meter 0
  # Logica:
  # Para el primer ciclo mete 1 o 0 segun le diga el usuario
  # Por medio del parametro a3
  # Ahora en el siguiente ciclo sobreescribe la variable de lo que tiene que meter
  # Si el ultimo numero de la palabra anterior es un 1,
  # Entonces setea a3 a 1 para saber que tiene que meter 1
  # Si el ultimo numero es cero, entonces setea a3 a 0 para
  # Meter un 0.
  # Termina cuando llega al final de las palabras
  add $t0, $0, $a1 # numero de palabras
  addi $t0, $t0, -1 # Restarle uno para quedar en el final
  li $t1, 0x00000001 # Mascara para ver el numero lsb
  li $t2, 0x80000000 # Mascara para introducir un uno
  # Esto es importante porque el lsb de una palabra
  # Entra en el msb de la siguiente
  # Se necesita ver cual es el lsb de la palabra anterior
  # Para saber que introducir en la siguiente
loop:
  sll $t4, $t0, 2 # Multiplicar t0 por dos para tener memoria fisica
  addu $t5, $t4, $a0 # Sumar la posicion de la base
  lw $t6, 0($t5) # En este paso ya se tiene en t6 el la palabra con la que se va tratar
  and $t4, $t6, $t1 # Se hace la mascara para guardar cual es el ultimo bit
  # Ojo que en el paso anterior t4 no guarda nada importante
  # Si t4 tiene cero, el ultimo bit de la palabra actual es cero
  # Si t4 tiene uno, el ultimo bit es uno
  # Ahora puedo rotar la palabra a la derecha
  # Sin embargo tengo dos opciones
  # a3, que es el numero a insertar en la palabra actual
  # puede tener un uno o un cero
  srl $t6, $t6, 1
  bne $a3, $0, insertar_uno
insertar_cero:
  # Si a3 tiene cero, ya se inserto un cero en la palabra actual
  j siguiente
insertar_uno:
  # Si a3 tiene un uno, vamos a insertar un uno en la palabra actual
  or $t6, $t6, $t2 # Esto le introduce un 1 en el MSB
  j siguiente
siguiente:
  # Cualquier camino nos lleva a aca
  # Ahora necesito guardar en a3 el siguiente valor
  # De acuerdo a lo encontrado en la seccion loop
  add $a3, $0, $t4 # Recordar que aqui se habia guardado el ultimo bit de la palabra
  # Osea solo puede ser 0 o 1 que es lo que se necesita
  # Ahora guardo la palabra en este campo
  sw $t6, 0($t5)
  # Y se termina la suma solo cuando t0 es cero
  beq $t0, $0, endloop
  # Finalmente se resta uno al contador
  addi $t0, $t0, -1
  j loop
endloop:
  lw $a1, 8($sp)
  lw $a3, 4($sp)
  lw $v0, 0($sp)
  addi $sp, $sp, 12 # Devolver la pila
  jr $ra


# Funcion para imprimir el arreglo
imprimir:
  # Hacer espacio para la pila
  addi $sp, $sp, -12 # Tres espacios
  sw $a0, 8($sp)
  sw $ra, 4($sp)
  sw $v0, 0($sp)
  # Recibe en a0 el tamano del array
  add $t0, $0, $a1 # numero de palabras
  addi $t0, $t0, -1 # Restarle uno para quedar en el final
  li $v0, 4 # string
  la $a0, enter # cargar espacio
  syscall
  li $v0, 1 # int
  la $s0, word # Cargar word
for:
  sll $t4, $t0, 2 # Multiplicar por 2
  addu $t4, $t4, $s0
  lw $a0, ($t4) # cargar el valor del array
  syscall
  beq $t0, $0, for_end # irse al final si el valor es cero
  addi $t0, $t0, -1
  li $v0, 4 # string
  la $a0, espacio # cargar un espacio
  syscall # imprimir
  li $v0, 1 # int de nuevo
  j for
for_end:
  lw $a0, 8($sp)
  lw $ra, 4($sp)
  lw $v0, 0($sp)
  addi $sp, $sp, 12 # Devolver la pila
  jr $ra

.data
word:
  .word -2147483648, 20, -1, 30

pal:
  .word 4

espacio:
  .asciiz " "

enter:
  .asciiz "\n"
