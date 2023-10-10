        include masm32rt.inc
        include jikken_macro.asm

        .const
i_max   equ  100

        .code
start:
        mov eax, 0
        mov ecx, 0

loop1:
        add ecx, 1
        add eax, ecx
        cmp ecx, i_max
        jl loop1

        dump_register
        exit
end start