/*
	This module is the handholder to the Painter
	It take in a validation signal and changing x,y coordinates
	When a valid movement is made, the next coord is updated
	
	When the SM moves from the pacman module to the painter,
	The painter has the current and old coordinates to update.
	The old coordinate is blanked,
	The current coordinate is replaced with the pacman sprite.
	
*/

module PacMan (input logic clock, valid, reset,
					input logic [2:0] select,
					input logic [4:0] new_x, new_y,
					output logic [4:0] old_x, old_y, cur_x, cur_y);
		logic [4:0] o_x, o_y, c_x, c_y;		

		
	initial
		begin
			c_x <= 5'd13;
			c_y <= 5'd23;
			o_x <= 5'd13;
			o_y <= 5'd23;
		end
		
	always_ff @(posedge clock)
		begin
			if(valid) //&& clock? if clock is game clock
				begin
				if((new_x != c_x) || (new_y != c_y))
					begin
						o_x = c_x;
						o_y = c_y;
					end
				c_x = new_x;
				c_y = new_y;
				end
			if(reset)
				begin
				c_x <= 5'd13;
				c_y <= 5'd23;
				o_x <= 5'd13;
				o_y <= 5'd23;
				end
		end
		
		assign  old_x=o_x;
		assign  old_y=o_y;
		assign  cur_x=c_x;
		assign  cur_y=c_y;
		
endmodule
				
				
				