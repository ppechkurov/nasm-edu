        %include "src/3.24/read.asm"
        global _start

        section .bss
        buf resb 10

        section .text
_start:
        mov eax, buf
        mov ecx, 5
        call read                      ; error code -> ecx
        jecxz .clean
        jmp .err
.clean:
        xor ebx, ebx
        jmp quit
.err:
        mov ebx, ecx                   ; exit code
quit:
        mov eax, 1                     ; exit syscall
        int 80h
