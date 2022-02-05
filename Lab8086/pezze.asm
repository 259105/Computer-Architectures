DIM EQU 5
.model small
.stack
.data
pezze   db 4, 4
        db 6, 7
        db 9, 5
        db 6, 4
        db 3, 4

.code
.startup
    mov al, 5
    mov ah, 4
    call  cerca
.exit
cerca proc
    
    cmp al, ah      ;if al>ah 
    jle continue    ;then al<->ah
        xchg al, ah
continue:
    mov bl, al
    mov bh, ah
    mov cx, DIM
    xor si, si
    mov di, 0ffffh
    xor dl, dl  ; major side
    xor al, al  ; minor side
    xor dh, dh  ; numbero of pezza
cycle1:
    mov al, pezze[si]
    add si, 1
    mov dl, pezze[si]
    add si, 1
    cmp al, dl
    jle continue2
        xchg al, dl
continue2:
    cmp al, bl
    jl no
        cmp dl, bh
        jl no
            mul dl
            cmp ax, di
            jae no
                mov di, ax 
                mov dx, si
                shl dx, 7
                sub dh, 1        
                
no:
    loop cycle1 
    mov dl, dh
    xor dh, dh    
    ret
cerca endp
end