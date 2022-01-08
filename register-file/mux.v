module mux32(input[31:0] cont, input[4:0]ip, output o);
	wire[1:0] t;
	mux16 mu(cont[31:16],ip[3:0],t[1]);
	mux16 md(cont[15:0],ip[3:0],t[0]);
	mux2 mf(t,ip[4],o);
endmodule

module mux16(input[15:0] cont, input[3:0] ip, output o);
	wire[1:0] t;
	mux8 mu(cont[15:8],ip[2:0],t[1]);
	mux8 md(cont[7:0],ip[2:0],t[0]);
	mux2 mf(t,ip[3],o);

endmodule

module mux8(input[7:0] cont, input[2:0] ip, output o);
	wire[1:0] t;
	mux4 mu(cont[7:4],ip[1:0],t[1]);
	mux4 md(cont[3:0],ip[1:0],t[0]);
	mux2 mf(t,ip[2],o);

endmodule

module mux4(input[3:0] cont, input[1:0] ip, output o);
	wire[1:0] t;
	mux2 mu(cont[3:2],ip[0],t[1]);
	mux2 md(cont[1:0],ip[0],t[0]);
	mux2 mf(t,ip[1],o);

endmodule

module mux2(input[1:0] cont, input ip, output o);

	and(t1,cont[1],ip);
	and(t2,cont[0],~ip);
	or(o,t1,t2);

endmodule