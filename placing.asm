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
    
    addi $t0, $t0, 4 
    blt $t0,16,input_loop

    li $a0, 10
    li $v0, 11
    syscall
    
    # set one cell
    li $a0, 1
    li $a1, 1
    li $a2, 0
    jal set_cell
    move $s0, $v0
    # unset it again
    li $a0, 1
    li $a1, 1
    move $a2, $s0
    jal set_cell
    move $s0, $v0
    
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

set_cell:
    # a0, a1, a2 are row, column, and value respectively in int
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2

    sll $t0, $t0, 2      # t0 = t0 * 8
    #sll $t1, $t1, 2
    addu $t2, $t2, 48    # convert value to ascii equivalent

    addu $t0, $t0, $gp   # go to the target row string base address
    lw $t0, 0($t0)       # get base address value from pointer
    la $t0, 0($t0)
    addu $t1, $t0, $t1   # t1 = t0 + t1
    lbu $v0, 0($t1)      # v0 = mem[t1]
    subiu $v0, $v0, 48   # v0 = v0 - 48 (now stored as integer
    sb $t2, 0($t1)       # t2 = mem[t1]
    
    move $t0, $zero
    move $t1, $zero
    move $t2, $zero
    jr $ra
.data
    string: .space 8    # reserve 8 bytes into memory
    row_1:  .space 8
    row_2:  .space 8
    row_3:  .space 8 
    row_4:  .space 8
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