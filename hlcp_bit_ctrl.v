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
// File name            : hlcp_bit_ctrl.v                             //
// Purpose              : HLCP master bit timing controller           //
//                                                                   //
//-------------------------------------------------------------------//
//*******************************************************************//

// HLCP command define
`define HLCP_NOP        5'b00000    // NOP
`define HLCP_START      5'b00001    // START
`define HLCP_WRITE      5'b00010    // WRITE
`define HLCP_READ       5'b00100    // READ
`define HLCP_STOP       5'b01000    // STOP
`define HLCP_WAIT       5'b10000    // WAIT

module hlcp_bit_ctrl(
                    // Inputs
                    sys_clk,       // system clock
                    sys_resetb,    // system reset  : Active low
                    cmd,           // command to bit controller
                    core_txd,      // Data in
                    scl_i,         // SCL input
                    sda_i,         // SDA input
                    clk_r,         // divided clock input
                    pending,       // pending due to interrupt handling
                    con_stop,      // STOP condition
                    con_start,     // START condition
                    start,         // HLCP start
                    stop,          // HLCP stop
                    wait_start,    // control the slave wait when start mode
                    wait_stop,     // control the slave wait when stop mode
                    // Outputs
                    mb_state,      // master bit current state
                    fetch,         // Data Fetch to shift register
                    bit_ack,       // finish command execution, ack to byte controller
                    bit_ack_stop,  // finish stop command execution, ack to byte controller
                    bit_ack_start, // finish start command execution, ack to byte controller
                    busy,          // HLCP bus free status
                    al,            // Arbitration lost
                    core_rxd,      // Data out
                    scl_oen,       // SCL output enable
                    sda_oen,        // SDA output enable

                    master_busy_o,
                    sr,

                    flag_for_SDA_stabilize
                   );

//*********************************
//        Input and output
//*********************************
input        sys_clk;                 // APB clock input
input        sys_resetb;             // APB reset input
input  [4:0] cmd;                  // command from byte controller
input        core_txd;             // data to be transferred
input        scl_i;                // hlcp clock line input
input        sda_i;                // hlcp data line input
input        clk_r;                // divided clock rising edge input
input        pending;              // pending due to interrupt handling
input        start;                // HLCP start
input        stop;                 // HLCP stop
input        wait_start;           // control the slave wait when start mode
input        wait_stop;            // control the slave wait when stop mode
input        flag_for_SDA_stabilize;
output [4:0] mb_state;             // master bit current state
output       fetch;                // Data Fetch to shift register
output       bit_ack;              // command complete acknowledge
output       bit_ack_stop;         // stop command complete acknowledge
output       bit_ack_start;        // start command complete acknowledge
output       busy;                 // hlcp bus busy
output       al;                   // hlcp bus arbitration lost
output       core_rxd;             // data received
output       scl_oen;              // hlcp clock line output enable (active low)
output       sda_oen;              // hlcp data line output enable (active low)
output       con_stop;             // HLCP bus stop condition
output       con_start;            // HLCP bus start condition
////////////////
output wire master_busy_o;
reg   master_busy;       // HLCP master busy
input wire [7:0] sr;
////////////////

// Signals declarations
wire        sys_clk;
wire        sys_resetb;
wire  [4:0] cmd;
wire        core_txd;
wire        scl_i;
wire        sda_i;
wire        clk_r;
wire        pending;
wire        con_stop;
wire        con_start;
wire        start;
wire        stop;
reg         fetch;
reg         bit_ack;
reg         bit_ack_stop;
reg         bit_ack_start;
reg         busy;
reg         al;
reg         core_rxd;
reg         scl_oen;
reg         sda_oen;


// variable declarations
reg         scl_c, sda_c;           // synchronized SCL and SDA inputs
reg         dscl_oen;               // delayed scl_oen
reg         sda_chk;                // check SDA output (Multi-master arbitration)
wire        clk_en;                 // clock generation signals
wire        slave_wait;
wire        al_ignore;


// --------------------------------------------------------------------------------
// module body
// --------------------------------------------------------------------------------

// whenever the slave is not ready it can delay the cycle by pulling SCL low
// delay scl_oen
always @(posedge sys_clk or negedge sys_resetb)
if(!sys_resetb)
  dscl_oen <= 1'b0;
else
  dscl_oen <=  scl_oen;

// In start/stop command executed phase, don't check slave wait
//assign slave_wait = ((dscl_oen && !scl_c)||(!dscl_oen && scl_c)) & !start & !stop;
wire start_t = (wait_start) ? start : 1'b0;
wire stop_t  = (wait_stop ) ? stop  : 1'b0;

