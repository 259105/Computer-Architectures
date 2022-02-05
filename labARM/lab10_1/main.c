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

unsigned int prec=0;
unsigned int curr=1;
/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void)
{  
  LED_init();                           /* LED Initialization                 */
  BUTTON_init();						/* BUTTON Initialization              */
	LPC_GPIO2->FIOPIN= 0x100 >> curr;
  while (1);                        	/* Loop forever                       */	
}
