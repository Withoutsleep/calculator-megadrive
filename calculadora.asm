; =========================================================================
; |           Calculadora, proyecto de prueba de withoutsleep_dev          |
; =========================================================================

VDP_CONTROL EQU $00C00004
VDP_DATA    EQU $00C00000

    org $00000000           ; El código empieza en la dirección 0 de la ROM  ; Para resumir un poco, todo esto es la mierda de la cabezera, sino, no funciona y te jodes xd (me cago en todo)

    dc.l $00FFFE00          ; 1. Dirección inicial de la pila (Stack Pointer)
    dc.l Inicio             ; 2. Dirección donde empieza el programa real

Inicio:
    ; PRUEBA DE COLOR: Forzamos pantalla morada inmediatamente al arrancar
    move.l #$C0000000,(VDP_CONTROL)  
    move.w #$082A,(VDP_DATA)

    ; Inicializamos las variables de la calculadora en la RAM
    move.w #0,($00FF0010)   ; Primer número
    move.w #0,($00FF0012)   ; Segundo número

    move.b  #$40,($00A10009) ; Inicializa el mando

BucleEspera:
    dbra d7,BucleEspera

EsperarBoton:

    nop
    nop
    move.b  ($00A10003),d0   ; Lee los botones reales
    andi.b  #%01000000,d0    ; Compara si has tocado el boton A
    beq     HacerSuma

    move.b  ($00A10003),d0 
    andi.b  #%00000001,d0    ; Boton UP
    beq     SubirNumero

    move.b  ($00A10003),d0 
    andi.b  #%00000010,d0    ; Boton DOWN
    beq     BajarNumero

    move.b  ($00A10003),d0 
    andi.b  #%00000100,d0    ; Boton LEFT
    beq     IzquierdearNumero

    move.b  ($00A10003),d0 
    andi.b  #%00001000,d0    ; Boton RIGHT
    beq     DerechearNumero

    bra     EsperarBoton     ; Repite el ciclo

SubirNumero:
    addq.w  #1,($00FF0010)

EsperarASoltarLaUP:
    move.b  ($00A10003),d0   
    andi.b  #%00000001,d0
    beq     EsperarASoltarLaUP
    bra     EsperarBoton

BajarNumero:
    subq.w  #1,($00FF0010)

EsperarASoltarLaDOWN:
    move.b  ($00A10003),d0   
    andi.b  #%00000010,d0
    beq     EsperarASoltarLaDOWN
    bra     EsperarBoton

IzquierdearNumero:
    subq.w  #1,($00FF0012)

EsperarAsoltarLaLEFT:
    move.b  ($00A10003),d0   
    andi.b  #%00000100,d0
    beq     EsperarAsoltarLaLEFT
    bra     EsperarBoton

DerechearNumero:
    addq.w  #1,($00FF0012)

EsperarAsoltarLaRIGHT:
    move.b  ($00A10003),d0   
    andi.b  #%00001000,d0    ; Corregido a bit de RIGHT
    beq     EsperarAsoltarLaRIGHT
    bra     EsperarBoton

HacerSuma:
    move.l  #$C0000000,(VDP_CONTROL)  
    move.w  #$00A0,(VDP_DATA)
    move.w  ($00FF0010),d0
    move.w  ($00FF0012),d1
    add.w   d0,d1
    move.w  d1,($00FF0000)

EsperarASoltarLaA:
    move.b  ($00A10003),d0   
    andi.b  #%01000000,d0
    beq     EsperarASoltarLaA
    bra     EsperarBoton     ; Regresa al menú siempre

FinDelPrograma:
    bra.s   FinDelPrograma   ; Bucle muerto por si acaso

; =========================================================================
; |                             RELLENO XD                                |
; =========================================================================
    org     $00000200        ; Fuerza al archivo a medir 512 bytes, ni uno mas, ni uno menos
    dc.b    0                ; Un byte de cierre