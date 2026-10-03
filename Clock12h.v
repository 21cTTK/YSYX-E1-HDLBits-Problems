module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
    ); 

    always @(posedge clk)
    begin
        if(reset)
        begin
        	pm <= 0;
            hh <= 12;
            mm <= 0;
            ss <= 0;
        end

        

        
        
    end

endmodule