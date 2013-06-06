`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:36:18 05/30/2013
// Design Name:   ddr2_rtl_top
// Module Name:   D:/ddr2_xilinx_v5/ddr2_fifo_module/ddr2_rtl_top_tb.v
// Project Name:  ddr2_fifo_module
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ddr2_rtl_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ddr2_rtl_top_tb;

	// Inputs
	reg clk_in;
	reg reset_n;
	
	

	// Outputs
	wire  [3:0]                   sys_clk_led  ;
	wire                          dout_vd      ;
  wire  [31 :0]                 data_out     ;
  wire                          phy_init_done;
  wire                          data_error   ;

	// Instantiate the Unit Under Test (UUT)
	ddr2_rtl_top uut (
		.clk_in(clk_in), 
		.reset_n(reset_n),
	 
		.dout_vd(dout_vd),
		.data_out(data_out),
		.data_error(data_error),
		.phy_init_done(phy_init_done),
		.sys_clk_led(sys_clk_led)
	);

	initial
	 begin
		
     clk_in   = 1'b0;
   forever     clk_in   = #10   ~clk_in;

	end
   
   
   
 
   
  
   
   
   
   
   
   
   
     
     
  initial 
	
	begin
      reset_n   = 1'b0;
      #400;
      reset_n   = 1'b1;
   end   
     
     
     
     
     
      
endmodule

