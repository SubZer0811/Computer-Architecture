`include "32rdcla.v"
`include "24bit-barrel-shift.v"

module FP_adder(output reg [31:0] out, 
	input [31:0] a, input [31:0] b
);

	reg s1, s2, s3;
	reg [7:0] e1, e2, e3, d1, d2;
	reg [23:0] m1, m2, m_a, m_t, m_b;
	reg [24:0] den_res;
	wire [24:0] rd_res;
	reg [24:0] res;
	wire [23:0] shift_res1, shift_res2;
	wire [24:0] shift_left;
	integer itr;
	reg cin;
	wire [6:0]trim;

	// recursive doubling CLA
	rdcla r ({trim, rd_res}, , {8'b0, m_a}, {8'b0, m_b}, cin);
	// right shift for 2 cases
	barrelRight br1 (m1,d1[4:0], shift_res1);
	barrelRight br2 (m2,d2[4:0], shift_res2);
	// left shift
	barrelLeft bl1(den_res, itr[4:0], shift_left);

	always@(*) begin

		// split the number as sign, exponent, mantissa
		// 1 bit sign
		s1 = a[31];
		s2 = b[31];
		// 8 bits exponent
		e1 = a[30:23];
		e2 = b[30:23];
		// 23 bits mantissa + 1 bit for 1
		m1[23] = 1'b1;
		m2[23] = 1'b1;
		m1[22:0] = a[22:0];
		m2[22:0] = b[22:0];

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
		 	s3 = s1;
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
			s3 = s2;
		end

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

		// Normalise the result
		itr = 24;
		while (itr >= 0 && den_res[itr] == 0) begin
			e3 -= 1;
			itr -= 1;
		end

		// shift 24-itr times
		itr = 24-itr;
		res = shift_left;

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