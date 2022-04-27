# a0, a1, a2, (row, column, value)
sudoku:
    ### PREAMBLE ###
    subiu $sp, $sp, 16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    ### PREAMBLE ###
    # base case
    bge $a1, 4, sudoku_end
    bge $a0, 4, sudoku_end
sudoku_recurse:
    jal get_cell
    move $a2, $v0
    jal check_cell
    
    bnez $v0, skip_cell    # if cell is not zero, skip cell
    # else : cell is zero
    li $a2, 1
sudoku_value_loop:
    sw $a2, 12($sp)

    jal check_set

    bnez $v0, next_value   # if value cant be placed, try another
    # cell can be placed here
    jal set_cell

    jal insert_to_set
    
    jal sudoku_check

    # addiu $a0, $a0, 1   # row = row + 1
    move $a0, $zero
    move $a1, $zero
    jal sudoku
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    # addiu $a1, $a1, 1   # col = col + 1
    # jal sudoku
    # lw $a1, 8($sp)
    lw $a2, 12($sp)
    ### backtrack ###
    move $s2, $a2
    jal delete_to_set      
    move $a2, $zero
    jal set_cell
    move $a2, $s2  
    move $s2, $zero
    ### backtrack ###
next_value:
    # next value pls
    addiu $a2, $a2, 1
    blt $a2, 5, sudoku_value_loop
    j sudoku_end    # no value possible, end
skip_cell:
    addiu $a1, $a1, 1   # col = col + 1
    jal sudoku
    lw $a1, 8($sp)
    addiu $a0, $a0, 1   # row = row + 1
    jal sudoku
    lw $a0, 4($sp)

sudoku_end:
    ### END ###
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    addiu $sp, $sp, 16
    ### END ###
sudoku_exit:
    jr $ra