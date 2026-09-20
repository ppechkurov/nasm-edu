; to_string (eax=number to convert, ecx=addr of the result str)
; returns nothing, result str is 0-terminated

; %include "macros/stud_io.inc"

to_string:
        push ecx                       ; [esp] save addr of str

        mov edi, ecx                   ; prepare write

        xor edx, edx                   ; prepare div
        mov ebx, 10

        cld

.convert:
        div ebx                        ; modulo -> edx
        mov ecx, eax                   ; save result
        add edx, "0"                   ; to char
        mov eax, edx

        stosb
        jecxz .done

        mov eax, ecx
        xor edx, edx

        jmp .convert

.done:
        xor eax, eax
        stosb                          ; terminate with 0

.reverse:
        pop ebx                        ; restore str addr
        mov esi, ebx                   ; prepare read
        mov edi, ebx                   ; prepare write
        cld

        xor ecx, ecx

.read_lp:
        lodsb
        cmp al, 0
        je .pop
        push eax
        inc ecx
        jmp .read_lp

.pop:
        pop eax
        stosb
        loop .pop

.ret:
        ret
