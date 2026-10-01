module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out
);

    parameter A=0, B=1; 
    reg state, next_state;

    always @(*)
    begin    // This is a combinational always block
        case (state)
            0: next_state = in ? A : B;
            1: next_state = in ? B : A;
            default: ;
        endcase
    end

    always @(posedge clk, posedge areset)
    begin    // This is a sequential always block
        // State flip-flops with asynchronous reset
        if(areset)
            state <= B;
        else
            state <= next_state;
    end

    assign out = (state == B);

endmodule
