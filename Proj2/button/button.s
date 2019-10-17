.global _start

_start:

    movia		r2, 0xff200020
    movia		r3, RTL
    movia       r4, LTR
    movia       r5, 0xff200050
    movi		r6, 8
    movi		r7, 0
    movi		r8, 32767

right_left:

    movi		r9, 0
    ldw         r8, 0(r3)
    addi		r3, r3, 4
    slli		r7, r7, 8
    add		    r7, r7, r8
    stwio		r7, 0(r2)
    call		delay
    bne	    	r12, r0, left_right
    subi		r6, r6, 1
    blt         r0, r6, right_left
    movi		r7, 0
    movi		r6, 8
    movia		r3, RTL
    br	    	right_left




left_right:

    movi		r9, 1
    ldw         r8, 0(r4)
    addi		r4, r4, 4
    srli		r7, r7, 8
    slli		r8, r8, 24
    add		    r7, r7, r8
    stwio		r7, 0(r2)
    call		delay
    beq	    	r12, r0, right_left
    subi		r6, r6, 1
    blt         r0, r6, left_right
    movi		r7, 0
    movi		r6, 8
    movia		r4, LTR
    br	    	left_right



switch:

    movi		r7, 0
    movi		r6, 8
    movia		r3, RTL
    movia       r4, LTR
    ldwio       r10, 0(r5)
    bgt         r10, r0, switch
    cmpeq		r12, r9, r0
    br		    delay_ret


delay:
    subi		r13, r13, 1
    ldwio       r10, 0(r5)
    bgt         r10, r0, switch
  delay_ret:
    bgt         r13, r0, delay
    movi        r13, 32767
    subi		r11, r11, 1
    bgt         r11, r0, delay
    movi		r11, 100

    ret


.data

RTL:
    .word 0b01111001, 0b01001001, 0b01001001, 0b01001001, 0b00000000, 0b00000000, 0b00000000, 0b00000000
LTR:
    .word 0b01001111, 0b01001001, 0b01001001, 0b01001001, 0b00000000, 0b00000000, 0b00000000, 0b00000000