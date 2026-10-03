module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
);

    wire [3:0] qd;

    MUX_DFF mux_dffs [3:0] (
        .clk(KEY[0]),
        .w  ({KEY[3], qd[3:1]}),
        .R  (SW),
        .E  ({4{KEY[1]}}),
        .L  ({4{KEY[2]}}),
        .Q  (qd)
    );

    assign LEDR = qd;

endmodule


module MUX_DFF (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    always @(posedge clk) begin
        Q <= L ? R :
             E ? w : Q;
    end
endmodule