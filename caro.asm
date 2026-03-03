.data
    #Board
    board: .space 225
    size: .word 15

    #Const
    CELL_EMPTY: .byte 0
    CELL_X: .byte 1
    CELL_O: .byte 2

    #Display
    quote: .asciiz "GOMOKU (FIVE IN A ROW)\n"
    turn1: .asciiz "Player 1 (X), please input your coordinates:\n"
    turn2: .asciiz "Player 2 (O), please input your coordinates:\n"
    formatmsg: .asciiz "Enter coordinates as 'x,y': "
    rowinp: .asciiz "Row (0-14): "
    colinp: .asciiz "Column (0-14): "
    invalid: .asciiz "Position Invalid. Try Again.\n"
    menuinv: .asciiz "Invalid Choice. Try Again.\n"
    played: .asciiz "Position Played. Try Again.\n"
    p1win: .asciiz "Player 1 WIN!\n"
    p2win: .asciiz "Player 2 WIN!\n"
    tie: .asciiz "TIE!\n"
    menumsg: .asciiz "1. Play Again\n2. Exit\nChoose: "
    inpbuffer: .space 1000

    #Pieces
    empty: .asciiz ".  "
    X: .asciiz "X  "
    O: .asciiz "O  "
    spacing: .asciiz "\n"

    #State
    currP: .word 1
    movcnt: .word 0
    gameovr: .word 0

    #Temp
    row: .word 0
    col: .word 0

    #Win check
    dx: .word 0, 1, 1, 1, 0, -1, -1, -1
    dy: .word -1, -1, 0, 1, 1, 1, 0, -1

    #output
    output: .asciiz "C:\\Users\\Thanh\\Desktop\\AssignmentKTMT\\result.txt"
    buffer: .space 2000
.text
.globl main
main:
    jal clr
    li $v0, 4
    la $a0, quote
    syscall
    jal initbrd
    li $t0, 0
    sw $t0, gameovr
    sw $t0, movcnt
    li $t0, 1
    sw $t0, currP

#gameplay
loop:
    jal clr
    jal displaybrd
    lw $t0, gameovr
    bne $t0, 0, end
    lw $t0, movcnt
    lw $t1, size
    mul $t1, $t1, $t1
    bge $t0, $t1, TIE
    lw $t0, currP
    li $t1, 1
    beq $t0, $t1, p1
    j p2
p1:
    li $v0, 4
    la $a0, turn1
    syscall
    jal Pmove
    li $a0, 1
    jal place
    j aftermove
p2:
    li $v0, 4
    la $a0, turn2
    syscall
    jal Pmove
    li $a0, 2
    jal place
    j aftermove
aftermove:
    lw $t0, movcnt
    addi $t0, $t0, 1
    sw $t0, movcnt
    jal checkwin
    lw $t0, gameovr
    bne $t0, 0, loop
    lw $t0, currP
    li $t1, 1
    beq $t0, $t1, switch
    li $t0, 1
    sw $t0, currP
    j loop
switch:
    li $t0, 2
    sw $t0, currP
    j loop
TIE:
    li $t0, 1
    sw $t0, gameovr
    j end
end:
    jal displayresult
menu:
    li $v0, 4
    la $a0, menumsg
    syscall
    jal menuread
    move $t0, $v0
    li $t1, 1
    beq $t0, $t1, main
    li $t1, 2
    beq $t0, $t1, exit
    li $v0, 4
    la $a0, menuinv
    syscall
    j menu
exit:
    li $v0, 10
    syscall
menuread:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    li $v0, 8
    la $a0, inpbuffer
    li $a1, 1000
    syscall
    li $v0, 0
    la $t0, inpbuffer
    lb $t1, 0($t0)
    li $t2, 49
    li $t3, 50
    seq $v0, $t1, $t2
    beq $t1, $t3, opt2
    beqz $v0, endchoice
    j digits
opt2:
    li $v0, 2
    j digits
digits:
    lb $t2, 1($t0)
    beq $t2, 10, endchoice
    beq $t2, 0, endchoice
    li $v0, 0
endchoice:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
usrinpread:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    li $v0, 8
    la $a0, inpbuffer
    li $a1, 100
    syscall
    la $v0, inpbuffer
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
inpcoord:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    move $s0, $a0
    li $t0, 0
    li $t1, 0
    li $t4, 0
rowcoord:
    lb $t2, 0($s0)
    beq $t2, 0, invcoord
    beq $t2, 10, invcoord
    beq $t2, ',', rowfin
    li $t3, 48
    blt $t2, $t3, invcoord
    li $t3, 57
    bgt $t2, $t3, invcoord
    sub $t2, $t2, 48
    mul $t0, $t0, 10
    add $t0, $t0, $t2
    lw $t3, size
    bge $t0, $t3, invcoord
    addi $s0, $s0, 1
    addi $t4, $t4, 1
    j rowcoord
rowfin:
    addi $s0, $s0, 1
    beq $t4, 0, invcoord
    li $t4, 0
