    .include "address_map_nios2.s"
    .text
    .global _start
_start:
    movia   r2, LED_BASE    # Address of LEDs
    movia   r3, SW_BASE     # Address of switches
LOOP:
    ldwio r4, (r3)       # Read the state of switches

    slli r5, r4, 27      # Shifts the bits of the switch register by 27 and stores it
    srli r5, r5, 27      # Shifts the bits back into place

    slli r6, r4, 22
    srli r6, r6, 27

    add r6, r6, r5
    
    stwio r6, (r2)       # Display the state on LEDs
    br LOOP
    .end