`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:59:09 05/27/2013 
// Design Name: 
// Module Name:    din_gen 
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
module din_gen(

//input

     input               reset_n  ,
     input               clk      ,	
     input               phy_init_done,
    
//output
     output reg             wr_en    ,  
     output reg             rd_en    ,
	  output reg  [31:0]  dout       
	 




    );



     reg     [12:0]            wr_count    ;

    reg      [12:0]            rd_count     ;
    

    reg                        phy_done     ;        

   always@(posedge  clk    or   negedge   reset_n )
   begin
     
     if (!reset_n)
      
          phy_done   <=   0;
     else   if (phy_init_done)
     
          phy_done   <=   1 ;
     
   
   
   
   end 



   always@( posedge  clk    or  negedge   reset_n )
    
    begin
       if (!reset_n)
     
           wr_count     <=   0 ;
      else  if (phy_done && wr_count <= 2048)
    
          wr_count   <=    wr_count  +1 ;
          
      else
      
         wr_count   <=    wr_count   ;   

   end 




always@( posedge  clk    or  negedge   reset_n )
    
    begin
       if (!reset_n)
     
           wr_en     <=   0 ;
      else  if (phy_done && wr_count <= 2048)
    
            wr_en   <=    1 ;
          
      else
      
         wr_en   <=    0   ;   

   end 





always@( posedge  clk    or  negedge   reset_n )
    
    begin
       if (!reset_n)
     
           rd_count     <=   0 ;
      else  if (phy_done && (wr_count>=2048)&& !wr_en && (rd_count<=32))
    
              rd_count   <=  rd_count +1 ;
          
      else
      
               rd_count   <=    rd_count   ;   
 
   end 






always@( posedge  clk    or  negedge   reset_n )
    
    begin
       if (!reset_n)
     
           rd_en     <=   0 ;
      else  if (phy_done &&(rd_count>=32))
    
            rd_en   <=    1 ;
          
      else
      
          rd_en   <=   rd_en  ;   

   end 








always@( posedge clk   or   negedge  reset_n )
		 begin
		    if (!reset_n)	
            
            begin
				   dout   <=  0;
							
             end 				
			
   	   else
			     if (wr_en)
           	  dout   <=  dout  +1  ;		
		         
		 
		 
		 end 








endmodule
