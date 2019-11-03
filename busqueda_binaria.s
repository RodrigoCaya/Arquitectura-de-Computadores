InFileName: .asciz "input2.txt" @InFileName = "input2.txt"
.align                          @es necesario
InFileHandle:.skip 4            @InFileHandle= darle memoria al archivo
array: .skip 500*4              @saltar 500 veces 4 bytes
s: .asciz "El arreglo es:\n"
text: .asciz "\nLa posicion del K es:\n"
tfin: .asciz "\nEl numero no se encuentra"

    ldr r0,=InFileName          @nombre el archivo que quieres leer
    mov r1,#0                   @seteas a lectura
    swi 0x66                    @abrir el archivo
    ldr r1,=InFileHandle        @cargar el archivo
    str r0,[r1]                 @r0=direccion de r1

    ldr r0,=InFileHandle
    ldr r0,[r0]
    swi 0x6c                    @r0 = n
    mov r2, r0                  @r2 = r0 = n
    mov r3, #0                  @r3 = contador = 0
    mov r5, #4                  @r5 = 4
    mov r6, #1                  @r6 = 1
    ldr r11, =array             @array parte desde r11

    ldr r0, =s
    swi 0x02



arreglo:
    ldr r0,=InFileHandle        @cargar el archivo al input
    ldr r0,[r0]
    swi 0x6c                    @r0 = leer un entero del arreglo

    mov r1,r0                   @r1 = r0
    mul r4, r3, r5              @r4 = r3*4
    str r1, [r11,r4]            @r11[0] = numero en r0
    add r3,r3,r6                @r3 += 1
    cmp r2,r3                   @compara r2 y r3
    bl printarreglo             @voy a printarreglo
    bne arreglo                 @recursividad
    b buscar                    @va a buscar cuando termina



printarreglo:
    mov r0, #1                  @modo salida
    ldr r1, [r11,r4]            @printea arreglo lugar r4
    swi 0x6b                    @printea r0
    mov pc ,lr                  @ vuelve al bl

buscar:
    ldr r0,=InFileHandle        @cargar el archivo al input
    ldr r0,[r0]
    swi 0x6c                    @r0 = k
    mov r2, r0                  @r2 = r0 = k

    mov r12, #0                 @INICIO
    mov r8, #0                  @r8 = 0
    mov r10, #4                 @r10 = 4
    sub r6, r3, #1              @r6 = r3-1 // r6 = FINAL
    mov r9, r3                  @r9 = contador = final

busqueda:
    cmp r9,r8                   @r9 = contador / r8 = 0
    beq fin
    add r1, r6, r12             @FINAL + INICIO
    add r4, r8, r1, asr #1      @r4 = (FINAL + INICIO)/2 = MITAD

    mul r7, r4, r10             @r7 = r4 * 4
    ldr r5, [r11,r7]            @r5 = r11[r7]

    cmp r5, r2                  @r5 = mitad del arreglo / r2 = k
    beq t1
    blt mayor
    bgt menor
    b terminar

mayor:
    add r12, r4, #1             @inicio = mitad + 1
    sub r9, r9, #1              @contador -= 1
    b busqueda

menor:
    sub r6, r4, #1              @final = mitad -1
    sub r9, r9, #1              @contador -= 1
    b busqueda

t1:
    ldr r0, =text
    swi 0x02                    @printea text

    mov r1, r4
    mov r0, #1
    swi 0x6b                    @printea el numero encontrado
    b terminar

fin:
    ldr r0, =tfin
    swi 0x02                    @printea tfin
    b terminar

terminar:
    ldr r0,=InFileHandle
    ldr r0,[r0]
    swi 0x68                    @cierro el input
    swi 0x11                    @termina el programa
