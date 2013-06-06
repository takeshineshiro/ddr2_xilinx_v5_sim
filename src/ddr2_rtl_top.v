`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:20:23 05/27/2013 
// Design Name: 
// Module Name:    ddr2_rtl_top 
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
 module ddr2_rtl_top  #(

   parameter   DATA_WIDTH             = 32 ,
	parameter   DO_WIDTH               = 64 ,
	
	 parameter BANK_WIDTH              = 3,       
                                       // # of memory bank addr bits.
   parameter CKE_WIDTH               = 1,       
                                       // # of memory clock enable outputs.
   parameter CLK_WIDTH               = 2,       
                                       // # of clock outputs.
   parameter COL_WIDTH               = 10,       
                                       // # of memory column bits.
   parameter CS_NUM                  = 1,       
                                       // # of separate memory chip selects.
   parameter CS_WIDTH                = 2,       
                                       // # of total memory chip selects.
   parameter CS_BITS                 = 0,       
                                       // set to log2(CS_NUM) (rounded up).
   parameter DM_WIDTH                = 4,       
                                       // # of data mask bits.
   parameter DQ_WIDTH                = 32,       
                                       // # of data width.
   parameter DQ_PER_DQS              = 8,       
                                       // # of DQ data bits per strobe.
   parameter DQS_WIDTH               = 4,       
                                       // # of DQS strobes.
   parameter DQ_BITS                 = 5,       
                                       // set to log2(DQS_WIDTH*DQ_PER_DQS).
   parameter DQS_BITS                = 2,       
                                       // set to log2(DQS_WIDTH).
   parameter ODT_WIDTH               = 2,       
                                       // # of memory on-die term enables.
   parameter ROW_WIDTH               = 13,       
                                       // # of memory row and # of addr bits.
   parameter ADDITIVE_LAT            = 0,       
                                       // additive write latency.
   parameter BURST_LEN               = 8,       
                                       // burst length (in double words).
   parameter BURST_TYPE              = 0,       
                                       // burst type (=0 seq; =1 interleaved).
   parameter CAS_LAT                 = 4,       
                                       // CAS latency.
   parameter ECC_ENABLE              = 0,       
                                       // enable ECC (=1 enable).
   parameter APPDATA_WIDTH           = 64,       
                                       // # of usr read/write data bus bits.
   parameter MULTI_BANK_EN           = 1,       
                                       // Keeps multiple banks open. (= 1 enable).
   parameter TWO_T_TIME_EN           = 0,       
                                       // 2t timing for unbuffered dimms.
   parameter ODT_TYPE                = 1,       
                                       // ODT (=0(none),=1(75),=2(150),=3(50)).
   parameter REDUCE_DRV              = 0,       
                                       // reduced strength mem I/O (=1 yes).
   parameter REG_ENABLE              = 0,       
                                       // registered addr/ctrl (=1 yes).
   parameter TREFI_NS                = 7800,       
                                       // auto refresh interval (ns).
   parameter TRAS                    = 40000,       
                                       // active->precharge delay.
   parameter TRCD                    = 15000,       
                                       // active->read/write delay.
   parameter TRFC                    = 127500,       
                                       // refresh->refresh, refresh->active delay.
   parameter TRP                     = 15000,       
                                       // precharge->command delay.
   parameter TRTP                    = 7500,       
                                       // read->precharge delay.
   parameter TWR                     = 15000,       
                                       // used to determine write->precharge.
   parameter TWTR                    = 7500,       
                                       // write->read delay.
   parameter HIGH_PERFORMANCE_MODE   = "TRUE",       
                              // # = TRUE, the IODELAY performance mode is set
                              // to high.
                              // # = FALSE, the IODELAY performance mode is set
                              // to low.
   parameter SIM_ONLY                = 0,       
                                       // = 1 to skip SDRAM power up delay.
   parameter DEBUG_EN                = 0,       
                                       // Enable debug signals/controls.
                                       // When this parameter is changed from 0 to 1,
                                       // make sure to uncomment the coregen commands
                                       // in ise_flow.bat or create_ise.bat files in
                                       // par folder.
   parameter CLK_PERIOD              = 8000,       
                                       // Core/Memory clock period (in ps).
   parameter DLL_FREQ_MODE           = "HIGH",       
                                       // DCM Frequency range.
   parameter CLK_TYPE                = "SINGLE_ENDED",       
                                       // # = "DIFFERENTIAL " ->; Differential input clocks ,
                                       // # = "SINGLE_ENDED" -> Single ended input clocks.
   parameter NOCLK200                = 0,       
                                       // clk200 enable and disable.
   parameter RST_ACT_LOW             = 1        
                                       // =1 for active low reset, =0 for active high.



)(

  // input
   
	input                                      clk_in ,
	input                                      reset_n,
	
	
	
  
  
  
  
//output
    output                                  dout_vd    ,
   output  [DATA_WIDTH-1 :0]               data_out   , 
   output                                  phy_init_done,




  

//ddr2_interface
  
     

//led

     output                               data_error ,
     output  reg  [3:0]                   sys_clk_led
	  



    );


  

   localparam DEVICE_WIDTH            = 16;             // Memory device data width
   localparam real CLK_PERIOD_NS      = CLK_PERIOD / 1000.0;
   localparam real TCYC_200           = 5.0;
   localparam real TPROP_DQS          = 0.01;  // Delay for DQS signal during Write Operation
   localparam real TPROP_DQS_RD       = 0.01;  // Delay for DQS signal during Read Operation
   localparam real TPROP_PCB_CTRL     = 0.01;  // Delay for Address and Ctrl signals
   localparam real TPROP_PCB_DATA     = 0.01;  // Delay for data signal during Write operation
   localparam real TPROP_PCB_DATA_RD  = 0.01;  // Delay for data signal during Read operation



   //wire
	
	
   wire                           clk_50   ;
   wire                           clk_100  ;
   wire	                         clk_125  ;
 	wire                           clk_200  ;
	wire                           clk_buf_125 ;
	wire                           clk_buf_200 ;
	wire                           clk_i_buf_200;
	wire                           clk_i_buf_125;
	wire                           locked   ;

	
	wire                           phy_init_done_reg ;
	
	wire                           wr_en    ;
	wire                           rd_en    ;
	
	wire    [31:0]                  data_in ;
   
               

  
	wire    [35 : 0]                CONTROL0 ;

  
  
  wire     [3:0]                   trig0   ;  



//new

  reg     [CLK_WIDTH-1:0]                     ddr2_clk_sdram ;
  reg      [CLK_WIDTH-1:0]                    ddr2_clk_n_sdram;
  reg     [CKE_WIDTH-1:0]                     ddr2_cke_sdram ;
  reg     [CS_WIDTH-1:0]                      ddr2_cs_n_sdram;
  reg                                         ddr2_ras_n_sdram;
  reg                                         ddr2_cas_n_sdram;
  reg                                         ddr2_we_n_sdram;
  reg       [DM_WIDTH-1:0]                    ddr2_dm_sdram_tmp;
  reg       [BANK_WIDTH-1:0]                  ddr2_ba_sdram;
  reg       [ROW_WIDTH-1:0]                   ddr2_address_sdram;
 // reg       [DQ_WIDTH-1:0]                    ddr2_dq_sdram;
 // reg       [DQS_WIDTH-1:0]                   ddr2_dqs_sdram;
 // reg       [DQS_WIDTH-1:0]                   ddr2_dqs_n_sdram;
  reg       [ODT_WIDTH-1:0]                   ddr2_odt_sdram;
  
  wire                                         soft_rst_n    ;     
  
  
  
  
   wire [DQ_WIDTH-1:0]          ddr2_dq_sdram;
   wire [DQS_WIDTH-1:0]         ddr2_dqs_sdram;
   wire [DQS_WIDTH-1:0]         ddr2_dqs_n_sdram;
   wire [DM_WIDTH-1:0]          ddr2_dm_sdram;
  
  
  
  
  
  
  
   wire [DQ_WIDTH-1:0]          ddr2_dq_fpga;
   wire [DQS_WIDTH-1:0]         ddr2_dqs_fpga;
   wire [DQS_WIDTH-1:0]         ddr2_dqs_n_fpga;
   wire [DM_WIDTH-1:0]          ddr2_dm_fpga;
   wire [CLK_WIDTH-1:0]         ddr2_clk_fpga;
   wire [CLK_WIDTH-1:0]         ddr2_clk_n_fpga;
   wire [ROW_WIDTH-1:0]         ddr2_address_fpga;
   wire [BANK_WIDTH-1:0]        ddr2_ba_fpga;
   wire                         ddr2_ras_n_fpga;
   wire                         ddr2_cas_n_fpga;
   wire                         ddr2_we_n_fpga;
   wire [CS_WIDTH-1:0]          ddr2_cs_n_fpga;
   wire [CKE_WIDTH-1:0]         ddr2_cke_fpga;
   wire [ODT_WIDTH-1:0]         ddr2_odt_fpga; 
  
  
  
  

	      
	wire [ROW_WIDTH-1:0]           ddr2_address_reg;
  wire [BANK_WIDTH-1:0]          ddr2_ba_reg;
  wire [CKE_WIDTH-1:0]           ddr2_cke_reg;
  wire                           ddr2_ras_n_reg;
  wire                           ddr2_cas_n_reg;
  wire                           ddr2_we_n_reg;
  wire [CS_WIDTH-1:0]            ddr2_cs_n_reg;
  wire [ODT_WIDTH-1:0]           ddr2_odt_reg;
		   
           
	       
	 
 wire   [DO_WIDTH-1:0]                           din_fifo    ;
 wire                                            din_fifo_vd ;      
 wire                                            wr_fifo_rd  ;              
	           
 wire                                            almost_full_wr  ;
 wire                                            almost_empty_wr ;
 wire                                            prog_full_wr    ;
 wire                                            prog_empty_wr   ;
 wire   [DO_WIDTH-1:0]                            wr_fifo_out  ;
 wire                                             wr_fifo_vd   ;	               
 wire                                            app_wdf_afull;
 wire                                            app_af_afull ;	            

 
 wire                                            app_wdf_wren ;
 wire                                            app_af_wren  ;
 wire  [30:0]                                    app_af_addr  ;
 wire  [2:0]                                     app_af_cmd   ;
 wire   [(APPDATA_WIDTH)-1:0]                    app_wdf_data ;
	            
 wire                                            rd_data_valid    ;
 wire [(APPDATA_WIDTH)-1:0]                      rd_data_fifo_out ;
 wire [(APPDATA_WIDTH)-1:0]                      rd_fifo_out      ;
 wire                                            fifo_out_vd      ;              	      
	
wire                                             clk_ddr_rst    ;
wire                                             clk_ddr_out    ;
wire                                             phy_done_rd    ;
wire                                              empty_fifo16   ;
	           

reg                                            phy_init_done_reg_0 ;
reg                                            phy_init_done_reg_1 ;



wire                                               rst0_tb     ;
wire                          				             clk0_tb     ;



wire    [31:0]                                     src_dout   ;
wire                                               src_valid  ;


 // assign           soft_rst_n    =   (!reset_n)?   0:  (locked  ?   1: soft_rst_n )  ;


  
   
   
   
   
 //  always@( posedge clk_in   or   negedge reset_n )
 //  begin
    
  //    if  (!reset_n)
 //            soft_rst_n   <=  0 ;
 //            
  //   else if (locked)
       
  //        soft_rst_n   <=  1   ;
  //   else
     
  //       soft_rst_n   <=  soft_rst_n  ;
     
      
   
 //  end 
   
   
   
   
   

   assign      phy_init_done   =    phy_init_done_reg     ;



//  new    trig 


 
 







fifo_clk          fifo_clk   (
     
       .rst(!locked),
       .wr_clk(clk0_tb ),
       .rd_clk(clk0_tb ),
       .din(phy_init_done_reg),
       .wr_en(phy_init_done_reg),
       .rd_en(!empty_fifo16),
       .dout(phy_done_rd),
       .full(),
       .empty(empty_fifo16),
       .valid()
   
);










 

   always@(posedge  clk0_tb     or   negedge   locked )
	
	begin
	  
	  if (!locked)
	     
	           sys_clk_led      <=    4'b1111   ;
				  
		else
		    begin
		 
          if  (phy_init_done_reg)
			   
       	  sys_clk_led         <=    4'b1010   ;	
			  
			  else
			   
	         sys_clk_led        <=  0       ;
	       end 
	
	end 
	
	
	









   






   pll_gen       pll_gen    (
   
                 .CLKIN1_IN(clk_in), 
                 .RST_IN(!reset_n), 
                 .CLKOUT0_OUT(clk_50), 
                 .CLKOUT1_OUT(clk_100), 
                 .CLKOUT2_OUT(clk_125), 
                 .CLKOUT3_OUT(clk_200), 
                 .LOCKED_OUT(locked)

  );








  












 din_gen         din_gen   (
 
 //input
      . reset_n (locked),
      . clk (clk0_tb),
   	  .phy_init_done(phy_done_rd),
 
 //output
 
     .wr_en (wr_en),
	  .rd_en (rd_en),
	  .dout  (data_in)
 
 
   );




 


data_format_in    #(
	    
		   .DI_WIDTH(DATA_WIDTH),
	      .DO_WIDTH(DO_WIDTH)
	 
	 
	 
	    )  data_format_in  (
	
	  //input
	        .clk (clk0_tb),
	        .reset(!locked),
			  .data_in(data_in),
	        .din_valid(wr_en),
			 
			    
	//output
	      .dout (din_fifo),
		   .dout_vd(din_fifo_vd)
			  	
	
	) ;








wr_fifo    # (
         .DATA_WIDTH(DO_WIDTH),
			.WRITE_BURST (BURST_LEN)
      
  
        )   wr_fifo_module    (
	

  // input	
		  .wr_clk  (clk0_tb),
		  .rd_clk  (clk0_tb),
		  .reset   (!locked),
		  .data_in (din_fifo),
		  .wr_fifo (din_fifo_vd),
		  .rd_fifo (wr_fifo_rd),
        .CONTROL (),  		  
		  
//output	
       .rd_data_count( ),
       .wr_data_count( ),
	    .almost_full  (almost_full_wr)  ,
       .almost_empty (almost_empty_wr) ,
		 .prog_full    (prog_full_wr),
       .prog_empty   (prog_empty_wr),
       .data_out     ( wr_fifo_out) ,
	    .dout_vd      ( wr_fifo_vd)
		  
		  
		  ) ;  







fifo_control   # (
      .DATA_WIDTH(DO_WIDTH),
      .WRITE_BURST(BURST_LEN),
		.COL_WIDTH(COL_WIDTH) ,
      .ROW_WIDTH(ROW_WIDTH),
      .BANK_WIDTH(BANK_WIDTH)  
 
 
 )  fifo_control  (
 
 //input
     .sys_clk      (clk0_tb ),
     .reset        (!locked),
     .data_in_vd   (din_fifo_vd),
	   .almost_full  (almost_full_wr)  ,
     .almost_empty (almost_empty_wr) ,
	   .prog_full    (prog_full_wr),
     .prog_empty   (prog_empty_wr),
     .phy_init_done(phy_init_done_reg),
	   
	   
     .app_wdf_afull(app_wdf_afull),
     .app_af_afull (app_af_afull),
     .rd_en        (rd_en),
     .wr_fifo_in   (wr_fifo_out),
     .wr_fifo_vd   (wr_fifo_vd),	  
 
 
 //output
 
    .wr_fifo_rd (wr_fifo_rd),
 
   .app_wdf_wren(app_wdf_wren),
   .app_af_wren(app_af_wren),
   .app_af_addr(app_af_addr),
   .app_af_cmd(app_af_cmd) ,
 
   .app_wdf_data(app_wdf_data)
	
  

 
 );












 rd_fifo   # (  
	      .DATA_WIDTH(DO_WIDTH),
			.WRITE_BURST (BURST_LEN)
	 
	 
	 )  rd_fifo_module(
	
// input	
	   .wr_clk 		(clk0_tb),
		.rd_clk 		(clk0_tb),
		.reset      (!locked),
		.rd_fifo_in (rd_data_fifo_out),
		.rd_fifo_vd	(rd_data_valid),
		.rd_en 		(rd_en),
		.CONTROL      (),
		
 //output
      .full        (),
		.almost_full () ,
      .empty       (),
	   .almost_empty (),
      .rd_fifo_out (rd_fifo_out),
		.fifo_out_vd (fifo_out_vd)
		
	 
	 
	 
	 );







data_format_out    # (
	
	   .DI_WIDTH (DO_WIDTH),
		.DO_WIDTH (DATA_WIDTH)
	
	
	
	  ) data_format_out (
	  
//input
       .clk    (clk0_tb),
		 .reset  (!locked),
		 .data_in(rd_fifo_out),
		 .din_vd (fifo_out_vd),
		 
//output
   	.data_out(data_out),
      .dout_vd (dout_vd)		
	  	  
	  
	  );





data_gen_src      data_gen_src   (

   .rst(!locked),
   .wr_clk(clk0_tb),
   .rd_clk(clk0_tb),
   .din   (data_in),
   .wr_en (wr_en),
   .rd_en (dout_vd),
   .dout   (src_dout),
   .full(),
   .empty(),
   .valid(src_valid)


);



compare_data   compare_data  (

       .sys_clk(clk0_tb)      ,
       .reset	(!locked)       ,
       .data_in	(src_dout)     ,
       .din_vd(src_valid)       ,
			 .dout_fifo(data_out)    ,
			 .dout_vd (dout_vd)     ,

			
    
	 
 //output
 
     .data_error( data_error)     





);





















ddr_sdram #
  (
            .BANK_WIDTH(BANK_WIDTH),       
                                       // # of memory bank addr bits.
            .CKE_WIDTH(CKE_WIDTH),       
                                       // # of memory clock enable outputs.
            .CLK_WIDTH(CLK_WIDTH),       
                                       // # of clock outputs.
            .COL_WIDTH(COL_WIDTH),       
                                       // # of memory column bits.
            .CS_NUM(CS_NUM),       
                                       // # of separate memory chip selects.
            .CS_WIDTH(CS_WIDTH),       
                                       // # of total memory chip selects.
            .CS_BITS(CS_BITS),       
                                       // set to log2(CS_NUM) (rounded up).
            .DM_WIDTH(DM_WIDTH),       
                                       // # of data mask bits.
            .DQ_WIDTH(DQ_WIDTH),       
                                       // # of data width.
            .DQ_PER_DQS(DQ_PER_DQS),       
                                       // # of DQ data bits per strobe.
            .DQS_WIDTH(DQS_WIDTH),       
                                       // # of DQS strobes.
            .DQ_BITS(DQ_BITS),       
                                       // set to log2(DQS_WIDTH*DQ_PER_DQS).
            .DQS_BITS(DQS_BITS),       
                                       // set to log2(DQS_WIDTH).
            .ODT_WIDTH(ODT_WIDTH),       
                                       // # of memory on-die term enables.
            .ROW_WIDTH(ROW_WIDTH),       
                                       // # of memory row and # of addr bits.
            .ADDITIVE_LAT(ADDITIVE_LAT),       
                                       // additive write latency.
            .BURST_LEN(BURST_LEN),       
                                       // burst length (in double words).
            .BURST_TYPE(BURST_TYPE),       
                                       // burst type (=0 seq; =1 interleaved).
            .CAS_LAT(CAS_LAT),       
                                       // CAS latency.
            .ECC_ENABLE(ECC_ENABLE),       
                                       // enable ECC (=1 enable).
            .APPDATA_WIDTH(APPDATA_WIDTH),       
                                       // # of usr read/write data bus bits.
            .MULTI_BANK_EN(MULTI_BANK_EN),       
                                       // Keeps multiple banks open. (= 1 enable).
            .TWO_T_TIME_EN(TWO_T_TIME_EN),       
                                       // 2t timing for unbuffered dimms.
			    	.ODT_TYPE(ODT_TYPE),       
                                       // ODT (=0(none),=1(75),=2(150),=3(50)).
            .REDUCE_DRV(REDUCE_DRV),       
                                       // reduced strength mem I/O (=1 yes).
            .REG_ENABLE(REG_ENABLE),       
                                       // registered addr/ctrl (=1 yes).
            .TREFI_NS(TREFI_NS),       
                                       // auto refresh interval (ns).
            .TRAS(TRAS),       
                                       // active->precharge delay.
            .TRCD(TRCD) ,                        
                                       // active->read/write delay.
            .TRFC(TRFC),       
                                       // refresh->refresh, refresh->active delay.
            .TRP(TRP),       
                                       // precharge->command delay.
            .TRTP(TRTP),       
                                       // read->precharge delay.
            .TWR(TWR),       
                                       // used to determine write->precharge.
            .TWTR(TWTR),       
                                       // write->read delay.
            .HIGH_PERFORMANCE_MODE(HIGH_PERFORMANCE_MODE),       
                              // # = TRUE, the IODELAY performance mode is set
                              // to high.
                              // # = FALSE, the IODELAY performance mode is set
                              // to low.
            .SIM_ONLY(SIM_ONLY),       
                                       // = 1 to skip SDRAM power up delay.
            .DEBUG_EN(DEBUG_EN),       
                                       // Enable debug signals/controls.
                                       // When this parameter is changed from 0 to 1,
                                       // make sure to uncomment the coregen commands
                                       // in ise_flow.bat or create_ise.bat files in
                                       // par folder.
            .CLK_PERIOD(CLK_PERIOD),       
                                       // Core/Memory clock period (in ps).
            .DLL_FREQ_MODE(DLL_FREQ_MODE),       
                
                                       // DCM Frequency range.
            .CLK_TYPE (CLK_TYPE),       
                                       // # = "DIFFERENTIAL " ->; Differential input clocks ,
                                       // # = "SINGLE_ENDED" -> Single ended input clocks.
            .NOCLK200(NOCLK200),       
                                       // clk200 enable and disable.
            .RST_ACT_LOW(RST_ACT_LOW)       
                                       // =1 for active low reset, =0 for active high.
   )  ddr_sdram  (
	
            .ddr2_dq(ddr2_dq_fpga),
            .ddr2_a(ddr2_address_fpga),
            .ddr2_ba(ddr2_ba_fpga),
            .ddr2_ras_n(ddr2_ras_n_fpga),
            .ddr2_cas_n(ddr2_cas_n_fpga),
            .ddr2_we_n(ddr2_we_n_fpga),
            .ddr2_cs_n(ddr2_cs_n_fpga),
            .ddr2_odt(ddr2_odt_fpga),
            .ddr2_cke(ddr2_cke_fpga),
            .ddr2_dm(ddr2_dm_fpga),                      //  new   add  
            .sys_clk(clk_125),
            .idly_clk_200(clk_200),
				    .sys_rst_n(soft_rst_n),
				    .phy_init_done(phy_init_done_reg),
				    .rst0_tb(rst0_tb),
				    .clk0_tb(clk0_tb),
				
				   .app_wdf_afull(app_wdf_afull),
				   .app_af_afull(app_af_afull),
				   .rd_data_valid(rd_data_valid),
				   .app_wdf_wren(app_wdf_wren),
				   .app_af_wren(app_af_wren),
			   	.app_af_addr(app_af_addr),
			  	.app_af_cmd(app_af_cmd),
				  .rd_data_fifo_out(rd_data_fifo_out),
				  .app_wdf_data(app_wdf_data),
				   .app_wdf_mask_data(0),                                          //  new  add
			   	.ddr2_dqs(ddr2_dqs_fpga),
				  .ddr2_dqs_n(ddr2_dqs_n_fpga),
				  .ddr2_ck(ddr2_clk_fpga),
				 .ddr2_ck_n(ddr2_clk_n_fpga)
				
			
				
				
				
   );
               	       
          

















// =============================================================================
//                             BOARD Parameters
// =============================================================================
// These parameter values can be changed to model varying board delays
// between the Virtex-5 device and the memory model


  always @( * ) begin
    ddr2_clk_sdram        <=  #(TPROP_PCB_CTRL) ddr2_clk_fpga;
    ddr2_clk_n_sdram      <=  #(TPROP_PCB_CTRL) ddr2_clk_n_fpga;
    ddr2_address_sdram    <=  #(TPROP_PCB_CTRL) ddr2_address_fpga;
    ddr2_ba_sdram         <=  #(TPROP_PCB_CTRL) ddr2_ba_fpga;
    ddr2_ras_n_sdram      <=  #(TPROP_PCB_CTRL) ddr2_ras_n_fpga;
    ddr2_cas_n_sdram      <=  #(TPROP_PCB_CTRL) ddr2_cas_n_fpga;
    ddr2_we_n_sdram       <=  #(TPROP_PCB_CTRL) ddr2_we_n_fpga;
    ddr2_cs_n_sdram       <=  #(TPROP_PCB_CTRL) ddr2_cs_n_fpga;
    ddr2_cke_sdram        <=  #(TPROP_PCB_CTRL) ddr2_cke_fpga;
    ddr2_odt_sdram        <=  #(TPROP_PCB_CTRL) ddr2_odt_fpga;
    ddr2_dm_sdram_tmp     <=  #(TPROP_PCB_DATA) ddr2_dm_fpga;//DM signal generation
  end



assign ddr2_dm_sdram = ddr2_dm_sdram_tmp;



// Controlling the bi-directional BUS
  genvar dqwd;
  generate
    for (dqwd = 0;dqwd < DQ_WIDTH;dqwd = dqwd+1) begin : dq_delay
      WireDelay #
       (
        .Delay_g     (TPROP_PCB_DATA),
        .Delay_rd    (TPROP_PCB_DATA_RD)
       )
      u_delay_dq
       (
        .A           (ddr2_dq_fpga[dqwd]),
        .B           (ddr2_dq_sdram[dqwd]),
        .reset       (reset_n)
       );
    end
  endgenerate

  genvar dqswd;
  generate
    for (dqswd = 0;dqswd < DQS_WIDTH;dqswd = dqswd+1) begin : dqs_delay
      WireDelay #
       (
        .Delay_g     (TPROP_DQS),
        .Delay_rd    (TPROP_DQS_RD)
       )
      u_delay_dqs
       (
        .A           (ddr2_dqs_fpga[dqswd]),
        .B           (ddr2_dqs_sdram[dqswd]),
        .reset       (reset_n)
       );

      WireDelay #
       (
        .Delay_g     (TPROP_DQS),
        .Delay_rd    (TPROP_DQS_RD)
       )
      u_delay_dqs_n
       (
        .A           (ddr2_dqs_n_fpga[dqswd]),
        .B           (ddr2_dqs_n_sdram[dqswd]),
        .reset       (reset_n)
       );
    end
  endgenerate









//***************************************************************************
   // Memory model instances
   //***************************************************************************
   genvar i, j;
   generate
      if (DEVICE_WIDTH == 16) begin
         // if memory part is x16
       
             // if the memory part is component or unbuffered DIMM
            if ( DQ_WIDTH%16 ) begin
              // for the memory part x16, if the data width is not multiple
              // of 16, memory models are instantiated for all data with x16
              // memory model and except for MSB data. For the MSB data
              // of 8 bits, all memory data, strobe and mask data signals are
              // replicated to make it as x16 part. For example if the design
              // is generated for data width of 72, memory model x16 parts
              // instantiated for 4 times with data ranging from 0 to 63.
              // For MSB data ranging from 64 to 71, one x16 memory model
              // by replicating the 8-bit data twice and similarly
              // the case with data mask and strobe.
              for(j = 0; j < CS_NUM; j = j+1) begin : gen_cs
                for(i = 0; i < DQ_WIDTH/16 ; i = i+1) begin : gen
                   ddr2_model u_mem0
                     (
                      .ck        (ddr2_clk_sdram[i]),
                     .ck_n      (ddr2_clk_n_sdram[i]),
                      .cke       (ddr2_cke_sdram[j]),
                      .cs_n      (ddr2_cs_n_sdram[(j*(CS_WIDTH/CS_NUM))+i]),
                      .ras_n     (ddr2_ras_n_sdram),
                      .cas_n     (ddr2_cas_n_sdram),
                      .we_n      (ddr2_we_n_sdram),
                      .dm_rdqs   (ddr2_dm_sdram[(2*(i+1))-1 : i*2]),
                      .ba        (ddr2_ba_sdram),
                      .addr      (ddr2_address_sdram),
                      .dq        (ddr2_dq_sdram[(16*(i+1))-1 : i*16]),
                      .dqs       (ddr2_dqs_sdram[(2*(i+1))-1 : i*2]),
                      .dqs_n     (ddr2_dqs_n_sdram[(2*(i+1))-1 : i*2]),
                      .rdqs_n    (),
                      .odt       (ddr2_odt_sdram[i])
                      );
                end
                   ddr2_model u_mem1
                     (
                      .ck        (ddr2_clk_sdram[CLK_WIDTH-1]),
                      .ck_n      (ddr2_clk_n_sdram[CLK_WIDTH-1]),
                      .cke       (ddr2_cke_sdram[j]),
                      .cs_n      (ddr2_cs_n_sdram[CS_WIDTH-1]),
                      .ras_n     (ddr2_ras_n_sdram),
                      .cas_n     (ddr2_cas_n_sdram),
                      .we_n      (ddr2_we_n_sdram),
                      .dm_rdqs   ({ddr2_dm_sdram[DM_WIDTH - 1],
                                   ddr2_dm_sdram[DM_WIDTH - 1]}),
                      .ba        (ddr2_ba_sdram),
                      .addr      (ddr2_address_sdram),
                      .dq        ({ddr2_dq_sdram[DQ_WIDTH - 1 : DQ_WIDTH - 8],
                                   ddr2_dq_sdram[DQ_WIDTH - 1 : DQ_WIDTH - 8]}),
                      .dqs       ({ddr2_dqs_sdram[DQS_WIDTH - 1],
                                   ddr2_dqs_sdram[DQS_WIDTH - 1]}),
                      .dqs_n     ({ddr2_dqs_n_sdram[DQS_WIDTH - 1],
                                   ddr2_dqs_n_sdram[DQS_WIDTH - 1]}),
                      .rdqs_n    (),
                      .odt       (ddr2_odt_sdram[ODT_WIDTH-1])
                      );
              end
            end
            else begin
              // if the data width is multiple of 16
              for(j = 0; j < CS_NUM; j = j+1) begin : gen_cs
                for(i = 0; i < CS_WIDTH/CS_NUM; i = i+1) begin : gen
                   ddr2_model u_mem0
                     (
                      .ck        (ddr2_clk_sdram[i]),
                     .ck_n      (ddr2_clk_n_sdram[i]),
                      .cke       (ddr2_cke_sdram[j]),
                      .cs_n      (ddr2_cs_n_sdram[(j*(CS_WIDTH/CS_NUM))+i]),
                      .ras_n     (ddr2_ras_n_sdram),
                      .cas_n     (ddr2_cas_n_sdram),
                      .we_n      (ddr2_we_n_sdram),
                      .dm_rdqs   (ddr2_dm_sdram[(2*(i+1))-1 : i*2]),
                      .ba        (ddr2_ba_sdram),
                      .addr      (ddr2_address_sdram),
                      .dq        (ddr2_dq_sdram[(16*(i+1))-1 : i*16]),
                      .dqs       (ddr2_dqs_sdram[(2*(i+1))-1 : i*2]),
                      .dqs_n     (ddr2_dqs_n_sdram[(2*(i+1))-1 : i*2]),
                      .rdqs_n    (),
                      .odt       (ddr2_odt_sdram[i])
                      );
               
              end
            end
         end

      end else
        if (DEVICE_WIDTH == 8) begin
           
             // if the memory part is component or unbuffered DIMM
             for(j = 0; j < CS_NUM; j = j+1) begin : gen_cs
               for(i = 0; i < CS_WIDTH/CS_NUM; i = i+1) begin : gen
                  ddr2_model u_mem0
                    (
                     .ck        (ddr2_clk_sdram[i]),
                    .ck_n      (ddr2_clk_n_sdram[i]),
                     .cke       (ddr2_cke_sdram[j]),
                     .cs_n      (ddr2_cs_n_sdram[(j*(CS_WIDTH/CS_NUM))+i]),
                     .ras_n     (ddr2_ras_n_sdram),
                     .cas_n     (ddr2_cas_n_sdram),
                     .we_n      (ddr2_we_n_sdram),
                     .dm_rdqs   (ddr2_dm_sdram[i]),
                     .ba        (ddr2_ba_sdram),
                     .addr      (ddr2_address_sdram),
                     .dq        (ddr2_dq_sdram[(8*(i+1))-1 : i*8]),
                     .dqs       (ddr2_dqs_sdram[i]),
                     .dqs_n     (ddr2_dqs_n_sdram[i]),
                     .rdqs_n    (),
                     .odt       (ddr2_odt_sdram[i])
                     );
              
             end
           end

        end else
          if (DEVICE_WIDTH == 4) begin
             // if the memory part is x4
             
               // if the memory part is component or unbuffered DIMM
               for(j = 0; j < CS_NUM; j = j+1) begin : gen_cs
                 for(i = 0; i < CS_WIDTH/CS_NUM; i = i+1) begin : gen
                    ddr2_model u_mem0
                      (
                       .ck        (ddr2_clk_sdram[i]),
                      .ck_n      (ddr2_clk_n_sdram[i]),
                       .cke       (ddr2_cke_sdram[j]),
                       .cs_n      (ddr2_cs_n_sdram[(j*(CS_WIDTH/CS_NUM))+i]),
                       .ras_n     (ddr2_ras_n_sdram),
                       .cas_n     (ddr2_cas_n_sdram),
                       .we_n      (ddr2_we_n_sdram),
                       .dm_rdqs   (ddr2_dm_sdram[i]),
                       .ba        (ddr2_ba_sdram),
                       .addr      (ddr2_address_sdram),
                       .dq        (ddr2_dq_sdram[(4*(i+1))-1 : i*4]),
                       .dqs       (ddr2_dqs_sdram[i]),
                       .dqs_n     (ddr2_dqs_n_sdram[i]),
                       .rdqs_n    (),
                       .odt       (ddr2_odt_sdram[i])
                       );
               
               end
             end
          end
   endgenerate
 























endmodule
