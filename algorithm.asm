# a0, a1, a2, (row, column, value)
sudoku:
    ### PREAMBLE ###
    subu $sp, $sp, 16
    sw $ra, 0($sp)  # 
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    ### PREAMBLE ###
# base case
    beq $a0,4,sudoku_end
    beq $a1,4,sudoku_end
sudoku_recurse:
    jal get_cell
    move $a2, $v0
    jal check_cell
    lw $a2, 12($sp)

    bnez $v0,skip_cell  # if cell is not zero, skip cell
    # else : cell is zero
    move $t0, $zero     # start of value do-while
value_loop:
    jal set_cell
    jal insert_to_set
    addu $t0, $t0, 1
    
    jal delete_to_set
    move $a2, $zero
    jal insert_to_set      # backtrack
    blt $t0,4,value_loop
skip_cell:
    
    addiu $a0, $a0, 1   # row = row + 1
    jal sudoku
    lw $a0, 4($sp)
    addiu $a1, $a1, 1   # col = col + 1
    jal sudoku
    lw $a1, 8($sp)
    
sudoku_end:
    ### END ###
    lw $ra, 0($sp)
    addu $sp, $sp, 16
    ### END ###
    jr $ra