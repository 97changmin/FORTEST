module Data_Process_module(
        sys_clk,
        sys_resetb,

        CMD,
        Operand_ID,

        DATA_i,  
        loop_count,

        init,
        CTS,
        error_flag,

        DATA_loop_0,
        DATA_loop_1,
        DATA_loop_2,
        DATA_loop_3,                        

        DATA_output0,
        DATA_output1,
        DATA_output2,
        DATA_output3
);

parameter ROW = 5'b0;
parameter COLUMN = 3'b0;
////////////////////////Input////////////////////////
input              sys_clk;
input              sys_resetb;

input [3:0]        CMD;
input [7:0]        Operand_ID;

input [47:0]       DATA_i;
input [1:0]        loop_count;

input              init;
input              CTS;
input              error_flag;

input [47:0]      DATA_loop_0;
input [47:0]      DATA_loop_1;
input [47:0]      DATA_loop_2;
input [47:0]      DATA_loop_3;
////////////////////////output////////////////////////
output [47:0]      DATA_output0;
output [47:0]      DATA_output1;
output [47:0]      DATA_output2;
output [47:0]      DATA_output3;
////////////////////////Wire//////////////////////////
wire        sys_clk;
wire        sys_resetb;

wire  [3:0]  CMD;
wire  [7:0]  Operand_ID;

wire        init;
wire        CTS;

reg  [47:0] DATA_LED0_w1;
reg  [47:0] DATA_LED1_w1;
reg  [47:0] DATA_LED2_w1;
reg  [47:0] DATA_LED3_w1;
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
always @(*) begin
        case (loop_count)
                2'd0: DATA_LED0_w1 = DATA_i;
                2'd1: DATA_LED1_w1 = DATA_i;
                2'd2: DATA_LED2_w1 = DATA_i;
                2'd3: DATA_LED3_w1 = DATA_i;
            default : begin
                DATA_LED0_w1 = 48'b0;
                DATA_LED1_w1 = 48'b0;
                DATA_LED2_w1 = 48'b0;
                DATA_LED3_w1 = 48'b0;
            end
        endcase
end

Instruction_Decoder_Unit #(.ROW(ROW), .COLUMN(COLUMN)) IDU_HLCP(
        .sys_clk(sys_clk),
        .sys_resetb(sys_resetb),

        .CMD(CMD),
        .Operand_ID(Operand_ID),

        .DATA0_i(DATA_LED0_w1),
        .DATA1_i(DATA_LED1_w1),
        .DATA2_i(DATA_LED2_w1),
        .DATA3_i(DATA_LED3_w1),

        .DATA_loop_0(DATA_loop_0),
        .DATA_loop_1(DATA_loop_1),
        .DATA_loop_2(DATA_loop_2),
        .DATA_loop_3(DATA_loop_3),

        .init(init),
        .CTS(CTS),
        .error_flag(error_flag),

        .DATA_output0(DATA_output0),
        .DATA_output1(DATA_output1),
        .DATA_output2(DATA_output2),
        .DATA_output3(DATA_output3)        
        );

endmodule