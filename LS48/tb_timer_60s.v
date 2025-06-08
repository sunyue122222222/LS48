`timescale 1ns / 1ps

module tb_timer_60s;

    // �����ź�����
    reg CLK50M;
    reg sys_rst_n;
    reg en;

    // ����ź�����
    wire [6:0] tens_seg;
    wire [6:0] ones_seg;

    // ʵ��������ģ��
    timer_60s uut (
       .CLK50M(CLK50M),
       .sys_rst_n(sys_rst_n),
       .en(en),
       .tens_seg(tens_seg),
       .ones_seg(ones_seg)
    );

    // ����50MHzʱ�ӣ�����1000ns��
    initial begin
        CLK50M = 0;
    end 
    always #10 CLK50M = ~CLK50M; // ÿ10ns��תһ�Σ��γ�20ns���ڵ�ʱ��

    // ��������
    initial begin
        // ��ʼ���źţ���λ��Ч��ʹ����Ч
        sys_rst_n = 0;
        en = 0;
        #40; // �ȴ�2��ʱ�����ڣ�40ns��

        // �ͷŸ�λ��׼������
        sys_rst_n = 1;
        #20; // �ȴ�1��ʱ�����ڣ�20ns��

        // ʹ�ܼ���������ʼ����
        en = 1;
        #4000; // �����㹻��ʱ�䣨200��ʱ�����ڣ��۲���60�������
         
        // ��ͣ��������ʹ����Ч��
        en = 0;
        #200; // �ȴ�10��ʱ�����ڣ�200ns��

        // �ٴ�ʹ�ܼ���������������
        en = 1;
        #4000; // ������200��ʱ������

        // ��ɲ���
        $stop; // ֹͣ���棬��ͨ�����β鿴���
    end

endmodule