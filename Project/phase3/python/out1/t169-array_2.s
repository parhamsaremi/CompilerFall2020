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

### LOCAL ID ADRS OF a ###
move $t0, $fp
addi $t0, $t0, -20
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF a ###

### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

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

#### FOR ####
### LOCAL ID ADRS OF i ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF i ###

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

addi $sp, $sp, 4
start_label3:
### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

### < ###
lw $t0, 4($sp)
lw $t1, 0($sp)
slt $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
### END OF < ###

lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, end_label4
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -20
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

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
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label6:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label7:
### END OF LOCAL ARR ADRS ###
### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

## + ##
lw $t0, 4($sp)
lw $t1, 0($sp)
add $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF + ##

lw $t0, 0($sp)
bgt $t0, 0, arr_size_ok_label8
la $a0, str_const_4
li $v0, 4
syscall
move $ra, $s0
jr $ra
arr_size_ok_label8:
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

### poping declared vars from stack ###
addi $sp, $sp, 0

### LOCAL ID ADRS OF i ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF i ###

### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

## + ##
lw $t0, 4($sp)
lw $t1, 0($sp)
add $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF + ##

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

addi $sp, $sp, 4
j start_label3
end_label4:
#### END OF FOR ####

#### FOR ####
### LOCAL ID ADRS OF i ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF i ###

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

addi $sp, $sp, 4
start_label9:
### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

### < ###
lw $t0, 4($sp)
lw $t1, 0($sp)
slt $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
### END OF < ###

lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, end_label10
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

#### FOR ####
### LOCAL ID ADRS OF j ###
move $t0, $fp
addi $t0, $t0, -12
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF j ###

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

addi $sp, $sp, 4
start_label11:
### LOCAL ID VALUE OF j ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF j ###

### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

### <= ###
lw $t0, 4($sp)
lw $t1, 0($sp)
slt $t0, $t1, $t0
addi $t1, $zero, 1
sub $t0, $t1, $t0
addi $sp, $sp, 4
sw $t0, 0($sp)
### END OF <= ###

lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, end_label12
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -20
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

### LOCAL ARR VALUE OF ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label13
bge $t2, $t1, index_more_size_label14
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
lw $t0, 0($t0)
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label15
index_less_zero_label13:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label14:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label15:
### END OF LOCAL ARR VALUE ###
### LOCAL ID VALUE OF j ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF j ###

### LOCAL ARR ADRS ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label16
bge $t2, $t1, index_more_size_label17
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label18
index_less_zero_label16:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label17:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label18:
### END OF LOCAL ARR ADRS ###
### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

lw $t0, 0($sp)
bgt $t0, 0, arr_size_ok_label19
la $a0, str_const_4
li $v0, 4
syscall
move $ra, $s0
jr $ra
arr_size_ok_label19:
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

#### FOR ####
### LOCAL ID ADRS OF k ###
move $t0, $fp
addi $t0, $t0, -16
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF k ###

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

addi $sp, $sp, 4
start_label20:
### LOCAL ID VALUE OF k ###
move $t0, $fp
addi $t0, $t0, -16
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF k ###

### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

### < ###
lw $t0, 4($sp)
lw $t1, 0($sp)
slt $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
### END OF < ###

lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, end_label21
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -20
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

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
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label23:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label24:
### END OF LOCAL ARR VALUE ###
### LOCAL ID VALUE OF j ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF j ###

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
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label26:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label27:
### END OF LOCAL ARR VALUE ###
### LOCAL ID VALUE OF k ###
move $t0, $fp
addi $t0, $t0, -16
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF k ###

### LOCAL ARR ADRS ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label28
bge $t2, $t1, index_more_size_label29
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label30
index_less_zero_label28:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label29:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label30:
### END OF LOCAL ARR ADRS ###
### LOCAL ID VALUE OF k ###
move $t0, $fp
addi $t0, $t0, -16
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF k ###

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### poping declared vars from stack ###
addi $sp, $sp, 0

### LOCAL ID ADRS OF k ###
move $t0, $fp
addi $t0, $t0, -16
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF k ###

### LOCAL ID VALUE OF k ###
move $t0, $fp
addi $t0, $t0, -16
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF k ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

## + ##
lw $t0, 4($sp)
lw $t1, 0($sp)
add $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF + ##

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

addi $sp, $sp, 4
j start_label20
end_label21:
#### END OF FOR ####

### poping declared vars from stack ###
addi $sp, $sp, 0

### LOCAL ID ADRS OF j ###
move $t0, $fp
addi $t0, $t0, -12
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF j ###

### LOCAL ID VALUE OF j ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF j ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

## + ##
lw $t0, 4($sp)
lw $t1, 0($sp)
add $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF + ##

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

addi $sp, $sp, 4
j start_label11
end_label12:
#### END OF FOR ####

