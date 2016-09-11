#!/bin/sh
make clean 
make all
avr-objcopy -I ihex Caterina.hex -O binary Caterina.bin 
avr-objdump -j .sec1 -d -m avr5 Caterina.hex  > Caterina.asm
#exit
PROGRAMER=-cstk500v1 -b19200 -P/dev/ttyUSB0
PROGRAMER=-cusbtiny

avrdude -v -v -patmega32u4 -e -Ulock:w:0x3F:m -Uefuse:w:0xce:m -Uhfuse:w:0xd8:m -Ulfuse:w:0xff:m $PROGRAMER
avrdude -v -v -patmega32u4 -Uflash:w:Caterina.hex:i -Ulock:w:0x2F:m $PROGRAMER

#exit
rm current_firmware.hex
avrdude -v -v -patmega32u4 -cstk500v1 -b19200 -P/dev/ttyUSB0 -U flash:r:current_firmware.hex:i
avr-objcopy -I ihex  current_firmware.hex -O binary current_firmware.bin
diff Caterina.hex current_firmware.hex
