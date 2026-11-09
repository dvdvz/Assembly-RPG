.macro printString(%address) # prints a preexisting string given its label/address
	li $v0, 4
	la $a0, %address
	syscall
.end_macro

.macro printNewString(%string) # prints a new string based on programmer input
	.data
	input: .asciiz %string
	.text
	printString(input)
.end_macro

.macro printNewDelayedString(%string) # prints a new string with a brief delay
	.data
	input: .asciiz %string
	.text
	sleep(1000)
	printString(input)
.end_macro

.macro printInt(%register) # prints a preexisting int given the register it's stored in
	li $v0, 1
	move $a0, %register
	syscall
.end_macro

.macro printNewInt(%int) # prints a new int based on programmer input
	li $v0, 1
	li $a0, %int
	syscall
.end_macro

.macro getInt(%register) # gets an int from user input and stores it in the given register
	li $v0, 5
	syscall
	move %register, $v0
.end_macro

.macro popupInt(%prompt, %register) # requests an int from the user with the given prompt and stores it in the given register
	loop:
	li $v0, 51
	la $a0, %prompt
	syscall
	bne $a1, 0, loop
	move %register, $a0
.end_macro

.macro printNewChar(%char) # prints a new char based on programmer input
	li $v0, 11
	li $a0, %char
	syscall
.end_macro

.macro getChar(%register) # gets a char from user input and stores it in the given register
	li $v0, 12
	syscall
	move %register, $v0
.end_macro

.macro branchAlphanumeric(%char, %valid, %invalid) # branches to the 'valid' address if the provided character is a letter or number, otherwise to 'invalid'
	numbers:
		blt %char, '0', uppercase
		bgt %char, '9', uppercase
		j %valid
	uppercase:
		blt %char, 'A', lowercase
		bgt %char, 'Z', lowercase
		j %valid
	lowercase:
		blt %char, 'a', %invalid
		bgt %char, 'z', %invalid
		j %valid
.end_macro

.macro branchLetterRange(%char, %char1, %char2, %valid, %invalid) # branches to the 'valid' address if the provided character is a letter in the given range, otherwise to 'invalid'
	uppercase:
		blt %char, 'A', lowercase
		bgt %char, 'Z', lowercase
		j letterRange
	lowercase:
		blt %char, 'a', %invalid
		bgt %char, 'z', %invalid
		swapCase(%char)
		j letterRange
	letterRange:
		blt %char, %char1, %invalid
		bgt %char, %char2, %invalid
		j %valid
.end_macro

.macro branchSafeLetterRange(%char, %char1, %char2, %valid, %invalid) # branchLetterRange but it validates the given range, char1 and char2 must be registers
	uppercase:
		blt %char, 'A', lowercase
		bgt %char, 'Z', lowercase
		j uppercase1
	lowercase:
		blt %char, 'a', %invalid
		bgt %char, 'z', %invalid
		swapCase(%char)
		j uppercase1
	uppercase1:
		blt %char1, 'A', lowercase1
		bgt %char1, 'Z', lowercase1
		j uppercase2
	lowercase1:
		blt %char1, 'a', %invalid
		bgt %char1, 'z', %invalid
		swapCase(%char1)
		j uppercase2
	uppercase2:
		blt %char2, 'A', lowercase2
		bgt %char2, 'Z', lowercase2
		j compareChars
	lowercase2:
		blt %char2, 'a', %invalid
		bgt %char2, 'z', %invalid
		swapCase(%char2)
		j compareChars
	compareChars:
		blt %char1, %char2, letterRange
		blt %char2, %char1, reverseRange
	letterRange:
		blt %char, %char1, %invalid
		bgt %char, %char2, %invalid
		j %valid
	reverseRange:
		blt %char, %char2, %invalid
		bgt %char, %char1, %invalid
		j %valid
.end_macro

.macro swapCase(%char) # swaps the case of a given char, notifies the programmer if it can't
	uppercase:
		blt %char, 'A', lowercase
		bgt %char, 'Z', lowercase
		add %char, %char, 32
		j swapDone
	lowercase:
		blt %char, 'a', nonLetter
		bgt %char, 'z', nonLetter
		sub %char, %char, 32
		j swapDone
	nonLetter: printNewString("Error: Can only swap the case of letters A-Z.")
	swapDone:
.end_macro

.macro setSeed # sets a seed for RNG, should be done once per program iteration
	li $v0, 30
	syscall
	li $v0, 40
	move $a1, $a0
	li $a0, 0
	syscall
.end_macro

.macro randomNumber (%register, %min, %max) # generates a random number in the given range
	li $v0, 42
	li $a0, 0
	add %max, %max, 1
	move $a1, %max
	syscall
	sub %max, %max, 1
	sub %register, %max, %min
	add %register, %register, 1
	div $a0, %register
	mfhi $a0
	add %register, $a0, %min
.end_macro

.macro sleep(%int) # sleeps for the given time in milliseconds
	li $v0, 32
	li $a0, %int
	syscall
.end_macro

.macro setSleep(%register) # sleeps for the time in milliseconds stored in the given register
	li $v0, 32
	move $a0, %register
	syscall
.end_macro

.macro dummyNote # plays a silent 2-second note to wake up MIDI so the audio doesn't break
	li $v0, 31
	li $a0, 0
	li $a1, 2000
	li $a2, 0
	li $a3, 0
	syscall
	sleep(2000)
.end_macro

.macro endOfNullTermArray(%register, %array) # prints the last number in a 0-terminated array
	la %register, %array
	loop:
		lw $a0, 0(%register)
		beqz $a0, done
		add %register, %register, 4
		j loop
	done:
		li $v0, 1
		lw $a0, -4(%register)
		syscall
.end_macro

.macro exitProgram # exits the program
	li $v0, 10 
	syscall
.end_macro
