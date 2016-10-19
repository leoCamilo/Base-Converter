;processador de 16 bits
;valor maximo 65535

;hexaDecimal de 4 campos
;binario de 16 campos
;decimal 5 campos 

;--------------------------------------------------------------------------------

jnpLine MACRO linha, coluna 
        PUSHA
        MOV AH,2                ;manda cursor pra posicao DH = linha,DL = coluna
        MOV DH,linha            ;linha
        MOV DL,coluna           ;coluna
        INT 10h                 ;executa interrupcao
        POPA
ENDM

;--------------------------------------------------------------------------------

toDecimal MACRO base            ;Le a string e a transforma em um valor referente ao digitado
    
    LOCAL faz, j1, j2, endD     ;loop's locais
    
    PUSHA
    MOV DI,2                    ;indice do vetor (depois do identificador 'x')
    SUB SI,3                    ;valor do expoente daquela casa
    MOV DX,0                    ;como e uma mult de 16b zerei o dx pra nao ter problema
    
    faz:
                                
        MOV CX,SI               ;SI == CX == valor do expoente
        MOV BX,base             ;BX e a base
        
        CALL pow                ;resultado em AX
        
        MOV BL,numString[DI]
        
        SUB BX,48               ;trazforma o numero de char para o seu inteiro
        CMP BX,9                ;vejo se o caractere e uma letra
        JG  j1                  ;se valor maior q nove e uma letra
        JMP j2                  ;se nao pula
        
        j1:
            SUB BX,7            ;subtrai mais 7 pra obter o valor real
        
        j2:
            MUL BX              ;AX = AL*BL
            ADD Num,AX          ;NumDec += AX
            
            INC DI              ;proxima posicao do vetor
            CMP numString[DI],0      
            JE  endD
            
            DEC SI              ;decrementa o expoente
            JMP faz
     endD:
     
     POPA
ENDM     

;--------------------------------------------------------------------------------

toDecimalD MACRO                ;Le a string e a transforma em um valor referente ao digitado
                                ;(foi criada outra pois a string para decimal era diferente)
    LOCAL faz, endD 
    
    PUSHA
    MOV DI,0                    ;indice do vetor (depois do identificador 'x')
    SUB SI,1                    ;valor do expoente daquela casa
    MOV DX,0                    ;como e uma mult de 16b zerei o dx pra nao ter problema
    
    faz:
                                
        MOV CX,SI               ;SI == CX == valor do expoente
        MOV BX,10               ;BX e a base
        
        CALL pow                ;resultado em AX
        
        MOV BL,numString[DI]
        
        SUB BX,48               ;trazforma o numero de char para o seu inteiro
        
        MUL BX                  ;AX = AL*BL
        ADD Num,AX              ;NumDec += AX
        
        INC DI                  ;proxima posicao do vetor
        CMP numString[DI],0      
        JE  endD
        
        DEC SI                  ;decrementa o expoente
        JMP faz
     
     endD:
     
     POPA
ENDM

;--------------------------------------------------------------------------------
     
NumToDec MACRO                  ;pega o valor e gera uma string referente aquele valor
                                ;gera a string para o decimal daquele valor
     LOCAL divi, fim
     
     MOV DI,4                   ;AX = (DX AX) / operando DX = resto (modulo)
     MOV AX,Num
     MOV CX,10
     MOV NumDec[5],'$'
     
     divi:
         
         MOV DX,0
         DIV CX
         ADD DX,48
         MOV NumDec[DI],DL
         DEC DI
         
         CMP CX,AX
         JG  fim
         JMP divi
     
     fim:
        
        ADD AL,48
        MOV NumDec[DI],AL
        
     POPA
ENDM

;--------------------------------------------------------------------------------

NumToBin MACRO                   ;pega o valor e gera uma string referente aquele valor
                                 ;gera a string para o binario daquele valor
     LOCAL divi, fim
     
     MOV DI,15                   ;AX = (DX AX) / operando DX = resto (modulo)
     MOV AX,Num
     MOV CX,2
     MOV NumBin[16],'$'
     
     divi:
         
         MOV DX,0
         DIV CX
         ADD DX,48
         MOV NumBin[DI],DL
         DEC DI
         
         CMP CX,AX
         JG  fim
         JMP divi
     
     fim:
        
        ADD AL,48
        MOV NumBin[DI],AL
        
     POPA
ENDM

;--------------------------------------------------------------------------------

NumToHexa MACRO                 ;pega o valor e gera uma string referente aquele valor
                                ;gera a string para o hexadecimal daquele valor
     LOCAL divi, fim, j1, j2, j3, j4, j5, j6
     
     MOV DI,3                   ;AX = (DX AX) / operando DX = resto (modulo)
     MOV AX,Num
     MOV CX,16
     MOV NumHexa[4],'$'
     
     divi:
         
         MOV DX,0
         DIV CX
         
         CMP DX,9               
         JG  j1                 
         JMP j2                  
        
         j1:
             ADD DX,55
             JMP j3            
         j2:  
             ADD DX,48
         
         j3:
             MOV NumHexa[DI],DL
             DEC DI
             
             CMP CX,AX
             JG  fim
             JMP divi
     
     fim:
        
        CMP AL,9               
        JG  j4                 
        JMP j5                  
        
        j4:
            ADD AL,55
            JMP j6            
        j5:  
            ADD AL,48
        
        j6:
            MOV NumHexa[DI],AL
        
     POPA
