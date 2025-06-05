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

    # Open the file
    addi sp, sp, -12
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)

    li a1, 1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, fopen
    lw ra, 0(sp)
    addi sp, sp, 4
    li t2, -1
    beq a0, t2, fopen_except
    mv t0, a0 # file desp
    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    addi sp, sp, 12

    # Write the rows and cols
    
    # Malloc a area to store them
    
    # Malloc
    li a0, 8
    addi sp, sp, -16
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw t0, 12(sp)
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra malloc
    lw ra, 0(sp)
    addi sp, sp, 4
    mv t1, a0 # ptr to array storing r and c
    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    lw t0, 12(sp)
    addi sp, sp, 16

    # Store them
    sw a2, 0(a0)
    sw a3, 4(a0)

    # write rows and cols

    addi sp, sp, -20
    sw a1, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)

    mv a0, t0
    mv a1, t1
    li a2, 2
    li a3, 4

    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, fwrite
    lw ra, 0(sp)
    addi sp, sp, 4

    li t2, 2
    bne t2, a0, fwrite_except

    lw a1, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw a2, 12(sp)
    lw a3, 16(sp)
    addi sp, sp, 20

    # write the matrix
    mul a2, a2, a3
    mv a0, t0
    li a3, 4

    addi sp, sp, -12
    sw t0, 0(sp)
    sw ra, 4(sp)
    sw a2, 8(sp)
    jal ra, fwrite
    lw t0, 0(sp)
    lw ra, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12

    bne a0, a2, fwrite_except

    # Close the file
    mv a0, t0
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, fclose
    lw ra, 0(sp)
    addi sp, sp, 4
    bne x0, a0, fclose_except 









    # Epilogue


    jr ra

fopen_except:
    li a0, 27
    j exit

fwrite_except:
    li a0, 30
    j exit

fclose_except:
    li a0, 28
    j exit