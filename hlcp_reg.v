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
// File name            : hlcp_reg.v                                  //
// Purpose              : HLCP control & status registers             //
//                                                                   //
//-------------------------------------------------------------------//
//*******************************************************************//

module hlcp_reg  (sys_clk,
                 sys_resetb,
                 sys_addr,
                 sys_wr,
                 sys_sel,
                 sys_rd,
                 sys_wdata,
                 sys_rdata,
                 ck_ratio,
                 hlcp_ackout,
                 start,
                 stop,
                 wait_start,
                 wait_stop,
                 //hlcp_saddr_97,
                 hlcp_saddr_70,
                 al,
                 busy,
                 m_rxd,
                 s_rxd,
                 m_txd,
                 s_txd,
                 core_en,
                 m_rd,
                 m_wr,
                 s_rd,
                 s_wr,
                 g_call,
                 addr_match,
                 m_ack_in,
                 s_ack_in,
                 pending,
                 m_state,
                 mb_state,
                 s_state,
                 int_mtx,
                 int_mrx,
                 int_stx,
                 int_srx,
                 int_stop,
                 rst_sm_n,
                 add_mode,
                 hlcp_int,
                 start_off,
                 stop_off,
                 ack_check,
                 s_stretching,
                 stxr_change
                 );

//APB interface signals
input                         sys_clk;         // system clock
input                         sys_resetb;      // system reset
input  [3:0]                  sys_addr;        // system input address
input                         sys_wr;          // system write enable
input                         sys_sel;         // system slave select
input                         sys_rd;          // system read enable
input  [31:0]                  sys_wdata;       // system write in data
output [31:0]                  sys_rdata;       // system read out data

output [5:0]                  ck_ratio;        // HLCP clcok divider
output                        hlcp_ackout;      // HLCP bus ack enable
output                        start;           // HLCP start
output                        stop;            // HLCP stop

output                        wait_start;      // control the slave wait when start mode
output                        wait_stop;       // control the slave wait when stop mode

output [7:0]                  hlcp_saddr_70;    // HLCP slave address bits [7:0]
input                         al;              // Arbitration lost
input                         busy;            // HLCP busy
input  [7:0]                  m_rxd;           // master received data
input  [7:0]                  s_rxd;           // slave received data


output [7:0]                  m_txd;           // data for master to transmit
output [7:0]                  s_txd;           // data for slave to transmit
output                        core_en;         // HLCP core enable
output                        m_rd;            // HLCP master read
output                        m_wr;            // HLCP master write
output                        s_rd;            // HLCP slave read
output                        s_wr;            // HLCP slave write
input                         g_call;          // general call occurs
input                         addr_match;      // HLCP slave address match
input                         m_ack_in;        // HLCP master receives ack
input                         s_ack_in;        // HLCP slave receives ack
output                        pending;         // pending bit -execution command while al and bus free
input  [2:0]                  m_state;         // Master State
input  [4:0]                  mb_state;        // Master Bit State
input  [3:0]                  s_state;         // Slave State
input                         int_mtx;         // when master receives ACK, assert interrupt
input                         int_mrx;         // when master receives data, asseert interrupt
input                         int_stx;         // when slave receives ACK, assert interrupt
input                         int_srx;         // when slave receives data, asseert interrupt
input                         int_stop;        // abnormal stop interrupt
output                        rst_sm_n;        // HLCP state machine reset
output                        add_mode;        // HLCP slave address mode
output                        hlcp_int;         // HLCP interrupt
input                         start_off;       // Turn off START command
input                         stop_off;        // Turn off STOP command
output                        ack_check;       // when slave in write mode, check received ACK/NAK to determine whether into IDLE mode
output                        s_stretching;    // HLCP slave port stretching
output                        stxr_change;     // STXR value change, will be set to high when its value changes

// HLCP register define

parameter ADDR_HLCPMTXR  = 4'h0; //
parameter ADDR_HLCPMRXR  = 4'h1;
parameter ADDR_HLCPSTXR  = 4'h2; //
parameter ADDR_HLCPSRXR  = 4'h3;

parameter ADDR_HLCPIER   = 4'h4;//2
parameter ADDR_HLCPISR   = 4'h5;//1
parameter ADDR_HLCPLCMR  = 4'h6;
parameter ADDR_HLCPLSR   = 4'h7;
parameter ADDR_HLCPCONR  = 4'h8;//5
parameter ADDR_HLCPOPR   = 4'h9;//3

parameter ADDR_HLCPDIV   = 4'hA;//4
parameter ADDR_HLCPSADDL = 4'hB;
parameter ADDR_HLCPSADDH = 4'hC;

parameter ADDR_CRCTRANSDCNT = 4'hD;

