`include "kpg.v"
`include "DFF.v"

module rdcla (sum, cout, a, b, cin, clk);

	input [31:0] a, b;
	input cin;
	output [31:0] sum;
	output cout;
	input wire clk;

	wire [32:0] partial_sum;
	wire [32:0] carry0, carry1;
	wire [32:0] carry0_1, carry1_1, carry0_2, carry1_2, carry0_4, carry1_4, carry0_8, carry1_8, carry0_16, carry1_16;
	wire [32:0] carry0_1_in, carry1_1_in, carry0_2_in, carry1_2_in, carry0_4_in, carry1_4_in, carry0_8_in, carry1_8_in, carry0_16_in, carry1_16_in;

	assign carry0[0] = cin;
	assign carry1[0] = cin;
	
	kpg_init init [32:1] (carry1[32:1], carry0[32:1], a[31:0], b[31:0], clk);

	assign carry1_1[0] = cin;
	assign carry0_1[0] = cin;
	assign carry1_2[1:0] = carry1_1[1:0];
	assign carry0_2[1:0] = carry0_1[1:0];
	assign carry1_4[3:0] = carry1_2[3:0];
	assign carry0_4[3:0] = carry0_2[3:0];
	assign carry1_8[7:0] = carry1_4[7:0];
	assign carry0_8[7:0] = carry0_4[7:0];
	assign carry1_16[15:0] = carry1_8[15:0];
	assign carry0_16[15:0] = carry0_8[15:0];

	kpg itr_1 [32:1] (carry1[32:1], carry0[32:1], carry1[31:0], carry0[31:0], carry1_1_in[32:1], carry0_1_in[32:1], clk);
	// DFF itr_1_dff [64:1] ({carry1_1_in[32:1], carry0_1_in[32:1}, {carry1_1[32:1], carry0_1[32:1}, clk);
	DFF itr_1_dff_1 [32:1] (carry1_1_in[32:1], carry1_1[32:1], clk);
	DFF itr_1_dff_0 [32:1] (carry0_1_in[32:1], carry0_1[32:1], clk);

	kpg itr_2 [32:2] (carry1_1[32:2], carry0_1[32:2], carry1_1[30:0], carry0_1[30:0], carry1_2_in[32:2], carry0_2_in[32:2], clk);
	DFF itr_2_dff_1 [32:2] (carry1_2_in[32:2], carry1_2[32:2], clk);
	DFF itr_2_dff_0 [32:2] (carry0_2_in[32:2], carry0_2[32:2], clk);
	
	kpg itr_4 [32:4] (carry1_2[32:4], carry0_2[32:4], carry1_2[28:0], carry0_2[28:0], carry1_4_in[32:4], carry0_4_in[32:4], clk);
	DFF itr_4_dff_1 [32:4] (carry1_4_in[32:4], carry1_4[32:4], clk);
	DFF itr_4_dff_0 [32:4] (carry0_4_in[32:4], carry0_4[32:4], clk);

	kpg itr_8 [32:8] (carry1_4[32:8], carry0_4[32:8], carry1_4[24:0], carry0_4[24:0], carry1_8_in[32:8], carry0_8_in[32:8], clk);
	DFF itr_8_dff_1 [32:8] (carry1_8_in[32:8], carry1_8[32:8], clk);
	DFF itr_8_dff_0 [32:8] (carry0_8_in[32:8], carry0_8[32:8], clk);

	kpg itr_16 [32:16] (carry1_8[32:16], carry0_8[32:16], carry1_8[16:0], carry0_8[16:0], carry1_16_in[32:16], carry0_16_in[32:16], clk);
	DFF itr_16_dff_1 [32:16] (carry1_16_in[32:16], carry1_16[32:16], clk);
	DFF itr_16_dff_0 [32:16] (carry0_16_in[32:16], carry0_16[32:16], clk);

	assign partial_sum[31:0] = a^b;
	assign sum[31:0] = partial_sum[31:0]^carry0_16[31:0];
	assign cout = carry0_16[32];

endmodule