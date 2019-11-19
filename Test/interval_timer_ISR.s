.include    "address_map_nios2.s"
.include    "globals.s"     
.extern     PATTERN         # externally defined variables
.extern     SHIFT_DIR       
/*******************************************************************************
 * Interval timer - Interrupt Service Routine
 *
 * Shifts a PATTERN being displayed. The shift direction is determined by the
 * external variable SHIFT_DIR.
 ******************************************************************************/
.global     INTERVAL_TIMER_ISR
INTERVAL_TIMER_ISR:             
        subi    sp, sp, 40      # reserve space on the stack
        stw     ra, 0(sp)       
        stw     r4, 4(sp)       
        stw     r5, 8(sp)       
        stw     r6, 12(sp)      
        stw     r8, 16(sp)      
        stw     r10, 20(sp)     
        stw     r20, 24(sp)     
        stw     r21, 28(sp)     
        stw     r22, 32(sp)     
        stw     r23, 36(sp)     

        movia   r10, TIMER_BASE # interval timer base address
        sthio   r0, 0(r10)      # clear the interrupt

        movia   r20, LED_BASE   # LED base address
        movia   r21, PATTERN    # set up a pointer to the display pattern
        movia   r22, SHIFT_DIR  # set up a pointer to the shift direction variable

        ldw     r6, 0(r21)      # load the pattern
        stwio   r6, 0(r20)      # store to LEDs

CHECK_SHIFT:                    
        ldw     r5, 0(r22)      # get shift direction
        movi    r8, RIGHT       
        bne     r5, r8, SHIFT_L 

SHIFT_R:                        
        movi    r5, 1           # set r5 to the constant value 1
        ror     r6, r6, r5      # rotate the displayed pattern right
        br      STORE_PATTERN   

SHIFT_L:                        
        movi    r5, 1           # set r5 to the constant value 1
        rol     r6, r6, r5      # shift left

STORE_PATTERN:                  
        stw     r6, 0(r21)      # store display pattern

END_INTERVAL_TIMER_ISR:         
        ldw     ra, 0(sp)       # restore registers
        ldw     r4, 4(sp)       
        ldw     r5, 8(sp)       
        ldw     r6, 12(sp)      
        ldw     r8, 16(sp)      
        ldw     r10, 20(sp)     
        ldw     r20, 24(sp)     
        ldw     r21, 28(sp)     
        ldw     r22, 32(sp)     
        ldw     r23, 36(sp)     
        addi    sp, sp, 40      # release the reserved space on the stack

                                
.end                        