// signal descrition
wire  [31:0]                   sys_rdata;
wire [5:0]                    ck_ratio;
wire                          hlcp_ackout;
wire                          start;
wire                          stop;
wire                          resume;
wire [7:0]                    hlcp_saddr_70;
wire                         hlcp_single_device_write;
wire                          al;
wire                          busy;
wire [7:0]                    m_rxd;
wire [7:0]                    s_rxd;
wire [7:0]                    m_txd;
wire [7:0]                    s_txd;
wire                          core_en;
wire                          m_rd;
wire                          m_wr;
wire                          s_rd;
wire                          s_wr;
wire                          g_call;
wire                          addr_match;
wire                          m_ack_in;
wire                          s_ack_in;
reg                           pending;
wire                          int_mtx;
wire                          int_mrx;
wire                          int_stx;
wire                          int_srx;
wire                          int_stop;
wire                          rst_sm_n;
wire                          add_mode;
wire                           hlcp_int;
wire                          hlcp_int_i;
wire                          start_off;
wire                          stop_off;
wire                          ack_check;
reg                           s_stretching;
wire                          stxr_change;

//end APB signals

// registers declaration
reg   [7:0]                  hlcpmtxr;
reg   [7:0]                  hlcpmrxr;
reg   [7:0]                  hlcpstxr;
reg   [7:0]                  hlcpsrxr;
reg   [7:0]                  hlcpsaddr_h;
//reg   [7:0]                  hlcpsaddr_l;
reg   [9:0]                  hlcpier;
reg   [9:0]                  hlcpisr;
reg   [2:0]                  hlcplcmr;
reg   [1:0]                  hlcplsr;
reg   [7:0]                  hlcpconr;
reg   [2:0]                  hlcpopr;
reg   [5:0]                  hlcpdiv;

//registers write enable signals
wire hlcpmtxr_wen;      // HLCP MTXR write enble
wire hlcpstxr_wen;      // HLCP STXR write enable
wire hlcpsaddh_wen;     // HLCP slave address write enable
wire hlcpsaddl_wen;     // HLCP slave address write enable
wire hlcpier_wen;       // HLCP IER write enable
wire hlcpisr_wen;       // HLCP ISR write enable
wire hlcplcmr_wen;      // HLCP LCMR write enble
wire hlcpconr_wen;      // HLCP CONR write enable
wire hlcpopr_wen;       // HLCP OPR write enable
wire hlcpdiv_wen;       // HLCP DIV write enable

wire wr_enable;
wire rd_enable;

//assign wr_enable = sys_sel & sys_wr;
assign wr_enable = sys_sel & sys_wr;// & sys_rd; // for APB
reg sys_wr_reg;
always @(posedge sys_clk or negedge sys_resetb) begin
    if (!sys_resetb)
        sys_wr_reg  <= 1'b0;
    else
        sys_wr_reg  <= sys_wr;
end

//assign wr_enable    = (sys_sel & sys_wr & ~sys_wr_reg);

assign rd_enable = sys_sel & sys_rd;

assign hlcpmtxr_wen  =  wr_enable & (sys_addr == ADDR_HLCPMTXR);
assign hlcpstxr_wen  =  wr_enable & (sys_addr == ADDR_HLCPSTXR);
assign hlcpier_wen   =  wr_enable & (sys_addr == ADDR_HLCPIER);
assign hlcpisr_wen   =  wr_enable & (sys_addr == ADDR_HLCPISR);
assign hlcplcmr_wen  =  wr_enable & (sys_addr == ADDR_HLCPLCMR);
assign hlcpconr_wen  =  wr_enable & (sys_addr == ADDR_HLCPCONR);
assign hlcpopr_wen   =  wr_enable & (sys_addr == ADDR_HLCPOPR);
assign hlcpdiv_wen   =  wr_enable & (sys_addr == ADDR_HLCPDIV);
//assign hlcpsaddl_wen =  wr_enable & (sys_addr == ADDR_HLCPSADDL);
assign hlcpsaddh_wen =  wr_enable & (sys_addr == ADDR_HLCPSADDH);

//end register write enable signals declaration



//-------------------------------------------------------------------------
//                         APB BUS Read/Write
//-------------------------------------------------------------------------

// registers write

// --- MTXR ---
always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb)
      hlcpmtxr <= 0;
    else if (hlcpmtxr_wen)
      hlcpmtxr[7:0] <= sys_wdata[7:0];
    else
      hlcpmtxr[7:0] <=  hlcpmtxr[7:0];
  end

assign m_txd = hlcpmtxr[7:0];

// --- MRXR ---
always@(posedge sys_clk or negedge sys_resetb) begin
   if(!sys_resetb)
     hlcpmrxr <= 0;
   else if(m_rd)
     hlcpmrxr <= m_rxd;
   else
     hlcpmrxr[7:0] <=  hlcpmrxr[7:0];
 end

