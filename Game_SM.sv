/*
  clock is 50 Mhz clock
  game_clock is 2Hz clock (ticks once every second)
  run will start the state machine
  reset will restart the state machine
  done 1-4 are signals that a move has been found for each ghost and allows proceeding to the next ghost
  done 5 is signal from the Painter, representative that the game changes are done being painted onto the board
  the keyboard is constantly being read for a pause signal "P"
  once paused, the game is reset with the "R" key
*/
module Game_SM (input logic clk, game_clock, run, reset, done1, done2, done3, done4, done5, complete,
					 input logic [7:0] keyboard, 
					 output logic [2:0] select, 
					 output logic run_display, read_req);
					
					enum logic[3:0] {start, halt, ghost1, ghost2, ghost3, ghost4, pacman, paint, display, display2, pause} State, Next_State;
	always_ff@(posedge clk)
					begin
					if(reset)
						begin
						State = halt;
						end
					else
						begin
						State = Next_State;
						end
					end
	always_comb	//Assign next state
		begin
			Next_State = State;
			
			unique case (State)
				start:
					if(keyboard == 8'h20)
						Next_State <= halt;
				halt: //holding state
					if (run)
						Next_State <= display;
				ghost1: //get new coordinates for ghosts
					if(done1)
						Next_State <= ghost2;
				ghost2:
					if(done2)
						Next_State <= ghost3;
				ghost3:
					if(done3)
						Next_State <= ghost4;
				ghost4:
					if(done4)
						Next_State <= pacman;
				pacman: //wait for user to define way to go (or not)
					if(keyboard == 8'h13) // Hax value for P key
						Next_State <= pause;
					else if(game_clock)
						Next_State <= paint;
				paint: //update board to reflect changes
					if(done5)
						Next_State <= display;
				display:
					if(select == 3'd6)
						Next_State <= display2;
				display2:
						if(complete)
							Next_State <= ghost1;
				pause:
					if(keyboard == 8'h15) // Hex value for R key
						Next_State <= pacman;
			endcase
		end
		always_comb
		begin
			select = 3'd0; 
			run_display = 1'b0;
			read_req = 1'b0;
			unique case(State)
				halt: select = 3'd7;
				ghost1: select = 3'd0;
				ghost2: select = 3'd1;
				ghost3: select = 3'd2;
				ghost4: select = 3'd3;
				pacman: 
					begin
					select = 3'd4;
					read_req = 1'b1;
					end
				paint: select = 3'd5;
				display:
				begin
					select = 3'd6;
				end
				start: ;
				display2: 
				begin
				select = 3'd6;
				run_display = 1'b1;
				end
				default: ;
			endcase
		end
			
		endmodule
					
					
					