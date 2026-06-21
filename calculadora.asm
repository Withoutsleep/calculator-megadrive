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

VDP_CONTROL EQU $00C00004
VDP_DATA    EQU $00C00000

    org $00000000           ; El código empieza en la dirección 0 de la ROM

    dc.l $00FFFE00          ; 1. Dirección inicial de la pila (Stack Pointer)
    dc.l Inicio             ; 2. Dirección donde empieza el programa real

Inicio:
    ; Forzamos el color inmediatamente al arrancar
    move.l #$C0000000,(VDP_CONTROL)  
    move.w #$082A,(VDP_DATA)

BucleInfinito:

    ; RELLENO DE SEGURIDAD:
    ; Los emuladores odian los archivos de menos de 512 bytes. 
    ; Esto rellena con ceros hasta alcanzar un tamaño que RetroArch acepte.
    align 512

    EsperarBoton:

        move.b  #$40,($00A10009) ; Inicializa el mando
        move.b  ($00A10003),d0 ; Lee los botones reales
        andi.b  #%01000000,d0   ; Compara si has tocado el boton A
        beq HacerSuma

        move.b  ($00A10003),d0 ; Lee los botones reales
        andi.b  #%00000001,d0   ; Compara si has tocado el boton UP
        beq SubirNumero

        move.b ($00A10003),d0 ; Lee los botones reales
        andi.b  #%00000010,d0  ; Comprueba si has tocado el boton DOWN
        beq BajarNumero

        move.b ($00A10003),d0 ; Lee los botones reales
        andi.b  #%00000100,d0  ; Comprueba si has tocado el boton LEFT
        beq IzquierdearNumero

        move.b ($00A10003),d0 ; Lee los botones reales
        andi.b  #%00001000,d0  ; Comprueba si has tocado el boton RIGHT
        beq DerechearNumero

        bra EsperarBoton  ; Repite el ciclo

    SubirNumero:
        addq.w #1,($00FF0010)

    EsperarASoltarLaUP:
        move.b  ($00A10003),d0        ; Lee los botones 
        andi.b  #%00000001,d0
        beq EsperarASoltarLaUP
        bra.s EsperarBoton

    BajarNumero:
        subq.w #1,($00FF0010)

    EsperarASoltarLaDOWN:
        move.b  ($00A10003),d0        ; Lee los botones 
        andi.b  #%00000010,d0
        beq EsperarASoltarLaDOWN
        bra.s EsperarBoton

    IzquierdearNumero:
        subq.w #1,($00FF0012)

    EsperarAsoltarLaLEFT:
        move.b  ($00A10003),d0        ; Lee los botones 
        andi.b  #%00000100,d0
        beq EsperarAsoltarLaLEFT
        bra EsperarBoton

    DerechearNumero:
        addq.w #1,($00FF0012)

    EsperarAsoltarLaRIGHT:
        move.b  ($00A10003),d0        ; Lee los botones 
        andi.b  #%00000100,d0
        beq EsperarAsoltarLaRIGHT
        bra EsperarBoton

    HacerSuma:
        move.l #$C0000000,(VDP_CONTROL)  ; Es necesario llamar a esta funcion para poder "activar" el canal de control
        move.w  #$082A,(VDP_DATA)
        move.w ($00FF0010),d0
        move.w ($00FF0012),d1
        add.w d0,d1
        move.w d1,($00FF0000)

    EsperarASoltarLaA:
        move.b  ($00A10003),d0        ; Lee los botones 
        andi.b  #%01000000,d0
        beq EsperarASoltarLaA
        bne EsperarBoton

    FinDelPrograma:
        bra.s FinDelPrograma ; Bucle final
bra BucleInfinito     ; Evitamos que el procesador siga leyendo vacío