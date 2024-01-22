(* DONT_TOUCH = "yes" *)
module PWMC(
        sys_clk,            // clock
        sys_resetb,         // reset

        SCL,
        SDA,

        sda_in,
        scl_in,

        short_i_0,
        open_i_0,

        overheat_0,
        overvoltage_0,
        undervoltage_0,

        short_i_1,
        open_i_1,

        overheat_1,
        overvoltage_1,
        undervoltage_1,

        short_i_2,
        open_i_2,

        overheat_2,
        overvoltage_2,
        undervoltage_2,

        short_i_3,
        open_i_3,

        overheat_3,
        overvoltage_3,
        undervoltage_3,                


        DATA_Brightness_o,
        CTS,
        
        pwm_o
        );

parameter ROW = 5'd0;                           
parameter COLUMN = 3'b1;                        

////////////////////////////////////////input////////////////////////////////////////////////////////
input               sys_clk;
input               sys_resetb;
 
inout               SCL;
inout               SDA;

input               sda_in;
input               scl_in;

input    [5:0]           short_i_0;
input    [5:0]           open_i_0;

input                    overheat_0;
input                    overvoltage_0;
input                    undervoltage_0;

input    [5:0]           short_i_1;
input    [5:0]           open_i_1;

input                    overheat_1;
input                    overvoltage_1;
input                    undervoltage_1;

input    [5:0]           short_i_2;
input    [5:0]           open_i_2;

input                    overheat_2;
input                    overvoltage_2;
input                    undervoltage_2;

input    [5:0]           short_i_3;
input    [5:0]           open_i_3;

input                    overheat_3;
input                    overvoltage_3;
input                    undervoltage_3;
////////////////////////////////////////output//////////////////////////////////////////////////////
output [191:0]       DATA_Brightness_o;
output              CTS;

output [23:0]       pwm_o;
////////////////////////////////////////////////////////////////////////////////////////////////////
wire                        scl_in_rs;
wire                        sda_in_rs;

wire                        scl_oen, sda_oen;

wire    [3:0]               CMD;
wire    [7:0]               Operand_ID;

wire    [1:0]               loop_count;

wire       init;
wire       CTS;                       // Clear To Send
wire       CTS_error;                 // Clear To Send Error

wire [47:0] DATA_LED_w;

wire [47:0] DATA_LED0_w;
wire [47:0] DATA_LED1_w;
wire [47:0] DATA_LED2_w;
wire [47:0] DATA_LED3_w;

wire [47:0] DATA_LED0_w2;
wire [47:0] DATA_LED1_w2;
wire [47:0] DATA_LED2_w2;
wire [47:0] DATA_LED3_w2;
////////////////////////////////////////////////////////////////////////////////////////////////
assign SDA = (~sda_oen) ?  1'b0 : 1'b1;
assign SCL = (~scl_oen) ?  1'b0 : 1'b1;
////////////////////////////////////////////////////////////////////////////////////////////////
reg   [7:0] LED_Error_Frame_0;
reg   [7:0] LED_Error_Frame_1;

reg [47:0] DATA0_r;
reg [47:0] DATA1_r;
reg [47:0] DATA2_r;
reg [47:0] DATA3_r;

always@(*) begin
        LED_Error_Frame_0 = 8'b11111111;
        LED_Error_Frame_1 = 8'b11111111;
        if(CMD==4'b1110&&CTS)begin
                case(Operand_ID)
                  {ROW,COLUMN} : begin
                        LED_Error_Frame_0 = {short_i_0,open_i_0[5:4]};
                        LED_Error_Frame_1 = {open_i_0[3:0],1'b1,overheat_0,overvoltage_0,undervoltage_0};
                  end              
                  {ROW,COLUMN+1'b1} : begin
                        LED_Error_Frame_0 = {short_i_1,open_i_1[5:4]};
                        LED_Error_Frame_1 = {open_i_1[3:0],1'b1,overheat_1,overvoltage_1,undervoltage_1};                        
                  end
                  {ROW+1'b1,COLUMN} : begin
                        LED_Error_Frame_0 = {short_i_2,open_i_2[5:4]};
                        LED_Error_Frame_1 = {open_i_2[3:0],1'b1,overheat_2,overvoltage_2,undervoltage_2};
                  end
                  {ROW+1'b1,COLUMN+1'b1} : begin
                        LED_Error_Frame_0 = {short_i_3,open_i_3[5:4]};
                        LED_Error_Frame_1 = {open_i_3[3:0],1'b1,overheat_3,overvoltage_3,undervoltage_3};
                  end                                 
                endcase
        end                
end

CMD_reciever#(.ROW(ROW), .COLUMN(COLUMN)) Reciever(
        .sys_clk(sys_clk),
        .sys_resetb(sys_resetb),

        .scl_in(scl_in),
        .sda_in(sda_in),

        .sda_oen(sda_oen),
        .scl_oen(scl_oen),

        .CMD(CMD),
        .Operand_ID(Operand_ID),

        .DATA_o(DATA_LED_w),
        .loop_count(loop_count),

        .LED_Error_Frame_0_i(LED_Error_Frame_0),
        .LED_Error_Frame_1_i(LED_Error_Frame_1),

        .init(init),
        .CTS(CTS),
        .CTS_error(CTS_error),
        .error_flag(error_flag)
);



always @(*) begin
        case (loop_count)
                2'd0: DATA0_r = DATA_LED_w;
                2'd1: DATA1_r = DATA_LED_w;
                2'd2: DATA2_r = DATA_LED_w;
                2'd3: DATA3_r = DATA_LED_w;
            default : begin
                DATA0_r = 48'b0;
                DATA1_r = 48'b0;
                DATA2_r = 48'b0;
                DATA3_r = 48'b0;
            end
        endcase
end



Instruction_Decoder_Unit #(.ROW(ROW), .COLUMN(COLUMN)) IDU(
        .sys_clk(sys_clk),
        .sys_resetb(sys_resetb),

        .CMD(CMD),
        .Operand_ID(Operand_ID),

        .DATA_i0(DATA0_r),
        .DATA_i1(DATA1_r),
        .DATA_i2(DATA2_r),
        .DATA_i3(DATA3_r),

        .DATA_loop_0(DATA_LED0_w2), // For data maintain #1
        .DATA_loop_1(DATA_LED1_w2),
        .DATA_loop_2(DATA_LED2_w2),
        .DATA_loop_3(DATA_LED3_w2),                        

        .init(init),
        .CTS(CTS),

        .DATA_output_0(DATA_LED0_w),
        .DATA_output_1(DATA_LED1_w),
        .DATA_output_2(DATA_LED2_w),
        .DATA_output_3(DATA_LED3_w)
);

TURN_ON_PWM PWMGenerate(
    .sys_clk(sys_clk),
    .sys_resetb(sys_resetb),

    .DATA_i0(DATA_LED0_w),
    .DATA_i1(DATA_LED1_w),
    .DATA_i2(DATA_LED2_w),
    .DATA_i3(DATA_LED3_w),
 
    .CTS(CTS),
    .CMD(CMD),

    .DATA_loop_0(DATA_LED0_w2),  // #1
    .DATA_loop_1(DATA_LED1_w2),
    .DATA_loop_2(DATA_LED2_w2),
    .DATA_loop_3(DATA_LED3_w2),

    .error_flag(error_flag),

    .pwm_o(pwm_o)
);

assign DATA_Brightness_o = {DATA_LED3_w2,DATA_LED2_w2,DATA_LED1_w2,DATA_LED0_w2};
endmodule