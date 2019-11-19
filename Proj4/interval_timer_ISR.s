.include    "address_map_nios2.s"
.extern     PATTERN1         # externally defined variables
.extern     PATTERN2
.extern     TEXT
.extern     STATE
.extern     SUBSTATE       
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

        movia   r20, HEX3_HEX0_BASE  
        movia   r21, STATE
        movia   r22, SUBSTATE

CHECK_STATE:                    
        ldw     r5, 0(r21)      
        beq     r5, r0, TEXT_SCROLL
        movi    r8, 1
        beq     r5, r8, PATT_1 

PATT_2:     
        movi    r6, 2
        stw     r6, 0(r21) /* set state */

        ldw     r5, 0(r22) /* check substate */
        movi    r6, 6
        bge     r5, r6, STATE_CHANGE

        andi    r6, r5, 1

        ldw     r5, 0(r22)
        addi    r5, r5, 1
        stw     r5, 0(r22)

        movia   r5, PATTERN2

        beq     r6, r0, PATT_2_A

        /*patt 2 b*/
        mov     r8, r0
        br      STORE_PATTERN     

    PATT_2_A:
        ldw     r8, 0(r5)
        br      STORE_PATTERN

PATT_1:
        movi    r6, 1
        stw     r6, 0(r21)

        ldw     r5, 0(r22) /* check substate */
        movi    r6, 6
        bge     r5, r6, STATE_CHANGE

        andi    r6, r5, 1

        ldw     r5, 0(r22)
        addi    r5, r5, 1
        stw     r5, 0(r22)

        movia   r5, PATTERN1

        beq     r6, r0, PATT_1_A

        /*patt 1 b*/
        ldw     r8, 4(r5)
        br      STORE_PATTERN     

    PATT_1_A:
        ldw     r8, 0(r5)
        br      STORE_PATTERN

TEXT_SCROLL:
        stw     r0, 0(r21) /* set state */

        ldw     r5, 0(r22) /* check substate */
        movi    r6, 0x12
        bge     r5, r6, STATE_CHANGE

        muli    r5, r5, 4 /*mul substate to get offset*/
        movia   r8, TEXT  
        add     r6, r8, r5
        ldw     r8, 0(r6) /* load from offset */
        ldw     r23, 0(r20)
        slli    r23, r23, 8
        add     r8, r8, r23
        ldw     r5, 0(r22)/* to increment offset */
        addi    r5, r5, 1
        stw     r5, 0(r22)
        br      STORE_PATTERN


STATE_CHANGE:
        stw     r0, 0(r22)

        ldw     r5, 0(r21)

        movi    r6, 2
        beq     r5, r6, STATE_RESET

        addi    r5, r5, 1
        stw     r5, 0(r21)
        br      CHECK_STATE

    STATE_RESET:
        stw     r0, 0(r21)
        br	CHECK_STATE


STORE_PATTERN:                  
        stwio   r8, 0(r20)      # store display pattern

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
        ret
.end