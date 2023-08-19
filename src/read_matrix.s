.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)
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
    
    # save registers
    addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
    addi a1, x0, 0
    jal fopen
    addi t0, x0, -1
    beq a0, t0, exit27
    lw a1, 0(sp)
    lw a2, 4(sp)
    addi sp, sp, 8
    
    # make a1 store the number of rows
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    addi a2, x0, 4
    jal fread
    addi t0, x0, 4
    bne a0, t0, exit29
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12
    
    #make a2 store the number of columns
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    mv a1, a2
    addi a2, x0, 4
    jal fread
    addi t0, x0, 4
    bne a0, t0, exit29
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12
    
    # malloc space for matrix
    lw t1, 0(a1)
    lw t2, 0(a2)
    mul t0, t1, t2
    slli t0, t0, 2
    
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw t0, 8(sp)
    
    mv a0, t0
    jal malloc
    beq a0, x0, exit26
    mv a4, a0
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw t0, 8(sp)
    addi sp, sp, 12
    
    # call fread to read the matrix
    addi sp, sp, -20
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw t0, 8(sp)
    sw a0, 12(sp)
    sw a4, 16(sp)
    
    mv a1, a4
    mv a2, t0
    jal fread
    lw t0, 8(sp)
    bne a0, t0, exit29
    
    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a0, 12(sp)
    lw a4, 16(sp)
    addi sp, sp, 20
    
    # close the file
    addi sp, sp, -8
    sw a0, 0(sp)
    sw a4, 4(sp)
    jal fclose
    addi t0, x0, -1
    beq a0, t0, exit28
    lw a0, 0(sp)
    lw a4, 4(sp)
    addi sp, sp, 8
    mv a0, a4
    
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    addi sp, sp, 36
    
    lw ra, 0(sp)
    addi sp, sp, 4
    
    jr ra
    # Epilogue
exit29:
    addi a0, x0, 29
    j exit
exit28:
    addi a0, x0, 28
    j exit
exit27:
    addi a0, x0, 27
    j exit
exit26:
    addi a0, x0, 26
    j exit
    
