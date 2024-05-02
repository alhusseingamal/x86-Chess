;   MACROS
MoveArr1Arr2 MACRO Arr1, Arr21
    local moveloop, arrays_Moved
    push BX 
    push AX
    MOV BX,0h
    MOV AH,64d
    MOV dummy1,AH
    moveloop:
    MOV AL, [Arr1+BX]
    MOV [Arr21+BX], AL
    inc BX
    dec dummy1
    CMP dummy1,0h
    JE arrays_Moved
    jmp moveloop
    arrays_Moved:
    pop AX
    pop BX
ENDM MoveArr1Arr2

getkeypress MACRO 
    MOV AH, 0
    int 16h
ENDM getkeypress

writeN1 MACRO writeout
    MOV AH, 02h        
    MOV DL, writeout
    add DL, 48d
    int 21h         
ENDM writeN1

GetSystemTime MACRO
    MOV AH, 2ch
    int 21h ; ;CH = hour CL = minute DH = second DL = 1/100 seconds
ENDM GetSystemTime

textmode MACRO
    MOV AH, 0
    MOV AL, 3h
    int 10h
ENDM textmode

graphicsmode MACRO
    MOV AH, 0
    MOV AL, 13h
    int 10h
ENDM graphicsmode

;Clear Keyboard Buffer
clearkeyboardbuffer MACRO
    MOV AX,0C00h ; or MOV AH, 08h
    INT 21h 
ENDM clearkeyboardbuffer

readchar MACRO readin
    MOV AH, 01
    int 21h    
    MOV readin, AL
ENDM readchar

movecursor MACRO row_parameter, col_parameter
    MOV AH, 2
    MOV DH, row_parameter
    MOV DL, col_parameter
    MOV BH, 0
    int 10h
ENDM movecursor

read MACRO buffername   ; read mybuffer
    MOV AH, 0ah 
    MOV DX, offset buffername
    int 21h
ENDM read

copystring MACRO source, target, size
    LOCAL label1
    MOV SI,0 
    MOV CH,0
    MOV CL,size
    label1:
    MOV AL,source[SI]
    MOV target[SI],AL
    inc SI
    loop label1
ENDM copystring


print MACRO text    ; print bufferdata
    MOV AH, 9h
    MOV DX, offset text        
    int 21h
ENDM print

clearscreen MACRO
    MOV AH,0
    MOV AL,3
    INT 10H
ENDM clearscreen

OpenFile MACRO Filehandle, Filename ; Open file
    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, Filename
    INT 21h
    
    ; you should check carry flag to make sure it worked correctly
    ; carry = 0 -> successful , file Handle -> AX
    ; carry = 1 -> failed , AX -> error code 
    MOV [Filehandle], AX
ENDM OpenFile

ReadData MACRO Filehandle, Width, Height, Data
    MOV AH,3Fh
    MOV BX, [Filehandle]
    MOV CX, Width* Height ; number of bytes to read
    LEA DX, Data
    INT 21h
ENDM ReadData 

CloseFile MACRO Filehandle
	MOV AH, 3Eh
	MOV BX, [Filehandle]
	INT 21h
ENDM CloseFile

exit MACRO
    MOV AH, 4ch
    int 21h
ENDM exit

;------------TIMER FUNCTIONS--------------
TurnTimetostring MACRO numbefore,StringVariable ;number before becoming string, stringvariable to save new string IN it
    local rem,end
    MOV AH,0
    MOV AL,numbefore   
    aam             
    MOV StringVariable+1 ,AL 
    add StringVariable+1,'0'         ;aam  AH=AL/10 remainder IN AL, value IN AH  
    MOV AL,AH 
    MOV AH,0                     
    aam  
    CMP AL,6h
    JGE rem 
    MOV StringVariable ,AL 
    add StringVariable,'0'
    jmp end  
    rem: 
    MOV StringVariable ,'0'    
    end:
ENDM TurnTimetostring

;BX has the offset of p1name
READNAME MACRO
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
ENDM READNAME

;-------DRAWING FUNCTIONS--------------
draw MACRO Width, Height, startingcolumn, color
    LOCAL drawLoop,drawnot
    MOV AH, 0CH
    drawLoop:
    MOV AL,[BX]
    CMP AL,color
    JE drawnot
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
ENDM draw ; check done

Drawsquare MACRO xnote,ynote,color
   local first, second, third, fourth
    
    MOV AH, 0ch
    MOV AL,color
    MOV CH, 0
    MOV CL,ynote
    MOV DH, 0
    MOV DL,xnote
    int 10h
    
   MOV BL,22d
   first:
   int 10h
   inc CX
   dec BL
   JNZ first 
   
    MOV BL,22d
    second:
    int 10h
    inc DX
    dec BL
    JNZ second
     
     
    MOV BL,22d
    third:
    int 10h
    dec CX
    dec BL
    JNZ third
   
    MOV BL,22d
    fourth:
    int 10h
    dec DX
    dec BL
    JNZ fourth
     
