`timescale 1ns/1ps

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

`define ADDR_CRCTRANSDCNT  4'hD

module hlcp_master_tb(
			input sys_clk,
			input sys_resetb,
			
			inout SCL,
			inout SDA,

			input sda_in,
			input scl_in
);


reg                       sys_sel;           // APB slave select
reg                       sys_rd;            // APB penable
reg                       sys_wr;            // APB write enable
reg [3:0]                 sys_addr;          // APB reg address
reg [31:0]                sys_wdata;         // APB write in data
wire unsigned [31:0]      sys_rdata;         // APB read out data

wire                      scl_out;           // HLCP scl wire
wire                      scl_oen;           // HLCP scl wire enable
wire                      sda_oen;           // HLCP sda wire enable
wire                      hlcp_int;           // HLCP interrupt

wire [5:0]					pwm_o;
///////////0622///////////
reg	[3:0]				  cmd;
reg [2:0]				  column;
reg [4:0]				  row;
reg 					  ack;
//wire					  al;


// reg al_r;
// wire al;
// always@(posedge sys_clk or negedge sys_resetb) begin
// if(!sys_resetb)
//         al_r <= 1'b0;
// else
//         al_r <= al_r|al;
// end


// assign SDA = ((sda_oen==1'b0)&&(busy==1'b0)) ?  1'b0 : 
// ((sda_oen==1'b1)&&(busy==1'b0)) ?  1'b1 : 
// (busy==1'b1) ? 1'bz : 1'bz;

// assign SCL = ((scl_oen==1'b0)&&(busy==1'b0)) ?  1'b0 : 
// ((scl_oen==1'b0)&&(busy==1'b0)) ? 1'b1 : 
// ((busy==1'b1)) ? 1'bz : 1'bz;


assign SCL = (~scl_oen) ?  1'b0 : 1'b1;
assign SDA = (~sda_oen) ?  1'b0 : 1'b1;

// assign scl_in = SCL;
// assign sda_in = SDA;

task APB_master_data_write;
	input	[3:0]	addr;
	input	[31:0]	data;
	begin
		@(posedge sys_clk)
			sys_sel	  <=	#1 1'b1;
			sys_wr	  <=	#1 1'b1;
			sys_addr  <=	#1 addr;
			sys_wdata <=	#1 data;
		@(posedge sys_clk)
			sys_rd 	  <=	#1 1'b1;
		@(posedge sys_clk)
			sys_sel	  <=	#1 1'b0;
			sys_wr	  <= 	#1 1'b0;
			sys_rd    <=	#1 1'b0;
		$display(" ---> MASTER ::: APB write register \(%h\) : wr_data %h",addr,data);
	end
endtask
	
task APB_master_data_read;        
	input [3:0] addr;
	begin
		@(posedge sys_clk)
			sys_sel  <= #1 1'b1;
			sys_wr   <= #1 1'b0;
			sys_addr <= #1 addr; 
		@(posedge sys_clk)
			sys_rd   <= #1 1'b1;
		@(posedge sys_clk)
			sys_sel  <= #1 1'b0;
			sys_rd   <= #1 1'b0;
		$display(" ---> MASTER ::: APB read register \(%h\) : rd_data %h",addr,sys_rdata);
	end
endtask
//u_hlcp_brightness.u_hlcp_master.ack_out

hlcp_top u_hlcp_brightness(
					.sys_resetb(sys_resetb),
					.sys_clk(sys_clk),

					.sys_sel(sys_sel),
					.sys_rd(sys_rd),
					.sys_wr(sys_wr),
					.sys_addr(sys_addr),
					.sys_wdata(sys_wdata),
					.sys_rdata(sys_rdata),

					.scl_in(scl_in),
					.scl_out(scl_out),
					.scl_oen(scl_oen),
					.sda_in(sda_in),
					.sda_out(sda_out),
					.sda_oen(sda_oen),

					.SCL(),
					.SDA(),

					.hlcp_int(hlcp_int)
					//.al(al)
					//.pwm_o(pwm_o)
					);
					
					
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
//11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
// 1. master tx

