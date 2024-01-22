//*******************************************************************--
// Copyright (c) 2006-2013  Naoplus Co., Ltd.                        //
//*******************************************************************//
//*******************************************************************//
// Please review the terms of the license agreement before using     //
// this file. If you are not an authorized user, please destroy this //
// source code file and notify Naoplus Co., Ltd. immediately         //
// that you inadvertently received an unauthorized copy.             //
//*******************************************************************//
//---------------------------------------------------------------------
// Project name         : MiCSoC                                     //
// Project description  :                                            //
//                                                                   //
// File name            : hlcp_master.v                               //
// Purpose              : HLCP master controller                      //
//                                                                   //
//---------------------------------------------------------------------
//*********************************************************************

// HLCP command define
`define HLCP_NOP        5'b00000    // NOP
`define HLCP_START      5'b00001    // START
`define HLCP_WRITE      5'b00010    // WRITE
`define HLCP_READ       5'b00100    // READ
`define HLCP_STOP       5'b01000    // STOP
`define HLCP_WAIT       5'b10000    // WAIT

module hlcp_master      (sys_clk,
                        clk_r,
                        sys_resetb,
                        txd,
                        ack_in,
                        ack_out,
                        rxd,
                        scl_i,
                        sda_i,
                        scl_oen,
                        sda_oen,
                        busy,
                        al,
                        start,
                        stop,
                        wait_start,
                        wait_stop,
                        m_rd,
                        m_wr,
                        pending,
                        m_state,
                        mb_state,
                        int_mtx,
                        int_mrx_w,
                        con_stop,
                        con_start,
                        start_off,
                        stop_off,
//////////////////////////////////////////////////////////////////////
                        fetch,
                        rxd_report
//////////////////////////////////////////////////////////////////////                        
                        );

input        sys_clk;          // APB clock in
input        clk_r;            // SCL rising
input        sys_resetb;       // APB reset
input        start;            // command start
input        stop;             // command stop
input        wait_start;       // control the slave wait when start mode
input        wait_stop;        // control the slave wait when stop mode
input  [7:0] txd;              // data transimitted
input        ack_in;           // ack in
output       ack_out;          // ack out
output [7:0] rxd;              // data out
output       busy;             // HLCP busy
output       al;               // HLCP arbitration lost
input        scl_i;            // SCL input
input        sda_i;            // SDA input
output       scl_oen;          // SCL output enable
output       sda_oen;          // SDA output enable
input        m_rd;             // master m_rd enable
input        m_wr;             // master m_wr enable
input        pending;          // HLCP core pending
output [2:0] m_state;          // Master current state
output [4:0] mb_state;         // Master bit current state
output       int_mtx;          // when receives ACK, assert interrupt
output       int_mrx_w;        // when receives data, asseert interrupt
output       con_stop;         // HLCP bus stop condition
output       con_start;        // HLCP bus start condition
output       start_off;        // Turn off START command
output       stop_off;         // Turn off STOP command
/////////////////////////////0531//////////////////////////////
output       fetch;

output [15:0]    rxd_report;

///////////////////////////////////////////////////////////////
// Input command
wire       sys_clk;
wire       clk_r;
wire       sys_resetb;
wire       start;         // internal start
wire       stop;          // internal stop
wire [7:0] txd;           // data for transmitting
wire       ack_in;        // external slave ack_in
reg        ack_out;       // ack to register bank
reg        byte_ack;      // amd execution over ack
reg [7:0]  rxd;           // data out to register bank
wire       busy;          // HLCP in busy
wire       al;            // arbitration lost
wire       scl_i;         // SCL input
wire       sda_i;         // SDA input
wire       scl_oen;       // SCL output enable
wire       sda_oen;       // SDA output enable
wire       m_rd;          // HLCP master m_rd enable
wire       m_wr;          // HLCP master m_wr enable
wire       pending;       // Before software handles ISR bits, core is pending
wire       int_mtx;       // when receives ACK, assert interrupt
wire       int_mrx_w;       // when receives data, asseert interrupt
wire       con_stop;      // HLCP bus stop condition
wire       con_start;     // HLCP bus start condition
reg        start_off;     // Turn off START command
reg        stop_off;      // Turn off stop command

////////0531//////
wire       fetch;         // Data fetch to shift register
//////////////////