ENDM Drawsquare ; check done



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
ENDM draw__filled_square ; check done

draw_board MACRO
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
    MOV CX, scol
    MOV DX, srow
    ADD CX, 44d; X-direction
    CMP CX, 154D
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
    MOV CX, scol
    MOV DX, srow
    ADD CX, 44d; X-direction
    CMP CX, 154D
    JBE DRAW_HORIZONTAL2
    MOV CX, 22D
    ADD DX, 44D
    CMP DX, 154d
    JBE DRAW_HORIZONTAL2
ENDM draw_board ; check done

draw_piece MACRO piecename_par, piecerow_par, piececol_par
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
ENDM draw_piece ; check done

draw_piece2 MACRO piecename_par, piecerow_par, piececol_par
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
ENDM draw_piece2 ; check done

calculate_square MACRO row_parameter, col_parameter, calculated_square ; square = 8 * row + col
    MOV AH, 0
    MOV AL, col_parameter
    div twentytwo
    MOV calculated_square, AL
    
    MOV AH, 0
    MOV AL, row_parameter
    div twentytwo
    mul eight

    add calculated_square, AL
ENDM calculate_square ; check done

 ; takes row, col and using them gets the piece type on that square by accessing the memory location of that square
ConfigurePieceSelection MACRO row_parameter, col_parameter
    MOV BL, row_parameter
    MOV SelectedPieceRow, BL
    MOV BL, col_parameter
    MOV SelectedPieceCol, BL
    calculate_square SelectedPieceRow, SelectedPieceCol, SelectedPieceSquare
    GetSquarePieceCode SelectedPieceCode, SelectedPieceSquare
    
    ; CALL CheckPieceTimer
    ; CMP LOCKED, 1D
    ; JNE CHECKIFSQUAREWASEMPTY
    ; MOV SelectedPieceCode, 0D

    CHECKIFSQUAREWASEMPTY:
    ; Check that the selected square is not empty
    CMP SelectedPieceCode, 0 
    JE ConfigurePieceSelection_end
    MOV PieceInSelection, 1h
    ConfigurePieceSelection_end:
ENDM ConfigurePieceSelection ; difffference

configureDes MACRO row_parameter, col_parameter
    MOV BL, row_parameter
    MOV DesRow, BL
    MOV BL, col_parameter
    MOV DesCol, BL
    calculate_square DesRow, DesCol, DesSquare
    GetSquarePieceCode DesPieceCode, DesSquare
ENDM configureDes ; check done
;----------------------------------


getSquareColor MACRO squarecolor_parameter, squarenumber_parameter
    MOV BH, 0
    MOV BL, squarenumber_parameter
    MOV AL, [SquareColorArray+BX]
    MOV squarecolor_parameter, AL
ENDM getSquareColor

GetSquarePieceCode MACRO squarecode_parameter, squarenumber_parameter
    MOV BH, 0
    MOV BL, squarenumber_parameter
    MOV AL, [SquarePieceArray+BX]
    MOV squarecode_parameter, AL
ENDM GetSquarePieceCode


GetSquareNumberFromPieceCode MACRO piececode_parameter, squarenumber_parameter
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
ENDM GetSquareNumberFromPieceCode



UpdateSquare MACRO squarenumber_parameter, piececode_parameter ; UPDATES THE SQUAREPIECEARRAY WITH THE CODE OF THE NEW ADDED PIECE
    MOV BH, 0D
    MOV BL, squarenumber_parameter
    MOV AL, piececode_parameter
    MOV [SquarePieceArray + BX], AL
ENDM UpdateSquare

Redraw MACRO SelectedPieceCode, piecerow_par,piececol_par
    CMP SelectedPieceCode, 1d
    JE GetBTabya
    CMP SelectedPieceCode, 2d
    JE GetBhosan
    CMP SelectedPieceCode, 3d
    JE GetBfeel
    CMP SelectedPieceCode, 4d
    JE GetBqueen
    CMP SelectedPieceCode, 5d
    JE GetBking
    CMP SelectedPieceCode, 6d
    JE GetBgond
    CMP SelectedPieceCode, 7d
    JE GetWTabya
    CMP SelectedPieceCode, 8d
    JE GetWhosan
    CMP SelectedPieceCode, 9d
    JE GetWfeel
    CMP SelectedPieceCode, 10d
    JE GetWqueen
    CMP SelectedPieceCode, 11d
    JE GetWking
    CMP SelectedPieceCode, 12d
    JE GetWgond
    ; CMP SelectedPieceCode, 100d
    ; JNE Redrawend
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
ENDM Redraw






