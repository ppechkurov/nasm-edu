%include "macros/stud_io.inc"

global _start
extern to_string
extern to_number

section .data
ten:        db 10
str:        db "1234", 0

section .bss
array       resb 10

section .text
_start:     xor eax, eax

            push dword str
            call to_number
            add esp, 4

            push eax
            call to_string
            add esp, 4

            mov esi, eax
            cld

.print      lodsb
            cmp al, 0
            je quit

            PUTCHAR al
            loop .print

quit:       mov ebx, 0                          ; success
            mov eax, 1                          ; _exit
            int 80h
