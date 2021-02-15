ReadLine:               li $t0 , $zero
                        li $t1 , 10
loopReadLine:           li $v0 , 12
                        syscall
                        addi $t0 , $t0 , 1
                        subi $sp , $sp , 1
                        beq $v0 , $t1 , endLoopReadLine
                        sb $v0 , 1($sp)
                        j loopReadLine
endLoopReadLine:        sb $zero , 1($sp)
                        li $v0 , 9
                        addi $a0 , $t0 , 0
                        syscall
                        move $t1 , $v0
                        subi $t0 , $t0 , 1
loopMoveString:         add $t2 , $t1 , $t0
                        lb $t3 , 1($sp)
                        sb $t3 , 0($t2)
                        beq $t0 , $zero , endLoopMoveString
                        addi $sp , $sp , 1
                        subi $t0 , $t0 , 1
                        j loopMoveString
endLoopMoveString:      addi $sp , $sp , 1
                        jr $ra