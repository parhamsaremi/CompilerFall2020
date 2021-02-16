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

### PRINT ###
### CONSTANT FLOAT 0.5 ###
addi $sp, $sp, -4
li.s $f0, 0.5
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.5 ###

## - ##
l.s $f0 , 0($sp)
neg.s $f0, $f0 
s.s $f0 , 0($sp)
## END OF - ##

### CONSTANT FLOAT 0.0 ###
addi $sp, $sp, -4
li.s $f0, 0.0
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.0 ###

l.s $f0, 4($sp)
l.s $f1, 0($sp)
addi $sp, $sp, 4
c.le.s $f1, $f0
bc1f false_label_label2
li $t0, 1
sw $t0, 0($sp)
j end_label_label3
false_label_label2:
li $t0, 0
sw $t0, 0($sp)
end_label_label3:
lw $t0, 0($sp)
beq $t0, $zero, print_false_label4
la $a0, str_const_7
li $v0, 4
syscall
j print_end_label5
print_false_label4:
la $a0, str_const_8
li $v0, 4
syscall
print_end_label5:
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### CONSTANT FLOAT 0.5 ###
addi $sp, $sp, -4
li.s $f0, 0.5
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.5 ###

## - ##
l.s $f0 , 0($sp)
neg.s $f0, $f0 
s.s $f0 , 0($sp)
## END OF - ##

### CONSTANT FLOAT 0.0 ###
addi $sp, $sp, -4
li.s $f0, 0.0
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.0 ###

l.s $f0, 4($sp)
l.s $f1, 0($sp)
addi $sp, $sp, 4
c.le.s $f0, $f1
bc1f false_label_label6
li $t0, 1
sw $t0, 0($sp)
j end_label_label7
false_label_label6:
li $t0, 0
sw $t0, 0($sp)
end_label_label7:
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

### PRINT ###
### CONSTANT FLOAT 0.5 ###
addi $sp, $sp, -4
li.s $f0, 0.5
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.5 ###

## - ##
l.s $f0 , 0($sp)
neg.s $f0, $f0 
s.s $f0 , 0($sp)
## END OF - ##

### CONSTANT FLOAT 0.0 ###
addi $sp, $sp, -4
li.s $f0, 0.0
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.0 ###

l.s $f0, 4($sp)
l.s $f1, 0($sp)
addi $sp, $sp, 4
c.lt.s $f1, $f0
bc1f false_label_label10
li $t0, 1
sw $t0, 0($sp)
j end_label_label11
false_label_label10:
li $t0, 0
sw $t0, 0($sp)
end_label_label11:
lw $t0, 0($sp)
beq $t0, $zero, print_false_label12
la $a0, str_const_7
li $v0, 4
syscall
j print_end_label13
print_false_label12:
la $a0, str_const_8
li $v0, 4
syscall
print_end_label13:
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### CONSTANT FLOAT 0.5 ###
addi $sp, $sp, -4
li.s $f0, 0.5
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.5 ###

## - ##
l.s $f0 , 0($sp)
neg.s $f0, $f0 
s.s $f0 , 0($sp)
## END OF - ##

### CONSTANT FLOAT 0.0 ###
addi $sp, $sp, -4
li.s $f0, 0.0
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.0 ###

l.s $f0, 4($sp)
l.s $f1, 0($sp)
addi $sp, $sp, 4
c.lt.s $f0, $f1
bc1f false_label_label14
li $t0, 1
sw $t0, 0($sp)
j end_label_label15
false_label_label14:
li $t0, 0
sw $t0, 0($sp)
end_label_label15:
lw $t0, 0($sp)
beq $t0, $zero, print_false_label16
la $a0, str_const_7
li $v0, 4
syscall
j print_end_label17
print_false_label16:
la $a0, str_const_8
li $v0, 4
syscall
print_end_label17:
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### CONSTANT FLOAT 0.5 ###
addi $sp, $sp, -4
li.s $f0, 0.5
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.5 ###

## - ##
l.s $f0 , 0($sp)
neg.s $f0, $f0 
s.s $f0 , 0($sp)
## END OF - ##

### CONSTANT FLOAT 0.9 ###
addi $sp, $sp, -4
li.s $f0, 0.9
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.9 ###

