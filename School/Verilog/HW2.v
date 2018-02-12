`timescale 1ns / 1ps

module parity_bit_generator(
    input [7:0] DATA_IN,
    input GEN_ODD_PAR,
    output PARITY_BIT_OUT
    );
    
    assign PARITY_BIT_OUT = GEN_ODD_PAR ^ ^DATA_IN;
endmodule

primitive mux2_1_udp(
    output muxout,
    input in0,
    input in1,
    input muxsel
    );
table    
//  sel in0 in1 out
    0   0   ?   : 0 ; // sel 0 in0 0, output 0
    0   1   ?   : 1 ; // sel 0 in0 1, output 1
    1   ?   0   : 0 ; // sel 1 in1 0, output 0
    1   ?   1   : 1 ; // sel 1 in1 1, output 1
    ?   0   0   : 0 ; // both 0, output 0
    ?   1   1   : 1 ; // both 1, output 1
endtable
endprimitive

primitive xor_udp(
    output xorout,
    input in0,
    input in1
    );
table
// in0 in1 out
    0  0  : 0 ;
    0  1  : 1 ;
    1  0  : 1 ;
    1  1  : 0 ;
	1  x  : x ;
	x  1  : x ;
	0  x  : x ;
	x  0  : x ;
	x  x  : x ;
endtable
endprimitive

module decoder(
    input enable,
    input [3:0] binary_in,
    output reg [15:0] decoder_out
    );
    
    always @(*)
    begin
        decoder_out <= (enable) ? (1 << binary_in) : 16'b0;
    end
endmodule

module shift_register(
    input clk,
    input [7:0] data_in,
    input resetl,
    input presetl,
    input [1:0] control,
    input shift_in_msb,
    input shift_in_lsb,
    output reg [7:0] q,
    output [7:0] q_bar
    );
	
    always @(posedge clk)
    begin
        if(!resetl)
            q <= 0;
        else if (!presetl)
            q <= 8'hff;
        else if (control == 1)
            q <= data_in;
        else if (control == 2)
            q <= {q[6:0], shift_in_lsb};
        else if (control == 3)
            q <= {shift_in_msb, q[7:1]};
    end
    assign q_bar = ~q;
endmodule

module counter(
    input clk,
    input resetl,
    input presetl,
    input load_ena,
    input up,
    input [3:0] data_in,
    output reg [3:0] count
    );

    always @(posedge clk)
    begin
        if (!resetl)
            count <= 0;
        else if (!presetl)
            count <= 4'hf;
        else if (load_ena)
            count <= data_in;
        else if (up)
            count <= count + 1;
        else
            count <= count - 1;
    end
endmodule	