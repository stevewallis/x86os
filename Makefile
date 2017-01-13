CC=/Users/steve/tools/cross/bin/i686-elf-gcc
LD=/Users/steve/tools/cross/bin/i686-elf-ld

C_SRCS = $(wildcard kernel/*.c)
INCLUDES = $(wildcard kernel/*.h)
OBJ = ${C_SRCS:.c=.o}

.PHONY: all clean run

# Full packages
bin/os.bin: bin/bootsector.bin bin/kernel.bin
	cat $^ > $@

bin/os.iso: bin/os.bin
	gtruncate $^ -s 1200k
	mkisofs -o $@ -b $^ .

# bootsector
bin/bootsector.bin: boot/bootsector.asm
	nasm $^ -f bin -o $@


#kernel	
bin/kernel.bin: ${OBJ}
	$(LD) -o $@ -Ttext 0x1000 $^ -m elf_i386 --oformat binary

# debugging
bin/kernel.dis: bin/kernel.bin
	ndisasm -b 32 $< > $@

bin/kernel.elf: ${OBJ}
	$(LD) -o $@ -Ttext 0x1000 $^ -m elf_i386

#wilcards
%.o: %.c ${INCLUDES}
	$(CC) -ffreestanding -c $< -o $@ -m32


#phonys
all: bin/kernel.dis bin/kernel.elf run 

run: bin/os.bin
	qemu-system-x86_64 $<

clean:
	rm bin/*
	rm kernel/*.o

