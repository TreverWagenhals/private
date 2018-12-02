// --------------------------------------------------------------------------
// 
// Copyright (c) 2014, NVIDIA Corp.
// All Rights Reserved.
// 
// This is UNPUBLISHED PROPRIETARY SOURCE CODE of NVIDIA Corp.;
// the contents of this file may not be disclosed to third parties, copied or
// duplicated in any form, in whole or in part, without the prior written
// permission of NVIDIA Corp.
// 
// RESTRICTED RIGHTS LEGEND:
// Use, duplication or disclosure by the Government is subject to restrictions
// as set forth in subdivision (c)(1)(ii) of the Rights in Technical Data
// and Computer Software clause at DFARS 252.227-7013, and/or in similar or
// successor clauses in the FAR, DOD or NASA FAR Supplement. Unpublished -
// rights reserved under the Copyright Laws of the United States.
// 
// --------------------------------------------------------------------------

//#######################################################################
//    Include Files From Ness
//#######################################################################


//--------------------------------------------------------
// Pull out all of the Vars we need and get them into Perl
//--------------------------------------------------------		     
&PerlBeg;
  
  #-------------------------------
  #  Project.h 
  #-------------------------------
  vcp_read_defines("project.h");
  our $NV_NVL_IOCTRL_NUM_LINKS = vcp_define("NV_NVL_IOCTRL_NUM_LINKS");

&PerlEnd;		     

		     
//#######################################################################
//   Viva Required Calls 
//#######################################################################
&Viva width_learning_on;
	     
//#######################################################################
//    Module Declaration  
//#######################################################################

&Module;

&Ports;
//#######################################################################
//    Port, Wire and Register Declaration  
//#######################################################################

//-------------------------------
//   Module Ports 
//-------------------------------
   //------------------------------------------------
   //	Clocks 
   //------------------------------------------------

	input 		nvlipt_ctl_clk;				
	 
	input           tmc2slcg_disable_clock_gating; 



   //------------------------------------------------
   //	Resets  
   //------------------------------------------------

   	input 		ioctrl_warm_reset_n; 		
 	input 		ioctrl_cold_reset_n; 	  

  // Discovery Table Personality pins
      
  input [7:0]      discovery_unicast_base;
  input [3:0]      discovery_table_instance_number; 
   //------------------------------------------------
   //	NESS Interfaces   
   //------------------------------------------------
 
    	#include "NV_IOCTRL_CTRL_pri_hookup.vxh"      

   //------------------------------------------------
   //	Perlink Resets
   //------------------------------------------------



   //------------------------------------------------
   //	Interrupts to host 
   //------------------------------------------------
 	       
	output  ioctrl2retimer_nvlink2host_intr_nostall;  
	output  ioctrl2retimer_nvlink2host_intr_stall;    
		 
 
 
   //--------------------------------------------------
   //	Clock Disable Registers 
   //--------------------------------------------------

 &PerlBeg;


  for my $i (0..$NV_NVL_IOCTRL_NUM_LINKS-1) { 

    vprintl qq { 
    
   //----------- 
   // Disables
   //-----------

	output nvlink${i}_clk_disable;
	
     };		
   
   }  
&PerlEnd;  



    
 
  //--------------------------------------------------------
  // Fuses
  //--------------------------------------------------------
  input [NV_NVL_IOCTRL_NUM_LINKS-1:0]  level2ioctrl_fs2all_per_link_disable; 
  input [7:0]  level2ioctrl_opt_secure_nvlink_mask_wr_secure; 


   //--------------------------------------------------------
   // IOCTRL SYS Perfmon controls
   //--------------------------------------------------------


   output [7:0]       debug_mux_select_m1select0;
   output [7:0]       debug_mux_select_m1select1;
   output [7:0]       debug_mux_select_m1select2;
   output [7:0]       debug_mux_select_m1select3;
   output 	      debug_mux_ctrl_watchbusenable;
   output [3:0]       debug_mux_ctrl_group252;
   output [3:0]       debug_mux_ctrl_group253;
   output [3:0]       debug_mux_ctrl_group254;
   output [3:0]       debug_mux_ctrl_group255;

   //--------------------------------------
   // Perfmon
   //-------------------------------------
   output perfmon_priv_updated;
   output perfmon_priv_rdupdate;
 
 
   //--------------------------------------
   // Connection to PLL Block in NVLPCTL
   //-------------------------------------
 
  output         master2pll_pri_req;
  output  [10:0] master2pll_pri_adr;
  output   [1:0] master2pll_pri_priv_level;
  output   [4:0] master2pll_pri_source_id;
  output  [31:0] master2pll_pri_wrdat;
  output         master2pll_pri_write;
   
  input        master2pll_pri_ack;
  input        master2pll_pri_error;
  input [31:0] master2pll_pri_rdat; 

