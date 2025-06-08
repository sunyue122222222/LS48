`timescale 1ns / 1ps

module tb_timer_simple;

    // 输入信号
    reg clk_1hz, cnt_2hz, cnt_4hz, cnt_10hz;
    reg rst_n, en;
    reg key0, key1, key2, key4, key5, key6;
    reg [3:0] ten, one;
    reg pause;
    
    // 输出信号
    wire [3:0] tens, ones, xiaoshu;
    wire point, led;
    
    // 实例化Timer模块
    Timer uut (
        .clk_1hz(clk_1hz),
        .cnt_2hz(cnt_2hz),
        .cnt_4hz(cnt_4hz),
        .cnt_10hz(cnt_10hz),
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
        .ones(ones),
        .xiaoshu(xiaoshu),
        .point(point),
        .led(led)
    );
    
    // 生成时钟信号
    initial begin
        clk_1hz = 0;
        cnt_2hz = 0;
        cnt_4hz = 0;
        cnt_10hz = 0;
        
        forever begin
            #50 cnt_10hz = ~cnt_10hz;   // 10Hz: 100ns周期
        end
    end
    
    always begin
        #125 cnt_4hz = ~cnt_4hz;        // 4Hz: 250ns周期
    end
    
    always begin
        #250 cnt_2hz = ~cnt_2hz;        // 2Hz: 500ns周期
    end
    
    always begin
        #500 clk_1hz = ~clk_1hz;        // 1Hz: 1000ns周期
    end
    
    // 测试序列
    initial begin
        // 生成波形文件
        $dumpfile("timer_simple.vcd");
        $dumpvars(0, tb_timer_simple);
        
        $display("=== Timer模块功能测试 ===");
        
        // 初始化
        rst_n = 0;
        en = 0;
        key0 = 1; key1 = 1; key2 = 1; key4 = 1; key5 = 1; key6 = 1;
        ten = 4'd1; one = 4'd5;  // 设定15秒
        pause = 0;
        
        #100;
        rst_n = 1;
        en = 1;
        $display("时间: %0t - 系统复位完成", $time);
        
        #200;
        
        // 测试1: 正计时模式
        $display("\n=== 测试正计时模式 ===");
        key0 = 0; #50; key0 = 1;  // 按下并释放KEY0
        $display("时间: %0t - 启动正计时", $time);
        
        // 观察几个时钟周期
        repeat(5) begin
            @(posedge clk_1hz);
            $display("时间: %0t - 正计时: %0d%0d.%0d, point=%b, led=%b", 
                     $time, tens, ones, xiaoshu, point, led);
        end
        
        // 测试精度模式
        $display("\n--- 切换到精度模式 ---");
        key6 = 0; #50; key6 = 1;  // 切换精度
        $display("时间: %0t - 切换到0.1秒精度", $time);
        
        repeat(10) begin
            @(posedge cnt_10hz);
            $display("时间: %0t - 高精度: %0d%0d.%0d, point=%b", 
                     $time, tens, ones, xiaoshu, point);
        end
        
        // 测试暂停
        $display("\n--- 测试暂停功能 ---");
        key4 = 0; #50; key4 = 1;  // 暂停
        $display("时间: %0t - 暂停计时", $time);
        
        repeat(3) begin
            @(posedge cnt_10hz);
            $display("时间: %0t - 暂停中: %0d%0d.%0d", 
                     $time, tens, ones, xiaoshu);
        end
        
        key4 = 0; #50; key4 = 1;  // 继续
        $display("时间: %0t - 继续计时", $time);
        
        repeat(5) begin
            @(posedge cnt_10hz);
            $display("时间: %0t - 继续: %0d%0d.%0d", 
                     $time, tens, ones, xiaoshu);
        end
        
        // 测试2: 倒计时模式
        $display("\n=== 测试倒计时模式 ===");
        key1 = 0; #50; key1 = 1;  // 启动倒计时
        $display("时间: %0t - 启动倒计时，初始: %0d%0d", $time, ten, one);
        
        repeat(8) begin
            @(posedge clk_1hz);
            $display("时间: %0t - 倒计时: %0d%0d.%0d, led=%b", 
                     $time, tens, ones, xiaoshu, led);
        end
        
        $display("\n=== 测试完成 ===");
        $finish;
    end

endmodule