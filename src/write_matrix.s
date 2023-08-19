.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

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
    # --- Open the file ---
    addi sp, sp, -12
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    
    addi a1, x0, 1
    jal fopen
    addi t0, x0, -1
    beq a0, t0, exit27
    
    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    addi sp, sp, 12
    # --- End of open the file ---
    
    # --- Write num of rows and columns into the file ---
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    
    # a1 contains the pointer to the number of rows (which is on stack)
    addi a1, sp, 8
    addi a2, x0, 1
    addi a3, x0, 4
    jal fwrite
    addi a2, x0, 1
    bne a0, a2, exit30
    
    lw a0, 0(sp)
    
    # a1 will now contain the pointer to the number of columns (which is on stack)
    addi a1, sp, 12
    addi a2, x0, 1
    addi a3, x0, 4
    jal fwrite
    addi a2, x0, 1
    bne a0, a2, exit30
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    addi sp, sp, 16
    # --- End of Write num of rows and columns into the file ---
    
    # --- Start to write matrix to the file ---
    addi sp, sp, -4
    sw a0, 0(sp)
    
    # We assume that a1 already points to a matrix stored in memory
    mul a2, a2, a3
    addi sp, sp, -4 # Must store a2 because we need to use it to compare later
    sw a2, 0(sp)
    
    addi a3, x0, 4
    jal fwrite
    lw a2, 0(sp)
    addi sp, sp, 4
    bne a0, a2, exit30
    
    lw a0, 0(sp)
    addi sp, sp, 4
    # --- End of write matrix to the file ---

    # --- Begin of close of file ---
    jal fclose
    addi t0, x0, -1
    beq a0, t0, exit28
    # --- End of close of file ---

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
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

exit27:
    addi a0, x0, 27
    j exit
exit28:
    addi a0, x0, 28
    j exit
exit30:
    addi a0, x0, 30
    j exit