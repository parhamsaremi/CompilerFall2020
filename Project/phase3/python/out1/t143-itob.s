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

### PRINT ###
### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

addi $sp, $sp, -4
sw $ra, 0($sp)
jal itob
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, 0($sp)
beq $t0, $zero, print_false_label2
la $a0, str_const_7
li $v0, 4
syscall
j print_end_label3
print_false_label2:
la $a0, str_const_8
li $v0, 4
syscall
print_end_label3:
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### LOCAL ID ADRS OF a ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF a ###

### CONSTANT INT 0 ###
addi $sp, $sp, -4
li $t0, 0
sw $t0, 0($sp)
### END OF CONSTANT INT 0 ###

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
### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

addi $sp, $sp, -4
sw $ra, 0($sp)
jal itob
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, 0($sp)
beq $t0, $zero, print_false_label4
la $a0, str_const_7
li $v0, 4
syscall
j print_end_label5
print_false_label4:
la $a0, str_const_8
li $v0, 4
syscall
print_end_label5:
addi $sp, $sp, 4
la $a0, str_const_5
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
