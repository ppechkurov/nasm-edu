        section .data
msg:
        db "hello, world!", 10

        section .text
        global _start

_start:
        mov rax, 1                     ; Specify the number of the system call (1 is `sys_write`).
        mov rdi, 1                     ; Set the first argument of `sys_write` to 1 (`stdout`).
        mov rsi, msg                   ; Set the second argument of `sys_write` to the reference of the `msg` variable.
        mov rdx, 14                    ; Set the third argument of `sys_write` to the length of the `msg` variable's value (14 bytes).
        syscall                        ; Call the `sys_write` system call.

        mov rax, 60                    ; Specify the number of the system call (60 is `sys_exit`).
        mov rdi, 0                     ; Set the first argument of `sys_exit` to 0. The 0 status code is success.
        syscall                        ; Call the `sys_exit` system call.
