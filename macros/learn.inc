        %macro pcall1 2

        push dword %2
        call %1
        add esp, 4

        %endmacro

; fill macro
        %macro fill 3

        %assign init %1
        %assign step %2
        %assign count %3
        %assign n init

        section .bss
        buf resd count

        section .text
        mov ecx, buf

        %rep count
        mov dword [ecx], n
        add ecx, 4
        %assign n n + step
        %endrep

        %endmacro

; switch macro
        %macro switch 1-*

        %assign n 1

        %rep %0
        cmp eax, n
        je %1
        %assign n n + 1
        %rotate 1
        %endrep

        jmp no_label

        %endmacro

; convert macro
        %macro convert 1

        section .text
        jmp %%start                    ; need to jump over definitions
%%lit:
        db %1, 0
        lit_len equ $-%%lit

        section .bss
        %%buf resd lit_len

        section .text
%%start:
        push esi
        push edi

        mov esi, %%lit
        mov edi, %%buf
        xor eax, eax
        cld

.lp:
        lodsb
        stosd

        cmp al, 0
        jne .lp

.quit:
        pop edi
        pop esi
        %endmacro
