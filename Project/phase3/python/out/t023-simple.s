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

### LOCAL ID ADRS OF i ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF i ###

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

### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

### CONSTANT INT 5 ###
addi $sp, $sp, -4
li $t0, 5
sw $t0, 0($sp)
### END OF CONSTANT INT 5 ###

### < ###
lw $t0, 4($sp)
lw $t1, 0($sp)
slt $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
### END OF < ###

#### IF ####
lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, cond_false_label2
### pushing space to stack for declared vars ###
addi $sp, $sp, -0

### PRINT ###

### CONSTANT STRING not run ###
addi $sp, $sp, -4
la $t0, str_const_3
sw $t0, 0($sp)
### END OF CONSTANT STRING not run ###

lw $t0, 0($sp)
li $v0, 4
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

j end_label_label3
cond_false_label2:
### pushing space to stack for declared vars ###
addi $sp, $sp, -0

### PRINT ###

### CONSTANT STRING correct ###
addi $sp, $sp, -4
la $t0, str_const_4
sw $t0, 0($sp)
### END OF CONSTANT STRING correct ###

lw $t0, 0($sp)
li $v0, 4
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

end_label_label3:
#### END OF IF ####
### poping declared vars from stack ###
addi $sp, $sp, 4

jr $ra

.data
str_const_0:  .asciiz "Runtime Error"
str_const_1:  .asciiz "\n"
str_const_2:  .asciiz " "
str_const_3:  .asciiz "not run"
str_const_4:  .asciiz "correct"
