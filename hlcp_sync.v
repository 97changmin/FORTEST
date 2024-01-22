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
// File name            : hlcp_sync.v                                 //
// Purpose              : HLCP input sync circuit                     //
//                                                                   //
//-------------------------------------------------------------------//
//*******************************************************************//
module hlcp_sync(
                sys_clk,
                sys_resetb,
                scl_in,
                sda_in,
                scl_in_rs,
                sda_in_rs
               );

//interface signals
input                        sys_clk;            // APB clock
input                        sys_resetb;        // APB reset
input                        scl_in;          // HLCP scl input
input                        sda_in;          // HLCP sda input
output                       scl_in_rs;       // HLCP scl input after sync
output                       sda_in_rs;       // HLCP sda input after sync


// signal declarations
reg         scl_in_s, sda_in_s;             // synchronized SCL and SDA inputs
reg         scl_in_rs, sda_in_rs;           // synchronized SCL and SDA inputs


// synchronize SCL and SDA inputs
// reduce metastability risk
always @(posedge sys_clk or negedge sys_resetb)
  if (!sys_resetb)
    begin
        scl_in_s <=  1'b1;
        sda_in_s <=  1'b1;

        scl_in_rs <=  1'b1;
        sda_in_rs <=  1'b1;
    end

  else
    begin
        scl_in_s <=  scl_in;
        sda_in_s <=  sda_in;

        scl_in_rs <=  scl_in_s;
        sda_in_rs <=  sda_in_s;
    end



endmodule
