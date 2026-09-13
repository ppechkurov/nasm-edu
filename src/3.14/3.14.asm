        %include "macros/stud_io.inc"
        global _start

        section .bss
        buf resb 10                    ; unsigned 32-bit int max

        section .text
_start:
        xor ebx, ebx                   ; current word's len
        xor edx, edx                   ; longest word's len
        xor ecx, ecx                   ; counter
lp:
        GETCHAR

        cmp eax, -1
        je quit                        ; eof

        cmp eax, " "
        je done

        cmp eax, 10                    ; \n
        je done

        inc ecx                        ; update len
        jmp lp
done:
        cmp ecx, 0
        je lp                          ; nothing to print

        mov ebx, ecx                   ; capture current word len
        xor ecx, ecx                   ; reset counter
        cmp edx, ebx                   ; compare current word len vs max len
        jg tst                         ; skip if max len > than current len

        mov edx, ebx                   ; update max word len

tst:
        cmp eax, 10                    ; \n
        je print                       ; print if at the end of a line

        jmp lp

print:
        cmp edx, 0
        je quit                        ; nothing to print

        mov ecx, edx                   ; setup counter
        xor edx, edx                   ; reset
        PRINT "max word len: "
max_lp:
        PUTCHAR "*"
        loop max_lp
        PUTCHAR 10

        PRINT "last word len: "
        mov ecx, ebx                   ; setup counter
        xor ebx, ebx

last_lp:
        PUTCHAR "*"
        loop last_lp
        PUTCHAR 10

        jmp _start

quit:
        mov eax, 1                     ; exit syscall
        mov ebx, 0                     ; exit code
        int 80h
