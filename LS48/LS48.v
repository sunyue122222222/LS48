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
    input wire D, C, B, A,    // BCD���� (4λ)
    input wire BI,            // �������� (�͵�ƽ��Ч)
    input wire LT,            // �Ʋ������� (�͵�ƽ��Ч)
    input wire RBI,           // �������� (�͵�ƽ��Ч)
    output reg RBO,           // ������� (�͵�ƽ��Ч)
    output reg out_a, out_b, out_c, out_d, out_e, out_f, out_g  // �߶���� (�͵�ƽ��Ч)
);

    wire [3:0] bcd_input = {D, C, B, A};
    
    always @(*) begin
        // Ĭ��ֵ
        RBO = 1'b1;
        
        // �Ʋ��Թ��� (LT=0ʱ���жε���)
        if (!LT) begin
            {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b0000000;
        end
        // �������� (BI=0ʱ���ж�Ϩ��)
        else if (!BI) begin
            {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b1111111;
        end
        // ���㹦�� (RBI=0������Ϊ0ʱ���ж�Ϩ��)
        else if (!RBI && bcd_input == 4'b0000) begin
            {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b1111111;
            RBO = 1'b0;  // ��������ź�
        end
        // �������빦��
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
                default: {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = 7'b1111111; // ��Ч���룬ȫ��Ϩ��
            endcase
        end
    end

endmodule

// ����̨ģ��
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
