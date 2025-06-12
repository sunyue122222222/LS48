`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 12:00:11
// Design Name: 
// Module Name: tb_clk_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_clk_divider();

// �����ź�
reg clk_50M;
reg rst_n;

// ����ź�
wire clk_1hz;
wire clk_2hz;
wire clk_4hz;
wire clk_10hz;

// ʵ��������ģ�飨ʹ�÷���ģʽ��
clk_divider #(.SIM_MODE(1)) uut (
    .clk_50M(clk_50M),
    .rst_n(rst_n),
    .clk_1hz(clk_1hz),
    .clk_2hz(clk_2hz),
    .clk_4hz(clk_4hz),
    .clk_10hz(clk_10hz)
);

// ����50MHz��ʱ��
always #10 clk_50M = ~clk_50M;  // 20ns���� = 50MHz

// ��ʼ������
initial begin
    // ��ʼ���ź�
    clk_50M = 0;
    rst_n = 0;  // ��ʼ��λ
    
    // ���ɲ����ļ�������Vivado�ȹ��߲鿴��
    $dumpfile("tb_clk_divider.vcd");
    $dumpvars(0, tb_clk_divider);
    
    // �ͷŸ�λ
    #100 rst_n = 1;
    
    // �����㹻��ʱ��۲��������
    #2000;  // 2000ns = 100����ʱ������
    
    // �ٴθ�λ����
    rst_n = 0;
    #100;
    rst_n = 1;
    #1000;
    
    $finish;
end

// �Զ���֤���Ƶ��
initial begin
    // �ȴ���λ�ͷ�
    wait(rst_n == 1);
    
    // ��֤1Hz�źţ�����ģʽ��ӦΪ20�����ڷ�ת��
    #400;  // �ȴ��ȶ�
    if (clk_1hz !== 1'b1) $error("1Hz clock not toggling correctly");
    
    // ��֤10Hz�źţ�Ӧ��1Hz��10����
    @(posedge clk_10hz);
    repeat(5) @(posedge clk_10hz);
    if ($time > 500) $error("10Hz too slow");
    
    // �ɹ���Ϣ
    #100 $display("All tests passed!");
end

// ʵʱ����źű仯
always @(posedge clk_1hz)  $display("1Hz posedge at %t", $time);
always @(posedge clk_2hz)  $display("2Hz posedge at %t", $time);
always @(posedge clk_4hz)  $display("4Hz posedge at %t", $time);
always @(posedge clk_10hz) $display("10Hz posedge at %t", $time);

endmodule
