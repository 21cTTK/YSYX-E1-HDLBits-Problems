module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0]
        edged,
        last_in;

    always @(posedge clk, posedge reset)
    begin
        if(reset)
            edged <= 0;
        else
            edged <= (~in & last_in) ? 1 : edged;
        
        last_in <= in;
    end

    assign out = edged;
endmodule