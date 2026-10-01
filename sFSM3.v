module top_module(
    input clk,
    input in,
    input areset,
    output out
); 

    parameter A = 0, B = 1, C = 2, D = 3;
    reg [1:0] state, next_state;
    
    always @(*)
    begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default:;
        endcase
    end

    always @(posedge clk, posedge areset)
    begin
        if(areset)
            state <= A;
        else
            state <= next_state;    
    end

    assign out = (state == D) ? 1 : 0;

endmodule