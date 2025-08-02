# LGPL v3 合规指南

## 用户义务
### 未修改使用
1. 在产品文档中声明：
   "本产品使用 [F401-WS2812b-ADA6] (LGPL v3)"
2. 提供协议文本获取方式：
   https://github.com/CoreStarXpp/f401-ws2812b-ada6/edit/master/LICENSES/lgpl-3.0.txt

### 修改代码
1. 在修改文件中标注：
;>>>>>LGPL_MOD_START [修改者] [日期] 修改内容
;<<<<<LGPL_MOD_END
2. 开源修改后的代码
3. 不得删除原始版权声明

## 静态链接说明
若将库静态链接到固件：
1. 必须提供可重定位的.o文件
2. 允许用户替换此库
