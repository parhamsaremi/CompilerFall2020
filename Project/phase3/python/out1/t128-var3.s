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
addi $sp, $sp, -4

### LOCAL ID ADRS OF a ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF a ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### GLOB ID ADRS OF b ###
la $t0, global_variable_9
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF GLOB ID ADRS b ###

### CONSTANT INT 2 ###
addi $sp, $sp, -4
li $t0, 2
sw $t0, 0($sp)
### END OF CONSTANT INT 2 ###

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### pushing space to stack for declared vars ###
addi $sp, $sp, -4

### LOCAL ID ADRS OF b ###
move $t0, $fp
addi $t0, $t0, -12
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF b ###

### CONSTANT INT 5 ###
addi $sp, $sp, -4
li $t0, 5
sw $t0, 0($sp)
### END OF CONSTANT INT 5 ###

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### PRINT ###
### LOCAL ID VALUE OF b ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF b ###

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_4
li $v0, 4
syscall
### END OF PRINT ###

### poping declared vars from stack ###
addi $sp, $sp, 4

### PRINT ###
### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
### GLOB ID VALUE OF b ###
la $t0, global_variable_9
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF GLOB ID VALUE b ###

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_4
li $v0, 4
syscall
### END OF PRINT ###

### poping declared vars from stack ###
addi $sp, $sp, 4

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
global_variable_8: .word 0
global_variable_9: .word 0
