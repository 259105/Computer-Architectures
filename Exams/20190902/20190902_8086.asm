.model small
.stack
.data
connect4    DB 0, 0, 0, 0, 0, 0, 0
	        DB 0, 0, 2, 0, 0, 0, 0
	        DB 0, 0, 2, 1, 1, 0, 1
	        DB 0, 1, 2, 2, 1, 1, 2
	        DB 2, 2, 2, 2, 1, 2, 1
	        DB 1, 2, 1, 1, 1, 2, 2
.code
.startup
			MOV CX, 6			; counter rows
			XOR SI, SI			; index of matrix
			MOV DL, 2			; player to check
			XOR AL, AL			; result
cycle1:			PUSH SI
			PUSH CX
			MOV CX, 4
cycle2:			PUSH SI
			CMP connect4[SI], DL		; compare the cell with the player number
			JNE continue			; if it isn't equal to the player, it isn't a quadrupla
			ADD SI, 1			; go forward
			CMP connect4[SI], DL		
			JNE continue
			ADD SI, 1
			CMP connect4[SI], DL		
			JNE continue
			ADD SI, 1
			CMP connect4[SI], DL		
			JNE continue
			MOV AL, 1			; a quaduple is found
continue:		POP SI
			ADD SI, 1			; go to next cell
			LOOP cycle2
			POP CX
			POP SI
			ADD SI, 7			; go to next line
			LOOP cycle1


			MOV CX, 6			; counter rows
			MOV SI, 21			; index of matrix
			XOR AH, AH			; result
cycle1D:		PUSH SI
			PUSH CX
			MOV CX, 4
cycle2D:		PUSH SI
			CMP connect4[SI], DL		; compare the cell with the player number
			JNE continueD			; if it isn't equal to the player, it isn't a quadrupla
			SUB SI, 6			; go forward
			CMP connect4[SI], DL		
			JNE continueD
			SUB SI, 6
			CMP connect4[SI], DL		
			JNE continueD
			SUB SI, 6
			CMP connect4[SI], DL		
			JNE continueD
			MOV AH, 1			; a quaduple is found
continueD:		POP SI
			ADD SI, 1			; go to next cell
			LOOP cycle2D
			POP CX
			POP SI
			ADD SI, 7			; go to next line
			LOOP cycle1D
.exit
end