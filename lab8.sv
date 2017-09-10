//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, 
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Run_h, Clk;
    logic [15:0] keycode;
    
    assign Clk = CLOCK_50;
    assign {Reset_h} = ~(KEY[0]);  // The push buttons are active low
	assign {Run_h} = ~(KEY[1]);

    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w,hpi_cs, we, valid;
	 
	
	 logic [9:0] DrawX, DrawY, BallX, BallY, BallS;
	 logic [1:0] display;
	 logic [19:0] frame_address;
	 assign frame_address = DrawY * 10'd640 + DrawX;
	 logic [2:0] state_select;
	 
	 logic [4:0] board_x, board_y, pac_cur_x, pac_req_x;
	 logic [3:0] sprite_x, sprite_y, write_board;
	 logic [9:0] board_count, gb_r_addr, write_board_address, score;
	 logic [3:0] board_out;
	 logic [7:0] sprite_count;
	 wire game_step, next_s, wf,sprite_en, run_display, complete;
	 wire [1:0] sprite_out, d0, d1, d2, d3, d4, d5, d6, d7, d8;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(1'b0),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),    
                            .OTG_RST_N(OTG_RST_N)
    );
     
     //The connections for nios_system might be named different depending on how you set up Qsys
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),   
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_out_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w)
    );
    
    //Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.*, .Reset(Reset_h), .DrawX, .DrawY);
    
    color_mapper color_instance(.*, .pixel(display));
	 HexDriver hex_inst_0 (score[3:0], HEX0);
    HexDriver hex_inst_1 (score[7:4], HEX1);
	 HexDriver hex_inst_2 (score[9:8], HEX2);
    //HexDriver hex_inst_3 (state_select, HEX3);
    //HexDriver hex_inst_4 (board_out, HEX4);
	 
	 
	 //SETTING UP THE GAME //siwtched in KEY[3] for 1'b1 in Run()
	 Game_Board gameboard_reset(.data_In(write_board), .write_address(write_board_address), .read_address(gb_r_addr), .we(we), .Clk(Clk), .data_Out(board_out));
	 game_board_reader board_reader(.Clk(Clk), .Reset(Reset_h), .complete, .Run(run_display), .next_sprite(next_s), .mem_access(), .ld_reg(), .write_out(sprite_en), .counter(board_count), 
											  .game_x(board_x), .game_y(board_y));
    Game_Top top_game(.clock(Clk), .reset(Reset_h), .run_display, .complete, .data_write(write_board), .we(we), .state_select, .score, 
								.run(Run_h), .keyboard(keycode), .address(write_board_address), .board_count, .gb_r_addr, .read_req(), .valid, 
								.data_out(board_out), .next_s(), .sprite_en(), .board_x(), .board_y(), .pac_req_x, .pac_cur_x);
	 //Translate from characters into sprites
	 Sprite_Picker sprite_selecter(.select(board_out), .Sout(sprite_out), .Din0(), .Din1(d1), .Din2(d2), .Din3(), .Din4(), .Din5(d5), .Din6(), .Din7(d7), .Din8(d8));
	 //Sprites initialization
	 Wall_sprite wally(.data_In(), .write_address(), .read_address(sprite_count), .we(), .Clk(Clk), .data_Out(d8));
	 pacman_sprite PacMan(.data_In(), .write_address(), .read_address(sprite_count), .we(), .Clk(Clk), .data_Out(d5));
	 Point_sprite ballpoint(.data_In(), .write_address(), .read_address(sprite_count), .we(), .Clk(Clk), .data_Out(d1));
	 Powerup_sprite powerup(.data_In(), .write_address(), .read_address(sprite_count), .we(), .Clk(Clk), .data_Out(d2));
	 Ghost_sprite ghost(.data_In(), .write_address(), .read_address(sprite_count), .we(), .Clk(Clk), .data_Out(d7));
	 //Sprite Reader
	 sprite_reader s_reader(.Clk(Clk), .Reset(Reset_h), .Run(sprite_en), .mem_access(), .ld_reg(), .write_out(wf), .next_s(next_s), .counter(sprite_count), .game_x(sprite_x), .game_y(sprite_y));
	 //Frame Buffer
	 logic [19:0] frame_write_address;
	 assign frame_write_address = 20'd640*(20'd15*board_y + sprite_y) + 20'd15*board_x + sprite_x;
	 frameRAM frame_buffer(.data_In(sprite_out), .write_address(frame_write_address), .read_address(frame_address), .we(wf), .Clk(Clk), .data_Out(display));

    
endmodule
