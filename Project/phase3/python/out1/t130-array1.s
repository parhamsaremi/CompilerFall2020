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
addi $sp, $sp, -16

### LOCAL ID ADRS OF b ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF b ###

### CONSTANT INT 10 ###
addi $sp, $sp, -4
li $t0, 10
sw $t0, 0($sp)
### END OF CONSTANT INT 10 ###

lw $t0, 0($sp)
bgt $t0, 0, arr_size_ok_label2
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
arr_size_ok_label2:
move $t1, $t0
sll $t0, $t0, 2
addi $t0, $t0, 4
move $a0, $t0
li $v0, 9
syscall
sw $v0, 0($sp)
sw $t1, 0($v0)
### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### LOCAL ID ADRS OF c ###
move $t0, $fp
addi $t0, $t0, -12
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF c ###

### CONSTANT INT 20 ###
addi $sp, $sp, -4
li $t0, 20
sw $t0, 0($sp)
### END OF CONSTANT INT 20 ###

lw $t0, 0($sp)
bgt $t0, 0, arr_size_ok_label3
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
arr_size_ok_label3:
move $t1, $t0
sll $t0, $t0, 2
addi $t0, $t0, 4
move $a0, $t0
li $v0, 9
syscall
sw $v0, 0($sp)
sw $t1, 0($v0)
### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### LOCAL ID ADRS OF s ###
move $t0, $fp
addi $t0, $t0, -20
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF s ###

### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

lw $t0, 0($sp)
bgt $t0, 0, arr_size_ok_label4
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
arr_size_ok_label4:
move $t1, $t0
sll $t0, $t0, 2
addi $t0, $t0, 4
move $a0, $t0
li $v0, 9
syscall
sw $v0, 0($sp)
sw $t1, 0($v0)
### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### LOCAL ID VALUE OF b ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF b ###

### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

### LOCAL ARR ADRS ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label5
bge $t2, $t1, index_more_size_label6
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label7
index_less_zero_label5:
la $a0, str_const_1
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label6:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label7:
### END OF LOCAL ARR ADRS ###
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

### LOCAL ID VALUE OF c ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF c ###

### CONSTANT INT 6 ###
addi $sp, $sp, -4
li $t0, 6
sw $t0, 0($sp)
### END OF CONSTANT INT 6 ###

### LOCAL ARR ADRS ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label8
bge $t2, $t1, index_more_size_label9
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label10
index_less_zero_label8:
la $a0, str_const_1
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label9:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label10:
### END OF LOCAL ARR ADRS ###

### CONSTANT BOOL false ###
addi $sp, $sp, -4
move $t0, $zero
sw $t0, 0($sp)
### END OF CONSTANT BOOL false ###

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### LOCAL ID ADRS OF d ###
move $t0, $fp
addi $t0, $t0, -16
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF d ###

### LOCAL ID VALUE OF b ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF b ###

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### LOCAL ID VALUE OF s ###
move $t0, $fp
addi $t0, $t0, -20
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF s ###

### CONSTANT INT 2 ###
addi $sp, $sp, -4
li $t0, 2
sw $t0, 0($sp)
### END OF CONSTANT INT 2 ###

### LOCAL ARR ADRS ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label11
bge $t2, $t1, index_more_size_label12
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label13
index_less_zero_label11:
la $a0, str_const_1
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label12:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label13:
### END OF LOCAL ARR ADRS ###

### CONSTANT STRING sara ###
addi $sp, $sp, -4
la $t0, str_const_8
sw $t0, 0($sp)
### END OF CONSTANT STRING sara ###

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
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF b ###

### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

### LOCAL ARR VALUE OF ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label14
bge $t2, $t1, index_more_size_label15
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
lw $t0, 0($t0)
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label16
index_less_zero_label14:
la $a0, str_const_1
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label15:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label16:
### END OF LOCAL ARR VALUE ###
lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
### LOCAL ID VALUE OF b ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF b ###

lw $t0, 0($sp)
lw $t0, 0($t0)
sw $t0, 0($sp)
lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4

### CONSTANT STRING \n ###
addi $sp, $sp, -4
la $t0, str_const_9
sw $t0, 0($sp)
### END OF CONSTANT STRING \n ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_4
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### LOCAL ID VALUE OF c ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF c ###

### CONSTANT INT 6 ###
addi $sp, $sp, -4
li $t0, 6
sw $t0, 0($sp)
### END OF CONSTANT INT 6 ###

### LOCAL ARR VALUE OF ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label17
bge $t2, $t1, index_more_size_label18
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
lw $t0, 0($t0)
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label19
index_less_zero_label17:
la $a0, str_const_1
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label18:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label19:
### END OF LOCAL ARR VALUE ###
lw $t0, 0($sp)
beq $t0, $zero, print_false_label20
la $a0, str_const_6
li $v0, 4
syscall
j print_end_label21
print_false_label20:
la $a0, str_const_7
li $v0, 4
syscall
print_end_label21:
addi $sp, $sp, 4
### LOCAL ID VALUE OF c ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF c ###

lw $t0, 0($sp)
lw $t0, 0($t0)
sw $t0, 0($sp)
lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4

### CONSTANT STRING \n ###
addi $sp, $sp, -4
la $t0, str_const_10
sw $t0, 0($sp)
### END OF CONSTANT STRING \n ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_4
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### LOCAL ID VALUE OF d ###
move $t0, $fp
addi $t0, $t0, -16
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF d ###

### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

### LOCAL ARR VALUE OF ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label22
bge $t2, $t1, index_more_size_label23
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
lw $t0, 0($t0)
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label24
index_less_zero_label22:
la $a0, str_const_1
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label23:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label24:
### END OF LOCAL ARR VALUE ###
lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
### LOCAL ID VALUE OF d ###
move $t0, $fp
addi $t0, $t0, -16
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF d ###

lw $t0, 0($sp)
lw $t0, 0($t0)
sw $t0, 0($sp)
lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4

### CONSTANT STRING \n ###
addi $sp, $sp, -4
la $t0, str_const_11
sw $t0, 0($sp)
### END OF CONSTANT STRING \n ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_4
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### LOCAL ID VALUE OF s ###
move $t0, $fp
addi $t0, $t0, -20
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF s ###

### CONSTANT INT 2 ###
addi $sp, $sp, -4
li $t0, 2
sw $t0, 0($sp)
### END OF CONSTANT INT 2 ###

### LOCAL ARR VALUE OF ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label25
bge $t2, $t1, index_more_size_label26
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
lw $t0, 0($t0)
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label27
index_less_zero_label25:
la $a0, str_const_1
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label26:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label27:
### END OF LOCAL ARR VALUE ###
lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
### LOCAL ID VALUE OF s ###
move $t0, $fp
addi $t0, $t0, -20
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF s ###

lw $t0, 0($sp)
lw $t0, 0($t0)
sw $t0, 0($sp)
lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4

### CONSTANT STRING \n ###
addi $sp, $sp, -4
la $t0, str_const_12
sw $t0, 0($sp)
### END OF CONSTANT STRING \n ###

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
addi $sp, $sp, 16

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
str_const_8:  .asciiz "sara"
str_const_9:  .asciiz "\n"
str_const_10:  .asciiz "\n"
str_const_11:  .asciiz "\n"
str_const_12:  .asciiz "\n"
