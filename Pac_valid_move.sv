/*
  Takes the sprite_num from the Game_Top GameBoard
  outputs if the space is a valid spot to move to 
  at the next game_clock trigger
  
*/
module Pac_valid_move(input logic [3:0] sprite_num,
							 input logic [2:0] sel, 
							 output logic valid);
							 
		always_comb
		begin
		valid = 1'b0;
		if(sel == 3'd4)
		begin
		unique case(sprite_num)
			4'd8: begin	//Wall
				valid = 1'b0;
				end
			4'd7: begin //Ghost
				valid = 1'b0;
				end
			4'd6: begin //Ghost Gate
				valid = 1'b0;
				end
			4'd5: begin //Pacman
				valid = 1'b0;
				end
			4'd4: begin //Edible Ghost
				valid = 1'b1;
				end
			4'd3: begin //Fruit
				valid = 1'b1;
				end
			4'd2: begin //Powerball
				valid = 1'b1;
				end
			4'd1: begin //Point
				valid = 1'b1;
				end
			default: 
				begin//Space
				valid = 1'b1;
				end
			endcase
		end
		end
		endmodule
				