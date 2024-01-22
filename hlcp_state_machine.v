`define ADDR_HLCPMTXR   4'h0
`define ADDR_HLCPMRXR   4'h1
`define ADDR_HLCPSTXR   4'h2
`define ADDR_HLCPSRXR   4'h3

`define ADDR_HLCPIER    4'h4
`define ADDR_HLCPISR    4'h5
`define ADDR_HLCPLCMR   4'h6
`define ADDR_HLCPLSR    4'h7
`define ADDR_HLCPCONR   4'h8
`define ADDR_HLCPOPR    4'h9

`define ADDR_HLCPDIV    4'hA
`define ADDR_HLCPSADDL  4'hB
`define ADDR_HLCPSADDH  4'hC


`define idle 			   2'h0
`define APB_APhase 		   2'h1
`define APB_DPhase		   2'h2

`define ADDR_CRCTRANSDCNT  4'hD

module	state_machine(
            sys_clk,
            sys_resetb,

			scl_in,				
			sda_in,				

			LED_Error_Frame_0_i,
			LED_Error_Frame_1_i,

			CMD,				
			Operand_ID,			

			DATA_o,
			loop_count,

			sda_oen,				
			scl_oen,				

			init,					
			CTS,				// Clear To Send
			CTS_error,			// Clear To Send 
			error_flag
);


parameter ROW = 5'b0;				
parameter COLUMN = 3'b0;			
//----------------------------input----------------------------
input sys_clk;
input sys_resetb;

input scl_in;
input sda_in;

input [7:0] LED_Error_Frame_0_i;
input [7:0] LED_Error_Frame_1_i;
//----------------------------output----------------------------
output [3:0]  CMD;
output [7:0]  Operand_ID;

output [47:0] DATA_o;
output [1:0]  loop_count;

output		  sda_oen;
output		  scl_oen;

output		  init;
output		  CTS;
output		  CTS_error;

output 	      error_flag;
//////////////////////APB//////////////////////
reg  PSEL;
reg  PREAD;
reg  PWRITE;
reg  PWRITE_reg;

reg  [5:0] PADDR;
reg  [5:0] PADDR_reg;
reg  [31:0] PWDATA;
reg  [31:0] PWDATA_reg;

reg   [4:0]  cnt;

wire [31:0] PRDATA;
///////////////////////////////////////////////
reg	[1:0] state_APB;
reg [1:0] state_APB_nxt;

reg [7:0]    data_reg[7:0];

reg			 count_flag;
reg 		 flag_enable;

reg [1:0] 	 loop_count;
//----------------------------------------------------------------------------------------------
//-------------------------------------------Error----------------------------------------------
//----------------------------------------------------------------------------------------------
reg 	  CTS_error_occur; //CTS ERROR COUNT

reg 	  CTS_error_flag; 			// CTS Error
reg		  CTS_error_flag_init;		// Flush

reg [7:0] LED_Error_Frame_0_r;		// Frame Zero
reg [7:0] LED_Error_Frame_1_r;		// Frame One

//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------
wire [3:0] CRC;
wire [3:0] CMD_w;
wire [7:0] Operand_ID;
wire [7:0] DATA0;
wire [7:0] DATA1;
wire [7:0] DATA2;
wire [7:0] DATA3;
wire [7:0] DATA4;
wire [7:0] DATA5;
////////////////////////////////////////////////////////////
wire hlcp_int;
wire con_start;
wire con_stop;
wire scl_in_rs, sda_in_rs;
wire match_w;

wire hlcp_int_falling;
wire error_flag;


hlcp_sync    u_hlcp_sync(.sys_clk(sys_clk),
                       .sys_resetb(sys_resetb),
                       .scl_in(scl_in),
                       .sda_in(sda_in),
                       .scl_in_rs(scl_in_rs),
                       .sda_in_rs(sda_in_rs)
                       );

hlcp_top #(.ROW(ROW), .COLUMN(COLUMN)) 
			u_hlcp_brightness( 
                .sys_resetb(sys_resetb),
                .sys_clk(sys_clk),

                .sys_sel(PSEL),
                .sys_rd(PREAD),
                .sys_wr(PWRITE),
                .sys_addr(PADDR),
                .sys_wdata(PWDATA),
                .sys_rdata(PRDATA),

                .scl_in(scl_in_rs),
                .scl_out(scl_out),
                .scl_oen(scl_oen),
                .sda_in(sda_in_rs),
                .sda_out(sda_out),
                .sda_oen(sda_oen),

                .hlcp_int(hlcp_int),

				.CMD(CMD),
				.ID_i(Operand_ID),

				.CTS(CTS),
				.CTS_error(CTS_error),
				.CRC_M(CRC),

				.init(init),
				.con_start(con_start),
				.con_stop(con_stop),

				.match_w(match_w),
				
				.SDA(),
				.SCL(),
				
				.rxd_report()
               );

assign     CMD = CMD_w;			   

reg [4:0]  Data_rx_cnt;

wire       CMD_report;
wire 	   CMD_report_wire;

assign 	   CMD_report = (CMD==4'b1110) ? 1'b1 : 1'b0;
assign     CMD_report_wire = (CMD==4'b1110&&state_APB==`APB_DPhase) ? 1'b1 : 1'b0;
//------------------------------------------------------------
//------------------------------------------------------------
//------------------------------------------------------------

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb)
		count_flag <= 1'b0; //For Report Instruction
	else if(CMD_report&&cnt==6'd22)
		count_flag <= 1'h0;										// reset setting for //count_flag==2'h1//
	else if(CMD_report_wire&&(cnt==6'd9)&&(hlcp_int))
		count_flag <= 1'b1;
	else 
		count_flag <= count_flag;
end

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) begin
		cnt 			 <= 5'd0; //For State Machine
		flag_enable 	 <= 1'b1; //Accept RUN
	end
	else if(CMD_report_wire&&count_flag) begin
		case(cnt)
		5'd9 :  cnt <= 5'd10;
		5'd15 : cnt <= 5'd16;
		5'd19 : begin 
			flag_enable <= 1'b0;
			if(hlcp_int) cnt <= 5'd20;
		end
		5'd22 : cnt <= 5'd0;
		default : cnt <= cnt + 1'b1;
		endcase
	end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	else if(state_APB==`APB_DPhase) begin
		if((cnt==5'd5||cnt==5'd9)&&(hlcp_int)) begin
			cnt <= 5'd6;												// IF cnt==4'd5 -> Interrupt after Setting
			flag_enable <= 1'b1;
		end
		else if(cnt==5'd5||cnt==5'd9) begin								// APB OFF for few time
			flag_enable <= 1'b0;
		end
		else begin
			cnt <= cnt + 1'b1;
			flag_enable <= flag_enable;
		end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end
	else if(hlcp_int) begin						// Reset
			flag_enable <= 1'b1;
	end
	else begin
			cnt 		 <= cnt;
			flag_enable  <= flag_enable;
	end
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------
always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) begin
		PSEL <= 1'b0; PWRITE  <=  1'b0;
		PREAD   <=  1'b0; PADDR   <=  'b0;
		PWDATA <= 'b0;
	end
	else if((flag_enable))begin
		case(state_APB)
		`idle : begin
					PSEL    <=  1'b0;
					PWRITE  <=  1'b0;
					PREAD   <=  1'b0;
			end
		`APB_APhase : begin
					PSEL    <=  1'b1;
					PWRITE  <=  PWRITE_reg;
					PADDR   <=  PADDR_reg;										
					PWDATA  <=  PWDATA_reg;
			end
		`APB_DPhase : begin
					PREAD   <=  1'b1;
			end
		default : begin
					PSEL    <=  1'b0;
					PWRITE  <=  1'b0;
					PREAD   <=  1'b0;
			end
		endcase
	end
	else begin
		PSEL <= PSEL; PWRITE  <=  PWRITE;
		PREAD   <=  PREAD; PADDR   <=  PADDR;
		PWDATA <= PWDATA;
	end
end
//------------------------------------------------------------------
//------------------------------------------------------------------

always @(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) begin
		state_APB <= `idle;
	end
	else if((flag_enable)) begin
		case(state_APB)
			`idle : state_APB   <= `APB_APhase;
			`APB_APhase : state_APB   <= `APB_DPhase;
			`APB_DPhase : state_APB <= `idle;
			default : state_APB <= `idle;
		endcase
	end
	else begin
		state_APB 	<= `idle;
	end
end
//--------------------------------------------------------------------
//--------------------------------------------------------------------
always @(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb) begin
	state_APB_nxt<=`idle;
	PWRITE_reg <='b0;
	PADDR_reg  <='b0;
	PWDATA_reg <='b0;
end
else begin	
	state_APB_nxt <= `idle;
	PWRITE_reg<=PWRITE_reg;
	PADDR_reg<=PADDR_reg;
	PWDATA_reg <= PWDATA_reg;
	case(cnt)
		5'd0 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPCONR;
			PWDATA_reg<='b0000_0001;
		end	
		5'd1 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPISR;
			PWDATA_reg<='b0;			
		end
		5'd2 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPIER;
			PWDATA_reg<='hFF;
		end
		5'd3 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPLCMR;
			PWDATA_reg<='b001;
		end
		5'd4 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPOPR;
			PWDATA_reg<='b1;
		end
//---------------------Repeat with Reading HLCP data-----------------------------		
		5'd6 : begin
			PWRITE_reg<='b0;
			PADDR_reg<=`ADDR_HLCPSRXR;
			PWDATA_reg<='b0;
		end
		5'd7 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPISR;
			PWDATA_reg<='b0;
		end
		5'd8 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPLCMR;
			PWDATA_reg<='h4;
		end
//////////////////////////////////////////////////
		5'd10 : begin
			PWRITE_reg<='b1;
			PADDR_reg  <=`ADDR_HLCPSADDH;
			PWDATA_reg <='b0;
		end					
		5'd11 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPCONR;
			PWDATA_reg<='b0000_0011;
		end
		5'd12 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPISR;
			PWDATA_reg<='b0;
		end
		5'd13 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPIER;
			PWDATA_reg<='hFF;
		end
		5'd14 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPLCMR;
			PWDATA_reg<='b0001;
		end		
		
///////////////////////////////////////////////////
		5'd16 : begin
			PWRITE_reg <= 'b1;
			PADDR_reg  <= `ADDR_HLCPSTXR;
			PWDATA_reg <= LED_Error_Frame_0_r;
		end
		5'd17 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPISR;
			PWDATA_reg<='b0000;
		end	
		5'd18 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPLCMR;
			PWDATA_reg<='b0100;
		end	
/////////////////////////////////////////////////////	
		5'd20 : begin
			PWRITE_reg <= 'b1;
			PADDR_reg  <= `ADDR_HLCPSTXR;
			PWDATA_reg <= LED_Error_Frame_1_r;
		end
		5'd21 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPISR;
			PWDATA_reg<='b0000;
		end	
		5'd22 : begin
			PWRITE_reg<='b1;
			PADDR_reg<=`ADDR_HLCPLCMR;
			PWDATA_reg<='b0110;
		end
/////////////////////////////////////////////////////
	endcase
	end
end
//--------------------------------------------------------------------
//--------------------------------------------------------------------
//--------------------------------------------------------------------
//--------------------------------------------------------------------
//--------------------------------------------------------------------
//--------------------------------------------------------------------
always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb)
		CTS_error_flag_init <= 1'b0;
	else if(con_stop&&(match_w)) // FLUSH
		CTS_error_flag_init <= ~CTS_error_flag_init; 	
	else
		CTS_error_flag_init <= CTS_error_flag_init; 	
end

reg hlcp_int_r0;
always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb)
		hlcp_int_r0 <= 1'b0;
	else
		hlcp_int_r0 <= hlcp_int;
end

assign hlcp_int_falling = (hlcp_int_r0&~hlcp_int);

always@(posedge sys_clk) begin
	if(!sys_resetb) begin
		data_reg[0] <= 8'b0; data_reg[1] <= 8'b0;
		data_reg[2] <= 8'b0; data_reg[3] <= 8'b0;
		data_reg[4] <= 8'b0; data_reg[5] <= 8'b0;
		data_reg[6] <= 8'b0; data_reg[7] <= 8'b0;		
	end	
	else if(state_APB==2'h0&&cnt==6'h7) begin		//Read DATA
		data_reg[Data_rx_cnt] <= PRDATA[7:0];
	end
	else begin
		data_reg[0] <= data_reg[0]; data_reg[1] <= data_reg[1];
		data_reg[2] <= data_reg[2]; data_reg[3] <= data_reg[3];
		data_reg[4] <= data_reg[4]; data_reg[5] <= data_reg[5];
		data_reg[6] <= data_reg[6]; data_reg[7] <= data_reg[7];		
	end
end

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) 
		Data_rx_cnt <= 5'b0; 
	else if(init)									// delay for refresh
		Data_rx_cnt <= 5'd0;
	else if(hlcp_int_falling)							    // Increase Data_rx_cnt
		Data_rx_cnt <= Data_rx_cnt + 1'b1;
	else if(con_start)										// FOR CMD REPORT
		Data_rx_cnt <= 5'b0;
	else if(Data_rx_cnt==5'd8) 								// loop for 0~47 48~95 96~143 144~191
		Data_rx_cnt <= 5'd2;
	else 
		Data_rx_cnt <= Data_rx_cnt;		
end

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb)
		loop_count <= 2'b0;
	else if(init)											// delay for refresh
		loop_count  <= 2'b0;
	else if(Data_rx_cnt==5'd8)								// loop for 0~47 48~95 96~143 144~191
		loop_count  <= loop_count + 1'b1;
	else
		loop_count <= loop_count;		
end

assign CRC = data_reg[0][7:4];
assign CMD_w = data_reg[0][3:0];

assign Operand_ID = data_reg[1];

assign DATA0 = data_reg[2];
assign DATA1 = data_reg[3];
assign DATA2 = data_reg[4];
assign DATA3 = data_reg[5];
assign DATA4 = data_reg[6];
assign DATA5 = data_reg[7];

assign DATA_o = {DATA5,DATA4,DATA3,DATA2,DATA1,DATA0};
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
reg error_flag_r2;
wire error_flag_w;

reg [4:0] Data_rx_cnt_d;
wire Data_rx_cnt_edge;
reg  Data_rx_cnt_edge_d;

always@(posedge sys_clk or negedge sys_resetb)
	if(!sys_resetb) begin
		Data_rx_cnt_d <= 5'b0;
	end
	else begin
		Data_rx_cnt_d <= Data_rx_cnt;
	end

always@(posedge sys_clk or negedge sys_resetb)
	if(!sys_resetb) begin
		Data_rx_cnt_edge_d <= 1'b0;
	end
	else begin
		Data_rx_cnt_edge_d <= Data_rx_cnt_edge;
	end

assign Data_rx_cnt_edge = (~Data_rx_cnt_d&Data_rx_cnt)? 1'b1 : 1'b0;

reg delay;
always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb)
		delay <= 1'b0;
	else
		delay <= error_flag_w;
