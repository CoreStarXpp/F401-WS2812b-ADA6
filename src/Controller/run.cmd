echo off
::�ر���ʾ
cls
::����
echo =====================================================================
echo ��Ŀ��F401-WS2812b-ADA6
echo �ļ���/src/Controller/Main.s
echo SPDX��ʶ��SPDX-License-Identifier: LGPL-3.0-only
echo ��Ȩ���У�Copyright (C) 2025 ��˸
echo 		о��-X++�����Ŷӣ�https://gitee.com/CoreStarXpp��
echo Э�飺�����ı���/LICENSES/lgpl-3.0.txt
echo =====================================================================
color f0
::�׵׺���
arm-none-eabi-as -o CopyF2S.o CopyF2S.s
arm-none-eabi-ld -Ttext=0x08000000 -o CopyF2S.elf CopyF2S.o
arm-none-eabi-objcopy -O binary CopyF2S.elf CopyF2S_.bin
arm-none-eabi-objcopy -I binary -O binary --pad-to 0x100 --gap-fill=0x00 CopyF2S_.bin CopyF2S.bin
echo ����CopyF2S
arm-none-eabi-as -o Main.o Main.s
arm-none-eabi-ld -Ttext=0x20000000 -o Main.elf Main.o
arm-none-eabi-objcopy -O binary Main.elf Main.bin
echo ����Main
copy /B CopyF2S.bin + Main.bin Flash.bin
echo �ϲ��ļ�
pause
::�ȴ�
color 0f
::�ָ��ڵװ���
echo on
::������ʾ