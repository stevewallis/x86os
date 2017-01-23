[org 0x7c00]
[bits 16]

KERNEL_OFFSET equ 0x1000

mov [BOOT_DRIVE], dl ; BIOS stores the number of the boot drive here, so we should keep it.

mov bp, 0x9000 ; init stack
mov sp, bp 

mov si, MSG_REAL_MODE
call print_string

;KBLOOP:
;in al, 0x64
;and al, 00000001b
;jz KBLOOP
;
;in al, 0x60
;mov dl, al
;call print_hex
;jmp KBLOOP

mov ah, 0x0e
int 0x10

mov si, MSG_BOOTING_KERNEL
call print_string


call load_kernel_from_disk
call switch_to_protected_mode

call KERNEL_OFFSET ; here we go!

jmp $ ; spin forever

%include "boot/utils/print_string.asm"
%include "boot/utils/print_hex.asm"
%include "boot/load_kernel_from_disk.asm"
%include "boot/gdt.asm"
%include "boot/switch_to_protected_mode.asm"

MSG_REAL_MODE db 'Started in 16-bit Real Mode',0x0d, 0x0a, 0
MSG_PROTECTED_MODE db 'Switched to 32-bit Protected Mode',0x0d, 0x0a, 0
MSG_BOOTING_KERNEL db 'Booting Kernel...',0x0d, 0x0a, 0

; Global Vars
BOOT_DRIVE: db 0

; pad to 512 bytes and add magic number to make it a bootsector
times 510-($-$$) db 0
dw 0xaa55

[bits 32]