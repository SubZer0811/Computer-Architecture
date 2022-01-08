module cache (
	output reg [31:0] read_data,
	input [16:0] read_addr,
	input [16:0] write_addr,
	input [31:0] write_data,
	input read_enable,
	input write_enable,
	input clk
);

	reg [31:0] main_memory [8191:0][15:0];
	reg [31:0] cache [1023:0][15:0];
	reg [2:0] cache_tags [1023:0];
	reg valid [1023:0];					// 0 => invalid, 1 => valid
	reg dirty [1023:0];					// 0 => not dirty, 1 => dirty

	wire [2:0] tag_r;
	wire [9:0] line_r;
	wire [3:0] block_off_r;
	wire [2:0] tag_w;
	wire [9:0] line_w;
	wire [3:0] block_off_w;

	integer i, j;

	assign tag_r = read_addr[16:14];
	assign line_r = read_addr[13:4];
	assign block_off_r = read_addr[3:0];

	assign tag_w = write_addr[16:14];
	assign line_w = write_addr[13:4];
	assign block_off_w = write_addr[3:0];

	always @(posedge clk) begin
		if (read_enable) begin
			if (cache_tags[line_r] == tag_r && valid[line_r] == 1'b1) begin
				$display("%d # Hit: Reading", $time);
				read_data = cache[line_r][block_off_r];
			end 
			// replace with correct line
			else begin
				$display("%d # Miss", $time);
				// check if line is dirty
				if (dirty[line_w] == 1'b1) begin
					// write cache line to memory block
					$display("%d # dirty line", $time);
					main_memory[{cache_tags[line_r], line_r}][0] = cache[line_r][0];
					main_memory[{cache_tags[line_r], line_r}][1] = cache[line_r][1];
					main_memory[{cache_tags[line_r], line_r}][2] = cache[line_r][2];
					main_memory[{cache_tags[line_r], line_r}][3] = cache[line_r][3];
					main_memory[{cache_tags[line_r], line_r}][4] = cache[line_r][4];
					main_memory[{cache_tags[line_r], line_r}][5] = cache[line_r][5];
					main_memory[{cache_tags[line_r], line_r}][6] = cache[line_r][6];
					main_memory[{cache_tags[line_r], line_r}][7] = cache[line_r][7];
					main_memory[{cache_tags[line_r], line_r}][8] = cache[line_r][8];
					main_memory[{cache_tags[line_r], line_r}][9] = cache[line_r][9];
					main_memory[{cache_tags[line_r], line_r}][10] = cache[line_r][10];
					main_memory[{cache_tags[line_r], line_r}][11] = cache[line_r][11];
					main_memory[{cache_tags[line_r], line_r}][12] = cache[line_r][12];
					main_memory[{cache_tags[line_r], line_r}][13] = cache[line_r][13];
					main_memory[{cache_tags[line_r], line_r}][14] = cache[line_r][14];
					main_memory[{cache_tags[line_r], line_r}][15] = cache[line_r][15];
					dirty[line_r] = 1'b0;
				end
				else begin
					// bring correct block to cache
					$display("%d # bringing ram block to cache", $time);
					cache[line_r][0] = main_memory[{tag_r, line_r}][0];
					cache[line_r][1] = main_memory[{tag_r, line_r}][1];
					cache[line_r][2] = main_memory[{tag_r, line_r}][2];
					cache[line_r][3] = main_memory[{tag_r, line_r}][3];
					cache[line_r][4] = main_memory[{tag_r, line_r}][4];
					cache[line_r][5] = main_memory[{tag_r, line_r}][5];
					cache[line_r][6] = main_memory[{tag_r, line_r}][6];
					cache[line_r][7] = main_memory[{tag_r, line_r}][7];
					cache[line_r][8] = main_memory[{tag_r, line_r}][8];
					cache[line_r][9] = main_memory[{tag_r, line_r}][9];
					cache[line_r][10] = main_memory[{tag_r, line_r}][10];
					cache[line_r][11] = main_memory[{tag_r, line_r}][11];
					cache[line_r][12] = main_memory[{tag_r, line_r}][12];
					cache[line_r][13] = main_memory[{tag_r, line_r}][13];
					cache[line_r][14] = main_memory[{tag_r, line_r}][14];
					cache[line_r][15] = main_memory[{tag_r, line_r}][15];				
					valid[line_r] = 1'b1;
					cache_tags[line_r] = tag_r;
				end
			end
		end

		if (write_enable) begin
			// check if block in cache and is valid
			if (cache_tags[line_w] == tag_w && valid[line_w] == 1'b1) begin
				$display("%d # Hit: Writing", $time);
				cache[line_w][block_off_w] = write_data;
				dirty[line_w] = 1'b1;
			end
			// replace with correct line
			else begin
				$display("%d # Miss", $time);
				// check if line is dirty
				if (dirty[line_w] == 1'b1) begin
					// write cache line to memory block
					$display("%d # dirty line", $time);
					main_memory[{cache_tags[line_w], line_w}][0] = cache[line_w][0];
					main_memory[{cache_tags[line_w], line_w}][1] = cache[line_w][1];
					main_memory[{cache_tags[line_w], line_w}][2] = cache[line_w][2];
					main_memory[{cache_tags[line_w], line_w}][3] = cache[line_w][3];
					main_memory[{cache_tags[line_w], line_w}][4] = cache[line_w][4];
					main_memory[{cache_tags[line_w], line_w}][5] = cache[line_w][5];
					main_memory[{cache_tags[line_w], line_w}][6] = cache[line_w][6];
					main_memory[{cache_tags[line_w], line_w}][7] = cache[line_w][7];
					main_memory[{cache_tags[line_w], line_w}][8] = cache[line_w][8];
					main_memory[{cache_tags[line_w], line_w}][9] = cache[line_w][9];
					main_memory[{cache_tags[line_w], line_w}][10] = cache[line_w][10];
					main_memory[{cache_tags[line_w], line_w}][11] = cache[line_w][11];
					main_memory[{cache_tags[line_w], line_w}][12] = cache[line_w][12];
					main_memory[{cache_tags[line_w], line_w}][13] = cache[line_w][13];
					main_memory[{cache_tags[line_w], line_w}][14] = cache[line_w][14];
					main_memory[{cache_tags[line_w], line_w}][15] = cache[line_w][15];
					dirty[line_w] = 1'b0;
				end
				else begin
					// bring correct block to cache
					$display("%d # bringing ram block to cache", $time);
					cache[line_w][0] = main_memory[{tag_w, line_w}][0];
					cache[line_w][1] = main_memory[{tag_w, line_w}][1];
					cache[line_w][2] = main_memory[{tag_w, line_w}][2];
					cache[line_w][3] = main_memory[{tag_w, line_w}][3];
					cache[line_w][4] = main_memory[{tag_w, line_w}][4];
					cache[line_w][5] = main_memory[{tag_w, line_w}][5];
					cache[line_w][6] = main_memory[{tag_w, line_w}][6];
					cache[line_w][7] = main_memory[{tag_w, line_w}][7];
					cache[line_w][8] = main_memory[{tag_w, line_w}][8];
					cache[line_w][9] = main_memory[{tag_w, line_w}][9];
					cache[line_w][10] = main_memory[{tag_w, line_w}][10];
					cache[line_w][11] = main_memory[{tag_w, line_w}][11];
					cache[line_w][12] = main_memory[{tag_w, line_w}][12];
					cache[line_w][13] = main_memory[{tag_w, line_w}][13];
					cache[line_w][14] = main_memory[{tag_w, line_w}][14];
					cache[line_w][15] = main_memory[{tag_w, line_w}][15];				
					valid[line_w] = 1'b1;
					cache_tags[line_w] = tag_w;
				end
			end
		end
	end



	initial begin
		for (i = 0; i < 8192; i = i + 1) begin
			for (j = 0; j < 16; j = j + 1) begin
				main_memory[i][j] = j;
			end
		end
		// Initially all tags need to be invalid
		for (i = 0; i < 1024; i = i + 1) begin
			valid[i] = 0;
			dirty[i] = 0;
		end
	end

endmodule