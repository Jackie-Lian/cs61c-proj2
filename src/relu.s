.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi t1, x0, 1
    blt a1, t1, error
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
    
loop_start:
    beq a1, x0, loop_end
    lw t0, 0(a0)

loop_continue:
    blt t0, x0, continue
    j else

continue:
    sw x0, 0(a0)

else:
    addi a0, a0, 4
    addi a1, a1, -1
    j loop_start

loop_end:
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
    
    lw ra 0(sp)
    addi sp, sp, 4
    jr ra

error:
    li a0 36
    j exit
    
    