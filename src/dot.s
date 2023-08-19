.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    addi t0, x0, 1 # t0 is an artificial 1
    blt a2, t0, error36 # error 36 cases
    blt a3, t0, error37 # error 37 cases
    blt a4, t0, error37
    mv t1, x0 # t1 tracks the total sum so far
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
    beq a2, x0, loop_end # If a2 has been decremented to 0
    lw t2, 0(a0) # t2 is current element of first array
    lw t3, 0(a1) # t3 is current element of second array
    mul t4, t2, t3
    add t1, t1, t4 # t1 += t4
    
    # Need to modify a0 and a1
    slli t5, a3, 2 # t5 is the offset step size (measured in bytes)
    add a0, a0, t5
    slli t5, a4, 2
    add a1, a1, t5
    
    addi a2, a2, -1 # a2 decrements by 1
    j loop_start # Goes back to start of loop

loop_end:
    mv a0, t1 # Moves the result back to the a0
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
    
error36:
    addi a0, x0, 36
    j exit
    
error37:
    addi a0, x0, 37
    j exit