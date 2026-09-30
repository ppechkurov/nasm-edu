        global _start
        extern print

        section .bss
        buf resb 10
        buf_size equ $-buf
        count resd 1
        argc resd 1
        argvp resd 1

        section .text
_start:
        pop dword [argc]               ; at the start esp is pointing at the arg count
        mov [argvp], esp               ; addr of args array

        cmp dword [argc], 2
        je .args_count_ok

        mov ebx, 1                     ; exit code 1
        mov eax, 1                     ; exit syscall
        int 80h

.args_count_ok:
        mov esi, [argvp]               ; arg addrs array
        mov edi, [esi+4]               ; file name

        mov eax, 5                     ; sys_open
        mov ebx, edi                   ; path (argv1, already extracted)
        xor ecx, ecx                   ; O_RDONLY = 0
        xor edx, edx                   ; mode: ignored without O_CREAT, zeroed anyway
        int 80h

        cmp eax, 0                     ; err?
        jl .fail

        mov esi, eax                   ; success: fd -> esi
        mov edi, edi                   ; new line count

.reset:
        mov eax, 3                     ; sys_read
        mov ebx, esi                   ; fd
        mov ecx, buf                   ; buf addr
        mov edx, buf_size              ; count
        int 80h

        cmp eax, 0
        jl .fail
        je .done

        mov ecx, eax                   ; bytes read
        xor eax, eax                   ; byte offset
        xor ebx, ebx                   ; new lines counter
.lp:
        jecxz .reset

        cmp [buf+eax], 10              ; new line?
        je .line

        cmp [buf+eax], 0               ; eof?
        je .done

        jmp .next

.line:
        inc dword [count]

.next:
        inc eax
        dec ecx

        jmp .lp

.done:
; TODO: add to string conversion and print here.
; Result is at [count]
        xor ebx, ebx
        jmp .quit

.fail:
        mov ebx, eax                   ; exit code from eax

.quit:
        mov eax, 1                     ; exit syscall
        int 80h
