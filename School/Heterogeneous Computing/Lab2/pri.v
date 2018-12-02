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
//
// Description: 
// This module is a wrapper for the PRI,ERROR and RESET
// blocks of IOCTRL.implements the M2 and M3 muxes and the CDC control blocks.
// --------------------------------------------------------------------------
::directives;
#include "dev_nvlctrl_nvgpu.vh"
//#######################################################################
//    Include Files From Ness
//#######################################################################
#include "project.h"


//#######################################################################
//   Viva Required Calls 
//#######################################################################
&Viva width_learning_on;
#include "dev_x_nvlctrl.vh"

&Module;


//#######################################################################
//   Parameters 
//#######################################################################


//*************************************************************
//   Module Ports 
//*************************************************************

    //------------------------------------------------
    //   NESS Interfaces   
    //------------------------------------------------
 
    #ifndef NO_NESS_RTL_IO
        #include "NV_NVLCTRL_pri_io.v"      
    #endif

    //------------------------------------------------
    //   Inferred Ports 
    //------------------------------------------------
    &Force output /_int_status$/;
    &Ports;


    //--------------------------------------
    // Connection to PLL Block in NVLPCTL
    //-------------------------------------
 
    output        master2pll_pri_req;
    output [10:0] master2pll_pri_adr;
    output  [1:0] master2pll_pri_priv_level;
    output  [4:0] master2pll_pri_source_id;
    output [31:0] master2pll_pri_wrdat;
    output        master2pll_pri_write;
   
    input         master2pll_pri_ack;
    input         master2pll_pri_error;
    input [31:0]  master2pll_pri_rdat;

    input  [3:0]  current_disabled_links;
    output [3:0]  pre_sw_current_disabled_links_sync;

    //*************************************************************
    // Regs and wires 
    //************************************************************* 
    &Regs;
    &Wires;   
    
    
