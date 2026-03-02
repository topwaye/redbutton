; os.asm
; Copyright (C) 2026.3.2 TOP WAYE topwaye@hotmail.com
; 8086 Operating System

int_66:
    in ax, 7h
    iret

start:
    mov ax, 1
    out 7h, ax
    hlt
    mov dx, ax
