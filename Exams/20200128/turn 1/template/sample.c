/*----------------------------------------------------------------------------
 * Name:    sample.c
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2020 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/
                  
#include <stdio.h>
#include "LPC17xx.h"                    /* LPC17xx definitions                */

/*-----------------------------------------------------------------
Uncomment to import the libraries that you need
 *-----------------------------------------------------------------*/
#include "led/led.h"
//#include "button/button.h"
//#include "timer/timer.h"
//#include "ADC_DAC/adc_dac.h"

extern int coprime(int a,int b);
extern int radical(int a);

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void)
{  
	int a=243;
	int b=0;
	int c;
	int solutions=0;
	int exceptions=0;
	int led=0x00000080;
	// Uncomment the instructions (and add others) according to your needs
	LED_init();					/* LED Initialization */
	//BUTTON_init();				/* BUTTON Initialization */
	//init_timer(0,0x0EE6B280);		/* TIMER0 Initialization */
	//enable_timer(0);
	//ADC_init();
	//DAC_init();
	
	while(solutions!=100){
		b++;
		c=a+b;
		if(coprime(a,b)==1 && coprime(a,c)==1 && coprime(b,c)){
			solutions++;
			if(c>radical(a*b*c)) exceptions++;
		}
	}
	
	led = led >> exceptions;
	LPC_GPIO2->FIOSET = led;
	
	
	LPC_SC->PCON |= 0x1;	/* power-down mode */								
	LPC_SC->PCON &= 0xFFFFFFFFD; 
	SCB->SCR |= 0x2;			/* set SLEEPONEXIT */	
	
	//ADC_start_conversion();

	__ASM("wfi");
}
