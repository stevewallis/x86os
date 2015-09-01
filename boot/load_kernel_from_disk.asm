[bits 16]
load_kernel_from_disk:
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
	mov bx, KERNEL_OFFSET

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
