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

#### WHILE ####
start_label2:

### CONSTANT BOOL false ###
addi $sp, $sp, -4
move $t0, $zero
sw $t0, 0($sp)
### END OF CONSTANT BOOL false ###

lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, end_label3
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### PRINT ###

### CONSTANT STRING khodafez ###
addi $sp, $sp, -4
la $t0, str_const_8
sw $t0, 0($sp)
### END OF CONSTANT STRING khodafez ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_4
li $v0, 4
syscall
### END OF PRINT ###

### poping declared vars from stack ###
addi $sp, $sp, 0

j start_label2
end_label3:
#### END OF WHILE ####

### PRINT ###

### CONSTANT STRING salam ###
addi $sp, $sp, -4
la $t0, str_const_9
sw $t0, 0($sp)
### END OF CONSTANT STRING salam ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
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
str_const_0:  .asciiz "Runtime Error"
str_const_1:  .asciiz "array index is less than zero"
str_const_2:  .asciiz "array index is more than arr.size-1"
str_const_3:  .asciiz "array size can't be negative"
str_const_4:  .asciiz "\n"
str_const_5:  .asciiz " "
str_const_6:  .asciiz "true"
str_const_7:  .asciiz "false"
str_const_8:  .asciiz "khodafez"
str_const_9:  .asciiz "salam"
