#include "button.h"
#include "LPC17xx.h"
#include "../led/led.h"

extern unsigned int led_state;

void EINT0_IRQHandler (void)	  
{
  LPC_GPIO2->FIOPIN=led_state;
  LPC_SC->EXTINT |= (1 << 0);     /* clear pending interrupt         */
}

void EINT1_IRQHandler (void)	  
{
	unsigned int newstate=LPC_GPIO2->FIOPIN << 1;
	LPC_GPIO2->FIOPIN = (newstate & 0xff) + ((newstate & 0x100)>>8);
	
	LPC_SC->EXTINT |= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  
{
	unsigned int state = LPC_GPIO2->FIOPIN&0xff;
	LPC_GPIO2->FIOPIN = (state>>1) | ((state&0x1)<<7) ;
	
  LPC_SC->EXTINT |= (1 << 2);     /* clear pending interrupt         */    
}