// State Machines
reg [4:0] core_cmd;  // command to bit control    //change from [3:0] to [4:0]
reg       core_txd;  // transfer data to bit controller
reg       shift;     // shift register shift enable
reg       ld;        // load data ftom register to shift register
reg [3:0] c_state;   // current state
reg       handshake; // write to read

// Core_rxd
wire      core_rxd;


// Counter
reg [3:0] counter;
wire      cnt_done;


// Shift register
reg [7:0] sr;


reg [15:0] rxd_report;
wire edge_detect;
wire int_mrx;

always@(posedge sys_clk or negedge sys_resetb)
    if(!sys_resetb)
        rxd_report <= 16'b0;
    else if(int_mrx)
        rxd_report <= {rxd_report[7:0],rxd};
    else
        rxd_report <= rxd_report;            

// bit controller bit_ack and bit_ack_stop
wire bit_ack;
wire bit_ack_stop;
wire bit_ack_start;

// hlcp crc
reg [7:0] ld_cnt;


// Parameters
parameter  ST_IDLE    = 3'b000;
parameter  ST_START   = 3'b001;
parameter  ST_READ    = 3'b010;
parameter  ST_WRITE   = 3'b011;
parameter  ST_ACK     = 3'b100;
parameter  ST_STOP    = 3'b101;
parameter  ST_WAIT    = 3'b110;

parameter  ST_ACK2    = 3'b111;
parameter  ST_READ2   = 4'd8;
// ********************************************
//            Byte controller
// ********************************************
reg [4:0] count_fetch;

always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb) begin
        count_fetch <= 5'd0;
    end
    else if(count_fetch==5'b10001) begin
        count_fetch <= 5'b0;
    end
    else if(c_state==4'h2&&bit_ack) begin
        count_fetch <= count_fetch + 1'b1;
    end
    else begin
        count_fetch <= count_fetch;
    end
end

reg ld_two;

///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
reg flag_for_SDA_stabilize;
wire done0;
reg  done1;

always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb)
        flag_for_SDA_stabilize <= 1'b0;
    else if(m_rd && (count_fetch == 5'h10))
        flag_for_SDA_stabilize <= 1'b1;
    else if(mb_state == 5'h7)
        flag_for_SDA_stabilize <= 1'b0;
    else
        flag_for_SDA_stabilize <= flag_for_SDA_stabilize;
end

/*
always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb)
        flag_for_SDA_stabilize <= 1'b0;
    else if(m_rd == 1'b1 && (count_fetch == 5'h10))
        flag_for_SDA_stabilize <= 1'b1;
    else if(mb_state == 5'h7)
        flag_for_SDA_stabilize <= 1'b0;
    else
        flag_for_SDA_stabilize <= flag_for_SDA_stabilize;
end
*/
// counter
always@(posedge sys_clk or negedge sys_resetb)begin
if(!sys_resetb)
 counter <= 4'h7;
else if(ld_two)     // Start Condition + DATA 8bit (9)
 counter <= 4'h7;
else if(ld)
 counter <= 4'h7;
else if(shift|fetch)
 counter <= counter-1;
 else
 counter <= counter;
end

assign cnt_done = ~(|counter);



assign done0 = ~(|counter) & scl_i;

always@(posedge sys_clk or negedge sys_resetb)begin
if(!sys_resetb)
   done1 <= 1'b0;
else
   done1 <= done0;
 end

// Data register load signal

wire ld_data;

reg pending_d;  // pending delay

always@(posedge sys_clk or negedge sys_resetb)begin
   if(!sys_resetb)
     pending_d <= 1'b0;
   else
     pending_d <= pending;
end

assign ld_data = pending_d & !pending;
//////////////0906//////////////////

assign edge_detect = pending_d!=pending;

wire edge_detect_bit_ack;
reg   bit_ack_d;

assign edge_detect_bit_ack = bit_ack!=bit_ack_d;

always@(posedge sys_clk or negedge sys_resetb)begin
   if(!sys_resetb)
     bit_ack_d <= 1'b0;
   else
     bit_ack_d <= bit_ack;
end

// Shift register
always@(posedge sys_clk or negedge sys_resetb)begin
if(!sys_resetb)            // when reset, clear sr to 0
  sr <= 8'b0;
else if(((ld_data & (m_wr))|(m_wr & ld & !pending))) // when ld or ld_data, sr = transimit data
  sr <= txd;
else if ((shift|fetch|handshake))          // when shift
  sr <= {sr[6:0], core_rxd};
else
  sr <= sr;
end

always@(posedge sys_clk or negedge sys_resetb)begin
if(!sys_resetb)            // when reset, clear sr to 0
  ld_cnt <= 8'd0;
else if (stop_off)
  ld_cnt <= 8'd0;
else if (byte_ack)          
  ld_cnt <= ld_cnt + 1'b1;
else
  ld_cnt <= ld_cnt;
end




always@(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb)
        rxd <= 1'b0;
    else if(count_fetch==5'b01000)
        rxd <= sr;
    else if(count_fetch==5'b10000)
        rxd <= sr;
    else
        rxd <= rxd;
end
// assign rxd = sr;       // rxd = shift register value

assign int_mtx = byte_ack & m_wr & !start & !stop;
assign int_mrx = !done0 & done1 & m_rd & (c_state == ST_ACK) ;

reg int_mrx_r;
//wire int_mrx_w;

always@(posedge sys_clk or negedge sys_resetb)
begin
    if(!sys_resetb) begin
        int_mrx_r <= 1'b0;
    end
    else
        int_mrx_r <= int_mrx;
end

assign int_mrx_w = int_mrx_r;

reg [3:0] flag;

// Byte controller state machine
always @(posedge sys_clk or negedge sys_resetb )
        if(!sys_resetb)
        begin
            core_cmd <= `HLCP_NOP;
            core_txd <= 1'b0;
            shift    <= 1'b0;
            ld       <= 1'b0;
            byte_ack  <= 1'b0;
            c_state  <= ST_IDLE;
            ack_out  <= 1'b0;
            start_off <=1'b0;
            stop_off <=1'b0;
            handshake <= 1'b0;
            flag <= 1'b0;
            ld_two <= 1'b0;
        end
        else if(al)      // Arbitration lost
        begin
            core_cmd <= `HLCP_NOP;
            core_txd <= 1'b0;
            shift    <= 1'b0;
            ld       <= 1'b0;
            byte_ack  <= 1'b0;
            c_state  <= ST_IDLE;
            ack_out  <= 1'b0;
            start_off <=1'b0;
            stop_off <=1'b0;
            handshake <= 1'b0;
        end
        else  begin      // Normal operation
            // initially reset all signals
            core_txd  <=  sr[7];
            shift     <=  1'b0;
            ld        <=  1'b0;
            byte_ack  <=  1'b0;
            start_off <=  1'b0;
            stop_off  <=  1'b0;
            handshake <=  1'b0;
            case(c_state)
                ST_IDLE:
                    if (start & (m_wr||m_rd))         // Transfer 1st byte
                    begin
                        c_state  <=  ST_START;
                        core_cmd <=  `HLCP_START;
                        ld <=  1'b1;
                    end
                    else begin// Add after RTLDA
                        c_state <= ST_IDLE;
                        core_cmd <= `HLCP_NOP;
                    end
                ST_START:
                    if(bit_ack_start && m_rd) begin
                        start_off <= 1'b1;
                        ld_two <= 1'b1;         // counter 주석?�� ?��?��?��?��
                        c_state  <=  ST_READ;
                        core_cmd <=  `HLCP_READ;
                    end
                    else if (bit_ack_start && m_wr) begin      // After START, Master must be in WRITE mode
                        start_off <= 1'b1;
                        ld <=  1'b1;
                        c_state  <=  ST_WRITE;
                        core_cmd <=  `HLCP_WRITE;
                    end
                    else   // Add after RTLDA
                        c_state <= ST_START;

                ST_READ:
                    if (bit_ack) begin       // If a write command is finished\
                        if (cnt_done)      // and a byte transfer ok
                        begin
                            c_state  <=  ST_ACK;
                            core_cmd <=  `HLCP_READ;
                        end
                        else              // else stay in write codition
                        begin
                            c_state  <=  ST_READ;   // stay in same state
                            core_cmd <=  `HLCP_READ; // m_rd next bit
                            ld_two   <=  1'b0;
                        end
                    end
                    else begin// Add after RTLDA
                        c_state  <=  ST_READ;
                    end
                ST_WRITE:
                    if (pending) begin
                        if(stop)
                        begin
                            c_state  <=  ST_STOP;
                            core_cmd <=  `HLCP_STOP;
                        end
                        else if(start)
                        begin
                            c_state  <=  ST_START;
                            core_cmd <=  `HLCP_START;
                        end
                        else if(m_wr)
                        begin
                            c_state  <=  ST_WRITE;
                            core_cmd <=  `HLCP_WRITE;
                        end
                        else if(m_rd)
                        begin
                            handshake <= 1'b1;
                            c_state  <=  ST_READ;
                            core_cmd <=  `HLCP_READ;
                        end
                        else   // Add after RTLDA
                            c_state <= ST_WRITE;
                    end
                    else
                    if (bit_ack) begin       // If a write command is finished
                        if (cnt_done)      // and a byte transfer ok
                        begin
                            c_state  <=  ST_ACK;
                            core_cmd <=  `HLCP_READ;
                        end
                        else              // else stay in write codition
                        begin
                            c_state  <=  ST_WRITE;   // stay in same state
                            core_cmd <=  `HLCP_WRITE; // m_wr next bit
                            shift    <=  1'b1;
                        end
                    end
                    else  // Add after RTLDA
                        c_state <= ST_WRITE;
                ST_ACK:
                    if(bit_ack)begin
                        ld <= 1'b1;
                        byte_ack <= 1'b1;
                        c_state  <= ST_WAIT;
                        core_cmd <= `HLCP_WAIT;
                        ack_out  <= sda_i;
                    end
                ST_STOP:
                    if (bit_ack_stop)begin
                        stop_off <= 1'b1;
                        c_state  <=  ST_IDLE;
                        core_cmd <=  `HLCP_NOP;
                    end
                    else  // Add after RTLDA
                        c_state  <=  ST_STOP;

                ST_WAIT:
                    if(!pending||sr==8'hff) begin
                        if(stop) begin
                            c_state  <=  ST_STOP;
                            core_cmd <=  `HLCP_STOP;
                            ld <= 1'b1;
                        end
                        else if(start) begin
                            c_state  <=  ST_START;
                            core_cmd <=  `HLCP_START;
                            ld <= 1'b1;
                        end
                        else if(m_wr) begin
                            c_state  <=  ST_WRITE;
                            core_cmd <=  `HLCP_WRITE;
                            ld <= 1'b1;
                        end
                        else if(m_rd) begin
                            c_state  <=  ST_READ;
                            core_cmd <=  `HLCP_READ;
                            ld <= 1'b1;
                        end
                        else  begin // Change after RTLDA
                            c_state  <=  ST_WAIT;
                            core_cmd <=  `HLCP_WAIT;
                            ld <= 1'b1;
                        end
                    end
                    else begin // Add after RTLDA
                        c_state  <=  ST_WAIT;
                    end

                default: begin
                    c_state  <=  ST_IDLE;
                    core_txd  <=  sr[7];
                    shift     <=  1'b0;
                    ld        <=  1'b0;
                    byte_ack  <=  1'b0;
                    start_off <=  1'b0;
                    stop_off  <=  1'b0;
                    handshake <=  1'b0;
                    end

            endcase
        end



assign m_state = c_state;
/*
// synopsys translate_off
reg [(40*8):0] m_state_str;

always @ (c_state) begin
   case(c_state) 
      ST_IDLE   : m_state_str = "ST_IDLE";
      ST_START  : m_state_str = "ST_START";
      ST_READ   : m_state_str = "ST_READ";
      ST_WRITE  : m_state_str = "ST_WRITE";
      ST_ACK    : m_state_str = "ST_ACK";
      ST_STOP   : m_state_str = "ST_STOP";
      ST_WAIT   : m_state_str = "ST_WAIT";
   endcase
end
// synopsys translate_on
*/

// integrate bit_controller
hlcp_bit_ctrl  u_bit_ctrl (
                         .sys_clk(sys_clk),
                         .sys_resetb(sys_resetb),
                         .cmd(core_cmd),
                         .bit_ack(bit_ack),
                         .bit_ack_stop(bit_ack_stop),
                         .bit_ack_start(bit_ack_start),
                         .busy(busy),
                         .al(al),
                         .core_txd(core_txd),
                         .core_rxd(core_rxd),
                         .scl_i(scl_i),
                         .scl_oen(scl_oen),
                         .sda_i(sda_i),
                         .sda_oen(sda_oen),
                         .clk_r(clk_r),
                         .pending(pending),
                         .con_stop(con_stop),
                         .con_start(con_start),
                         .fetch(fetch),
                         .mb_state(mb_state),
                         .start(start),
                         .stop(stop),
                         .wait_start(wait_start),
                         .wait_stop(wait_stop),

                         .sr(sr),
                         .flag_for_SDA_stabilize(flag_for_SDA_stabilize)
                        );


endmodule
