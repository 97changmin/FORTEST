(* DONT_TOUCH = "yes" *)
module DATA_Process_IDU(
    sys_clk,
    sys_resetb,

    CMD,
    Operand_ID,

    DATA_loop_0,
    DATA_loop_1,
    DATA_loop_2,
    DATA_loop_3,

    DATA0_i,
    DATA1_i,
    DATA2_i,
    DATA3_i,
    
    init,

    DATA0_o,
    DATA1_o,
    DATA2_o,
    DATA3_o
);

parameter ROW = 5'd0;
parameter COLUMN = 3'd0;
//--------------------input------------------------
input sys_clk;
input sys_resetb;

input [3:0] CMD;
input [7:0] Operand_ID;

input [47:0] DATA_loop_0;
input [47:0] DATA_loop_1;
input [47:0] DATA_loop_2;
input [47:0] DATA_loop_3;

input [47:0] DATA0_i;
input [47:0] DATA1_i;
input [47:0] DATA2_i;
input [47:0] DATA3_i;

input       init;
//--------------------output------------------------
output [47:0] DATA0_o;
output [47:0] DATA1_o;
output [47:0] DATA2_o;
output [47:0] DATA3_o;
//--------------------wire&reg------------------------
wire [2:0]  signal;
reg  [4:0]  select;
wire  [3:0]  PWMC_Boundary;

wire   Immediate_6x1;
wire   Immediate_6x2;
wire   Immediate_12x1;
wire   Immediate_12x2;

reg [47:0] DATA0_o;
reg [47:0] DATA1_o;
reg [47:0] DATA2_o;
reg [47:0] DATA3_o;
//-------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------
wire EDGE_between_PWMC_COLUMN0;
wire EDGE_between_PWMC_COLUMN1;
wire EDGE_between_PWMC_ROW0;
wire EDGE_between_PWMC_ROW1;

wire EDGE_Immediate_12x2_right;
wire EDGE_Immediate_12x2_bottom;
wire EDGE_Immediate_12x2_edge;
wire [2:0] Immediate_12x2_merge;

