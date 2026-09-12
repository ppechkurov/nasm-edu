        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
        xor ecx, ecx                   ; setup counter
lp:
        GETCHAR

        cmp eax, -1
        je done                        ; eof

        cmp eax, 10
        je done
count:
        inc ecx
        jmp lp
done:
        jecxz quit                     ; nothing to print
print:
        PUTCHAR "*"
        loop print
        PUTCHAR 10
        jmp _start
quit:
        mov eax, 1                     ; exit syscall
        mov ebx, 0                     ; exit code
        int 80h
