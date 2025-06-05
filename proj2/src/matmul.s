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
    blt a1, t0, invalid_mat_except
    blt a2, t0, invalid_mat_except
    blt a4, t0, invalid_mat_except
    blt a5, t0, invalid_mat_except

    bne a2, a4, invalid_mul_except
    
    # Prologue


    mv t0, a0   # ptr to array0
    mv t1, a3   # ptr to array1
    mv t2, a1 
    mv t3, a5
    mv t5, x0
    mv t6, x0

    
    addi sp, sp, -4
    sw s0, 0(sp)
    mv s0, a3

    li a3, 1
    mv a4, a5

outer_loop_start:
    beq t5, t2, outer_loop_end
    j inner_loop_start

inner_loop_start:
    beq t6, t3, inner_loop_end
    mv a0, t0
    mv a1, t1
    addi sp, sp, -4
    sw a2, 0(sp)
    addi sp, sp, -4
    sw t0, 0(sp)
    addi sp, sp, -4
    sw t1, 0(sp)
    addi sp, sp, -4
    sw t2, 0(sp)
    addi sp, sp, -4
    sw t3, 0(sp)
    addi sp, sp, -4
    sw t5, 0(sp)
    addi sp, sp, -4
    sw t6, 0(sp)
    addi sp, sp, -4
    sw a3, 0(sp)
    addi sp, sp, -4
    sw a4, 0(sp)
    addi sp, sp, -4
    sw t4, 0(sp)
    addi sp, sp, -4
    sw a6, 0(sp)
    addi sp, sp, -4
    sw ra, 0(sp)            
    

    jal ra, dot
    
    lw ra, 0(sp)
    addi sp, sp, 4
    lw a6, 0(sp)
    addi sp, sp, 4
    lw t4, 0(sp)
    addi sp, sp, 4
    lw a4, 0(sp)
    addi sp, sp, 4
    lw a3, 0(sp)
    addi sp, sp, 4
    lw t6, 0(sp)
    addi sp, sp, 4
    lw t5, 0(sp)
    addi sp, sp, 4
    lw t3, 0(sp)
    addi sp, sp, 4
    lw t2, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)         
    addi sp, sp, 4
    lw t0, 0(sp)
    addi sp, sp, 4  
    lw a2, 0(sp)
    addi sp, sp, 4

    mul t4, t5, t3
    add t4, t4, t6
    slli t4, t4, 2
    add t4, t4, a6
    sw a0, 0(t4)

    addi t6, t6, 1

    addi t1, t1, 4

    j inner_loop_start

inner_loop_end:
    li t6, 0 
    mv t1, s0
    addi t5, t5, 1
    slli t4, a2, 2
    add t0, t0, t4 
    j outer_loop_start

outer_loop_end:
    # Epilogue
    
    lw s0, 0(sp)
    addi sp, sp, 4

    jr ra

invalid_mat_except:
    li a0, 38
    j exit

invalid_mul_except:
    li a0, 38
    j exit