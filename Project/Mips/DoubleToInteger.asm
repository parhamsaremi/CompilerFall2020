DoubleToInteger:        l.s $f0 , 4($sp)
                        cvt.w.s $f1, $f0
                        mfc1 $v0 , $f1
                        mtc1 $v0 , $f1
                        cvt.s.w $f1 , $f1
                        sub.s $f0 , $f0 , $f1
                        li.s $f1 , 0.0
                        c.lt.s $f0 , $f1
                        bc1t flag1
                        li.s $f1 , 0.5
                        c.lt.s $f0 , $f1
                        bc1t exit
                        addi $v0 , $v0 , 1
                        j exit
                        flag1:  li.s $f1 , -0.5
                        c.lt.s $f0 , $f1
                        bc1f exit
                        subi $v0 , $v0 , 1
                        exit: jr $ra