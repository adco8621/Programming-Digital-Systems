.global _start

# refer to button.s one folder up for a similar program for comments

_start:

    movia       r2, 0xff200020  # HEX addr
    movia       r3, TEXT        # scrolling text in memory
    movia       r4, PATTERN1    # patterns a & b
    movia       r5, PATTERN2    # pattern c

    mov		    r6, r0
    movi		r7, 0x11
    movi        r8, 32767
    movi		r11, 500

text_scroll:
    ldw	    	r9, 0(r3)
    stwio		r9, 0(r2)
    call        delay

ts:
    addi		r3, r3, 4
    slli        r9, r9, 8
    ldw         r10, 0(r3)
    add	    	r9, r9, r10
    stwio		r9, 0(r2)
    addi        r6, r6, 1
    beq		    r6, r7, pattern
    call	    delay
    br		    ts

pattern:   
    ldw         r9, 0(r4)
    stwio       r9, 0(r2)
    call        delay
    ldw         r9, 4(r4)
    stwio       r9, 0(r2)
    call        delay
    ldw         r9, 0(r4)
    stwio       r9, 0(r2)
    call        delay
    ldw         r9, 4(r4)
    stwio       r9, 0(r2)
    call        delay
    ldw         r9, 0(r4)
    stwio       r9, 0(r2)
    call        delay
    ldw         r9, 4(r4)
    stwio       r9, 0(r2)
    call        delay
    ldw         r9, 0(r5)
    stwio       r9, 0(r2)
    call        delay
    stwio       r0, 0(r2)
    call        delay
    ldw         r9, 0(r5)
    stwio       r9, 0(r2)
    call        delay
    stwio       r0, 0(r2)
    call        delay
    ldw         r9, 0(r5)
    stwio       r9, 0(r2)
    call        delay
    stwio       r0, 0(r2)
    call        delay
    br          _start
    


delay:
    subi		r8, r8, 1
    bgt         r8, r0, delay
    movi        r8, 32767
    subi		r11, r11, 1
    bgt         r11, r0, delay
    movi		r11, 500

    ret

.data
PATTERN1:
    .word 0b01001001010010010100100101001001, 0b00110110001101100011011000110110

PATTERN2:
    .word 0b01111111011111110111111101111111

TEXT:
    .word 0b01110110, 0b01111001, 0b00111000, 0b00111000, 0b00111111, 0b00000000, 0b01111100, 0b00111110, 0b01110001, 0b01110001, 0b01101101, 0b01000000, 0b01000000, 0b01000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000