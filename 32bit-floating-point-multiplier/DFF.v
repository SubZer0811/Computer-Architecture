module DFF(
	input in,
	output reg out,
	input clk
);

always @(posedge clk) begin
	out = in;
end

endmodule