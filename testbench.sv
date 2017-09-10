module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic	 clock, reset, run, next_s, complete;
logic		[7:0] keyboard;
logic		[9:0] board_count;
								
logic 	[9:0] address,gb_r_addr, score; 
logic    [3:0] data_out;
logic		[3:0] data_write;
logic 	sprite_en, run_display, we, read_req, valid;
logic [2:0] state_select;
logic 	[4:0] board_x, board_y, pac_req_x, pac_cur_x;


Game_Top test( .*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 clock = ~clock;
end

initial begin: CLOCK_INITIALIZATION
    clock = 0;
end 


initial begin: TEST_VECTORS
reset = 1'b1;
complete = 1'b1;
data_out = 4'h1;

#2 reset = 1'b0;
run = 1'b1;

#2 keyboard = 8'h04;

#5000000 keyboard = 8'h00;



end
endmodule
