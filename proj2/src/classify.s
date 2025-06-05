.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi sp, sp, -48
    sw s0, 0(sp)    # row of m0 == row of h
    sw s1, 4(sp)    # col of m0
    sw s2, 8(sp)    # m0
    sw s3, 12(sp)   # m1
    sw s4, 16(sp)   # input m
    sw s5, 20(sp)   # row of m1 == row of o
    sw s6, 24(sp)   # col of m1
    sw s7, 28(sp)   # row of input m
    sw s8, 32(sp)   # col of input m == col of h == col of o
    sw s9, 36(sp)   # h
    sw s10, 40(sp)  # o
    sw s11, 44(sp)

    li t0, 5
    bne t0, a0, arg_num_except
    
    lw t0, 4(a1)    # file containing m0
    lw t1, 8(a1)    # file containing m1
    lw t2, 12(a1)   # input file
    lw t3, 16(a1)   # output file
    mv t4, a2   # silent mode

    # Create space for read_matrix pointer args
    # ptr for m0
    # ptr 1
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw ra, 20(sp)
    
    li a0, 4
    jal malloc
    beq a0, x0, malloc_except
    mv s0, a0
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    # ptr 2
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw ra, 20(sp)
    
    li a0, 4
    jal malloc
    beq a0, x0, malloc_except
    mv s1, a0
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    # ptr for m1
    # ptr 1
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw ra, 20(sp)
    
    li a0, 4
    jal malloc
    beq a0, x0, malloc_except
    mv s5, a0
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    # ptr 2
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw ra, 20(sp)
    
    li a0, 4
    jal malloc
    beq a0, x0, malloc_except
    mv s6, a0
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    # ptr for input m
    # ptr 1
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw ra, 20(sp)
    
    li a0, 4
    jal malloc
    beq a0, x0, malloc_except
    mv s7, a0
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    # ptr 2
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw ra, 20(sp)
    
    li a0, 4
    jal malloc
    beq a0, x0, malloc_except
    mv s8, a0
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24
    
    # Read pretrained m0
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw ra, 20(sp)
    
    mv a0, t0
    mv a1, s0
    mv a2, s1
    jal ra read_matrix
    mv s2, a0
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    # Read pretrained m1
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw ra, 20(sp)
    
    mv a0, t1
    mv a1, s5
    mv a2, s6
    jal ra read_matrix
    mv s3, a0
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24    
    
    # Read input matrix
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw ra, 20(sp)
    
    mv a0, t2
    mv a1, s7
    mv a2, s8
    jal ra read_matrix
    mv s4, a0
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24    

    # Compute h = matmul(m0, input)
    # malloc area for h
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw ra, 20(sp)
    
    lw a0, 0(s0)
    lw a1, 0(s8)
    mul a0, a0, a1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, malloc_except
    mv s9, a0
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24
    
    # h = matmul(m0, input)
    mv a0, s2
    lw a1, 0(s0)
    lw a2, 0(s1)
    mv a3, s4
    lw a4, 0(s7)
    lw a5, 0(s8)
    mv a6, s9
    addi sp, sp, -12
    sw t3, 0(sp)
    sw t4, 4(sp)
    sw ra, 8(sp)
    jal ra, matmul
    lw t3, 0(sp)
    lw t4, 4(sp)
    lw ra, 8(sp)   
    addi sp, sp, 12
   
    # Compute h = relu(h)
    lw a0, 0(s0)
    lw a1, 0(s8)
    mul a1, a0, a1 
    mv a0, s9
    addi sp, sp, -12
    sw t3, 0(sp)
    sw t4, 4(sp)
    sw ra, 8(sp)
    jal ra, relu
    lw t3, 0(sp)
    lw t4, 4(sp)
    lw ra, 8(sp)   
    addi sp, sp, 12
    
    # Compute o = matmul(m1, h)
    # malloc area for o
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw ra, 20(sp)
    
    lw a0, 0(s5)
    lw a1, 0(s8)
    mul a0, a0, a1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, malloc_except
    mv s10, a0
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    # o = matmul(m1, h)
    mv a0, s3
    lw a1, 0(s5)
    lw a2, 0(s6)
    mv a3, s9
    lw a4, 0(s0)
    lw a5, 0(s8)
    mv a6, s10
    addi sp, sp, -12
    sw t3, 0(sp)
    sw t4, 4(sp)
    sw ra, 8(sp)
    jal ra, matmul
    lw t3, 0(sp)
    lw t4, 4(sp)
    lw ra, 8(sp)   
    addi sp, sp, 12

    # Write output matrix o
    mv a0, t3
    mv a1, s10
    lw a2, 0(s5)
    lw a3, 0(s8)
    addi sp, sp, -8
    sw t4, 0(sp)
    sw ra, 4(sp)
    jal write_matrix
    lw t4, 0(sp)
    lw ra, 4(sp)   
    addi sp, sp, 8
    # Compute and return argmax(o)
    lw a0, 0(s5)
    lw a1, 0(s8)
    mul a1, a0, a1
    mv a0, s10
    addi sp, sp, -8
    sw t4, 0(sp)
    sw ra, 4(sp)
    jal ra, argmax
    lw t4, 0(sp)
    lw ra, 4(sp)   
    addi sp, sp, 8
    # If enabled, print argmax(o) and newline
    bne x0, t4, no_print
    mv t0, a0

    addi sp, sp, -8
    sw ra, 0(sp)
    sw t0, 4(sp)
    jal ra print_int
    lw ra, 0(sp)
    lw t0, 4(sp)
    addi sp, sp, 8

    addi sp, sp, -8
    sw ra, 0(sp)
    sw t0, 4(sp)
    li a0 '\n'
    jal ra print_char
    lw ra, 0(sp)
    lw t0, 4(sp)
    addi sp, sp, 8

    mv a0, t0

