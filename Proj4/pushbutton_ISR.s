.include    "address_map_nios2.s"
.extern     SCROLL_SPEED_INT
.extern     SCROLL_SPEED_CURR
.extern     SCROLL_SPEED_MAX                                                
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

        movia   r10, SCROLL_SPEED_CURR

CHECK_KEY0:                                     
        andi    r13, r11, 0b0001                # check KEY0
        beq     r13, zero, CHECK_KEY1           

        ldw     r10, 0(r10)
        movia   r11, SCROLL_SPEED_INT
        ldw     r11, 0(r11)

        ble     r10, r11, END_PUSHBUTTON_ISR

        movia   r11, SCROLL_SPEED_INT
        ldw     r11, 0(r11)
        sub     r10, r10, r11

        br      END_PUSHBUTTON_ISR
        

CHECK_KEY1:                                     
        andi    r13, r11, 0b0010                # check KEY1
        beq     r13, zero, END_PUSHBUTTON_ISR   

        ldw     r10, 0(r10)
        movia   r11, SCROLL_SPEED_MAX
        ldw     r11, 0(r11)

        bge     r10, r11, END_PUSHBUTTON_ISR

        movia   r11, SCROLL_SPEED_INT
        ldw     r11, 0(r11)
        add     r10, r10, r11

        br      END_PUSHBUTTON_ISR

      

END_PUSHBUTTON_ISR:
        movia   r13, TIMER_BASE
        movia   r12, SCROLL_SPEED_CURR
        stw     r10, 0(r12)
        ldw	r12, 0(r12)
        sthio   r12, 8(r13)         # store the low half word of counter
                                        # start value
        srli    r12, r12, 16        
        sthio   r12, 0xC(r13)

        movi    r12, 0b0111         # START = 1, CONT = 1, ITO = 1
        sthio   r12, 4(r13)


        ldw     ra, 0(sp)                       # Restore all used register to
                                                # previous
        ldw     r10, 4(sp)                      
        ldw     r11, 8(sp)                      
        ldw     r12, 12(sp)                     
        ldw     r13, 16(sp)                     
        addi    sp, sp, 20
        ret
                   
.end