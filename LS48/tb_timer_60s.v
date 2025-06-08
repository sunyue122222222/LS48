`timescale 1ns / 1ps

module tb_timer_60s;

    // 输入信号声明
    reg CLK50M;
    reg sys_rst_n;
    reg en;

    // 输出信号声明
    wire [6:0] tens_seg;
    wire [6:0] ones_seg;

    // 实例化被测模块
    timer_60s uut (
       .CLK50M(CLK50M),
       .sys_rst_n(sys_rst_n),
       .en(en),
       .tens_seg(tens_seg),
       .ones_seg(ones_seg)
    );

    // 生成50MHz时钟（周期1000ns）
    initial begin
        CLK50M = 0;
    end 
    always #10 CLK50M = ~CLK50M; // 每10ns翻转一次，形成20ns周期的时钟

    // 测试序列
    initial begin
        // 初始化信号：复位有效，使能无效
        sys_rst_n = 0;
        en = 0;
        #40; // 等待2个时钟周期（40ns）

        // 释放复位，准备计数
        sys_rst_n = 1;
        #20; // 等待1个时钟周期（20ns）

        // 使能计数器，开始计数
        en = 1;
        #4000; // 运行足够长时间（200个时钟周期，观察多次60秒计数）
         
        // 暂停计数器（使能无效）
        en = 0;
        #200; // 等待10个时钟周期（200ns）

        // 再次使能计数器，继续计数
        en = 1;
        #4000; // 再运行200个时钟周期

        // 完成测试
        $stop; // 停止仿真，可通过波形查看结果
    end

endmodule