ResetVariables macro
MOV FL , 0
MOV SL , 0
MOV NotificationVar , 1D
MOV NextNotification , 0
MOV WhitegondiDeath , 0
MOV WhiteTabyaDeath , 0  
MOV WhitefeelDeath , 0
MOV WhiteKingDeath , 0
MOV WhiteQueenDeath , 0
MOV WhiteHosanDeath , 0   
MOV BlackgondiDeath , 0
MOV BlackTabyaDeath , 0
MOV BlackfeelDeath , 0
MOV BlackKingDeath , 0
MOV BlackQueenDeath , 0
MOV BlackHosanDeath , 0
;---TIMER VARIABLES---
MoveArr1Arr2 StartTimeArrayCopy,StartTimeArray
MoveArr1Arr2 StartTimeArrayCopy,timerArray
;MOV StartTimeArray , 64 DUP(0)
;MOV timerArray , 64 dup(0)
MOV CountDownTime , 35d
MOV LOCKED , 0d
MOV dummy1 , 0
MOV dummy2 , 0
MOV dummy3 , 0
MOV dummy4 , 0
MOV dummy5 , 0
MOV BKingPos , 4d ; initial position of the black king
MOV WkingPos , 60d ; initial position of the white king
MOV BKINGROW1 , 0D
MOV BKINGCOL1 , 88D
MOV wkingrow1 , 154D
MOV wkingcol1 , 88D
MOV WKingChecked , 0h
MOV BKingChecked , 0h
MOV THERE_IS_A_WINNER , 0h
MOV GAME_END , 0h
;--------------
MOV number_of_potential_cells , 0
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_col
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_row
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_squareNumber
;MOV potential_cells_row , 64 dup(0)
;MOV potential_cells_col , 64 dup(0)
;MOV potential_cells_squareNumber , 64 dup(0)
MOV to_test_row , 0
MOV to_test_col , 0
MOV to_test_squareNumber , 0
MOV to_test_square_piececode , 0
MOV IsSameColor , 0
;----Moving a piece-----
MOV PieceInSelection , 0
MOV selectedSquareColor , 0h
MOV selectedPieceSquare , 0
MOV SelectedPieceRow , 0
MOV SelectedPieceCol , 0
MOV SelectedPieceCode , 0 ; initially no piece is selected 
MOV DesRow , 0
MOV DesCol , 0
MOV DesSquare , 0
MOV DesColor , 0
MOV DesPieceCode , 0
;------------player1 Plays---------
MOV number_of_potential_cellsp1 , 0
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_rowp1
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_colp1
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_squareNumberp1
;MOV potential_cells_rowp1 , 64 dup(0)
;MOV potential_cells_colp1 , 64 dup(0)
;MOV potential_cells_squareNumberp1 , 64 dup(0)
MOV PieceInSelectionp1 , 0
MOV selectedSquareColorp1 , 0h
MOV selectedPieceSquarep1 , 0
MOV SelectedPieceRowp1 , 0
MOV SelectedPieceColp1 , 0
MOV SelectedPieceCodep1 , 0 ; initially no piece is selected 
MOV DesRowp1 , 0
MOV DesColp1 , 0
MOV DesSquarep1 , 0
MOV DesColorp1 , 0
MOV DesPieceCodep1 , 0
;-------------PLAYER 2 PLAYS--------------
MOV number_of_potential_cellsp2 , 0
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_colp2
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_squareNumberp2
MoveArr1Arr2 StartTimeArrayCopy,potential_cells_rowp2
;MOV potential_cells_rowp2 , 64 dup(0)
;MOV potential_cells_colp2 , 64 dup(0)
;MOV potential_cells_squareNumberp2 , 64 dup(0)
MOV PieceInSelectionp2 , 0
MOV selectedSquareColorp2 , 0h
MOV selectedPieceSquarep2 , 0
MOV SelectedPieceRowp2 , 0
MOV SelectedPieceColp2 , 0
MOV SelectedPieceCodep2 , 0 ; initially no piece is selected 
MOV DesRowp2 , 0
MOV DesColp2 , 0
MOV DesSquarep2 , 0
MOV DesColorp2 , 0
MOV DesPieceCodep2 , 0
 ;---------------------
MOV isValidMove , 1H
MOV IsOccupiedFlag , 0
MOV IsSameColorFlag , 0
MOV Isfirstgame , 1 
 ;------------General Variables-------
MOV cell_color , 0
MOV cell_number , 0

 ;----Movements------
