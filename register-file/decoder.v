module decode32(input [4:0] addr,output [31:0] s);
    decode16 h1(addr[3:0],addr[4],s[31:16]);
    decode16 h2(addr[3:0],~addr[4],s[15:0]);
endmodule

module decode16(input [3:0]addr,input en,output [15:0] s);
    and(enable_h1,en,addr[3]);
    and(enable_h2,en,~addr[3]);
    decode8 h1(addr[2:0],enable_h1,s[15:8]);
    decode8 h2(addr[2:0],enable_h2,s[7:0]);
endmodule

module decode8(input [2:0]addr,input en,output [7:0] s);
    and(enable,en,addr[2]);
    decode4 h1(addr[1:0],enable,s[7:4]);
    decode4 h2(addr[1:0],~enable & en,s[3:0]);
endmodule

module decode4(input [1:0]addr,input en,output [3:0] s);
    and(enable,en,addr[1]);
    decode2 h1(addr[0],enable,s[3:2]);
    decode2 h2(addr[0],~enable & en,s[1:0]);
endmodule

module decode2(input addr,input en,output [1:0] s);
    and(s[1],addr,en);
    and(s[0],~addr,en);
endmodule

// en addr[1] finen 
// 0   0       0
// 0   1       0
// 1   0       0
// 1   1       1