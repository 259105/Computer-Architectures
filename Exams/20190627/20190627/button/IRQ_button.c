#include "button.h"
#include "lpc17xx.h"

extern int GoldbachConjecture(int num);

int n=0;

void EINT0_IRQHandler (void)	  
{
	int r;
	if(n!=0){
    n = n<<1;
		r = GoldbachConjecture(n);
    if(r>255) LPC_GPIO2->FIOPIN=0xFF;
    else LPC_GPIO2->FIOPIN=r;
    n=0;
  }
	LPC_SC->EXTINT |= (1 << 0);     /* clear pending interrupt         */
}


void EINT1_IRQHandler (void)	  
{
	if(n!=0)
    n = n<<1;
	LPC_GPIO2->FIOPIN=n;
	LPC_SC->EXTINT |= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  
{
	if(n==0){
    n++;
  }else{
    n = n<<1;
    n++;
  }
	LPC_GPIO2->FIOPIN=n;
	LPC_SC->EXTINT |= (1 << 2);     /* clear pending interrupt         */    
}


