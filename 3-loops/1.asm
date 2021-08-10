.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    INP1 DB 'OPERAND 1 = $'           
    INP2 DB CR, LF, 'OPERAND 2 = $'
    INP3 DB CR, LF, 'OPERATOR = $'
                                                
    OUT1 DB CR, LF, 'OUTPUT = $'                
    OUT2 DB 'WRONG OPERATOR $'
    
    FIRST_OP DW 0H
    SECOND_OP DW 0H
    OPER DB ?
    COUNT DB 0
    NEG_FLAG DB 0                       
    
.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
;INPUT 
    LEA DX, INP1
    MOV AH, 9
    INT 21H
                                
    CALL INPUT_OPERAND
    MOV FIRST_OP, CX
    
    
    LEA DX, INP2
    MOV AH, 9
    INT 21H
    
    CALL INPUT_OPERAND
    MOV SECOND_OP, CX    
    
    
    LEA DX, INP3
    MOV AH, 9
    INT 21H
          
    MOV AH, 1
    INT 21H 
    MOV OPER, AL
    
    
    LEA DX, OUT1
    MOV AH, 9
    INT 21H        
    
;OPERATIONS                
    MOV DX, FIRST_OP         
    MOV AL, OPER
    
    CMP AL, 2BH
    JZ ADD_OP
    CMP AL, 2DH
    JZ SUB_OP
    CMP AL, 2AH
    JZ MUL_OP
    CMP AL, 2FH
    JZ DIV_OP
    CMP AL, 71H
    JZ QUIT_OP
    
    JMP WRONG_OP
    
    
ADD_OP:                          
    ADD DX, SECOND_OP
    JMP PRINT
SUB_OP:                          
    SUB DX, SECOND_OP 
    JMP PRINT
MUL_OP:  
    MOV AX, FIRST_OP
    MOV BX, SECOND_OP
    IMUL BX   
    MOV DX, AX 
    JMP PRINT
DIV_OP:      
    MOV AX, FIRST_OP 
    CWD
    MOV BX, SECOND_OP
    IDIV BX   
    MOV DX, AX
    JMP PRINT  
QUIT_OP:             
    JMP EXIT
WRONG_OP:       
    JMP PRINT_INVALID
         
      
;PRINT 
               
PRINT:
;    MOV AH, 2
;    INT 21H   
    CALL OUTPUT_OPERAND
    JMP EXIT 
     
PRINT_INVALID:
    LEA DX, OUT2
    MOV AH, 9
    INT 21H
    
    JMP EXIT 
        
EXIT:
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP  



;INPUT OPERAND PROCEDURE

INPUT_OPERAND PROC  
    
    MOV CX, 0  
    MOV NEG_FLAG, -1
          
REPEAT:
    MOV AH, 1
    INT 21H
    
    ;TAKE SIGN
    CMP NEG_FLAG, -1 
    JNE CHECK_RANGE
    CMP AL, 2DH
    MOV NEG_FLAG, 1
    JE REPEAT
    MOV NEG_FLAG, 0
      
      
CHECK_RANGE:    
    CMP AL, CR
    JZ SET_SIGN
    
    CMP AL, 30H
    JL REPEAT
    CMP AL, 39H
    JG REPEAT
            
UPDATE_NUMBER:
    MOV AH, 0
    SUB AL, 30H
    MOV BX, AX
    
    MOV AX, CX
    MOV DX, 10
    MUL DX
    
    MOV CX, AX
    ADD CX, BX
    
    JMP REPEAT
    
SET_SIGN:
    CMP NEG_FLAG, 0
    JE END
    NEG CX
    
END:
    RET              
INPUT_OPERAND ENDP 


;OUTPUT OPERAND PROCEDURE

OUTPUT_OPERAND PROC 
    MOV AX, DX
    MOV COUNT, 0    
    
PRINT_SIGN:
    CMP AX, 0
    JGE AGAIN
    NEG AX
    MOV CX, AX
    
    MOV DL, 2DH             
    MOV AH, 2
    INT 21H
    
    MOV AX, CX
    
AGAIN:
    INC COUNT
    
    ;DIVIDE BY 10
    CWD
    MOV CX, 10       
    DIV CX
             
    ;PRINT REMAINDER
    ADD DX, 30H
    PUSH DX
    
    ;CHECK IF QUOTIENT 0
    CMP AX, 0H
    JNZ AGAIN 
                 
    MOV CX, 0
    MOV CL, COUNT
           
PRINT_NUMBER:
  
    POP DX                 
    MOV AH, 2
    INT 21H
 
    DEC CL   
    CMP CL, 0
    JNZ PRINT_NUMBER
             
    RET              
OUTPUT_OPERAND ENDP 

    END MAIN
