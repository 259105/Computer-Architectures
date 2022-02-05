N EQU 4
M EQU 7
P EQU 5

.MODEL small
.STACK
.DATA
    matrix1 DB 3, 14, -15, 9, 26, -53, 5, 89, 79, 3, 23, 84, -6, 26, 43, -3, 83, 27, -9, 50, 28, -88, 41, 97, -103, 69, 39, -9
    matrix2 DB 37, 9, -23, 0, 9, 82, 70, -101, 74, 90, -62, 86, 5, -67, 0, 94, -78, 86, 28, 34, 9, 58, -4, 16, 20, 0, -21, 82, -20,59,-4,89,-34,1,14
    result  DW N*P DUP(?)
.CODE
.STARTUP 
    
    XOR cl,cl;                  Counter rows A cl=0 to N
    xor si,si;                  Counter cells A si=0 to M
    xor bx,bx;									Counter for the address of results    
    by_row_a:                   ; index cl
    
            xor di, di;         Counter cells B di=0 it is always resetted for a new row in A					
            XOR ch,ch;                  Counter colums B ch=0 to P
            
            by_colum_b:         ; index ch
                
                xor dx,dx;      temporary i sum of moltiplications

                mult_cell:      ; index si 
                    xor ah,ah;             ah must be 0
                    mov al, matrix1[si];   take the value matrixA[i][k]   
                    imul matrix2[di];      take the value matrixB[k][j] and multiply it
                    add dx, ax;    mov the result of the multiplication to matrix result, ordered by rows

                jno end_overflow
                    mov dx, 32767 ;     maximum number rappresentable on 16 bits
                    jnc end_overflow;   if it is negative so:
                        not dx;         i do not to change all bits with the opposite 
                        
                end_overflow:
                add di, 1;      go to the next value for moltiplication in B
                add si, 1;      go to the next value for moltiplication
                mov al, M;      this servs for the loop, each rows the condition is different
                mul cl;         with this I do M*CL,  so the condition of loop i s different for each line
                add ax, M;
                cmp si, ax;      si < M
                jl mult_cell;   jump      

            mov result[bx],dx;  move the sum of moltiplications in memory
            add bx, 2;      go to the next cell of the matrix result, plus 2 because it is a word matrix
            sub si,M;           go to the first element to moltiply 
                           
            add ch, 1;          increment ch to the next coulum of B   
            cmp ch, P;          ch < P
            jl by_colum_b;      jump 
    
    add si, M;                  go to the next row in A to multiply        
    add cl, 1;                  Increment cl to next row of A
    cmp cl, N;                  cl < N
    jl by_row_a;               jump
    
    ; ######################
    ; ##PRINT SIGNED VALUE##      
    ; ######################
    
    xor bx,bx       ; bx=0 it is a counter of the elements of result matrix
    
    print:
            mov cx, result[bx]  ; take the result
            push bx
            mov bx, cx          ; make a copy of ax in bx
            and cx, 8000H       ; get only the MSB
            and bx, 7FFFH       ; get the other bits without the MSB 
            cmp cx, 8000H
            jne positive        ; it is negative
                mov ah, 2       ;
                mov dl, 45      ; print the "-"
                int 21h
                sub cx, bx      ; get the modulo of the number
                mov bx, cx      ; copy the value in ax for printing 
            positive:           ; print only BX because it is positive
            mov ax,bx           ; if it is 
            mov cx, 10          ; for div by 10
            xor bl, bl          ; counter of digits
            division:
                    xor dx, dx  ; dx=0 for division
                    div cx      ; div by 10                   
                    push dx     ; push the residual
                    add bl, 1   ; increment the counter of digits
                cmp ax, 0
                jne division
            mov ah, 2
            print_digits:
                    pop dx      ; get the digit
                    add dl, 48  ; convert in ascii
                    int 21h
                sub bl, 1       ; sub the counter of digits
                cmp bl, 0
                jne print_digits    
            mov dl, ' '         ; print a space
            int 21h
            pop bx
            
        add bx, 2   ; increment the counter
            ; go to the next line if bx is a multiple of P
            mov ax, bx  ; for division
            mov cl, P*2   ; get the value of P
            div cl
            cmp ah, 0
            jne not_return
                mov ah, 2
                mov dl, 10
                int 21h
                mov dl, 13
                int 21h    
        not_return:         
        cmp bx, N*P*2 ; while cl<N*P then go to stampa
        JL print
.EXIT
END
