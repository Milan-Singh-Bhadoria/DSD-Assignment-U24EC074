`timescale 1ns / 1ps
module Sequence_detector(
   input clk,
   input x,
  output y
);
  reg q0,q1;
  
  always @(posedge clk)begin
    q0<= x &(q0|q1);
    q1<= x & ~q1;
  end
   
  assign y = ~x&q0;
endmodule
