.text
.globl main

main:
move $fp, $sp
addi $sp, $sp, -4
sw $ra, 0($sp)
jal GLOBAL_main_label1
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

GLOBAL_main_label1:
### pushing space to stack for declared vars ###
addi $sp, $sp, -4

### LOCAL ID ADRS OF y ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF y ###

### CONSTANT INT 10 ###
addi $sp, $sp, -4
li $t0, 10
sw $t0, 0($sp)
### END OF CONSTANT INT 10 ###

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### GLOB ID ADRS OF x ###
la $t0, global_variable_3
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF GLOB ID ADRS x ###

### CONSTANT INT 20 ###
addi $sp, $sp, -4
li $t0, 20
sw $t0, 0($sp)
### END OF CONSTANT INT 20 ###

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
### LOCAL ID VALUE OF y ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF y ###

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_2
li $v0, 4
syscall
la $a0, str_const_1
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### GLOB ID VALUE OF x ###
la $t0, global_variable_3
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF GLOB ID VALUE x ###

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_2
li $v0, 4
syscall
la $a0, str_const_1
li $v0, 4
syscall
### END OF PRINT ###

### poping declared vars from stack ###
addi $sp, $sp, 4

jr $ra

.data
str_const_0:  .asciiz "Runtime Error"
str_const_1:  .asciiz "\n"
str_const_2:  .asciiz " "
global_variable_3: .word 0
