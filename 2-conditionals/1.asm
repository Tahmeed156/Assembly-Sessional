.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    INP1 DB 'X = $'
    INP2 DB CR, LF, 'Y = $'
    INP3 DB CR, LF, 'Z = $'
                                                
    OUT1 DB CR, LF, 'ALL THE NUMBERS ARE EQUAL$'
    OUT2 DB CR, LF, '2ND GREATEST = $'
    
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
    
    LEA DX, INP2
    MOV AH, 9
    INT 21H

    MOV AH, 1
    INT 21H
    MOV Y, AL 
    
    LEA DX, INP3
    MOV AH, 9
    INT 21H

    MOV AH, 1
    INT 21H
    MOV Z, AL      
                                   
;CHOOSING THE NUMBER
    MOV BH, X
    MOV CH, Y
    MOV DH, Z         
              
;CHECKING EQUALITY

THREE_EQUAL:
    CMP BH, CH
    JNE TWO_EQUAL_1
    CMP CH, DH
    JE PRINT_EQUAL
    
TWO_EQUAL_1:    
    CMP BH, CH
    JNE TWO_EQUAL_2
    MOV BH, 0H
TWO_EQUAL_2:    
    CMP CH, DH
    JNE TWO_EQUAL_3
    MOV CH, 0H
TWO_EQUAL_3:    
    CMP DH, BH
    JNE XY
    MOV DH, 0H
    

;COMPARISONS        

XY:
    CMP BH, CH
    JG XZ1 
    JMP YZ1
    
XZ1:
    CMP BH, DH
    JG YZ2
    JMP PRINTX        
YZ1:          
    CMP CH, DH
    JG XY2
    JMP PRINTY    
    
YZ2:          
    CMP CH, DH
    JG PRINTY
    JMP PRINTZ    
XY2:          
    CMP BH, DH
    JG PRINTX
    JMP PRINTZ
    
    
;PRINTING THE NUMBER      

             
PRINTX:        
    LEA DX, OUT2
    MOV AH, 9
    INT 21H
    
    MOV DL, X
    MOV AH, 2
    INT 21H  
    JMP EXIT
    
PRINTY:            
    LEA DX, OUT2
    MOV AH, 9
    INT 21H
    
    MOV DL, Y
    MOV AH, 2
    INT 21H  
    JMP EXIT
    
PRINTZ:           
    LEA DX, OUT2
    MOV AH, 9
    INT 21H
    
    MOV DL, Z
    MOV AH, 2
    INT 21H  
    JMP EXIT
    
PRINT_EQUAL:
    LEA DX, OUT1
    MOV AH, 9
    INT 21H  
    
EXIT:
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN