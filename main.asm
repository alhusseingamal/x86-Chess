include Macros.inc
.286
.model small
.stack 64
.data
;================= serial comm variables ============
firs_half   dw 0400h
sec_half    dw 0f00h
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

;==================== Game Variables ====================================
Who_Plays DB 0D ; 0 FOR BLACK, 1 FOR WHITE
FL DB 0
SL DB 0
NotificationVar DB 1D
NextNotification dw 0
BKill DB 0           
WKill DB 0
WhiteKill DB 'White Killed = $'
BlackKill DB 'Black Killed = $'
Wkkill DB 2,?,'$'
Bkkill DB 2,?,'$'
WhitePlayerWonMessage DB 'WhitePlayer Won = $'
BlackPlayerWonMessage DB 'BlackPlayer Won = $'
WhitegondiDeath DB 0
WhiteTabyaDeath DB 0  
WhitefeelDeath DB 0
WhiteKingDeath DB 0
WhiteQueenDeath DB 0
WhiteHosanDeath DB 0   
BlackgondiDeath DB 0
BlackTabyaDeath DB 1
BlackfeelDeath DB 0
BlackKingDeath DB 0
BlackQueenDeath DB 0
BlackHosanDeath DB 0
;---TIMER VARIABLES---
StartTimeArray DB 64 DUP(0)
timerArray DB 64 dup(0)
CountDownTime DB 19d
LOCKED DB 0d
;----------
dummy1 DB 0
dummy2 DB 0
dummy3 DB 0
dummy4 DB 0
dummy5 DB 0

SquareRowArray db 0,0,0,0,0,0,0,0
               db 1,1,1,1,1,1,1,1
               db 2,2,2,2,2,2,2,2
               db 3,3,3,3,3,3,3,3
               db 4,4,4,4,4,4,4,4
               db 5,5,5,5,5,5,5,5
               db 6,6,6,6,6,6,6,6
               db 7,7,7,7,7,7,7,7

SquareColumnArray db 0,1,2,3,4,5,6,7
                  db 0,1,2,3,4,5,6,7
                  db 0,1,2,3,4,5,6,7
                  db 0,1,2,3,4,5,6,7
                  db 0,1,2,3,4,5,6,7
                  db 0,1,2,3,4,5,6,7
                  db 0,1,2,3,4,5,6,7
                  db 0,1,2,3,4,5,6,7

SquareColorArray DB  0fh, 00h, 0fh, 00h, 0fh, 00h, 0fh, 00h
                 db  00h, 0fh, 00h, 0fh, 00h, 0fh, 00h, 0fh
                 db  0fh, 00h, 0fh, 00h, 0fh, 00h, 0fh, 00h
                 db  00h, 0fh, 00h, 0fh, 00h, 0fh, 00h, 0fh
                 db  0fh, 00h, 0fh, 00h, 0fh, 00h, 0fh, 00h
                 db  00h, 0fh, 00h, 0fh, 00h, 0fh, 00h, 0fh
                 db  0fh, 00h, 0fh, 00h, 0fh, 00h, 0fh, 00h
                 db  00h, 0fh, 00h, 0fh, 00h, 0fh, 00h, 0fh

SquarePieceArray DB   1,2,3,4,5,3,2,1
                  db  6,6,6,6,6,6,6,6
                  db  0,0,0,0,0,0,0,0
                  db  0,0,0,0,0,0,0,0
                  db  0,0,0,0,0,0,0,0
                  db  12d,12d,12d,12d,12d,12d,12d,12d
                  db  7,8,9,10d,11d,9,8,7

SquarePieceArrayCopy DB 1,2,3,4,5,3,2,1
                     db 6,6,6,6,6,6,6,6
                     db 0,0,0,0,0,0,0,0
                     db 0,0,0,0,0,0,0,0
                     db 0,0,0,0,0,0,0,0
                     db 0,0,0,0,0,0,0,0
                     db 12d,12d,12d,12d,12d,12d,12d,12d
                     db 7,8,9,10d,11d,9,8,7

BKingPos DB 4d ; initial position of the black king
WkingPos DB 60d ; initial position of the white king
BKINGROW1 DB 0D
BKINGCOL1 DB 88D
wkingrow1 DB 154D
wkingcol1 DB 88D
WKingChecked DB 0h
BKingChecked DB 0h
THERE_IS_A_WINNER DB 0h
GAME_END DB 0h
;--------------
number_of_potential_cells DB 0
potential_cells_row DB 64 dup(0)
potential_cells_col DB 64 dup(0)
potential_cells_squareNumber DB 64 dup(0)
to_test_row DB 0
to_test_col DB 0
to_test_squareNumber DB 0
to_test_square_piececode DB 0
IsSameColor DB 0
;----Moving a piece-----
PieceInSelection DB 0
selectedSquareColor DB 0h
selectedPieceSquare DB 0
SelectedPieceRow DB 0
SelectedPieceCol DB 0
SelectedPieceCode DB 0 ; initially no piece is selected 
DesRow DB 0
DesCol DB 0
DesSquare DB 0
DesColor DB 0
DesPieceCode DB 0
;------------player1 Plays---------
number_of_potential_cellsp1 DB 0
potential_cells_rowp1 DB 64 dup(0)
potential_cells_colp1 DB 64 dup(0)
potential_cells_squareNumberp1 DB 64 dup(0)
PieceInSelectionp1 DB 0
selectedSquareColorp1 DB 0h
selectedPieceSquarep1 DB 0
SelectedPieceRowp1 DB 0
SelectedPieceColp1 DB 0
SelectedPieceCodep1 DB 0 ; initially no piece is selected 
DesRowp1 DB 0
DesColp1 DB 0
DesSquarep1 DB 0
DesColorp1 DB 0
DesPieceCodep1 DB 0
;-------------PLAYER 2 PLAYS--------------
number_of_potential_cellsp2 DB 0
potential_cells_rowp2 DB 64 dup(0)
potential_cells_colp2 DB 64 dup(0)
potential_cells_squareNumberp2 DB 64 dup(0)
PieceInSelectionp2 DB 0
selectedSquareColorp2 DB 0h
selectedPieceSquarep2 DB 0
SelectedPieceRowp2 DB 0
SelectedPieceColp2 DB 0
SelectedPieceCodep2 DB 0 ; initially no piece is selected 
DesRowp2 DB 0
DesColp2 DB 0
DesSquarep2 DB 0
DesColorp2 DB 0
DesPieceCodep2 DB 0
;---------------------
isValidMove DB 1H
IsOccupiedFlag DB 0
IsSameColorFlag DB 0
Isfirstgame DB 1 
;------------General Variables-------
twentytwo DB 22d
eight DB 8d
zero DB 0d
ten DB 10d
four DB 4d
cell_color DB 0
cell_number DB 0
;-----colors---------
black_color DB 0h
red_color DB 04h
white_color DB 0fh
cyan_color DB 1h
green_color DB 2h
;----Movements------
distance EQU 22d
selected_frame_row DB 0 ; y
selected_frame_col DB 0 ; x
selected_frame_square DB 0; initially at upper left 
selected_frame_color DB 0h 
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
aux_time DB 0
secondsstr DB 2,?,'$'
noerror3 DB 1,?,'$'
minutesstr DB 2,?,'$'
noerror2 DB 1,?,'$'
hoursstr DB 2,?,'$'  
noerror DB 1,0,'$'
seconds DB 0
minutes DB 0
hours   DB 0 
delay DB 1 
inctime DB 0  
;---------Square INFO------
squaredimension equ 21d
pieceDimension equ 22d
PieceHandle DW ?
PieceData DB pieceDimension*pieceDimension dup(0)

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
F4scancode equ 3Eh 
F2scancode equ 3Ch
;-------------CHAT MODULE VARIABLES-----------------
playername DB 'player 1 : $'
checkname DB 0
checkname1 DB 0
;-----------------
key DB ?
enternamemes DB 'Please, Enter your name:$'
presstocontinuemes DB 'Press Enter key to continue$'
mes1 DB 'To start chatting press F4$'
mes2 DB 'To start the game press F2$'
mes3 DB 'To end the program press ESC$'
mes5 DB 50h dup('-'), '$'
mes6 DB 'Here starts the game$'
EMPTYMESSAGE DB '                                '
NotificationBarMessage DW 0
BlackKingIsCheckedMessaage DB 'Black King is Checked$'
WhiteKingIsCheckedMessaage DB 'White King is Checked$'
;-------------invitation messages------------
chatinvitemes DB 10, 'You have recieved a chat invitation, to accept it press F4 key!$'
gameinvitemes DB 10, 'You have recieved a game invitation, to accept it press F2 key!$'
message DB 10, 13, 'welcome', 10, 13, 'bitch$'
;------------- players data------------------
p1namedata label byte
p1namemaxsize DB 16
p1nameactualsize DB 0
p1name DB 16 dup('$')
p2namedata label byte
p2namemaxsize DB 16
p2nameactualsize DB 0
p2name DB 16 dup('$')
;-------Sending and Receiveing----------------
CharacterSent DB ?
Characterreceived DB 0FFh
; ---------- Connection Variables ----- ;
gameinvite DB 0
chatinvite DB 0
Acceptgame DB 0
Acceptchat DB 0
HOST DB 0
;-----------------------------
mybuffer label byte
buffersize DB 16 
actualsize DB ?
bufferdata DB 16 dup('$')
bufferdataCopy db 16 dup('$')
;-----------------------
.code
.386
MAIN PROC FAR
    ;----PREPARE MEMORY---------
    MOV AX, @DATA
    MOV DS, AX
    ; MOV ES, AX
    ;---------------------------
    clearscreen
    CALL NAMESCREEN
    CALL MAINSCREEN
    RET
