.text
.globl main

main:

#### CREATING VTABLE OF CLASS Class ####
la $t0, SPACE_Class_main_vtable_0
move $a0, $t0
li $v0, 1
syscall
li $t1, 0
sw $t1, 0($t0)
la $t1, Class_func_label1
sw $t1, 4($t0)
#### END OF CREATING VTABLE OF CLASS Class ####

move $fp, $sp
move $s0, $ra
addi $sp, $sp, -4
sw $ra, 0($sp)
jal GLOBAL_main_label2
addi $sp, $sp, 4
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

#### FUNCTION DECL Class_func ####
Class_func_label1:
### pushing space to stack for declared vars ###
addi $sp, $sp, 0

### RETURN ###
### CONSTANT INT 8 ###
addi $sp, $sp, -4
li $t0, 8
sw $t0, 0($sp)
### END OF CONSTANT INT 8 ###

lw $t0, 0($sp)
addi $sp, $fp, -8
sw $t0, 0($sp)
jr $ra
### END OF RETURN ###

### popping declared vars from stack ###
addi $sp, $sp, 0

### auto return of func func ###
addi $sp, $sp, -4
li $t0, -1000
sw $t0, 0($sp)
### end of auto return of func func ###

jr $ra

#### END OF FUNCTION DECL Class_func ####

#### FUNCTION DECL GLOBAL_main ####
GLOBAL_main_label2:
### pushing space to stack for declared vars ###
addi $sp, $sp, -4

### LOCAL ID ADRS OF c ###
move $t0, $fp
addi $t0, $t0, -8
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID ADRS OF c ###

### ALLOC NEW ID Class ###
li $a0, 4
li $v0, 9
syscall
move $t0, $v0
la $t1, SPACE_Class_main_vtable_0
move $a0, $t1
li $v0, 1
syscall
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

### PRINT ###
### LOCAL ID VALUE OF c ###
move $t0, $fp
addi $t0, $t0, -8
lw $t0, 0($t0)
addi $sp, $sp, -4
sw $t0, 0($sp)
### END OF LOCAL ID VALUE OF c ###

#### OBJ FUNC CALL ####
lw $t0, 0($sp)
move $a0, $t0
li $v0, 1
syscall
move $t1, $t0
addi $t1, $t1, 0
lw $t1, 0($t1)
lw $t2, 0($t1)
add $t0, $t0, $t2
addi $sp, $sp, -4
sw $t0, 0($sp)
addi $t1, $t1, 4
lw $t1, 0($t1)
addi $sp, $sp, -4
sw $fp, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
la $ra, return_label3
addi $fp, $sp, 4
jr $t1
return_label3:
lw $fp, 8($sp)
lw $ra, 4($sp)
lw $t0, 0($sp)
sw $t0, 12($sp)
addi $sp, $sp, 12
#### END OF OBJ FUNC CALL ####

lw $t0, 0($sp)
li $v0, 1
move $a0, $t0
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

#### END OF FUNCTION DECL GLOBAL_main ####


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
SPACE_Class_main_vtable_0: .space 8
