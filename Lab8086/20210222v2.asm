.model small
.stack
.data    
DIM EQU 3
SRC db 1,2,3,4,5,6,7,8,9
DEST dw  3*3 dup(?)
.code
.startup
    mov cx,DIM*DIM 
    xor di,di
    mov si, DIM 
    xor dx,dx
cycle:
    xor ax,ax
    mov al, src[di]  
    mov dl, src[si] 
    add ax,dx 
    shl di, 1
    mov dest[di],ax
    shr di, 1
    add si, 1
    add di, 1
    cmp si, DIM*DIM
    jne continue    
        xor si,si
continue:  
    LOOP cycle
.exit
end