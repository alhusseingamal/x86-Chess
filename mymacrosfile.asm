;------------- get key press from the user ==> wait for user
getkeypress macro 
    mov ah, 0
    int 16h
endm getkeypress
;---------------------


;---------------- read a one-digit number
readN1 macro readin
    mov ah, 01
    int 21h
    sub al, 48    
    mov readin, al
endm readN1
;---------------------


;------------------ read a character from the user
readchar macro readin
    mov ah, 01
    int 21h    
    mov readin, al
endm readchar  
;---------------------


;----------------- read string character by character
readstring macro string_parameter, size_parameter
    mov cl, size_parameter
    cmp cl, 0
    je readstring_terminate
    readAgain:
    dec cl
    jnz readAgain
    readstring_terminate:
endm readstring   
;---------------------


;---------------------read two-digit number in variable num using ten = 10        
readN2 macro readin
    mov ah, 01h
    int 21h
    sub al, 48
    mul ten
    
    mov readin, al

    mov ah, 01h
    int 21h
    sub al, 48
    
    add readin, al
endm readN2
;---------------------
                       
                       
;--------------------- 
readN12 macro readin
    mov ah, 01h
    int 21h
    sub al, 48
    
    mov readin, al
    
    mov ah, 01h
    int 21h             
    
    cmp al, Enterasciicode
    je readN12_terminate
    
    sub al, 48
    
    mov ah, readin
    mov readin, al
    mov al, ah
    mul ten
    add readin, al
    
    readN12_terminate:
        
endm readN12
;---------------------

    
     
;--------------------- read a three-digit character
readN3 macro readin  ; readin is DW
    mov ah, 01h
    int 21h
    sub al, 48
    mul hundred
    
    mov readin, al
    
    mov ah, 01h
    int 21h
    sub al, 48
    mul ten
    
    add readin, al
        
    mov ah, 01h
    int 21h
    sub al, 48
    
    add readin, al
endm readN3  
;---------------------


;--------------------- write one-digit number 
writeN1 macro writeout
    mov ah, 02h        
    mov dl, writeout
    add dl, 48d
    int 21h         
endm writeN1
;---------------------

;--------------------- write a char
writechar macro writeout
    mov ah, 02h
    mov dl, writeout
    int 21h
endm writechar
;---------------------


;---------------------write two-digit number num using ten = 10 and dummy
writeN2 macro writeout
    
    mov al, writeout
    mov ah, 00h
    div ten
    
    mov dummy, ah
    
    mov dl, al
    add dl, 48d
    
    mov ah, 02h
    int 21h
    
    mov dl, dummy
    add dl, 48d
    
    mov ah, 02h
    int 21h
endm writeN2
;---------------------

;---------------------write 3-digit number
writeN3 macro writeout
    mov al, writeout
    mov ah, 0h
    div ten
    
    mov dummy1, ah
    
    mov ah, 0h
    div ten
    
    mov dummy2, ah
    
    mov dl, al
    add dl, 48
    mov ah, 02h
    int 21h
    
    mov dl, dummy2
    add dl, 48
    
    mov ah, 02h
    int 21h
    
    mov dl, dummy1
    add dl, 48
    
    mov ah, 02h
    int 21h
endm writeN3
;---------------------

;---------------------read string 
read macro buffername
    mov ah, 0ah
    mov dx, offset buffername
    int 21h
endm read             
;---------------------

;--------------------- move cursor position
movecursor macro x,y
    mov ah, 2
    mov dh, x
    mov dl, y
    int 10h
endm movecursor
;---------------------

;--------------------- get cursor position
getcursor macro ; saved in DL,DH row,col
    mov ah, 3
    mov bh, 0
    int 10h
endm getcursor
;---------------------

                              
;---------------------print single time                               
print macro text
    mov ah, 9h
    mov dx, offset text ; or LEA, text       
    int 21h
endm print         
;---------------------


;---------------------print macro n number of times      
printmany macro text, numberoftimes
    local lbl
    mov ah, 9h
    mov dx, offset text        
    mov cx, numberoftimes
    lbl: int 21h
    dec cx
    jnz lbl
endm printmany
;---------------------


;---------------------clears screen contents
clearscreen macro
	MOV AH,0
	MOV AL,3
	INT 10H
endm clearscreen      
;---------------------

