.text
.globl main

main:
move $fp, $sp
addi $sp, $sp, -4
sw $ra, 0($sp)
jal GLOBAL_main_label1
addi $sp, $sp, 4
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

GLOBAL_main_label1:
### pushing space to stack for declared vars ###
addi $sp, $sp, -0

### PRINT ###

### CONSTANT BOOL true ###
addi $sp, $sp, -4
addi $t0, $zero, 1
sw $t0, 0($sp)
### END OF CONSTANT BOOL true ###

lw $t0, 0($sp)
beq $t0, $zero, print_false_label2
la $a0, str_const_3
li $v0, 4
syscall
j print_end_label3
print_false_label2:
la $a0, str_const_4
li $v0, 4
syscall
print_end_label3:
addi $sp, $sp, 4
la $a0, str_const_2
li $v0, 4
syscall
la $a0, str_const_1
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###

### CONSTANT BOOL false ###
addi $sp, $sp, -4
move $t0, $zero
sw $t0, 0($sp)
### END OF CONSTANT BOOL false ###

lw $t0, 0($sp)
beq $t0, $zero, print_false_label4
la $a0, str_const_3
li $v0, 4
syscall
j print_end_label5
print_false_label4:
la $a0, str_const_4
li $v0, 4
syscall
print_end_label5:
addi $sp, $sp, 4
la $a0, str_const_2
li $v0, 4
syscall
la $a0, str_const_1
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

.data
str_const_0:  .asciiz "Runtime Error"
str_const_1:  .asciiz "\n"
str_const_2:  .asciiz " "
str_const_3:  .asciiz "true"
str_const_4:  .asciiz "false"
