.model small
.stack
.data
R EQU 8 ; rows
C EQU 5 ; colums
matrix DB     1, 2, 3, 4, 5
       DB     6, 7, 8, 9, 0
       DB     9, 8, 7, 6, 5
       DB     4, 3, 2, 1, 0
       DB     7, 7, 7, 7, 7
       DB     3, 5, 7, 9, 0
       DB     8, 7, 6, 5, 4
       DB     9, 9, 9, 3, 2
            
.code
.startup

           MOV CX, C*R            ; counter for loop
           SHR CX, 1                 ; we know that 40 is even so we can do add and sub in a single cycle
           XOR AX, AX               ; it will store the result
           XOR DX, DX
           MOV SI, offset matrix ; Pointer to the matrix, used also as index
cycle:     MOV DL, [SI]
           ADD AX, DX               ; Add the even value
           INC SI
           MOV DL, [SI]                         ; Go to the next value
           SUB AX, DX               ; Sub the odd value
           INC SI                         ; Go to the next value
           LOOP cycle                 ; Loop for 20 times

           ; In AX now is stored the result value

.exit
end