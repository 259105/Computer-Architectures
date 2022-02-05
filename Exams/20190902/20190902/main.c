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

extern int checkRow(int player, char grid[]);
extern int checkDiagonal(int player, char grid[]);

char grid[42] = {0, 0, 0, 0, 0, 0, 0,
				0, 0, 2, 0, 0, 0, 0,
				0, 0, 2, 1, 1, 1, 1,
				0, 1, 2, 2, 1, 0, 2,
				2, 2, 2, 2, 1, 2, 1,
				1, 2, 1, 1, 1, 2, 2};
				
/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void)
{  
	LED_init();					/* LED Initialization */
	BUTTON_init();				/* BUTTON Initialization */
 
	
	while(1);
}
