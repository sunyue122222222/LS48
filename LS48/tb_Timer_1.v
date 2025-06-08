`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/07 19:49:15
// Design Name: 
// Module Name: tb_Timer_1
// Project Name: 
// Target Devices: 
// Tool Versions: 

// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module tb_Timer;
    // 1. ���������źţ��� Timer ģ�����������Ӧ��
    reg clk_1hz;    // 50MHz ʱ�ӣ��������� 1Hz��
     reg cnt_2hz;    // 50MHz ʱ�ӣ��������� 1Hz��
      reg cnt_4hz;    // 50MHz ʱ�ӣ��������� 1Hz��
    reg cnt_10hz;    // 50MHz ʱ�ӣ��������� 1Hz��
    reg rst_n;        // ��λ������Ч��
    reg en;           // ʹ�ܣ�����Ч��
    reg key0, key1, key2, key4, key5, key6; // �����ź�
    reg [3:0] ten;    // Ԥ��ʮλ
    reg [3:0] one;    // Ԥ�ø�λ
    reg pause;        // ��ͣ�ź�
    
    wire [3:0] tens;  // ʮλ���
    wire [3:0] ones;  // ��λ���
    wire [3:0] xiaoshu; // С��λ���
    wire point;       // С����
    wire led;         // С����˸

    // 2. ʵ���� Timer ģ��
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

    // 3. ���� 50MHz ʱ�ӣ����� 20ns��
    always #20 clk_1hz = ~clk_1hz;
    always #10 cnt_2hz = ~cnt_2hz;
     always #5 cnt_4hz = ~cnt_4hz;
      always #2 cnt_10hz = ~cnt_10hz;

    // 4. ��ʼ�������ź�
    initial begin
        // ��ʼ�������ź�
        clk_1hz = 0;
        cnt_2hz=0;
        cnt_4hz=0;
        cnt_10hz=0;
        rst_n = 0;   // ��ʼ��λ״̬
        en = 0;      // ʹ�ܹر�
        key0 = 0; key1 = 0; key2 = 0; key4 = 0; key5 = 0; key6 = 0;
        ten = 0; one = 0;
        pause = 0;

        #200; // ����ͣ��

        // ���� 1��������ʱ������ʱ��
        en = 1;  // ����ģ��
        #200;
         rst_n=1;#200;
          rst_n=0;#200; // ����ͣ��
        key0 = 1; #400; key0 = 0; #100; // ��������ʱ��������

        // ���� 2���л�����ʱ
        key1 = 1; key2 = 1; #400; key1 = 0; key2 = 0; #100;
         

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

    // 5. ��ʾ���沨�Σ���ѡ��
    initial begin
        $monitor(
            "Time = %t, tens = %d, ones = %d, xiaoshu = %d, point = %b, led = %b",
            $time, tens, ones, xiaoshu, point, led
        );
    end

endmodule
