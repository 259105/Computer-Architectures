DIM EQU 50
MIN EQU 20
.MODEL SMAL
.STACK
.DATA

first_line DB DIM DUP(?)
second_line DB DIM DUP(?)
third_line DB DIM DUP(?)
fourth_line DB DIM DUP(?)
arrays DW 4 DUP(?)
occurences DB 52 DUP(?)
msg1 db "The most frequent character is: $"
msg2 db "List of characters appearing at least MAX/2: $"
   

.CODE
.STARTUP
     

MOV SI, 0       ; counter lines used also to access in memory

MOV arrays[0], offset first_line
MOV arrays[2], offset second_line
;MOV arrays[4], offset third_line
LEA AX, third_line
MOV arrays[4], AX
;MOV arrays[6], offset fourth_line
LEA AX, fourth_line
MOV arrays[6], AX

read_line:
    MOV BX, arrays[SI]  ; put offset in BX in order to use them after
    MOV DI, 0               ; reset the initial value of DI
    
    loop_zero:
        mov occurences[DI],0    ;loop used to azzerate array of occurences
        add DI,1
        cmp DI,52
        jl loop_zero
        
    mov DI, 0
    
    read:
        MOV AH, 1
        INT 21H         ; interrupt for reading

        cmp di, MIN     ;
        jge save        ; if DI>20 => go to save
            
            cmp AL, 13    ;
            jne save      ; if readed char is a \r => continue reading
                
                MOV AH, 2   ; writing \n to do line feed 10 in table ascii 
                MOV DL, 10
                INT 21H
                MOV AH, 1   ; reset value for reading in AH
                jmp read
    save: 
        cmp AL, 13      ; check if the char is \r
        je end          ; if it is \r so go to the end
    
        mov [BX][DI], AL ; save char in array
        mov AH, 0
        mov bp, AX 
        sub bp, 65       ; sottraggo 65 per rendere la A=0
        cmp bp, 26       ; se e'>26 vuol dire che e' minuscola
        JL save_occ
            sub bp, 6    ; adatto le minuscole in modo tale da partire dalla 27esima posizione nel vettore delle occorrenze
        save_occ:
        add ds:occurences[bp], 1     
        
        ADD DI, 1       ; increment index
        CMP DI, DIM     ; loop while DI<50
        JL read
        
        ; in this case we do not insert the final \r so we have to print it in order to see the pointer in the following line
        MOV AH, 2       ;      <-+
        MOV DL, 13      ;      <-+
        INT 21H         ;      <-+
        MOV AH, 1       ;      <-+
    
    end:
    
    ;   finding the max occurence
        
        mov DL, 0 ;register for the max value
        mov CH, 0 ; saving the position of the max
        mov BX, 0 ; used for counter
        max:
            mov CL, occurences[BX]      ; take the number of occurences
            add BX, 1
            cmp CL,DL
            jle end_max
                mov DL,CL
                mov CH,BL
                sub CH,1
            end_max:
            cmp BX, 52
            jl max
    ; print the max occurences        
        mov BH, CH  ; position in the array
        mov BL, DL  ; number of occurences
        mov ah, 2
        mov dl, 13  ; print \r
        int 21H
        mov dl, 10  ; print \n
        int 21H
        mov dx, offset msg1 ; print the message          
        mov ah, 9
        int 21h
    
    ; traslation in ASCII faccio l'operazione inversa di quanto fatto sopra
        add BH, 65
        cmp BH, 90
        jle traslate
            add bh, 6
        traslate:
        mov ah, 2
        mov dl, bh  ; stampo la lettera con piu' frequenze
        int 21h
        mov dl, 58  ;  :
        int 21h
        
        ; trasforno il numero in char per stamparlo
        ; I use the stack to semplify
        mov cl, 0       ; contatore delle cifre
        mov al, bl      ; sposto in al il numero delle occurences
        mov ch ,10      ; put 10 in bp for the division
        division:
            mov ah, 0
            div ch      ;divido il quoziente per 10 fin quando il quoziente diventa 0
            mov dh, 0
            mov dl, ah  ; i have to do so, because push accept only a regiester on 16 bit
            push dx     ; I push the resto in the stack 
            add cl, 1
            cmp al,0    ; I continue until the quoziente is 0
            jne division
        print_num:
            pop dx      ; pop the value and print it
            add dx, 48  ; conver the number in ascii char
            mov ah, 2
            int 21h
            sub cl, 1
            cmp cl, 0
            jne print_num
            
        ; PRINT THE MESSAGE FOR THE LIST OF OCCURENCES
        
        mov ah, 2
        mov dl, 13  ; print \r
        int 21H
        mov dl, 10  ; print \n
        int 21H
        mov dx, offset msg2 ; print the message          
        mov ah, 9
        int 21h
        
        ; PRINT THE CHAR WITH OCC > MAX/2
        
        mov DI,0     ; contatore
        sar bl, 1    ; faccio il massimo/2 attraverso uno shift register right
        occ:
            cmp occurences[DI],bl ;  compare the occurence i.esima with the max/2
            jl end_occ            ; if it is less then go to end_occ
                mov dx, di        ; save in bx the value of the letter
                add dl, 65        ; i make the conversion to ascii code
                cmp dl, 90
                jle end_conv
                    add dl, 6
                end_conv:
                mov ah, 2         
                ; print the letter
                int 21h
                mov dl, 58              ; stampo i :
                int 21h
                
                mov ch, 10              ; divisione per 10
                mov al, occurences[di]  ; divido ax per 10 
                mov cl ,0               ; counter digits
                gen_num_char:
                    mov ah, 0
                    div ch
                    mov dl, ah
                    mov dh, 0
                    push dx             ; pusho the residual in the stack
                    add cl, 1           ; increment the number of digits
                    cmp al,0            ; i compare the quozient with to check if the the number is ended
                    jne gen_num_char
                print_num_char:
                    pop ax              ; pop the first digit of the number
                    mov dl, al          ; mov the digit on dl for the print
                    add dl, 48          ; convert the digit in ascci code
                    mov ah, 2           ; interrup for print on stdout
                    int 21h
                    sub cl, 1
                    cmp cl, 0
                    jne print_num_char   
                mov ah, 2
                mov dl, 32
                int 21h     
            end_occ:
            add DI, 1
            cmp DI, 52
            jl occ
        ; GO IN A NEW LINE FOR THE CRYPTOGRAPH
       
        mov ah, 2
        mov dl, 13  ; print \r
        int 21H
        mov dl, 10  ; print \n
        int 21H
        
        ; CRYPTOGRAPH 
        
        mov di, 0      ; position in the array and counters
        mov bx, arrays[si]    ; take the current line
        mov dx, si ;mov in DH SI, because it serves to calculate k
        mov dh, dl
        sar dh, 1  ; i do shift register to right to divide SI, for example if the line is the third so SI=6 k=6/2=3
        add dh, 1  ; i have to add 1 because the array start from 0, so in the first line 0/2=0, and then we add 1
        mov ah, 2  ; for the writing in stdout
        crypt:  
                mov dl, [BX][di]    ; use DL register to store the ascci code
                cmp dl, 65                ; if it is under 65 it is not a letter
                jl end_crypt
                    cmp dl, 90       ; 90 is the value of Z in ascii
                    jle crypt_AZ
                        cmp dl, 97   ; 
                        jl end_crypt ; in this case it is not a letter
                            cmp dl, 123
                            jge end_crypt ; in this caseit is ot a letter
                                ; a...z
                                add dl, dh; in DH is stored k , so i do ascii code + k
                                cmp dl, 122      ; 122 in ascii is z
                                jle print_crypt_az
                                    sub dl, 58   ; it is a value to rotate in the maiusc ascii letters 
                                print_crypt_az:
                                int 21h
                                jmp end_crypt    
                    crypt_AZ:
                                ; A...Z
                                add dl, dh ; adding the value k
                                cmp dl, 90 ; 90 in ascii is 'Z'
                                jle print_crypt_AZ1
                                    add dl, 6 ; 6 are the ascii symblos in between 'Z' and 'a'
                                print_crypt_AZ1:
                                int 21h
        end_crypt:
            add di, 1      ; go to the next char
            cmp di, DIM    ; compare with the max and loop while bx<DIM
            jl crypt       

        MOV AH, 2   ; writing \n to do line feed 10 in table ascii 
        MOV DL, 10
        INT 21H
        mov dl, 13  ; writing \r to do carriage return
        int 21H
        MOV AH, 1   ; reset value for reading in AH
        
        ADD SI, 2
        CMP SI, 8
        JL read_line
   
.EXIT
END                                                                                                        
