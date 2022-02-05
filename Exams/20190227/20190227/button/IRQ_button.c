#include "button.h"
#include "lpc17xx.h"

extern unsigned int getTime(void);
extern int iterativeCollatz(unsigned int n);
extern int recursiveCollatz(unsigned int n, int i);

void EINT0_IRQHandler (void)	  
{
	volatile unsigned int t;
  int r;
  t = getTime();
  r = iterativeCollatz(t);
  if(r>255) LPC_GPIO2->FIOPIN=0xFF;
  else LPC_GPIO2->FIOPIN=r;
	LPC_SC->EXTINT |= (1 << 0);     /* clear pending interrupt         */
}


void EINT1_IRQHandler (void)	  
{
	LPC_SC->EXTINT |= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  
{
	LPC_SC->EXTINT |= (1 << 2);     /* clear pending interrupt         */    
}


