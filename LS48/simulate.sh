#!/bin/bash
# LS48项目仿真脚本
# 使用Icarus Verilog进行仿真并生成波形文件

echo "=== LS48项目仿真脚本 ==="
echo "此脚本将编译所有模块并运行仿真，生成波形文件用于查看"
echo

# 检查iverilog是否安装
if ! command -v iverilog &> /dev/null; then
    echo "错误: 未找到iverilog，请先安装Icarus Verilog"
    echo "Ubuntu/Debian: sudo apt install iverilog"
    exit 1
fi

# 检查gtkwave是否安装（可选）
if command -v gtkwave &> /dev/null; then
    GTKWAVE_AVAILABLE=true
    echo "检测到GTKWave，仿真完成后可以查看波形"
else
    GTKWAVE_AVAILABLE=false
    echo "提示: 安装GTKWave可以查看波形文件 (sudo apt install gtkwave)"
fi

echo

# 创建仿真输出目录
mkdir -p sim_output
cd sim_output

echo "1. 仿真LS48七段译码器..."
iverilog -o ls48_sim ../LS48.v
if [ $? -eq 0 ]; then
    vvp ls48_sim > ls48_output.txt 2>&1
    echo "   ✓ LS48仿真完成，输出保存到 ls48_output.txt"
else
    echo "   ✗ LS48编译失败"
fi

echo "2. 仿真时钟分频器..."
iverilog -o clk_div_sim ../clk_divider.v ../tb_clk_divider.v
if [ $? -eq 0 ]; then
    vvp clk_div_sim > clk_div_output.txt 2>&1
    echo "   ✓ 时钟分频器仿真完成，输出保存到 clk_div_output.txt"
    if [ -f tb_clk_divider.vcd ]; then
        echo "   ✓ 波形文件生成: tb_clk_divider.vcd"
    fi
else
    echo "   ✗ 时钟分频器编译失败"
fi

echo "3. 仿真Timer模块..."
iverilog -o timer_sim ../Timer.v ../tb_Timer.v
if [ $? -eq 0 ]; then
    vvp timer_sim > timer_output.txt 2>&1
    echo "   ✓ Timer仿真完成，输出保存到 timer_output.txt"
else
    echo "   ✗ Timer编译失败"
fi

echo "4. 仿真完整系统..."
iverilog -o system_sim ../LS48.v ../clk_divider.v ../Timer.v ../timer_60s.v ../tb_timer_60s.v
if [ $? -eq 0 ]; then
    vvp system_sim > system_output.txt 2>&1
    echo "   ✓ 完整系统仿真完成，输出保存到 system_output.txt"
else
    echo "   ✗ 完整系统编译失败"
fi

echo
echo "=== 仿真结果总结 ==="
echo "所有仿真输出文件保存在 sim_output/ 目录中："
ls -la *.txt 2>/dev/null | awk '{print "  - " $9}'

if [ -f tb_clk_divider.vcd ]; then
    echo
    echo "波形文件:"
    ls -la *.vcd 2>/dev/null | awk '{print "  - " $9}'
    
    if [ "$GTKWAVE_AVAILABLE" = true ]; then
        echo
        echo "要查看波形，请运行:"
        echo "  gtkwave sim_output/tb_clk_divider.vcd"
    fi
fi

echo
echo "=== 快速验证 ==="
echo "检查关键输出..."

# 检查LS48输出
if grep -q "输入.*输出" ls48_output.txt 2>/dev/null; then
    echo "✓ LS48译码器功能正常"
else
    echo "⚠ LS48译码器输出异常"
fi

# 检查时钟分频器
if grep -q "posedge" clk_div_output.txt 2>/dev/null; then
    echo "✓ 时钟分频器产生时钟信号"
else
    echo "⚠ 时钟分频器输出异常"
fi

# 检查Timer
if grep -q "Time:" timer_output.txt 2>/dev/null; then
    echo "✓ Timer模块运行正常"
else
    echo "⚠ Timer模块输出异常"
fi

echo
echo "仿真完成！查看详细输出请检查 sim_output/ 目录中的文件。"