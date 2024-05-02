;   MACROS
MoveArr1Arr2 macro Arr1, Arr21
    local moveloop, arrays_Moved
    push bx 
    push ax
    mov bx,0h
    mov ah,64d
    mov dummy1,ah
    moveloop:
    mov al, [Arr1+bx]
    mov [Arr21+bx], al
    inc bx
    dec dummy1
    cmp dummy1,0h
    je arrays_Moved
    jmp moveloop
    arrays_Moved:
    pop ax
    pop bx
endm MoveArr1Arr2

getkeypress macro 
    mov ah, 0
    int 16h
endm getkeypress

writeN1 macro writeout
    mov ah, 02h        
    mov dl, writeout
    add dl, 48d
    int 21h         
endm writeN1

GetSystemTime macro
    mov ah, 2ch
    int 21h ; ;CH = hour CL = minute DH = second DL = 1/100 seconds
endm GetSystemTime

textmode macro
    mov ah, 0
    mov al, 3h
    int 10h
endm textmode

graphicsmode macro
    mov ah, 0
    mov al, 13h
    int 10h
endm graphicsmode

;Clear Keyboard Buffer
clearkeyboardbuffer macro
    MOV AX,0C00h ; or mov ah, 08h
    INT 21h 
endm clearkeyboardbuffer

readchar macro readin
    mov ah, 01
    int 21h    
    mov readin, al
endm readchar

movecursor macro row_parameter, col_parameter
    mov ah, 2
    mov dh, row_parameter
    mov dl, col_parameter
    mov bh, 0
    int 10h
endm movecursor

read macro buffername   ; read mybuffer
    mov ah, 0ah 
    mov dx, offset buffername
    int 21h
endm read

copystring macro source, target, size
    LOCAL label1
    mov si,0 
    mov ch,0
    mov cl,size
    label1:
    mov al,source[si]
    mov target[si],al
    inc si
    loop label1
endm copystring


print macro text    ; print bufferdata
    mov ah, 9h
    mov dx, offset text        
    int 21h
endm print

clearscreen macro
    MOV AH,0
    MOV AL,3
    INT 10H
endm clearscreen

OpenFile macro Filehandle, Filename ; Open file
    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, Filename
    INT 21h
    
    ; you should check carry flag to make sure it worked correctly
    ; carry = 0 -> successful , file Handle -> AX
    ; carry = 1 -> failed , AX -> error code 
    MOV [Filehandle], AX
endm OpenFile

ReadData macro Filehandle, Width, Height, Data
    MOV AH,3Fh
    MOV BX, [Filehandle]
    MOV CX, Width* Height ; number of bytes to read
    LEA DX, Data
    INT 21h
endm ReadData 

CloseFile macro Filehandle
	MOV AH, 3Eh
	MOV BX, [Filehandle]
	INT 21h
endm CloseFile

exit macro
    mov ah, 4ch
    int 21h
endm exit

;------------TIMER FUNCTIONS--------------
TurnTimetostring macro numbefore,StringVariable ;number before becoming string, stringvariable to save new string in it
    local rem,end
    mov ah,0
    mov al,numbefore   
    aam             
    mov StringVariable+1 ,al 
    add StringVariable+1,'0'         ;aam  ah=al/10 remainder in al, value in ah  
    mov al,ah 
    mov ah,0                     
    aam  
    cmp al,6h
    jge rem 
    mov StringVariable ,al 
    add StringVariable,'0'
    jmp end  
    rem: 
    mov StringVariable ,'0'    
    end:
endm TurnTimetostring

; DELAYSecond MACRO
;     local delaying
;     delaying:   
;     GetSystemTime
;     cmp  dh, inctime ;CHECK IF NO SECOND HAS PASSED 
;     je   DELAYSecondEnd
;     ;IF NO JUMP, ONE SECOND HAS PASSED. VERY IMPORTANT : PRESERVE
;     ;SECONDS TO USE THEM TO COMPARE WITH NEXT SECONDS. THIS IS HOW
;     ;WE KNOW ONE SECOND HAS PASSED.
;     mov  inctime, dh
;     dec  delay   
;     jnz  delaying  ;IF DELAY IS NOT ZERO, REPEAT. 
;     mov delay,1
;     DELAYSecondEnd:
; endm DELAYSecond
;--------------------------


    ;BX has the offset of p1name
READNAME macro
                    MOV CX,15                           ; LOOP TILL THE TOTAL VALID CHARACTERS INPUT ARE 15
                    MOV SI,0                            ; INITIALIZE SI WITH 0 TO USE IT AS A POINTER 
        CHECK_FIRST_CHARACTER: MOV AH,0                  ; WAIT FOR KEY TO BE PRESSED 
                    INT 16H 
                    CMP AL,41H                          ; CHECK IF IT WITHIN THE ALPHABET LETTERS  'A' = 41H
                    JB CHECK_FIRST_CHARACTER                             
                    CMP AL,5AH                          ; IF IT WAS LESS THAN 'Z' = 5AH, SO IT IS A VALID FIRST CHARACTER 
                    JB VALID_FIRST_CHAR
                    CMP AL,61H                          ; IF IT IS LESS THAN 'a' = 61H, then it is not a valid first character
                    JB CHECK_FIRST_CHARACTER
                    CMP AL,7AH
                    JA CHECK_FIRST_CHARACTER            ; IF IT IS MORE THAN 'z' = 7AH, then it is not a valid first character
                    JBE VALID_FIRST_CHAR ; MY ADDITION
        TAKE_ANOTHER_INPUT: MOV AH,0
                    INT 16H
                    CMP AH,Enterscancode                        ; CHECK IF THE PRESSED KEY IS ENTER TO END ENTERING NAME 
                    JE END_TYPING 
                    CMP AH, 0Eh                       ; CHECK IF THE PRESSED KEY IS BACKSPACE
                    JE  DELETE_CHAR
        VALID_FIRST_CHAR: MOV [BX+SI],AL                 ; AFTER ALL VALIDATIONS ADD THE LETTER TO THE PLAYER NAME 
                    INC SI
                    INC p1nameactualsize   
                    MOV DL,AL                           ; PRINT THE VALID INPUT CHARACTER 
                    MOV AH,2
                    INT 21H
                    LOOP TAKE_ANOTHER_INPUT
                    JMP END_TYPING
        DELETE_CHAR: 
                    DEC p1nameactualsize
                    DEC SI
                    INC CX
                    MOV DL,08H                          ; IN ORDER TO REMOVE THE CHARACTER 
                    MOV AH,2                            ; BACKSPACE WAS FIRST PRINTED 
                    INT 21H
                    MOV DL,' '                          ; THEN SPACE WAS PRINTED 
                    MOV AH,2
                    INT 21H
                    MOV DL, "$"
                    MOV [BX+SI],DL                      ; OVERRIDE THE DATA SAVED PREVIUOSY 
                    MOV DL,08H                          ; THEN BACKSPACE AGAIN "NOTE: BACKSPACE ONLY BRING THE CURSOR OF TYPING ONE CHAR BACK WITHOUT DELETING" 
                    MOV AH,2
                    INT 21H
                    CMP CX, 15
                    JZ CHECK_FIRST_CHARACTER
                    JMP TAKE_ANOTHER_INPUT
        END_TYPING: 
endm READNAME

;-------DRAWING FUNCTIONS--------------
draw macro Width, Height, startingcolumn, color
    LOCAL drawLoop,drawnot
    mov AH, 0CH
    drawLoop:
    MOV AL,[BX]
    cmp al,color
    je drawnot
    INT 10h 
    drawnot:
    INC CX
    INC BX
    CMP CX,Width
    JNE drawLoop	
    MOV CX , startingcolumn
    INC DX
    CMP DX , Height
    JNE drawLoop
endm draw

Drawsquare macro xnote,ynote,color
   local first, second, third, fourth
    
    mov ah, 0ch
    mov al,color
    mov ch, 0
    mov cl,ynote
    mov dh, 0
    mov dl,xnote
    int 10h
    
   mov bl,22d
   first:
   int 10h
   inc cx
   dec bl
   jnz first 
   
    mov bl,22d
    second:
    int 10h
    inc dx
    dec bl
    jnz second
     
     
    mov bl,22d
    third:
    int 10h
    dec cx
    dec bl
    jnz third
   
    mov bl,22d
    fourth:
    int 10h
    dec dx
    dec bl
    jnz fourth
     
endm Drawsquare



draw_filled_square MACRO Width, Height, startingcolumn, color
    local DRAW_HORIZONTAL
            MOV AH,0Ch                   ;set the configuration to writing a pixel
			MOV AL,color 					 ;choose white as color
			MOV BH,00h 					 ;set the page number
		DRAW_HORIZONTAL:
			INT 10h    					 ;execute the configuration
			INC CX     					 ;CX = CX + 1		
			CMP CX,Width
			JNG DRAW_HORIZONTAL
			
			MOV CX,startingcolumn 				 ;the CX register goes back to the initial column
			INC DX       				 ;we advance one line
            
			CMP DX,Height
			JNG DRAW_HORIZONTAL
ENDM draw__filled_square

draw_board macro
    MOV CX, 0D
    MOV DX, 0D
    DRAW_HORIZONTAL1:
    MOV scol, CX
    MOV srow, DX
    MOV HorizontalDimension, squaredimension
    MOV VerticalDimension, squaredimension
    ADD HorizontalDimension, CX
    ADD VerticalDimension, DX
    draw_filled_square HorizontalDimension, VerticalDimension, scol, 0fh
    mov cx, scol
    mov dx, srow
    ADD CX, 44d; X-direction
    cmp cx, 154D
    JBE DRAW_HORIZONTAL1
    MOV CX, 0D
    ADD DX, 44D
    CMP DX, 154d
    JBE DRAW_HORIZONTAL1
    ;--------------
    MOV CX, 22D
    MOV DX, 22D
    DRAW_HORIZONTAL2:
    MOV scol, CX
    MOV srow, DX
    MOV HorizontalDimension, squaredimension
    MOV VerticalDimension, squaredimension
    ADD HorizontalDimension, CX
    ADD VerticalDimension, DX
    draw_filled_square HorizontalDimension, VerticalDimension, scol, 0fh
    mov cx, scol
    mov dx, srow
    ADD CX, 44d; X-direction
    cmp cx, 154D
    JBE DRAW_HORIZONTAL2
    MOV CX, 22D
    ADD DX, 44D
    CMP DX, 154d
    JBE DRAW_HORIZONTAL2
endm draw_board

draw_piece macro piecename_par, piecerow_par, piececol_par
    OpenFile PieceHandle, piecename_par
    ReadData PieceHandle, pieceDimension, pieceDimension, PieceData
    LEA BX,PieceData
    MOV CH, 0D
    MOV CL,piecerow_par; X-direction
    MOV DH, 0D
    MOV DL,piececol_par; Y-direction
    MOV scol, CX
    MOV HorizontalDimension, piecedimension
    MOV VerticalDimension, piecedimension
    ADD HorizontalDimension, CX
    ADD VerticalDimension, DX
    draw HorizontalDimension, VerticalDimension, scol,0fh
    CloseFile PieceHandle
endm draw_piece

draw_piece2 macro piecename_par, piecerow_par, piececol_par
    OpenFile PieceHandle, piecename_par
    ReadData PieceHandle, PieceDimension, PieceDimension, pieceData
    LEA BX,pieceData
    MOV CH, 0D
    MOV CL,piecerow_par; X-direction
    MOV DH, 0D
    MOV DL,piececol_par; Y-direction
    MOV scol, CX
    MOV HorizontalDimension, PieceDimension
    MOV VerticalDimension, PieceDimension
    ADD HorizontalDimension, CX
    ADD VerticalDimension, DX
    draw HorizontalDimension, VerticalDimension, scol,00h
    CloseFile PieceHandle
endm draw_piece2

calculate_square macro row_parameter, col_parameter, calculated_square ; square = 8 * row + col
    mov ah, 0
    mov al, col_parameter
    div twentytwo
    mov calculated_square, al
    
    mov ah, 0
    mov al, row_parameter
    div twentytwo
    mul eight

    add calculated_square, al
endm calculate_square

 ; takes row, col and using them gets the piece type on that square by accessing the memory location of that square
 RConfigurePieceSelection macro row_parameter, col_parameter
    mov bl, row_parameter
    mov SelectedPieceRow, bl
    mov bl, col_parameter
    mov SelectedPieceCol, bl
    calculate_square SelectedPieceRow, SelectedPieceCol, SelectedPieceSquare
    GetSquarePieceCode SelectedPieceCode, SelectedPieceSquare
    
    CALL CheckPieceTimer
    CMP LOCKED, 1D
    JNE RCHECKIFSQUAREWASEMPTY
    MOV SelectedPieceCode, 0D

    RCHECKIFSQUAREWASEMPTY:
    ; Check that the selected square is not empty
    cmp SelectedPieceCode, 0 
    JE RConfigurePieceSelection_end
    mov PieceInSelection, 1h
    RConfigurePieceSelection_end:
endm RConfigurePieceSelection

ConfigurePieceSelection macro row_parameter, col_parameter
    mov bl, row_parameter
    mov SelectedPieceRow, bl
    mov bl, col_parameter
    mov SelectedPieceCol, bl
    calculate_square SelectedPieceRow, SelectedPieceCol, SelectedPieceSquare
    GetSquarePieceCode SelectedPieceCode, SelectedPieceSquare
    
    CALL CheckPieceTimer
    CMP LOCKED, 1D
    JNE CHECKIFSQUAREWASEMPTY
    MOV SelectedPieceCode, 0D

    CHECKIFSQUAREWASEMPTY:
    ; Check that the selected square is not empty
    cmp SelectedPieceCode, 0 
    JE ConfigurePieceSelection_end
    mov PieceInSelection, 1h
    ConfigurePieceSelection_end:
endm ConfigurePieceSelection

configureDes macro row_parameter, col_parameter
    mov bl, row_parameter
    mov DesRow, bl
    mov bl, col_parameter
    mov DesCol, bl
    calculate_square DesRow, DesCol, DesSquare
    GetSquarePieceCode DesPieceCode, DesSquare
endm configureDes
;----------------------------------

getSquareColor macro squarecolor_parameter, squarenumber_parameter
    MOV BH, 0
    MOV BL, squarenumber_parameter
    MOV AL, [SquareColorArray+BX]
    MOV squarecolor_parameter, AL
endm getSquareColor

GetSquarePieceCode macro squarecode_parameter, squarenumber_parameter
    MOV BH, 0
    MOV BL, squarenumber_parameter
    MOV AL, [SquarePieceArray+BX]
    MOV squarecode_parameter, AL
endm GetSquarePieceCode

getRowColumnfromsquareNumber macro squarerow_parameter , squarecolumn_parameter ,squarenumber_parameter
    mov bh, 0
    mov bl, squarenumber_parameter
    mov al, [SquareRowArray + BX]
    mul twentytwo
    mov squarerow_parameter , al
    mov al, [SquareColumnArray + BX]
    mul twentytwo
    mov squarecolumn_parameter , al
endm getRowColumnfromsquareNumber


GetSquareNumberFromPieceCode macro piececode_parameter, squarenumber_parameter
    MOV BX, 0
    MOV CL, 64D
    GetSquareNumberFromPieceCodeLABEL1:
    CMP [SquarePieceArray + BX], piececode_parameter
    JE FOUND
    INC BX
    DEC CL
    JNZ GetSquareNumberFromPieceCodeLABEL1
    FOUND:
    MOV squarenumber_parameter, BL
endm GetSquareNumberFromPieceCode



UpdateSquare macro squarenumber_parameter, piececode_parameter ; UPDATES THE SQUAREPIECEARRAY WITH THE CODE OF THE NEW ADDED PIECE
    MOV BH, 0D
    MOV BL, squarenumber_parameter
    MOV AL, piececode_parameter
    MOV [SquarePieceArray + BX], AL
endm UpdateSquare

Redraw macro SelectedPieceCode, piecerow_par,piececol_par
    cmp SelectedPieceCode, 1d
    je GetBTabya
    cmp SelectedPieceCode, 2d
    je GetBhosan
    cmp SelectedPieceCode, 3d
    je GetBfeel
    cmp SelectedPieceCode, 4d
    je GetBqueen
    cmp SelectedPieceCode, 5d
    je GetBking
    cmp SelectedPieceCode, 6d
    je GetBgond
    cmp SelectedPieceCode, 7d
    je GetWTabya
    cmp SelectedPieceCode, 8d
    je GetWhosan
    cmp SelectedPieceCode, 9d
    je GetWfeel
    cmp SelectedPieceCode, 10d
    je GetWqueen
    cmp SelectedPieceCode, 11d
    je GetWking
    cmp SelectedPieceCode, 12d
    je GetWgond
    ; cmp SelectedPieceCode, 100d
    ; jne Redrawend
    JMP Redrawend
  
    GetBTabya:
    draw_piece tabia,piecerow_par, piececol_par
    jmp Redrawend
    GetBhosan:
    draw_piece hosan, piecerow_par, piececol_par
    jmp Redrawend
    GetBfeel:
    draw_piece feel, piecerow_par, piececol_par
    jmp Redrawend
    GetBqueen:
    draw_piece queen, piecerow_par, piececol_par
    jmp Redrawend 
    GetBking:
    draw_piece king, piecerow_par, piececol_par
    jmp Redrawend 
    GetBgond:
    draw_piece Solider, piecerow_par, piececol_par
    jmp Redrawend

    GetWTabya:
    draw_piece2 tabia2, piecerow_par, piececol_par
    jmp Redrawend
    GetWhosan:
    draw_piece2 hosan2, piecerow_par, piececol_par
    jmp Redrawend
    GetWfeel:
    draw_piece2 feel2, piecerow_par, piececol_par
    jmp Redrawend
    GetWqueen:
    draw_piece2 queen2, piecerow_par, piececol_par
    jmp Redrawend 
    GetWking:
    draw_piece2 king2, piecerow_par, piececol_par
    jmp Redrawend 
    GetWgond:
    draw_piece2 Solider2, piecerow_par, piececol_par
    jmp Redrawend
    Redrawend:
endm Redraw

ResetVariables macro
mov FL , 0
mov SL , 0
mov NotificationVar , 1D
mov NextNotification , 0
mov WhitegondiDeath , 0
mov WhiteTabyaDeath , 0  
mov WhitefeelDeath , 0
mov WhiteKingDeath , 0
mov WhiteQueenDeath , 0
mov WhiteHosanDeath , 0   
mov BlackgondiDeath , 0
mov BlackTabyaDeath , 0
mov BlackfeelDeath , 0
mov BlackKingDeath , 0
mov BlackQueenDeath , 0
mov BlackHosanDeath , 0
;---TIMER VARIABLES---
MoveArr1Arr2 StartTimeArrayCopy,StartTimeArray
MoveArr1Arr2 StartTimeArrayCopy,timerArray
;mov StartTimeArray , 64 DUP(0)
;mov timerArray , 64 dup(0)
mov CountDownTime , 35d
mov LOCKED , 0d
mov dummy1 , 0
mov dummy2 , 0
mov dummy3 , 0
mov dummy4 , 0
mov BKingPos , 4d ; initial position of the black king
mov WkingPos , 60d ; initial position of the white king
mov BKINGROW1 , 0D
mov BKINGCOL1 , 88D
mov wkingrow1 , 154D
mov wkingcol1 , 88D
mov WKingChecked , 0h
mov BKingChecked , 0h
mov THERE_IS_A_WINNER , 0h
mov GAME_END , 0h
;--------------
mov number_of_potential_cells , 0
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_col
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_row
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_squareNumber
;mov potential_cells_row , 64 dup(0)
;mov potential_cells_col , 64 dup(0)
;mov potential_cells_squareNumber , 64 dup(0)
mov to_test_row , 0
mov to_test_col , 0
mov to_test_squareNumber , 0
mov to_test_square_piececode , 0
mov IsSameColor , 0
;----Moving a piece-----
mov PieceInSelection , 0
mov selectedSquareColor , 0h
mov selectedPieceSquare , 0
mov SelectedPieceRow , 0
mov SelectedPieceCol , 0
mov SelectedPieceCode , 0 ; initially no piece is selected 
mov DesRow , 0
mov DesCol , 0
mov DesSquare , 0
mov DesColor , 0
mov DesPieceCode , 0
;------------player1 Plays---------
mov number_of_potential_cellsp1 , 0
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_rowp1
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_colp1
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_squareNumberp1
;mov potential_cells_rowp1 , 64 dup(0)
;mov potential_cells_colp1 , 64 dup(0)
;mov potential_cells_squareNumberp1 , 64 dup(0)
mov PieceInSelectionp1 , 0
mov selectedSquareColorp1 , 0h
mov selectedPieceSquarep1 , 0
mov SelectedPieceRowp1 , 0
mov SelectedPieceColp1 , 0
mov SelectedPieceCodep1 , 0 ; initially no piece is selected 
mov DesRowp1 , 0
mov DesColp1 , 0
mov DesSquarep1 , 0
mov DesColorp1 , 0
mov DesPieceCodep1 , 0
;-------------PLAYER 2 PLAYS--------------
mov number_of_potential_cellsp2 , 0
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_colp2
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_squareNumberp2
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_rowp2
;mov potential_cells_rowp2 , 64 dup(0)
;mov potential_cells_colp2 , 64 dup(0)
;mov potential_cells_squareNumberp2 , 64 dup(0)
mov PieceInSelectionp2 , 0
mov selectedSquareColorp2 , 0h
mov selectedPieceSquarep2 , 0
mov SelectedPieceRowp2 , 0
mov SelectedPieceColp2 , 0
mov SelectedPieceCodep2 , 0 ; initially no piece is selected 
mov DesRowp2 , 0
mov DesColp2 , 0
mov DesSquarep2 , 0
mov DesColorp2 , 0
mov DesPieceCodep2 , 0
 ;---------------------
mov isValidMove , 1H
mov IsOccupiedFlag , 0
mov IsSameColorFlag , 0
mov Isfirstgame , 1 
 ;------------General Variables-------
mov cell_color , 0
mov cell_number , 0

 ;----Movements------
mov selected_frame_row , 0 ; y
mov selected_frame_col , 0 ; x
mov selected_frame_square , 0; initially at upper left 
mov selected_frame_color , 0h 
 ;--------------------
mov selected_frame_row1 , 0D ; y
mov selected_frame_col1 , 0d ; x
mov selected_frame_square1 , 0d; initially at upper left 
mov selected_frame_color1 , 0h 
 ;---------------
mov selected_frame_row2 , 154D ; y
mov selected_frame_col2 , 154d ; x
mov selected_frame_square2 , 63d; initially at lower right
mov selected_frame_color2 , 0h 
 
 ;---------game timer variables-------
mov aux_time , 0
;mov secondsstr , 2,?,'$'
;mov noerror3 , 1,?,'$'
;mov minutesstr , 2,?,'$'
;mov noerror2 , 1,?,'$'
;mov hoursstr , 2,?,'$'  
;mov noerror , 1,0,'$'
mov seconds , 0
mov minutes , 0
mov hours   , 0 
mov delay , 1 
mov inctime , 0  

 ;---king INFO-----------
mov bkingrow , 0088d
mov bkingcol , 00H
 ;---queen INFO-----------
mov bqueenrow , 66d
mov bqueencol , 00h
;---tabia INFO-----------
mov btabiarow , 00h
mov btabiacol , 00h
mov btabia2row , 154d
mov btabia2col , 00h
;---hosan INFO-----------
mov bhosanrow , 22d
mov bhosancol , 00h
mov bhosan2row , 132d
mov bhosan2col , 00h
;---feel INFO-----------
mov bfeelrow , 44d
mov bfeelcol ,  00h
mov bfeel2row , 110d
mov bfeel2col , 00h
;---solider INFO-----------
mov bsoliderrow , 0d
mov bsolidercol ,  22D
mov bsolider2row , 22D
mov bsolider2col , 22d
mov bsolider3row , 44D
mov bsolider3col , 22d
mov bsolider4row , 66d
mov bsolider4col , 22d
mov bsolider5row , 88d
mov bsolider5col , 22d
mov bsolider6row , 110d
mov bsolider6col , 22d
mov bsolider7row , 132d
mov bsolider7col , 22d
mov bsolider8row , 154d
mov bsolider8col , 22d
;---solider2 INFO-----------
mov wsoliderrow , 0000H
mov wsolidercol ,  132d
mov wsolider2row , 22d
mov wsolider2col ,  132d
mov wsolider3row , 44D
mov wsolider3col ,  132d
mov wsolider4row , 66d
mov wsolider4col ,  132d
mov wsolider5row , 88d
mov wsolider5col ,  132d
mov wsolider6row , 110d
mov wsolider6col ,  132d
mov wsolider7row , 132d
mov wsolider7col ,  132d
mov wsolider8row , 154d
mov wsolider8col ,  132d
;---hosan2 INFO-----------
mov whosanrow , 22d
mov whosancol , 154d
mov whosan2row , 132d
mov whosan2col , 154d
;---tabia INFO-----------
mov wtabiarow , 00H
mov wtabiacol , 154d
mov wtabia2row , 154d
mov wtabia2col , 154d
;---feel2 INFO-----------
mov wfeelrow , 44d
mov wfeelcol , 154d
mov wfeel2row , 110d
mov wfeel2col , 154d
;---king2 INFO-----------
mov wkingrow , 66d
mov wkingcol , 154d
;---queen2 INFO-----------
mov wqueenrow , 88d
mov wqueencol , 154d
;----GENERAL VARIABLES AND DATA------
mov HorizontalDimension , 0
mov VerticalDimension , 0
mov SCOL , 0 ; starting column
mov SROW , 0

mov checkname , 0
mov checkname1 , 0
;-----------------
mov key , ?
mov NotificationBarMessage , 0

;-------Sending and Receiveing----------------
mov CharacterSent , (?)
mov Characterreceived , 0FFh
; ---------- Connection Variables ----- ;
mov gameinvite , 0
mov chatinvite , 0
mov Acceptgame , 0
mov Acceptchat , 0
mov HOST , 0
;-----------------------------
;mov mybuffer label byte
mov buffersize , 16 
mov actualsize , ?
MoveArr1Arr2 StartTimeArrayCopy,bufferdataCopy
;mov bufferdata , 16 dup('$')
MoveArr1Arr2 SquarePieceArrayCopy,SquarePieceArray
endm ResetVariables 


.model small
.stack 64
.data
Who_Plays DB 0D ; 0 FOR BLACK, 1 FOR WHITE
SELECTION DB 3D
;--------GAME CHAT VARIABLES-----------------
border2    db    "-----------------$"
space2 db ': $'
empty2 db " $"
xpos db 15
ypos db 102d
xpos2 db 20
ypos2 db 102d
letter db 1,?,'$'
noerror4 db 1,?,'$'
letter2 db 1,?,'$'
noerror5 db 1,?,'$'
;------------Notifications-------
FL db 0
SL db 0
NotificationVar DB 1D
NextNotification dw 0
BKill db 0           
WKill db 0
WhiteKill db 'White Killed = $'
BlackKill db 'Black Killed = $'
Wkkill db 2,?,'$'
Bkkill db 2,?,'$'
WhitePlayerWonMessage db 'WhitePlayer Won         $'
BlackPlayerWonMessage db 'BlackPlayer Won         $'
WhitegondiDeath db 0
WhiteTabyaDeath db 0  
WhitefeelDeath db 0
WhiteKingDeath db 0
WhiteQueenDeath db 0
WhiteHosanDeath db 0   
BlackgondiDeath db 0
BlackTabyaDeath db 1
BlackfeelDeath db 0
BlackKingDeath db 0
BlackQueenDeath db 0
BlackHosanDeath db 0
;---TIMER VARIABLES---
StartTimeArrayCopy DB 64 DUP(0)
StartTimeArray DB 64 DUP(0)
timerArray db 64 dup(0)
CountDownTime db 40d
LOCKED db 0d
;----------
dummy1 db 0
dummy2 DB 0
dummy3 DB 0
dummy4 DB 0
SquareRowArray db 0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7
SquareColumnArray db 0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7
SquareColorArray db 0fh, 00h,0fh, 00h,0fh, 00h,0fh, 00h,00h,0fh, 00h,0fh, 00h,0fh, 00h,0fh,0fh, 00h,0fh, 00h,0fh, 00h,0fh, 00h,00h,0fh, 00h,0fh, 00h,0fh, 00h,0fh,0fh, 00h,0fh, 00h,0fh, 00h,0fh, 00h,00h,0fh, 00h,0fh, 00h,0fh, 00h,0fh,0fh, 00h,0fh, 00h,0fh, 00h,0fh, 00h,00h,0fh, 00h,0fh, 00h,0fh, 00h,0fh
SquarePieceArray db 1,2,3,4,5,3,2,1,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12d,12d,12d,12d,12d,12d,12d,12d,7,8,9,10d,11d,9,8,7
SquarePieceArrayCopy db 1,2,3,4,5,3,2,1,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12d,12d,12d,12d,12d,12d,12d,12d,7,8,9,10d,11d,9,8,7
BKingPos db 4d ; initial position of the black king
WkingPos db 60d ; initial position of the white king
BKINGROW1 DB 0D
BKINGCOL1 DB 88D
wkingrow1 DB 154D
wkingcol1 DB 88D
WKingChecked db 0h
BKingChecked db 0h
THERE_IS_A_WINNER db 0h
GAME_END DB 0h
;--------------
number_of_potential_cells db 0
potential_cells_row db 64 dup(0)
potential_cells_col db 64 dup(0)
potential_cells_squareNumber db 64 dup(0)
to_test_row db 0
to_test_col db 0
to_test_squareNumber db 0
to_test_square_piececode db 0
IsSameColor db 0
;----Moving a piece-----
PieceInSelection db 0
selectedSquareColor db 0h
selectedPieceSquare db 0
SelectedPieceRow db 0
SelectedPieceCol db 0
SelectedPieceCode db 0 ; initially no piece is selected 
DesRow db 0
DesCol db 0
DesSquare db 0
DesColor db 0
DesPieceCode db 0
;------------player1 Plays---------
number_of_potential_cellsp1 db 0
potential_cells_rowp1 db 64 dup(0)
potential_cells_colp1 db 64 dup(0)
potential_cells_squareNumberp1 db 64 dup(0)
PieceInSelectionp1 db 0
selectedSquareColorp1 db 0h
selectedPieceSquarep1 db 0
SelectedPieceRowp1 db 0
SelectedPieceColp1 db 0
SelectedPieceCodep1 db 0 ; initially no piece is selected 
DesRowp1 db 0
DesColp1 db 0
DesSquarep1 db 0
DesColorp1 db 0
DesPieceCodep1 db 0
;-------------PLAYER 2 PLAYS--------------
number_of_potential_cellsp2 db 0
potential_cells_rowp2 db 64 dup(0)
potential_cells_colp2 db 64 dup(0)
potential_cells_squareNumberp2 db 64 dup(0)
PieceInSelectionp2 db 0
selectedSquareColorp2 db 0h
selectedPieceSquarep2 db 0
SelectedPieceRowp2 db 0
SelectedPieceColp2 db 0
SelectedPieceCodep2 db 0 ; initially no piece is selected 
DesRowp2 db 0
DesColp2 db 0
DesSquarep2 db 0
DesColorp2 db 0
DesPieceCodep2 db 0
;---------------------
isValidMove DB 1H
IsOccupiedFlag db 0
IsSameColorFlag db 0
Isfirstgame db 1 
;------------General Variables-------
twentytwo db 22d
eight db 8d
cell_color db 0
cell_number db 0
;-----colors---------
black_color db 0h
red_color db 04h
white_color db 0fh
cyan_color db 1h
green_color db 2h
yellow_color db 0EH
;----Movements------
distance EQU 22d
selected_frame_row db 0 ; y
selected_frame_col db 0 ; x
selected_frame_square db 0; initially at upper left 
selected_frame_color db 0h 
;--------------------
selected_frame_row1 db 0D ; y
selected_frame_col1 db 0d ; x
selected_frame_square1 db 0d; initially at upper left 
selected_frame_color1 db 0h 
;---------------
selected_frame_row2 db 154D ; y
selected_frame_col2 db 154d ; x
selected_frame_square2 db 63d; initially at lower right
selected_frame_color2 db 0h 

