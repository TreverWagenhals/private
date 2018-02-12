`timescale 1ns / 1ps
module HW2_tb();
	reg clk;
	reg [7:0] pbg_data_in;
	reg pbg_gen_odd_par;
	wire pbg_parity_bit_out;
	
	initial begin
		clk = 0;
		forever #5 clk <= ~clk;
	end
	
	parity_bit_generator pbg_DUT(
	.DATA_IN(pbg_data_in),
	.GEN_ODD_PAR(pbg_gen_odd_par),
	.PARITY_BIT_OUT(pbg_parity_bit_out)
	);
	
	initial begin
		pbg_data_in = 2'h00;
		pbg_gen_odd_par = 0;
		#10
		pbg_gen_odd_par = 1;
		#10
		pbg_data_in = 2'h01;
		#10
		pbg_gen_odd_par = 0;
		forever #10;
	end
	
	reg d_enable;
	reg [3:0] d_binary_in;
	wire [15:0] d_decoder_out;
	
	decoder d_DUT(
	.enable(d_enable),
	.binary_in(d_binary_in),
	.decoder_out(d_decoder_out)
	);
	
	initial begin
		d_enable = 0;
		#10
		d_binary_in = 5;
		#10
		d_enable = 1;
		#10
		d_binary_in = 1;
		forever #10;
	end
	
	reg sr_resetl;
	reg sr_presetl;
	reg sr_shift_in_msb;
	reg sr_shift_in_lsb;
	reg [1:0] sr_control;
	reg [7:0] sr_data_in;
	
	wire [7:0] sr_q;
	wire [7:0] sr_q_bar;
	
	shift_register sr_DUT(
	.clk(clk),
	.presetl(sr_presetl),
	.resetl(sr_resetl),
	.shift_in_msb(sr_shift_in_msb),
	.shift_in_lsb(sr_shift_in_lsb),
	.control(sr_control),
	.data_in(sr_data_in),
	.q(sr_q),
	.q_bar(sr_q_bar)
	);
	
	initial begin
		sr_resetl = 1;
		sr_presetl = 1;
		sr_shift_in_lsb = 1;
		@(posedge clk);
		sr_resetl = 0;
		@(posedge clk);
		sr_presetl = 0;
		@(posedge clk);
		sr_resetl = 1;
		@(posedge clk);
		sr_presetl = 1;
		sr_control = 0;
		sr_data_in = 0;
		@(posedge clk);
		sr_control = 1;
		@(posedge clk);
		sr_data_in = 1;
		@(posedge clk);
		sr_control = 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		sr_control = 2;
		@(posedge clk);
		sr_shift_in_lsb = 0;
		@(posedge clk);
		sr_control = 3;
		sr_shift_in_msb = 0;
		@(posedge clk);
		sr_shift_in_msb = 1;
		forever #10;
	end
	
	reg cnt_resetl;
	reg cnt_presetl;
	reg cnt_load_ena;
	reg cnt_up;
	reg [3:0] cnt_data_in;
	wire [3:0] cnt_count;
	
	counter cnt_DUT(
	.clk(clk),
	.resetl(cnt_resetl),
	.presetl(cnt_presetl),
	.load_ena(cnt_load_ena),
	.up(cnt_up),
	.data_in(cnt_data_in),
	.count(cnt_count)
	);
	
	initial begin
		cnt_presetl = 0;
		@(posedge clk);
		cnt_resetl = 0;
		@(posedge clk);
		cnt_presetl = 1;
		@(posedge clk);
		cnt_resetl = 1;
		cnt_load_ena = 1;
		cnt_data_in = 0;
		@(posedge clk);
		cnt_data_in = 1;
		#20
		@(posedge clk);
		cnt_load_ena = 0;
		cnt_up = 1;
		#200
		@(posedge clk);
		cnt_up = 0;
		forever #10;		
	end
endmodule
		