no_print:
    mv s11, a0
    # Free the allocated blocks
    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, s0
    jal ra free
    lw ra, 0(sp)
    addi sp, sp, 4  

    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, s1
    jal ra free
    lw ra, 0(sp)
    addi sp, sp, 4  
    
    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, s2
    jal ra free
    lw ra, 0(sp)
    addi sp, sp, 4  

    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, s3
    jal ra free
    lw ra, 0(sp)
    addi sp, sp, 4  

    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, s4
    jal ra free
    lw ra, 0(sp)
    addi sp, sp, 4  

    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, s5
    jal ra free
    lw ra, 0(sp)
    addi sp, sp, 4  

    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, s6
    jal ra free
    lw ra, 0(sp)
    addi sp, sp, 4  

    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, s7
    jal ra free
    lw ra, 0(sp)
    addi sp, sp, 4  

    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, s8
    jal ra free
    lw ra, 0(sp)
    addi sp, sp, 4  

    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, s9
    jal ra free
    lw ra, 0(sp)
    addi sp, sp, 4  

    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, s10
    jal ra free
    lw ra, 0(sp)
    addi sp, sp, 4  
    
    mv a0, s11
    
    lw s0, 0(sp)    # row of m0 == row of h
    lw s1, 4(sp)    # col of m0
    lw s2, 8(sp)    # m0
    lw s3, 12(sp)   # m1
    lw s4, 16(sp)   # input m
    lw s5, 20(sp)   # row of m1 == row of o
    lw s6, 24(sp)   # col of m1
    lw s7, 28(sp)   # row of input m
    lw s8, 32(sp)   # col of input m == col of h == col of o
    lw s9, 36(sp)   # h
    lw s10, 40(sp)  # o
    lw s11, 44(sp)
    addi sp, sp, 48
    

    jr ra
arg_num_except:
    li a0, 31
    j exit

malloc_except:
    li a0, 26
    j exit