`timescale 1ns / 1ps

module tb_timer_60s;

    // �����ź�����
    reg clk_50M;
    reg rst, rst_n, en;
    reg key0, key1, key2, key4, key5, key6;
    reg [3:0] ten, one;
    reg pause;

    // ����ź�����
    wire [3:0] tens;
    wire [6:0] out_ge, out_xiao;
    wire point, led;

    // ʵ��������ģ��
    timer_60s uut (
       .clk_50M(clk_50M),
       .rst(rst),
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
       .out_ge(out_ge),
       .out_xiao(out_xiao),
       .point(point),
       .led(led)
    );

    // ����50MHzʱ�ӣ�����20ns��
    initial begin
        clk_50M = 0;
    end 
    always #10 clk_50M = ~clk_50M; // ÿ10ns��תһ�Σ��γ�20ns���ڵ�ʱ��

    // ��������
    initial begin
        // ��ʼ���ź�
        rst = 1;       // ��λ��Ч
        rst_n = 0;     // ��λ��Ч
        en = 0;        // ʹ����Ч
        key0 = 1;      // ����Ĭ�ϸߵ�ƽ
        key1 = 1;
        key2 = 1;
        key4 = 1;
        key5 = 1;
        key6 = 1;
        ten = 4'd1;    // ���ó�ʼʮλ
        one = 4'd5;    // ���ó�ʼ��λ
        pause = 0;     // ����ͣ
        
        #100;          // �ȴ���λ
        
        // �ͷŸ�λ��׼������
        rst = 0;       // �ͷŸ�λ
        rst_n = 1;     // �ͷŸ�λ
        #50;

        // ʹ�ܼ���������ʼ����
        en = 1;
        #200;          // �۲��ʼ״̬
        
        // ��������ʱģʽ
        key0 = 0;      // ����key0��������ʱ
        #40;
        key0 = 1;      // �ͷ�key0
        
        #500;          // �۲�����ʱ
        
        // ���Ե���ʱģʽ
        key1 = 0;      // ����key1��������ʱ
        #40;
        key1 = 1;      // �ͷ�key1
        
        #500;          // �۲쵹��ʱ

        // ��ɲ���
        $finish;       // ��������
    end
    
    // ������
    initial begin
        $monitor("Time: %0t, tens=%d, out_ge=%b, out_xiao=%b, point=%b, led=%b", 
                 $time, tens, out_ge, out_xiao, point, led);
    end

endmodule