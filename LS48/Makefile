# Makefile for LS48 project
# 使用Icarus Verilog进行仿真

# 编译器
IVERILOG = iverilog
VVP = vvp

# 源文件
LS48_SRC = LS48.v
CLK_DIV_SRC = clk_divider.v
TIMER_SRC = Timer.v
TIMER_60S_SRC = timer_60s.v

# 测试台文件
LS48_TB = LS48.v
CLK_DIV_TB = tb_clk_divider.v
TIMER_TB = tb_Timer.v
TIMER_60S_TB = tb_timer_60s.v

# 输出文件
LS48_OUT = ls48_test
CLK_DIV_OUT = clk_divider_test
TIMER_OUT = timer_test
TIMER_60S_OUT = timer_60s_test

# 默认目标
all: test_ls48 test_clk_divider test_timer test_timer_60s

# 仿真目标
simulate: test_complete_system
	@echo "=== 运行仿真脚本 ==="
	./simulate.sh

# 编译和测试LS48模块
test_ls48: $(LS48_OUT)
	@echo "=== 测试LS48模块 ==="
	$(VVP) $(LS48_OUT)

$(LS48_OUT): $(LS48_SRC)
	$(IVERILOG) -o $(LS48_OUT) $(LS48_SRC)

# 编译和测试时钟分频器
test_clk_divider: $(CLK_DIV_OUT)
	@echo "=== 测试时钟分频器 ==="
	$(VVP) $(CLK_DIV_OUT)

$(CLK_DIV_OUT): $(CLK_DIV_SRC) $(CLK_DIV_TB)
	$(IVERILOG) -o $(CLK_DIV_OUT) $(CLK_DIV_SRC) $(CLK_DIV_TB)

# 编译和测试Timer模块
test_timer: $(TIMER_OUT)
	@echo "=== 测试Timer模块 ==="
	$(VVP) $(TIMER_OUT)

$(TIMER_OUT): $(TIMER_SRC) $(TIMER_TB)
	$(IVERILOG) -o $(TIMER_OUT) $(TIMER_SRC) $(TIMER_TB)

# 编译和测试完整的timer_60s模块
test_timer_60s: $(TIMER_60S_OUT)
	@echo "=== 测试timer_60s模块 ==="
	$(VVP) $(TIMER_60S_OUT)

$(TIMER_60S_OUT): $(LS48_SRC) $(CLK_DIV_SRC) $(TIMER_SRC) $(TIMER_60S_SRC) $(TIMER_60S_TB)
	$(IVERILOG) -o $(TIMER_60S_OUT) $(LS48_SRC) $(CLK_DIV_SRC) $(TIMER_SRC) $(TIMER_60S_SRC) $(TIMER_60S_TB)

# 编译和测试完整系统（带波形输出）
test_complete_system: complete_system_test
	@echo "=== 测试完整系统（生成波形） ==="
	$(VVP) complete_system_test

complete_system_test: $(LS48_SRC) $(CLK_DIV_SRC) $(TIMER_SRC) $(TIMER_60S_SRC) tb_complete_system.v
	$(IVERILOG) -o complete_system_test $(LS48_SRC) $(CLK_DIV_SRC) $(TIMER_SRC) $(TIMER_60S_SRC) tb_complete_system.v

# 清理生成的文件
clean:
	rm -f $(LS48_OUT) $(CLK_DIV_OUT) $(TIMER_OUT) $(TIMER_60S_OUT) complete_system_test
	rm -f *.vcd
	rm -rf sim_output

# 语法检查
syntax_check:
	@echo "=== 语法检查 ==="
	$(IVERILOG) -t null $(LS48_SRC)
	$(IVERILOG) -t null $(CLK_DIV_SRC)
	$(IVERILOG) -t null $(TIMER_SRC)
	$(IVERILOG) -t null $(TIMER_60S_SRC) $(LS48_SRC) $(CLK_DIV_SRC) $(TIMER_SRC)
	@echo "所有文件语法检查通过！"

# 帮助信息
help:
	@echo "可用的目标："
	@echo "  all              - 运行所有测试"
	@echo "  test_ls48        - 测试LS48模块"
	@echo "  test_clk_divider - 测试时钟分频器"
	@echo "  test_timer       - 测试Timer模块"
	@echo "  test_timer_60s   - 测试timer_60s模块"
	@echo "  test_complete_system - 测试完整系统并生成波形"
	@echo "  simulate         - 运行完整仿真脚本"
	@echo "  syntax_check     - 检查所有文件的语法"
	@echo "  clean            - 清理生成的文件"
	@echo "  help             - 显示此帮助信息"

.PHONY: all test_ls48 test_clk_divider test_timer test_timer_60s test_complete_system simulate clean syntax_check help