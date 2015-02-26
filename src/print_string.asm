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
