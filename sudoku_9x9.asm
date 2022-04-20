# CS 21 MP 1 -- S2 AY 2021-2022
# Shann Aurelle G. Ripalda -- 03/25/2022
# sudoku9x9.asm -- program to solve a 4x4 sudoku board
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
    la $t0, row_5
    sw $t0, 20($gp)
    la $t0, row_6
    sw $t0, 24($gp)
    la $t0, row_7
    sw $t0, 28($gp)
    la $t0, row_8
    sw $t0, 32($gp)
    la $t0, row_9
    sw $t0, 36($gp)

    # row sets for algorithm
    la $t0, row_set_1
    sw $t0, 40($gp)
    la $t0, row_set_2
    sw $t0, 44($gp)
    la $t0, row_set_3
    sw $t0, 48($gp)
    la $t0, row_set_4
    sw $t0, 52($gp)
    la $t0, row_set_5
    sw $t0, 56($gp)
    la $t0, row_set_6
    sw $t0, 60($gp)
    la $t0, row_set_7
    sw $t0, 64($gp)
    la $t0, row_set_8
    sw $t0, 68($gp)
    la $t0, row_set_9
    sw $t0, 72($gp)

    # column sets for algorithm
    la $t0, col_set_1
    sw $t0, 76($gp)
    la $t0, col_set_2
    sw $t0, 80($gp)
    la $t0, col_set_3
    sw $t0, 84($gp)
    la $t0, col_set_4
    sw $t0, 88($gp)
    la $t0, col_set_5
    sw $t0, 92($gp)
    la $t0, col_set_6
    sw $t0, 96($gp)
    la $t0, col_set_7
    sw $t0, 100($gp)
    la $t0, col_set_8
    sw $t0, 104($gp)
    la $t0, col_set_9
    sw $t0, 108($gp)

    # region sets for algorithm
    la $t0, region_set_1
    sw $t0, 112($gp)
    la $t0, region_set_2
    sw $t0, 116($gp)
    la $t0, region_set_3
    sw $t0, 120($gp)
    la $t0, region_set_4
    sw $t0, 124($gp)
    la $t0, region_set_5
    sw $t0, 128($gp)
    la $t0, region_set_6
    sw $t0, 132($gp)
    la $t0, region_set_7
    sw $t0, 136($gp)
    la $t0, region_set_8
    sw $t0, 140($gp)
    la $t0, region_set_9
    sw $t0, 144($gp)

    # get input string
    move $t0, $zero
input_loop:
    addu $t1, $t0, $gp 
    lw $t1, 0($t1)
    la $a0, 0($t1)
    li $a1, 10 
    li $v0, 8
    syscall
    
    li $a0, 10
    li $v0, 11
    syscall
    
    addi $t0, $t0, 4 
    blt $t0,36,input_loop

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
    blt $t0,36,print_loop
    
exit:
    li $v0, 10
    syscall

.data
    row_1:  .space 12
    row_2:  .space 12
    row_3:  .space 12
    row_4:  .space 12
    row_5:  .space 12
    row_6:  .space 12
    row_7:  .space 12
    row_8:  .space 12
    row_9:  .space 12
    row_set_1: .space 4
    row_set_2: .space 4
    row_set_3: .space 4
    row_set_4: .space 4
    row_set_5: .space 4
    row_set_6: .space 4
    row_set_7: .space 4
    row_set_8: .space 4
    row_set_9: .space 4
    col_set_1: .space 4
    col_set_2: .space 4
    col_set_3: .space 4
    col_set_4: .space 4
    col_set_5: .space 4
    col_set_6: .space 4
    col_set_7: .space 4
    col_set_8: .space 4
    col_set_9: .space 4
    region_set_1: .space 4
    region_set_2: .space 4
    region_set_3: .space 4
    region_set_4: .space 4
    region_set_5: .space 4
    region_set_6: .space 4
    region_set_7: .space 4
    region_set_8: .space 4
    region_set_9: .space 4
