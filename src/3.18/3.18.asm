        %include "macros/stud_io.inc"
        global _start

        section .bss
        buf resb 64

        section .text
_start:
        xor eax, eax
        xor ecx, ecx
        mov edi, buf
        cld
lp:
        GETCHAR

        cmp eax, -1                    ; eof?
        je done                        ; eof: judge the pending line

        cmp eax, "0"                   ; \n?
        jl done

        cmp eax, "9"                   ; \n?
        jg done

        stosb
        inc ecx

        jmp lp

done:
        cmp ecx, 0
        je quit                        ; nothing to print?

        mov esi, buf
        xor ebx, ebx                   ; accumulated number here
        xor ecx, ecx                   ; intermidiate results
        xor eax, eax                   ; clean up
        mov edx, 10                    ; multiplier
read:
        lodsb
        cmp al, 0
        je r_done

        sub al, "0"                    ; char to digit

        mov ecx, eax                   ; save eax
        mov eax, ebx                   ; load accumulated
        mul dl                         ; x10

        add eax, ecx                   ; add digit to multiplied
        mov ebx, eax                   ; update accumulated
        xor eax, eax                   ; reset eax

        jmp read

r_done:
        mov ecx, ebx
        jecxz quit
t_lp:
        PUTCHAR "*"
        loop t_lp
        PUTCHAR 10

quit:
        mov eax, 1                     ; exit syscall
        mov ebx, 0                     ; exit code
        int 80h
