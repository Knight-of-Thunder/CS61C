.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    addi t5, x0, 1
    blt a1, t5, except
    lw t0 0(a0) # max
    mv t1, x0 # index
    mv t4, x0 # max_idx

loop_start:
    beq t1, a1, loop_end
    lw t2 0(a0)
    bgt t2, t0, change_max
    j loop_continue

change_max:
    mv t0, t2
    mv t4, t1
    j loop_continue

loop_continue:
    addi t1, t1, 1
    addi a0, a0, 4
    j loop_start

loop_end:
    # Epilogue
    mv a0, t4
    jr ra

except:
    li a0, 36
    j exit