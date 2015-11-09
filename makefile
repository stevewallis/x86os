CC=/Users/steve/tools/cross/bin/i686-elf-gcc
LD=/Users/steve/tools/cross/bin/i686-elf-ld
all: _boot _kernel iso

_boot: boot/bootsector.asm
	nasm boot/bootsector.asm -f bin -o bin/bootsector.bin

_kernel: boot
	$(CC) -ffreestanding -c kernel/kernel.c -o bin/kernel.o -m32
	$(LD) -o bin/kernel.bin -Ttext 0x1000 bin/kernel.o -m elf_i386 --oformat binary

iso: _kernel
	cat bin/bootsector.bin bin/kernel.bin > bin/os.bin
	gtruncate bin/os.bin -s 1200k
	mkisofs -o bin/os.iso -b bin/os.bin .
clean:
	rm bin/bootsector.bin bin/kernel.bin bin/kernel.o bin/os.bin bin/os.iso 

