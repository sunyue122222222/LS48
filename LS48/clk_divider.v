`timescale 1ns / 1ps

module clk_divider (
    input wire clk_50M,    // 50MHz��ʱ��
    input wire rst_n,      // �͵�ƽ��λ
    output reg clk_1hz,    // 1Hz���
    output reg clk_2hz,    // 2Hz���
    output reg clk_4hz,    // 4Hz���
    output reg clk_10hz    // 10Hz���
);

// ʵ��Ӳ����Ƶϵ��
parameter SIM_MODE = 0;  // 0:Ӳ��ģʽ, 1:����ģʽ

// ����ģʽѡ���Ƶϵ��
localparam DIV_1HZ  = SIM_MODE ? 28'd20      : 28'd24_999_999;  // 1Hz
localparam DIV_2HZ  = SIM_MODE ? 27'd10      : 27'd12_499_999;  // 2Hz
localparam DIV_4HZ  = SIM_MODE ? 26'd5       : 26'd6_249_999;   // 4Hz
localparam DIV_10HZ = SIM_MODE ? 25'd2       : 25'd2_499_999;   // 10Hz

// ��Ƶ������
reg [27:0] cnt_1hz;
reg [26:0] cnt_2hz;
reg [25:0] cnt_4hz;
reg [24:0] cnt_10hz;

// 1Hz��Ƶ��
always @(posedge clk_50M or negedge rst_n) begin
    if (!rst_n) begin
        cnt_1hz <= 0;
        clk_1hz <= 0;
    end else if (cnt_1hz == DIV_1HZ) begin
        cnt_1hz <= 0;
        clk_1hz <= ~clk_1hz;
    end else begin
        cnt_1hz <= cnt_1hz + 1;
    end
end

// 2Hz��Ƶ��
always @(posedge clk_50M or negedge rst_n) begin
    if (!rst_n) begin
        cnt_2hz <= 0;
        clk_2hz <= 0;
    end else if (cnt_2hz == DIV_2HZ) begin
        cnt_2hz <= 0;
        clk_2hz <= ~clk_2hz;
    end else begin
        cnt_2hz <= cnt_2hz + 1;
    end
end

// 4Hz��Ƶ��
always @(posedge clk_50M or negedge rst_n) begin
    if (!rst_n) begin
        cnt_4hz <= 0;
        clk_4hz <= 0;
    end else if (cnt_4hz == DIV_4HZ) begin
        cnt_4hz <= 0;
        clk_4hz <= ~clk_4hz;
    end else begin
        cnt_4hz <= cnt_4hz + 1;
    end
end

// 10Hz��Ƶ��
always @(posedge clk_50M or negedge rst_n) begin
    if (!rst_n) begin
        cnt_10hz <= 0;
        clk_10hz <= 0;
    end else if (cnt_10hz == DIV_10HZ) begin
        cnt_10hz <= 0;
        clk_10hz <= ~clk_10hz;
    end else begin
        cnt_10hz <= cnt_10hz + 1;
    end
end

endmodule
