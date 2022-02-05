/*----------------------------------------------------------------------------
 * Name:    sample.c
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2022 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/

/* When creating the project, open the Debug tab (inside Options for target) and set:
	1) Dialog DLL: DARMP1.DLL (Simulator) or TARMP1.DLL (ULINK2/ME Cortex Debugger)
	2) Parameter: -pLPC1768 (both)						*/


#include <stdio.h>
#include "LPC17xx.h"                    
#include "led/led.h"
#include "button/button.h"


/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void)
{  
	LED_init();					/* LED Initialization */
	BUTTON_init();			/* BUTTON Initialization */
	

	while (1);         /* Loop forever */	
 

}
