.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
#   a0 (int*) is a pointer to the input integer
# Returns:
#   None
# =================================================================
abs:
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
    # Load number from memory
    lw t0 0(a0)
    ebreak 
    bge t0, zero, done

    # Negate a0
    sub t0, x0, t0

    # Store number back to memory
    sw t0 0(a0)
done:
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
  ret