initial begin
		#0
		 	sys_sel <= 1'b0;
			sys_wr  <= 1'b0;
			sys_rd  <= 1'b0;
			sys_addr <= 4'd0;
			sys_wdata <= 32'd0;

			cmd    <= 1'b0;
			column <= 1'b0;
			row	   <= 1'b0;

			ack    <= 1'b0;
		#10000
		#2000 APB_master_data_write(`ADDR_HLCPCONR, {32'b0000_0000_0000_0000_0000_0000_0000_1100});//M/S 모드설정, R/W 모드설정, nack/ack 모드설정
		#2000 APB_master_data_write(`ADDR_HLCPISR,{32'h00});//인터럽트 초기화
		#2000 APB_master_data_write(`ADDR_HLCPIER,{32'hFF});//인터럽트 마스크 초기화
		#2000 APB_master_data_write(`ADDR_HLCPDIV,{32'b0000_0000_0000_0000_0000_0000_0000_0011});//clock div 알맞게 설정.
		#2000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_0001_1000});//[3:0] cmd -> ppt 확인
		#2000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0001});//[3]:resume,[2]:stop,[1]:start
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_00000_000});//[7:0] address1
	
		#2000 APB_master_data_write(`ADDR_HLCPOPR,{32'b0000_0000_0000_0000_0000_0000_0000_0001});//[2]:확장된  ADDR mode, [1]:reset_sm, [0]:core_en 설정.
		
		#2000 APB_master_data_read(`ADDR_HLCPMTXR);

		cmd = sys_rdata[3:0];
		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#20000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hF0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hF0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hF0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address

			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hF0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h33});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address
	
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_01_011011});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h40});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_101_00_000});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end
		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
	

		end		
		

		
							
	endcase

	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
//222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
//222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
//222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
//////////////////////////
		//제거
		#50000
		//CMD 1000

		wait(hlcp_int)
		#1000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_1111_1000});//[3:0] cmd -> ppt 확인
		#1000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_11111_111});//[7:0] address1
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[2]:resume,[1]:stop,[0]:start
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		cmd = sys_rdata[3:0];
		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address
			
			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h66});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h80});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_11_000001});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h80});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_000_00_000});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end		
							
	endcase

	//APB_master_data_write (`ADDR_HLCPLCMR, {32'h02});
//제거	

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
//3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
//3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
//3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
//3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
//3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
//3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
//3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333

		#25000
		wait(hlcp_int)
		#1000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_0010_1010});//[3:0] cmd -> ppt 확인
		#1000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_01111_000});//[7:0] address1
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[2]:resume,[1]:stop,[0]:start
		
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		cmd = sys_rdata[3:0];
		

		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address

			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hF0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h66});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h55});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0010_11_001001});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_000_00_000});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h80});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end

	endcase
