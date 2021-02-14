.data
truemsg:.asciiz "false"
falsemsg:.asciiz "true"
str1: .space 500
str2: .space 500
.text
.globl main
main:
syscall
li $v0,8
la $a0,str1
addi $a1,$zero,500
syscall
li $v0,8
la $a0,str2
addi $a1,$zero,500
syscall

la $a0,str1
la $a1,str2
jal compare

beq $v0,$zero,match
li $v0,4
la $a0,truemsg
syscall
j exit
match:
li $v0,4
la $a0,falsemsg
syscall
exit:
li $v0,10
syscall

compare:
add $t0,$zero,$zero
add $t1,$zero,$a0
add $t2,$zero,$a1

loop:
lb $t3($t1) 
lb $t4($t2)
beqz $t3,checkt2
beqz $t4,missmatch
slt $t5,$t3,$t4
bnez $t5,missmatch
addi $t1,$t1,1
addi $t2,$t2,1
j loop

missmatch:
addi $v0,$zero,1
j exit
checkt2:
bnez $t4,missmatch
add $v0,$zero,$zero

exit:
jr $ra