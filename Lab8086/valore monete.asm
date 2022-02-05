n equ 8
.model small
.stack
.data
valore dw 1,2,5,10,20,50,100,200
monete db 100,23,17,0,79,48,170,211
euro dw ?
cent dw ?
.code
.startup
    mov si, offset valore
    mov di, offset monete
    call CALCOLA
.exit
CALCOLA proc
    push bp
    mov bp, sp
    pusha
    
    mov cx, n
    mov euro, 0     ; setup result
    mov cent,0      ; setup result
cycle:
    xor dx, dx      ; setup dx for multiplication
    xor ah, ah
    mov al, [di]    ; take the number of coins
    mul [si]        ; multiply for the value of current coin
                    ; the result of mul is into DX:AX
    
    mov bx, 100     ; 
    div bx          ; DX:AX / BX(100) for getting euro and cents
    add euro, ax    ; ax is the quotient
    add cent, dx    ; dx is the residual
    
    add si, 2
    add di, 1
    loop cycle
   
    ; convert the sum of cents in euros
    mov ax, cent    ; take cent from memory
    mov bl, 100     
    div bl          ; divide it by 100  quotient in AL , residual AH
    mov bl, ah
    xor bh, bh
    xor ah, ah
    add euro, ax
    mov cent, bx
       
    popa
    pop bp
    ret
CALCOLA endp

end