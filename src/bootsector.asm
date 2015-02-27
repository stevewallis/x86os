[org 0x7c00]

mov bp, 0xffff ; init stack
mov sp, bp 

mov si, STRING_HELLO
call print_string

call read_from_disk

mov si, MEMORY_LOADED
call print_string

jmp $ ; spin forever

%include "src/print_string.asm"
%include "src/print_hex.asm"

read_from_disk:
	push ax
	push cx
	push dx

	mov ah, 0x02 ; BIOS Read Sectors From Disk
	
	mov al, 1    ; number of sectors to read
	mov dl, 0x80 ; select HD 0
	mov ch, 0x00 ; select cylinder 0
	mov dh, 0x00 ; select head 0
	mov cl, 0x02 ; start reading from sector 2
	

	mov bx, 0
	mov es, bx
	mov bx, 0x7c00 + 0x200

	int 0x13 ; Fire interrupt

	jc disk_read_error

	pop dx
	pop cx
	pop ax

	ret

disk_read_error:
	mov si, DISK_READ_ERR_MSG
	call print_string
	jmp $

DISK_READ_ERR_MSG:
	db "Disk Read Error!",0


STRING_HELLO:
db 'Hello',0x0d, 0x0a, 0

; pad to 512 bytes and add magic number to make it a bootsector
times 510-($-$$) db 0
dw 0xaa55

MEMORY_LOADED:
db 'I am loaded',0
times 0x200 db 0