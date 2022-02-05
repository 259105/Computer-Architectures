N EQU 4
M EQU 7
P EQU 5
.model small
.stack
.data
matrix1 DB 3, 14, -15, 9, 26, -53, 5, 89, 79, 3, 23, 84, -6, 26, 43, -3, 83, 27, -9, 50, 28, -88, 41, 97, -103, 69, 39, -9
matrix2 DB 37, 9, -23, 0, 9, 82, 70, -101, 74, 90, -62, 86, 5, -67, 0, 94, -78, 86, 28, 34, 9, 58, -4, 16, 20, 0, -21, 82, -20,59,-4,89,-34,1,14
result  DW N*P DUP(?)
.code
.startup
        XOR BP, BP  ; destination result
        MOV CX, N   ; cycleN
        XOR SI, SI  ; index matrix1
cycleN: XOR DI, DI  ; index matrix2
        PUSH CX
        MOV CX, P   ; cycleP
cycleP: XOR DX, DX  ; current sum
        XOR BX, BX  ; index internal multiplication
        PUSH CX
        MOV CX, M   ; cycleM
cycleM: MOV AL, matrix1[SI][BX]  ; take the first value
        XOR AH, AH  ; ah must be 0 for the moltiplication
        IMUL matrix2[DI][BX] ; multiply the first for the second
        ADD DX, AX  ; add the result to current res
        JNO noOverflow
            ; Overflow
            CMP DX, 0
            JGE positive
                ; negative
                MOV DX, 07FFFH  ; save in DX the maximum positive number
                JMP Overflow
positive:   MOV DX, 08000H  ; save in DX the minimum negative number
            JMP Overflow
noOverflow:
        ADD BX, 1   ; go to next multiplication
        LOOP cycleM
Overflow: MOV DS:result[BP], DX  ; save the result
        ADD BP, 2   ; go to next cell
        ADD DI, M   ; go to next P column
        POP CX
        LOOP cycleP
        ADD SI, M   ; go to next N row
        POP CX
        LOOP cycleN
.exit
end 
        