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

### CONSTANT STRING Winky Inky Binky Slinky Dinky\n ###
addi $sp, $sp, -4
la $t0, str_const_5
sw $t0, 0($sp)
### END OF CONSTANT STRING Winky Inky Binky Slinky Dinky\n ###

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
str_const_5:  .asciiz "Winky Inky Binky Slinky Dinky\n"