end

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb)
		error_flag_r2 <= 1'b0;
	else if((Data_rx_cnt==5'b1)&&Data_rx_cnt_edge)
		error_flag_r2 <= 1'b0;
	else if((delay)&&Data_rx_cnt_edge)
		error_flag_r2 <= 1'b1;
	else
		error_flag_r2 <= error_flag_r2;	
end

// For DATAFORMAT
// IF TIMER occupies delayed packet -> don't change brightness
command_processor DATA_FORMAT_maintain(
	.sys_clk(sys_clk),
	.sys_resetb(sys_resetb),
	.start_count(hlcp_int_falling),
	.error_flag(error_flag_w)
);
assign error_flag = error_flag_r2;
//----------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------Report------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------
	always@(posedge sys_clk or negedge sys_resetb) begin
		if(!sys_resetb)
			CTS_error_occur <= 1'b0;
		else if(CTS_error_flag_init)
			CTS_error_occur <= 1'b0;					// Flush
		else if(CTS_error)
			CTS_error_occur <= 1'b1;  //CTS Error count
		else 
			CTS_error_occur <= CTS_error_occur;
	end

	always@(posedge sys_clk or negedge sys_resetb) begin
		if(~sys_resetb) begin
			LED_Error_Frame_0_r <= 8'hff;
		end
		else if(CTS_error_flag_init)begin
			LED_Error_Frame_0_r <=	8'b0000_0000;															// Flush
		end
		else if(!CTS_error_flag_init && init)begin
			LED_Error_Frame_0_r <= LED_Error_Frame_0_i;														// Report instruction One LED Frame
		end
		else begin
			LED_Error_Frame_0_r <= LED_Error_Frame_0_r;
		end
	end

	always@(posedge sys_clk or negedge sys_resetb) begin
		if(~sys_resetb) begin
			LED_Error_Frame_1_r <= 8'hff;
		end
		else if(CTS_error_flag_init)begin
			LED_Error_Frame_1_r <=	8'b0000_0000;															// Flush
		end
		else if(!CTS_error_flag_init && init)begin
			LED_Error_Frame_1_r <= {LED_Error_Frame_1_i[7:4],CTS_error_occur,LED_Error_Frame_1_i[2:0]};		// Report instruction One LED Frame
		end
		else begin
			LED_Error_Frame_1_r <= LED_Error_Frame_1_r;
		end
		end





endmodule