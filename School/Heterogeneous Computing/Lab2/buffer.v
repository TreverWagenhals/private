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
#include "dev_x_nvlctrl.mch"

//#######################################################################
//    Include Files From Ness
//#######################################################################
&PerlBeg;
    #-------------------------------
    #  Project.h 
    #-------------------------------
    vcp_read_defines("project.h");
&PerlEnd;		     

::directives;

//#######################################################################
//    Module Declaration  
//#######################################################################

&Module;

//#######################################################################
//    Port, Wire and Register Declaration  
//#######################################################################

//-------------------------------------------------------------
//   Module Ports 
//-------------------------------------------------------------

    //------------------------------------------------
    //	Clocks 
    //------------------------------------------------
	input nvlipt_ctl_clk;				
		
    //------------------------------------------------
    //	Resets  
    //------------------------------------------------
   	input ioctrl_warm_reset_n; 			// Synchonous Reset to nvlipt_ctl_clk for resetting logic 
	input ioctrl_cold_reset_n; 	        // Reset synchonized from pex power good signal 

    //-------------------------------------------------
    // Fuses
    //-------------------------------------------------
   	input [NV_NVL_IOCTRL_NUM_LINKS-1:0]  fs2all_per_link_disable; 
    input [7:0]                          opt_secure_nvlink_mask_wr_secure; 
    
    //------------------------------------------------
    //	Interrupts to host 
    //------------------------------------------------       
	output  nvlink2host_intr_nostall;  
	output  nvlink2host_intr_stall;    
	
    //------------------------------------------------
    //	NESS Interfaces   
    //------------------------------------------------
    #include "NV_IOCTRL_CTRL_PRI_registers_hookup.vxh"      
 
    //------------------------------------------------
    //	Cold Common Resets
    //------------------------------------------------
    output perfmon_priv_updated;
	output perfmon_priv_rdupdate;

    //-----------------------------
    // Common Interrupts
    //----------------------------
    input nvlipt_intr_A;
    input nvlipt_intr_B;

    //---------------------------
    // Discovery table personality pins
    //---------------------------
    input [7:0]      discovery_unicast_base;
    input [3:0]      discovery_table_instance_number;

&PerlBeg;
    for my $i (0..$NV_NVL_IOCTRL_NUM_LINKS-1) 
    { 
        vprintl qq 
        {   
            //------------------------------------------------
            //	Perlink Clock Disables  
            //------------------------------------------------
            output nvlink${i}_clk_disable;	
    
            //--------------------------------------------
            // Interrupts
            //-----------------------------------
            input link${i}_intr_A;
            input link${i}_intr_B;
        };		
    }  
&PerlEnd;  	       

    //--------------------------------------------------------
    // IOCTRL SYS Perfmon controls
    //--------------------------------------------------------
    output [7:0]       debug_mux_select_m1select0;
    output [7:0]       debug_mux_select_m1select1;
    output [7:0]       debug_mux_select_m1select2;
    output [7:0]       debug_mux_select_m1select3;
    output 	          debug_mux_ctrl_watchbusenable;
    output [3:0]       debug_mux_ctrl_group252;
    output [3:0]       debug_mux_ctrl_group253;
    output [3:0]       debug_mux_ctrl_group254;
    output [3:0]       debug_mux_ctrl_group255;

    //----------------------------------------------------
    // PLL ASYNC MASTER CONTROL
    //---------------------------------------------------
    output 		    pll_pri_master_smconfig_fs_action;        
    output [2:0]	pll_pri_master_smconfig_hold_clocks;       
    output 		    pll_pri_master_smconfig_reset_action;      
    output [2:0]    pll_pri_master_smconfig_setup_clocks;     
    output [17:0]   pll_pri_master_smconfig_timeout;    
    output [2:0]	pll_pri_master_smconfig_wait_clocks;   
    output		    pll_pri_clock_gating_cg1_slcg;
    
    output [NV_NVL_IOCTRL_NUM_LINKS-1:0] pre_sw_current_disabled_links_sync;
    input  [NV_NVL_IOCTRL_NUM_LINKS-1:0] current_disabled_links;

//-------------------------------------------------------------
//   Module Wires
//-------------------------------------------------------------
    &Wires;
    
//-------------------------------------------------------------
//   Module Registers
//-------------------------------------------------------------
    &Regs;

