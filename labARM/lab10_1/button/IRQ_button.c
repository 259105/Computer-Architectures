#include "button.h"
#include "LPC17xx.h"
#include "../led/led.h"

extern unsigned int prec;
extern unsigned int curr;

void EINT0_IRQHandler (void)	  
{
	all_LED_off();
  LPC_SC->EXTINT |= (1 << 0);     /* clear pending interrupt         */
}

void EINT1_IRQHandler (void)	  
{
	if(prec!=0){
		prec = curr - prec;
		curr-=prec;
		LPC_GPIO2->FIOPIN= 0x100 >> curr;
	}
	LPC_SC->EXTINT |= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  
{
	if(curr!=8){
		curr+=prec;
		prec = curr - prec;
		LPC_GPIO2->FIOPIN= 0x100 >> curr;
	}
  LPC_SC->EXTINT |= (1 << 2);     /* clear pending interrupt         */    
}
