.text
.globl main

main:
move $fp, $sp
move $s0, $ra
addi $sp, $sp, -4
sw $ra, 0($sp)
jal GLOBAL_main_label2
addi $sp, $sp, 4
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

GLOBAL_fib_label1:
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### LOCAL ID VALUE OF n ###
move $t0, $fp
addi $t0, $t0, 4
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF n ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

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
beq $t0, $zero, cond_false_label3
### RETURN ###
### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

lw $t0, 0($sp)
addi $sp, $fp, -8
sw $t0, 0($sp)
jr $ra
### END OF RETURN ###

j end_label_label4
cond_false_label3:
end_label_label4:
#### END OF IF ####
### LOCAL ID VALUE OF n ###
move $t0, $fp
addi $t0, $t0, 4
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF n ###

### CONSTANT INT 2 ###
addi $sp, $sp, -4
li $t0, 2
sw $t0, 0($sp)
### END OF CONSTANT INT 2 ###

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
beq $t0, $zero, cond_false_label5
### RETURN ###
### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

lw $t0, 0($sp)
addi $sp, $fp, -8
sw $t0, 0($sp)
jr $ra
### END OF RETURN ###

j end_label_label6
cond_false_label5:
end_label_label6:
#### END OF IF ####
### RETURN ###
#### func call fib ####
### LOCAL ID VALUE OF n ###
move $t0, $fp
addi $t0, $t0, 4
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF n ###

### CONSTANT INT 1 ###
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
### END OF CONSTANT INT 1 ###

## - ##
lw $t0, 4($sp)
lw $t1, 0($sp)
sub $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF - ##

addi $sp, $sp, -4
sw $fp, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $fp, $sp, 4
jal GLOBAL_fib_label1
lw $fp, 8($sp)
lw $ra, 4($sp)
lw $t0, 0($sp)
sw $t0, 12($sp)
addi $sp, $sp, 12
#### end of func call fib ####

#### func call fib ####
### LOCAL ID VALUE OF n ###
move $t0, $fp
addi $t0, $t0, 4
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF n ###

### CONSTANT INT 2 ###
addi $sp, $sp, -4
li $t0, 2
sw $t0, 0($sp)
### END OF CONSTANT INT 2 ###

## - ##
lw $t0, 4($sp)
lw $t1, 0($sp)
sub $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF - ##

addi $sp, $sp, -4
sw $fp, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $fp, $sp, 4
jal GLOBAL_fib_label1
lw $fp, 8($sp)
lw $ra, 4($sp)
lw $t0, 0($sp)
sw $t0, 12($sp)
addi $sp, $sp, 12
#### end of func call fib ####

## + ##
lw $t0, 4($sp)
lw $t1, 0($sp)
add $t0, $t0, $t1
addi $sp, $sp, 4
sw $t0, 0($sp)
## END OF + ##

lw $t0, 0($sp)
addi $sp, $fp, -8
sw $t0, 0($sp)
jr $ra
### END OF RETURN ###

### poping declared vars from stack ###
addi $sp, $sp, 0

### auto return of func fib ###
addi $sp, $sp, -4
li $t0, -1000
sw $t0, 0($sp)
### end of auto return of func fib ###

jr $ra

GLOBAL_main_label2:
### pushing space to stack for declared vars ###
addi $sp, $sp, -8

### LOCAL ID ADRS OF n ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF n ###

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

### LOCAL ID ADRS OF ans ###
move $t0, $fp
addi $t0, $t0, -12
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF ans ###

#### func call fib ####
### LOCAL ID VALUE OF n ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF n ###

addi $sp, $sp, -4
sw $fp, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $fp, $sp, 4
jal GLOBAL_fib_label1
lw $fp, 8($sp)
lw $ra, 4($sp)
lw $t0, 0($sp)
sw $t0, 12($sp)
addi $sp, $sp, 12
#### end of func call fib ####

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
### LOCAL ID VALUE OF ans ###
move $t0, $fp
addi $t0, $t0, -12
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF ans ###

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
