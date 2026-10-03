module top_module (
    input clk,
    input areset,
    input x,
    output z
    ); 

    parameter
        A = 1'b0,
        B = 1'b1;
    reg curr_state, next_state;

    always @(*)
    begin
        case (curr_state)
            A: next_state = x ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    always @(posedge clk, posedge areset)
    begin
        if(areset)
            curr_state <= A;
        else
            curr_state <= next_state;
    end

    assign z = ((curr_state == A) && (x == 1)) ||
               ((curr_state == B) && (x == 0));
endmodule