MAIN ENDP

PRINTMESSAGE  PROC  NEAR
    ; DX HOLDS THE OFFSET OF THE MESSAGE 
    MOV AH,9
    MOV AL,0
    INT 21H
    RET
PRINTMESSAGE  ENDP ; check done

ShowNotifications PROC NEAR
     CMP FL,0           
     JE FirstMessage
     CMP SL,0          
     JE FirstSecondMessage

     SecondMessage:
     movecursor 23,1
     MOV DX , NotificationBarMessage
     CALL PRINTMESSAGE            ;hena ba shafett
     movecursor 24, 1
     MOV DX , NextNotification
     MOV NotificationBarMessage , DX
     MOV DX, NotificationBarMessage
     CALL PRINTMESSAGE
     JMP ShowNotifications_RET

     FirstSecondMessage :
     movecursor 24, 1
     MOV DX , NextNotification
     MOV NotificationBarMessage , DX
     MOV DX, NotificationBarMessage
     CALL PRINTMESSAGE
     MOV SL,1
     JMP ShowNotifications_RET

    FirstMessage:
    movecursor 23, 1
    MOV DX , NextNotification
     MOV NotificationBarMessage , DX
     MOV DX, NotificationBarMessage
    CALL PRINTMESSAGE
    MOV FL,1
    ShowNotifications_RET:
    RET
ShowNotifications ENDP

CheckGameEnd PROC NEAR
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
        MOV NextNotification, offset WhitePlayerWonMessage
        CALL ShowNotifications
        JMP CheckGameEnd_ret
    BlackWon:
        MOV GAME_END, 1H
        MOV NextNotification, offset BlackPlayerWonMessage
        CALL ShowNotifications
        JMP CheckGameEnd_ret
    CheckGameEnd_ret:
        RET
CheckGameEnd ENDP ; check done





    
executekeypress PROC NEAR ; getkeypress function is called right before this function is called
    CMP AH, Dscancode
    JZ moveright

    CMP AH, Ascancode
    JZ moveleft

    CMP AH, Wscancode
    JZ moveup

    CMP AH, Sscancode
    JZ movedown

    CMP AH, Qscancode
    JZ QClick

    
    ; CMP AH, UpArrowScanCode
    ; JZ moveup2
    ; CMP AH, DownArrowScanCode
    ; JZ movedown2
    ; CMP AH, RightArrowScanCode
    ; JZ moveright2
    ; CMP AH, LeftArrowScanCode
    ; JZ moveleft2
    ; CMP AH, Enterscancode
    ; ; JZ 

    
    JNZ executekeypress_ret
    ;-------------------------------------
    QClick:
    MOV Who_Plays, 0D
    CMP PieceInSelection, 1
    JE ThereIsASelectedPiece

    ThereIsNoSelectedPiece:
    ConfigurePieceSelection selected_frame_row, selected_frame_col
    CMP SelectedPieceCode, 0d
    JE Qclickend 
    ; if square is not occupied, Qclick has no effect and end

    ; ELSE SELECT ALL PIECE MOVES AND HIGHLIGHT THEM
    CALL SelectPieceMoves
    CALL Highlight  
    jmp Qclickend
    
    ; if Click is on the same square as the selected piece square, we deselect the piece
    ThereIsASelectedPiece:
    configureDes selected_frame_row, selected_frame_col
    MOV BL, SelectedPieceSquare
    CMP BL, DesSquare
    JNE QClickIsNotInSamePlace

    ; If click is IN the same place, de-select; that involves dehighlighting the potential squares among other stuff
    QClickIsInTheSamePlace:
    CALL Dehighlight
    JMP QclickCleanUp

    QClickIsNotInSamePlace:
    CALL ValidateMove ; move is to one of the possible cells for the piece
    CALL Dehighlight
    CMP isValidMove, 1 ; check that move is still valid
    JNE QclickCleanUp
    CALL movepiece
    ; CALL KingInCheck
    
    ; MoveisNotValid:
    
    QclickCleanUp:  
    Drawsquare selected_frame_row, selected_frame_col, red_color ; draw the moving frame around the current position
    MOV PieceInSelection, 0h
    MOV isValidMove, 1h
    MOV number_of_potential_cells, 0 
    MOV selectedPieceCode, 0
    MOV BKingChecked, 0
    MOV WKingChecked, 0
    jmp Qclickend

    Qclickend:
    jmp executekeypress_ret
    ;---------------------------------------

    moveright:
    CMP selected_frame_col, 154d
    jae executekeypress_ret
    calculate_square selected_frame_row, selected_frame_col, selected_frame_square
    getSquareColor selected_frame_color, selected_frame_square
    Drawsquare selected_frame_row, selected_frame_col, selected_frame_color
    ; CALL RedrawPotentialSquare
    add selected_frame_col, distance
    movecursor selected_frame_row, selected_frame_col, 0
    Drawsquare selected_frame_row, selected_frame_col, red_color
    jmp executekeypress_ret
    
    moveleft:
    CMP selected_frame_col, 0d
    jbe executekeypress_ret
    calculate_square selected_frame_row, selected_frame_col, selected_frame_square
    getSquareColor selected_frame_color, selected_frame_square
    Drawsquare selected_frame_row, selected_frame_col, selected_frame_color
    ; CALL RedrawPotentialSquare
    sub selected_frame_col, distance
    movecursor selected_frame_row, selected_frame_col, 0
    Drawsquare selected_frame_row, selected_frame_col, red_color
    jmp executekeypress_ret
    
    
    moveup:
    CMP selected_frame_row, 0d
    jbe executekeypress_ret
    calculate_square selected_frame_row, selected_frame_col, selected_frame_square
    getSquareColor selected_frame_color, selected_frame_square
    Drawsquare selected_frame_row, selected_frame_col, selected_frame_color
    ; CALL RedrawPotentialSquare
    sub selected_frame_row, distance
    movecursor selected_frame_row, selected_frame_col, 0
    Drawsquare selected_frame_row, selected_frame_col, red_color
    jmp executekeypress_ret
    
    
    movedown:
    CMP selected_frame_row, 154d
    jae executekeypress_ret
    calculate_square selected_frame_row, selected_frame_col, selected_frame_square
    getSquareColor selected_frame_color, selected_frame_square
    Drawsquare selected_frame_row, selected_frame_col, selected_frame_color
    ; CALL RedrawPotentialSquare
    add selected_frame_row, distance
    movecursor selected_frame_row, selected_frame_col, 0
    Drawsquare selected_frame_row, selected_frame_col, red_color
    jmp executekeypress_ret 
    
    executekeypress_ret:
    RET
