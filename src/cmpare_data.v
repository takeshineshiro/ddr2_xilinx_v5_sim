`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:32 05/06/2013 
// Design Name: 
// Module Name:    addr_gen 
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
module  compare_data  (
 
 //input
 
         input                sys_clk      ,
         input                reset	       ,
         input [31:0]         data_in	     ,
         input         			  din_vd       ,
			   input [31:0]         dout_fifo    ,
			   input                dout_vd      ,

			
    
	 
 //output
 
      output                data_error           
 





    );



     reg         [31:0]       dout_buf     ;
     
     
     
     
     always@( posedge  sys_clk   or   posedge  reset)
     
     begin
        
          if (reset)
             
                dout_buf   <=  0  ;
                
          else
          
              
                dout_buf  <=  dout_fifo ;
     
     
     end





   

  assign      data_error    =   din_vd ?  ((dout_buf==data_in) ?   0:1 )  :  0  ;











endmodule