//--------------------------------------------------------------------
// Fuse Handling 
//--------------------------------------------------------------------

wire [NV_NVL_IOCTRL_NUM_LINKS-1:0] pre_sw_current_disabled_links;

//------------------------------------------------
//    Synchonize  the HW from Fuse block 
//------------------------------------------------

	NV_NVLINK_CMN_sync3d #(NV_NVL_IOCTRL_NUM_LINKS) u_pre_sw_current_disabled_links_sync (
                                                                     .in(pre_sw_current_disabled_links),
                                                                     .clock(nvlipt_ctl_clk),
                                                                     .out(pre_sw_current_disabled_links_sync[NV_NVL_IOCTRL_NUM_LINKS-1:0])
	);


	NV_NVLINK_CMN_sync3d #(8) u_opt_secure_nvlink_mask_wr_secure_sync (
                                                                     .in(opt_secure_nvlink_mask_wr_secure),
                                                                     .clock(nvlipt_ctl_clk),
                                                                     .out(opt_secure_nvlink_mask_wr_secure_sync[7:0])
	);


//------------------------------------------------
// Flop For Fan out  
//------------------------------------------------
   &Always posedge nvlipt_ctl_clk;
       current_disabled_links_reg[NV_NVL_IOCTRL_NUM_LINKS-1:0]<=  current_disabled_links[NV_NVL_IOCTRL_NUM_LINKS-1:0];     // MIF's 
   &End;

//--------------------------------------------------------------------
// Clock Disable Features from Bug 1730304
//
//   Disable the clock on the following situations
//	- 1) Link is HW or SW Fused Away 
//	- 2) SW Disables it via PRI write 
//	- 3) We are not in reset as we need clocks to always run
//           to distribute reset as we are synchonous
//
//-------------------------------------------------------------------- 

&PerlBeg;
  for my $i (0..$NV_NVL_IOCTRL_NUM_LINKS-1) {  
    vprintl qq {
    
  assign next_nvlink${i}_clk_disable = (current_disabled_links_reg[${i}] ) &  ioctrl_warm_reset_n; //FIXME_BUG2248952  
  
   &Always posedge nvlipt_ctl_clk;
       nvlink${i}_clk_disable<=next_nvlink${i}_clk_disable; 
   &End;

    };
  }
  
&PerlEnd;


