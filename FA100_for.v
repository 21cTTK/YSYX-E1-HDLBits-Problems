module FA(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = a & b | a & cin | b & cin;
endmodule

module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum
    );

    wire [100:0]
        carry;

    assign carry[0] = cin;

    generate
        genvar i;
        for (i = 0; i < 100; i++)
        begin: gen_fa
            FA fa(
                .a      (a[i]),
                .b      (b[i]),
                .cin    (carry[i]),
                .cout   (carry[i+1]),
                .sum    (sum[i])
            );
        end
    endgenerate

    assign cout[99:0] = carry[100:1];
endmodule
