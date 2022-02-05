DIM EQU 12
.MODEL small
.STACK
.DATA
vett DW 15,64,9,2,4,5,9,1,294,52,-4,5
.CODE
.STARTUP
CALL MONOTONO
.EXIT      

MONOTONO PROC
    pusha
    
    mov cx,DIM-1
    xor si, si  ;index scanning vett
    xor dx, dx  ; current value in vett
    xor ax,ax   ; max subsequence (add 1 at the end)
    xor di,di   ; current subsequence dim
    xor bx,bx   ; index curr subsequence
    push bx     ; index max subsequence (x2)
cycle:
    mov dx, vett[si]    ; take first value
    add si, 2
    cmp dx, vett[si]    ; take second value
    jle continue         ; if first>second
        cmp di,ax
        jl notmax       ; if current dim subseq > max subseq
            mov ax, di  ; save new max
            add sp, 2   ; delete old index of max
            push bx     ; save the new intex of max
    notmax: 
        mov bx, si      ; new subsequence
        xor di, di      ; reset value 
        jmp continue_new
continue:
    add di, 1           ; add 1 to numbers in the subseq
continue_new:
    LOOP cycle
    ; last subsequence
    cmp di, ax
    jl notlast
        mov ax, di
        add sp, 2
        push bx
notlast:
    add ax, 1           ;
    pop bx
    shr bx, 1           ;
    
    popa
MONOTONO ENDP
END
