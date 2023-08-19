.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi t0, x0, 5
    bne a0, t0, exit31
    addi sp, sp, -4
    sw ra 0(sp)
    addi sp, sp, -36
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    # ----Read pretrained m0----
    addi sp, sp, -8
    sw a1 0(sp)
    sw a2 4(sp)
    # malloc space for arguments for read_matrix
    addi t0, x0, 4
    mv a0, t0
    jal malloc
    beq a0, x0, exit26
    mv s0, a0 #s0 stores the pointer of m0's number of rows
    
    addi t0, x0, 4
    mv a0, t0
    jal malloc
    beq a0, x0, failExit7
    mv s1, a0 #s1 stores the pointer of m0's number of columns
    
    lw a1 0(sp)
    lw a2 4(sp)
    addi sp, sp, 8
    
    # use read_matrix 
    addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
    
    lw a0, 4(a1)
    mv a1, s0
    mv a2, s1
    jal read_matrix
    mv t3, a0 #t3 stores m0
    
    lw a1, 0(sp)
    lw a2, 4(sp)
    addi sp, sp, 8
    
    #----Read pretrained m1----
    addi sp, sp, -12
    sw a1 0(sp)
    sw a2 4(sp)
    sw t3, 8(sp)
    # malloc space for arguments for read_matrix
    addi t0, x0, 4
    mv a0, t0
    jal malloc
    beq a0, x0, failExit6
    mv s2, a0 #s2 stores the pointer to m1's number of rows of m0

    addi t0, x0, 4
    mv a0, t0
    jal malloc
    beq a0, x0, failExit5
    mv s3, a0 #s3 stores the pointer to m1's number of columns
    
    lw a1 0(sp)
    lw a2 4(sp)
    lw t3, 8(sp)
    addi sp, sp, 12
    
    # use read_matrix 
    addi sp, sp, -12
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw t3, 8(sp)
    
    lw a0, 8(a1)
    mv a1, s2
    mv a2, s3
    jal read_matrix
    mv t4, a0 #t4 stores m1
    
    lw a1, 0(sp)
    lw a2, 4(sp)
    lw t3, 8(sp)
    addi sp, sp, 12

    # -----Read input matrix-----
    addi sp, sp, -16
    sw a1 0(sp)
    sw a2 4(sp)
    sw t3, 8(sp)
    sw t4, 12(sp)
    # malloc space for arguments for read_matrix
    addi t0, x0, 4
    mv a0, t0
    jal malloc
    beq a0, x0, failExit4
    mv s4, a0 #s4 stores the pointer of input matrix's number of rows
    
    addi t0, x0, 4
    mv a0, t0
    jal malloc
    beq a0, x0,failExit3
    mv s5, a0 #s5 stores the pointer of input matrix's number of columns
    
    lw a1 0(sp)
    lw a2 4(sp)
    lw t3, 8(sp)
    lw t4, 12(sp)
    addi sp, sp, 16
    
    # use read_matrix 
    addi sp, sp, -16
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw t3, 8(sp)
    sw t4, 12(sp)
    
    lw a0, 12(a1)
    mv a1, s4
    mv a2, s5
    jal read_matrix
    mv t5, a0 #t5 stores input
    
    lw a1, 0(sp)
    lw a2, 4(sp)
    lw t3, 8(sp)
    lw t4, 12(sp)
    addi sp, sp, 16

    #----Compute h = matmul(m0, input)----
    #save a1, a2, t3, t4, t5 before calling matmul
    addi sp, sp, -20
    sw a1 0(sp)
    sw a2 4(sp)
    sw t3 8(sp)
    sw t4 12(sp)
    sw t5 16(sp)
    
    #malloc space for h
    lw t0, 0(s0) #number of rows of m0
    lw t1, 0(s5) #number of columns of input 
    mul a0, t0, t1
    slli a0, a0, 2 #total number of bytes passed to malloc
    jal malloc
    beq a0, x0, failExit2
    mv a6, a0 #a6 is the pointer to result array
    mv s6, a0 #s6 stores the pointer to result array
    lw t3, 8(sp) #load t3 and t5 back after calling malloc
    lw t5, 16(sp)
    
    mv a0, t3
    lw a1, 0(s0)
    lw a2, 0(s1)
    mv a3, t5
    lw a4, 0(s4)
    lw a5, 0(s5)
    jal matmul
    
    #load a1, a2, t3, t4, t5 back
    lw a1 0(sp)
    lw a2 4(sp)
    lw t3 8(sp)
    lw t4 12(sp)
    lw t5 16(sp)
    addi sp, sp, 20
    
    #----Compute h = relu(h)----
    #save a1, a2, t3, t4, t5 before calling matmul
    addi sp, sp, -20
    sw a1 0(sp)
    sw a2 4(sp)
    sw t3 8(sp)
    sw t4 12(sp)
    sw t5 16(sp)
    
    #call relu
    mv a0, s6
    lw t0, 0(s0) #number of rows of m0
    lw t1, 0(s5) #number of columns of input 
    mul a1, t0, t1
    jal relu
    
    #load a1, a2, t3, t4, t5 back
    lw a1 0(sp)
    lw a2 4(sp)
    lw t3 8(sp)
    lw t4 12(sp)
    lw t5 16(sp)
    addi sp, sp, 20
    

    #----Compute o = matmul(m1, h)----
    #save a1, a2, t3, t4, t5 before calling matmul
    addi sp, sp, -20
    sw a1 0(sp)
    sw a2 4(sp)
    sw t3 8(sp)
    sw t4 12(sp)
    sw t5 16(sp)
    
    #call matmul 
    lw t0, 0(s2) #number of rows of m1
    lw t1, 0(s5) #number of columns of result
    mul a0, t0, t1
    slli a0, a0, 2 #total number of bytes passed to malloc
    jal malloc
    beq a0, x0, failExit1
    mv a6, a0 #a6 is the pointer to result array
    mv s7, a0 #s7 stores the pointer to output array
    lw t3, 8(sp) #load t3 and t5 back after calling malloc
    lw t4, 12(sp)
    lw t5, 16(sp)
    
    mv a0, t4
    lw a1, 0(s2)
    lw a2, 0(s3)
    mv a3, s6
    lw a4, 0(s0)
    lw a5, 0(s5)
    jal matmul
    #load a1, a2, t3, t4, t5 back
    lw a1 0(sp)
    lw a2 4(sp)
    lw t3 8(sp)
    lw t4 12(sp)
    lw t5 16(sp)
    addi sp, sp, 20
    
    #----Write output matrix o----
    #save a1, a2, t3, t4, t5 before calling matmul
    addi sp, sp, -20
    sw a1 0(sp)
    sw a2 4(sp)
    sw t3 8(sp)
    sw t4 12(sp)
    sw t5 16(sp)
    
    #call write_matrix
    lw a0, 16(a1) #a0 is the pointer to output file
    mv a1, s7
    lw a2, 0(s2)
    lw a3, 0(s5)
    jal write_matrix
   
    
    #load a1, a2, t3, t4, t5 back
    lw a1 0(sp)
    lw a2 4(sp)
    lw t3 8(sp)
    lw t4 12(sp)
    lw t5 16(sp)
    addi sp, sp, 20
    #----Compute and return argmax(o)----
    #save a1, a2, t3, t4, t5 before calling
    addi sp, sp, -20
    sw a1 0(sp)
    sw a2 4(sp)
    sw t3 8(sp)
    sw t4 12(sp)
    sw t5 16(sp)
    
    #call argmax
    mv a0, s7
    lw t0, 0(s2) #number of rows of m1
    lw t1, 0(s5) #number of columns of output
    mul a1, t0, t1
    jal argmax
    mv s8, a0
  
    #load a1, a2, t3, t4, t5 back
    lw a1 0(sp)
    lw a2 4(sp)
    lw t3 8(sp)
    lw t4 12(sp)
    lw t5 16(sp)
    addi sp, sp, 20
   

    # If enabled, print argmax(o) and newline
    bne a2, x0, done

    addi sp, sp, -12
    sw t3 0(sp)
    sw t4 4(sp)
    sw t5 8(sp)

    jal print_int
    li a0 '\n'
    jal print_char
    
    lw t3 0(sp)
    lw t4 4(sp)
    lw t5 8(sp)
    addi sp, sp, 12
    
