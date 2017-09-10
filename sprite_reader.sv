/*
  Maps out the processing signals for translating from a sprite down to pixels
*/



module sprite_reader ( 	input logic		Clk, 
													Reset, 
													Run,
								output logic	mem_access,
													next_s, 
													ld_reg ,
													write_out,
								output logic 	[7:0] counter, //the pixel of the individual sprite we are on
								output logic 	[3:0] game_x, game_y); //the coordinates of the individual sprite we are on

	 parameter [7:0] done_counting=224;	//15 * 15 size of sprite
	 logic[7:0] counted;
	 logic[3:0] old_x, old_y;
	 logic complete; //Hi when all sprite data has been output
		
		enum logic [1:0] {halt, read1, read2, write_vid} State, Next_state;
		
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				begin
				State <= halt;
				counter <= 8'd0;
				game_x <= 4'd0;
				game_y <= 4'd0;
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
					if(complete)
						Next_state <= halt;
					else
						Next_state <= read1;	
				default : ;
			endcase
		end
		
		always_comb //set signals for reading from sprite memory
		begin
			mem_access = 1'b1;
			ld_reg = 1'b0;
			complete = 1'b0;
			counted = counter;
			old_x = game_x;
			old_y = game_y;
			write_out = 1'b0;
			next_s = 1'b0;
			unique case (State)
				halt: 
					counted = 8'b0;
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
							complete = 1'b1;
							counted = 8'd0;
							old_x = 5'd0;
							old_y = 5'd0;
							next_s = 1'b1;
						end
					else
						begin
							counted <= counter + 1'd1;
							if (game_x == 4'hE) //when reaching the end of a row
							begin
								old_x <= 4'h0;
								old_y <= game_y + 1'd1;	
							end
							else
								old_x <= game_x + 1'd1;
						end
					end
			endcase
		end

endmodule
