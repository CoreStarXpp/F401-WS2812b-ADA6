echo off
::关闭显示
cls
::清屏
echo =====================================================================
echo 项目：F401-WS2812b-ADA6
echo 文件：/src/Controller/Main.s
echo SPDX标识：SPDX-License-Identifier: LGPL-3.0-only
echo 版权所有：Copyright (C) 2025 张烁
echo 		芯星-X++开发团队（https://gitee.com/CoreStarXpp）
echo 协议：完整文本见/LICENSES/lgpl-3.0.txt
echo =====================================================================
color f0
::白底黑字
arm-none-eabi-as -o CopyF2S.o CopyF2S.s
arm-none-eabi-ld -Ttext=0x08000000 -o CopyF2S.elf CopyF2S.o
arm-none-eabi-objcopy -O binary CopyF2S.elf CopyF2S_.bin
arm-none-eabi-objcopy -I binary -O binary --pad-to 0x100 --gap-fill=0x00 CopyF2S_.bin CopyF2S.bin
echo 编译CopyF2S
arm-none-eabi-as -o Main.o Main.s
arm-none-eabi-ld -Ttext=0x20000000 -o Main.elf Main.o
arm-none-eabi-objcopy -O binary Main.elf Main.bin
echo 编译Main
copy /B CopyF2S.bin + Main.bin Flash.bin
echo 合并文件
pause
::等待
color 0f
::恢复黑底白字
echo on
::开启显示