//Once run is set to Hi, this program will run through the entire screen and output data memory SIGNALS (not the memory itself)
// as well as the current value that the memory is on



module write ( 	input logic		Clk, 
                        			Reset,
											Run,
						output logic	mem_access, 
											ld_reg ,
											write_out ,
						output logic 	[19:0] counter);

	 parameter [19:0] done_counting=307199;	//max X * max Y - 1 for the total number of pixels on screen
	 logic[19:0] counted;
	 logic complete;
		
		enum logic [1:0] {halt, read1, read2, write_vid} State, Next_state;
		
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				begin
				State <= halt;
				counter <= 20'd0;
				end
			else
				begin
				State <= Next_state;
				counter <= counted;
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
		
		always_comb
		begin
			mem_access = 1'b1;
			ld_reg = 1'b0;
			complete = 1'b0;
			counted = counter;
			write_out = 1'b0;
			unique case (State)
				halt: 
					counted = 1'b0;
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
						end
					else
						begin
							counted <= counter + 1'd1;
						end
					end
			endcase
		end

endmodule
