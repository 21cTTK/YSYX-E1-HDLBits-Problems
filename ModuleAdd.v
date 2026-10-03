//module add16 ( input[15:0] a, input[15:0] b, input cin, output[15:0] sum, output cout );
module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire carry_out;
    
    add16
        FA1(
            .a      (a[15:0]),
            .b      (b[15:0]),
            .cin    (1'b0),

            .cout   (carry_out),
            .sum    (sum[15:0])
        ),
        FA2(
            .a      (a[31:16]),
            .b      (b[31:16]),
            .cin    (carry_out),

            .sum    (sum[31:16])
        );

endmodule