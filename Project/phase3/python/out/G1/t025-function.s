.text
.globl main

main:
move $fp, $sp
addi $sp, $sp, -4
sw $ra, 0($sp)
jal GLOBAL_main_label2
addi $sp, $sp, 4
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

GLOBAL_func_label1:
### pushing space to stack for declared vars ###
addi $sp, $sp, -0

### PRINT ###
### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, 4
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

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
addi $sp, $sp, 0

### auto return of func func ###
addi $sp, $sp, -4
li $t0, -1000
sw $t0, 0($sp)
### end of auto return of func func ###

jr $ra

GLOBAL_main_label2:
### pushing space to stack for declared vars ###
addi $sp, $sp, -4

### LOCAL ID ADRS OF a ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF a ###

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

#### func call func ####
### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

addi $sp, $sp, -4
sw $fp, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $fp, $sp, 4
jal GLOBAL_func_label1
lw $fp, 8($sp)
lw $ra, 4($sp)
lw $t0, 0($sp)
sw $t0, 12($sp)
addi $sp, $sp, 12
#### end of func call func ####

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### poping declared vars from stack ###
addi $sp, $sp, 4

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
