module Timer(
    input wire clk_1hz,    // 1Hz时钟
    input wire cnt_2hz,
    input wire cnt_4hz,
    input wire cnt_10hz,
    input wire rst_n,      // 复位（低有效）
    input wire en,        //使能输出
    input wire key0,
    input wire key1,
    input wire key2, 
    input wire key4,
    input wire key5,
    input wire key6,
    input wire [3:0]ten,
    input wire [3:0]one,
    input wire pause,
            // 使能（高有效）
    output wire [3:0] tens,  // 十位输出（0-5）
    output wire[3:0] ones,  // 个位输出（0-9）
    output wire [3:0] xiaoshu,
    output wire point,
    output wire led          //小灯闪烁
);
reg mode;//正计时还是倒计时
reg running;//暂停还是不暂停
reg [2:0]count=0;
reg [1:0]count1=0;
wire clk=0;
reg key5_last;
reg key6_last;
reg key0_last;
reg key1_last;
reg [3:0] tens1; // 十位输出（0-5）
reg [3:0] ones1;  // 个位输出（0-9）
reg [3:0] xiaoshu1;
reg  point1;
reg  led1;
assign tens=tens1;
assign ones=ones1;
assign xiaoshu=xiaoshu1;
assign point=point1;
assign led=led1;
always@(posedge clk)begin 
    key5_last=key5;
    key6_last=key6;
    key0_last=key0;
    key1_last=key1;
end
wire key5_up;
wire key6_up;
wire key0_up;
wire key1_up;
assign key5_up=key5&&(!key5_last);
assign key6_up=key6&&(!key6_last);
assign key0_up=key0&&(!key0_last);
assign key1_up=key1&&(!key1_last);
assign clk = 
 (count1==1) ? cnt_10hz :         // 先判断是否需要高精度时钟（count1生效）
  (count == 0) ? clk_1hz :       // 再处理count的分频
  (count == 1) ? cnt_2hz :    
  (count == 2) ? cnt_4hz : 
  clk_1hz;                               // 默认1Hz


reg remark0=0;
reg remark1=0;

reg [3:0]count2=0;

always@(posedge clk)begin 
   if(!en)begin
     xiaoshu1<=0;
     tens1<=0;
     ones1<=0;
     point1<=0;
     running<=0;
     led1<=0;
  end else begin
  if(rst_n) begin
      ones1<=9;
      tens1<=1;
      running<=0;
  end else begin
  if(key0_up)begin
      remark0<=1;
      ones1<=0;
      tens1<=0;
      mode<=0;
      running<=1;
  end 
  if(key1_up)begin
      remark1<=1;
      running<=1;
      mode<=1;
      ones1<=9;
      tens1<=1; 
  end 
  if(!key0&!key1)begin
      remark0<=0;
      remark1<=0;
      running=0;
  end  
  if(remark1)begin
       running=1;
       mode<=1;
  end
  if(remark0) begin
       mode<=0;
       running<=1;
  end
  if(!key4&!pause&(!key0&!key1))begin 
     mode=1;
     tens1=ten;
     ones1=one;
     running=0;
  end else if(key4&!pause)begin
      running=1;
  end else if((key4&pause)||(!key4&pause))begin
      running=0;
  end
   if(!key2)begin
    mode=0;
  end else if(key2) begin
    mode=1;
  end
  if(key5_up)begin
        count<=count+1;
        if(count>2)begin
          count<=0;
        end
    end
    if(key6_up)begin
          count1<=count1+1;
          if(count1>1)begin
          count1<=0;
        end
       
    end
  if(running)begin
        if(!mode)begin
            if(count1==1)begin //有精度
                  point1<=1;
                  if(xiaoshu1<9)begin
                   xiaoshu1<=xiaoshu1+1;
                  end else begin
                      xiaoshu1<=0;
                      if (ones1 < 9) begin
                       ones1 <= ones1 + 1;
                       end else begin
                          ones1 <= 0;
                          if (tens1 < 5) begin
                             tens1 <= tens1 + 1;
                          end else begin
                              tens1 <= 0;
                          end
                      end
                   end
                  
            end else if(!(count1==1))  begin  //没有精度
                point1=0;xiaoshu1=0;
                if(ones1<9)begin
                   ones1 <= ones1 + 1;
                end else begin
                    ones1 <= 0;
                 if (tens1 < 5) begin
                      tens1 <= tens1 + 1;
                      end else begin
                          tens1 <= 0;
                      end
                  end
            end
       end else begin // 倒计时
            if(count1==1)begin 
                point1<=1;
                  if(xiaoshu1>0)begin  //当key6按下的时候,显示精度
                  xiaoshu1<=xiaoshu1-1;
                  end else begin
                      xiaoshu1<=9;
                      if (ones1 >0) begin
                       ones1 <= ones1 - 1;
                       end else begin
                         ones1 <= 9;
                          if (tens1 >0) begin
                             tens1 <= tens1 - 1;
                          end else begin
                              tens1 <= 5;
                          end
                      end
                   end
            end else if(!(count1==1))begin
                 xiaoshu1<=0;
                 point1=0;
                  if (ones1 > 0) begin
                    ones1 <= ones1 - 1;
                    if(tens1==0&&ones1<8&&key4) begin
                         led1=~led1;
                         if(led1)begin
                         count2<=count2+1;
                         if(count2==3)begin
                            count2<=0;
                              led1=0;
                         end
                     end
                  end 
                  end else begin
                     ones1 <= 9;
                     if (tens1 >0) begin
                             tens1 <= tens1 - 1;
                      end else begin
                              tens1 <= 5;
                       end
                 end
            end
        end 
   end
 end
 end
end
endmodule
