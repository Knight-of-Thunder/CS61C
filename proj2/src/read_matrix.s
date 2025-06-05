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
    addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
    # Open the file
    li a1, 0
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, fopen
    lw ra, 0(sp)
    addi sp, sp, 4
    lw a1, 0(sp)
    lw a2, 4(sp)
    addi sp ,sp, 8

    li t2, -1   # use t2 to determine except, tp
    beq t2, a0, fopen_except
    mv t0, a0   # file descriptor


    # Get the rows
    mv a0, t0
    # notice
    # mv a1, a1
    addi sp, sp, -12
    sw t0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    addi sp, sp, -4
    sw ra, 0(sp)
    li a2, 4
    jal ra, fread
    lw ra, 0(sp)
    addi sp, sp, 4
    lw t0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp ,sp, 12

    li t2, 4    # tp
    bne a0, t2, fread_excecpt

    lw t4, 0(a1)    # rows
    
    # Get the cols
    mv a0, t0
    # notice
    # mv a1, a1
    addi sp, sp, -16
    sw t0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw t4, 12(sp)
    addi sp, sp, -4
    sw ra, 0(sp)
    mv a1, a2
    li a2, 4
    jal ra, fread
    lw ra, 0(sp)
    addi sp, sp, 4
    lw t0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw t4, 12(sp)
    addi sp ,sp, 16

    li t2, 4    # tp
    bne a0, t2, fread_excecpt

    lw t3, 0(a2)    # cols


    mul t3, t3, t4 # mat size, later will also be used, so keep it
    li t2, 4
    mul t2, t3, t2  # the byte size of mat

    # Malloc the matrix
    mv a0, t2
    addi sp, sp, -12
    sw t0, 0(sp)
    sw t3, 4(sp)
    sw ra, 8(sp)
    jal ra, malloc
    lw t0, 0(sp)
    lw t3, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12
    li t2, 0
    beq t2, a0, malloc_except

    mv t4, a0   # ptr to matrix

    # Fill the matrix

    mv t1, x0   # index to matrix
    mv t5, t4   # ptr: to iterate the matrix

read_loop:
    beq t1, t3, read_end
    mv a0, t0
    li a2, 4
    mv a1, t5
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t3, 4(sp)
    sw ra, 8(sp)
    sw t5, 12(sp)
    sw t1, 16(sp)
    sw t4, 20(sp)
    jal ra, fread
    lw t0, 0(sp)
    lw t3, 4(sp)
    lw ra, 8(sp)
    lw t5, 12(sp)
    lw t1, 16(sp)
    lw t4, 20(sp)
    addi sp, sp, 24
    li t2, 4
    bne a0, t2, fread_excecpt
    addi t5, t5, 4
    addi t1, t1, 1
    j read_loop

read_end:

    # Close the file
    mv a0, t0
    addi sp, sp, -8
    sw t4, 0(sp)
    sw ra, 4(sp)
    jal ra, fclose
    lw t4, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    bne x0, a0, fclose_except 

    # Epilogue
    mv a0, t4
    jr ra


fread_excecpt:
    li a0, 29
    j exit

malloc_except:
    li a0, 26
    j exit

fopen_except:
    li a0, 27
    j exit

fclose_except:
    li a0, 28
    j exit