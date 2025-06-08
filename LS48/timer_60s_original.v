`timescale 1ns / 1ps

module timer_60s (
    input wire clk_50M,   
    input wire rst, 
    input wire rst_n,      
    input wire en,        
    input wire key0,
    input wire key1,
    input wire key2, 
    input wire key4,
    input wire key5,
    input wire key6,
    input wire [3:0] ten,
    input wire [3:0] one,
    input wire pause,
    output wire [3:0] tens,
    output wire [6:0] out_ge,
    output wire [6:0] out_xiao,
    output wire point,
    output wire led
);
    // ��Ƶ�����
    wire clk_1hz, clk_2hz, clk_4hz, clk_10hz;

    // ʵ������Ƶ����ʹ�÷���ģʽ��
    clk_divider #(.SIM_MODE(1)) u_clk_divider (  // ���÷���ģʽ
        .clk_50M(clk_50M),
        .rst_n(rst),  // ʹ��rst��Ϊ��λ������Ч��
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .clk_4hz(clk_4hz),
        .clk_10hz(clk_10hz)
    );

    
    wire [3:0] ones_reg;
    wire [3:0] xiaoshu_reg;
    
    // �޸�2��ֱ������Timer�����reg�ź�
    Timer u_Timer (
        .clk_1hz(clk_1hz),
        .cnt_2hz(clk_2hz),
        .cnt_4hz(clk_4hz),
        .cnt_10hz(clk_10hz),
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
        .ones(ones_reg),  // ֱ�����ӵ�reg
        .xiaoshu(xiaoshu_reg), // ֱ�����ӵ�reg
        .point(point),
        .led(led)     // ֱ�����ӵ�reg
    );

    // �޸�3����ӳ�ʼֵȷ���źŶ���
// ʵ����LS48ģ�飨��λ����ܣ�
wire out_a_ge, out_b_ge, out_c_ge, out_d_ge, out_e_ge, out_f_ge, out_g_ge;
LS48 u_LS48_ones (
    .D(ones_reg[3]),
    .C(ones_reg[2]),
    .B(ones_reg[1]),
    .A(ones_reg[0]),
    .BI(1'b1),
    .LT(1'b1),
    .RBI(1'b1),
    .RBO(),
    .out_a(out_a_ge),
    .out_b(out_b_ge),
    .out_c(out_c_ge),
    .out_d(out_d_ge),
    .out_e(out_e_ge),
    .out_f(out_f_ge),
    .out_g(out_g_ge)
);

// ʵ����LS48ģ�飨С��λ����ܣ�
wire out_a_xiao, out_b_xiao, out_c_xiao, out_d_xiao, out_e_xiao, out_f_xiao, out_g_xiao;
LS48 u_LS48_xiaoshu (
    .D(xiaoshu_reg[3]),
    .C(xiaoshu_reg[2]),
    .B(xiaoshu_reg[1]),
    .A(xiaoshu_reg[0]),
    .BI(1'b1),
    .LT(1'b1),
    .RBI(1'b1),
    .RBO(),
    .out_a(out_a_xiao),
    .out_b(out_b_xiao),
    .out_c(out_c_xiao),
    .out_d(out_d_xiao),
    .out_e(out_e_xiao),
    .out_f(out_f_xiao),
    .out_g(out_g_xiao)
);

// �������ź���ϳ��������
assign out_ge = {out_a_ge, out_b_ge, out_c_ge, out_d_ge, out_e_ge, out_f_ge, out_g_ge};
assign out_xiao = {out_a_xiao, out_b_xiao, out_c_xiao, out_d_xiao, out_e_xiao, out_f_xiao, out_g_xiao};

endmodule