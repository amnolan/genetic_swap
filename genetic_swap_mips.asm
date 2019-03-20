#################################
# amnolan						#
# Last Revised: 10/23/2014		#
#################################

.globl main

.data
    
    parent1: 	.space 17
    parent2:	.space 17
    child1:	.space 17
    child2:	.space 17
    
    in1:  	.asciiz "Enter your first string no with spaces (16 total): "
    in2:	.asciiz "\nEnter your second string with no spaces (16 total): "
    in3:	.asciiz "\nEnter an integer (to be later used as an upper limit for copying the arrays): "
    
    prtln:	.asciiz "\n" # simply to create space
    entered:	.asciiz "\nYou entereed the following: "
    working:	.asciiz "\nCreating new babies with your specified inputs..."
    congrats:	.asciiz "\nYou must be a proud parent! Child One and Child Two are shown below: "
    
.text

	main:
	
	jal getInput1 # get first user input (String)
	jal getInput2 # get second user input (String)
	jal getInput3 # get third user input (integer)
	jal output1 # print out what the user typed for input 1
	jal output2 # print out what the user typed for input 2
	jal output3 # print out what the user typed for input 3
	jal copySwap1 # do the hard logic, copying String input 1 into an auxiliary array up until the integer input, then copies from the other array
	jal copySwap2 # do the hard logic, copying String input 2 into an auxiliary array up until the integer input, then copies from the other array
	jal printResults # finally, print out the results
	j   end # jump to the end, to avoid running arbitrarily through all the routines below

#################################first input################

	getInput1:
		la $a0, in1 # get prompt one
		li $v0, 4 # load 4 into v0 (for string print syscall)
		syscall # print the string
	
		li $v0, 8 # load 8 into v0 (read string)
		li $a1, 17 # load 17 into a1 (max length for string reading)
		la $a0, parent1 # load the address for the new string (array of char)
		move $s1, $a0 # save the address in s1
		syscall # run the syscall for getting input
		jr $ra # jump back to calling routine

################################second input################

	getInput2:
		la $a0, in2 # get prompt two
		li $v0, 4 # load 4 into v0 (for string print syscall)
		syscall # print the string
	
		li $v0, 8 # load 8 into v0 (read string)
		li $a1, 17 # load 17 into a1 (max length for string reading)
		la $a0, parent2 # load the address for the new string (array of char)
		move $s2, $a0 # save the address in s2
		syscall # run the syscall for getting input
		jr $ra # jump back to calling routine
	
##############################third input###################

	getInput3:
		la $a0, in3 # get prompt three
		li $v0, 4 # load 4 into v0 (for string print syscall)
		syscall # print the string
	
		li $v0, 5 # load 5 into v0 (read integer)
		syscall # read it in
		move $s3, $v0 # store the integer recorded in v0 during the syscall into s3
		
		jr $ra # jump back to calling routine
		
################################first output################

	output1:
		move $t5, $ra # move the return address into $t5 (otherwise we will cause an infinite loop) restore it before returning to calling routine
	
		la $a0, entered # print a string telling the user "You entered the following:"
		li $v0, 4 # printing
		syscall # printing

		jal printCr

		la $a0, parent1 # get address
		li $v0, 4 # input 4 for string print
		syscall # print
		move $ra, $t5 # restore the previous return address (main routine)
		jr $ra # jump back to calling routine
	
################################second output###############

	output2:
		move $t5, $ra # move the return address into $t5 (otherwise we will cause an infinite loop) restore it before returning to calling routine
		jal printCr

		la $a0, parent2 # get address
		li $v0, 4 # input 4 for string print
		syscall # print
		move $ra, $t5  # restore the previous return address (main routine)
		jr $ra # jump back to calling routine
		
################################third output################

	output3:
		move $t5, $ra # move the return address into $t5 (otherwise we will cause an infinite loop) restore it before returning to calling routine
		jal printCr

		la $a0, ($s3) # load the address of the integer
		li $v0, 1 # store 1 in v0
		syscall # print integer value

		jal printCr

		la $a0, working # load the message that it's working
		li $v0, 4 # load the number 4 for printing
		syscall # print message
		move $ra, $t5  # restore the previous return address (main routine)
		jr $ra # jump back to calling routine
				
################################copy/swap loop1##############
		
		
	copySwap1:
	
		add $t0, $zero, $zero # zero out t0, use it as a counter

	Loop1:
		sgt $t1, $t0, $s3 # Check if i still < user specified cross-over point
		bne $t1, $zero, Exit1 # if = 0 break
		lb $a0, parent1($t0) # load the element at i to $a0
		sb $a0, child1($t0) # store the element at i babe1
		addi $t0, $t0, 1 # increment i (t0)
		j Loop1 # return to Loop label
	Exit1:
	
	Loop2:
		beq $t0, 17, Exit2
		lb $a0, parent2($t0) # load the element at i to $a0
		sb $a0, child1($t0) # store the element at i babe1
		addi $t0, $t0, 1 # increment i (t0)
		j Loop2 # return to Loop label
	Exit2:	
		jr $ra

#################################copy/swap loop2##############

	copySwap2:
	
		add $t0, $zero, $zero # zero out t0, use it as a counter

	Loop3:
		sgt $t1, $t0, $s3 # Check if i still < user specified cross-over point
		bne $t1, $zero, Exit3 # if = 0 break
		lb $a0, parent2($t0) # load the element at i to $a0
		sb $a0, child2($t0) # store the element at i babe1
		addi $t0, $t0, 1 # increment i (t0)
		j Loop3 # return to Loop label
	Exit3:
	
	Loop4:
		beq $t0, 17, Exit4
		lb $a0, parent1($t0) # load the element at i to $a0
		sb $a0, child2($t0) # store the element at i babe1
		addi $t0, $t0, 1 # increment i (t0)
		j Loop4 # return to Loop label
	Exit4:
		jr $ra

################################print results################

	printResults:
		move $t5, $ra # move the return address into $t5 (otherwise we will cause an infinite loop) restore it before returning to calling routine
		la $a0, congrats # print out congratulatory message to parents
		li $v0, 4 # pass v0 4 to prepare it for a string pringing syscall
		syscall # run the syscall

		jal printCr # return
		
		la $a0, child1 # print out the contents
		li $v0, 4 # load 4 into v0
		syscall	# syscall to finally print
	
		jal printCr # return
	
		la $a0, child2 # print out the contents
		li $v0, 4 # load 4 into v0
		syscall	# syscall to finally print
		move $ra, $t5 # restore address of original calling routine
		jr $ra
		
#################################printCr#################### (carriage return)

	printCr:
		la $a0, prtln # print a return
		li $v0, 4 # print a return
		syscall # print a return
		jr $ra
##################################end####################### (end of program)

	end:
		li $v0, 10 # end the program
		syscall # end the program
