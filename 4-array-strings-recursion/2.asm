.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH 
    
    INP1 DB 'N = $'
    INP2 DB CR, LF, '$'           
                                                
    OUT1 DB CR, LF, 'FIBONACCI SEQUENCE: ', CR, LF, '$'              
    
    COUNT DW 0
    N DW ?
    ;RESULTS DB 99 DUP(-1)                      
    
.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX   
    
;INPUT 
    LEA DX, INP1
    MOV AH, 9
    INT 21H
                  
    CALL NUMBER_INPUT 
    MOV DH, 0
    MOV N, DX    
    
    LEA DX, OUT1
    MOV AH, 9
    INT 21H  
    
;OPERATIONS
FIB_SERIES:
    MOV DX, N
    PUSH COUNT  
    
    CALL FIBONACCI
    MOV DL, AL    
    CALL NUMBER_OUTPUT
                 
    INC COUNT
    MOV CX, COUNT            
    CMP CX, N
    JL FIB_SERIES
        
;EXIT
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP  

; PROCEDURE - FIBONACCI

FIBONACCI PROC
    PUSH BP
    MOV BP, SP
    MOV AX, [BP+4] ; GET N
    
    ;BASE CONDITIONS
    CMP AX, 1
    JE RETURN
    CMP AX, 0
    JE RETURN

RESUME: 
    ;F(N-1)
    MOV CX, [BP+4]
    SUB CX, 1
    PUSH CX ; PUT N-1
    CALL FIBONACCI
    PUSH AX
    
    ;F(N-2)
    MOV CX, [BP+4]
    SUB CX, 2
    PUSH CX ; PUT N-2
    CALL FIBONACCI
    
    ;F(N-2) += F(N-1)
    POP BX
    ADD AX, BX
    
RETURN:
    POP BP              
    RET 2
FIBONACCI ENDP      

;PROCEDURE - INPUT

NUMBER_INPUT PROC
         
    ;FIRST CHAR INPUT
    MOV AH, 1
    INT 21H
    SUB AL, 30H
    MOV AH, 0
    MOV DL, AL       
    
    ;SECOND CHAR INPUT 
    MOV AH, 1
    INT 21H
    
    ;CHECK RANGE
    CMP AL, 30H
    JL EXIT
    CMP AL, 39H
    JG EXIT
    
    SUB AL, 30H
    XCHG AL, DL
                  
    ;UPDATE NUMBER
    MOV AH, 10
    MUL AH
    ADD DL, AL
     
EXIT:
    RET              
NUMBER_INPUT ENDP

; PROCEDURE - OUTPUT

NUMBER_OUTPUT PROC
    MOV CL, 0
                  
REPEAT_LOOP:
    INC CL
    
    ;DIVIDE BY 10  
    MOV DH, 0
    MOV AX, DX
    MOV BL, 10
    DIV BL
           
    ;PRINT REMAINDER
    MOV DX, AX
    PUSH DX
    
    ;CHECK IF QUOTIENT 0
    CMP DL, 0
    JG REPEAT_LOOP
          
PRINT_NUMBER:
    POP DX
    XCHG DL, DH
    
    ADD DL, 30H                 
    MOV AH, 2
    INT 21H
 
    DEC CL   
    CMP CL, 0
    JNZ PRINT_NUMBER
    
    ;DELIMETER OUTPUT   
    MOV DL, 20H         
    MOV AH, 2
    INT 21H

    RET
NUMBER_OUTPUT ENDP        

    END MAIN
