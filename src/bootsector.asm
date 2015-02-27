[org 0x7c00]
[bits 16]

mov [BOOT_DRIVE], dl ; BIOS stores the number of the boot drive here, so we should keep it.

mov bp, 0xffff ; init stack
mov sp, bp 

mov si, STRING_HELLO
call print_string

call read_from_disk

; switch to protected mode

jmp $ ; spin forever

%include "src/print_string.asm"
%include "src/print_hex.asm"

[bits 16]
switch_to_protected_mode:
	cli 	; disable interrupts
	lgdt [GDT_DESCRIPTOR] ; load our global descriptor table
	
	mov eax, cr0 
	or eax, 0x1
	mov cr0, eax ; set the lowest bit of cr0 to 1, this turns on protected mode

	jmp CODE_SEG:init_protected_mode  ; far jmp to 32 bit code. This forces CPU flush.

[bits 32]
init_protected_mode:
	mov ax, DATA_SEG   ; reset all our segment registers to our GDT data segment
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000 ; we have more space now, so put the stack far away
	mov esp, ebp



read_from_disk:
	push ax
	push cx
	push dx

	mov ah, 0x02 ; BIOS Read Sectors From Disk
	
	mov al, 1    ; number of sectors to read
	mov dl, [BOOT_DRIVE] ; select boot drive
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

; Global Vars
BOOT_DRIVE: db 0

; pad to 512 bytes and add magic number to make it a bootsector
times 510-($-$$) db 0
dw 0xaa55

MEMORY_LOADED:
db 'I am loaded',0
times 0x200 db 0