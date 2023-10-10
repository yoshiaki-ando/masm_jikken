        include masm32rt.inc
        include jikken_macro.asm

        .data?
var1    dd ?

        .data
var2    db  80h
var3    dd  123456789
fmt     db  'result = %d', 13, 10, 0

        .const
C1      equ 1000

        .code
start:
        dump_register
        dump_registerh
        dump_register16h
        dump_register8h
        mov var1, 987654321
        mov eax, 0
        mov ebx, 0
        dump_register

        mov ah, var2
        mov bx, C1
        mov ecx, var3
        mov edx, var1
        dump_register8
        dump_register16
        dump_register

        sub edx, ecx
        dump_register
        invoke crt_printf, OFFSET fmt, edx
        dump_register

        exit
end start