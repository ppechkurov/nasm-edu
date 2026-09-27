        %include "macros/learn.inc"

        global _start

        section .text
_start:
        mov eax, 10

        switch first, second, third, fourth
        jmp quit

first:
        jmp quit
second:
        jmp quit
third:
        jmp quit
fourth:
        jmp quit
no_label:
        jmp quit
quit:
        xor ebx, ebx
        mov eax, 1                     ; exit syscall
        int 80h
