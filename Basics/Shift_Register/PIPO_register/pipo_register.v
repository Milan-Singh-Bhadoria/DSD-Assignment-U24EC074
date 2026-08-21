`timescale 1ns / 1ps
module flip_flop(
    input clk,D,
    output reg Q
);
  always@(posedge clk)begin
       Q <= D;
  end
endmodule

module PIPO_register(
    input clk,
    input [3:0]Din,
    output [3:0]Q
);
wire d0,d1,d2,d3;
  wire q0,q1,q2,q3;
  assign {d3,d2,d1,d0} = Din;
  flip_flop s1(.clk(clk), .D(d3), .Q(q3));
  flip_flop s2(.clk(clk), .D(d2), .Q(q2));
  flip_flop s3(.clk(clk), .D(d1), .Q(q1));
  flip_flop s4(.clk(clk), .D(d0), .Q(q0));
  assign Q = {q3,q2,q1,q0};
  
endmodule
