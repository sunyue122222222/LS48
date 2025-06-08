`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 02:18:21
// Design Name: 
// Module Name: timer_60tb
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

`timescale 1ns / 1ps

module tb_timer_60s();

// 输入信号
reg clk_50M;
reg rst_n;
reg rst;
reg en;
reg key0, key1, key2, key4, key5, key6;
reg [3:0] ten;
reg [3:0] one;
reg pause;

// 输出信号
wire [3:0] tens;
wire [6:0]out_ge;
wire [6:0]out_xiao;
wire point;
wire led;

// 实例化被测模块
timer_60s uut (
    .clk_50M(clk_50M),
    .ret(rst_n),
    .rst(rst),
    .en(en),
    .key0(key0),
    .key1(key1),
    .key2(key2),
    .key4(key4),
    .key5(key5),
    .key6(key6),
    .ten(ten),
    .one(one),
    .pause(pause),
    .tens(tens),
    .out_ge(out_ge),
    .out_xiao(out_xiao),
    .point(point),
    .led(led)
);

// 生成50MHz时钟
always #1 clk_50M = ~clk_50M;  // 20ns周期 = 50MHz

// 测试序列
initial begin
     // 初始化所有信号
       clk_50M=0;
        rst_n = 1; 
        rst=0;  // 初始复位状态
        en = 0;      // 使能关闭
        key0 = 0; key1 = 0; key2 = 0; key4 = 0; key5 = 0; key6 = 0;
        ten = 0; one = 0;
        pause = 0;

        #200; // 稍作停留
        
        // 步骤 1：启动计时（正计时） 
        en = 1;  // 启动模块
        rst=1;
        #200;
        key0 = 1; #400; key0 = 0; #100; // 产生正计时启动脉冲
       rst_n=0;#200;
        // 步骤 2：切换倒计时
       rst_n = 1;   key1 = 1; key2 = 1; #400; key1 = 0; key2 = 0; #100;
         

        // 步骤 6：模拟恢复计数
        key4 = 0; key2=1;one=9;ten=1;#200; key4 = 1; #400;
        // 步骤 5：模拟暂停功能
        pause = 1; #400; pause = 0; #200;

        // 步骤 3：调整频率模式（key5 切换 1Hz / 2Hz / 4Hz / 10Hz）
        key5 = 1; #40; key5 = 0; #200; // 第一次切换
        key5 = 1; #40; key5 = 0; #200; // 第二次切换
        key5 = 1; #40; key5 = 0; #400; // 第三次切换

        // 步骤 4：调整精度显示模式（key6 切换）
        key6 = 1; #40; key6 = 0; #200; // 第一次切换
        key6 = 1; #40; key6 = 0; #200; // 第二次切换

      

        // 结束仿真
        #5000;
        $finish;
    end

endmodule
