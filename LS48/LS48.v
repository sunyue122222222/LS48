`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 21:59:46
// Design Name: 
// Module Name: LS48
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: LS48 BCD to 7-segment decoder
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

// LS48 BCD to 7-segment decoder module
module LS48 (
    input wire D, C, B, A,    // BCD输入 (4位)
    input wire BI,            // 消隐输入 (低电平有效)
    input wire LT,            // 灯测试输入 (低电平有效)
    input wire RBI,           // 灭零输入 (低电平有效)
    output reg RBO,           // 灭零输出 (低电平有效)
    output reg out_a, out_b, out_c, out_d, out_e, out_f, out_g  // 七段输出 (低电平有效)
);

    wire [3:0] bcd_input = {D, C, B, A};
    
    always @(*) begin
        // 默认值
        RBO = 1'b1;
        
        // 灯测试功能 (LT=0时所有段点亮)
        if (!LT) begin
            {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b0000000;
        end
        // 消隐功能 (BI=0时所有段熄灭)
        else if (!BI) begin
            {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b1111111;
        end
        // 灭零功能 (RBI=0且输入为0时所有段熄灭)
        else if (!RBI && bcd_input == 4'b0000) begin
            {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b1111111;
            RBO = 1'b0;  // 输出灭零信号
        end
        // 正常译码功能
        else begin
            case (bcd_input)
                4'b0000: {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b0000001; // 0
                4'b0001: {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b1001111; // 1
                4'b0010: {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b0010010; // 2
                4'b0011: {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b0000110; // 3
                4'b0100: {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b1001100; // 4
                4'b0101: {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b0100100; // 5
                4'b0110: {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b0100000; // 6
                4'b0111: {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b0001111; // 7
                4'b1000: {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b0000000; // 8
                4'b1001: {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b0000100; // 9
                default: {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b1111111; // 无效输入，全部熄灭
            endcase
        end
    end

endmodule

// 测试台模块
module tb_LS48;

    // 信号声明
    reg D, C, B, A;    // BCD输入
    reg BI, LT, RBI;  // 控制输入
    wire RBO;         // 灭零输出
    wire out_a, out_b, out_c, out_d, out_e, out_f, out_g; // 七段输出
    
    // 实例化被测试模块
    LS48 uut (
       .D(D),
       .C(C),
       .B(B),
       .A(A),
       .BI(BI),
       .LT(LT),
       .RBI(RBI),
       .RBO(RBO),
       .out_a(out_a),
       .out_b(out_b),
       .out_c(out_c),
       .out_d(out_d),
       .out_e(out_e),
       .out_f(out_f),
       .out_g(out_g)
    );

    // 测试序列
    initial begin
        // 初始化信号
        D = 1'b0; C = 1'b0; B = 1'b0; A = 1'b0;
        BI = 1'b1; LT = 1'b1; RBI = 1'b1;
        #100;
        
        // 1. 测试灯测试功能 (LT=0)
        $display("=== 测试灯测试功能 (LT=0) ===");
        LT = 1'b0;
        #100;
        
        // 2. 测试消隐功能 (BI=0)
        $display("=== 测试消隐功能 (BI=0) ===");
        LT = 1'b1;
        BI = 1'b0;
        #100;
        
        // 3. 测试正常译码功能
        $display("=== 测试正常译码功能 (0-9) ===");
        BI = 1'b1;
        RBI = 1'b1;
        
        // 测试数字0-9
        for (integer i = 0; i <= 9; i = i + 1) begin
            {D, C, B, A} = i;
            $display("输入: %d (BCD: %b), 输出: %b%b%b%b%b%b%b", 
                     i, {D, C, B, A}, out_a, out_b, out_c, out_d, out_e, out_f, out_g);
            #100;
        end
        
        // 4. 测试灭零功能 (RBI=0且输入为0)
        $display("=== 测试灭零功能 (RBI=0且输入为0) ===");
        {D, C, B, A} = 4'b0000;
        RBI = 1'b0;
        #100;
        
        // 5. 测试无效输入 (10-15)
        $display("=== 测试无效输入 (10-15) ===");
        RBI = 1'b1;
        
        for (integer i = 10; i <= 15; i = i + 1) begin
            {D, C, B, A} = i;
            $display("输入: %d (BCD: %b), 输出: %b%b%b%b%b%b%b", 
                     i, {D, C, B, A}, out_a, out_b, out_c, out_d, out_e, out_f, out_g);
            #100;
        end
        
        $finish;
    end
    
    // 监控输出结果
    initial begin
        $monitor("时间: %0t, D=%b, C=%b, B=%b, A=%b, BI=%b, LT=%b, RBI=%b, RBO=%b, 七段输出: %b%b%b%b%b%b%b",
                 $time, D, C, B, A, BI, LT, RBI, RBO, out_a, out_b, out_c, out_d, out_e, out_f, out_g);
    end

endmodule    
