module Instruction_Decoder_Unit(
    sys_clk,
    sys_resetb,

    CMD,
    Operand_ID,

    DATA_i0,
    DATA_i1,
    DATA_i2,
    DATA_i3,

    DATA_loop_0,
    DATA_loop_1,
    DATA_loop_2,
    DATA_loop_3,        

    init,
    CTS,
    
    DATA_output_0,
    DATA_output_1,
    DATA_output_2,
    DATA_output_3
);


///////////////Modify from higher hierarchy////////////
parameter ROW = 5'b0;
parameter COLUMN = 3'b0;
///////////////////////////////////////////////////////

/////////////////////Input/////////////////////
input       sys_clk;
input       sys_resetb;

input   [3:0] CMD;
input   [7:0] Operand_ID;

input   [47:0] DATA_i0;
input   [47:0] DATA_i1;
input   [47:0] DATA_i2;
input   [47:0] DATA_i3;

input   [47:0] DATA_loop_0;        // For Data maintain
input   [47:0] DATA_loop_1;
input   [47:0] DATA_loop_2;
input   [47:0] DATA_loop_3;

input          init;
input          CTS;
/////////////////////output/////////////////////
output   [47:0] DATA_output_0;
output   [47:0] DATA_output_1;
output   [47:0] DATA_output_2;
output   [47:0] DATA_output_3;

/////////////////////Wire/////////////////////
wire       sys_clk;
wire       sys_resetb;

wire   [3:0] CMD;
wire   [7:0] Operand_ID;

wire [47:0] DATA0_w;
wire [47:0] DATA1_w;
wire [47:0] DATA2_w;
wire [47:0] DATA3_w;

wire [47:0] Wire_B0;
wire [47:0] Wire_B1;
wire [47:0] Wire_B2;
wire [47:0] Wire_B3;

wire [47:0] Wire_C0;
wire [47:0] Wire_C1;
wire [47:0] Wire_C2;
wire [47:0] Wire_C3;

wire [47:0] Wire_D0;
wire [47:0] Wire_D1;
wire [47:0] Wire_D2;
wire [47:0] Wire_D3;
//-----------------------------------------------------
//------------------------shfit------------------------
//-----------------------------------------------------
reg [3:0] count_init;
reg [3:0] count_CTS;

wire      done_init;
wire      done_CTS;

