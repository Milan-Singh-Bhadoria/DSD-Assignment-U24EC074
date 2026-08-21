`timescale 1ns / 1ps
module flip_flop(
    input clk,D,
    output reg Q
);
  always@(posedge clk)begin
       Q <= D;
  end
endmodule

module PISO_register(
    input clk,
    input [3:0]D,
    input load,
    output Q
);
  wire d0,d1,d2,d3,shift;
  wire q0,q1,q2,q3;
  wire l1,l2,l3,l4,l5,l6;
   
   not n1(shift,load);
   
   and a1(l1,q3,shift);
   and a2(l2,D[2],load);
   or o1 (d2,l1,l2);
   
   and a3(l3,q2,shift);
   and a4(l4,D[1],load);
   or o2 (d1,l3,l4);
   
   and a5(l5,q1,shift);
   and a6(l6,D[0],load);
   or o3 (d0,l5,l6);
   
   flip_flop s1(.clk(clk), .D(D[3]), .Q(q3));
   flip_flop s2(.clk(clk), .D(d2), .Q(q2));
   flip_flop s3(.clk(clk), .D(d1), .Q(q1));
   flip_flop s4(.clk(clk), .D(d0), .Q(q0));
   
  assign Q = q0;
endmodule
