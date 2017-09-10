/*
  Author: Matthew Gross 2k17
  The biggest peice of the puzzle perhaps. This is the Painter.
  Purpose: Proceed through moving sprites,
  Updating their positions as they are in their modules
  onto the GameBoard. This is done by keeping track of 
  current and old coordinates, and "bellies" which keep track of what is "eaten"
  This is also where I choose to keep track of score.
  
  This will also have a giant amount of inputs and like 2 outputs. 
  
  
  ...I am sorry.
  The Process:
  First go through and replace all the ghosts with their counter parts
  This means that if a ghost moves to a spot with a point,
  then when the ghost moves again, the spot will be put back
  For pacman this means placing a blank space where he was
  
  Second, take account of whatever is about to be "eaten" and then 
  place the sprites in their updated postions. 
  
  These steps must be executes sequentially or the entire sytem will fail in close quarters.
  
  Notes: 
  Pretty sure that the GameBoardMux has to have an additon to its selection now.
  Pacman should go first in the Draw Order
  
  A separate program should be made to check for end_game conditions. These are:
  -all pellets have been eaten
  -pacman shares coordinates with a ghost
			-if edible then ghost resets current positon to Ghost Pen
			-if regular ghost then game is over
*/

module Painter(input logic clk, reset,
					input logic [1:0] GAME_STATUS,
					input logic [2:0] select,
					input logic [3:0] data_in, 
					input logic [4:0] pac_cur_x, pac_cur_y, pac_old_x, pac_old_y,
					input logic [4:0]		g1_cur_x, g1_cur_y, g1_old_x, g1_old_y,
					input logic [4:0]		g2_cur_x, g2_cur_y, g2_old_x, g2_old_y,
					input logic [4:0]		g3_cur_x, g3_cur_y, g3_old_x, g3_old_y,
					input logic [4:0]		g4_cur_x, g4_cur_y, g4_old_x, g4_old_y,
					output logic [3:0] data_out,
					output logic [9:0] score, write_addr, read_addr, 
					output logic done, we);
					
					//Registers
					logic [9:0] r_addr, w_addr, temp_score;
					assign write_addr = w_addr;
					assign read_addr = r_addr;
					logic [3:0] g1_belly, g2_belly, g3_belly, g4_belly, pacbelly;
					
					//The pacbelly can be read to gain points and initiate change of ghosts to edible ghosts for a set amount of cycles.

				enum logic[3:0] {halt, prep_pac, read_pac, write_pac, prep_ghost, write_ghost} State, Next_State;
	always_ff @(posedge clk)
					begin
					if(reset)
						begin
						State = halt;
						score = 10'd0;
						end
					else
						begin
						State = Next_State;
						score = temp_score;
						end
					end
	always_comb	//Assign next state
		begin
			Next_State = State;
			temp_score = score;
			
			unique case (State)
				halt: //holding state
					if (select == 3'd5)
						Next_State <= prep_pac;
				prep_pac: //get new coordinates for ghosts
						Next_State <= read_pac;
				read_pac:
					begin
						Next_State <= write_pac;
						if(data_in == 4'd1)	//If he has a pellet
						begin
							temp_score <= score + 10'd5;
						end
						if(data_in == 4'd2) //If he has a powerball
						begin
							temp_score <= score + 10'd25;
						end
					end
				write_pac:
					begin
						Next_State <= prep_ghost;
					end
				prep_ghost:
						Next_State <= write_ghost;
				write_ghost:
						Next_State <= halt;

			endcase
		end
		always_comb
		begin
			done = 1'b0;
			we = 1'b0;
			data_out = 3'd8;
			w_addr = 10'd0;
			r_addr = 10'd0;
			pacbelly = 3'd0;
			unique case(State)
				halt:
				begin
				end
				prep_pac:
				begin
					w_addr = pac_old_x + 10'd28*pac_old_y;
					data_out = 3'd0;
					we = 1'b1;
				end
				read_pac:
				begin
					r_addr = pac_cur_x + 10'd28*pac_cur_y;
					pacbelly = data_in; 
				end
				write_pac:
					begin
					w_addr = pac_cur_x + 10'd28*pac_cur_y;
					data_out = 4'd5; //Pacman sprite
					we = 1'b1;
				end
				prep_ghost:
				begin
					done = 1'b1;
				end
				write_ghost:
				begin
				
				end
				default: ;
			endcase
		end
				endmodule
				