module top_module (
    input clk,
    input d,
    output q
    );

    reg qpos, qneg;

    always @(posedge clk)
    begin
        qpos <= d;
    end

    always @(negedge clk)
    begin
        qneg <= d;
    end

    assign q = clk ? qpos : qneg;
endmodule
