Public Send
Public Receive
Public SendByte
Public RecieveByte
PUBLIC configuration
firs_half   dw 0400h
sec_half    dw 0f00h

.286
.model small
.stack 64
.CODE
Send PROC FAR 
	MOV Xsend,AL;if esc was clicked so exit
	CMP AL,27
    JNZ continue
	MOV DX ,3FDH		; Line Status Register, to send data check if THR empty or not
	AGAIN11:
  	In AL,DX 			;Read Line Status
	and AL , 00100000b
	JZ AGAIN11

	MOV DX , 3F8H		; (if empty)Transmit data register
    MOV  AL,Xsend
  	OUT DX , AL 
	MOV Exit_Chat, 1
	RET
	
	CMP AX, 0E08H
	JNZ continue
	MOV Xsend, 08H
	JMP sDisplay
	
	
    continue:	
	MOV AH,79
	CMP byte ptr firs_half,AH
	JB snot_end_x

	MOV AH,0Dh
	CMP byte ptr firs_half[1],AH
	JB sDisplay

	MOV word ptr firs_half,0D00h
	MOV AH,2
	MOV DX,word ptr firs_half   ;setting cursor
	int 10h 
	MOV BL,0
	MOV AX,0601h
	MOV BH,00Fh       ;scrolling one line
	MOV CX,0400h
	MOV DX,0D4fh
	int 10h
	jmp sDisplay

    snot_end_x:
	MOV AH,0Dh
	CMP byte ptr firs_half[1],AH 
	JB scheck_enter
	CMP AL,0Dh
	JNE sDisplay
	MOV word ptr firs_half,0D00h
	MOV BL,0
	MOV AX,0601h
	MOV BH,00Fh
	MOV CX,0400h
	MOV DX,0D4fh
    ;add DL,8
	int 10h
	jmp sDisplay

    scheck_enter:
	CMP AL,0dh
	JNE sDisplay
	MOV byte ptr firs_half,00h	
	inc byte ptr firs_half[1]
    	
	jmp sDisplay
	
    sDisplay:
	MOV AH,2
	MOV DX,word ptr firs_half
	int 10h 
	CMP Xsend, 08H
	JNZ PRINT_CHAR_MES
	MOV DL,08H                          ; IN ORDER TO REMOVE THE CHARACTER 
    MOV AH,2                            ; BACKSPACE WAS FIRST PRINTED 
    INT 21H
    MOV DL,' '                          ; THEN SPACE WAS PRINTED 
    MOV AH,2
    INT 21H
	MOV DL,08H                          ; IN ORDER TO REMOVE THE CHARACTER 
    MOV AH,2                            ; BACKSPACE WAS FIRST PRINTED 
    INT 21H
	JMP NEXT_STEP
    PRINT_CHAR_MES:
	MOV DL , Xsend;print char
	MOV AH ,2 
  	int 21h
    NEXT_STEP:
	MOV AH,3h 
	MOV BH,0h    ;getting cursor position
	int 10h
	MOV word ptr firs_half,DX

	MOV DX ,3FDH		; Line Status Register, to send data check if THR empty or not
	AGAIN1:
  	In AL,DX 			;Read Line Status
	and AL , 00100000b
	JZ AGAIN1

	MOV DX , 3F8H		; (if empty)Transmit data register
    MOV  AL,Xsend
  	OUT DX , AL 
	RET
Send ENDP
    ;-----------------------------------------------------------------------------------------------------------------------------
    ;-----------------------------------------------------------------------------------------------------------------------------
Receive PROC FAR 
        MOV DX , 03F8H
        IN AL , DX 
        MOV Yrecieve , AL
        CMP AL,27               ; esc was clicked 
        JZ buffer
        
        MOV AH,79
        CMP byte ptr sec_half,AH
        JB rnot_end_x

        MOV AH,18h
        CMP byte ptr sec_half[1],AH
        JB rDisplay

        MOV word ptr sec_half,1800h
        MOV AH,2
        MOV DX,word ptr sec_half
        int 10h 

        MOV BL,0
        MOV AX,0601h
        MOV BH,00Fh
        MOV CX,0F00h      ;scrolling one line
        MOV DX,184fh
        int 10h
        jmp rDisplay
    buffer:
        MOV Exit_Chat, 1
        RET
    rnot_end_x:

        MOV AH,18h
        CMP byte ptr sec_half[1],AH
        JB rcheck_enter
        CMP AL,0Dh
        JNE rDisplay
        MOV word ptr sec_half,1800h
        MOV BL,0
        MOV AX,0601h
        MOV BH,00Fh
        MOV CX,0F00h
        MOV DX,184fh
        int 10h
        jmp rDisplay

    rcheck_enter:
        CMP AL,0Dh
        JNE rDisplay
        MOV byte ptr sec_half,00h	
        inc byte ptr sec_half[1]	
        jmp rDisplay
        
    rDisplay:
        MOV AH,2
        MOV DX,word ptr sec_half
        int 10h 
        CMP Yrecieve, 08H
        JNZ PRINT_CHAR_2
        MOV DL,08H                          ; IN ORDER TO REMOVE THE CHARACTER 
        MOV AH,2                            ; BACKSPACE WAS FIRST PRINTED 
        INT 21H
        MOV DL,' '                          ; THEN SPACE WAS PRINTED 
        MOV AH,2
        INT 21H
        MOV DL,08H                          ; IN ORDER TO REMOVE THE CHARACTER 
        MOV AH,2                            ; BACKSPACE WAS FIRST PRINTED 
        INT 21H
        JMP NEXT_STEP_2
    PRINT_CHAR_2:
    MOV DL , Yrecieve
        MOV AH ,2 
        int 21h
    NEXT_STEP_2:	
        MOV AH,3h 
        MOV BH,0h 
        int 10h
        MOV word ptr sec_half,DX
        RET
Receive ENDP




    ;-----------------------------------------------------------------------------------------------------------------------------
    ; serial port configuration
    configuration PROC FAR
        MOV DX,3fbh 			; Line Control Register
        MOV AL,10000000b		;Set Divisor Latch Access Bit
        OUT DX,AL			    ;Out it
    
        MOV DX,3f8h	            ;set lsb byte of the baud rate devisor latch register	
        MOV AL,0ch		 	
        OUT DX,AL
    
        MOV DX,3f9h             ;set msb byte of the baud rate devisor latch register
        MOV AL,00h              ;to ensure no garbage IN msb it should be setted
        OUT DX,AL

        MOV DX,3fbh             ;used for send and receive
        MOV AL,00011011b
        OUT DX,AL
        RET
    configuration ENDP
    ;-----------------------------------------------------------------------------------------------------------------------------




    Sending_Char        PROC FAR 
        MOV DX , 3FDH            ; Line Status Register
    CHECK_AGAIN:        IN  AL , DX               ;Read Line Status
        TEST AL , 00100000b
        JZ CHECK_AGAIN
        ;If empty put the VALUE IN Transmit data register
        MOV DX , 3F8H ; Transmit data register
        MOV AL,Char_Send
        OUT DX , AL
        RET
    Sending_Char        ENDP 
    ;-----------------------------------------------------------------------------------------------------------------------------
    Recieving_Char      PROC FAR
        ;Check that Data is Ready
        MOV DX , 3FDH ; Line Status Register
        CHK_AGAIN: 			IN AL , DX
        TEST AL , 1
        JZ CHK_AGAIN ;Not Ready 
        ;If Ready read the VALUE IN Receive data register
        MOV DX , 3F8H
        IN AL , DX
        MOV Char_Recieve , AL
        RET
    Recieving_Char      ENDP	
        ;; ------------------------------------ Connection Procedures ----------------------- ;;
        
RecieveInvitations PROC FAR
    PUSHA

    ;Check that Data is Ready
    MOV DX , 3FDH		; Line Status Register
    IN AL , DX 
    test AL , 1
    JZ Return_RecieveInvitations             ; Not Ready

    ; If Ready read the VALUE IN Receive data register
    MOV DX , 03F8H
    IN AL , DX 

    CMP AL, F1scancode
    JZ Recievedchatinvite
    CMP AL, F2scancode
    JZ Recievedgameinvite
    JMP Return_RecieveInvitations

    Recievedchatinvite:
        MOV chatinvite, 1
        JMP Return_RecieveInvitations

    Recievedgameinvite:
        MOV gameinvite, 1
        JMP Return_RecieveInvitations

    Return_RecieveInvitations:
        POPA
        RET
RecieveInvitations ENDP







    RecieveByte PROC ; data is saved IN BL

            ;Check that Data is Ready
            MOV DX , 3FDH		; Line Status Register
            CHK_RecieveByte:
                IN AL , DX 
                test AL , 1
            JZ CHK_RecieveByte              ; Not Ready

            ; If Ready read the VALUE IN Receive data register
            MOV DX , 03F8H
            IN AL , DX 
            MOV BL , AL

            Return_RecieveByte:
                RET
        RecieveByte ENDP


CheckInvitationsAcception PROC FAR
    CMP AH, F1ScanCode
    JZ Acceptchatinvite
    CMP AH, F2ScanCode
    JZ Acceptgameinvite
    JMP Return_CheckInvitationsAcception

    Acceptchatinvite:
        CMP chatinvite, 0
        JZ Return_CheckInvitationsAcception
        MOV chatinvite, 0
        ;;; accepted invite
        ;;; Send Acception
        MOV BL, F1ScanCode
        CALL SendByte
        MOV Acceptchat, 1
        JMP Return_CheckInvitationsAcception

    Acceptgameinvite:
        CMP gameinvite, 0
        JZ Return_CheckInvitationsAcception
        MOV gameinvite, 0
        ;;; accepted invite
        ;;; Send Acception
        MOV BL, F2ScanCode
        CALL SendByte
        MOV Acceptgame, 1
        JMP Return_CheckInvitationsAcception

    Return_CheckInvitationsAcception:
        RET
    CheckInvitationsAcception ENDP


    SendGameInvite PROC FAR
            PUSHA
                MOV BL, F2ScanCode
                CALL SendByte
            POPA
            RET
    SendGameInvite ENDP
    SendChatInvite PROC FAR
            PUSHA
                MOV BL, F1ScanCode
                CALL SendByte
            POPA
            RET
    SendChatInvite ENDP


    



    WaitgameAcception PROC FAR
            WaitgameAccept:
                CALL RecieveByte
                CMP BL, F2ScanCode
                JZ gameaccepted
                JMP WaitgameAccept
            gameaccepted:
                RET
        WaitgameAcception ENDP



    WaitchatAcception PROC FAR
            WaitchatAccept:
                CALL RecieveByte
                CMP BL, F1ScanCode
                JZ chataccepted
                JMP WaitchatAccept
            chataccepted:
                RET
        WaitchatAcception ENDP


PrintInvitation PROC FAR                  
    movecursor 22h, 0h
    CMP chatinvite, 1
    JZ showchatinvitemes
    CMP gameinvite, 1
    JZ showgameinvitemes
    RET
    showchatinvitemes:
        print chatinvitemes
        RET
    showgameinvitemes:
        print gameinvitemes
        RET
PrintInvitation ENDP

ExchangeInfo PROC FAR
    CMP HOST, 1 ; The host is player 1
    JZ SENDFIRST
    JMP SENDSECOND

    SENDFIRST:

    lea SI, p1name
    CALL SendMsg
    LEA DI, p2name
    CALL RecMsg
        
        ;MOV BL, InitialPointsP1
    CALL SendByte

    CALL RecieveByte
        ;MOV InitialPointsP2, BL

    JMP Finish

    SENDSECOND:
    LEA DI, p1name
    CALL RecMsg
    lea SI, p2name
    CALL SendMsg

    CALL RecieveByte
        ; MOV InitialPointsP2, BL

        ; MOV BL, InitialPointsP1
        CALL SendByte


    Finish:
    RET
ExchangeInfo ENDP	



SendByte PROC FAR; data transferred is in THE ADDRESS AT DI
    PUSHA
    ;Check that Transmitter Holding Register is Empty
    MOV DX , 3FDH		        ; Line Status Register
    AGAIN:
        In AL, DX 			    ; Read Line Status
        test AL, 00100000b
        JZ AGAIN                    ; Not empty
    ;If empty put the VALUE IN Transmit data register
    MOV DX, 3F8H		        ; Transmit data register
    MOV AL, BL
    OUT DX, AL
    POPA
    RET
SendByte ENDP


SendData PROC  FAR; data transferred is pointed to by SI (8 bits)
    ;Check that Transmitter Holding Register is Empty
    MOV DX , 3FDH		        ; Line Status Register
    AGAIN_SendData:
        In AL, DX 			    ; Read Line Status
        test AL, 00100000b
    JZ AGAIN_SendData                    ; Not empty

    ;If empty put the VALUE IN Transmit data register
    MOV DX, 3F8H		        ; Transmit data register
    MOV AL, [SI]
    OUT DX, AL
    RET
SendData ENDP


SendMsg PROC FAR; Sent string offset is saved IN SI, ended with '$'
    SendMessage:
    CALL SendData
    inc SI
    MOV DL, '$'
    CMP DL , byte ptr [SI]-1
    JNZ SendMessage
    RET
SendMsg ENDP






RecMsg PROC FAR    ; Recieved string offset is saved IN di
    RecieveMsg:
    CALL RecieveByte
    MOV [di], BL
    inc di
    CMP BL, '$'
    JNZ RecieveMsg
    RET
RecMsg ENDP


RecieveData PROC FAR; data is saved IN BL

    ;Check that Data is Ready
    MOV DX , 3FDH		; Line Status Register
    CHK_RecieveData:
        IN AL , DX 
        test AL , 1
    JZ Return_RecieveData              ; Not Ready

    ; If Ready read the VALUE IN Receive data register
    MOV DX , 03F8H
    IN AL , DX 
    MOV BL , AL
    Return_RecieveData:
        RET
RecieveData ENDP

END