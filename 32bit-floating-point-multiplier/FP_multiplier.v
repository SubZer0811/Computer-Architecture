`include "wallace.v"
`include "8rdcla.v"

module FP_multiplier(
	output [31:0] prod, 
	input [31:0] a, b,
	input clk
);

	wire s_a, s_b;
	wire [22:0] m_a, m_b, m_a_out, m_b_out;
	wire [30:23] e_a, e_b;
	wire [63:0] wallace_out, wallace_t;
	wire [7:0] e1, e2, e3, e1_out, e2_out;
	wire [47:0] need;
	wire [31:0] int_prod, int_prod_1, int_prod_2, int_prod_out, int_prod_1_out, int_prod_2_out, final_prod;
	
	split _a (s_a, e_a, m_a, a);
	split _b (s_b, e_b, m_b, b);
	DFF split_a_1 (s_a, s_a_out, clk);
	DFF split_b_1 (s_b, s_b_out, clk);
	DFF split_a_2 [7:0] (e_a, e_a_out, clk);
	DFF split_b_2 [7:0] (e_b, e_b_out, clk);
	DFF split_a_3 [22:0] (m_a[22:0], m_a_out[22:0], clk);
	DFF split_b_3 [22:0] (m_b[22:0], m_b_out[22:0], clk);

	wallace wallace1 ({9'b000000001, m_a_out}, {9'b000000001, m_b_out}, wallace_t, clk);
	DFF wallace_dff [63:0] (wallace_t, wallace_out, clk);
	
	// Assigning mantissa of output
	assign need = wallace_out[47:0];
	shift shift [22:0] (int_prod[22:0], need[47], need[45:23], need[46:24]);
	DFF shift_p [22:0] (int_prod[22:0], int_prod_out[22:0], clk);

	// Assigning exponent of output
	rdcla_8bit adder1 (e1, 1'b0, e_a, e_b, clk);
	DFF exp_add_1 [7:0] (e1[7:0], e1_out[7:0], clk);
	rdcla_8bit adder2 (e2, 1'b0, e1_out, 8'b10000001, clk);
	DFF exp_add_2 [7:0] (e2[7:0], e2_out[7:0], clk);
	rdcla_8bit adder3 (int_prod[30:23], 1'b0, e2_out, {7'b000000, wallace_out[47]}, clk);
	DFF exp_add_3 [7:0] (int_prod[30:23], int_prod_out[30:23], clk);

	// Assigning correct sign bit
	assign int_prod_out[31] = s_a ^ s_b;

	is_zero is_zero (int_prod_1, a, b, int_prod_out);
	DFF is_zero_dff [31:0] (int_prod_1[31:0], int_prod_1_out[31:0], clk);

	is_inf is_inf (int_prod_2, a, b, int_prod_1);
	DFF is_inf_dff [31:0] (int_prod_2[31:0], int_prod_2_out[31:0], clk);

	is_nan is_nan (final_prod, a, b, int_prod_2);
	DFF is_nan_dff [31:0] (final_prod[31:0], prod[31:0], clk);

	// always @(*) begin
	// 	$display($time, " in # %b", wallace_out);
	// end

endmodule


module split(
	output s, 
	output [7:0]e, 
	output [22:0]m, 
	input [31:0]in
);

	assign s = in[31];
	assign e = in[30:23];
	assign m = in[22:0];

endmodule

module shift(
	output r,
	input MSB,
	input cur_bit,
	input next_bit
);

	assign r = (!MSB & cur_bit) | (MSB & next_bit);
	
endmodule

module is_zero(
	output [31:0] out,
	input [31:0] a,
	input [31:0] b,
	input [31:0] prod
);
	wire is_zero = ((|a[30:23]) & (|b[30:23]));		// if zero => is_zero=0
	assign out = (prod & {32{is_zero}}) | (32'b0_00000000_00000000000000000000000 & {32{!is_zero}});

endmodule

module is_inf(
	output [31:0] out,
	input [31:0] a,
	input [31:0] b,
	input [31:0] prod
);

	wire is_inf = ((&a[30:23]) | (&b[30:23]));		// if inf => is_inf=1
	assign out = (prod & {32{!is_inf}}) | ({a[31] ^ b[31], 31'b11111111_00000000000000000000000} & {32{is_inf}});

endmodule

module is_nan(
	output [31:0] out,
	input [31:0] a,
	input [31:0] b,
	input [31:0] prod
);

	wire is_nan = ((&a[30:23]) & !(|b[30:23])) || (!(|a[30:23]) & (&b[30:23]));		// if nan => is_nan = 1
	assign out = (prod & {32{!is_nan}}) | ({32'b0_11111111_11111111111111111111111} & {32{is_nan}});

endmodule