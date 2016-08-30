CC=/Users/steve/tools/cross/bin/i686-elf-gcc
LD=/Users/steve/tools/cross/bin/i686-elf-ld

.PHONY: all clean run

bin/bootsector.bin: boot/bootsector.asm
	nasm $^ -f bin -o $@

bin/kernel.o: kernel/kernel.c 
	$(CC) -ffreestanding -c $< -o $@ -m32

bin/kernel.bin: bin/kernel.o
	$(LD) -o $@ -Ttext 0x1000 $< -m elf_i386 --oformat binary

bin/os.bin: bin/bootsector.bin bin/kernel.bin
	cat bin/bootsector.bin bin/kernel.bin > $@

bin/os.iso: bin/os.bin
	gtruncate $^ -s 1200k
	mkisofs -o $@ -b $^ .

all: run

run: bin/os.bin
	qemu-system-x86_64 $<

clean:
	rm bin/*

