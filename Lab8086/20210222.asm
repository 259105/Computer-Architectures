.model small
.stack
.data
SRC db 1,2,3,4,5,6,7,8,9
DEST dw  3*3 dup(?)
.code
.startup
    mov cx, 9         ; setting loop of 9 cycles
    xor si, si        ; resetting si to 0
    xor di, di        ; resetting si to 0
cycle:
    xor ax, ax
    mov al, SRC[si]   ; copy first line number to ax
    mov bx, si        ; save si for next coulum
    add si, 3         ; add si 3 in ordert to go to the next line
    cmp si, 9         ; 
    jl continue       ; if si>9
        sub si, 9     ; then si=si-9
continue:
    xor dx,dx
    mov dl, SRC[si]   ; add to ax the next number in the same coloum
    add ax, dx
    mov DEST[di], ax  ; save to dest
    mov si, bx        ; taking the real vaule of si
    add si, 1         ; setup for next cycle
    add di, 2         ; setup for next cycle
    LOOP cycle
    
.exit
end