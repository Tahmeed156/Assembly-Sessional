.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH 
    +
    
    INP1 DB 'ENTER MATRIX 1: ', CR, LF, '$'
    INP2 DB CR, LF, 'ENTER MATRIX 2: ', CR, LF, '$'
    INP3 DB CR, LF, '$'           
                                                
    OUT1 DB CR, LF, 'RESULTANT MATRIX: ', CR, LF, '$'              
    
    MAT_1 DB 4 DUP(?)
    MAT_2 DB 4 DUP(?)
    COUNT DB 0                      
    
.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX   
    
;INPUT 
    LEA DX, INP1
    MOV AH, 9
    INT 21H
                        
    LEA SI, MAT_1 
    CALL ARRAY_INPUT 
    
    LEA DX, INP2
    MOV AH, 9
    INT 21H
                        
    LEA SI, MAT_2 
    CALL ARRAY_INPUT
    
;OPERATIONS
    LEA SI, MAT_1
    LEA DI, MAT_2
    MOV CX, 4
    
CALCULATE:
    MOV AL, [DI]
    ADD [SI], AL
    
    ADD SI, 1
    ADD DI, 1
    
    LOOP CALCULATE
       
;OUTPUT
    LEA DX, OUT1
    MOV AH, 9
    INT 21H  
              
    LEA SI, MAT_1 
    CALL ARRAY_OUTPUT
        
;EXIT
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP       

;PROCEDURE - INPUT

ARRAY_INPUT PROC
    MOV COUNT, 0  
         
REPEAT:
    ; CHARACTER INPUT  
    MOV AH, 1
    INT 21H 
    
    ;CHECK RANGE
    CMP AL, 30H
    JL REPEAT
    CMP AL, 39H
    JG REPEAT
    
    ;STORE IN ARR
    SUB AL, 30H
    MOV [SI], AL
    ADD SI, 1
    
    ;PRINT NEW LINE
    INC COUNT    
    CMP COUNT, 2
    JNE CHECK_DONE
         
    LEA DX, INP3
    MOV AH, 9
    INT 21H
     
    ;CHECK IF DONE
CHECK_DONE:
    CMP COUNT, 4
    JL REPEAT
    
    RET              
ARRAY_INPUT ENDP 

; PROCEDURE - OUTPUT

ARRAY_OUTPUT PROC        
    
    MOV CX, 4

OUTPUT_REPEAT:
                
    MOV DL, [SI]
    CMP DL, 10
    JL SINGLE_CHAR
                    
    ;CHARACTER OUTPUT
MULTI_CHAR:  
    MOV DH, 0
    MOV AX, DX
    MOV BL, 10
    DIV BL
 
    MOV DX, AX
    ADD DL, 30H
    MOV AH, 2
    INT 21H    
    
    MOV DL, DH             
    
SINGLE_CHAR:
    ADD DL, 30H
    MOV AH, 2
    INT 21H 
    
    ;SPACE OUTPUT         
    MOV DL, 20H         
    MOV AH, 2
    INT 21H
    
    ;PRINT NEW LINE    
    CMP CX, 3
    JNE CHECK_LOOP
         
    LEA DX, INP3
    MOV AH, 9
    INT 21H
     
    ;LOOP 
CHECK_LOOP:
    ADD SI, 1
    LOOP OUTPUT_REPEAT

    RET
ARRAY_OUTPUT ENDP        

    END MAIN