;---------game timer variables-------
aux_time db 0
secondsstr db 2,?,'$'
noerror3 db 1,?,'$'
minutesstr db 2,?,'$'
noerror2 db 1,?,'$'
hoursstr db 2,?,'$'  
noerror db 1,0,'$'
seconds db 0
minutes db 0
hours   db 0 
delay db 1 
inctime db 0  
;---------Square INFO------
squaredimension equ 21d
pieceDimension equ 22d
PieceHandle DW ?
PieceData DB pieceDimension*pieceDimension dup(0)
;------BONUS VARIABLES-------------
powerup db 'p22.bin', 0   ; We assume powerup has the code 13d
PowerUpSquare db 64D
PowerUpSquareColor db 0h
poweruprow db 0h
powerupcol db 0h
poweruponboard db 0h
powerupselector db 0h
;---king INFO-----------
king DB 'bking.bin', 0
bkingrow DB 0088d
bkingcol DB 00H
;---queen INFO-----------
queen DB 'bqueen.bin', 0
bqueenrow DB 66d
bqueencol DB 00h
;---tabia INFO-----------
tabia DB 'btabya.bin', 0
btabiarow DB 00h
btabiacol DB 00h
btabia2row DB 154d
btabia2col DB 00h
;---hosan INFO-----------
hosan DB 'bhosan.bin', 0
bhosanrow DB 22d
bhosancol DB 00h
bhosan2row DB 132d
bhosan2col DB 00h
;---feel INFO-----------
feel DB 'bfeel.bin', 0
bfeelrow DB 44d
bfeelcol DB  00h
bfeel2row DB 110d
bfeel2col DB 00h
;---solider INFO-----------
Solider DB 'bgond.bin', 0
bsoliderrow DB 0d
bsolidercol DB  22D
bsolider2row DB 22D
bsolider2col DB 22d
bsolider3row DB 44D
bsolider3col DB 22d
bsolider4row DB 66d
bsolider4col DB 22d
bsolider5row DB 88d
bsolider5col DB 22d
bsolider6row DB 110d
bsolider6col DB 22d
bsolider7row DB 132d
bsolider7col DB 22d
bsolider8row DB 154d
bsolider8col DB 22d
;---solider2 INFO-----------
Solider2 DB 'wgond.bin', 0
wsoliderrow DB 0000H
wsolidercol DB  132d
wsolider2row DB 22d
wsolider2col DB  132d
wsolider3row DB 44D
wsolider3col DB  132d
wsolider4row DB 66d
wsolider4col DB  132d
wsolider5row DB 88d
wsolider5col DB  132d
wsolider6row DB 110d
wsolider6col DB  132d
wsolider7row DB 132d
wsolider7col DB  132d
wsolider8row DB 154d
wsolider8col DB  132d
;---hosan2 INFO-----------
hosan2 DB 'whosan.bin', 0
whosanrow DB 22d
whosancol DB 154d
whosan2row DB 132d
whosan2col DB 154d
;---tabia INFO-----------
tabia2 DB 'wtabya.bin', 0
wtabiarow DB 00H
wtabiacol DB 154d
wtabia2row DB 154d
wtabia2col DB 154d
;---feel2 INFO-----------
feel2 DB 'wfeel.bin', 0
wfeelrow DB 44d
wfeelcol DB 154d
wfeel2row DB 110d
wfeel2col DB 154d
;---king2 INFO-----------
king2 DB 'wking.bin', 0
wkingrow DB 66d
wkingcol DB 154d
;---queen2 INFO-----------
queen2 DB 'wqueen.bin', 0
wqueenrow DB 88d
wqueencol DB 154d
;----GENERAL VARIABLES AND DATA------
HorizontalDimension DW 0
VerticalDimension DW 0
SCOL DW 0 ; starting column
SROW DW 0
; ----------------------------------------------- Keys Scan Codes ------------------------------------------- ;
Wscancode EQU 11h
Ascancode EQU 1Eh
Sscancode EQU 1Fh
Dscancode EQU 20h
Qscancode EQU 10h
Enterscancode EQU 1Ch
UpArrowScanCode EQU 48H
DownArrowScanCode EQU 50H
RightArrowScanCode EQU 4DH
LeftArrowScanCode EQU 4BH
Escscancode equ 1h
Bckspacescancode equ 0Eh
F1scancode equ 3Eh ; this is actually F4 scancode as we are using F4 in place of F1
F2scancode equ 3Ch
F3scancode equ 3Dh
;-------------CHAT MODULE VARIABLES-----------------
border    db    "-----------------------------------------------------------------------------------$"
Line	  db    "-----------------------------------------------------------------------------------$"
Hsend db ?
Hsend2 db ?
Xsend db ?
Yrecieve db ?
Char_Send    DB   ? 
Char_Recieve DB   ? 
Exit_Chat    DB   0
firs_half   dw 0300h
sec_half    dw 0d00h
playername db 'player 1 : $'
space db ' : $'
checkname db 0
checkname1 db 0
;-----------------
key db ?
Empty db       '                     $'
enternamemes db 'Please, Enter your name:$'
presstocontinuemes db 'Press Enter key to continue$'
mes1 db 'To start chatting press F1$'
mes2 db 'To start the game press F2$'
mes3 db 'To end the program press ESC$'
mes4 db 'To end chatting, press F3$'
mes5 db 50h dup('-'), '$'
mes6 db 'Here starts the game$'
EMPTYMESSAGE DB '                                '
NotificationBarMessage DW 0
BlackKingIsCheckedMessaage db 'Black King is Checked$'
WhiteKingIsCheckedMessaage db 'White King is Checked$'
;-------------invitation messages------------
chatinvitemes DB 10, 'You have recieved a chat invitation, to accept it press F1 key!$'
gameinvitemes DB 10, 'You have recieved a game invitation, to accept it press F2 key!$'
message db 10, 13, 'welcome', 10, 13, 'bitch$'
;------------- players data------------------
p1namedata label byte
p1namemaxsize db 16
p1nameactualsize db 0
p1name db 16 dup('$')
p2namedata label byte
p2namemaxsize db 16
p2nameactualsize db 0
p2name db 16 dup('$')
;-------Sending and Receiveing----------------
CharacterSent DB (?)
Characterreceived DB 0FFh
; ---------- Connection Variables ----- ;
gameinvite db 0
chatinvite db 0
Acceptgame db 0
Acceptchat db 0
HOST DB 0
;-----------------------------
mybuffer label byte
buffersize db 16 
actualsize db ?
bufferdata db 16 dup('$')
bufferdataCopy db 16 dup('$')
;-----------------------
.code
.386
MAIN PROC FAR
            
    ;----PREPARE MEMORY---------
    MOV AX, @DATA
    MOV DS, AX
    ;MOV ES, AX
    ;---------------------------
    
    clearscreen
    call NAMESCREEN
    call MAINSCREEN
    RET
MAIN ENDP

PRINTMESSAGE  PROC  NEAR
    ; DX HOLDS THE OFFSET OF THE MESSAGE 
    MOV AH,9
    MOV AL,0
    INT 21H
    RET
PRINTMESSAGE  ENDP

ShowNotifications PROC NEAR
     cmp FL,0           
     je FirstMessage
     cmp SL,0          
     je FirstSecondMessage

     SecondMessage:
     movecursor 23,1
     mov dx , NotificationBarMessage
     CALL PRINTMESSAGE            ;hena ba shafett
     movecursor 24, 1
     mov dx , NextNotification
     mov NotificationBarMessage , dx
     MOV DX, NotificationBarMessage
     CALL PRINTMESSAGE
     JMP ShowNotifications_RET

     FirstSecondMessage :
     movecursor 24, 1
     mov dx , NextNotification
     mov NotificationBarMessage , dx
     MOV DX, NotificationBarMessage
     CALL PRINTMESSAGE
     mov SL,1
     JMP ShowNotifications_RET

    FirstMessage:
    movecursor 23, 1
    mov dx , NextNotification
     mov NotificationBarMessage , dx
     MOV DX, NotificationBarMessage
    CALL PRINTMESSAGE
    mov FL,1
    ShowNotifications_RET:
    RET
ShowNotifications ENDP

CheckGameEnd proc near
    CHECK_IF_BLACK_WON:
        CMP WhiteKingDeath, 1D
        JNE CHECK_IF_WHITE_WON
        MOV THERE_IS_A_WINNER, 2H ; 2 INDICATES THAT BLACK (PLAYER 2) WON
        JMP BlackWon
    ;------------    
    CHECK_IF_WHITE_WON:
        CMP BlackKingDeath, 1D
        JNE CheckGameEnd_ret
        MOV THERE_IS_A_WINNER, 1H ; 1 INDICATES THAT WHITE (PLAYER 1) WON
        JMP WhiteWon
    WhiteWon:
        MOV GAME_END, 1H
        MOV NextNotification, offset WhitePlayerWonMessage ; MOVE THE NOTIFICATION TO BE DISPLAYED
        call ShowNotifications
        JMP CheckGameEnd_ret
    BlackWon:
        MOV GAME_END, 1H
        MOV NextNotification, offset BlackPlayerWonMessage
        call ShowNotifications
        JMP CheckGameEnd_ret
    CheckGameEnd_ret:
        RET
CheckGameEnd endp

Rexecutekeypress proc near ; getkeypress function is called right before this function is called
 mov dx , 03F8H
        in al , dx 
        mov ah , al
       ; mov Hsend2,ah
    ; cmp ah, Dscancode ; COMPARE WITH SCANCODES
    ; jz Rmoveright

    ; cmp ah, Ascancode
    ; jz Rmoveleft

    ; cmp ah, Wscancode
    ; jz Rmoveup

    ; cmp ah, Sscancode
    ; jz Rmovedown

    ; cmp ah, Qscancode
    ; jz RSET_PLAYER_1_TO_PLAY

    
    cmp ah, UpArrowScanCode
    jz Rmoveup2
    cmp ah, DownArrowScanCode
    jz Rmovedown2
    cmp ah, RightArrowScanCode
    jz Rmoveright2
    cmp ah, LeftArrowScanCode
    jz Rmoveleft2
    cmp ah, Enterscancode
    jz RSET_PLAYER_2_TO_PLAY
     cmp ah,Bckspacescancode
   je backspace2
    mov letter2,al
    ;Add letter,'0'
    movecursor xpos2,ypos2
    print letter2
    inc ypos2
    cmp ypos2,119d
    jne rexecutekeypress_ret
mov ypos2,102d
inc xpos2
cmp xpos2,24
jne rexecutekeypress_ret
mov ypos2,118d
mov xpos2,23
movecursor xpos2,ypos2
print empty2

    ;jnz Rexecutekeypress_ret

    RSET_PLAYER_1_TO_PLAY:
    MOV Who_Plays, 0D
    JMP RRQClick
    RSET_PLAYER_2_TO_PLAY:
    MOV Who_Plays, 1D
    ;-------------------------------------
    RRQClick:
    call setplayer
    cmp PieceInSelection, 1
    je RThereIsASelectedPiece

    RThereIsNoSelectedPiece:
    RConfigurePieceSelection selected_frame_row, selected_frame_col
    cmp SelectedPieceCode, 0
    JE RRQClickend 
    ; if square is not occupied, RRQClick has no effect and end

    ; ELSE SELECT ALL PIECE MOVES AND HIGHLIGHT THEM
    call SelectPieceMoves
    CALL Highlight  
    jmp RRQClickend
    
    ; if Click is on the same square as the selected piece square, we deselect the piece
    RThereIsASelectedPiece:
    configureDes selected_frame_row, selected_frame_col
    mov bl, SelectedPieceSquare
    cmp bl, DesSquare
    JNE RRQClickIsNotInSamePlace

    ; If click is in the same place, de-select; that involves dehighlighting the potential squares among other stuff
    RRQClickIsInTheSamePlace:
    call Dehighlight
    JMP RRQClickCleanUp

    RRQClickIsNotInSamePlace:
    CALL ValidateMove ; move is to one of the possible cells for the piece
    call Dehighlight
    CMP isValidMove, 1 ; check that move is still valid
    JNE RRQClickCleanUp
    call movepiece
    call KingInCheck
    
    ;MoveisNotValid:
    
    RRQClickCleanUp:  
    ; Drawsquare selected_frame_row, selected_frame_col, red_color ; draw the moving frame around the current position
    MOV PieceInSelection, 0h
    MOV isValidMove, 1h
    mov number_of_potential_cells, 0 
    mov selectedPieceCode, 0
    mov BKingChecked, 0
    mov WKingChecked, 0
    jmp RRQClickend

    RRQClickend:
    call De_set_Player
    jmp Rexecutekeypress_ret
    ;---------------------------------------

    Rmoveright:
    cmp selected_frame_col1, 154d
    jae Rexecutekeypress_ret
    calculate_square selected_frame_row1, selected_frame_col1, selected_frame_square1
    getSquareColor selected_frame_color1, selected_frame_square1
    Drawsquare selected_frame_row1, selected_frame_col1, selected_frame_color1
    ; CALL RedrawPotentialSquare
    add selected_frame_col1, distance
    movecursor selected_frame_row1, selected_frame_col1, 0
    Drawsquare selected_frame_row1, selected_frame_col1, red_color
    jmp Rexecutekeypress_ret
    
    Rmoveleft:
    cmp selected_frame_col1, 0d
    jbe Rexecutekeypress_ret
    calculate_square selected_frame_row1, selected_frame_col1, selected_frame_square1
    getSquareColor selected_frame_color1, selected_frame_square1
    Drawsquare selected_frame_row1, selected_frame_col1, selected_frame_color1
    ; CALL RedrawPotentialSquare
    sub selected_frame_col1, distance
    movecursor selected_frame_row1, selected_frame_col1, 0
    Drawsquare selected_frame_row1, selected_frame_col1, red_color
    jmp Rexecutekeypress_ret
    
    
    Rmoveup:
    cmp selected_frame_row1, 0d
    jbe Rexecutekeypress_ret
    calculate_square selected_frame_row1, selected_frame_col1, selected_frame_square1
    getSquareColor selected_frame_color1, selected_frame_square1
    Drawsquare selected_frame_row1, selected_frame_col1, selected_frame_color1
    ; CALL RedrawPotentialSquare
    sub selected_frame_row1, distance
    movecursor selected_frame_row1, selected_frame_col1, 0
    Drawsquare selected_frame_row1, selected_frame_col1, red_color
    jmp Rexecutekeypress_ret
    
    
    Rmovedown:
    cmp selected_frame_row1, 154d
    jae Rexecutekeypress_ret
    calculate_square selected_frame_row1, selected_frame_col1, selected_frame_square1
    getSquareColor selected_frame_color1, selected_frame_square1
    Drawsquare selected_frame_row1, selected_frame_col1, selected_frame_color1
    ; CALL RedrawPotentialSquare
    add selected_frame_row1, distance
    movecursor selected_frame_row1, selected_frame_col1, 0
    Drawsquare selected_frame_row1, selected_frame_col1, red_color
    jmp Rexecutekeypress_ret 


    ;-----PLAYER 2 MOVEMENTS---------------
    Rmoveright2:
    cmp selected_frame_col2, 154d
    jae Rexecutekeypress_ret
    calculate_square selected_frame_row2, selected_frame_col2, selected_frame_square2
    getSquareColor selected_frame_color2, selected_frame_square2
    Drawsquare selected_frame_row2, selected_frame_col2, selected_frame_color2
    ; CALL RedrawPotentialSquare
    add selected_frame_col2, distance
    movecursor selected_frame_row2, selected_frame_col2, 0
    Drawsquare selected_frame_row2, selected_frame_col2, green_color
    jmp Rexecutekeypress_ret
    
    Rmoveleft2:
    cmp selected_frame_col2, 0d
    jbe Rexecutekeypress_ret
    calculate_square selected_frame_row2, selected_frame_col2, selected_frame_square2
    getSquareColor selected_frame_color2, selected_frame_square2
    Drawsquare selected_frame_row2, selected_frame_col2, selected_frame_color2
    ; CALL RedrawPotentialSquare
    sub selected_frame_col2, distance
    movecursor selected_frame_row2, selected_frame_col2, 0
    Drawsquare selected_frame_row2, selected_frame_col2, green_color
    jmp Rexecutekeypress_ret
    
    
    Rmoveup2:
    cmp selected_frame_row2, 0d ; restore frame to pos
    jbe Rexecutekeypress_ret
    calculate_square selected_frame_row2, selected_frame_col2, selected_frame_square2
    getSquareColor selected_frame_color2, selected_frame_square2
    Drawsquare selected_frame_row2, selected_frame_col2, selected_frame_color2
    ; CALL RedrawPotentialSquare
    sub selected_frame_row2, distance
    movecursor selected_frame_row2, selected_frame_col2, 0
    Drawsquare selected_frame_row2, selected_frame_col2, green_color
    jmp Rexecutekeypress_ret
    
    ; restore frame to pos
    Rmovedown2:
    cmp selected_frame_row2, 154d
    jae Rexecutekeypress_ret
    calculate_square selected_frame_row2, selected_frame_col2, selected_frame_square2
    getSquareColor selected_frame_color2, selected_frame_square2
    Drawsquare selected_frame_row2, selected_frame_col2, selected_frame_color2
    ; CALL RedrawPotentialSquare
    add selected_frame_row2, distance
    movecursor selected_frame_row2, selected_frame_col2, 0
    Drawsquare selected_frame_row2, selected_frame_col2, green_color
    jmp Rexecutekeypress_ret 

    ;--------------------
    backspace2:
    checkypos2:
   cmp ypos2,102d
   je reset2
