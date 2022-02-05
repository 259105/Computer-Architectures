DIM EQU 15
.MODEL SMALL
.STACK
.DATA

VETT DW 2,5,16,12,34,7,20,11,31,44,70,69,2,4,23
RESULT DW ?

.CODE
.STARTUP

MOV AX,0
MOV CX,DIM ;array size now stored in CX
MOV DI,0    ; DESTINATION INDEX 

lab:ADD AX,VETT[DI]; add i-th elememnt to AX
    ADD DI,2; go to the next element
    DEC CX
    CMP CX,0       ;compare index with zero
    JNE lab        ;if it is not zero then go to lab
    MOV RESULT, AX  ;copy the sum on RESULT in memory

.EXIT
END    