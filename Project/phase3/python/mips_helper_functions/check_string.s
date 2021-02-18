check_strings:

lw $t0, 4($sp)
lw $t1, 0($sp)

start_loop_check_string:

lw $t2, 0($t0)
lw $t3, 0($t1)

beq $t2, $t3, eq_check_string
j failed_check_string

eq_check_string:

beqz $t2, done_check_string
addi $t0, $t0, 4
addi $t1, $t1, 4
j start_loop_check_string

done_check_string:
addi $sp,$sp,4
li $t5, 1
sw $t5, 0($sp)
j finished_check_string

failed_check_string:
addi $sp,$sp,4
li $t5, 0
sw $t5, 0($sp)

finished_check_string:

