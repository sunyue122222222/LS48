`timescale 1ns / 1ps

module tb_Timer;

    // �ź�����
    reg clk_1hz;
    reg rst_n;
    reg en;
    wire [3:0] tens_seg;
    wire [3:0] ones_seg;

    // ʵ��������ģ��
    Timer uut (
       .clk_1hz(clk_1hz),
       .rst_n(rst_n),
       .en(en),
       .tens_seg(tens_seg),
       .ones_seg(ones_seg)
    );

    // ����1Hzʱ�ӣ�����20ns������Ϊ�˿��ٹ۲��������ڣ�ʵ��1Hz������1000ns���˴���Ϊ����۲췽�㣩
    initial begin
        clk_1hz = 0;
    end
    always  #10 clk_1hz = ~clk_1hz;  // ����20ns��ģ�����ʱ�ӱ��ڹ۲�

    // ��������
    initial begin
        // ��ʼ���ź�
        rst_n = 1;  // ����rst_n=1���Ǹ�λ��
        en = 1;     // ʹ����Ч
        #40;        // �ȴ�2������ʱ�����ڣ�20ns*2����ȷ��ģ���ڷǸ�λ״̬�¹���
        rst_n = 0;  // ���͸�λ
        en = 0;     // ʹ����Ч
        #40;        // �ȴ�2��ʱ������
        rst_n = 1;  // �ͷŸ�λ
        en = 1;     // ����ʹ��
        #200;       // ���ж��ʱ�����ڹ۲����
        rst_n = 1;  // �ͷŸ�λ
        en = 0;     // ����ʹ��
        #20; 
        rst_n = 1;  // �ͷŸ�λ
        en = 1;     // ����ʹ��
        #80; 
        $stop;      // ֹͣ����
    end
endmodule