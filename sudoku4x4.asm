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
    move $t2, $zero
copy_loop:
    add $t3, $t1, $t2  
    lbu $t4, 0($t3)    # copy from input string
    sb  $t4, 64($t3)   # and save to old_row, offset 64
    addi $t3, $t3, 1 
    blt $t3,5,copy_loop

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

    li $a0, 10
    li $v0, 11
    syscall

    jal print_board
exit:
    li $v0, 10
    syscall

print_board:
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
    jr $ra

get_cell:
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
    jr $ra

set_cell:
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
    jr $ra

# 4x4 sets' offsets (row,col,region) : (16,32,48)
# 9x9 sets' offsets (row,col,region) : (36,72,108)
insert_to_set:
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

    subi $t2, $t2, 1     # t3 = t3 - 1
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

    jr $ra

delete_to_set:
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

    subi $t2, $t2, 1     # t3 = t3 - 1
    li   $t4, 1          # t4 = 1 
    sllv $t4, $t4, $t2   # t4 = t4 * 2 ** (t2) 

    lw   $t0, 16($t0)      # get base address value from row global
    lw   $t5, 0($t0)       # load value from base address
    subu $t5, $t4, $t5     # get logical or
    sw   $t5, 0($t0)       # store result

    lw   $t1, 32($t1)      # get base address value from row global
    lw   $t5, 0($t1)       # load value from base address
    subu $t5, $t4, $t5     # get logical or
    sw   $t5, 0($t1)       # store result

    lw   $t3, 48($t3)      # get base address value from row global
    lw   $t5, 0($t3)       # load value from base address
    subu $t5, $t4, $t5     # get logical or
    sw   $t5, 0($t3)       # store result

    jr $ra

create_sets:
    # a0 is the number of rows
    # a1 is the number of columns
    move $s0, $a0
    move $s1, $a1
    move $s2, $ra
    move $t0, $zero
row_loop:
    move $t1, $zero
col_loop:
    move $a0, $t0
    move $a1, $t1
    move $s3, $t0
    move $s4, $t1
    jal  get_cell
    move $t0, $s3
    move $t1, $s4
    move $a2, $v0
    beqz  $a2, col_skip
    jal  insert_to_set
    move $t0, $s3
    move $t1, $s4 
    addu $t1, $t1, 1
    blt  $t1, $s1, col_loop
col_skip:
    addu $t0, $t0, 1
    blt  $t0, $s0, row_loop
    move $ra, $s2
    move $s0, $zero
    move $s1, $zero
    move $s2, $zero
    move $s3, $zero
    move $s4, $zero
    jr $ra

check_cell:
    # a0, a1 is the row and column 
    # v0 returns 0 if the char is zero char, 1 if otherwise
    move $t0, $a0
    move $t1, $a1
    sll  $t0, $t0, 2       # t0 = t0 * 4

    addu  $t0, $t0, $gp    # go to the target row string base address
    lw    $t0, 0($t0)      # get base address value from pointer
    la    $t0, 0($t0)
    addu  $t1, $t0, $t1    # t1 = t0 + t1
    lbu   $t2, 0($t1)      # v0 = mem[t1]
    subiu $t2, $t2, 48
    beqz  $t2, check_cell_end
    li    $t2, 1
check_cell_end:
    move $v0, $t2
    jr $ra

# 4x4 sets' offsets (row,col,region) : (16,32,48)
# 9x9 sets' offsets (row,col,region) : (36,72,108)
check_set:
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
    or $t0, $t0, $t2
    and $t0, $t0, $t4    

    beqz $t0, check_set_end  # if resulting set is 0, then the set is ready for insert
    li $t0, 1                # else the set is 1, and the set is not ready for insert
check_set_end:
    move $v0, $t0
    jr $ra

# a0, a1, a2, (row, column, value)
sudoku:
    ### PREAMBLE ###
    subu $sp, $sp, 16
    sw $ra, 0($sp)  # 
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    ### PREAMBLE ###
    move $t0, $zero
    move $t1, $zero
    move $t2, $zero
    move $t3, $zero
# base case
    beq $a0,4,sudoku_end
    beq $a1,4,sudoku_end
accumulate:
    lb $t1, row_1($t0)
    beqz $t1, skip_add
    addu $t2, $t2, $t1
skip_add:
    addu $t0, $t0, 1
    blt $t0,20,accumulate
    subu $t2, $t2, 768
    bne $t2,40,sudoku_recurse
    jal print_board
    j exit
sudoku_recurse:
    move $s3, $zero

    jal check_set
    bnez $v0,skip_cell 
    jal set_cell
    move $s3, $v0
skip_cell:
    addiu $a1, $a1, 1   # col = col + 1
    jal sudoku
    lw $a1, 8($sp)
    addiu $a0, $a0, 1   # row = row + 1
    jal sudoku
    lw $a0, 4($sp)
    

    jal check_set
    bnez $v0,sudoku_end
    lw $a2, 12($sp)
    jal set_cell      # backtrack

sudoku_end:
    ### END ###
    lw $ra, 0($sp)
    addu $sp, $sp, 16
    ### END ###
    jr $ra

.data
    row_1:  .space 5
    row_2:  .space 5
    row_3:  .space 5 
    row_4:  .space 5
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
    safe_set:     .space 16
    no_solution: .asciiz "NO SOLUTION"
    
