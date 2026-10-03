module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z
    );

    parameter [1:0] 
        A = 2'b00, // pending '1'01
        B = 2'b01, // pending 1'0'1
        C = 2'b10; // pending 10'1'
    reg [1:0]
        curr_state,
        next_state;

    always @(*)
    begin
        next_state = curr_state;

        case (curr_state)
            A: next_state = (x) ? B : curr_state;
            B: next_state = (x) ? B : C;
            C: next_state = (x) ? B : A;
            default:;
        endcase
    end

    always @(posedge clk, negedge aresetn)
    begin
        if(!aresetn)
            curr_state <= A;
        else
            curr_state <= next_state;
    end

    assign z = (curr_state == C) && (x == 1);
endmodule
