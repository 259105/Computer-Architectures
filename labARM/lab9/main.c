/*----------------------------------------------------------------------------
 * Name:    sample.c
 * Purpose: to control led through EINT buttons
 * Note(s):
 *----------------------------------------------------------------------------
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2019 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/
                  
#include <stdio.h>
#include "LPC17xx.h"                    /* LPC17xx definitions                */
#include "led/led.h"
#include "button/button.h"

unsigned int led_state;

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void)
{  
  LED_init();                           /* LED Initialization                 */
  BUTTON_init();						/* BUTTON Initialization              */
	
	led4and11_On();
	led4_Off();
	ledEvenOn_OddOff();
	LED_On(1);
	LED_On(3);
	LED_On(5);
	LED_On(7);
	LED_Off(6);
	LED_Off(4);
	LED_Off(2);
	LED_Off(0);
	
	led_state=LPC_GPIO2->FIOPIN;
	
  while (1);                        	/* Loop forever                       */	
}