printing2:
cmp ypos2,120d
je reset2
dec ypos2
movecursor xpos2,ypos2
print empty2
jmp Rexecutekeypress_ret
  reset2:
  cmp xpos2,20
  je Rexecutekeypress_ret
  movecursor xpos2,ypos2
  print empty2
  mov ypos2,119d
  dec xpos2
     Rexecutekeypress_ret:
    ; mov dx ,3FDH		; Line Status Register, to send data check if THR empty or not
	; AGAIN1:
  	; In al,dx 			;Read Line Status
	; and al , 00100000b
	; jz AGAIN1

	; mov dx , 3F8H		; (if empty)Transmit data register
    ; mov  al,Hsend
  	; out dx , al 
    RET
Rexecutekeypress ENDP


; KEYPRESS IS EXECUTED
    
executekeypress proc near ; getkeypress function is called right before this function is called

mov Hsend,ah
    ; cmp ah, Dscancode ; COMPARE WITH SCANCODES
    ; jz moveright

    ; cmp ah, Ascancode
    ; jz moveleft

    ; cmp ah, Wscancode
    ; jz moveup

    ; cmp ah, Sscancode
    ; jz movedown

    ; cmp ah, Qscancode
    ; jz SET_PLAYER_1_TO_PLAY

    
    cmp ah, UpArrowScanCode
    jz moveup2
    cmp ah, DownArrowScanCode
    jz movedown2
    cmp ah, RightArrowScanCode
    jz moveright2
    cmp ah, LeftArrowScanCode
    jz moveleft2
    cmp ah, Enterscancode
    jz SET_PLAYER_2_TO_PLAY
     cmp ah,Bckspacescancode
   je backspace
    mov letter,al
    ;Add letter,'0'
    movecursor xpos,ypos
    print letter
    inc ypos
    cmp ypos,119d
    jne executekeypress_ret
mov ypos,102d
inc xpos
cmp xpos,18
jne executekeypress_ret
mov ypos,118d
mov xpos,17
movecursor xpos,ypos
print empty2
   ; jnz executekeypress_ret

    SET_PLAYER_1_TO_PLAY:
    MOV Who_Plays, 0D
    JMP QClick
    SET_PLAYER_2_TO_PLAY:
    MOV Who_Plays, 1D
    ;-------------------------------------
    QClick:
    call setplayer
    cmp PieceInSelection, 1
    je ThereIsASelectedPiece

    ThereIsNoSelectedPiece:
    ConfigurePieceSelection selected_frame_row, selected_frame_col
    cmp SelectedPieceCode, 0
    JE Qclickend 
    ; if square is not occupied, Qclick has no effect and end

    ; ELSE SELECT ALL PIECE MOVES AND HIGHLIGHT THEM
    call SelectPieceMoves
    CALL Highlight  
    jmp Qclickend
    
    ; if Click is on the same square as the selected piece square, we deselect the piece
    ThereIsASelectedPiece:
    configureDes selected_frame_row, selected_frame_col
    mov bl, SelectedPieceSquare
    cmp bl, DesSquare
    JNE QClickIsNotInSamePlace

    ; If click is in the same place, de-select; that involves dehighlighting the potential squares among other stuff
    QClickIsInTheSamePlace:
    call Dehighlight
    JMP QclickCleanUp

    QClickIsNotInSamePlace:
    CALL ValidateMove ; move is to one of the possible cells for the piece
    call Dehighlight
    CMP isValidMove, 1 ; check that move is still valid
    JNE QclickCleanUp
    call movepiece
    call KingInCheck
    
    ;MoveisNotValid:
    
    QclickCleanUp:  
    ; Drawsquare selected_frame_row, selected_frame_col, red_color ; draw the moving frame around the current position
    MOV PieceInSelection, 0h
    MOV isValidMove, 1h
    mov number_of_potential_cells, 0 
    mov selectedPieceCode, 0
    mov BKingChecked, 0
    mov WKingChecked, 0
    jmp Qclickend

    Qclickend:
    call De_set_Player
    jmp executekeypress_ret
    ;---------------------------------------

    moveright:
    cmp selected_frame_col1, 154d
    jae executekeypress_ret
    calculate_square selected_frame_row1, selected_frame_col1, selected_frame_square1
    getSquareColor selected_frame_color1, selected_frame_square1
    Drawsquare selected_frame_row1, selected_frame_col1, selected_frame_color1
    ; CALL RedrawPotentialSquare
    add selected_frame_col1, distance
    movecursor selected_frame_row1, selected_frame_col1, 0
    Drawsquare selected_frame_row1, selected_frame_col1, red_color
    jmp executekeypress_ret
    
    moveleft:
    cmp selected_frame_col1, 0d
    jbe executekeypress_ret
    calculate_square selected_frame_row1, selected_frame_col1, selected_frame_square1
    getSquareColor selected_frame_color1, selected_frame_square1
    Drawsquare selected_frame_row1, selected_frame_col1, selected_frame_color1
    ; CALL RedrawPotentialSquare
    sub selected_frame_col1, distance
    movecursor selected_frame_row1, selected_frame_col1, 0
    Drawsquare selected_frame_row1, selected_frame_col1, red_color
    jmp executekeypress_ret
    
    
    moveup:
    cmp selected_frame_row1, 0d
    jbe executekeypress_ret
    calculate_square selected_frame_row1, selected_frame_col1, selected_frame_square1
    getSquareColor selected_frame_color1, selected_frame_square1
    Drawsquare selected_frame_row1, selected_frame_col1, selected_frame_color1
    ; CALL RedrawPotentialSquare
    sub selected_frame_row1, distance
    movecursor selected_frame_row1, selected_frame_col1, 0
    Drawsquare selected_frame_row1, selected_frame_col1, red_color
    jmp executekeypress_ret
    
    
    movedown:
    cmp selected_frame_row1, 154d
    jae executekeypress_ret
    calculate_square selected_frame_row1, selected_frame_col1, selected_frame_square1
    getSquareColor selected_frame_color1, selected_frame_square1
    Drawsquare selected_frame_row1, selected_frame_col1, selected_frame_color1
    ; CALL RedrawPotentialSquare
    add selected_frame_row1, distance
    movecursor selected_frame_row1, selected_frame_col1, 0
    Drawsquare selected_frame_row1, selected_frame_col1, red_color
    jmp executekeypress_ret 


    ;-----PLAYER 2 MOVEMENTS---------------
    moveright2:
    cmp selected_frame_col2, 154d
    jae executekeypress_ret
    calculate_square selected_frame_row2, selected_frame_col2, selected_frame_square2
    getSquareColor selected_frame_color2, selected_frame_square2
    Drawsquare selected_frame_row2, selected_frame_col2, selected_frame_color2
    ; CALL RedrawPotentialSquare
    add selected_frame_col2, distance
    movecursor selected_frame_row2, selected_frame_col2, 0
    Drawsquare selected_frame_row2, selected_frame_col2, green_color
    jmp executekeypress_ret
    
    moveleft2:
    cmp selected_frame_col2, 0d
    jbe executekeypress_ret
    calculate_square selected_frame_row2, selected_frame_col2, selected_frame_square2
    getSquareColor selected_frame_color2, selected_frame_square2
    Drawsquare selected_frame_row2, selected_frame_col2, selected_frame_color2
    ; CALL RedrawPotentialSquare
    sub selected_frame_col2, distance
    movecursor selected_frame_row2, selected_frame_col2, 0
    Drawsquare selected_frame_row2, selected_frame_col2, green_color
    jmp executekeypress_ret
    
    
    moveup2:
    cmp selected_frame_row2, 0d ; restore frame to pos
    jbe executekeypress_ret
    calculate_square selected_frame_row2, selected_frame_col2, selected_frame_square2
    getSquareColor selected_frame_color2, selected_frame_square2
    Drawsquare selected_frame_row2, selected_frame_col2, selected_frame_color2
    ; CALL RedrawPotentialSquare
    sub selected_frame_row2, distance
    movecursor selected_frame_row2, selected_frame_col2, 0
    Drawsquare selected_frame_row2, selected_frame_col2, green_color
    jmp executekeypress_ret
    
    ; restore frame to pos
    movedown2:
    cmp selected_frame_row2, 154d
    jae executekeypress_ret
    calculate_square selected_frame_row2, selected_frame_col2, selected_frame_square2
    getSquareColor selected_frame_color2, selected_frame_square2
    Drawsquare selected_frame_row2, selected_frame_col2, selected_frame_color2
    ; CALL RedrawPotentialSquare
    add selected_frame_row2, distance
    movecursor selected_frame_row2, selected_frame_col2, 0
    Drawsquare selected_frame_row2, selected_frame_col2, green_color
    jmp executekeypress_ret 

    ;--------------------
    backspace:
    checkypos:
   cmp ypos,102d
   je reset
printing:
cmp ypos,120d
je reset
dec ypos
movecursor xpos,ypos
print empty2
jmp executekeypress_ret
  reset:
  cmp xpos,15
  je executekeypress_ret
  movecursor xpos,ypos
  print empty2
  mov ypos,119d
  dec xpos
    executekeypress_ret:
    mov dx ,3FDH		; Line Status Register, to send data check if THR empty or not
	RAGAIN1:
  	In al,dx 			;Read Line Status
	and al , 00100000b
	jz RAGAIN1

	mov dx , 3F8H		; (if empty)Transmit data register
    mov  al,Hsend
  	out dx , al 
    RET
executekeypress ENDP   

setplayer proc near
cmp Who_Plays, 0D
JNE Player2Plays

Player1Plays:
MoveArr1Arr2 potential_cells_rowp1, potential_cells_row
MoveArr1Arr2 potential_cells_colp1, potential_cells_col
MoveArr1Arr2 potential_cells_squareNumberp1, potential_cells_squareNumber
mov al,number_of_potential_cellsp1
mov number_of_potential_cells, al
mov al, PieceInSelectionp1
mov PieceInSelection, al
mov al,selectedSquareColorp1
mov selectedSquareColor, al
mov al,selectedPieceSquarep1
mov selectedPieceSquare, al
mov al,SelectedPieceRowp1
mov SelectedPieceRow, al
mov al,SelectedPieceColp1
mov selectedpiececol, al
mov al,SelectedPieceCodep1
mov selectedpiececode, al 
mov al,DesRowp1
mov DesRow, al
mov al,DesColp1
mov DesCol, al
mov al,DesSquarep1
mov DesSquare, al
mov al,DesColorp1
mov DesColor, al
mov al,DesPieceCodep1
mov DesPieceCode, al
mov al, selected_frame_row1
mov selected_frame_row, al
mov al, selected_frame_col1
mov selected_frame_col, al
mov al, selected_frame_square1
mov selected_frame_square, al
mov al, selected_frame_color1
mov selected_frame_color, al

RET

Player2Plays:
MoveArr1Arr2 potential_cells_rowp2, potential_cells_row
MoveArr1Arr2 potential_cells_colp2, potential_cells_col
MoveArr1Arr2 potential_cells_squareNumberp2, potential_cells_squareNumber
mov ah,number_of_potential_cellsp2
mov number_of_potential_cells, ah
mov ah, PieceInSelectionp2
mov PieceInSelection, ah
mov ah,selectedSquareColorp2
mov selectedSquareColor, ah
mov ah,selectedPieceSquarep2
mov selectedPieceSquare, ah
mov ah,SelectedPieceRowp2
mov SelectedPieceRow, ah
mov ah,SelectedPieceColp2
mov selectedpiececol, ah
mov ah,SelectedPieceCodep2
mov selectedpiececode, ah
mov ah,DesRowp2
mov DesRow, ah
mov ah,DesColp2
mov DesCol, ah
mov ah,DesSquarep2
mov DesSquare, ah
mov ah,DesColorp2
mov DesColor, ah
mov ah,DesPieceCodep2
mov DesPieceCode, ah
mov al, selected_frame_row2
mov selected_frame_row, al
mov al, selected_frame_col2
mov selected_frame_col, al
mov al, selected_frame_square2
mov selected_frame_square, al
mov al, selected_frame_color2
mov selected_frame_color, al

RET
setplayer endp

De_set_Player proc near
cmp Who_Plays, 0D
JNE Player2DePlays

Player1DePlays:
MoveArr1Arr2 potential_cells_row, potential_cells_rowp1
MoveArr1Arr2 potential_cells_col, potential_cells_colp1
MoveArr1Arr2 potential_cells_squareNumber, potential_cells_squareNumberp1
mov al,number_of_potential_cells
mov number_of_potential_cellsp1, al
mov al, PieceInSelection
mov PieceInSelectionp1, al
mov al,selectedSquareColor
mov selectedSquareColorp1, al
mov al,selectedPieceSquare
mov selectedPieceSquarep1, al
mov al,SelectedPieceRow
mov SelectedPieceRowp1, al
mov al,SelectedPieceCol
mov selectedpiececolp1, al
mov al,SelectedPieceCode
mov selectedpiececodep1, al 
mov al,DesRow
mov DesRowp1, al
mov al,DesCol
mov DesColp1, al
mov al,DesSquare
mov DesSquarep1, al
mov al,DesColor ;; Retrieve all the needed data
mov DesColorp1, al
mov al,DesPieceCode
mov DesPieceCodep1, al
mov al, selected_frame_row
mov selected_frame_row1, al
mov al, selected_frame_col
mov selected_frame_col1, al
mov al, selected_frame_square
mov selected_frame_square1, al
mov al, selected_frame_color
mov selected_frame_color1, al
RET