executekeypress ENDP   




setplayer proc near
CMP Who_Plays, 0D
JNE Player2Plays

Player1Plays:
MoveArr1Arr2 potential_cells_rowp1, potential_cells_row
MoveArr1Arr2 potential_cells_colp1, potential_cells_col
MoveArr1Arr2 potential_cells_squareNumberp1, potential_cells_squareNumber
MOV AL,number_of_potential_cellsp1
MOV number_of_potential_cells, AL
MOV AL, PieceInSelectionp1
MOV PieceInSelection, AL
MOV AL,selectedSquareColorp1
MOV selectedSquareColor, AL
MOV AL,selectedPieceSquarep1
MOV selectedPieceSquare, AL
MOV AL,SelectedPieceRowp1
MOV SelectedPieceRow, AL
MOV AL,SelectedPieceColp1
MOV selectedpiececol, AL
MOV AL,SelectedPieceCodep1
MOV selectedpiececode, AL 
MOV AL,DesRowp1
MOV DesRow, AL
MOV AL,DesColp1
MOV DesCol, AL
MOV AL,DesSquarep1
MOV DesSquare, AL
MOV AL,DesColorp1
MOV DesColor, AL
MOV AL,DesPieceCodep1
MOV DesPieceCode, AL
MOV AL, selected_frame_row1
MOV selected_frame_row, AL
MOV AL, selected_frame_col1
MOV selected_frame_col, AL
MOV AL, selected_frame_square1
MOV selected_frame_square, AL
MOV AL, selected_frame_color1
MOV selected_frame_color, AL

RET

Player2Plays:
MoveArr1Arr2 potential_cells_rowp2, potential_cells_row
MoveArr1Arr2 potential_cells_colp2, potential_cells_col
MoveArr1Arr2 potential_cells_squareNumberp2, potential_cells_squareNumber
MOV AH,number_of_potential_cellsp2
MOV number_of_potential_cells, AH
MOV AH, PieceInSelectionp2
MOV PieceInSelection, AH
MOV AH,selectedSquareColorp2
MOV selectedSquareColor, AH
MOV AH,selectedPieceSquarep2
MOV selectedPieceSquare, AH
MOV AH,SelectedPieceRowp2
MOV SelectedPieceRow, AH
MOV AH,SelectedPieceColp2
MOV selectedpiececol, AH
MOV AH,SelectedPieceCodep2
MOV selectedpiececode, AH
MOV AH,DesRowp2
MOV DesRow, AH
MOV AH,DesColp2
MOV DesCol, AH
MOV AH,DesSquarep2
MOV DesSquare, AH
MOV AH,DesColorp2
MOV DesColor, AH
MOV AH,DesPieceCodep2
MOV DesPieceCode, AH
MOV AL, selected_frame_row2
MOV selected_frame_row, AL
MOV AL, selected_frame_col2
MOV selected_frame_col, AL
MOV AL, selected_frame_square2
MOV selected_frame_square, AL
MOV AL, selected_frame_color2
MOV selected_frame_color, AL

RET

setplayer endp

De_set_Player proc near
CMP Who_Plays, 0D
JNE Player2DePlays

Player1DePlays:
MoveArr1Arr2 potential_cells_row, potential_cells_rowp1
MoveArr1Arr2 potential_cells_col, potential_cells_colp1
MoveArr1Arr2 potential_cells_squareNumber, potential_cells_squareNumberp1
MOV AL,number_of_potential_cells
MOV number_of_potential_cellsp1, AL
MOV AL, PieceInSelection
MOV PieceInSelectionp1, AL
MOV AL,selectedSquareColor
MOV selectedSquareColorp1, AL
MOV AL,selectedPieceSquare
MOV selectedPieceSquarep1, AL
MOV AL,SelectedPieceRow
MOV SelectedPieceRowp1, AL
MOV AL,SelectedPieceCol
MOV selectedpiececolp1, AL
MOV AL,SelectedPieceCode
MOV selectedpiececodep1, AL 
MOV AL,DesRow
MOV DesRowp1, AL
MOV AL,DesCol
MOV DesColp1, AL
MOV AL,DesSquare
MOV DesSquarep1, AL
MOV AL,DesColor ;; Retrieve all the needed data
MOV DesColorp1, AL
MOV AL,DesPieceCode
MOV DesPieceCodep1, AL
MOV AL, selected_frame_row
MOV selected_frame_row1, AL
MOV AL, selected_frame_col
MOV selected_frame_col1, AL
MOV AL, selected_frame_square
MOV selected_frame_square1, AL
MOV AL, selected_frame_color
MOV selected_frame_color1, AL
RET

Player2DePlays: ; De select player 2
MoveArr1Arr2 potential_cells_row, potential_cells_rowp2
MoveArr1Arr2 potential_cells_col, potential_cells_colp2
MoveArr1Arr2 potential_cells_squareNumber, potential_cells_squareNumberp2
MOV AH,number_of_potential_cells
MOV number_of_potential_cellsp2, AH
MOV AH, PieceInSelection
MOV PieceInSelectionp2, AH
MOV AH,selectedSquareColor
MOV selectedSquareColorp2, AH ; Retrieve all the needed data
MOV AH,selectedPieceSquare
MOV selectedPieceSquarep2, AH
MOV AH,SelectedPieceRow
MOV SelectedPieceRowp2, AH
MOV AH,SelectedPieceCol
MOV selectedpiececolp2, AH
MOV AH,SelectedPieceCode
MOV selectedpiececodep2, AH
MOV AH,DesRow
MOV DesRowp2, AH
MOV AH,DesCol
MOV DesColp2, AH
MOV AH,DesSquare
MOV DesSquarep2, AH
MOV AH,DesColor
MOV DesColorp2, AH
MOV AH,DesPieceCode
MOV DesPieceCodep2, AH
MOV AL, selected_frame_row
MOV selected_frame_row2, AL
MOV AL, selected_frame_col
MOV selected_frame_col2, AL
MOV AL, selected_frame_square
MOV selected_frame_square2, AL
MOV AL, selected_frame_color
MOV selected_frame_color2, AL


