module logic_unit (
	input [31:0] a,
	input [31:0] b,
	input [2:0] control,
	output [31:0] out
);
	/*
	  control		 Operation
		000 		bitwise AND
		001 		bitwise XOR
		010 		bitwise NAND
		011 		bitwise OR
		100 		bitwise NOT
		101 		bitwise NOR
		110 		2's Complement
		111 		bitwise XNOR
	*/
	wire [31:0] AND, XOR, NAND, OR, NOT, NOR, _2sCOMP, XNOR;

	and And [31:0] (AND, a, b);
	xor Xor [31:0] (XOR, a, b);
	nand Nand [31:0] (NAND, a, b);
	or Or [31:0] (OR, a, b);
	not Not [31:0] (NOT, a);
	nor Nor [31:0] (NOR, a, b);
	two_complement two (a, _2sCOMP);
	xnor Xnor [31:0] (XNOR, a, b);

	mux8x1 mux [31:0] (AND, XOR, NAND, OR, NOT, NOR, _2sCOMP, XNOR, control, out);
	
endmodule

module mux8x1 (
	input i0,
	input i1,
	input i2,
	input i3,
	input i4,
	input i5,
	input i6,
	input i7,
	input [2:0] select,
	output out
);

	wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11;
	not (w1, select[0]);
	not (w2, select[1]);
	not (w3, select[2]);
	and (w4, i0, w1, w2, w3), (w5, i1, select[0], w2, w3);
	and (w6, i2, w1, select[1], w3), (w7, i3, select[0], select[1], w3);
	and (w8, i4, w1, w2, select[2]), (w9, i5, select[0], w2, select[2]);
	and (w10, i6, w1, select[1], select[2]), (w11, i7, select[0], select[1], select[2]);
	or (out, w4, w5, w6, w7, w8, w9, w10, w11);

endmodule

module two_complement (
	input [31:0] a,
	output [31:0] out
);
	wire [31:0] l, complement;
	not Not [31:0] (complement, a);
	half_adder HA [31:0] (out[31:0], l[31:0], complement, {l[30:0], 1'b1});
	// half_adder HA1 (out[0], l[0], a[0], 1'b1);
endmodule

module half_adder (
	output sum,
	output carry,
	input a,
	input b
);
	xor (sum, a, b);
	and (carry, a, b);
endmodule