### poping declared vars from stack ###
addi $sp, $sp, 0

### LOCAL ID ADRS OF i ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF i ###

### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

## + ##
lw $t0, 4($sp)
lw $t1, 0($sp)
add $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF + ##

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

addi $sp, $sp, 4
j start_label9
end_label10:
#### END OF FOR ####

#### FOR ####
### LOCAL ID ADRS OF i ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF i ###

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

addi $sp, $sp, 4
start_label31:
### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

### < ###
lw $t0, 4($sp)
lw $t1, 0($sp)
slt $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
### END OF < ###

lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, end_label32
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### PRINT ###

### CONSTANT STRING i  ###
addi $sp, $sp, -4
la $t0, str_const_9
sw $t0, 0($sp)
### END OF CONSTANT STRING i  ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

#### FOR ####
### LOCAL ID ADRS OF j ###
move $t0, $fp
addi $t0, $t0, -12
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF j ###

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

addi $sp, $sp, 4
start_label33:
### LOCAL ID VALUE OF j ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF j ###

### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

### <= ###
lw $t0, 4($sp)
lw $t1, 0($sp)
slt $t0, $t1, $t0
addi $t1, $zero, 1
sub $t0, $t1, $t0
addi $sp, $sp, 4
sw $t0, 0($sp)
### END OF <= ###

lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, end_label34
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### PRINT ###

### CONSTANT STRING j  ###
addi $sp, $sp, -4
la $t0, str_const_10
sw $t0, 0($sp)
### END OF CONSTANT STRING j  ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
### LOCAL ID VALUE OF j ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF j ###

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

#### FOR ####
### LOCAL ID ADRS OF k ###
move $t0, $fp
addi $t0, $t0, -16
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF k ###

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

addi $sp, $sp, 4
start_label35:
### LOCAL ID VALUE OF k ###
move $t0, $fp
addi $t0, $t0, -16
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF k ###

### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

### < ###
lw $t0, 4($sp)
lw $t1, 0($sp)
slt $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
### END OF < ###

lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, end_label36
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### PRINT ###
### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -20
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

### LOCAL ARR VALUE OF ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label37
bge $t2, $t1, index_more_size_label38
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
lw $t0, 0($t0)
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label39
index_less_zero_label37:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label38:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label39:
### END OF LOCAL ARR VALUE ###
### LOCAL ID VALUE OF j ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF j ###

### LOCAL ARR VALUE OF ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label40
bge $t2, $t1, index_more_size_label41
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
lw $t0, 0($t0)
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label42
index_less_zero_label40:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label41:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label42:
### END OF LOCAL ARR VALUE ###
### LOCAL ID VALUE OF k ###
move $t0, $fp
addi $t0, $t0, -16
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF k ###

### LOCAL ARR VALUE OF ###
lw $t0, 4($sp)
lw $t1, 0($t0)
lw $t2, 0($sp)
blt $t2, $zero, index_less_zero_label43
bge $t2, $t1, index_more_size_label44
addi $t2, $t2, 1
sll $t2, $t2, 2
add $t0, $t0, $t2
lw $t0, 0($t0)
addi $sp, $sp, 4
sw $t0, 0($sp)
j no_runtime_error_label45
index_less_zero_label43:
la $a0, str_const_2
li $v0, 4
syscall
move $ra, $s0
jr $ra
index_more_size_label44:
la $a0, str_const_3
li $v0, 4
syscall
move $ra, $s0
jr $ra
no_runtime_error_label45:
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
addi $sp, $sp, 0

### LOCAL ID ADRS OF k ###
move $t0, $fp
addi $t0, $t0, -16
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF k ###

### LOCAL ID VALUE OF k ###
move $t0, $fp
addi $t0, $t0, -16
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF k ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

## + ##
lw $t0, 4($sp)
lw $t1, 0($sp)
add $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF + ##

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

addi $sp, $sp, 4
j start_label35
end_label36:
#### END OF FOR ####

### poping declared vars from stack ###
addi $sp, $sp, 0

### LOCAL ID ADRS OF j ###
move $t0, $fp
addi $t0, $t0, -12
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF j ###

### LOCAL ID VALUE OF j ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF j ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

## + ##
lw $t0, 4($sp)
lw $t1, 0($sp)
add $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF + ##

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

addi $sp, $sp, 4
j start_label33
end_label34:
#### END OF FOR ####

### poping declared vars from stack ###
addi $sp, $sp, 0

### LOCAL ID ADRS OF i ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF i ###

### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

## + ##
lw $t0, 4($sp)
lw $t1, 0($sp)
add $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF + ##

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

addi $sp, $sp, 4
j start_label31
end_label32:
#### END OF FOR ####

### poping declared vars from stack ###
addi $sp, $sp, 16

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
str_const_9:  .asciiz "i "
str_const_10:  .asciiz "j "
