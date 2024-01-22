`timescale 1ns/1ps

module hlcp_data_top_MS_tb();

reg                       sys_resetb;
reg                       sys_clk;

wire 					  SDA;
wire					  SCL;

reg						sda_in;
reg						scl_in;

wire 					  SDA_0 , SDA_1 , SDA_2 , SDA_3 , SDA_4 , SDA_5 , SDA_6 , SDA_7, SDA_8, SDA_9, SDA_10, SDA_11, SDA_12, SDA_13, SDA_14, SDA_15;
wire 					  SCL_0 , SCL_1 , SCL_2 , SCL_3 , SCL_4 , SCL_5 , SCL_6 , SCL_7, SCL_8, SCL_9, SCL_10, SCL_11, SCL_12, SCL_13, SCL_14, SCL_15;

initial
begin
	#1
	sys_clk=0;
	sys_resetb = 1;
	#1 sys_resetb = 0;
	#10 sys_resetb= 1;
end

always @(*)
begin
	#5 sys_clk<=~sys_clk;
end

wire SDA_bus;
wire SCL_bus;

//assign SCL_bus = SCL & SCL_0 & SCL_1;
//assign SDA_bus = SDA & SDA_0 & SDA_1;

assign SDA_bus = SDA & SDA_0 & SDA_1 & SDA_2 & SDA_3 & SDA_4;// bus
assign SCL_bus = SCL;// & SCL_0 & SCL_1 & SCL_2 & SCL_3 & SCL_4 & SCL_5 & SCL_6 & SCL_7 & SCL_8 & SCL_9;// bus

pullup(SDA_bus);
pullup(SCL_bus);


hlcp_master_tb hlcp_data_top_M(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA),
.SCL(SCL),

.sda_in(SDA_bus),
.scl_in(SCL_bus)
);
/*
PWMC #(.ROW(5'd8),
                    	   .COLUMN(3'd2))
					HLCP_pwmc_8_2(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA_0),
.SCL(SCL_0),

.sda_in(SDA_bus),
.scl_in(SCL_bus),

.pwm_o(),

.LED_short_0_i(6'b111111),
.LED_open_0_i(6'b111111),

.overheat_0_i(1'b0),
.overvoltage_0_i(1'b0),
.undervoltage_0_i(1'b0),

.LED_short_1_i(6'b111111),
.LED_open_1_i(6'b111111),

.overheat_1_i(1'b0),
.overvoltage_1_i(1'b0),
.undervoltage_1_i(1'b0),

.LED_short_2_i(6'b111111),
.LED_open_2_i(6'b111111),

.overheat_2_i(1'b0),
.overvoltage_2_i(1'b0),
.undervoltage_2_i(1'b0),

.LED_short_3_i(6'b111111),
.LED_open_3_i(6'b111111),

.overheat_3_i(1'b0),
.overvoltage_3_i(1'b0),
.undervoltage_3_i(1'b0)
);
////////////////////////////////////////////////
PWMC #(.ROW(5'd16),
                    	   .COLUMN(3'd4))
					HLCP_pwmc_16_4(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA_1),
.SCL(SCL_1),

.sda_in(SDA_bus),
.scl_in(SCL_bus),

.pwm_o(),

.LED_short_0_i(6'b000011),
.LED_open_0_i(6'b100000),

.overheat_0_i(1'b0),
.overvoltage_0_i(1'b0),
.undervoltage_0_i(1'b0),

.LED_short_1_i(6'b111111),
.LED_open_1_i(6'b111111),

.overheat_1_i(1'b0),
.overvoltage_1_i(1'b0),
.undervoltage_1_i(1'b0),

.LED_short_2_i(6'b111111),
.LED_open_2_i(6'b111111),

.overheat_2_i(1'b0),
.overvoltage_2_i(1'b0),
.undervoltage_2_i(1'b0),

.LED_short_3_i(6'b111111),
.LED_open_3_i(6'b111111),

.overheat_3_i(1'b0),
.overvoltage_3_i(1'b0),
.undervoltage_3_i(1'b0)
);
*/


////////////////////////////////////////////////////
PWMC #(.ROW(5'd8),
                    	   .COLUMN(3'd2))
					HLCP_PWMC_8_2(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA_0),
.SCL(SCL_0),

.sda_in(SDA_bus),
.scl_in(SCL_bus),

.short_i_0(6'b101010),
.open_i_0(6'b101010),

.overheat_0(1'b0),
.overvoltage_0(1'b0),
.undervoltage_0(1'b0),

.short_i_1(6'b101010),
.open_i_1(6'b101010),

.overheat_1(1'b0),
.overvoltage_1(1'b0),
.undervoltage_1(1'b0),

.short_i_2(6'b101010),
.open_i_2(6'b101010),

.overheat_2(1'b0),
.overvoltage_2(1'b0),
.undervoltage_2(1'b0),

.short_i_3(6'b101010),
.open_i_3(6'b101010),

.overheat_3(1'b0),
.overvoltage_3(1'b0),
.undervoltage_3(1'b0),

.pwm_o()
);

PWMC #(.ROW(5'd10),
                    	   .COLUMN(3'd2))
					HLCP_PWMC_10_2(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA_1),
.SCL(SCL_1),

.sda_in(SDA_bus),
.scl_in(SCL_bus),

.short_i_0(6'b101010),
.open_i_0(6'b101010),

.overheat_0(1'b0),
.overvoltage_0(1'b0),
.undervoltage_0(1'b0),

.short_i_1(6'b101010),
.open_i_1(6'b101010),

.overheat_1(1'b0),
.overvoltage_1(1'b0),
.undervoltage_1(1'b0),

.short_i_2(6'b101010),
.open_i_2(6'b101010),

.overheat_2(1'b0),
.overvoltage_2(1'b0),
.undervoltage_2(1'b0),

.short_i_3(6'b101010),
.open_i_3(6'b101010),

.overheat_3(1'b0),
.overvoltage_3(1'b0),
.undervoltage_3(1'b0),
.pwm_o()
);

PWMC #(.ROW(5'd15),
                    	   .COLUMN(3'd2))
					HLCP_PWMC_15_2(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA_2),
.SCL(SCL_2),

.sda_in(SDA_bus),
.scl_in(SCL_bus),

.short_i_0(6'b101010),
.open_i_0(6'b101010),

.overheat_0(1'b0),
.overvoltage_0(1'b0),
.undervoltage_0(1'b0),

.short_i_1(6'b101010),
.open_i_1(6'b101010),

.overheat_1(1'b0),
.overvoltage_1(1'b0),
.undervoltage_1(1'b0),

.short_i_2(6'b101010),
.open_i_2(6'b101010),

.overheat_2(1'b0),
.overvoltage_2(1'b0),
.undervoltage_2(1'b0),

.short_i_3(6'b101010),
.open_i_3(6'b101010),

.overheat_3(1'b0),
.overvoltage_3(1'b0),
.undervoltage_3(1'b0),

.pwm_o()
);
//제거
PWMC #(.ROW(5'd15),
                    	   .COLUMN(3'd4))
					HLCP_PWMC_15_4(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA_3),
.SCL(SCL_3),

.sda_in(SDA_bus),
.scl_in(SCL_bus),

.short_i_0(6'b101010),
.open_i_0(6'b101010),

.overheat_0(1'b0),
.overvoltage_0(1'b0),
.undervoltage_0(1'b0),

.short_i_1(6'b101010),
.open_i_1(6'b101010),

.overheat_1(1'b0),
.overvoltage_1(1'b0),
.undervoltage_1(1'b0),

.short_i_2(6'b101010),
.open_i_2(6'b101010),

.overheat_2(1'b0),
.overvoltage_2(1'b0),
.undervoltage_2(1'b0),

.short_i_3(6'b101010),
.open_i_3(6'b101010),

.overheat_3(1'b0),
.overvoltage_3(1'b0),
.undervoltage_3(1'b0),

.pwm_o()
);


PWMC #(.ROW(5'd16),
                    	   .COLUMN(3'd2))
					HLCP_PWMC_16_2(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA_2),
.SCL(SCL_2),

.sda_in(SDA_bus),
.scl_in(SCL_bus),

.short_i_0(6'b101010),
.open_i_0(6'b101010),

.overheat_0(1'b0),
.overvoltage_0(1'b0),
.undervoltage_0(1'b0),

.short_i_1(6'b101010),
.open_i_1(6'b101010),

.overheat_1(1'b0),
.overvoltage_1(1'b0),
.undervoltage_1(1'b0),

.short_i_2(6'b101010),
.open_i_2(6'b101010),

.overheat_2(1'b0),
.overvoltage_2(1'b0),
.undervoltage_2(1'b0),

.short_i_3(6'b101010),
.open_i_3(6'b101010),

.overheat_3(1'b0),
.overvoltage_3(1'b0),
.undervoltage_3(1'b0),

.pwm_o()
);
//제거
PWMC #(.ROW(5'd16),
                    	   .COLUMN(3'd4))
					HLCP_PWMC_16_4(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA_3),
.SCL(SCL_3),

.sda_in(SDA_bus),
.scl_in(SCL_bus),

.short_i_0(6'b101010),
.open_i_0(6'b101010),

.overheat_0(1'b0),
.overvoltage_0(1'b0),
.undervoltage_0(1'b0),

.short_i_1(6'b101010),
.open_i_1(6'b101010),

.overheat_1(1'b0),
.overvoltage_1(1'b0),
.undervoltage_1(1'b0),

.short_i_2(6'b101010),
.open_i_2(6'b101010),

.overheat_2(1'b0),
.overvoltage_2(1'b0),
.undervoltage_2(1'b0),

.short_i_3(6'b101010),
.open_i_3(6'b101010),

.overheat_3(1'b0),
.overvoltage_3(1'b0),
.undervoltage_3(1'b0),

.pwm_o()
);



PWMC #(.ROW(5'd26),
                    	   .COLUMN(3'd4))
					HLCP_PWMC_26_4(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA_4),
.SCL(SCL_4),

.sda_in(SDA_bus),
.scl_in(SCL_bus),

.short_i_0(6'b101010),
.open_i_0(6'b101010),

.overheat_0(1'b0),
.overvoltage_0(1'b0),
.undervoltage_0(1'b0),

.short_i_1(6'b101010),
.open_i_1(6'b101010),

.overheat_1(1'b0),
.overvoltage_1(1'b0),
.undervoltage_1(1'b0),

.short_i_2(6'b101010),
.open_i_2(6'b101010),

.overheat_2(1'b0),
.overvoltage_2(1'b0),
.undervoltage_2(1'b0),

.short_i_3(6'b101010),
.open_i_3(6'b101010),

.overheat_3(1'b0),
.overvoltage_3(1'b0),
.undervoltage_3(1'b0),

.pwm_o()
);

endmodule




/*
Digital_String_Controller #(.ROW(5'd0),
                    	   .COLUMN(3'd3))
					hlcp_DSC_03_(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA),
.SCL(SCL),

.pwm_o()
);

Digital_String_Controller #(.ROW(5'd0),
                    	   .COLUMN(3'd4))
					hlcp_DSC_04_(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA),
.SCL(SCL),

.pwm_o()
);
*/
/*
Analog_String_Controller #(.ROW(5'd0),
                    	   .COLUMN(3'd5))
					hlcp_ASC_05_(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA),
.SCL(SCL),

.pwm_o()
);

Analog_String_Controller #(.ROW(5'd0),
                    	   .COLUMN(3'd6))
					hlcp_ASC_06_(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA),
.SCL(SCL),

.pwm_o()
);

Analog_String_Controller #(.ROW(5'd0),
                    	   .COLUMN(3'd7))
					hlcp_ASC_07_(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA),
.SCL(SCL),

.pwm_o()
);
*/
////////////////////////////////////////////////////



/*
Analog_String_Controller #(.ROW(5'd1),
                    	   .COLUMN(3'd7))
					hlcp_ASC_27_(
.sys_clk(sys_clk),
.sys_resetb(sys_resetb),

.SDA(SDA),
.SCL(SCL),

.pwm_o()
);
*/