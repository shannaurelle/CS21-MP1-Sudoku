# CS 21 MP 1 -- S2 AY 2021-2022
# Shann Aurelle G. Ripalda -- 03/25/2022
# sudoku4x4.asm -- program to solve a 4x4 sudoku board
.text
main:
    # store the row address to global ptr gp
    la $t0, row_1
    sw $t0, 0($gp)
    la $t0, row_2
    sw $t0, 4($gp)
    la $t0, row_3
    sw $t0, 8($gp)
    la $t0, row_4
    sw $t0, 12($gp)

    # row sets for algorithm
    la $t0, row_set_1
    sw $t0, 16($gp)
    la $t0, row_set_2
    sw $t0, 20($gp)
    la $t0, row_set_3
    sw $t0, 24($gp)
    la $t0, row_set_4
    sw $t0, 28($gp)

    # column sets for algorithm
    la $t0, col_set_1
    sw $t0, 32($gp)
    la $t0, col_set_2
    sw $t0, 36($gp)
    la $t0, col_set_3
    sw $t0, 40($gp)
    la $t0, col_set_4
    sw $t0, 44($gp)

    # region sets for algorithm
    la $t0, region_set_1
    sw $t0, 48($gp)
    la $t0, region_set_2
    sw $t0, 52($gp)
    la $t0, region_set_3
    sw $t0, 56($gp)
    la $t0, region_set_4
    sw $t0, 60($gp)

    # get input string
    move $t0, $zero
    
input_loop:
    addu $t1, $t0, $gp 
    lw $t1, 0($t1)
    la $a0, 0($t1)
    li $a1, 5 
    li $v0, 8
    syscall

    li $a0, 10
    li $v0, 11
    syscall
    
    addi $t0, $t0, 4 
    blt $t0,16,input_loop

    li $a0, 10
    li $v0, 11
    syscall
    
    
    li $a0, 4
    li $a1, 4
    jal create_sets
    
    move $a0, $zero
    move $a1, $zero
    li $a2, 1
    jal sudoku

    la $a0, no_solution
    li $v0, 4
    syscall
    # diagnostic functions 
    li $a0, 10
    li $v0, 11
    syscall

    li $t0, 0
    sets_loop:
    mul $t2, $t0, 4
    lw $t1, row_set_1($t2)
    move $a0, $t1
    li $v0, 1
    syscall

    li $a0, 10
    li $v0, 11
    syscall

    addu $t0, $t0, 1
    blt $t0,12,sets_loop

    li $a0, 10
    li $v0, 11
    syscall

    jal print_board
exit:
    li $v0, 10
    syscall

print_board:
    ### PREAMBLE ###
    subiu $sp, $sp, 4
    sw $ra, 0($sp)
    ### PREAMBLE ###
    # print stored string
    move $t0, $zero
print_loop:
    addu $t1, $t0, $gp 
    lw $t1, 0($t1)
    la $a0, 0($t1)
    li $v0, 4
    syscall
    
    li $a0, 10
    li $v0, 11
    syscall
    
    addi $t0, $t0, 4 
    blt $t0,16,print_loop
    ### END ###
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    ### END ###
    jr $ra

get_cell:
    ### PREAMBLE ###
    subiu $sp, $sp, 4
    sw $ra, 0($sp)
    ### PREAMBLE ###
    # a0, a1 are row and column respectively in int
    # v0 is the value of the cell
    move $t0, $a0
    move $t1, $a1

    sll $t0, $t0, 2      # t0 = t0 * 4

    addu $t0, $t0, $gp   # go to the target row string base address
    lw $t0, 0($t0)      # get base address value from pointer
    la $t0, 0($t0)
    addu $t1, $t0, $t1   # t1 = t0 + t1
    lbu $v0, 0($t1)      # v0 = mem[t1]
    subiu $v0, $v0, 48   # v0 = v0 - 48 (now stored as integer)
    
    move $t0, $zero
    move $t1, $zero
    move $t2, $zero

    ### END ###
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    ### END ###
    jr $ra

set_cell:
    ### PREAMBLE ###
    subiu $sp, $sp, 4
    sw $ra, 0($sp)
    ### PREAMBLE ###
    # a0, a1, a2 are row, column, and value respectively in int
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2

    sll $t0, $t0, 2      # t0 = t0 * 4
    addu $t2, $t2, 48    # convert value to ascii equivalent

    addu $t0, $t0, $gp   # go to the target row string base address
    lw $t0, 0($t0)       # get base address value from pointer
    la $t0, 0($t0)
    addu $t1, $t0, $t1   # t1 = t0 + t1
    lbu $v0, 0($t1)      # v0 = mem[t1]
    subiu $v0, $v0, 48   # v0 = v0 - 48 (now stored as integer for next backtrack)
    sb $t2, 0($t1)       # t2 = mem[t1]
    
    move $t0, $zero
    move $t1, $zero
    move $t2, $zero

    ### END ###
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    ### END ###
    jr $ra

