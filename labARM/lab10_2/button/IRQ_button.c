#include "button.h"
#include "LPC17xx.h"
#include "../led/led.h"

extern void startTimer(unsigned int time);
extern void stopTimer(void);
extern unsigned int getTimer(void);

extern unsigned int state;

unsigned int pressed=-1;

void EINT0_IRQHandler (void){
	startTimer(1);
	if(state==4){
		state=0;
	}else{
		LED_On(2);
		pressed=2;
	}
  LPC_SC->EXTINT |= (1 << 0);     /* clear pending interrupt         */
}

void EINT1_IRQHandler (void){
	startTimer(1);
	if(state==4){
		state=0;
	}else{
		LED_On(1);
		pressed=1;
	}
	LPC_SC->EXTINT |= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void){
	startTimer(1);
	if(state==4){
		state=0;
	}else{
		LED_On(0);
		pressed=0;	
	}
  LPC_SC->EXTINT |= (1 << 2);     /* clear pending interrupt         */    
}
