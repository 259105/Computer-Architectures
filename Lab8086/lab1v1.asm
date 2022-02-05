DIM EQU 50
.model small
.stack
.data
occurences DB 52 DUP(?)
buffer  DB DIM,?,DIM DUP(?) ; dimenzione del buffer, num char letti, caratteri letti
first   DB DIM+1 DUP(?)
second  DB DIM+1 DUP(?)
third   DB DIM+1 DUP(?)
fourth  DB DIM+1 DUP(?)
lines   DW 4 DUP(?)
maxstring DB 'The max occurrence char is: ','$'
halfstring DB 'The chars with occurences >max/2: ','$'
.code
.startup
            MOV lines[0], offset first  ;
            MOV lines+2, offset second ;
            MOV lines[4], offset third  ;
            MOV lines+6, offset fourth  ; loading the address of lines in an Array
            XOR DI, DI  ; counter line
            MOV CX, 4   ; number of cycle for scanning the lines
cycleLine:  MOV buffer[0], DIM  ; set the initial value
            MOV AL, DIM  ; number of free chars in buffer
            MOV SI, lines[DI]   ; save to SI the address of line i-th
cycleBuffer:MOV DX, offset buffer   ; load the offset of buffer
            MOV AH, 0AH
            PUSH AX
            INT 21H
            POP AX
            MOV BL, buffer+1  ; take the number of readed chars
            SUB AL, BL
            MOV buffer, AL  ; modify the max dim of buffer to AL
            PUSH CX
            MOV CX, BX      ; loop until all readed chars
            XOR BX, BX  
cycleSave:  MOV AH, buffer[BX]+2;[2]  ; save the char from the buffer to [SI]
            PUSH AX     ; save because i want to do the crypto
            PUSH DI     ; save because i want to do the crypto
            PUSH AX     ; par1 the AH into AX
            SHR DI, 1   ; because in k is rappresented as k*2
            ADD DI, 1   ; k=k+1 initialli k=0
            PUSH DI     ; par2 the k value
            CALL crypto
            POP DI
            POP AX
            MOV [SI], AH          ; save the char from the buffer to [SI]
            POP DI
            POP AX
            PUSH AX
            CALL char2num   ; trasformo 
            POP AX
            MOV BP, AX  ; uso BP per accedere ad occurrences
            AND BP, 0FF00H   ; take only the higher part
            SHR BP, 8   ; shift the higher part to lower
            ADD DS:occurences[BP], 1   ; increment the counter
            ADD BX, 1   ; go next
            ADD SI, 1   ; go next
            LOOP cycleSave
            POP CX  
            CMP AL, 30      ; because 50 - 20 = 30, so we have already wrote 20 chars
            JA cycleBuffer  ; if(AL>30) continue to cycle
            MOV [SI], '$'   ; usefull for printing with 9h
            CALL println
            PUSH CX
            MOV CX, 52  ; cycle on the occurences array
            XOR BX, BX  ; index for occurences
            XOR AL, AL  ; maximum
            XOR AH, AH  ; charMax
cycleMax:   MOV DL, occurences[BX]; take the value
            CMP DL, AL
            JBE continueMax
                MOV AL, DL  ; new MAX
                MOV AH, BL  ; max associated
continueMax:ADD BX, 1   ; go next
            LOOP cycleMax
            MOV DX, offset maxstring 
            PUSH DX
            CALL printString
            POP DX
            PUSH AX     ; AH=CHARMAX, AL=OCCURENCES
            CALL printChar
            POP AX 
            CALL println
            MOV DX, offset halfstring
            PUSH DX
            CALL printString
            POP DX
            SHR AL, 1   ; max/2
            MOV CX, 52  ; cycle in the occurences array 
            XOR BX, BX  ; index for occurences
cycleMaxHalf: MOV DL, occurences[BX]
            CMP DL, AL
            JBE continueMaxHalf
                MOV DH, BL  ; take the charnumber
                PUSH DX
                CALL printChar
                POP DX  
continueMaxHalf: ADD BX, 1   ; go next
            LOOP cycleMaxHalf
            CALL println
            MOV AX, lines[DI]
            PUSH AX
            CALL printString
            CALL println
            POP AX
            MOV CX, 52
            XOR BX, BX
