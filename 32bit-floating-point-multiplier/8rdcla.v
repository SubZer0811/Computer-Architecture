// `include "DFF.v"
`include "kpg.v"

module rdcla_8bit (sum, cin, a, b, clk);

	input [7:0] a, b;
	input cin;
	output [7:0] sum;
	output cout;
	input wire clk;

	wire [8:0] partial_sum;
	wire [8:0] carry0, carry1;
	wire [8:0] carry0_1, carry1_1, carry0_2, carry1_2, carry0_4, carry1_4, carry0_8, carry1_8, carry0_16, carry1_16;
	wire [8:0] carry0_1_in, carry1_1_in, carry0_2_in, carry1_2_in, carry0_4_in, carry1_4_in, carry0_8_in, carry1_8_in, carry0_16_in, carry1_16_in;

	assign carry0[0] = cin;
	assign carry1[0] = cin;
	
	kpg_init init [8:1] (carry1[8:1], carry0[8:1], a[7:0], b[7:0], clk);

	assign carry1_1[0] = cin;
	assign carry0_1[0] = cin;
	assign carry1_2[1:0] = carry1_1[1:0];
	assign carry0_2[1:0] = carry0_1[1:0];
	assign carry1_4[3:0] = carry1_2[3:0];
	assign carry0_4[3:0] = carry0_2[3:0];
	assign carry1_8[7:0] = carry1_4[7:0];
	assign carry0_8[7:0] = carry0_4[7:0];

	kpg itr_1 [8:1] (carry1[8:1], carry0[8:1], carry1[7:0], carry0[7:0], carry1_1_in[8:1], carry0_1_in[8:1], clk);
	// DFF itr_1_dff [64:1] ({carry1_1_in[8:1], carry0_1_in[8:1}, {carry1_1[8:1], carry0_1[8:1}, clk);
	DFF itr_1_dff_1 [8:1] (carry1_1_in[8:1], carry1_1[8:1], clk);
	DFF itr_1_dff_0 [8:1] (carry0_1_in[8:1], carry0_1[8:1], clk);

	kpg itr_2 [8:2] (carry1_1[8:2], carry0_1[8:2], carry1_1[6:0], carry0_1[6:0], carry1_2_in[8:2], carry0_2_in[8:2], clk);
	DFF itr_2_dff_1 [8:2] (carry1_2_in[8:2], carry1_2[8:2], clk);
	DFF itr_2_dff_0 [8:2] (carry0_2_in[8:2], carry0_2[8:2], clk);
	
	kpg itr_4 [8:4] (carry1_2[8:4], carry0_2[8:4], carry1_2[4:0], carry0_2[4:0], carry1_4_in[8:4], carry0_4_in[8:4], clk);
	DFF itr_4_dff_1 [8:4] (carry1_4_in[8:4], carry1_4[8:4], clk);
	DFF itr_4_dff_0 [8:4] (carry0_4_in[8:4], carry0_4[8:4], clk);

	assign partial_sum = a^b;
	assign sum[7:0] = partial_sum[7:0]^carry0_4[7:0];

endmodule