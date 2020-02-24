.data
guessmax:	.word	5
guessbase:	.word	0
answer:		.word	5
guesscount:	.word	0

countremain:	.asciiz	" attempts remaining.\n"
onexit:		 .asciiz	"Program exited.\n"

success:	.asciiz	"Yay!\n"
failure:	.asciiz	"Meh!\n"
endgame:	.asciiz	"You Suck!\n"

answertext:	.asciiz " is the random number.\n"

mod10:		.word	10
moda:		.word	41
modb:		.word	3301
seed:		.word	123456789

.text
.globl main
.ent main
	
main:

	# create random number seed
	# li $v0, 30 # save system time
	# syscall
	# move $a0, $v0
	lw $a0, seed
	lw $a1, moda
	lw $a2, modb
	jal rand
	lw $t1, mod10
	rem $t0, $t0, $t1
	sw $t0, seed
	sw $t0, answer

play:

	lw $t0, guessmax
	lw $t1, guesscount
	sub $t2, $t0, $t1
	li $v0, 1
	move $a0, $t2
	syscall

	li $v0, 4
	la $a0, countremain
	syscall

	lw $t0, answer
	li $v0, 1
	move $a0, $t0
	syscall

	li $v0, 4
	la $a0, answertext
	syscall

	li $v0, 5	# input is now in $v0
	syscall

	move $t0, $v0 # moved input to $t0

	lw $t1, answer
	beq $t0, $t1, guessright
	bne $t0, $t1, guesswrong

guessright:
	li $v0, 4 	# Systemcall code print_str
	la $a0, success
	syscall
	j exit

guesswrong:
	li $v0, 4 	# Systemcall code print_str
	la $a0, failure
	syscall

	# increment the counter
	lw $t0, guesscount
	lw $t1, guessmax
	addi $t0, 1
	sw $t0, guesscount
	beq $t0, $t1, prepareexit
	bne $t0, $t1, play

rand: # $a0, $a1, $a2 for three operands
	mul $t0, $a0, $a1
	rem $t0, $t0, $a2
	jr $ra # return to previous location

prepareexit:
	li $v0, 4
	la $a0, endgame
	syscall
	j exit

exit:
	li $v0, 4
	la $a0, onexit
	syscall

	li $v0, 10	# Systemcall code exit
	syscall