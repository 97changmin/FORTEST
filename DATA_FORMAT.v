module command_processor(
    sys_clk,
    sys_resetb,
    start_count, // ëª…ë ¹?–´ ?…? ¥
    error_flag    // ?˜¤ë¥? ?”Œ?˜ê·?
);

input           sys_clk;
input           sys_resetb;
input           start_count;
output          error_flag;

parameter       THRESHOLD = 20;//20
parameter       SIZE      = THRESHOLD << 2;
parameter       ERROR_THRESHOLD = (2**THRESHOLD-1); // ?˜¤ë¥? ?„ê³„ê°’ ?˜ˆ?‹œ

reg [SIZE-1:0] error_counter;
reg            error_flag;
reg            en;

always@(posedge sys_clk or negedge sys_resetb) begin
    if(!sys_resetb)
        en <= 1'b0;
    else if(start_count)
        en <= 1'b1;
    else
        en <= en;
end

always@(posedge sys_clk or negedge sys_resetb) begin
    if(!sys_resetb)
        error_counter <= 16'b0;
    else if(en)
        if(start_count)         
            error_counter <= 16'b0;
        else if(error_counter==ERROR_THRESHOLD-1'b1)
            error_counter <= error_counter;
        else
            error_counter <= error_counter + 1'b1;
end

always@*
    if (error_counter >= (ERROR_THRESHOLD>>1)-1'b1) begin
        error_flag = 1'b1;
    end else begin
        error_flag = 1'b0;
    end


/* ëª…ë ¹?–´ ì²˜ë¦¬ ë¡œì§
always @(posedge sys_clk or negedge sys_resetb) begin
    if (!sys_resetb) begin
        error_flag <= 1'b0;
    end else if(en)begin
        if (error_counter >= (ERROR_THRESHOLD>>1)-1'b1) begin
            error_flag <= 1'b1;
        end else begin
            error_flag <= 1'b0;
        end
    end
end

*/


endmodule