RET

De_set_Player endp

CheckPieceTimer PROC NEAR
    MOV LOCKED, 0D
    MOV BH, 0D
    MOV BL, SelectedPieceSquare
    CMP [timerArray + BX], 0D
    JE PieceIsFreeToMove
    PieceIsNotFreeToMove:
    MOV LOCKED, 1D
    PieceIsFreeToMove:
    CheckPieceTimer_RET:
    RET
CheckPieceTimer ENDP

GetKingMoves PROC NEAR
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ;-----------------------------------------
    OneRight:
    add to_test_Col, distance 
    CMP to_test_Col, 154d
    JA OneRightEnd
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneRightEnd
    CALL HelperFunction1
    
    OneRightEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ;-----------------------------------------
    OneLeft:
    CMP to_test_Col, 0D
    JE OneLeftEnd
    sub to_test_Col, distance 
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneLeftEnd
    CALL HelperFunction1

    OneLeftEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ;-----------------------------------------
    OneDown:
    add to_test_Row, distance 
    CMP to_test_Row, 154d
    JA OneDownEnd
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneDownEnd
    CALL HelperFunction1
    
    OneDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ;-----------------------------------------
    OneUp:
    CMP to_test_Row, 0D
    JE OneUpEnd
    sub to_test_Row, distance 
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneUpEnd
    CALL HelperFunction1

    OneUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ;-----------------------------------------
    OneRightOneUp:
    add to_test_Col, distance 
    CMP to_test_Col, 154d
    JA OneRightOneUpEnd
    CMP to_test_Row, 0D
    JE OneRightOneUpEnd
    sub to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneRightOneUpEnd
    CALL HelperFunction1
    
    OneRightOneUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    
    ;-----------------------------------------
    OneRightOneDown:
    add to_test_Col, distance
    CMP to_test_Col, 154d
    JA OneRightOneDownEnd
    CMP to_test_Row, 154d
    JE OneRightOneDownEnd
    add to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneRightOneDownEnd
    CALL HelperFunction1
    
    OneRightOneDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    
    ;-----------------------------------------
    OneLeftOneUp:
    CMP to_test_Col, 0D
    JE OneLeftOneUpEnd
    sub to_test_Col, distance
    CMP to_test_Row, 0D
    JE OneLeftOneUpEnd
    sub to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneLeftOneUpEnd
    CALL HelperFunction1
    
    OneLeftOneUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ;-----------------------------------------
    OneLeftOneDown:
    CMP to_test_Col, 0D
    JE OneLeftOneDownEnd
    sub to_test_Col, distance
    CMP to_test_Row, 154d
    JE OneLeftOneDownEnd
    add to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneLeftOneDownEnd
    CALL HelperFunction1

    OneLeftOneDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    ;-----------------------------------------
    RET
GetKingMoves ENDP


GetBgondMoves PROC NEAR
MOV BL, SelectedPieceRow
MOV BH, SelectedPieceCol
CMP BL,154d
JE narymove
add BL,22d
MOV to_test_row,BL
MOV to_test_col,BH
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
CMP to_test_square_piececode,0D
JNE checkfirsteat
CALL HelperFunction1
checkfirsteat:
MOV BL, SelectedPieceRow
MOV BH, SelectedPieceCol
CMP BH,154d
JE secondeatcheck
add BL,22d
add BH,22d
MOV to_test_row,BL
MOV to_test_col,BH
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
CMP to_test_square_piececode,6d
jbe secondeatcheck
CALL HelperFunction1
secondeatcheck:
MOV BL, SelectedPieceRow
MOV BH, SelectedPieceCol
CMP BH,0d
JE narymove
add BL,22d
sub BH,22d
MOV to_test_row,BL
MOV to_test_col,BH
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
CMP to_test_square_piececode,6d
jbe narymove
CALL HelperFunction1
narymove:
RET
GetBgondMoves ENDP

GetWgondMoves PROC NEAR
MOV BL, SelectedPieceRow
MOV BH, SelectedPieceCol
CMP BL,0d
JE narymove2
sub BL,22d
MOV to_test_row,BL
MOV to_test_col,BH
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
CMP to_test_square_piececode,0D
JNE checkfirsteat1
CALL HelperFunction1
checkfirsteat1:
MOV BL, SelectedPieceRow
MOV BH, SelectedPieceCol
CMP BH,154d
JE secondeatcheck1
sub BL,22d
add BH,22d
MOV to_test_row,BL
MOV to_test_col,BH
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
CMP to_test_square_piececode,6d 
ja secondeatcheck1
CMP to_test_square_piececode,0D
JE secondeatcheck1
CALL HelperFunction1
secondeatcheck1:
MOV BL, SelectedPieceRow
MOV BH, SelectedPieceCol
CMP BH,0d
JE narymove2
sub BL,22d
sub BH,22d
MOV to_test_row,BL
MOV to_test_col,BH
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
CMP to_test_square_piececode,6d 
ja narymove2
CMP to_test_square_piececode,0D
JE narymove2
CALL HelperFunction1
narymove2:
RET
GetWgondMoves ENDP


GetTabyaMoves PROC NEAR
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    ; PrepareAbove exists for the reason that if the selected piece column is already 0 and we subtract from it, then this will give a negative
    ; number, so it is better to avoid that IN the comparison
    ; The same for PrepareLeft but for the row

    PrepareAbove:
    CMP to_test_row, 0 ; if selected piece is at column 0, then there's nothing to the left to check
    JE CheckAboveEnd
    
    CheckAbove:
    sub to_test_row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d; DE 3OMRHA MA HTKON 1 ELA LW ASASN OCCUPIED
    JE CheckAboveEnd    ; IF PIECE HAS SAME COLOR THEN END, LW MSH SAME COLOR F L CELL DE M3ANA
    CALL HelperFunction1 ; KEDA KEDA 7TA LW MSH OCCUPIED F HYA M3ANA
    CMP IsOccupiedFlag, 1d ; LKN LW OCCUPIED F DE A5ER CELL M3ANA W H N END
    JE CheckAboveEnd
    CMP to_test_row, 0D
    JNE CheckAbove

    CheckAboveEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    
    CheckBelow:
    add to_test_row, distance
    CMP to_test_row, 154d
    JA CheckBelowEnd
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE CheckBelowEnd    
    CALL HelperFunction1 
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
    CMP to_test_col, 154d
    JA CheckRightEnd
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1H 
    JE CheckRightEnd    
    CALL HelperFunction1 
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
    JE CheckLeftEnd
    
    CheckLeft:
    sub to_test_col, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1H 
    JE CheckLeftEnd    
    CALL HelperFunction1 
    CMP IsOccupiedFlag, 1h
    JE CheckLeftEnd
    CMP to_test_col, 0D
    JNE CHECKLEFT
    CheckLeftEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    RET
GetTabyaMoves ENDP