MOV selected_frame_row , 0 ; y
MOV selected_frame_col , 0 ; x
MOV selected_frame_square , 0; initially at upper left 
MOV selected_frame_color , 0h 
 ;--------------------
MOV selected_frame_row1 , 0D ; y
MOV selected_frame_col1 , 0d ; x
MOV selected_frame_square1 , 0d; initially at upper left 
MOV selected_frame_color1 , 0h 
 ;---------------
MOV selected_frame_row2 , 154D ; y
MOV selected_frame_col2 , 154d ; x
MOV selected_frame_square2 , 63d; initially at lower right
MOV selected_frame_color2 , 0h 
 
 ;---------game timer variables-------
MOV aux_time , 0
;MOV secondsstr , 2,?,'$'
;MOV noerror3 , 1,?,'$'
;MOV minutesstr , 2,?,'$'
;MOV noerror2 , 1,?,'$'
;MOV hoursstr , 2,?,'$'  
;MOV noerror , 1,0,'$'
MOV seconds , 0
MOV minutes , 0
MOV hours   , 0 
MOV delay , 1 
MOV inctime , 0  

 ;---king INFO-----------
MOV bkingrow , 0088d
MOV bkingcol , 00H
 ;---queen INFO-----------
MOV bqueenrow , 66d
MOV bqueencol , 00h
;---tabia INFO-----------
MOV btabiarow , 00h
MOV btabiacol , 00h
MOV btabia2row , 154d
MOV btabia2col , 00h
;---hosan INFO-----------
MOV bhosanrow , 22d
MOV bhosancol , 00h
MOV bhosan2row , 132d
MOV bhosan2col , 00h
;---feel INFO-----------
MOV bfeelrow , 44d
MOV bfeelcol ,  00h
MOV bfeel2row , 110d
MOV bfeel2col , 00h
;---solider INFO-----------
MOV bsoliderrow , 0d
MOV bsolidercol ,  22D
MOV bsolider2row , 22D
MOV bsolider2col , 22d
MOV bsolider3row , 44D
MOV bsolider3col , 22d
MOV bsolider4row , 66d
MOV bsolider4col , 22d
MOV bsolider5row , 88d
MOV bsolider5col , 22d
MOV bsolider6row , 110d
MOV bsolider6col , 22d
MOV bsolider7row , 132d
MOV bsolider7col , 22d
MOV bsolider8row , 154d
MOV bsolider8col , 22d
;---solider2 INFO-----------
MOV wsoliderrow , 0000H
MOV wsolidercol ,  132d
MOV wsolider2row , 22d
MOV wsolider2col ,  132d
MOV wsolider3row , 44D
MOV wsolider3col ,  132d
MOV wsolider4row , 66d
MOV wsolider4col ,  132d
MOV wsolider5row , 88d
MOV wsolider5col ,  132d
MOV wsolider6row , 110d
MOV wsolider6col ,  132d
MOV wsolider7row , 132d
MOV wsolider7col ,  132d
MOV wsolider8row , 154d
MOV wsolider8col ,  132d
;---hosan2 INFO-----------
MOV whosanrow , 22d
MOV whosancol , 154d
MOV whosan2row , 132d
MOV whosan2col , 154d
;---tabia INFO-----------
MOV wtabiarow , 00H
MOV wtabiacol , 154d
MOV wtabia2row , 154d
MOV wtabia2col , 154d
;---feel2 INFO-----------
MOV wfeelrow , 44d
MOV wfeelcol , 154d
MOV wfeel2row , 110d
MOV wfeel2col , 154d
;---king2 INFO-----------
MOV wkingrow , 66d
MOV wkingcol , 154d
;---queen2 INFO-----------
MOV wqueenrow , 88d
MOV wqueencol , 154d
;----GENERAL VARIABLES AND DATA------
MOV HorizontalDimension , 0
MOV VerticalDimension , 0
MOV SCOL , 0 ; starting column
MOV SROW , 0

MOV checkname , 0
MOV checkname1 , 0
;-----------------
MOV key , ?
MOV NotificationBarMessage , 0

;-------Sending AND Receiveing----------------
MOV CharacterSent , (?)
MOV Characterreceived , 0FFh
; ---------- Connection Variables ----- ;
MOV gameinvite , 0
MOV chatinvite , 0
MOV Acceptgame , 0
MOV Acceptchat , 0
MOV HOST , 0
;-----------------------------
;MOV mybuffer label byte
MOV buffersize , 16 
MOV actualsize , ?
MoveArr1Arr2 StartTimeArrayCopy,bufferdataCopy
;MOV bufferdata , 16 dup('$')
MoveArr1Arr2 SquarePieceArrayCopy,SquarePieceArray
endm ResetVariables ; check done