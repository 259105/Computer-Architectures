N EQU 6
.model small
.stack
.data
anni dw 1945, 2008, 1800, 2006, 1748, 1600
ris db n dup(?)
.code
.startup
    mov si, offset anni
    mov di, offset ris
    mov bx, N
    CALL bisestile
.exit

bisestile proc
    pusha
    
    mov cx,bx   ; cx <- lenght of vector
cycle:        
    mov ax,[si] ; ax <- year  for division
    mov bl, 100
    div bl      ; div by 100
    cmp ah, 0
    jne by4
    ; by 100
        mov ax, [si]
        xor dx,dx
        mov bx, 400
        div bx
        cmp dx, 0
        jne by100not
            mov [di], 1
        jmp next    
    by100not:
        mov [di], 0
    jmp next    
by4:
    ; by 4
    mov ax,[si]
    and ax, 0003H     ; take the residual of division by 4
    cmp ax, 0
    jne by4not:
        mov [di], 1
    jmp next
by4not:
    mov [di], 0
next:
    add si, 2 ; go to the next year
    add di, 1 ; go to the next result
    LOOP cycle    
    
    popa
    ret
bisestile endp
end
    