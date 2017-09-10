/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 * 
 * 
   This is a memory heap of information, and array of the sprites stored as 3-bit values.
   It is read by being given a read address and then taking that and putting it into a
	mapper and that will have access to the individial bits of data about each indivual sprite.
	So in essence this is the overview of the PacMan Game Board and is really the only PNG-to-Txt
	that should be written, and that is done by the game controller.
	 
 */

module  Game_Board
(
		input [3:0] data_In,
		input [9:0] write_address, read_address,
		input we, Clk,

		output logic [3:0] data_Out
);

// mem has width of 3 bits and a total of 868 addresses
logic [3:0] mem [0:867];

initial
begin
	 $readmemh("sprite_bytes/GameBoard.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule
