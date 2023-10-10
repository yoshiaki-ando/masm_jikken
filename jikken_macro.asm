    .const
    CHK_CF dd 1
    SHIFT_CF db 0
    
    CHK_PF dd 4
    SHIFT_PF db 2

    CHK_ZF dd 64
    SHIFT_ZF db 6

    CHK_SF dd 128
    SHIFT_SF db 7

    CHK_OF dd 2048
    SHIFT_OF db 11

    MASK16 dd 0000FFFFh
    MASK8  dd 000000FFh
    MASK8h dd 0000FF00h

    .data
    format_flag db "CF = %d , PF = %d , ZF = %d , SF = %d , OF = %d", 13, 10, 0
    format_register db "EAX = %d, EBX = %d, ECX = %d, EDX = %d, ESI = %d, EDI = %d, ESP = %d, EBP = %d", 13, 10, 0
    format_registerh db "EAX = %08X, EBX = %08X, ECX = %08X, EDX = %08X, ESI = %08X, EDI = %08X, ESP = %08X, EBP = %08X", 13, 10, 0
    format_register16 db "AX = %d, BX = %d, CX = %d, DX = %d, SI = %d, DI = %d, SP = %d, BP = %d", 13, 10, 0
    format_register16h db "AX = %04X, BX = %04X, CX = %04X, DX = %04X, SI = %04X, DI = %04X, SP = %04X, BP = %04X", 13, 10, 0
    format_register8 db "AL = %d, AH = %d, BL = %d, BH = %d, CL = %d, CH = %d, DL = %d, DH = %d", 13, 10, 0
    format_register8h db "AL = %02X, AH = %02X, BL = %02X, BH = %02X, CL = %02X, CH = %02X, DL = %02X, DH = %02X", 13, 10, 0
    format_register8b db "AL = %s, AH = %s, BL = %s, BH = %s, CL = %s, CH = %s, DL = %s, DH = %s", 13, 10, 0

    str_al db '00000000', 0
    str_ah db '00000000', 0
    str_bl db '00000000', 0
    str_bh db '00000000', 0
    str_cl db '00000000', 0
    str_ch db '00000000', 0
    str_dl db '00000000', 0
    str_dh db '00000000', 0

    .data?
    zero_flag dd ?
    sign_flag dd ?
    carry_flag dd ?
    parity_flag dd ?
    overflow_flag dd ?

    register_eax    dd  ?
    register_ebx    dd  ?
    register_ecx    dd  ?
    register_edx    dd  ?
    register_esi    dd  ?
    register_edi    dd  ?
    register_esp    dd  ?
    register_ebp    dd  ?

    register_ax    dd  ?
    register_bx    dd  ?
    register_cx    dd  ?
    register_dx    dd  ?
    register_si    dd  ?
    register_di    dd  ?
    register_sp    dd  ?
    register_bp    dd  ?

    register_al    dd  ?
    register_bl    dd  ?
    register_cl    dd  ?
    register_dl    dd  ?
    register_ah    dd  ?
    register_bh    dd  ?
    register_ch    dd  ?
    register_dh    dd  ?

    .code
save_register MACRO
    mov register_eax, eax
    mov register_ebx, ebx
    mov register_ecx, ecx
    mov register_edx, edx
    mov register_esi, esi
    mov register_edi, edi
    mov register_esp, esp
    mov register_ebp, ebp
ENDM

save_register16 MACRO
    mov register_ax, eax
    mov register_bx, ebx
    mov register_cx, ecx
    mov register_dx, edx
    mov register_si, esi
    mov register_di, edi
    mov register_sp, esp
    mov register_bp, ebp

    mov eax, register_ax
    and eax, MASK16
    mov register_ax, eax

    mov eax, register_bx
    and eax, MASK16
    mov register_bx, eax

    mov eax, register_cx
    and eax, MASK16
    mov register_cx, eax

    mov eax, register_dx
    and eax, MASK16
    mov register_dx, eax

    mov eax, register_si
    and eax, MASK16
    mov register_si, eax

    mov eax, register_di
    and eax, MASK16
    mov register_di, eax

    mov eax, register_sp
    and eax, MASK16
    mov register_sp, eax

    mov eax, register_bp
    and eax, MASK16
    mov register_bp, eax
ENDM

save_register8 MACRO
    mov register_al, eax
    mov register_bl, ebx
    mov register_cl, ecx
    mov register_dl, edx
    mov register_ah, eax
    mov register_bh, ebx
    mov register_ch, ecx
    mov register_dh, edx

    mov eax, register_al
    and eax, MASK8
    mov register_al, eax

    mov eax, register_bl
    and eax, MASK8
    mov register_bl, eax

    mov eax, register_cl
    and eax, MASK8
    mov register_cl, eax

    mov eax, register_dl
    and eax, MASK8
    mov register_dl, eax

    mov eax, register_ah
    and eax, MASK8h
    shr eax, 8
    mov register_ah, eax

    mov eax, register_bh
    and eax, MASK8h
    shr eax, 8
    mov register_bh, eax

    mov eax, register_ch
    and eax, MASK8h
    shr eax, 8
    mov register_ch, eax

    mov eax, register_dh
    and eax, MASK8h
    shr eax, 8
    mov register_dh, eax
ENDM

