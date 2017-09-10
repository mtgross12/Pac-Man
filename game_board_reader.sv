/*
Gives a count, the current (X,Y) coordinates of the sprite
      Basically is the write_buffer.sv except it requires a run 
		signal to start off from the Halt state as well as 
		a next_sprite signal in order to grab the next sprite
*/



module game_board_reader ( 	input logic		Clk, 
												Reset,
												Run,
												next_sprite,
							output logic	mem_access, 
												ld_reg ,
												write_out ,
												complete,
							output logic 	[9:0] counter,
							output logic 	[4:0] game_x, game_y); //coordinates of the current sprite

	 parameter [9:0] done_counting=868;	//31 * 28 total number of game pieces
	 logic[9:0] counted;
	 logic[4:0] old_x, old_y;
		
		enum logic [1:0] {halt, read1, read2, write_vid} State, Next_state;
		
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				begin
				State <= halt;
				counter <= 10'd0;
				game_x <= 5'd0;
				game_y <= 5'd0;
				end
			else
				begin
				State <= Next_state;
				counter <= counted;
				game_x <= old_x;
				game_y <= old_y;
				end
		end
		
		always_comb	//Assign next state
		begin
			Next_state = State;
			
			unique case (State)
				halt:
					if (Run)
						Next_state <= read1;
				read1:
					Next_state <= read2;
				read2:
					Next_state <= write_vid;
				write_vid:
					if(complete)//if we have output all pixels from this sprite then we go to halt
						Next_state <= halt;
					else if (next_sprite)//if the next sprite is requested then the unit progresses
						Next_state <= read1;

				//default : ;
			endcase
		end
		
		always_comb
		begin
			mem_access = 1'b1;
			ld_reg = 1'b0;
			complete = 1'b0;
			counted = counter;
			old_x = game_x;
			old_y = game_y;
			write_out = 1'b0;
			unique case (State)
				halt: 
					counted = 10'b0;
				read1:
					mem_access = 1'b0;
				read2:
				begin
					mem_access = 1'b0;
					ld_reg = 1'b1;
				end
				write_vid:
				begin
					write_out = 1'b1;
					if (done_counting == counter)
						begin
							counted = 10'b0;
							old_x = 5'd0;
							old_y = 5'd0;
							complete = 1'b1;
						end
					else if (next_sprite)//if the next sprite is requested then the unit progresses
						begin
							counted <= counter + 1'd1;
							if (game_x == 5'd27)
							begin
								old_x <= 5'h0;
								old_y <= game_y + 1'd1;	
							end
							else
							begin
								old_x <= game_x + 1'd1;
							end
						end
				end
			endcase
		end

endmodule
