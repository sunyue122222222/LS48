`timescale 1ns / 1ps

module tb_Timer;

    // 信号声明
    reg clk_1hz, cnt_2hz, cnt_4hz, cnt_10hz;
    reg rst_n, en;
    reg key0, key1, key2, key4, key5, key6;
    reg [3:0] ten, one;
    reg pause;
    wire [3:0] tens, ones, xiaoshu;
    wire point, led;

    // 实例化被测模块
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
    end
    always #10 clk_1hz = ~clk_1hz;    // 1Hz时钟，周期20ns
    always #5  cnt_2hz = ~cnt_2hz;    // 2Hz时钟，周期10ns
    always #2.5 cnt_4hz = ~cnt_4hz;   // 4Hz时钟，周期5ns
    always #1  cnt_10hz = ~cnt_10hz;  // 10Hz时钟，周期2ns

    // 测试序列
    initial begin
        // 初始化信号
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
        
        #50;           // 等待复位
        rst_n = 1;     // 释放复位
        en = 1;        // 使能有效
        
        #100;          // 观察初始状态
        
        // 测试正计时模式
        key0 = 0;      // 按下key0启动正计时
        #20;
        key0 = 1;      // 释放key0
        
        #200;          // 观察正计时
        
        // 测试倒计时模式
        key1 = 0;      // 按下key1启动倒计时
        #20;
        key1 = 1;      // 释放key1
        
        #200;          // 观察倒计时
        
        $finish;       // 结束仿真
    end
    
    // 监控输出
    initial begin
        $monitor("Time: %0t, tens=%d, ones=%d, xiaoshu=%d, point=%b, led=%b, mode=%b", 
                 $time, tens, ones, xiaoshu, point, led, uut.mode);
    end
endmodule