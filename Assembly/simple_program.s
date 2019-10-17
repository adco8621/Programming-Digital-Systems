.include    "address_map_nios2.s" 

.text        

.global     _start 
_start:                         
        movia   r2, LED_BASE    # Address of LEDs
        movia   r3, SW_BASE     # Address of switches

LOOP:                           
        ldwio   r4, (r3)        # Read the state of switches
        stwio   r4, (r2)        # Display the state on LEDs
        br      LOOP            

.end         
