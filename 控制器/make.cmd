color f0

arm-none-eabi-as -o Copy_Flash-SRAM.o Copy_Flash-SRAM.s
arm-none-eabi-ld -Ttext=0x08000000 -o Copy_Flash-SRAM.elf Copy_Flash-SRAM.o
arm-none-eabi-objcopy -O binary Copy_Flash-SRAM.elf Copy_Flash-SRAM_.bin
arm-none-eabi-objcopy -I binary -O binary --pad-to 0x100 --gap-fill=0x00 Copy_Flash-SRAM_.bin Copy_Flash-SRAM.bin

arm-none-eabi-as -o Main.o Main.s
arm-none-eabi-ld -Ttext=0x20000000 -o Main.elf Main.o
arm-none-eabi-objcopy -O binary Main.elf Main.bin

arm-none-eabi-objdump -b binary -m arm -M force-thumb -D --adjust-vma=0x20000000 Main.bin > Main-elf.s

copy /B Copy_Flash-SRAM.bin + Main.bin Flash.bin

pause
color 0f