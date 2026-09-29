        global _start

        extern strlen
        extern print

        %define argc ebp
        %define arg ebp+8              ; first arg addr
        %define cur_arg_addr arg+esi*4

        section .text
_start:
        mov ebp, esp

        mov edi, [argc]                ; argc -> edi
        dec edi                        ; skip prog name
        cmp edi, 0
        je .fail                       ; no args, skipping

        xor ebx, ebx                   ; longest arg addr
        xor esi, esi                   ; args offset -> esi

.lp:
        mov eax, [cur_arg_addr]        ; current arg addr

        push eax
        call strlen                    ; len -> eax
        add esp, 4

        cmp eax, ebx
        jl .again
        mov ebx, eax                   ; update max len
        push dword [cur_arg_addr]      ; save longest arg

.again:
        dec edi
        inc esi

        cmp edi, 0                     ; last arg?
        je .print

        jmp .lp

.print:
        call print                     ; here we should have longest address
        add esp, 4

        cmp eax, 0                     ; print error?
        jl .fail

        xor ebx, ebx                   ; exit code 0
        jmp .quit

.fail:
        mov ebx, eax                   ; exit code from print
.quit:
        mov eax, 1                     ; exit syscall
        int 80h
