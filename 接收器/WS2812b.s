.syntax unified						// 标准ARM语法
.cpu cortex-m3						// 指定Cortex-m3内核
.thumb							// Thumb模式
.global WS2812b						// 定义全局变量，_start程序开始

.text							// 代码段开始

// 程序入口
WS2812b:
// 备份返回地址
	push {r14}
	LDR R0, [R2]									// 读取GPIO_ODR
	BIC R0, R0, R1									// 端口置0
	STR R0, [R2]									// 写入GPIO_ODR
	LDR R3, [R5], #4								// 读取RGB值
	SUBS R6, R6, #1									// 更新剩余灯珠
	MOV R7, #0x12000								// 加载Reset等待周期
	
// 循环程序入口
Start:
	MOV R4, #0x00800000								// 循环操作位
	TST R3, R4										// 检测RGB值
	NOP												// 等待标志
	BNE Core_1										// RGB值=1跳转，=0略过
// Core0 低位信号 0.35us高电平+0.8us低电平
Core_0:
	LDR R0, [R2]									// 读取GPIO_ODR寄存器
	ORR R0, R0, R1									// 清除目标位
	STR R0, [R2]									// 写入GPIO_ODR寄存器
	MOV R0, #3										// 延时次数
	BL WaitCore										// 跳转到延时程序
	LDR R0, [R2]									// 读取GPIO_ODR寄存器
	BIC R0, R0, R1									// 清除目标位
	STR R0, [R2]									// 写入GPIO_ODR寄存器
	MOV R0, #9										// 延时次数
	BL WaitCore										// 跳转到延时程序
	LSRS R4, R4, #1									// 切换检测位
	BEQ Exit										// 检测完退出
	TST R3, R4										// 检测RGB值
	NOP												// 等待标志
	BEQ Core_0

// Core1 高位信号 0.7us高电平+0.6us低电平
Core_1:
	LDR R0, [R2]									// 读取GPIO_ODR寄存器
	ORR R0, R0, R1									// 清除目标位
	STR R0, [R2]									// 写入GPIO_ODR寄存器
	MOV R0, #9										// 延时次数
	BL WaitCore										// 跳转到延时程序
	LDR R0, [R2]									// 读取GPIO_ODR寄存器
	BIC R0, R0, R1									// 清除目标位
	STR R0, [R2]									// 写入GPIO_ODR寄存器
	MOV R0, #7										// 延时次数
	BL WaitCore										// 跳转到延时程序
	LSRS R4, R4, #1									// 切换检测位
	BEQ Exit										// 检测完退出
	TST R3, R4										// 检测RGB值
	NOP												// 等待标志
	BEQ Core_0
	B Core_1

// 一次数据完成处理程序
Exit:
	CMP R6, #0										// 检查剩余灯珠数量
	NOP												// 等待标志位
	BNE ColorUpdate_ws 								//！=0则继续
	BL Deep1											//=0，延时刷新
	pop {r14}
	BX LR											// 返回

// 颜色更新程序
ColorUpdate_ws:
	LDR R3, [R5], #4								// 读取RGB值
	SUBS R6, R6, #1									// 更新剩余灯珠
	B Start											// 开始新一次循环


// Reset延时程序
Deep1:
	SUBS R7, R7, #1									// 递减
	NOP												// 等待标志
	BNE Deep1										// ！=0则跳转
	BX LR											// 返回

// Core时序补足程序
WaitCore:
	SUBS R0, R0, #1									// 递减
	NOP												// 等待标志
	BNE WaitCore									// ！=0则跳转
	BX LR											// 返回
