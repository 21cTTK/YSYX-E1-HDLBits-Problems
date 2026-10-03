module top_module( 
    input [99:0] a, b,
    input cin,
    output cout,
    output [99:0] sum );
	
    wire [100:0]
    	carry;
    
    assign carry[0] = cin;
    
    generate
        genvar i;
        for(i = 0; i < 100; i++)
        begin:gen_fa100
            assign carry[i + 1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        	assign sum[i]		= a[i] ^ b[i] ^ carry[i];
        end
    endgenerate
    
    assign cout = carry[100];
    
endmodule
