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
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    
    # Prologue
    li t0, 1
    blt a2, t0, num_except
    blt a3, t0, stride_except
    blt a4, t0, stride_except

    li t0, 4          
    mul t4, t0, a3 # first gap
    mul t5, t0, a4 # second gap

    mv t0, x0 # sum
    mv t1, x0 # idx
    



loop_start:
    bge t1, a2, loop_end
    lw t2, 0(a0)
    lw t3, 0(a1)
    mul t2, t2, t3
    add t0, t0, t2
    add a0, a0, t4
    add a1, a1, t5
    addi t1, t1, 1
    j loop_start

loop_end:

    # Epilogue
    mv a0, t0

    jr ra

num_except:
    li a0 36
    j exit

stride_except:
    li a0 37
    j exit