## - ##
l.s $f0 , 0($sp)
neg.s $f0, $f0 
s.s $f0 , 0($sp)
## END OF - ##

l.s $f0, 4($sp)
l.s $f1, 0($sp)
addi $sp, $sp, 4
c.le.s $f1, $f0
bc1f false_label_label18
li $t0, 1
sw $t0, 0($sp)
j end_label_label19
false_label_label18:
li $t0, 0
sw $t0, 0($sp)
end_label_label19:
lw $t0, 0($sp)
beq $t0, $zero, print_false_label20
la $a0, str_const_7
li $v0, 4
syscall
j print_end_label21
print_false_label20:
la $a0, str_const_8
li $v0, 4
syscall
print_end_label21:
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### CONSTANT FLOAT 0.5 ###
addi $sp, $sp, -4
li.s $f0, 0.5
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.5 ###

## - ##
l.s $f0 , 0($sp)
neg.s $f0, $f0 
s.s $f0 , 0($sp)
## END OF - ##

### CONSTANT FLOAT 0.9 ###
addi $sp, $sp, -4
li.s $f0, 0.9
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.9 ###

## - ##
l.s $f0 , 0($sp)
neg.s $f0, $f0 
s.s $f0 , 0($sp)
## END OF - ##

l.s $f0, 4($sp)
l.s $f1, 0($sp)
addi $sp, $sp, 4
c.le.s $f0, $f1
bc1f false_label_label22
li $t0, 1
sw $t0, 0($sp)
j end_label_label23
false_label_label22:
li $t0, 0
sw $t0, 0($sp)
end_label_label23:
lw $t0, 0($sp)
beq $t0, $zero, print_false_label24
la $a0, str_const_7
li $v0, 4
syscall
j print_end_label25
print_false_label24:
la $a0, str_const_8
li $v0, 4
syscall
print_end_label25:
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### CONSTANT FLOAT 0.5 ###
addi $sp, $sp, -4
li.s $f0, 0.5
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.5 ###

## - ##
l.s $f0 , 0($sp)
neg.s $f0, $f0 
s.s $f0 , 0($sp)
## END OF - ##

### CONSTANT FLOAT 0.9 ###
addi $sp, $sp, -4
li.s $f0, 0.9
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.9 ###

## - ##
l.s $f0 , 0($sp)
neg.s $f0, $f0 
s.s $f0 , 0($sp)
## END OF - ##

l.s $f0, 4($sp)
l.s $f1, 0($sp)
addi $sp, $sp, 4
c.lt.s $f1, $f0
bc1f false_label_label26
li $t0, 1
sw $t0, 0($sp)
j end_label_label27
false_label_label26:
li $t0, 0
sw $t0, 0($sp)
end_label_label27:
lw $t0, 0($sp)
beq $t0, $zero, print_false_label28
la $a0, str_const_7
li $v0, 4
syscall
j print_end_label29
print_false_label28:
la $a0, str_const_8
li $v0, 4
syscall
print_end_label29:
addi $sp, $sp, 4
la $a0, str_const_5
li $v0, 4
syscall
### END OF PRINT ###

### PRINT ###
### CONSTANT FLOAT 0.5 ###
addi $sp, $sp, -4
li.s $f0, 0.5
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.5 ###

## - ##
l.s $f0 , 0($sp)
neg.s $f0, $f0 
s.s $f0 , 0($sp)
## END OF - ##

### CONSTANT FLOAT 0.9 ###
addi $sp, $sp, -4
li.s $f0, 0.9
s.s $f0, 0($sp)
### END OF CONSTANT FLOAT 0.9 ###

## - ##
l.s $f0 , 0($sp)
neg.s $f0, $f0 
s.s $f0 , 0($sp)
## END OF - ##

l.s $f0, 4($sp)
l.s $f1, 0($sp)
addi $sp, $sp, 4
c.lt.s $f0, $f1
bc1f false_label_label30
li $t0, 1
sw $t0, 0($sp)
j end_label_label31
false_label_label30:
li $t0, 0
sw $t0, 0($sp)
end_label_label31:
lw $t0, 0($sp)
beq $t0, $zero, print_false_label32
la $a0, str_const_7
li $v0, 4
syscall
j print_end_label33
print_false_label32:
la $a0, str_const_8
li $v0, 4
syscall
print_end_label33:
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
