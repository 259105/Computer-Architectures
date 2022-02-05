N EQU 5
.model small
.stack
.data
prezzi dw 39, 1880, 2394, 1000, 1590
sconto dw 1
scontati dw N dup(?)
totsconto dw ?
.code
.startup
    call sconti
.exit

sconti proc
    pusha
    
    mov cx, N   ; # of cycles
    xor si, si  ; offset for prezzi
    xor di, di  ; offset for scontati
    xor bp, bp  ; sum disconts
    ; BX is used to do multiplications and divisions
cycle:
    mov ax, prezzi[si]   ; take the price
    add bp, ax           ; add the price in the sum of disconts
    xor dx, dx           ; setup dx for mutiplycation on 16bits
    mov bx, 100    ; perche lo sconto va calcolato sul complementare
    sub bx, sconto ; sottraggo per trovare il complementare dello sconto
    mul bx         ; the result is stored in DX:AX
    mov bx, 100    ; divide for 100
    div bx         ; the quotient is in AX, the residual is in DX
    ; to round by excess i apply the formula 2*residual>=divisor
    ; so i know that residual is always less then the divisor
    ; since the divisor is 100, the res is rappresented on 7bits
    ; so i can do mul by 2 (shift left by 1) without problems of overflow
                ; shl dx, 1
    cmp dx, 50  ; cmp dx, 100
    jl cont
    ; round_up
        ; we know that the divisor is over than 1, so the quotient
        ; is minus than the dividend, and if the dividend is on 16 bits
        ; we will have no problems of overflow 
        add ax, 1
cont:    
     
    sub bp, ax            ; sub the price disconted on the sum of discounts 
    mov scontati[di], ax  ; save the price
    
    add si, 2   ; array of word
    add di, 2   ; array of word
    
    LOOP cycle
    
    mov totsconto, bp   ; save the total discont
    
    popa
    ret
sconti endp
end