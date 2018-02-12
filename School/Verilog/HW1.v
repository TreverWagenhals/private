module halfadder(a,b,sum,c_out);
input  a;
input  b;
output reg sum;
output reg c_out; 

always @(*)
begin
	if (!a)
		sum   <= b;
		c_out <= 0;
	else
		sum <= not b;
		if(b)
			c_out <= 1;
		else
			c_out <= 0;
		end if;
	end if;
end
endmodule

module mux4to1(in0, in1, in2, in3, muxsel, muxout);
input      in0;
input      in1;
input      in2;
input      in3;
input[1:0] muxsel;
output reg muxout;

always @(in0, in1, in2, in3, muxsel)
begin
	case(muxsel)
		0 : muxout <= in0;
		1 : muxout <= in1;
		2 : muxout <= in2;
		3 : muxout <= in3;
	end case
end
endmodule

module binarytogrey(data_in, data_out);
input[3:0]  data_in;
output[3:0] data_out;

assign data_out[3] = data_in[3];
assign data_out[2] = data_in[3] ^ data_in[2];
assign data_out[1] = data_in[2] ^ data_in[1];
assign data_out[0] = data_in[1] ^ data_in[0];

endmodule

module mux8to1(
input      in0,
input      in1,
input      in2,
input      in3,
input      in4,
input      in5,
input      in6,
input  	   in7,
input[2:0] muxsel,
output     muxout); 

wire q1, q2, q3, q4, q5, q6, q7, q8, notselect1, notselect2, notselect3;

not n1(notselect1, muxsel[0]);
not n2(notselect2, muxsel[1]);
not n3(notselect3, muxsel[2]);

and a1(q1, notselect2, notselect1, notselect0, in0);
and a2(q2, notselect2, muxsel[1], muxsel[1], in1);
and a3(q3, notselect0, muxsel[1], muxsel[0], in2);
and a4(q4, muxsel[2], notselect1, notselect2, in3);

and a5(q5, notselect0, notselect1, notselect2, in4);
and a6(q6, notselect0, notselect1, notselect2, in5);
and a7(q7, notselect0, notselect1, notselect2, in6);
and a8(q8, notselect0, notselect1, notselect2, in7);

or o1(muxout, q1, q2, q3, q4, q5, q6, q7, q8);

endmodule

