`include "wallace.v"

module tbench;

reg signed [31:0] a, b;
wire [63:0]out;
reg clk;

wallace test (a, b, out, clk);

initial
begin

	a = 32'b1111111111111111111;
	b = 32'b1111111111111111111;
	#50 $finish();
end

initial begin
	clk = 0;
	forever begin
		#1 clk = ~clk;
	end
end

initial begin
	$monitor("%d# a=%d b=%d out=%b", $time, a, b, out);
end

endmodule