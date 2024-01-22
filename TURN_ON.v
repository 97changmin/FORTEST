(* DONT_TOUCH = "yes" *)
module TURN_ON_PWM(
    sys_clk,
    sys_resetb,

    CMD,

    DATA_i0,
    DATA_i1,
    DATA_i2,
    DATA_i3,
    
    CTS,
    error_flag,
    
    DATA_loop_0,
    DATA_loop_1,
    DATA_loop_2,
    DATA_loop_3,

    pwm_o
);
//------------------------------------------
input           sys_clk;
input           sys_resetb;

input  [3:0]    CMD;

input  [47:0]   DATA_i0;
input  [47:0]   DATA_i1;
input  [47:0]   DATA_i2;
input  [47:0]   DATA_i3;

input           CTS;
input           error_flag;
//------------------------------------------
output [47:0] DATA_loop_0;
output [47:0] DATA_loop_1;
output [47:0] DATA_loop_2;
output [47:0] DATA_loop_3;

output [23:0]   pwm_o;
//----------------------------------------------------------------------------------
//----------------------------------------------------------------------------------
//----------------------------------------------------------------------------------
//----------------------------------------------------------------------------------
reg [3:0] count_CTS;
wire done_CTS;
reg done_CTS_d;

wire  [47:0]   DATA_w0;
wire  [47:0]   DATA_w1;
wire  [47:0]   DATA_w2;
wire  [47:0]   DATA_w3;

assign DATA_w0 = (!(CMD==4'b1110)&&!error_flag) ? DATA_i0 : DATA_loop_0;
assign DATA_w1 = (!(CMD==4'b1110)&&!error_flag) ? DATA_i1 : DATA_loop_1;
assign DATA_w2 = (!(CMD==4'b1110)&&!error_flag) ? DATA_i2 : DATA_loop_2;
assign DATA_w3 = (!(CMD==4'b1110)&&!error_flag) ? DATA_i3 : DATA_loop_3;


always@(posedge sys_clk or negedge sys_resetb) begin 
	if(!sys_resetb) begin
		count_CTS <= 4'd15;
	end
	else if(CTS) begin
		count_CTS <= 4'd15;
	end
	else if(count_CTS==1'b0) begin
		count_CTS <= count_CTS;
	end
	else begin
		count_CTS <= count_CTS - 1'b1;
	end
end

assign done_CTS  = (count_CTS==4'd1)  ? 4'b1 : 4'b0;

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) begin
		done_CTS_d <= 1'b0;
	end
	else begin
		done_CTS_d <= done_CTS;
	end
end

Brightness_PWM PWMG00(
    .sys_clk(sys_clk),
    .sys_resetb(sys_resetb),
    .DATA_i(DATA_w0),

    .CTS(done_CTS_d),
    
	.DATA_Brightness_o(DATA_loop_0),                     // FOR Loop and FPGA verification
    .pwm_o(pwm_o[5:0])
);

Brightness_PWM PWMG01(
    .sys_clk(sys_clk),
    .sys_resetb(sys_resetb),
    .DATA_i(DATA_w1),

    .CTS(done_CTS_d),
	
    .DATA_Brightness_o(DATA_loop_1),
    .pwm_o(pwm_o[11:6])
);

Brightness_PWM PWMG10(
    .sys_clk(sys_clk),
    .sys_resetb(sys_resetb),
    .DATA_i(DATA_w2),

    .CTS(done_CTS_d),
	
    .DATA_Brightness_o(DATA_loop_2),
    .pwm_o(pwm_o[17:12])
);

Brightness_PWM PWMG11(
    .sys_clk(sys_clk),
    .sys_resetb(sys_resetb),
    .DATA_i(DATA_w3),

    .CTS(done_CTS_d),

    .DATA_Brightness_o(DATA_loop_3),
    .pwm_o(pwm_o[23:18])
);



endmodule