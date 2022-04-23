# 4x4 sets' offsets (row,col,region) : (16,32,48)
# 9x9 sets' offsets (row,col,region) : (36,72,108)
insert_set:
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

insert_end:
    move $v0, $t0
    jr $ra