# 4x4 sets' offsets (row,col,region) : (16,32,48)
# 9x9 sets' offsets (row,col,region) : (36,72,108)
insert_to_set:
    ### PREAMBLE ###
    subiu $sp, $sp, 4
    sw $ra, 0($sp)
    ### PREAMBLE ###
    # a0, a1, a2, are row, col, and value in int respectively
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $zero
    move $t4, $zero
    move $t5, $zero

    # get_region
    srl $t3, $t0, 1      # t3 = t0 / 2
    and $t3, $t3, 1      # t3 = t3 % 2
    sll $t3, $t3, 1      # t3 = t3 * 2
    srl $t4, $t1, 1      # t4 = t1 / 2
    add $t3, $t3, $t4    # t3 = t3 + t4

    sll $t0, $t0, 2      # t0 = t0 * 4
    sll $t1, $t1, 2      # t1 = t1 * 4
    sll $t3, $t3, 2      # t3 = t3 * 4

    addu $t0, $t0, $gp   # row offset address
    addu $t1, $t1, $gp   # column offset address
    addu $t3, $t3, $gp   # region offset address

    subi $t2, $t2, 1     # t2 = t2 - 1
    li   $t4, 1          # t4 = 1 
    sllv $t4, $t4, $t2   # t4 = t4 * 2 ** (t2) 

    lw $t0, 16($t0)      # get base address value from row global
    lw $t5, 0($t0)       # load value from base address
    or $t5, $t4, $t5     # get logical or
    sw $t5, 0($t0)       # store result
    
    lw $t1, 32($t1)      # get base address value from row global
    lw $t5, 0($t1)       # load value from base address
    or $t5, $t4, $t5     # get logical or
    sw $t5, 0($t1)       # store result
    
    lw $t3, 48($t3)      # get base address value from row global
    lw $t5, 0($t3)       # load value from base address
    or $t5, $t4, $t5     # get logical or
    sw $t5, 0($t3)       # store result

    ### END ###
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    ### END ###
    jr $ra

delete_to_set:
    ### PREAMBLE ###
    subiu $sp, $sp, 4
    sw $ra, 0($sp)
    ### PREAMBLE ###
    # a0, a1, a2, are row, col, and value in int respectively
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $zero
    move $t4, $zero
    move $t5, $zero

    # get_region
    srl $t3, $t0, 1      # t3 = t0 / 2
    and $t3, $t3, 1      # t3 = t3 % 2
    sll $t3, $t3, 1      # t3 = t3 * 2
    srl $t4, $t1, 1      # t4 = t1 / 2
    addu $t3, $t3, $t4   # t3 = t3 + t4

    sll $t0, $t0, 2      # t0 = t0 * 4
    sll $t1, $t1, 2      # t1 = t1 * 4
    sll $t3, $t3, 2      # t3 = t3 * 4

    addu $t0, $t0, $gp   # row offset address
    addu $t1, $t1, $gp   # column offset address
    addu $t3, $t3, $gp   # region offset address

    subi $t2, $t2, 1     # t3 = t3 - 1
    li   $t4, 1          # t4 = 1 
    sllv $t4, $t4, $t2   # t4 = t4 * 2 ** (t2)
    not  $t4, $t4        # get opposite bitmask

    lw   $t0, 16($t0)      # get base address value from row global
    lw   $t5, 0($t0)       # load value from base address
    and  $t5, $t4, $t5     # get logical or
    sw   $t5, 0($t0)       # store result

    lw   $t1, 32($t1)      # get base address value from row global
    lw   $t5, 0($t1)       # load value from base address
    and  $t5, $t4, $t5     # remove bit 
    sw   $t5, 0($t1)       # store result

    lw   $t3, 48($t3)      # get base address value from row global
    lw   $t5, 0($t3)       # load value from base address
    and  $t5, $t4, $t5     # remove bit 
    sw   $t5, 0($t3)       # store result

    ### END ###
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    ### END ###
    jr $ra

