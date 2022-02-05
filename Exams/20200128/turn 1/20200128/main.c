#include <stdio.h>
#include "LPC17xx.h"                    /* LPC17xx definitions                */
#include "led/led.h"

extern int radical(int n);
extern int coprime(int u, int v);

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void) 
{
  LED_init();                           /* LED Initialization                 */
	int a=2;
  int b=1;
  int c;
  int sol=0;
  int exceptions=0;

  while(sol!=100){
    c=a+b;
    if(coprime(a,b) && coprime(b,c) && coprime(a,c)){
      sol++;
      if(c>radical(a*b*c)){
        exceptions++;
      }
    }
    b++;
  }

  // switch on the led
  LPC_GPIO2->FIOPIN = 0x80 >> exceptions;

  while(1);                
}
