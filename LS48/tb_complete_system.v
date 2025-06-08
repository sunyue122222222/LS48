`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 完整系统仿真测试台
// 包含所有模块的综合测试，生成详细的波形文件
//////////////////////////////////////////////////////////////////////////////////

module tb_complete_system;

    // 系统时钟和复位
    reg clk_50M;
    reg rst, rst_n, en;
    
    // 按键输入
    reg key0, key1, key2, key4, key5, key6;
    reg [3:0] ten, one;
    reg pause;
    
    // 系统输出
    wire [3:0] tens;
    wire [6:0] out_ge, out_xiao;
    wire point, led;
    
    // 内部时钟信号（用于观察）
    wire clk_1hz, clk_2hz, clk_4hz, clk_10hz;
    
    // 实例化完整系统
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
    
    // 连接内部时钟信号用于观察
    assign clk_1hz = uut.clk_1hz;
    assign clk_2hz = uut.clk_2hz;
    assign clk_4hz = uut.clk_4hz;
    assign clk_10hz = uut.clk_10hz;
    
    // 生成50MHz主时钟
    initial begin
        clk_50M = 0;
    end
    always #10 clk_50M = ~clk_50M;  // 20ns周期 = 50MHz
    
    // 主测试序列
    initial begin
        // 生成波形文件
        $dumpfile("complete_system.vcd");
        $dumpvars(0, tb_complete_system);
        
        // 初始化所有信号
        rst = 1;
        rst_n = 0;
        en = 0;
        key0 = 1;
        key1 = 1;
        key2 = 1;
        key4 = 1;
        key5 = 1;
        key6 = 1;
        ten = 4'd2;
        one = 4'd5;
        pause = 0;
        
        $display("=== 完整系统仿真开始 ===");
        $display("时间: %0t - 系统初始化", $time);
        
        // 复位阶段
        #200;
        rst = 0;
        rst_n = 1;
        en = 1;
        $display("时间: %0t - 释放复位，使能系统", $time);
        
        // 观察初始状态
        #300;
        $display("时间: %0t - 观察初始状态: tens=%d, out_ge=%b, out_xiao=%b", 
                 $time, tens, out_ge, out_xiao);
        
        // 测试正计时模式
        $display("时间: %0t - 开始测试正计时模式", $time);
        key0 = 0;  // 按下key0
        #100;
        key0 = 1;  // 释放key0
        $display("时间: %0t - 启动正计时", $time);
        
        // 观察正计时过程
        #800;
        $display("时间: %0t - 正计时状态: tens=%d, out_ge=%b, point=%b", 
                 $time, tens, out_ge, point);
        
        // 测试倒计时模式
        $display("时间: %0t - 开始测试倒计时模式", $time);
        key1 = 0;  // 按下key1
        #100;
        key1 = 1;  // 释放key1
        $display("时间: %0t - 启动倒计时", $time);
        
        // 观察倒计时过程
        #800;
        $display("时间: %0t - 倒计时状态: tens=%d, out_ge=%b, point=%b", 
                 $time, tens, out_ge, point);
        
        // 测试频率切换
        $display("时间: %0t - 测试频率切换", $time);
        key5 = 0;  // 按下key5切换频率
        #50;
        key5 = 1;
        #400;
        $display("时间: %0t - 频率切换后状态", $time);
        
        // 测试精度模式
        $display("时间: %0t - 测试精度模式", $time);
        key6 = 0;  // 按下key6启用精度
        #50;
        key6 = 1;
        #600;
        $display("时间: %0t - 精度模式状态: xiaoshu=%d, point=%b", 
                 $time, uut.u_Timer.xiaoshu, point);
        
        // 测试暂停功能
        $display("时间: %0t - 测试暂停功能", $time);
        key4 = 0;  // 按下key4
        pause = 1; // 启用暂停
        #300;
        $display("时间: %0t - 暂停状态", $time);
        
        pause = 0; // 取消暂停
        #300;
        key4 = 1;  // 释放key4
        $display("时间: %0t - 恢复运行", $time);
        
        // 最终观察
        #500;
        $display("时间: %0t - 最终状态: tens=%d, out_ge=%b, out_xiao=%b, led=%b", 
                 $time, tens, out_ge, out_xiao, led);
        
        $display("=== 完整系统仿真结束 ===");
        $finish;
    end
    
    // 监控关键信号变化
    always @(posedge clk_1hz) begin
        $display("1Hz时钟上升沿 - 时间: %0t", $time);
    end
    
    always @(tens or out_ge or out_xiao) begin
        if ($time > 0) begin
            $display("显示更新 - 时间: %0t, tens=%d, ge_seg=%b, xiao_seg=%b", 
                     $time, tens, out_ge, out_xiao);
        end
    end
    
    // 检测模式切换
    always @(uut.u_Timer.mode) begin
        if ($time > 0) begin
            case (uut.u_Timer.mode)
                1'b0: $display("模式切换 - 时间: %0t, 切换到正计时模式", $time);
                1'b1: $display("模式切换 - 时间: %0t, 切换到倒计时模式", $time);
            endcase
        end
    end

endmodule