colcoord:
    lb $t2, 0($s0)
    beq $t2, 0, endinp
    beq $t2, 10, endinp
    li $t3, 48
    blt $t2, $t3, invcoord
    li $t3, 57
    bgt $t2, $t3, invcoord
    sub $t2, $t2, 48
    mul $t1, $t1, 10
    add $t1, $t1, $t2
    lw $t3, size
    bge $t1, $t3, invcoord
    addi $s0, $s0, 1
    addi $t4, $t4, 1
    j colcoord
endinp:
    beq $t4, 0, invcoord
    sw $t0, row
    sw $t1, col
    li $v0, 1
    j coordfin
invcoord:
    li $v0, 0
coordfin:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

#Board
initbrd:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    li $s0, 0
    lw $s1, size
    mul $s1, $s1, $s1
initbrdloop:
    beq $s0, $s1, initbrdend
    la $t0, board
    add $t0, $t0, $s0
    lb $t1, CELL_EMPTY
    sb $t1, 0($t0)
    addi $s0, $s0, 1
    j initbrdloop
initbrdend:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra
displaybrd:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    li $s0, 0
    lw $s1, size
displaybrdrlp:
    beq $s0, $s1, displaybrdend
    li $v0, 1
    move $a0, $s0
    syscall
    li $v0, 11
    li $a0, '\t'
    syscall
    li $s2, 0
displaybrdclp:
    beq $s2, $s1, displaybrdrend
    mul $s3, $s0, $s1
    add $s3, $s3, $s2
    la $t0, board
    add $t0, $t0, $s3
    lb $t1, 0($t0)
    li $t2, 0
    beq $t1, $t2, emptycell
    li $t2, 1
    beq $t1, $t2, xcell
    li $t2, 2
    beq $t1, $t2, ocell
    j displaybrdcend
emptycell:
    li $v0, 4
    la $a0, empty
    syscall
    j displaybrdcend
xcell:
    li $v0, 4
    la $a0, X
    syscall
    j displaybrdcend
ocell:
    li $v0, 4
    la $a0, O
    syscall
displaybrdcend:
    addi $s2, $s2, 1
    j displaybrdclp
displaybrdrend:
    li $v0, 4
    la $a0, spacing
    syscall
    addi $s0, $s0, 1
    j displaybrdrlp
displaybrdend:
    li $v0, 11
    li $a0, '\t'
    syscall
    li $s0, 0
    lw $s1, size
displaycolindx:
    beq $s0, $s1, displaybrdfin
    li $v0, 1
    move $a0, $s0
    syscall
    li $t0, 9
    ble $s0, $t0, space
    li $v0, 11
    li $a0, ' '
    syscall
    j colspacing
space:
    li $v0, 11
    li $a0, ' '
    syscall
    li $v0, 11
    li $a0, ' '
    syscall
colspacing:
    addi $s0, $s0, 1
    j displaycolindx
displaybrdfin:
    li $v0, 4
    la $a0, spacing
    syscall
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addi $sp, $sp, 20
    jr $ra

#logic
Pmove:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
getinp:
    li $v0, 4
    la $a0, formatmsg
    syscall
    jal usrinpread
    move $a0, $v0
    jal inpcoord
    beqz $v0, invgameinp
    lw $t0, row
    lw $t1, col
    lw $t2, size
    mul $t0, $t0, $t2
    add $t0, $t0, $t1
    la $t1, board
    add $t1, $t1, $t0
    lb $t2, 0($t1)
    beq $t2, 0, valid
    li $v0, 4
    la $a0, played
    syscall
    j getinp
invgameinp:
    li $v0, 4
    la $a0, invalid
    syscall
    j getinp
valid:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
place:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    lw $t0, row
    lw $t1, col
    lw $t2, size
    mul $t0, $t0, $t2
    add $t0, $t0, $t1
    la $t1, board
    add $t1, $t1, $t0
    sb $a0, 0($t1)
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
checkwin:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    lw $s0, row
    lw $s1, col
    lw $t0, size
    mul $t0, $s0, $t0
    add $t0, $t0, $s1
    la $t1, board
    add $t1, $t1, $t0
    lb $s2, 0($t1)
    li $t0, 0
direction:
    li $t9, 8
    beq $t0, $t9, checkwinend
    la $t1, dx
    la $t2, dy
    sll $t3, $t0, 2
    add $t1, $t1, $t3
    add $t2, $t2, $t3
    lw $t1, 0($t1)
    lw $t2, 0($t2)
    li $t3, 1
    move $t4, $s0
    move $t5, $s1
posdir:
    add $t4, $t4, $t1
    add $t5, $t5, $t2
    bltz $t4, negdir
    bltz $t5, negdir
    lw $t6, size
    bge $t4, $t6, negdir
    bge $t5, $t6, negdir
    mul $t6, $t4, $t6
    add $t6, $t6, $t5
    la $t7, board
    add $t7, $t7, $t6
    lb $t8, 0($t7)
    bne $t8, $s2, negdir
    addi $t3, $t3, 1
    li $t9, 5
    beq $t3, $t9, getwin
    j posdir
negdir:
    move $t4, $s0
    move $t5, $s1
