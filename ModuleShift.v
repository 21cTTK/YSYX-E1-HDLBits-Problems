module top_module ( input clk, input d, output q );
    wire [1:0]
    	dff;
    
    my_dff
		dff_1(
			.clk	(clk),
			.d		(d),

			.q		(dff[0])
		),
		
		dff_2(
			.clk	(clk),
			.d		(dff[0]),
			.q		(dff[1])
		),

		dff_3(
			.clk	(clk),
			.d		(dff[1]),
			.q		(q)
		);

endmodule