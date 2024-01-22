module Linear_Save_Restore(
    sys_clk,
    sys_resetb,

    CMD,
    Operand_ID,

    DATA_i,
    init,
    CTS,

    DATA_o
);

//------------------------------------------------------------
input sys_clk;
input sys_resetb;

input [3:0] CMD;
input [7:0] Operand_ID;

input [95:0]  DATA_i;
input         init;
input         CTS;
//------------------------------------------------------------
output [95:0] DATA_o;
//------------------------------------------------------------
wire [95:0]          DATA_o;

reg [1:0]           coeff;  // y = ax + b -> a(0.5 1.0 1.5 2.0) 
reg [5:0]           offset; // y = ax + b -> b(-32 ~ 31)
reg signed  [10:0]  signed_offset_r; // sign extension

reg  [10:0] linear_r;
reg  [7:0]  prev_pwm[11:0];
//-------------------------------------------------------------------------------
reg [3:0] count_init;
wire      done_init;
reg       done_init_d;

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) begin
		count_init <= 4'd15;
	end
	else if(init) begin
		count_init <= 4'd15;
	end
	else if(count_init==4'd0) begin
		count_init <= count_init;
	end
	else begin
		count_init <= count_init - 1'b1;
	end
end

assign done_init = (count_init==4'd1) ? 4'b1 : 4'b0;

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) begin
		done_init_d <= 1'b0;
	end
	else begin
		done_init_d <= done_init;
	end
end
//-----------------------------------------------------------------------------------

//sign extension
always@(*) begin
    coeff = 2'b0;
    offset = 6'b0;
    signed_offset_r = 11'b0;
    if((CMD==4'b1001)&&count_init) begin                                                      //if (CMD==4'b1001), the operator eats a lot of LUTs, so expressed as linear_CMD_en
        coeff  = Operand_ID[7:6];                                                              // y = ax + b -> a(0.5 1.0 1.5 2.0) 
        offset = Operand_ID[5:0];                                                              // y = ax + b -> b(-32 ~ 31)
        signed_offset_r = {offset[5],offset[5],offset[5],offset[5],offset[5],offset};  // sign extension
    end
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
reg [7:0] DATA;

always@*begin
case(count_init)
4'd15 : DATA = DATA_i[95:88];
4'd14 : DATA = DATA_i[87:80];
4'd13 : DATA = DATA_i[79:72];
4'd12 : DATA = DATA_i[71:64];
4'd11 : DATA = DATA_i[63:56];
4'd10 : DATA = DATA_i[55:48];
4'd9 : DATA = DATA_i[47:40];
4'd8 : DATA = DATA_i[39:32];
4'd7 : DATA = DATA_i[31:24];
4'd6 : DATA = DATA_i[23:16];
4'd5 : DATA = DATA_i[15:8];
4'd4 : DATA = DATA_i[7:0];
default : DATA = 96'b0;
endcase
end



reg [95:0]  DATA_linear;

always@(*) begin
    linear_r = DATA;        
    if(CMD==4'b1001&&count_init) begin
    case(coeff)
            2'b00 : begin
                linear_r  = {4'b0,linear_r[7:1]} + signed_offset_r;
            end
            2'b01 : begin
                linear_r  = linear_r + signed_offset_r;
            end
            2'b10 : begin
                linear_r  = linear_r + {4'b0,linear_r[7:1]} + signed_offset_r;
            end
            2'b11 : begin
                linear_r  = {2'b0,linear_r[7:0],1'b0} + signed_offset_r;
            end               
    endcase
    end
    if(linear_r[10])
            linear_r = 8'b0;
    else if((linear_r[9]||linear_r[8]))    
            linear_r = 8'd255;
end

always@(posedge sys_clk or negedge sys_resetb) begin
    if(!sys_resetb)
        DATA_linear <= 96'b0;
    else if(CMD==4'b1001&&count_init>4'h3)
        DATA_linear <= {DATA_linear[87:0],linear_r[7:0]};
    else
        DATA_linear <= DATA_linear;
end

always@(posedge sys_clk or negedge sys_resetb) begin
    if(!sys_resetb) begin
        prev_pwm[11] <= 8'b0; prev_pwm[10] <= 8'b0;
        prev_pwm[9]  <= 8'b0; prev_pwm[8]   <= 8'b0;
        prev_pwm[7]  <= 8'b0; prev_pwm[6]   <= 8'b0;
        prev_pwm[5]  <= 8'b0; prev_pwm[4]   <= 8'b0;
        prev_pwm[3]  <= 8'b0; prev_pwm[2]   <= 8'b0;
        prev_pwm[1]  <= 8'b0; prev_pwm[0]   <= 8'b0;                
    end
    else if(CMD==4'b1100&&CTS) begin
        prev_pwm[11] <=  DATA_i[95:88]; prev_pwm[10] <=  DATA_i[87:80];
        prev_pwm[9] <= DATA_i[79:72]; prev_pwm[8] <=  DATA_i[71:64];
        prev_pwm[7] <= DATA_i[63:56]; prev_pwm[6] <=  DATA_i[55:48];
        prev_pwm[5] <= DATA_i[47:40]; prev_pwm[4] <= DATA_i[39:32];
        prev_pwm[3] <= DATA_i[31:24]; prev_pwm[2] <= DATA_i[23:16];
        prev_pwm[1] <= DATA_i[15:8];  prev_pwm[0] <= DATA_i[7:0];
    end
    else begin
        prev_pwm[11] <= prev_pwm[11]; prev_pwm[10] <= prev_pwm[10];
        prev_pwm[9] <= prev_pwm[9]; prev_pwm[8] <= prev_pwm[8];
        prev_pwm[7] <= prev_pwm[7]; prev_pwm[6] <= prev_pwm[6];        
        prev_pwm[5] <= prev_pwm[5]; prev_pwm[4] <= prev_pwm[4];
        prev_pwm[3] <= prev_pwm[3]; prev_pwm[2] <= prev_pwm[2];
        prev_pwm[1] <= prev_pwm[1]; prev_pwm[0] <= prev_pwm[0];
    end
end

assign DATA_o = (CMD==4'b1001&&done_init_d) ? DATA_linear :
                (CMD==4'b1101&&done_init_d) ? {prev_pwm[11],prev_pwm[10],prev_pwm[9],prev_pwm[8],prev_pwm[7],prev_pwm[6],prev_pwm[5],prev_pwm[4],prev_pwm[3],prev_pwm[2],prev_pwm[1],prev_pwm[0]} :
                DATA_i;
endmodule