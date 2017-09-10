module Game_Board_MUX(input logic [2:0]select,  
							 input logic [9:0] pac_read_ADDR, g1_read_ADDR, g2_read_ADDR, g3_read_ADDR, g4_read_ADDR, paint_read, display_addr,
							 output logic [9:0] read_address);
always_comb	
	begin	
	read_address = 10'd0;
			unique case(select)
				4'd0: //g1
				begin
					read_address = g1_read_ADDR;
				end
				4'd1: //g2
				begin
					read_address = g2_read_ADDR;
				end
				4'd2: //g3
				begin
					read_address = g3_read_ADDR;
				end
				4'd3: //g4
				begin
					read_address = g4_read_ADDR;
				end
				4'd4: //PacMan
				begin
					read_address = pac_read_ADDR;
				end
				4'd5:
					read_address = paint_read;
				4'd6:
					read_address = display_addr;
				default: read_address = 10'd0;
			endcase
	end	
endmodule
