#include "button.h"
#include "lpc17xx.h"
#include "../led/led.h"

extern int restoringSquareRoot(int x, int k);

int n=0;
int c=0;

void EINT0_IRQHandler (void)	  
{
	int r;
  r = restoringSquareRoot(n,c);

  LPC_GPIO2->FIOPIN = r;
  
  n=0;
  c=0;
	
	LPC_SC->EXTINT |= (1 << 0);     /* clear pending interrupt         */
}


void EINT1_IRQHandler (void)	  
{
	if(n!=0){
    n = n<<1;		// add a 0
    c++; 		// increment counter
  }
	LPC_SC->EXTINT |= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  
{
	if(n==0){
    n++; 		// add 1 
  }else{
    n=n<<1; 		// shift 1 bit left 
    n++; 		// add a 1
  }
  c++;			// increment counter
	
 	LPC_SC->EXTINT |= (1 << 2);     /* clear pending interrupt         */    
}


