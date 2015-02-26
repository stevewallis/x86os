; Will print value in dx as hex
; requires print_string
print_hex:
	push dx
	push bx
	push si

	mov bx, dx
	shr bx, 12
	mov bx, [HEX_TABLE+bx]
	mov [HEX_TEMPLATE+2], bl

	mov bx, dx
	shr bx, 8
	and bx, 0x000f
	mov bx, [HEX_TABLE+bx]
	mov [HEX_TEMPLATE+3], bl

	mov bx, dx
	shr bx, 4
	and bx, 0x000f
	mov bx, [HEX_TABLE+bx]
	mov [HEX_TEMPLATE+4], bl

	mov bx, dx
	and bx, 0x000f
	mov bx, [HEX_TABLE+bx]
	mov [HEX_TEMPLATE+5], bl

	mov si, HEX_TEMPLATE
	call print_string

	pop si
	pop bx
	pop dx
	ret

;Data
HEX_TEMPLATE:
db '0x???? ',0
HEX_TABLE:
db '0123456789abcdef',0