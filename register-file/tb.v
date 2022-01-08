`include "register_file.v"

module top;

reg [4:0] addr1, addr2, in_addr;
wire [31:0] out1, out2;
reg [31:0]in_data;
reg write_enable;
integer j;

register_file regs (out1, out2, addr1, addr2, in_addr, in_data, write_enable);

initial begin

	addr1 = 5'd3;
	addr2 = 5'd5;
	$display("addr: %d: %d, addr: %d: %d", addr1, out1, addr2, out2);

	#5 write_enable = 1'b1;
	#5 in_addr = 5'd5;
	#5 in_data = 32'd5;
	#10 write_enable = 1'b0;
	#10 $display("addr: %d: %d, addr: %d: %d", addr1, out1, addr2, out2);

	#11 write_enable = 1'b1;
	#11 in_addr = 5'd3;
	#11 in_data = 32'd3;
	#15 write_enable = 1'b0;
	#15 $display("addr: %d: %d, addr: %d: %d", addr1, out1, addr2, out2);


	#16 write_enable = 1'b1;
	#16 in_addr = 5'd3;
	#16 in_data = 32'd123321;
	#20 write_enable = 1'b0;
	#25 $display("addr: %d: %d, addr: %d: %d", addr1, out1, addr2, out2);

end

endmodule