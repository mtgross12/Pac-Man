/* Sub-top level to clean up the code
   Takes the keycode and system clock
	Outputs the gameboard data and a write signal
	  in order to update the GameBoard at toplevel
	Also should take the KEY's and uses them for Resets
	as well as beginning the game
*/

module Game_Top ( input logic	 clock, reset, run, next_s, complete,
				  input logic		[7:0] keyboard,
				  input logic		[9:0] board_count,
								
				  output logic 	[9:0] address,gb_r_addr, score, 
				  input logic    [3:0] data_out,
				  output logic		[3:0] data_write,
				  output logic 	sprite_en, run_display, we, read_req, valid, 
				  output logic [2:0] state_select,
				  output logic 	[4:0] board_x, board_y, pac_req_x, pac_cur_x);
	//registers and connections



	logic [9:0] paint_read;
	logic [3:0] gb_data_out, gb_data_in;
	wire game_clk, d1, d2, d3, d4, d5;
	logic [4:0]  g1_req_x, g1_req_y, g2_req_x, g2_req_y, g3_req_x, g3_req_y, g4_req_x, g4_req_y;//pac_req_x, pac_cur_x,
	logic [4:0]  pac_old_x, pac_old_y, pac_req_y, pac_cur_y;
	
	logic [9:0] pac_request_ADDR;
	
	
	//OVERSEER
	
	g_clock g_c(.Clk(clock), .Reset(reset), .game_clk(game_clk));
	Game_SM state_game(.clk(clock), .game_clock(game_clk), .run(run), .reset(reset), .done1(1'b1), .done2(1'b1), .done3(1'b1), .done4(1'b1), .done5(d5), 
						.keyboard(keyboard), .select(state_select), .complete(complete), .run_display(run_display), .read_req);
	// EndGame
	//Keeping track of changes LIVE
	//game_board_reader board_reader(.Clk(clock), .Reset(reset), .Run(run_display), .next_sprite(next_s), .mem_access(), .ld_reg(), .write_out(sprite_en), 
									//.counter(gb_r_addr), .game_x(board_x), .game_y(board_y), .complete(complete));
	//Game_Board active_board(.data_In(gb_data_in), .write_address(gb_w_addr), .read_address(board_count), .we(1'b0), .Clk(clock), .data_Out(data_out));
	Game_Board_MUX board_control(.select(state_select), .pac_read_ADDR(pac_request_ADDR), .g1_read_ADDR(), .g2_read_ADDR(), .g3_read_ADDR(), .g4_read_ADDR(), .read_address(gb_r_addr), 
										  .display_addr(board_count), .paint_read);
	
	// Painter
	Painter paint(.clk(clock), .reset, .we(we), .done(d5),.GAME_STATUS(2'b00), .select(state_select), .data_in(data_out), 
					.pac_cur_x, .pac_cur_y, .pac_old_x, .pac_old_y, 
					.g1_cur_x(), .g1_cur_y(), .g1_old_x(), .g1_old_y(),
					.g2_cur_x(), .g2_cur_y(), .g2_old_x(), .g2_old_y(),
					.g3_cur_x(), .g3_cur_y(), .g3_old_x(), .g3_old_y(),
					.g4_cur_x(), .g4_cur_y(), .g4_old_x(), .g4_old_y(),
					.data_out(data_write), .score, .write_addr(address), .read_addr(paint_read));
	
	
	
	//original pac 13, 23
	//User-Controlled Pacman
	PacMan pac(.clock(game_clk), .reset, .select(state_select), .valid, .new_x(pac_req_x), .new_y(pac_req_y), .old_x(pac_old_x), .old_y(pac_old_y),
							 .cur_x(pac_cur_x), .cur_y(pac_cur_y));
	Pac_Move move_pac(.keyboard(keyboard), .reset, .clock(clock), .select(state_select), .valid(valid), .cur_x(pac_cur_x), .cur_y(pac_cur_y),
							 .request_x(pac_req_x), .request_y(pac_req_y));
	assign pac_request_ADDR = 10'd28*pac_req_y + pac_req_x;
	Pac_valid_move valid_move(.sprite_num(data_out), .sel(state_select), .valid(valid));
	
	//Computer-Controlled Ghosts
	// Ghost
	// Number_Generator
	// Ghost_Mover
	// Ghost_Move_Validator
	
endmodule
