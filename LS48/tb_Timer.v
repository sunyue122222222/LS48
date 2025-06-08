`timescale 1ns / 1ps

module tb_Timer;

    // 信号声明
    reg clk_1hz;
    reg rst_n;
    reg en;
    wire [3:0] tens_seg;
    wire [3:0] ones_seg;

    // 实例化被测模块
    Timer uut (
       .clk_1hz(clk_1hz),
       .rst_n(rst_n),
       .en(en),
       .tens_seg(tens_seg),
       .ones_seg(ones_seg)
    );

    // 生成1Hz时钟（周期20ns，这里为了快速观察缩短周期，实际1Hz周期是1000ns，此处仅为仿真观察方便）
    initial begin
        clk_1hz = 0;
    end
    always  #10 clk_1hz = ~clk_1hz;  // 周期20ns，模拟快速时钟便于观察

    // 测试序列
    initial begin
        // 初始化信号
        rst_n = 1;  // 先让rst_n=1（非复位）
        en = 1;     // 使能有效
        #40;        // 等待2个完整时钟周期（20ns*2），确保模块在非复位状态下工作
        rst_n = 0;  // 拉低复位
        en = 0;     // 使能无效
        #40;        // 等待2个时钟周期
        rst_n = 1;  // 释放复位
        en = 1;     // 重新使能
        #200;       // 运行多个时钟周期观察计数
        rst_n = 1;  // 释放复位
        en = 0;     // 重新使能
        #20; 
        rst_n = 1;  // 释放复位
        en = 1;     // 重新使能
        #80; 
        $stop;      // 停止仿真
    end
endmodule