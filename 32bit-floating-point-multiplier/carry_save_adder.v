`include "DFF.v"

module FA (
	input [63:0] x,
	input [63:0] y,
	input [63:0] z,
	output [63:0] u,
	output [63:0] v,
	input clk
);
	wire [63:0] u_in, v_in;
	assign u_in = x^y^z;
	assign v_in[0] = 0;
	assign v_in[63:1] = (x&y) | (y&z) | (z&x);

	DFF dff_u [63:0] (u_in[63:0], u[63:0], clk);
	DFF dff_v [63:0] (v_in[63:0], v[63:0], clk);

endmodule