;---------------------scroll screen
scrollscreen macro row, col ; ROW, COL ARE THE DIMENSIONS OF THE RIGHT MOST CORNER; THEY DETERMINE HOW MUCH THE SCREEN SCROLLS
    mov ax, 0600h
    mov bh, 0FH
    mov cx, 0h
    mov dh, row
    mov dl, col
    int 10h
endm scrollscreen
;---------------------


;--------------------- exit
exit macro
    mov ah, 4ch
    int 21h
endm exit
;---------------------
                      
                      
;---------------------print a  single character in colored background and/or font
printcoloredbckfnt1 macro val, bckfnt
    mov ah, 09 
    mov bh, 0h ; page number
    mov al, val ; value to be printed should be in al
    add al, 48d
    mov cx, 1h  ; number of times to print it : could later be modified to be passed as a parameter
    mov bl, bckfnt ; background and font color
    int 10h
endm printcoloredbckfnt1
;---------------------


;---------------------
printcharcoloredbckfnt1 macro val, bckfnt
    mov ah, 09 
    mov bh, 0h ; page number
    mov al, val ; value to be printed should be in al
    mov cx, 1h  ; number of times to print it : could later be modified to be passed as a parameter
    mov bl, bckfnt ; background and font color
    int 10h
endm printcharcoloredbckfnt1
;---------------------


;---------------------
printcoloredbckfnt2 macro val, bckfnt 
    mov ah, 0h
    mov al, val ; value to be printed should be in al
    div ten
    mov dummy1, ah
    
    add al, 48d
    
    mov ah, 09                        
    mov bh, 0h ; page number
    mov cx, 1h  ; number of times to print it : could later be modified to be passed as a parameter
    mov bl, bckfnt ; background and font color
    int 10h
    
    mov ah, 03h
    mov bh, 0h
    int 10h
    inc dl
    movecursor dh, dl
    
    mov al, dummy1
    add al, 48d
    
    
    mov ah, 09
    mov bh, 0h
    mov cx, 1h
    mov bl, bckfnt
    int 10h
endm printcoloredbckfnt2 
;---------------------


;--------------------- go to graphics mode ==> (you have to specify which one?)
graphicsmode macro
        mov ah, 0
        mov al, 13h
        int 10h
endm graphicsmode                       
;---------------------


;--------------------- go to text mode    
textmode macro                                  
        mov ah, 0
        mov al, 3h
        int 10h
endm textmode
;---------------------


;--------------------- go to monochrome mode
monochromemode macro
    mov ah, 0
    mov al, 7h
    int 10h
endm monochromemode              
;---------------------


;--------------------- draw a line
drawline macro
    graphicsmode
    mov cx, 0
    mov dx, 50
    mov ah, 0ch
    mov bh, 0
    mov al, 0fh
    drawagain: int 10h
    inc cx
    cmp cx, 320
    jnz drawagain
endm drawline
;---------------------

;--------------------- read an array of specific size
readArray macro arr_parameter, size_parameter
    mov cl, size_parameter
    cmp cl, 0h
    je readArray_terminate
    readAgain:
    readN1 num
    mov dl, num
    mov bx, i
    mov [arr_parameter+bx], dl
    inc i
    add col, 2
    movecursor row, col     
    dec cl
    jnz readAgain         
    readArray_terminate:
endm readArray
;---------------------

    
          
.model small
.stack 64
.data
;-------------Problem data----------
i db 0                              
j db 1
size db 10d
arr db 10d, 9d, 1d, 7d, 13d, 4d, 9d, 8d, 7d, 2d
outarr db 10 dup(0)
 
;-------------MACROS & GENERAL VARIABLES------
EnterAsciicode EQU 13d
Enterscancode EQU 1Ch
;size db 0
;i dw 0
;arr db 100 dup(0) ; the number is the max size
;outarr db 100 dup(0)
ten db 10
hundred db 100
dummy db 0
dummy1 db 0
dummy2 db 0         
res db 0
row db 1
col db 1
num db 0
mybuffer label byte
buffersize db 30
actualsize db ?
bufferdata db 30 dup('$') ; use print 'bufferdata' to print the read data
mes1 db 'hello world$'
;---------------------------------------------

.code
;.386 to use extra segment
main proc far
    mov ax, @data
    mov ds, ax 
    ;mov es, ax ; uncomment if you want to use the extra segment
                     
                             
                     
    program_ended:hlt
    endp main
end main                


;the ASSUME directive directs to the assembler the name of the stack, code and data segments
;The directive ASSUME facilitates to name the segments with the desired name that 
;is not a mnemonic or keyword.