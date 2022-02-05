#include "button.h"
#include "lpc17xx.h"
#include <stdio.h>

extern int checkRow(int player, char grid[]);
extern int checkDiagonal(int player, char grid[]);
extern char grid[];

void EINT0_IRQHandler (void)	  
{
	LPC_GPIO2->FIOCLR=0xFF;
	LPC_SC->EXTINT |= (1 << 0);     /* clear pending interrupt         */
}


void EINT1_IRQHandler (void){
	int horizontal;
	int diagonal;
	horizontal = checkRow(1,grid);
	diagonal =	checkDiagonal(1,grid);
  if(horizontal==0 && diagonal==0){
    LPC_GPIO2->FIOPIN=0x01;
  }else if(horizontal==1){
    LPC_GPIO2->FIOPIN=0x02;
  }else{
    LPC_GPIO2->FIOPIN=0x04;
  }
	
	LPC_SC->EXTINT |= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void){
	int horizontal;
	int diagonal;
	horizontal=checkRow(2,grid);
	diagonal=checkDiagonal(2,grid);
  if(horizontal==0 && diagonal==0){
    LPC_GPIO2->FIOPIN=0x10;
  }else if(horizontal==1){
    LPC_GPIO2->FIOPIN=0x20;
  }else{
    LPC_GPIO2->FIOPIN=0x40;
  }
	
	LPC_SC->EXTINT |= (1 << 2);     /* clear pending interrupt         */    
}


