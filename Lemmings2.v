module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
); 

    parameter [1:0]
        LEFT  = 2'b00,
        RIGHT = 2'b01,
        AAAH  = 2'b10;

    reg [1:0]
        state, next_state, last_dir;

    // State transition logic
    always @(*)
    begin
        next_state = state;

        case (state)
            LEFT:
                next_state = !(ground) ? AAAH :
                             (bump_left ? RIGHT: LEFT);
            RIGHT:
                next_state = !(ground) ? AAAH :
                             (bump_right ? LEFT: RIGHT);
            AAAH:
                next_state = !(ground) ? AAAH : 
                             (last_dir == LEFT) ? LEFT : RIGHT;
            default:;
        endcase
    end

    // Update logic
    always @(posedge clk, posedge areset)
    begin
        if (areset)
        begin
            last_dir <= LEFT;
            state    <= LEFT;
        end
        else
        begin
            if(state != AAAH)
                last_dir <= state;
            else;

            state <= next_state;
        end
    end

    // Output logic
    always @(*)
    begin
        walk_left  = (state == LEFT);
        walk_right = (state == RIGHT);
        aaah       = (state == AAAH);
    end

endmodule
