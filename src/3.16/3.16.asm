        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
        xor eax, eax                   ; reset eax
        xor ebx, ebx                   ; space count
        xor edx, edx                   ; prev char
lp:
        mov edx, eax                   ; capture prev char
        GETCHAR

        cmp eax, " "                   ; space?
        je space

        cmp eax, -1                    ; eof?
        je done                        ; eof: judge the pending line

        cmp eax, 10                    ; \n?
        je done

        jmp lp
space:
        cmp edx, 0
        je lp                          ; skip leading space

        cmp edx, " "                   ; is prev char space?
        je lp                          ; skip multiple spaces

        inc ebx
        jmp lp
done:
        cmp edx, " "                   ; is prev char space?
        je prep
        inc ebx                        ; prev char is not a space - +1 word
prep:
        mov ecx, ebx
        jecxz quit

p_lp:
        PUTCHAR "*"
        loop p_lp
        PUTCHAR 10

        cmp eax, -1                    ; eof?
        je quit

        jmp _start

quit:
        mov eax, 1                     ; exit syscall
        mov ebx, 0                     ; exit code
        int 80h
