`include "cache-memory.v"

module top ();

	reg [16:0] read_addr, write_addr;
	reg [31:0] write_data;
	reg clk;
	reg read_enable, write_enable;
	wire [31:0] read_data;
	
	cache C1 (read_data, read_addr, write_addr, write_data, read_enable, write_enable, clk);

	initial begin
		// read_enable = 1'b1;
		// read_addr = 17'b000_0000000000_0000;
		// #5 read_enable = 1'b0;
		// $display("%d # %b: %h", $time, read_addr, read_data);

		// #5 read_enable = 1'b1;
		// read_addr = 17'b000_0000000000_1110;
		// #5 read_enable = 1'b0;
		// $display("%d # %b: %h", $time, read_addr, read_data);
		
		
		#5 read_enable = 1'b1;
		read_addr = 17'b100_1110000000_1011;
		#5 read_enable = 1'b0;
		#5 $display("%d # %b: %h", $time, read_addr, read_data);

		#5 write_enable = 1'b1;
		write_addr = 17'b100_1110000000_1011;
		write_data = 32'h0F0F0F0F;
		#5 write_enable = 1'b0;

		#5 read_enable = 1'b1;
		read_addr = 17'b100_1110000000_1011;
		#5 read_enable = 1'b0;
		#5 $display("%d # %b: %h", $time, read_addr, read_data);

		#5 read_enable = 1'b1;
		read_addr = 17'b110_1110000000_1011;
		#5 read_enable = 1'b0;
		#5 $display("%d # %b: %h", $time, read_addr, read_data);

		#5 read_enable = 1'b1;
		read_addr = 17'b100_1110000000_1011;
		#5 read_enable = 1'b0;
		#5 $display("%d # %b: %h", $time, read_addr, read_data);

		#10 $finish;
	end

	initial begin
		clk = 0;
		forever begin
			#1 clk = ~clk;
		end
	end
	// initial begin
	// 	$monitor("%d # %b: %d", $time, read_addr, read_data);
	// end

endmodule