module top_module ();
	reg clk=0;
	always #5 clk = ~clk;  // Create clock with period=10
	initial `probe_start;   // Start the timing diagram

	`probe(clk);        // Probe signal "clk"

	// A testbench
	reg in=0;
	initial begin
		#10 in <= 1;
		#10 in <= 0;
		#20 in <= 1;
		#20 in <= 0;
		$display ("Hello world! The current time is (%0d ps)", $time);
		#50 $finish;            // Quit the simulation
	end

	invert inst1 ( .in(in) );   // Sub-modules work too.

endmodule

module invert(input in, output out);
    assign out = ~in;

    `probe(in);	// Sub-modules can also have `probe()
    `probe(out);
endmodule