GetHosanMoves PROC NEAR ; the knight can move to a max of eight different cells on the board
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    
    TwoRightOneUp:
    add to_test_Col, distance * 2
    CMP to_test_Col, 154d
    JA TwoRightOneUpEnd
    CMP to_test_Row, 0D
    JE TwoRightOneUpEnd
    sub to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    ;maybe we will have to check that the cell isn't occupied here
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  TwoRightOneUpEnd
    CALL HelperFunction1 
    
    TwoRightOneUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    
    
    
    TwoRightOneDown:
    add to_test_Col, distance * 2
    CMP to_test_Col, 154d
    JA TwoRightOneDownEnd
    CMP to_test_Row, 154d
    JE TwoRightOneDownEnd
    add to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  TwoRightOneDownEnd
    CALL HelperFunction1
    
    TwoRightOneDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL


    OneRightTwoUp:
    add to_test_Col, distance
    CMP to_test_Col, 154d
    JA OneRightTwoUpEnd
    CMP to_test_Row, 22d
    JBE OneRightTwoUpEnd
    sub to_test_Row, distance * 2
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneRightTwoUpEnd
    CALL HelperFunction1
    
    OneRightTwoUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    

    OneRightTwoDown:
    add to_test_Col, distance
    CMP to_test_Col, 154d
    JA OneRightTwoDownEnd
    CMP to_test_Row, 132d
    JAE OneRightTwoDownEnd
    add to_test_Row, distance * 2
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneRightTwoDownEnd
    CALL HelperFunction1
    
    OneRightTwoDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL
    

    TwoLeftOneUp:
    CMP to_test_Col, 22d
    JBE TwoLeftOneUpEnd
    sub to_test_Col, distance * 2
    CMP to_test_Row, 0D
    JE TwoLeftOneUpEnd
    sub to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  TwoLeftOneUpEnd
    CALL HelperFunction1
    
    TwoLeftOneUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    TwoLeftOneDown:
    CMP to_test_Col, 22d
    JBE TwoLeftOneDownEnd
    sub to_test_Col, distance * 2
    CMP to_test_Row, 154d
    JE TwoLeftOneDownEnd
    add to_test_Row, distance
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  TwoLeftOneDownEnd
    CALL HelperFunction1

    TwoLeftOneDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    OneLeftTwoUp:
    CMP to_test_Col, 0D
    JE OneLeftTwoUpEnd
    sub to_test_Col, distance
    CMP to_test_Row, 22d
    jbe OneLeftTwoUpEnd
    sub to_test_Row, distance*2
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneLeftTwoUpEnd
    CALL HelperFunction1

    OneLeftTwoUpEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    OneLeftTwoDown:
    CMP to_test_Col, 0D
    JE OneLeftTwoDownEnd
    sub to_test_Col, distance
    CMP to_test_Row, 132d
    jae OneLeftTwoDownEnd
    add to_test_Row, distance*2
    calculate_square to_test_row, to_test_col, to_test_squareNumber
    GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
    CALL IsOccupied
    CMP IsSameColorFlag, 1d 
    JE  OneLeftTwoDownEnd
    CALL HelperFunction1

    OneLeftTwoDownEnd:
    MOV BL, SelectedPieceRow
    MOV to_test_row, BL
    MOV BL, SelectedPieceCol
    MOV to_test_col, BL

    RET
GetHosanMoves ENDP

GetFeelMoves PROC Near

MOV AH, SelectedPieceCol
MOV to_test_col, AH
MOV AL, SelectedPieceRow
MOV to_test_row,AL


CMP SelectedPieceCol,0
JE afteruppermain
CMP SelectedPieceRow, 0
JE afteruppermain


checkuppermaindiagonal:
sub to_test_Row, distance
sub to_test_Col, distance
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
CALL IsOccupied
CMP IsSameColorFlag, 1d 
JE afteruppermain   
CALL HelperFunction1 
CMP IsOccupiedFlag, 1d  
JE afteruppermain
CMP to_test_col,0
JE afteruppermain
CMP to_test_row,0
JE afteruppermain
jmp checkuppermaindiagonal




afteruppermain:
MOV AX,00H
MOV AH,SelectedPieceCol
MOV to_test_col,AH
MOV AL, SelectedPieceRow
MOV to_test_row,AL
CMP to_test_col,154d
JE afterlowermain ;;no lower main check would be executed here
CMP to_test_row, 154d
JE afterlowermain
check_lower_main_diagonal:
MOV AL,to_test_col
add AL,22d
MOV AH, to_test_row
add AH,22d
MOV to_test_col, AL
MOV to_test_row, AH
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
CMP to_test_square_piececode, 0D
CALL IsOccupied
CMP IsSameColorFlag, 1d 
JE afterlowermain   
CALL HelperFunction1 
CMP IsOccupiedFlag, 1d  
JE afterlowermain
CALL HelperFunction1

CMP to_test_col,154d
JE afterlowermain
CMP to_test_row,154d
JE afterlowermain
CMP to_test_col,154d
JNE check_lower_main_diagonal




afterlowermain:
MOV AX,00H
MOV AH,SelectedPieceCol
MOV to_test_col,AH
MOV AL, SelectedPieceRow
MOV to_test_row,AL
CMP to_test_col,154d
JE afteruppersecondary
CMP to_test_row, 0d
JE afteruppersecondary

checkuppersecondary:
MOV AL, to_test_col
MOV AH, to_test_row
add AL, 22d
sub AH, 22d
MOV to_test_col,AL
MOV to_test_row, AH
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
CMP to_test_square_piececode, 0D
CALL IsOccupied
CMP IsSameColorFlag, 1d 
JE afteruppersecondary  
CALL HelperFunction1 
CMP IsOccupiedFlag, 1d  
JE afteruppersecondary
CALL HelperFunction1

CMP to_test_col, 154d
JE afteruppersecondary
CMP to_test_row,0d;
JE afteruppersecondary
CMP to_test_col,154d
JNE checkuppersecondary




afteruppersecondary:
MOV AX,00H
MOV AH,SelectedPieceCol
MOV to_test_col,AH
MOV AL, SelectedPieceRow
MOV to_test_row,AL
CMP to_test_col,0d
JE afterlowersecondary
CMP to_test_row,154d
JE afterlowersecondary



checklowersecondary:
MOV AL, to_test_col
MOV AH, to_test_row
CMP AL,00H
JE alis0
sub AL, 22d
alis0:
add AH, 22d
MOV to_test_col,AL
MOV to_test_row, AH
calculate_square to_test_row, to_test_col, to_test_squareNumber
GetSquarePieceCode to_test_square_piececode, to_test_squareNumber
CMP to_test_square_piececode, 0D
CALL IsOccupied
CMP IsSameColorFlag, 1d 
JE afterlowersecondary  
CALL HelperFunction1 
CMP IsOccupiedFlag, 1d  
JE afterlowersecondary
CALL HelperFunction1

CMP to_test_col, 0d
JE afterlowersecondary
CMP to_test_row,154d;
JE afterlowersecondary
CMP to_test_col,0d
JNE checklowersecondary

afterlowersecondary:
RET
GetFeelMoves ENDP

getQueenMoves PROC NEAR
    CALL GetTabyaMoves
    CALL GetFeelMoves
    RET
getQueenMoves ENDP


