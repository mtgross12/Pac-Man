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
    logic [25:0] counter;
	 
    // Counting the 50MHz clock
    always_ff @ (posedge Clk or posedge Reset)
    begin
		  case(counter)
				26'd25000000:
					begin
						game_clk = 1'b1;
						counter = 26'd0;
					end
				default: 
					begin
						if(Reset)
						begin
							counter = 26'd0;
							game_clk = 1'b0;
						end
						else
						begin
							counter = counter + 16'd1;
							game_clk = 1'b0;
						end
					end
			endcase
    end
    
    
    
endmodule
