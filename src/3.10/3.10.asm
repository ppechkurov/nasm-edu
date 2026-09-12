        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
        xor ebx, ebx                   ; count +
        xor edx, edx                   ; count -
lp:
        GETCHAR
test:
        cmp eax, -1                    ; eof
        je lp_quit

        cmp eax, 10                    ; new line
        je lp_quit

        cmp al, "+"
        jne minus

        inc ebx
        jmp lp
minus:
        cmp al, "-"
        jne lp

        inc edx
        jmp lp
lp_quit:
        mov eax, ebx                   ; number of +
        mul edx
        mov ecx, eax                   ; setup counter
        jecxz quit                     ; got 0, nothing to print
pr_lp:
        PUTCHAR "*"
        loop pr_lp
quit:
        PUTCHAR 10
        mov eax, 1                     ; exit syscall
        mov ebx, 0                     ; exit code
        int 80h
