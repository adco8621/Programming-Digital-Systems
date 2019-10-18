.global _start


# TODO: make in NIOS II standard for registers
_start:

    movia		r2, 0xff200020      # 7 seg disp addr
    movia		r3, RTL             # right to left pattern
    movia       r4, LTR             # left to right pattern
    movia       r5, 0xff200050      # button addr
    movi		r6, 8               # iterator max for each pattern
    movi		r7, 0               # setting to 0 (dont think is necessary)
    movi		r8, 32767           # for delay (could have used movia for bigger num)

right_left:

    movi		r9, 0               # indicator for rtl pattern
    ldw         r8, 0(r3)           # pull next item to display
    addi		r3, r3, 4           # shift data to load
    slli		r7, r7, 8           # shift data to display
    add		    r7, r7, r8          # add current disp to next disp
    stwio		r7, 0(r2)           # disp next
    call		delay               # delay
    bne	    	r12, r0, left_right # check if button pressed
    subi		r6, r6, 1           # iterator for item to display
    blt         r0, r6, right_left  # pass this if looping pattern
    movi		r7, 0               # reset display reg
    movi		r6, 8               # reset iterator
    movia		r3, RTL             # reset RTL addr
    br	    	right_left          # start over




left_right:

    movi		r9, 1               # indicator for ltr pattern
    ldw         r8, 0(r4)           # same stuff as above except moving the other direction
    addi		r4, r4, 4
    srli		r7, r7, 8
    slli		r8, r8, 24
    add		    r7, r7, r8
    stwio		r7, 0(r2)
    call		delay
    beq	    	r12, r0, right_left # check if button press
    subi		r6, r6, 1
    blt         r0, r6, left_right
    movi		r7, 0
    movi		r6, 8
    movia		r4, LTR
    br	    	left_right



switch:

    movi		r7, 0               # reset disp registers
    movi		r6, 8
    movia		r3, RTL
    movia       r4, LTR
    ldwio       r10, 0(r5)          # check if button is being held
    bgt         r10, r0, switch     # keep looping till button release
    cmpeq		r12, r9, r0         # check pattern last displayed
    br		    delay_ret           # resume delay


delay:
    subi		r13, r13, 1         # do stuff to delay the cpu
    ldwio       r10, 0(r5)          # check if button press
    bgt         r10, r0, switch     # if button press goto
  delay_ret:                        # come back from button press mode
    bgt         r13, r0, delay      # more regular delay
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