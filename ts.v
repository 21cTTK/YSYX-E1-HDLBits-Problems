module lem4(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
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

module top_module();

    reg clk;
    reg areset;
    reg bump_left;
    reg bump_right;
    reg ground;
    reg dig;

    wire walk_left;
    wire walk_right;
    wire aaah;
    wire digging;

    // DUT
    lem4 dut (
        .clk        (clk),
        .areset     (areset),
        .bump_left  (bump_left),
        .bump_right (bump_right),
        .ground     (ground),
        .dig        (dig),
        .walk_left  (walk_left),
        .walk_right (walk_right),
        .aaah       (aaah),
        .digging    (digging)
    );

    initial clk = 0;
    initial `probe_start;
    always #5 clk = ~clk;

    // Timing Diagram - IN
    `probe(clk);
    `probe(areset);
    `probe(bump_left);
    `probe(bump_right);
    `probe(ground);
    `probe(dig);

    // Timing Diagram = OUT
    `probe(walk_left);
    `probe(walk_right);
    `probe(aaah);
    `probe(digging);

    // Internal FSM signals
    `probe(dut.state);
    `probe(dut.next_state);
    `probe(dut.last_dir);
    `probe(dut.fall_cnt);

    // Stimuli
    initial begin

        // Initial values
        areset      = 1;
        bump_left   = 0;
        bump_right  = 0;
        ground      = 1;
        dig         = 0;

        // Hold reset for one clock
        @(negedge clk);
        areset = 0;

        // ========================================================
        // TEST 1:
        // LEFT -> RIGHT by bump_left
        // ========================================================
        @(negedge clk);
        bump_left = 1;

        @(negedge clk);
        bump_left = 0;

        // ========================================================
        // TEST 2:
        // RIGHT -> LEFT by bump_right
        // ========================================================
        @(negedge clk);
        bump_right = 1;

        @(negedge clk);
        bump_right = 0;


        // ========================================================
        // TEST 4:
        // LEFT -> DIGN -> FALL -> LEFT
        // ========================================================
        @(negedge clk);
        dig = 1;

        @(negedge clk);
        dig = 0;

        // Remove ground while digging
        ground = 0;

        repeat (5)
            @(negedge clk);

        ground = 1;

        repeat (2)
            @(negedge clk);

        // Splatter test
        @(negedge clk);
        ground = 0;

        repeat (19)
            @(negedge clk);

        // Ground returns after >20 falling cycles
        ground = 1;
        // Splatter test
        // Give FSM a little time to recover
        repeat (2)
            @(negedge clk);
        // Splatter test
        @(negedge clk);
        ground = 0;

        repeat (20)
            @(negedge clk);

        // Ground returns after >20 falling cycles
        ground = 1;
        // Splatter test
        // Give FSM a little time to recover
        repeat (2)
            @(negedge clk);
        // Splatter test
        @(negedge clk);
        ground = 0;

        repeat (21)
            @(negedge clk);

        // Ground returns after >20 falling cycles
        ground = 1;
        // Splatter test
        // Give FSM a little time to recover
        repeat (2)
            @(negedge clk);
        // ========================================================
        // TEST 5:
        // LONG FALL -> DEAD
        //
        // Ground goes away, and we stay in FALL for >20 clocks.
        // Then ground returns.
        // ========================================================
        @(negedge clk);
        ground = 0;

        repeat (22)
            @(negedge clk);

        // Ground returns after >20 falling cycles
        ground = 1;

        // Stay alive long enough to observe DEAD
        repeat (3)
            @(negedge clk);

        $finish;
    end

    // ------------------------------------------------------------
    // Text debug output
    // ------------------------------------------------------------
    // initial begin
    //     $monitor(
    //         "t=%0t | rst=%b ground=%b dig=%b BL=%b BR=%b | "
    //         "state=%03b next=%03b last=%03b cnt=%02d | "
    //         "L=%b R=%b FALL=%b DIG=%b",
    //         $time,
    //         areset,
    //         ground,
    //         dig,
    //         bump_left,
    //         bump_right,
    //         dut.state,
    //         dut.next_state,
    //         dut.last_dir,
    //         dut.fall_cnt,
    //         walk_left,
    //         walk_right,
    //         aaah,
    //         digging
    //     );
    // end

endmodule
