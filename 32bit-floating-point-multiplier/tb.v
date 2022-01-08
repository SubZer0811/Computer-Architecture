`include "FP_multiplier.v"

module FP_adder_tb; 
reg [31:0]a, b;
wire [31:0]out;
reg clk;

FP_multiplier FP1 (out, a, b, clk);

initial
begin

	// non-zero, zero
	#1 a = 32'b0_10000000_11110000000000000000000; b = 32'b0_10000000_11000000000000000000000;
	// #5 $display("A:\t %b %b %b\nB:\t %b %b %b\noutput:\t %b %b %b\n", a[31], a[30:23], a[22:0], b[31], b[30:23], b[22:0], out[31], out[30:23], out[22:0]);

	/*

	// +ve +ve 
	#5 a = 32'b1_10000000_11100000000000000000000;		
	#5 b = 32'b0_00000000_00000000000000000000000;
	#10 $display("A:\t %b %b %b\nB:\t %b %b %b\noutput:\t %b %b %b\n", a[31], a[30:23], a[22:0], b[31], b[30:23], b[22:0], out[31], out[30:23], out[22:0]);
	
	// inf, non-zero
	#15 a = 32'b0_11111111_00000000000000000000000;
	#15 b = 32'b0_11111100_00000000000000000000000;
	#15 $display("A:\t %b %b %b\nB:\t %b %b %b\noutput:\t %b %b %b\n", a[31], a[30:23], a[22:0], b[31], b[30:23], b[22:0], out[31], out[30:23], out[22:0]);
	
	// +ve, -ve
	#20 a = 32'b0_10001000_11101100000101000000100;
	#20	b = 32'b1_10001011_01101110110100100101010;
	#20 $display("A:\t %b %b %b\nB:\t %b %b %b\noutput:\t %b %b %b\n", a[31], a[30:23], a[22:0], b[31], b[30:23], b[22:0], out[31], out[30:23], out[22:0]);
	
	// inf, -inf
	#25 a = 32'b0_11111111_00000000000000000000000;
	#25 b = 32'b1_11111111_00000000000000000000000;
	#25 $display("A:\t %b %b %b\nB:\t %b %b %b\noutput:\t %b %b %b\n", a[31], a[30:23], a[22:0], b[31], b[30:23], b[22:0], out[31], out[30:23], out[22:0]);

	// inf, zero
	#30 b = 32'b0_11111111_00000000000000000000000;
	#30 a = 32'b0_00000000_00000000000000000000000;
	#30 $display("A:\t %b %b %b\nB:\t %b %b %b\noutput:\t %b %b %b\n", a[31], a[30:23], a[22:0], b[31], b[30:23], b[22:0], out[31], out[30:23], out[22:0]);

	*/

	#100 $finish();
end

initial begin
	$monitor($time, "# output:\t %b %b %b", out[31], out[30:23], out[22:0]);
end

initial begin
	clk = 0;
	forever begin
		#1 clk = ~clk;
	end
end

endmodule