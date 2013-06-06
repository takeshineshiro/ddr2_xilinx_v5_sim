`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:08:17 05/06/2013 
// Design Name: 
// Module Name:    wr_fifo 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module wr_fifo   # (

   parameter  DATA_WIDTH   = 64 ,  
   parameter  WRITE_BURST  = 8
      )

   (
	
	//input
	  
	 input                               wr_clk  ,
    input                               rd_clk  ,
    input                               reset   ,
    input  	[DATA_WIDTH-1:0]            data_in ,
    input           	                   wr_fifo ,
	 input                               rd_fifo ,
	 inout    [35:0]                     CONTROL ,
	 
	 
//output	
   output  [9 : 0]                      rd_data_count,
   output  [9 : 0]                      wr_data_count,
	output                               almost_full  ,
   output                               almost_empty ,
	output                               prog_full ,
   output                               prog_empty,
   output [DATA_WIDTH-1:0]              data_out ,
   output                               dout_vd 	
      
	
	
	
	
    );


//wire

   wire    [70:0]                            trig0    ;
	


//reg

  assign     trig0[0]                  =   wr_fifo     ;
  assign     trig0[1]                  =   rd_fifo     ;
  assign     trig0[2]                  =   almost_full ;
  assign     trig0[3]                  =   almost_empty ;
  assign     trig0[4]                  =   prog_full   ;
  assign     trig0[5]                  =   prog_empty  ;
  assign     trig0[6]                  =   dout_vd     ;
  assign     trig0[70:7]               =   data_out    ;
   

 






fifo_0    fifo_0  (

//input 
     .rst   (reset) ,
     .wr_clk(wr_clk),
     .rd_clk(rd_clk),
     .din   (data_in),
     .wr_en (wr_fifo),
     .rd_en (rd_fifo),

//output	  
     .dout(data_out),
	  .valid(dout_vd),
     .full(),
     .almost_full(almost_full),
     .empty(),
     .almost_empty(almost_empty),
     .rd_data_count(rd_data_count),
     .wr_data_count(wr_data_count),
	  .prog_full(prog_full),
     .prog_empty(prog_empty)




);

  
// ila_chipscope_wr_fifo     ila_chipscope_wr_fifo (
 
//    .CONTROL(CONTROL),
//    .CLK(rd_clk),
//    .TRIG0(trig0)

 
// );
  
  





















endmodule