negative:
    sub $t4, $t4, $t1
    sub $t5, $t5, $t2
    bltz $t4, nxtdirection
    bltz $t5, nxtdirection
    lw $t6, size
    bge $t4, $t6, nxtdirection
    bge $t5, $t6, nxtdirection
    mul $t6, $t4, $t6
    add $t6, $t6, $t5
    la $t7, board
    add $t7, $t7, $t6
    lb $t8, 0($t7)
    bne $t8, $s2, nxtdirection
    addi $t3, $t3, 1
    li $t9, 5
    beq $t3, $t9, getwin
    j negative
nxtdirection:
    addi $t0, $t0, 1
    j direction
getwin:
    li $t0, 1
    sw $t0, gameovr
checkwinend:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra
    
#printout
displayresult:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    lw $t0, movcnt
    lw $t1, size
    mul $t1, $t1, $t1
    beq $t0, $t1, displayTIE
    lw $t0, currP
    li $t1, 1
    beq $t0, $t1, displayp1win
    li $v0, 4
    la $a0, p2win
    syscall
    j displayresultend
displayp1win:
    li $v0, 4
    la $a0, p1win
    syscall
    j displayresultend
displayTIE:
    li $v0, 4
    la $a0, tie
    syscall
displayresultend:
    jal printtxt
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra    
clr:
    li $v0, 4
    la $a0, spacing
    syscall
    jr $ra

#result.txt
printtxt:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    la $s1, buffer
    li $s2, 2000
clearbuffer:
    beqz $s2, cleared
    sb $zero, 0($s1)
    addi $s1, $s1, 1
    addi $s2, $s2, -1
    j clearbuffer
cleared:
    li $v0, 13
    la $a0, output
    li $a1, 1
    li $a2, 0
    syscall
    move $s0, $v0
    la $s1, buffer
    li $t0, 0
    li $t1, 0
brdrow:
    lw $t2, size
    beq $t1, $t2, txtprintcolnum
    move $t3, $t1
    li $t4, 9
    ble $t3, $t4, onedigitrow
    li $t8, 49
    sb $t8, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
    addi $t3, $t3, -10
    addi $t3, $t3, 48
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
    j rownumok
onedigitrow:
    move $t3, $t1
    addi $t3, $t3, 48
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
rownumok:
    li $t3, '\t'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
    li $t3, 0
celltxt:
    lw $t4, size
    beq $t3, $t4, rowendtxt
    mul $t5, $t1, $t4
    add $t5, $t5, $t3
    la $t6, board
    add $t6, $t6, $t5
    lb $t7, 0($t6)
    li $t8, 0
    beq $t7, $t8, txtempty
    li $t8, 1
    beq $t7, $t8, Xtxt
    li $t8, 'O'
    sb $t8, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
    j spacetxt
txtempty:
    li $t8, '.'
    sb $t8, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
    j spacetxt
Xtxt:
    li $t8, 'X'
    sb $t8, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
spacetxt:
    li $t8, ' '
    sb $t8, 0($s1)
    addi $s1, $s1, 1
    sb $t8, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 2
    addi $t3, $t3, 1
    j celltxt
rowendtxt:
    li $t8, '\n'
    sb $t8, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j brdrow
txtprintcolnum:
    li $t8, '\t'
    sb $t8, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
    li $t1, 0
txtcolnum:
    lw $t2, size
    beq $t1, $t2, txtresult
    move $t3, $t1
    li $t4, 9
    ble $t3, $t4, onedigitcol
    li $t8, 49
    sb $t8, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
    addi $t3, $t3, -10
    addi $t3, $t3, 48
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
    j txtcolnumok
onedigitcol:
    move $t3, $t1
    addi $t3, $t3, 48
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
txtcolnumok:
    li $t4, 9
    ble $t1, $t4, txtspacex2
    li $t3, ' '
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
    j txtcolnumnxt
txtspacex2:
    li $t3, ' '
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 2
txtcolnumnxt:
    addi $t1, $t1, 1
    j txtcolnum
txtresult:
    li $t8, '\n'
    sb $t8, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
    li $t8, '\n'
    sb $t8, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 1
    lw $t1, movcnt
    lw $t2, size
    mul $t2, $t2, $t2
    beq $t1, $t2, txttie
    lw $t1, currP
    li $t2, 2
    beq $t1, $t2, txtp2win
    j txtp1win
txtp1win:
    li $t3, 'P'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'l'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'a'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'y'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'e'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'r'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, ' '
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, '1'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, ' '
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'W'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'I'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'N'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, '!'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 13
    j printtxtok
txtp2win:
    li $t3, 'P'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'l'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'a'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'y'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'e'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'r'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, ' '
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, '2'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, ' '
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'W'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'I'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'N'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, '!'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 13
    j printtxtok
txttie:
    li $t3, 'T'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'I'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, 'E'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    li $t3, '!'
    sb $t3, 0($s1)
    addi $s1, $s1, 1
    addi $t0, $t0, 4
printtxtok:
    li $v0, 15
    move $a0, $s0
    la $a1, buffer
    move $a2, $t0
    syscall
    li $v0, 16
    move $a0, $s0
    syscall
    j txtexit
txtexit:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra