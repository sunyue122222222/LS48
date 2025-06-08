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

    // �ź�����
    reg D, C, B, A;    // BCD����
    reg BI, LT, RBI;  // ��������
    wire RBO;         // �������
    wire out_a, out_b, out_c, out_d, out_e, out_f, out_g; // �߶����
    
    // ʵ����������ģ��
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

    // ��������
    initial begin
        // ��ʼ���ź�
        D = 1'b0; C = 1'b0; B = 1'b0; A = 1'b0;
        BI = 1'b1; LT = 1'b1; RBI = 1'b1;
        #100;
        
        // 1. ���ԵƲ��Թ��� (LT=0)
        $display("=== ���ԵƲ��Թ��� (LT=0) ===");
        LT = 1'b0;
        #100;
        
        // 2. ������������ (BI=0)
        $display("=== ������������ (BI=0) ===");
        LT = 1'b1;
        BI = 1'b0;
        #100;
        
        // 3. �����������빦��
        $display("=== �����������빦�� (0-9) ===");
        BI = 1'b1;
        RBI = 1'b1;
        
        // ��������0-9
        for (integer i = 0; i <= 9; i = i + 1) begin
            {D, C, B, A} = i;
            $display("����: %d (BCD: %b), ���: %b%b%b%b%b%b%b", 
                     i, {D, C, B, A}, out_a, out_b, out_c, out_d, out_e, out_f, out_g);
            #100;
        end
        
        // 4. �������㹦�� (RBI=0������Ϊ0)
        $display("=== �������㹦�� (RBI=0������Ϊ0) ===");
        {D, C, B, A} = 4'b0000;
        RBI = 1'b0;
        #100;
        
        // 5. ������Ч���� (10-15)
        $display("=== ������Ч���� (10-15) ===");
        RBI = 1'b1;
        
        for (integer i = 10; i <= 15; i = i + 1) begin
            {D, C, B, A} = i;
            $display("����: %d (BCD: %b), ���: %b%b%b%b%b%b%b", 
                     i, {D, C, B, A}, out_a, out_b, out_c, out_d, out_e, out_f, out_g);
            #100;
        end
        
        $finish;
    end
    
    // ���������
    initial begin
        $monitor("ʱ��: %0t, D=%b, C=%b, B=%b, A=%b, BI=%b, LT=%b, RBI=%b, RBO=%b, �߶����: %b%b%b%b%b%b%b",
                 $time, D, C, B, A, BI, LT, RBI, RBO, out_a, out_b, out_c, out_d, out_e, out_f, out_g);
    end

endmodule    
