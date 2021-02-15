IntegerToByte:      lw $v0 , 4($sp)
                    beqz $v0 , exit
                    li $v0 , 0
                    addi $v0, $v0, 1
                    exit: jr $ra