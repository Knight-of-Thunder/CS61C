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
    addi t0, x0, 1
    blt a1, t0, except
    mv t0, x0   # index to the array
    j loop_start

loop_start:
    beq t0, a1, loop_end
    lw t1 0(a0)
    blt t1, x0, zerolize
    j loop_continue

except:
    li a0, 36
    j exit

zerolize:
    sw x0 0(a0)
    j loop_continue


loop_continue:
    addi t0, t0, 1
    addi a0, a0, 4
    j loop_start


loop_end:


    # Epilogue


    jr ra
    