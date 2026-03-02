; os.asm
; Copyright (C) 2026.3.2 TOP WAYE topwaye@hotmail.com
; 8086 Operating System

int_66:
    in ax, 7h
    iret

start_8086:
    mov ax, 1
    out 7h, ax
for_loop:
    mov cx, 1
    cmp ax, 10
    je end_8086
    loop for_loop
end_8086:
    mov bx, ax