reg       done_init_d;
reg       done_CTS_d;

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

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) begin
		count_CTS <= 4'd15;
	end
	else if(CTS) begin
		count_CTS <= 4'd15;
	end
	else if(count_CTS==4'd0) begin
		count_CTS <= count_CTS;
	end
	else begin
		count_CTS <= count_CTS - 1'b1;
	end
end

assign done_init = (count_init==4'd1) ? 4'b1 : 4'b0;
assign done_CTS  = (count_CTS==4'd1)  ? 4'b1 : 4'b0;

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) begin
		done_init_d <= 1'b0;
	end
	else begin
		done_init_d <= done_init;
	end
end

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) begin
		done_CTS_d <= 1'b0;
	end
	else begin
		done_CTS_d <= done_CTS;
	end
end



//-----------------------------------------------------
//-----------------------------------------------------
wire   Immediate_6x1;
wire   Immediate_6x2;
wire   Immediate_12x1;
wire   Immediate_12x2;
wire   Fill;
wire   CMD_COLUMN0;
wire   CMD_COLUMN1;
wire   CMD_ROW0;
wire   CMD_ROW1;
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
wire [2:0] position;
assign position = ((CMD==4'b1011)&&((Operand_ID[2:0]==COLUMN||Operand_ID[2:0]==COLUMN+1'b1))) ? Operand_ID[7:5] : 3'd6;
//-------------------------------------------------------------------------------------------------------------------------------------------
wire [47:0] DATA_COLUMN0;
assign DATA_COLUMN0 = (position == 3'd5) ? {DATA_i0[7:0],Wire_B0[39:0]} :
                      (position == 3'd4) ? {Wire_B0[47:40],DATA_i0[7:0],Wire_B0[31:0]} :
                      (position == 3'd3) ? {Wire_B0[47:32],DATA_i0[7:0],Wire_B0[23:0]} :
                      (position == 3'd2) ? {Wire_B0[47:32],DATA_i0[7:0],Wire_B0[23:0]} :
                      (position == 3'd1) ? {Wire_B0[47:32],DATA_i0[7:0],Wire_B0[23:0]} :
                      (position == 3'd0) ? {Wire_B0[47:32],DATA_i0[7:0],Wire_B0[23:0]} : Wire_B0;

wire [47:0] DATA_COLUMN1;
assign DATA_COLUMN1 = (position == 3'd5) ? {DATA_i0[7:0],Wire_B1[39:0]} :
                      (position == 3'd4) ? {Wire_B1[47:40],DATA_i0[7:0],Wire_B1[31:0]} :
                      (position == 3'd3) ? {Wire_B1[47:32],DATA_i0[7:0],Wire_B1[23:0]} :
                      (position == 3'd2) ? {Wire_B1[47:32],DATA_i0[7:0],Wire_B1[23:0]} :
                      (position == 3'd1) ? {Wire_B1[47:32],DATA_i0[7:0],Wire_B1[23:0]} :
                      (position == 3'd0) ? {Wire_B1[47:32],DATA_i0[7:0],Wire_B1[23:0]} : Wire_B1;

wire [47:0] DATA_COLUMN2;
assign DATA_COLUMN2 = (position == 3'd5) ? {DATA_i0[7:0],Wire_B2[39:0]} :
                      (position == 3'd4) ? {Wire_B2[47:40],DATA_i0[7:0],Wire_B2[31:0]} :
                      (position == 3'd3) ? {Wire_B2[47:32],DATA_i0[7:0],Wire_B2[23:0]} :
                      (position == 3'd2) ? {Wire_B2[47:32],DATA_i0[7:0],Wire_B2[23:0]} :
                      (position == 3'd1) ? {Wire_B2[47:32],DATA_i0[7:0],Wire_B2[23:0]} :
                      (position == 3'd0) ? {Wire_B2[47:32],DATA_i0[7:0],Wire_B2[23:0]} : Wire_B2;

wire [47:0] DATA_COLUMN3;
assign DATA_COLUMN3 = (position == 3'd5) ? {DATA_i0[7:0],Wire_B3[39:0]} :
                      (position == 3'd4) ? {Wire_B3[47:40],DATA_i0[7:0],Wire_B3[31:0]} :
                      (position == 3'd3) ? {Wire_B3[47:32],DATA_i0[7:0],Wire_B3[23:0]} :
                      (position == 3'd2) ? {Wire_B3[47:32],DATA_i0[7:0],Wire_B3[23:0]} :
                      (position == 3'd1) ? {Wire_B3[47:32],DATA_i0[7:0],Wire_B3[23:0]} :
                      (position == 3'd0) ? {Wire_B3[47:32],DATA_i0[7:0],Wire_B3[23:0]} : Wire_B3;                                            
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
assign   Immediate_6x1  = (CMD==4'b0100) ? 1'b1 : 1'b0;
assign   Immediate_6x2  = (CMD==4'b0101) ? 1'b1 : 1'b0;
assign   Immediate_12x1 = (CMD==4'b0110) ? 1'b1 : 1'b0;
assign   Immediate_12x2 = (CMD==4'b0111) ? 1'b1 : 1'b0;

assign   Fill           = (CMD==4'b1000) ? 1'b1 : 1'b0;

assign   CMD_COLUMN0 = (CMD==4'b1011&&(Operand_ID[2:0]==(COLUMN)))      ? 1'b1 : 1'b0;
assign   CMD_COLUMN1 = (CMD==4'b1011&&(Operand_ID[2:0]==(COLUMN+1'b1))) ? 1'b1 : 1'b0;
assign   CMD_ROW0    = (CMD==4'b1010&&(Operand_ID[7:3]==(ROW)))         ? 1'b1 : 1'b0;
assign   CMD_ROW1    = (CMD==4'b1010&&(Operand_ID[7:3]==(ROW+1'b1)))    ? 1'b1 : 1'b0;
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------Immediate-----------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
DATA_Process_IDU #(.ROW(ROW), .COLUMN(COLUMN)) IMMEDIATE_Process(
    .sys_clk(sys_clk),
    .sys_resetb(sys_resetb),

    .CMD(CMD),
    .Operand_ID(Operand_ID),

    .DATA_loop_0(DATA_loop_0),
    .DATA_loop_1(DATA_loop_1),
    .DATA_loop_2(DATA_loop_2),
    .DATA_loop_3(DATA_loop_3),            

    .DATA0_i(DATA_i0),
    .DATA1_i(DATA_i1),
    .DATA2_i(DATA_i2),
    .DATA3_i(DATA_i3),
    
    .init(done_init_d),

    .DATA0_o(DATA0_w),
    .DATA1_o(DATA1_w),
    .DATA2_o(DATA2_w),
    .DATA3_o(DATA3_w)
);
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
assign Wire_B0 = (done_init_d & (Fill)) ? {6{Operand_ID}} : DATA0_w;     // DATA Transimission when FIll
assign Wire_B1 = (done_init_d & (Fill)) ? {6{Operand_ID}} : DATA1_w;
assign Wire_B2 = (done_init_d & (Fill)) ? {6{Operand_ID}} : DATA2_w;
assign Wire_B3 = (done_init_d & (Fill)) ? {6{Operand_ID}} : DATA3_w;

assign Wire_C0 = (done_init_d & CMD_COLUMN0)      ? DATA_COLUMN0 : Wire_B0; // DATA Transimission when COLUMN
assign Wire_C1 = (done_init_d & CMD_COLUMN1)      ? DATA_COLUMN1 : Wire_B1;
assign Wire_C2 = (done_init_d & CMD_COLUMN0)      ? DATA_COLUMN2 : Wire_B2;
assign Wire_C3 = (done_init_d & CMD_COLUMN1)      ? DATA_COLUMN3 : Wire_B3;

assign Wire_D0 = ((done_init_d & CMD_ROW0))      ? {6{DATA_i0[7:0]}} : Wire_C0; // DATA Transimission when ROW
assign Wire_D1 = ((done_init_d & CMD_ROW0))      ? {6{DATA_i0[7:0]}} : Wire_C1;
assign Wire_D2 = ((done_init_d & CMD_ROW1))      ? {6{DATA_i0[7:0]}} : Wire_C2;
assign Wire_D3 = ((done_init_d & CMD_ROW1))      ? {6{DATA_i0[7:0]}} : Wire_C3;

// DATA Transimission when Linear Restore Save
Linear_Save_Restore Process0(
    .sys_clk(sys_clk),
    .sys_resetb(sys_resetb),

    .CMD(CMD),
    .Operand_ID(Operand_ID),

    .DATA_i({Wire_D1,Wire_D0}),

    .init(init),
    .CTS(done_CTS_d),

    .DATA_o({DATA_output_1,DATA_output_0})
);

Linear_Save_Restore Process1(
    .sys_clk(sys_clk),
    .sys_resetb(sys_resetb),

    .CMD(CMD),
    .Operand_ID(Operand_ID),

    .DATA_i({Wire_D3,Wire_D2}),

    .init(init),
    .CTS(done_CTS_d),

    .DATA_o({DATA_output_3,DATA_output_2})
);
endmodule
