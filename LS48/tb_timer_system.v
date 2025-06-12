`timescale 1ns / 1ps

module tb_timer_system;

    // 输入信号
    reg clk_50M;
    reg rst, rst_n, en;
    reg key0, key1, key2, key4, key5, key6;
    reg [3:0] ten, one;
    reg pause;
    
    // 输出信号
    wire [3:0] tens;
    wire [6:0] out_ge, out_xiao;
    wire point, led;
    
    // 实例化被测试模块
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
    
    // 生成50MHz时钟
    initial begin
        clk_50M = 0;
        forever #10 clk_50M = ~clk_50M;  // 20ns周期 = 50MHz
    end
    
    // 显示七段码的函数
    function [7:0] seg_to_digit;
        input [6:0] seg;
        begin
            case (seg)
                7'b0000001: seg_to_digit = "0";
                7'b1001111: seg_to_digit = "1";
                7'b0010010: seg_to_digit = "2";
                7'b0000110: seg_to_digit = "3";
                7'b1001100: seg_to_digit = "4";
                7'b0100100: seg_to_digit = "5";
                7'b0100000: seg_to_digit = "6";
                7'b0001111: seg_to_digit = "7";
                7'b0000000: seg_to_digit = "8";
                7'b0000100: seg_to_digit = "9";
                default:    seg_to_digit = "?";
            endcase
        end
    endfunction
    
    // 测试序列
    initial begin
        // 生成波形文件
        $dumpfile("timer_system.vcd");
        $dumpvars(0, tb_timer_system);
        
        $display("=== 数字秒表/计时器系统测试开始 ===");
        
        // 初始化信号
        rst = 1;
        rst_n = 0;
        en = 0;
        key0 = 1;
        key1 = 1;
        key2 = 1;
        key4 = 1;
        key5 = 1;
        key6 = 1;
        ten = 4'd1;   // 设定倒计时时间为15秒
        one = 4'd5;
        pause = 0;
        
        // 复位
        #100;
        rst = 0;
        rst_n = 1;
        en = 1;
        $display("时间: %0t - 系统复位完成，使能系统", $time);
        
        #200;
        
        // 测试1: 正计时模式（秒表）
        $display("\n=== 测试1: 正计时模式（秒表） ===");
        key0 = 0;  // 按下KEY0启动秒表
        #50;
        key0 = 1;  // 释放KEY0
        $display("时间: %0t - 启动秒表模式", $time);
        
        // 观察几秒钟的计时
        repeat(5) begin
            #1000;  // 等待1000ns
            $display("时间: %0t - 显示: %0d%c%c", $time, tens, 
                     seg_to_digit(out_ge), seg_to_digit(out_xiao));
        end
        
        // 测试暂停功能
        $display("\n--- 测试暂停功能 ---");
        key4 = 0;  // 按下KEY4暂停
        #50;
        key4 = 1;
        $display("时间: %0t - 暂停计时", $time);
        
        #2000;  // 等待2000ns，时间应该不变
        $display("时间: %0t - 暂停中，显示: %0d%c%c", $time, tens, 
                 seg_to_digit(out_ge), seg_to_digit(out_xiao));
        
        // 继续计时
        key4 = 0;  // 再次按下KEY4继续
        #50;
        key4 = 1;
        $display("时间: %0t - 继续计时", $time);
        
        #2000;
        
        // 测试精度模式切换
        $display("\n--- 测试精度模式切换 ---");
        key6 = 0;  // 按下KEY6切换精度
        #50;
        key6 = 1;
        $display("时间: %0t - 切换到0.1秒精度模式，小数点: %b", $time, point);
        
        // 观察高精度计时
        repeat(3) begin
            #500;
            $display("时间: %0t - 高精度显示: %0d%c.%c", $time, tens, 
                     seg_to_digit(out_ge), seg_to_digit(out_xiao));
        end
        
        // 测试频率切换
        $display("\n--- 测试频率切换 ---");
        key5 = 0;  // 按下KEY5切换频率
        #50;
        key5 = 1;
        $display("时间: %0t - 切换到2Hz频率", $time);
        
        #1000;
        
        // 测试2: 倒计时模式（定时器）
        $display("\n=== 测试2: 倒计时模式（定时器） ===");
        key1 = 0;  // 按下KEY1启动倒计时
        #50;
        key1 = 1;
        $display("时间: %0t - 启动倒计时模式，初始时间: %0d%0d", $time, ten, one);
        
        // 观察倒计时
        repeat(8) begin
            #800;
            $display("时间: %0t - 倒计时显示: %0d%c.%c, LED: %b", $time, tens, 
                     seg_to_digit(out_ge), seg_to_digit(out_xiao), led);
        end
        
        // 测试模式切换
        $display("\n--- 测试模式切换 ---");
        key2 = 0;  // 按下KEY2切换模式
        #50;
        key2 = 1;
        $display("时间: %0t - 切换模式", $time);
        
        #1000;
        
        // 再次启动正计时验证
        key0 = 0;
        #50;
        key0 = 1;
        $display("时间: %0t - 重新启动正计时", $time);
        
        #3000;
        
        $display("\n=== 测试完成 ===");
        $finish;
    end
    
    // 监控显示变化
    always @(tens or out_ge or out_xiao or point or led) begin
        if ($time > 1000) begin  // 跳过初始化阶段
            $display("显示更新 - 时间: %0t, 显示: %0d%c%s%c, LED: %b", 
                     $time, tens, seg_to_digit(out_ge), 
                     point ? "." : " ", seg_to_digit(out_xiao), led);
        end
    end

endmodule