assign EDGE_between_PWMC_COLUMN0 =   ((!(COLUMN==3'b0))&&(ROW==Operand_ID[7:3])&&((COLUMN-1)==Operand_ID[2:0])&&(Operand_ID[3]==1'b0))         ? 1'b1 : 1'b0;
assign EDGE_between_PWMC_COLUMN1 =   ((!(COLUMN==3'b0))&&(ROW+1'b1==Operand_ID[7:3])&&((COLUMN-1)==Operand_ID[2:0])&&(Operand_ID[3]==1'b1))    ? 1'b1 : 1'b0;

assign EDGE_between_PWMC_ROW0    =   ((!(ROW==5'b0))&&(COLUMN==Operand_ID[2:0])&&((ROW-1)==Operand_ID[7:3])&&(Operand_ID[0]==1'b0))            ? 1'b1 : 1'b0;
assign EDGE_between_PWMC_ROW1    =   ((!(ROW==5'b0))&&(COLUMN+1'b1==Operand_ID[2:0])&&((ROW-1)==Operand_ID[7:3])&&(Operand_ID[0]==1'b1))       ? 1'b1 : 1'b0;

assign EDGE_Immediate_12x2_right =  ((!(COLUMN==3'b0))&&(ROW+1'b1==Operand_ID[7:3])&&((COLUMN-1)==Operand_ID[2:0]))                            ? 1'b1 : 1'b0;
assign EDGE_Immediate_12x2_bottom = ((!(ROW==5'b0))&&(ROW-1'b1==Operand_ID[7:3])&&((COLUMN+1)==Operand_ID[2:0]))                               ? 1'b1 : 1'b0;
assign EDGE_Immediate_12x2_edge = ((!(ROW==5'b0)&&!(COLUMN==3'b0))&&(ROW-1'b1==Operand_ID[7:3])&&((COLUMN-1)==Operand_ID[2:0]))                ? 1'b1 : 1'b0;
//-------------------------------------------------------------------------------------------------------------------------------------------
assign   Immediate_6x1  = (CMD==4'b0100) ? 1'b1 : 1'b0;
assign   Immediate_6x2  = (CMD==4'b0101) ? 1'b1 : 1'b0;
assign   Immediate_12x1 = (CMD==4'b0110) ? 1'b1 : 1'b0;
assign   Immediate_12x2 = (CMD==4'b0111) ? 1'b1 : 1'b0;
//-------------------------------------------------------------------------------------------------------------------------------------------
assign   signal =    {Operand_ID=={ROW,COLUMN}} ? 3'd0 :
                     {Operand_ID=={ROW,COLUMN+1'b1}} ? 3'd1 :
                     {Operand_ID=={ROW+1'b1,COLUMN}} ? 3'd2 :
                     {Operand_ID=={ROW+1'b1,COLUMN+1'b1}} ? 3'd3: 3'd4;
//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------
assign PWMC_Boundary = (CMD!=4'b0111) ? {EDGE_between_PWMC_ROW1,EDGE_between_PWMC_ROW0,EDGE_between_PWMC_COLUMN1,EDGE_between_PWMC_COLUMN0} : 1'b0;
assign Immediate_12x2_merge = (CMD==4'b0111) ? {EDGE_Immediate_12x2_right,EDGE_Immediate_12x2_bottom,EDGE_Immediate_12x2_edge} : 1'b0;

always@* begin
    select = 1'b0;
    case(CMD)
        4'b0100: begin
             case(signal)
                3'd0 : select = 5'd13;
                3'd1 : select = 5'd14;
                3'd2 : select = 5'd15;
                3'd3 : select = 5'd16;      
            endcase
        end
        4'b0101: begin
             case(signal)
                3'd0 : select = 5'd1;
                3'd1 : select = 5'd2;
                3'd2 : select = 5'd3;
                3'd3 : select = 5'd4;      
            endcase           
        end
        4'b0110: begin
            case(signal)
                3'd0 : select = 5'd5;
                3'd1 : select = 5'd6;
                3'd2 : select = 5'd7;
                3'd3 : select = 5'd8;     
            endcase
        end
        4'b0111: begin
            case(signal)
                3'd0 : select = 5'd9;
                3'd1 : select = 5'd10;
                3'd2 : select = 5'd11;
                3'd3 : select = 5'd12;                
            endcase
        end
    endcase
end

always@* begin
DATA0_o = DATA_loop_0;
DATA1_o = DATA_loop_1;
DATA2_o = DATA_loop_2;
DATA3_o = DATA_loop_3;
if(init) begin
case(select)
  5'd0 : begin
    case(PWMC_Boundary)
      4'b0000 : begin
          case(Immediate_12x2_merge)
          3'b001 : begin
            DATA0_o = DATA3_i;
          end
          3'b010 : begin
            DATA0_o = DATA2_i;
            DATA1_o = DATA3_i;
          end
          3'b100 : begin
            DATA0_o = DATA1_i;
            DATA2_o = DATA3_i;
          end         
          endcase
      end
      4'b0001 : begin
        DATA0_o = DATA1_i;
      end
      4'b0010 : begin
        DATA2_o = DATA1_i;
      end
      4'b0100 : begin
        DATA0_o = DATA1_i;
      end
      4'b1000 : begin
        DATA1_o = DATA1_i;         
      end
    endcase
  end
//-------------------------------------------------------------------------------------
//-----------------------------------6x2-----------------------------------------------
//-------------------------------------------------------------------------------------
  5'd1 :  begin
    DATA0_o = DATA0_i;
    DATA2_o = DATA1_i;
  end
  5'd2 : begin
    DATA1_o = DATA0_i;
    DATA3_o = DATA1_i;        
  end
  5'd3 : begin
    DATA2_o = DATA0_i;
    // DONE  
  end
  5'd4 : begin
    DATA3_o = DATA0_i;
    // DONE
  end
//-------------------------------------------------------------------------------------
//--------------------------------------12x1-------------------------------------------
//-------------------------------------------------------------------------------------
  5'd5 : begin
    DATA0_o = DATA0_i;
    DATA1_o = DATA1_i;
  end
  5'd6 : begin
    DATA1_o = DATA0_i;
    // DONE
  end
  5'd7 : begin
    DATA2_o = DATA0_i;
    DATA3_o = DATA1_i;
  end
  5'd8 : begin
    DATA3_o = DATA0_i;  
    // DONE
  end
//-------------------------------------------------------------------------------------
//--------------------------------------12x2-------------------------------------------
//-------------------------------------------------------------------------------------
  5'd9 : begin
    DATA0_o = DATA0_i;
    DATA1_o = DATA1_i;
    DATA2_o = DATA2_i;
    DATA3_o = DATA3_i;
  end
  5'd10 : begin
    DATA1_o = DATA0_i;
    DATA3_o = DATA3_i;
    if(Operand_ID[2:0]==3'd7) begin
      DATA1_o = DATA0_i;
      DATA3_o = DATA1_i;
    end  
    // DONE
    // DONE    
  end
  5'd11 : begin
    DATA2_o = DATA0_i;
    DATA3_o = DATA0_i;
    // DONE
    // DONE    
  end
  5'd12 : begin
    DATA3_o = DATA0_i;  
    // DONE
    // DONE
    // DONE        
  end
  5'd13 : begin
    DATA0_o = DATA0_i;
  end
  5'd14 : begin
    DATA1_o = DATA0_i;
  end
  5'd15 : begin
    DATA2_o = DATA0_i;
  end
  5'd16 : begin
    DATA3_o = DATA0_i;
  end      
endcase
end
end


endmodule