Player2DePlays: ; De select player 2
MoveArr1Arr2 potential_cells_row, potential_cells_rowp2
MoveArr1Arr2 potential_cells_col, potential_cells_colp2
MoveArr1Arr2 potential_cells_squareNumber, potential_cells_squareNumberp2
mov ah,number_of_potential_cells
mov number_of_potential_cellsp2, ah
mov ah, PieceInSelection
mov PieceInSelectionp2, ah
mov ah,selectedSquareColor
mov selectedSquareColorp2, ah ; Retrieve all the needed data
mov ah,selectedPieceSquare
mov selectedPieceSquarep2, ah
mov ah,SelectedPieceRow
mov SelectedPieceRowp2, ah
mov ah,SelectedPieceCol
mov selectedpiececolp2, ah
mov ah,SelectedPieceCode
mov selectedpiececodep2, ah
mov ah,DesRow
mov DesRowp2, ah
mov ah,DesCol
mov DesColp2, ah
mov ah,DesSquare
mov DesSquarep2, ah
mov ah,DesColor
mov DesColorp2, ah
mov ah,DesPieceCode
mov DesPieceCodep2, ah
mov al, selected_frame_row
mov selected_frame_row2, al
mov al, selected_frame_col
mov selected_frame_col2, al
mov al, selected_frame_square
mov selected_frame_square2, al
mov al, selected_frame_color
mov selected_frame_color2, al


RET

De_set_Player endp

CheckPieceTimer proc near
    MOV LOCKED, 0D
    MOV BH, 0D
    mov BL, SelectedPieceSquare
    CMP [timerArray + BX], 0D
    JE PieceIsFreeToMove
    PieceIsNotFreeToMove:
    MOV LOCKED, 1D
    PieceIsFreeToMove:
    CheckPieceTimer_RET:
    RET
CheckPieceTimer endp

GetKingMoves proc near
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ;-----------------------------------------
    OneRight:
    add to_test_Col, distance 
    cmp to_test_Col, 154d
    JA OneRightEnd
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneRightEnd
    call HelperFunction1
    
    OneRightEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ;-----------------------------------------
    OneLeft:
    cmp to_test_Col, 0D
    JE OneLeftEnd
    sub to_test_Col, distance 
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneLeftEnd
    call HelperFunction1

    OneLeftEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ;-----------------------------------------
    OneDown:
    add to_test_Row, distance 
    cmp to_test_Row, 154d
    JA OneDownEnd
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneDownEnd
    call HelperFunction1
    
    OneDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ;-----------------------------------------
    OneUp:
    cmp to_test_Row, 0D
    JE OneUpEnd
    sub to_test_Row, distance 
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneUpEnd
    call HelperFunction1

    OneUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ;-----------------------------------------
    OneRightOneUp:
    add to_test_Col, distance 
    cmp to_test_Col, 154d
    JA OneRightOneUpEnd
    cmp to_test_Row, 0D
    JE OneRightOneUpEnd
    sub to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneRightOneUpEnd
    call HelperFunction1
    
    OneRightOneUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    
    ;-----------------------------------------
    OneRightOneDown:
    add to_test_Col, distance
    cmp to_test_Col, 154d
    JA OneRightOneDownEnd
    cmp to_test_Row, 154d
    JE OneRightOneDownEnd
    add to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneRightOneDownEnd
    call HelperFunction1
    
    OneRightOneDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    
    ;-----------------------------------------
    OneLeftOneUp:
    cmp to_test_Col, 0D
    JE OneLeftOneUpEnd
    sub to_test_Col, distance
    cmp to_test_Row, 0D
    je OneLeftOneUpEnd
    sub to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneLeftOneUpEnd
    call HelperFunction1
    
    OneLeftOneUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ;-----------------------------------------
    OneLeftOneDown:
    cmp to_test_Col, 0D
    JE OneLeftOneDownEnd
    sub to_test_Col, distance
    cmp to_test_Row, 154d
    je OneLeftOneDownEnd
    add to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneLeftOneDownEnd
    call HelperFunction1

    OneLeftOneDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    ;-----------------------------------------
    ret
endp GetKingMoves


GetBgondMoves proc near
mov bl, SelectedPieceRow
mov bh, SelectedPieceCol
cmp bl,154d
je narymove
add bl,22d
mov to_test_row,bl
mov to_test_col,bh
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
cmp to_test_square_piececode,0D
jne checkfirsteat
call HelperFunction1
checkfirsteat:
mov bl, SelectedPieceRow
mov bh, SelectedPieceCol
cmp bh,154d
je secondeatcheck
add bl,22d
add bh,22d
mov to_test_row,bl
mov to_test_col,bh
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
cmp to_test_square_piececode,6d
jbe secondeatcheck
call HelperFunction1
secondeatcheck:
mov bl, SelectedPieceRow
mov bh, SelectedPieceCol
cmp bh,0d
je narymove
add bl,22d
sub bh,22d
mov to_test_row,bl
mov to_test_col,bh
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
cmp to_test_square_piececode,6d
jbe narymove
call HelperFunction1
narymove:
ret
endp GetBgondMoves

GetWgondMoves proc near
mov bl, SelectedPieceRow
mov bh, SelectedPieceCol
cmp bl,0d
je narymove2
sub bl,22d
mov to_test_row,bl
mov to_test_col,bh
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
cmp to_test_square_piececode,0D
jne checkfirsteat1
call HelperFunction1
checkfirsteat1:
mov bl, SelectedPieceRow
mov bh, SelectedPieceCol
cmp bh,154d
je secondeatcheck1
sub bl,22d
add bh,22d
mov to_test_row,bl
mov to_test_col,bh
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
cmp to_test_square_piececode,6d 
ja secondeatcheck1
cmp to_test_square_piececode,0D
je secondeatcheck1
call HelperFunction1
secondeatcheck1:
mov bl, SelectedPieceRow
mov bh, SelectedPieceCol
cmp bh,0d
je narymove2
sub bl,22d
sub bh,22d
mov to_test_row,bl
mov to_test_col,bh
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
cmp to_test_square_piececode,6d 
ja narymove2
cmp to_test_square_piececode,0D
je narymove2
call HelperFunction1
narymove2:
ret
endp GetWgondMoves


GetTabyaMoves PROC NEAR
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ; PrepareAbove exists for the reason that if the selected piece column is already 0 and we subtract from it, then this will give a negative
    ; number, so it is better to avoid that in the comparison
    ; The same for PrepareLeft but for the row

    PrepareAbove:
    CMP to_test_row, 0 ; if selected piece is at column 0, then there's nothing to the left to check
    je CheckAboveEnd
    
    CheckAbove:
    sub to_test_row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d; DE 3OMRHA MA HTKON 1 ELA LW ASASN OCCUPIED
    JE CheckAboveEnd    ; IF PIECE HAS SAME COLOR THEN END, LW MSH SAME COLOR F L CELL DE M3ANA
    call HelperFunction1 ; KEDA KEDA 7TA LW MSH OCCUPIED F HYA M3ANA
    CMP IsOccupiedFlag, 1d ; LKN LW OCCUPIED F DE A5ER CELL M3ANA W H N END
    JE CheckAboveEnd
    cmp to_test_row, 0D
    JNE CheckAbove

    CheckAboveEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    
    CheckBelow:
    add to_test_row, distance
    cmp to_test_row, 154d
    JA CheckBelowEnd
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE CheckBelowEnd    
    call HelperFunction1 
    CMP IsOccupiedFlag, 1d  
    JE CheckBelowEnd
    jmp CheckBelow

    CheckBelowEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL 

    CheckRight:
    add to_test_col, distance
    cmp to_test_col, 154d
    JA CheckRightEnd
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1H 
    JE CheckRightEnd    
    call HelperFunction1 
    CMP IsOccupiedFlag, 1h
    JE CheckRightEnd
    jmp CheckRight

    CheckRightEnd: 
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    
    PrepareLeft:
    CMP to_test_col, 0 ; if selected piece is at column 0, then there's nothing to the left to check
    je CheckLeftEnd
    
    CheckLeft:
    sub to_test_col, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1H 
    JE CheckLeftEnd    
    call HelperFunction1 
    CMP IsOccupiedFlag, 1h
    JE CheckLeftEnd
    cmp to_test_col, 0D
    JNE CHECKLEFT
    CheckLeftEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ret
GetTabyaMoves ENDP

GetHosanMoves PROC NEAR ; the knight can move to a max of eight different cells on the board
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    
    TwoRightOneUp:
    add to_test_Col, distance * 2
    cmp to_test_Col, 154d
    JA TwoRightOneUpEnd
    cmp to_test_Row, 0D
    JE TwoRightOneUpEnd
    sub to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    ;maybe we will have to check that the cell isn't occupied here
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  TwoRightOneUpEnd
    call HelperFunction1 
    
    TwoRightOneUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    
    ; CONTINUE TO TEST OTHER POSSIBLE MOVES
    
    TwoRightOneDown:
    add to_test_Col, distance * 2
    cmp to_test_Col, 154d
    JA TwoRightOneDownEnd
    cmp to_test_Row, 154d
    JE TwoRightOneDownEnd
    add to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  TwoRightOneDownEnd
    call HelperFunction1
    
    TwoRightOneDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL


    OneRightTwoUp:
    add to_test_Col, distance
    cmp to_test_Col, 154d
    JA OneRightTwoUpEnd
    cmp to_test_Row, 22d
    JBE OneRightTwoUpEnd
    sub to_test_Row, distance * 2
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneRightTwoUpEnd
    call HelperFunction1
    
    OneRightTwoUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    

    OneRightTwoDown:
    add to_test_Col, distance
    cmp to_test_Col, 154d
    JA OneRightTwoDownEnd
    cmp to_test_Row, 132d
    JAE OneRightTwoDownEnd
    add to_test_Row, distance * 2
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneRightTwoDownEnd
    call HelperFunction1
    
    OneRightTwoDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    

    TwoLeftOneUp:
    cmp to_test_Col, 22d
    JBE TwoLeftOneUpEnd
    sub to_test_Col, distance * 2
    cmp to_test_Row, 0D
    je TwoLeftOneUpEnd
    sub to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  TwoLeftOneUpEnd
    call HelperFunction1
    
    TwoLeftOneUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    TwoLeftOneDown:
    cmp to_test_Col, 22d
    JBE TwoLeftOneDownEnd
    sub to_test_Col, distance * 2
    cmp to_test_Row, 154d
    je TwoLeftOneDownEnd
    add to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  TwoLeftOneDownEnd
    call HelperFunction1

    TwoLeftOneDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    OneLeftTwoUp:
    cmp to_test_Col, 0D
    JE OneLeftTwoUpEnd
    sub to_test_Col, distance
    cmp to_test_Row, 22d
    jbe OneLeftTwoUpEnd
    sub to_test_Row, distance*2
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneLeftTwoUpEnd
    call HelperFunction1

    OneLeftTwoUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    OneLeftTwoDown:
    cmp to_test_Col, 0D
    JE OneLeftTwoDownEnd
    sub to_test_Col, distance
    cmp to_test_Row, 132d
    jae OneLeftTwoDownEnd
    add to_test_Row, distance*2
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneLeftTwoDownEnd
    call HelperFunction1

    OneLeftTwoDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ret
GetHosanMoves ENDP

GetFeelMoves proc Near

mov ah, SelectedPieceCol
mov to_test_col, AH
mov al, SelectedPieceRow
mov to_test_row,al


cmp SelectedPieceCol,0
je afteruppermain
cmp SelectedPieceRow, 0
je afteruppermain


checkuppermaindiagonal:
sub to_test_Row, distance
sub to_test_Col, distance
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
CALL IsOccupied
CMP IsSameColorFlag, 1d 
JE afteruppermain   
call HelperFunction1 
CMP IsOccupiedFlag, 1d  
JE afteruppermain
cmp to_test_col,0
je afteruppermain
cmp to_test_row,0
je afteruppermain
jmp checkuppermaindiagonal




afteruppermain:
mov ax,00H
mov ah,SelectedPieceCol
mov to_test_col,ah
mov al, SelectedPieceRow
mov to_test_row,al
cmp to_test_col,154d
je afterlowermain ;;no lower main check would be executed here
cmp to_test_row, 154d
je afterlowermain
check_lower_main_diagonal:
mov al,to_test_col
add al,22d
mov ah, to_test_row
add ah,22d
mov to_test_col, AL
mov to_test_row, AH
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
cmp to_test_square_piececode, 0D
CALL IsOccupied
CMP IsSameColorFlag, 1d 
JE afterlowermain   
call HelperFunction1 
CMP IsOccupiedFlag, 1d  
JE afterlowermain
call HelperFunction1

cmp to_test_col,154d
je afterlowermain
cmp to_test_row,154d
je afterlowermain
cmp to_test_col,154d
jne check_lower_main_diagonal




afterlowermain:
mov ax,00H
mov ah,SelectedPieceCol
mov to_test_col,ah
mov al, SelectedPieceRow
mov to_test_row,al
cmp to_test_col,154d
je afteruppersecondary
cmp to_test_row, 0d
je afteruppersecondary

checkuppersecondary:
mov al, to_test_col
mov ah, to_test_row
add al, 22d
sub ah, 22d
mov to_test_col,al
mov to_test_row, ah
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
cmp to_test_square_piececode, 0D
CALL IsOccupied
CMP IsSameColorFlag, 1d 
JE afteruppersecondary  
call HelperFunction1 
CMP IsOccupiedFlag, 1d  
JE afteruppersecondary
call HelperFunction1

cmp to_test_col, 154d
je afteruppersecondary
cmp to_test_row,0d;
je afteruppersecondary
cmp to_test_col,154d
jne checkuppersecondary




afteruppersecondary:
mov ax,00H
mov ah,SelectedPieceCol
mov to_test_col,ah
mov al, SelectedPieceRow
mov to_test_row,al
cmp to_test_col,0d
je afterlowersecondary
cmp to_test_row,154d
je afterlowersecondary



checklowersecondary:
mov al, to_test_col
mov ah, to_test_row
cmp al,00H
je alis0
sub al, 22d
alis0:
add ah, 22d
mov to_test_col,al
mov to_test_row, ah
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
cmp to_test_square_piececode, 0D
CALL IsOccupied
CMP IsSameColorFlag, 1d 
JE afterlowersecondary  
call HelperFunction1 
CMP IsOccupiedFlag, 1d  
JE afterlowersecondary
call HelperFunction1

cmp to_test_col, 0d
je afterlowersecondary
cmp to_test_row,154d;
je afterlowersecondary
cmp to_test_col,0d
jne checklowersecondary

afterlowersecondary:
ret
GetFeelMoves ENDP

getQueenMoves proc near
    call GetTabyaMoves
    call GetFeelMoves
    ret
getQueenMoves endp


