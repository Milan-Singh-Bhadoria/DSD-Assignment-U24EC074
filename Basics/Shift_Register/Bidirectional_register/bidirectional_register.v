`timescale 1ns / 1ps
module flip_flop(
    input clk,D,
    output reg Q
);
  always@(posedge clk)begin
       Q <= D;
  end
endmodule

module Bidirectional_register(
    input clk,
    input D,
    input shift,
    output Q
);
  wire shift_left;
  wire d0,d1,d2,d3;
  wire q0,q1,q2,q3;
  wire l1,l2,l3,l4,l5,l6,l7,l8;
   
   not n1(shift_left,shift);
   
   and a1(l1,D,shift);
   and a2(l2,q2,shift_left);
   or o1 (d3,l1,l2);
   
   and a3(l3,q3,shift);
   and a4(l4,q1,shift_left);
   or o2 (d2,l3,l4);
   
   and a5(l5,q2,shift);
   and a6(l6,q0,shift_left);
   or o3 (d1,l5,l6);
   
   and a7(l7,q1,shift);
   and a8(l8,~D,shift_left);
   or o4 (d0,l7,l8);
   
   flip_flop s1(.clk(clk), .D(d3), .Q(q3));
   flip_flop s2(.clk(clk), .D(d2), .Q(q2));
   flip_flop s3(.clk(clk), .D(d1), .Q(q1));
   flip_flop s4(.clk(clk), .D(d0), .Q(q0));
   
  assign Q = shift ? q0 : q3;
endmodule
