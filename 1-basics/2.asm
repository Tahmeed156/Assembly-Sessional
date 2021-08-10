.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    INP DB 'ENTER LETTER: $'
    OUT1 DB CR, LF, 'LOWER CASE LETTER: $'
    OUT2 DB CR, LF, 'ONES COMPLEMENT: $'
    X DB ?
    Y DB ?

.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
;INPUT - GET LETTER
    LEA DX, INP
    MOV AH, 9
    INT 21H

    MOV AH, 1
    INT 21H
    MOV X, AL         
    MOV Y, AL
    
;OUTPUT 1 - LOWER CASE LETTER           
    ADD X, 1FH
    
    LEA DX, OUT1
    MOV AH, 9
    INT 21H     
    
    MOV AH, 2
    MOV DL, X
    INT 21H
                                   
;OUTPUT 2 - ONES COMPLEMENT
    NEG Y
    SUB Y, 1H
    
    LEA DX, OUT2
    MOV AH, 9
    INT 21H     
    
    MOV AH, 2
    MOV DL, Y
    INT 21H
    
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN