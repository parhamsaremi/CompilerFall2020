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
addi $sp, $sp, -0

### PRINT ###
### CONSTANT INT 0 ###
addi $sp, $sp, -4
li $t0, 0
sw $t0, 0($sp)
### END OF CONSTANT INT 0 ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

lw $t0, 4($sp)
lw $t1, 0($sp)
sub $t0, $t0, $t1
slt $t2, $t0, $zero
slt $t3, $zero, $t0
or $t2, $t2, $t3
addi $sp, $sp, 4
sw $t2, 0($sp)
lw $t0, 0($sp)
beq $t0, $zero, print_false_label2
la $a0, str_const_6
li $v0, 4
syscall
j print_end_label3
print_false_label2:
la $a0, str_const_7
li $v0, 4
syscall
print_end_label3:
addi $sp, $sp, 4
la $a0, str_const_4
li $v0, 4
syscall
### END OF PRINT ###

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

lw $t0, 4($sp)
lw $t1, 0($sp)
sub $t0, $t0, $t1
slt $t2, $t0, $zero
slt $t3, $zero, $t0
or $t2, $t2, $t3
addi $sp, $sp, 4
sw $t2, 0($sp)
lw $t0, 0($sp)
beq $t0, $zero, print_false_label4
la $a0, str_const_6
li $v0, 4
syscall
j print_end_label5
print_false_label4:
la $a0, str_const_7
li $v0, 4
syscall
print_end_label5:
addi $sp, $sp, 4
la $a0, str_const_4
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###

### CONSTANT BOOL true ###
addi $sp, $sp, -4
addi $t0, $zero, 1
sw $t0, 0($sp)
### END OF CONSTANT BOOL true ###


### CONSTANT BOOL true ###
addi $sp, $sp, -4
addi $t0, $zero, 1
sw $t0, 0($sp)
### END OF CONSTANT BOOL true ###

lw $t0, 4($sp)
lw $t1, 0($sp)
sub $t0, $t0, $t1
slt $t2, $t0, $zero
slt $t3, $zero, $t0
or $t2, $t2, $t3
addi $sp, $sp, 4
sw $t2, 0($sp)
lw $t0, 0($sp)
beq $t0, $zero, print_false_label6
la $a0, str_const_6
li $v0, 4
syscall
j print_end_label7
print_false_label6:
la $a0, str_const_7
li $v0, 4
syscall
print_end_label7:
addi $sp, $sp, 4
la $a0, str_const_4
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###

### CONSTANT BOOL true ###
addi $sp, $sp, -4
addi $t0, $zero, 1
sw $t0, 0($sp)
### END OF CONSTANT BOOL true ###


### CONSTANT BOOL false ###
addi $sp, $sp, -4
move $t0, $zero
sw $t0, 0($sp)
### END OF CONSTANT BOOL false ###

lw $t0, 4($sp)
lw $t1, 0($sp)
sub $t0, $t0, $t1
slt $t2, $t0, $zero
slt $t3, $zero, $t0
or $t2, $t2, $t3
addi $sp, $sp, 4
sw $t2, 0($sp)
lw $t0, 0($sp)
beq $t0, $zero, print_false_label8
la $a0, str_const_6
li $v0, 4
syscall
j print_end_label9
print_false_label8:
la $a0, str_const_7
li $v0, 4
syscall
print_end_label9:
addi $sp, $sp, 4
la $a0, str_const_4
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
str_const_1:  .asciiz "array index is less than zero"
str_const_2:  .asciiz "array index is more than arr.size-1"
str_const_3:  .asciiz "array size can't be negative"
str_const_4:  .asciiz "\n"
str_const_5:  .asciiz " "
str_const_6:  .asciiz "true"
str_const_7:  .asciiz "false"
