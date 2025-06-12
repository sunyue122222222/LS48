module Timer(
    input wire clk_1hz,    // 1Hz时钟
    input wire cnt_2hz,    // 2Hz时钟
    input wire cnt_4hz,    // 4Hz时钟
    input wire cnt_10hz,   // 10Hz时钟
    input wire rst_n,      // 复位（低有效）
    input wire en,         // 使能输出
    input wire key0,       // 启动正计时（秒表）
    input wire key1,       // 启动倒计时（定时器）
    input wire key2,       // 模式切换
    input wire key4,       // 暂停/继续
    input wire key5,       // 切换计时频率
    input wire key6,       // 切换精度显示
    input wire [3:0] ten,  // 设定时间十位
    input wire [3:0] one,  // 设定时间个位
    input wire pause,      // 外部暂停信号
    
    output wire [3:0] tens,    // 十位输出（0-5）
    output wire [3:0] ones,    // 个位输出（0-9）
    output wire [3:0] xiaoshu, // 小数位输出（0-9）
    output wire point,         // 小数点
    output wire led            // LED闪烁
);

    // 内部寄存器
    reg [3:0] tens_reg;
    reg [3:0] ones_reg;
    reg [3:0] xiaoshu_reg;
    reg point_reg;
    reg led_reg;
    
    // 控制信号
    reg mode;              // 0=正计时, 1=倒计时
    reg running;           // 运行状态
    reg [2:0] freq_sel;    // 频率选择 0=1Hz, 1=2Hz, 2=4Hz
    reg precision_mode;    // 精度模式 0=秒, 1=0.1秒
    
    // 按键边沿检测 - 使用固定时钟
    reg key0_last, key1_last, key2_last, key4_last, key5_last, key6_last;
    wire key0_up, key1_up, key2_up, key4_up, key5_up, key6_up;
    
    // LED闪烁计数器
    reg [3:0] led_count;
    reg led_toggle;
    
    // 时钟选择
    wire selected_clk;
    
    // 输出赋值
    assign tens = tens_reg;
    assign ones = ones_reg;
    assign xiaoshu = xiaoshu_reg;
    assign point = point_reg;
    assign led = led_reg;
    
    // 时钟选择逻辑 - 添加默认值避免X态
    assign selected_clk = (!rst_n) ? clk_1hz :
                         precision_mode ? cnt_10hz :
                         (freq_sel == 3'd1) ? cnt_2hz :
                         (freq_sel == 3'd2) ? cnt_4hz : clk_1hz;
    
    // 按键边沿检测 - 使用1Hz时钟避免时钟域问题
    always @(posedge clk_1hz or negedge rst_n) begin
        if (!rst_n) begin
            key0_last <= 1'b1;
            key1_last <= 1'b1;
            key2_last <= 1'b1;
            key4_last <= 1'b1;
            key5_last <= 1'b1;
            key6_last <= 1'b1;
        end else begin
            key0_last <= key0;
            key1_last <= key1;
            key2_last <= key2;
            key4_last <= key4;
            key5_last <= key5;
            key6_last <= key6;
        end
    end
    
    assign key0_up = (!key0) && key0_last;  // 检测下降沿（按键按下）
    assign key1_up = (!key1) && key1_last;
    assign key2_up = (!key2) && key2_last;
    assign key4_up = (!key4) && key4_last;
    assign key5_up = (!key5) && key5_last;
    assign key6_up = (!key6) && key6_last;
    
    // 主控制逻辑
    always @(posedge selected_clk or negedge rst_n) begin
        if (!rst_n) begin
            // 复位状态 - 完整初始化
            tens_reg <= 4'd0;
            ones_reg <= 4'd0;
            xiaoshu_reg <= 4'd0;
            point_reg <= 1'b0;
            led_reg <= 1'b0;
            mode <= 1'b0;
            running <= 1'b0;
            freq_sel <= 3'd0;
            precision_mode <= 1'b0;
            led_count <= 4'd0;
            led_toggle <= 1'b0;
        end else if (!en) begin
            // 禁用状态
            tens_reg <= 4'd0;
            ones_reg <= 4'd0;
            xiaoshu_reg <= 4'd0;
            point_reg <= 1'b0;
            led_reg <= 1'b0;
            running <= 1'b0;
        end else begin
            // 按键处理 - 在1Hz时钟域检测
            
            // KEY0: 启动正计时（秒表）
            if (key0_up) begin
                mode <= 1'b0;          // 正计时模式
                running <= 1'b1;       // 开始运行
                tens_reg <= 4'd0;      // 从00.0开始
                ones_reg <= 4'd0;
                xiaoshu_reg <= 4'd0;
                led_reg <= 1'b0;
            end
            
            // KEY1: 启动倒计时（定时器）
            if (key1_up) begin
                mode <= 1'b1;          // 倒计时模式
                running <= 1'b1;       // 开始运行
                tens_reg <= ten;       // 从设定时间开始
                ones_reg <= one;
                xiaoshu_reg <= 4'd0;
                led_reg <= 1'b0;
                led_count <= 4'd0;
            end
            
            // KEY2: 模式切换
            if (key2_up) begin
                mode <= ~mode;
                running <= 1'b0;       // 停止运行
            end
            
            // KEY4: 暂停/继续
            if (key4_up) begin
                running <= ~running;
            end
            
            // 外部暂停信号
            if (pause) begin
                running <= 1'b0;
            end
            
            // KEY5: 切换计时频率
            if (key5_up) begin
                freq_sel <= (freq_sel >= 3'd2) ? 3'd0 : freq_sel + 1;
            end
            
            // KEY6: 切换精度显示
            if (key6_up) begin
                precision_mode <= ~precision_mode;
                point_reg <= ~precision_mode;  // 精度模式时显示小数点
            end
            
            // 计时逻辑
            if (running) begin
                if (mode == 1'b0) begin
                    // 正计时模式（秒表）
                    if (precision_mode) begin
                        // 0.1秒精度
                        if (xiaoshu_reg < 4'd9) begin
                            xiaoshu_reg <= xiaoshu_reg + 1;
                        end else begin
                            xiaoshu_reg <= 4'd0;
                            if (ones_reg < 4'd9) begin
                                ones_reg <= ones_reg + 1;
                            end else begin
                                ones_reg <= 4'd0;
                                if (tens_reg < 4'd5) begin
                                    tens_reg <= tens_reg + 1;
                                end else begin
                                    tens_reg <= 4'd0;  // 60秒后重新开始
                                end
                            end
                        end
                    end else begin
                        // 1秒精度
                        xiaoshu_reg <= 4'd0;
                        if (ones_reg < 4'd9) begin
                            ones_reg <= ones_reg + 1;
                        end else begin
                            ones_reg <= 4'd0;
                            if (tens_reg < 4'd5) begin
                                tens_reg <= tens_reg + 1;
                            end else begin
                                tens_reg <= 4'd0;  // 60秒后重新开始
                            end
                        end
                    end
                end else begin
                    // 倒计时模式（定时器）
                    if (precision_mode) begin
                        // 0.1秒精度
                        if (xiaoshu_reg > 4'd0) begin
                            xiaoshu_reg <= xiaoshu_reg - 1;
                        end else begin
                            xiaoshu_reg <= 4'd9;
                            if (ones_reg > 4'd0) begin
                                ones_reg <= ones_reg - 1;
                            end else begin
                                ones_reg <= 4'd9;
                                if (tens_reg > 4'd0) begin
                                    tens_reg <= tens_reg - 1;
                                end else begin
                                    // 倒计时结束
                                    tens_reg <= 4'd0;
                                    ones_reg <= 4'd0;
                                    xiaoshu_reg <= 4'd0;
                                    running <= 1'b0;
                                end
                            end
                        end
                    end else begin
                        // 1秒精度
                        xiaoshu_reg <= 4'd0;
                        if (ones_reg > 4'd0) begin
                            ones_reg <= ones_reg - 1;
                        end else begin
                            ones_reg <= 4'd9;
                            if (tens_reg > 4'd0) begin
                                tens_reg <= tens_reg - 1;
                            end else begin
                                // 倒计时结束
                                tens_reg <= 4'd0;
                                ones_reg <= 4'd0;
                                running <= 1'b0;
                            end
                        end
                    end
                    
                    // LED闪烁逻辑（倒计时模式下时间<8秒时）
                    if (tens_reg == 4'd0 && ones_reg < 4'd8) begin
                        led_count <= led_count + 1;
                        if (led_count >= 4'd4) begin  // 每0.4秒切换一次
                            led_count <= 4'd0;
                            led_toggle <= ~led_toggle;
                            led_reg <= led_toggle;
                        end
                    end else begin
                        led_reg <= 1'b0;
                        led_count <= 4'd0;
                        led_toggle <= 1'b0;
                    end
                end
            end
        end
    end

endmodule