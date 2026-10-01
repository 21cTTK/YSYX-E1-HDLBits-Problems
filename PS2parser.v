module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done
    ); //

    parameter 
        IDLE = 1'b0,
        RX = 1'b1;
    reg state, next_state;
    reg [1:0]
        byte_cnt;

    // State transition logic (combinational)
    always @(*)
    begin
        next_state = state;

        if (state == IDLE)
            next_state = in[3] ? RX : IDLE;
        else// (state == RX)
            next_state = (byte_cnt > 2) ? IDLE : RX;
    end

    // State flip-flops (sequential)
    always @(posedge clk) begin
        if(reset)
        begin
            state <= IDLE;
            byte_cnt <= 2'b00;
        end
        else
        begin
            if(next_state == RX)
                byte_cnt++;
            else
                byte_cnt = 0;

            state <= next_state;
        end
    end
 
    assign done = (byte_cnt > 2) ? 1 : 0;
endmodule