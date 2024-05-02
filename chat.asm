PUBLIC chatSCREEN

include Macros.inc

EXTRN configuration:FAR
EXTRN RECEIVE:FAR
EXTRN SEND:FAR
EXTRN p1name:byte

; .286
.model small
.stack 64
.data
;-------------CHAT MODULE VARIABLES-----------------
Xsend DB ?
Yrecieve DB ?
Char_Send    DB   ? 
Char_Recieve DB   ? 
Exit_Chat    DB   0
border    DB    "-----------------------------------------------------------------------------------$"
space DB ': $'
mes4 DB 'To end chatting, press F3$'
F3scancode equ 3Dh

.code
.386
chatSCREEN PROC FAR
    mov ax, @DATA
    mov ds, ax
        movecursor 01h,02h
        print mes4

        movecursor 02h, 00h
        print border

        movecursor 03h, 00h
        print p1name
        print space

        movecursor 0EH, 00h  
        
        print border

        movecursor 04h, 00h
        
        MOV BL,0
        MOV AX,0600h
        MOV BH,00fh         ; font and screen colour
        MOV CX,0400H        ;first half
        MOV DX,0d4fh		
        int 10h	

        MOV BL,0
        MOV AX,0600h
        MOV BH,00Fh       ;font and screen colour
        MOV CX,0F00h      ;second half
        MOV DX,184fh
        int 10h
        MOV BH,0  
        CALL configuration;first thing to do
    IsSenT:
        MOV DX , 3FDH    ; check Line Status Register 
        IN AL , DX 
        and AL , 1
        JZ next          ; There is no recieved data
        CALL Receive     ;if ready read the value IN received data register
        CMP Exit_Chat, 1
        JZ exitchat
        MOV AL,1 
        MOV DX , 3FDH 
        OUT DX,AL   
    next:
        MOV AH,1
        int 16h			 ;check if character available IN buffer
        JZ IsSenT        ; no char is written
        getkeypress ;lw buffer not empty asci IN AL,scan IN AH
        CMP AH, F3scancode
        JE exitchat
        CALL Send
        CMP Exit_Chat, 1
        JZ exitchat
        jmp IsSenT
  	
    exitchat:
        ; a3tkd hena hykon fe shwyt cleanup
        CLEARSCREEN 	
		RET  	
chatSCREEN ENDP
end