resetOcc:   MOV occurences[BX], 0
            ADD BX, 1
            LOOP resetOcc 
            POP CX
            ADD DI, 2
            LOOP cycleLine
.exit 

printString PROC NEAR 
            PUSH BP
            MOV BP,SP
            PUSHA
            MOV DX, [BP+4]  ; take the string address
            MOV AH, 9
            INT 21h
            POPA
            POP BP
            RET
            ENDP

printChar   PROC NEAR
            PUSH BP
            MOV BP, SP
            PUSHA
            MOV AH, 6;
            MOV DL, BYTE PTR [BP+5] ; take the char number
            PUSH DX
            CALL num2char
            POP DX
            INT 21h
            MOV DL,'='
            INT 21h
            MOV DL,'0'
            ADD DL, BYTE PTR [BP+4]  ;take the number of accurences
            INT 21h
            MOV DL,' '
            INT 21h
            POPA
            POP BP
            RET
            ENDP

crypto      PROC NEAR
            PUSH BP
            MOV BP, SP
            PUSHA
            MOV AH, BYTE PTR [BP][4] ; take the k value fro cripting
            MOV AL, BYTE PTR [BP][7] ; take the AH from AX saved in the stack
            ADD AL, AH  ; do char + k
            CMP AH, 0
            JGE fwCrypto 
                ; bwCrypto
                CMP AL, 'A'
                JL  beforeA
                    ; maybe before a
                    CMP AL, 'a'
                    JGE endCrypto
                        ; maybe before a 
                        CMP AL, 'Z'
                        JLE endCrypto
                            SUB AL, 'a'
                            ADD AL, 'Z'
                            ADD AL, 1
                            JMP endCrypto
beforeA:        SUB AL, 'A'
                ADD AL, 'Z'
                ADD AL, 1
                JMP endCrypto
fwCrypto:   CMP AL, 'z'
            JG afterz
                ; maybe after Z
                CMP AL, 'Z'
                JLE endCrypto
                    ; maybe afterZ
                    CMP AL, 'a'
                    JGE endCrypto
                        SUB AL, 'Z'
                        ADD AL, 'a'
                        SUB AL, 1
                        JMP endCrypto
afterz:     SUB AL, 'z'
            ADD AL, 'A'
            SUB AL, 1
endCrypto:  MOV BYTE PTR [BP+7], AL  ; save the result char
            POPA
            POP BP
            RET
crypto      ENDP            
        
println     PROC    NEAR 
            PUSH BP
            MOV BP, SP
            PUSHA 
            MOV DL, 13
            MOV AH, 2
            INT 21H
            MOV DL, 10
            MOV AH, 2
            INT 21H
            POPA
            POP  BP
            RET
println     ENDP

num2char    PROC NEAR
            PUSH BP
            MOV BP, SP
            PUSHA
            MOV AL, BYTE PTR [BP+4]
            CMP AL, 26
            JAE lowercaseNum2Char 
                ; uppercase
                ADD AL ,'A'
                JMP continueNum2Char
lowercaseNum2Char:  SUB AL, 26
            ADD AL, 'a'
continueNum2Char:
            XOR AH, AH   
            MOV [BP+4], AX
            POPA
            POP BP
            RET
            ENDP 

char2num    PROC NEAR
            PUSH BP
            MOV BP, SP
            PUSHA
            MOV AL,BYTE PTR [BP+5]  ; +4 because it's near otherwise +6, then +1 because i want the higer part
            CMP AL, 'z'     ; char > 'z'
            JA endChar2num
                CMP AL, 'a'
                JAE lowerCase
                    ; Maybe upper Case
                    CMP AL, 'Z'
                    JA endChar2num
                        ; Maybe upper Case
                        CMP AL, 'A'
                        JB endChar2num
                            ; UpperCase
                            SUB AL, 'A'
                            JMP endChar2num
lowerCase:  SUB AL, 'a'
            ADD AL, 'Z'
            SUB AL, 'A'
            ADD AL, 1
endChar2num:MOV BYTE PTR [BP+5], AL  ; save in stack the return value
            POPA
            POP BP
            RET
char2num    ENDP

end