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
#include "button/button.h"

extern void SysTick_Handler(void);
extern void startTimer(unsigned int time);
extern void stopTimer(void);
extern unsigned int getTimer(void);
extern unsigned int pressed;

int sequence[]={0,1,2,2,1,0};
int n=1;
int i=0;
int j=0;
int timerTicks=0;
int state=0;


/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void)
{  
  LED_init();                           /* LED Initialization                 */
  BUTTON_init();						/* BUTTON Initialization              */
	startTimer(1);
  while (1);                        	/* Loop forever                       */	
}

void SysTick_Handler(void){
	// every 1.5 seconds tick the timer
	startTimer(1);
//	if(timerTicks!=15){
//		timerTicks++;
//		return;
//	}
//	timerTicks=0;
	if(state==0){
		// random led on; i++
		all_LED_off();
		LED_On(sequence[i++]);
		state++;
	}else if(state==1){
		// all led off;
		all_LED_off();
		if(i<n) state--;
		else{
			state++;
			stopTimer();
		}
	}else if(state==2){
		// check the button j-th;
		all_LED_off();
		state++;
	}else if(state==3){
		if(pressed==sequence[j]){
			// correct answer
			j++;
			if(j<n){
				stopTimer();
				state--;
			}
			else state++;
		}else {
			// wrong answer
			show_num(j);
			n=1;
			i=j=0;
			state=0;
		}
	}else if(state==4){
		stopTimer();
		show_num(n);
		n++;
		i=j=0;
		// state update in button in order to don't have problems
	}
	
	return;
}