ShowKills proc near
draw_piece tabia,  181d, 10d
movecursor 2, 186d 
writeN1 0
draw_piece hosan, 218d,10d
movecursor 2, 190d 
writeN1 0
draw_piece feel, 255d,10d
movecursor 2,195d
writeN1 0
draw_piece Solider,182d,33d
movecursor 5, 186d 
writeN1 0
draw_piece queen,218d,32d
movecursor 5, 190d 
writeN1 0
draw_piece king,255d,32d
movecursor 5, 195d 
writeN1 0
draw_piece2 tabia2,  181d, 56d
movecursor 8, 186d 
writeN1 0
draw_piece2 hosan2, 218d,56d
movecursor 8, 190d 
writeN1 0
draw_piece2 feel2, 255d,56d
movecursor 8,195d
writeN1 0
draw_piece2 Solider2,182d,80d
movecursor 11, 186d 
writeN1 0
draw_piece2 queen2,218d,80d
movecursor 11, 190d 
writeN1 0
draw_piece2 king2,255d,80d
movecursor 11, 195d 
writeN1 0
ret
ShowKills endp
calculatepiecesdeath proc near
    checkbtabya:
        cmp DesPieceCode,1d
        jne checkbhosan
        inc BlackTabyaDeath 
        movecursor 2, 186d 
        writeN1 BlackTabyaDeath
        checkbhosan:
        cmp DesPieceCode,2d
        jne checkbfeel
        inc BlackHosanDeath
        movecursor 2, 190d 
        writeN1 BlackHosanDeath
        checkbfeel:
        cmp DesPieceCode,3d
        jne checkbQueen
        inc BlackfeelDeath
        movecursor 2, 195d 
        writeN1 BlackfeelDeath
        checkbQueen:
        cmp DesPieceCode,4d
        jne checkbking
        inc BlackQueenDeath
        movecursor 5, 190d 
        writeN1 BlackQueenDeath
        checkbking:
        cmp DesPieceCode,5d
        jne checkbgond
        inc BlackKingDeath
        movecursor 5, 195d 
        writeN1 BlackKingDeath
        checkbgond:
        cmp DesPieceCode,6d
        jne checkwtabya
        inc BlackgondiDeath
        movecursor 5, 186d 
    writeN1 BlackgondiDeath
        checkwtabya:
        cmp DesPieceCode,7d
        jne checkwhosan
        inc WhiteTabyaDeath 
        movecursor 8, 186d 
    writeN1 WhiteTabyaDeath
        checkwhosan:
        cmp DesPieceCode,8d
        jne checkwfeel
    inc WhiteHosanDeath
        movecursor 8, 190d 
    writeN1 WhiteHosanDeath
    checkwfeel:
    cmp DesPieceCode,9d
        jne checkwQueen
    inc WhitefeelDeath
    movecursor 8, 195d 
    writeN1 WhitefeelDeath
        checkwQueen:
    cmp DesPieceCode,10d
    jne checkwking
    inc WhiteQueenDeath
    movecursor 11, 190d 
    writeN1 WhiteQueenDeath
    checkwking:
    cmp DesPieceCode,11d
    jne checkwgond
    inc WhiteKingDeath
    movecursor 11, 195d 
    writeN1 WhiteKingDeath
    checkwgond:
    cmp DesPieceCode,12d
    jne check_ended
    inc WhitegondiDeath
    movecursor 11, 186d 
    writeN1 WhitegondiDeath
    check_ended:
    ret
calculatepiecesdeath  endp


SelectPieceMoves proc near
    mov number_of_potential_cells, 0D
    cmp SelectedPieceCode, 1d
    JE SelectPieceMovesLabel_17
    cmp SelectedPieceCode, 2d
    je SelectPieceMovesLabel_28
    cmp SelectedPieceCode, 3d
    je SelectPieceMovesLabel_39
    cmp SelectedPieceCode, 4d
    je SelectPieceMovesLabel_410
    cmp SelectedPieceCode, 5d
    je SelectPieceMovesLabel_511
    cmp SelectedPieceCode, 6d
    je SelectPieceMovesLabel_6
    cmp SelectedPieceCode, 7d
    JE SelectPieceMovesLabel_17
    cmp SelectedPieceCode, 8d
    je SelectPieceMovesLabel_28
    cmp SelectedPieceCode, 9d
    je SelectPieceMovesLabel_39
    cmp SelectedPieceCode, 10d
    je SelectPieceMovesLabel_410
    cmp SelectedPieceCode, 11d
    je SelectPieceMovesLabel_511
    cmp SelectedPieceCode, 12d
    je SelectPieceMovesLabel_12
    
    SelectPieceMovesLabel_17:
    call GetTabyaMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesLabel_28:
    call GetHosanMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesLabel_39:
    call GetFeelMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesLabel_410:
    call getQueenMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesLabel_511:
    call GetKingMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesLabel_6:
    call GetBgondMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesLabel_12:
    call GetWgondMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesEnd:
    RET
SelectPieceMoves ENDP

ValidateMove proc Near
    MOV isValidMove, 0
    mov BX, 0
    cmp number_of_potential_cells, 0
    JE validateMoveEnd
    ValidateMoveFlag1:
    MOV AL, [potential_cells_squareNumber + BX]
    CMP DesSquare, AL
    JE ValidateMoveFlag2
    INC BL
    cmp BL, number_of_potential_cells
    jne ValidateMoveFlag1
    jmp validateMoveEnd

    ValidateMoveFlag2:
    mov isValidMove, 1
    validateMoveEnd:
    RET
ValidateMove ENDP

; TWO VARIABLES ISOCCUPIEDFLAG AND ISSAMECOLORFLAG
IsOccupied proc near
    MOV IsOccupiedFlag, 0D
    MOV IsSameColorFlag, 0D
    CMP to_test_square_piececode, 0D
    JE IsOccupiedRet
    MOV IsOccupiedFlag, 1d

    cmp SelectedPieceCode, 6d
    JBE notblack
    JMP notwhite

    notblack: ; Selected is black (1-6) so destination cannot be black
    CMP to_test_square_piececode, 6d
    JBE PieceIsOfSameColor
    jmp IsOccupiedRet

    notwhite:
    CMP to_test_square_piececode, 7d
    JAE PieceIsOfSameColor
    jmp IsOccupiedRet
    
    PieceIsOfSameColor:
    MOV IsSameColorFlag, 1d

    IsOccupiedRet:
    RET

IsOccupied endp

HelperFunction1 proc Near
    mov bh, 0
    mov bl, number_of_potential_cells
    mov AL, to_test_row
    mov [potential_cells_row + BX], AL
    mov AL, to_test_col
    mov [potential_cells_col + BX], AL
    inc number_of_potential_cells
    calculate_square to_test_Row, to_test_Col, dummy1
    mov AL, dummy1
    mov [potential_cells_squareNumber + BX], AL
    RET
HelperFunction1 endp


Highlight PROC NEAR
    CMP number_of_potential_cells, 0d
    JE HighlightRet
    MOV BX, 0d
    CONTINUE_HIGHLIGHT:
    MOV AL, [potential_cells_row + BX]
    MOV to_test_row, AL
    MOV AL, [potential_cells_col + BX]
    MOV to_test_col, AL
    push BX
    Drawsquare to_test_row, to_test_col, cyan_color
    pop BX
    INC BL
    CMP BL, number_of_potential_cells
    JNE CONTINUE_HIGHLIGHT
    HighlightRet:
    RET
Highlight ENDP

Dehighlight PROC NEAR
    CMP number_of_potential_cells, 0d
    JE DeHighlightRet
    MOV BX, 0d
    CONTINUE_DEHIGHLIGHT:
    MOV AL, [potential_cells_row + BX]
    MOV to_test_row, AL
    MOV AL, [potential_cells_col + BX]
    MOV to_test_col, AL
    push BX 
    calculate_square to_test_Row, to_test_Col, cell_number ; This is not the function that affects BX
    getSquareColor cell_color, cell_number
    Drawsquare to_test_row, to_test_col, cell_color
    pop BX
    INC BL
    CMP BL, number_of_potential_cells
    JNE CONTINUE_DEHIGHLIGHT
    DehighlightRet:
    ret
Dehighlight ENDP

NAMESCREEN PROC near
    movecursor 01h, 01h
    print enternamemes
    movecursor 02h, 05h
    mov bx, offset p1name
    READNAME
    mov bh, 0h ; necessary since bx changes in readname function ; default is bh = 0 for moving cursor

    movecursor 10h, 01h
    print presstocontinuemes

    waitforuseractionNS:
    mov ah, 0
    int 16h

    ; CHECK IF KEY IS ESC
    cmp ah, Escscancode
    je exitnamescreen

    ; CHECK IF KEY IS ENTER
    cmp ah, Enterscancode
    jne waitforuseractionNS
    clearscreen
    RET
    exitnamescreen:
    clearscreen
    exit
NAMESCREEN ENDP


GAMESCREEN PROC NEAR
    ;CONFIGURATION  
    graphicsmode
    draw_board
;......................................................THE BLACK SET...........................................................

    ; ----------- DRAW king ------------
    draw_piece king,  bkingrow, bkingcol
    ;----------- DRAW queen ------------
    draw_piece queen,  bqueenrow, bqueencol
    ;-------DRAW hosan-------------
    draw_piece hosan,  bhosanrow, bhosancol
    ;-------DRAW Another hosan-------------
    draw_piece hosan,  bhosan2row, bhosan2col
    ;-------DRAW tabia-------------
    draw_piece tabia, btabiarow, btabiacol
    ;-------DRAW Another tabia-------------
    draw_piece tabia,btabia2row, btabia2col
    ;-------DRAW feel-------------
    draw_piece feel, bfeelrow, bfeelcol
    ;-------DRAW Another feel-------------
    draw_piece feel, bfeel2row, bfeel2col
    ;----------- DRAW Solider ------------
    draw_piece Solider, bsoliderrow, bsolidercol
    ;-------DRAW ANOTHER Solider-------------
    draw_piece Solider, bsolider2row, bsolider2col
    ;-------DRAW ANOTHER Solider-------------
    draw_piece Solider, bsolider3row, bsolider3col
    ;-------DRAW ANOTHER Solider-------------
    draw_piece Solider, bsolider4row, bsolider4col
    ;-------DRAW ANOTHER Solider-------------
    draw_piece Solider, bsolider5row, bsolider5col
    ;-------DRAW ANOTHER Solider-------------
    draw_piece Solider, bsolider6row, bsolider6col
    ;-------DRAW ANOTHER Solider-------------
    draw_piece Solider,  bsolider7row, bsolider7col
    ;-------DRAW ANOTHER Solider-------------
    draw_piece Solider,bsolider8row, bsolider8col
;......................................................THE WHITE SET...........................................................
    ; ----------- DRAW king ------------
    draw_piece2 king2,  wkingrow, wkingcol
    ;----------- DRAW queen ------------
    draw_piece2 queen2,  wqueenrow, wqueencol
    ;-------DRAW hosan-------------
    draw_piece2 hosan2,  whosanrow, whosancol
    ;-------DRAW Another hosan-------------
    draw_piece2 hosan2,  whosan2row, whosan2col
    ;-------DRAW tabia-------------
    draw_piece2 tabia2, wtabiarow, wtabiacol
    ;-------DRAW Another tabia-------------
    draw_piece2 tabia2, wtabia2row, wtabia2col
    ;-------DRAW feel-------------
    draw_piece2 feel2, wfeelrow, wfeelcol
    ;-------DRAW Another feel-------------
    draw_piece2 feel2, wfeel2row, wfeel2col
    ;----------- DRAW Solider ------------
    draw_piece2 Solider2, wsoliderrow, wsolidercol
    ;-------DRAW ANOTHER Solider-------------
    draw_piece2 Solider2, wsolider2row, wsolider2col
    ;-------DRAW ANOTHER Solider-------------
    draw_piece2 Solider2, wsolider3row, wsolider3col
    ;-------DRAW ANOTHER Solider-------------
    draw_piece2 Solider2, wsolider4row, wsolider4col
    ;-------DRAW ANOTHER Solider-------------
    draw_piece2 Solider2, wsolider5row, wsolider5col
    ;-------DRAW ANOTHER Solider-------------
    draw_piece2 Solider2, wsolider6row, wsolider6col
    ;-------DRAW ANOTHER Solider-------------
    draw_piece2 Solider2, wsolider7row, wsolider7col
    ;-------DRAW ANOTHER Solider-------------
    draw_piece2 Solider2, wsolider8row, wsolider8col
    ;-------------------------
    Drawsquare selected_frame_row, selected_frame_col, red_color ; draw frame in initial position at topleft of the board

    Drawsquare selected_frame_row2, selected_frame_col2, green_color ; ; draw frame in initial position at bottom right of the board
    ;----------------------------------
    call ShowKills
    
    ;---------------
    GetSystemTime
    mov inctime, dh

    CHECK_Time1: 
    call RunTime
    call InGameChat
    CALL RunPieceTimers
    CMP powerupselector, 0h
    JNE powerupSkipped
    CMP poweruponboard, 1H
    JE powerupSkipped
    ;CALL PowerUpFunction
    powerupSkipped:
    CALL CheckGameEnd
    CMP GAME_END, 1h
    JE GAME_ENDED_LABEL
    waitforuseractionGS:
    ; mov ah, 01h
    ; int 16h
    ; JZ label3
    ; cmp ah, Escscancode ; check if key is ESC
    ; jz GameScreenEnd
    RIsSenT:
        mov dx , 3FDH    ; check Line Status Register 
        in al , dx 
        and al , 1
        JZ Rnext          ; There is no recieved data
        call Rexecutekeypress     ;if ready read the value in received data register
       ; CMP Exit_Chat, 1
       ; JZ exitchat
        mov al,1 
        mov dx , 3FDH 
        out dx,al 
        jmp cont
    Rnext:
        mov ah,1
        int 16h			 ;check if character available in buffer
        jz cont
        ;jz RIsSenT        ; no char is written
        mov ah,0         ;lw buffer not empty asci in al,scan in ah
        int 16h          ;get key pressed
        call executekeypress
        ;CMP Exit_Chat, 1
        ;JZ exitchat
        ;jmp IsSenT
    ;call executekeypress
    cont:
    clearkeyboardbuffer

    label3:
    GetSystemTime
    cmp dl, aux_time ; dl contains 1/100 of a second
    JE waitforuseractionGS ; if no 1/100 second has passed, wait for user action again
    
    ; If 1/100 seconds passed, run the time 
    mov aux_time, dl
    jmp CHECK_Time1
    
    GAME_ENDED_LABEL:
    clearkeyboardbuffer
    getkeypress ; WAITS FOR ANY OF THE USER TO PRESS ESC TO EXIT THE GAME COMPLETELY
    cmp ah, Escscancode
    JNE GAME_ENDED_LABEL
    GameScreenEnd: ; clean up
    clearscreen
    textmode
    RET          
GAMESCREEN ENDP
movepiece proc near
    ;-----------DRAW A SQUARE ON THE selected SQUARE PIECE
    getSquareColor selectedSquareColor, SelectedPieceSquare
    MOV DH, 0D
    MOV DL, SelectedPieceRow
    MOV CH, 0D
    MOV CL, SelectedPieceCol
    MOV scol, CX
    MOV VerticalDimension, squaredimension ; fe e7tmal enena mafrod n3ml de squaredimension + 1 lly hya 25
    MOV HorizontalDimension, squaredimension
    ADD HorizontalDimension, CX
    ADD VerticalDimension, DX
    draw_filled_square HorizontalDimension, VerticalDimension, scol, selectedSquareColor
    UpdateSquare selectedPieceSquare, 0D ; set the past square of the piece to 0 which means empty square
    ;----------First, DRAW A SQUARE ON THE DESTINATION SQUARE TO AVOID OVERLAPPING OF IMAGES
    getSquareColor DesColor, DesSquare
    MOV DH, 0D
    MOV DL, DesRow
    MOV CH, 0D
    MOV CL, DesCol
    MOV scol, CX
    MOV VerticalDimension, squaredimension 
    MOV HorizontalDimension, squaredimension
    ADD HorizontalDimension, CX
    ADD VerticalDimension, DX
    draw_filled_square HorizontalDimension, VerticalDimension, scol, DesColor
    ;-----------------------------

    call calculatepiecesdeath ; update number of killed pieces
    
    UpdateSquare DesSquare, SelectedPieceCode ; the square is updated with the new piece on it
    
    Redraw SelectedPieceCode, DesCol, DesRow ; piece is redrawn
    
    CALL SetPieceStopTime
    
    call CheckPromotion
    ; call UpdateKillStatus
    
    call updateKingsPos
    ;--------------------------
    ;cmp DesSquare, PowerUpSquare ; CHECK IF PLAYER CAPTURES ON CELL WITH POWERUP ON IT
    JNE UpdatePowerUpVars
    CMP poweruponboard, 1D ; ADDITIONAL CHECK IN CASE POWERUPSQUARE CONTAINS GARABAGE WHICH MIGHT CAUSE PROBLEMS
    JNE UpdatePowerUpVars ; REMEMBER HOWERVER, TO SET POWERUPSQUARE TO 64D IF NO POWERUP IS ON BOARD
    MOV poweruponboard, 0D ; IF A PLAYER TAKES THE POWERUP, UPDATE ITS STATE
    CALL ImplementPowerUp
    UpdatePowerUpVars:
    inc powerupselector ; powerupselector is incremented to facilitate its appearance
    cmp powerupselector, 5D
    jne movepieceEnd
    mov powerupselector, 0d
    ;--------------------------
    movepieceEnd:
    RET
