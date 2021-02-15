IntegerToDouble:    lw $a1 , 4($sp)
                    mtc1 $a1, $f12
                    cvt.s.w $f12, $f12
                    mov.s $f0 , $f12
                    jr $ra