//제거

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
//44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
//44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
//44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
//44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
//44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
//44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
//44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
//44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
//44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444

		#1000
		
		//CMD 1010
		wait(hlcp_int)
		#1000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_1110_1010});//[3:0] cmd -> ppt 확인
		#1000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_10000_000});//[7:0] address1
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[2]:resume,[1]:stop,[0]:start
		
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		cmd = sys_rdata[3:0];
		

		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address
			
			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((column<10'd31)&&(row<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_01_011011});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_101_00_110});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end

	endcase
	/////////////////////////////////////////////////////0813
	
	//APB_master_data_write (`ADDR_HLCPLCMR, {32'h02});

	//wait(hlcp_int);
	
	
	//제거
 	//////////////////////////////////////////////////////
	//555555555555555555555555555555555555555555555555555555555555555555555
	//555555555555555555555555555555555555555555555555555555555555555555555
	//555555555555555555555555555555555555555555555555555555555555555555555
	//555555555555555555555555555555555555555555555555555555555555555555555
	//555555555555555555555555555555555555555555555555555555555555555555555
	//555555555555555555555555555555555555555555555555555555555555555555555
		#1000
		
		//CMD 1011
		wait(hlcp_int)
		#1000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_1110_1011});//[3:0] cmd -> ppt 확인
		#1000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_00000_000});//[7:0] address1
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[2]:resume,[1]:stop,[0]:start
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		cmd = sys_rdata[3:0];
		

		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address
			
			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_01_011011});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_101_00_011});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end

	endcase
	/////////////////////////////////////////////////////0813
	
	//APB_master_data_write (`ADDR_HLCPLCMR, {32'h02});

	//wait(hlcp_int);
	
	
	//제거



	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////
	//beginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbegin
	//beginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbegin
	//beginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbegin
	//beginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbegin
	//beginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbegin
	//beginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbeginbegin

 	//////////////////////////////////////////////////////
	//666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
	//666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
	//666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
	//666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
	//666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
	//666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
	//666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
	//666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
		#1000
		
		//CMD 1011S
		wait(hlcp_int)
		#1000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_0010_1011});//[3:0] cmd -> ppt 확인
		#1000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_00001_000});//[7:0] address1
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[2]:resume,[1]:stop,[0]:start
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		cmd = sys_rdata[3:0];
		

		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address
			
			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_01_011011});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_000_00_100});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end

	endcase
	/////////////////////////////////////////////////////0813
	
	//APB_master_data_write (`ADDR_HLCPLCMR, {32'h02});

	//wait(hlcp_int);
 	//////////////////////////////////////////////////////
	//7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
	//7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
	//7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
	//7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
	//7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
	//7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
	//7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
	//7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
	//7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
		 //제거
		//#30000 APB_master_data_write(`ADDR_HLCPISR,{32'h00});//인터럽트 초기화
		//#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[3]:resume,[2]:stop,[1]:start


		
	 	//////////////////////////////////////////////////////
		#10000
		//#30000 APB_master_data_write(`ADDR_HLCPISR,{32'h00});//인터럽트 초기화
		wait(hlcp_int)
		#3000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_0100_1001});//[3:0] cmd -> ppt 확인
		#3000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_00000_000});//[7:0] address1
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#3000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0100});//[3]:resume,[2]:stop,[1]:start
		
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		cmd = sys_rdata[3:0];
		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'h50});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address
			
			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address

		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address


		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_00_100000});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_101_00_000});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end

	endcase
	/////////////////////////////////////////////////////0813
	

	//wait(hlcp_int);
	
	
	//제거

	 	//////////////////////////////////////////////////////
	//8888888888888888888888888888888888888888888888888888888888888888888888
	//8888888888888888888888888888888888888888888888888888888888888888888888
	//8888888888888888888888888888888888888888888888888888888888888888888888
	//8888888888888888888888888888888888888888888888888888888888888888888888
	//8888888888888888888888888888888888888888888888888888888888888888888888
		 //제거
		//APB_master_data_write (`ADDR_HLCPLCMR, {32'h02});
		#10000
		// wait(hlcp_int);
		// #2000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_0000_0101});//[3:0] cmd -> ppt 확인
		// #2000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[2]:resume,[1]:stop,[0]:start
		wait(hlcp_int)
		#1000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_0111_1100});//[3:0] cmd -> ppt 확인
		#1000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_00000_111});//[7:0] address1
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[2]:resume,[1]:stop,[0]:start
		
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		cmd = sys_rdata[3:0];
		

		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address
			
			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address

		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address


		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_01_011011});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_101_00_000});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end

	endcase
	/////////////////////////////////////////////////////0813
	//99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	//99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	//99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	//99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	//99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	//99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	//APB_master_data_write (`ADDR_HLCPLCMR, {32'h02});
	//제거

		#10000
		wait(hlcp_int)
		#1000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_1100_0101});//[3:0] cmd -> ppt 확인
		#1000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_01000_010});//[7:0] address1
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[2]:resume,[1]:stop,[0]:start
		
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);


