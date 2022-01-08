`include "32rdcla.v"
`include "24bit-barrel-shift.v"
`include "DFF.v"

module FP_adder(
	output  [31:0] out, 
	input [31:0] a, 
	input [31:0] b, 
	input clk
);

	wire s1, s2, s1_out, s2_out, s3;
	wire [7:0] e1, e2, e1_out, e2_out, e3, e3_fin, e3_;
	wire [23:0] m1, m1_out, m2, m2_out, m_a, m_t, m_b;
	wire [4:0] d1, d2, shift;
	wire [23:0] shift_res1_in, shift_res2_in;
	wire [23:0] shift_res1, shift_res2;
	wire [24:0] rd_res;
	wire [24:0] den_res;
	wire [6:0]trim;
	integer itr;
	wire [24:0] shift_left;
	wire [24:0] res;
	wire cin;

	// reg s1, s2, s3;
	// reg [7:0] e1, e2, e3, d1, d2;
	// // reg [23:0] m1, m2, m_a, m_t, m_b;
	// reg [23:0] m1, m2;

	split _a (s1, e1, m1, a);
	split _b (s2, e2, m2, b);
	DFF split_a_1 (s1, s1_out, clk);
	DFF split_b_1 (s2, s2_out, clk);
	DFF split_a_2 [7:0] (e1, e1_out, clk);
	DFF split_b_2 [7:0] (e2, e2_out, clk);
	DFF split_a_3 [23:0] (m1, m1_out, clk);
	DFF split_b_3 [23:0] (m2, m2_out, clk);

	// right shift for 2 cases
	barrelRight br1 (m1_out[23:0], d1[4:0], shift_res1_in);
	DFF bR1 [23:0] (shift_res1_in, shift_res1, clk);
	barrelRight br2 (m2_out, d2[4:0], shift_res2_in);
	DFF bR2 [23:0] (shift_res2_in, shift_res2, clk);

	wire [23:0] m_a_, m_t_;
	wire [4:0] d1_, d2_;

	Step1 step1 (s1_out, s2_out, e1_out, e2_out, m1_out, m2_out, 
				shift_res1, shift_res2, 
				, e3_, m_a_, m_t_, d1_, d2_);
	DFF step1_e3 [7:0] (e3_, e3, clk);
	DFF step1_m_a [23:0] (m_a_, m_a, clk);
	DFF step1_m_t [23:0] (m_t_, m_t, clk);
	DFF step1_d1 [4:0] (d1_, d1, clk);
	DFF step1_d2 [4:0] (d2_, d2, clk);

	wire s3_, cin_;
	wire [23:0] m_b_;
	Step2 step2 (s1, s2, e1_out, e2_out, m1_out, m2_out,
				m_t, rd_res, 
				s3_, den_res, m_b_, cin);

	DFF step2_s3 (s3_, s3, clk);
	DFF step2_cin (cin_, cin, clk);
	DFF step2_m_b [23:0] (m_b_, m_b, clk);

	rdcla r ({trim, rd_res}, , {8'b0, m_a}, {8'b0, m_b}, cin, clk);

	barrelLeft bl1(den_res, shift, shift_left);

	Step3 step3 (e3, shift_left, den_res, res, e3_fin, shift);
	Step4 step4 (s1_out, s2_out, s3,
				e1_out, e2_out, e3,
				m1_out, m2_out,
				res, out);

endmodule

module split(
	output s, 
	output [7:0]e, 
	output [23:0]m, 
	input [31:0]in
);

	assign s = in[31];
	assign e = in[30:23];
	assign m = {1'b1, in[22:0]};

endmodule

module Step1(
	input s1, s2,
	input [7:0] e1, e2,
	input [23:0] m1, m2,
	input [23:0] shift_res1, shift_res2,
	output reg s3,
	output reg [7:0] e3,
	output reg [23:0] m_a, m_t,
	output reg [4:0] d1, d2
);

	always @(*) begin
		// exponents are equal
		if(e1 == e2) begin
			m_a = m1;
			m_t = m2;
			e3 = e1 + 1'b1;
		end
		// e1 > e2
		else if(e1 > e2) begin
			d2 = e1 - e2;
			if(d2 > 32'd24)begin
				d2 = 32'd24;
			end
		 	m_a = m1;
			m_t = shift_res2;
		 	e3 = e1 + 1'b1;
		 	// s3 = s1;
		end
		// e2 > e1
		else begin
			d1 = e2 - e1;
			if(d1 > 32'd24)begin
				d1 = 32'd24;
			end
			m_a = m2;
			m_t = shift_res1;
			e3 = e2 +1'b1;
			// s3 = s2;
		end

	end
endmodule

module Step2(
	input s1, s2,
	input [7:0] e1, e2,
	input [23:0] m1, m2,
	input [23:0] m_t,
	input [24:0] rd_res,
	output reg s3,
	output reg [24:0] den_res,
	output reg [23:0] m_b,
	output reg cin
);

	always @(*) begin
		
		// addition
		if(s1 ^ s2 == 0) begin
			cin = 0;
			m_b = m_t;
			den_res = rd_res;
			s3 = s1;
		end
		// subtraction
		else begin
			cin = 1;
			m_b = (m_t ^ 24'hffffff);
			den_res = {1'b0, rd_res[23:0]};
			if(e1 == e2) begin 
				if(m1 > m2) begin 
					s3 = s1;				
				end
				else begin
					s3 = s2;
				end
			end
		end
	end

endmodule

module Step3 (
	input [7:0] e3_in,
	input [24:0] shift_left,
	input [24:0] den_res,
	output reg [24:0] res,
	output reg [7:0] e3_out,
	output reg [4:0] shift
);
	integer itr;
	always @(*) begin
		// Normalise the result
		e3_out = e3_in;
		itr = 24;
		while (itr >= 0 && den_res[itr] == 0) begin
			e3_out -= 1;
			itr -= 1;
		end

		// shift 24-itr times
		shift = 24-itr;
		res = shift_left;

	end
endmodule

module Step4 (
	input s1, s2, s3,
	input [7:0] e1, e2, e3,
	input [23:0] m1, m2,
	input [24:0] res,
	output reg [31:0] out
);
	always@(*) begin

		// either one of numbers is infinity
		if(&e1 == 1 || &e2 == 1) begin
			out = 32'b0_11111111_11111111111111111111111;
		end
		// first number is zero
		else if((|e1 == 0) && (|m1[22:0] == 0)) begin
			out={s2, e2, m2[22:0]};
		end
		// second number is zero
		else if((|e2 == 0) && (|m2[22:0] == 0)) begin 
			out={s1, e1, m1[22:0]};
		end
		// result is zero
		else if(res[24] == 0) begin 
			out = 32'b0;
		end
		// result does not fall under above cases
		else begin
			out = {s3, e3, res[23:1]};
		end
	end
endmodule