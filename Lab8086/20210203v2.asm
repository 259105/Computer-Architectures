DIM EQU 4
N EQU -1
.model small
.stack
.data
SRC DW 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P'
DST DW DIM*DIM DUP(?)
.code
.startup
    mov di, n   ; move n in di
    and di, 3   ; %4
    shl di, 3   ; set where we have to start in destination
    xor si, si  ; si = 0
    mov cx, DIM*DIM ; # of cycles are 4*4
cycle: mov ax, src[si]  ; take the from source
    mov dst[di], ax ; save in new postision in the dest
    add si, 2   ; for next char
    add di, 2   ; for next char  
    cmp di, 32  ; if di is arrived to the end fo the matrix, move it to start
    jne continue     
        xor di, di  ; di = 0
continue:
    LOOP cycle    
.exit
end