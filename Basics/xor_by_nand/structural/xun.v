module xun(
  input a,b,
  output O
);
  wire a1,a2,b1,b2;
  nand m1(a1,a,a);
  nand m2(a2,a1,b);
  nand m3(b1,b,b);
  nand m4(b2,b1,a);
  nand m5(O,a2,b2);
endmodule