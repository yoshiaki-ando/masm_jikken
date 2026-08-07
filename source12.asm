; 文字列中の大文字と 小文字の変換
    include masm32rt.inc
    include jikken_macro.asm
    
    .data
    msg db 'MASMjikken', 13, 10, 0; 変換する 文字列
    .code

start:
    mov eax, OFFSET msg; 文字列の先頭ア ド レ ス を EAX に 保存


change_case:
    cmp BYTE PTR [eax], 13        ; 現在の文字を復帰コードと比較
    je change_end                 ; 復帰コ ードなら変換を終了
    xor BYTE PTR [eax], 00100000b ; 大文字と小文字を変換
    add eax, 1                    ; 次の文字のアドレスへ移動
    jmp change_case               ; 次の文字を変換
change_end:
    invoke crt_printf, OFFSET msg ; 変換後の文字列を表示
    exit
end start
