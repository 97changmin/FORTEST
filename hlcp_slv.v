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
// File name            : hlcp_slv.v                                  //
// Purpose              : HLCP slave controller                       //
//                                                                   //
//-------------------------------------------------------------------//
//*******************************************************************//
 
module hlcp_slv (  sys_clk,
                  sys_resetb,
                  scl_i,
                  scl_oen,
                  sda_i,
                  sda_oen,
                  clk_r,

                  hlcp_saddr_70,
                  int_stx,
                  int_srx,
                  pending,
                  s_state,
                  con_start,
                  con_stop,
                  s_rd,
                  s_wr,
                  addr_match,
                  g_call,
                  core_en,
                  ack_in,
                  ack_out,
                  txd,
                  rxd,
                  rst_sm_n,
                  add_mode,
                  int_stop,
                  ack_check,
                  s_stretching,
                  stxr_change,

                  CMD,
                  ID_i,

                  busy,

                  CTS,
                  CTS_error,

                  init_output,

                  CRC_M,
                  match_w
                  );

input             sys_clk;         // APB clock
input             sys_resetb;     // APB reset

input             scl_i;        // HLCP SCL input
output            scl_oen;      // HLCP SCL output enable
input             sda_i;        // HLCP SDA input
output            sda_oen;      // HLCP SDA output enable
input             clk_r;

input  [7:0]      hlcp_saddr_70; // Slave address of HLCP controller slave port bits [6:0]

output            int_stx;      // STX mode interrupt
output            int_srx;      // SRC mode interrupt

input             pending;      // Pending signal

output [3:0]      s_state;      // Slave State

input             con_start;    // START condition occurs
input             con_stop;     // STOP condition occurs

input             s_rd;         // Slave read mode
input             s_wr;         // Slave write mode

output            addr_match;   // Slave address match
output            g_call;       // broadcast signal detect
input             core_en;      // internal core enable
input             ack_in;       // ACK to transmit
output            ack_out;      // ACK received
input  [7:0]      txd;          // Data to transmit
output [7:0]      rxd;          // Data received
/////////////////0530/////////////////
output            CTS;
output            CTS_error;
//////////////////////////////////////
input             rst_sm_n;     // state machine reset
input             add_mode;     // 7 or 10 bits mode
output            int_stop;     // Abnormal STOP detect
input             ack_check;    // Check received ACK, if NAK, go to IDLE state
input             s_stretching; // HLCP slave port stretching
input             stxr_change;  // STXR value change occurs

//0812
input  wire   [3:0]      CMD;
input  wire   [7:0]      ID_i;

input  wire              busy;
output wire              init_output;
       
output                   match_w;
input  [3:0]             CRC_M;
////////////////////////////////////  
wire             sys_clk;
wire             sys_resetb;
wire             scl_i;
wire             scl_oen;
wire             sda_i;
reg              sda_oen;
wire   [7:0]     hlcp_saddr_70;
reg              int_stx;
reg              int_srx;
wire             pending;
wire             con_start;
wire             con_stop;
wire             s_rd;
wire             s_wr;
reg              addr_match;
reg              g_call;
wire             core_en;
wire             ack_in;
reg              ack_out;
wire   [7:0]     txd;
reg    [7:0]     rxd;
wire             rst_sm_n;
wire             add_mode;
wire             int_stop;
wire             ack_check;
wire             s_stretching;
wire             stxr_change;


//0623
reg    [4:0]     fetch_r; // 1B count
wire             CTS_error;

// Internal signals
reg              load;
reg              shift;

reg              shift_wr;  // POST_PENDING to write shift
reg              stop_check; // check STOP signal follows START signal immediately, it's not allowed in protocol
reg              addr_chk; // Address check whil slave is not actived

reg              counter_flag;
reg              flag_once;


// Closk synchronous citcuit
reg scl_d1;
reg scl_d2;
wire scl_r;
wire scl_f;

reg init;//0903
reg [3:0] counter_CSTX;

wire CMD_report;
assign CMD_report = (CMD==4'b1110) ? 1'b1 : 1'b0;
// State machine
reg [3:0]  s_state;
parameter   IDLE          = 4'b0000;
parameter   GET_ADD       = 4'b0001; //8bit
parameter   ADD_ACK       = 4'b0010;
parameter   READ          = 4'b0011;
parameter   WRITE         = 4'b0100;
parameter   DATA_ACK      = 4'b0101;
parameter   INT_RD        = 4'b0110;
parameter   INT_ADD       = 4'b0111;
parameter   STANDBY       = 4'b1000;
parameter   POST_ADD_ACK  = 4'b1001;
parameter   POST_ACK      = 4'b1010;
parameter   PRE_WRITE     = 4'b1011;

parameter   ROW           = 5'd0;
parameter   COLUMN        = 3'd0;


always@(posedge sys_clk or negedge sys_resetb) begin
  if (!sys_resetb) begin
     scl_d1 <= 0;
     scl_d2 <= 0;
     end
  else begin
     scl_d1 <= scl_i;
     scl_d2 <= scl_d1;
     end
end

assign scl_r = scl_d1 & !scl_d2 & core_en;   // SCL rising
assign scl_f = !scl_d1 & scl_d2 & core_en;   // SCL falling


// Prefetch circuit
// In s_rd mode, data is fetched according to scl_r, and shift register is shifted according to scl_f

reg data_in;
always@(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb)
   data_in <= 1'b0;
else if(scl_r)
   data_in <= sda_i;
else
   data_in <= data_in;
end



// 3 bits counter
reg [2:0] s_cnt;
wire      cnt_done0;
reg       cnt_done1;
reg       cnt_done;

always@(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb)
   s_cnt <= 3'h7;
else if (load)
   s_cnt <= 3'h7;
else if (shift)            // shift on -> SDA?ùù ?ùù?ùù?ùùù? ?ùù?ùù
   s_cnt <= s_cnt -1'h1;
else
   s_cnt <= s_cnt;
end

assign  cnt_done0 = (~|s_cnt);

always@(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb)
 cnt_done1 <= 1'b0;
else if(scl_f)
 cnt_done1 <= cnt_done0;
else if(scl_r)
 cnt_done1 <= 1'b0;
else
 cnt_done1 <= cnt_done1;
end


always@(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb)
 cnt_done <= 1'b0;
else if (cnt_done1)
 cnt_done <= 1'b1;
else
 cnt_done <= 1'b0;
end


// delayed stxr_change signal
reg stxr_change_d; // delayed stxt_change signal

always@(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb) begin
  stxr_change_d <= 1'b0;
end
else begin
  stxr_change_d <= stxr_change;

end
end


reg load_d; // delayed stxt_change signal
always@(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb)
  load_d <= 1'b0;
else
  load_d <= load;
end
//////////////////////////////////////////////////////////////////
/////////////////////for slave tx/////////////////////////////////
reg  match2_r;

always@(posedge sys_clk or negedge sys_resetb) begin
   if(!sys_resetb) begin
      match2_r <= 1'b0;
   end
   else if(CMD==4'b1110&&CTS==1'b1)
      match2_r <= 1'b1;
   else if(init)
      match2_r <= 1'b0;
   else begin
      match2_r <= match2_r;
   end
end

wire             match_w;
wire             match0;
wire             match1;
wire             match2;

assign match0 = (CMD==4'b1110) ? 1'b1 : 1'b0;
assign match1 = (ID_i=={ROW,COLUMN}||ID_i=={ROW,COLUMN+1'b1}||ID_i=={ROW+1'b1,COLUMN}||ID_i=={ROW+1'b1,COLUMN+1'b1})? 1'b1 : 1'b0;
assign match2 = match2_r;//Clear to Send OK

assign match_w = match0 & match1 & match2;
// Shift register
// In s_rd mode, scl_r fetch data and scl_f shift, in s_wr mode, data is shift out while scl_f occurs
reg [7:0] sr;
 
always@(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb)
  sr <= 8'b0;
else if((load | stxr_change))
  sr <= txd;
else if(((shift & s_rd) /*| (addr_chk & !s_rd)*/ ) ) // In READ mode, data is fetched into data_in when scl_r, and send to sr according to shift
  sr <= {sr[6:0], data_in};                    // Besides sr should shift in GET_ADD phase if slave is not actived to avoid master al
else if(((load_d | stxr_change_d) | ( shift & s_wr) | shift_wr))             // and slave address match
  sr <= {sr[6:0], sda_i};
else
  sr <= sr;
end

wire     CMD_reserved;
assign   CMD_reserved = (CMD==4'b0000||CMD==4'b0001||CMD==4'b0010||CMD==4'b0011||CMD==4'b1111) ? 1'b1 : 1'b0;

reg counter_flag_d; //FOR 1B INSTRUCTION

always@(posedge sys_clk or negedge sys_resetb) begin
   if(!sys_resetb) begin
      counter_flag_d <= 1'b0;
   end
   else begin
      counter_flag_d <= counter_flag;
   end
end


assign CMD_1B = ((CMD==4'b1100)||(CMD==4'b1101)) ? 1'b1 : 1'b0;
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
reg [4:0] count_init;
wire      done_init;
reg       done_init_d;
reg       done_init_dd;

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) begin
		count_init <= 5'd15;
	end
	else if(init==1'b1) begin
		count_init <= 5'd10;
	end
	else if(count_init==5'd0) begin
		count_init <= count_init;
	end
	else begin
		count_init <= count_init - 1'b1;
	end
end

assign done_init  = (count_init==4'd1)  ? 5'b1 : 4'b0;

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) begin
		done_init_d <= 1'b0;
	end
	else begin
		done_init_d <= done_init;
	end
end

always@(posedge sys_clk or negedge sys_resetb) begin
	if(!sys_resetb) begin
		done_init_dd <= 1'b0;
	end
	else begin
		done_init_dd <= done_init_d;
	end
end

reg    flag_1B; // for initializing one fetch
reg    init_delay_flag;

always@(posedge sys_clk or negedge sys_resetb) begin
   if(!sys_resetb)
      flag_1B <= 1'b0;
   else if(s_state==STANDBY)
      flag_1B <= 1'b0;
   else if(s_state==ADD_ACK&&!flag_1B&&s_rd)
      flag_1B <= 1'b1;
end


always@(posedge sys_clk or negedge sys_resetb) begin
   if(!sys_resetb) begin
      init    <= 1'b0;
      fetch_r <= 5'b0;
      init_delay_flag <= 1'b0;
   end
   else if(s_state==STANDBY) begin
      init_delay_flag <= 1'b0;
      fetch_r <= 5'b0;
   end
   else if(s_state==READ&&s_rd)begin
         if(cnt_done&&!(CMD_report)) begin
            fetch_r <= fetch_r + 1'b1;
         end
   end 
   else if(s_state==ADD_ACK&&!flag_1B&&s_rd)begin
            fetch_r <= fetch_r + 1'b1;
   end     
   else if(s_state==4'h6&&CMD_report&&s_rd) begin
            fetch_r <= fetch_r + 1'b1;
   end   
   else if(s_state==DATA_ACK) begin
      case(CMD)
         4'b0100 : begin
            if(fetch_r==5'd8) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end
         end
         4'b0101 : begin
            if((fetch_r==5'd8)&&(ID_i[7:3]==5'd31)) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else if(fetch_r==5'd14) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end         
         end
         4'b0110 : begin
            if((fetch_r==5'd8)&&(ID_i[2:0]==3'd7)) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else if(fetch_r==5'd14) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end 
         end
         4'b0111 : begin
            if(fetch_r==5'd8&&(ID_i[2:0]==3'd7&&ID_i[7:3]==5'd31)) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else if(fetch_r==5'd14&&(ID_i[7:3]==5'd31)) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else if(fetch_r==4'd14&&(ID_i[2:0]==3'd7))  begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else if(fetch_r==5'd26) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end             
         end
         4'b1000 : begin
           if(fetch_r==5'd2) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end
         end
         4'b1001: begin
            if(fetch_r==5'd2) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end
         end 
         4'b1010 : begin
           if(fetch_r==5'd3) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end
         end
         4'b1011 : begin
           if(fetch_r==5'd3) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end
         end
         4'b1100 : begin
            if(fetch_r==5'd1&&!counter_flag_d) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end            
         end 
         4'b1101 : begin
            if(fetch_r==5'd1&&!counter_flag_d) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end
         end    
         4'b1110 : begin
            if(fetch_r==5'd2&&(!init_delay_flag))begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
               if(CMD_report)
                  init_delay_flag <= 1'b1;
            end            
            else if(fetch_r==5'd2&&init_delay_flag)begin
               fetch_r <= 5'b0;
               if(CMD_report)
                  init_delay_flag <= 1'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end
         end

         4'b0001 : begin
            if(fetch_r==5'd1&&!counter_flag_d) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end
         end
         4'b0010 : begin
            if(fetch_r==5'd1&&!counter_flag_d) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end
         end
         4'b0011 : begin
            if(fetch_r==5'd1&&!counter_flag_d) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end
         end
         4'b1111 : begin
            if(fetch_r==5'd1&&!counter_flag_d) begin
               init    <= 1'b1;
               fetch_r <= 5'b0;
            end
            else begin
               init <= 1'b0;
               fetch_r <= fetch_r;
            end
         end                                    

         default : begin
            init <= 1'b0;
            fetch_r <= fetch_r;
         end                                             
      endcase
   end
   else begin
      init    <= 1'b0;
      fetch_r <= fetch_r;
   end
end

always@(*) begin
   if((CMD==4'b1100&&sr[3:0]==4'h9)||(CMD==4'b1101&&sr[3:0]==4'hb))
      counter_flag = 1'b0;
   else if(((CMD==4'b0000)&&(sr[3:0]==4'h1))||((CMD==4'b0001)&&(sr[3:0]==4'h3))||((CMD==4'b0010)&&(sr[3:0]==4'h5))||((CMD==4'b0011)&&(sr[3:0]==4'h7)))   
      counter_flag = 1'b0;
   else if(CMD_1B||CMD_reserved)
      counter_flag = 1'b1;
   else
      counter_flag = 1'b0;
end

// State machine
always@(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb) begin
   s_state <= IDLE;
   load <= 1'b0;
   addr_match <= 1'b0;
   g_call <= 1'b0;
   sda_oen <= 1'b1;
   int_srx <= 1'b0;
   int_stx <= 1'b0;
   ack_out <=1'b0;
   shift <= 1'b0;
   shift_wr <= 1'b0;
   stop_check <= 1'b0;
   addr_chk <= 1'b0;
   flag_once      <= 1'b0;
   counter_CSTX   <= 4'b0;
   end


else if(!rst_sm_n) begin  // synchronous reset
   s_state <= IDLE;
   load <= 1'b0;
   addr_match <= 1'b0;
   g_call <= 1'b0;
   sda_oen <= 1'b1;
   int_srx <= 1'b0;
   int_stx <= 1'b0;
   ack_out <=1'b0;
   shift <= 1'b0;
   shift_wr <= 1'b0;
   stop_check <= 1'b0;
   addr_chk <= 1'b0;
   counter_CSTX   <= 4'b0;
   end


else if(con_stop) begin //should be removed
   s_state <= IDLE;
   load <= 1'b0;
   addr_match <= 1'b0;
   g_call <= 1'b0;
   sda_oen <= 1'b1;
   int_srx <= 1'b0;
   int_stx <= 1'b0;
   ack_out <=1'b0;
   shift <= 1'b0;
   shift_wr <= 1'b0;
   stop_check <= 1'b0;
   addr_chk <= 1'b0;
   counter_CSTX   <= 4'b0;   
   end

else begin
    load <= 1'b0;
    addr_match <= 1'b0;
    int_srx <= 1'b0;
    int_stx <= 1'b0;
    shift <= 1'b0;
    shift_wr <= 1'b0;
    addr_chk <= 1'b0;

    
    
  case(s_state)
  IDLE:
    if( (((CMD==4'b1110))&&counter_CSTX<2'd2) | (con_start & (s_rd | s_wr))) begin     // Don't check s_rd to make sure when  master with al, slave can be actived. // match_w?ùù?ùù Slave -> Master ?ùù?ùù?ùù ?ùù?ùù
       s_state <= STANDBY;
    end
    else
       s_state <= IDLE;

  STANDBY:
     if(scl_f) begin
       s_state <= GET_ADD;
       load <= 1'b1;
       stop_check <= 1'b1;
     end
     else
       s_state <= STANDBY;

  GET_ADD:                 // GET Address
     if(cnt_done)begin     // When cnt_done, scl is low
        sda_oen <= 1'b1;
        s_state <=  INT_ADD;
     end
     else if(scl_f)begin  // when scl_f , shift = 1 , addr_chk  = 1
       s_state <=  GET_ADD ;
       shift   <= 1'b1;
       addr_chk <= 1'b1;
       stop_check <= 1'b0;
     end
     else
       s_state <= GET_ADD;


  INT_ADD: begin
       if(!pending) begin
          s_state <= ADD_ACK; // Issue ACK/NAK to master
       end
       else
          sda_oen <= ~ack_in;   // If scl is still low, ack to master
      end


  ADD_ACK:
      if(scl_f) begin
          shift <= 1'b1;
          load <= 1'b1;
        if(s_wr) begin
            s_state <= POST_ADD_ACK;
        end
        else if(s_rd) begin
            s_state <= DATA_ACK;
            int_srx <= 1'b1;
        end
        else
            s_state <= READ;
      end
      else begin
        sda_oen <= ~ack_in;
      end

 READ: begin
     if(con_start) begin
       s_state <= STANDBY;
        load <= 1'b1;
        end
     else if(con_stop)
        s_state <= IDLE;
     else begin
       if(cnt_done) begin
         s_state <= INT_RD;
         int_srx <= 1'b1;
       end
       else if(scl_f) begin
         shift <= 1'b1;
       end
       else begin
        sda_oen <= 1'b1;
       end
     end
 end
 POST_ADD_ACK:
       begin
        int_stx <= 1'b1;
        s_state <= PRE_WRITE;
        shift_wr <= 1'b1;
       end

 PRE_WRITE:
       begin
       sda_oen <= sr[7];//sr
       s_state <= WRITE;
       end

  INT_RD:
      if(!pending) begin
          s_state <= DATA_ACK; // Issue ACK/NAK to master
      end
      else begin
          sda_oen <= ~ack_in;   // If scl is still low, ack to master
      end

  WRITE:
     if(con_stop)
       s_state <= IDLE;
     else if(con_start) begin
       s_state <= STANDBY;
     end
     else if((CMD_report)&&(counter_CSTX<2'd2))begin
      if(cnt_done) begin
         s_state <= DATA_ACK;
         counter_CSTX <= counter_CSTX + 1'b1;
      end        
      else 
         if(scl_f) begin
            sda_oen   <= sr[7];//sr
            shift <= 1'b1;
         end
         else if(stxr_change_d|load_d)
            sda_oen   <= sr[7];//sr
         else
            sda_oen   <= sda_oen;
     end
     else begin
      s_state <= DATA_ACK;
     end    

   DATA_ACK: begin
      if(s_rd) begin                            
        if(scl_f) begin
          s_state <= READ;
          shift <= 1'b1;
          load <= 1'b1;
         end
        else begin
          sda_oen <= ~ack_in;
          s_state <= DATA_ACK;
         end
      end
      else  begin
        if(scl_f) begin
          s_state <= POST_ACK;
          load <= 1'b1;
        end
        else  begin
          ack_out <= sda_i;
          sda_oen <= 1'b1;
        end
      end
   end
  POST_ACK: begin
     if(ack_check) begin
        s_state <= WRITE;
        int_stx <= 1'b1;
     end
     else begin
        s_state <= WRITE;
        shift_wr <= 1'b1;
        sda_oen <= sda_oen;
     end
  end
   default:
         s_state <= IDLE;
endcase
end
end

// Assign scl_oen
assign scl_oen = !s_stretching;

// Assign Abnormal interrupt
assign int_stop = con_stop & ((stop_check && s_cnt == 3'b111) || s_cnt != 3'b111);

/////////////////CRC wire/////////////////
wire   [3:0] CRC_M;               
wire   [3:0] crc_out;
wire         CTS;
wire         CTS_w;

assign CTS = !(CMD_reserved) ? CTS_w : 1'b0;

/////////////////////////////////////////////CRC/////////////////////////////////////////////
serial_crc_ccitt	u_hlcp_crc_s (
			.sys_clk(sys_clk),
			.sys_resetb(sys_resetb),
			.enable(shift),      // 
			.data_in(sda_i),     // DATA_IN 
         .CMD(CMD),        
         .CRC_M(CRC_M),       // CRC
         .init(done_init_d),  // INIT
         .CTS(CTS_w),         // Clear To Send
         .CTS_error(CTS_error)// CRC ERROR
);

assign                   init_output = done_init_d;
//////////////////////////////////////////////////////////////////////////////////////////////

always@(posedge sys_clk or negedge sys_resetb) begin
   if(!sys_resetb)
     rxd <= 8'b0;
   else if((s_state==4'h3)&&(s_cnt==3'h0))
     rxd <= sr;     
   else if(((s_state==4'h2)&&(s_cnt==3'h7)))
     rxd <= sr;
   else
     rxd <= rxd;
end

endmodule