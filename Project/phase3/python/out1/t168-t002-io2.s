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
addi $sp, $sp, -12

### LOCAL ID ADRS OF b ###
move $t0, $fp
addi $t0, $t0, -12
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF b ###

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

#### FOR ####
### LOCAL ID ADRS OF i ###
move $t0, $fp
addi $t0, $t0, -16
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF i ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

### ASSIGN ###
lw $t0, 4($sp)
lw $t1, 0($sp)
sw $t1, 0($t0)
sw $t1, 4($sp)
addi $sp, $sp, 4
### END OF ASSIGN ###

addi $sp, $sp, 4
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

### PRINT ###

### CONSTANT STRING Please enter the # ###
addi $sp, $sp, -4
la $t0, str_const_9
sw $t0, 0($sp)
### END OF CONSTANT STRING Please enter the # ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -16
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4

### CONSTANT STRING  number: ###
addi $sp, $sp, -4
la $t0, str_const_10
sw $t0, 0($sp)
### END OF CONSTANT STRING  number: ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
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

li $v0, 5
syscall
addi $sp, $sp, -4
sw $v0, 0($sp)
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
beq $t0, $zero, cond_false_label4
### BREAK ###
j end_label3
### END OF BREAK ###

j end_label_label5
cond_false_label4:
end_label_label5:
#### END OF IF ####
### LOCAL ID ADRS OF b ###
move $t0, $fp
addi $t0, $t0, -12
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF b ###

### LOCAL ID VALUE OF b ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF b ###

### LOCAL ID VALUE OF a ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF a ###

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

### CLOSING ASSIGN ON NEXT LINE ###
addi $sp, $sp, 4

### poping declared vars from stack ###
addi $sp, $sp, 0

### LOCAL ID ADRS OF i ###
move $t0, $fp
addi $t0, $t0, -16
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF i ###

### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -16
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
j start_label2
end_label3:
#### END OF FOR ####

### PRINT ###

### CONSTANT STRING Sum of  ###
addi $sp, $sp, -4
la $t0, str_const_11
sw $t0, 0($sp)
### END OF CONSTANT STRING Sum of  ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
### LOCAL ID VALUE OF i ###
move $t0, $fp
addi $t0, $t0, -16
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF i ###

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
syscall
addi $sp, $sp, 4

### CONSTANT STRING  items is:  ###
addi $sp, $sp, -4
la $t0, str_const_12
sw $t0, 0($sp)
### END OF CONSTANT STRING  items is:  ###

lw $t0, 0($sp)
li $v0, 4
move $a0, $t0
syscall
addi $sp, $sp, 4
### LOCAL ID VALUE OF b ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF b ###

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
addi $sp, $sp, 12

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
str_const_9:  .asciiz "Please enter the #"
str_const_10:  .asciiz " number:"
str_const_11:  .asciiz "Sum of "
str_const_12:  .asciiz " items is: "