reg  [7:0] hlcpstxr_d; // delayed hlcpstxr

// --- STXR ---
  always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb)
      hlcpstxr <= 0;
    else if (hlcpstxr_wen)
      hlcpstxr[7:0] <= sys_wdata[7:0];
    else
      hlcpstxr[7:0] <=  hlcpstxr[7:0];
  end

assign s_txd = hlcpstxr[7:0];

always@(posedge sys_clk or negedge sys_resetb) begin
   if(!sys_resetb)
     hlcpstxr_d <= 0;
   else
     hlcpstxr_d <= hlcpstxr;
end

assign stxr_change = (hlcpstxr_d != hlcpstxr);


// --- SRXR ---
always@(posedge sys_clk or negedge sys_resetb) begin
   if(!sys_resetb)
     hlcpsrxr <= 0;
   else if(s_rd)
     hlcpsrxr <= s_rxd;////////////////////////////////////m_rxd
   else
     hlcpsrxr[7:0] <=  hlcpsrxr[7:0];
end


// --- SADDR ---
   always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb)
      hlcpsaddr_h <= 8'hff;
    else if (hlcpsaddh_wen)
      hlcpsaddr_h <= sys_wdata[7:0];
    else
      hlcpsaddr_h <=  hlcpsaddr_h;
  end

/*
   always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb)
      hlcpsaddr_l <= 8'hff;
    else if (hlcpsaddl_wen)
      hlcpsaddr_l <= sys_wdata[7:0];
    else
      hlcpsaddr_l <=  hlcpsaddr_l;
  end
*/

/////////////////////////////////////0528///////////////////////////////////////////
assign hlcp_saddr_70  = hlcpsaddr_h[7:0];
////////////////////////////////////////////////////////////////////////////////
// --- IER ---
always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb)
      hlcpier <= 0;
    else if (hlcpier_wen)
      hlcpier <= sys_wdata[9:0];
    else
      hlcpier <= hlcpier;
  end

wire    int_mtx_i;
wire    int_mrx_i;
wire    int_stx_i;
wire    int_srx_i;
wire    addr_match_i;
wire    g_call_i;
wire    int_stop_i;
wire    al_i;

assign  al_i          = hlcpier[7] & hlcpisr[7];
assign  int_stop_i    = hlcpier[6] & hlcpisr[6];
assign  g_call_i      = hlcpier[5] & hlcpisr[5];
assign  addr_match_i  = hlcpier[4] & hlcpisr[4];
assign  int_srx_i     = hlcpier[3] & hlcpisr[3];
assign  int_stx_i     = hlcpier[2] & hlcpisr[2];
assign  int_mrx_i     = hlcpier[1] & hlcpisr[1];
assign  int_mtx_i     = hlcpier[0] & hlcpisr[0];


assign hlcp_int = (al_i | int_stop_i |g_call_i |addr_match_i|int_srx_i |int_stx_i|int_mrx_i |int_mtx_i);


// --- ISR ---
always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb)
      hlcpisr <= 0;
    else if (hlcpisr_wen) begin
      hlcpisr[9] <= sys_wdata[9]?hlcpisr[9]:1'b0;
      hlcpisr[8] <= sys_wdata[8]?hlcpisr[8]:1'b0;
      hlcpisr[7] <= sys_wdata[7]?hlcpisr[7]:1'b0;
      hlcpisr[6] <= sys_wdata[6]?hlcpisr[6]:1'b0;
      hlcpisr[5] <= sys_wdata[5]?hlcpisr[5]:1'b0;
      hlcpisr[4] <= sys_wdata[4]?hlcpisr[4]:1'b0;
      hlcpisr[3] <= sys_wdata[3]?hlcpisr[3]:1'b0;
      hlcpisr[2] <= sys_wdata[2]?hlcpisr[2]:1'b0;
      hlcpisr[1] <= sys_wdata[1]?hlcpisr[1]:1'b0;
      hlcpisr[0] <= sys_wdata[0]?hlcpisr[0]:1'b0;
     end
    else if(int_mtx)
       hlcpisr[0] <= 1'b1;
    else if(int_mrx)
       hlcpisr[1] <= 1'b1;
    else if(int_stx)
       hlcpisr[2] <= 1'b1;
    else if(int_srx)
       hlcpisr[3] <= 1'b1;
    else if(addr_match)
       hlcpisr[4] <= 1'b1;
    else if(g_call)
       hlcpisr[5] <= 1'b1;
    else if(int_stop)
       hlcpisr[6] <= 1'b1;
    else if(al && hlcpconr[2])
       hlcpisr[7] <= 1'b1;
    else
       hlcpisr <= hlcpisr;
  end


wire   pending_i;
assign pending_i = |hlcpisr;  // If any interrupt occurs, pending_i will be high

