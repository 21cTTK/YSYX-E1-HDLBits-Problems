module top_module( 
    input [2:0] in,
    output [1:0] out
    );
    
    reg [1:0]
        cnt;
    
    always @(*)
    begin
        cnt = 2'b00;

        for (integer i = 0; i < 3; i++)
            cnt += in[i];
    end

    assign out = cnt;

endmodule
