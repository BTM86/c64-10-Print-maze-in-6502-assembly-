; 	COMMODORE 64 RANDOM MAZE IN ASSEMBLY
; 	BY: BEN M AKA BTM86  (2023)
;--------------------------------------------------------------------------------
*=$0801
;BASIC SPEED SELECT PART
        BYTE    $1c,$08,$0a,$00,$85,$22,$46,$55,$4c,$4c,$20,$53,$50,$45,$45,$44
        BYTE    $20,$5b,$59,$2f,$4e,$5d,$22,$3b,$58,$24,$00,$35,$08,$14,$00,$8b
        BYTE    $20,$58,$24,$b2,$22,$59,$22,$20,$a7,$20,$97,$20,$32,$35,$34,$2c
        BYTE    $32,$35,$35,$00,$40,$08,$1e,$00,$9e,$20,$34,$38,$36,$34,$00
;--------------------------------------------------------------------------------
*=$1300
SCREEN = $FB
SCREEN_ADDR_LO = $FB
SCREEN_ADDR_HI = $FC
COUNTER = $FD
;--------------------------------------------------------------------------------
        LDX #$00
SCNCLR
        LDA #32
        STA 1024,X
        STA 1024+256,X
        STA 1024+512,X
        STA 1024+768,X
        LDA #1
        STA 55296,X
        STA 55296+256,X
        STA 55296+512,X
        STA 55296+768,X
        INX
        CPX #$00
        BNE SCNCLR

        LDA #$00
        STA SCREEN_ADDR_LO
        LDA #$04
        STA SCREEN_ADDR_HI       ;SET UP ADDRESS FOR INDIRECT ADDRESSING MODE
;IRQ SETUP
        SEI
        LDA #<IRQ_CODE
        STA $0314
        LDA #>IRQ_CODE
        STA $0315
        CLI

; SID RANDOM NUMBER SETUP
        LDA #$FF
        STA $D40E
        STA $D40F
        LDA #$80
        STA $D412

        LDX #$00

;PICK CHAR 205 OR 206 AND PRINT IT
LOOP    LDA $FE
        CMP #$FF      ;CHECK FOR FULL SPEED MODE
        BEQ START
        LDA COUNTER
        CMP #1        
        BNE LOOP      ;WAIT FOR IRQ
START   CLC           ;MAKE SURE CARRY IS 0
        LDA #$00      ;SET A TO 0
        STA COUNTER   ;RESET COUNTER TO 0
        ROR $D41B     ;ROTATE RIGHT MOST BIT OF RANDOM NUMBER INTO CARRY
        ADC #77       ;IF CARRY HAS A 1 THEN WE GET 78, BUT IF CARRY IS 0 THEN WE JUST GET 77
        STA (SCREEN,X);PUT CHAR ON SCREEN (X IS ALWAYS 0)
        LDA #7
        CMP SCREEN_ADDR_LO+1
        BNE NNE       ;NNE STANDS FOR "NOT NEAR THE END"
        LDA #231
        CMP SCREEN_ADDR_LO
        BEQ START_SCROLL
NNE     INC SCREEN_ADDR_LO
        LDA #0
        CMP SCREEN_ADDR_LO
        BNE LOOP
        INC SCREEN_ADDR_HI
        LDA #8
        CMP SCREEN_ADDR_HI    ;INCREMENT CHAR POSITION
        BNE LOOP
START_SCROLL
        LDA #$03
        STA SCREEN_ADDR_HI
        LDA #$D7
        STA SCREEN_ADDR_LO ;MOVE CHAR POSITION TO THE START
        LDY #40         
SCROLL
        LDA (SCREEN),Y
        STA (SCREEN,X)     ;MOVE CHAR BACK 40 SPACES
        INC SCREEN_ADDR_LO
        LDA #0
        CMP SCREEN_ADDR_LO
        BNE SCROLL
        INC SCREEN_ADDR_HI
        LDA #8
        CMP SCREEN_ADDR_HI
        BNE SCROLL              ;INCREMENT CHAR POSITION
        LDA #$07
        STA SCREEN_ADDR_HI
        LDA #$98
        STA SCREEN_ADDR_LO
        LDY #$00
        LDA #32
CLEAR   STA (SCREEN),Y
        INY
        CPY #80
        BNE CLEAR               ;CLEAR BOTTOM 2 ROWS
        LDA #$07
        STA SCREEN_ADDR_HI
        LDA #$98
        STA SCREEN_ADDR_LO        ;MOVE CHAR POS TO THE BEGINING OF THE SECOND LAST ROW
        JMP LOOP               ;DO IT ALL OVER AGAIN        
IRQ_CODE
        INC COUNTER
        JMP $EA31


        TEXT'BTM86 WAS HERE!'   ;JUST A LITTLE EASTER EGG :)
        
