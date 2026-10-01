module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 

    parameter
        P0 = 0,
        P1 = 1,
        P2 = 2,
        P3 = 3,
        P4 = 4,
        P5 = 5;

    reg [2:0]
        state, next_state;

    // Transition logic
    always @(*)
    begin
        next_state = state; // default

        case (state)
            P0: next_state = (s == 3'b001) ? P1 : P0;
            // P1 P2 are actaully the same except for output
            P1,P2:
                if (s == 3'b000)
                    next_state = P0;
                else if(s == 3'b011)
                    next_state = P3;
                else;
            /// P3 P4 are actaully the same except for output
            P3, P4:
                if (s == 3'b001)
                    next_state = P2;
                else if(s == 3'b111)
                    next_state = P5;
                else;
            P5: next_state = (s == 3'b011) ? P4 : P5;
            default:; 
        endcase
    end

    //Update logic
    always @(posedge clk)
        state <= (reset) ? P0 : next_state;

    // Output logic
    case (state)
        P0: {fr3, fr2, fr1, dfr} = 4'b1111;
        P1: {fr3, fr2, fr1, dfr} = 4'b0110;
        P2: {fr3, fr2, fr1, dfr} = 4'b0111;
        P3: {fr3, fr2, fr1, dfr} = 4'b0010;
        P4: {fr3, fr2, fr1, dfr} = 4'b0011;
        P5: {fr3, fr2, fr1, dfr} = 4'b0000;
        default:;
    endcase

endmodule
