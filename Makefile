all: run

kernel.bin: kernel-entry.o kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.elf: kernel-entry.o kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

kernel-entry.o: kernel-entry.asm
	nasm $< -f elf -o $@

kernel.o: kernel.c
	gcc -m32 -ffreestanding -c $< -o $@

mbr.bin: mbr.asm
	nasm $< -f bin -o $@

os-image.bin: mbr.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 -hda os-image.bin

debug: os-image.bin kernel.elf
	gcc -m32 -ffreestanding -g -c kernel.c -o kernel.o
	ld -m elf_i386 -o kernel.elf -Ttext 0x1000 kernel-entry.o kernel.o
	qemu-system-i386 -fda os-image.bin -S -s -vga std

clean:
	$(RM) *.bin *.o *.dis *.elf
