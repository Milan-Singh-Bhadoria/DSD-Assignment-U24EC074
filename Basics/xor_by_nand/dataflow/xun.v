module xun(
  input a,b,
  output O
);
  wire a1,a2,b1,b2;
  
  assign a1=~(a&a);
  assign a2=~(a1&b);
  assign b1=~(b&b);
  assign b2=~(b1&a);
  assign O=~(a2&b2);
endmodule