assign slave_wait = ((dscl_oen && !scl_c)||(!dscl_oen && scl_c)) & !start_t & !stop_t;
assign al_ignore = (scl_oen && !scl_i)||(!scl_oen && scl_i);


// generate clk enable signal
//assign clk_en = !slave_wait & !pending;
assign clk_en = !slave_wait & clk_r & !pending;

// generate bus status controller
reg scl_p, sda_p;
reg sta_condition;
reg sto_condition;

// synchronize SCL and SDA inputs
// reduce metastability risc
always @(posedge sys_clk or negedge sys_resetb)
  if (!sys_resetb)
    begin
        scl_c <=  1'b1;
        sda_c <=  1'b1;

        scl_p <=  1'b1;
        sda_p <=  1'b1;
    end

  else
    begin
        scl_c <=  scl_i;
        sda_c <=  sda_i;

        scl_p <=  scl_c;
        sda_p <=  sda_c;
    end

// detect start condition => detect falling edge on SDA while SCL is high
// detect stop condition => detect rising edge on SDA while SCL is high
always @(posedge sys_clk or negedge sys_resetb)
  if (~sys_resetb)
    begin
        sta_condition <=  1'b0;
        sto_condition <=  1'b0;
    end

  else
    begin
        sta_condition <=  ~sda_c &  sda_p & scl_c & scl_p;
        sto_condition <=   sda_c & ~sda_p & scl_c & scl_p;
    end

assign con_stop =  sto_condition;
assign con_start = sta_condition;



// generate hlcp bus busy signal
always @(posedge sys_clk or negedge sys_resetb)
  if(!sys_resetb)
    busy <=  1'b0;
  else
    busy <=  (sta_condition | busy) & ~sto_condition;
    //busy <=  (sta_condition | busy) & ~sto_condition;





// generate arbitration lost signal
// aribitration lost when:
// 1) master drives SDA high, but the hlcp bus is low
// 2) stop detected while not requested
reg cmd_stop;
reg cmd_stop_d;

always @(posedge sys_clk or negedge sys_resetb)
  if (~sys_resetb)
    cmd_stop <=  1'b0;
  else if (clk_en)
    cmd_stop <=  cmd == `HLCP_STOP;
  else
    cmd_stop <= cmd_stop;

 always @(posedge sys_clk or negedge sys_resetb)
  if (~sys_resetb)
    cmd_stop_d <=  1'b0;
  else if (clk_en)
    cmd_stop_d <= cmd_stop ;
  else
    cmd_stop_d <= cmd_stop_d;


// HLCP core busy detection


always @(posedge sys_clk or negedge sys_resetb)
  if (~sys_resetb)
    master_busy <=  1'b0;
  else if (sta_condition)
    master_busy <=  1'b1;
  else if (sto_condition)
    master_busy <=  1'b0;
  else if (al)
    master_busy <=  1'b0;
  else
    master_busy <=  master_busy;

assign master_busy_o = master_busy;

// arbitration lost detection
always @(posedge sys_clk or negedge sys_resetb)
  if (~sys_resetb)
    al <=  1'b0;
  else
    // AL occurs when SDA check fail or master detects STOP but not issue STOP aommand while master is active
      al <= (sda_chk & ~sda_c & sda_oen & ~al_ignore) | (sto_condition & ~cmd_stop_d & master_busy);

// generate core_rxd signal (store SDA on rising edge of SCL)
always @(posedge sys_clk or negedge sys_resetb)
   if (~sys_resetb)
     core_rxd <= 0;
   else if(scl_c & ~scl_p)
     core_rxd <=  sda_c;
   else
     core_rxd <= core_rxd;

reg [4:0] c_state;
reg [4:0] count_fetch;

always@(posedge sys_clk or negedge sys_resetb)begin
    if(!sys_resetb) begin
        count_fetch <= 5'd0;
    end
    else if(pending) begin
        count_fetch <= 5'b0;
    end
    else if(count_fetch==5'd20) begin
        count_fetch <= count_fetch;
    end
    else if(bit_ack&&count_fetch!=5'd20) begin
        count_fetch <= count_fetch + 1'b1;
    end
    else begin
        count_fetch <= count_fetch;
    end
end
// generate statemachine

// next_state decoder
parameter  IDLE    = 5'b0_0000;//0
parameter  START1  = 5'b0_0001;//1
parameter  START2  = 5'b0_0010;//2
parameter  START3  = 5'b0_0011;//3
parameter  START4  = 5'b0_0100;//4
parameter  START5  = 5'b0_0101;//5
parameter  STOP1   = 5'b0_0110;//6
parameter  STOP2   = 5'b0_0111;//7
parameter  STOP3   = 5'b0_1000;//8
parameter  STOP4   = 5'b0_1001;//9
parameter  RD1     = 5'b0_1010;//10
parameter  RD2     = 5'b0_1011;//11
parameter  RD3     = 5'b0_1100;//12
parameter  RD4     = 5'b0_1101;//13
parameter  WR1     = 5'b0_1110;//14
parameter  WR2     = 5'b0_1111;//15
parameter  WR3     = 5'b1_0000;
parameter  WR4     = 5'b1_0001;
parameter  WAITING = 5'b1_0010;

always @(posedge sys_clk or negedge sys_resetb)
  if (!sys_resetb)
    begin
        c_state       <=  IDLE;
        bit_ack       <=  1'b0;
        bit_ack_stop  <=  1'b0;
        bit_ack_start <=  1'b0;
        scl_oen       <=  1'b1;
        sda_oen       <=  1'b1;
        sda_chk       <=  1'b0;
        fetch         <=  1'b0;
    end


  else if (al)
    begin
        c_state       <=  IDLE;
        bit_ack       <=  1'b0;
        bit_ack_stop  <=  1'b0;
        bit_ack_start <=  1'b0;
        scl_oen       <=  1'b1;
        sda_oen       <=  1'b1;
        sda_chk       <=  1'b0;
        fetch         <=  1'b0;
    end
    
  else
    begin
        bit_ack       <=  1'b0;      // default no command acknowledge + assert bit_ack only 1clk cycle
        bit_ack_stop  <=  1'b0;
        bit_ack_start <=  1'b0;
        fetch <= 1'b0;
        if(flag_for_SDA_stabilize)
                  sda_oen <=  1'b0;
        if (clk_en)      //clk_en
          case (c_state) // synopsis full_case parallel_case
            // IDLE state
            IDLE:
            begin
                case (cmd) // synopsis full_case parallel_case
                  `HLCP_START:
                     c_state <=  START1;

                  `HLCP_STOP:
                     c_state <=  STOP1;

                  `HLCP_WRITE:
                     c_state <=  WR1;

                  `HLCP_READ:
                     c_state <=  RD1;

                  `HLCP_WAIT:
                     c_state <=  WAITING;

                  default:
                    c_state  <=  IDLE;
                endcase
                
                scl_oen <=  scl_oen; // keep SCL in same state
                sda_oen <=  sda_oen; // keep SDA in same state
                sda_chk <=  1'b0;    // don't check SDA output

            end

            // start
            START1:
            begin
                c_state <=  START2;
                scl_oen <=  scl_oen; // keep SCL in same state
                sda_oen <=  1'b1;    // set SDA high
                sda_chk <=  1'b0;    // don't check SDA output
            end

            START2:
            begin
                c_state <=  START3;
                scl_oen <=  1'b1; // set SCL high
                sda_oen <=  1'b1; // keep SDA high
                sda_chk <=  1'b0; // don't check SDA output
            end

            START3:
            begin
                c_state <=  START4;
                scl_oen <=  1'b1; // keep SCL high
                sda_oen <=  1'b0; // set SDA low
                sda_chk <=  1'b0; // don't check SDA output
            end

            START4:
            begin
                c_state <=  START5;
                scl_oen <=  1'b1; // keep SCL high
                sda_oen <=  1'b0; // keep SDA low
                sda_chk <=  1'b0; // don't check SDA output
            end

            START5:
            begin
                c_state <=  IDLE;
                bit_ack <=  1'b1;
                bit_ack_start  <=  1'b1;
                scl_oen <=  1'b0; // set SCL low
                sda_oen <=  1'b0; // keep SDA low
                sda_chk <=  1'b0; // don't check SDA output
            end

            // stop
            STOP1:
            begin
                c_state <=  STOP2;
                scl_oen <=  1'b0; // keep SCL low
                sda_oen <=  1'b0; // set SDA low
                sda_chk <=  1'b0; // don't check SDA output
            end

            STOP2:
            begin
                c_state <=  STOP3;
                scl_oen <=  1'b1; // set SCL high
                sda_oen <=  1'b0; // keep SDA low
                sda_chk <=  1'b0; // don't check SDA output
            end

            STOP3:
            begin
                c_state <=  STOP4;
                scl_oen <=  1'b1; // keep SCL high
                sda_oen <=  1'b0; // keep SDA low
                sda_chk <=  1'b0; // don't check SDA output
            end

            STOP4:
            begin
                c_state      <=  IDLE;
                bit_ack      <=  1'b1;
                bit_ack_stop <=  1'b1;
                scl_oen      <=  1'b1; // keep SCL high
                sda_oen      <=  1'b1; // set SDA high
                sda_chk      <=  1'b0; // don't check SDA output
            end

            // read
            RD1:
            begin
                if(flag_for_SDA_stabilize)
                  sda_oen <=  1'b0;
                else                  
                  sda_oen <=  1'b1; // keep SDA tri-stated
                c_state <=  RD2;
                scl_oen <=  1'b0;//scl_oen <=  1'b0; // keep SCL low
                sda_chk <=  1'b0; // don't check SDA output
            end

            RD2:
            begin
                if(stop)
                  scl_oen <=  1'b0; // set SCL high
                else
                  scl_oen <=  1'b1;
                if(flag_for_SDA_stabilize)
                  sda_oen <=  1'b0;
                else                  
                  sda_oen <=  1'b1; // keep SDA tri-stated            
                c_state <=  RD3;
                sda_chk <=  1'b0; // don't check SDA output
            end

            RD3:
            begin
                if(stop)
                  scl_oen <=  1'b0; // set SCL high
                else
                  scl_oen <=  1'b1;              
                if(flag_for_SDA_stabilize)
                  sda_oen <=  1'b0;
                else                  
                  sda_oen <=  1'b1; // keep SDA tri-stated
                c_state <=  RD4;
                sda_chk <=  1'b0; // don't check SDA output
            end

            RD4:
            begin
                if(flag_for_SDA_stabilize)
                  sda_oen <=  1'b0;
                else                  
                  sda_oen <=  1'b1; // keep SDA tri-stated              
                c_state <=  IDLE;
                bit_ack <=  1'b1;
                scl_oen <=  1'b0; // set SCL low
                sda_chk <=  1'b0; // don't check SDA output
                fetch   <=  1'b1;
            end

            // write
            WR1:
            begin
                c_state <=  WR2;
                scl_oen <=  1'b0; // keep SCL low
                sda_oen <=  core_txd;  // set SDA
                sda_chk <=  1'b0; // don't check SDA output (SCL low)
            end

            WR2:
            begin
                c_state <=  WR3;
                scl_oen <=  1'b1; // set SCL high
                sda_oen <=  core_txd;  // keep SDA
                sda_chk <=  1'b1; // check SDA output
            end

            WR3:
            begin
                c_state <=  WR4;
                scl_oen <=  1'b1; // keep SCL high
                sda_oen <=  core_txd;
                sda_chk <=  1'b1; // check SDA output
            end

            WR4:
            begin
                c_state <=  IDLE;
                bit_ack <=  1'b1;
                scl_oen <=  1'b0; // set SCL low
                sda_oen <=  core_txd;
                sda_chk <=  1'b0; // don't check SDA output (SCL low)
            end

            // WAITING
            WAITING:
             begin
                 c_state <=  IDLE;
                 scl_oen <=  1'b0; // keep SCL low
                 sda_oen <=  sda_oen;  // set SDA unchange
                 sda_chk <=  1'b0; // don't check SDA output (SCL low)
                 //bit_ack <=  1'b1;                 
             end


       default:
            c_state <= IDLE;

       endcase

       else
                 c_state <= c_state;
    end

assign mb_state = c_state;

endmodule




/*
reg [(40*8):0] cmd_str;
reg [(40*8):0] mb_state_str;

always @ (cmd) begin
   case(cmd) 
      `HLCP_NOP   : cmd_str = "NOP";
      `HLCP_START : cmd_str = "START";
      `HLCP_WRITE : cmd_str = "WRITE";
      `HLCP_READ  : cmd_str = "READ";
      `HLCP_STOP  : cmd_str = "STOP";
      `HLCP_WAIT  : cmd_str = "WAIT";
   endcase
end

always @ (c_state) begin
   case(c_state) 
      IDLE      : mb_state_str = "IDLE";
      START1    : mb_state_str = "START1";
      START2    : mb_state_str = "START2";
      START3    : mb_state_str = "START3";
      START4    : mb_state_str = "START4";
      START5    : mb_state_str = "START5";
      STOP1     : mb_state_str = "STOP1";
      STOP2     : mb_state_str = "STOP2";
      STOP3     : mb_state_str = "STOP3";
      STOP4     : mb_state_str = "STOP4";
      RD1       : mb_state_str = "RD1";
      RD2       : mb_state_str = "RD2";
      RD3       : mb_state_str = "RD3";
      RD4       : mb_state_str = "RD4";
      WR1       : mb_state_str = "WR1";
      WR2       : mb_state_str = "WR2";
      WR3       : mb_state_str = "WR3";
      WR4       : mb_state_str = "WR4";
      WAITING   : mb_state_str = "WAITING";
   endcase
end
// synopsys translate_on
*/

