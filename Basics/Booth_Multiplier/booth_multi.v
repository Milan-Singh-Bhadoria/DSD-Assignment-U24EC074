`timescale 1ns / 1ps
module Booth_multi #(parameter bit = 8)(
    input signed [bit-1:0]m,q,
    output reg signed [(2*bit)-1:0]o
);
   reg q_1 = 0;
   reg signed [bit-1:0]acc = 8'b0;
   reg signed [2*bit:0]product;
   
   integer i;
  always @(*)begin
  product = {acc,q,q_1};
    
      for(i=0;i<bit;i=i+1)begin
      if(product[1:0] == 2'b01)begin
       product[2*bit:bit+1] = product[2*bit:bit+1] + m;
       end
     else if(product[1:0] == 2'b10)begin
       product[2*bit:bit+1] = product[2*bit:bit+1] - m ;
     end
    product = product >>> 1;
    end
     o = product[2*bit:1];
  end
 endmodule
