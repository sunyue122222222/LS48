`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 21:59:46
// Design Name: 
// Module Name: LS48tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
`timescale 1ns / 1ps

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
