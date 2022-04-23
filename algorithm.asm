# a0, a1, a2, (row, column, value)
sudoku:
    ### PREAMBLE ###
    subu $sp, $sp, 16
    sw $ra, 0($sp)  # 
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    ### PREAMBLE ###
    move $t0, $zero
    move $t1, $zero
    move $t2, $zero
# base case
    beq $a0,4,sudoku_end
    beq $a1,4,sudoku_end
    beq $a2,5,sudoku_end
accumulate:
    lw $t1, row_set_1($t0)
    addu $t2, $t2, $t1
    addu $t0, $t0, 4
    blt $t0,48,accumulate

    
    bne $t2,300,sudoku_recurse
    jal print_board
    j exit
sudoku_recurse:
    move $s3, $zero

    #jal check_set
    #beq $v0,1,sudoku_end
    jal get_cell
    move $a2, $v0
    jal check_cell
    lw $a2, 12($sp)

    bnez $v0,skip_cell
    addiu $a2, $a2, 1   # value = value + 1
    jal sudoku
    lw $a2, 12($sp)
skip_cell:
    jal set_cell
    move $s3, $v0       # s3 = former cell
    jal insert_to_set

    addiu $a0, $a0, 1   # row = row + 1
    jal sudoku
    lw $a0, 4($sp)
    addiu $a1, $a1, 1   # col = col + 1
    jal sudoku
    lw $a1, 8($sp)
    
    jal delete_to_set
    move $a2, $s3
    jal insert_to_set      # backtrack
    
sudoku_end:
    ### END ###
    lw $ra, 0($sp)
    addu $sp, $sp, 16
    ### END ###
    jr $ra