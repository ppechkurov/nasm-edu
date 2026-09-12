        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
        xor eax, eax
        PRINT "input a digit: "
; read ONLY ONE char into eax. rest are buffered and printed to a shell.
; read all buffered input if you care
        GETCHAR
compare:
        cmp al, -1                     ; eof
        je eof

        cmp al, '0'                    ; ascii 0
        jl err

        cmp al, '9'                    ; ascii 9
        jg err

        mov ebx, 0                     ; prepare success exit

        xor ecx, ecx                   ; prepare a counter
        mov cl, al
        sub cl, '0'                    ; convert to a decimal

        jecxz quit                     ; got 0 - don't need print
lp:
        PUTCHAR '*'
        loop lp

        jmp quit
eof:
        PRINT "EOF"
        mov ebx, 1                     ; exit code
        jmp quit
err:
        PRINT "ERR"
        mov ebx, 1                     ; exit code
        jmp quit
quit:
        PUTCHAR 10
        mov eax, 1                     ; exit
        int 80h
