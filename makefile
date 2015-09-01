
all: boot _kernel iso

boot: boot/bootsector.asm
	nasm boot/bootsector.asm -f bin -o bin/bootsector.bin

_kernel: boot
	i386-elf-gcc -ffreestanding -c kernel/kernel.c -o bin/kernel.o -m32
	i386-elf-ld -o bin/kernel.bin -Ttext 0x1000 bin/kernel.o -m elf_i386 --oformat binary

iso: _kernel
	cat bin/bootsector.bin bin/kernel.bin > bin/os.bin
	gtruncate bin/os.bin -s 1200k
	mkisofs -o bin/os.iso -b bin/os.bin .
clean:
	rm bin/bootsector.bin bin/kernel.bin bin/kernel.o bin/os.bin bin/os.iso 

