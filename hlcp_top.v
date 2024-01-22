//*******************************************************************--
// Copyright (c) 2006-2013  Naoplus Co., Ltd.                        //
//*******************************************************************//
//*******************************************************************//
// Please review the terms of the license agreement before using     //
// this file. If you are not an authorized user, please destroy this //
// source code file and notify Naoplus Co., Ltd. immediately         //
// that you inadvertently received an unauthorized copy.             //
//*******************************************************************//
//-------------------------------------------------------------------//
// Project name         : MiCSoC                                     //
// Project description  :                                            //
//                                                                   //
// File name            : hlcp_top.v                                  //
// Purpose              : HLCP Controller top module                  //
//                                                                   //
//-------------------------------------------------------------------//
//*******************************************************************//
module hlcp_top( 
                sys_resetb,
                sys_clk,

                sys_sel,
                sys_rd,
                sys_wr,
                sys_addr,
                sys_wdata,
                sys_rdata,

                scl_in,
                scl_out,
                scl_oen,
                sda_in,
                sda_out,
                sda_oen,

                SDA,
                SCL,

                hlcp_int,
                
                CMD,
                ID_i,

                CTS,
                CTS_error,
                CRC_M,

                init,
                con_start,
                con_stop,
                match_w,

                rxd_report
               );

//parameter ROW = 5'd0;
//parameter COLUMN = 3'd0;

//APB interface signals
input                       sys_resetb;        // system reset
input                       sys_clk;           // system clock

input                       sys_sel;           // APB slave select
input                       sys_rd;            // APB penable
input                       sys_wr;            // APB write enable
input [3:0]                 sys_addr;          // APB input address
input [31:0]                 sys_wdata;         // APB write in data
output[31:0]                 sys_rdata;         // APB read out data

input                       scl_in;            // HLCP scl input
output                      scl_out;           // HLCP scl output
output                      scl_oen;           // HLCP scl output enable
input                       sda_in;            // HLCP sda input
output                      sda_out;           // HLCP sda output
output                      sda_oen;           // HLCP sda output enable

inout   wire                SCL;
inout   wire                SDA;

output                      hlcp_int;           // HLCP interrupt

/////////////0802/////////////
output wire                 CTS;
output wire                 CTS_error;

input     [3:0]             CMD;
input     [7:0]             ID_i;


output                      init;
output                      con_start;
output                      con_stop;
output    [15:0]            rxd_report;

wire                        scl_out;
wire                        scl_oen;
wire                        sda_out;
wire                        sda_oen;
wire                        sda_oen_o;
// signal declarations
wire  [31:0]                sys_rdata;


wire                        hlcp_int;

// internal signal declaration
wire                        scl_oen_m;
wire                        scl_oen_s;
wire                        sda_oen_m;
wire                        sda_oen_s;
wire                        clk_r;
wire  [7:0]                 m_txd;
wire  [7:0]                 s_txd;
wire  [7:0]                 m_rxd;
wire  [7:0]                 s_rxd;
wire                        busy;
wire                        al;
wire                        core_en;
wire                        start;
wire                        stop;
wire                        wait_start;
wire                        wait_stop;
wire                        m_rd;
wire                        m_wr;
wire                        s_rd;
wire                        s_wr;
wire                        g_call; //broadcast
wire                        addr_match;
wire                        pending;
wire [2:0]                  m_state;
wire [4:0]                  mb_state;
wire [3:0]                  s_state;
//wire [2:0]                  hlcp_saddr_97;
wire [7:0]                  hlcp_saddr_70;
wire [5:0]                  ck_ratio;
wire                        hlcp_ackout;
wire                        m_ackout;
wire                        s_ackout;
wire                        int_mtx;
wire                        int_mrx;
wire                        int_stx;
wire                        int_srx;
wire                        con_stop;
wire                        con_start;
wire                        rst_sm_n;
wire                        add_mode;
wire                        int_stop;
wire                        start_off;
wire                        stop_off;
wire                        ack_check;
wire                        s_stretching;
wire                        stxr_change;
wire                        scl_in_rs;
wire                        sda_in_rs;

output                        match_w;
//wire [5:0]                  pwm_o;
///////////////////////0530/////////////////
/////////////////////////////////////////////////////////////////
assign scl_out = 1'b0;
assign sda_out = 1'b0;
//assign scl_out = (scl_oen==1)?1'b1:1'b0;
//assign sda_out = (sda_oen==1)?1'b1:1'b0;
assign scl_oen = scl_oen_m & scl_oen_s;
assign sda_oen = sda_oen_m & sda_oen_s;
/////////////////////////////////////////////////////////////////
/////////////////////////1009//////////////////////////////////////
input [3:0]                 CRC_M;
/////////////////////////////////////////////////////////////////

parameter   ROW           = 5'd0;
parameter   COLUMN        = 3'd0;


hlcp_sync    u_hlcp_sync(.sys_clk(sys_clk),
                       .sys_resetb(sys_resetb),
                       .scl_in(scl_in),
                       .sda_in(sda_in),
                       .scl_in_rs(scl_in_rs),
                       .sda_in_rs(sda_in_rs)
                       );


