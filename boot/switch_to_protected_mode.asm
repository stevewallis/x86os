[bits 16]
switch_to_protected_mode:
	cli 	; disable interrupts
	lgdt [gdt_descriptor] ; load our global descriptor table
	
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
	ret
	