/*
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#3000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0100});//[3]:resume,[2]:stop,[1]:start

		#2000 APB_master_data_write(`ADDR_HLCPCONR, {32'b0000_0000_0000_0000_0000_0000_0000_1100});//M/S 모드설정, R/W 모드설정, nack/ack 모드설정
		
		#3000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_1001_1001});//[3:0] cmd -> ppt 확인
		#3000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_00000_000});//[7:0] address1
		
		
		#3000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0001});//[3]:resume,[2]:stop,[1]:start
		*/
		
		
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);





	/*
		#3000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_1101_1110});//[3:0] cmd -> ppt 확인
		#3000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_00001_001});//[7:0] address1
		#2000 APB_master_data_write(`ADDR_HLCPCONR, {32'b0000_0000_0000_0000_0000_0000_0000_1100});//M/S 모드설정, R/W 모드설정, nack/ack 모드설정


		#3000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0101});//[3]:resume,[2]:stop,[1]:start

		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		*/

		cmd = sys_rdata[3:0];
		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address

			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address
	
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address

		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_01_110000});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_101_00_000});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end

	endcase
	/////////////////////////////////////////////////////0813
	
	//APB_master_data_write (`ADDR_HLCPLCMR, {32'h02});

	//wait(hlcp_int);
	///////////////////////////////////////////////////////////////////////////////////////////
		//#1000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0010});//[3]:resume,[2]:stop,[1]:start	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////READREAD//////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	 	//////////////////////////////////////////////////////
	//10101010101010101010101010101010101010101010101010101010101010101010101010
	//10101010101010101010101010101010101010101010101010101010101010101010101010
	//10101010101010101010101010101010101010101010101010101010101010101010101010
	//10101010101010101010101010101010101010101010101010101010101010101010101010
	//10101010101010101010101010101010101010101010101010101010101010101010101010
	//10101010101010101010101010101010101010101010101010101010101010101010101010
		 //제거
		//APB_master_data_write (`ADDR_HLCPLCMR, {32'h02});
		#10000
		//#30000 APB_master_data_write(`ADDR_HLCPISR,{32'h00});//인터럽트 초기화
		wait(hlcp_int)
		#3000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_1100_0101});//[3:0] cmd -> ppt 확인
		#3000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_01010_010});//[7:0] address1
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#3000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0100});//[3]:resume,[2]:stop,[1]:start
		
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		cmd = sys_rdata[3:0];
		

		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address
			
			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address

		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address


		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_01_011011});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_101_00_000});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end

	endcase
	/////////////////////////////////////////////////////0813
	
	//APB_master_data_write (`ADDR_HLCPLCMR, {32'h02});

	//wait(hlcp_int);
	
	
	//제거

	 	//////////////////////////////////////////////////////
	//1111111111111111111111111111111111111111111111111111111111111111111
	//1111111111111111111111111111111111111111111111111111111111111111111
	//1111111111111111111111111111111111111111111111111111111111111111111
	//1111111111111111111111111111111111111111111111111111111111111111111
	//1111111111111111111111111111111111111111111111111111111111111111111
	//1111111111111111111111111111111111111111111111111111111111111111111
		 //제거
		//APB_master_data_write (`ADDR_HLCPLCMR, {32'h02});
		#10000
		// wait(hlcp_int);
		// #2000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_0000_0101});//[3:0] cmd -> ppt 확인
		// #2000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[2]:resume,[1]:stop,[0]:start
		
		wait(hlcp_int);
		#1000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_0100_1101});//[3:0] cmd -> ppt 확인
		#1000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_00000_111});//[7:0] address1
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[2]:resume,[1]:stop,[0]:start
		
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		cmd = sys_rdata[3:0];
		

		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address
			
			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address

		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address


		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_01_011011});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_101_00_000});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end

	endcase
	
/////////////12121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212
/////////////12121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212
/////////////12121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212
/////////////12121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212
/////////////12121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212
/////////////12121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212
/////////////12121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212


		wait(hlcp_int);
		#1000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_0101_1110});//[3:0] cmd -> ppt 확인
		#1000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_11010_100});//[7:0] address1
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[2]:resume,[1]:stop,[0]:start
		
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		cmd = sys_rdata[3:0];
		

		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h00});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address
			
			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address

		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address


		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_01_011011});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_101_00_000});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end

	endcase
////READREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREAD
////READREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREAD
////READREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREAD
////READREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREAD
////READREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREAD
////READREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREADREAD
wait(hlcp_int);
		#1000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0101});//[3]:resume,[2]:stop,[1]:start	

		#4000 APB_master_data_write(`ADDR_HLCPCONR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//M/S 모드설정, R/W 모드설정, nack/ack 모드설정
		
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#2000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[3]:resume,[2]:stop,[1]:start
		
		wait(hlcp_int);
		#1000 APB_master_data_read (`ADDR_HLCPMRXR);//1017
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[3]:resume,[2]:stop,[1]:start	

		wait(hlcp_int);
		#1000 APB_master_data_read (`ADDR_HLCPMRXR);//1017		
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0110});//[3]:resume,[2]:stop,[1]:start
/////////////13131313131313131313131313131313133333131313131131313131313131333331313131311313131313131313131313
/////////////13131313131313131313131313131313133333131313131131313131313131333331313131311313131313131313131313
/////////////13131313131313131313131313131313133333131313131131313131313131333331313131311313131313131313131313
/////////////13131313131313131313131313131313133333131313131131313131313131333331313131311313131313131313131313
/////////////13131313131313131313131313131313133333131313131131313131313131333331313131311313131313131313131313
/////////////13131313131313131313131313131313133333131313131131313131313131333331313131311313131313131313131313
/////////////13131313131313131313131313131313133333131313131131313131313131333331313131311313131313131313131313

	
		//#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		//#3000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0100});//[3]:resume,[2]:stop,[1]:start

		#2000 APB_master_data_write(`ADDR_HLCPCONR, {32'b0000_0000_0000_0000_0000_0000_0000_1100});//M/S 모드설정, R/W 모드설정, nack/ack 모드설정
		
		#3000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_0101_0101});//[3:0] cmd -> ppt 확인
		#3000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_01000_010});//[7:0] address1
		
		
		#3000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0001});//[3]:resume,[2]:stop,[1]:start
		
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		cmd = sys_rdata[3:0];
		

		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address
			
			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address

		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address


		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_01_011011});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_101_00_000});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end

	endcase
