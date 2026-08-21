module xun(
  input a,b,
  output reg O
);
  
  always@(*) begin
    reg a1,a2,b1,b2;
    a1=~(a&a);
	a2=~(a1&b);
	b1=~(b&b);
	b2=~(b1&a);
	O=~(a2&b2);
  end
endmodule