/*----------------------------------------------------------------------------
 * Name:    sample.c
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2019 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/
                  
#include <stdio.h>
#include "LPC17xx.h"                    /* LPC17xx definitions                */
#include "led/led.h"
#include "button/button.h"

extern void startTimer(void);

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void)
{  
	// Uncomment the instructions (and add others) according to your needs
	LED_init();					/* LED Initialization */
	BUTTON_init();				/* BUTTON Initialization */
	startTimer();
	
	while(1);
}

void SysTick_Handler(void){

}
