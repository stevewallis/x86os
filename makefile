
all: emu iso

emu: boot/bootsector.asm
	nasm boot/bootsector.asm -f bin -o bin/bootsector.bin
iso: emu
	gtruncate bin/bootsector.bin -s 1200k
	mkisofs -o bin/os.iso -b bin/bootsector.bin .
clean:
	rm bin/bootsector.bin bin/os.iso

