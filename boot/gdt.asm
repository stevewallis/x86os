; Global Descriptor Table
; A descriptor is an 8 byte struct like this:
;
; 00:0F Segment Limit (00:0F) - first 16 bits of the size of the segment 
; 10:1F Base Address (00:0F) - first 16 bits of the base address of the segment
; 20:27 Base Address (0F:18) - next 8 bits of the base address of the segment
; 28:2B TYPE Segment Type - 4 bits segment type (flags - Code, Conforming, Readable/Writable, Accessed)
; 2C    S Descriptor type (0 = system, 1 = code or data) 
; 2D:2E DPL Descriptor Privilege level
; 2F    P Segment present (1 = segment is present in memory. Used for virtual mem)
; 30:33 Segment Limit (10:13) - final 4 bits of the segment size
; 34    AVL (Available for use by system software)
; 35    L 64-bit code segment
; 36    D/B Default operation size (0 = 16bit segment, 1 = 32bit segment)
; 37    G Granularity if set, multiplies our segment limit by 0xf*0xf*0xf, ie 0xfffff -> 0xfffff000 to allow 4GB addressing
; 38:3F Base Address (18:1F) final 8 bits of base address.

; ############
; For now, our GDT will just be the intel Basic Flat Model. 
; i.e. Two overlapping segments (code and data) that span the full 4GB addressable memory
; ############

gdt_start:

gdt_null:          ; mandatory null Descriptor
	times 8 db 0x0

gdt_code_segment:  ; Code segment Descriptor
	dw 0xffff      ; Segment Limit (00:0F)
	dw 0x0         ; Base Address (00:0F)
	db 0x0         ; Base Address (0F:18)
	db 10011010b   ; P(1 = Segment present in memory)<-DPL(00 = ring 0)<-S(1 = code or data)<-TYPE(Code=1, Conforming=0, Readable=1, Accessed=0)
	db 11001111b   ; G(1 = Granularity on)<-D/B(1 = 32bit)<-L(0 = not 64bit)<-AVL(0 = not AVL)<-Segment Limit (10:13)
	db 0x0         ; Base Address (18:1F)

gdt_data_segment:  ; Data segment Descriptor
	dw 0xffff      ; Segment Limit (00:0F)
	dw 0x0         ; Base Address (00:0F)
	db 0x0         ; Base Address (0F:18)
	db 10010010b   ; P(1 = Segment present in memory)<-DPL(00 = ring 0)<-S(1 = code or data)<-TYPE(Code=0, Conforming=0, Readable=1, Accessed=0)
	db 11001111b   ; G(1 = Granularity on)<-D/B(1 = 32bit)<-L(0 = not 64bit)<-AVL(0 = not AVL)<-Segment Limit (10:13)
	db 0x0         ; Base Address (18:1F)

gdt_end:           ; only used for calculating size of gdt

gdt_descriptor:                 ; this is the Descriptor that we give to the CPU
	dw gdt_end - gdt_start - 1  ; it contains the size of the GDT (ie, number of segments*8bytes - 1)
	dd gdt_start                ; and the starting address


CODE_SEG equ gdt_code_segment - gdt_start  ; these are the offsets from gdt_start for our CODE and DATA segments
DATA_SEG equ gdt_data_segment - gdt_start  ; these are useful defines, as this is what will be in our segmentation registers
