[org 0x7c00]

mov bp, 0x8000 ; init stack
mov sp, bp 

mov si, STRING_HELLO
call print_string

mov dx, [0x7c00]
call print_hex


jmp $ ; spin forever

%include "src/print_utils.asm"

STRING_HELLO:
db 'Hello',0

; pad to 512 bytes and add magic number to make it a bootsector
times 510-($-$$) db 0
dw 0xaa55