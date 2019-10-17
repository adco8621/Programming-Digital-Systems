#include "address_map_nios2.h"

int main(void){

    volatile int *sw_base_addr = (int*)SW_BASE; // set a pointer to the switches
    // same as int *sw_base_addr = 0xFF200040

    volatile int *led_base_addr = (int*)LED_BASE; // pointer to the LEDs

    // volatile means that the value can change outside of the program so keep an eye out
    // same as ldw vs ldwio

    // int to store the switches
    int sw_value;


    while (1)
    {
        // sets the value in the pointer to the switches to sw_value
        sw_value = *sw_base_addr;

        //         first 5 bits      last 5 bits
        sw_value = (sw_value >> 5) + (sw_value & 0x1F)

        // setting the LEDs to match the switches
        *led_base_addr = sw_value;
    }
    return 1;

}

// in program settings in monitor program, there is a part that says -01 and you can change it 
// to -02 or -03 which changes what it optimizes for. -01 does mem, -02 does idk, -03 does operations