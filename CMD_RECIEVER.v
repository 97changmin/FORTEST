module CMD_reciever(
        sys_clk,
        sys_resetb,

        scl_in,
        sda_in,

        LED_Error_Frame_0_i,
        LED_Error_Frame_1_i,

        sda_oen,
        scl_oen,        

        CMD,
        Operand_ID,

        DATA_o,
        loop_count,



        init,
        CTS,
        CTS_error,
        error_flag
);

//////////////////////////////input//////////////////////////////
input               sys_clk;
input               sys_resetb;

input               sda_in;
input               scl_in;

input [7:0]         LED_Error_Frame_0_i;
input [7:0]         LED_Error_Frame_1_i;
//////////////////////////////output//////////////////////////////
output        sda_oen;
output        scl_oen;

output     [3:0]    CMD;
output     [7:0]    Operand_ID;

output     [47:0]   DATA_o;
output     [1:0]    loop_count;

output        init;
output        CTS;
output        CTS_error;

output        error_flag;
////////////////////////////////Wire////////////////////////////////
wire              sys_clk;
wire              sys_resetb;

wire              sda_in;
wire              scl_in;

wire     [3:0]    CMD;
wire     [7:0]    Operand_ID;

wire     [47:0]   DATA_o;

wire      [1:0]   loop_count;

wire              sda_oen;
wire              scl_oen;

wire              init;
wire              CTS;
wire              CTS_error;

wire              error_flag;
////////////////////////////////////////////////////////////////////////
parameter ROW = 5'b0;
parameter COLUMN = 3'b0;

hlcp_sync    u_hlcp_sync(.sys_clk(sys_clk),
                       .sys_resetb(sys_resetb),
                       .scl_in(scl_in),
                       .sda_in(sda_in),
                       .scl_in_rs(scl_in_rs),
                       .sda_in_rs(sda_in_rs)
                       );

state_machine #(.ROW(ROW), .COLUMN(COLUMN)) brighteness_state_machine 
        (
        .sys_clk(sys_clk),
        .sys_resetb(sys_resetb),

        .scl_in(scl_in_rs),
        .sda_in(sda_in_rs),

        .LED_Error_Frame_0_i(LED_Error_Frame_0_i),
        .LED_Error_Frame_1_i(LED_Error_Frame_1_i),

        .CMD(CMD),              
        .Operand_ID(Operand_ID),                

        .DATA_o(DATA_o),
        .loop_count(loop_count),

        .sda_oen(sda_oen),
        .scl_oen(scl_oen),

        .init(init),            
        .CTS(CTS),                                      // Clear To Send
        .CTS_error(CTS_error),                           // Clear To Send Error
        .error_flag(error_flag)
        );
endmodule