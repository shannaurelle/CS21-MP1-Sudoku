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
    
exit:
    li $v0, 10
    syscall

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
