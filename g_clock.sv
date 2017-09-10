//-------------------------------------------------------------------------
//      Game Clock                                                  --
//      Matthew Gross                                                   --
//      4-27-2017                                                    --
//                                                                       --
//      slows the 50MHz standard clock into a 2Hz clock for the game step
//-------------------------------------------------------------------------


module  g_clock (input                    Clk,         // 50 MHz clock
                                           Reset,       // reset signal
                        output logic       game_clk	  // slowed down clock
                        );     
	  parameter [25:0] done_counting=9000000;
    logic [25:0] counter, counted;
	 
    // Counting the 50MHz clock
    always_ff @ (posedge Clk or posedge Reset)
    begin
		if(Reset)
			counter <= 26'd0;
		else
			counter <= counted;
			
		end
	always_comb
	begin
		game_clk = 1'b0;
		counted = counter;
		if(Reset)
			counted = 26'd0;
		if (done_counting == counter)
						begin
							counted = 10'b0;
							game_clk = 1'b1;
						end
		else
						begin
							counted <= counter + 1'd1;
						end
	end
endmodule
