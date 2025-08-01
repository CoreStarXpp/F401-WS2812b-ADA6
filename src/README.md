##### ===================================================================
##### F401-WS2812b-ADA6 - 芯星-X++开发团队
##### SPDX标识：SPDX-License-Identifier: LGPL-3.0-only
##### 版权所有：Copyright (C) 2025 张烁
#####  		芯星-X++开发团队（https://gitee.com/CoreStarXpp）
##### ===================================================================

[![LGPL-3.0](https://img.shields.io/badge/License-LGPL_v3-blue.svg)](LICENSES/lgpl-3.0.txt)

#### 项目共分两个部分，控制器（Controller）和接收器（Receiver），结构上采取单目录包含所有源码

#### 控制器（Controller）
	核心频率16MHz
	蓝牙模块XY-MB035A
	未使用CTS
	USART1（PA9，PA10）
	按键高电压驱动（PA0）
	发送数据0xff010100

#### 接收器（Receiver）
	核心频率84MHz
	蓝牙模块XY-MB035A
	未使用CTS
	USART1（PA9，PA10）
	WS2812b灯带5V 160灯（PA0）
	蓝牙LINK引脚控制灯带电源