//------------------------------------------------
//    Synchonize  the HW from Fuse block 
//------------------------------------------------

    NV_NVLINK_CMN_sync3d #(4) u_pre_sw_current_disabled_links_sync (
                                               .in(pre_sw_current_disabled_links),
                                               .clock(nvlipt_ctl_clk),
                                               .out(pre_sw_current_disabled_links_sync[3:0]));
   

    NV_NVLINK_CMN_sync3d #(8) u_opt_secure_nvlink_mask_wr_secure_sync (
                                                                     .in(nvlipt_security_priv_mask_wr_secure[7:0]),
                                                                     .clock(nvlipt_ctl_clk),
                                                                     .out(opt_secure_nvlctrl_mask_wr_secure_sync[7:0]));

    //----------------------------------
    //  - need to zero out upper bits
    //    for multiple instantiations
    //----------------------------------
    assign zero_pre_fixed_address = {14'h0, nvlctrl_pri_adr[17:0]}; 
    assign upper_address_NC       = nvlctrl_pri_adr[31:18];
    assign nvlipt_pri_ack_write   = 1'b1; //Saw the MKPRIVBLK2 code

    //----------------------------------------------------------------------
    // we use the Converter to convert the async interface to sync interface and then pass it to nvlipt mkprivblk2
    // The TOP level NVLW is a subpri of the NVLIPT MKPRIVBLK
    //-------------------------------------------------------------------------------------------------------------
    &Instance NV_NVLCTRL_PRI_converter;
        &Connect nvlipt_ctl_clk nvlipt_ctl_clk;
        &Connect nvlipt_warm_reset_n nvlipt_warm_reset_n;
        //HOST side request attributes
        &Connect pri_reqack_req      nvlctrl_pri_req    ;
        &Connect pri_reqack_req_data   {zero_pre_fixed_address, nvlctrl_pri_wrdat, nvlctrl_pri_write,nvlctrl_pri_priv_level,nvlctrl_pri_source_id};
        // Host side response 
        &Connect pri_reqack_ack      nvlctrl_pri_rtn_ack;
        &Connect pri_reqack_ack_data {nvlctrl_pri_rtn_rdat,nvlctrl_pri_rtn_error};
        // Request to PRI Router
        &Connect slv_req_vld        nvlipt_pri_pvld; // >> o
        &Connect slv_req_rdy        nvlipt_pri_prdy; // <<i
        &Connect slv_req_data           {nvlipt_pri_adr, nvlipt_pri_wrdat, nvlipt_pri_write,nvlipt_pri_priv_level,nvlipt_pri_source_id}; // >> o
        // Response to PRI Router
        &Connect slv_ack_vld        nvlipt_pri_rtn_valid; // <<i
        &Terminate slv_ack_rdy  ;          
        &Connect slv_ack_data       {nvlipt_pri_rtn_rdat, nvlipt_pri_rtn_error};      

  //--------------------------------------------------------
   //  Local IOCTRL PRI Register Block and Sub-PRI Router
   //--------------------------------------------------------
 	     
   NV_NVLCTRL_CTRL_PRI_registers registers (
		      
		      //-----------------------------
		      //  Clocks and Resets
		      //-----------------------------  		
		      .nvlipt_ctl_clk  			 		(nvlipt_ctl_clk),
		      .ioctrl_warm_reset_n 	 	 		(ioctrl_warm_reset_n),
		      .ioctrl_cold_reset_n			    (ioctrl_cold_reset_n), 
    
		      .ioctrl_pri_pvld					(ioctrl_pri_pvld),
  		      .ioctrl_pri_prdy					(ioctrl_pri_prdy), 
  		      .ioctrl_pri_adr					(ioctrl_pri_adr),        	 
		      .ioctrl_pri_wrdat					(ioctrl_pri_wrdat),
  		      .ioctrl_pri_write					(ioctrl_pri_write),             
  		      .ioctrl_pri_priv_level			(ioctrl_pri_priv_level),             
  		      .ioctrl_pri_source_id				(ioctrl_pri_source_id),             
  		      .ioctrl_pri_ack_write				(ioctrl_pri_ack_write),
  		      .ioctrl_pri_rtn_valid				(ioctrl_pri_rtn_valid),
  		      .ioctrl_pri_rtn_error				(ioctrl_pri_rtn_error),
  		      .ioctrl_pri_rtn_rdat				(ioctrl_pri_rtn_rdat),

 		      //-----------------------------
		      // To PLL 
		      //-----------------------------  	
  		      .subpri_pll_pri_pvld  			        (subpri_pll_pri_pvld),
  		      .subpri_pll_pri_prdy  			      	(subpri_pll_pri_prdy), 
  		      .subpri_pll_pri_adr				      	(subpri_pll_pri_adr),		 
		      .subpri_pll_pri_wrdat 			      	(subpri_pll_pri_wrdat),
  		      .subpri_pll_pri_write 			      	(subpri_pll_pri_write),		
  		      .subpri_pll_pri_priv_level			    (subpri_pll_pri_priv_level),	     
  		      .subpri_pll_pri_source_id			      	(subpri_pll_pri_source_id),	    
  		      .subpri_pll_pri_ack_write			      	(subpri_pll_pri_ack_write),
  		      .subpri_pll_pri_rtn_valid			      	(subpri_pll_pri_rtn_valid),
  		      .subpri_pll_pri_rtn_error			      	(subpri_pll_pri_rtn_error),
  		      .subpri_pll_pri_rtn_rdat			      	(subpri_pll_pri_rtn_rdat),

		      //-----------------------------------
		      // To Perfmon
		      //----------------------------------
              .perfmon_priv_rdupdate						(perfmon_priv_rdupdate),    
  		      .perfmon_priv_updated					        (perfmon_priv_updated),     
	
   		      //------------------------------------------------
   		      // Errors and Interrupt lines 
   		      //------------------------------------------------
                &PerlBeg;
                    for my $i (0..$NV_NVL_IOCTRL_NUM_LINKS-1) 
                    { 
                        vprintl qq 
                        {   
                            .link${i}_err_fatal			       (link${i}_err_fatal), 
                            .link${i}_err_nonfatal			   (link${i}_err_nonfatal), 
                            .link${i}_err_correctable 		   (link${i}_err_correctable), 
                            .link${i}_intr_A    			   (link${i}_intr_0),  
                            .link${i}_intr_B	         	   (link${i}_intr_1),  
                        };		
   
                    }  
                &PerlEnd;  	       
		    

                .nvlipt_err_fatal			 		(nvlipt_err_fatal), 
                .nvlipt_err_nonfatal			 	(nvlipt_err_nonfatal), 
                .nvlipt_err_correctable		        (nvlipt_err_correctable),
                .nvlipt_intr_A			        	(nvlipt_intr_0),  
                .nvlipt_intr_B			 	        (nvlipt_intr_1),         

                //--------------------------------------------------
                //      Clock Disable Registers 
                //--------------------------------------------------
                &PerlBeg;
                    for my $i (0..$NV_NVL_IOCTRL_NUM_LINKS-1) 
                    { 
                        vprintl qq 
                        { 
                            .nvlink${i}_clk_disable   		       	     (nvlink${i}_clk_disable),
                        };		
       
                    }  
                &PerlEnd;  	
                        
		        	      
                //--------------------------------------------------
                // Fuse Ports 
                //--------------------------------------------------
                .fs2all_per_link_disable				     (level2ioctrl_fs2all_per_link_disable), 
                .opt_secure_nvlink_mask_wr_secure	         (level2ioctrl_opt_secure_nvlink_mask_wr_secure), 
 
                .pre_sw_current_disabled_links_sync		     (pre_sw_current_disabled_links_sync),
                .current_disabled_links				         (current_disabled_links),

                .discovery_unicast_base                      (discovery_unicast_base),
                .discovery_table_instance_number             (discovery_table_instance_number),

                //-------------------------------------------------
                //  Control Registers for ASYCN PLL MASTER
                //-------------------------------------------------
                .pll_pri_master_smconfig_fs_action                 (pll_pri_master_smconfig_fs_action),
                .pll_pri_master_smconfig_hold_clocks               (pll_pri_master_smconfig_hold_clocks[2:0]), 
                .pll_pri_master_smconfig_reset_action              (pll_pri_master_smconfig_reset_action) ,    
                .pll_pri_master_smconfig_setup_clocks              (pll_pri_master_smconfig_setup_clocks[2:0]),
                .pll_pri_master_smconfig_timeout                   (pll_pri_master_smconfig_timeout[17:0]),    
                .pll_pri_master_smconfig_wait_clocks               (pll_pri_master_smconfig_wait_clocks[2:0]),
    		    .pll_pri_clock_gating_cg1_slcg		               (pll_pri_clock_gating_cg1_slcg),
    
                //------------------------------------------------
                //    ERR out
                //------------------------------------------------
                .nvlipt_wrap_err_fatal                   (nvlipt_wrap_err_fatal)
                .nvlipt_wrap_err_nonfatal                (nvlipt_wrap_err_nonfatal)
                .nvlipt_wrap_err_correctable             (nvlipt_wrap_err_correctable)
                
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
                .debug_mux_ctrl_group255(debug_mux_ctrl_group255));		      
 
    //------------------------------------------------
    // Flop For Fan out  
    //------------------------------------------------
    always @(posedge nvlipt_ctl_clk) 
    begin
        current_disabled_links_reg[3:0] <= current_disabled_links[3:0];     // use with clock control disables for CAR output
        current_disabled_links_pm[3:0]   <= current_disabled_links[3:0];     // Feed this to perfmon decoders so that multicast does not occur for disabled links

        priv_rdupdate <= priv_rdupdate_temp;
        priv_updated  <= priv_updated_temp;
    end

    //----------------------------------------------------------------------------------------
    // The SUBPRI from NVLIPT_wrap_two goes to PLL via a async master
    // PLL is on a different clock
    //---------------------------------------------------------------------------------------

    &PerlBeg;
        my $address_width = 10;

        vprintl qq
        {
            //----------------------------------------------
            //   Asycnc  Master For SYS clk to ATALx4 CLK 
            //--------------------------------------------      
            NV_NVLIPT_CMN_pri_async_master_strictsync     #(.PRI_ADDRESS_WIDTH(${address_width} + 1)) pll_master (  
                //-----------------------------
                //  Clocks and Resets
                //-----------------------------          
                .master_clk_nobg              (nvlipt_ctl_clk),          
                .master_reset_                (nvlipt_warm_reset_n), 

                .client_clk_nobg              (pllctl_clk),        
                .client_reset_                (nvlw2pllctl_warm_reset_pllctlclk_sync_n), 

                //-----------------------------
                //  Clock Gating 
                //-----------------------------          
                .tmc2slcg_disable_clock_gating          (tmc2slcg_disable_clock_gating),  
              
                //-------------------------------------------------------
                // CYA CSR values for Given PRI Controlled 
                //-------------------------------------------------------
                .config_disable_slcg                  (pll_pri_clock_gating_cg1_slcg),         
                .config_timeout                       (pll_pri_master_smconfig_timeout[17:0]),            
                .config_fs_action                     (pll_pri_master_smconfig_fs_action),
                .config_reset_action                  (pll_pri_master_smconfig_reset_action), 
                .config_hold_clocks                   (pll_pri_master_smconfig_hold_clocks[2:0] ),        
                .config_setup_clocks                  (pll_pri_master_smconfig_setup_clocks[2:0]),
                .config_wait_clocks                   (pll_pri_master_smconfig_wait_clocks[2:0]),               
                  
                //-------------------------------------------------------
                // Fuse and Reset bits for the downstream target 
                //-------------------------------------------------------             
                // Also Fused links will be handeled above at NVLIPT    
                .client_fused_away            (1'b0),         //Tied to zero can never have txclk without rxclk     

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
                .client_pri_req               (master2pll_pri_req),      
                .client_pri_adr               (master2pll_pri_adr[${address_width}:0]),   
                .client_pri_wrdat             (master2pll_pri_wrdat),
                .client_pri_write             (master2pll_pri_write),                
                .client_pri_priv_level        (master2pll_pri_priv_level),
                .client_pri_source_id         (master2pll_pri_source_id),
              
                .client_pri_ack               (master2pll_pri_ack),
                .client_pri_rdat              (master2pll_pri_rdat),
                .client_pri_error             (master2pll_pri_error),

                //-------------------------------------------------------
                // Perf Mon signals 
                //-------------------------------------------------------
                .perfmon_client_pri_req     (),            //FIXME needs to go to perfmon    
                .perfmon_client_pri_write   (),                
                .perfmon_client_pri_ack     (),                
                .perfmon_client_pri_error   ());
        };
    &PerlEnd;
&EndModule;
