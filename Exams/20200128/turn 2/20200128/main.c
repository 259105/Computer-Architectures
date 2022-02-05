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

extern int binaryGCD(int x, int y);
extern int binaryExtendedGCD(int x, int y);
extern void startTimer(void);
extern void stopTimer(void);

int ticks=0;
int absD;

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void) 
{
	LED_init();
  int x=7560;
  int y=5280 ;
  int z=binaryGCD(x,y);
  int C=binaryExtendedGCD(x,y);
  int D=(z-C*x)/y;
  int absC= C>=0?C:-C;
  absD= D>=0?D:-D;

  if(absC>255) LPC_GPIO2->FIOPIN=0xFF;
  else LPC_GPIO2->FIOPIN=absC;

  startTimer();
   
  while(1);
}

void SysTick_Handler(){
  startTimer();
  if(ticks!=20){
    ticks++;
  }else{
    if(absD>255) LPC_GPIO2->FIOPIN=0xFF;
    else LPC_GPIO2->FIOPIN=absD;
    stopTimer();
  }
}
