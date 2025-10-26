[bits 16]
[org 0x7c00]

; Setup
cli
mov ax, 0
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

; Switch to graphics mode
mov ax, 0x0013
int 0x10

; Draw graphics
call draw_graphics

; Wait a bit
mov cx, 0xFFFF
.delay:
loop .delay

; Hang forever
cli
hlt
jmp $

draw_graphics:
    mov ax, 0xA000
    mov es, ax
    xor di, di
    
    ; Rainbow gradient
    mov cx, 320*200
    mov al, 0
.gradient:
    mov [es:di], al
    inc di
    inc al
    loop .gradient
    
    ; Draw a smiling face
    ; Eyes
    mov di, 70*320 + 140
    mov cx, 10
.eyes_outer:
    push cx
    mov cx, 10
    mov al, 0x00  ; Black
.eyes_inner:
    mov [es:di], al
    inc di
    loop .eyes_inner
    add di, 320 - 10
    pop cx
    loop .eyes_outer
    
    mov di, 70*320 + 170
    mov cx, 10
.eyes2_outer:
    push cx
    mov cx, 10
    mov al, 0x00
.eyes2_inner:
    mov [es:di], al
    inc di
    loop .eyes2_inner
    add di, 320 - 10
    pop cx
    loop .eyes2_outer
    
    ; Smile
    mov di, 100*320 + 140
    mov cx, 5
.smile_outer:
    push cx
    mov cx, 40
    mov al, 0x00
.smile_inner:
    mov [es:di], al
    inc di
    loop .smile_inner
    add di, 320 - 40
    pop cx
    loop .smile_outer
    
    ret

times 510-($-$$) db 0
dw 0xAA55