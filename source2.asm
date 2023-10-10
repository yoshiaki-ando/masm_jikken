        include masm32rt.inc
        include jikken_macro.asm

        .code
start:
        mov al, 5
        mov ah, 3
        sub ah, al
        dump_register8
        dump_flag

        mov bl, 127
        mov bh, 127
        add bl, bh
        dump_register8
        dump_flag

        exit
end start