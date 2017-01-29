CC=/Users/steve/tools/cross/bin/i686-elf-gcc
LD=/Users/steve/tools/cross/bin/i686-elf-ld
GDB=/Users/steve/tools/cross/bin/i686-elf-gdb

C_SRCS = $(wildcard kernel/*.c kernel/drivers/*.c libc/*.c)
INCLUDES = $(wildcard kernel/*.h kernel/drivers/*.h libc/*.h)
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
bin/kernel.bin: kernel/startup.s.o ${OBJ}
	$(LD) -o $@ -T linker.ld $^ -m elf_i386 --oformat binary

bin/kernel.elf: kernel/startup.s.o ${OBJ}
	$(LD) -o $@ -T linker.ld $^ -m elf_i386

#wilcards
%.o: %.c ${INCLUDES}
	$(CC) -ffreestanding -c $< -o $@ -m32 -nostdinc -isystem libc/
%.s.o: %.s
	nasm $^ -f elf -o $@

#phonys
all: run 

run: bin/os.bin
	qemu-system-x86_64 -drive format=raw,file=$< 

debug: bin/os.bin bin/kernel.elf
	qemu-system-x86_64 -s -S -drive format=raw,file=$< &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file bin/kernel.elf"

clean:
	rm bin/*
	rm kernel/*.o
	rm kernel/drivers/*.o
	rm libc/*.o

