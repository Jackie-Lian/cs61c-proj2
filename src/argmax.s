.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
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
    
    addi t4, x0, 1
    blt a1, t4, error
    #t0 is the index of the max value
    addi t0, x0, 0
    #t1 stores the max value seen so far
    lw t1, 0(a0)
    #t2 is the index counter
    addi t2, x0, 0
    
loop_start:
    #a1 goes from end to front to the array
    beq t2, a1, loop_end
    
loop_continue:
    #t3 is the current element in the array
    lw t3, 0(a0)
    blt t3, t1, continue
    beq t3, t1, continue
    mv t0, t2
    mv t1, t3
    
continue:
    addi a0, a0, 4
    addi t2, t2, 1
j loop_start

loop_end:
    # Epilogue
    mv a0, t0
    
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
    
    lw ra 0(sp)
    addi sp, sp, 4
    jr ra

error:
    addi a0, x0, 36
    j exit