`include "mux.v"

module register_file(
	output [31:0] data1,
	output [31:0] data2,
	input [4:0] addr1,
	input [4:0] addr2,
	input [4:0] in_addr,
	input [31:0] in_data,
	input write_enable
);

	reg [31:0] register [31:0];
	genvar i;
	
	// // TESTING
	// integer j;
	// initial begin
	// 	for(j=0; j<32; j=j+1)
	// 		register[j] = j;
	// end

	generate
		for(i=0; i<32; i=i+1)begin
			mux32 mux1 ({register[31][i],register[30][i],register[29][i],register[28][i],register[27][i],register[26][i],register[25][i],register[24][i],register[23][i],register[22][i],register[21][i],register[20][i],register[19][i],register[18][i],register[17][i],register[16][i],register[15][i],register[14][i],register[13][i],register[12][i],register[11][i],register[10][i],register[9][i],register[8][i],register[7][i],register[6][i],register[5][i],register[4][i],register[3][i],register[2][i],register[1][i],register[0][i]}, addr1, data1[i]);
			mux32 mux2 ({register[31][i],register[30][i],register[29][i],register[28][i],register[27][i],register[26][i],register[25][i],register[24][i],register[23][i],register[22][i],register[21][i],register[20][i],register[19][i],register[18][i],register[17][i],register[16][i],register[15][i],register[14][i],register[13][i],register[12][i],register[11][i],register[10][i],register[9][i],register[8][i],register[7][i],register[6][i],register[5][i],register[4][i],register[3][i],register[2][i],register[1][i],register[0][i]}, addr2, data2[i]);
		end
	endgenerate

	always @(*) begin
		if (write_enable) begin
			register[in_addr] <= in_data;
		end
	end

endmodule