# CS 21 MP 1 -- S2 AY 2021-2022
# Shann Aurelle G. Ripalda -- 03/25/2022
# sudoku4x4.asm -- program to solve a 4x4 sudoku board
.text
main:
    # get input four times
    li $t0, 0
    li $t1, 20
input_loop:
    # get input string
    la $a0, string
    li $a1, 4
    li $v0, 8
    syscall

    # copy the string character by character, then store to global gp pointer
    move $t3, $a0
    move $t4, $gp
    add  $t4, $t4, $t0 
copy_loop:
    lbu  $t5, 0($t3)
    sb   $t5, 0($t4)
    addi $t3, $t3, 1
    addi $t4, $t4, 1
    bnez $t5, copy_loop # stop copying when null character reached
    addi $t4, $t4, 1
    sb $zero, 0($t4)       # add the null terminator

    addi $t0, $t0, 5
    blt $t0,$t1,input_loop

    li $a0, 10
    li $v0, 11
    syscall             # print newline 

    move $t0, $zero
    move $t3, $gp
print_loop:
    move $a0, $t3
    li $v0, 4           # for print string syscall
    syscall             # print string

    li $a0, 10
    li $v0, 11
    syscall             # print newline 

    add $t3, $t3, 5
    add $t0, $t0, 5
    blt $t0, $t1, print_loop 
exit:
    li $v0, 10
    syscall
.data
    string: .space 8    # reserve 8 bytes into memory 