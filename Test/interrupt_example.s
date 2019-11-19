.include    "address_map_nios2.s" 
.include    "globals.s" 

/*******************************************************************************
 * This program demonstrates use of interrupts. It
 * first starts an interval timer with 50 msec timeouts, and then enables
 * Nios II interrupts from the interval timer and pushbutton KEYs
 *
 * The interrupt service routine for the interval timer displays a pattern
 * on the LEDs, and shifts this pattern either left or right:
 *		KEY[0]: loads a new pattern from the SW switches
 *		KEY[1]: toggles the shift direction the displayed pattern
 ******************************************************************************/

.text        # executable code follows
.global     _start 
_start:                             
/* set up the stack */
        movia   sp, SDRAM_END - 3   # stack starts from largest memory
                                    # address

        movia   r16, TIMER_BASE     # interval timer base address
/* set the interval timer period for scrolling the LED lights */
        movia   r12, 5000000        # 1/(100 MHz) x (5 x 10^6) = 50 msec
        sthio   r12, 8(r16)         # store the low half word of counter
                                    # start value
        srli    r12, r12, 16        
        sthio   r12, 0xC(r16)       # high half word of counter start value

/* start interval timer, enable its interrupts */
        movi    r15, 0b0111         # START = 1, CONT = 1, ITO = 1
        sthio   r15, 4(r16)         

/* write to the pushbutton port interrupt mask register */
        movia   r15, KEY_BASE       # pushbutton key base address
        movi    r7, 0b11            # set interrupt mask bits
        stwio   r7, 8(r15)          # interrupt mask register is (base + 8)

/* enable Nios II processor interrupts */
        movia   r7, 0x00000001      # get interrupt mask bit for interval
                                    # timer
        movia   r8, 0x00000002      # get interrupt mask bit for pushbuttons
        or      r7, r7, r8          
        wrctl   ienable, r7         # enable interrupts for the given mask
                                    # bits
        movi    r7, 1               
        wrctl   status, r7          # turn on Nios II interrupt processing

IDLE:                               
        br      IDLE                # main program simply idles

.data        
/*******************************************************************************
 * The global variables used by the interrupt service routines for the interval
 * timer and the pushbutton keys are declared below
 ******************************************************************************/
.global     PATTERN 
PATTERN:                            
.word       0x0F0F0F0F # pattern to show on the LED lights
.global     SHIFT_DIR 
SHIFT_DIR:                          
.word       RIGHT # pattern shifting direction

.end         
