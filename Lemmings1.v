module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    parameter 
        LEFT = 0,
        RIGHT = 1;
    reg 
        state, next_state;

    always @(*)
    begin
        next_state = state;

        if(state == LEFT)
            next_state = bump_left ? RIGHT: LEFT;
        else// RIGHT
            next_state = bump_right ? LEFT : RIGHT;
    end

    always @(posedge clk, posedge areset)
        state <= areset ? LEFT : next_state;

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule