//*******************************************************************//
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
// File name            : hlcp_divider.v                              //
// Purpose              : HLCP clock divider                          //
//                                                                   //
//-------------------------------------------------------------------//
//*******************************************************************//

module hlcp_divider (sys_clk,
                    sys_resetb,
                    ck_ratio,
                   // clkout,
                    clk_r,
                   // clk_f,
                    core_en
                    );

// clkout = ( ck_raio[5:3]+1)x2^(ck_ratio[2:0]+1)

input       sys_clk;    // clock input for divider
input       sys_resetb; // APB reset
input [5:0] ck_ratio;   // sys_clk to clkout ratio setting
output      clk_r;      // divided clk rising
input       core_en;    // HLCP core enable

wire        sys_clk;
wire        sys_resetb;
wire  [5:0] ck_ratio;
wire        clk_r;
wire        core_en;


// ck_ratio[2:0]
reg [6:0]   count1;
reg         div1;

always@(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb)
  count1 <= 0;
else
  count1 <= count1+1;
end

always@(count1 or ck_ratio) begin
  case(ck_ratio[2:0])
  3'b000: div1 = 1;                             //1
  3'b001: div1 = (count1[0]   == 1'b1);         //2
  3'b010: div1 = (count1[1:0] == 2'b11);        //4
  3'b011: div1 = (count1[2:0] == 3'b111);       //8
  3'b100: div1 = (count1[3:0] == 4'b1111);      //16
  3'b101: div1 = (count1[4:0] == 5'b11111);     //32
  3'b110: div1 = (count1[5:0] == 6'b111111);    //64
  3'b111: div1 = (count1[6:0] == 7'b1111111);   //128
  default: div1 = 1;
  endcase
end


// ck_ratio[5:3]
reg [3:0] count2;
reg       div2;

always@(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb)
  count2 <= 0;
else if(div2)
  count2 <= 0;
else if(div1)
  count2 <= count2+1;
else
  count2 <= count2;
end

always@(div1 or count2 or ck_ratio) begin
if(ck_ratio[2:0]!=0) begin
  case(ck_ratio[5:3])
  3'b000: div2 = div1;
  3'b001: div2 = (count2 == 4'h2);
  3'b010: div2 = (count2 == 4'h3);
  3'b011: div2 = (count2 == 4'h4);
  3'b100: div2 = (count2 == 4'h5);
  3'b101: div2 = (count2 == 4'h6);
  3'b110: div2 = (count2 == 4'h7);
  3'b111: div2 = (count2 == 4'h8);
  default: div2 = div1;
  endcase
end

else begin
   case(ck_ratio[5:3])
   3'b000: div2 = div1;
   3'b001: div2 = (count2 == 4'h1);
   3'b010: div2 = (count2 == 4'h2);
   3'b011: div2 = (count2 == 4'h3);
   3'b100: div2 = (count2 == 4'h4);
   3'b101: div2 = (count2 == 4'h5);
   3'b110: div2 = (count2 == 4'h6);
   3'b111: div2 = (count2 == 4'h7);
   default: div2 = div1;
   endcase
end
end

// clkout
reg div_clk;

always@(posedge sys_clk or negedge sys_resetb) begin
if(!sys_resetb)
  div_clk <= 0;
else if(div2)
  div_clk <= ~div_clk;
else
  div_clk <= div_clk;
end

// clk_r
assign clk_r = core_en & div2 & !div_clk;

endmodule
