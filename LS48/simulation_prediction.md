# 数字秒表/计时器系统仿真预测结果

## 仿真场景设计

### 场景1: 正计时模式（秒表功能）测试

**初始状态:**
- 系统复位后: tens=0, ones=0, xiaoshu=0, point=0, led=0
- mode=0 (正计时), running=0 (停止), precision_mode=0 (秒精度)

**操作序列:**
1. 按下KEY0启动秒表
2. 观察1Hz计时过程
3. 按KEY6切换到0.1秒精度
4. 按KEY5切换到2Hz计时频率
5. 按KEY4暂停
6. 再按KEY4继续

**预期结果:**
```
时间: 0ns     - 复位: tens=0, ones=0, xiaoshu=0, point=0, led=0, running=0
时间: 1000ns  - 按KEY0: mode=0, running=1, 开始正计时
时间: 2000ns  - 1Hz计时: tens=0, ones=1, xiaoshu=0 (显示 01)
时间: 3000ns  - 1Hz计时: tens=0, ones=2, xiaoshu=0 (显示 02)
时间: 4000ns  - 1Hz计时: tens=0, ones=3, xiaoshu=0 (显示 03)
时间: 5000ns  - 按KEY6: precision_mode=1, point=1 (启用小数点)
时间: 5100ns  - 10Hz计时: tens=0, ones=3, xiaoshu=1 (显示 03.1)
时间: 5200ns  - 10Hz计时: tens=0, ones=3, xiaoshu=2 (显示 03.2)
时间: 6000ns  - 10Hz计时: tens=0, ones=4, xiaoshu=0 (显示 04.0)
时间: 7000ns  - 按KEY5: freq_sel=1 (切换到2Hz)
时间: 7500ns  - 2Hz计时: tens=0, ones=4, xiaoshu=5 (显示 04.5)
时间: 8000ns  - 2Hz计时: tens=0, ones=5, xiaoshu=0 (显示 05.0)
时间: 9000ns  - 按KEY4: running=0 (暂停)
时间: 10000ns - 暂停状态: 显示保持 05.0
时间: 11000ns - 按KEY4: running=1 (继续)
时间: 11500ns - 继续计时: tens=0, ones=5, xiaoshu=5 (显示 05.5)
```

### 场景2: 倒计时模式（定时器功能）测试

**初始设置:**
- ten=1, one=5 (设定15秒倒计时)

**操作序列:**
1. 按下KEY1启动倒计时
2. 观察倒计时过程
3. 当时间<8秒时观察LED闪烁
4. 观察倒计时结束

**预期结果:**
```
时间: 0ns     - 设定: ten=1, one=5 (15秒)
时间: 1000ns  - 按KEY1: mode=1, running=1, tens=1, ones=5, xiaoshu=0
时间: 2000ns  - 1Hz倒计时: tens=1, ones=4, xiaoshu=0 (显示 14)
时间: 3000ns  - 1Hz倒计时: tens=1, ones=3, xiaoshu=0 (显示 13)
...
时间: 8000ns  - 1Hz倒计时: tens=0, ones=7, xiaoshu=0 (显示 07)
时间: 8400ns  - LED开始闪烁: led=1 (时间<8秒)
时间: 8800ns  - LED闪烁: led=0
时间: 9000ns  - 1Hz倒计时: tens=0, ones=6, xiaoshu=0 (显示 06)
时间: 9200ns  - LED闪烁: led=1
...
时间: 15000ns - 倒计时: tens=0, ones=1, xiaoshu=0 (显示 01)
时间: 16000ns - 倒计时结束: tens=0, ones=0, xiaoshu=0, running=0, led=0
```

### 场景3: 精度模式和频率切换测试

**操作序列:**
1. 启动正计时
2. 切换到0.1秒精度
3. 测试不同频率下的计时

