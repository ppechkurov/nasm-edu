        global _start

        extern strlen
        %define argv1 esp+8
        %define argv2 esp+12

        section .bss
        argc resd 1

        section .text

_start:
        mov eax, [esp]
        sub eax, 1                     ; skip prog name
        mov dword [argc], eax          ; save argc

        xor ebx, ebx                   ; exit code 0 by default

        cmp [argc], 2                  ; two args?
        jne .fail                      ; fail if not

        push dword [argv1]
        call strlen                    ; len -> eax
        add esp, 4
        mov esi, eax                   ; keep len1

        push dword [argv2]
        call strlen                    ; len -> eax
        add esp, 4
        mov edi, eax                   ; keep len2

        cmp esi, edi                   ; len1 vs len2
        je .quit                       ; ok

        mov eax, [argv1]               ; string base
        mov al, [eax+esi-1]            ; last byte, full len in esi

        mov ecx, [argv2]               ; string base
        mov cl, [ecx+edi-1]            ; last byte, full len in edi

        cmp al, cl
        je .quit

.fail:
        mov ebx, 1                     ; exit code 1
.quit:
        mov eax, 1                     ; exit syscall
        int 80h
