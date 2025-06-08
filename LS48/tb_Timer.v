`timescale 1ns / 1ps

module tb_Timer;

    // �ź�����
    reg clk_1hz, cnt_2hz, cnt_4hz, cnt_10hz;
    reg rst_n, en;
    reg key0, key1, key2, key4, key5, key6;
    reg [3:0] ten, one;
    reg pause;
    wire [3:0] tens, ones, xiaoshu;
    wire point, led;

    // ʵ��������ģ��
    Timer uut (
       .clk_1hz(clk_1hz),
       .cnt_2hz(cnt_2hz),
       .cnt_4hz(cnt_4hz),
       .cnt_10hz(cnt_10hz),
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
       .ones(ones),
       .xiaoshu(xiaoshu),
       .point(point),
       .led(led)
    );

    // ����ʱ���ź�
    initial begin
        clk_1hz = 0;
        cnt_2hz = 0;
        cnt_4hz = 0;
        cnt_10hz = 0;
    end
    always #10 clk_1hz = ~clk_1hz;    // 1Hzʱ�ӣ�����20ns
    always #5  cnt_2hz = ~cnt_2hz;    // 2Hzʱ�ӣ�����10ns
    always #2.5 cnt_4hz = ~cnt_4hz;   // 4Hzʱ�ӣ�����5ns
    always #1  cnt_10hz = ~cnt_10hz;  // 10Hzʱ�ӣ�����2ns

    // ��������
    initial begin
        // ��ʼ���ź�
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
        
        #50;           // �ȴ���λ
        rst_n = 1;     // �ͷŸ�λ
        en = 1;        // ʹ����Ч
        
        #100;          // �۲��ʼ״̬
        
        // ��������ʱģʽ
        key0 = 0;      // ����key0��������ʱ
        #20;
        key0 = 1;      // �ͷ�key0
        
        #200;          // �۲�����ʱ
        
        // ���Ե���ʱģʽ
        key1 = 0;      // ����key1��������ʱ
        #20;
        key1 = 1;      // �ͷ�key1
        
        #200;          // �۲쵹��ʱ
        
        $finish;       // ��������
    end
    
    // ������
    initial begin
        $monitor("Time: %0t, tens=%d, ones=%d, xiaoshu=%d, point=%b, led=%b, mode=%b", 
                 $time, tens, ones, xiaoshu, point, led, uut.mode);
    end
endmodule