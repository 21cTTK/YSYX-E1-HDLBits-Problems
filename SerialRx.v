module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
    ); 

    parameter [1:0]
        PENDING_START = 2'b00,
        PENDING_STOP  = 2'b01,
        PENDING_BITS  = 2'b10;
    reg state, next_state;
    reg [31:0]
        cnt;
    
    // State transition logic (combinational)
    always @(*)
    begin
        next_state = state;

        case (state)
            PENDING_START:
                next_state = (in) ? state : PENDING_BITS;
            PENDING_BITS:
                next_state = (cnt > 7) : PENDING_STOP : state;
            PENDING_STOP:
                next_state = (in) ? PENDING_START : state;  
            default:;
        endcase
    end

    // State flip-flops (sequential)
    always @(posedge clk)
    begin
        if(reset)
        begin
            state <= PENDING_START;
            cnt   <= 0;
        end
        else
        begin
            if(next_state != PENDING_START)
                cnt++;
            else
                cnt = 0;

            state <= next_state;
        end
    end

    assign done = ((cnt < 10) && (next_state == PENDING_START)) ? 1 : 0;
endmodule