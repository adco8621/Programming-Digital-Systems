.text

.global sum_two
sum_two:
    add     r2, r4, r5
    ret

.global op_three
op_three:
    call    op_two
    mov     r4, r2
    mov     r5, r6
    call    op_two
    ret

.global fibonacci
# Caller saved registers used:  r8, r10
fibonacci:
    addi	sp, sp, -0x10
    stw     ra, 12(sp)
    stw     fp, 8(sp)
    addi	fp, sp, 8

    beq		r4, r0, zero
    movi	r8, 1
    beq		r4, r8, one    

    subi	r4, r4, 1
    stw     r4, -4(fp)
    call    fibonacci

    ldw     r4, -4(fp)
    stw     r2, -8(fp)
    subi	r4, r4, 1
    call    fibonacci

    ldw     r10, -8(fp)
    add     r2, r2, r10

    br		fib_out
    


  zero:
    movi	r2, 0
    br		fib_out

  one:
    movi	r2, 1
    br		fib_out

  fib_out:

    mov     sp, fp
    ldw     ra, 4(sp)
    ldw     fp, 0(sp)
    addi    sp, sp, 8   
    ret
    
