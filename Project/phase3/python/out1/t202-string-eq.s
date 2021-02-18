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
addi $sp, $sp, -8

### LOCAL ID ADRS OF a ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF a ###


### CONSTANT STRING salam ###
addi $sp, $sp, -4
la $t0, str_const_9
sw $t0, 0($sp)
### END OF CONSTANT STRING salam ###

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### LOCAL ID ADRS OF b ###
move $t0, $fp
addi $t0, $t0, -12
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF b ###


### CONSTANT STRING salama ###
addi $sp, $sp, -4
la $t0, str_const_10
sw $t0, 0($sp)
### END OF CONSTANT STRING salama ###

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

### LOCAL ID VALUE OF b ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF b ###

check_strings_label2:
lw $t0, 4($sp)
lw $t1, 0($sp)
start_loop_label3:
lb $t2, 0($t0)
lb $t3, 0($t1)
beq $t2, $t3, eq_label4
j failed_label5
eq_label4:
beqz $t2, done_label6
add $t0, $t0, 1
add $t1, $t1, 1
j start_loop_label3
done_label6:
add $sp,$sp,4
li $t5, 0
sw $t5, 0($sp)
j finished_label7
failed_label5:
add $sp,$sp,4
li $t5, 1
sw $t5, 0($sp)
finished_label7:
lw $t0, 0($sp)
beq $t0, $zero, print_false_label8
la $a0, str_const_7
li $v0, 4
syscall
j print_end_label9
print_false_label8:
la $a0, str_const_8
li $v0, 4
syscall
print_end_label9:
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### popping declared vars from stack ###
addi $sp, $sp, 8

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
str_const_9:  .asciiz "salam"
str_const_10:  .asciiz "salama"