movepiece ENDP

;-----------------BONUS-------------------
 GeneratePowerUp proc Near ; works by generating a random number using the system time, then checking that the cell with this number is 
    GetSystemTime ; valid ( in range [0,63] and that it is not occupied)
    CMP DL, 63D
    JA GeneratePowerUpEnd
    MOV BX, 0H
    MOV BL, DL
    CMP [SquarePieceArray + BX], 0H ; check that the random generated number
    JNE GeneratePowerUpEnd ; is not the square number of an occupied cell
    MOV PowerUpSquare, DL
    GeneratePowerUpEnd:
    RET
GeneratePowerUp endp

PowerUpFunction PROC NEAR
    call GeneratePowerUp ; generate the powerup square
    CMP PowerUpSquare, 63D
    JA PowerUpFunctionEnd ; if generated square powerup is 64, then PowerUpFunction is not implemented
    
    ; PowerUp will be implemented. It is guaranteed that powerup will appear on an empty cell

    getRowColumnfromsquareNumber poweruprow, powerupcol, PowerUpSquare
    getSquareColor PowerUpSquareColor, PowerUpSquare
    ;--------- Prepare for drawing----------
    MOV CH, 0d
    MOV CL, powerupcol
    mov scol, CX
    draw_filled_square squaredimension,squaredimension,SCOL, PowerUpSquareColor
    ;----------------
    draw_piece2 powerup, powerupcol, poweruprow
    MOV poweruponboard, 1D
    PowerUpFunctionEnd:
    RET
PowerUpFunction ENDP

ImplementPowerUp proc near

ImplementPowerUp ENDP
;-----------------------------------------

SetPieceStopTime proc near
    GetSystemTime
    mov bh, 0000H
    mov bl, DesSquare ; we need to check this didn't change
    mov [StartTimeArray + BX], DH ; THE TIME IN SECONDS AT WHICH THE PIECE WAS MOVED IS RECORDED
    MOV AL, CountDownTime
    mov [timerArray + BX], AL ; SET PIECE TIMER START TO 3 SECONDS
    Drawsquare DesRow, DesCol, yellow_color
    RET
SetPieceStopTime endp


 RunPieceTimers proc near
    GetSystemTime ; DH HAS THE SYSTEM TIME IN SECONDS
    cmp dh, seconds
    JE RunPieceTimersEnd
    MOV BX, 0 
    RunPieceTimers_Label:
    mov AL,[timerArray+BX]  ; IF ZERO, THAT MEANS THE PIECE HAS NO COUNTDOWN ON IT, SO GO TO THE NEXT
    CMP AL, 0D
    JE nxtloop
    MOV AL, [StartTimeArray + BX] ; else if not zero, compare the time at which its timer started with the current time in seconds
    CMP AL, DH
    je nxtloop ; if equal, do nothing
    MOV AL, [timerArray + BX] ; else , decrement it
    DEC AL
    MOV [timerArray + BX], AL
    CMP [timerArray + BX], 0D
    jne nxtloop
    Unlock_Redraw:
    mov dummy4, BL ; DUMMY4 HAS THE SQUARE NUMBER
    PUSHA
    getSquareColor dummy1, dummy4
    getRowColumnfromsquareNumber dummy2, dummy3, dummy4 ; DUMMY2 AND DUMMY3 HAVE THE ROW AND COL RESPECTIVELY
    Drawsquare dummy2, dummy3, dummy1 ; DUMMY1 HAS THE SQUARE COLOR
    POPA
    nxtloop:
    INC BX
    CMP BX, 64D
    JE RunPieceTimersEnd
    JMP RunPieceTimers_Label
    RunPieceTimersEnd:
    RET
RunPieceTimers ENDP



RunTime proc near
    GetSystemTime  ; dh :seconds , dl:1/100 seconds
    cmp dh, inctime ;dummy variable 
    JE RunTimeEnd

    inc inctime
    cmp inctime, 60d
    JNE RuntimeLabel1
    Mov inctime, 0d


    RuntimeLabel1:
    inc seconds 
    cmp seconds,60d
    jne label2  
    mov seconds,00
    inc minutes
    cmp minutes,60d
    jne label2
    mov minutes,00
    inc hours
    cmp hours,24d 
    jne label2
    mov seconds,00
    mov minutes,00
    mov hours,00
    label2:
    TurnTimetostring seconds,secondsstr+2 
    TurnTimetostring hours,hoursstr+2  
    TurnTimetostring minutes,minutesstr+2
    movecursor 0,29
    mov dx,offset hoursstr+2
    call PRINTMESSAGE
    mov dl,':'
    mov ah,2
    int 21h     
    mov dx,offset minutesstr+2
    call PRINTMESSAGE
    mov dl,':'
    mov ah,2
    int 21h
    mov dx,offset secondsstr+2
    call PRINTMESSAGE

    RunTimeEnd:
    ret
RunTime endp


; UpdateKillStatus proc near
    
;     cmp DesPieceCode , 0
;     je killend
    
;     cmp selectedPieceCode , 6
;     jbe Black
    
;     cmp DesPieceCode , 6
;     ja killend
    
;     inc BKill
;     jmp killB

;     Black :
;     cmp DesPieceCode , 6
;     jbe killend

;     inc WKill
;     jmp KillW

;     killW :
;     movecursor 23,1
;     print WhiteKill
;     movecursor 23,16
;     TurnTimetostring WKill , Wkkill
;     mov NotificationBarMessage,offset Wkkill
;     CALL ShowNotifications
    
;     jmp killend
    
;     KillB :
;     movecursor 23,1
;     print BlackKill
;     movecursor 23,16
;     TurnTimetostring BKill , Bkkill
;     mov NotificationBarMessage,offset Bkkill
;     CALL ShowNotifications
    
;     killend :
;     RET
; UpdateKillStatus endp





CheckPromotion proc near
    cmp selectedPieceCode, 6d
    JNE BlackPromotionEnd ; if piece is not black pawn, check white pawn
    BlackPromotion:
        CMP DesSquare, 56D ; 56D IS THE THE SQUARE CODE OF THE FIRST SQUARE IN THE LAST ROW
        JB CheckPromotionEnd
        CMP DesSquare, 63D
        JA CheckPromotionEnd ; THIS SHOULD NEVER HAPPEN THOUGH
        CALL Promote
    BlackPromotionEnd:
    
    CMP SelectedPieceCode, 12d
    JNE CheckPromotionEnd ; if piece is also not white pawn, end

    WhitePromotion:
        CMP DesSquare, 7d
        JA CheckPromotionEnd
        CMP DesSquare, 0d
        JB CheckPromotionEnd
        CALL Promote
    CheckPromotionEnd:
    Ret
CheckPromotion endp

Promote PROC NEAR

    ;--------- Prepare for drawing----------
    MOV CH, 0d
    MOV CL, DesCol
    mov scol, CX
    draw_filled_square squaredimension,squaredimension,SCOL, DesColor
    ;--------------------
    CMP SelectedPieceCode, 6d
    JNE PromoteWhite
    PromoteBlack:
    draw_piece queen,  DesCol, DesRow
    UpdateSquare DesSquare, 4d
    RET
    PromoteWhite:
    draw_piece2 queen2, DesCol, DesRow
    UpdateSquare DesSquare, 10d
    RET
Promote ENDP

Castle proc Near

Castle endp

KingInCheck proc Near
    mov NextNotification, offset empty

    ; LET A HOSAN IN THE POSITION OF THE KING AND GET ALL THE REACHABLE POSITIONS LIKE USUAL
    ; CHECK IF ANY OF THOSE POSITIONS HAS A WHITE HOSAN IN IT, IF SO THEN KING IS IN CHECK
    
    BlackKing:
    MOV AL, BKingPos
    MOV SelectedPieceSquare, AL
    MOV AL, bkingrow1
    MOV SelectedPieceRow, AL
    MOV AL, bkingcol1
    MOV SelectedPieceCol, AL


    LET_BKING_BE_KING:
    MOV number_of_potential_cells, 0D 
    MOV SelectedPieceCode, 5D 
    call GetKingMoves
    CMP number_of_potential_cells, 0d
    JE LET_BKING_BE_HOSAN
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_BKING_BE_KING_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    PUSH BX
    GetSquarePieceCode dummy1, CH
    POP BX
    CMP dummy1, 11d 
    JE BlackkingISInCheck
    DEC CL
    JNZ LET_BKING_BE_KING_LABEL1


    LET_BKING_BE_HOSAN:
    MOV number_of_potential_cells, 0D ; reset number of potential cells in case it is not zero ; it probably is though
    MOV SelectedPieceCode, 2D ; king is hosan
    call GetHosanMoves
    CMP number_of_potential_cells, 0d
    JE LET_BKING_BE_TABIA
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_BKING_BE_HOSAN_LABEL1: ; loop
    MOV CH, [potential_cells_squareNumber + BX] ; get square number of all potential cells
    INC BX
    PUSH BX
    GetSquarePieceCode dummy1, CH ; get square piece code of given square number in dummy2
    POP BX
    CMP dummy1, 8d ; if square piece code equals the square piece code of WHITE HOSAN, THAT means that a white hosan checks the black king
    JE BlackkingISInCheck
    DEC CL
    JNZ LET_BKING_BE_HOSAN_LABEL1
    
    LET_BKING_BE_TABIA:
    MOV number_of_potential_cells, 0D
    MOV SelectedPieceCode, 1D 
    call GetTabyaMoves
    CMP number_of_potential_cells, 0d
    JE LET_BKING_BE_FEEL 
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_BKING_BE_TABIA_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    PUSH BX
    GetSquarePieceCode dummy1, CH
    POP BX
    CMP dummy1, 7d 
    JE BlackkingISInCheck
    DEC CL
    JNZ LET_BKING_BE_TABIA_LABEL1

    LET_BKING_BE_FEEL:
    MOV number_of_potential_cells, 0D
    MOV SelectedPieceCode, 3D 
    call GetFeelMoves 
    CMP number_of_potential_cells, 0d
    JE LET_BKING_BE_QUEEN
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_BKING_BE_FEEL_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    PUSH BX
    GetSquarePieceCode dummy1, CH
    POP BX
    CMP dummy1, 9d 
    JE BlackkingISInCheck
    DEC CL
    JNZ LET_BKING_BE_FEEL_LABEL1

    LET_BKING_BE_QUEEN:
    MOV number_of_potential_cells, 0D
    MOV SelectedPieceCode, 4D 
    call getQueenMoves
    CMP number_of_potential_cells, 0d
    JE WhiteKing;LET_BKING_BE_GOND
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_BKING_BE_QUEEN_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    push BX
    GetSquarePieceCode dummy1, CH
    pop BX
    CMP dummy1, 10d 
    JE BlackkingISInCheck
    DEC CL
    JNZ LET_BKING_BE_QUEEN_LABEL1
    JMP WhiteKing

    ; LET_BKING_BE_GOND:
    ; MOV number_of_potential_cells, 0D
    ; MOV SelectedPieceCode, 6D 
    ; call GetBgondMoves
    ; CMP number_of_potential_cells, 0d
    ; JE WhiteKing
    ; MOV BX, 0d
    ; MOV CL, number_of_potential_cells
    ; LET_BKING_BE_GOND_LABEL1: 
    ; MOV CH, [potential_cells_squareNumber + BX] 
    ; INC BX
    ; push BX
    ; GetSquarePieceCode dummy1, CH
    ; pop BX
    ; CMP dummy1, 12d 
    ; JE BlackkingISInCheck
    ; DEC CL
    ; JNZ LET_BKING_BE_GOND_LABEL1


    
    
    BlackKingIsInCheck:
    MOV number_of_potential_cells, 0D ; REMEMBER TO RESET TO ZERO
    MOV BKingChecked, 1D
    MOV NextNotification, offset BlackKingIsCheckedMessaage
    call ShowNotifications
   
    ret
    
    WhiteKing:
    MOV AL, WKingPos
    MOV SelectedPieceSquare, AL
    MOV AL, wkingrow1
    MOV SelectedPieceRow, AL
    MOV AL, wkingcol1
    MOV SelectedPieceCol, AL


    LET_WKING_BE_KING:
    MOV number_of_potential_cells, 0D 
    MOV SelectedPieceCode,11D 
    call GetKingMoves
    CMP number_of_potential_cells, 0d
    JE LET_WKING_BE_HOSAN
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_WKING_BE_KING_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    PUSH BX
    GetSquarePieceCode dummy1, CH 
    POP BX
    CMP dummy1, 5d 
    JE WhitekingISInCheck
    DEC CL
    JNZ LET_WKING_BE_KING_LABEL1

    LET_WKING_BE_HOSAN:
    MOV number_of_potential_cells, 0D 
    MOV SelectedPieceCode, 8D 
    call GetHosanMoves
    CMP number_of_potential_cells, 0d
    JE LET_WKING_BE_TABIA
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_WKING_BE_HOSAN_LABEL1:
    MOV CH, [potential_cells_squareNumber + BX]
    INC BX 
    push BX
    GetSquarePieceCode dummy1, CH 
    pop BX
    CMP dummy1, 2d 
    JE WhitekingISInCheck
    DEC CL
    JNZ LET_WKING_BE_HOSAN_LABEL1
    
    LET_WKING_BE_TABIA:
    MOV number_of_potential_cells, 0D
    MOV SelectedPieceCode, 7D 
    call GetTabyaMoves
    CMP number_of_potential_cells, 0d
    JE LET_WKING_BE_FEEL
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_WKING_BE_TABIA_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX]
    INC BX
    PUSH BX 
    GetSquarePieceCode dummy1, CH
    POP BX
    CMP dummy1, 1d 
    JE WhitekingISInCheck
    DEC CL
    JNZ LET_WKING_BE_TABIA_LABEL1

    LET_WKING_BE_FEEL:
    MOV number_of_potential_cells, 0D
    MOV SelectedPieceCode, 9D 
    call GetFeelMoves 
    CMP number_of_potential_cells, 0d
    JE LET_WKING_BE_QUEEN
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_WKING_BE_FEEL_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    push BX
    GetSquarePieceCode dummy1, CH
    POP BX
    CMP dummy1, 3d
    JE WhitekingISInCheck
    DEC CL
    JNZ LET_WKING_BE_FEEL_LABEL1

    LET_WKING_BE_QUEEN:
    MOV number_of_potential_cells, 0D
    MOV SelectedPieceCode, 10d 
    call SelectPieceMoves 
    CMP number_of_potential_cells, 0d
    JE KingInCheckRetempty
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_WKING_BE_QUEEN_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    PUSH BX
    GetSquarePieceCode dummy1, CH
    POP BX
    CMP dummy1, 4d
    JE WhitekingISInCheck
    DEC CL
    JNZ LET_WKING_BE_QUEEN_LABEL1
    JMP KingInCheckRetempty


    WhiteKingIsInCheck:
    MOV number_of_potential_cells, 0D ; REMEMBER TO RESET TO ZERO
    MOV WKingChecked, 1D
    MOV NextNotification, offset WhiteKingIsCheckedMessaage
    call ShowNotifications
    jmp KingInCheckRet
    
    
    KingInCheckRetempty:
    MOV NextNotification, offset Empty
    call ShowNotifications
    call ShowNotifications
    RET
    KingInCheckRet:
    RET