wire   stretching_i;
assign stretching_i = |hlcpisr[6:2];  // If slave related interrupt occurs, stretching_i will be high


always@(posedge sys_clk or negedge sys_resetb)begin
   if(!sys_resetb)
      pending <= 0;
   else if(resume)
      pending <= 0;
   else if(pending_i)
      pending <= 1'b1;
   else
      pending <= pending;
  end



always@(posedge sys_clk or negedge sys_resetb)begin
   if(!sys_resetb)
      s_stretching <= 0;
   else if(resume)
      s_stretching <= 0;
   else if(stretching_i)
      s_stretching <= 1'b1;
   else
      s_stretching <= s_stretching;
  end

// --- LCMR ---
always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb)
      hlcplcmr <= 0;
    else if (hlcplcmr_wen)
      hlcplcmr <= sys_wdata[2 :0];
    else if (start_off)
      hlcplcmr[0] <= 1'b0;
    else if (stop_off)
      hlcplcmr[1] <= 1'b0;
    else if(!pending)
      hlcplcmr[2] <= 1'b0;
    else
      hlcplcmr <= hlcplcmr;
  end

assign start  = hlcplcmr[0];
assign stop   = hlcplcmr[1];
assign resume = hlcplcmr[2];

// --- LSR ---
wire    ack_bit;   // ack from receiver to register
assign  ack_bit = (s_wr)? s_ack_in : m_ack_in;
//assign  ack_bit = (m_wr)? m_ack_in : s_ack_in;

always@(posedge sys_clk or negedge sys_resetb) begin
    if(!sys_resetb)
      hlcplsr <= 0;
    else
      hlcplsr<= {ack_bit,busy};
  end

assign ack_check = hlcplsr[1];


// --- CONR ---
always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb)
      hlcpconr <= 0;
    else if (hlcpconr_wen)
      hlcpconr <= sys_wdata[7 :0];
    else
      hlcpconr <= hlcpconr;
  end

assign wait_stop  = hlcpconr[7];
assign wait_start = hlcpconr[6];
//assign crc_enable = hlcpconr[5];
assign hlcp_ackout = hlcpconr[4];
assign m_wr       = (hlcpconr[2] &  hlcpconr[3]);
assign m_rd       = (hlcpconr[2] & !hlcpconr[3]);
assign s_wr       = (hlcpconr[0] &  hlcpconr[1]);
assign s_rd       = (hlcpconr[0] & !hlcpconr[1]);

// --- OPR ---
always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb)
      hlcpopr <= 0;
    else if (hlcpopr_wen)
      hlcpopr <= sys_wdata[2 :0];
    else
      hlcpopr <= hlcpopr;
  end

assign core_en   = hlcpopr[0];
assign rst_sm_n  = !(hlcpopr[1] && hlcpopr[2]);
assign add_mode  = hlcpopr[2];

// --- DIV ---
always@(posedge sys_clk or negedge sys_resetb) begin
    if(!sys_resetb)
      hlcpdiv <= 0;
    else if(hlcpdiv_wen)
      hlcpdiv <= sys_wdata[5:0];
    else
      hlcpdiv <= hlcpdiv;
  end

assign ck_ratio  = hlcpdiv[5:0];






// registers read
 
reg [31:0] pre_rdata;
always@(*) begin
  if(rd_enable) begin
    case (sys_addr) // synopsys parallel_case
      ADDR_HLCPMTXR : pre_rdata = {24'd0, hlcpmtxr};
      ADDR_HLCPMRXR : pre_rdata = {24'd0, hlcpmrxr};
      ADDR_HLCPSTXR : pre_rdata = {24'd0, hlcpstxr};
      ADDR_HLCPSRXR : pre_rdata = {24'd0, hlcpsrxr};
      ADDR_HLCPIER  : pre_rdata = {22'd0, hlcpier};
      ADDR_HLCPISR  : pre_rdata = {22'd0, hlcpisr};
      ADDR_HLCPLCMR : pre_rdata = {24'd0, s_state, 1'b0, hlcplcmr};
      ADDR_HLCPLSR  : pre_rdata = {24'd0, 1'b0, m_state, 2'h0, hlcplsr};
      ADDR_HLCPCONR : pre_rdata = {24'd0, hlcpconr};
      ADDR_HLCPOPR  : pre_rdata = {24'd0, mb_state, hlcpopr};
      ADDR_HLCPDIV  : pre_rdata = {24'd0, 2'h0, hlcpdiv};
      //ADDR_HLCPSADDL: pre_rdata = {24'd0, hlcpsaddr_l};
      ADDR_HLCPSADDH: pre_rdata = {24'd0, hlcpsaddr_h};
      default      : pre_rdata = 32'h0;
    endcase
  end
  else
    pre_rdata = 32'h0;
end

assign sys_rdata = pre_rdata;

endmodule