ShowKills PROC NEAR
draw_piece tabia,  181d, 18d
movecursor 3, 186d 
writeN1 0
draw_piece2 tabia2,  223d, 18d
movecursor 3, 191d 
writeN1 0
draw_piece hosan,  181d, 40d
movecursor 6, 186d 
writeN1 0
draw_piece2 hosan2,  223d, 40d
movecursor 6, 191d 
writeN1 0
draw_piece feel,  181d, 64d
movecursor 9, 186d 
writeN1 0
draw_piece2 feel2,  223d, 64d
movecursor 9, 191d 
writeN1 0
draw_piece queen,  181d, 88d
movecursor 12, 186d 
writeN1 0
draw_piece2 queen2,  223d, 88d
movecursor 12, 191d 
writeN1 0
draw_piece king,  181d, 112d
movecursor 15, 186d 
writeN1 0
draw_piece2 king2,  223d, 112d
movecursor 15, 191d 
writeN1 0
draw_piece Solider,  181d, 136d
movecursor 18, 186d 
writeN1 0
draw_piece2 Solider2,  223d, 136d
movecursor 18, 191d 
writeN1 0
ShowKills ENDP
calculatepiecesdeath PROC NEAR
    checkbtabya:
        CMP DesPieceCode,1d
        JNE checkbhosan
        inc BlackTabyaDeath 
        movecursor 3, 186d 
        writeN1 BlackTabyaDeath
        checkbhosan:
        CMP DesPieceCode,2d
        JNE checkbfeel
        inc BlackHosanDeath
        movecursor 6, 186d 
        writeN1 BlackHosanDeath
        checkbfeel:
        CMP DesPieceCode,3d
        JNE checkbQueen
        inc BlackfeelDeath
        movecursor 9, 186d 
        writeN1 BlackfeelDeath
        checkbQueen:
        CMP DesPieceCode,4d
        JNE checkbking
        inc BlackQueenDeath
        movecursor 12, 186d 
        writeN1 BlackQueenDeath
        checkbking:
        CMP DesPieceCode,5d
        JNE checkbgond
        inc BlackKingDeath
        movecursor 15, 186d 
        writeN1 BlackKingDeath
        checkbgond:
        CMP DesPieceCode,6d
        JNE checkwtabya
        inc BlackgondiDeath
        movecursor 18, 186d 
    writeN1 BlackgondiDeath
        checkwtabya:
        CMP DesPieceCode,7d
        JNE checkwhosan
        inc WhiteTabyaDeath 
        movecursor 3, 191d 
    writeN1 WhiteTabyaDeath
        checkwhosan:
        CMP DesPieceCode,8d
        JNE checkwfeel
    inc WhiteHosanDeath
        movecursor 6, 191d 
    writeN1 WhiteHosanDeath
    checkwfeel:
    CMP DesPieceCode,9d
        JNE checkwQueen
    inc WhitefeelDeath
    movecursor 9, 191d 
    writeN1 WhitefeelDeath
        checkwQueen:
    CMP DesPieceCode,10d
    JNE checkwking
    inc WhiteQueenDeath
    movecursor 12, 191d 
    writeN1 WhiteQueenDeath
    checkwking:
    CMP DesPieceCode,11d
    JNE checkwgond
    inc WhiteKingDeath
    movecursor 15, 191d 
    writeN1 WhiteKingDeath
    checkwgond:
    CMP DesPieceCode,12d
    JNE check_ended
    inc WhitegondiDeath
    movecursor 18, 191d 
    writeN1 WhitegondiDeath
    check_ended:
    RET
calculatepiecesdeath  ENDP


SelectPieceMoves PROC NEAR
    MOV number_of_potential_cells, 0D
    CMP SelectedPieceCode, 1d
    JE SelectPieceMovesLabel_17
    CMP SelectedPieceCode, 2d
    JE SelectPieceMovesLabel_28
    CMP SelectedPieceCode, 3d
    JE SelectPieceMovesLabel_39
    CMP SelectedPieceCode, 4d
    JE SelectPieceMovesLabel_410
    CMP SelectedPieceCode, 5d
    JE SelectPieceMovesLabel_511
    CMP SelectedPieceCode, 6d
    JE SelectPieceMovesLabel_6
    CMP SelectedPieceCode, 7d
    JE SelectPieceMovesLabel_17
    CMP SelectedPieceCode, 8d
    JE SelectPieceMovesLabel_28
    CMP SelectedPieceCode, 9d
    JE SelectPieceMovesLabel_39
    CMP SelectedPieceCode, 10d
    JE SelectPieceMovesLabel_410
    CMP SelectedPieceCode, 11d
    JE SelectPieceMovesLabel_511
    CMP SelectedPieceCode, 12d
    JE SelectPieceMovesLabel_12
    
    SelectPieceMovesLabel_17:
    CALL GetTabyaMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesLabel_28:
    CALL GetHosanMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesLabel_39:
    CALL GetFeelMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesLabel_410:
    CALL getQueenMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesLabel_511:
    CALL GetKingMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesLabel_6:
    CALL GetBgondMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesLabel_12:
    CALL GetWgondMoves
    jmp SelectPieceMovesEnd
    SelectPieceMovesEnd:
    RET
SelectPieceMoves ENDP

ValidateMove PROC Near
    MOV isValidMove, 0
    MOV BX, 0
    CMP number_of_potential_cells, 0
    JE validateMoveEnd
    ValidateMoveFlag1:
    MOV AL, [potential_cells_squareNumber + BX]
    CMP DesSquare, AL
    JE ValidateMoveFlag2
    INC BL
    CMP BL, number_of_potential_cells
    JNE ValidateMoveFlag1
    jmp validateMoveEnd

    ValidateMoveFlag2:
    MOV isValidMove, 1
    validateMoveEnd:
    RET
ValidateMove ENDP

; TWO VARIABLES ISOCCUPIEDFLAG AND ISSAMECOLORFLAG
IsOccupied PROC NEAR
    MOV IsOccupiedFlag, 0D
    MOV IsSameColorFlag, 0D
    CMP to_test_square_piececode, 0D
    JE IsOccupiedRet
    MOV IsOccupiedFlag, 1d

    CMP SelectedPieceCode, 6d
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

IsOccupied ENDP

HelperFunction1 PROC Near
    MOV BH, 0
    MOV BL, number_of_potential_cells
    MOV AL, to_test_row
    MOV [potential_cells_row + BX], AL
    MOV AL, to_test_col
    MOV [potential_cells_col + BX], AL
    inc number_of_potential_cells
    calculate_square to_test_Row, to_test_Col, dummy1
    MOV AL, dummy1
    MOV [potential_cells_squareNumber + BX], AL
    RET
HelperFunction1 ENDP


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
    RET
Dehighlight ENDP

NAMESCREEN PROC NEAR
    movecursor 01h, 01h
    print enternamemes
    movecursor 02h, 05h
    MOV BX, offset p1name
    READNAME
    MOV BH, 0h ; necessary since BX changes IN readname function ; default is BH = 0 for moving cursor

    movecursor 10h, 01h
    print presstocontinuemes

    waitforuseractionNS:
    MOV AH, 0
    int 16h

    ; CHECK IF KEY IS ESC
    CMP AH, Escscancode
    JE exitnamescreen

    ; CHECK IF KEY IS ENTER
    CMP AH, Enterscancode
    JNE waitforuseractionNS
    clearscreen
    RET
    exitnamescreen:
    clearscreen
    exit
NAMESCREEN ENDP



GAMESCREEN PROC NEAR
    
    ; CONFIGURATION  
    graphicsmode
    draw_board
