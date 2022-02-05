N EQU 4
.model small
.stack
.data
SOURCE DW 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P'
DESTINATION DW N*N DUP(?)
.code
.startup
;   GET n : # of rotations
    ;mov ah, 1   ; for int 21h
    ;int 21h     ; interrupt
    ;xor ah, ah  ; it keeps only al   
    
    mov ax, 80
    
    
    
    and ax, 3   ; 0000 0011 get the residual of division by 4  
    shl ax, 3   ; ax x8: x4 for the matrix 4x4; x2 for matrix word
    mov cx, N   ; setup loop of N cycles
    xor si, si  ; azzerate si
    mov di, si  ; setting delta form si to di
    add di, ax  ; setting delta from si to di
    cmp di, 0   ; 
;    jxx continue; if di<0
;        mov dx, di    ; save the of negative di we need it after
;        and di, 001FH ; 0001 1111 residual from /32
;        sub di, dx    ; conversion of negative index
first:
    push cx       ; save cx for the nested loop
    mov cx, 4     ; 
    and di, 001FH ;0001 1111 getting the residual of division by 32 (in the matrix there are 32 cells of bytes, because it is of words) 
    second:
        mov dx, SOURCE[SI]      ; moving from src to dest
        mov DESTINATION[DI], dx ; moving from src to dest
        add si, 2               ; increment by 2 because they are words
        add di, 2               ; increment by 2 because they are words
        LOOP second
    pop cx
    LOOP first   
.exit
end