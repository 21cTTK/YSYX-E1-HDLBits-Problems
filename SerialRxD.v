module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
    ); //

    parameter [1:0]
        PENDING_START = 2'b00,
        PENDING_STOP  = 2'b01,
        PENDING_BITS  = 2'b10;
    reg [1:0]
        state, next_state;
    reg [31:0]
        cnt;
    reg [7:0]
        out_reg;
    reg byte_ac;
    
    // State transition logic (combinational)
    always @(*)
    begin
        next_state = state;

        case (state)
            PENDING_START:
                next_state = (in) ? state : PENDING_BITS;
            PENDING_BITS:
                next_state = (cnt > 7) ? PENDING_STOP : state;
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
            state   <= PENDING_START;
            cnt     <= 0;
            byte_ac <= 0;
        end
        else
        begin
            byte_ac <= ((next_state == PENDING_START) && (cnt == 9)) ? 1 : 0;
            out_reg[cnt - 1] <= in;

            if(next_state != PENDING_START)
                cnt = cnt + 1;
            else//PENDING_START
                cnt = 0;

            state <= next_state;
        end
    end

    assign done     = byte_ac ? 1 : 0;
    assign out_byte = out_reg;
endmodule
