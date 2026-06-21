;  =========================================================================
; |           Calculadora, proyecto de prueba de withoutsleep_dev          |
;  =========================================================================

;  =========================================================================
; |                Lista de botones de la Sega Mega Drive                  |
; |------------------------------------------------------------------------|
; |       A       |            #%01000000                                  |
; |       B       |            #%00010000                                  |
; |       C       |            #%00100000                                  |
;  =========================================================================

VDP_CONTROL EQU $00C00004   ; Esto se utiliza para poder llamar de un determinado nombre una direccion en la memoria
VDP_DATA    EQU $00C00000   

move.w #0, ($00FF0010) ; Aqui dejaré el primer numero (que de momento es 30 pero a futuro se podra cambiar) ;Para restaurar los numeros
move.w #0, ($00FF0012) ; Aqui el segundo numero

EsperarBoton:

    move.b  #$40,($00A10009) ; Inicializa el mando
    move.b  ($00A10003),d0 ; Lee los botones reales
    andi.b  #%01000000,d0   ; Compara si has tocado el boton A
    beq.s HacerSuma

    move.b  ($00A10003),d0 ; Lee los botones reales
    andi.b  #%00010000,d0   ; Compara si has tocado el boton B
    beq.s HacerResta

    move.b  ($00A10003),d0 ; Lee los botones reales
    andi.b  #%00100000,d0   ; Compara si has tocado el boton C
    beq.s HacerMultiplicacion

    move.b  ($00A10003),d0 ; Lee los botones reales
    andi.b  #%00000001,d0   ; Compara si has tocado el boton UP
    beq.s SubirNumero

    move.b ($00A10003),d0 ; Lee los botones reales
    andi.b  #%00000010,d0  ; Comprueba si has tocado el boton DOWN
    beq.s BajarNumero

    move.b ($00A10003),d0 ; Lee los botones reales
    andi.b  #%00000100,d0  ; Comprueba si has tocado el boton LEFT
    beq.s IzquierdearNumero

    move.b ($00A10003),d0 ; Lee los botones reales
    andi.b  #%00001000,d0  ; Comprueba si has tocado el boton RIGHT
    beq.s DerechearNumero

    bra.s EsperarBoton  ; Repite el ciclo

SubirNumero:
    addq.w #1, ($00FF0010)

EsperarASoltarLaUP:
    move.b  ($00A10003),d0        ; Lee los botones 
    andi.b  #%00000001,d0
    beq.s EsperarASoltarLaUP
    bra.s EsperarBoton

BajarNumero:
    subq.w #1, ($00FF0010)

EsperarAsoltarLaDOWN:
    move.b  ($00A10003),d0        ; Lee los botones 
    andi.b  #%00000010,d0
    beq.s EsperarASoltarLaDOWN
    bra.s EsperarBoton

IzquierdearNumero:
    subq.w #1, ($00FF0012)

EsperarAsoltarLaLEFT:
    move.b  ($00A10003),d0        ; Lee los botones 
    andi.b  #%00000100,d0
    beq.s EsperarAsoltarLaLEFT
    bra.s EsperarBoton

DerechearNumero:
    addq.w #1, ($00FF0012)

EsperarAsoltarLaLEFT:
    move.b  ($00A10003),d0        ; Lee los botones 
    andi.b  #%00000100,d0
    beq.s EsperarAsoltarLaRIGHT
    bra.s EsperarBoton

HacerSuma:
    move.l #$C0000000, (VDP_CONTROL)  ; Es necesario llamar a esta funcion para poder "activar" el canal de control
    move.w  #$082A, (VDP_DATA)
    move.w ($00FF0010),d0
    move.w ($00FF0012),d1
    add.w d0,d1
    move.w d1,($00FF0000)

EsperarASoltarLaA:
    move.b  ($00A10003),d0        ; Lee los botones 
    andi.b  #%01000000,d0
    beq.s EsperarASoltarLaA
    bne.s EsperarBoton

HacerResta:
    move.w #30,d0
    move.w #20,d1
    sub.w d0, d1
    move.w d1,($00FF0000)
    bra.s FinDelPrograma

HacerMultiplicacion:
    move.w #30,d0
    move.w #20,d1
    mulu.w d0,d1
    move.w d1,($00FF0000)

FinDelPrograma:
    bra.s FinDelPrograma ; Bucle final