.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    addi t0, x0, 1
    blt a1, t0, error38
    blt a2, t0, error38
    blt a4, t0, error38
    blt a5, t0, error38
    bne a2, a4, error38
    
    mul t2, a1, a5 #t2 is the number of elements in the resulting matrix (descending)
    #a1 never changes
    #save ra
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
    
outer_loop_start:
    beq t2, x0, outer_loop_end
    mv t5, x0 # column counter in the 2nd array (ascending), initialized to 0
    
inner_loop_start:
    #increment column counter(t5)
    beq t5, a5, inner_loop_end
    #function call starts
    addi sp, sp, -40
    
    sw a6, 36(sp)
    sw a5, 32(sp)
    sw t5, 28(sp)
    sw t2, 24(sp)
    sw ra, 20(sp) # save the return address
    sw a4, 16(sp)
    sw a3, 12(sp)
    sw a2, 8(sp)
    sw a1, 4(sp)
    sw a0, 0(sp)
    
    #a1 = a3 + t5 * 4
    addi t4, x0, 4
    mul t4, t4, t5
    add t4, t4, a3
    
    mv a1, t4
    addi a3, x0, 1
    mv a4, a5
    #function call
    jal dot
    
    #t4 temporarily stores the return value of the function call
    mv t4, a0
    
    #restore all arguments
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw ra, 20(sp)
    lw t2, 24(sp)
    lw t5, 28(sp)
    lw a5, 32(sp)
    lw a6, 36(sp)
    
    addi sp, sp, 40
    
    #everything restored
    sw t4, 0(a6) #store the return value to the corresponding entry in resulting array
    addi a6, a6, 4 #increment a6 to the next entry in the resulting array
    
    #inner loop continues, update arguments (t5, t2)
    addi t5, t5, 1
    addi t2, t2, -1
    j inner_loop_start

inner_loop_end:
    #update a0
    add t4, x0, a2
    addi t6, x0, 4
    mul t6, t6, t4
    add a0, a0, t6
    
    j outer_loop_start 
    
outer_loop_end:
    # Epilogue
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
    
    #load ra
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

error38:
    addi a0, x0, 38
    j exit