ENDM

;--------------------------------------------------------------------------------

teste MACRO tam
    
    LOCAL warning, ok
    
    CMP SI,tam
    JG  warning
    JMP ok
    
    warning:                   ;se numero invalido
        
        jnpLine 2,0
        
        MOV DX,OFFSET msg2
        MOV AH,9
        INT 21h
        RET                    ;Fim do programa           
    
    ok:
    
ENDM

;-------------------------------------------------------------------------------- 
 
printF MACRO var
    
    PUSH AX
    PUSH DX
    
    MOV DX,OFFSET var
    MOV AH,9
    INT 21h
    
    POP DX
    POP AX

ENDM
;--------------------------------------------------------------------------------


ORG 100h 

printF msg1               ;printa uma string na tela

MOV SI,0                  ;inicia o indice

nextChar:                 ;Le a String do teclado (backspace implementado!)

    MOV AH,00h            ;carrega o parametro da interrupcao
    INT 16h               ;realiza a interrupcao (Scanf)
    MOV AH,0Eh            ;carrega o parametro da interrupcao
    INT 10h               ;realiza a interrupcao (Print)
    
    MOV numString[SI],AL  ;carrega o byte lido de AL para o vetor
    INC SI                ;incremeta o indice
    
    CMP AL,0Dh            ;compara se a tecla apertada = Enter
    JNE backSpace         ;se diferente
    JMP end               ;se igual
    
    backSpace:
        
        CMP  AL,8           ;compara se a tecla apertada = Backspace
        JNE  nextChar       ;se diferente
        PUSH AX             ;salva valor de AX na pilha
        
        MOV  AH,0Eh         ;carrega o parametro da interrupcao
        MOV  AL,' '         ;carrega pra AL um char pra "limpar" a posicao velha 
        INT  10h            ;realiza a interrupcao (Print)
        MOV  AL,8           ;carrega pra AL o backspace
        INT  10h            ;realiza a interrupcao (Print)
        SUB  SI,2           ;subtrai 2 do indice para que guarde o novo valor certo no vetor
            
        POP  AX             ;recupera o valor de AX
        JMP  nextChar       ;volta a ler o teclado
        
    end:
        DEC SI
        MOV numString[SI],0 ;encerra o vetor com 0  ou '\0'
        
;---------------------------------------------------------------------------------------

CMP numString[1],'x'    ;compara se segunda posicao == 'x' que caracteriza um hexadecimal
JE  hexa                ;if num[1] == 'x' executa normal
JMP next                ;else pula pro proximo

hexa:

    teste 6                    ;verifica se o numero e menor q 16bit
    
    printF msgH                     
    
    toDecimal 16               ;chama a macro que converte a string para o valor
    
    jnpLine 2, 0               ;macro pular linha
    
    NumToBin                   ;chama a macro que converte o valor para a string Bin
    
    printF msgB
    printF NumBin
    
    jnpLine 4, 0               ;pula linha
    
    NumToDec                   ;chama a macro que converte o valor para a string Dec
    
    printF msgD
    printF NumDec
     
    RET                        ;Fim do programa

;---------------------------------------------------------------------------------------

next:
    CMP numString[1],'b'        ;compara se segunda posicao == 'b' que caracteriza um binario
    JE  bin
    JMP decimal
     
bin:
                                ;verifica se o numero e menor q 16bit
    teste 16
     
    printF msgB
    
    jnpLine 2, 0                ;macro pular linha
    
    toDecimal 2                 ;chama a macro que converte a string para o valor
    
    NumToDec                    ;chama a macro que converte o valor para a string Dec
    
    printF msgD
    printF NumDec
    
    jnpLine 4, 0                ;macro pular linha
    
    NumToHexa                   ;chama a macro que converte o valor para a string Hexa
    
    printF msgH
    printF NumHexa
    
    RET

;---------------------------------------------------------------------------------------

decimal:

    teste 5                     ;verifica se o numero e menor q 16bit
    
    printF msgD
                                ;chama a macro que converte a string para o valor
    toDecimalD                  ;macro pular linha
    jnpLine 2, 0                ;macro pular linha
    
    NumToBin                    ;chama a macro que converte o valor para a string Bin
    
    printF msgB
    printF NumBin
    
    jnpLine 4, 0                ;macro pular linha
    
    NumToHexa                   ;chama a macro que converte o valor para a string Hexa
    
    printF msgH
    printF NumHexa
    
    RET
    
;---------------------------------------------------------------------------------------

msg1    DB "Digite um numero:   $"
msg2    DB "Valor Invalido!$"
msgH    DB "numero hexadecimal: $"
msgB    DB "numero binario:     $"
msgD    DB "numero decimal:     $"

numString   DB 18 DUP(0)
NumHexa     DB 5  DUP('0')
NumBin      DB 17 DUP('0')
NumDec      DB 6  DUP('0')
Num         DW 0


pow PROC ;pow => AX = BL^CX
    
    MOV AX,1
    CMP CX,0
    JE endPow
    
    loop1:
        MUL BX  ;AX = AL*BX
        LOOP loop1
        
    endPow:
        RET

pow ENDP