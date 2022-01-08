`include "logic_unit.v"

module top();

reg [31:0] a, b;
reg [2:0] ctl;
wire [31:0] out;

	logic_unit LU (a, b, ctl, out);

	initial begin
		$monitor("ctl: %b\na:   %b\nb:   %b\nout: %b\n", ctl, a, b, out);
		a = 32'b0000100110; b = 32'b0; ctl = 3'b000;
		#1 ctl = 3'b001;
		#2 ctl = 3'b010;
		#3 ctl = 3'b011;
		#4 ctl = 3'b100;
		#5 ctl = 3'b101;
		#6 ctl = 3'b110;
		#7 ctl = 3'b111;
	end

endmodule