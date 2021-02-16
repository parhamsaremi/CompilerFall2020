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
addi $sp, $sp, 0

#### WHILE ####
start_label2:

### CONSTANT BOOL true ###
addi $sp, $sp, -4
addi $t0, $zero, 1
sw $t0, 0($sp)
### END OF CONSTANT BOOL true ###

lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, end_label3
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

li $v0, 5
syscall
addi $sp, $sp, -4
sw $v0, 0($sp)
### CONSTANT INT 5 ###
addi $sp, $sp, -4
li $t0, 5
sw $t0, 0($sp)
### END OF CONSTANT INT 5 ###

lw $t0, 4($sp)
lw $t1, 0($sp)
sub $t0, $t0, $t1
slt $t2, $t0, $zero
slt $t3, $zero, $t0
or $t2, $t2, $t3
addi $t3, $zero, 1
sub $t2, $t3, $t2
addi $sp, $sp, 4
sw $t2, 0($sp)
#### IF ####
lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, cond_false_label4
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### PRINT ###
### CONSTANT INT 2 ###
addi $sp, $sp, -4
li $t0, 2
sw $t0, 0($sp)
### END OF CONSTANT INT 2 ###

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### BREAK ###
j end_label3
### END OF BREAK ###

### poping declared vars from stack ###
addi $sp, $sp, 0

j end_label_label5
cond_false_label4:
end_label_label5:
#### END OF IF ####
### PRINT ###
### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

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

j start_label2
end_label3:
#### END OF WHILE ####

#### WHILE ####
start_label6:

### CONSTANT BOOL true ###
addi $sp, $sp, -4
addi $t0, $zero, 1
sw $t0, 0($sp)
### END OF CONSTANT BOOL true ###

lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, end_label7
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

#### WHILE ####
start_label8:

### CONSTANT BOOL true ###
addi $sp, $sp, -4
addi $t0, $zero, 1
sw $t0, 0($sp)
### END OF CONSTANT BOOL true ###

lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, end_label9
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

li $v0, 5
syscall
addi $sp, $sp, -4
sw $v0, 0($sp)
### CONSTANT INT 5 ###
addi $sp, $sp, -4
li $t0, 5
sw $t0, 0($sp)
### END OF CONSTANT INT 5 ###

lw $t0, 4($sp)
lw $t1, 0($sp)
sub $t0, $t0, $t1
slt $t2, $t0, $zero
slt $t3, $zero, $t0
or $t2, $t2, $t3
addi $t3, $zero, 1
sub $t2, $t3, $t2
addi $sp, $sp, 4
sw $t2, 0($sp)
#### IF ####
lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, cond_false_label10
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### PRINT ###
### CONSTANT INT 4 ###
addi $sp, $sp, -4
li $t0, 4
sw $t0, 0($sp)
### END OF CONSTANT INT 4 ###

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### BREAK ###
j end_label9
### END OF BREAK ###

### poping declared vars from stack ###
addi $sp, $sp, 0

j end_label_label11
cond_false_label10:
end_label_label11:
#### END OF IF ####
### PRINT ###
### CONSTANT INT 3 ###
addi $sp, $sp, -4
li $t0, 3
sw $t0, 0($sp)
### END OF CONSTANT INT 3 ###

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

j start_label8
end_label9:
#### END OF WHILE ####

#### WHILE ####
start_label12:

### CONSTANT BOOL true ###
addi $sp, $sp, -4
addi $t0, $zero, 1
sw $t0, 0($sp)
### END OF CONSTANT BOOL true ###

lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, end_label13
### pushing space to stack for declared vars ###
addi $sp, $sp, 0


### CONSTANT BOOL false ###
addi $sp, $sp, -4
move $t0, $zero
sw $t0, 0($sp)
### END OF CONSTANT BOOL false ###

#### IF ####
lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, cond_false_label14
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### poping declared vars from stack ###
addi $sp, $sp, 0

j end_label_label15
cond_false_label14:
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### BREAK ###
j end_label13
### END OF BREAK ###

### poping declared vars from stack ###
addi $sp, $sp, 0

end_label_label15:
#### END OF IF ####
### PRINT ###

### CONSTANT STRING bashe ###
addi $sp, $sp, -4
la $t0, str_const_9
sw $t0, 0($sp)
### END OF CONSTANT STRING bashe ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### poping declared vars from stack ###
addi $sp, $sp, 0

j start_label12
end_label13:
#### END OF WHILE ####

### BREAK ###
j end_label7
### END OF BREAK ###

### poping declared vars from stack ###
addi $sp, $sp, 0

j start_label6
end_label7:
#### END OF WHILE ####

### PRINT ###

### CONSTANT STRING bashe bashe ###
addi $sp, $sp, -4
la $t0, str_const_10
sw $t0, 0($sp)
### END OF CONSTANT STRING bashe bashe ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_5
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
str_const_9:  .asciiz "bashe"
str_const_10:  .asciiz "bashe bashe"
