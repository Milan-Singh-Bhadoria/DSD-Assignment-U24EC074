module cba_32(
   input [31:0]a,b,
   input cin,
   output [31:0]s,
   output cout
);
wire [31:0]p;
assign p=a^b;
wire [2:0]c;
wire c8,c16,c24,c32;
wire [3:0]sel ;
genvar i;
generate
    for(i=0;i<4;i=i+1)begin
    assign sel[i] = p[8*i]&p[8*i+1]&p[8*i+2]&p[8*i+3]&p[8*i+4]&p[8*i+5]&p[8*i+6]&p[8*i+7];
    end
endgenerate

assign {c8,s[7:0]} = a[7:0]+b[7:0]+cin;
assign c[0] = sel[0] ? cin:c8;

assign {c16,s[15:8]} = a[15:8]+b[15:8]+c[0];
assign c[1] = sel[1] ? c[0]:c16;

assign {c24,s[23:16]} = a[23:16]+b[23:16]+c[1];
assign c[2] = sel[2] ? c[1]:c24;

assign {c32,s[31:24]} = a[31:24]+b[31:24]+c[2];
assign cout = sel[3] ? c[2]:c32;
    
endmodule