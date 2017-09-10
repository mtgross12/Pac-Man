module register_16(input logic [15:0] data_in,
						 input logic Clk, load, reset,
						 output logic [15:0] data_out);
						 
always_ff @ (posedge Clk)
begin
	if(reset)
		data_out <= 16'h0;
	else if(load)
		data_out <= data_in;
end
						 
endmodule
						 