module Brightness_PWM(
    sys_clk,
    sys_resetb,

    DATA_i,

    CTS,

    DATA_Brightness_o,

    pwm_o
);
//------------input-----------
input                  sys_clk;
input                  sys_resetb;

input    [47:0]        DATA_i;
input                  CTS;
//------------output-----------
output  [5:0]           pwm_o;
output  [47:0]          DATA_Brightness_o;
//----------reg & wire-----------
reg     [47:0]          DATA_Brightness_o;
reg     [5:0]           pwm;
reg     [7:0]           PWM_COUNT;

wire    [5:0]           pwm_o;
//-------------------------------------------------
always @(posedge sys_clk or negedge sys_resetb) begin
    if (!sys_resetb) begin
        DATA_Brightness_o <= 48'b0;
    end
    else if(CTS) begin
        DATA_Brightness_o <= DATA_i;                    //CLEAR TO SEND
    end
    else begin
        DATA_Brightness_o <= DATA_Brightness_o;
    end
end

//------------------------PWM---------------------------
always@(posedge sys_clk or negedge sys_resetb) 
if(!sys_resetb)
    PWM_COUNT <= 8'b0;
else  begin
    PWM_COUNT <= PWM_COUNT + 1'b1;
end

//-----------------------Brightness-----------------------
always@(posedge sys_clk or negedge sys_resetb) begin
    if(!sys_resetb) begin
        pwm[5] <= 1'b0;
    end
    else if(PWM_COUNT < DATA_Brightness_o[47:40]) begin        //pwm
        pwm[5] <= 1'b1;
    end
    else begin
        pwm[5] <= 1'b0;
    end
end

always@(posedge sys_clk or negedge sys_resetb) begin
    if(!sys_resetb) begin
        pwm[4] <= 1'b0;
    end
    else if(PWM_COUNT < DATA_Brightness_o[39:32]) begin
        pwm[4] <= 1'b1;
    end
    else begin
        pwm[4] <= 1'b0;
    end
end

always@(posedge sys_clk or negedge sys_resetb) begin
    if(!sys_resetb) begin
        pwm[3] <= 1'b0;
    end
    else if(PWM_COUNT < DATA_Brightness_o[31:24]) begin
        pwm[3] <= 1'b1;
    end
    else begin
        pwm[3] <= 1'b0;
    end
end

always@(posedge sys_clk or negedge sys_resetb) begin
    if(!sys_resetb) begin
        pwm[2] <= 1'b0;
    end
    else if(PWM_COUNT < DATA_Brightness_o[23:16]) begin
        pwm[2] <= 1'b1;
    end
    else begin
        pwm[2] <= 1'b0;
    end
end

always@(posedge sys_clk or negedge sys_resetb) begin
    if(!sys_resetb) begin
        pwm[1] <= 1'b0;
    end
    else if(PWM_COUNT < DATA_Brightness_o[15:8]) begin
        pwm[1] <= 1'b1;
    end
    else begin
        pwm[1] <= 1'b0;
    end
end

always@(posedge sys_clk or negedge sys_resetb) begin
    if(!sys_resetb) begin
        pwm[0] <= 1'b0;
    end
    else if(PWM_COUNT < DATA_Brightness_o[7:0]) begin
        pwm[0] <= 1'b1;
    end
    else begin
        pwm[0] <= 1'b0;
    end
end

assign pwm_o = {pwm[5],pwm[4],pwm[3],pwm[2],pwm[1],pwm[0]};
endmodule