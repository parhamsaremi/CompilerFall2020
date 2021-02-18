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

### LOCAL ID ADRS OF c ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF c ###

### ALLOC NEW ID Class ###
li $a0, 16
li $v0, 9
syscall
move $t0, $v0
la $t1, space_0
sw $t1, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF ALLOC NEW ID Class ###

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
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF c ###

### OBJ FIELD ADRS ###
lw $t0, 0($sp)
addi $t0, $t0, 4
sw $t0, 0($sp)
### OBJ FIELD ADRS ###
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

### LOCAL ID VALUE OF c ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF c ###

### OBJ FIELD ADRS ###
lw $t0, 0($sp)
addi $t0, $t0, 8
sw $t0, 0($sp)
### OBJ FIELD ADRS ###

### CONSTANT BOOL true ###
addi $sp, $sp, -4
addi $t0, $zero, 1
sw $t0, 0($sp)
### END OF CONSTANT BOOL true ###

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
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF c ###

### OBJ FIELD ADRS ###
lw $t0, 0($sp)
addi $t0, $t0, 12
sw $t0, 0($sp)
### OBJ FIELD ADRS ###
### CONSTANT FLOAT 1.2 ###
addi $sp, $sp, -4
li.s $f0, 1.2
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 1.2 ###

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
### LOCAL ID VALUE OF c ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF c ###

### OBJ FIELD VALUE ###
lw $t0, 0($sp)
addi $t0, $t0, 4
lw $t0, 0($t0)
sw $t0, 0($sp)
### OBJ FIELD VALUE ###
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
### LOCAL ID VALUE OF c ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF c ###

### OBJ FIELD VALUE ###
lw $t0, 0($sp)
addi $t0, $t0, 8
lw $t0, 0($t0)
sw $t0, 0($sp)
### OBJ FIELD VALUE ###
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

### PRINT ###
### LOCAL ID VALUE OF c ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF c ###

### OBJ FIELD VALUE ###
lw $t0, 0($sp)
addi $t0, $t0, 12
lw $t0, 0($t0)
sw $t0, 0($sp)
### OBJ FIELD VALUE ###
l.s $f12, 0($sp)
li $v0, 2
syscall
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### popping declared vars from stack ###
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
space_0: .space 4
