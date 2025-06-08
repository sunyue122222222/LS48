`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/07 19:49:15
// Design Name: 
// Module Name: tb_Timer_1
// Project Name: 
// Target Devices: 
// Tool Versions: 

// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module tb_Timer;
    // 1. 声明测试信号（与 Timer 模块输入输出对应）
    reg clk_1hz;    // 50MHz 时钟（用于生成 1Hz）
     reg cnt_2hz;    // 50MHz 时钟（用于生成 1Hz）
      reg cnt_4hz;    // 50MHz 时钟（用于生成 1Hz）
    reg cnt_10hz;    // 50MHz 时钟（用于生成 1Hz）
    reg rst_n;        // 复位（低有效）
    reg en;           // 使能（高有效）
    reg key0, key1, key2, key4, key5, key6; // 按键信号
    reg [3:0] ten;    // 预置十位
    reg [3:0] one;    // 预置个位
    reg pause;        // 暂停信号
    
    wire [3:0] tens;  // 十位输出
    wire [3:0] ones;  // 个位输出
    wire [3:0] xiaoshu; // 小数位输出
    wire point;       // 小数点
    wire led;         // 小灯闪烁

    // 2. 实例化 Timer 模块
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

    // 3. 生成 50MHz 时钟（周期 20ns）
    always #20 clk_1hz = ~clk_1hz;
    always #10 cnt_2hz = ~cnt_2hz;
     always #5 cnt_4hz = ~cnt_4hz;
      always #2 cnt_10hz = ~cnt_10hz;

    // 4. 初始化测试信号
    initial begin
        // 初始化所有信号
        clk_1hz = 0;
        cnt_2hz=0;
        cnt_4hz=0;
        cnt_10hz=0;
        rst_n = 0;   // 初始复位状态
        en = 0;      // 使能关闭
        key0 = 0; key1 = 0; key2 = 0; key4 = 0; key5 = 0; key6 = 0;
        ten = 0; one = 0;
        pause = 0;

        #200; // 稍作停留

        // 步骤 1：启动计时（正计时）
        en = 1;  // 启动模块
        #200;
         rst_n=1;#200;
          rst_n=0;#200; // 稍作停留
        key0 = 1; #400; key0 = 0; #100; // 产生正计时启动脉冲

        // 步骤 2：切换倒计时
        key1 = 1; key2 = 1; #400; key1 = 0; key2 = 0; #100;
         

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

    // 5. 显示仿真波形（可选）
    initial begin
        $monitor(
            "Time = %t, tens = %d, ones = %d, xiaoshu = %d, point = %b, led = %b",
            $time, tens, ones, xiaoshu, point, led
        );
    end

endmodule