// Integrate register
hlcp_reg    u_hlcp_reg  (
						//APB interface
			.sys_clk(sys_clk),
                       .sys_addr(sys_addr),
                       .sys_wr(sys_wr),
                       .sys_sel(sys_sel),
                       .sys_rd(sys_rd),
                       .sys_wdata(sys_wdata),
                       .sys_rdata(sys_rdata),
                       .sys_resetb(sys_resetb),
					   
					   //
                       .ck_ratio(ck_ratio),
                       .hlcp_ackout(hlcp_ackout),
					   
                       .start(start),
                       .stop(stop),
                       .start_off(start_off),
                       .stop_off(stop_off),		
					   
					   //
                       .wait_start(wait_start),
                       .wait_stop(wait_stop),
                       //.hlcp_saddr_97(hlcp_saddr_97),
                       .hlcp_saddr_70(hlcp_saddr_70),
                       .busy(busy),
                       .m_rxd(m_rxd),
                       .s_rxd(s_rxd),
                       .m_txd(m_txd),
                       .s_txd(s_txd),
                       .core_en(core_en),
                       .m_rd(m_rd),
                       .m_wr(m_wr),
                       .s_rd(s_rd),
                       .s_wr(s_wr),
					   
					   // interrupt
                       .int_mtx(int_mtx),			// when master receives ACK, assert interrupt
                       .int_mrx(int_mrx),			// when master receives data, asseert interrupt
                       .int_stx(int_stx),			// when slave receives ACK, assert interrupt
                       .int_srx(int_srx),			// when slave receives data, asseert interrupt
                       .addr_match(addr_match),		// HLCP slave address match
                       .g_call(g_call),				//general call occurs
                       .int_stop(int_stop),			// abnormal stop interrupt
                       .al(al),						//Arbitration lost
					   
					   
                       .m_ack_in(m_ackout),
                       .s_ack_in(s_ackout),
                       .pending(pending),
                       .m_state(m_state),
                       .mb_state(mb_state),

					   .s_state(s_state),
					   .rst_sm_n(rst_sm_n),
                       .add_mode(add_mode),

                       .hlcp_int(hlcp_int),

                       .ack_check(ack_check),
                       .s_stretching(s_stretching),
                       .stxr_change(stxr_change)
                       );

hlcp_master u_hlcp_master (.sys_clk(sys_clk),
                         .clk_r(clk_r),
                         .sys_resetb(sys_resetb),
                         .txd(m_txd),
                         .ack_in(hlcp_ackout),
                         .ack_out(m_ackout),
                         .rxd(m_rxd),
                         .scl_i(scl_in_rs),
                         .sda_i(sda_in_rs),
                         .scl_oen(scl_oen_m),
                         .sda_oen(sda_oen_m),
						 
                         .busy(busy),
                         .al(al),
						 
                         .start(start),
                         .stop(stop),
                         .wait_start(wait_start),
                         .wait_stop(wait_stop),
                         .m_rd(m_rd),
                         .m_wr(m_wr),
                         .pending(pending),
                         .m_state(m_state),
                         .mb_state(mb_state),
						 
                         .int_mtx(int_mtx),
                         .int_mrx_w(int_mrx),
						 
                         .con_stop(con_stop),
                         .con_start(con_start),
						 
                         .start_off(start_off),
                         .stop_off(stop_off),

                         .rxd_report(rxd_report)
                          );

hlcp_divider u_hlcp_divider (.sys_clk(sys_clk),
                           .sys_resetb(sys_resetb),
                           .ck_ratio(ck_ratio),
                           .clk_r(clk_r),
                           .core_en(core_en)
                          );


hlcp_slv  #(.ROW(ROW), .COLUMN(COLUMN))
            u_hlcp_slave    ( .sys_clk(sys_clk),
                           .sys_resetb(sys_resetb),
                           .scl_i(scl_in_rs),
                           .scl_oen(scl_oen_s),
                           .sda_i(sda_in_rs),
                           .sda_oen(sda_oen_s),
                           
                           .clk_r(clk_r),

                           .hlcp_saddr_70(hlcp_saddr_70),
                           .int_stx(int_stx),
                           .int_srx(int_srx),
                           .pending(pending),
                           .s_state(s_state),
                           .s_rd(s_rd),
                           .s_wr(s_wr),
                           .addr_match(addr_match),
                           .g_call(g_call),
                           .core_en(core_en),
                           .con_stop(con_stop),
                           .con_start(con_start),
                           .ack_in(hlcp_ackout),
                           .ack_out(s_ackout),
                           .txd(s_txd),
                           .rxd(s_rxd),
                           .rst_sm_n(rst_sm_n),
                           .add_mode(add_mode),
                           .int_stop(int_stop),
                           .ack_check(ack_check),
                           .s_stretching(s_stretching),
                           .stxr_change(stxr_change),
                           
                           .CMD(CMD),
                           .ID_i(ID_i),
                           .busy(busy),

                           .CTS(CTS),
                           .CTS_error(CTS_error),

                           .init_output(init),

                           .CRC_M(CRC_M),


                           .match_w(match_w)
                         );
endmodule
