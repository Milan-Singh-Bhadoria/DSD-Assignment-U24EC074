`timescale 1ns / 1ps
module flip_flop(
    input clk,D,
    output reg Q
);
  always@(posedge clk)begin
       Q <= D;
  end
endmodule
module SISO_register(
    input clk,Din,
    output Q
);
  wire q0,q1,q2,q3;
  flip_flop s1(.clk(clk), .D(Din), .Q(q3));
  flip_flop s2(.clk(clk), .D(q3), .Q(q2));
  flip_flop s3(.clk(clk), .D(q2), .Q(q1));
  flip_flop s4(.clk(clk), .D(q1), .Q(q0));
  assign Q = q0;
  
endmodule
