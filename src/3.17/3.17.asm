        %include "macros/stud_io.inc"
        global _start

        section .bss
        buf resb 64

        section .text
_start:
        xor edx, edx                   ; prev char
        xor ecx, ecx
        mov edi, buf

        mov eax, "("                   ; setup buf
        stosb
        xor eax, eax
        mov ecx, 1
lp:
        mov edx, eax                   ; capture prev char
        GETCHAR

        cmp eax, " "                   ; space?
        je space

        cmp eax, -1                    ; eof?
        je done                        ; eof: judge the pending line

        cmp eax, 10                    ; \n?
        je done

        stosb
        inc ecx

        jmp lp
space:
        cmp edx, 0
        je lp                          ; skip leading space

        cmp edx, " "                   ; is prev char space?
        je lp                          ; skip multiple spaces

done:
        mov ebx, eax                   ; keep original char

        mov eax, ")"
        stosb
        inc ecx

        mov esi, buf
p_lp:
        lodsb
        PUTCHAR al
        loop p_lp

        PUTCHAR 10

        cmp ebx, -1                    ; eof?
        je quit

        jmp _start

quit:
        mov eax, 1                     ; exit syscall
        mov ebx, 0                     ; exit code
        int 80h
