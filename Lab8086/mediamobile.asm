DIM EQU 6
.model small
.stack
.data
vett1 dw 4, 6, 7, 12, 99 ,192
vett2 dw DIM dup(?)
num db 3
.code
.startup
    call mediam
.exit
mediam proc
    pusha
    xor si,si
    mov cx, dim-2
cycle1:
    push cx
    mov cl, num
    xor ch, ch
    mov bx, si
    xor ax, ax
    cycle2:
        add ax, vett1[si]
        add si, 2
        LOOP cycle2
    div num
    xor ah, ah
    mov si, bx
    mov vett2[si], ax
    add si, 2
    pop cx
    LOOP cycle1
    
    popa
    ret
mediam endp
end
