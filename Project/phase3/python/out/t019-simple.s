.text
.globl main

main:
addi $sp, $sp -4
sw $ra, 0($sp)
jal GLOBAL_main_label1
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

GLOBAL_main_label1:
addi $sp, $sp, -4
li $t0, 2
sw $t0, 0($sp)
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
jr $ra

.data
str_const_0:  .asciiz "Runtime Error"
str_const_1:  .asciiz "\n"
str_const_2:  .asciiz " "
