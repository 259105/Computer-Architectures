DIM EQU 4
.MODEL small
.STACK
.DATA

VETT DB DIM DUP(?)
.CODE
.STARTUP

MOV CX,DIM
MOV DI,0
MOV AH,1; set AH for reading
                                                            
lab1:
INT 21H; read a character, this is an interrupt
MOV VETT[DI], AL; store the character in AL
INC DI
DEC CX
CMP CX,0
JNE lab1

MOV CX,DIM
mov di,0
MOV AH,2; set AH for writing

lab2:
;DEC DI          
MOV DL,VETT[DI]
INT 21H; display the character
inc di
DEC CX
CMP CX,0
JNE lab2

.EXIT
END
                                                            