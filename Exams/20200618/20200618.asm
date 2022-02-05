 .model small
.stack
.data
matrix DB 2000 DUP(?)					; save the matrix by rows
array DW 4, 30, 120, 340, 780
.code
.startup
	MOV SI, offset matrix
	MOV DI, offset array
	MOV AX, 5
	PUSH SI
	PUSH DI
	PUSH AX
	CALL initializeMatrix
	POP AX
	POP DI
	POP SI
	PUSH SI
	PUSH AX
	CALL computeDifferences
	POP AX
	POP SI
	MOV DX, 9
	PUSH SI
	PUSH AX
	PUSH DX
	CALL getPolynomialValue
	POP DX
	POP AX
	POP SI

.exit

initializeMatrix		PROC NEAR
				PUSH BP
				MOV BP, SP
				PUSHA
				MOV SI, [BP+8]		; take the matrix address
				MOV DI, [BP+6]		; take the array address
				MOV CX, [BP+4]		; take the number of values in the array
				MOV DX, CX		; save the offset to jump
				SHL DX, 1		; because they are words
				; I update directily SI and DI, because there aren't enough register to access mem
				; and because the start address is saved in stack, so i don't lose information
cycleInit:		MOV AX, [DI]		; take i-th value from array
				MOV [SI], AX	; save the value in matrix
				ADD SI, DX		; go to next word in matrix
				ADD DI, 2		; go to next word in array
				LOOP cycleInit		; loop for N+1 time
				POPA
				POP BP
				RET
				ENDP

computeDifferences		PROC NEAR
				PUSH BP
				MOV BP, SP
				PUSHA
				MOV SI, [BP+6]
				MOV CX, [BP+4]
				MOV BX, CX		; DX = N+1 it is the number of bits to jump for going in new row
				SHL BX, 1		; because they are words		
				SUB CX, 1		; CX = N
				MOV DI, SI		; copy in DI, SI
				ADD DI, 2		; go to next colum for destination
cycleColums:			PUSH SI
				PUSH DI
cycleRows:		CMP [SI][BX], 0
				JE endRows		; if the value of cell is 0, then there aren't other values
				MOV AX, [SI][BX]	; take value	
				SUB AX, [SI]		; sub with its precedent value
				JNO noOverflowDiff
					; there was an overflow
					CMP AX,0
					JGE positiveOverflow
						; negativeOverflow
						MOV AX, 07FFFH	; save the maximum positive number
						JMP noOverflowDiff
positiveOverflow:	MOV AX, 08000H	; save the minimum negative number				
noOverflowDiff:	MOV [DI], AX		; save the result in destination
				ADD SI, BX		; go to next cell
				ADD DI, BX		; go to next cell
				JMP cycleRows
endRows:				POP DI
				POP SI
				ADD SI, 2		; go to next colum
				ADD DI, 2		; go to next colum
				LOOP cycleColums	; loop for N times = number of colums to calculate
				POPA
				POP BP
				RET
				ENDP

getPolynomialValue		PROC
				PUSH BP
				MOV BP, SP
				PUSHA
				MOV SI, [BP+8]
				MOV CX, [BP+6]
				MOV DX, CX		; DX = N+1	jumps for next line
				SHL DX, 1		; because they are words		
				SUB CX, 1		; CX = N
				MOV BX, CX		; 
				SHL BX, 1		; jumps by 4 cells
				ADD SI, BX		; go to last column of first row
				MOV DI, SI		; copy in DI the value of SI
				ADD DI, DX		; DI now is under SI
				PUSH SI
				PUSH DI
				PUSH CX
cycleInitPoly:			MOV AX, [SI]		; take the value of last cell in the first colum
				MOV [DI], AX		; copy it in the under cell
				ADD DI, DX		; go to next line
				ADD SI, DX		; go to next line
				LOOP cycleInitPoly
				POP CX
				POP DI
				POP SI
				ADD SI, BX		; move by diagonal
				ADD DI, BX		; move by diagonal
cyclePolyColums:PUSH CX
				MOV CX, [BP+6]
				SUB CX, 1		; CX = N
				PUSH SI
				PUSH DI
cycleInternalRows:MOV AX, [SI]		; take first
				ADD AX, [SI+2]		; sum to second  
				JNO noOverflowPoly
					; there was an overflow
					CMP AX,0
					JGE positiveOver
						; negativeOverflow
						MOV AX, 07FFFH	; save the maximum positive number
						JMP noOverflowDiff
positiveOver:	MOV AX, 08000H	; save the minimum negative number				
noOverflowPoly:	MOV [DI], AX		; save
				ADD SI, DX		; go to next line
				ADD DI, DX		; go to next lne
				LOOP cycleInternalRows
				POP DI
				POP SI
				ADD SI, BX		; move by diagonal
				ADD DI, BX		; move by diagonal 
				POP CX
				LOOP cyclePolyColums
				POPA
				POP BP
				RET
				ENDP


end