; ;......................................................THE BLACK SET...........................................................

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
    Drawsquare selected_frame_row, selected_frame_col, red_color ; draw frame IN initial position at topleft of the board

    Drawsquare selected_frame_row2, selected_frame_col2, green_color
    ;----------------------------------
    CALL ShowKills
    ;...............
    GetSystemTime
    MOV inctime, DH

    CHECK_Time1: 
    CALL RunTime
    CALL RunPieceTimers
    CALL CheckGameEnd
    CMP GAME_END, 1h
    JE GAME_ENDED_LABEL
    waitforuseractionGS:
    MOV AH, 01h
    int 16h
    JZ label3
    CMP AH, Escscancode ; check if key is ESC
    JZ GameScreenEnd
    CALL executekeypress
    clearkeyboardbuffer
    
    label3:
    GetSystemTime
    CMP DL, aux_time ; DL contains 1/100 of a second
    JE waitforuseractionGS ; if no 1/100 second has passed, wait for user action again
    
    ; If 1/100 seconds passed, run the time 
    MOV aux_time, DL
    jmp CHECK_Time1
    
    GAME_ENDED_LABEL:
    getkeypress
    CMP AH, Escscancode
    JNE GAME_ENDED_LABEL
    GameScreenEnd: ; clean up
    clearscreen
    textmode
    RET          
GAMESCREEN ENDP

movepiece PROC NEAR
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
    UpdateSquare selectedPieceSquare, zero ; set the past square of the piece to 0 which means empty square
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
    CALL calculatepiecesdeath
    UpdateSquare DesSquare, SelectedPieceCode
    Redraw SelectedPieceCode, DesCol, DesRow
    CALL SetPieceStopTime
    CALL CheckPromotion
    CALL updateKingsPos
    RET
movepiece ENDP

SetPieceStopTime PROC NEAR
    GetSystemTime
    MOV BH, 0000H
    MOV BL, DesSquare ; we need to check this didn't change
    MOV [StartTimeArray + BX], DH ; THE TIME IN SECONDS AT WHICH THE PIECE WAS MOVED IS RECORDED
    MOV AL, CountDownTime
    MOV [timerArray + BX], AL ; SET PIECE TIMER START TO 3 SECONDS
    RET
SetPieceStopTime ENDP

 RunPieceTimers PROC NEAR
    MOV BX, 0 
    GetSystemTime ; DH HAS THE SYSTEM TIME IN SECONDS
    RunPieceTimers_Label:
    MOV AL,[timerArray+BX]  ; IF ZERO, THAT MEANS THE PIECE HAS NO COUNTDOWN ON IT, SO GO TO THE NEXT
    CMP AL, 0D
    JE nxtloop
    MOV AL, [StartTimeArray + BX]
    CMP AL, DH
    JE nxtloop
    MOV AL, [timerArray + BX]
    DEC AL
    MOV [timerArray + BX], AL
    nxtloop:
    INC BX
    CMP BX, 64D
    JE RunPieceTimersEnd
    JMP RunPieceTimers_Label
    RunPieceTimersEnd:
    RET
RunPieceTimers ENDP



RunTime PROC NEAR
    GetSystemTime  ; DH :seconds , DL:1/100 seconds
    CMP DH, inctime ;dummy variable ;
    JE RunTimeEnd
    
    inc inctime
    CMP inctime, 60d
    JNE RuntimeLabel1
    Mov inctime, 0d


    RuntimeLabel1:
    inc seconds 
    CMP seconds,60d
    JNE label2  
    MOV seconds,00
    inc minutes
    CMP minutes,60d
    JNE label2
    MOV minutes,00
    inc hours
    CMP hours,24d 
    JNE label2
    MOV seconds,00
    MOV minutes,00
    MOV hours,00
    label2:
    TurnTimetostring seconds,secondsstr+2 
    TurnTimetostring hours,hoursstr+2  
    TurnTimetostring minutes,minutesstr+2
    movecursor 0,29
    MOV DX,offset hoursstr+2
    CALL PRINTMESSAGE
    MOV DL,':'
    MOV AH,2
    int 21h     
    MOV DX,offset minutesstr+2
    CALL PRINTMESSAGE
    MOV DL,':'
    MOV AH,2
    int 21h
    MOV DX,offset secondsstr+2
    CALL PRINTMESSAGE

    RunTimeEnd:
    RET
RunTime ENDP


CheckPromotion PROC NEAR
    CMP selectedPieceCode, 6d
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
CheckPromotion ENDP

Promote PROC NEAR

    ;--------- Prepare for drawing----------
    MOV CH, 0d
    MOV CL, DesCol
    MOV scol, CX
    draw_filled_square squaredimension,squaredimension,SCOL, DesColor
    ;--------------------
    CMP SelectedPieceCode, 6d
    JNE PromoteWhite
    PromoteBlack:
    draw_piece queen,  DesCol, DesRow
    UpdateSquare DesSquare, four
    RET
    PromoteWhite:
    draw_piece2 queen2, DesCol, DesRow
    UpdateSquare DesSquare, ten
    RET
Promote ENDP

Castle PROC Near

Castle ENDP

