.text
.globl main

main:
move $fp, $sp
move $s0, $ra
addi $sp, $sp, -4
sw $ra, 0($sp)
jal GLOBAL_main_label1
addi $sp, $sp, 4
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

GLOBAL_main_label1:
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### PRINT ###
### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

## + ##
lw $t0, 4($sp)
lw $t1, 0($sp)
add $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF + ##

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### CONSTANT INT 2 ###
addi $sp, $sp, -4
li $t0, 2
sw $t0, 0($sp)
### END OF CONSTANT INT 2 ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

## - ##
lw $t0, 4($sp)
lw $t1, 0($sp)
sub $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF - ##

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### CONSTANT INT 12 ###
addi $sp, $sp, -4
li $t0, 12
sw $t0, 0($sp)
### END OF CONSTANT INT 12 ###

### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

## / ##
lw $t0, 4($sp)
lw $t1, 0($sp)
div $t0, $t0, $t1
addi $sp, $sp, 4
mflo $t0
sw $t0, 0($sp)
## END OF / ##

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### CONSTANT INT 123 ###
addi $sp, $sp, -4
li $t0, 123
sw $t0, 0($sp)
### END OF CONSTANT INT 123 ###

### CONSTANT INT 456 ###
addi $sp, $sp, -4
li $t0, 456
sw $t0, 0($sp)
### END OF CONSTANT INT 456 ###

## * ##
lw $t0, 4($sp)
lw $t1, 0($sp)
mul $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF * ##

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### CONSTANT INT 78 ###
addi $sp, $sp, -4
li $t0, 78
sw $t0, 0($sp)
### END OF CONSTANT INT 78 ###

### CONSTANT INT 9 ###
addi $sp, $sp, -4
li $t0, 9
sw $t0, 0($sp)
### END OF CONSTANT INT 9 ###

## / ##
lw $t0, 4($sp)
lw $t1, 0($sp)
div $t0, $t0, $t1
addi $sp, $sp, 4
mfhi $t0
sw $t0, 0($sp)
## END OF / ##

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### poping declared vars from stack ###
addi $sp, $sp, 0

### auto return of func main ###
addi $sp, $sp, -4
li $t0, -1000
sw $t0, 0($sp)
### end of auto return of func main ###

jr $ra


itob:
lw $t0, 4($sp)
beqz $t0, false_label
li $t0, 1
sw $t0, 4($sp)
jr $ra
false_label:
li $t0, 0
sw $t0, 4($sp)
jr $ra

.data
input_buffer__: .space 1000
str_const_0:  .asciiz ""
str_const_1:  .asciiz "Runtime Error"
str_const_2:  .asciiz "array index is less than zero"
str_const_3:  .asciiz "array index is more than arr.size-1"
str_const_4:  .asciiz "array size can't be negative"
str_const_5:  .asciiz "\n"
str_const_6:  .asciiz " "
str_const_7:  .asciiz "true"
str_const_8:  .asciiz "false"