////////////1414141414141414141441414141414141414141414141414141414141414141414
////////////1414141414141414141441414141414141414141414141414141414141414141414
////////////1414141414141414141441414141414141414141414141414141414141414141414
////////////1414141414141414141441414141414141414141414141414141414141414141414
////////////1414141414141414141441414141414141414141414141414141414141414141414
////////////1414141414141414141441414141414141414141414141414141414141414141414

		wait(hlcp_int);
		#1000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_1100_0101});//[3:0] cmd -> ppt 확인
		#1000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_01010_010});//[7:0] address1
		#1000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#1000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[2]:resume,[1]:stop,[0]:start
		
		
		#1000 APB_master_data_read(`ADDR_HLCPMTXR);
		cmd = sys_rdata[3:0];
		

		
		case(cmd)
		///////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0001 : begin
			////////////////xxxxxxx/////////////////
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////6x1 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0100 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#30000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);
			APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});


				
		end
	

		///////////////////////////////////////////////////////////////
		////////////////////////////6x2 LED////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b0101 : begin
		
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];


		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		//wait(hlcp_int);
		if(row<10'd31) begin
		#10000 APB_master_data_write(`ADDR_HLCPSADDH,{(row+1'b1),column});//[7:0] address
			
			#30000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 2/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 3/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'h10});//DATA 5/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
			#10000
			wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
				APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
				APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
				APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
	
		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x1 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0110: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<10'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address

		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	

		end
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////12x2 LED///////////////////////////
		///////////////////////////////////////////////////////////////		
		4'b0111: begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		
		
		if(column<5'd7) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row,column+1'b1});//[7:0] address


		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if(row<10'd31) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column});//[7:0] address
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end

		if((row<10'd31)&&(column<10'd7)) begin
		#2000 APB_master_data_write(`ADDR_HLCPSADDH,{row+1'b1,column+1'b1});//[7:0] address

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h20});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hFF});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});							
		end
		end


		///////////////////////////////////////////////////////////////
		/////////////////////////////fill//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1000 : begin
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});// VALUE(8)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		end
		///////////////////////////////////////////////////////////////
		////////////////////////////linear/////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1001 : begin
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_01_011011});// coeff, offset
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////row//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1010 : begin

		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#30000			
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// row(5)(xxx)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});//DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end
		///////////////////////////////////////////////////////////////
		//////////////////////////////col//////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1011 : begin

		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_101_00_000});// pos(3xx)col(3)
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
 
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'hA0});	 //DATA 
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});				
		end			

		///////////////////////////////////////////////////////////////
		////////////////////////////save////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1100 : begin
			////////////////xxxxxxx/////////////////

		end
		///////////////////////////////////////////////////////////////
		////////////////////////////restore////////////////////////////
		///////////////////////////////////////////////////////////////
		4'b1101 : begin
			////////////////xxxxxxx/////////////////
		end		

		4'b1110 : begin
		#2000 APB_master_data_read(`ADDR_HLCPSADDH);
		column = sys_rdata[2:0];
		row	   = sys_rdata[7:3];

		#10000
		wait(hlcp_int);
		    APB_master_data_write (`ADDR_HLCPMTXR, {row,column});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});			
		end

	endcase		
	
	/////////////////////////////////////////////////////0813
	
	//APB_master_data_write (`ADDR_HLCPLCMR, {32'h02});

	//wait(hlcp_int);
	
	
	//제거
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*wait(hlcp_int);
		#1000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0101});//[3]:resume,[2]:stop,[1]:start	


		//#2000 APB_master_data_write(`ADDR_HLCPOPR,{32'b0000_0000_0000_0000_0000_0000_0000_0000});//[2]:확장된 ADDR mode, [1]:reset_sm, [0]:core_en 설정.	
		//#2000 APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

	
		
		// #2000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0100});//[3]:resume,[2]:stop,[1]:start
		
		
		
		#4000 APB_master_data_write(`ADDR_HLCPCONR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//M/S 모드설정, R/W 모드설정, nack/ack 모드설정
		#2000 APB_master_data_write(`ADDR_HLCPISR,{32'h00});//인터럽트 초기화
		#2000 APB_master_data_write(`ADDR_HLCPIER,{32'hFF});//인터럽트 마스크 초기화
		#2000 APB_master_data_write(`ADDR_HLCPDIV,{32'b0000_0000_0000_0000_0000_0000_0000_0011});//clock div 알맞게 설정.
		
		
		//#2000 APB_master_data_write(`ADDR_HLCPMTXR, {32'b0000_0000_0000_0000_0000_0000_0000_0001});//[3:0] cmd -> ppt 확인		
		
		
		
		//wait(hlcp_int);
		#2000 APB_master_data_write(`ADDR_HLCPLCMR,{32'b0000_0000_0000_0000_0000_0000_0000_0101});//[3]:resume,[2]:stop,[1]:start
		//#2000 APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_00000_000});//[7:0] address1
		//#2000 APB_master_data_read(`ADDR_HLCPMRXR);
		
		#8000 APB_master_data_write(`ADDR_HLCPOPR,{32'b0000_0000_0000_0000_0000_0000_0000_0001});//[2]:확장된 ADDR mode, [1]:reset_sm, [0]:core_en 설정.	
		
		//#2000 APB_master_data_write(`ADDR_HLCPCONR, {32'b0000_0000_0000_0000_0000_0000_1100_0100});
		wait(hlcp_int);
		#10000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#10000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[3]:resume,[2]:stop,[1]:start	
		
		wait(hlcp_int);
		#10000 APB_master_data_write(`ADDR_HLCPISR,  {32'h00});//인터럽트 초기화
		#10000 APB_master_data_write(`ADDR_HLCPLCMR, {32'b0000_0000_0000_0000_0000_0000_0000_0100});//[3]:resume,[2]:stop,[1]:start	*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////



	

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////READ/////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


end



















endmodule
/*
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h0A});// ADDRESS by HLCP
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});		
		
		#30000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h05});//DATA 1/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h05});//DATA 2/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 3/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h80});//DATA 4/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 5/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 6/6개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});	
			*/											
/*
///////////////////////////////////////////////////ADD for 24byte write///////////////////////////////////////////////////
		#2000 
			APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_0101_0101});//[7:0] address
		
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 7/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 8/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 9/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 10/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 11/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 12/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});

		#2000 
			APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_0010_0101});//[7:0] address

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 13/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 14/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 15/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 16/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 17/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 18/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		
		#2000 
			APB_master_data_write(`ADDR_HLCPSADDH,{32'b0000_0000_0000_0000_0000_0000_1001_0101});//[7:0] address

		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 19/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 20/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 21/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 22/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 23/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});
		#10000
		wait(hlcp_int);	//hlcp_top_master.u_hlcp_master.ack_out
		    APB_master_data_write (`ADDR_HLCPMTXR, {32'h70});//DATA 24/24개
			APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
			APB_master_data_write (`ADDR_HLCPLCMR, {32'h04});						
		
		#10000
		APB_master_data_write (`ADDR_HLCPISR,  {32'h00});
		APB_master_data_write (`ADDR_HLCPLCMR, {32'h02});
*/