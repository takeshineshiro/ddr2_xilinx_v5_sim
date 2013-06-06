`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:06:03 05/06/2013 
// Design Name: 
// Module Name:    rd_fifo 
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
module rd_fifo  # (

    parameter     DATA_WIDTH   = 128 ,
	 parameter     WRITE_BURST  = 8
 

   )(
	
  //input
    
	  input                     wr_clk    ,
     input         	          rd_clk    ,
     input     	             reset     ,
	  input [DATA_WIDTH-1:0]    rd_fifo_in,
	  input                     rd_fifo_vd, 
     input                     rd_en     ,
	  inout  [35:0]             CONTROL   ,
	
//output  
     output                    full        ,
     output                    almost_full ,
	  output                    empty       ,
	  output                 	 almost_empty,
     output  [DATA_WIDTH-1:0]  rd_fifo_out,
	  output                    fifo_out_vd
	
	
	
	
	
	
	
	
    );


  //wire

     wire                                            rd_fifo_en  ;

     wire          [130:0]                           trig0  ;

//reg 

   reg       [9:0]                                   delay_cnt    ;
	




//combination


  assign          rd_fifo_en                   = !empty     ;  


//new   trig

  assign     trig0[0]                       =    rd_fifo_vd   ;
  assign     trig0[64:1]                    =    rd_fifo_in   ;
  assign     trig0[65]                      =    rd_en        ;
  assign     trig0[66]                      =    fifo_out_vd  ;
  assign     trig0[130:67]                  =    rd_fifo_out  ;




//seq

   






//iniation




  fifo_1     rd_fifo   (
  
     .rst        (reset),
     .wr_clk     (wr_clk),
     .rd_clk     (rd_clk),
     .din        (rd_fifo_in),
     .wr_en      (rd_fifo_vd),
     .rd_en      (rd_fifo_en),
     .dout       (rd_fifo_out),
     .full       (full),
     .almost_full(almost_full),
     .empty      (empty),
     .almost_empty(almost_empty),
     .valid        (fifo_out_vd),
     .rd_data_count(),
     .wr_data_count()
   
  
  );





 //ila_chip_rd_fifo     ila_chip_rd_fifo   (
 //
 //  .CONTROL(CONTROL),
//   .CLK( ),
 //  .TRIG0(trig0)
 
//









endmodule
