//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  03-03-2017                               --
//                                                                       --
//    Spring 2017 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// Honestly I don't even know how this helps. It takes a 2 bit pixel and clock and gives three 0-255 values
module  color_mapper ( input        [1:0] pixel, 
							  input					Clk,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    
    logic [7:0] Red, Green, Blue;
    
	 always_ff @ (posedge Clk)
	 begin
			VGA_R <= Red;
			VGA_G <= Green;
			VGA_B <= Blue;
	 end
    

    
    // Assign color based on index
    always_comb
    begin : RGB_Display
			Red = VGA_R;
			Green = VGA_G;
			Blue = VGA_B;
		unique case (pixel)
			2'b00: //0x000000
				begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
				end
			2'b01: //0x0000FF
				begin
				Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hFF;
				end
			2'b10: //0xFFFF00
				begin
				Red = 8'hFF;
            Green = 8'hFF;
            Blue = 8'h00;
				end
			2'b11: //0xFFFFFF
				begin
				Red = 8'hFF;
				Green = 8'hFF;
				Blue = 8'hFF;
				end
			default: ;
		endcase
    end 
    
endmodule
