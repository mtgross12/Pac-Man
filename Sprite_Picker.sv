/*
This is a module designed to handle defining the 3-bit incoming signal into
	some signal to determine some sprites!

Matthew Gross 2k17 lez go
Feel my Caffeine and rage fueled coding experiment
*/

module Sprite_Picker(input [3:0] select,
							input [1:0] Din0, Din1, Din2, Din3, Din4, Din5, Din6, Din7, Din8, 
							output [1:0] Sout);
							
				always_comb
				begin
						case(select)
							4'd8: 
								begin	//Wall
								Sout = Din8;
								end
							4'd7: 
								begin//Ghost
								Sout = Din7;
								end
							4'd6: 
								begin//Ghost Gate
								Sout = Din6;
								end
							4'd5: 
								begin//Pacman
								Sout = Din5;
								end
							4'd4: 
								begin//Edible Ghost
								Sout = Din4;
								end
							4'd3: 
								begin;//Fruit
								Sout = Din3;
								end
							4'd2: 
								begin//PowerBall
								Sout = Din2;
								end
							4'd1: 
								begin//Point
								Sout = Din1;
								end
							default: 
								begin //Space
								Sout = Din0;
								end
								
						endcase
				end
endmodule
