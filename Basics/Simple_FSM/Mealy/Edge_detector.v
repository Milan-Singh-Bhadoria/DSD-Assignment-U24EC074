`timescale 1ns/1ps
 module edge_detect(
  input clk,x,
  output y
);
  reg q;
  
  always @(posedge clk)begin
    q<=x;
  end
   
  assign y = q ^ x;
endmodule
