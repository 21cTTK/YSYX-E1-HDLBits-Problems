module FA(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module top_module( 
    input  [99:0] a, b,
    input         cin,
    output [99:0] cout,
    output [99:0] sum
);

    wire [100:0] carry;

    assign carry[0]   = cin;
    assign carry[100:1] = cout;

    FA fa [99:0] (
        .a   (a),
        .b   (b),
        .cin (carry[99:0]),
        .sum (sum),
        .cout(cout)
    );

endmodule