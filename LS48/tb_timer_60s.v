`timescale 1ns / 1ps

module tb_timer_60s;

    // 输入信号声明
    reg clk_50M;
    reg rst, rst_n, en;
    reg key0, key1, key2, key4, key5, key6;
    reg [3:0] ten, one;
    reg pause;

    // 输出信号声明
    wire [3:0] tens;
    wire [6:0] out_ge, out_xiao;
    wire point, led;

    // 实例化被测模块
    timer_60s uut (
       .clk_50M(clk_50M),
       .rst(rst),
       .rst_n(rst_n),
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

    // 生成50MHz时钟（周期20ns）
    initial begin
        clk_50M = 0;
    end 
    always #10 clk_50M = ~clk_50M; // 每10ns翻转一次，形成20ns周期的时钟

    // 测试序列
    initial begin
        // 初始化信号
        rst = 1;       // 复位有效
        rst_n = 0;     // 复位有效
        en = 0;        // 使能无效
        key0 = 1;      // 按键默认高电平
        key1 = 1;
        key2 = 1;
        key4 = 1;
        key5 = 1;
        key6 = 1;
        ten = 4'd1;    // 设置初始十位
        one = 4'd5;    // 设置初始个位
        pause = 0;     // 不暂停
        
        #100;          // 等待复位
        
        // 释放复位，准备计数
        rst = 0;       // 释放复位
        rst_n = 1;     // 释放复位
        #50;

        // 使能计数器，开始计数
        en = 1;
        #200;          // 观察初始状态
        
        // 测试正计时模式
        key0 = 0;      // 按下key0启动正计时
        #40;
        key0 = 1;      // 释放key0
        
        #500;          // 观察正计时
        
        // 测试倒计时模式
        key1 = 0;      // 按下key1启动倒计时
        #40;
        key1 = 1;      // 释放key1
        
        #500;          // 观察倒计时

        // 完成测试
        $finish;       // 结束仿真
    end
    
    // 监控输出
    initial begin
        $monitor("Time: %0t, tens=%d, out_ge=%b, out_xiao=%b, point=%b, led=%b", 
                 $time, tens, out_ge, out_xiao, point, led);
    end

endmodule