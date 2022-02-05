;/**************************************************************************//**
; * @file     startup_LPC17xx.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           NXP LPC17xx Device Series
; * @version  V1.10
; * @date     06. April 2011
; *
; * @note
; * Copyright (C) 2009-2011 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/

; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------

; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
                DCD     USBActivity_IRQHandler    ; 49: USB Activity interrupt to wakeup
                DCD     CANActivity_IRQHandler    ; 50: CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF


                AREA    |.text|, CODE, READONLY


; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
                
				; item 1
				;MOV r0, #90
				;MOV r1, #89
				;BL binaryGCD
				
				; remove comments to solve item 2
				;MOV r0, #7560
				;MOV r1, #5280
				;BL binaryExtendedGCD
				
				; remove comments to solve item 3
				IMPORT  SystemInit
                IMPORT  __main
                LDR     R0, =SystemInit
                BLX     R0
                LDR     R0, =__main
                BX      R0
stop			B stop
                ENDP
					
binaryGCD		PROC
				EXPORT binaryGCD
				PUSH {r4,LR}
				; r0 = x
				; r1 = y
				EOR r2, r2	; r2 = g
firstStepGCP	AND r3, r0, #1	; take first bit
				LSL r3, #1	; move the bit in the second position
				AND r4, r1, #1	; take first bit
				ORR r3, r3, r4	; union of results
				CMP r3, #2_00	
				BNE continueGCD	; if one of two isn't even continue GCD
					; if both are even
					LSR r0, #1	; x/2
					LSR r1, #1	; y/2
					ADD r2, #1	; g = g + 1
					B firstStepGCP
				; ------ FIRST METHOD FOR CHECKING PARITY -----
				; PRE-DIVIDING THE NUMBER
continueGCD		LSRS r0, #1	; pre-divide by 2
				BCC continueGCD	; if r0 was even continue GCD
					; r0 was odd so restore value
					LSL r0, #1	; multiple by 2
					ADD r0, #1	; add trunced val
				; ------ SECOND METHOD FOR CHECKING PARITY -----	
				; WITH TST
yEvenLoop		TST r1, #1	; check LSB
				BNE continueAfterY	; y is odd
					; y is even
					LSR r1, #1
					B yEvenLoop
continueAfterY	CMP r0, r1
				BHS	xgtey	; if x >= y go to xgtey
					; x < y
					SUB r1, r1, r0	; y = y - x
					B continueAfterIf
				; x >= y
xgtey			SUB r0, r0, r1	; x = x - Y
continueAfterIf CMP r0, #0
				BNE	continueGCD	; if x != 0 loop	
				LSL r0, r1, r2	;  return y*2^g
				POP {r4,PC}
				ENDP
					
binaryExtendedGCD PROC
				EXPORT binaryExtendedGCD
				PUSH {r4-r10,LR}
				; r0 = x
				; r1 = y
				EOR r2, r2	; r2 = g
firstStepExt	AND r3, r0, #1	; take first bit
				LSL r3, #1	; move the bit in the second position
				AND r4, r1, #1	; take first bit
				ORR r3, r3, r4	; union of results
				CMP r3, #2_00	
				BNE continueAfter	; if one of two isn't even continue GCD
					; if both are even
					LSR r0, #1	; x/2
					LSR r1, #1	; y/2
					ADD r2, #1	; g = g + 1
					B firstStepExt
continueAfter	MOV r3, r0	; u = x
				MOV r4, r1	; v = y
				MOV r5, #1	; A = 1
				MOV r6, #0	; B = 0
				MOV r7, #0	; C = 0
				MOV r8, #1	; D = 0
xEvenLoopExt	TST r0, #1	; check LSB
				BNE yEvenLoopExt	; x is odd
					; x is even
					LSR r0, #1	; x = x / 2
					AND r9, r5, #1	; take LSB of A
					LSL r9, #1	; move the bit in second bit
					AND r10, r6, #1	; take LSB of B
					ORR r9, r9, r10	; union of results
					CMP r9, #2_00
					BEQ	ABEven	; if both are even
						; one of two isn't even
						ADD r5, r4	; A = A + v
						ASR r5, #1	; A/2
						SUB r6, r3 	; B = B - u
						ASR r6, #1	; B/2
						B xEvenLoopExt
ABEven				; A and B are both even
					ASR r5, #1	; A/2
					ASR r6, #1	; B/2
					B xEvenLoopExt
yEvenLoopExt	TST r1, #1	; check LSB
				BNE continueAfterYExt	; y is odd
					; y is even
					LSR r1, #1	; y = y / 2
					AND r9, r7, #1	; take LSB of C
					LSL r9, #1	; move the bit in second bit
					AND r10, r8, #1	; take LSB of D
					ORR r9, r9, r10	; union of results
					CMP r9, #2_00
					BEQ	CDEven	; if both are even
						; one of two isn't even
						ADD r7, r4	; C = C + v
						ASR r7, #1	; C/2
						SUB r8, r3 	; D = D - u
						ASR r8, #1	; D/2
						B yEvenLoopExt
CDEven				; A and B are both even
					ASR r7, #1	; C/2
					ASR r8, #1	; D/2
					B yEvenLoopExt
continueAfterYExt CMP r0, r1
				BHS	xgteyExt	; if x >= y go to xgteyExt
					; x < y
					SUB r1, r1, r0	; y = y - x
					SUB r7, r5		; C = C - A
					SUB r8, r6		; D = D - B
					B continueAfterIfExt
				; x >= y
xgteyExt		SUB r0, r0, r1	; x = x - y
				SUB r5, r7		; A = A - C
				SUB r6, r8		; B = B - D
continueAfterIfExt CMP r0, #0
				BNE	xEvenLoopExt	; if x != 0 loop	
				MOV r0, r7;
				POP {r4-r10,PC}
				ENDP


; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
                EXPORT  USBActivity_IRQHandler    [WEAK]
                EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler
TIMER0_IRQHandler
TIMER1_IRQHandler
TIMER2_IRQHandler
TIMER3_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
UART2_IRQHandler
UART3_IRQHandler
PWM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI_IRQHandler
SSP0_IRQHandler
SSP1_IRQHandler
PLL0_IRQHandler
RTC_IRQHandler
EINT0_IRQHandler
EINT1_IRQHandler
EINT2_IRQHandler
EINT3_IRQHandler
ADC_IRQHandler
BOD_IRQHandler
USB_IRQHandler
CAN_IRQHandler
DMA_IRQHandler
I2S_IRQHandler
ENET_IRQHandler
RIT_IRQHandler
MCPWM_IRQHandler
QEI_IRQHandler
PLL1_IRQHandler
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                IF      :DEF:__MICROLIB

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit

                ELSE

                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap
__user_initial_stackheap

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + Stack_Size)
                LDR     R2, = (Heap_Mem +  Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR

                ALIGN

                ENDIF


                END
