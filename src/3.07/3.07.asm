        %include "macros/stud_io.inc"
        global _start

_start:
        xor eax, eax
        PRINT "input a char: "
; read ONLY ONE char into eax. rest are buffered and printed to a shell.
; read all buffered input if you care
        GETCHAR
compare:
        cmp al, -1                     ; eof
        je eof

        cmp al, 'A'
        jne no

        PRINT "YES"
        PUTCHAR 10
        mov ebx, 0                     ; success
        jmp quit
eof:
        PRINT "EOF"
err:
        mov ebx, 1                     ; exit code
        jmp quit
no:
        mov ebx, 1                     ; exit code
        PRINT "NO"
quit:
        PUTCHAR 10
        mov eax, 1                     ; exit
        int 80h
