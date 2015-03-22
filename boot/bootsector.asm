[org 0x7c00]
[bits 16]

mov [BOOT_DRIVE], dl ; BIOS stores the number of the boot drive here, so we should keep it.

mov bp, 0xffff ; init stack
mov sp, bp 

mov si, STRING_HELLO
call print_string

call load_kernel_from_disk
call switch_to_protected_mode

jmp KERNEL_ENTRY

jmp $ ; spin forever

%include "boot/utils/print_string.asm"
%include "boot/utils/print_hex.asm"
%include "boot/load_kernel_from_disk.asm"
%include "boot/gdt.asm"
%include "boot/switch_to_protected_mode.asm"

STRING_HELLO:
db 'Hello',0x0d, 0x0a, 0

; Global Vars
BOOT_DRIVE: db 0

; pad to 512 bytes and add magic number to make it a bootsector
times 510-($-$$) db 0
dw 0xaa55

[bits 32]
KERNEL_ENTRY:
jmp $