create_sets:
    ### PREAMBLE ###
    subiu $sp, $sp, 4
    sw $ra, 0($sp)
    ### PREAMBLE ###
    # a0 is the number of rows
    # a1 is the number of columns
    move $s0, $a0
    move $s1, $a1
    move $s2, $ra
    move $a0, $zero
row_loop:
    move $a1, $zero
col_loop:
    jal  get_cell
    beqz $v0, col_skip
    move $a2, $v0
    jal  insert_to_set
col_skip:    
    addu $a1, $a1, 1
    blt  $a1, 4, col_loop

    addu $a0, $a0, 1
    blt  $a0, 4, row_loop

    move $a0, $s0
    move $a1, $s1

    move $s0, $zero
    move $s1, $zero
    move $ra, $s2
    ### END ###
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    ### END ###
    jr $ra

# 4x4 sets' offsets (row,col,region) : (16,32,48)
# 9x9 sets' offsets (row,col,region) : (36,72,108)
check_set:
    ### PREAMBLE ###
    subiu $sp, $sp, 4
    sw $ra, 0($sp)
    ### PREAMBLE ###
    # a0, a1, a2, are row, col, and value in int respectively
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $zero
    move $t4, $zero

    # get_region
    srl $t3, $t0, 1      # t3 = t0 / 2
    and $t3, $t3, 1      # t3 = t3 % 2
    sll $t3, $t3, 1      # t3 = t3 * 2
    srl $t4, $t1, 1      # t4 = t1 / 2
    add $t3, $t3, $t4    # t3 = t3 + t4

    sll $t0, $t0, 2      # t0 = t0 * 4
    sll $t1, $t1, 2      # t1 = t1 * 4
    sll $t3, $t3, 2      # t3 = t3 * 4

    addu $t0, $t0, $gp   # row offset address
    addu $t1, $t1, $gp   # column offset address
    addu $t3, $t3, $gp   # region offset address

    lw $t0, 16($t0)      # get base address value from row global
    lw $t0, 0($t0)       # get value from base address
    lw $t1, 32($t1)      # get base address value from col global
    lw $t1, 0($t1)       # get value from base address
    lw $t3, 48($t3)      # get base address value from region global
    lw $t3, 0($t3)       # get value from base address

    subi $t2, $t2, 1     # t3 = t3 - 1
    li $t4, 1            # t4 = 1 
    sllv $t4, $t4, $t2   # t4 = t4 * 2 ** (t2) 

    or $t0, $t0, $t1
    or $t0, $t0, $t3
    and $t0, $t0, $t4    

    beqz $t0, check_set_end  # if resulting set is 0, then the set is ready for insert
    li $t0, 1
check_set_end:
    move $v0, $t0
    ### END ###
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    ### END ###
    jr $ra

sudoku_check:
    ### PREAMBLE ###
    subiu $sp, $sp, 4
    sw $ra, 0($sp)
    ### PREAMBLE ###
    # test for correct solution: 15 row value for 4x4 and 511 for 9x9
    # number of rows: 12 for 4x4 and 27 for 9x9 
    move $t0, $zero

sudoku_check_loop:

    sll   $t2, $t0, 2  # t0 = t0 * 4
    lw    $t1, row_set_1($t2)
    bne   $t1, 15, sudoku_check_fail
    addiu $t0, $t0, 1
    blt   $t0, 12, sudoku_check_loop
    # solution is correct, print the result
    jal print_board
    j exit

sudoku_check_fail:
    ### END ###
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    ### END ###
    jr $ra

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
    jal sudoku_check
    # if row == 3 and col == 4 stop
    mul $t2, $a0, $a1
    beq $t2, 12, sudoku_end      

    blt $a1, 4, sudoku_recurse
    move $a1, $zero
    sw $a1, 8($sp)
    addiu $a0, $a0, 1
    sw $a0, 4($sp)

sudoku_recurse:

    jal get_cell
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

    jal place

    # start from current position
    jal sudoku
    lw $a0, 4($sp)
    lw $a1, 8($sp)
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

.data
    row_1:  .space 12
    row_2:  .space 12
    row_3:  .space 12
    row_4:  .space 12
    row_set_1: .space 4
    row_set_2: .space 4
    row_set_3: .space 4
    row_set_4: .space 4
    col_set_1: .space 4
    col_set_2: .space 4
    col_set_3: .space 4
    col_set_4: .space 4
    region_set_1: .space 4
    region_set_2: .space 4
    region_set_3: .space 4
    region_set_4: .space 4
    no_solution: .asciiz "NO SOLUTION"
    placed: .asciiz "placed\n"
    removed: .asciiz "removed\n"

    