KingInCheck endp


updateKingsPos proc near
    cmp selectedPieceCode, 5d
    JNE updateKingsPos_label2
    updateKingsPos_label1: ; update black king pos
    MOV AL, DesSquare
    MOV BkingPos, AL
    mov AL, DesRow
    MOV Bkingrow1, AL
    mov AL, DesCol
    MOV Bkingcol1, AL
    JMP updateKingsPosRet


    updateKingsPos_label2: ; update white king pos
    cmp selectedPieceCode, 11d
    JNE updateKingsPosRet
    MOV AL, DesSquare
    MOV WkingPos, AL
    mov AL, DesRow
    MOV Wkingrow1, AL
    mov AL, DesCol
    MOV Wkingcol1, AL

    updateKingsPosRet:
    ret
updateKingsPos ENDP

ingamechat proc near
       movecursor 13, 102d 
       print border2
movecursor 14, 102d 
print p1name
print space2
movecursor 18, 102d 
 print border2
 movecursor 19, 102d 
print p2name
print space2
movecursor 23, 102d 
 print border2
 movecursor 15,102d
        ; mov bl,0
        ;   mov ax,0602h
        ;  mov bh,00Fh       ;font and screen colour
        ;   mov cl,12      ;first half
        ;   mov ch,102d
        ;  mov dL,18
        ;  mov dh,119d
        ; int 10h
      
    ;     mov bl,0
    ;      mov ax,0602h
    ;      mov bh,00Fh       ;font and screen colour
    ;      mov cx,2E36h      ;second half
    ;     mov dx,324fh
    ;      int 10h
    ;    mov bh,0  
        ; call configuration;first thing to do
       ;configuration
    RIsSenT2:
        mov dx , 3FDH    ; check Line Status Register 
        in al , dx 
        and al , 1
        JZ Rnext2         ; There is no recieved data
        call Rexecutekeypress     ;if ready read the value in received data register
       ; CMP Exit_Chat, 1
       ; JZ exitchat
        mov al,1 
        mov dx , 3FDH 
        out dx,al 
        jmp cont2
    Rnext2:
        mov ah,1
        int 16h			 ;check if character available in buffer
        jz cont2
        ;jz RIsSenT        ; no char is written
        mov ah,0         ;lw buffer not empty asci in al,scan in ah
        int 16h          ;get key pressed
        call executekeypress
        ;CMP Exit_Chat, 1
        ;JZ exitchat
        ;jmp IsSenT
    ;call executekeypress
    cont2:
    clearkeyboardbuffer
    exitchat2:
        ; a3tkd hena hykon fe shwyt cleanup	
		ret  	
endp ingamechat




chatSCREEN PROC NEAR
        mov firs_half, 0300h
        mov sec_half,  0d00h

        movecursor 18h,02h
        print mes4

        movecursor 00h, 00h
        print border

        movecursor 01h, 00h
        print p1name
        print space

        movecursor 0AH, 00h  

        
        print line
        movecursor 0bh,00h

        print p2name
        print space

        movecursor 03h, 00h
        
        mov bl,0
        mov ax,0600h
        mov bh,00fh         ; font and screen colour
        mov cx,0300H        ;first half
        mov dx,094fh		
        int 10h	

        mov bl,0
        mov ax,0600h
        mov bh,00Fh       ;font and screen colour
        mov cx,0C00h      ;second half
        mov dx,154fh
        int 10h
        mov bh,0  
        ; call configuration;first thing to do
    IsSenT:
        mov dx , 3FDH    ; check Line Status Register 
        in al , dx 
        and al , 1
        JZ next          ; There is no recieved data
        call Receive     ;if ready read the value in received data register
        CMP Exit_Chat, 1
        JZ exitchat
        mov al,1 
        mov dx , 3FDH 
        out dx,al   
    next:
        mov ah,1
        int 16h			 ;check if character available in buffer
        jz IsSenT        ; no char is written
        getkeypress ;lw buffer not empty asci in al,scan in ah
        cmp ah, F3scancode
        JE exitchat
        call Send
        CMP Exit_Chat, 1
        JZ exitchat
        jmp IsSenT
  	
    exitchat:
        ; a3tkd hena hykon fe shwyt cleanup
        CLEARSCREEN 	
		ret  	
chatSCREEN ENDP





Send Proc near 
	mov Xsend,al;if esc was clicked so exit
	cmp al,27
    jnz continue
	mov dx ,3FDH		; Line Status Register, to send data check if THR empty or not
	AGAIN11:
  	In al,dx 			;Read Line Status
	and al , 00100000b
	jz AGAIN11

	mov dx , 3F8H		; (if empty)Transmit data register
    mov  al,Xsend
  	out dx , al 
	MOV Exit_Chat, 1
	RET
	
	CMP AX, 0E08H
	JNZ continue
	MOV Xsend, 08H
	JMP sDisplay
	
	
    continue:	
	mov ah,79
	cmp byte ptr firs_half,ah
	jb snot_end_x

	mov ah,09h
	cmp byte ptr firs_half[1],ah
	jb sDisplay

	mov word ptr firs_half,0900h
	mov ah,2
	mov dx,word ptr firs_half   ;setting cursor
	int 10h 
	mov bl,0
	mov ax,0601h
	mov bh,00Fh       ;scrolling one line
	mov cx,0300h
	mov dx,094fh
	int 10h
	jmp sDisplay

    snot_end_x:
	mov ah,09h
	cmp byte ptr firs_half[1],ah 
	jb scheck_enter
	cmp al,0Dh
	jne sDisplay
	mov word ptr firs_half,0D00h
	mov bl,0
	mov ax,0601h
	mov bh,00Fh
	mov cx,0300h
	mov dx,094fh
    ;add dl,8
	int 10h
	jmp sDisplay

    scheck_enter:
	cmp al,0dh
	jne sDisplay
	mov byte ptr firs_half,00h	
	inc byte ptr firs_half[1]
    	
	jmp sDisplay
	
    sDisplay:
	mov ah,2
	mov dx,word ptr firs_half
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
	mov dl , Xsend;print char
	mov ah ,2 
  	int 21h
    NEXT_STEP:
	mov ah,3h 
	mov bh,0h    ;getting cursor position
	int 10h
	mov word ptr firs_half,dx

	mov dx ,3FDH		; Line Status Register, to send data check if THR empty or not
	AGAIN2:
  	In al,dx 			;Read Line Status
	and al , 00100000b
	jz AGAIN2

	mov dx , 3F8H		; (if empty)Transmit data register
    mov  al,Xsend
  	out dx , al 
	ret
Send endp
    ;-----------------------------------------------------------------------------------------------------------------------------
    ;-----------------------------------------------------------------------------------------------------------------------------
Receive proc near 
        mov dx , 03F8H
        in al , dx 
        mov Yrecieve , al
        cmp al,27               ; esc was clicked 
        jz buffer
        
        mov ah,79
        cmp byte ptr sec_half,ah
        jb rnot_end_x

        mov ah,15h
        cmp byte ptr sec_half[1],ah
        jb rDisplay

        mov word ptr sec_half,1500h
        mov ah,2
        mov dx,word ptr sec_half
        int 10h 

        mov bl,0
        mov ax,0601h
        mov bh,00Fh
        mov cx,0C00h      ;scrolling one line
        mov dx,154fh
        int 10h
        jmp rDisplay
    buffer:
        MOV Exit_Chat, 1
        RET
    rnot_end_x:

        mov ah,15h
        cmp byte ptr sec_half[1],ah
        jb rcheck_enter
        cmp al,0Dh
        jne rDisplay
        mov word ptr sec_half,1800h
        mov bl,0
        mov ax,0601h
        mov bh,00Fh
        mov cx,0C00h
        mov dx,154fh
        int 10h
        jmp rDisplay

    rcheck_enter:
        cmp al,0Dh
        jne rDisplay
        mov byte ptr sec_half,00h	
        inc byte ptr sec_half[1]	
        jmp rDisplay
        
    rDisplay:
        mov ah,2
        mov dx,word ptr sec_half
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
    mov dl , Yrecieve
        mov ah ,2 
        int 21h
    NEXT_STEP_2:	
        mov ah,3h 
        mov bh,0h 
        int 10h
        mov word ptr sec_half,dx
        ret
Receive endp
    ;-----------------------------------------------------------------------------------------------------------------------------
    configuration 		Proc near
        mov dx,3fbh 			; Line Control Register
        mov al,10000000b		;Set Divisor Latch Access Bit
        out dx,al			    ;Out it
    
        mov dx,3f8h	            ;set lsb byte of the baud rate devisor latch register	
        mov al,0ch		 	
        out dx,al
    
        mov dx,3f9h             ;set msb byte of the baud rate devisor latch register
        mov al,00h              ;to ensure no garbage in msb it should be setted
        out dx,al

        mov dx,3fbh             ;used for send and receive
        mov al,00011011b
        out dx,al
        ret
    configuration 		endp
    ;-----------------------------------------------------------------------------------------------------------------------------
    Sending_Char        PROC NEAR 
        mov dx , 3FDH            ; Line Status Register
    CHECK_AGAIN:        IN  al , dx               ;Read Line Status
        TEST al , 00100000b
        JZ CHECK_AGAIN
        ;If empty put the VALUE in Transmit data register
        mov dx , 3F8H ; Transmit data register
        mov al,Char_Send
        OUT dx , al
        RET
    Sending_Char        ENDP 
    ;-----------------------------------------------------------------------------------------------------------------------------
    Recieving_Char      PROC NEAR
        ;Check that Data is Ready
        mov dx , 3FDH ; Line Status Register
        CHK_AGAIN: 			IN al , dx
        TEST al , 1
        JZ CHK_AGAIN ;Not Ready 
        ;If Ready read the VALUE in Receive data register
        mov dx , 3F8H
        IN al , dx
        mov Char_Recieve , al
        RET
    Recieving_Char      ENDP	
        ;; ------------------------------------ Connection Procedures ----------------------- ;;
        
RecieveInvitations PROC NEAR
    PUSHA
    ;Check that Data is Ready
    mov dx , 3FDH		; Line Status Register
    in al , dx 
    test al , 1
    JZ Return_RecieveInvitations             ; Not Ready

    ; If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx 

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

SendByte PROC  ; data transferred is in BL (8 bits)
    ;Check that Transmitter Holding Register is Empty
    mov dx , 3FDH		        ; Line Status Register
    AGAIN:
        In al, dx 			    ; Read Line Status
        test al, 00100000b
    JZ AGAIN                    ; Not empty

    ;If empty put the VALUE in Transmit data register
    mov dx, 3F8H		        ; Transmit data register
    mov al, BL
    out dx, al
    ret
SendByte ENDP



RecieveByte PROC ; data is saved in BL

    ;Check that Data is Ready
    mov dx , 3FDH		; Line Status Register
    CHK_RecieveByte:
        in al , dx 
        test al , 1
    JZ CHK_RecieveByte              ; Not Ready

    ; If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx 
    mov bl , al

    Return_RecieveByte:
        ret
RecieveByte ENDP



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
    movecursor 15h, 0h
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

    lea si, p1name
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
    lea si, p2name
    CALL SendMsg
CALL SendByte
    CALL RecieveByte
        ; MOV InitialPointsP2, BL

        ; MOV BL, InitialPointsP1
        


    Finish:
    RET
ExchangeInfo ENDP	

SendMsg PROC  ; Sent string offset is saved in si, ended with '$'
    SendMessage:
        CALL SendData
        inc si
        mov dl, '$'
        cmp dl , byte ptr [si]-1
        jnz SendMessage

    RET
    SendMsg ENDP

    RecMsg PROC     ; Recieved string offset is saved in di
    RecieveMsg:
        CALL RecieveByte
        mov [di], bl
        inc di
        cmp bl, '$'
        jnz RecieveMsg

    RET
RecMsg ENDP

SendData PROC  ; data transferred is pointed to by si (8 bits)

    ;Check that Transmitter Holding Register is Empty
    mov dx , 3FDH		        ; Line Status Register
    AGAIN_SendData:
        In al, dx 			    ; Read Line Status
        test al, 00100000b
    JZ AGAIN_SendData                    ; Not empty

    ;If empty put the VALUE in Transmit data register
    mov dx, 3F8H		        ; Transmit data register
    mov al, [si]
    out dx, al

    ret
SendData ENDP

RecieveData PROC ; data is saved in BL

    ;Check that Data is Ready
    mov dx , 3FDH		; Line Status Register
    CHK_RecieveData:
        in al , dx 
        test al , 1
    JZ Return_RecieveData              ; Not Ready

    ; If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx 
    mov bl , al

    Return_RecieveData:
        ret
RecieveData ENDP



  MAINSCREEN PROC NEAR
   ;clearkeyboardbuffer
    CALL CONFIGURATION

    displaymainscreen:
    movecursor 09h, 10h
    print mes1      
    
    movecursor 0bh,10h
    print mes2
    
    movecursor 0dh,10h
    print mes3

    movecursor 15h,00h
    print mes5
    
    
    BACK_TO_MAIN_SCREEN:
    ; MOV SELECTION, 3D

    CALL RecieveInvitations
    CALL PrintInvitation

    MOV Exit_Chat , 0
    MOV firs_half , 0400h
    MOV sec_half , 0f00h
    MOV AH,1                                     ; GET KEY PRESSED WITHOUT WAITING 
    INT 16H
    JZ BACK_TO_MAIN_SCREEN                       ; JUMP TO MAIN SCREEN IF THERE IS NO KEY PRESSED 
    getkeypress									 ; CONSUME THE ENTERED KEY FROM THE KEYBOARD BUFFER
    CMP AH, Enterscancode                                 ; CHECK IF THE ENTERED KEY IS THE ENTER KEY 
    JE  NEXTSCREEN                               ; JUMP IF THE ENTERED KEY IS PRESSED


    check_f2:
    CMP AH, F2ScanCode
    JNE check_f1
    MOV SELECTION, 2 ; 2 FOR GAME
    JMP Accept_Invitation_Check
    check_f1:
    CMP AH, F1ScanCode
    JNE check_Esc
    MOV SELECTION, 1 ; 1 FOR CHAT
    JMP Accept_Invitation_Check
    check_Esc:
    CMP AH, Escscancode
    JE MAINSCREEN_END

    Accept_Invitation_Check:
    CALL CheckInvitationsAcception
    CMP AcceptChat, 1
    JZ GuestChat
    CMP AcceptGame, 1
    JZ GuestGame
    JMP BACK_TO_MAIN_SCREEN


    NEXTSCREEN:
    CMP GameInvite, 1 ;  IF THERE IS AN INVITATION AND USER WANT TO BECOME HOST
    JE BACK_TO_MAIN_SCREEN
    CMP ChatInvite, 1
    JE BACK_TO_MAIN_SCREEN

    CHECK_GAME:
    CMP SELECTION, 2    
    JNE CHECK_CHAT
    MOV HOST, 1
    CALL SendGameInvite
    CALL WaitGameAcception
    MOV CX, 100
    
    WasteTime:
    DEC CX
    JNZ WasteTime
    
    GuestGame:
    CALL ExchangeInfo
    CALL GAMESCREEN
    JMP displaymainscreen

    CHECK_CHAT:
    CMP SELECTION, 1
    JNE BACK_TO_MAIN_SCREEN
    MOV HOST, 1
    Call SendChatInvite 
    CALL WaitChatAcception
    
    GuestChat:
    CALL ExchangeInfo
    clearscreen
    CALL chatSCREEN
    JMP displaymainscreen

    MAINSCREEN_END:
    MOV AH,0                        ; NORMAL TERMINATION OF THE GAME 
    MOV AL,12H 
    INT 10H
    MOV BL,2
    exit
    RET
MAINSCREEN ENDP      
        
end main