`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 02:18:21
// Design Name: 
// Module Name: timer_60tb
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

`timescale 1ns / 1ps

module tb_timer_60s();

// �����ź�
reg clk_50M;
reg rst_n;
reg rst;
reg en;
reg key0, key1, key2, key4, key5, key6;
reg [3:0] ten;
reg [3:0] one;
reg pause;

// ����ź�
wire [3:0] tens;
wire [6:0]out_ge;
wire [6:0]out_xiao;
wire point;
wire led;

// ʵ��������ģ��
timer_60s uut (
    .clk_50M(clk_50M),
    .ret(rst_n),
    .rst(rst),
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

// ����50MHzʱ��
always #1 clk_50M = ~clk_50M;  // 20ns���� = 50MHz

// ��������
initial begin
     // ��ʼ�������ź�
       clk_50M=0;
        rst_n = 1; 
        rst=0;  // ��ʼ��λ״̬
        en = 0;      // ʹ�ܹر�
        key0 = 0; key1 = 0; key2 = 0; key4 = 0; key5 = 0; key6 = 0;
        ten = 0; one = 0;
        pause = 0;

        #200; // ����ͣ��
        
        // ���� 1��������ʱ������ʱ�� 
        en = 1;  // ����ģ��
        rst=1;
        #200;
        key0 = 1; #400; key0 = 0; #100; // ��������ʱ��������
       rst_n=0;#200;
        // ���� 2���л�����ʱ
       rst_n = 1;   key1 = 1; key2 = 1; #400; key1 = 0; key2 = 0; #100;
         

        // ���� 6��ģ��ָ�����
        key4 = 0; key2=1;one=9;ten=1;#200; key4 = 1; #400;
        // ���� 5��ģ����ͣ����
        pause = 1; #400; pause = 0; #200;

        // ���� 3������Ƶ��ģʽ��key5 �л� 1Hz / 2Hz / 4Hz / 10Hz��
        key5 = 1; #40; key5 = 0; #200; // ��һ���л�
        key5 = 1; #40; key5 = 0; #200; // �ڶ����л�
        key5 = 1; #40; key5 = 0; #400; // �������л�

        // ���� 4������������ʾģʽ��key6 �л���
        key6 = 1; #40; key6 = 0; #200; // ��һ���л�
        key6 = 1; #40; key6 = 0; #200; // �ڶ����л�

      

        // ��������
        #5000;
        $finish;
    end

endmodule
