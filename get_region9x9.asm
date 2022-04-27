

main:
    # get manual input
    # li $v0, 5
    # syscall
    # move $s0, $v0 
    # li $v0, 5
    # syscall
    # move $s1, $v0

    li $s0, 0
test_row:
    li $s1, 0
test_column:
    
    # function proper
    move $a0, $s0
    move $a1, $s1
    jal get_region_9x9

    # print result
    move $a0, $v0
    li $v0, 1
    syscall

    addi $s1, $s1, 1
    ble $s1, 8, test_column

    li $a0, 10
    li $v0, 11
    syscall # call newline

    addi $s0, $s0, 1
    ble $s0, 8, test_row
    
    j exit
get_region_9x9:
    move $t0, $a0
    move $t1, $a1
    div $t0, $t0, 3   # t0 = t0 / 3
    and $t0, $t0, 3   # t0 = t0 % 4
    bne $t0, 3, next  # if (t0 == 3) 
    move $t0, $zero   # t0 = 0
next:
    mul $t0, $t0, 3   # t0 = t0 * 3
    div $t1, $t1, 3   # t1 = t1 / 3
    add $v0, $t0, $t1 # v0 = t0 + t1
    jr $ra            # exit
 
exit:
    li $v0, 10
    syscall