done:
    #free s0-s7, t3-t5
    addi sp, sp, -12
    sw t3 0(sp)
    sw t4 4(sp)
    sw t5 8(sp)
    
    mv a0, s0
    jal free
    mv a0, s1
    jal free
    mv a0, s2
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    lw t3 0(sp)
    mv a0, t3
    jal free
    lw t4 4(sp)
    mv a0, t4
    jal free
    lw t5 8(sp)
    mv a0, t5
    jal free
    
#     lw t3 0(sp)
#     lw t4 4(sp)
#     lw t5 8(sp)
    addi sp, sp, 12
    
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    mv a0, s8
    lw s8 32(sp)
    addi sp, sp, 36
    lw ra 0(sp)
    addi sp, sp, 4
    jr ra
exit31:
    addi a0, x0, 31
    j exit

failExit1:
    mv a0, s6
    jal free
    lw t5 16(sp)
    mv a0, t5
    jal free
failExit2:
    mv a0, s6
    jal free
failExit3:
    mv a0, s5
    jal free
    lw t4 12(sp)
    mv a0, t4
    jal free
failExit4:
    mv a0, s3
    jal free
failExit5:
    mv a0, s2
    jal free
    lw t3 8(sp)
    mv a0, t3
    jal free
failExit6:
    mv a0, s1
    jal free
failExit7:
    mv a0, s0
    jal free
exit26:
    addi a0, x0, 26
    j exit