output [NV_NVL_IOCTRL_NUM_LINKS-1:0] pre_sw_current_disabled_links_sync;
input [NV_NVL_IOCTRL_NUM_LINKS-1:0]  current_disabled_links; 

//-------------------------------
//   Module Wires
//------------------------------
    wire [31:0] level2ioctrl_pri_adr; 

    
    &Wires; 
//-------------------------------
//   Module Registers
//-------------------------------
    &Regs;
     	
//-------------------------------
//  Vectors
//-------------------------------
&Vector 32 /_pri_rtn_rdat$/;
&Vector 32 /_pri_rdat$/;
&Vector 32 /_pri_wrdat$/;
&Vector 2  /_pri_priv_level$/;
&Vector 5  /_pri_source_id$/;
  
  
//-------------------------------
//  Default Clock
//-------------------------------
&Clock nvlipt_ctl_clk;
   

    

//#######################################################################
//    Combinational Logic 
//#######################################################################

		      
 
	
//#######################################################################
//    Sequential Logic 
//#######################################################################


			      
//#######################################################################
//    Module Instantiations 
//#######################################################################

 //#####################################################################
// Convert the req-ack protocol to pvld  prdy protocol
// Dummy protocol conversion
//####################################################################

assign adjusted_fecs2ioctrl_pri_adr = {14'h0, level2ioctrl_pri_adr[17:0]}; 
assign adjusted_fecs2ioctrl_pri_adr_NC[13:0] = level2ioctrl_pri_adr[31:18]; 
&Force internal adjusted_fecs2ioctrl_pri_adr_NC;


&Instance NV_IOCTRL_CTRL_PRI_converter;
//Clocks and reset

&Connect nvlipt_ctl_clk nvlipt_ctl_clk;
&Connect ioctrl_warm_reset_n ioctrl_warm_reset_n;

//HOST side request attributes

&Connect pri_reqack_req 	level2ioctrl_pri_req;
&Connect pri_reqack_req_data   {adjusted_fecs2ioctrl_pri_adr, level2ioctrl_pri_wrdat, level2ioctrl_pri_write,
level2ioctrl_pri_priv_level, level2ioctrl_pri_source_id};

// Host side response 
&Connect pri_reqack_ack      ioctrl2level_pri_ack;
&Connect pri_reqack_ack_data {ioctrl2level_pri_rdat, ioctrl2level_pri_error};

// Request to PRI Router
&Connect slv_req_vld		nvlipt_pri_pvld; // >> o
&Connect slv_req_rdy		nvlipt_pri_prdy; // <<i
&Connect slv_req_data           {nvlipt_pri_adr, nvlipt_pri_wrdat, nvlipt_pri_write,nvlipt_pri_priv_level,nvlipt_pri_source_id}; // >> o

// Response to PRI Router
&Connect slv_ack_vld		nvlipt_pri_rtn_valid; // <<i
&Terminate slv_ack_rdy  ;          
&Connect slv_ack_data		{nvlipt_pri_rtn_rdat, nvlipt_pri_rtn_error};

assign nvlipt_pri_ack_write = 1'b1; //Saw the MKPRIVBLK2 code


	    

   //--------------------------------------------------------
   //  Local IOCTRL PRI Register Block and Sub-PRI Router
   //--------------------------------------------------------
 	     
   NV_IOCTRL_CTRL_PRI_registers registers (
		      
		      //-----------------------------
		      //  Clocks and Resets
		      //-----------------------------  		
		      .nvlipt_ctl_clk  			 				(nvlipt_ctl_clk),
		      
		      .ioctrl_warm_reset_n 	 	 			(ioctrl_warm_reset_n),
		      .ioctrl_cold_reset_n			(ioctrl_cold_reset_n), 
		      
		      //-----------------------------
		      //  Host Side Interface
		      //-----------------------------  	
/*		      .fecs2ioctrl_pri_req				       (level2ioctrl_pri_req),
		      .fecs2ioctrl_pri_adr				       (level2ioctrl_pri_adr),
		      .fecs2ioctrl_pri_wrdat				       (level2ioctrl_pri_wrdat),
		      .fecs2ioctrl_pri_write				       (level2ioctrl_pri_write),
		      .fecs2ioctrl_pri_priv_level			       (level2ioctrl_pri_priv_level),
		      .fecs2ioctrl_pri_source_id			       (level2ioctrl_pri_source_id),

		      .ioctrl2fecs_pri_rdat				       (ioctrl2level_pri_rdat),
		      .ioctrl2fecs_pri_ack				       (ioctrl2level_pri_ack),
		      .ioctrl2fecs_pri_error				       (ioctrl2level_pri_error), 
*/		     
		      .ioctrl_pri_pvld					(ioctrl_pri_pvld),
  		      .ioctrl_pri_prdy					(ioctrl_pri_prdy), 
		      
  		      .ioctrl_pri_adr					(ioctrl_pri_adr),        	 
		      .ioctrl_pri_wrdat					(ioctrl_pri_wrdat),
  		      .ioctrl_pri_write					(ioctrl_pri_write),             
  		      .ioctrl_pri_priv_level				(ioctrl_pri_priv_level),             
  		      .ioctrl_pri_source_id				(ioctrl_pri_source_id),             

  		      .ioctrl_pri_ack_write				(ioctrl_pri_ack_write),

  		      .ioctrl_pri_rtn_valid				(ioctrl_pri_rtn_valid),
  		      .ioctrl_pri_rtn_error				(ioctrl_pri_rtn_error),
  		      .ioctrl_pri_rtn_rdat				(ioctrl_pri_rtn_rdat),
	

		       

 		      //-----------------------------
		      // To PLL 
		      //-----------------------------  	
  		      .subpri_pll_pri_pvld  			                (subpri_pll_pri_pvld),
  		      .subpri_pll_pri_prdy  			      	        (subpri_pll_pri_prdy), 
		      
  		      .subpri_pll_pri_adr				      	(subpri_pll_pri_adr),		 
		      .subpri_pll_pri_wrdat 			      	        (subpri_pll_pri_wrdat),
  		      .subpri_pll_pri_write 			      	        (subpri_pll_pri_write),		
  		      .subpri_pll_pri_priv_level			      	(subpri_pll_pri_priv_level),	     
  		      .subpri_pll_pri_source_id			      	        (subpri_pll_pri_source_id),	     

  		      .subpri_pll_pri_ack_write			      	        (subpri_pll_pri_ack_write),

  		      .subpri_pll_pri_rtn_valid			      	        (subpri_pll_pri_rtn_valid),
  		      .subpri_pll_pri_rtn_error			      	        (subpri_pll_pri_rtn_error),
  		      .subpri_pll_pri_rtn_rdat			      	        (subpri_pll_pri_rtn_rdat),

		      //-----------------------------------
		      // To Perfmon
		      //----------------------------------
                      .perfmon_priv_rdupdate						(perfmon_priv_rdupdate),    
  		      .perfmon_priv_updated					        (perfmon_priv_updated),     
	

  		      
   		      //------------------------------------------------
   		      // Errors and Interrupt lines 
   		      //------------------------------------------------
&PerlBeg;


  for my $i (0..$NV_NVL_IOCTRL_NUM_LINKS-1) { 

    vprintl qq {   
 
    		      .link${i}_err_fatal			       (link${i}_err_fatal), 
    		      .link${i}_err_nonfatal			       (link${i}_err_nonfatal), 
    		      .link${i}_err_correctable 		       (link${i}_err_correctable), 
		      
    		      .link${i}_intr_A    			       (link${i}_intr_0),  
    		      .link${i}_intr_B	         		       (link${i}_intr_1),  

  
     };		
   
   }  
&PerlEnd;  	       
		    

   		      .nvlipt_err_fatal			 		(nvlipt_err_fatal), 
    		      .nvlipt_err_nonfatal			 	(nvlipt_err_nonfatal), 
    		      .nvlipt_err_correctable		        	(nvlipt_err_correctable), 
		      
    		      .nvlipt_intr_A			        	(nvlipt_intr_0),  
    		      .nvlipt_intr_B			 	        (nvlipt_intr_1),         
  


   		     //--------------------------------------------------
   		     //      Clock Disable Registers 
  		     //--------------------------------------------------

&PerlBeg;


  for my $i (0..$NV_NVL_IOCTRL_NUM_LINKS-1) { 

    vprintl qq { 
    
   			//----------- 
   			// Disables
   			//-----------

			.nvlink${i}_clk_disable   		       	     (nvlink${i}_clk_disable),

     };		
   
   }  
&PerlEnd;  	
                        
		        	      
  		     //--------------------------------------------------
   		     // Fuse Ports 
  		     //--------------------------------------------------
		       .fs2all_per_link_disable				     (level2ioctrl_fs2all_per_link_disable), 
		       .opt_secure_nvlink_mask_wr_secure	             (level2ioctrl_opt_secure_nvlink_mask_wr_secure), 
 
 


			.pre_sw_current_disabled_links_sync		    (pre_sw_current_disabled_links_sync),
			.current_disabled_links				    (current_disabled_links),

      .discovery_unicast_base (discovery_unicast_base),
      .discovery_table_instance_number  (discovery_table_instance_number),
	      
   		      //------------------------------------------------------
   		      //      Control Register Outputs SYNC PRI Masters
   		      //------------------------------------------------------

&PerlBeg;

  my $loop_count = ($NV_NVL_IOCTRL_NUM_LINKS)-1;

  for my $i (0..$loop_count) { 


    vprintl qq {  
		// MIF has been removed
		// Code clean up
    	   	//       .config_${i}_fs_action   				(config_${i}_fs_action),
      	   	//       .config_${i}_timeout 					(config_${i}_timeout[17:0] ),
      	   	//       .config_${i}_reset_action				(config_${i}_reset_action),
 		      
    		    
     };		
   
   }  
&PerlEnd;  
		     //-------------------------------------------------
		     //  Control Registers for ASYCN PLL MASTER
		     //-------------------------------------------------
                    .pll_pri_master_smconfig_fs_action                 (pll_pri_master_smconfig_fs_action),
                    .pll_pri_master_smconfig_hold_clocks               (pll_pri_master_smconfig_hold_clocks[2:0]), 
                    .pll_pri_master_smconfig_reset_action              (pll_pri_master_smconfig_reset_action) ,    
                    .pll_pri_master_smconfig_setup_clocks              (pll_pri_master_smconfig_setup_clocks[2:0]),
                    .pll_pri_master_smconfig_timeout                   (pll_pri_master_smconfig_timeout[17:0]),    
                    .pll_pri_master_smconfig_wait_clocks               (pll_pri_master_smconfig_wait_clocks[2:0]),
    		    .pll_pri_clock_gating_cg1_slcg		       (pll_pri_clock_gating_cg1_slcg),
    



   		      //------------------------------------------------
   		      //    Multicast Registers
   		      //------------------------------------------------
   		      //------------------------------------------------
   		      //      Interrupts to host 
   		      //------------------------------------------------
 	             
		     .nvlink2host_intr_nostall				     (ioctrl2retimer_nvlink2host_intr_nostall),
		     .nvlink2host_intr_stall				     (ioctrl2retimer_nvlink2host_intr_stall),
		     
		     //--------------------------------------------------------
  		     // Clock Gating Registers 
  		     //--------------------------------------------------------
              
		     //--------------------------------------------------------
		     // Permon/debug control Registers 
		     //--------------------------------------------------------
		          

		     .debug_mux_select_m1select0(debug_mux_select_m1select0),
		     .debug_mux_select_m1select1(debug_mux_select_m1select1),
                     .debug_mux_select_m1select2(debug_mux_select_m1select2),
                     .debug_mux_select_m1select3(debug_mux_select_m1select3),

                     .debug_mux_ctrl_watchbusenable(debug_mux_ctrl_watchbusenable),
 
                     .debug_mux_ctrl_group252(debug_mux_ctrl_group252),
                     .debug_mux_ctrl_group253(debug_mux_ctrl_group253),
                     .debug_mux_ctrl_group254(debug_mux_ctrl_group254),
                     .debug_mux_ctrl_group255(debug_mux_ctrl_group255)


		      );		      
 




//----------------------------------------------------------------------------------------
// The SUBPRI from IOCTRL goes to PLL via a async master
// PLL is on a different clock
//---------------------------------------------------------------------------------------

&PerlBeg;
my $address_width = 10;

vprintl qq{
//----------------------------------------------
//   Asycnc  Master For SYS clk to ATALx4 CLK 
//--------------------------------------------      


   NV_NVLIPT_CMN_pri_async_master_strictsync     #(.PRI_ADDRESS_WIDTH(${address_width} + 1)) pll_master (
          
  //-----------------------------
  //  Clocks and Resets
  //-----------------------------          
  .master_clk_nobg      		(nvlipt_ctl_clk),            
  .master_reset_              		(ioctrl_warm_reset_n), 

  .client_clk_nobg      		(pllctl_clk),           
  .client_reset_            		(warm_reset_pllctlclk_sync_n), 


  //-----------------------------
  //  Clock Gating 
  //-----------------------------          
  .tmc2slcg_disable_clock_gating          (tmc2slcg_disable_clock_gating),  
  
  //-------------------------------------------------------
  // CYA CSR values for Given PRI Controlled 
  //-------------------------------------------------------
  .config_disable_slcg                  	(pll_pri_clock_gating_cg1_slcg),         

  .config_timeout                       	(pll_pri_master_smconfig_timeout[17:0]),            
  
  .config_fs_action           	 	        (pll_pri_master_smconfig_fs_action),
  .config_reset_action           		(pll_pri_master_smconfig_reset_action), 
  
  .config_hold_clocks          			(pll_pri_master_smconfig_hold_clocks[2:0] ),        
  .config_setup_clocks          		(pll_pri_master_smconfig_setup_clocks[2:0]),
  .config_wait_clocks         			(pll_pri_master_smconfig_wait_clocks[2:0]),               
      
  //-------------------------------------------------------
  // Fuse and Reset bits for the downstream target 
  //-------------------------------------------------------             
  .client_fused_away            (1'b0),         //Tied to zero can never have txclk without rxclk 
                      // Also Fused links will be handeled above at NVLIPT        

  //-------------------------------------------------------
  // Master Synchonous PRI Interface 
  //-------------------------------------------------------
  .master_pri_pvld        (subpri_pll_pri_pvld),
  .master_pri_prdy        (subpri_pll_pri_prdy),
  
  .master_pri_adr         (subpri_pll_pri_adr[${address_width}:0]),   
  .master_pri_wrdat       (subpri_pll_pri_wrdat),
  .master_pri_write       (subpri_pll_pri_write), 
  .master_pri_priv_level  (subpri_pll_pri_priv_level),   
  .master_pri_source_id   (subpri_pll_pri_source_id),    

  .master_pri_ack_write   (subpri_pll_pri_ack_write),

  .master_pri_rtn_vld     (subpri_pll_pri_rtn_valid),
  .master_pri_rtn_error   (subpri_pll_pri_rtn_error),
  .master_pri_rtn_rdat    (subpri_pll_pri_rtn_rdat),
    
  //-------------------------------------------------------
  // Client Asynchonous PRI Interface 
  //-------------------------------------------------------
  .client_pri_req             	(master2pll_pri_req),      
  .client_pri_adr             	(master2pll_pri_adr[${address_width}:0]),   
  .client_pri_wrdat             (master2pll_pri_wrdat),
  .client_pri_write             (master2pll_pri_write),                
  .client_pri_priv_level        (master2pll_pri_priv_level),
  .client_pri_source_id         (master2pll_pri_source_id),
  
  .client_pri_ack             	(master2pll_pri_ack),
  .client_pri_rdat            	(master2pll_pri_rdat),
  .client_pri_error             (master2pll_pri_error),

  //-------------------------------------------------------
  // Perf Mon signals 
  //-------------------------------------------------------
  .perfmon_client_pri_req     (),            //FIXME needs to go to perfmon    
  .perfmon_client_pri_write   (),                
  .perfmon_client_pri_ack     (),                
  .perfmon_client_pri_error   ()               
  
  
  );
  };
&PerlEnd; 

&EndModule;

