
all: emu iso

emu: src/bootsector.asm
	nasm src/bootsector.asm -f bin -o bin/bootsector.bin
iso:
	
clean:
	rm bin/bootsector.bin

