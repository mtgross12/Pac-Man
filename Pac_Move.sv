/*
  Determines the next coordinate to place pacman.
  Keeps track of direction
  If keypress is detected,
		keypress is scanned and checked for WASD values
	Otherwise the Default is to continue in the current direction
	
  Then the direction is processed with the current coordinates
  to create requested new coordinates. These coordinates are sent to the pacman module
  as well as the validator. With a combinted coordinate and validation signal, the 
  coordinates are stored in the pacman module
  
*/


module Pac_Move (input logic [7:0] keyboard, 
					  input logic	[2:0] select, //3'd4 to activate move selection
						input logic	valid,
						input logic	[4:0]	cur_x,
						input logic	[4:0]	cur_y,
						input	logic	clock, reset,
						output logic [4:0]request_x,
						output logic		 [4:0]request_y);
								
		logic [7:0] old_key; //keeping track of if a new key is pressed
		logic [2:0] direction; //0=Left, 1=Right, 2=Down, 3=Up, 4=hold
		logic [4:0] rx, ry;
		assign request_x = rx;
		assign request_y = ry;
		
		initial old_key = 8'd0;
		
		always_ff @ (posedge clock)
		begin
			if(reset) direction = 3'd4;
			if(keyboard != old_key)
			begin
				unique case(keyboard)
				8'h1A: //up
					begin
						old_key <= keyboard;
						direction = 3'd3;
					end
				8'h04: //left
					begin
						old_key <= keyboard;
						direction = 3'd0;
					end
				8'h16: //down
					begin
						old_key <= keyboard;
						direction = 3'd2;
					end
				8'h07: //right
					begin
						old_key <= keyboard;
						direction = 3'd1;
					end
				8'h13:
					begin
						old_key <= keyboard;
						direction = 3'd4;
					end
				default: ;
				endcase
				end
				end
				always_comb
				begin
				case(direction)
				3'd0: 
					begin
					if(cur_x == 5'd0)
						rx = 5'd27;
					else
						rx = cur_x-1;
					ry = cur_y;
					end
				3'd1: 
					begin
					if(cur_x == 5'd27)
						rx = 5'd0;
					else
						rx = cur_x+1;
					ry = cur_y;
					end
				3'd2: 
					begin
					rx = cur_x;
					ry = cur_y +1;
					end
				3'd3: 
					begin
					rx = cur_x;
					ry = cur_y -1;
					end
				3'd4:
					begin
					rx = cur_x;
					ry = cur_y;
					end
				endcase
			end
		endmodule
					
					
				