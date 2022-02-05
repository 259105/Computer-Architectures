.model small
.stack
.data
SRC db 1,2,3,4,5,6,7,8,9,0,9,8,7,6,5,4,3,2,1,0,7,7,7,7,7,3,5,7,9,0,8,7,6,5,4,9,9,9,3,2
.code
.startup
    mov cx,5*8
    xor si,si
    xor ax,ax ; result
    xor dx,dx ; curr value
cycle:
    mov dl, src[si]
    mov bx,si
    and bx, 1
    cmp bx, 0
    je even
    ; odd
    sub ax, dx
    jmp continue
even:
    add ax, dx
continue:
    add si,1
    LOOP cycle
.exit
end