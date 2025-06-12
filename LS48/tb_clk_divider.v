`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 12:00:11
// Design Name: 
// Module Name: tb_clk_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_clk_divider();

// 输入信号
reg clk_50M;
reg rst_n;

// 输出信号
wire clk_1hz;
wire clk_2hz;
wire clk_4hz;
wire clk_10hz;

// 实例化被测模块（使用仿真模式）
clk_divider #(.SIM_MODE(1)) uut (
    .clk_50M(clk_50M),
    .rst_n(rst_n),
    .clk_1hz(clk_1hz),
    .clk_2hz(clk_2hz),
    .clk_4hz(clk_4hz),
    .clk_10hz(clk_10hz)
);

// 生成50MHz主时钟
always #10 clk_50M = ~clk_50M;  // 20ns周期 = 50MHz

// 初始化测试
initial begin
    // 初始化信号
    clk_50M = 0;
    rst_n = 0;  // 初始复位
    
    // 生成波形文件（用于Vivado等工具查看）
    $dumpfile("tb_clk_divider.vcd");
    $dumpvars(0, tb_clk_divider);
    
    // 释放复位
    #100 rst_n = 1;
    
    // 运行足够长时间观察所有输出
    #2000;  // 2000ns = 100个主时钟周期
    
    // 再次复位测试
    rst_n = 0;
    #100;
    rst_n = 1;
    #1000;
    
    $finish;
end

// 自动验证输出频率
initial begin
    // 等待复位释放
    wait(rst_n == 1);
    
    // 验证1Hz信号（仿真模式下应为20个周期翻转）
    #400;  // 等待稳定
    if (clk_1hz !== 1'b1) $error("1Hz clock not toggling correctly");
    
    // 验证10Hz信号（应比1Hz快10倍）
    @(posedge clk_10hz);
    repeat(5) @(posedge clk_10hz);
    if ($time > 500) $error("10Hz too slow");
    
    // 成功信息
    #100 $display("All tests passed!");
end

// 实时监控信号变化
always @(posedge clk_1hz)  $display("1Hz posedge at %t", $time);
always @(posedge clk_2hz)  $display("2Hz posedge at %t", $time);
always @(posedge clk_4hz)  $display("4Hz posedge at %t", $time);
always @(posedge clk_10hz) $display("10Hz posedge at %t", $time);

endmodule
