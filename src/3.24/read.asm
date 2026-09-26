; read a string at addr up to len (eax=address of a string, ecx=len)
; returns (ebx=read len, ecx=error code)

        %include "macros/stud_io.inc"

read:
        push eax                       ; [esp] initial str addr
        cmp ecx, 0
        je .return                     ; len=0

        mov edi, eax                   ; prepare write
        mov ebx, ecx                   ; keep scan len in ebx

        xor eax, eax                   ; char
        xor ecx, ecx                   ; scanned

.read_lp:
        GETCHAR

        cmp al, "0"
        jl .not_digit

        cmp al, "9"
        jg .not_digit

.put:
        stosb
        inc ecx

.check:
        cmp ebx, ecx
        jle .return
        jmp .read_lp

.not_digit:
        mov ebx, ecx                   ; read len -> ebx
        mov ecx, eax                   ; char as error code

.return:
        mov [edi+1], 0                 ; finish str
        pop eax                        ; restore eax
        ret
