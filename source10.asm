        include masm32rt.inc
        include jikken_macro.asm

        .code

sum_eaxebx proc
        mov ecx, eax
        add ecx, ebx
        ret
sum_eaxebx endp

start:
        mov eax, 5
        mov ebx, 7
        call sum_eaxebx
        dump_register
        exit
end start