KingInCheck PROC Near

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
    CALL GetKingMoves
    CMP number_of_potential_cells, 0d
    JE LET_BKING_BE_HOSAN
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_BKING_BE_KING_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    PUSH BX
    MOV dummy5, CH
    GetSquarePieceCode dummy1, dummy5
    POP BX
    CMP dummy1, 11d 
    JE BlackkingISInCheck
    DEC CL
    JNZ LET_BKING_BE_KING_LABEL1


    LET_BKING_BE_HOSAN:
    MOV number_of_potential_cells, 0D ; reset number of potential cells IN case it is not zero ; it probably is though
    MOV SelectedPieceCode, 2D ; king is hosan
    CALL GetHosanMoves
    CMP number_of_potential_cells, 0d
    JE LET_BKING_BE_TABIA
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_BKING_BE_HOSAN_LABEL1: ; loop
    MOV CH, [potential_cells_squareNumber + BX] ; get square number of all potential cells
    INC BX
    PUSH BX
    MOV dummy5, CH
    GetSquarePieceCode dummy1, dummy5
    POP BX
    CMP dummy1, 8d ; if square piece code equals the square piece code of WHITE HOSAN, THAT means that a white hosan checks the black king
    JE BlackkingISInCheck
    DEC CL
    JNZ LET_BKING_BE_HOSAN_LABEL1
    
    LET_BKING_BE_TABIA:
    MOV number_of_potential_cells, 0D
    MOV SelectedPieceCode, 1D 
    CALL GetTabyaMoves
    CMP number_of_potential_cells, 0d
    JE LET_BKING_BE_FEEL 
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_BKING_BE_TABIA_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    PUSH BX
    MOV dummy5, CH
    GetSquarePieceCode dummy1, dummy5
    POP BX
    CMP dummy1, 7d 
    JE BlackkingISInCheck
    DEC CL
    JNZ LET_BKING_BE_TABIA_LABEL1

    LET_BKING_BE_FEEL:
    MOV number_of_potential_cells, 0D
    MOV SelectedPieceCode, 3D 
    CALL GetFeelMoves 
    CMP number_of_potential_cells, 0d
    JE LET_BKING_BE_QUEEN
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_BKING_BE_FEEL_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    PUSH BX
    MOV dummy5, CH
    GetSquarePieceCode dummy1, dummy5
    POP BX
    CMP dummy1, 9d 
    JE BlackkingISInCheck
    DEC CL
    JNZ LET_BKING_BE_FEEL_LABEL1

    LET_BKING_BE_QUEEN:
    MOV number_of_potential_cells, 0D
    MOV SelectedPieceCode, 4D 
    CALL getQueenMoves
    CMP number_of_potential_cells, 0d
    JE WhiteKing
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_BKING_BE_QUEEN_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    push BX
    MOV dummy5, CH
    GetSquarePieceCode dummy1, dummy5
    pop BX
    CMP dummy1, 10d 
    JE BlackkingISInCheck
    DEC CL
    JNZ LET_BKING_BE_QUEEN_LABEL1
    JMP WhiteKing


    
    
    BlackKingIsInCheck:
    MOV number_of_potential_cells, 0D ; REMEMBER TO RESET TO ZERO
    MOV BKingChecked, 1D
    ;-----------
    CMP FL,0          ;if not 0 ----> first line maktoob feh we second bardo fa hanshafet elle kan second fe first 
    JE print2
    CMP SL,0                 
    JE print2
    movecursor 23,1
    MOV DX , NotificationBarMessage
    CALL PRINTMESSAGE            ;hena ba shafett
    print2:
    ;-----------
    MOV NextNotification, offset BlackKingIsCheckedMessaage
    CALL ShowNotifications
   
    RET
    

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
    CALL GetKingMoves
    CMP number_of_potential_cells, 0d
    JE LET_WKING_BE_HOSAN
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_WKING_BE_KING_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    PUSH BX
    MOV dummy5, CH
    GetSquarePieceCode dummy1, dummy5
    POP BX
    CMP dummy1, 5d 
    JE WhitekingISInCheck
    DEC CL
    JNZ LET_WKING_BE_KING_LABEL1

    LET_WKING_BE_HOSAN:
    MOV number_of_potential_cells, 0D 
    MOV SelectedPieceCode, 8D 
    CALL GetHosanMoves
    CMP number_of_potential_cells, 0d
    JE LET_WKING_BE_TABIA
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_WKING_BE_HOSAN_LABEL1:
    MOV CH, [potential_cells_squareNumber + BX]
    INC BX 
    push BX
    MOV dummy5, CH
    GetSquarePieceCode dummy1, dummy5
    pop BX
    CMP dummy1, 2d 
    JE WhitekingISInCheck
    DEC CL
    JNZ LET_WKING_BE_HOSAN_LABEL1
    
    LET_WKING_BE_TABIA:
    MOV number_of_potential_cells, 0D
    MOV SelectedPieceCode, 7D 
    CALL GetTabyaMoves
    CMP number_of_potential_cells, 0d
    JE LET_WKING_BE_FEEL
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_WKING_BE_TABIA_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX]
    INC BX
    PUSH BX 
    MOV dummy5, CH
    GetSquarePieceCode dummy1, dummy5
    POP BX
    CMP dummy1, 1d 
    JE WhitekingISInCheck
    DEC CL
    JNZ LET_WKING_BE_TABIA_LABEL1

    LET_WKING_BE_FEEL:
    MOV number_of_potential_cells, 0D
    MOV SelectedPieceCode, 3D 
    CALL GetFeelMoves 
    CMP number_of_potential_cells, 0d
    JE LET_WKING_BE_QUEEN
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_WKING_BE_FEEL_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    push BX
    MOV dummy5, CH
    GetSquarePieceCode dummy1, dummy5
    POP BX
    CMP dummy1, 9d 
    JE WhitekingISInCheck
    DEC CL
    JNZ LET_WKING_BE_FEEL_LABEL1

    LET_WKING_BE_QUEEN:
    MOV number_of_potential_cells, 0D
    MOV SelectedPieceCode, 4D 
    CALL SelectPieceMoves 
    CMP number_of_potential_cells, 0d
    JE KingInCheckRet
    MOV BX, 0d
    MOV CL, number_of_potential_cells
    LET_WKING_BE_QUEEN_LABEL1: 
    MOV CH, [potential_cells_squareNumber + BX] 
    INC BX
    PUSH BX
    MOV dummy5, CH
    GetSquarePieceCode dummy1, dummy5
    POP BX
    CMP dummy1, 10d 
    JE WhitekingISInCheck
    DEC CL
    JNZ LET_WKING_BE_QUEEN_LABEL1
    JMP KingInCheckRet


    WhiteKingIsInCheck:
    MOV number_of_potential_cells, 0D ; REMEMBER TO RESET TO ZERO
    MOV WKingChecked, 1D
        ;-----------
    CMP FL,0          ;if not 0 ----> first line maktoob feh we second bardo fa hanshafet elle kan second fe first 
    JE print3
    CMP SL,0                 
    JE print3 
    movecursor 23,1
    MOV DX , NotificationBarMessage
    CALL PRINTMESSAGE            ;hena ba shafett
    print3:
    ;-----------
    MOV NextNotification, offset WhiteKingIsCheckedMessaage
    KingInCheckRet:
    RET
KingInCheck ENDP


updateKingsPos PROC NEAR
    CMP selectedPieceCode, 5d
    JNE updateKingsPos_label2
    updateKingsPos_label1: ; update black king pos
    MOV AL, DesSquare
    MOV BkingPos, AL
    MOV AL, DesRow
    MOV Bkingrow1, AL
    MOV AL, DesCol
    MOV Bkingcol1, AL
    JMP updateKingsPosRet


    updateKingsPos_label2: ; update white king pos
    CMP selectedPieceCode, 11d
    JNE updateKingsPosRet
    MOV AL, DesSquare
    MOV WkingPos, AL
    MOV AL, DesRow
    MOV Wkingrow1, AL
    MOV AL, DesCol
    MOV Wkingcol1, AL

    updateKingsPosRet:
    RET
updateKingsPos ENDP

RedrawPotentialSquare PROC NEAR 
    push BX
    MOV BL, number_of_potential_cells
    MOV dummy1, BL
    MOV BX, 0D 
    Potential_array_loop:
    MOV AL, selected_frame_square
    CMP [potential_cells_squareNumber+BX],AL
    JNE lbl1
    Drawsquare selected_frame_row, selected_frame_col, cyan_color
    jmp not_in_my_potential_list
    lbl1:
    inc BX
    dec dummy1
    JNZ Potential_array_loop
    not_in_my_potential_list:
    pop BX
    RET
RedrawPotentialSquare ENDP
        



;===========================================

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

    CMP AL, F4scancode
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
    CMP AH, F4ScanCode
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
        MOV BL, F4scancode
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
                MOV BL, F4scancode
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
                CMP BL, F4scancode
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


;======================
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


MAINSCREEN PROC NEAR
    
    displaymainscreen:
    movecursor 09h, 10h
    print mes1      
    
    movecursor 0bh,10h
    print mes2
    
    movecursor 0dh,10h
    print mes3

    movecursor 15h,00h
    print mes5
    
    waitforuseractionMS:
    getkeypress
                
    ; check if key is ESC                    
    CMP AH, Escscancode        
    JNE checkf4
    clearscreen
    exit
    RET            
    
    ; check if key is F4                    
    checkf4:
    CMP AH, F4scancode
    JNE checkf2
    clearscreen
    CALL chatSCREEN
    jmp displaymainscreen
    
    ; check if key is F2
    checkf2:
    CMP AH, F2ScanCode
    JNE waitforuseractionMS
    clearscreen
    CALL GAMESCREEN
    jmp displaymainscreen
    RET
MAINSCREEN ENDP

end main