**预期结果:**
```
# 1Hz模式 + 0.1秒精度
时间: 1000ns  - KEY0: 启动正计时
时间: 1100ns  - KEY6: precision_mode=1, point=1
时间: 1200ns  - 10Hz: tens=0, ones=0, xiaoshu=1 (00.1)
时间: 1300ns  - 10Hz: tens=0, ones=0, xiaoshu=2 (00.2)
...
时间: 2000ns  - 10Hz: tens=0, ones=1, xiaoshu=0 (01.0)

# 2Hz模式 + 0.1秒精度
时间: 2100ns  - KEY5: freq_sel=1 (2Hz模式)
时间: 2600ns  - 2Hz: tens=0, ones=1, xiaoshu=5 (01.5)
时间: 3100ns  - 2Hz: tens=0, ones=2, xiaoshu=0 (02.0)

# 4Hz模式 + 0.1秒精度  
时间: 3200ns  - KEY5: freq_sel=2 (4Hz模式)
时间: 3450ns  - 4Hz: tens=0, ones=2, xiaoshu=2 (02.2)
时间: 3700ns  - 4Hz: tens=0, ones=2, xiaoshu=5 (02.5)
时间: 3950ns  - 4Hz: tens=0, ones=2, xiaoshu=7 (02.7)
时间: 4200ns  - 4Hz: tens=0, ones=3, xiaoshu=0 (03.0)
```

### 场景4: 边界条件测试

**测试59.9秒溢出:**
```
# 正计时模式到达59.9秒
时间: 59900ns - tens=5, ones=9, xiaoshu=9 (59.9)
时间: 60000ns - 溢出重置: tens=0, ones=0, xiaoshu=0 (00.0)
```

**测试倒计时到0:**
```
# 倒计时从00.1到00.0
时间: 100ns   - tens=0, ones=0, xiaoshu=1 (00.1)
时间: 200ns   - 倒计时结束: tens=0, ones=0, xiaoshu=0, running=0
```

## LS48译码器输出预测

### 数字0-9的七段码输出
```
数字 | BCD输入 | 七段码输出 (abcdefg)
-----|---------|-------------------
  0  |  0000   |  0000001  (显示 0)
  1  |  0001   |  1001111  (显示 1)  
  2  |  0010   |  0010010  (显示 2)
  3  |  0011   |  0000110  (显示 3)
  4  |  0100   |  1001100  (显示 4)
  5  |  0101   |  0100100  (显示 5)
  6  |  0110   |  0100000  (显示 6)
  7  |  0111   |  0001111  (显示 7)
  8  |  1000   |  0000000  (显示 8)
  9  |  1001   |  0000100  (显示 9)
```

### 显示示例
```
时间显示: 25.7秒
- tens = 2 (十位)
- ones = 5 → out_ge = 0100100 (个位显示5)
- xiaoshu = 7 → out_xiao = 0001111 (小数位显示7)
- point = 1 (小数点亮)
```

## 时钟分频器输出预测

**50MHz输入时钟分频结果:**
```
clk_1hz:  周期 = 1秒    = 50,000,000个时钟周期
clk_2hz:  周期 = 0.5秒  = 25,000,000个时钟周期  
clk_4hz:  周期 = 0.25秒 = 12,500,000个时钟周期
clk_10hz: 周期 = 0.1秒  = 5,000,000个时钟周期
```

**仿真模式下(SIM_MODE=1):**
```
clk_1hz:  周期 = 100ns (仿真加速)
clk_2hz:  周期 = 50ns
clk_4hz:  周期 = 25ns  
clk_10hz: 周期 = 10ns
```

## 按键响应预测

### 按键防抖和边沿检测
```
按键按下过程:
时间: 1000ns - key0 = 0 (按下)
时间: 1100ns - key0_last = 0, key0_up = 0 (第一个时钟周期)
时间: 1200ns - key0_last = 0, key0_up = 0 (稳定状态)

按键释放过程:  
时间: 2000ns - key0 = 1 (释放)
时间: 2100ns - key0_last = 0, key0_up = 1 (检测到上升沿)
时间: 2200ns - key0_last = 1, key0_up = 0 (边沿检测完成)
```

## LED闪烁模式预测

**倒计时模式下时间<8秒时:**
```
时间: 7000ns - tens=0, ones=7: led=0 (还未开始闪烁)
时间: 7900ns - tens=0, ones=7: led_count=0, led=0
时间: 8000ns - tens=0, ones=6: led_count=1, led=0  
时间: 8100ns - tens=0, ones=6: led_count=2, led=0
时间: 8200ns - tens=0, ones=6: led_count=3, led=0
时间: 8300ns - tens=0, ones=6: led_count=4, led=0
时间: 8400ns - tens=0, ones=6: led_count=0, led=1 (开始闪烁)
时间: 8500ns - tens=0, ones=6: led_count=1, led=1
...
时间: 8800ns - tens=0, ones=6: led_count=0, led=0 (闪烁切换)
```

这些预测结果基于新设计的Timer模块逻辑，应该能够准确反映系统的实际行为。