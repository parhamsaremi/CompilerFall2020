readInteger:                      li $t1 , 0
                                  li $t2 , 0
                                  li $t3 , 10
                                  li $t4 , 120 # 'x'
                                  li $t5 , 88 # 'X'
                                  li $t6 , 43 # '+'
                                  li $t7 , 45 # '-'
                                  li $t8 , 1
start:                            li $v0 , 0
                                  lb $v0 , 0($a0)
                                  beq $v0 , $t6 , positive_sign
                                  beq $v0 , $t7 , negative_sign
                                  subi $v0 , $v0 , 47
                                  lb $t1 , 0($a0)
                                  beq $t1 , $t4 , read_line_hexadecimal
                                  beq $t1 , $t5 , read_line_hexadecimal
read_line_loop_decimal:           lb $t1 , 0($a0)
                                  beq $t1 , $zero , end
                                  subi $t1 , $t1 , 48
                                  mul $v0 , $v0 , $t3
                                  add $v0 , $v0 , $t1
                                  addi $a0 , $a0 , 1
                                  j read_line_loop_decimal
read_line_hexadecimal:            addi $a0 , $a0 , 1
loop:                             li $t1 , 0
                                  lb $t1 , 0($a0)
                                  beq $t1 , $zero , end
                                  bge $t1 , 65 , uppercase
                                  bge $t1 , 97 , lowercase
                                  subi $t1 , $t1 , 48
                                  j add
uppercase:                        subi $t1 , $t1 , 65
                                  addi $t1 , $t1 , 10
                                  j add
lowercase:                        subi $t1 , $t1 , 97
                                  addi $t1 , $t1 , 10
add:                              sll $v0 , $v0 , 4
                                  add $v0 , $v0 , $t1
                                  addi $a0 , $a0 , 1
                                  j loop
end:                              mul $v0 , $v0 , $t8
                                  jr $ra
positive_sign:                    addi $a0 , $a0 , 1
                                  j start
negative_sign:                    lw $t8 , $zero
                                  subi $t8,$t8,1
                                  addi $a0 , $a0 , 1
                                  j start