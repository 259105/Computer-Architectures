.model small       
.stack
.data
M db 1,2,3,4,5,6,7,8,9,0,9,8,7,6,5,4,3,2,1,0,7,7,7,7,7
.code
.startup
    xor ax,ax
    xor si,si
    xor dx,dx
    mov dl,m[si]
    sub ax,dx
    add si,1
    mov cx,4
first:
    push cx
    mov cx,5
    second:
        mov dl,m[si]
        add ax,dx
        add si,1
        LOOP second
    pop cx
    mov dl, m[si]
    sub ax, dx
    add si, 1
    LOOP first
.exit
end