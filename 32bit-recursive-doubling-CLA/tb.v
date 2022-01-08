`include "32rdcla.v"

module top;
reg [31:0] a, b;
wire [31:0] s;
wire cout;
reg cin;
reg clk;

rdcla test (s, cout, a, b, cin, clk);

initial
begin

	a = 32'd123;
	b = 32'd123;
	cin = 1'b1;
	#30 $finish;
end
initial begin
	clk = 0;
	forever begin
		#1 clk = ~clk;
	end
end

initial
	// $monitor($time,"\n         a = %d;\n         b = %d;\n  carry_in = %d;\n       sum = %d;\n carry_out = %d;\n", a, b, cin, s, cout);
	$monitor($time,"# a = %d; b = %d; carry_in = %d; sum = %b; carry_out = %d;", a, b, cin, s, cout);

endmodule