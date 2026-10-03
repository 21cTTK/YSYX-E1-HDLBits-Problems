module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
	);

    reg [255:0] q_next;

    // state transition logic
    always @(*)
    begin
        //latch guard
        q_next = q;

        //locate (i,j)
        for (integer i = 0; i < 16; i++)
        begin   // traverse Rows i[15:0]
            for (integer j = 0; j < 16; j++)
            begin   // traverse Cols j[15:0]
                integer
                    live_cnt,
                    iL, iR, // i:L[15,14,13...1,0]R
                    jL, jR; // j:L[15,14,13...1,0]R

                // inner
                iL = i + 1;
                iR = i - 1;
                jL = j + 1;
                jR = j - 1;

                // boundaries
                if(i == 0)
                    iR = 15;
                else if(i == 15)
                    iL = 0;
                else;

                if(j == 0)
                    jR = 15;
                else if(j == 15)
                    jL = 0;
                else;

                live_cnt = q[iR * 16 + jL] + // TL
                        q[iR * 16 + j ] + // Top
                        q[iR * 16 + jR] + // TR
                        q[i  * 16 + jL] + // Left
                        q[i  * 16 + jR] + // Right
                        q[iL * 16 + jL] + // BL
                        q[iL * 16 + j ] + // Bottom
                        q[iL * 16 + jR];  // BR
                
                // state transition
                if((live_cnt == 0) ||
                (live_cnt == 1) ||
                (live_cnt > 3))
                    q_next[i * 16 + j] = 0;
                else if(live_cnt == 3)
                    q_next[i * 16 + j] = 1;
            end
        end
    end
    
    always @(posedge clk)
    begin
        if(load)
            q <= data;
        else
            q <= q_next;
    end
endmodule
