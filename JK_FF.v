module DFF (
	input clk,
	input d,
	output reg q
    );
	
    always @(posedge clk)
		q <= d;
endmodule

module top_module (
    input clk,
    input j,
    input k,
    output Q
	); 
	
    wire d;
    assign d = (j & ~Q) | (~k & Q);
    DFF dff(
        .clk    (clk),
        .d      (d),
        .q      (Q)    
    );

endmodule
