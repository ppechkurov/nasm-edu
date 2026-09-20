        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
        xor eax, eax                   ; current char
        xor ecx, ecx                   ; counter

read:
        GETCHAR

        cmp eax, -1                    ; eof?
        je .eof

        cmp eax, 10                    ; \n?
        je print

        push eax
        inc ecx

        jmp read

.eof:
        PUTCHAR 10
        mov ebx, eax                   ; save GETCHAR return value

print:
        jecxz read_all
.lp:
        pop eax
        PUTCHAR al
        loop .lp
        mov eax, ebx                   ; restore originar GETCHAR return value

read_all:
        cmp eax, -1
        je .done

        cmp eax, 10
        je .done

        GETCHAR                        ; read all stdin
        jmp read_all
.done:
        nop

quit:
        PUTCHAR 10
        mov eax, 1                     ; exit syscall
        int 80h
