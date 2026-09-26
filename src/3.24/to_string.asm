; to_string ([ebp+8]=number to convert, [ebp+12]=addr of the result str)

        section .text
divider:
        dd 10

to_string:
        push ebp                       ; CDECL
        mov ebp, esp                   ; save esp

        push edi
        push esi

        mov edi, [ebp+12]              ; prepare write
        xor edx, edx                   ; prepare div

        cld

.convert:
        div dword [divider]            ; modulo -> edx
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
        mov esi, [ebp+12]              ; prepare read
        mov edi, [ebp+12]              ; prepare write
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
        pop esi
        pop edi
        mov esp, ebp                   ; CDECL
        pop ebp                        ; caller's frame back
        ret
