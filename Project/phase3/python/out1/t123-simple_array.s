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

### CONSTANT INT 5 ###
addi $sp, $sp, -4
li $t0, 5
sw $t0, 0($sp)
### END OF CONSTANT INT 5 ###

lw $t0, 0($sp)
bgt $t0, 0, arr_size_ok_label2
la $a0, str_const_4
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

### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

### CONSTANT INT 0 ###
addi $sp, $sp, -4
li $t0, 0
sw $t0, 0($sp)
### END OF CONSTANT INT 0 ###

### LOCAL ARR ADRS ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label3
bge $t2, $t1, index_more_size_label4
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label5
index_less_zero_label3:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label4:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label5:
### END OF LOCAL ARR ADRS ###
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

### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

### LOCAL ARR ADRS ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label6
bge $t2, $t1, index_more_size_label7
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label8
index_less_zero_label6:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label7:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label8:
### END OF LOCAL ARR ADRS ###
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

### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

### CONSTANT INT 2 ###
addi $sp, $sp, -4
li $t0, 2
sw $t0, 0($sp)
### END OF CONSTANT INT 2 ###

### LOCAL ARR ADRS ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label9
bge $t2, $t1, index_more_size_label10
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label11
index_less_zero_label9:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label10:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label11:
### END OF LOCAL ARR ADRS ###
### CONSTANT INT 30 ###
addi $sp, $sp, -4
li $t0, 30
sw $t0, 0($sp)
### END OF CONSTANT INT 30 ###

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

### LOCAL ARR ADRS ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label12
bge $t2, $t1, index_more_size_label13
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label14
index_less_zero_label12:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label13:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label14:
### END OF LOCAL ARR ADRS ###
### CONSTANT INT 40 ###
addi $sp, $sp, -4
li $t0, 40
sw $t0, 0($sp)
### END OF CONSTANT INT 40 ###

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

### CONSTANT INT 4 ###
addi $sp, $sp, -4
li $t0, 4
sw $t0, 0($sp)
### END OF CONSTANT INT 4 ###

### LOCAL ARR ADRS ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label15
bge $t2, $t1, index_more_size_label16
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label17
index_less_zero_label15:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label16:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label17:
### END OF LOCAL ARR ADRS ###
### CONSTANT INT 50 ###
addi $sp, $sp, -4
li $t0, 50
sw $t0, 0($sp)
### END OF CONSTANT INT 50 ###

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

### CONSTANT INT 0 ###
addi $sp, $sp, -4
li $t0, 0
sw $t0, 0($sp)
### END OF CONSTANT INT 0 ###

### LOCAL ARR VALUE OF ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label18
bge $t2, $t1, index_more_size_label19
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
lw $t0, 0($t0)
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label20
index_less_zero_label18:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label19:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label20:
### END OF LOCAL ARR VALUE ###
lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

### CONSTANT INT 2 ###
addi $sp, $sp, -4
li $t0, 2
sw $t0, 0($sp)
### END OF CONSTANT INT 2 ###

### LOCAL ARR VALUE OF ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label21
bge $t2, $t1, index_more_size_label22
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
lw $t0, 0($t0)
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label23
index_less_zero_label21:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label22:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label23:
### END OF LOCAL ARR VALUE ###
lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

### CONSTANT INT 4 ###
addi $sp, $sp, -4
li $t0, 4
sw $t0, 0($sp)
### END OF CONSTANT INT 4 ###

### LOCAL ARR VALUE OF ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label24
bge $t2, $t1, index_more_size_label25
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
lw $t0, 0($t0)
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label26
index_less_zero_label24:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label25:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label26:
### END OF LOCAL ARR VALUE ###
lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
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
