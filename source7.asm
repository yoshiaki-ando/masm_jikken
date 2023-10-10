    include masm32rt.inc
    include jikken_macro.asm

    .data
str_plus    db "EAX > EBX", 13, 10, 0
str_minus   db "EAX < EBX", 13, 10, 0
str_equal   db "EAX = EBX", 13, 10, 0

    .code
start:
    mov eax, 5
    mov ebx, 7
    sub eax, ebx
    jz equal_res
    js minus_res
    invoke crt_printf, OFFSET str_plus
    jmp shuryo

equal_res:
    invoke crt_printf, OFFSET str_equal
    jmp shuryo

minus_res:
    invoke crt_printf, OFFSET str_minus

shuryo:
    exit
end start