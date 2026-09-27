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
