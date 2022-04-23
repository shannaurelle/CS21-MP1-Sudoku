create_sets:
    # a0 is the number of rows
    # a1 is the number of columns
    move $s0, $a0
    move $s1, $a1
    move $t0, $zero
row_loop:
    move $t1, $zero
col_loop:
    move $a0, $t0
    move $a1, $t1
    jal get_cell
    move $a2, $v0
    jal insert_set 
    addu $t1, $t1, 1
    blt $t1, $s1, col_loop
    addu $t0, $t0, 1
    blt $t0, $s0, row_loop

    jr $ra
