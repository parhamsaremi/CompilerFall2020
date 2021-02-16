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

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

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

### > ###
lw $t0, 4($sp)
lw $t1, 0($sp)
slt $t0, $t1, $t0
addi $sp, $sp, 4
sw $t0, 0($sp)
### END OF > ###

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

### < ###
lw $t0, 4($sp)
lw $t1, 0($sp)
slt $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
### END OF < ###

lw $t0, 0($sp)
lw $t1, 4($sp)
or $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

### CONSTANT INT 0 ###
addi $sp, $sp, -4
li $t0, 0
sw $t0, 0($sp)
### END OF CONSTANT INT 0 ###

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

### CONSTANT BOOL true ###
addi $sp, $sp, -4
addi $t0, $zero, 1
sw $t0, 0($sp)
### END OF CONSTANT BOOL true ###

lw $t0, 0($sp)
lw $t1, 4($sp)
and $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
lw $t0, 0($sp)
lw $t1, 4($sp)
or $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
#### IF ####
lw $t0, 0($sp)
addi $sp, $sp, 4
beq $t0, $zero, cond_false_label2
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### PRINT ###

### CONSTANT STRING yes ###
addi $sp, $sp, -4
la $t0, str_const_8
sw $t0, 0($sp)
### END OF CONSTANT STRING yes ###

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
addi $sp, $sp, 0

j end_label_label3
cond_false_label2:
### PRINT ###

### CONSTANT STRING no ###
addi $sp, $sp, -4
la $t0, str_const_9
sw $t0, 0($sp)
### END OF CONSTANT STRING no ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
la $a0, str_const_4
li $v0, 4
syscall
### END OF PRINT ###

end_label_label3:
#### END OF IF ####
### PRINT ###

### CONSTANT STRING no ###
addi $sp, $sp, -4
la $t0, str_const_10
sw $t0, 0($sp)
### END OF CONSTANT STRING no ###

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
str_const_0:  .asciiz "Runtime Error"
str_const_1:  .asciiz "array index is less than zero"
str_const_2:  .asciiz "array index is more than arr.size-1"
str_const_3:  .asciiz "array size can't be negative"
str_const_4:  .asciiz "\n"
str_const_5:  .asciiz " "
str_const_6:  .asciiz "true"
str_const_7:  .asciiz "false"
str_const_8:  .asciiz "yes"
str_const_9:  .asciiz "no"
str_const_10:  .asciiz "no"