//#######################################################################
//    Module Instantiations 
//#######################################################################

   //--------------------------------------------------------
   //  Local IOCTRL PRI Register Block and Sub-PRI Router
   //--------------------------------------------------------
 	     
   NV_IOCTRL_CTRL_PRI_REGISTERS_pri pri (
		      
            //-----------------------------
            //  Clocks and Resets
            //-----------------------------  		
            .nvlipt_ctl_clk  			 				(nvlipt_ctl_clk),
            .ioctrl_warm_reset_n 	 	 			    (ioctrl_warm_reset_n),
            .cold_reset_n 	 	 			        (ioctrl_cold_reset_n),

            //-----------------------------------------
            //  Fuses to control Prive level defaults 
            //-----------------------------------------  		
            .opt_secure_nvlink_mask0_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[0]),     
            .opt_secure_nvlink_mask1_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[1]),     
            .opt_secure_nvlink_mask2_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[2]),     
            .opt_secure_nvlink_mask3_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[3]),     
            .opt_secure_nvlink_mask4_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[4]),     
            .opt_secure_nvlink_mask5_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[5]),     
            .opt_secure_nvlink_mask6_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[6]),     
            .opt_secure_nvlink_mask7_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[7]),     
          
            //----------------------------------------
            // MKPRIVBLK converted to a synchronous interface
            //---------------------------------------------
            .pri_pvld					(ioctrl_pri_pvld),
            .pri_prdy					(ioctrl_pri_prdy), 
            .pri_adr					(ioctrl_pri_adr),        	 
            .pri_wrdat				    (ioctrl_pri_wrdat),
            .pri_write				    (ioctrl_pri_write),             
            .pri_priv_level				(ioctrl_pri_priv_level),             
            .pri_source_id				(ioctrl_pri_source_id),             
            .pri_ack_write				(ioctrl_pri_ack_write),
            .pri_rtn_vld				(ioctrl_pri_rtn_valid),
            .pri_rtn_error				(ioctrl_pri_rtn_error),
            .pri_rtn_rdat				(ioctrl_pri_rtn_rdat),
          
            //-----------------------------
            //  Siganls to go to Perfmon
            //-----------------------------  		     
            .priv_rdupdate				(perfmon_priv_rdupdate_temp),    
            .priv_updated				(perfmon_priv_updated_temp),     
         
            //-----------------------------
            // Sub Pri Bus to PLL 
            //-----------------------------  	
            .subpri_pll_pri_pvld				(subpri_pll_pri_pvld),
            .subpri_pll_pri_prdy				(subpri_pll_pri_prdy), 
            .subpri_pll_pri_adr				    (subpri_pll_pri_adr[10:0]),        	 
            .subpri_pll_pri_wrdat				(subpri_pll_pri_wrdat),
            .subpri_pll_pri_write				(subpri_pll_pri_write),             
            .subpri_pll_pri_priv_level			(subpri_pll_pri_priv_level),             
            .subpri_pll_pri_source_id		    (subpri_pll_pri_source_id),             
            .subpri_pll_pri_ack_write			(subpri_pll_pri_ack_write),
            .subpri_pll_pri_rtn_vld				(subpri_pll_pri_rtn_valid),
            .subpri_pll_pri_rtn_error			(subpri_pll_pri_rtn_error),
            .subpri_pll_pri_rtn_rdat			(subpri_pll_pri_rtn_rdat),
          
            //-----------------------------
            // Sub Pri Bus to DISCOVERY 
            //-----------------------------  	
            .subpri_discovery_pri_pvld				    (subpri_discovery_pri_pvld),
            .subpri_discovery_pri_prdy				    (subpri_discovery_pri_prdy), 
            .subpri_discovery_pri_adr					(subpri_discovery_pri_adr[10:0]),        	 
            .subpri_discovery_pri_wrdat				    (subpri_discovery_pri_wrdat),
            .subpri_discovery_pri_write				    (subpri_discovery_pri_write),             
            .subpri_discovery_pri_priv_level			(subpri_discovery_pri_priv_level),             
            .subpri_discovery_pri_source_id				(subpri_discovery_pri_source_id),             
            .subpri_discovery_pri_ack_write				(subpri_discovery_pri_ack_write),
            .subpri_discovery_pri_rtn_vld				(subpri_discovery_pri_rtn_valid),
            .subpri_discovery_pri_rtn_error				(subpri_discovery_pri_rtn_error),
            .subpri_discovery_pri_rtn_rdat				(subpri_discovery_pri_rtn_rdat),

            //-----------------------------
            // Sub Pri Bus to CHIP SPECIFIC 
            //-----------------------------  	
            .subpri_chip_specific_pri_pvld				(subpri_chip_specific_pri_pvld),
            .subpri_chip_specific_pri_prdy				(subpri_chip_specific_pri_prdy), 
            .subpri_chip_specific_pri_adr				(subpri_chip_specific_pri_adr[10:0]),        	 
            .subpri_chip_specific_pri_wrdat				(subpri_chip_specific_pri_wrdat),
            .subpri_chip_specific_pri_write				(subpri_chip_specific_pri_write),             
            .subpri_chip_specific_pri_priv_level		(subpri_chip_specific_pri_priv_level),             
            .subpri_chip_specific_pri_source_id			(subpri_chip_specific_pri_source_id),             
            .subpri_chip_specific_pri_ack_write			(subpri_chip_specific_pri_ack_write),
            .subpri_chip_specific_pri_rtn_vld			(subpri_chip_specific_pri_rtn_valid),
            .subpri_chip_specific_pri_rtn_error			(subpri_chip_specific_pri_rtn_error),
            .subpri_chip_specific_pri_rtn_rdat			(subpri_chip_specific_pri_rtn_rdat),

            .top_intr_0_status_link		    (
                                                {
                                                    &PerlBeg;
                                                        for (my $i=$NV_NVL_IOCTRL_NUM_LINKS-1; $i>0; $i--)
                                                        {     
                                                            vprintl qq 
                                                            {								      			 
                                                                link${i}_intr_0,
                                                            };
                                                        }
                                                    &PerlEnd;
                                                    link0_intr_0
                                                }
                                            ),

            .top_intr_0_status_common				(common_intr_0),
                
            &PerlBeg;
                our $num_intr   = 3;
                my  $loop_count = ($NV_NVL_IOCTRL_NUM_LINKS)-1;

                for my $j (0..$num_intr)
                {
                    for my $i (0..$loop_count) 
                    { 
                        vprintl qq 
                        {   
                          .link_intr_${j}_mask_${i}_correctable		    (link_intr_${j}_mask_${i}_correctable),
                          .link_intr_${j}_mask_${i}_fatal				(link_intr_${j}_mask_${i}_fatal),
                          .link_intr_${j}_mask_${i}_nonfatal			(link_intr_${j}_mask_${i}_nonfatal),
                          .link_intr_${j}_mask_${i}_intr0				(link_intr_${j}_mask_${i}_intr0),
                          .link_intr_${j}_mask_${i}_intr1				(link_intr_${j}_mask_${i}_intr1),

                          .link_intr_${j}_status_${i}_correctable		(link$_{i}_intr_${j}_correctable),
                          .link_intr_${j}_status_${i}_fatal			    (link$_{i}_intr_${j}_fatal),
                          .link_intr_${j}_status_${i}_nonfatal			(link$_{i}_intr_${j}_nonfatal),
                          .link_intr_${j}_status_${i}_intr0			    (link$_{i}_intr_${j}_intr0),
                          .link_intr_${j}_status_${i}_intr1			    (link$_{i}_intr_${j}_intr1),
                        };
                    }
                    
                    .common_intr_${j}_mask_correctable  		    	(common_intr_${j}_mask_correctable),
                    .common_intr_${j}_mask_fatal	 		    		(common_intr_${j}_mask_fatal),
                    .common_intr_${j}_mask_intr0	 		    		(common_intr_${j}_mask_intr0),
                    .common_intr_${j}_mask_intr1	 		    		(common_intr_${j}_mask_intr1),
                    .common_intr_${j}_mask_nonfatal	 		    	    (common_intr_${j}_mask_nonfatal),

                    .common_intr_${j}_status_correctable		    	(common_intr_${j}_correctable),
                    .common_intr_${j}_status_fatal	 		    	    (common_intr_${j}_fatal),
                    .common_intr_${j}_status_intr0	 		    	    (common_intr_${j}_intr0),
                    .common_intr_${j}_status_intr1	 		    	    (common_intr_${j}_intr1),
                    .common_intr_${j}_status_nonfatal   		    	(common_intr_${j}_nonfatal),
                }          
            &PerlEnd;
              
            //-----------------------------------------------------------
            // PLL ASYNC MASTER CONTROL
            //------------------------------------------------------------
            .pll_pri_master_smconfig_fs_action                 (pll_pri_master_smconfig_fs_action),
            .pll_pri_master_smconfig_hold_clocks               (pll_pri_master_smconfig_hold_clocks[2:0]), 
            .pll_pri_master_smconfig_reset_action              (pll_pri_master_smconfig_reset_action) ,    
            .pll_pri_master_smconfig_setup_clocks              (pll_pri_master_smconfig_setup_clocks[2:0]),
            .pll_pri_master_smconfig_timeout                   (pll_pri_master_smconfig_timeout[17:0]),    
            .pll_pri_master_smconfig_wait_clocks               (pll_pri_master_smconfig_wait_clocks[2:0]),
            .pll_pri_clock_gating_cg1_slcg		               (pll_pri_clock_gating_cg1_slcg),

            //--------------------------------------------------------
            // debug Registers 
            //--------------------------------------------------------
           .debug_mux_select_m1select0              (debug_mux_select_m1select0),
           .debug_mux_select_m1select1              (debug_mux_select_m1select1),
           .debug_mux_select_m1select2              (debug_mux_select_m1select2),
           .debug_mux_select_m1select3              (debug_mux_select_m1select3),
           .debug_mux_ctrl_watchbusenable           (debug_mux_ctrl_watchbusenable),
           .debug_mux_ctrl_group252                 (debug_mux_ctrl_group252),
           .debug_mux_ctrl_group253                 (debug_mux_ctrl_group253),
           .debug_mux_ctrl_group254                 (debug_mux_ctrl_group254),
           .debug_mux_ctrl_group255                 (debug_mux_ctrl_group255),
	
		   //-----------------------------
		   // Scratch Registers 
		   //-----------------------------		  
		   .scratch_privmask0_data			     (),         
		   .scratch_privmask1_data			     (),	 
		   .scratch_privmask2_data			     (),	 
		   .scratch_privmask3_data			     (),	 
		   .scratch_privmask4_data			     (),	 
		   .scratch_privmask5_data			     (),	 
		   .scratch_privmask6_data			     (),	 
		   .scratch_privmask7_data			     (),	 
		   .scratch_warm_data				     (),
		   .scratch_cold_data				     ()
);

    //----------------------------------------------------------------
    // NVLIPT DISCOVERY REGISTERS
    //---------------------------------------------------------------- 
    &Instance NV_NVLCTRL_CTRL_PRI_REGISTERS_nvlctrl_disc_pri discovery_regs;
        // Main Pri Connections  from sub_pri bus 
        &Connect -final /^pri_(.*)/ subpri_discovery_pri_${1};
        //Register Connections 
        &Connect -final /^registers_(.*)_chain/ discovery_${1}_chain; 
        &Connect -final /^registers_(.*)_contents/ discovery_${1}_contents[30:2]; 
        &Connect -final /^registers_(.*)_entry/ discovery_${1}_entry; 
        // Terminate Connection as this a sub pri 
        &Terminate /^priv_rdupdate/;  
        &Terminate /^priv_updated/;  
        
    //----------------------------------------------------------------
    // NVLIPT CSPEC REGISTERS
    //---------------------------------------------------------------- 
    &Instance NV_NVLCTRL_CTRL_PRI_REGISTERS_nvlctrl_cspec_pri cspec_regs;
        // Priv level Mask Registers 
        &Connect -final  /opt_secure_nvlink_mask(.*)_wr_secure/ opt_secure_nvlctrl_mask_wr_secure_sync[${1}];
        // Main Pri Connections  from sub_pri bus 
        &Connect -final /^pri_(.*)/ subpri_chip_specific_pri_${1};
        // Terminate Scratch Regs 
        &Terminate /^scratch_(.*)/;  
        // Terminate Connection as this a sub pri 
        &Terminate /^priv_rdupdate/;  
        &Terminate /^priv_updated/;  

    &Instance NV_NVLCTRL_PRI_REGISTERS_discovery  discovery_base; 
        &Connect -final discovery_unicast_base  discovery_unicast_base; 
        &Connect -final discovery_perfmon_unicast_base discovery_perfmon_unicast_base; 
        &Connect -final discovery_table_instance_number discovery_table_instance_number; 
        &Connect -final  nvlw_unicast_discovery_0_link_disable   current_disabled_links_reg; 

  NV_IOCTRL_CTRL_PRI_REGISTERS_nvlctrl_cspec_pri  chip_specific_pri (

		      //-----------------------------
		      //  Clocks and Resets
		      //-----------------------------  		
		      .nvlipt_ctl_clk  			 				(nvlipt_ctl_clk),
		      .nvlipt_warm_reset_n 	 	 			    (nvlipt_warm_reset_n),
		      .nvlipt_cold_reset_n 	 	 			    (nvlipt_cold_reset_n),

		      //-----------------------------------------
		      //  Fuses to control Prive level defaults 
		      //-----------------------------------------  		
		      .opt_secure_nvlink_mask0_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[0]),      
		      .opt_secure_nvlink_mask1_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[1]),     
		      .opt_secure_nvlink_mask2_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[2]),     
		      .opt_secure_nvlink_mask3_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[3]),     
		      .opt_secure_nvlink_mask4_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[4]),     		       
		      .opt_secure_nvlink_mask5_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[5]),     		      
		      .opt_secure_nvlink_mask6_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[6]),     		      
		      .opt_secure_nvlink_mask7_wr_secure	       (opt_secure_nvlink_mask_wr_secure_sync[7]),     

		      //----------------------------------------
		      // MKPRIVBLK converted to a synchronous interface
		      //---------------------------------------------
  		      .pri_pvld					(subpri_chip_specific_pri_pvld),
  		      .pri_prdy					(subpri_chip_specific_pri_prdy), 		      
  		      .pri_adr					(subpri_chip_specific_pri_adr[10:0]),        	 
		      .pri_wrdat				(subpri_chip_specific_pri_wrdat[31:0]),
  		      .pri_write				(subpri_chip_specific_pri_write),             
  		      .pri_priv_level			(subpri_chip_specific_pri_priv_level[1:0]),             
  		      .pri_source_id			(subpri_chip_specific_pri_source_id[4:0]),             
  		      .pri_ack_write			(subpri_chip_specific_pri_ack_write),
  		      .pri_rtn_vld				(subpri_chip_specific_pri_rtn_valid),
  		      .pri_rtn_error			(subpri_chip_specific_pri_rtn_error),
  		      .pri_rtn_rdat				(subpri_chip_specific_pri_rtn_rdat[31:0]),
              
		      //-----------------------------
		      //  Signals to go to Perfmon
		      //-----------------------------  		     
		      .priv_rdupdate						(),    
  		      .priv_updated					        (),     
	
		      //-----------------------------
		      // Scratch Registers 
		      //-----------------------------		  
		      .scratch_privmask0_data			     (),         
		      .scratch_privmask1_data			     (),	 
		      .scratch_privmask2_data			     (),	 
		      .scratch_privmask3_data			     (),	 
		      .scratch_privmask4_data			     (),	 
		      .scratch_privmask5_data			     (),	 
		      .scratch_privmask6_data			     (),	 
		      .scratch_privmask7_data			     (),	 
		      .scratch_warm_data				     (),
		      .scratch_cold_data				     ());

              
    &PerlBeg;
        our $NUM_LINKS      = 4;
        our $NUM_INTERRUPTS = 3;

        for my $i (0..$NUM_LINKS-1) 
        {
        
            vprintl qq
            {
                // Flop inputs to avoid NADQ violations
                &Always posedge nvlipt_ctl_clk;
                    link_${i}_err_fatal_reg         <= link_${i}_err_fatal;
                    link_${i}_err_nonfatal_reg      <= link_${i}_err_nonfatal;
                    link_${i}_err_correctable_reg   <= link_${i}_err_correctable;
                    link_${i}_err_intr0_reg         <= link_${i}_err_intr0;
                    link_${i}_err_intr1_reg         <= link_${i}_err_intr1;
                &End;
            };
             
            for my $j (0..$NUM_INTERRUPTS-1) 
            {            
                vprintl qq 
                {
                    // The naming of the PRI registers is not intuitive. The link number is placed at the end because
                    // The stride uses is the link number and the stride can only be placed at the end for SW to use.
                    // This is here just to rename it to make it more untuitive and automatically connect to the PRI
                    assign link_${i}_intr_${j}_mask_fatal          = link_intr_${j}_mask_${i}_fatal;
                    assign link_${i}_intr_${j}_mask_nonfatal       = link_intr_${j}_mask_${i}_nonfatal;
                    assign link_${i}_intr_${j}_mask_correctable    = link_intr_${j}_mask_${i}_correctable;
                    assign link_${i}_intr_${j}_mask_intr0          = link_intr_${j}_mask_${i}_intr0;
                    assign link_${i}_intr_${j}_mask_intr1          = link_intr_${j}_mask_${i}_intr1;
                 
                    assign  next_link_${i}_intr_${j}_fatal         = link_${i}_err_fatal_reg       & link_${i}_intr_${j}_mask_fatal;
                    assign  next_link_${i}_intr_${j}_nonfatal      = link_${i}_err_nonfatal_reg    & link_${i}_intr_${j}_mask_nonfatal;
                    assign  next_link_${i}_intr_${j}_correctable   = link_${i}_err_correctable_reg & link_${i}_intr_${j}_mask_correctable;
                    assign  next_link_${i}_intr_${j}_intr0         = link_${i}_err_intr0_reg       & link_${i}_intr_${j}_mask_intr0;
                    assign  next_link_${i}_intr_${j}_intr1         = link_${i}_err_intr1_reg       & link_${i}_intr_${j}_mask_intr1;
                    
                    assign  next_link_${i}_intr_${j} = link_${i}_intr_${j}_fatal | link_${i}_intr_${j}_nonfatal | link_${i}_intr_${j}_correctable | 
                                                       link_${i}_intr_${j}_intr0 | link_${i}_intr_${j}_intr1;   
       
                    &Reset nvlipt_warm_reset_n;    
                    &Always posedge nvlipt_ctl_clk;
                        link_${i}_intr_${j}             <0= next_link_${i}_intr_${j}; 
                     
                        link_${i}_intr_${j}_fatal       <0= next_link_${i}_intr_${j}_fatal; 
                        link_${i}_intr_${j}_nonfatal    <0= next_link_${i}_intr_${j}_nonfatal; 
                        link_${i}_intr_${j}_correctable <0= next_link_${i}_intr_${j}_correctable; 
                        link_${i}_intr_${j}_intr0       <0= next_link_${i}_intr_${j}_intr0; 
                        link_${i}_intr_${j}_intr1       <0= next_link_${i}_intr_${j}_intr1;
                    &End;

                    assign link_intr_${j}_status_${i}_fatal       = link_${i}_intr_${j}_fatal;
                    assign link_intr_${j}_status_${i}_nonfatal    = link_${i}_intr_${j}_nonfatal;
                    assign link_intr_${j}_status_${i}_correctable = link_${i}_intr_${j}_correctable;
                    assign link_intr_${j}_status_${i}_intr0       = link_${i}_intr_${j}_intr0;
                    assign link_intr_${j}_status_${i}_intr1       = link_${i}_intr_${j}_intr1;
                }; 
            }       
        }

        for my $j (0..$NUM_INTERRUPTS-1) 
        {
            vprintl qq 
            {
                &Reset nvlipt_warm_reset_n;    
                &Always posedge nvlipt_ctl_clk;
                    common_intr_${j}          <0= next_common_intr_${j}; 
                    nvlink2host_intr_${j}     <0= next_nvlink2host_intr_${j}; 
                    
                    common_intr_${j}_fatal          <0= next_common_intr_${j}_fatal; 
                    common_intr_${j}_nonfatal       <0= next_common_intr_${j}_nonfatal; 
                    common_intr_${j}_correctable    <0= next_common_intr_${j}_correctable; 
                    common_intr_${j}_intr0          <0= next_common_intr_${j}_intr0; 
                    common_intr_${j}_intr1          <0= next_common_intr_${j}_intr1;
                &End;

                assign common_intr_${j}_status_fatal       = common_intr_${j}_fatal;
                assign common_intr_${j}_status_nonfatal    = common_intr_${j}_nonfatal;
                assign common_intr_${j}_status_correctable = common_intr_${j}_correctable;
                assign common_intr_${j}_status_intr0       = common_intr_${j}_intr0;
                assign common_intr_${j}_status_intr1       = common_intr_${j}_intr1;
             
                assign  next_common_intr_${j}_fatal        = nvlipt_err_fatal_reg       & common_intr_${j}_mask_fatal;
                assign  next_common_intr_${j}_nonfatal     = nvlipt_err_nonfatal_reg    & common_intr_${j}_mask_nonfatal;
                assign  next_common_intr_${j}_correctable  = nvlipt_err_correctable_reg & common_intr_${j}_mask_correctable;    
                assign  next_common_intr_${j}_intr0        = nvlipt_intr0_reg           & common_intr_${j}_mask_intr0;
                assign  next_common_intr_${j}_intr1        = nvlipt_intr1_reg           & common_intr_${j}_mask_intr1;  
                
                assign next_common_intr_${j} = common_intr_${j}_fatal| common_intr_${j}_nonfatal | common_intr_${j}_correctable | 
                                                common_intr_${j}_intr0 | common_intr_${j}_intr1;

                assign top_intr_${j}_status_common = common_intr_${j};
            };

            my @stall_array = ();
            for my $i (0..$NUM_LINKS-1)
            {
                my $int_signal = "link_${i}_intr_${j}";
                push @stall_array, $int_signal;        
            }
            
            vprintl "\n    assign next_nvlink2host_intr_${j} =  common_intr_${j} | ".join(" | ", @stall_array).";";
            vprintl "\n    assign top_intr_${j}_status_link  =  {".join(" , ", reverse @stall_array)."};";
        
        }    
    &PerlEnd;

    // Flop inputs to avoid NADQ violations
    &Always posedge nvlipt_ctl_clk;
        nvlipt_err_fatal_reg            <0= nvlipt_err_fatal;
        nvlipt_err_nonfatal_reg         <0= nvlipt_err_nonfatal;
        nvlipt_err_correctable_reg      <0= nvlipt_err_correctable;
        nvlipt_intr0_reg                <0= nvlipt_intr0;
        nvlipt_intr1_reg                <0= nvlipt_intr1;
    &End;

    assign nvlipt_wrap_err_fatal       = nvlink2host_intr_0;
    assign nvlipt_wrap_err_nonfatal    = nvlink2host_intr_1;
    assign nvlipt_wrap_err_correctable = nvlink2host_intr_2;
   
&EndModule;


