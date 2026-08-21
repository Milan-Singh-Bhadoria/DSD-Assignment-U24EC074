module fa(
  input a,b,cin,
  output s,cout  
);
  wire s1,c1,c2;
  xor s1(s1,a,b);
  xor s2(s,s1,cin);
  and c1(c1,a,b);
  and c2(c2,s1,cin);
  or c3(cout,c1,c2);
endmodule