; al に 0/1 文字列にする値を入れる
; edx に文字列のアドレスを入れる
makestr8bin MACRO
    LOCAL for_loop

    add edx, 8 ; アドレスの後ろから 0/1 を入れていく

    mov ecx, 0 ; カウンタ
for_loop:
    mov bl, al
    shr bl, cl ; シフトする
    and bl, 1 ; 下位1ビットのみ取り出す
    sub edx, 1 ; 一つずつ前のアドレスに行く
    add byte ptr [edx], bl ; 0か1を足す (1を足すと、文字列 '1'になる)

    add cl, 1 ; カウンタ増分
    cmp cl, 8 ; 終了判定
    jnz for_loop
ENDM

;; 1バイトレジスタのリセット
; edx に文字列のアドレスを入れる
resetstr8bin MACRO
    LOCAL reset_loop
    
    mov cl, 0
reset_loop:
    mov byte ptr [edx], '0'
    add edx, 1
    add cl, 1
    cmp cl, 8
    jl reset_loop
ENDM


dump_register8b MACRO
    pushfd
    pushad
    save_register8

    mov eax, register_al
    mov edx, OFFSET str_al
    makestr8bin
    
    mov eax, register_ah
    mov edx, OFFSET str_ah
    makestr8bin
    
    mov eax, register_bl
    mov edx, OFFSET str_bl
    makestr8bin
    
    mov eax, register_bh
    mov edx, OFFSET str_bh
    makestr8bin
    
    mov eax, register_cl
    mov edx, OFFSET str_cl
    makestr8bin
    
    mov eax, register_ch
    mov edx, OFFSET str_ch
    makestr8bin
    
    mov eax, register_dl
    mov edx, OFFSET str_dl
    makestr8bin
    
    mov eax, register_dh
    mov edx, OFFSET str_dh
    makestr8bin
    
    invoke crt_printf, OFFSET format_register8b, OFFSET str_al, OFFSET str_ah, OFFSET str_bl, OFFSET str_bh, OFFSET str_cl, OFFSET str_ch, OFFSET str_dl, OFFSET str_dh

	; 文字列をリセットする
    mov edx, OFFSET str_al
    resetstr8bin
    mov edx, OFFSET str_ah
    resetstr8bin
    mov edx, OFFSET str_bl
    resetstr8bin
    mov edx, OFFSET str_bh
    resetstr8bin
    mov edx, OFFSET str_cl
    resetstr8bin
    mov edx, OFFSET str_ch
    resetstr8bin
    mov edx, OFFSET str_dl
    resetstr8bin
    mov edx, OFFSET str_dh
    resetstr8bin
    popad
    popfd
ENDM

dump_register8 MACRO
    pushfd
    pushad
    save_register8
    invoke crt_printf, OFFSET format_register8, register_al, register_ah, register_bl, register_bh, register_cl, register_ch, register_dl, register_dh
    popad
    popfd
ENDM

dump_register8h MACRO
    pushfd
    pushad
    save_register8
    invoke crt_printf, OFFSET format_register8h, register_al, register_ah, register_bl, register_bh, register_cl, register_ch, register_dl, register_dh
    popad
    popfd
ENDM


dump_register16 MACRO
    pushfd
    pushad
    save_register16
    invoke crt_printf, OFFSET format_register16, register_ax, register_bx, register_cx, register_dx, register_si, register_di, register_sp, register_bp
    popad
    popfd
ENDM

dump_register16h MACRO
    pushfd
    pushad
    save_register16
    invoke crt_printf, OFFSET format_register16h, register_ax, register_bx, register_cx, register_dx, register_si, register_di, register_sp, register_bp
    popad
    popfd
ENDM

dump_register MACRO
    pushfd
    save_register
    pushad
    invoke crt_printf, OFFSET format_register, register_eax, register_ebx, register_ecx, register_edx, register_esi, register_edi, register_esp, register_ebp
    popad
    popfd
ENDM

dump_registerh MACRO
    pushfd
    save_register
    pushad
    invoke crt_printf, OFFSET format_registerh, register_eax, register_ebx, register_ecx, register_edx, register_esi, register_edi, register_esp, register_ebp
    popad
    popfd
ENDM

dump_flag MACRO
    pushad
    pushfd
    pop eax

    ; Carry flag
    mov ebx, eax
    and ebx, CHK_CF
    mov cl, SHIFT_CF
    shr ebx, cl
    mov carry_flag, ebx

    ; Parity flag
    mov ebx, eax
    and ebx, CHK_PF
    mov cl, SHIFT_PF
    shr ebx, cl
    mov parity_flag, ebx

    ; Zero flag
    mov ebx, eax
    and ebx, CHK_ZF
    mov cl, SHIFT_ZF
    shr ebx, cl
    mov zero_flag, ebx
  
    ; Sign flag
    mov ebx, eax
    and ebx, CHK_SF
    mov cl, SHIFT_SF
    shr ebx, cl
    mov sign_flag, ebx
  
    ; Overflow flag
    mov ebx, eax
    and ebx, CHK_OF
    mov cl, SHIFT_OF
    shr ebx, cl
    mov overflow_flag, ebx
  
;    print str$(eax)
;    print OFFSET format
    push eax
    invoke crt_printf, offset format_flag, carry_flag, parity_flag, zero_flag, sign_flag, overflow_flag
    popfd
    popad
ENDM
