`timescale 1ns / 1ps

module timer_60s (
    input wire clk_50M,        // 50MHz主时钟
    input wire rst,            // 复位（高有效）
    input wire rst_n,          // 复位（低有效）
    input wire en,             // 使能
    input wire key0,           // 启动正计时（秒表）
    input wire key1,           // 启动倒计时（定时器）
    input wire key2,           // 模式切换
    input wire key4,           // 暂停/继续
    input wire key5,           // 切换计时频率
    input wire key6,           // 切换精度显示
    input wire [3:0] ten,      // 设定时间十位
    input wire [3:0] one,      // 设定时间个位
    input wire pause,          // 外部暂停信号
    
    output wire [3:0] tens,    // 十位数字（用于数码管显示）
    output wire [6:0] out_ge,  // 个位七段码输出
    output wire [6:0] out_xiao,// 小数位七段码输出
    output wire point,         // 小数点
    output wire led            // LED指示
);

    // 内部时钟信号
    wire clk_1hz, clk_2hz, clk_4hz, clk_10hz;
    wire rst_internal;
    
    // Timer模块输出
    wire [3:0] ones_internal;
    wire [3:0] xiaoshu_internal;
    
    // 复位信号处理
    assign rst_internal = rst | (~rst_n);
    
    // 时钟分频器实例 - 确保使用仿真模式
    clk_divider #(.SIM_MODE(1)) u_clk_divider (
        .clk_50M(clk_50M),
        .rst_n(~rst_internal),
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .clk_4hz(clk_4hz),
        .clk_10hz(clk_10hz)
    );
    
    // Timer核心模块实例
    Timer u_Timer (
        .clk_1hz(clk_1hz),
        .cnt_2hz(clk_2hz),
        .cnt_4hz(clk_4hz),
        .cnt_10hz(clk_10hz),
        .rst_n(~rst_internal),
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
        .ones(ones_internal),
        .xiaoshu(xiaoshu_internal),
        .point(point),
        .led(led)
    );
    
    // LS48译码器实例 - 个位显示
    LS48 u_LS48_ones (
        .D(ones_internal[3]),
        .C(ones_internal[2]),
        .B(ones_internal[1]),
        .A(ones_internal[0]),
        .BI(1'b1),           // 不消隐
        .LT(1'b1),           // 不灯测试
        .RBI(1'b1),          // 不灭零
        .RBO(),              // 未使用
        .out_a(out_ge[6]),
        .out_b(out_ge[5]),
        .out_c(out_ge[4]),
        .out_d(out_ge[3]),
        .out_e(out_ge[2]),
        .out_f(out_ge[1]),
        .out_g(out_ge[0])
    );
    
    // LS48译码器实例 - 小数位显示
    LS48 u_LS48_xiaoshu (
        .D(xiaoshu_internal[3]),
        .C(xiaoshu_internal[2]),
        .B(xiaoshu_internal[1]),
        .A(xiaoshu_internal[0]),
        .BI(1'b1),           // 不消隐
        .LT(1'b1),           // 不灯测试
        .RBI(1'b1),          // 不灭零
        .RBO(),              // 未使用
        .out_a(out_xiao[6]),
        .out_b(out_xiao[5]),
        .out_c(out_xiao[4]),
        .out_d(out_xiao[3]),
        .out_e(out_xiao[2]),
        .out_f(out_xiao[1]),
        .out_g(out_xiao[0])
    );

endmodule