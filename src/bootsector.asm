[org 0x7c00]
mov ah, 0x0e ; BIOS scrolling teletype fn

mov al, 'H'
int 0x10
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10

jmp $ ; spin forever

; pad to 512 bytes and add magic number to make it a bootsector
times 510-($-$$) db 0
dw 0xaa55