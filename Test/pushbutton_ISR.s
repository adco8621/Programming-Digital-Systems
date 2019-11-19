.include    "address_map_nios2.s"           
.include    "globals.s"                     
.extern     PATTERN                         # externally defined variables
.extern     SHIFT_DIR                       
/*******************************************************************************
 * Pushbutton - Interrupt Service Routine
 *
 * This routine checks which KEY has been pressed and updates the global
 * variables as required.
 ******************************************************************************/
.global     PUSHBUTTON_ISR                  
PUSHBUTTON_ISR:                                 
        subi    sp, sp, 20                      # reserve space on the stack
        stw     ra, 0(sp)                       
        stw     r10, 4(sp)                      
        stw     r11, 8(sp)                      
        stw     r12, 12(sp)                     
        stw     r13, 16(sp)                     

        movia   r10, KEY_BASE                   # base address of pushbutton KEY
                                                # parallel port
        ldwio   r11, 0xC(r10)                   # read edge capture register
        stwio   r11, 0xC(r10)                   # clear the interrupt

CHECK_KEY0:                                     
        andi    r13, r11, 0b0001                # check KEY0
        beq     r13, zero, CHECK_KEY1           

        movia   r10, SW_BASE                    # base address of SW slider
                                                # switches parallel port
        ldwio   r12, 0(r10)                     # load a new pattern from the SW
                                                # switches
        movia   r10, PATTERN                    # set up a pointer to the pattern
                                                # variable
        stw     r12, 0(r10)                     # store the new pattern to the
                                                # global variable

CHECK_KEY1:                                     
        andi    r13, r11, 0b0010                # check KEY1
        beq     r13, zero, END_PUSHBUTTON_ISR   

        movia   r10, SHIFT_DIR                  # set up a pointer to the shift
                                                # direction variable
        ldw     r12, 0(r10)                     # load the current shift direction
        xori    r12, r12, 1                     # toggle the direction
        stw     r12, 0(r10)                     # store the new shift direction

END_PUSHBUTTON_ISR:                             
        ldw     ra, 0(sp)                       # Restore all used register to
                                                # previous
        ldw     r10, 4(sp)                      
        ldw     r11, 8(sp)                      
        ldw     r12, 12(sp)                     
        ldw     r13, 16(sp)                     
        addi    sp, sp, 20                      


.end                                        
