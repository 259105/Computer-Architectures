.model small
.stack
.data
mySpace DB 128 DUP(?)
string1 DB 'computer architectures',0
string2 DB 'accurate search',0
.code
.startup
			MOV SI, offset string1
			MOV DI, offset string2
			XOR AX, AX
			PUSH SI
			PUSH DI
			PUSH AX
			CALL longestSubstring
			POP AX
			POP DI
			POP SI
.exit

isContained:PROC NEAR
			PUSH BP
			MOV BP, SP
			PUSHA
			MOV SI, [BP+8]		; SI = string1  
			XOR BX, BX
cycle1:		MOV BL, BYTE PTR [SI]	; take i-th char from string1
			ADD SI, 1		; go to next char
			CMP BL, 0
			JE continue1
			ADD BYTE PTR mySpace[BX], 1	; increment the occurences
			JMP cycle1
continue1:	MOV SI, [BP+6]		; SI = string2    
            XOR BX, BX
cycle2:		MOV BL, BYTE PTR [SI]	; take j-th char from string2
			ADD SI, 1		; go to next char
			CMP BL, 0		
			JE continue2
			SUB BYTE PTR mySpace[BX], 1	; decrement the occurences
			JMP cycle2
continue2:	MOV CX, 128		; dimention of mySpace
			XOR SI, SI		; index for scannig mySpace
cycle3:		CMP BYTE PTR mySpace[SI], 0
			JGE continue3
				; mySpace[SI]<0
				MOV [BP+4], 0	; return 0
				JMP endContained
continue3:		ADD SI, 1	; go to next
			LOOP cycle3
			MOV [BP+4], 1
endContained: POPA
			POP BP
			RET
            ENDP

isAnagram	PROC NEAR
			PUSH BP
			MOV BP, SP
			PUSHA
			PUSH [BP+8]
			PUSH [BP+6]
			PUSH [BP+4]
			CALL isContained
			POP [BP+4]
			POP DI
			POP SI
			CMP [BP+4], 0
			JE endAnagram
			MOV CX, 128		; dimention of mySpace
			XOR SI, SI
cycleAnagram:CMP mySpace[SI], 0
			JNE endAnagram
			ADD SI, 1		; go to next occurence
			LOOP cycleAnagram
			MOV [BP+4], 1
endAnagram:		POPA
			POP BP
			RET			
            ENDP

longestSubstring 	PROC NEAR
            		PUSH BP
            		MOV BP, SP
            		PUSHA
            		XOR AL, AL		        ; result
        			MOV SI, [BP+8]		    ; take string1
        			MOV DI, [BP+6]		    ; take string2
cycleOuter:		    CMP [DI], 0
        			JE endLongest
        			PUSH SI
        			PUSH DI
        			XOR AH, AH		        ; current max
cycleSubstring:		MOV DL, BYTE PTR [DI]	; take the i-th char from string2
        			ADD DI, 1		        ; update index for the next cycle
        			CMP DL, 0
			        JE continue		        ; if the char is 0 end the procedure
cycleOutstring:		MOV DH, BYTE PTR [SI]	; take the j-th char from string1
        			ADD SI, 1		        ; update index for the next cycle
        			CMP DH, 0
        			JE continue		        ; if the char is 0 end the procedure
        			CMP DL, DH
        			JNE cycleOutstring	    ; if char i-th and j-th aren't equal go to next char of string1
        				; DL==DH
        				ADD AH, 1	        ; update the current max
        				JMP cycleSubstring	; go the next char in the substring
continue:		    CMP AH, AL
        			JBE noMax
        				; if AH(current) > AL(global)
        				MOV AL, AH	        ; save the new max
noMax:			    POP DI
        			POP SI
        			ADD DI, 1		        ; go to next substring
        			JMP cycleOuter
endLongest:		    MOV [BP+4], AL 		    ; save the result
			        MOV [BP+5], 0		    ;   
           		    POPA
            		POP BP
            		RET
            		ENDP

end