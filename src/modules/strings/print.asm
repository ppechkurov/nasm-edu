; print a string starting at address ([ebp+8]=address of a string to print)
; returns len=eax

        global print
        extern strlen

        %define str_addr ebp+8

print:
        push ebp                       ; CDECL
        mov ebp, esp

        push esi                       ; len
        push ebx                       ; fd

        push dword [str_addr]          ; arg
        call strlen
        add esp, 4

        cmp eax, 0
        je .quit

        mov esi, eax                   ; save len

.write:
        mov eax, 4                     ; write syscall
        mov ebx, 1                     ; stdout
        mov ecx, [str_addr]            ; addr
        mov edx, esi                   ; len
        int 80h

        cmp eax, 0
        jl .quit                       ; error -> eax

.success:
        mov eax, esi                   ; return print len

.quit:
        pop ebx
        pop esi
        mov esp, ebp                   ; CDECL
        pop ebp
        ret
