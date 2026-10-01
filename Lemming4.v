module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
); 

    parameter [2:0]
        LEFT  = 3'b000,
        RIGHT = 3'b001,
        FALL  = 3'b010,
        DIGN  = 3'b011,
        DEAD  = 3'b100;

    reg [2:0]
        state, next_state, last_dir;
    reg [4:0]
        fall_cnt;

    // State transition logic
    always @(*)
    begin
        next_state = state;

        case (state)
            LEFT:
                next_state = !(ground) ? FALL :
                             ( 
                                dig ? DIGN : 
                                (bump_left ? RIGHT: LEFT)
                             );
            RIGHT:
                next_state = !(ground) ? FALL :
                             ( 
                                dig ? DIGN : 
                                (bump_right ? LEFT: RIGHT)
                             );
            FALL:
                next_state = !(ground) ? FALL : 
                             (
                                (fall_cnt > 20) ? DEAD :
                                ((last_dir == LEFT) ? LEFT : RIGHT)
                             );
            DIGN:
                next_state = (ground) ? DIGN : FALL;
            DEAD:
                next_state = state;
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
            fall_cnt <= 0;
        end
        else
        begin
            if((state == LEFT) ||
               (state == RIGHT))
                last_dir <= state;
            else;

            if (next_state == FALL)
                fall_cnt <= fall_cnt + 1'b1;
            else
                fall_cnt = 0;

            state <= next_state;
        end
    end

    // Output logic
    always @(*)
    begin
        walk_left  = (state == LEFT);
        walk_right = (state == RIGHT);
        aaah       = (state == FALL);
        digging    = (state == DIGN);
    end

endmodule
