[org 0x7c00]

mov bp, 0x8000 ; init stack
mov sp, bp 

mov si, STRING_HELLO
call print_string

mov dx, 0x1234
call print_hex_at_address



jmp $ ; spin forever

; %include "utils.asm"
print_string: ; will print string at si using bios int
	push ax
	push si
	mov ah, 0x0e ; BIOS scrolling teletype fn
	.repeat:
		lodsb
		cmp al, 0
		je .done
		int 0x10
		jmp .repeat
	.done:
	pop si
	pop ax
	ret

print_hex_at_address:
	push dx
	push bx

	mov bx, dx
	shr bx, 12
	mov bx, [HEX_TABLE+bx]
	mov [HEX_TEMPLATE+2], bl
	mov si, HEX_TEMPLATE
	call print_string

	pop bx
	pop dx
	ret

;Data
HEX_TEMPLATE:
db '0x???? ',0
HEX_TABLE:
db '0123456789abcdef',0

STRING_HELLO:
db 'Hello',0

; pad to 512 bytes and add magic number to make it a bootsector
times 510-($-$$) db 0
dw 0xaa55