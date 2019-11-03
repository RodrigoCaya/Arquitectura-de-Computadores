InFileName: .asciz "input1.txt"
.align
InFileHandle:.word 0

    ldr r0,=InFileName              @nombre el archivo que quieres leer
    mov r1,#0                       @seteas a lectura
    swi 0x66                        @abrir el archivo
    ldr r1,=InFileHandle
    str r0,[r1]

    ldr r0,=InFileHandle
    ldr r0,[r0]
    swi 0x6c                        @r0 = numero

    mov r1, #1                      @r1 = 1
    cmp r0,r1                       @comparar r1 con r0
    beq print

    mov r1, #2                      @r1 = 2
    cmp r0,r1                       @comparar r1 con r0
    beq print

    mov r1, #6                      @r1 = 6
    cmp r0,r1                       @comparar r1 con r0
    moveq r0, #3                    @r0 = 3 para printear
    beq print

    mov r1, #24                     @r1 = 24
    cmp r0,r1                       @comparar r1 con r0
    moveq r0, #4                    @r0 = 4 para printear
    beq print

    mov r1, #120                    @r1 = 120
    cmp r0,r1                       @comparar r1 con r0
    moveq r0, #5                    @r0 = 5 para printear
    beq print

    ldr r0, =s
    swi 0x02                        @printear
    s: .asciz "No es un número factorial.\n"

    swi 0x11                        @terminar el programa

    print:
    mov r1, r0
    mov r0, #1
    swi 0x6b                        @printear r0
    swi 0x11                        @terminar el programa
