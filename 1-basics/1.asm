.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    INP1 DB 'X = $'
    INP2 DB CR, LF, 'Y = $'
    OUT1 DB CR, LF, 'Z = X-2Y = $'
    OUT2 DB CR, LF, 'Z = 25-(X+Y) = $'
    OUT3 DB CR, LF, 'Z = 2X-3Y = $'
    OUT4 DB CR, LF, 'Z = Y-X+1 = $'
    X DB ?
    Y DB ?
    Z DB ?
    
.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
;INPUT 
    LEA DX, INP1
    MOV AH, 9
    INT 21H

    MOV AH, 1
    INT 21H
    MOV X, AL
    SUB X, 30H

    LEA DX, INP2
    MOV AH, 9
    INT 21H

    MOV AH, 1
    INT 21H
    MOV Y, AL
    SUB Y, 30H

;X-2Y
    MOV BH, X
    SUB BH, Y
    SUB BH, Y

    MOV Z, BH
    ADD Z, 30H

    LEA DX, OUT1
    MOV AH, 9
    INT 21H

    MOV DL, Z
    MOV AH, 2
    INT 21H

;25-(X+Y)
    MOV BH, 25
    SUB BH, X
    SUB BH, Y     
    
    MOV Z, BH
    ADD Z, 30H
        
    LEA DX, OUT2
    MOV AH, 9
    INT 21H     
             
    MOV DL, Z
    MOV AH, 2
    INT 21H     

;2X-3Y
    MOV BH, X
    ADD BH, X
    SUB BH, Y
    SUB BH, Y
    SUB BH, Y     
    
    MOV Z, BH
    ADD Z, 30H
        
    LEA DX, OUT3
    MOV AH, 9
    INT 21H     
             
    MOV DL, Z
    MOV AH, 2
    INT 21H      
                                   
;Y-X+1
    MOV BH, Y
    SUB BH, X
    ADD BH, 1     
    
    MOV Z, BH
    ADD Z, 30H
        
    LEA DX, OUT4
    MOV AH, 9
    INT 21H     
             
    MOV DL, Z
    MOV AH, 2
    INT 21H
    
;EXIT
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN
